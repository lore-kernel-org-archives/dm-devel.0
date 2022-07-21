Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74645C43334
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jul 2022 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658424145;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ufLeKYS9B1izEYqRJYSlwQ0LySF+WBwZiUn39EcjbGw=;
	b=Ccg4xJZVJn4SGhsfxCF0R5xrmHzz1jgdygp7c4NC7uEGQmEf8+0Y8GgN1LZw+GBvqGnY77
	5kyKWh7Q4oCtBDyJzYP6IzJGHmkJFeP0+mGYjpQn1JfGRvU3UgCe9mNTpjy3t3GZLxfPrY
	IU2dTNkjN5DEB0peNlGdhpS3BfADLyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-OZaIy6rpNViPsF6MH3Es2g-1; Thu, 21 Jul 2022 13:22:16 -0400
X-MC-Unique: OZaIy6rpNViPsF6MH3Es2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93BC2811E84;
	Thu, 21 Jul 2022 17:22:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB5FD403D0E3;
	Thu, 21 Jul 2022 17:22:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 669C71947050;
	Thu, 21 Jul 2022 17:22:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41A081947049
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Jul 2022 17:22:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3417E909FF; Thu, 21 Jul 2022 17:22:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3019218ECB
 for <dm-devel@redhat.com>; Thu, 21 Jul 2022 17:22:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14024801585
 for <dm-devel@redhat.com>; Thu, 21 Jul 2022 17:22:11 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-uINt1h7vPZyOlKkl22AkRw-1; Thu, 21 Jul 2022 13:22:07 -0400
X-MC-Unique: uINt1h7vPZyOlKkl22AkRw-1
Received: by mail-wr1-f42.google.com with SMTP id h8so3231520wrw.1;
 Thu, 21 Jul 2022 10:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=z/ovWtWtbepI7fQCo0pZqHeere6R3qOJLtKrfVoWxU8=;
 b=a/DPWl3TJSPNsLNGDE1Ri2lSKkfKbADssWwo8LbfXHpSocrF9Dqy3JUSdJNBst83Nk
 Tqk09EWWtJz/8MBpmfdIeOAm4fBvodSjOeI68OaEHA8+4djYLCLsOzNI5DD9FogsYIl5
 EagAIOZAenFeCjXzCFpn94ZPNzC2cN3XpoGbznuuZJ8XBdsXv7UwvCIzM5HEesUCie7H
 0LTsKfO6P7tBxwtdQL8gs+UiT1KwXh9EWYF5D5Ktbo9N/LF4zEg+cyTU4ULqaHIxTXXj
 aAxwvsAW1GFQHR6FnfwY/Eyjtvi+HB6dGFx1GS2HfsojvOA9bilqt/vdl1uyc8CmFQJy
 ADXw==
X-Gm-Message-State: AJIora//RPfQXK/kbEsLEbGI10RzwQYdhudXOrXpRfxu9jSkRYDlw/RH
 1WPdmUq7swOOnzds53S1EQ==
X-Google-Smtp-Source: AGRyM1tqFlQC/BKFAWmmAyWXsGYBAR2Fqlf+4pxylFxYb7oliWbuy3aCsziOXaHutnNmuq3miPlOvQ==
X-Received: by 2002:a5d:6b02:0:b0:21e:4c90:f4 with SMTP id
 v2-20020a5d6b02000000b0021e4c9000f4mr6541232wrw.385.1658424125547; 
 Thu, 21 Jul 2022 10:22:05 -0700 (PDT)
Received: from localhost (51.red-81-44-172.dynamicip.rima-tde.net.
 [81.44.172.51]) by smtp.gmail.com with ESMTPSA id
 o8-20020a05600c378800b003a2e7c13a3asm2266834wmr.42.2022.07.21.10.22.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Jul 2022 10:22:04 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 21 Jul 2022 19:22:04 +0200
Message-Id: <20220721172204.14402-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] multipath-tools: remove list of rebranded arrays
 vendors from man page
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It does not provide useful info, and it is incomplete.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c2d34f18..d5506d99 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -315,12 +315,12 @@ accepts the optional prio_arg \fIexclusive_pref_bit\fR.
 .TP
 .I ontap
 (Hardware-dependent)
-Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
+Generate the path priority for NetApp ONTAP class, and rebranded arrays.
 .TP
 .I rdac
 (Hardware-dependent)
 Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp SANtricity
-E/EF Series, and OEM arrays from IBM DELL SGI STK and SUN.
+E/EF Series, and rebranded arrays.
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -496,7 +496,7 @@ Active/Standby mode exclusively.
 .I rdac
 (Hardware-dependent)
 Check the path state for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
-Series, and OEM arrays from IBM DELL SGI STK and SUN.
+Series, and rebranded arrays.
 .TP
 .I directio
 Read the first sector with direct I/O. This checker could cause spurious path
@@ -1568,7 +1568,7 @@ families.
 .I 1 rdac
 (Hardware-dependent)
 Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
-Series, and OEM arrays from IBM DELL SGI STK and SUN.
+Series, and rebranded arrays.
 .TP
 .I 1 hp_sw
 (Hardware-dependent)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

