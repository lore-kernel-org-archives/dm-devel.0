Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91AB3C2BA12
	for <dm-devel@archiver.kernel.org>; Sat, 16 Sep 2023 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694888430;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jpFSq73hkglt5HJgnq2SlJqaVK/MaFKE3AErI8d/Mos=;
	b=enLbPyTDJOcuK4HrIBS5X/L+ETR/0RObYXG1e5akFqIrbA7PwJv0uBEJRKGUsgvPVHAdA7
	0jXeJIGSGj1S4VIRBpTAnxPti417EgpfEMj7J1XPBB04VYluAwnB60ewGsbUyxlhoBlHVI
	kNYu+BmJ+Z29SbiBfKTsaAOSKMuLhPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-o4BcAonJNuSk2ahX0M88GQ-1; Sat, 16 Sep 2023 14:20:27 -0400
X-MC-Unique: o4BcAonJNuSk2ahX0M88GQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D52441875070;
	Sat, 16 Sep 2023 18:20:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0C4840C6EA8;
	Sat, 16 Sep 2023 18:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 537E21946588;
	Sat, 16 Sep 2023 18:20:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2CC6A1946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 16 Sep 2023 18:20:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBF3B200BFE3; Sat, 16 Sep 2023 18:20:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B52E1200BC7F
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 18:20:21 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97CE18039C8
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 18:20:21 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com
 (smtp-relay-internal-0.canonical.com [185.125.188.122]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-VPZ1e-MxP3m_L8Fz1kq5sw-1; Sat,
 16 Sep 2023 14:20:18 -0400
X-MC-Unique: VPZ1e-MxP3m_L8Fz1kq5sw-1
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3616F3F0F7
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 18:12:35 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id
 af79cd13be357-76ef50e2513so423291985a.3
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 11:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694887954; x=1695492754;
 h=content-transfer-encoding:mime-version:user-agent:message-id:date
 :subject:to:from:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=4KdA8FmCI8DO5eicyTYRk3j840IZZVfnYyCNfjr/XkQ=;
 b=ly5pBRW2OHJNg/TkaqqjxxVJ2omf9v29VaYoNj1tEfJV1pSsn4cXiTTuguHA0NonCK
 qXTW+Ufi62ZuXc6WltzBYeCgoJoj4IFzYoGy/TxtIMdwfwKHcTAnh8LY5a21tY1iUVZh
 wiSx6zaU9HcJRAyhd1XQDrZ4Wyi/uErOlai64BrHoXatGiyfczJMdWw0zBu1VpsqMO3v
 GKVAo6CDG1WB36dkoNfXNkK9dETyU7+hQ/jkJygaFPPVmbXLns3iGwICU/2VxHVu6pZh
 6+RIWudeNYi2GpcAEA+WUWeU9ISO+hqRMTmlhUzs4NAwLAhG4J3jdTTQmxuD00zgaseQ
 Mg1w==
X-Gm-Message-State: AOJu0YwZTgHAeR1o5Yxwts66/dOfIf5aZzOnwJR67jR1wvbWcah5E/r1
 99sY1DsDVQ8ImCRS2DZPEDbFozM3QDiGGGwpgp5bq0rJIYwjAmD3DxvALugVoTSqR+xyp0Xiv0/
 AYvSF0KLRytrIoAtgFMZvKo57oULulq8L39dxUA==
X-Received: by 2002:a05:620a:28cd:b0:773:a83f:3392 with SMTP id
 l13-20020a05620a28cd00b00773a83f3392mr6789718qkp.32.1694887954282; 
 Sat, 16 Sep 2023 11:12:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAn4PvkEBptJWGxGXRi0imKlaB3B5dNZwnpJxmH2VVA23vOKW+wlx3qcuQjDNYpB2jmCZl9w==
X-Received: by 2002:a05:620a:28cd:b0:773:a83f:3392 with SMTP id
 l13-20020a05620a28cd00b00773a83f3392mr6789707qkp.32.1694887953992; 
 Sat, 16 Sep 2023 11:12:33 -0700 (PDT)
Received: from localhost ([103.191.186.138]) by smtp.gmail.com with ESMTPSA id
 a26-20020a05620a16da00b0076db1caab16sm2033452qkn.22.2023.09.16.11.12.32
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 16 Sep 2023 11:12:33 -0700 (PDT)
From: Sergio Durigan Junior <sergio.durigan@canonical.com>
To: dm-devel@redhat.com
X-URL: http://blog.sergiodj.net
Date: Sat, 16 Sep 2023 14:12:29 -0400
Message-ID: <874jjuq96a.fsf@canonical.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] Selectively start multipathd
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: canonical.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpJIGhhdmUgYmVlbiB3b3JraW5nIG9uIHRoaXMgcHJvb2Ygb2YgY29uY2VwdCB0byBz
ZWUgaWYgaXQncyBmZWFzaWJsZSB0bwpzdGFydCBtdWx0aXBhdGhkIG9ubHkgb24gc2l0dWF0aW9u
cyB3aGVyZSB0aGVyZSBpcyBhY3R1YWxseSBhIG11bHRpcGF0aApkZXZpY2UgcHJlc2VudCBpbiB0
aGUgc3lzdGVtLgoKVGhlIG1vdGl2YXRpb24gYmVoaW5kIHRoaXMgaW52ZXN0aWdhdGlvbiBpcyB0
aGUgZmFjdCB0aGF0LCBpbiBVYnVudHUKKGFuZCBEZWJpYW4pLCB3ZSdyZSBhbHdheXMgc3RhcnRp
bmcgbXVsdGlwYXRoZCBpcnJlc3BlY3RpdmUgb2Ygd2hldGhlcgp0aGVyZSdzIGEgbXVsdGlwYXRo
IGRldmljZSB0byBiZSBhY3RlZCB1cG9uLiAgVGhpcyBpcyBPSyB3aGVuIHRoZSB1c2VyCm5lZWRz
IHRoZSBzZXJ2aWNlLCBidXQgY2FuIGJlY29tZSBwcm9ibGVtYXRpYyBpZiB3ZSdyZSBkZWFsaW5n
IHdpdGgKZS5nLiBhIGxpbWl0ZWQtcmVzb3VyY2Ugc3lzdGVtIGxpa2UgYSBSYXNwYmVycnkgUGku
CgpNeSBpbml0aWFsIChhbmQgc29tZXdoYXQgbmHDr3ZlKSBwbGFuIHdhcyB0byB1c2Ugc3lzdGVt
ZCBhbmQgZG8gc29tZXRoaW5nCmxpa2UgQ29uZGl0aW9uUGF0aEV4aXN0c0dsb2IgdG8gY2hlY2sg
aWYgdGhlcmUncyBhbiAibXBhdGhYIiBkZXZpY2UKcHJlc2VudCwgYnV0IG9idmlvdXNseSB0aGlz
IGlzIG5vdCBwb3NzaWJsZSBiZWNhdXNlIHRoZSBkZXZpY2UgbmFtZSBjYW4KYmUgZWFzaWx5IGNo
YW5nZWQuCgpJJ20gbm93IHRoaW5raW5nIHdoZXRoZXIgaXQgaXMgcG9zc2libGUgdG8gaW1wbGVt
ZW50IHNvbWUgdWRldiBydWxlIGZvcgp0aGF0LiAgTWF5YmUgZXh0ZW5kIHRoZSBleGlzdGluZyA2
MC1tdWx0aXBhdGgucnVsZXMgZmlsZSwgZXZlbiB0aG91Z2ggaXQKc2VlbXMgdG8gYmUgZXhlY3V0
ZWQgd2hlbiB0aGUgZGV2aWNlIGlzIG5vdCB5ZXQgcmVhZHkgKGFzIGlzIHN1Z2dlc3RlZApieSB0
aGUgIkVOVntTWVNURU1EX1JFQURZfT0wIiBzZWN0aW9ucykuCgpNeSBtdWx0aXBhdGgtZnUgaXMg
bGFja2luZyBhIGJpdCBhcyBjYW4gYmUgc2VlbiBhYm92ZSwgc28gSSB3b3VsZCByZWFsbHkKYXBw
cmVjaWF0ZSBzb21lIGV4cGVydCBhZHZpY2Uvb3BpbmlvbiBoZXJlLiAgSSB0cmllZCBmaW5kaW5n
IHJlbGF0ZWQKZGlzY3Vzc2lvbnMgaW4gdGhlIG1haWxpbmcgbGlzdCBidXQgY291bGRuJ3Qgc2Vl
IGFueXRoaW5nIHByb21pc2luZwp0aGVyZS4KClRoYW5rIHlvdSwKCi0tIApTZXJnaW8KR1BHIGtl
eSBJRDogRTkyRiBEMEIzIDZCMTQgRjFGNCBEOEUwICBFQjJGIDEwNkQgQTFDOCBDM0NCIEJGMTQK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

