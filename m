Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7C1CD54B9
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666970;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0NKbRDPhKaH+OS0ZJPVsKPt+PVvMFc/wKWGuLUqeBZ0=;
	b=arKxaC3jdh8vFiQz+xO1+4bggzIt2GJT9XR5FLa8VPkDxYXk/Pj7P16ITAjPIgeujribIW
	wCoijeYbUIiKg/1zwTJ4SXQsuBDC5THskJ/sQMlbxStal5J+KW+jsDT9+OeezcHSY8Pq5y
	sDgonfeEfvyZ121CcDOJwKn04l2qEno=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-z6DTHOOHPn-0raF4-6x0kA-1; Mon, 25 Sep 2023 14:36:07 -0400
X-MC-Unique: z6DTHOOHPn-0raF4-6x0kA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AE538039D1;
	Mon, 25 Sep 2023 18:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5694410EE6C9;
	Mon, 25 Sep 2023 18:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 684AA19466EC;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA583194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 06:35:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7938640C6E77; Mon, 25 Sep 2023 06:35:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70C4140C6EA8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:35:58 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52B103C100A0
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:35:58 +0000 (UTC)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-Qzfo570zPiyQajFAFGbjdg-1; Mon, 25 Sep 2023 02:35:56 -0400
X-MC-Unique: Qzfo570zPiyQajFAFGbjdg-1
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-59c240e637aso111505717b3.3
 for <dm-devel@redhat.com>; Sun, 24 Sep 2023 23:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695623755; x=1696228555;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=bcrp0ZXERhmGEwBm/uzVnD0KZhCDXIgRvCKxEA2CEAk=;
 b=jlA85NPKhqcbQQZMfAscoqOgOYDkmSO3lcr0tcQ3ELOTr7wB8q0vcuKHfX7yr7lvjN
 3ZdHCCJYaOFXe1DSAXqcn5hARA4juKDqQqMBPsIF8WvdOeDejtfBvL0G+HyZUGQqy4/L
 XGvPUY7BiUJWk457b9o4RVe5mdoqIf9bOc8YU/nE3OkDFVQS8afPpdVdFzz/125tBvuj
 Dhu2g4svgLS+kXkDzDWp4ClYakFIGmtkF+uifJpfBm6glSb9HmRsFnNIXZQphJChZ9Rb
 UJLfjWskfP2Ks6sdRRuACNsgRFMGp+VexC3O2eOJtYnJbbssIq7wlf3e4wpi6lnLbkwa
 sYwQ==
X-Gm-Message-State: AOJu0Yw8bNCI9siQAIa9dVVCd7Xr4Aa7MRyqVq8loo0tcSIZXLm7zq2f
 lkI6DFcX26r9zwjgNmYzn86cn7eKm3S1pcYQmA==
X-Google-Smtp-Source: AGHT+IEL+v1AKm/ankIjajUpkORjZ9CG55V363ptxL+fCbeQnS97/LMJgSUav90kcBtnIjOjc2USO1BqtT7+Ykf+5g==
X-Received: from jstitt-linux1.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a81:ac17:0:b0:59b:ec33:ec70 with SMTP
 id k23-20020a81ac17000000b0059bec33ec70mr62785ywh.6.1695623755612; Sun, 24
 Sep 2023 23:35:55 -0700 (PDT)
Date: Mon, 25 Sep 2023 06:35:54 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEkqEWUC/x3MQQqDQAwAwK9Izg3olqL1K9LDNkk1B7dLIqKIf
 3fxOJc5wMVUHPrqAJNVXf+poHlUQFNMo6ByMYQ6POt3eKEvlijvyKarmOPMyDOS7XlBQo5tw13
 77YgJypFNfrrd//A5zwsvv404bwAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519;
 pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695623754; l=1489;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=JzUgrhuHr9AIb+fIgjCoX4OAuDxhGR+xHWRbaTpyl7I=;
 b=sT93N+bGfSIOi1sfnFt85uF+GI0tMjBiB+kioUutRn1Sju1ssa2QNCZUqxcrTzj+gGFqgTzPt
 +W7ks6UvmCLDpC5diuhueOkl7nJyKmMWRREAquuJd6gWCqbGMqbJZEE
Message-ID: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
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
Subject: [dm-devel] [PATCH] dm crypt: replace open-coded kmemdup_nul
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: google.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

kzalloc() followed by strncpy() on an expected NUL-terminated string is
just kmemdup_nul(). Let's simplify this code (while also dropping a
deprecated strncpy() call [1]).

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
Similar-to: https://lore.kernel.org/all/20230925-strncpy-drivers-hwmon-acpi_power_meter-c-v4-1-3bac7534f10f@google.com/
---
 drivers/md/dm-crypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f2662c21a6df..8a03b3590733 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2858,10 +2858,9 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 	if (!start || !end || ++start > end)
 		return -EINVAL;
 
-	mac_alg = kzalloc(end - start + 1, GFP_KERNEL);
+	mac_alg = kmemdup_nul(start, end - start, GFP_KERNEL);
 	if (!mac_alg)
 		return -ENOMEM;
-	strncpy(mac_alg, start, end - start);
 
 	mac = crypto_alloc_ahash(mac_alg, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	kfree(mac_alg);

---
base-commit: 6465e260f48790807eef06b583b38ca9789b6072
change-id: 20230925-strncpy-drivers-md-dm-crypt-c-da71d87b8cdc

Best regards,
--
Justin Stitt <justinstitt@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

