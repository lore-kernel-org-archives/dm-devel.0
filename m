From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/14] dm: Simplify use_blk_mq initialization
Date: Fri, 18 Nov 2016 14:27:42 -0800
Message-ID: <f335d0b1-15a5-6dec-fad9-7da6c962e631@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Use a single statement to declare and initialize 'use_blk_mq' instead
of two statements.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-rq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 7df7948..12ed327 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -23,11 +23,7 @@ static unsigned dm_mq_queue_depth = DM_MQ_QUEUE_DEPTH;
 #define RESERVED_REQUEST_BASED_IOS	256
 static unsigned reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
 
-#ifdef CONFIG_DM_MQ_DEFAULT
-static bool use_blk_mq = true;
-#else
-static bool use_blk_mq = false;
-#endif
+static bool use_blk_mq = IS_ENABLED(CONFIG_DM_MQ_DEFAULT);
 
 bool dm_use_blk_mq_default(void)
 {
-- 
2.10.1
