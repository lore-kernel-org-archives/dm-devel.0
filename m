Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78BFC433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:33:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-7miCod4RPnGs63ea9fXSUA-1; Mon, 07 Feb 2022 04:33:31 -0500
X-MC-Unique: 7miCod4RPnGs63ea9fXSUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B0FA1800D50;
	Mon,  7 Feb 2022 09:33:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0316C105B1F2;
	Mon,  7 Feb 2022 09:33:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88EC71809CBA;
	Mon,  7 Feb 2022 09:33:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214BYRmd019363 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 06:34:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE13440885CA; Fri,  4 Feb 2022 11:34:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA99540885BE
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 11:34:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A147285A5A8
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 11:34:27 +0000 (UTC)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
	[209.85.208.43]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-561-5lTXfFabO26c0l7e3VsQ9g-1; Fri, 04 Feb 2022 06:34:26 -0500
X-MC-Unique: 5lTXfFabO26c0l7e3VsQ9g-1
Received: by mail-ed1-f43.google.com with SMTP id b13so12608862edn.0
	for <dm-devel@redhat.com>; Fri, 04 Feb 2022 03:34:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=TQF1/AEnbtmUHa3FAuw6nQDJrxJFCv8yYCIQAgYMNR0=;
	b=GNZRF9VfaE9zphpq5ZvttUJ517myxChzJWQhZZjYcQW9B1ijIqVL9NMXvlmHIQ6uNK
	MKBOcX3sCGMLRURoa6iwl5QZ0P8Ro/jZgRHEEDe9pubz2M8T3NOKgG5JuAb7Ke1B/rEG
	jGtEFWofy3NIHz/D+3MVX59VDv6BW5X5u1UavJNZ+362WcnAEX/wyk9S76WIoxV68usH
	gxyBej7eaFcLAWaGy7CI/Ryh4JM7z2HcdslzJNI1aRZHtOSHF84sD3RtMASm7BqQyyfa
	7nrSqipHHC1mgdxM805NpI1CaZKKGYL5jK5pri3X+fZ//MaaaiDeOncjzDInFOc5AIIK
	o9NQ==
X-Gm-Message-State: AOAM532b1enK2JRSiXh7hZwy9LOFkU7G/ZvUdh0T6ikrDOcUZ8NzTVcs
	8VCZD+OCF6x32sCr62+DrGVqXQ==
X-Google-Smtp-Source: ABdhPJyHnNd9ApX9T3hNeWQ8SqCfGSdnwH7VDzen0VyUwGIsxdXYZM95bCYkUb7xHMbslFw5zjsfww==
X-Received: by 2002:a05:6402:2691:: with SMTP id
	w17mr2622163edd.126.1643974464821; 
	Fri, 04 Feb 2022 03:34:24 -0800 (PST)
Received: from localhost (5.186.121.195.cgn.fibianet.dk. [5.186.121.195])
	by smtp.gmail.com with ESMTPSA id z8sm556366ejc.151.2022.02.04.03.34.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Feb 2022 03:34:24 -0800 (PST)
Date: Fri, 4 Feb 2022 12:34:23 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20220204113423.jmynvz4w5u6wdban@ArmHalley.local>
References: <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
	<2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
	<9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
	<20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
	<4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDQuMDIuMjAyMiAwOTo1OCwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+T24gMi80LzIy
IDEyOjI0IEFNLCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+PiBPbiAwNC4wMi4yMDIyIDA3OjU4
LCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6Cj4+PiBPbiAyLzMvMjIgMjI6MjgsIERhbWllbiBM
ZSBNb2FsIHdyb3RlOgo+Pj4+IE9uIDIvNC8yMiAxMjoxMiwgQ2hhaXRhbnlhIEt1bGthcm5pIHdy
b3RlOgo+Pj4+Pgo+Pj4+Pj4+PiBPbmUgY2FuIGluc3RhbnRpYXRlIHNjc2kgZGV2aWNlcyB3aXRo
IHFlbXUgYnkgdXNpbmcgZmFrZSBzY3NpCj4+Pj4+Pj4+IGRldmljZXMsCj4+Pj4+Pj4+IGJ1dCBv
bmUgY2FuIGFsc28ganVzdCB1c2Ugc2NzaV9kZWJ1ZyB0byBkbyB0aGUgc2FtZS4gSSBzZWUgYm90
aAo+Pj4+Pj4+PiBlZmZvcnRzCj4+Pj4+Pj4+IGFzIGRlc2lyYWJsZSwgc28gbG9uZyBhcyBzb21l
b25lIG1hbnRhaW5zIHRoaXMuCj4+Pj4+Pj4+Cj4+Pj4+Cj4+Pj4+IFdoeSBkbyB5b3UgdGhpbmsg
Ym90aCBlZmZvcnRzIGFyZSBkZXNpcmFibGUgPwo+Pj4+Cj4+Pj4gV2hlbiB0ZXN0aW5nIGNvZGUg
dXNpbmcgdGhlIGZ1bmN0aW9uYWxpdHksIGl0IGlzIGZhciBlYXNpZXIgdG8gZ2V0IHNhaWQKPj4+
PiBmdW5jdGlvbmFsaXR5IGRvaW5nIGEgc2ltcGxlICJtb2Rwcm9iZSIgcmF0aGVyIHRoYW4gaGF2
aW5nIHRvIHNldHVwIGEKPj4+PiBWTS4gQy5mLiBydW5uaW5nIGJsa3Rlc3RzIG9yIGZzdGVzdHMu
Cj4+Pj4KPj4+Cj4+PiBhZ3JlZSBvbiBzaW1wbGljaXR5IGJ1dCB0aGVuIHdoeSBkbyB3ZSBoYXZl
IFFFTVUgaW1wbGVtZW50YXRpb25zIGZvcgo+Pj4gdGhlIE5WTWUgZmVhdHVyZXMgKGUuZy4gWk5T
LCBOVk1lIFNpbXBsZSBDb3B5KSA/IHdlIGNhbiBqdXN0IGJ1aWxkCj4+PiBtZW1vZXJ5IGJhY2tl
ZCBOVk1lT0YgdGVzdCB0YXJnZXQgZm9yIE5WTWUgY29udHJvbGxlciBmZWF0dXJlcy4KPj4+Cj4+
PiBBbHNvLCByZWNvZ25pemluZyB0aGUgc2ltcGxpY2l0eSBJIHByb3Bvc2VkIGluaXRpYWxseSBO
Vk1lIFpOUwo+Pj4gZmFicmljcyBiYXNlZCBlbXVsYXRpb24gb3ZlciBRRU1VIChJIHRoaW5rIEkg
c3RpbGwgaGF2ZSBpbml0aWFsIHN0YXRlCj4+PiBtYWNoaW5lIGltcGxlbWVudGF0aW9uIGNvZGUg
Zm9yIFpOUyBzb21ld2hlcmUpLCB0aG9zZSB3ZXJlICJuYWNrZWQiIGZvcgo+Pj4gdGhlIHJpZ2h0
IHJlYXNvbiwgc2luY2Ugd2UndmUgZGVjaWRlZCBnbyB3aXRoIFFFTVUgYW5kIHVzZSB0aGF0IGFz
IGEKPj4+IHByaW1hcnkgcGxhdGZvcm0gZm9yIHRlc3RpbmcsIHNvIEkgZmFpbGVkIHRvIHVuZGVy
c3RhbmQgd2hhdCBoYXMKPj4+IGNoYW5nZWQuLiBzaW5jZSBnaXZlbiB0aGF0IFFFTVUgYWxyZWFk
eSBzdXBwb3J0cyBOVk1lIHNpbXBsZSBjb3B5IC4uLgo+Pgo+PiBJIHdhcyBub3QgcGFydCBvZiB0
aGlzIGNvbnZlcnNhdGlvbiwgYnV0IGFzIEkgc2VlIGl0IGVhY2ggYXBwcm9hY2ggZ2l2ZQo+PiBh
IGJlbmVmaXQuIFFFTVUgaXMgZmFudGFzdGljIGZvciBjb21wbGlhbmNlIHRlc3RpbmcgYW5kIEkg
YW0gbm90IHN1cmUKPj4geW91IGdldCB0aGUgc2FtZSBsZXZlbCBvZiBjb21tYW5kIGFuYWx5c2lz
IGFueXdoZXJlIGVsc2U7IGF0IGxlYXN0IG5vdAo+PiB3aXRob3V0IHdyaXRpbmcgZGVkaWNhdGVk
IGNvZGUgZm9yIHRoaXMgaW4gYSB0YXJnZXQuCj4+Cj4+IFRoaXMgc2FpZCwgd2hlbiB3ZSB3YW50
IHRvIHRlc3QgZm9yIHJhY2UgY29uZGl0aW9ucywgUUVNVSBpcyB2ZXJ5IHNsb3cuCj4KPkNhbiB5
b3UgcGxlYXNlIGVsYWJvcmF0ZSB0aGUgc2NlbmFyaW8gYW5kIG51bWJlcnMgZm9yIHNsb3duZXNz
IG9mIFFFTVU/CgpRRU1VIGlzIGFuIGVtdWxhdG9yLCBub3QgYSBzaW11bGF0b3IuIFNvIHdlIHdp
bGwgbm90IGJlIGFibGUgdG8gc3RyZXNzCnRoZSBob3N0IHN0YWNrIGluIHRoZSBzYW1lIHdheSB0
aGUgbnVsbF9ibGsgZGV2aWNlIGRvZXMuIElmIHdlIHdhbnQgdG8KdGVzdCBjb2RlIGluIHRoZSBO
Vk1lIGRyaXZlciB0aGVuIHdlIG5lZWQgYSB3YXkgdG8gaGF2ZSB0aGUgZXF1aXZhbGVudAp0byB0
aGUgbnVsbF9ibGsgaW4gTlZNZS4gSXQgc2VlbXMgbGlrZSB0aGUgbnZtZS1sb29wIHRhcmdldCBj
YW4gYWNoaWV2ZQp0aGlzLgoKRG9lcyB0aGlzIGFuc3dlciB5b3VyIGNvbmNlcm4/Cgo+Cj5Gb3Ig
cmFjZSBjb25kaXRpb25zIHRlc3Rpbmcgd2UgY2FuIGJ1aWxkIGVycm9yIGluamVjdGlvbiBmcmFt
ZXdvcmsKPmFyb3VuZCB0aGUgY29kZSBpbXBsZW1lbnRhdGlvbiB3aGljaCBwcmVzZW50IGluIGtl
cm5lbCBldmVyeXdoZXJlLgoKVHJ1ZS4gVGhpcyBpcyBhbHNvIGEgZ29vZCB3YXkgdG8gZG8gdGhp
cy4KCgo+Cj4+IEZvciBhIHNvZnR3YXJlLW9ubHkgc29sdXRpb24sIHdlIGhhdmUgZXhwZXJpbWVu
dGVkIHdpdGggc29tZXRoaW5nCj4+IHNpbWlsYXIgdG8gdGhlIG52bWUtZGVidWcgY29kZSB0aGEg
TWlrdWxhcyBpcyBwcm9wb3NpbmcuIEFkYW0gcG9pbnRlZCB0bwo+PiB0aGUgbnZtZS1sb29wIHRh
cmdldCBhcyBhbiBhbHRlcm5hdGl2ZSBhbmQgdGhpcyBzZWVtcyB0byB3b3JrIHByZXR0eQo+PiBu
aWNlbHkuIEkgZG8gbm90IGJlbGlldmUgdGhlcmUgc2hvdWxkIGJlIG1hbnkgY2hhbmdlcyB0byBz
dXBwb3J0IGNvcHkKPj4gb2ZmbG9hZCB1c2luZyB0aGlzLgo+Pgo+Cj5JZiBRRU1VIGlzIHNvIGlu
Y29tcGV0ZW50IHRoZW4gd2UgbmVlZCB0byBhZGQgZXZlcnkgYmlnIGZlYXR1cmUgaW50bwo+dGhl
IE5WTWVPRiB0ZXN0IHRhcmdldCBzbyB0aGF0IHdlIGNhbiB0ZXN0IGl0IGJldHRlciA/IGlzIHRo
YXQgd2hhdAo+eW91IGFyZSBwcm9wb3NpbmcgPyBzaW5jZSBpZiB3ZSBpbXBsZW1lbnQgb25lIGZl
YXR1cmUsIGl0IHdpbGwgYmUKPmhhcmQgdG8gbmFjayBhbnkgbmV3IGZlYXR1cmVzIHRoYXQgcHBs
IHdpbGwgY29tZSB1cCB3aXRoCj5zYW1lIHJhdGlvbmFsZSAid2l0aCBRRU1VIGJlaW5nIHNsb3cg
YW5kIGhhcmQgdG8gdGVzdCByYWNlCj5jb25kaXRpb25zIGV0YyAuLiIKCkluIG15IG9waW5pb24s
IGlmIHBlb3BsZSB3YW50IHRoaXMgYW5kIGlzIHdpbGxpbmcgdG8gbWFpbnRhaW4gaXQsIHRoZXJl
CmlzIGEgY2FzZSBmb3IgaXQuCgo+Cj5hbmQgaWYgdGhhdCBpcyB0aGUgY2FzZSB3aHkgd2UgZG9u
J3QgaGF2ZSBaTlMgTlZNZU9GIHRhcmdldAo+bWVtb3J5IGJhY2tlZCBlbXVsYXRpb24gPyBJc24n
dCB0aGF0IGEgYmlnZ2VyIGFuZCBtb3JlCj5jb21wbGljYXRlZCBmZWF0dXJlIHRoYW4gU2ltcGxl
IENvcHkgd2hlcmUgY29udHJvbGxlciBzdGF0ZXMKPmFyZSBpbnZvbHZlZCB3aXRoIEFFTnMgPwoK
SSB0aGluayB0aGlzIGlzIGEgZ29vZCBpZGVhLgoKPgo+Wk5TIGtlcm5lbCBjb2RlIHRlc3Rpbmcg
aXMgYWxzbyBkb25lIG9uIFFFTVUsIEkndmUgYWxzbyBmaXhlZAo+YnVncyBpbiB0aGUgWk5TIGtl
cm5lbCBjb2RlIHdoaWNoIGFyZSBkaXNjb3ZlcmVkIG9uIFFFTVUgYW5kIEkndmUgbm90Cj5zZWVu
IGFueSBpc3N1ZXMgd2l0aCB0aGF0LiBHaXZlbiB0aGF0IHNpbXBsZSBjb3B5IGZlYXR1cmUgaXMg
d2F5IHNtYWxsZXIKPnRoYW4gWk5TIGl0IHdpbGwgbGVzcyBsaWtlbHkgdG8gc3VmZmVyIGZyb20g
c2xvd25lc3MgYW5kIGV0YyAobGlzdGVkCj5hYm92ZSkgaW4gUUVNVS4KClFFTVUgaXMgc3VwZXIg
dXNlZnVsOiBpdCBpcyBlYXN5IGFuZCBpdCBoZWxwIGlkZW50aWZ5aW5nIG1hbnkgaXNzdWVzLgpC
dXQgaXQgaXMgZm9yIGNvbXBsaWFuY2UsIG5vdCBmb3IgcGVyZm9ybWFuY2UuIFRoZXJlIHdhcyBh
biBlZmZvcnQgdG8KbWFrZSBGRU1VLCBidXQgdGhpcyBzZWVtcyB0byBiZSBhbiBhYmFuZG9uZWQg
cHJvamVjdC4KCj4KPm15IHBvaW50IGlzIGlmIHdlIGFsbG93IG9uZSwgd2Ugd2lsbCBiZSBvcGVu
aW5nIGZsb29kZ2F0ZXMgYW5kIHdlIG5lZWQKPnRvIGJlIGNhcmVmdWwgbm90IHRvIGJsb2F0IHRo
ZSBjb2RlIHVubGVzcyBpdCBpcyBfYWJzb2x1dGVseQo+bmVjZXNzYXJ5XyB3aGljaCBJIGRvbid0
IHRoaW5rIGl0IGlzIGJhc2VkIG9uIHRoZSBzaW1wbGUgY29weQo+c3BlY2lmaWNhdGlvbi4KCkkg
dW5kZXJzdGFuZCwgYW5kIHRoaXMgaXMgYSB2ZXJ5IHZhbGlkIHBvaW50LiBJdCBzZWVtcyBsaWtl
IHRoZQpudm1lLWxvb3AgZGV2aWNlIGNhbiBnaXZlIGEgbG90IG9mIHdoYXQgd2UgbmVlZDsgYWxs
IHRoZSBuZWNlc3NhcnkgZXh0cmEKbG9naWMgY2FuIGdvIGludG8gdGhlIG51bGxfYmxrIGFuZCB0
aGVuIHdlIGRvIG5vdCBuZWVkIE5WTWUgc3BlY2lmaWMKY29kZS4KCkRvIHlvdSBzZWUgYW55IGlu
Y29udmVuaWVudCB3aXRoIHRoaXMgYXBwcm9hY2g/CgoKPgo+PiBTbyBpbiBteSB2aWV3IGhhdmlu
ZyBib3RoIGlzIG5vdCByZXBsaWNhdGlvbiBhbmQgaXQgZ2l2ZXMgbW9yZQo+PiBmbGV4aWJpbGl0
eSBmb3IgdmFsaWRhdGlvbiwgd2hpY2ggSSBiZWxpZXZlIGl0IGlzIGFsd2F5cyBnb29kLgo+Pgo+
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

