Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECADCD54B9
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666977;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Xb/Tgpw5lQXwancYd+/tgtRsRHQ2COCrka423MXikZM=;
	b=IprL4IQIkPJCbqDCpmVgeBB+pQrJHkOPLZGH5oDVZjqMkrUDZJT5Iz06kGu9YF4RJiCOUo
	5pgIh5lT60qEy8qd31x/tI1klHbeyUyCAqTSvQtIPqeeW4qK2Oy8I4c5uSag6j6UYtWASJ
	65ab9fCu6AnpsdJQYov/xuqz9wNhcpo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-BnbDrdObPYis-Sw6qpJAyw-1; Mon, 25 Sep 2023 14:36:13 -0400
X-MC-Unique: BnbDrdObPYis-Sw6qpJAyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E6FE802D35;
	Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 099F051E3;
	Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F8C71946A46;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B68C194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 07:06:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82B7940C6E76; Mon, 25 Sep 2023 07:06:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B85640C6EA8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 07:06:09 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B1B485A5BF
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 07:06:09 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-y-Q-8iccPyKL48b0vrxBkw-1; Mon, 25 Sep 2023 03:06:06 -0400
X-MC-Unique: y-Q-8iccPyKL48b0vrxBkw-1
Received: by mail-yb1-f202.google.com with SMTP id
 3f1490d57ef6-d81646fcf3eso8856430276.0
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 00:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695625566; x=1696230366;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=qo6OQpCE04pWWcsadpkT68s/JdHKPH3Fz0vzZ7bj3RM=;
 b=sXEaQ6ObuS64uJP3+d9snx3xUQ7HrpArjw73xhjs8T71GUhYgF7cMRD6TVA5oUY87u
 HSOLFgAWGvEjNZ+p5bm1FCXOgAa78EMIphP2rbYC0O+mKu2WZ/Zkph2kfBHB2X7Tdzvs
 ofcf+G/2DckjvIxDNELj7ZAj0IEgxcHT8kxDQQbWV657p4qs1CT8AQrY7RKUN986Eotz
 1qT36I9A5pLI5JZYF1QQ8X1YtHMzrqDiR7opO/euN0mtkHBmnIi2iZAvWaonivTuq+BM
 L4lIMsny8oOcizLMMB85FAuPEJIhdFDCoiH+D5G9a9sql6X3pVPLIZoANO1qhzptcPuc
 b1FA==
X-Gm-Message-State: AOJu0YwztbD9ETe/R8mDPR4D9AlfG17XxDVL7ocxiDcrskKsoB2Jnfbl
 ECA0XE21lt+nd5hJNsRg1hgkRDZcZqW2y2QGzQ==
X-Google-Smtp-Source: AGHT+IFL6RcLEbqF4P22oc8KJthtgJZ9I4gjnelF8DLVDruqhPbX4JycAc0dVu2g6PwkxJz9KG5Vnb8BbiVa784GOQ==
X-Received: from jstitt-linux1.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:abac:0:b0:d7a:c85c:725b with SMTP
 id v41-20020a25abac000000b00d7ac85c725bmr50744ybi.7.1695625565925; Mon, 25
 Sep 2023 00:06:05 -0700 (PDT)
Date: Mon, 25 Sep 2023 07:06:03 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFoxEWUC/x3NwQ6CMAyA4VchPdsEhwvMVzEe5lqwiYylRaIhv
 LuLx//y/TsYq7DBtdlBeROTJdc4nxpIz5gnRqHa4FrXtcF5tFVzKl8klY3VcCakGV/LhO9KWYm
 J8RGNMeHge98HCkN3GaGCRXmUz392ux/HD7dkJu58AAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519;
 pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695625564; l=1779;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=/oJWFABMzt7p+74DCkUM9oNwgT1wgj/iJtocYZ9umPE=;
 b=aJltci5reHJ/m8Bl/fua5gmnn3LHr/vrCoxC6FkKpLlZloqYPwsgN7m+WzQ/bTCl2oTwryUfE
 4vAxdwy5r4MB2/Vog4MR9HvDyl+0FGAW4WZIsC/HKj48oacyV+kqUry
Message-ID: <20230925-strncpy-drivers-md-dm-log-userspace-base-c-v1-1-030d7bcf1004@google.com>
From: Justin Stitt <justinstitt@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 25 Sep 2023 18:36:03 +0000
Subject: [dm-devel] [PATCH] dm log userspace: replace deprecated strncpy
 with strscpy
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
Cc: Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
 Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: google.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

`strncpy` is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

`lc` is already zero-allocated:
|       lc = kzalloc(sizeof(*lc), GFP_KERNEL);
... as such, any future NUL-padding is superfluous.

A suitable replacement is `strscpy` [2] due to the fact that it
guarantees NUL-termination on the destination buffer without
unnecessarily NUL-padding.

Let's also go with the more idiomatic `dest, src, sizeof(dest)` pattern
for destination buffers that the compiler can calculate the size for.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 drivers/md/dm-log-userspace-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 5aace6ee6d47..7e4f27e86150 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -224,7 +224,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 
 	lc->usr_argc = argc;
 
-	strncpy(lc->uuid, argv[0], DM_UUID_LEN);
+	strscpy(lc->uuid, argv[0], sizeof(lc->uuid));
 	argc--;
 	argv++;
 	spin_lock_init(&lc->flush_lock);

---
base-commit: 6465e260f48790807eef06b583b38ca9789b6072
change-id: 20230925-strncpy-drivers-md-dm-log-userspace-base-c-857579d9834f

Best regards,
--
Justin Stitt <justinstitt@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

