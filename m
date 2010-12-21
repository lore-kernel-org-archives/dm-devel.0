From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 1/7] dm crypt: fix per cpu struct dereference in
	destructor
Date: Tue, 21 Dec 2010 16:28:13 +0100
Message-ID: <c718a9b949f971d43980ec91e55b3111aac5c7fa.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

If destructor is called early (e.g. wrong cipher format)
the destructor tries to access nonexistent per cpu struct
and causes OOps.

Patch adds check for struct existence (and simplifies
tfm destructor as well).

(introduced in per cpu patch)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 98a7ad0..6aeb1fe 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1088,7 +1088,6 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 	return err;
 }
 
-
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	unsigned key_size = strlen(key) >> 1;
@@ -1114,20 +1113,6 @@ static int crypt_wipe_key(struct crypt_config *cc)
 	return crypt_setkey_allcpus(cc);
 }
 
-static void crypt_dtr_cpus(struct crypt_config *cc)
-{
-	struct crypt_cpu *cs;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		cs = per_cpu_ptr(cc->cpu, cpu);
-		if (cs->tfm) {
-			crypto_free_ablkcipher(cs->tfm);
-			cs->tfm = NULL;
-		}
-	}
-}
-
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = ti->private;
@@ -1144,11 +1129,14 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
-	for_each_possible_cpu(cpu) {
-		cs = per_cpu_ptr(cc->cpu, cpu);
-		if (cs->req)
-			mempool_free(cs->req, cc->req_pool);
-	}
+	if (cc->cpu)
+		for_each_possible_cpu(cpu) {
+			cs = per_cpu_ptr(cc->cpu, cpu);
+			if (cs->req)
+				mempool_free(cs->req, cc->req_pool);
+			if (cs->tfm)
+				crypto_free_ablkcipher(cs->tfm);
+		}
 
 	if (cc->bs)
 		bioset_free(cc->bs);
@@ -1166,8 +1154,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	crypt_dtr_cpus(cc);
-
 	if (cc->cpu)
 		free_percpu(cc->cpu);
 
-- 
1.7.2.3
