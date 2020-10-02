From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v1] dm verity: Add support for signature verification with 2nd keyring
Date: Fri,  2 Oct 2020 09:18:02 +0200
Message-ID: <20201002071802.535023-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Deven Bowers <deven.desai@linux.microsoft.com>, Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
List-Id: dm-devel.ids

From: Mickaël Salaün <mic@linux.microsoft.com>

Add a new DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING configuration
to enable dm-verity signatures to be verified against the secondary
trusted keyring.  This allows certificate updates without kernel update
and reboot, aligning with module and kernel (kexec) signature
verifications.

Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Cc: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/Kconfig                | 13 ++++++++++++-
 drivers/md/dm-verity-verify-sig.c |  9 +++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba3573626c..63870fdfe8ce 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -530,11 +530,22 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG
 	bool "Verity data device root hash signature verification support"
 	depends on DM_VERITY
 	select SYSTEM_DATA_VERIFICATION
-	  help
+	---help---
 	  Add ability for dm-verity device to be validated if the
 	  pre-generated tree of cryptographic checksums passed has a pkcs#7
 	  signature file that can validate the roothash of the tree.
 
+	  By default, rely on the builtin trusted keyring.
+
+	  If unsure, say N.
+
+config DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
+	bool "Verity data device root hash signature verification with secondary keyring"
+	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
+	depends on SECONDARY_TRUSTED_KEYRING
+	---help---
+	  Rely on the secondary trusted keyring to verify dm-verity signatures.
+
 	  If unsure, say N.
 
 config DM_VERITY_FEC
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 614e43db93aa..29385dc470d5 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -119,8 +119,13 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 	}
 
 	ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
-				sig_len, NULL, VERIFYING_UNSPECIFIED_SIGNATURE,
-				NULL, NULL);
+				sig_len,
+#ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
+				VERIFY_USE_SECONDARY_KEYRING,
+#else
+				NULL,
+#endif
+				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
 
 	return ret;
 }
-- 
2.28.0
