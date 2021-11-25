Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153C5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 16:29:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-268-DGChH8uFPIKJd4_PTlwLDw-1; Thu, 25 Nov 2021 11:28:58 -0500
X-MC-Unique: DGChH8uFPIKJd4_PTlwLDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EABBD102CC54;
	Thu, 25 Nov 2021 16:28:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD719100164A;
	Thu, 25 Nov 2021 16:28:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA7B21809C8A;
	Thu, 25 Nov 2021 16:28:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1APGSl0a017178 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Nov 2021 11:28:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E2D4540CFD12; Thu, 25 Nov 2021 16:28:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB813400DFBC
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 16:28:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF80180A0B3
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 16:28:46 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-529-fsA-Jk-gNmWMCX-oxU8wFQ-1; Thu, 25 Nov 2021 11:28:43 -0500
X-MC-Unique: fsA-Jk-gNmWMCX-oxU8wFQ-1
Received: by mail-wr1-f42.google.com with SMTP id a18so12810984wrn.6;
	Thu, 25 Nov 2021 08:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:from:to:cc:references:message-id:date
	:user-agent:mime-version:in-reply-to:content-transfer-encoding
	:content-language;
	bh=lyY8vrpQYTPMmqv9qPyqZTymKet8W1tg+ZPRZv53qdw=;
	b=pz1hMfRcwPGntXlqK9nabjnTsvsUeh5pzQCa8RBQR1M2t9NuHD8I1CH+Bxnk+UIsb3
	4w5WJdT2lCM72d6sMyV0s9wHbxysFncKW/Xjc6pP89+Lxjd50gdx6KiDiTEji+2x+Nie
	e6CRpupmu8FzAqqvjqNxy1EKewJOJyaA/0K2YFywL2D8NoT84kJ2DH/BuQM4mvAE0AhW
	QQ6yzQjneUjMPUkOR3ABNGuKxoUAir7QiUMeg0rjhdIvoT78RlotoBrzMWl0KMf2ZmSL
	vZDe3Z9iYmJZKGqLAC6Fyy4js88QXRkjAOuarsF+ywdQJL4kERrqSW+in67/HcJ3tAi6
	GB7g==
X-Gm-Message-State: AOAM530i6shXOsVaWESLuRRmeKpV1yGEj+8KKtrV6W7HDEN0KeCw7rwA
	0WSK+4F/gUtwt9nlxMgg2fEui5ym34OORqWN
X-Google-Smtp-Source: ABdhPJzItRkYMMhjrbZbAvxUfpVx7I3FJZ/Hq+UTwdc4elgUlDo0UsOWRHzn9zOhkdRXFqiCsQEe9g==
X-Received: by 2002:adf:e0c7:: with SMTP id m7mr8031855wri.530.1637857720415; 
	Thu, 25 Nov 2021 08:28:40 -0800 (PST)
Received: from [10.53.134.167] ([193.169.71.150])
	by smtp.gmail.com with ESMTPSA id
	o4sm10112775wmq.31.2021.11.25.08.28.38
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 25 Nov 2021 08:28:39 -0800 (PST)
From: Itai Handler <itai.handler@gmail.com>
To: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com
References: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
	<da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
	<c93ae166-faf8-f00f-7e63-b852a224310c@gmail.com>
Message-ID: <0efdd94f-94f4-1330-fe99-ec395d0c84ff@gmail.com>
Date: Thu, 25 Nov 2021 18:28:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c93ae166-faf8-f00f-7e63-b852a224310c@gmail.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [RFC PATCH 1/1] dm crypt: change maximum sector size
 to PAGE_SIZE
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTQvMTEvMjAyMSAxMzo1NiwgSXRhaSBIYW5kbGVyIHdyb3RlOgo+IE9uIDExLzExLzIwMjEg
MTU6MDcsIE1pbGFuIEJyb3ogd3JvdGU6Cj4+IE9uIDEwLzExLzIwMjEgMTg6NDMsIEl0YWkgSGFu
ZGxlciB3cm90ZToKPj4+IE1heGltdW0gc2VjdG9yIHNpemUgb2YgZG0tY3J5cHQgaXMgY3VycmVu
dGx5IGxpbWl0ZWQgdG8gNDA5NiBieXRlcy4KPj4+Cj4+PiBPbiBzeXN0ZW1zIHdoZXJlIFBBR0Vf
U0laRSBpcyBsYXJnZXIgdGhhbiA0MDk2IGJ5dGVzLCB1c2luZyBsYXJnZXIKPj4+IHNlY3RvcnMg
Y2FuIGJlIGJlbmVmaWNpYWwgZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnMuCj4+Cj4+IFRoZSBsaW1p
dCB0byA0MDk2IHdhcyBzZXQgYmVjYXVzZSB0aGlzIGlzIHRoZSBzbWFsbGVzdCBwb3NzaWJsZQo+
PiBwYWdlIHNpemUgdGhhdCBhbGwgcGxhdGZvcm0gc3VwcG9ydHMuCj4+Cj4+IElmIHlvdSBhbGxv
dyBhIGhpZ2hlciBzaXplIGhlcmUsIHRoZSBkZXZpY2UgY2Fubm90IGJlIGFjdGl2YXRlZCBvbiBh
IAo+PiBwbGF0Zm9ybQo+PiB3aXRoIHRoZSBzbWFsbGVyIHBhZ2Ugc2l6ZS4gKEVuY3J5cHRlZCBz
ZWN0b3Igc2l6ZSBiZWNvbWVzCj4+IGF0b21pYyBzZWN0b3Igc2l6ZSBmb3IgYWxsIHVwcGVyIGxh
eWVycyAtIGFzIHlvdSBtZW50aW9uIGJlbG93LCBub3QKPj4gYWxsIGZzIHN1cHBvcnQgYmlnZ2Vy
IHNlY3RvcnMuKQo+Pgo+PiBGb3IgTFVLUywgdGhpcyBpcyBub3QgYWNjZXB0YWJsZSAtIHRoZSBm
b3JtYXQgaXMgcG9ydGFibGUgYnkgZGVmaW5pdGlvbi4KPj4KPj4gRm9yIHNwZWNpZmljIGRtLWNy
eXB0IGRldmljZSwgSSBhbSBub3Qgc3VyZS4gSSB3b3VsZCBiZXR0ZXIga2VwdAo+PiB0aGUgNDA5
NiBwYWdlIHNpemUgbGltaXQgaGVyZS4KPgo+IEkgY29uc2lkZXJlZCBvbmx5IHBsYWluIGRtLWNy
eXB0IHNpbmNlIEkgYW0gdW5mYW1pbGlhciB3aXRoIExVS1MuCj4gRG9lcyBMVUtTIGFzc3VtZSB0
aGF0IGRtLWNyeXB0IHNlY3RvciBzaXplIGlzIGxpbWl0ZWQgdG8gNEs/Cj4gSWYgc28sIG1heWJl
IEknbGwgYmUgYWJsZSB0byBhbHNvIHBhdGNoIExVS1MgcmVnYXJkaW5nIHRoaXMgaXNzdWUuCj4K
Pj4KPj4gSXQgYWxzbyBkZXBlbmRzIG9uIGNyeXB0byBBUEkgZHJpdmVyIGhlcmUgKHBlcmZvcm1h
bmNlIGlzIHVzdWFsbHkgCj4+IG9wdGltaXplZCB0byA0aykuCj4+IFdoYXQgY2lwaGVyIGFuZCBl
bmNyeXB0aW9uIG1vZGUgZGlkIHlvdSB1c2UgZm9yIHRlc3Q/Cj4KPiBUaGUgY2lwaGVyIEkgdXNl
ZCBmb3IgdGhlIHRlc3QgaXMgbm90IHB1YmxpY2x5IGF2YWlsYWJsZSBidXQgSSBjYW4gc2F5IAo+
IHRoYXQgaXQncyBwZXJmb3JtYW5jZQo+IGlzIG5vdCBvcHRpbWl6ZWQgdG8gNGsgYmxvY2tzLgo+
IEkgYmVsaWV2ZSB0aGF0IHRoaXMgcmVzdWx0cyBmcm9tIHRoZSBoaWdoIG92ZXJoZWFkIG9mIHNl
dHRpbmcgdXAgRE1BIAo+IHRyYW5zZmVycy4gKG15Cj4gY2lwaGVyIHVzZXMgRE1BIHRvIHRyYW5z
ZmVyIGRhdGEgYmV0d2VlbiBtZW1vcnkgYW5kIHByb2dyYW1tYWJsZSBsb2dpYykuCj4gVGhlcmUg
YXJlIG1hbnkgYWRkaXRpb25hbCBjaXBoZXJzIHRoYXQgdXNlIERNQSBpbiB0aGUgdHJlZSwgYnV0
IEkgCj4gY2Fubm90IHJ1biBhbnkKPiBiZW5jaG1hcmsgd2l0aCB0aGVtIGF0IHRoZSBtb21lbnQu
Cj4KPiBJIGhhdmUgcGVyZm9ybWVkIHNvbWUgYWRkaXRpb25hbCBiZW5jaG1hcmtzIHVzaW5nIHRo
ZSBBUk0gCj4gQ3J5cHRvZ3JhcGhpYyBFeHRlbnNpb25zCj4gQ1BVIGNpcGhlcnMgYW5kIHNhdyB0
aGF0IGluY3JlYXNpbmcgYmxvY2sgc2l6ZSBiZXlvbmQgNEsgZG9lcyBpbmNyZWFzZSAKPiBwZXJm
b3JtYW5jZSwKPiBhbGJlaXQgdGhlIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IGlzbid0IGFzIGxh
cmdlIGFzIEkndmUgc2VlbiB3aGVuIAo+IHVzaW5nIG15IGNpcGhlci4KPgo+IEZvbGxvd2luZyBh
cmUgInRjcnlwdCBtb2RlPTYwMCBzZWM9NSBudW1fbWI9NTEyIiByZXN1bHRzIGZvciAKPiB4dHMt
YWVzLWNlIGRlY3J5cHRpb24KPiAoQVJNIENQVSBDcnlwdG9ncmFwaGljIEV4dGVuc2lvbnMgY2lw
aGVyKToKPiDCoCB0ZXN0aW5nIHNwZWVkIG9mIG11bHRpYnVmZmVyIHh0cyhhZXMpICh4dHMtYWVz
LWNlKSBkZWNyeXB0aW9uCj4gwqAgLi4uCj4gwqAgdHJjeXB0OiB0ZXN0IDUgKDI1NiBiaXQga2V5
LCA0MDk2IGJ5dGUgYmxvY2tzKTogODAxNzkyIG9wZXJhdGlvbnMgaW4gCj4gNSBzZWNvbmRzICgz
Mjg0MTQwMDMyIGJ5dGVzKQo+IMKgIC4uLgo+IMKgIHRyY3lwdDogdGVzdCA5ICgyNTYgYml0IGtl
eSwgNjU1MzYgYnl0ZSBibG9ja3MpOiA2MzQ4OCBvcGVyYXRpb25zIGluIAo+IDUgc2Vjb25kcyAo
NDE2MDc0OTU2OCBieXRlcykKPgo+IFRoYXQgdHJhbnNsYXRlcyB0bzoKPiDCoCA2NTcgTUIvcyBm
b3IgNEsgYnl0ZSBibG9ja3MuCj4gwqAgODMyIE1CL3MgZm9yIDY0SyBibG9ja3MuCj4KPiBUaGF0
IG1lYW5zIHRoYXQgdGhlcmUgaXMgYWJvdXQgMjcgcGVyY2VudHMgaW1wcm92ZW1lbnQgd2hlbiAK
PiB0cmFuc2l0aW9uaW5nIHRvIDY0SyBzZWN0b3JzLAo+IGZvciB0aGUgY2lwaGVyIGFsb25lIChv
bmx5IHRjcnlwdCBiZW5jaG1hcmspLgo+Cj4gVGhpcyBiZW5jaG1hcmsgaGFkIGJlZW4gcGVyZm9y
bWVkIG9uIGFuIEFSTSBDb3J0ZXggQTUzIENQVS4KPiAoTm90ZSB0aGF0IGluIGFsbCBvZiBteSBi
ZW5jaG1hcmtzIFBBR0VfU0laRT02NEspLgo+Cj4+IEhvdyB0aGUgbnVtYmVyIGxvb2tzIGZvciBy
YW5kb20gYWNjZXNzPyBMaW5lYXIgdGVzdCBpcyB1c3VhbGx5IAo+PiBtaXNsZWFkaW5nLgo+PiBJ
IGV4cGVjdCB0aGVyZSB3aWxsIGJlIGJpZyBwZXJmb3JtYW5jZSBwcm9ibGVtIGlmIHlvdSB3cml0
ZSBzbWFsbCAKPj4gZGF0YSBjaHVua3MsCj4+IHdyaXRlcyBhbmQgZW5jcnlwdGlvbiB3aWxsIGJl
IGFtcGxpZmllZCB0byBmdWxsIGJpZyBzZWN0b3JzIGhlcmUuLi4pCj4gSSB1bmRlcnN0YW5kIHlv
dXIgY29uY2Vybi4KPiBIb3dldmVyIG15IHBhdGNoIGRvZXMgbm90IGZvcmNlIGFueW9uZSB0byB1
c2UgbGFyZ2Ugc2VjdG9ycyAtIGl0IG9ubHkgCj4gb3BlbnMgdXAgdGhpcwo+IHBvc3NpYmlsaXR5
IGZvciB0aG9zZSBpbnRlcmVzdGVkIGluIHRoYXQgb3B0aW9uLgo+IFRoaXMgaXMgc2ltaWxhcmx5
IHRvIHRoZSBvcHRpb24gdG8gZm9ybWF0IGFuIGV4dDQgZmlsZXN5c3RlbSB3aXRoIDY0SyAKPiBz
ZWN0b3JzLgo+IEJ5IHRoZSB3YXk6IHdoZW4geW91IGRvIHRoYXQsIHlvdSBnZXQgYSB3YXJuaW5n
IHNheWluZyB0aGF0IHRoZSAKPiBmaWxlc3lzdGVtCj4gd2lsbCBub3QgYmUgdXNhYmxlIG9uIG1v
c3Qgc3lzdGVtcy4KPgo+IFNvbWV0aW1lIHVzZXJzIG5lZWQgdG8gc3RvcmUgbW9zdGx5IGxhcmdl
IGZpbGVzIG9uIGEgZmlsZXN5c3RlbSwgZm9yIAo+IGV4YW1wbGUgZm9yCj4gYmFja3VwIG9yIGZv
ciB2aWRlbyBmaWxlcy4KPiBJIHRoaW5rIHRoYXQgaW4gdGhlc2UgY2FzZXMgcmFuZG9tIGFjY2Vz
cyB0aW1lIGlzIG5vdCBzbyBpbXBvcnRhbnQuCj4gU29tZSB1c2VycyBtYXkgYWxzbyBiZSBhYmxl
IHRvIHJlc2VydmUgYSBkZWRpY2F0ZWQgcGFydGl0aW9uIGZvciAKPiBzdG9yaW5nIHN1Y2gKPiBs
YXJnZSBmaWxlcy4KPgo+Pgo+PiAoVGVjaG5pY2FsIGRldGFpbDogc3VjaCBwYXQgTVVTVCBpbmNy
ZWFzZSBkbS1jcnlwdCBtaW5vciB2ZXJzaW9uLikKPiBUaGFua3MgZm9yIHBvaW50aW5nIHRoYXQg
b3V0LiBJIGJlbGlldmUgdGhhdCBJIGNhbiBwcmVwYXJlIGEgdjIgcGF0Y2ggCj4gdGhhdCB3aWxs
Cj4gYWRkcmVzcyB0aGF0IGlzc3VlLgo+Pgo+PiBNaWxhbgo+Pgo+Pj4KPj4+IFRoaXMgcGF0Y2gg
Y2hhbmdlcyBtYXhpbXVtIHNlY3RvciBzaXplIGZyb20gNDA5NiBieXRlcyB0byBQQUdFX1NJWkUs
Cj4+PiBhbmQgaW4gYWRkaXRpb24gaXQgY2hhbmdlcyB0aGUgdHlwZSBvZiBzZWN0b3Jfc2l6ZSBp
bgo+Pj4gc3RydWN0IGNyeXB0X2NvbmZpZyBmcm9tICd1bnNpZ25lZCBzaG9ydCBpbnQnIHRvICd1
bnNpZ25lZCBpbnQnLCBpbgo+Pj4gb3JkZXIgdG8gYmUgYWJsZSB0byByZXByZXNlbnQgbGFyZ2Vy
IHZhbHVlcy4KPj4+Cj4+PiBPbiBhIHByb3RvdHlwZSBzeXN0ZW0gd2hpY2ggaGFzIFBBR0VfU0la
RSBvZiA2NTUzNiBieXRlcywgSSBzYXcgYWJvdXQKPj4+IHgyIHBlcmZvcm1hbmNlIGltcHJvdmVt
ZW50IGluIHNlcXVlbnRpYWwgcmVhZCB0aHJvdWdocHV0IGJlbmNobWFyawo+Pj4gd2hpbGUgdXNp
bmcgb25seSBhYm91dCBoYWxmIG9mIHRoZSBDUFUgdXNhZ2UsIGFmdGVyIHNpbXBseSBpbmNyZWFz
aW5nCj4+PiBzZWN0b3Igc2l6ZSBmcm9tIDQwOTYgdG8gNjU1MzYgYnl0ZXMuCj4+PiBJIHVzZWQg
ZXh0NCBmaWxlc3lzdGVtIGZvciB0aGF0IGJlbmNobWFyaywgd2hpY2ggc3VwcG9ydHMgNjRLaUIK
Pj4+IHNlY3RvcnMuCj4+Pgo+Pj4gTm90ZTogQSBzbWFsbCBjaGFuZ2Ugc2hvdWxkIGJlIG1hZGUg
aW4gY3J5cHRzZXR1cCBpbiBvcmRlciB0byBhZGQKPj4+IHN1cHBvcnQgZm9yIHNlY3RvcnMgbGFy
Z2VyIHRoYW4gNDA5NiBieXRlcy4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBJdGFpIEhhbmRsZXIg
PGl0YWkuaGFuZGxlckBnbWFpbC5jb20+Cj4+PiAtLS0KPj4+IMKgIGRyaXZlcnMvbWQvZG0tY3J5
cHQuYyB8IDYgKysrLS0tCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMg
Yi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+IGluZGV4IDkxNmI3ZGExNmRlMi4uNzhjMjM5NDQz
YmQ1IDEwMDY0NAo+Pj4gLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4+PiArKysgYi9kcml2
ZXJzL21kL2RtLWNyeXB0LmMKPj4+IEBAIC0xNjgsNyArMTY4LDcgQEAgc3RydWN0IGNyeXB0X2Nv
bmZpZyB7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIH0gaXZfZ2VuX3ByaXZhdGU7Cj4+PiDCoMKgwqDC
oMKgwqDCoMKgIHU2NCBpdl9vZmZzZXQ7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGlu
dCBpdl9zaXplOwo+Pj4gLcKgwqDCoMKgwqDCoCB1bnNpZ25lZCBzaG9ydCBpbnQgc2VjdG9yX3Np
emU7Cj4+PiArwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBzZWN0b3Jfc2l6ZTsKPj4+IMKgwqDC
oMKgwqDCoMKgwqAgdW5zaWduZWQgY2hhciBzZWN0b3Jfc2hpZnQ7Cj4+Pgo+Pj4gwqDCoMKgwqDC
oMKgwqDCoCB1bmlvbiB7Cj4+PiBAQCAtMzExNSw5ICszMTE1LDkgQEAgc3RhdGljIGludCBjcnlw
dF9jdHJfb3B0aW9uYWwoc3RydWN0IGRtX3RhcmdldAo+Pj4gKnRpLCB1bnNpZ25lZCBpbnQgYXJn
YywgY2hhciAqKmFyCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY2MtPmNpcGhlcl9hdXRoID0ga3N0cmR1cChzdmFsLCBHRlBfS0VSTkVMKTsKPj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIWNj
LT5jaXBoZXJfYXV0aCkKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9NRU07Cj4+PiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB9IGVsc2UgaWYgKHNzY2FuZihvcHRfc3RyaW5nLCAic2VjdG9y
X3NpemU6JWh1JWMiLAo+Pj4gJmNjLT5zZWN0b3Jfc2l6ZSwgJmR1bW15KSA9PSAxKSB7Cj4+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9IGVsc2UgaWYgKHNzY2FuZihvcHRfc3RyaW5n
LCAic2VjdG9yX3NpemU6JXUlYyIsCj4+PiAmY2MtPnNlY3Rvcl9zaXplLCAmZHVtbXkpID09IDEp
IHsKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoY2MtPnNlY3Rvcl9zaXplIDwgKDEgPDwgU0VDVE9SX1NISUZUKSB8fAo+Pj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2MtPnNlY3Rvcl9z
aXplID4gNDA5NiB8fAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgY2MtPnNlY3Rvcl9zaXplID4gUEFHRV9TSVpFIHx8Cj4+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoY2MtPnNl
Y3Rvcl9zaXplICYgKGNjLT5zZWN0b3Jfc2l6ZSAtIAo+Pj4gMSkpKSB7Cj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRp
LT5lcnJvciA9ICJJbnZhbGlkIGZlYXR1cmUgdmFsdWUgZm9yCj4+PiBzZWN0b3Jfc2l6ZSI7Cj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+Pj4KPj4KPiBJIGFwcHJlY2lhdGUgeW91ciB2YWx1
YWJsZSBjb21tZW50cy4KPgo+IEl0YWkKPgpNaWxhbiwgY2FuIHlvdSBjb21tZW50IG9uIHRoZSBh
Ym92ZT8KCkl0YWkKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

