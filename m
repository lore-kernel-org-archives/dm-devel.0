From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] dm crypt: remove an impossible condition
Date: Fri, 17 Mar 2017 23:46:56 +0300
Message-ID: <20170317204655.GA28261@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Static checkers complain that it doesn't make sense to check if "sval"
is NULL.  The intention was to check if strchr() returned NULL, but in
that situation "sval" would be "NULL + 1" so the check doesn't work.  We
know from the sscanf() that there is a ':' character in the string so
the check is unnecessary and can be removed.

Now that the check doesn't depend on "sval" it can be moved earlier
for readability.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ec09bd703b7d..eba218737bdb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2401,12 +2401,12 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
 		else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
-			cc->on_disk_tag_size = val;
-			sval = strchr(opt_string + strlen("integrity:"), ':') + 1;
-			if (val == 0 || val > MAX_TAG_SIZE || !sval) {
+			if (val == 0 || val > MAX_TAG_SIZE) {
 				ti->error = "Invalid integrity arguments";
 				return -EINVAL;
 			}
+			cc->on_disk_tag_size = val;
+			sval = strchr(opt_string + strlen("integrity:"), ':') + 1;
 			if (!strcasecmp(sval, "aead")) {
 				set_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags);
 			} else  if (!strncasecmp(sval, "hmac(", strlen("hmac("))) {
