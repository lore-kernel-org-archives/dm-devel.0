Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E1EC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:11:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF15E6112F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF15E6112F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-KPBYIh2IOlWctrmy5HRHEw-1; Fri, 29 Oct 2021 07:11:51 -0400
X-MC-Unique: KPBYIh2IOlWctrmy5HRHEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FB4619200D0;
	Fri, 29 Oct 2021 11:11:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EB5778307;
	Fri, 29 Oct 2021 11:11:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C503F1806D04;
	Fri, 29 Oct 2021 11:11:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19T8GELU013581 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 04:16:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6214740C1242; Fri, 29 Oct 2021 08:16:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E1F1400F3E5
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 08:16:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43AC3811E7A
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 08:16:14 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
	[209.85.128.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-Zm56HQQ0OY-YxkMABhEkGg-1; Fri, 29 Oct 2021 04:16:11 -0400
X-MC-Unique: Zm56HQQ0OY-YxkMABhEkGg-1
Received: by mail-wm1-f44.google.com with SMTP id
	z11-20020a1c7e0b000000b0030db7b70b6bso11860249wmc.1
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 01:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=+A2GKLI9DhSLswhTJfVeFD3Ahs1nltZEg2bN0VulWy8=;
	b=8JahXqTmIc9WYIqT3x78T2fJyzkHRdlS+sBDdCOMSeRK3fszna7U/wj3+rkNdoPJzP
	HGTi5UKAl+/1F97TtAGVKkJlFpPyM0NT+fGCdQUuTw1NrOZpDozsKXF7ltFPUOhxLEmd
	M30WiI54ZKTaU2F/XG4t1AjvU/NPb3KQEiPBAIO6gha1/YGwH7nJDdfmTQjrOchHqX83
	8e9ODGJ9+s5Bu0vq2yQRD/F/21O33fp3n/tA/YN3VJXiU3IhQ/XzgiIRFvQRBNDbcvri
	Pcb+364bRSCxPvC6Bt5fzruSJP0SqdRiA7ETmXE0qdAoFvOwtILxyfcS0OamfzZLd5vv
	yiHA==
X-Gm-Message-State: AOAM531SS/i00IEzMO0wl4PIDlF09WHGZEzs0uHI6j6dLFDs67+vtkqJ
	3g4n6cdMoKnsY1JWQgD64SUQ9A==
X-Google-Smtp-Source: ABdhPJxEYoo56lOQFgqbHz0cJdbenOnmGMwhPleHbo+aaGvg342CUYI8ey6L6o22+/T2Kqj82W+gKA==
X-Received: by 2002:a1c:2507:: with SMTP id l7mr10125921wml.144.1635495370273; 
	Fri, 29 Oct 2021 01:16:10 -0700 (PDT)
Received: from localhost (5.186.124.144.cgn.fibianet.dk. [5.186.124.144])
	by smtp.gmail.com with ESMTPSA id i3sm7380661wmq.18.2021.10.29.01.16.09
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 29 Oct 2021 01:16:09 -0700 (PDT)
Date: Fri, 29 Oct 2021 10:16:09 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20211029081609.obt7ssqxd3aotnum@ArmHalley.local>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
MIME-Version: 1.0
In-Reply-To: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
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
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
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

T24gMjkuMTAuMjAyMSAwNzo1MSwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+T24gMTAvMjkvMjEg
MjoyMSBBTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+Pk9uIDEwLzcvMjEgMTE6NDkgUE0s
IEphdmllciBHb256w6FsZXogd3JvdGU6Cj4+PkV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBv
cGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzCj4+Pgo+Pj4KPj4+T24gMDYuMTAuMjAyMSAxMDoz
MywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+Pj4+T24gMTAvNi8yMSAzOjA1IEFNLCBKYXZpZXIg
R29uesOhbGV6IHdyb3RlOgo+Pj4+PkkgYWdyZWUgdGhhdCB0aGUgdG9waWMgaXMgY29tcGxleC4g
SG93ZXZlciwgd2UgaGF2ZSBub3QgYmVlbiBhYmxlIHRvCj4+Pj4+ZmluZCBhIGNsZWFyIHBhdGgg
Zm9yd2FyZCBpbiB0aGUgbWFpbGluZyBsaXN0Lgo+Pj4+Cj4+Pj5IbW0gLi4uIHJlYWxseT8gQXQg
bGVhc3QgTWFydGluIFBldGVyc2VuIGFuZCBJIGNvbnNpZGVyIGRldmljZSBtYXBwZXIKPj4+PnN1
cHBvcnQgZXNzZW50aWFsLiBIb3cgYWJvdXQgc3RhcnRpbmcgZnJvbSBNaWt1bGFzJyBwYXRjaCBz
ZXJpZXMgdGhhdAo+Pj4+c3VwcG9ydHMgdGhlIGRldmljZSBtYXBwZXI/IFNlZSBhbHNvCj4+Pj5o
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYWxwaW5lLkxSSC4yLjAyLjIxMDgxNzE2MzAxMjAu
MzAzNjNAZmlsZTAxLmludHJhbmV0LnByb2QuaW50LnJkdTIucmVkaGF0LmNvbS8KPj4+Pgo+Pgo+
PldoZW4gd2UgYWRkIGEgbmV3IFJFUV9PUF9YWFggd2UgbmVlZCB0byBtYWtlIHN1cmUgaXQgd2ls
bCB3b3JrIHdpdGgKPj5kZXZpY2UgbWFwcGVyLCBzbyBJIGFncmVlIHdpdGggQmFydCBhbmQgTWFy
dGluLgo+Pgo+PlN0YXJ0aW5nIHdpdGggTWlrdWxhcyBwYXRjaGVzIGlzIGEgcmlnaHQgZGlyZWN0
aW9uIGFzIG9mIG5vdy4uCj4+Cj4+Pgo+Pj5UaGFua3MgZm9yIHRoZSBwb2ludGVycy4gV2UgYXJl
IGxvb2tpbmcgaW50byBNaWt1bGFzJyBwYXRjaCAtIEkgYWdyZWUKPj4+dGhhdCBpdCBpcyBhIGdv
b2Qgc3RhcnQuCj4+Pgo+Pj4+PldoYXQgZG8geW91IHRoaW5rIGFib3V0IGpvaW5pbmcgdGhlIGNh
bGwgdG8gdGFsayB2ZXJ5IHNwZWNpZmljIG5leHQKPj4+Pj5zdGVwcyB0byBnZXQgYSBwYXRjaHNl
dCB0aGF0IHdlIGNhbiBzdGFydCByZXZpZXdpbmcgaW4gZGV0YWlsLgo+Pj4+Cj4+Pj5JIGNhbiBk
byB0aGF0Lgo+Pj4KPj4+VGhhbmtzLiBJIHdpbGwgd2FpdCB1bnRpbCBDaGFpdGFueWEncyByZXBs
eSBvbiBoaXMgcXVlc3Rpb25zLiBXZSB3aWxsCj4+PnN0YXJ0IHN1Z2dlc3Rpbmcgc29tZSBkYXRl
cyB0aGVuLgo+Pj4KPj4KPj5JIHRoaW5rIGF0IHRoaXMgcG9pbnQgd2UgbmVlZCB0byBhdCBsZWFz
dCBkZWNpZGUgb24gaGF2aW5nIGEgZmlyc3QgY2FsbAo+PmZvY3VzZWQgb24gaG93IHRvIHByb2Nl
ZWQgZm9yd2FyZCB3aXRoIE1pa3VsYXMgYXBwcm9hY2ggIC4uLgo+Pgo+PkphdmllciwgY2FuIHlv
dSBwbGVhc2Ugb3JnYW5pemUgYSBjYWxsIHdpdGggcGVvcGxlIHlvdSBsaXN0ZWQgaW4gdGhpcwo+
PnRocmVhZCBlYXJsaWVyID8KPj4KPkFsc28gS2VpdGggcHJlc2VudGVkIGhpcyB3b3JrIG9uIGEg
c2ltcGxlIHpvbmUtYmFzZWQgcmVtYXBwaW5nIGJsb2NrIAo+ZGV2aWNlLCB3aGljaCBpbmNsdWRl
ZCBhbiBpbi1rZXJuZWwgY29weSBvZmZsb2FkIGZhY2lsaXR5Lgo+SWRlYSBpcyB0byBsaWZ0IHRo
YXQgYXMgYSBzdGFuZGFsb25lIHBhdGNoIHN1Y2ggdGhhdCB3ZSBjYW4gdXNlIGl0IGEgCj5mYWxs
YmFjayAoaWUgc29mdHdhcmUpIGltcGxlbWVudGF0aW9uIGlmIG5vIG90aGVyIGNvcHkgb2ZmbG9h
ZCAKPm1lY2hhbmlzbSBpcyBhdmFpbGFibGUuCj4KCkkgYmVsaWV2ZSB0aGlzIGlzIGluIGVzc2Vu
Y2Ugd2hhdCB3ZSBhcmUgdHJ5aW5nIHRvIGNvbnZleSBoZXJlOiBhCm1pbmltYWwgcGF0Y2hzZXQg
dGhhdCBlbmFibGVzIFNpbXBsZSBDb3B5IGFuZCB0aGUgaW5mcmEgYXJvdW5kIHRvIGV4dGVuZApj
b3B5LW9mZmxvYWQgdXNlLWNhc2VzLgoKSSBsb29rIGZvcndhcmQgdG8gaGVhciBLZWl0aCdzIGlk
ZWFzIGFyb3VuZCB0aGlzIQoKSmF2aWVyCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs

