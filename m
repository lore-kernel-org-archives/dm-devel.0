From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 2/7] dm crypt: remove redundant setkey call
Date: Tue, 21 Dec 2010 16:28:14 +0100
Message-ID: <96a50ca507cdb1433729f5321136d159ea5fd3f4.1292944625.git.mbroz@redhat.com>
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

All keys are already set in crypt_ctr_cipher() call,
no need set the key again later.

(introduced in per cpu patch)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6aeb1fe..dbed83d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1317,10 +1317,9 @@ bad_mem:
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
-	struct crypt_cpu *cs;
 	unsigned int key_size;
 	unsigned long long tmpll;
-	int ret, cpu;
+	int ret;
 
 	if (argc != 5) {
 		ti->error = "Not enough arguments";
@@ -1372,14 +1371,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	for_each_possible_cpu(cpu) {
-		cs = per_cpu_ptr(cc->cpu, cpu);
-		if (crypto_ablkcipher_setkey(cs->tfm, cc->key, key_size) < 0) {
-			ti->error = "Error setting key";
-			goto bad;
-		}
-	}
-
 	ret = -EINVAL;
 	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid iv_offset sector";
-- 
1.7.2.3
