Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5FFC7EE24
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480086;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hvLcsstDiy2YOpBcWTDdwbH7NTpxvVPeABrclD7boWE=;
	b=g7hzy7l7JpOWMm6hOZka5oDLTf9wK0icowFwU5zMEdT2BY7XduEsjNlosGPcrD8Phsg1ED
	bhAoAIdEsUmPsOI1o3HkveM3M3z5UM0PmMC5HkS+wll7DIZ6qhXPx32JbqR/2eCqOtjNhk
	APGkgZENviR0CgG/Jyn8faEQJ+cvucE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526--zIPxobOMimSZ7JX0Ock3w-1; Tue, 30 May 2023 16:54:44 -0400
X-MC-Unique: -zIPxobOMimSZ7JX0Ock3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00CE1811E85;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E080040D1B60;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BAC9194F277;
	Tue, 30 May 2023 20:54:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0956E1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0F50420AA; Tue, 30 May 2023 20:40:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CF7421D3
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9869238107EF
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:53 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-D0uLt3nAPNGWkvu3OXLWKg-1; Tue, 30 May 2023 16:40:52 -0400
X-MC-Unique: D0uLt3nAPNGWkvu3OXLWKg-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.west.internal (Postfix) with ESMTP id CFA993200344;
 Tue, 30 May 2023 16:31:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute5.internal (MEProxy); Tue, 30 May 2023 16:31:58 -0400
X-ME-Sender: <xms:PV12ZIVF4XPa7vIfh95cZrTywjn8VZD4NyR1CTBdML7zBZS2OQ0OCg>
 <xme:PV12ZMkz8m_rPSIhxv_rMuxKobm9-zYx_FK6lU8br5aJB3NAksWPvPvzYNZSVPKrL
 8tt4fS9m_JgihU>
X-ME-Received: <xmr:PV12ZMb6UkdCD8vCp-byAOWnuf9MDLOmpVrsZt8uOG51rWcoEfGitxi_avKN2K4JLBHhcokC1KE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedvne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:PV12ZHUWDhP7wugXqpeBlzXBDQksonnz5X2q5g8xJmd9-TvmhVV3cQ>
 <xmx:PV12ZClyTCts34PN4tBkcQghm4JynLn6RCdKMJJB878uR0m85eus7w>
 <xmx:PV12ZMcN0GoE-Y5NGUx_8gB2vH4zuAqBUwFoamms2hdSBsmZ6pnCrA>
 <xmx:PV12ZEVCZBpjvTGgpOo1SkHD80xPv9iLaEtVk4dz0Sca4ECSJjxkrA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:56 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:08 -0400
Message-Id: <20230530203116.2008-9-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 08/16] device-mapper: Allow userspace to
 provide expected diskseq
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
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This can be used to avoid race conditions in which a device is destroyed
and recreated with the same major/minor, name, or UUID.  diskseqs are
only honored if strict parameter checking is on, to avoid any risk of
breaking old userspace.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c         | 48 ++++++++++++++++++++++++++++-------
 include/uapi/linux/dm-ioctl.h | 33 +++++++++++++++++++++---
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index cf752e72ef6a2d8f8230e5bd6d1a6dc817a4f597..01cdf57bcafbf7f3e1b8304eec28792c6b24642d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -871,6 +871,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 		}
 		dm_put_live_table(md, srcu_idx);
 	}
+
+	if (param->version[0] >= DM_VERSION_MAJOR_STRICT)
+		dm_set_diskseq(param, disk->diskseq);
 }
 
 static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_size)
@@ -889,6 +892,8 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		return r;
 
+	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
+
 	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
 	if (r) {
 		dm_put(md);
@@ -909,6 +914,7 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 {
 	struct hash_cell *hc = NULL;
+	static_assert(offsetof(struct dm_ioctl, diskseq_high) == offsetof(struct dm_ioctl, data) + 3);
 
 	if (*param->uuid) {
 		if (*param->name || param->dev) {
@@ -937,6 +943,27 @@ static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 	} else
 		return NULL;
 
+	if (param->version[0] >= DM_VERSION_MAJOR_STRICT) {
+		u64 expected_diskseq = dm_get_diskseq(param);
+		u64 diskseq;
+		struct mapped_device *md = hc->md;
+
+		if (WARN_ON_ONCE(md->disk == NULL))
+			return NULL;
+		diskseq = md->disk->diskseq;
+		if (WARN_ON_ONCE(diskseq == 0))
+			return NULL;
+		if (expected_diskseq != 0) {
+			if (expected_diskseq != diskseq) {
+				DMERR("Diskseq mismatch: expected %llu actual %llu",
+				      expected_diskseq, diskseq);
+				return NULL;
+			}
+		} else {
+			dm_set_diskseq(param, diskseq);
+		}
+	}
+
 	/*
 	 * Sneakily write in both the name and the uuid
 	 * while we have the cell.
@@ -2088,7 +2115,6 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
 			   uint32_t ioctl_flags, uint32_t supported_flags)
 {
 	static_assert(__same_type(param->flags, supported_flags));
-	u64 zero = 0;
 
 	if (cmd == DM_DEV_CREATE_CMD) {
 		if (!*param->name) {
@@ -2112,14 +2138,24 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
 		return 0;
 	}
 
+	if (param->data_size < sizeof(struct dm_ioctl)) {
+		DMERR("Entire struct dm_ioctl (size %zu) must be valid, but only %u was valid",
+		      sizeof(struct dm_ioctl), param->data_size);
+		return -EINVAL;
+	}
+
 	/* Check that strings are terminated */
 	if (!no_non_nul_after_nul(param->name, DM_NAME_LEN, cmd, "Name") ||
 	    !no_non_nul_after_nul(param->uuid, DM_UUID_LEN, cmd, "UUID")) {
 		return -EINVAL;
 	}
 
-	if (memcmp(param->data, &zero, sizeof(param->data)) != 0) {
-		DMERR("second padding field not zeroed in strict mode (cmd %u)", cmd);
+	/*
+	 * This also reads the NUL terminator of the UUID, but that has already been
+	 * checked to be zero by no_non_nul_after_nul().
+	 */
+	if (*(const u32 *)((const char *)param + sizeof(struct dm_ioctl) - 8) != 0) {
+		DMERR("padding field not zeroed in strict mode (cmd %u)", cmd);
 		return -EINVAL;
 	}
 
@@ -2129,12 +2165,6 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
 		return -EINVAL;
 	}
 
-	if (param->padding) {
-		DMERR("padding not zeroed in strict mode (got %u, cmd %u)",
-		      param->padding, cmd);
-		return -EINVAL;
-	}
-
 	if (param->open_count != 0) {
 		DMERR("open_count not zeroed in strict mode (got %d, cmd %u)",
 		      param->open_count, cmd);
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 81103e1dcdac3015204e9c05d73037191e965d59..5647b218f24b626f5c1cefe8bec18dc04373c3d0 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -136,16 +136,43 @@ struct dm_ioctl {
 	 * For output, the ioctls return the event number, not the cookie.
 	 */
 	__u32 event_nr;      	/* in/out */
-	__u32 padding;
+
+	union {
+		/* valid if DM_VERSION_MAJOR is used */
+		__u32 padding;		/* padding */
+		/* valid if DM_VERSION_MAJOR_STRICT is used */
+		__u32 diskseq_low;	/* in/out: low 4 bytes of the diskseq */
+	};
 
 	__u64 dev;		/* in/out */
 
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
 				 * the block device */
-	char data[7];		/* padding or data */
+	union {
+		/* valid if DM_VERSION_MAJOR is used */
+		char data[7];	/* padding or data */
+		/* valid if DM_VERSION_MAJOR_STRICT is used */
+		struct {
+			char _padding[3];	/* padding */
+			__u32 diskseq_high;	/* in/out: high 4 bytes of the diskseq */
+		} __attribute__((packed));
+	};
 };
 
+__attribute__((always_inline)) static inline __u64
+dm_get_diskseq(const struct dm_ioctl *_i)
+{
+	return (__u64)_i->diskseq_high << 32 | (__u64)_i->diskseq_low;
+}
+
+__attribute__((always_inline)) static inline void
+dm_set_diskseq(struct dm_ioctl *_i, __u64 _diskseq)
+{
+	_i->diskseq_low = (__u32)(_diskseq & 0xFFFFFFFFU);
+	_i->diskseq_high = (__u32)(_diskseq >> 32);
+}
+
 /*
  * Used to specify tables.  These structures appear after the
  * dm_ioctl.
@@ -402,6 +429,6 @@ enum {
  * If DM_VERSION_MAJOR_STRICT is used, these flags are reserved and
  * must be zeroed.
  */
-#define DM_STRICT_ONLY_FLAGS ((__u32)0xFFF00004)
+#define DM_STRICT_ONLY_FLAGS ((__u32)(~((1UL << 19) - 1) | 1 << 9 | 1 << 7))
 
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

