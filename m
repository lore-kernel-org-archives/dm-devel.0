Return-Path: <SRS0=OBV6=JL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7C2C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:15:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B2641613A9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2641613A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-6dXeCsRbNli6cn9T1_sA7A-1; Wed, 14 Apr 2021 04:14:57 -0400
X-MC-Unique: 6dXeCsRbNli6cn9T1_sA7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18D3181744F;
	Wed, 14 Apr 2021 08:14:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 210115946E;
	Wed, 14 Apr 2021 08:14:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 759FB44A5B;
	Wed, 14 Apr 2021 08:14:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13DIQ6Cf029812 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 13 Apr 2021 14:26:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0F724203660A; Tue, 13 Apr 2021 18:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A1632036600
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 18:26:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D336100DE77
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 18:26:03 +0000 (UTC)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
	[209.85.208.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-547-PzqHeKTjNF2npymDA6g0Pg-1; Tue, 13 Apr 2021 14:26:00 -0400
X-MC-Unique: PzqHeKTjNF2npymDA6g0Pg-1
Received: by mail-ed1-f49.google.com with SMTP id s15so20528813edd.4
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 11:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=gUmzsxIe9Usd79B4Ol6Ovwj7y0RVrVcb5f5DujLhjr4=;
	b=nClIJBTxujN9xz3EpnOSBb658L0T3H+lXRWATDELnqeOodysvWJPTIYWQhOkGlE7ay
	bDAZpUjcZBsSSjR95J8Gur4z74Iib3bkhIwLlEoBixC5/UizC/Yu0k0F2vVDAK4OkOZc
	UGzl64PmiCFsYsOCKfUcg0OEx1jtmaPOXClhsea3iPGUYCGujGINFMhAQ3ymoAHAJKQN
	ChMYj8WvpvIxxPoc2R7CwT4FyE2N7FqBRTdwaCd7zxDRd4NGHwcjyCCNlxDKCQnMm5jY
	YwjZmyDawSjhS0EWO9eCg1hVjbxvdEIuPHeTx3KBPRv9zpSzii0NnZYhkXA7wd7iCj03
	cJHA==
X-Gm-Message-State: AOAM5303l/E0DT2Ida4S7vJ3k3clbQ+ZgRW58CqOG071llhiJirNmJS7
	dziLlvqJCSwoSfEUPYuokUkfEw==
X-Google-Smtp-Source: ABdhPJy7SvyslbxUDaNLIDv1BBMpbhsvXcAeoi5qDTCEQdBe4vv+UqkCJh1ZRD5tvlU1eL4u4IyrjA==
X-Received: by 2002:a05:6402:35cd:: with SMTP id
	z13mr36855014edc.21.1618338359704; 
	Tue, 13 Apr 2021 11:25:59 -0700 (PDT)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id g20sm181363edu.91.2021.04.13.11.25.59
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 13 Apr 2021 11:25:59 -0700 (PDT)
Date: Tue, 13 Apr 2021 20:25:58 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <20210413182558.v2lynge6aleazgbv@mpHalley.localdomain>
References: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
	<5BE5E1D9-675F-4122-A845-B0A29BB74447@javigon.com>
	<c7848f1c-c2c1-6955-bf20-f413a44f9969@nvidia.com>
	<20210411192641.ya6ntxannk3gjyl5@mpHalley.localdomain>
	<3a52cc06-27ce-96a4-b180-60fc269719ba@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <3a52cc06-27ce-96a4-b180-60fc269719ba@nvidia.com>
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
X-Mailman-Approved-At: Wed, 14 Apr 2021 04:14:49 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTMuMDQuMjAyMSAxODozOCwgTWF4IEd1cnRvdm95IHdyb3RlOgo+Cj5PbiA0LzExLzIwMjEg
MTA6MjYgUE0sIEphdmllciBHb256w6FsZXogd3JvdGU6Cj4+T24gMTEuMDQuMjAyMSAxMjoxMCwg
TWF4IEd1cnRvdm95IHdyb3RlOgo+Pj4KPj4+T24gNC8xMC8yMDIxIDk6MzIgQU0sIEphdmllciBH
b256w6FsZXogd3JvdGU6Cj4+Pj4+T24gMTAgQXByIDIwMjEsIGF0IDAyLjMwLCBDaGFpdGFueWEg
S3Vsa2FybmkgCj4+Pj4+PENoYWl0YW55YS5LdWxrYXJuaUB3ZGMuY29tPiB3cm90ZToKPj4+Pj4K
Pj4+Pj7vu79PbiA0LzkvMjEgMTc6MjIsIE1heCBHdXJ0b3ZveSB3cm90ZToKPj4+Pj4+Pk9uIDIv
MTkvMjAyMSAyOjQ1IFBNLCBTZWx2YUt1bWFyIFMgd3JvdGU6Cj4+Pj4+Pj5UaGlzIHBhdGNoc2V0
IHRyaWVzIHRvIGFkZCBzdXBwb3J0IGZvciBUUDQwNjVhICgiU2ltcGxlIAo+Pj4+Pj4+Q29weSBD
b21tYW5kIiksCj4+Pj4+Pj52MjAyMC4wNS4wNCAoIlJhdGlmaWVkIikKPj4+Pj4+Pgo+Pj4+Pj4+
VGhlIFNwZWNpZmljYXRpb24gY2FuIGJlIGZvdW5kIGluIGZvbGxvd2luZyBsaW5rLgo+Pj4+Pj4+
aHR0cHM6Ly9udm1leHByZXNzLm9yZy93cC1jb250ZW50L3VwbG9hZHMvTlZNLUV4cHJlc3MtMS40
LVJhdGlmaWVkLVRQcy0xLnppcAo+Pj4+Pj4+Cj4+Pj4+Pj4KPj4+Pj4+PlNpbXBsZSBjb3B5IGNv
bW1hbmQgaXMgYSBjb3B5IG9mZmxvYWRpbmcgb3BlcmF0aW9uIGFuZCBpc8KgIAo+Pj4+Pj4+dXNl
ZCB0byBjb3B5Cj4+Pj4+Pj5tdWx0aXBsZSBjb250aWd1b3VzIHJhbmdlcyAoc291cmNlX3Jhbmdl
cykgb2YgTEJBJ3MgdG8gYSAKPj4+Pj4+PnNpbmdsZSBkZXN0aW5hdGlvbgo+Pj4+Pj4+TEJBIHdp
dGhpbiB0aGUgZGV2aWNlIHJlZHVjaW5nIHRyYWZmaWMgYmV0d2VlbiBob3N0IGFuZCBkZXZpY2Uu
Cj4+Pj4+Pj4KPj4+Pj4+PlRoaXMgaW1wbGVtZW50YXRpb24gZG9lc24ndCBhZGQgbmF0aXZlIGNv
cHkgb2ZmbG9hZCAKPj4+Pj4+PnN1cHBvcnQgZm9yIHN0YWNrZWQKPj4+Pj4+PmRldmljZXMgcmF0
aGVyIGNvcHkgb2ZmbG9hZCBpcyBkb25lIHRocm91Z2ggZW11bGF0aW9uLiBQb3NzaWJsZSB1c2UK
Pj4+Pj4+PmNhc2VzIGFyZSBGMkZTIGdjIGFuZCBCVFJGUyByZWxvY2F0aW9uL2JhbGFuY2UuCj4+
Pj4+Pj4KPj4+Pj4+PipibGtkZXZfaXNzdWVfY29weSogdGFrZXMgc291cmNlIGJkZXYsIG5vIG9m
IHNvdXJjZXMsIAo+Pj4+Pj4+YXJyYXkgb2Ygc291cmNlCj4+Pj4+Pj5yYW5nZXMgKGluIHNlY3Rv
cnMpLCBkZXN0aW5hdGlvbiBiZGV2IGFuZCBkZXN0aW5hdGlvbiAKPj4+Pj4+Pm9mZnNldChpbiBz
ZWN0b3JzKS4KPj4+Pj4+PklmIGJvdGggc291cmNlIGFuZCBkZXN0aW5hdGlvbiBibG9jayBkZXZp
Y2VzIGFyZSBzYW1lIGFuZCAKPj4+Pj4+PmNvcHlfb2ZmbG9hZCA9IDEsCj4+Pj4+Pj50aGVuIGNv
cHkgaXMgZG9uZSB0aHJvdWdoIG5hdGl2ZSBjb3B5IG9mZmxvYWRpbmcuIENvcHkgCj4+Pj4+Pj5l
bXVsYXRpb24gaXMgdXNlZAo+Pj4+Pj4+aW4gb3RoZXIgY2FzZXMuCj4+Pj4+Pj4KPj4+Pj4+PkFz
IFNDU0kgWENPUFkgY2FuIHRha2UgdHdvIGRpZmZlcmVudCBibG9jayBkZXZpY2VzIGFuZCBubyAK
Pj4+Pj4+Pm9mIHNvdXJjZSByYW5nZSBpcwo+Pj4+Pj4+ZXF1YWwgdG8gMSwgdGhpcyBpbnRlcmZh
Y2UgY2FuIGJlIGV4dGVuZGVkIGluIGZ1dHVyZSB0byAKPj4+Pj4+PnN1cHBvcnQgU0NTSSBYQ09Q
WS4KPj4+Pj4+QW55IGlkZWEgd2h5IHRoaXMgVFAgd2Fzbid0IGRlc2lnbmVkIGZvciBjb3B5IG9m
ZmxvYWQgYmV0d2VlbiAyCj4+Pj4+PmRpZmZlcmVudCBuYW1lc3BhY2VzIGluIHRoZSBzYW1lIGNv
bnRyb2xsZXIgPwo+Pj4+PlllcywgaXQgd2FzIHRoZSBmaXJzdCBhdHRlbXB0IHNvIHRvIGtlZXAg
aXQgc2ltcGxlLgo+Pj4+Pgo+Pj4+PkZ1cnRoZXIgd29yayBpcyBuZWVkZWQgdG8gYWRkIGluY3Jl
bWVudGFsIFRQIHNvIHRoYXQgd2UgY2FuIAo+Pj4+PmFsc28gZG8gYSBjb3B5Cj4+Pj4+YmV0d2Vl
biB0aGUgbmFtZS1zcGFjZXMgb2Ygc2FtZSBjb250cm9sbGVyIChpZiB3ZSBjYW4ndCAKPj4+Pj5h
bHJlYWR5KSBhbmQgdG8gdGhlCj4+Pj4+bmFtZXNwYWNlcyB0aGF0IGJlbG9uZ3MgdG8gdGhlIGRp
ZmZlcmVudCBjb250cm9sbGVyLgo+Pj4+Pgo+Pj4+Pj5BbmQgYSBzaW1wbGUgY29weSB3aWxsIGJl
IHRoZSBjYXNlIHdoZXJlIHRoZSBzcmNfbnNpZCA9PSBkc3RfbnNpZCA/Cj4+Pj4+Pgo+Pj4+Pj5B
bHNvIHdoeSB0aGVyZSBhcmUgbXVsdGlwbGUgc291cmNlIHJhbmdlcyBhbmQgb25seSBvbmUgZHN0
IHJhbmdlID8gV2UKPj4+Pj4+Y291bGQgYWRkIGEgYml0IHRvIGluZGljYXRlIGlmIHRoaXMgcmFu
Z2UgaXMgc3JjIG9yIGRzdC4uCj4+Pj5PbmUgb2YgdGhlIHRhcmdldCB1c2UgY2FzZXMgd2FzIFpO
UyBpbiBvcmRlciB0byBhdm9pZCBmYWJyaWMgCj4+Pj50cmFuc2ZlcnMgZHVyaW5nIGhvc3QgR0Mu
IFlvdSBjYW4gc2VlIGhvdyB0aGlzIHBsYXlzIHdlbGwgd2l0aCAKPj4+PnNldmVyYWwgem9uZSBy
YW5nZXMgYW5kIGEgc2luZ2xlIHpvbmUgZGVzdGluYXRpb24uCj4+Pj4KPj4+PklmIHdlIHN0YXJ0
IGdldHRpbmcgc3VwcG9ydCBpbiBMaW51eCB0aHJvdWdoIHRoZSBkaWZmZXJlbnQgcGFzdCAKPj4+
PmNvcHkgb2ZmbG9hZCBlZmZvcnRzLCBJ4oCZbSBzdXJlIHdlIGNhbiBleHRlbmQgdGhpcyBUUCBp
biB0aGUgCj4+Pj5mdXR1cmUuCj4+Pgo+Pj5CdXQgdGhlICJjb3B5IiBjb21tYW5kIElNTyBpcyBt
b3JlIGdlbmVyYWwgdGhhbiB0aGUgWk5TIEdDIGNhc2UsIAo+Pj50aGF0IGNhbiBiZSBhIHByaXZh
dGUgY2FzZSBvZiBjb3B5LCBpc24ndCBpdCA/Cj4+Cj4+SXQgYXBwbGllcyB0byBhbnkgbmFtZXNw
YWNlIHR5cGUsIHNvIHllcy4gSSBqdXN0IHdhbnRlZCB0byBnaXZlIHlvdSB0aGUKPj5iYWNrZ3Jv
dW5kIGZvciB0aGUgY3VycmVudCAic2ltcGxlIiBzY29wZSB0aHJvdWdoIG9uZSBvZiB0aGUgdXNl
IGNhc2VzCj4+dGhhdCB3YXMgaW4gbWluZC4KPj4KPj4+V2UgY2FuIGdldCBhIGJpZyBiZW5lZml0
IG9mIG9mZmxvYWRpbmcgdGhlIGRhdGEgY29weSBmcm9tIG9uZSBucyAKPj4+dG8gYW5vdGhlciBp
biB0aGUgc2FtZSBjb250cm9sbGVyIGFuZCBldmVuIGluIGRpZmZlcmVudCAKPj4+Y29udHJvbGxl
cnMgaW4gdGhlIHNhbWUgc3Vic3lzdGVtLgo+Pgo+PkRlZmluaXRlbHkuCj4+Cj4+Pgo+Pj5EbyB5
b3UgdGhpbmsgdGhlIGV4dGVuc2lvbiBzaG91bGQgYmUgdG8gImNvcHkiIGNvbW1hbmQgb3IgdG8g
Cj4+PmNyZWF0ZSBhIG5ldyBjb21tYW5kICJ4X2NvcHkiIGZvciBjb3B5aW5nIHRvIGRpZmZlcmVu
dCBkZXN0aW5hdGlvbiAKPj4+bnMgPwo+Pgo+PkkgYmVsaWV2ZSB0aGVyZSBpcyBzcGFjZSBmb3Ig
ZXh0ZW5zaW9ucyB0byBzaW1wbGUgY29weS4gQnV0IGdpdmVuIHRoZQo+PmV4cGVyaWVuY2Ugd2l0
aCBYQ09QWSwgSSBjYW4gaW1hZ2luZSB0aGF0IGNoYW5nZXMgd2lsbCBiZSBpbmNyZW1lbnRhbCwK
Pj5iYXNlZCBvbiB2ZXJ5IHNwZWNpZmljIHVzZSBjYXNlcy4KPj4KPj5JIHRoaW5rIGdldHRpbmcg
c3VwcG9ydCB1cHN0cmVhbSBhbmQgYnJpbmdpbmcgZGVwbG95ZWQgY2FzZXMgaXMgYSB2ZXJ5Cj4+
Z29vZCBzdGFydC4KPgo+Q29weWluZyBkYXRhIChmaWxlcykgd2l0aGluIHRoZSBjb250cm9sbGVy
L3N1YnN5c3RlbSBmcm9tIG5zX0EgdG8gbnNfQiAKPnVzaW5nIE5WTWYgd2lsbCByZWR1Y2UgbmV0
d29yayBCVyBhbmQgbWVtb3J5IEJXIGluIHRoZSBob3N0IHNlcnZlci4KPgo+VGhpcyBmZWF0dXJl
IGlzIHdlbGwga25vd24gYW5kIHRoZSB1c2UgY2FzZSBpcyB3ZWxsIGtub3duLgoKRGVmaW5pdGVs
eS4KCj4KPlRoZSBxdWVzdGlvbiB3aGV0aGVyIHdlIGltcGxlbWVudCBpdCBpbiB2ZW5kb3Igc3Bl
Y2lmaWMgbWFubmVyIG9mIHdlIAo+YWRkIGl0IHRvIHRoZSBzcGVjaWZpY2F0aW9uLgo+Cj5JIHBy
ZWZlciBhZGRpbmcgaXQgdG8gdGhlIHNwZWMgOikKCkFncmVlLiBMZXQncyBidWlsZCB1cCBvbiB0
b3Agb2YgU2ltcGxlIENvcHkuIFdlIGNhbiB0YWxrIGFib3V0IGl0Cm9mZmxpbmUgaW4gdGhlIGNv
bnRleHQgb2YgdGhlIE5WTWUgVFdHLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==

