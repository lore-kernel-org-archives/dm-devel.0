Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617CDC0015E
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jun 2023 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687648214;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LhFfAqbCrrGxhPHiEIrQ7CVg5aZO0d0F3bRPhqIF06U=;
	b=NCNqkWXgUPup07SeHJPocD74tQkEXZTl/JwSVGenRcv7ojHLj5g8l9hkKT4IdQ5cqhMeHi
	pNOmpmxj8/rVpTbsULWnFVFEDtQkdGgpTs6uHd1ZbQaGEdjy7RMfwSwUnsEhE46WcFS4I7
	w/78XLoPL3yjxJI1A5mu6Jzm8j5IYcs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-Sl9my-WvNGike3Oswj6aLg-1; Sat, 24 Jun 2023 19:10:10 -0400
X-MC-Unique: Sl9my-WvNGike3Oswj6aLg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD63B3C025BC;
	Sat, 24 Jun 2023 23:10:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA7DF492B01;
	Sat, 24 Jun 2023 23:10:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A133E194658D;
	Sat, 24 Jun 2023 23:10:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F364C1946594
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 23:10:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4DFF425364; Sat, 24 Jun 2023 23:10:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD715425361
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD9773C025BC
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:07 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-q8k58BQVMxuK9IhP7OPVZA-1; Sat, 24 Jun 2023 19:10:05 -0400
X-MC-Unique: q8k58BQVMxuK9IhP7OPVZA-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.west.internal (Postfix) with ESMTP id 470663200065;
 Sat, 24 Jun 2023 19:10:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Sat, 24 Jun 2023 19:10:04 -0400
X-ME-Sender: <xms:y3eXZFRz36sxxbLfs0gfFKAcfJ7QGduz4377NHGCIbMljDzHZR6Q6A>
 <xme:y3eXZOyuJ2Fqr6XDrPtMSP8OWdW5MoE4TEOFWmSE0tQfrum5QVROBBdoFWcQoKMZK
 HTFlFWlwWEvl20>
X-ME-Received: <xmr:y3eXZK3a_eVPRBg9l94TsMTbV0_Fzar5voKePt8sxIyLlqmc83zP8O1Mt7-K-T_OK-qTBFDZCC8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeegkedgudekucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:y3eXZND17OGUsJvX45vNHQhA_o3xcivFhsz21rX4ubR5kYFS1Wx0DQ>
 <xmx:y3eXZOhNwU44Sk6kJp4jDxDpulXsj9hww8lFjs9KHrHJC-HyU2Wthw>
 <xmx:y3eXZBo4E7foBXTAqnOlpBoxWPCfIznI1X1rjAPol9BANsmjVWE7DQ>
 <xmx:y3eXZBswoU2Wved-F9JGID52pLxTVOIdQU1answEQehUjgRS-KFUWw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Jun 2023 19:10:03 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat, 24 Jun 2023 19:09:46 -0400
Message-ID: <20230624230950.2272-4-demi@invisiblethingslab.com>
In-Reply-To: <20230624230950.2272-1-demi@invisiblethingslab.com>
References: <20230624230950.2272-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 3/4] dm ioctl: Allow userspace to suppress
 uevent generation
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Userspace can use this to avoid spamming udev with events that udev
should ignore.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-core.h          |  2 +
 drivers/md/dm-ioctl.c         | 71 ++++++++++++++++++-----------------
 drivers/md/dm.c               |  5 ++-
 include/linux/device-mapper.h |  2 +-
 include/uapi/linux/dm-ioctl.h | 14 +++++--
 5 files changed, 54 insertions(+), 40 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 0d93661f88d306e0d0aa3a1ac085880a8b63d9d6..5a4acdbf119f9b3f9a1c60de36d23f0658449701 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -115,6 +115,8 @@ struct mapped_device {
 
 	/* for blk-mq request-based DM support */
 	bool init_tio_pdu:1;
+	/* If set, do not emit any uevents. */
+	bool disable_uevents:1;
 	struct blk_mq_tag_set *tag_set;
 
 	struct dm_stats stats;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7abaeec33f1884d4588e8563fb02e9ea1a6782c8..7eab9a8c77ff3286346a1c44581d3b6370a731eb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -821,6 +821,11 @@ static struct dm_table *dm_get_live_or_inactive_table(struct mapped_device *md,
 		dm_get_inactive_table(md, srcu_idx) : dm_get_live_table(md, srcu_idx);
 }
 
+static inline bool sloppy_checks(const struct dm_ioctl *param)
+{
+	return param->version[0] < DM_VERSION_MAJOR_STRICT;
+}
+
 /*
  * Fills in a dm_ioctl structure, ready for sending back to
  * userland.
@@ -879,7 +884,7 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 		dm_put_live_table(md, srcu_idx);
 	}
 
-	if (param->version[0] >= DM_VERSION_MAJOR_STRICT)
+	if (!sloppy_checks(param))
 		dm_set_diskseq(param, disk->diskseq);
 }
 
@@ -895,7 +900,7 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (param->flags & DM_PERSISTENT_DEV_FLAG)
 		m = MINOR(huge_decode_dev(param->dev));
 
-	r = dm_create(m, &md);
+	r = dm_create(m, &md, param->flags & DM_DISABLE_UEVENTS_FLAG);
 	if (r)
 		return r;
 
@@ -1463,11 +1468,6 @@ static int next_target(struct dm_target_spec *last, uint32_t next, const char *e
 	return 0;
 }
 
-static inline bool sloppy_checks(const struct dm_ioctl *param)
-{
-	return param->version[0] < DM_VERSION_MAJOR_STRICT;
-}
-
 static bool no_non_nul_after_nul(const char *untrusted_str, size_t size,
 				 unsigned int cmd, const char *msg)
 {
@@ -1939,64 +1939,67 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
  * Implementation of open/close/ioctl on the special char device.
  *---------------------------------------------------------------
  */
-static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags, uint32_t *supported_flags)
+static ioctl_fn lookup_ioctl(unsigned int cmd, bool strict, int *ioctl_flags,
+			     uint32_t *supported_flags)
 {
 	static const struct {
 		int cmd;
 		int flags;
 		ioctl_fn fn;
 		uint32_t supported_flags;
+		uint32_t strict_flags;
 	} _ioctls[] = {
 		/* Macro to make the structure initializers somewhat readable */
-#define I(cmd, flags, fn, supported_flags) ((typeof(_ioctls[0])) {				\
+#define I(cmd, flags, fn, supported_flags, strict_flags) ((typeof(_ioctls[0])) {		\
 	(cmd),											\
 	(flags),										\
 	(fn),											\
 	/*
 	 * Supported flags in sloppy mode must not include anything in DM_STRICT_ONLY_FLAGS.
-	 * Use BUILD_BUG_ON_ZERO to check for that.  Currently there are no strict-only flags
-	 * defined.
+	 * Use BUILD_BUG_ON_ZERO to check for that.
 	 */											\
 	(supported_flags) | BUILD_BUG_ON_ZERO((supported_flags) & DM_STRICT_ONLY_FLAGS),	\
+	(strict_flags) | (supported_flags) |							\
+	 BUILD_BUG_ON_ZERO((supported_flags) & (strict_flags)),					\
 })
-		I(DM_VERSION_CMD, 0, NULL, 0), /* version is dealt with elsewhere */
+		I(DM_VERSION_CMD, 0, NULL, 0, 0), /* version is dealt with elsewhere */
 		I(DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT,
-		  remove_all, DM_DEFERRED_REMOVE),
-		I(DM_LIST_DEVICES_CMD, 0, list_devices, DM_UUID_FLAG),
+		  remove_all, DM_DEFERRED_REMOVE, 0),
+		I(DM_LIST_DEVICES_CMD, 0, list_devices, DM_UUID_FLAG, 0),
 		I(DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT,
-		  dev_create, DM_PERSISTENT_DEV_FLAG),
+		  dev_create, DM_PERSISTENT_DEV_FLAG, DM_DISABLE_UEVENTS_FLAG),
 		I(DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT,
-		  dev_remove, DM_DEFERRED_REMOVE),
+		  dev_remove, DM_DEFERRED_REMOVE, 0),
 		I(DM_DEV_RENAME_CMD, IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_rename,
-		 DM_QUERY_INACTIVE_TABLE_FLAG | DM_UUID_FLAG),
+		  DM_QUERY_INACTIVE_TABLE_FLAG | DM_UUID_FLAG, 0),
 		I(DM_DEV_SUSPEND_CMD, IOCTL_FLAGS_NO_PARAMS, dev_suspend,
-		 DM_QUERY_INACTIVE_TABLE_FLAG | DM_SUSPEND_FLAG | DM_SKIP_LOCKFS_FLAG |
-		 DM_NOFLUSH_FLAG),
+		  DM_QUERY_INACTIVE_TABLE_FLAG | DM_SUSPEND_FLAG |
+		  DM_SKIP_LOCKFS_FLAG | DM_NOFLUSH_FLAG, 0),
 		I(DM_DEV_STATUS_CMD, IOCTL_FLAGS_NO_PARAMS, dev_status,
-		  DM_QUERY_INACTIVE_TABLE_FLAG),
+		  DM_QUERY_INACTIVE_TABLE_FLAG, 0),
 		I(DM_DEV_WAIT_CMD, IOCTL_FLAGS_TAKES_EVENT_NR, dev_wait,
-		 DM_QUERY_INACTIVE_TABLE_FLAG | DM_STATUS_TABLE_FLAG | DM_NOFLUSH_FLAG),
-		I(DM_TABLE_LOAD_CMD, 0, table_load, DM_QUERY_INACTIVE_TABLE_FLAG |
-		  DM_READONLY_FLAG),
+		  DM_QUERY_INACTIVE_TABLE_FLAG | DM_STATUS_TABLE_FLAG | DM_NOFLUSH_FLAG, 0),
+		I(DM_TABLE_LOAD_CMD, 0, table_load,
+		  DM_QUERY_INACTIVE_TABLE_FLAG | DM_READONLY_FLAG, 0),
 		I(DM_TABLE_CLEAR_CMD, IOCTL_FLAGS_NO_PARAMS, table_clear,
-		  DM_QUERY_INACTIVE_TABLE_FLAG),
-		I(DM_TABLE_DEPS_CMD, 0, table_deps, DM_QUERY_INACTIVE_TABLE_FLAG),
+		  DM_QUERY_INACTIVE_TABLE_FLAG, 0),
+		I(DM_TABLE_DEPS_CMD, 0, table_deps, DM_QUERY_INACTIVE_TABLE_FLAG, 0),
 		I(DM_TABLE_STATUS_CMD, 0, table_status,
-		 DM_QUERY_INACTIVE_TABLE_FLAG | DM_STATUS_TABLE_FLAG | DM_NOFLUSH_FLAG),
+		 DM_QUERY_INACTIVE_TABLE_FLAG | DM_STATUS_TABLE_FLAG | DM_NOFLUSH_FLAG, 0),
 
-		I(DM_LIST_VERSIONS_CMD, 0, list_versions, 0),
+		I(DM_LIST_VERSIONS_CMD, 0, list_versions, 0, 0),
 
-		I(DM_TARGET_MSG_CMD, 0, target_message, DM_QUERY_INACTIVE_TABLE_FLAG),
-		I(DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry, 0),
-		I(DM_DEV_ARM_POLL_CMD, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll, 0),
-		I(DM_GET_TARGET_VERSION_CMD, 0, get_target_version, 0),
+		I(DM_TARGET_MSG_CMD, 0, target_message, DM_QUERY_INACTIVE_TABLE_FLAG, 0),
+		I(DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry, 0, 0),
+		I(DM_DEV_ARM_POLL_CMD, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll, 0, 0),
+		I(DM_GET_TARGET_VERSION_CMD, 0, get_target_version, 0, 0),
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
 	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
-	*supported_flags = _ioctls[cmd].supported_flags;
+	*supported_flags = strict ? _ioctls[cmd].strict_flags : _ioctls[cmd].supported_flags;
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
@@ -2260,7 +2263,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	if (cmd == DM_VERSION_CMD)
 		return 0;
 
-	fn = lookup_ioctl(cmd, &ioctl_flags, &supported_flags);
+	fn = lookup_ioctl(cmd, !sloppy_checks(&param_kernel), &ioctl_flags, &supported_flags);
 	if (!fn) {
 		DMERR("dm_ctl_ioctl: unknown command 0x%x", command);
 		return -ENOTTY;
@@ -2480,7 +2483,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 		m = MINOR(huge_decode_dev(dmi->dev));
 
 	/* alloc dm device */
-	r = dm_create(m, &md);
+	r = dm_create(m, &md, false);
 	if (r)
 		return r;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ea1671c39ba131ab2e49b93289d1094cda5cfb25..b7817b4aea52033afeeea9f2b93b9215de682e9c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2281,13 +2281,14 @@ static struct dm_table *__unbind(struct mapped_device *md)
 /*
  * Constructor for a new device.
  */
-int dm_create(int minor, struct mapped_device **result)
+int dm_create(int minor, struct mapped_device **result, bool disable_uevents)
 {
 	struct mapped_device *md;
 
 	md = alloc_dev(minor);
 	if (!md)
 		return -ENXIO;
+	md->disable_uevents = disable_uevents;
 
 	dm_ima_reset_data(md);
 
@@ -3005,6 +3006,8 @@ int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[3] = { NULL, NULL, NULL };
 	char **envpp = envp;
+	if (md->disable_uevents)
+		return 0;
 	if (cookie) {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb0d7b712e2b8bf32d9ba34c54e09e..2be940c2c6f42ed8e13b97ea8b07d0895566f3e2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -461,7 +461,7 @@ void dm_consume_args(struct dm_arg_set *as, unsigned int num_args);
  * DM_ANY_MINOR chooses the next available minor number.
  */
 #define DM_ANY_MINOR (-1)
-int dm_create(int minor, struct mapped_device **md);
+int dm_create(int minor, struct mapped_device **md, bool disable_uevents);
 
 /*
  * Reference counting for md.
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 1d33109aece2ff9854e752066baa96fdf7d85857..b338a4f9a299acda9430995d63fbb490e70c8cd8 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -369,8 +369,16 @@ enum {
 #define DM_BUFFER_FULL_FLAG	(1 << 8) /* Out */
 
 /*
- * This flag is now ignored if DM_VERSION_MAJOR is used, and causes
- * -EINVAL if DM_VERSION_MAJOR_STRICT is used.
+ * This flag is only recognized when DM_VERSION_MAJOR_STRICT is used.
+ * It tells the kernel to not generate any uevents for the newly-created
+ * device.  Using it outside of DM_DEV_CREATE results in -EINVAL.  When
+ * DM_VERSION_MAJOR is used this flag is ignored.
+ */
+#define DM_DISABLE_UEVENTS_FLAG	(1 << 9) /* In */
+
+/*
+ * This flag is now ignored if DM_VERSION_MAJOR is used.  When
+ * DM_VERSION_MAJOR_STRICT is used it is an alias for DM_DISABLE_UEVENT_FLAG.
  */
 #define DM_SKIP_BDGET_FLAG	(1 << 9) /* In */
 
@@ -439,8 +447,6 @@ enum {
 
 /*
  * If DM_VERSION_MAJOR is used, these flags are ignored by the kernel.
- * If DM_VERSION_MAJOR_STRICT is used, these flags are reserved and
- * must be zeroed.
  */
 #define DM_STRICT_ONLY_FLAGS					\
 	(DM_ACTIVE_PRESENT_FLAG | DM_INACTIVE_PRESENT_FLAG |	\
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

