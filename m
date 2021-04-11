Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC35C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:40:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 376286120B
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:40:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 376286120B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-pzmZ3ZcnPAin1vaiRJk9Uw-1; Mon, 12 Apr 2021 03:40:41 -0400
X-MC-Unique: pzmZ3ZcnPAin1vaiRJk9Uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81C65107ACE6;
	Mon, 12 Apr 2021 07:40:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 541CF131FA;
	Mon, 12 Apr 2021 07:40:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E2D081806D16;
	Mon, 12 Apr 2021 07:40:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13BJQnss020440 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 11 Apr 2021 15:26:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63C2534581; Sun, 11 Apr 2021 19:26:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E23A34580
	for <dm-devel@redhat.com>; Sun, 11 Apr 2021 19:26:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B62DA85A5A8
	for <dm-devel@redhat.com>; Sun, 11 Apr 2021 19:26:46 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
	[209.85.128.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-574-r2YHJJzNMfSe4pRbsbpuZg-1; Sun, 11 Apr 2021 15:26:44 -0400
X-MC-Unique: r2YHJJzNMfSe4pRbsbpuZg-1
Received: by mail-wm1-f50.google.com with SMTP id
	o20-20020a05600c4fd4b0290114265518afso5661922wmq.4
	for <dm-devel@redhat.com>; Sun, 11 Apr 2021 12:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=/8TJhA68h/8e3XqwlnCzlH6v3LnaNubb1RVVGCxTa4g=;
	b=RTiXntC5Mn2CovZoQKAtvva6+56oWO4/9+AWa58KQxxPsQ/K7LCG70edcbaN3oUHL0
	qaCqnRSBtFGEIfWpKQsG1NkThHG9s5AF1N2uOBDKSgil4JRS3wpfrV3CI0yKUufsg7Md
	m1Urkd0AZ7/ZFXSs1judbxt4ty0kXTyB9MFuYrlRQJHImD7DndrChBqExbhgUVdLMM4b
	ugD5rhIzPtbfFVJxa4kJQUmxly5ZcQTNzs0Lm9dvWzIaCVlMegUXPPqv7uTfCPM/lm5A
	Dlmgr5DsoEvo8AhLJl3NoLWfcvmxtlV7JZr82Zyorto9bZqIGRNkKyf5cvHNTuD//6gV
	OCQA==
X-Gm-Message-State: AOAM532v4W4rnuw5PTBA8BldUoH2GvK9lcuYFl1J0nf0gXjUNWxZsITP
	tJHV86fJ6uTm2lQQk85ugwZP6g==
X-Google-Smtp-Source: ABdhPJztsA/xwX5L/DoL1oZX+LcVXnIQD+VgkEO9P1o2PIOgshz/wlckdDgYHVifqaAMs+uSrN4kbw==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr23533683wmc.100.1618169203190;
	Sun, 11 Apr 2021 12:26:43 -0700 (PDT)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id d5sm16939244wrx.0.2021.04.11.12.26.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 11 Apr 2021 12:26:42 -0700 (PDT)
Date: Sun, 11 Apr 2021 21:26:41 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <20210411192641.ya6ntxannk3gjyl5@mpHalley.localdomain>
References: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
	<5BE5E1D9-675F-4122-A845-B0A29BB74447@javigon.com>
	<c7848f1c-c2c1-6955-bf20-f413a44f9969@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <c7848f1c-c2c1-6955-bf20-f413a44f9969@nvidia.com>
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
X-Mailman-Approved-At: Mon, 12 Apr 2021 03:36:19 -0400
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	selvajove@gmail.com, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	hch@lst.de, linux-block@vger.kernel.org, kbusch@kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com,
	linux-fsdevel@vger.kernel.org, joshiiitr@gmail.com, nj.shetty@samsung.com
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEuMDQuMjAyMSAxMjoxMCwgTWF4IEd1cnRvdm95IHdyb3RlOgo+Cj5PbiA0LzEwLzIwMjEg
OTozMiBBTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4+T24gMTAgQXByIDIwMjEsIGF0IDAy
LjMwLCBDaGFpdGFueWEgS3Vsa2FybmkgPENoYWl0YW55YS5LdWxrYXJuaUB3ZGMuY29tPiB3cm90
ZToKPj4+Cj4+Pu+7v09uIDQvOS8yMSAxNzoyMiwgTWF4IEd1cnRvdm95IHdyb3RlOgo+Pj4+Pk9u
IDIvMTkvMjAyMSAyOjQ1IFBNLCBTZWx2YUt1bWFyIFMgd3JvdGU6Cj4+Pj4+VGhpcyBwYXRjaHNl
dCB0cmllcyB0byBhZGQgc3VwcG9ydCBmb3IgVFA0MDY1YSAoIlNpbXBsZSBDb3B5IENvbW1hbmQi
KSwKPj4+Pj52MjAyMC4wNS4wNCAoIlJhdGlmaWVkIikKPj4+Pj4KPj4+Pj5UaGUgU3BlY2lmaWNh
dGlvbiBjYW4gYmUgZm91bmQgaW4gZm9sbG93aW5nIGxpbmsuCj4+Pj4+aHR0cHM6Ly9udm1leHBy
ZXNzLm9yZy93cC1jb250ZW50L3VwbG9hZHMvTlZNLUV4cHJlc3MtMS40LVJhdGlmaWVkLVRQcy0x
LnppcAo+Pj4+Pgo+Pj4+PlNpbXBsZSBjb3B5IGNvbW1hbmQgaXMgYSBjb3B5IG9mZmxvYWRpbmcg
b3BlcmF0aW9uIGFuZCBpcyAgdXNlZCB0byBjb3B5Cj4+Pj4+bXVsdGlwbGUgY29udGlndW91cyBy
YW5nZXMgKHNvdXJjZV9yYW5nZXMpIG9mIExCQSdzIHRvIGEgc2luZ2xlIGRlc3RpbmF0aW9uCj4+
Pj4+TEJBIHdpdGhpbiB0aGUgZGV2aWNlIHJlZHVjaW5nIHRyYWZmaWMgYmV0d2VlbiBob3N0IGFu
ZCBkZXZpY2UuCj4+Pj4+Cj4+Pj4+VGhpcyBpbXBsZW1lbnRhdGlvbiBkb2Vzbid0IGFkZCBuYXRp
dmUgY29weSBvZmZsb2FkIHN1cHBvcnQgZm9yIHN0YWNrZWQKPj4+Pj5kZXZpY2VzIHJhdGhlciBj
b3B5IG9mZmxvYWQgaXMgZG9uZSB0aHJvdWdoIGVtdWxhdGlvbi4gUG9zc2libGUgdXNlCj4+Pj4+
Y2FzZXMgYXJlIEYyRlMgZ2MgYW5kIEJUUkZTIHJlbG9jYXRpb24vYmFsYW5jZS4KPj4+Pj4KPj4+
Pj4qYmxrZGV2X2lzc3VlX2NvcHkqIHRha2VzIHNvdXJjZSBiZGV2LCBubyBvZiBzb3VyY2VzLCBh
cnJheSBvZiBzb3VyY2UKPj4+Pj5yYW5nZXMgKGluIHNlY3RvcnMpLCBkZXN0aW5hdGlvbiBiZGV2
IGFuZCBkZXN0aW5hdGlvbiBvZmZzZXQoaW4gc2VjdG9ycykuCj4+Pj4+SWYgYm90aCBzb3VyY2Ug
YW5kIGRlc3RpbmF0aW9uIGJsb2NrIGRldmljZXMgYXJlIHNhbWUgYW5kIGNvcHlfb2ZmbG9hZCA9
IDEsCj4+Pj4+dGhlbiBjb3B5IGlzIGRvbmUgdGhyb3VnaCBuYXRpdmUgY29weSBvZmZsb2FkaW5n
LiBDb3B5IGVtdWxhdGlvbiBpcyB1c2VkCj4+Pj4+aW4gb3RoZXIgY2FzZXMuCj4+Pj4+Cj4+Pj4+
QXMgU0NTSSBYQ09QWSBjYW4gdGFrZSB0d28gZGlmZmVyZW50IGJsb2NrIGRldmljZXMgYW5kIG5v
IG9mIHNvdXJjZSByYW5nZSBpcwo+Pj4+PmVxdWFsIHRvIDEsIHRoaXMgaW50ZXJmYWNlIGNhbiBi
ZSBleHRlbmRlZCBpbiBmdXR1cmUgdG8gc3VwcG9ydCBTQ1NJIFhDT1BZLgo+Pj4+QW55IGlkZWEg
d2h5IHRoaXMgVFAgd2Fzbid0IGRlc2lnbmVkIGZvciBjb3B5IG9mZmxvYWQgYmV0d2VlbiAyCj4+
Pj5kaWZmZXJlbnQgbmFtZXNwYWNlcyBpbiB0aGUgc2FtZSBjb250cm9sbGVyID8KPj4+WWVzLCBp
dCB3YXMgdGhlIGZpcnN0IGF0dGVtcHQgc28gdG8ga2VlcCBpdCBzaW1wbGUuCj4+Pgo+Pj5GdXJ0
aGVyIHdvcmsgaXMgbmVlZGVkIHRvIGFkZCBpbmNyZW1lbnRhbCBUUCBzbyB0aGF0IHdlIGNhbiBh
bHNvIGRvIGEgY29weQo+Pj5iZXR3ZWVuIHRoZSBuYW1lLXNwYWNlcyBvZiBzYW1lIGNvbnRyb2xs
ZXIgKGlmIHdlIGNhbid0IGFscmVhZHkpIGFuZCB0byB0aGUKPj4+bmFtZXNwYWNlcyB0aGF0IGJl
bG9uZ3MgdG8gdGhlIGRpZmZlcmVudCBjb250cm9sbGVyLgo+Pj4KPj4+PkFuZCBhIHNpbXBsZSBj
b3B5IHdpbGwgYmUgdGhlIGNhc2Ugd2hlcmUgdGhlIHNyY19uc2lkID09IGRzdF9uc2lkID8KPj4+
Pgo+Pj4+QWxzbyB3aHkgdGhlcmUgYXJlIG11bHRpcGxlIHNvdXJjZSByYW5nZXMgYW5kIG9ubHkg
b25lIGRzdCByYW5nZSA/IFdlCj4+Pj5jb3VsZCBhZGQgYSBiaXQgdG8gaW5kaWNhdGUgaWYgdGhp
cyByYW5nZSBpcyBzcmMgb3IgZHN0Li4KPj5PbmUgb2YgdGhlIHRhcmdldCB1c2UgY2FzZXMgd2Fz
IFpOUyBpbiBvcmRlciB0byBhdm9pZCBmYWJyaWMgdHJhbnNmZXJzIGR1cmluZyBob3N0IEdDLiBZ
b3UgY2FuIHNlZSBob3cgdGhpcyBwbGF5cyB3ZWxsIHdpdGggc2V2ZXJhbCB6b25lIHJhbmdlcyBh
bmQgYSBzaW5nbGUgem9uZSBkZXN0aW5hdGlvbi4KPj4KPj5JZiB3ZSBzdGFydCBnZXR0aW5nIHN1
cHBvcnQgaW4gTGludXggdGhyb3VnaCB0aGUgZGlmZmVyZW50IHBhc3QgY29weSBvZmZsb2FkIGVm
Zm9ydHMsIEnigJltIHN1cmUgd2UgY2FuIGV4dGVuZCB0aGlzIFRQIGluIHRoZSBmdXR1cmUuCj4K
PkJ1dCB0aGUgImNvcHkiIGNvbW1hbmQgSU1PIGlzIG1vcmUgZ2VuZXJhbCB0aGFuIHRoZSBaTlMg
R0MgY2FzZSwgdGhhdCAKPmNhbiBiZSBhIHByaXZhdGUgY2FzZSBvZiBjb3B5LCBpc24ndCBpdCA/
CgpJdCBhcHBsaWVzIHRvIGFueSBuYW1lc3BhY2UgdHlwZSwgc28geWVzLiBJIGp1c3Qgd2FudGVk
IHRvIGdpdmUgeW91IHRoZQpiYWNrZ3JvdW5kIGZvciB0aGUgY3VycmVudCAic2ltcGxlIiBzY29w
ZSB0aHJvdWdoIG9uZSBvZiB0aGUgdXNlIGNhc2VzCnRoYXQgd2FzIGluIG1pbmQuCgo+V2UgY2Fu
IGdldCBhIGJpZyBiZW5lZml0IG9mIG9mZmxvYWRpbmcgdGhlIGRhdGEgY29weSBmcm9tIG9uZSBu
cyB0byAKPmFub3RoZXIgaW4gdGhlIHNhbWUgY29udHJvbGxlciBhbmQgZXZlbiBpbiBkaWZmZXJl
bnQgY29udHJvbGxlcnMgaW4gCj50aGUgc2FtZSBzdWJzeXN0ZW0uCgpEZWZpbml0ZWx5LgoKPgo+
RG8geW91IHRoaW5rIHRoZSBleHRlbnNpb24gc2hvdWxkIGJlIHRvICJjb3B5IiBjb21tYW5kIG9y
IHRvIGNyZWF0ZSBhIAo+bmV3IGNvbW1hbmQgInhfY29weSIgZm9yIGNvcHlpbmcgdG8gZGlmZmVy
ZW50IGRlc3RpbmF0aW9uIG5zID8KCkkgYmVsaWV2ZSB0aGVyZSBpcyBzcGFjZSBmb3IgZXh0ZW5z
aW9ucyB0byBzaW1wbGUgY29weS4gQnV0IGdpdmVuIHRoZQpleHBlcmllbmNlIHdpdGggWENPUFks
IEkgY2FuIGltYWdpbmUgdGhhdCBjaGFuZ2VzIHdpbGwgYmUgaW5jcmVtZW50YWwsCmJhc2VkIG9u
IHZlcnkgc3BlY2lmaWMgdXNlIGNhc2VzLgoKSSB0aGluayBnZXR0aW5nIHN1cHBvcnQgdXBzdHJl
YW0gYW5kIGJyaW5naW5nIGRlcGxveWVkIGNhc2VzIGlzIGEgdmVyeQpnb29kIHN0YXJ0LgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

