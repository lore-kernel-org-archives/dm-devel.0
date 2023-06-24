Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E37EEB64DC
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jun 2023 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687648229;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XOsyiyr4HPUvu6D1l3oIHaQNDzEhKeHnbkwjjbJv+O0=;
	b=V5jx5p+MdQYYXwdVSKiJ+K+bJXUCb2WvuHgtP8xThTgADU2b1tScS1l1ujWZ/0eoiCn17t
	pVgbkiuMvdmvXGxUQx5+owFqE4bnxruAiAOtHZ6Ty1HewXIVGjW3ASziDCL25Age4j7F6z
	JKtx32GtoxEe1j1SHozR5aGyxMkkivw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-W7nb21nDOjOdtzTKf8Zdcw-1; Sat, 24 Jun 2023 19:10:13 -0400
X-MC-Unique: W7nb21nDOjOdtzTKf8Zdcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2B3F800969;
	Sat, 24 Jun 2023 23:10:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0676207B2BD;
	Sat, 24 Jun 2023 23:10:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAA791946589;
	Sat, 24 Jun 2023 23:10:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8349D1946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 23:10:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73192207B2C3; Sat, 24 Jun 2023 23:10:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AC00207B2BC
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B7F98CC209
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:05 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-4IIIryjRPH-BcN3wWp6sVQ-1; Sat, 24 Jun 2023 19:10:03 -0400
X-MC-Unique: 4IIIryjRPH-BcN3wWp6sVQ-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.west.internal (Postfix) with ESMTP id DF02D32004AE;
 Sat, 24 Jun 2023 19:10:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Sat, 24 Jun 2023 19:10:02 -0400
X-ME-Sender: <xms:yXeXZBiRsmlhSJ-cGuCRucqK2VZIK8_2d7S1Qk8ayR4lqjkPnLHKdw>
 <xme:yXeXZGBzeUlGE9ryziWR4rm209PlPwRIRvDtgStkvSoZ9EcuS_99vjLRzvSks_ZUh
 MeVytveAfczB4Y>
X-ME-Received: <xmr:yXeXZBG4Pvo_w3HxlaFoQnpwvpSgGv7r3lSAI-1Ymi-1wf3aSHjuSxA9DpKruNv4NP4R8-SkvHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeegkedgudekucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:yXeXZGQRo5h7ubzCdHvBBNmnBKnt1lcwtn13z61P0MMZZgLNjGZ1yw>
 <xmx:yXeXZOwDgnvN97Onk1ZOrQjg-qKfstBq4Cq0tvLmF6AzAmbWBkWpNw>
 <xmx:yXeXZM5PWCxy3HVl7-WZtcTW4RN5J7X1cyhidkL4GTCmcwNX0lesyQ>
 <xmx:yXeXZJ8iGY7wy65Ks7_ZAzv8_IXnMjOuCBDOwqnblWGfKGYN9VpYTQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Jun 2023 19:10:00 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat, 24 Jun 2023 19:09:45 -0400
Message-ID: <20230624230950.2272-3-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 drivers/md/dm-ioctl.c         | 41 +++++++++++++++++++++++++++++------
 include/uapi/linux/dm-ioctl.h | 31 ++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e7693479c0cd974ddde69b3b1c4c67abc2ae3ad6..7abaeec33f1884d4588e8563fb02e9ea1a6782c8 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -878,6 +878,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 		}
 		dm_put_live_table(md, srcu_idx);
 	}
+
+	if (param->version[0] >= DM_VERSION_MAJOR_STRICT)
+		dm_set_diskseq(param, disk->diskseq);
 }
 
 static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_size)
@@ -918,6 +921,9 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 {
 	struct hash_cell *hc = NULL;
+	static_assert(offsetof(struct dm_ioctl, diskseq_high) ==
+		      offsetof(struct dm_ioctl, data) + 3,
+		      "diskseq_high field misplaced");
 
 	if (*param->uuid) {
 		if (*param->name || param->dev) {
@@ -946,6 +952,27 @@ static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
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
@@ -2139,6 +2166,12 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
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
 	    !no_non_nul_after_nul(param->uuid, DM_UUID_LEN, cmd, "UUID"))
@@ -2148,7 +2181,7 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
 	 * This also checks the last byte of the UUID field, but that was
 	 * checked to be zero above.
 	 */
-	if (*(const u64 *)((const char *)param + (sizeof(*param) - 8)) != 0) {
+	if (*(const u32 *)((const char *)param + (sizeof(*param) - 8)) != 0) {
 		DMERR("second padding field not zeroed in strict mode (cmd %u)", cmd);
 		return -EINVAL;
 	}
@@ -2159,12 +2192,6 @@ static int validate_params(uint cmd, struct dm_ioctl *param,
 		return -EINVAL;
 	}
 
-	if (param->padding != 0) {
-		DMERR("padding not zeroed in strict mode (got %u, cmd %u)",
-		      param->padding, cmd);
-		return -EINVAL;
-	}
-
 	if (param->open_count != 0) {
 		DMERR("open_count not zeroed in strict mode (got %d, cmd %u)",
 		      param->open_count, cmd);
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 62bfdc95ebccb2f1c20c24496a449fe3e2a76113..1d33109aece2ff9854e752066baa96fdf7d85857 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -146,16 +146,43 @@ struct dm_ioctl {
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
-	char data[7];		/* padding or data, must be zero in strict mode */
+	union {
+		/* valid if DM_VERSION_MAJOR is used */
+		char data[7];	/* padding or data */
+		/* valid if DM_VERSION_MAJOR_STRICT is used */
+		struct {
+			char _padding[3];	/* padding, must be zeroed */
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
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

