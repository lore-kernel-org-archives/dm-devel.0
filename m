From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] dm: Fix trailing semicolon
Date: Wed, 17 Jan 2018 15:09:25 +0000
Message-ID: <20180117150925.32368-1-luisbg@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Luis de Bethencourt <luisbg@kernel.org>
List-Id: dm-devel.ids

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards,
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c1c6160be355..629c555890c1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1722,7 +1722,7 @@ static void __remap_and_issue_shared_cell(void *context,
 		    bio_op(bio) == REQ_OP_DISCARD)
 			bio_list_add(&info->defer_bios, bio);
 		else {
-			struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));;
+			struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
 
 			h->shared_read_entry = dm_deferred_entry_inc(info->tc->pool->shared_read_ds);
 			inc_all_io_entry(info->tc->pool, bio);
-- 
2.15.1
