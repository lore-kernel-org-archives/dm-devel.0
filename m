From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH] dm: fix freeze_bdev() return value check
Date: Tue, 25 Sep 2007 23:23:03 +0900
Message-ID: <961aa3350709250723q14308a41hfebbae60e0cabe53@mail.gmail.com>
References: <20070924105636.GA30406@APFDCB5C>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070924105636.GA30406@APFDCB5C>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

2007/9/24, Akinobu Mita <akinobu.mita@gmail.com>:
> freeze_bdev() does not return errno as pointer on failure.
> This patch fixes the return value check.

I misunderstood the meaning of the return value of freeze_bdev().
I thought NULL returned by freeze_bdev means error. But it is wrong.
freeze_bdev returns NULL when there is no filesystem mounted on the
device with holding bd_mount_sem.
So this patch is totally broken.

But there is no reason to check the return value with IS_ERR().
Because freeze_bdev return NULL or valid super block

Subject: [PATCH] dm: remove freeze_bdev() return value check
From: Akinobu Mita <akinobu.mita@gmail.com>

There is no reason to check the return value with IS_ERR().
Because freeze_bdev return NULL or valid super block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/md/dm.c |    7 -------
 1 file changed, 7 deletions(-)

Index: 2.6-git/drivers/md/dm.c
===================================================================
--- 2.6-git.orig/drivers/md/dm.c
+++ 2.6-git/drivers/md/dm.c
@@ -1290,16 +1290,9 @@ out:
  */
 static int lock_fs(struct mapped_device *md)
 {
-	int r;
-
 	WARN_ON(md->frozen_sb);

 	md->frozen_sb = freeze_bdev(md->suspended_bdev);
-	if (IS_ERR(md->frozen_sb)) {
-		r = PTR_ERR(md->frozen_sb);
-		md->frozen_sb = NULL;
-		return r;
-	}

 	set_bit(DMF_FROZEN, &md->flags);
