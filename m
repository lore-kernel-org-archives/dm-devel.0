Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA07C77B73
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685905609;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o4SND51TKg/OiBln1BaygatkoslApX+ISwTlTOqyarM=;
	b=NJCj9AFkQ7a0Fj3IrF7VvAufDxNuED6cIEkOIQrxBHOcDRQm5vj6cCtFXx7ozNRwjiYIcY
	dJ2A4PTGX4p7qd2AB6clMMEyJJ4urz+ArxHQovmVtn4163h+BD3L6AdfHSMfxLJDKWQnsB
	4X+eXPyzVpSwH1gV8+lpI96P8N6o1IY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-XsWa-VI-OuOj5S-lq-dcxQ-1; Sun, 04 Jun 2023 15:06:45 -0400
X-MC-Unique: XsWa-VI-OuOj5S-lq-dcxQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D3221C05136;
	Sun,  4 Jun 2023 19:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01291400F45;
	Sun,  4 Jun 2023 19:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C56EA19465A0;
	Sun,  4 Jun 2023 19:06:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 999081946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 19:06:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89BE62026D6A; Sun,  4 Jun 2023 19:06:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 818712026D49
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 661033806060
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:41 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-cnKjOTngPgW-Xg7jS5C8Kw-1; Sun, 04 Jun 2023 15:06:37 -0400
X-MC-Unique: cnKjOTngPgW-Xg7jS5C8Kw-1
Received: by mail-pl1-f174.google.com with SMTP id
 d9443c01a7336-1b026657a6fso35643845ad.0; 
 Sun, 04 Jun 2023 12:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685905596; x=1688497596;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=GG3Hy7n4oCrePrc6XsNght2qZ/b76zbKsk6sMW+iZsQ=;
 b=OMF34ytpU0mlL5wZPacgEU8cLGOM82skkI9POHIPyo0YTgCxiEgqzGXr9HxNQ9AQJ/
 O8kM2Z618xlBcMWaizJ+T5Ez+qO0npMysTjN0n8yMOH5F/ywXEfwTupjPrhbPTEEpA3T
 FYa3B92o/l13Yn2UdrZZ4gNDquSl8lk/qZgyr9OgIHUm91kHS1H0ggH2QMiHEi50mukT
 0V9TAnzR3+r2nW/VS0OJX8NvOP53xqHr99/ty528ueWaBiPuK2VgRIf6mdMm0Viwq+Yl
 UMKN38OG782IUkdjTbiSoJun4vxz8icNR7UMeZtaUA/wAAUOdooINc/O7TMhvmGHRtAq
 MJJA==
X-Gm-Message-State: AC+VfDwTK8/A89tjq2AATn/1DXDpMpL3L40uvIgP/Bzd5jWzflPuR+f1
 jQeb2X8JkiGa29jwG425+Kc=
X-Google-Smtp-Source: ACHHUZ5pvsmZXxQML0usbfB4Onm1WEYm3om0LDI/OSvyhEtbDdsMhpgRo4e5YYhi9zts2K9eeziOxg==
X-Received: by 2002:a17:902:6b0a:b0:1ac:5717:fd5 with SMTP id
 o10-20020a1709026b0a00b001ac57170fd5mr6023028plk.60.1685905596187; 
 Sun, 04 Jun 2023 12:06:36 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b001a6ed2d0ef8sm4979072plx.273.2023.06.04.12.06.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 12:06:35 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 12:06:01 -0700
Message-Id: <20230604190604.4800-2-eatnumber1@gmail.com>
In-Reply-To: <20230604190604.4800-1-eatnumber1@gmail.com>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v3 1/4] Fix minor grammatical error in
 dm-integrity.rst.
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
Cc: Russell Harmon <eatnumber1@gmail.com>, dm-devel@redhat.com,
 mpatocka@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

"where dm-integrity uses bitmap" becomes "where dm-integrity uses a
bitmap"

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 8db172efa272..b2a698e955a3 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -25,7 +25,7 @@ mode it calculates and verifies the integrity tag internally. In this
 mode, the dm-integrity target can be used to detect silent data
 corruption on the disk or in the I/O path.
 
-There's an alternate mode of operation where dm-integrity uses bitmap
+There's an alternate mode of operation where dm-integrity uses a bitmap
 instead of a journal. If a bit in the bitmap is 1, the corresponding
 region's data and integrity tags are not synchronized - if the machine
 crashes, the unsynchronized regions will be recalculated. The bitmap mode
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

