From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] dm-target.c: remove unused macro DM_MOD_NAME_SIZE
Date: Mon,  5 Feb 2018 10:25:44 +0800
Message-ID: <20180205022544.5341-1-shhuiw@foxmail.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

DM_MOD_NAME_SIZE is not used in the kernel src.
Remove the macro define.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 drivers/md/dm-target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index c0d7e60820c4..314d17ca6466 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -16,8 +16,6 @@
 static LIST_HEAD(_targets);
 static DECLARE_RWSEM(_lock);
 
-#define DM_MOD_NAME_SIZE 32
-
 static inline struct target_type *__find_target_type(const char *name)
 {
 	struct target_type *tt;
-- 
2.11.0
