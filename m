Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D339DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 18:02:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 618D561A02
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 18:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 618D561A02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-q05za0BzNW6HFFaT0DGOpw-1; Tue, 16 Nov 2021 13:02:32 -0500
X-MC-Unique: q05za0BzNW6HFFaT0DGOpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A6E8102CC4E;
	Tue, 16 Nov 2021 18:02:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2348960BD8;
	Tue, 16 Nov 2021 18:02:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C529181A1D0;
	Tue, 16 Nov 2021 18:02:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGHxopa026940 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 12:59:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 29A9251E3; Tue, 16 Nov 2021 17:59:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2038251E1
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 17:59:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF7B7811E81
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 17:59:45 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-52-Z2W_GoAYPOyKpLkC6x3Bgg-1; Tue, 16 Nov 2021 12:59:42 -0500
X-MC-Unique: Z2W_GoAYPOyKpLkC6x3Bgg-1
Received: by mail-pg1-f169.google.com with SMTP id r5so12414701pgi.6;
	Tue, 16 Nov 2021 09:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=HMNPM/fgk1MNRXov4s8Yb+E4mhC1XJHGgm4p3VUdnQM=;
	b=pkycJ5/GDdM/jmnj1GkL4bzoyn1/gxUsJ5GTbc3kXfA8Mumz/19J8+duFPr59TMi8D
	UQ4fw6j9xl6iIgF4w1gQ4hZGwEvOglknlPPpTxxoADtwzMtAlnCaFpLqACevKF/k3ti9
	iEVd7TQDnUH5lZGUY2YTMOYDol2ovjOUlQdBA7aGyUNCDgAOSfmMkGUnMNRzYw2iXA9k
	IKfGcO8ivDnwbEYlegwVLk8c0eCN6ukiq08zriO4z4tKCOyaCtvIeYxKdp2rzN12lTro
	Fwb6sv9m7hoLVxyWGDq9zOpmysl3UqDkT6cYQWKs2gA13flNnNXub+522w5XjvjaG/Cn
	8owg==
X-Gm-Message-State: AOAM533AbMi5mLRcoJWkBDL9go4Db2GCiaWBIFNfSlkdV01NjDbawI89
	QZixzAHoqPCkdOHdEaUtZ8c=
X-Google-Smtp-Source: ABdhPJzQD9bdY0VMmDxiCswmvq2I7y2fm9Zu6J87Vg5yOKJcwCnM9HD6kc+dZh6uUa9ezmqsxHqBag==
X-Received: by 2002:a63:b241:: with SMTP id t1mr604217pgo.154.1637085580607;
	Tue, 16 Nov 2021 09:59:40 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
	([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
	by smtp.gmail.com with ESMTPSA id
	v16sm15096386pgo.71.2021.11.16.09.59.38
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 16 Nov 2021 09:59:39 -0800 (PST)
Message-ID: <ab4ec640-9a89-ea25-fe68-85bae2ae5d8d@acm.org>
Date: Tue, 16 Nov 2021 09:59:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<20211029081447.ativv64dofpqq22m@ArmHalley.local>
	<20211103192700.clqzvvillfnml2nu@mpHalley-2>
	<20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjEgMDU6NDMsIEphdmllciBHb256w6FsZXogd3JvdGU6Cj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgLSBIZXJlLCB3ZSBuZWVkIGNvcHkgZW11bGF0aW9uIHRvIHN1cHBvcnQgZW5j
cnlwdGlvbiAKPiB3aXRob3V0IGRlYWxpbmcgd2l0aCBIVyBpc3N1ZXMgYW5kIGdhcmJhZ2UKCkhp
IEphdmllciwKClRoYW5rcyB2ZXJ5IG11Y2ggZm9yIGhhdmluZyB0YWtlbiBub3RlcyBhbmQgYWxz
byBmb3IgaGF2aW5nIHNoYXJlZCAKdGhlc2UuIFJlZ2FyZGluZyB0aGUgYWJvdmUgY29tbWVudCwg
YWZ0ZXIgdGhlIG1lZXRpbmcgSSBsZWFybmVkIHRoYXQgdGhlIAphYm92ZSBpcyBub3QgY29ycmVj
dC4gRW5jcnlwdGlvbiBpbiBBbmRyb2lkIGlzIExCQSBpbmRlcGVuZGVudCBhbmQgaGVuY2UgCml0
IHNob3VsZCBiZSBwb3NzaWJsZSB0byBvZmZsb2FkIEYyRlMgZ2FyYmFnZSBjb2xsZWN0aW9uIGlu
IEFuZHJvaWQgb25jZSAKdGhlIChVRlMpIHN0b3JhZ2UgY29udHJvbGxlciBzdXBwb3J0cyB0aGlz
LgoKRm9yIHRoZSBnZW5lcmFsIGNhc2UsIEkgcHJvcG9zZSB0byBsZXQgdGhlIGRtLWNyeXB0IGRy
aXZlciBkZWNpZGUgCndoZXRoZXIgb3Igbm90IHRvIG9mZmxvYWQgZGF0YSBjb3B5aW5nIHNpbmNl
IHRoYXQgZHJpdmVyIGtub3dzIHdoZXRoZXIgCm9yIG5vdCBkYXRhIGNvcHlpbmcgY2FuIGJlIG9m
ZmxvYWRlZC4KClRoYW5rcywKCkJhcnQuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs

