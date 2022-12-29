Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20D9C3DA7A
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645388;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cKIK3K90uob+rCDUIpQUNg3JSrTT+j8ZXFk6iKm5Xyk=;
	b=Q0zvTsAbrcAayHs0r/BDHMdl0QULZI1/Tyfl1U+vXezkoV8xYY/Tmwvdr1OBw6IYv68zHi
	062IADgKMEjdp//hjhfP7IsNJByqfcpJlWWMZKasbt8a5nyXN0MylAzBtXra+U6iMic7Nh
	PxiCdt4LZF5/dytxF36pk3RnSumSUT8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-BIKL6ak7N7yoDEoZZwdhkg-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: BIKL6ak7N7yoDEoZZwdhkg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD3113811F41;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6D1D112132E;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C9A0194706C;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1389C1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6B472026D68; Thu, 29 Dec 2022 08:13:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEFAD2026D4B
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0128811E6E
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:20 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-Mam3GFN-O4GW_1HHXLnnnw-1; Thu, 29 Dec 2022 03:13:16 -0500
X-MC-Unique: Mam3GFN-O4GW_1HHXLnnnw-1
Received: by mail-pl1-f169.google.com with SMTP id 20so4853336plo.3
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/8DbNiGbTyMPWSOnHF8Kc/zLYgsGw2pv5SS5s5v0R+s=;
 b=6SkpRs+1DNJ7YwzlLW7qjwgA+RDRknfd0mI0dhyQZ1qsryJleAtLa7+JL3u39OPLYe
 4w0ilxXNw28niJnfU+k7DmkCYityNjygYaNuZ7QJiOmu1mctQqoXXUycIiMnN8cu2gN5
 vIl9+NGNxtwFynVspCWyFlF8NSbIVr90J82NeOW6uJL7EfWfkUc78ljnG2RNXPhgjQrJ
 1OZ1H4s1Sr9fTKudWhZgAld3qxOv4ma0QKW0Tub5xs9RtybkyM1paFcNvJfrw7WDf13i
 R/ZkBR5Aa+sRnPcK0Lm0ESdX2WlwtO1a0SP1CX8qvCm92mwnNQcWBqQM+zGYQV9kA4Iy
 SSTQ==
X-Gm-Message-State: AFqh2krB5RwQvR16UE9F7lLhy+bgUV4iycWIj018RQDt+bH8CP3iVGyf
 cgKb+fGwGHgjqFpAiq47mkqgtg==
X-Google-Smtp-Source: AMrXdXtgQYYpwQ6pz9x9/465K8tsLdsmt3F7AV27atGdHHls0t4amkRI67RTybj/weosU20glWNaiw==
X-Received: by 2002:a17:903:228a:b0:191:217f:b2ea with SMTP id
 b10-20020a170903228a00b00191217fb2eamr42495271plh.40.1672301595208; 
 Thu, 29 Dec 2022 00:13:15 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:75ff:1277:3d7b:d67a])
 by smtp.gmail.com with ESMTPSA id
 12-20020a170902e9cc00b00192820d00d0sm6496325plk.120.2022.12.29.00.13.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Dec 2022 00:13:14 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 29 Dec 2022 00:12:52 -0800
Message-Id: <20221229081252.452240-8-sarthakkukreti@chromium.org>
In-Reply-To: <20221229081252.452240-1-sarthakkukreti@chromium.org>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: [dm-devel] [PATCH v2 7/7] ext4: Add a per-file provision override
 xattr
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adds a per-file provision override that allows select files to
override the per-mount setting for provisioning blocks on allocation.

This acts as a mechanism to allow mounts using provision to
replicate the current behavior for fallocate() and only preserve
space at the filesystem level.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 fs/ext4/extents.c | 32 ++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h   |  1 +
 2 files changed, 33 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a73f44264fe2..9861115681b3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4428,6 +4428,26 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 	return err;
 }
 
+static int ext4_file_provision_support(struct inode *inode)
+{
+	char provision;
+	int ret =
+		ext4_xattr_get(inode, EXT4_XATTR_INDEX_TRUSTED,
+			       EXT4_XATTR_NAME_PROVISION_POLICY, &provision, 1);
+
+	if (ret < 0)
+		return ret;
+
+	switch (provision) {
+	case 'y':
+		return 1;
+	case 'n':
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 				  ext4_lblk_t len, loff_t new_size,
 				  int flags)
@@ -4440,12 +4460,24 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	struct ext4_map_blocks map;
 	unsigned int credits;
 	loff_t epos;
+	bool provision = false;
+	int file_provision_override = -1;
 
 	/*
 	 * Attempt to provision file blocks if the mount is mounted with
 	 * provision.
 	 */
 	if (test_opt2(inode->i_sb, PROVISION))
+		provision = true;
+
+	/*
+	 * Use file-specific override, if available.
+	 */
+	file_provision_override = ext4_file_provision_support(inode);
+	if (file_provision_override >= 0)
+		provision &= file_provision_override;
+
+	if (provision)
 		flags |= EXT4_GET_BLOCKS_PROVISION;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 824faf0b15a8..69e97f853b0c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -140,6 +140,7 @@ extern const struct xattr_handler ext4_xattr_security_handler;
 extern const struct xattr_handler ext4_xattr_hurd_handler;
 
 #define EXT4_XATTR_NAME_ENCRYPTION_CONTEXT "c"
+#define EXT4_XATTR_NAME_PROVISION_POLICY "provision"
 
 /*
  * The EXT4_STATE_NO_EXPAND is overloaded and used for two purposes.
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

