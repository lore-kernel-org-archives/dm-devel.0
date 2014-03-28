From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/9] dm crypt: use unbound workqueue for request
	processing
Date: Fri, 28 Mar 2014 16:11:11 -0400
Message-ID: <1396037476-26595-5-git-send-email-snitzer@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Use unbound workqueue so that work is automatically ballanced between
available CPUs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2221d12..a57b02a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1800,7 +1800,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
-- 
1.8.1.4
