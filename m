From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5/8] dm verity: Fix compilation warning
Date: Wed, 15 Jul 2020 18:52:14 +0900
Message-ID: <20200715095217.441885-6-damien.lemoal@wdc.com>
References: <20200715095217.441885-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200715095217.441885-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

For the case !CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG, declare the
functions verity_verify_root_hash(), verity_verify_is_sig_opt_arg(),
verity_verify_sig_parse_opt_args() and verity_verify_sig_opts_cleanup()
as inline to avoid a "no previous prototype for xxx" compilation
warning when compiling with W=1.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-verity-verify-sig.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-verify-sig.h b/drivers/md/dm-verity-verify-sig.h
index 19b1547aa741..3987c7141f79 100644
--- a/drivers/md/dm-verity-verify-sig.h
+++ b/drivers/md/dm-verity-verify-sig.h
@@ -34,25 +34,25 @@ void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts);
 
 #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 0
 
-int verity_verify_root_hash(const void *data, size_t data_len,
-			    const void *sig_data, size_t sig_len)
+static inline int verity_verify_root_hash(const void *data, size_t data_len,
+					  const void *sig_data, size_t sig_len)
 {
 	return 0;
 }
 
-bool verity_verify_is_sig_opt_arg(const char *arg_name)
+static inline bool verity_verify_is_sig_opt_arg(const char *arg_name)
 {
 	return false;
 }
 
-int verity_verify_sig_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
-				    struct dm_verity_sig_opts *sig_opts,
-				    unsigned int *argc, const char *arg_name)
+static inline int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
+			struct dm_verity *v, struct dm_verity_sig_opts *sig_opts,
+			unsigned int *argc, const char *arg_name)
 {
 	return -EINVAL;
 }
 
-void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
+static inline void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
 {
 }
 
-- 
2.26.2
