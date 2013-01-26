From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] dm: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:04 -0800
Message-ID: <1359163872-1949-7-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c72e4d5..ea1a6ca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -318,7 +318,6 @@ static void __exit dm_exit(void)
 	/*
 	 * Should be empty by this point.
 	 */
-	idr_remove_all(&_minor_idr);
 	idr_destroy(&_minor_idr);
 }
 
-- 
1.8.1
