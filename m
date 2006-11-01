From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] Round-robin path selector adds paths in wrong
	order.
Date: Wed, 01 Nov 2006 12:53:04 -0600
Message-ID: <1162407184.23016.4.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

When adding paths to the round-robin path selector, we expect to get
a FIFO behavior.  Instead, we get FILO.  This can be especially bad
if we specify a repeat count of 0, because it will result in us never
getting the path we wanted.

Here is an example of the problem:
[root@neo-04 ~]# echo "0 1024 error" | dmsetup create error
[root@neo-04 ~]# echo "0 1024 zero" | dmsetup create zero
[root@neo-04 ~]# echo "0 1024 multipath 0 0 1 1 round-robin 0 2 1 /dev/mapper/error 0 /dev/mapper/zero 0" | dmsetup create mpath
[root@neo-04 ~]# dd if=/dev/mapper/mpath of=/dev/null
1024+0 records in
1024+0 records out
[root@neo-04 ~]# dmsetup status mpath
0 1024 multipath 1 0 0 1 1 A 0 2 0 253:2 A 0 253:3 A 0
[root@neo-04 ~]# dmsetup remove mpath
[root@neo-04 ~]# echo "0 1024 multipath 0 0 1 1 round-robin 0 2 1 /dev/mapper/zero 0 /dev/mapper/error 0" | dmsetup create mpath
[root@neo-04 ~]# dd if=/dev/mapper/mpath of=/dev/null
1024+0 records in
1024+0 records out
[root@neo-04 ~]# dmsetup status mpath
0 1024 multipath 1 0 0 1 1 A 0 2 0 253:3 A 0 253:2 F 1

The problem stems from using 'list_add' where 'list_add_tail' should have
been used.

Index: linux-2.6.18.1/drivers/md/dm-round-robin.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-round-robin.c	2006-10-31 14:21:33.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-round-robin.c	2006-11-01 12:41:13.000000000 -0600
@@ -136,7 +136,7 @@ static int rr_add_path(struct path_selec
 
 	path->pscontext = pi;
 
-	list_add(&pi->list, &s->valid_paths);
+	list_add_tail(&pi->list, &s->valid_paths);
 
 	return 0;
 }
