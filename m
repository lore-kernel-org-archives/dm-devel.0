Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784DEC6FA86
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 07:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662622378;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sE+DA+M4vDbUhrkyspMkg0Buag1WBfCvwv3uAg07BDM=;
	b=Me6hG6Fo/BjGNV1ntU1c4WAbIpHpVFZWDJcSVDlBp1epBEnXLglVgUpLB4M7vrPScyipbY
	spYimtGqVh+tc3kDBBALJokzBpqlNFLYiXwvxCZQn5tguHE4EEShbtRQUiJn7hMfYf4uq0
	Yka9Yx0kD2btenE0i33LxOC4Hmh5Z1Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-iKCKaOq0PNe67R-itj3_Yw-1; Thu, 08 Sep 2022 03:32:54 -0400
X-MC-Unique: iKCKaOq0PNe67R-itj3_Yw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44890381078E;
	Thu,  8 Sep 2022 07:32:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86D082026D64;
	Thu,  8 Sep 2022 07:32:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54B361946A49;
	Thu,  8 Sep 2022 07:32:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AD311946A40
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Sep 2022 20:31:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B89040D2830; Wed,  7 Sep 2022 20:31:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87B3E40D282E
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 20:31:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E2C180231E
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 20:31:06 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-dkWx0RxxOg2yYZI-3dkb_Q-1; Wed, 07 Sep 2022 16:31:04 -0400
X-MC-Unique: dkWx0RxxOg2yYZI-3dkb_Q-1
Received: by mail-pj1-f47.google.com with SMTP id o4so15649199pjp.4
 for <dm-devel@redhat.com>; Wed, 07 Sep 2022 13:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=6pTFRiLK72lDLdL/CFtwCq6GJd3SSyre7C8utHPxd+4=;
 b=A9qAbfl1kDymmU6kjNQobx3jIGFo7iut3uXf7/MhfeMJJA77f7aY6sL8c2mc6WR855
 OADnEpGD6bUqb1lSnTSnUidyIz3PEhbT7ay28h6jOHps6u7Yd3JxT8AqRKO8aN7Icqdz
 1rN0WFKwJVSjACebiC/w0Mr246UoPANv2zg0MuhSsVkrwVxfutza7tIFYCGochW5zA/T
 l/7pkGz92NPMB3iVamL7NGiFw7A/2fKFxqRoqHFW6qheeX6BH6vWUxXb8qvzrqbKIeMA
 eaIbFbyKlGcaUTqXgszizLEZStpdhyfp+yokkzxpT6bseTXkeRlF1Z5RLLazr3uzcGvg
 jnQw==
X-Gm-Message-State: ACgBeo3wuRE7CK3yXpfziJ0zOzRvU40h0dkBaqqjuIBeOcgY8Z7nzEKe
 LCfXgLctPBGmGtdjfdPQnKrNew==
X-Google-Smtp-Source: AA6agR4Jj+aDoQUpu0UnfmMWUM+18y8TybSFaxZUO1YTlB7aUNe4vRMzcskBpJQXeKKRvJ290Hr/3w==
X-Received: by 2002:a17:90a:aa87:b0:200:68d8:17b8 with SMTP id
 l7-20020a17090aaa8700b0020068d817b8mr313448pjq.110.1662582663653; 
 Wed, 07 Sep 2022 13:31:03 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:7731:4d19:a7d1:20d])
 by smtp.gmail.com with UTF8SMTPSA id
 ik20-20020a170902ab1400b001769e7062c0sm8955667plb.249.2022.09.07.13.31.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 07 Sep 2022 13:31:03 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>
Date: Wed,  7 Sep 2022 13:30:58 -0700
Message-Id: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 08 Sep 2022 07:32:48 +0000
Subject: [dm-devel] [PATCH] dm: verity-loadpin: Only trust verity targets
 with enforcement
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>,
 linux-security-module@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Verity targets can be configured to ignore corrupted data blocks.
LoadPin must only trust verity targets that are configured to
perform some kind of enforcement when data corruption is detected,
like returning an error, restarting the system or triggering a
panic.

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

 drivers/md/dm-verity-loadpin.c |  8 ++++++++
 drivers/md/dm-verity-target.c  | 16 ++++++++++++++++
 drivers/md/dm-verity.h         |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 387ec43aef72..4f78cc55c251 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -14,6 +14,7 @@ LIST_HEAD(dm_verity_loadpin_trusted_root_digests);
 
 static bool is_trusted_verity_target(struct dm_target *ti)
 {
+	int verity_mode;
 	u8 *root_digest;
 	unsigned int digest_size;
 	struct dm_verity_loadpin_trusted_root_digest *trd;
@@ -22,6 +23,13 @@ static bool is_trusted_verity_target(struct dm_target *ti)
 	if (!dm_is_verity_target(ti))
 		return false;
 
+	verity_mode = dm_verity_get_mode(ti);
+
+	if ((verity_mode != DM_VERITY_MODE_EIO) &&
+	    (verity_mode != DM_VERITY_MODE_RESTART) &&
+	    (verity_mode != DM_VERITY_MODE_PANIC))
+		return false;
+
 	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
 		return false;
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 94b6cb599db4..8a00cc42e498 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1446,6 +1446,22 @@ bool dm_is_verity_target(struct dm_target *ti)
 	return ti->type->module == THIS_MODULE;
 }
 
+/*
+ * Get the verity mode (error behavior) of a verity target.
+ *
+ * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
+ * target.
+ */
+int dm_verity_get_mode(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+
+	if (!dm_is_verity_target(ti))
+		return -EINVAL;
+
+	return v->mode;
+}
+
 /*
  * Get the root digest of a verity target.
  *
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 45455de1b4bc..98f306ec6a33 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -134,6 +134,7 @@ extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
 extern bool dm_is_verity_target(struct dm_target *ti);
+extern int dm_verity_get_mode(struct dm_target *ti);
 extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
 				     unsigned int *digest_size);
 
-- 
2.37.2.789.g6183377224-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

