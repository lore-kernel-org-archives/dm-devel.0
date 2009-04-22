From: Mike Snitzer <snitzer@redhat.com>
Subject: double free in recent multipath-tools
Date: Wed, 22 Apr 2009 18:05:44 -0400
Message-ID: <20090422220544.GH32602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Seems the latest multipath-tools has an issue with a double free.  I
haven't looked at what the proper fix is yet but I wanted to give others
a heads up.

Running something as basic as 'multipath' drops a core.

The recent commit 37b079e555c459bd902a3855f223e3803aeb1fbe appears to
have the offending hunk:

@@ -404,6 +410,12 @@ free_config (struct config * conf)
        if (conf->checker_name)
                FREE(conf->checker_name);
 
+       if (conf->prio_name)
+               FREE(conf->prio_name);
+
+       if (conf->checker_name)
+               FREE(conf->checker_name);
+
        free_blacklist(conf->blist_devnode);
        free_blacklist(conf->blist_wwid);
        free_blacklist_device(conf->blist_device);


(gdb) bt
#0  0x0000003a6ec32f05 in raise () from /lib64/libc.so.6
#1  0x0000003a6ec34a73 in abort () from /lib64/libc.so.6
#2  0x0000003a6ec72438 in __libc_message () from /lib64/libc.so.6
#3  0x0000003a6ec77ec8 in malloc_printerr () from /lib64/libc.so.6
#4  0x0000003a6ec7a486 in free () from /lib64/libc.so.6
#5  0x00007ffff7dbc205 in xfree (p=0x60b2e0) at memory.c:52
#6  0x00007ffff7dc3624 in free_config (conf=0x604620) at config.c:414
#7  0x00000000004027a4 in main (argc=3, argv=0x7fffffffe718) at main.c:474
(gdb) frame 6
#6  0x00007ffff7dc3624 in free_config (conf=0x604620) at config.c:414
(gdb) l
409
410             if (conf->checker_name)
411                     FREE(conf->checker_name);
412
413             if (conf->prio_name)
414                     FREE(conf->prio_name);
415
416             if (conf->checker_name)
417                     FREE(conf->checker_name);
418
