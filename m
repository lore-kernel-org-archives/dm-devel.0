From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] fix double frees in recent multipath-tools
Date: Wed, 22 Apr 2009 21:18:35 -0400
Message-ID: <20090423011834.GA14759@redhat.com>
References: <20090422220544.GH32602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090422220544.GH32602@redhat.com>
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

On Wed, Apr 22 2009 at  6:05pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> 
> Seems the latest multipath-tools has an issue with a double free.  I
> haven't looked at what the proper fix is yet but I wanted to give others
> a heads up.
> 
> Running something as basic as 'multipath' drops a core.
...
> (gdb) bt
> #0  0x0000003a6ec32f05 in raise () from /lib64/libc.so.6
> #1  0x0000003a6ec34a73 in abort () from /lib64/libc.so.6
> #2  0x0000003a6ec72438 in __libc_message () from /lib64/libc.so.6
> #3  0x0000003a6ec77ec8 in malloc_printerr () from /lib64/libc.so.6
> #4  0x0000003a6ec7a486 in free () from /lib64/libc.so.6
> #5  0x00007ffff7dbc205 in xfree (p=0x60b2e0) at memory.c:52
> #6  0x00007ffff7dc3624 in free_config (conf=0x604620) at config.c:414
> #7  0x00000000004027a4 in main (argc=3, argv=0x7fffffffe718) at main.c:474
> (gdb) frame 6
> #6  0x00007ffff7dc3624 in free_config (conf=0x604620) at config.c:414
> (gdb) l
> 409
> 410             if (conf->checker_name)
> 411                     FREE(conf->checker_name);
> 412
> 413             if (conf->prio_name)
> 414                     FREE(conf->prio_name);
> 415
> 416             if (conf->checker_name)
> 417                     FREE(conf->checker_name);
> 418

Here is another one:

(gdb) bt
#0  0x0000003a6ec32f05 in raise () from /lib64/libc.so.6
#1  0x0000003a6ec34a73 in abort () from /lib64/libc.so.6
#2  0x0000003a6ec72438 in __libc_message () from /lib64/libc.so.6
#3  0x0000003a6ec77ec8 in malloc_printerr () from /lib64/libc.so.6
#4  0x0000003a6ec7a486 in free () from /lib64/libc.so.6
#5  0x00007ffff7dbc205 in xfree (p=0x604a90) at memory.c:52
#6  0x00007ffff7dc2ac2 in free_hwe (hwe=0x604950) at config.c:162
#7  0x00007ffff7dc2b0f in free_hwtable (hwtable=0x604460) at config.c:179
#8  0x00007ffff7dc3684 in free_config (conf=0x604620) at config.c:422
#9  0x00000000004027a4 in main (argc=1, argv=0x7fffffffe738) at main.c:474
(gdb) frame 6
#6  0x00007ffff7dc2ac2 in free_hwe (hwe=0x604950) at config.c:162
162                     FREE(hwe->prio_name);
(gdb) l
157
158             if (hwe->bl_product)
159                     FREE(hwe->bl_product);
160
161             if (hwe->prio_name)
162                     FREE(hwe->prio_name);
163
164             if (hwe->checker_name)
165                     FREE(hwe->checker_name);
166             FREE(hwe);


The following patch fixes the crashes I saw.

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6039642..05dbcd2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -158,11 +158,6 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->bl_product)
 		FREE(hwe->bl_product);
 
-	if (hwe->prio_name)
-		FREE(hwe->prio_name);
-
-	if (hwe->checker_name)
-		FREE(hwe->checker_name);
 	FREE(hwe);
 }
 
@@ -410,12 +405,6 @@ free_config (struct config * conf)
 	if (conf->checker_name)
 		FREE(conf->checker_name);
 
-	if (conf->prio_name)
-		FREE(conf->prio_name);
-
-	if (conf->checker_name)
-		FREE(conf->checker_name);
-
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
