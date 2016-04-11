From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] dm thin: Remove return statement from void function
Date: Mon, 11 Apr 2016 11:37:08 +0530
Message-ID: <20160411060707.GA2236@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: dm-devel.ids

Return statement at the end of a void function is useless.

The Coccinelle semantic patch used to make this change is as follows:
//<smpl>
@@
identifier f;
expression e;
@@
void f(...) {
<...
- return
  e;
...>
}
//</smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 92237b6..04e7f3b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -632,7 +632,7 @@ static void error_retry_list(struct pool *pool)
 {
 	int error = get_pool_io_error_code(pool);
 
-	return error_retry_list_with_code(pool, error);
+	error_retry_list_with_code(pool, error);
 }
 
 /*
-- 
1.9.1

