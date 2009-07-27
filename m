From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] drop mutex in __set_size
Date: Mon, 27 Jul 2009 19:44:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907271942001.10397@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com> <4A6824DA.30205@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A6824DA.30205@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 23 Jul 2009, Jun'ichi Nomura wrote:

> Hi Alasdair, Mikulas,
> 
> I found 2.6.31-rc includes the following commit:
>   commit 32a926da5a16c01a8213331e5764472ce2f14a8d
>   Author: Mikulas Patocka <mpatocka@redhat.com>
>   Date:   Mon Jun 22 10:12:17 2009 +0100
> 
> which will introduce a deadlock problem described here:
> https://www.redhat.com/archives/dm-devel/2009-May/msg00097.html
> (or see below)
> 
> Was the problem fixed/worked around somehow?

Hi.

I'd submit this. What do others think about it?

Mikulas

---

Drop the mutex.

It doesn't make sense to lock it for a single assignment, this code can't
be executed concurrently. The size should be read with i_size_read which
is automatically protected against concurrent i_size_write.

This locking can lead to a deadlock, if someone holds i_mutex while
the device is being suspended, described by Jun'ichi Nomura at
https://www.redhat.com/archives/dm-devel/2009-May/msg00097.html

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.31-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.31-rc3-devel.orig/drivers/md/dm.c	2009-07-28 01:20:17.000000000 +0200
+++ linux-2.6.31-rc3-devel/drivers/md/dm.c	2009-07-28 01:20:27.000000000 +0200
@@ -1901,9 +1901,7 @@ static void __set_size(struct mapped_dev
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 static int __bind(struct mapped_device *md, struct dm_table *t,
