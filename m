Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6660EC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F298261139
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F298261139
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-jeHsW2O7OKu3nESaxszMQA-1; Thu, 04 Nov 2021 03:22:56 -0400
X-MC-Unique: jeHsW2O7OKu3nESaxszMQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72D1518125C6;
	Thu,  4 Nov 2021 07:22:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0379B71775;
	Thu,  4 Nov 2021 07:22:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D3591806D04;
	Thu,  4 Nov 2021 07:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3JR5ev011693 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 15:27:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2D52740CFD10; Wed,  3 Nov 2021 19:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2796340CFD07
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 19:27:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D6578007B1
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 19:27:05 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
	[209.85.221.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-341-3-bj-R0dNu2aBDk2R2piqA-1; Wed, 03 Nov 2021 15:27:03 -0400
X-MC-Unique: 3-bj-R0dNu2aBDk2R2piqA-1
Received: by mail-wr1-f41.google.com with SMTP id d24so5239112wra.0
	for <dm-devel@redhat.com>; Wed, 03 Nov 2021 12:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=n9eZm4ZLjJ18S7/RZOpREFC5R9Pnj2s1MfiRIP09vP4=;
	b=2l4bVHcQuLTXPWgIiDHLTrsuDuljmsdDdL5gzSWa2SPj6i0Tff2yLhSR/lR+4zUu3F
	v3b1HxZ5+Ic/TehA2nRwLAZvJ2gt4BX0kCh5ZaOJhsdyy95I5tLxtn842OEfxpCUGmzp
	bf/KUkJwd3ulp1mfy3pb/ahjZ54C1dUaMqqnF7TOGvD9DIkT4mUIHy2P6tv2rmG7kxEp
	HOvtdsX/Jx1/Y6Ge/LZp9mPoRSjpIooShN8MyNgA1ZE4ijM3ubMXmnMF956lS28u1vNS
	aE2gKuLVtnXrNhb2Ir+hCHeb5OBp0O3s4x1spBG+2ghDVXOxxqNB01U1A+Q/R2lW+Ovt
	5jRQ==
X-Gm-Message-State: AOAM530xQHBmIRtdlc1Y27EWJ6qgnEy9f7rV14LJSVUK6wO54xH3fUA9
	QLsSACZXKqCYmeSV061FQnk9SA==
X-Google-Smtp-Source: ABdhPJwm0J2qtE+FE/PUvTFUO5lV8Xw5XsKj4sTwM2pR0jbx5CoUJ/9kjWwlg9/c73FShGDpL5/+Cg==
X-Received: by 2002:a05:6000:1841:: with SMTP id
	c1mr24598385wri.425.1635967621989; 
	Wed, 03 Nov 2021 12:27:01 -0700 (PDT)
Received: from localhost (5.186.126.13.cgn.fibianet.dk. [5.186.126.13])
	by smtp.gmail.com with ESMTPSA id 9sm3893755wry.0.2021.11.03.12.27.01
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 03 Nov 2021 12:27:01 -0700 (PDT)
Date: Wed, 3 Nov 2021 20:27:00 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211103192700.clqzvvillfnml2nu@mpHalley-2>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<20211029081447.ativv64dofpqq22m@ArmHalley.local>
MIME-Version: 1.0
In-Reply-To: <20211029081447.ativv64dofpqq22m@ArmHalley.local>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Nov 2021 03:22:43 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjkuMTAuMjAyMSAxMDoxNCwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPk9uIDI5LjEwLjIw
MjEgMDA6MjEsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPj5PbiAxMC83LzIxIDExOjQ5IFBN
LCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+Pj5FeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24g
b3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cwo+Pj4KPj4+Cj4+Pk9uIDA2LjEwLjIwMjEgMTA6
MzMsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4+Pk9uIDEwLzYvMjEgMzowNSBBTSwgSmF2aWVy
IEdvbnrDoWxleiB3cm90ZToKPj4+Pj5JIGFncmVlIHRoYXQgdGhlIHRvcGljIGlzIGNvbXBsZXgu
IEhvd2V2ZXIsIHdlIGhhdmUgbm90IGJlZW4gYWJsZSB0bwo+Pj4+PmZpbmQgYSBjbGVhciBwYXRo
IGZvcndhcmQgaW4gdGhlIG1haWxpbmcgbGlzdC4KPj4+Pgo+Pj4+SG1tIC4uLiByZWFsbHk/IEF0
IGxlYXN0IE1hcnRpbiBQZXRlcnNlbiBhbmQgSSBjb25zaWRlciBkZXZpY2UgbWFwcGVyCj4+Pj5z
dXBwb3J0IGVzc2VudGlhbC4gSG93IGFib3V0IHN0YXJ0aW5nIGZyb20gTWlrdWxhcycgcGF0Y2gg
c2VyaWVzIHRoYXQKPj4+PnN1cHBvcnRzIHRoZSBkZXZpY2UgbWFwcGVyPyBTZWUgYWxzbwo+Pj4+
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2FscGluZS5MUkguMi4wMi4yMTA4MTcxNjMwMTIw
LjMwMzYzQGZpbGUwMS5pbnRyYW5ldC5wcm9kLmludC5yZHUyLnJlZGhhdC5jb20vCj4+Pj4KPj4K
Pj5XaGVuIHdlIGFkZCBhIG5ldyBSRVFfT1BfWFhYIHdlIG5lZWQgdG8gbWFrZSBzdXJlIGl0IHdp
bGwgd29yayB3aXRoCj4+ZGV2aWNlIG1hcHBlciwgc28gSSBhZ3JlZSB3aXRoIEJhcnQgYW5kIE1h
cnRpbi4KPj4KPj5TdGFydGluZyB3aXRoIE1pa3VsYXMgcGF0Y2hlcyBpcyBhIHJpZ2h0IGRpcmVj
dGlvbiBhcyBvZiBub3cuLgo+Pgo+Pj4KPj4+VGhhbmtzIGZvciB0aGUgcG9pbnRlcnMuIFdlIGFy
ZSBsb29raW5nIGludG8gTWlrdWxhcycgcGF0Y2ggLSBJIGFncmVlCj4+PnRoYXQgaXQgaXMgYSBn
b29kIHN0YXJ0Lgo+Pj4KPj4+Pj5XaGF0IGRvIHlvdSB0aGluayBhYm91dCBqb2luaW5nIHRoZSBj
YWxsIHRvIHRhbGsgdmVyeSBzcGVjaWZpYyBuZXh0Cj4+Pj4+c3RlcHMgdG8gZ2V0IGEgcGF0Y2hz
ZXQgdGhhdCB3ZSBjYW4gc3RhcnQgcmV2aWV3aW5nIGluIGRldGFpbC4KPj4+Pgo+Pj4+SSBjYW4g
ZG8gdGhhdC4KPj4+Cj4+PlRoYW5rcy4gSSB3aWxsIHdhaXQgdW50aWwgQ2hhaXRhbnlhJ3MgcmVw
bHkgb24gaGlzIHF1ZXN0aW9ucy4gV2Ugd2lsbAo+Pj5zdGFydCBzdWdnZXN0aW5nIHNvbWUgZGF0
ZXMgdGhlbi4KPj4+Cj4+Cj4+SSB0aGluayBhdCB0aGlzIHBvaW50IHdlIG5lZWQgdG8gYXQgbGVh
c3QgZGVjaWRlIG9uIGhhdmluZyBhIGZpcnN0IGNhbGwKPj5mb2N1c2VkIG9uIGhvdyB0byBwcm9j
ZWVkIGZvcndhcmQgd2l0aCBNaWt1bGFzIGFwcHJvYWNoICAuLi4KPj4KPj5KYXZpZXIsIGNhbiB5
b3UgcGxlYXNlIG9yZ2FuaXplIGEgY2FsbCB3aXRoIHBlb3BsZSB5b3UgbGlzdGVkIGluIHRoaXMK
Pj50aHJlYWQgZWFybGllciA/Cj4KPkhlcmUgeW91IGhhdmUgYSBEb29nbGUgZm9yIGVuZCBvZiBu
ZXh0IHdlZWsgYW5kIHRoZSB3ZWVrIGFmdGVyIE9DUC4KPlBsZWFzZSBmaWxsIGl0IG91dCB1bnRp
bCBXZWRuZXNkYXkuIEkgd2lsbCBzZXQgdXAgYSBjYWxsIHdpdGggdGhlCj5zZWxlY3RlZCBzbG90
Ogo+Cj4gICAgaHR0cHM6Ly9kb29kbGUuY29tL3BvbGwvcjJjOGR1eTNyOGc4OHY4cT91dG1fc291
cmNlPXBvbGwmdXRtX21lZGl1bT1saW5rCj4KPlRoYW5rcywKPkphdmllcgoKSSBzZW50IHRoZSBp
bnZpdGUgZm9yIHRoZSBwZW9wbGUgdGhhdCBzaWduZWQgdXAgaW50byB0aGUgRG9vZGxlLiBUaGUK
Y2FsbCB3aWxsIHRha2UgcGxhY2Ugb24gTW9uZGF5IE5vdmVtYmVyIDE1dGgsIDE3LjAwLTE5LjAw
IENFVC4gU2VlIHRoZQpsaXN0IG9mIGN1cnJlbnQgcGFydGljaXBhbnRzIGJlbG93LiBJZiBhbnlv
bmUgZWxzZSB3YW50cyB0byBwYXJ0aWNpcGF0ZSwKcGxlYXNlIHNlbmQgbWUgYSBub3RlIGFuZCBJ
IHdpbGwgZXh0ZW5kIHRoZSBpbnZpdGUuCgogICBKb2hhbm5lcy5UaHVtc2hpcm5Ad2RjLmNvbQog
ICBWaW5jZW50LmZ1QHNhbXN1bmcuY29tCiAgIGEuZGF3bkBzYW1zdW5nLmNvbQogICBhLm1hbnph
bmFyZXNAc2Ftc3VuZy5jb20KICAgYnZhbmFzc2NoZUBhY20ub3JnCiAgIGhpbWFuc2h1Lm1hZGhh
bmlAb3JhY2xlLmNvbQogICBqb3NoaS5rQHNhbXN1bmcuY29tCiAgIGtjaEBudmlkaWEuY29tCiAg
IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tCiAgIG5qLnNoZXR0eUBzYW1zdW5nLmNvbQogICBz
ZWx2YWt1bWEuczFAc2Ftc3VuZwoKSmF2aWVyCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

