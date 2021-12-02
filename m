Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403B5C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:42:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-Tcoi4KxwNcaMs9ZgYIdWow-1; Thu, 02 Dec 2021 07:41:55 -0500
X-MC-Unique: Tcoi4KxwNcaMs9ZgYIdWow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 878E8839A45;
	Thu,  2 Dec 2021 12:41:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 743F65F4E9;
	Thu,  2 Dec 2021 12:41:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 774344BB7C;
	Thu,  2 Dec 2021 12:41:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2Cfgo5015467 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 07:41:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00A18C23DB5; Thu,  2 Dec 2021 12:41:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F05F8C23DB4
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 12:41:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D697E80A0B0
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 12:41:41 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
	[209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-326-YFeumWE3MYqghjoCWild1Q-1; Thu, 02 Dec 2021 07:41:38 -0500
X-MC-Unique: YFeumWE3MYqghjoCWild1Q-1
Received: by mail-wm1-f45.google.com with SMTP id 133so22930650wme.0;
	Thu, 02 Dec 2021 04:41:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=Ml8o+wwwyFHlMctPucoE6N5UNCKVNxWwyUAFeljIl6U=;
	b=HHQlZrRtdsBk6JP4leM5zmEmsMqUhcGAc9m4wM9QRik+ONq5y4T8rwgZ94hV4EsBDz
	RxUFMW8QlUJ7Omelib57/hmy2Rj7YpoIHYlHZNHAjX1dW46oJbxvNwUHJjQbWL62nYNB
	IVkRcp5LzNfxvvmBHefENu6B4kTQJioD0nooHyvxb+NAQJAsiv24/VGPmijlCM76sLlK
	ZiquV0ODFXvAjfJA2JFCI7FKL6pe8dRDObXZ5HrYlE7GMcxC2j2NngBuErmQaxSz6tFN
	KbYka1wyIBlSEXV5G/tig+Ykn8LyjF5uJ91sVovBUYsXnDCv14/mlYynuTGFZdm2hcLq
	EEUg==
X-Gm-Message-State: AOAM532jbJtEsp0ZNauinJRPoyh3CFk8cpclNiD+ILPcsajUbF8QLElG
	U+08JJbdwaQT4UixO0T/5Q==
X-Google-Smtp-Source: ABdhPJzIw0g/OQjQHgpYCL6/RTenPypB1vmehXMHXUnQ/DLSKkCnqYvo1sNr9vR5L3zVCy7pEUgbkw==
X-Received: by 2002:a05:600c:1548:: with SMTP id
	f8mr6093545wmg.67.1638448897108; 
	Thu, 02 Dec 2021 04:41:37 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id o4sm3037716wry.80.2021.12.02.04.41.35
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 02 Dec 2021 04:41:36 -0800 (PST)
Message-ID: <7514be21-8209-f3ab-2d83-4f8639e53458@gmail.com>
Date: Thu, 2 Dec 2021 13:41:34 +0100
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>, ng-eseries-upstream-maintainers@netapp.com
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
	<20211201223518.3775-2-xose.vazquez@gmail.com>
	<dd47410226f48d3fc3851a10a12cb89854e6ac8c.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <dd47410226f48d3fc3851a10a12cb89854e6ac8c.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>, "Schremmer,
	Steven" <Steve.Schremmer@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Subject: Re: [dm-devel] [PATCH resend] multipath-tools: delete duplicate
 RDAC maintainer entries
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
Content-Language: en-GB
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvMi8yMSAwODo1NiwgTWFydGluIFdpbGNrIHdyb3RlOgoKPiAKPiBJJ2QgbGlrZSB0byBo
YXZlIHRoaXMgYWNrZWQgYnkgTmV0YXBwIGJlZm9yZSBtZXJnaW5nIGl0LiBBY3R1YWxseSwgSSdk
Cj4gcHJlZmVyIHRvIGhhdmUgaXQgYWNrZWQgYnkgRnVqaXRzdSBhbmQgTGVub3ZvLCB0b28sIGJ1
dCB3ZSBkb24ndCBoYXZlCj4gY29udGFjdCBhZGRyZXNzZXMgZm9yIHRoZW0sIHNvIGJlIGl0Lgo+
IAo+IE15IOKCrDAuMDI6IEknZCByYXRoZXIgbm90IGhhdmUgdGhpcywgYmVjYXVzZSBpdCdzIG5v
dCBvYnZpb3VzIHRvCj4gZXZlcnlib2R5IHRoYXQgdGhlc2UgYXJyYXlzIGFyZSBhY3R1YWxseSBO
ZXRhcHAgc3lzdGVtcyBhbmQgYXJlIHRodXMKPiBtYWludGFpbmVkIG5vdCBieSB0aGVpciB2ZW5k
b3JzIGJ1dCBOZXRhcHAuCgpUaGVyZSBhcmUgMjUgUkRBQyBhcnJheXMgaW4gaHd0YWJsZSwgb25s
eSB0d28gb2YgdGhlbSh0aG9zZSBpbmNsdWRlZCBpbgp0aGUgcGF0Y2gpIGFuZCB0aGUgTmV0QXBw
IG9uZSBoYXZlIGEgIk1haW50YWluZXIiIGVudHJ5LgpBbmQgdGhleSBjYW4gZWFzaWx5IGlkZW50
aWZpZWQsIC5jaGVja2VyX25hbWUgYW5kIC5wcmlvX25hbWUgYXJlIFJEQUMuCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

