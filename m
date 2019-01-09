From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Fix parsing of extended IV arguments.
Date: Wed,  9 Jan 2019 11:57:14 +0100
Message-ID: <20190109105714.3606-1-gmazyland@gmail.com>
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
To: dm-devel@redhat.com
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>, snitzer@redhat.com
List-Id: dm-devel.ids

The dm-crypt cipher specification in a mapping table is defined as
  cipher[:keycount]-chainmode-ivmode[:ivopts] or with the new crypt API format
  capi:cipher_api_spec-ivmode[:ivopts].

For ESSIV, the parameter includes hash specification, for example aes-cbc-essiv:sha256.

The implementation expected that additional IV option never includes another dash '-' character

Unfortunately, with SHA3, we have now names like sha3-256, so the mapping table parser fails:

dmsetup create test --table "0 8 crypt aes-cbc-essiv:sha3-256 9c1185a5c5e9fc54612808977ee8f5b9e 0 /dev/sdb 0"
  or (new format)
dmsetup create test --table "0 8 crypt capi:cbc(aes)-essiv:sha3-256 9c1185a5c5e9fc54612808977ee8f5b9e 0 /dev/sdb 0"

  device-mapper: crypt: Ignoring unexpected additional cipher options
  device-mapper: table: 253:0: crypt: Error creating IV
  device-mapper: ioctl: error adding target to table

This patch fixes the dm-crypt constructor to ignore additional dash in IV options and also removes
bogus warning (that is ignored anyway).

[This patch should go into stable tree as well.]

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0ff22159a0ca..71bfb85f9652 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2414,9 +2414,21 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	 * capi:cipher_api_spec-iv:ivopts
 	 */
 	tmp = &cipher_in[strlen("capi:")];
-	cipher_api = strsep(&tmp, "-");
-	*ivmode = strsep(&tmp, ":");
-	*ivopts = tmp;
+
+	/* Separate IV options if present, it can contain another '-' in hash name */
+	*ivopts = strrchr(tmp, ':');
+	if (*ivopts) {
+		**ivopts = '\0';
+		(*ivopts)++;
+	}
+	/* Parse IV mode */
+	*ivmode = strrchr(tmp, '-');
+	if (*ivmode) {
+		**ivmode = '\0';
+		(*ivmode)++;
+	}
+	/* The rest is crypto API spec */
+	cipher_api = tmp;
 
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
@@ -2486,11 +2498,8 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		goto bad_mem;
 
 	chainmode = strsep(&tmp, "-");
-	*ivopts = strsep(&tmp, "-");
-	*ivmode = strsep(&*ivopts, ":");
-
-	if (tmp)
-		DMWARN("Ignoring unexpected additional cipher options");
+	*ivmode   = strsep(&tmp, ":");
+	*ivopts = tmp;
 
 	/*
 	 * For compatibility with the original dm-crypt mapping format, if
-- 
2.20.1
