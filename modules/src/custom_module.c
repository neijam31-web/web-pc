/*
 * Custom Debian-styled Kernel Module
 * A basic template for kernel module development
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/miscdevice.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Debian Custom");
MODULE_DESCRIPTION("Custom kernel module for Debian-styled distribution");
MODULE_VERSION("1.0");

#define MODULE_NAME "custom_module"
#define DEVICE_NAME "custom_device"

/* Character device node */
static struct miscdevice misc_dev;

/**
 * Device file read operation
 */
static ssize_t custom_read(struct file *file, char __user *buf,
                           size_t count, loff_t *offset)
{
    const char *message = "Hello from kernel module!\n";
    size_t len = strlen(message);
    
    if (*offset >= len)
        return 0;
    
    if (count > len - *offset)
        count = len - *offset;
    
    if (copy_to_user(buf, message + *offset, count))
        return -EFAULT;
    
    *offset += count;
    return count;
}

/**
 * Device file write operation
 */
static ssize_t custom_write(struct file *file, const char __user *buf,
                            size_t count, loff_t *offset)
{
    char kernel_buf[256];
    
    if (count > sizeof(kernel_buf) - 1)
        count = sizeof(kernel_buf) - 1;
    
    if (copy_from_user(kernel_buf, buf, count))
        return -EFAULT;
    
    kernel_buf[count] = '\0';
    printk(KERN_INFO MODULE_NAME ": Received from userspace: %s\n", kernel_buf);
    
    return count;
}

/**
 * Device file open operation
 */
static int custom_open(struct inode *inode, struct file *file)
{
    printk(KERN_INFO MODULE_NAME ": Device opened\n");
    return 0;
}

/**
 * Device file close operation
 */
static int custom_release(struct inode *inode, struct file *file)
{
    printk(KERN_INFO MODULE_NAME ": Device closed\n");
    return 0;
}

/**
 * File operations structure
 */
static const struct file_operations custom_fops = {
    .owner = THIS_MODULE,
    .read = custom_read,
    .write = custom_write,
    .open = custom_open,
    .release = custom_release,
};

/**
 * Module initialization
 */
static int __init custom_module_init(void)
{
    int ret;
    
    printk(KERN_INFO MODULE_NAME ": Loading kernel module...\n");
    
    /* Register character device */
    misc_dev.minor = MISC_DYNAMIC_MINOR;
    misc_dev.name = DEVICE_NAME;
    misc_dev.fops = &custom_fops;
    misc_dev.mode = 0666;
    
    ret = misc_register(&misc_dev);
    if (ret) {
        printk(KERN_ERR MODULE_NAME ": Failed to register device\n");
        return ret;
    }
    
    printk(KERN_INFO MODULE_NAME ": Device registered at /dev/%s\n", DEVICE_NAME);
    printk(KERN_INFO MODULE_NAME ": Module loaded successfully\n");
    
    return 0;
}

/**
 * Module exit
 */
static void __exit custom_module_exit(void)
{
    printk(KERN_INFO MODULE_NAME ": Unloading kernel module...\n");
    
    /* Unregister character device */
    misc_deregister(&misc_dev);
    
    printk(KERN_INFO MODULE_NAME ": Module unloaded\n");
}

module_init(custom_module_init);
module_exit(custom_module_exit);
