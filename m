From: Kumar Amit Mehta <gmate.amit@gmail.com>
Subject: [PATCH] dm-lc.c: return -ENOMEM if alloc_workqueue fails
Date: Tue, 30 Jul 2013 02:18:10 +0530
Message-ID: <1375130890-9279-1-git-send-email-gmate.amit@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: ruby.wktk@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Audit the return value of alloc_workqueue and return -ENOMEM if it fails

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 Driver/dm-lc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Driver/dm-lc.c b/Driver/dm-lc.c
index 4f48cf2..9d394ee 100644
--- a/Driver/dm-lc.c
+++ b/Driver/dm-lc.c
@@ -2963,6 +2963,8 @@ static int __init lc_module_init(void)
 
 	safe_io_wq = alloc_workqueue("safeiowq",
 				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	if (!safe_io_wq)
+		return -ENOMEM;
 
 	lc_io_client = dm_io_client_create();
 
-- 
1.8.3.1
