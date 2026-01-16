Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED20224B0E
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573883; cv=none; b=YP+gDnrZmVY9dNFv+xm3de5i8aSwtS82MnYOSZwx3A71SBIxWMUD0ctGahNQ1T1TGfbQUzadtMltXcc5ZhrQPUvHBHkcmWGEZWYH6Va6LrSy3aS9aYj9OVOPT3BiC652sQ/mw0Lsa/cikgri7D3chSSV9mb98e+46cUxpN3J9Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573883; c=relaxed/simple;
	bh=3xlcbET22g64bzkAxQaHFSNW+78gZ8AkVfPNR6LirZw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t7ZYJwLpQU/F9mQXcGPH8RdKCbuPlWsa08virKsFCDNIbedsByE4KE3ZELVNyMdCgF4LrjAQ7P9VToR12/u1IEBg/qKBGyZX9ng8rcMAXsvN29h3pvdgjpTVXfJjQaYFejtM7aJBhG+zw7a2q59n/HveZG2/d7/kumk3AOztVXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rT+hrQgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rT+hrQgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CAC19423;
	Fri, 16 Jan 2026 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768573880;
	bh=3xlcbET22g64bzkAxQaHFSNW+78gZ8AkVfPNR6LirZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rT+hrQgw4w1hetNrv27UsBxdmN/ybIEK2nXjGnloyQp7xY2V04e6bIaWUa9zRLg7B
	 gCkLSpprtsPQ2d3qyDxtNqsZDir0n341KmY4IjJmBMlGsX84AyLrzrBEFIkCFezp0g
	 6H/haKfvPi/1amTI+EuWd8Gbpe2J0U3Wlc5qgJMC4YQf+xy7xCsvQCLu/UmPTC/yVx
	 /3/somGLlD/THGmeEgFWHNZSpvuwSmbP+dS3TQ1tVRhe0K84ovFmPWbEJOFfAhW68q
	 gz4IKnCnZiXZ+MQMbPUGhVfhGeZEinMFv+Iq6hNESOD0wupwxD2SVCer5VIIT9M0N+
	 Fb3EUzfLVpTtg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 16 Jan 2026 15:30:34 +0100
Subject: [PATCH 1/2] dm-verity: add dm-verity keyring
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-work-dm-verity-keyring-v1-1-0d3de29b0618@kernel.org>
References: <20260116-work-dm-verity-keyring-v1-0-0d3de29b0618@kernel.org>
In-Reply-To: <20260116-work-dm-verity-keyring-v1-0-0d3de29b0618@kernel.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, dm-devel@lists.linux.dev, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-a6db3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6301; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3xlcbET22g64bzkAxQaHFSNW+78gZ8AkVfPNR6LirZw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRmeW/hNtjvuJBjbxn3Zq9mlldrPud8L/zufF9y7b5aI
 Z2fNxtbO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACay6QPDf7eLEfqvlrzrYrh4
 oalRd/JV11I2+RR53/SGL0XN6fWPWBkZdikz73xwfd2EPy7Lky9wZDxquOPX+o4tNUNo4vK37l8
 LeQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a dedicated ".dm-verity" keyring for root hash signature
verification, similar to the ".fs-verity" keyring used by fs-verity.

By default the keyring is unused retaining the exact same old behavior.
For systems that provision additional keys only intended for dm-verity
images during boot, the dm_verity.keyring_unsealed=1 kernel parameter
leaves the keyring open.

We want to use this in systemd as a way add keys during boot that are
only used for creating dm-verity devices for later mounting and nothing
else. The discoverable disk image (DDI) spec at [1] heavily relies on
dm-verity and we would like to expand this even more. This will allow us
to do that in a fully backward compatible way.

Once provisioning is complete, userspace restricts and activates it for
dm-verity verification. If userspace fully seals the keyring then it
gains the guarantee that no new keys can be added.

Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification [1]
Co-developed-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 ++++
 drivers/md/dm-verity-target.c                   | 20 ++++++++++-
 drivers/md/dm-verity-verify-sig.c               | 45 +++++++++++++++++++++++++
 drivers/md/dm-verity-verify-sig.h               | 12 +++++++
 4 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..374571c7921a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1370,6 +1370,13 @@ Kernel parameters
 			For details see:
 			Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst
 
+	dm_verity.keyring_unsealed=
+			[KNL] When set to 1, leave the dm-verity keyring
+			unsealed after initialization so userspace can
+			provision keys. Once the keyring is restricted
+			it becomes active and is searched during signature
+			verification.
+
 	driver_async_probe=  [KNL]
 			List of driver names to be probed asynchronously. *
 			matches with all driver names. If * is specified, the
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5c17472d7896..835358f63d09 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1803,7 +1803,25 @@ static struct target_type verity_target = {
 	.preresume	= verity_preresume,
 #endif /* CONFIG_SECURITY */
 };
-module_dm(verity);
+
+static int __init dm_verity_init(void)
+{
+	int r;
+
+	r = dm_verity_verify_sig_init();
+	if (r)
+		return r;
+
+	return dm_register_target(&verity_target);
+}
+module_init(dm_verity_init);
+
+static void __exit dm_verity_exit(void)
+{
+	dm_unregister_target(&verity_target);
+	dm_verity_verify_sig_exit();
+}
+module_exit(dm_verity_exit);
 
 /*
  * Check whether a DM target is a verity target.
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index d5261a0e4232..2a2abd9864c9 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -7,6 +7,7 @@
  */
 #include <linux/device-mapper.h>
 #include <linux/verification.h>
+#include <linux/key.h>
 #include <keys/user-type.h>
 #include <linux/module.h>
 #include "dm-verity.h"
@@ -14,6 +15,12 @@
 
 #define DM_VERITY_VERIFY_ERR(s) DM_VERITY_ROOT_HASH_VERIFICATION " " s
 
+static struct key *dm_verity_keyring;
+
+static bool dm_verity_keyring_unsealed __ro_after_init;
+module_param_named(keyring_unsealed, dm_verity_keyring_unsealed, bool, 0444);
+MODULE_PARM_DESC(keyring_unsealed, "Leave the dm-verity keyring unsealed");
+
 static bool require_signatures;
 module_param(require_signatures, bool, 0444);
 MODULE_PARM_DESC(require_signatures,
@@ -143,6 +150,17 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 					VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
 #endif
 
+	if (ret != -ENOKEY && ret != -EKEYREJECTED)
+		return ret;
+
+	if (dm_verity_keyring->keys.nr_leaves_on_tree &&
+	    dm_verity_keyring->restrict_link)
+		ret = verify_pkcs7_signature(root_hash, root_hash_len,
+					     sig_data, sig_len,
+					     dm_verity_keyring,
+					     VERIFYING_UNSPECIFIED_SIGNATURE,
+					     NULL, NULL);
+
 	return ret;
 }
 
@@ -152,3 +170,30 @@ void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
 	sig_opts->sig = NULL;
 	sig_opts->sig_size = 0;
 }
+
+int __init dm_verity_verify_sig_init(void)
+{
+	dm_verity_keyring = keyring_alloc(".dm-verity",
+					  GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
+					  current_cred(),
+					  KEY_POS_SEARCH |
+					  KEY_USR_VIEW | KEY_USR_READ |
+					  KEY_USR_WRITE | KEY_USR_SEARCH |
+					  KEY_USR_SETATTR,
+					  KEY_ALLOC_NOT_IN_QUOTA,
+					  NULL, NULL);
+	if (IS_ERR(dm_verity_keyring))
+		panic("dm-verity can't allocate keyring\n");
+
+	if (!dm_verity_keyring_unsealed &&
+	    keyring_restrict(make_key_ref(dm_verity_keyring, true), NULL, NULL))
+		panic("dm-verity can't seal keyring\n");
+
+	return 0;
+}
+
+void __exit dm_verity_verify_sig_exit(void)
+{
+	key_revoke(dm_verity_keyring);
+	key_put(dm_verity_keyring);
+}
diff --git a/drivers/md/dm-verity-verify-sig.h b/drivers/md/dm-verity-verify-sig.h
index f36ea92127bf..b0bb0d427244 100644
--- a/drivers/md/dm-verity-verify-sig.h
+++ b/drivers/md/dm-verity-verify-sig.h
@@ -30,6 +30,9 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 
 void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts);
 
+int __init dm_verity_verify_sig_init(void);
+void __exit dm_verity_verify_sig_exit(void);
+
 #else
 
 #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 0
@@ -56,5 +59,14 @@ static inline void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig
 {
 }
 
+static inline int dm_verity_verify_sig_init(void)
+{
+	return 0;
+}
+
+static inline void dm_verity_verify_sig_exit(void)
+{
+}
+
 #endif /* CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG */
 #endif /* DM_VERITY_SIG_VERIFICATION_H */

-- 
2.47.3

