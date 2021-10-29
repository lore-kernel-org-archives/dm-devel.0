Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE66C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:11:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6696D61130
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6696D61130
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-8lqlKobaPxy842zk_8prXA-1; Fri, 29 Oct 2021 07:11:43 -0400
X-MC-Unique: 8lqlKobaPxy842zk_8prXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DFCB9F943;
	Fri, 29 Oct 2021 11:11:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C56EB60C13;
	Fri, 29 Oct 2021 11:11:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 447491806D03;
	Fri, 29 Oct 2021 11:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19T8EwMC013447 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 04:14:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 56068112131F; Fri, 29 Oct 2021 08:14:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FD631121315
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 08:14:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A8F3899EC1
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 08:14:54 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
	[209.85.221.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-421-7ancoi6vMY2ei5oeGWZnxA-1; Fri, 29 Oct 2021 04:14:50 -0400
X-MC-Unique: 7ancoi6vMY2ei5oeGWZnxA-1
Received: by mail-wr1-f41.google.com with SMTP id m22so15006514wrb.0
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 01:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=8ddftgpK0LDx+G+FjrkBslhvyIqXHl28zfgWlGOCfAA=;
	b=opVyg0slkq9r32R/+ppJ3dM7SBsDeMc6EwSxE2iC1UcKoZf5S3Mahg54exI9f+dSYy
	Ecqj0E1hhuXF9B6fXmF8aWy3nzphQb5YMLMlfqyA0DxTMcpQkKbLM6swbbmRQHBt0QcU
	BFaTPfxcey5IYmfL9kEx4+zjnM9OHs62KECdREoEigfbeZV/dskCMX+3J9zcKcU+8luK
	fP/k/7QhkwqezCDdLHc0/3yWjeSLwmCmZ1MsA2fMnZuxGeeUn53VQZOBJpxSAfLQX1Xp
	wO4al/Sx2WsPUjiJ6GPTta+XJutYoWTQglEw7mbAOkscte1X/eSHaBpmXAJ97Bf0W5mP
	ca+g==
X-Gm-Message-State: AOAM530QpoG/nGhtHhnvG+m6jNNmaEL67TLMZJUbm0x+EjQfGpgOqGZI
	UwfTDJDzjgjf+Z+f6UxHNoIf7A==
X-Google-Smtp-Source: ABdhPJz4KKl/vCIv4EZQxDSYhXgl6hLs1xW5oRUFqmNOfzBiIlxs2qrs7OEPigr3oNUptn2YXM3COQ==
X-Received: by 2002:adf:e387:: with SMTP id e7mr1473005wrm.412.1635495289096; 
	Fri, 29 Oct 2021 01:14:49 -0700 (PDT)
Received: from localhost (5.186.124.144.cgn.fibianet.dk. [5.186.124.144])
	by smtp.gmail.com with ESMTPSA id s3sm8001684wmh.30.2021.10.29.01.14.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 29 Oct 2021 01:14:48 -0700 (PDT)
Date: Fri, 29 Oct 2021 10:14:47 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211029081447.ativv64dofpqq22m@ArmHalley.local>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 29 Oct 2021 07:06:18 -0400
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjkuMTAuMjAyMSAwMDoyMSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+T24gMTAvNy8y
MSAxMTo0OSBQTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gRXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMKPj4KPj4KPj4gT24gMDYuMTAu
MjAyMSAxMDozMywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+Pj4gT24gMTAvNi8yMSAzOjA1IEFN
LCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+Pj4+IEkgYWdyZWUgdGhhdCB0aGUgdG9waWMgaXMg
Y29tcGxleC4gSG93ZXZlciwgd2UgaGF2ZSBub3QgYmVlbiBhYmxlIHRvCj4+Pj4gZmluZCBhIGNs
ZWFyIHBhdGggZm9yd2FyZCBpbiB0aGUgbWFpbGluZyBsaXN0Lgo+Pj4KPj4+IEhtbSAuLi4gcmVh
bGx5PyBBdCBsZWFzdCBNYXJ0aW4gUGV0ZXJzZW4gYW5kIEkgY29uc2lkZXIgZGV2aWNlIG1hcHBl
cgo+Pj4gc3VwcG9ydCBlc3NlbnRpYWwuIEhvdyBhYm91dCBzdGFydGluZyBmcm9tIE1pa3VsYXMn
IHBhdGNoIHNlcmllcyB0aGF0Cj4+PiBzdXBwb3J0cyB0aGUgZGV2aWNlIG1hcHBlcj8gU2VlIGFs
c28KPj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hbHBpbmUuTFJILjIuMDIuMjEwODE3
MTYzMDEyMC4zMDM2M0BmaWxlMDEuaW50cmFuZXQucHJvZC5pbnQucmR1Mi5yZWRoYXQuY29tLwo+
Pj4KPgo+V2hlbiB3ZSBhZGQgYSBuZXcgUkVRX09QX1hYWCB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSBp
dCB3aWxsIHdvcmsgd2l0aAo+ZGV2aWNlIG1hcHBlciwgc28gSSBhZ3JlZSB3aXRoIEJhcnQgYW5k
IE1hcnRpbi4KPgo+U3RhcnRpbmcgd2l0aCBNaWt1bGFzIHBhdGNoZXMgaXMgYSByaWdodCBkaXJl
Y3Rpb24gYXMgb2Ygbm93Li4KPgo+Pgo+PiBUaGFua3MgZm9yIHRoZSBwb2ludGVycy4gV2UgYXJl
IGxvb2tpbmcgaW50byBNaWt1bGFzJyBwYXRjaCAtIEkgYWdyZWUKPj4gdGhhdCBpdCBpcyBhIGdv
b2Qgc3RhcnQuCj4+Cj4+Pj4gV2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgam9pbmluZyB0aGUgY2Fs
bCB0byB0YWxrIHZlcnkgc3BlY2lmaWMgbmV4dAo+Pj4+IHN0ZXBzIHRvIGdldCBhIHBhdGNoc2V0
IHRoYXQgd2UgY2FuIHN0YXJ0IHJldmlld2luZyBpbiBkZXRhaWwuCj4+Pgo+Pj4gSSBjYW4gZG8g
dGhhdC4KPj4KPj4gVGhhbmtzLiBJIHdpbGwgd2FpdCB1bnRpbCBDaGFpdGFueWEncyByZXBseSBv
biBoaXMgcXVlc3Rpb25zLiBXZSB3aWxsCj4+IHN0YXJ0IHN1Z2dlc3Rpbmcgc29tZSBkYXRlcyB0
aGVuLgo+Pgo+Cj5JIHRoaW5rIGF0IHRoaXMgcG9pbnQgd2UgbmVlZCB0byBhdCBsZWFzdCBkZWNp
ZGUgb24gaGF2aW5nIGEgZmlyc3QgY2FsbAo+Zm9jdXNlZCBvbiBob3cgdG8gcHJvY2VlZCBmb3J3
YXJkIHdpdGggTWlrdWxhcyBhcHByb2FjaCAgLi4uCj4KPkphdmllciwgY2FuIHlvdSBwbGVhc2Ug
b3JnYW5pemUgYSBjYWxsIHdpdGggcGVvcGxlIHlvdSBsaXN0ZWQgaW4gdGhpcwo+dGhyZWFkIGVh
cmxpZXIgPwoKSGVyZSB5b3UgaGF2ZSBhIERvb2dsZSBmb3IgZW5kIG9mIG5leHQgd2VlayBhbmQg
dGhlIHdlZWsgYWZ0ZXIgT0NQLgpQbGVhc2UgZmlsbCBpdCBvdXQgdW50aWwgV2VkbmVzZGF5LiBJ
IHdpbGwgc2V0IHVwIGEgY2FsbCB3aXRoIHRoZQpzZWxlY3RlZCBzbG90OgoKICAgICBodHRwczov
L2Rvb2RsZS5jb20vcG9sbC9yMmM4ZHV5M3I4Zzg4djhxP3V0bV9zb3VyY2U9cG9sbCZ1dG1fbWVk
aXVtPWxpbmsKClRoYW5rcywKSmF2aWVyCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs

