Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054ABC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 58BA023433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58BA023433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-EpeKnPCxPk20WtdKjlXXPw-1; Wed, 09 Dec 2020 04:58:09 -0500
X-MC-Unique: EpeKnPCxPk20WtdKjlXXPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51E2B80EF82;
	Wed,  9 Dec 2020 09:58:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 326485C23D;
	Wed,  9 Dec 2020 09:58:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 053D01809CA2;
	Wed,  9 Dec 2020 09:58:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8CLcek010579 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 07:21:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7FB92026D48; Tue,  8 Dec 2020 12:21:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2F662026D5D
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:21:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C490801E6B
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:21:35 +0000 (UTC)
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com
	[209.85.218.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-73-iyyZXbhwP2-XwFod25FU_g-1; Tue, 08 Dec 2020 07:21:17 -0500
X-MC-Unique: iyyZXbhwP2-XwFod25FU_g-1
Received: by mail-ej1-f67.google.com with SMTP id qw4so24263352ejb.12
	for <dm-devel@redhat.com>; Tue, 08 Dec 2020 04:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=IAI5d5pS3efjsbXLYKh2mpe6utm2q/uw9y9/qssJFDE=;
	b=rX0/1spfYYp3MvF/RoPIKrfWOu0dV02KRUdWmLfIbrENUS3qalkdWNt8H3luudhJ4D
	FMlh1bS04UPi5hAWQKT9I/MXN6G4WfzRJjmjpmMiMJlg482QjEIsM5fT9VltzQG93KmO
	eAv0Tfa3JrDWcsN+i3E8WEjNPNNwUeRsE59sdArYgCjA4VjEFgC0qBAmLjwmiPvR0anb
	EFMViy3klO7yQ34/VD3DuNDGnJL+3dfQr/IMlHHHvhcSj5a03jyhpnJimRPu19PYxAtb
	CQUGn+zhBOIkNvNpckdMrp4gejVn329MVHYbin0emhiwYmQ7n2ZT1voyIJwNH6sPTZwn
	gp4w==
X-Gm-Message-State: AOAM531lMP9gYuBIuFiwn6DrevybmTB1Ba+qciTce6I4QK/Ryo+03clt
	OY65k9yrJ6baEUh6aZkhrK/nmA==
X-Google-Smtp-Source: ABdhPJxhL6i6yFmZQunp7bazoVScU9q+jr5k0Xgzao5BDSe6y/H+nh7mEFR+wnSA5Kolq55NeVPyBQ==
X-Received: by 2002:a17:906:718b:: with SMTP id
	h11mr6669589ejk.241.1607430076628; 
	Tue, 08 Dec 2020 04:21:16 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	e3sm15781214ejq.96.2020.12.08.04.21.15
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 08 Dec 2020 04:21:15 -0800 (PST)
From: "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?=
	<javier.gonz@samsung.com>
Date: Tue, 8 Dec 2020 13:21:15 +0100
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201208122115.jy7s3w2wr3ysxvkk@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
	<9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
MIME-Version: 1.0
In-Reply-To: <9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
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
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	nj.shetty@samsung.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>, joshi.k@samsung.com,
	dgilbert@interlog.com, kbusch@kernel.org,
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
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

T24gMDguMTIuMjAyMCAwNzo0NCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+T24gMTIvNy8yMCAx
MToxMiBQTSwgRG91Z2xhcyBHaWxiZXJ0IHdyb3RlOgo+Pk9uIDIwMjAtMTItMDcgOTo1NiBhLm0u
LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+Pk9uIDEyLzcvMjAgMzoxMSBQTSwgQ2hyaXN0b3Bo
IEhlbGx3aWcgd3JvdGU6Cj4+Pj5TbywgSSdtIHJlYWxseSB3b3JyaWVkIGFib3V0Ogo+Pj4+Cj4+
Pj7CoCBhKSBhIGdvb2QgdXNlIGNhc2UuwqAgR0MgaW4gZjJmcyBvciBidHJmcyBzZWVtIGxpa2Ug
Z29vZCB1c2UgY2FzZXMsIGFzCj4+Pj7CoMKgwqDCoCBkb2VzIGFjY2VsYXRpbmcgZG0ta2NvcHlk
LsKgIEkgYWdyZWUgd2l0aCBEYW1pZW4gdGhhdCAKPj4+PmxpZnRpbmcgZG0ta2NvcHlkCj4+Pj7C
oMKgwqDCoCB0byBjb21tb24gY29kZSB3b3VsZCBhbHNvIGJlIHJlYWxseSBuaWNlLsKgIEknbSBu
b3QgMTAwJSAKPj4+PnN1cmUgaXQgc2hvdWxkCj4+Pj7CoMKgwqDCoCBiZSBhIHJlcXVpcmVtZW50
LCBidXQgaXQgc3VyZSB3b3VsZCBiZSBuaWNlIHRvIGhhdmUKPj4+PsKgwqDCoMKgIEkgZG9uJ3Qg
dGhpbmsganVzdCBhZGRpbmcgYW4gaW9jdGwgaXMgZW5vdWdoIG9mIGEgdXNlIGNhc2UgCj4+Pj5m
b3IgY29tcGxleAo+Pj4+wqDCoMKgwqAga2VybmVsIGluZnJhc3RydWN0dXJlLgo+Pj4+wqAgYikg
V2UgaGFkIGEgYnVuY2ggb2YgZGlmZmVyZW50IGF0dGVtcHRzIGF0IFNDU0kgWENPUFkgc3VwcG9y
dCAKPj4+PmZvcm0gSUlSQwo+Pj4+wqDCoMKgwqAgTWFydGluLCBCYXJ0IGFuZCBNaWt1bGFzLsKg
IEkgdGhpbmsgd2UgbmVlZCB0byBwdWxsIHRoZW0gaW50byB0aGlzCj4+Pj7CoMKgwqDCoCBkaXNj
dXNzaW9uLCBhbmQgbWFrZSBzdXJlIHdoYXRldmVyIHdlIGRvIGNvdmVycyB0aGUgU0NTSSBuZWVk
cy4KPj4+Pgo+Pj5BbmQgd2Ugc2hvdWxkbid0IGZvcmdldCB0aGF0IHRoZSBtYWluIGlzc3VlIHdo
aWNoIGtpbGxlZCBhbGwgCj4+PnByZXZpb3VzIGltcGxlbWVudGF0aW9ucyB3YXMgYSBtaXNzaW5n
IFFvUyBndWFyYW50ZWUuCj4+Pkl0J3MgbmljZSB0byBoYXZlIHNpbXBseSBjb3B5LCBidXQgaWYg
dGhlIGltcGxlbWVudGF0aW9uIGlzIAo+Pj5fc2xvd2VyXyB0aGFuIGRvaW5nIGl0IGJ5IGhhbmQg
ZnJvbSB0aGUgT1MgdGhlcmUgaXMgdmVyeSBsaXR0bGUgCj4+PnBvaW50IGluIGV2ZW4gYXR0ZW1w
dGluZyB0byBkbyBzby4KPj4+SSBjYW4ndCBzZWUgYW55IHByb3Zpc2lvbnMgZm9yIHRoYXQgaW4g
dGhlIFRQQVIsIGxlYWRpbmcgbWUgdG8gdGhlIAo+Pj5hc3N1bXB0aW9uIHRoYXQgTlZNZSBzaW1w
bGUgY29weSB3aWxsIHN1ZmZlciBmcm9tIHRoZSBzYW1lIGlzc3VlLgo+Pj4KPj4+U28gaWYgd2Ug
Y2FuJ3QgYWRkcmVzcyB0aGlzIEkgZ3Vlc3MgdGhpcyBhdHRlbXB0IHdpbGwgZmFpbCwgdG9vLgo+
Pgo+PkkgaGF2ZSBiZWVuIGRvaW5nIHF1aXRlIGEgbG90IG9mIHdvcmsgYW5kIHRlc3RpbmcgaW4g
bXkgc2cgZHJpdmVyIHJld3JpdGUKPj5pbiB0aGUgY29weSBhbmQgY29tcGFyZSBhcmVhLiBUaGUg
YmFzZWxpbmVzIGZvciBwZXJmb3JtYW5jZSBhcmUgZGQgYW5kCj4+aW9fdXJpbmctY3AgKGluIGxp
YnVyaW5nKS4gVGhlcmUgYXJlIGxvdHMgb2Ygd2F5cyB0byBpbXByb3ZlIG9uIHRoZW0uIEhlcmUK
Pj5hcmUgc29tZToKPj4gwqDCoCAtIHRoZSB1c2VyIGRhdGEgbmVlZCBuZXZlciBwYXNzIHRocm91
Z2ggdGhlIHVzZXIgc3BhY2UgKGNvdWxkCj4+IMKgwqDCoMKgIG1tYXAgaXQgb3V0IGR1cmluZyB0
aGUgUkVBRCBpZiB0aGVyZSBpcyBhIGdvb2QgcmVhc29uKS4gT25seSB0aGUKPj4gwqDCoMKgwqAg
bWV0YWRhdGEgKGUuZy4gTlZNZSBvciBTQ1NJIGNvbW1hbmRzKSBuZWVkcyB0byBjb21lIGZyb20g
dGhlIHVzZXIKPj4gwqDCoMKgwqAgc3BhY2UgYW5kIGVycm9ycywgaWYgYW55LCByZXBvcnRlZCBi
YWNrIHRvIHRoZSB1c2VyIHNwYWNlLgo+PiDCoMKgIC0gYnJlYWsgYSBsYXJnZSBjb3B5IChvciBj
b21wYXJlKSBpbnRvIHNlZ21lbnRzLCB3aXRoIGVhY2ggc2VnbWVudAo+PiDCoMKgwqDCoCBhICJj
b21mb3J0YWJsZSIgc2l6ZSBmb3IgdGhlIE9TIHRvIGhhbmRsZSwgc2F5IDI1NiBLQgo+PiDCoMKg
IC0gdGhlcmUgaXMgb25lIGNvbnN0cmFpbnQ6IHRoZSBSRUFEIGluIGVhY2ggc2VnbWVudCBtdXN0
IGNvbXBsZXRlCj4+IMKgwqDCoMKgIGJlZm9yZSBpdHMgcGFpcmVkIFdSSVRFIGNhbiBjb21tZW5j
ZQo+PiDCoMKgwqDCoCAtIGV4dHJhIGNvbnN0cmFpbnQgZm9yIHNvbWUgem9uZWQgZGlza3M6IFdS
SVRFcyBtdXN0IGJlCj4+IMKgwqDCoMKgwqDCoCBpc3N1ZWQgaW4gb3JkZXIgKGFzc3VtaW5nIHRo
ZXkgYXJlIGFwcGxpZWQgaW4gdGhhdCBvcmRlciwgaWYKPj4gwqDCoMKgwqDCoMKgIG5vdCwgbmVl
ZCB0byB3YWl0IHVudGlsIGVhY2ggV1JJVEUgY29tcGxldGVzKQo+PiDCoMKgIC0gYXJyYW5nZSBm
b3IgUkVBRCBXUklURSBwYWlyIGluIGVhY2ggc2VnbWVudCB0byBzaGFyZSB0aGUgc2FtZSBiaW8K
Pj4gwqDCoCAtIGhhdmUgbXVsdGlwbGUgc2xvdHMgZWFjaCBob2xkaW5nIGEgc2VnbWVudCAoaS5l
LiBhIGJpbyBhbmQKPj4gwqDCoMKgwqAgbWV0YWRhdGEgdG8gcHJvY2VzcyBhIFJFQUQtV1JJVEUg
cGFpcikKPj4gwqDCoCAtIHJlLXVzZSBlYWNoIHNsb3QncyBiaW8gZm9yIHRoZSBmb2xsb3dpbmcg
UkVBRC1XUklURSBwYWlyCj4+IMKgwqAgLSBpc3N1ZSB0aGUgUkVBRHMgaW4gZWFjaCBzbG90IGFz
eW5jaHJvbm91c2x5IGFuZCBkbyBhbiBpbnRlcmxlYXZlZAo+PiDCoMKgwqDCoCAoaW8pcG9sbCBm
b3IgY29tcGxldGlvbi4gVGhlbiBpc3N1ZSB0aGUgcGFpcmVkIFdSSVRFCj4+IMKgwqDCoMKgIGFz
eW5jaHJvbm91c2x5Cj4+IMKgwqAgLSB0aGUgYWJvdmUgInNsb3QiIGFsZ29yaXRobSBydW5zIGlu
IG9uZSB0aHJlYWQsIHNvIHRoZXJlIGNhbiBiZQo+PiDCoMKgwqDCoCBtdWx0aXBsZSB0aHJlYWRz
IGRvaW5nIHRoZSBzYW1lIGFsZ29yaXRobS4gU2VnbWVudCBtYW5hZ2VyIG5lZWRzCj4+IMKgwqDC
oMKgIHRvIGJlIGxvY2tlZCAob3IgdXNlIGFuIGF0b21pY3MpIHNvIHRoYXQgZWFjaCBzZWdtZW50
IChpZGVudGlmaWVkCj4+IMKgwqDCoMKgIGJ5IGl0cyBzdGFydGluZyBMQkFzKSBpcyBpc3N1ZWQg
b25jZSBhbmQgb25seSBvbmNlIHdoZW4gdGhlCj4+IMKgwqDCoMKgIG5leHQgdGhyZWFkIHdhbnRz
IGEgc2VnbWVudCB0byBjb3B5Cj4+Cj4+UnVubmluZyBtdWx0aXBsZSB0aHJlYWRzIGdpdmVzIGRp
bWluaXNoaW5nIG9yIGV2ZW4gd29yc2VuaW5nIHJldHVybnMuCj4+UnVudGltZSBtZXRyaWNzIG9u
IGxvY2sgY29udGVudGlvbiBhbmQgc3RvcmFnZSBidXMgY2FwYWNpdHkgbWF5IGhlbHAKPj5jaG9v
c2luZyB0aGUgbnVtYmVyIG9mIHRocmVhZHMuIEEgc2ltcGxlciBhcHByb2FjaCBtaWdodCBiZSBh
ZGQgbW9yZQo+PnRocmVhZHMgdW50aWwgdGhlIGNvbWJpbmVkIHRocm91Z2hwdXQgaW5jcmVhc2Ug
aXMgbGVzcyB0aGFuIDEwJSBzYXkuCj4+Cj4+Cj4+VGhlICdjb21wYXJlJyB0aGF0IEkgbWVudGlv
biBpcyBiYXNlZCBvbiB0aGUgU0NTSSBWRVJJRlkoQllUQ0hLPTEpIGNvbW1hbmQKPj4ob3IgTlZN
ZSBOVk0gQ29tcGFyZSBjb21tYW5kKS4gVXNpbmcgZGQgbG9naWMsIGEgZGlzayB0byBkaXNrIGNv
bXBhcmUgY2FuCj4+YmUgaW1wbGVtZW50ZWQgd2l0aCBub3QgbXVjaCBtb3JlIHdvcmsgdGhhbiBj
aGFuZ2luZyB0aGUgV1JJVEUgdG8gYSBWRVJJRlkKPj5jb21tYW5kLiBUaGlzIGlzIGEgZGlmZmVy
ZW50IGFwcHJvYWNoIHRvIHRoZSBMaW51eCBjbXAgdXRpbGl0eSB3aGljaAo+PlJFQURzIGluIGJv
dGggc2lkZXMgYW5kIGRvZXMgYSBtZW1jbXAoKSB0eXBlIG9wZXJhdGlvbi4gVXNpbmcgcmFtZGlz
a3MKPj4oZnJvbSB0aGUgc2NzaV9kZWJ1ZyBkcml2ZXIpIHRoZSBjb21wYXJlIG9wZXJhdGlvbiAo
bWF4IH4gMTAgR0Ivcykgd2FzCj4+YWN0dWFsbHkgZmFzdGVyIHRoYW4gdGhlIGNvcHkgKG1heCB+
IDcgR0IvcykuIEkgcHV0IHRoaXMgZG93biB0byBXUklURQo+Pm9wZXJhdGlvbnMgdGFraW5nIGEg
d3JpdGUgbG9jayBvdmVyIHRoZSBzdG9yZSB3aGlsZSB0aGUgVkVSSUZZIG9ubHkKPj5uZWVkcyBh
IHJlYWQgbG9jayBzbyBtYW55IFZFUklGWSBvcGVyYXRpb25zIGNhbiBjby1leGlzdCBvbiB0aGUg
c2FtZQo+PnN0b3JlLiBVbmZvcnR1bmF0ZWx5IG9uIHJlYWwgU0FTIGFuZCBOVk1lIFNTRHMgdGhh
dCBJIHRlc3RlZCB0aGUKPj5wZXJmb3JtYW5jZSBvZiB0aGUgVkVSSUZZIGFuZCBOVk0gQ29tcGFy
ZSBjb21tYW5kcyBpcyB1bmRlcndoZWxtaW5nLgo+PkZvciBjb21wYXJpc29uLCB1c2luZyBzY3Np
X2RlYnVnIHJhbWRpc2tzLCBkZCBjb3B5IHRocm91Z2hwdXQgd2FzCj4+PCAxIEdCL3MgYW5kIGlv
X3VyaW5nLWNwIHdhcyBhcm91bmQgMi0zIEdCL3MuIFRoZSBzeXN0ZW0gd2FzIFJ5emVuCj4+MzYw
MCBiYXNlZC4KPj4KPldoaWNoIGlzIHByZWNpc2VseSBteSBjb25jZXJuLgo+U2ltcGxlIGNvcHkg
bWlnaHQgYmUgZWZmaWNpZW50IGZvciBvbmUgcGFydGljdWxhciBpbXBsZW1lbnRhdGlvbiwgYnV0
IAo+aXQgbWlnaHQgYmUgY29tcGxldGVseSBvZmYgdGhlIGJvYXJkIGZvciBvdGhlcnMuCj5CdXQg
Ym90aCB3aWxsIGJlIGNsYWltaW5nIHRvIHN1cHBvcnQgaXQsIGFuZCB1cyBoYXZpbmcgbm8gaWRl
YSB3aGV0aGVyIAo+Y2hvb3Npbmcgc2ltcGxlIGNvcHkgd2lsbCBzcGVlZCB1cCBtYXR0ZXJzIG9y
IG5vdC4KPldpdGhvdXQgaGF2aW5nIGEgcHJvZ3JhbW1hdGljIHdheSB0byBmaWd1cmUgb3V0IHRo
ZSBzcGVlZCBvZiB0aGUgCj5pbXBsZW1lbnRhdGlvbiB3ZSBoYXZlIHRvIGRldGVjdCB0aGUgcGVy
Zm9ybWFuY2Ugb3Vyc2VsdmVzLCBsaWtlIHRoZSAKPmJlbmNobWFya2luZyBsb29wIFJBSUQ1IGRv
ZXMuCj5JIHdhcyBob3BpbmcgdG8gYXZvaWQgdGhhdCwgYW5kIGp1c3QgYXNrIHRoZSBkZXZpY2Uv
Y29udHJvbGxlcjsgYnV0IAo+dGhhdCB0dXJuZWQgb3V0IHRvIGJlIGluIHZhaW4uCgpJIGJlbGll
dmUgaXQgbWFrZXMgc2Vuc2UgdG8gZG8gZXh0ZW5zaXZlIGNoYXJhY3Rlcml6YXRpb24gdG8gdW5k
ZXJzdGFuZApob3cgdGhlIGhvc3QgYW5kIGRldmljZSBpbXBsZW1lbnRhdGlvbiBiZWhhdmUuIEhv
d2V2ZXIsIEkgZG8gbm90IGJlbGlldmUKd2Ugd2lsbCBnZXQgZmFyIGlmIHRoZSByZXF1aXJlbWVu
dCBpcyB0aGF0IGFueSBhY2NlbGVyYXRpb24gaGFzIHRvCm91dHBlcmZvcm0gdGhlIGxlZ2FjeSBw
YXRoIHVuZGVyIGFsbCBjaXJjdW1zdGFuY2VzIGFuZCBpbXBsZW1lbnRhdGlvbnMuCgpBdCB0aGlz
IG1vbWVudCBpbiB0aW1lLCB0aGlzIGlzIGEgZmVhdHVyZSB2ZXJ5IG11Y2ggdGFyZ2V0ZWQgdG8K
ZWxpbWluYXRpbmcgdGhlIGV4dHJhIHJlYWQvd3JpdGUgdHJhZmZpYyBnZW5lcmF0ZWQgYnkgWk5T
IGhvc3QgR0MuCgpUaGlzIHNhaWQsIHdlIGRvIHNlZSB0aGUgdmFsdWUgaW4gYWxpZ25pbmcgd2l0
aCBleGlzdGluZyBlZmZvcnRzIHRvCm9mZmxvYWQgY29weSB1bmRlciBvdGhlciB1c2UgY2FzZXMs
IHNvIGlmIHlvdSBoYXZlIGEgc2V0IG9mIHRlc3RzIHdlIGNhbgpydW4gdG8gc3BlYWsgdGhlIHNh
bWUgbGFuZ3VhZ2UsIHdlIHdvdWxkIGJlIGhhcHB5IHRvIHRha2UgdGhlbSBhbmQgYWRhcHQKdGhl
bSB0byB0aGUgZmlvIGV4dGVuc2lvbnMgd2UgaGF2ZSBwb3N0ZWQgZm9yIHRlc3RpbmcgdGhpcyB0
b28uCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

