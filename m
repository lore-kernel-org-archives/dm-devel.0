From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 02/20] dm-crypt: use unbound workqueue for
	request processing
Date: Tue, 21 Aug 2012 11:09:13 +0200
Message-ID: <ca44fed7b535aaddbfb0593860ae98bc69ff2495.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Use unbound workqueue so that work is automatically ballanced between
available CPUs.

Note: workqueue implementation is somehow buggy, so it still does not yield
full parallelization across multiple CPUs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7a3e8eb..4c8b4e0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1649,8 +1649,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->crypt_queue = alloc_workqueue("kcryptd",
 					  WQ_NON_REENTRANT|
 					  WQ_CPU_INTENSIVE|
-					  WQ_MEM_RECLAIM,
-					  1);
+					  WQ_MEM_RECLAIM|
+					  WQ_UNBOUND,
+					  num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
-- 
1.7.10.4
