# Kernel Module Development Guide

Developing loadable kernel modules for the custom Debian-styled distribution.

## Overview

Kernel modules extend kernel functionality without recompiling the entire kernel. They're useful for:
- Custom device drivers
- Filesystem extensions
- Protocol implementations
- System utilities
- Experimental features

## Building Modules

### Prerequisites

```bash
sudo apt-get install -y linux-headers-$(uname -r)
sudo apt-get install -y build-essential git
```

### Build

```bash
cd modules
make build
```

### Install module

```bash
make install
```

### Remove module

```bash
make remove
```

## Module Basics

### Entry/Exit Points

Every kernel module needs:

```c
#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Developer");
MODULE_DESCRIPTION("Module description");

static int __init module_init_func(void)
{
    printk(KERN_INFO "Module loaded\n");
    return 0;
}

static void __exit module_exit_func(void)
{
    printk(KERN_INFO "Module unloaded\n");
}

module_init(module_init_func);
module_exit(module_exit_func);
```

### Logging

```c
printk(KERN_DEBUG "Debug message\n");
printk(KERN_INFO "Information\n");
printk(KERN_WARNING "Warning\n");
printk(KERN_ERR "Error\n");
printk(KERN_CRIT "Critical\n");
```

View kernel logs:
```bash
dmesg | tail -20
sudo tail -f /var/log/kern.log
```

## Character Devices

### Register device

```c
#include <linux/fs.h>
#include <linux/cdev.h>

static dev_t dev_num;
static struct cdev cdev;
static struct class *dev_class;

static int device_open(struct inode *inode, struct file *file)
{
    printk(KERN_INFO "Device opened\n");
    return 0;
}

static int device_release(struct inode *inode, struct file *file)
{
    printk(KERN_INFO "Device closed\n");
    return 0;
}

static ssize_t device_read(struct file *file, char __user *buf,
                          size_t count, loff_t *offset)
{
    // Read from device
    return 0;
}

static ssize_t device_write(struct file *file, const char __user *buf,
                           size_t count, loff_t *offset)
{
    // Write to device
    return count;
}

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = device_open,
    .release = device_release,
    .read = device_read,
    .write = device_write,
};

static int __init device_module_init(void)
{
    // Allocate device number
    alloc_chrdev_region(&dev_num, 0, 1, "custom_device");
    
    // Create device class
    dev_class = class_create(THIS_MODULE, "custom_device");
    
    // Create character device
    cdev_init(&cdev, &fops);
    cdev_add(&cdev, dev_num, 1);
    
    // Create device file
    device_create(dev_class, NULL, dev_num, NULL, "custom_device");
    
    printk(KERN_INFO "Device created\n");
    return 0;
}

static void __exit device_module_exit(void)
{
    device_destroy(dev_class, dev_num);
    class_destroy(dev_class);
    cdev_del(&cdev);
    unregister_chrdev_region(dev_num, 1);
    printk(KERN_INFO "Device destroyed\n");
}
```

## Accessing from Userspace

### Reading from device

```bash
cat /dev/custom_device
```

### Writing to device

```bash
echo "test" > /dev/custom_device
```

### Using ioctl for control

```c
// In kernel module
#define IOCTL_CMD _IOW('D', 1, int)

static long device_ioctl(struct file *file, unsigned int cmd,
                        unsigned long arg)
{
    if (cmd == IOCTL_CMD) {
        int value;
        copy_from_user(&value, (int *)arg, sizeof(int));
        printk(KERN_INFO "Received: %d\n", value);
    }
    return 0;
}
```

### Userspace program

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

int main() {
    int fd = open("/dev/custom_device", O_RDWR);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    int value = 42;
    ioctl(fd, IOCTL_CMD, &value);
    
    close(fd);
    return 0;
}
```

## Platform Drivers

For hardware devices:

```c
#include <linux/platform_device.h>

static struct platform_device *pdev;

static int probe(struct platform_device *pdev)
{
    printk(KERN_INFO "Device probed\n");
    return 0;
}

static int remove(struct platform_device *pdev)
{
    printk(KERN_INFO "Device removed\n");
    return 0;
}

static struct platform_driver driver = {
    .probe = probe,
    .remove = remove,
    .driver = {
        .name = "custom_driver",
        .owner = THIS_MODULE,
    },
};
```

## Memory Allocation

### Kernel memory

```c
#include <linux/slab.h>

// Safe allocation (can sleep)
void *mem = kmalloc(size, GFP_KERNEL);

// Contiguous memory (for DMA)
void *mem = kmalloc(size, GFP_DMA);

// Zero-initialized
void *mem = kzalloc(size, GFP_KERNEL);

// Per-CPU allocation
void *mem = alloc_percpu(type);

// Free memory
kfree(mem);
free_percpu(mem);
```

## Work Queues and Tasklets

### Task queue

```c
#include <linux/workqueue.h>

static struct work_struct work;

static void work_handler(struct work_struct *work)
{
    printk(KERN_INFO "Work handler called\n");
}

// In init
INIT_WORK(&work, work_handler);
schedule_work(&work);  // Queue work
```

### Tasklet (bottom half)

```c
#include <linux/interrupt.h>

static struct tasklet_struct tasklet;

static void tasklet_handler(unsigned long data)
{
    printk(KERN_INFO "Tasklet executed\n");
}

// In init
tasklet_init(&tasklet, tasklet_handler, 0);
tasklet_schedule(&tasklet);  // Schedule tasklet
```

## Interrupt Handlers

```c
static irqreturn_t interrupt_handler(int irq, void *dev_id)
{
    printk(KERN_INFO "Interrupt %d\n", irq);
    return IRQ_HANDLED;
}

// Register interrupt
request_irq(irq_number, interrupt_handler, IRQF_SHARED, "custom_device", NULL);

// Unregister
free_irq(irq_number, NULL);
```

## Sysfs Interface

Expose parameters to userspace:

```c
static int param_value = 0;
module_param(param_value, int, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(param_value, "Module parameter");
```

View/modify:
```bash
cat /sys/module/custom_module/parameters/param_value
echo 42 | tee /sys/module/custom_module/parameters/param_value
```

## Debugging

### Check if module loaded

```bash
lsmod | grep custom_module
```

### Detailed module info

```bash
modinfo custom_module.ko
```

### View module parameters

```bash
cat /sys/module/custom_module/parameters/
```

### Debug with printk

Add to `/etc/sysctl.conf`:
```
kernel.printk = 8 8 1 7
```

### Debug with dynamic debug

```bash
# Enable all custom_module debug prints
echo "file src/custom_module.c +p" > /proc/dynamic_debug/control
```

## Module Signing

```bash
# Generate key
openssl genrsa -out key.pem 2048

# Sign module
kmodsign sha512 key.pem cert.pem custom_module.ko

# Install
insmod custom_module.ko
```

## Best Practices

1. **Always use GFP_KERNEL** - Allows sleeping where safe
2. **Handle errors** - Check return values
3. **Use printk sparingly** - Logging impacts performance
4. **Proper locking** - Use mutexes/spinlocks for shared data
5. **Module versioning** - Maintain compatibility
6. **Documentation** - Comment complex logic

## Common Pitfalls

### Not calling module_init/exit
```c
module_init(my_init);
module_exit(my_exit);
```

### Forgetting MODULE_LICENSE
```c
MODULE_LICENSE("GPL");  // Required!
```

### Sleeping in atomic context
```c
// DON'T do this in interrupt handler
kmalloc(size, GFP_KERNEL);  // Can sleep!

// Use instead
kmalloc(size, GFP_ATOMIC);  // Won't sleep
```

## Example: Simple Character Device

See `src/custom_module.c` for a complete example with:
- Character device creation
- Read/write operations
- Device file at `/dev/custom_device`

## References

- Linux Kernel Module Programming: https://tldp.org/LDP/lkmpg/
- Kernel Documentation: https://www.kernel.org/doc/
- Linux Device Drivers: https://lwn.net/
- Kernel API Reference: https://www.kernel.org/doc/html/latest/
