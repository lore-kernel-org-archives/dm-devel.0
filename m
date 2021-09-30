Return-Path: <SRS0=+DI7=OU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A264BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 30 Sep 2021 16:20:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 12E7B615A2
	for <dm-devel@archiver.kernel.org>; Thu, 30 Sep 2021 16:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12E7B615A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-taITS7eaMfKCiCOXwXTloA-1; Thu, 30 Sep 2021 12:20:51 -0400
X-MC-Unique: taITS7eaMfKCiCOXwXTloA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B218A184216C;
	Thu, 30 Sep 2021 16:20:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64C762C175;
	Thu, 30 Sep 2021 16:20:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E160C1803B30;
	Thu, 30 Sep 2021 16:20:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18UGKLn6018885 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 30 Sep 2021 12:20:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB0D720A8C07; Thu, 30 Sep 2021 16:20:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A36D420A8ACA
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 16:20:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F898811E85
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 16:20:12 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
	[209.85.216.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-62-tY8xG22sORizt3gJVmKtRw-1; Thu, 30 Sep 2021 12:20:10 -0400
X-MC-Unique: tY8xG22sORizt3gJVmKtRw-1
Received: by mail-pj1-f41.google.com with SMTP id
	d4-20020a17090ad98400b0019ece228690so7142492pjv.5; 
	Thu, 30 Sep 2021 09:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=yG1/o+/DnMH77sK/4dZhI1SBFsLkmeMylzKyExyvyVo=;
	b=GN93tTa/O8aMGjbU24V6fZs/09bt/YG8/tLIwhLZj6Vz8SC08CLcfnRJ51TDPvVgWH
	FXHAzmuEmh+KChxmKjpTfxPavKprkuVdumQ6+YXlorfqteve5ApBNWSLdO4sIuLduDhk
	wNMcmvnChGBBk4LryCqpQASTJ5wLFTquvu9Ajy9ggQmGpKVzxalKhVqU7IUa9VAvqCJo
	mlm4siV0Ep3rrg4v+SVFnADWV4Wmt0lXXmufXa0VOpEXD4yIudlnJwyKqChuZlYqjYVr
	P1WQzSXMRB+OGzHcNl2AGQ/aS28S4bDY1EtXC5hOldZqWGcUhi9OnoGWkrg+WysbpjYW
	1mzw==
X-Gm-Message-State: AOAM530y6BhFu7IksHn5OSmh/kxnAIp97TvS2RDZ77LcbDPWd5ooMOR6
	HEIV6t2cdKwAMRNcBzX20jI=
X-Google-Smtp-Source: ABdhPJzaCOnFZETcMKaHwCPxzFz713M2S082LglpsjtX0j5t65Ek+coBFDcqzxklnkgshMeKu30lrQ==
X-Received: by 2002:a17:90b:104d:: with SMTP id
	gq13mr14201836pjb.101.1633018808562; 
	Thu, 30 Sep 2021 09:20:08 -0700 (PDT)
Received: from [10.254.204.66] (50-242-106-94-static.hfc.comcastbusiness.net.
	[50.242.106.94]) by smtp.gmail.com with ESMTPSA id
	t15sm3663221pgi.80.2021.09.30.09.20.05
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 30 Sep 2021 09:20:07 -0700 (PDT)
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
Date: Thu, 30 Sep 2021 09:20:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
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
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS8yOC8yMSAxMjoxMyBQTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPiBTaW5jZSB3ZSBh
cmUgbm90IGdvaW5nIHRvIGJlIGFibGUgdG8gdGFsayBhYm91dCB0aGlzIGF0IExTRi9NTSwgYSBm
ZXcgb2YKPiB1cyB0aG91Z2h0IGFib3V0IGhvbGRpbmcgYSBkZWRpY2F0ZWQgdmlydHVhbCBkaXNj
dXNzaW9uIGFib3V0IENvcHkKPiBPZmZsb2FkLiBJIGJlbGlldmUgd2UgY2FuIHVzZSBDaGFpdGFu
eWEncyB0aHJlYWQgYXMgYSBzdGFydC4gR2l2ZW4gdGhlCj4gY3VycmVudCBzdGF0ZSBvZiB0aGUg
Y3VycmVudCBwYXRjaGVzLCBJIHdvdWxkIHByb3Bvc2UgdGhhdCB3ZSBmb2N1cyBvbgo+IHRoZSBu
ZXh0IHN0ZXAgdG8gZ2V0IHRoZSBtaW5pbWFsIHBhdGNoc2V0IHRoYXQgY2FuIGdvIHVwc3RyZWFt
IHNvIHRoYXQKPiB3ZSBjYW4gYnVpbGQgZnJvbSB0aGVyZS4KPiAKPiBCZWZvcmUgd2UgdHJ5IHRv
IGZpbmQgYSBkYXRlIGFuZCBhIHRpbWUgdGhhdCBmaXRzIG1vc3Qgb2YgdXMsIHdobyB3b3VsZAo+
IGJlIGludGVyZXN0ZWQgaW4gcGFydGljaXBhdGluZz8KCkdpdmVuIHRoZSB0ZWNobmljYWwgY29t
cGxleGl0eSBvZiB0aGlzIHRvcGljIGFuZCBhbHNvIHRoYXQgdGhlIHBlb3BsZSB3aG8gYXJlCmlu
dGVyZXN0ZWQgbGl2ZSBpbiBtdWx0aXBsZSB0aW1lIHpvbmVzLCBJIHByZWZlciBlbWFpbCB0byBk
aXNjdXNzIHRoZSB0ZWNobmljYWwKYXNwZWN0cyBvZiB0aGlzIHdvcmsuIE15IGF0dGVtcHQgdG8g
c3VtbWFyaXplIGhvdyB0byBpbXBsZW1lbnQgY29weSBvZmZsb2FkaW5nCmlzIGF2YWlsYWJsZSBo
ZXJlOiBodHRwczovL2dpdGh1Yi5jb20vYnZhbmFzc2NoZS9saW51eC1rZXJuZWwtY29weS1vZmZs
b2FkLgpGZWVkYmFjayBvbiB0aGlzIHRleHQgaXMgd2VsY29tZS4KClRoYW5rcywKCkJhcnQuCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

