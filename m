Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6ACC4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A72423433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A72423433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-Rua6ifkuPRSGwiHI-oJnXA-1; Wed, 09 Dec 2020 04:57:19 -0500
X-MC-Unique: Rua6ifkuPRSGwiHI-oJnXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F4AB192296B;
	Wed,  9 Dec 2020 09:57:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13E7B60C5F;
	Wed,  9 Dec 2020 09:57:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCAD51809C9F;
	Wed,  9 Dec 2020 09:57:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B99HDXR026107 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 04:17:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 39569AC97C; Wed,  9 Dec 2020 09:17:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 339329E80
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 09:17:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEFC1800962
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 09:17:10 +0000 (UTC)
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com
	[209.85.218.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-542-_FJPmqlwNhOu2_ZFNxi7eA-1; Wed, 09 Dec 2020 04:17:08 -0500
X-MC-Unique: _FJPmqlwNhOu2_ZFNxi7eA-1
Received: by mail-ej1-f65.google.com with SMTP id ce23so1047081ejb.8
	for <dm-devel@redhat.com>; Wed, 09 Dec 2020 01:17:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=rhhiMX6lpyZpBTo++Wq1vgh3A63oG1sQxoZyJsc1aQg=;
	b=mP/1Ah/WZxVlW8wAfMhLeoNhAt8CnpWKSOpoKfxBq3AvMKqlIap+gcKEv0kpQnuLRh
	McJ6R3tfaxvkzQkVEYBfPAoXnMWxRazOXYtwX1Ck6sp5ctkb4lCO4IkqsGip3ikIoigH
	ahDVIrY3nCzz3rDEKNGqB5zAvJA75uxl5ifyHIuAn2kXqBKNyJtzLRhJFOH1Hi2vLo65
	LV+sNXx13ZfEy8d/HeMG4lohHkuwr5u3avxofJ4og/1DhF5IuqWLE1Dx87v7vneARX0k
	Z9sa5JoBiVYuBc0TX43LStnog/KPV64Fko0ZVZeQBsBMs/4QZf6ULqHyaFYr49u5c6K6
	ygpw==
X-Gm-Message-State: AOAM533UgdWjUqxSDVyvORAKQDg1amlGvIfk3KJginnXbqs6YDsKozdl
	yQ6tFASd1p0TzX7Ew1KVqS61fw==
X-Google-Smtp-Source: ABdhPJxbBbOAPum4JxhLDvVO8oH4bCpyUFUBf6xuJ19RfGwEp+yksU2UBrKm/QCGpkEPA7yZYkCfcA==
X-Received: by 2002:a17:906:a857:: with SMTP id
	dx23mr1242029ejb.189.1607505427041; 
	Wed, 09 Dec 2020 01:17:07 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	j20sm874968ejy.124.2020.12.09.01.17.05
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 09 Dec 2020 01:17:06 -0800 (PST)
Date: Wed, 9 Dec 2020 10:17:05 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20201209091705.brzbbqedavtxvhms@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208122248.utv7pqthmmn6uwv6@mpHalley>
	<SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208131333.xoxincxcnh7iz33z@mpHalley>
	<SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDguMTIuMjAyMCAxMzoyNCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+T24gMDgvMTIv
MjAyMCAxNDoxMywgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gT24gMDguMTIuMjAyMCAxMjoz
NywgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+Pj4gT24gMDgvMTIvMjAyMCAxMzoyMiwgSmF2
aWVyIEdvbnrDoWxleiB3cm90ZToKPj4+PiBHb29kIGlkZWEuIEFyZSB5b3UgdGhpbmtpbmcgb2Yg
YSBzeXNmcyBlbnRyeSB0byBzZWxlY3QgdGhlIGJhY2tlbmQ/Cj4+Pgo+Pj4gTm90IHN1cmUgb24g
dGhpcyBvbmUsIGluaXRpYWxseSBJIHRob3VnaHQgb2YgYSBzeXNmcyBmaWxlLCBidXQgdGhlbgo+
Pj4gaG93IHdvdWxkIHlvdSBkbyBpdC4gT25lICJnbG9iYWwiIHN5c2ZzIGVudHJ5IGlzIHByb2Jh
Ymx5IGEgYmFkIGlkZWEuCj4+PiBIYXZpbmcgb25lIHBlciBibG9jayBkZXZpY2UgdG8gc2VsZWN0
IG5hdGl2ZSB2cyBlbXVsYXRpb24gbWF5YmU/IEFuZAo+Pj4gYSBnb29kIHdheSB0byBiZW5jaG1h
cmsuCj4+Cj4+IEkgd2FzIHRoaW5raW5nIGEgcGVyIGJsb2NrIGRldmljZSB0byB0YXJnZXQgdGhl
IHVzZSBjYXNlIHdoZXJlIGEgY2VydGFpbgo+PiBpbXBsZW1lbnRhdGlvbiAvIHdvcmtsb2FkIGlz
IGJldHRlciBvbmUgd2F5IG9yIHRoZSBvdGhlci4KPgo+WWVzIHNvbWV0aGluZyBhbG9uZyB0aG9z
ZSBsaW5lcy4KPgo+Pj4KPj4+IFRoZSBvdGhlciBpZGVhIHdvdWxkIGJlIGEgYmVuY2htYXJrIGxv
b3Agb24gYm9vdCBsaWtlIHRoZSByYWlkIGxpYnJhcnkKPj4+IGRvZXMuCj4+Pgo+Pj4gVGhlbiBv
biB0aGUgb3RoZXIgaGFuZCwgdGhlcmUgbWlnaHQgYmUgd29ya2xvYWRzIHRoYXQgcnVuIGZhc3Rl
ciB3aXRoCj4+PiB0aGUgZW11bGF0aW9uIGFuZCBzb21lIHRoYXQgcnVuIGZhc3RlciB3aXRoIHRo
ZSBoYXJkd2FyZSBhY2NlbGVyYXRpb24uCj4+Pgo+Pj4gSSB0aGluayB0aGVzZSBwb2ludHMgYXJl
IHRoZSByZWFzb24gdGhlIGxhc3QgYXR0ZW1wdHMgZ290IHN0dWNrLgo+Pgo+PiBZZXMuIEkgYmVs
aWV2ZSB0aGF0IGFueSBiZW5jaG1hcmsgd2UgcnVuIHdvdWxkIGJlIGJpYXNlZCBpbiBhIGNlcnRh
aW4KPj4gd2F5LiBJZiB3ZSBjYW4gbW92ZSBmb3J3YXJkIHdpdGggYSBzeXNmcyBlbnRyeSBhbmQg
ZGVmYXVsdCB0byBsZWdhY3kKPj4gcGF0aCwgd2Ugd291bGQgbm90IGFsdGVyIGN1cnJlbnQgYmVo
YXZpb3IgYW5kIGVuYWJsZSBOVk1lIGNvcHkgb2ZmbG9hZAo+PiAoZm9yIG5vdykgZm9yIHRob3Nl
IHRoYXQgd2FudCB0byB1c2UgaXQuIFdlIGNhbiB0aGVuIGJ1aWxkIG9uIHRvcCBvZiBpdC4KPj4K
Pj4gRG9lcyB0aGlzIHNvdW5kIGxpa2UgYSByZWFzb25hYmxlIGFwcHJvYWNoPwo+Pgo+Cj5ZZXMg
dGhpcyBzb3VuZHMgbGlrZSBhIHJlYXNvbmFibGUgYXBwcm9hY2ggdG8gbWUuCgpDb29sLiBXZSB3
aWxsIGFkZCB0aGlzIHRvIHRoZSBWMyB0aGVuLgoKVGhhbmtzIEpvaGFubmVzIQoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

