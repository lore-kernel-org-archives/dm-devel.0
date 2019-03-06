From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Serial console is causing system lock-up
Date: Wed, 6 Mar 2019 09:27:13 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-serial@vger.kernel.org
Cc: dm-devel@redhat.com, Nigel Croxon <ncroxon@redhat.com>
List-Id: dm-devel.ids

Hi

I was debugging some kernel lockup with storage drivers and it turned out 
that the lockup is caused by the serial console subsystem. If we use 
serial console and if we write to it excessively, the kernel sometimes 
lockup, sometimes reports rcu stalls and NMI backtraces. Sometimes it will 
just print the console messages without donig anything else.

This program tests the issue - on framebuffer console, the system is 
sluggish, but it is possible to unload the module with rmmod. On serial 
console, it locks up to the point that unloading the module is not 
possible.

Mikulas



------------

#include <linux/module.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/kthread.h>

int n_threads = 0;
int sleep_ms = 0;

module_param_named(n_threads, n_threads, int, S_IRUGO);
MODULE_PARM_DESC(n_threads, "The number of kernel threads");

module_param_named(sleep_ms, sleep_ms, int, S_IRUGO);
MODULE_PARM_DESC(sleep_ms, "Sleep time in milliseconds");

struct task_struct **tasks;

static int console_dumper(void *data)
{
	int t = (int)(long)data;
	while (!kthread_should_stop()) {
		printk("line from thread %d ---------------------------------------------------------------------------------------------------------------------------------------\n", t);
		if (sleep_ms > 0)
			msleep(sleep_ms);
		cond_resched();
	}
	return 0;
}

static int __init dump_init(void)
{
	int i;
	if (n_threads <= 0)
		n_threads = num_online_cpus();
	tasks = kmalloc(n_threads * sizeof(struct task_struct *), GFP_KERNEL);
	if (!tasks)
		return -ENOMEM;
	for (i = 0; i < n_threads; i++) {
		tasks[i] = kthread_create(console_dumper, (void *)(long)i, "console_dumper");
		if (!tasks[i]) {
			while (i--)
				kthread_stop(tasks[i]);
			kfree(tasks);
			return -ENOMEM;
		}
		wake_up_process(tasks[i]);
	}
	return 0;
}

static void __exit dump_exit(void)
{
	int i;
	for (i = 0; i < n_threads; i++) {
		kthread_stop(tasks[i]);
	}
	kfree(tasks);
}

module_init(dump_init)
module_exit(dump_exit)
MODULE_LICENSE("GPL");
