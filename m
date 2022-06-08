Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC786CCA47B
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:07:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-dQcvEn31MKqFsyAnjgSKoA-1; Wed, 08 Jun 2022 15:07:43 -0400
X-MC-Unique: dQcvEn31MKqFsyAnjgSKoA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FB4E81B549;
	Wed,  8 Jun 2022 19:07:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DE87492C3B;
	Wed,  8 Jun 2022 19:07:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F86A1947058;
	Wed,  8 Jun 2022 19:07:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DAAC5194705D
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BEB8D112131E; Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAEAE1121319
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A08E283397F
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-156-Aw8gLB95NmqLZpePav7PfA-3; Wed,
 08 Jun 2022 15:07:30 -0400
X-MC-Unique: Aw8gLB95NmqLZpePav7PfA-3
Received: from
 linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
 (linux.microsoft.com [13.77.154.182])
 by linux.microsoft.com (Postfix) with ESMTPSA id EF38820BE677;
 Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EF38820BE677
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  8 Jun 2022 12:01:23 -0700
Message-Id: <1654714889-26728-12-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [RFC PATCH v8 11/17] dm-verity: consume root hash digest
 and signature data via LSM hook
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-audit@redhat.com, linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-verity provides a strong guarantee of a block device's integrity. As
a generic way to check the integrity of a block device, it provides
those integrity guarantees to its lower layers, including the filesystem
level.

An LSM that control access to a resource on the system based on the
available integrity claims can use this transitive property of
dm-verity, by querying the underlying block_device of a particular
file.

The digest and signature information need to be stored in the block
device to fulfill the next requirement of authorization via LSM policy.
This will enable the LSM being able to perform revocation of devices
that are still mounted, prohibiting execution of files that are no
longer authorized by the LSM in question.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + No changes

v4:
  + No changes

v5:
  + No changes

v6:
  + Fix an improper cleanup that can result in
    a leak

v7:
  + Squash patch 08/12, 10/12 to [11/16]
  + Use part0 for block_device, to retrieve the block_device, when
    calling security_bdev_setsecurity

v8:
  + Undo squash of 08/12, 10/12 - separating drivers/md/ from
    security/ & block/
  + Use common-audit function for dmverity_signature.
  + Change implementation for storing the dm-verity digest to use the
    newly introduced dm_verity_digest structure introduced in patch
    14/20.
  + Create new structure, dm_verity_digest, containing digest algorithm,
    size, and digest itself to pass to the LSM layer. V7 was missing the
    algorithm.
  + Create an associated public header containing this new structure and
    the key values for the LSM hook, specific to dm-verity.
  + Additional information added to commit, discussing the layering of
    the changes and how the information passed will be used.
---
 drivers/md/dm-verity-target.c     | 25 +++++++++++++++++++++++--
 drivers/md/dm-verity-verify-sig.c | 16 +++++++++++++---
 drivers/md/dm-verity-verify-sig.h | 10 ++++++----
 include/linux/dm-verity.h         | 19 +++++++++++++++++++
 4 files changed, 61 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/dm-verity.h

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index d6dbd47492a8..0d499441e780 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -13,12 +13,16 @@
  * access behavior.
  */
 
+#include "dm-core.h"
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/scatterlist.h>
+#include <linux/security.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -1060,6 +1064,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	sector_t hash_position;
 	char dummy;
 	char *root_hash_digest_to_validate;
+	struct block_device *bdev;
+	struct dm_verity_digest root_digest;
 
 	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
 	if (!v) {
@@ -1093,6 +1099,13 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	v->version = num;
 
+	bdev = dm_table_get_md(ti->table)->disk->part0;
+	if (!bdev) {
+		ti->error = "Mapped device lookup failed";
+		r = -ENOMEM;
+		goto bad;
+	}
+
 	r = dm_get_device(ti, argv[1], FMODE_READ, &v->data_dev);
 	if (r) {
 		ti->error = "Data device lookup failed";
@@ -1225,7 +1238,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	/* Root hash signature is  a optional parameter*/
-	r = verity_verify_root_hash(root_hash_digest_to_validate,
+	r = verity_verify_root_hash(bdev, root_hash_digest_to_validate,
 				    strlen(root_hash_digest_to_validate),
 				    verify_args.sig,
 				    verify_args.sig_size);
@@ -1298,12 +1311,20 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->per_io_data_size = roundup(ti->per_io_data_size,
 				       __alignof__(struct dm_verity_io));
 
+	root_digest.digest = v->root_digest;
+	root_digest.digest_len = v->digest_size;
+	root_digest.algo = v->alg_name;
+
+	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
+				      sizeof(root_digest));
+	if (r)
+		goto bad;
+
 	verity_verify_sig_opts_cleanup(&verify_args);
 
 	return 0;
 
 bad:
-
 	verity_verify_sig_opts_cleanup(&verify_args);
 	verity_dtr(ti);
 
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index db61a1f43ae9..06c15c555a4b 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -9,6 +9,9 @@
 #include <linux/verification.h>
 #include <keys/user-type.h>
 #include <linux/module.h>
+#include <linux/security.h>
+#include <linux/dm-verity.h>
+#include "dm-core.h"
 #include "dm-verity.h"
 #include "dm-verity-verify-sig.h"
 
@@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
  * verify_verify_roothash - Verify the root hash of the verity hash device
  *			     using builtin trusted keys.
  *
+ * @bdev: block_device representing the device-mapper created block device.
+ *	Used by the security hook, to set information about the block_device.
  * @root_hash: For verity, the roothash/data to be verified.
  * @root_hash_len: Size of the roothash/data to be verified.
  * @sig_data: The trusted signature that verifies the roothash/data.
  * @sig_len: Size of the signature.
  *
  */
-int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
-			    const void *sig_data, size_t sig_len)
+int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
+			    size_t root_hash_len, const void *sig_data,
+			    size_t sig_len)
 {
 	int ret;
 
@@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 				NULL,
 #endif
 				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
+	if (ret)
+		return ret;
 
-	return ret;
+	return security_bdev_setsecurity(bdev,
+					 DM_VERITY_SIGNATURE_SEC_NAME,
+					 sig_data, sig_len);
 }
 
 void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
diff --git a/drivers/md/dm-verity-verify-sig.h b/drivers/md/dm-verity-verify-sig.h
index 3987c7141f79..31692fff92e4 100644
--- a/drivers/md/dm-verity-verify-sig.h
+++ b/drivers/md/dm-verity-verify-sig.h
@@ -20,8 +20,9 @@ struct dm_verity_sig_opts {
 
 #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 2
 
-int verity_verify_root_hash(const void *data, size_t data_len,
-			    const void *sig_data, size_t sig_len);
+int verity_verify_root_hash(struct block_device *bdev, const void *data,
+			    size_t data_len, const void *sig_data,
+			    size_t sig_len);
 bool verity_verify_is_sig_opt_arg(const char *arg_name);
 
 int verity_verify_sig_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
@@ -34,8 +35,9 @@ void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts);
 
 #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 0
 
-static inline int verity_verify_root_hash(const void *data, size_t data_len,
-					  const void *sig_data, size_t sig_len)
+int verity_verify_root_hash(struct block_device *bdev, const void *data,
+			    size_t data_len, const void *sig_data,
+			    size_t sig_len)
 {
 	return 0;
 }
diff --git a/include/linux/dm-verity.h b/include/linux/dm-verity.h
new file mode 100644
index 000000000000..bb0413d55d72
--- /dev/null
+++ b/include/linux/dm-verity.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_DM_VERITY_H
+#define _LINUX_DM_VERITY_H
+
+#include <linux/types.h>
+#include <crypto/hash_info.h>
+#include <linux/device-mapper.h>
+
+struct dm_verity_digest {
+	const char *algo;
+	const u8 *digest;
+	size_t digest_len;
+};
+
+#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-signature"
+#define DM_VERITY_ROOTHASH_SEC_NAME  DM_NAME	".verity-roothash"
+
+#endif /* _LINUX_DM_VERITY_H */
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

