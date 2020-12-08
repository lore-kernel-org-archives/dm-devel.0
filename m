Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D381DC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 452AD23433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 452AD23433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-KRNYZLdTOa6AIt1OrHXeCw-1; Wed, 09 Dec 2020 04:57:25 -0500
X-MC-Unique: KRNYZLdTOa6AIt1OrHXeCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFBB7809DC3;
	Wed,  9 Dec 2020 09:57:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A25915C23E;
	Wed,  9 Dec 2020 09:57:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AE9F5002F;
	Wed,  9 Dec 2020 09:57:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8CMwpM010677 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 07:22:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 422E194626; Tue,  8 Dec 2020 12:22:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BCF79465B
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:22:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33A14811E76
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:22:55 +0000 (UTC)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
	[209.85.208.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-166-RiKUhBliM2C5GvD5Vx9f_A-1; Tue, 08 Dec 2020 07:22:51 -0500
X-MC-Unique: RiKUhBliM2C5GvD5Vx9f_A-1
Received: by mail-ed1-f66.google.com with SMTP id p22so5304753edu.11
	for <dm-devel@redhat.com>; Tue, 08 Dec 2020 04:22:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=mimyofEa+0whU409Dhp0a+YV5b97sukKj8gfG9Rbmic=;
	b=DOXHZXr99jm0jKPJkvGkAn4HQ0q5hn+3hFdFuXDMJuAIkaU/WHyzCAi6jBHB7h598N
	HkFgTUO6htAApTYvFgpKTuZCoESymti4pO0q9LbSxfbsOOhGBi+gJKPyykiLot3BvEy2
	8TBfZUxxld8rAxDiqtQB7wPOaLbRNBGrXsA+qnmcuRdnGTxDDwtrch4cZ0x5dy7FDbCe
	U1HFC/JIt476/8Ahpa0H37yULXx3jkzZWpV8jdHa2sy8uLNpc+FzUhkwm7PTxhQaoH9R
	iVW1CoYMSjNELiGpA5IWwLjzvHOLkz63JRhgZeMoWXF7yXL0YrlGjC8sOdT+k5FbAe6i
	/1mw==
X-Gm-Message-State: AOAM533BHzOtFrAWaIds4z0xK8JWEq7GQt/NmVSdTZVLgGtp2wOXxsRA
	02NqoS1MTC8wahcjONH/Ot35gg==
X-Google-Smtp-Source: ABdhPJwDxIoRMy+9VbYFQ3igoSIhbhtPBIxA8vjX9L86uM4LXFP5Wttpcb3/4YB/UuHFCIPdaYrkmA==
X-Received: by 2002:a50:ccdb:: with SMTP id b27mr18839271edj.20.1607430169696; 
	Tue, 08 Dec 2020 04:22:49 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	x15sm16783915edj.91.2020.12.08.04.22.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 08 Dec 2020 04:22:49 -0800 (PST)
Date: Tue, 8 Dec 2020 13:22:48 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20201208122248.utv7pqthmmn6uwv6@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDguMTIuMjAyMCAwODo0MCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+T24gMDcvMTIv
MjAyMCAyMDoyNywgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gR29vZCBwb2ludC4gV2UgY2Fu
IHNoYXJlIHNvbWUgcGVyZm9ybWFuY2UgZGF0YSBvbiBob3cgU2ltcGxlIENvcHkgc2NhbGVzCj4+
IGluIHRlcm1zIG9mIGJ3IC8gbGF0ZW5jeSBhbmQgdGhlIENQVSB1c2FnZS4gRG8geW91IGhhdmUg
YW55dGhpbmcgZWxzZSBpbgo+PiBtaW5kPwo+Pgo+Cj5XaXRoIGFuIGVtdWxhdGlvbiBpbiB0aGUg
a2VybmVsLCB3ZSBjb3VsZCBtYWtlIHRoZSB1c2QgImJhY2tlbmQiCj5pbXBsZW1lbnRhdGlvbiBj
b25maWd1cmFibGUuIFNvIGlmIHRoZSBlbXVsYXRpb24gaXMgZmFzdGVyLCB1c2VycyBjYW4gc2Vs
ZWN0Cj50aGUgZW11bGF0aW9uLCBpZiB0aGUgZGV2aWNlIGlzIGZhc3RlciB0aGVuIHRoZSBkZXZp
Y2UuCj4KPktpbmQgb2Ygd2hhdCB0aGUgY3J5cHRvIGFuZCByYWlkIGNvZGUgZG8gYXMgd2VsbC4K
Ckdvb2QgaWRlYS4gQXJlIHlvdSB0aGlua2luZyBvZiBhIHN5c2ZzIGVudHJ5IHRvIHNlbGVjdCB0
aGUgYmFja2VuZD8KPgo+SSdtIHJlYWxseSBpbnRlcmVzdGVkIGluIHRoaXMgd29yaywgYXMgQlRS
RlMgcmVsb2NhdGlvbi9iYWxhbmNlIHdpbGwgaGF2ZQo+cG90ZW50aWFsIGJlbmVmaXRzLCBidXQg
d2UgbmVlZCB0byBnZXQgaXQgcmlnaHQuCgpBZ3JlZS4gV2Ugd2lsbCBwb3N0IGEgVjMgd2l0aCBl
bXVsYXRpb24gYW5kIGFkZHJlc3Npbmcgb3RoZXIgY29tbWVudHMuCldlIGNhbiB0YWtlIGl0IGZy
b20gdGhlcmUuIElmIHlvdSBoYXZlIGNvbW1lbnRzIG9uIFYyLCBwbGVhc2Ugc2VuZCB0aGVtCm91
ciB3YXkgYW5kIHdlIHdpbGwgdGFrZSB0aGVtIGluLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

