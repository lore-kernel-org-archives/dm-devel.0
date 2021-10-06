Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2948CC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:49:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A1EF610EA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5A1EF610EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-D9FFRo1uN_Cwjy8QWCB5jQ-1; Wed, 06 Oct 2021 13:49:03 -0400
X-MC-Unique: D9FFRo1uN_Cwjy8QWCB5jQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B3B18414A0;
	Wed,  6 Oct 2021 17:48:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6962F9AA2F;
	Wed,  6 Oct 2021 17:48:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E325E1806D01;
	Wed,  6 Oct 2021 17:48:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196HXskB007117 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 13:33:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C11322166B47; Wed,  6 Oct 2021 17:33:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A26222167D65
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 17:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94E661066564
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 17:33:46 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-ioCNDYBtNrS89qc-CP4fdg-1; Wed, 06 Oct 2021 13:33:37 -0400
X-MC-Unique: ioCNDYBtNrS89qc-CP4fdg-1
Received: by mail-pj1-f46.google.com with SMTP id
	k23-20020a17090a591700b001976d2db364so2941762pji.2; 
	Wed, 06 Oct 2021 10:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=b0udGD6yPXFIVJbeGvfLIzJwm0LmddvqozG4vFBfvTE=;
	b=GKiV3xQVDu3I7y6atlwgudxp7BUXKfNXNEQzca8HMEgRzUK5IlO49KMWsARJw8MmDW
	s562o1XyM8Grnt6pn/70s5RRrdfq138WyTkVOq2h1dVvCjNMjaMnCcTlGgUSonrP2DFP
	hHZDBY7+L6qYMd3hnNd122hBa9WDOVG472MaT5oC9+CYiMZfe/9u9AeMKjX2X21PSrTZ
	J1oK4VGiYyiIUmMIKMAWYSRsDgDgGqiuZl5H2slRxJMUJBtKC3hDsZmh8dTGLKEP0zi7
	8vdri7BeVrHDYXJJcBAMMXsqgbiwjE7zkCBCx5oa0PX55zhR8p3Xn/XgUSqR6CD0SAeB
	nA2A==
X-Gm-Message-State: AOAM531x8bKpFNTiGTdzf4s4U9NUUWSQulAan8QFnnSy+2ylH2NNYXNc
	gQrOSceVcCDSqZYD0WR2+5TCKV5Ter0=
X-Google-Smtp-Source: ABdhPJww5vn0LIX4yaBzMmvw+4zhd9LR+fC9FR6Wt5P5+rHOabghLfn4cJcj1iGMZ4cyBz8ApUN3GQ==
X-Received: by 2002:a17:902:e801:b0:13f:255:9db5 with SMTP id
	u1-20020a170902e80100b0013f02559db5mr1022291plg.23.1633541615361;
	Wed, 06 Oct 2021 10:33:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:201:6ad6:c36f:fdfb:9e74])
	by smtp.gmail.com with ESMTPSA id
	c15sm9368288pfp.39.2021.10.06.10.33.33
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 06 Oct 2021 10:33:34 -0700 (PDT)
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
Date: Wed, 6 Oct 2021 10:33:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvNi8yMSAzOjA1IEFNLCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+IEkgYWdyZWUgdGhh
dCB0aGUgdG9waWMgaXMgY29tcGxleC4gSG93ZXZlciwgd2UgaGF2ZSBub3QgYmVlbiBhYmxlIHRv
Cj4gZmluZCBhIGNsZWFyIHBhdGggZm9yd2FyZCBpbiB0aGUgbWFpbGluZyBsaXN0LgoKSG1tIC4u
LiByZWFsbHk/IEF0IGxlYXN0IE1hcnRpbiBQZXRlcnNlbiBhbmQgSSBjb25zaWRlciBkZXZpY2Ug
bWFwcGVyIApzdXBwb3J0IGVzc2VudGlhbC4gSG93IGFib3V0IHN0YXJ0aW5nIGZyb20gTWlrdWxh
cycgcGF0Y2ggc2VyaWVzIHRoYXQgCnN1cHBvcnRzIHRoZSBkZXZpY2UgbWFwcGVyPyBTZWUgYWxz
byAKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2FscGluZS5MUkguMi4wMi4yMTA4MTcxNjMw
MTIwLjMwMzYzQGZpbGUwMS5pbnRyYW5ldC5wcm9kLmludC5yZHUyLnJlZGhhdC5jb20vCgo+IFdo
YXQgZG8geW91IHRoaW5rIGFib3V0IGpvaW5pbmcgdGhlIGNhbGwgdG8gdGFsayB2ZXJ5IHNwZWNp
ZmljIG5leHQKPiBzdGVwcyB0byBnZXQgYSBwYXRjaHNldCB0aGF0IHdlIGNhbiBzdGFydCByZXZp
ZXdpbmcgaW4gZGV0YWlsLgoKSSBjYW4gZG8gdGhhdC4KClRoYW5rcywKCkJhcnQuCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

