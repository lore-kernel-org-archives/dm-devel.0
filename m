Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC89C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 22:37:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-305-c84ACSTSPz6Sxg6S-BYb2w-1; Wed, 01 Dec 2021 17:37:09 -0500
X-MC-Unique: c84ACSTSPz6Sxg6S-BYb2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74EC01023F4E;
	Wed,  1 Dec 2021 22:37:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51D615D6BA;
	Wed,  1 Dec 2021 22:37:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28D9F1809C89;
	Wed,  1 Dec 2021 22:37:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1MZXm9013771 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 17:35:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2450F2026D60; Wed,  1 Dec 2021 22:35:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9742026D67
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 088F9181E066
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:30 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
	[209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-191-nMrjmW6mOYCKBWZaHabf0Q-1; Wed, 01 Dec 2021 17:35:26 -0500
X-MC-Unique: nMrjmW6mOYCKBWZaHabf0Q-1
Received: by mail-wr1-f44.google.com with SMTP id i5so55543004wrb.2;
	Wed, 01 Dec 2021 14:35:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=uK4PzeK/5E4tloYhmpv28yHQkJOmGhi2bG/rPQo732I=;
	b=65D8ihlpBkmtaviMw5jDdUw7xkHEHO8Jm1Zy4b9ttkDBSONNArbFxTTeUcL2EkJCqt
	/Pu2yYz2uhuxwe08AfvarVsdYrrjKuNPRRiZXemes/hdQuWwjY7b74aNV5Gz3+Xz4GWF
	s6XWgUI9JJcg1UwIP/7t4SWlSh1/rqtW40wFnwrzu30Of1/i5qpx2o/fXiTRuHJ0yHlq
	SbrEOqPboIBRbfpcpSp2G/Jr5byoUtPxDOHVZ5eUZbML/JykMKci9TMVViITUNtIQl9A
	MbBjvoHTWledKTwv6X92jbfrhpLzV55fr1ghWA1xQnC0wygW94vgHeOXnv/Ifzps/Vfi
	vFGw==
X-Gm-Message-State: AOAM531U9R1dfeZQRaWACTSLKrzC5+nDagkbiyfxXySRaBtsz5XVJUmF
	7/mWl+DGCYYElWFqmYjaqw==
X-Google-Smtp-Source: ABdhPJzf3jrk3CkIf23PGKGEP8NI8O0Q6ITM2+d2RBbaag8U8jgYb1quKsRr/HJLnT4RV3H41HYiTw==
X-Received: by 2002:a05:6000:2a3:: with SMTP id
	l3mr9866975wry.415.1638398124913; 
	Wed, 01 Dec 2021 14:35:24 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id n1sm483239wmq.6.2021.12.01.14.35.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 01 Dec 2021 14:35:24 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  1 Dec 2021 23:35:17 +0100
Message-Id: <20211201223518.3775-3-xose.vazquez@gmail.com>
In-Reply-To: <20211201223518.3775-1-xose.vazquez@gmail.com>
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH resend] multipath-tools: dm-devel is a closed ml
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just for subscribers

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index b15c265f..2d3d1023 100644
--- a/README.md
+++ b/README.md
@@ -77,7 +77,7 @@ Maintainer
 ==========
 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
-Device-mapper development mailing list <dm-devel@redhat.com>
+Device-mapper development mailing list (subscribers-only) <dm-devel@redhat.com>
 
 
 Licence
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

