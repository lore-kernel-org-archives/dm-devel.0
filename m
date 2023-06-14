Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C98AEB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 09:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686733948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g2cPv1keDBIDkBPKOLuUxuWi+AUS78ZTaWtO0044Sw0=;
	b=QvJPqGYNklw2NdmbWOBOP6LPtHJplFEggM0AbgGoBicPw7F5/ZCH5i+DDRvbemtsVYFC3n
	5B8yDqstsGi2VQIZqd0wlE3WOB5KLa/M8WbiV4K535qYIBoT6cqqrkGT3NjcJmSTtaHC70
	r5sVHj+l8rnXtQ66Gnq2br8M/tbLOkw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-j2lsom7uNvS5Jn_nER0c9g-1; Wed, 14 Jun 2023 05:12:24 -0400
X-MC-Unique: j2lsom7uNvS5Jn_nER0c9g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B465B185A792;
	Wed, 14 Jun 2023 09:12:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9977A492C38;
	Wed, 14 Jun 2023 09:12:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0ABD19451D8;
	Wed, 14 Jun 2023 09:12:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E935419459F1
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 09:09:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0A7C17596; Wed, 14 Jun 2023 09:09:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C827A17338
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 09:09:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1BB0185A7AD
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 09:09:02 +0000 (UTC)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461--SY29ytuN7yc2M8NGt5QUA-1; Wed, 14 Jun 2023 05:08:59 -0400
X-MC-Unique: -SY29ytuN7yc2M8NGt5QUA-1
Received: by mail-oi1-f199.google.com with SMTP id
 5614622812f47-39c872bab70so4189589b6e.3
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 02:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686733738; x=1689325738;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YuZfFGL1mKI+1SfogZenr2tUCwIM+u0pKlzpY1axVWo=;
 b=W1nxhS3zrSZ86N22WGFtWxDlSlCOZygRPNqNjeYKMv5zCIMj3FKWzPWSUGGmoFuHl/
 7o6cCQ+E9G03ju8NvAeWghzWX9zPyROgeVfnBbcwmHkmaW11v0SOI43wnzsC0DVuvjUg
 kh2Us/KMIooxqg+GonCcyXgFeiBnD9YuRtc1W0Pomzg+PgalRhisBucGm39+YKtdotRX
 2x703otaBZLd2ADjKIn2Y18AIk4yR5pg54lb2fWLDv2eFWIMe6Nua9wB6ohb7uwxKlk3
 +9P/br4rgzehYVuyG6wgq5kn0vFCKoAdnf62Ot8/kf1WQPsEcIKV4OBVRAonguLiZip5
 k6gg==
X-Gm-Message-State: AC+VfDxdaUx7cEjL6Siau80TDwRVLWFQkVHFmFfGoW7dKccQbvdjkOZc
 /X3RNmgX9KVuRoKRNzWIYpQ8yBHBWvIms2ACTQmxhDnE5l1NMklnPwfv5bdT1uS1AjCJtHEU5pn
 pQCBEWUX9QU4ntDwPXBYIdrA2SxjuFgg=
X-Received: by 2002:a05:6808:1389:b0:39c:a986:953a with SMTP id
 c9-20020a056808138900b0039ca986953amr12173549oiw.34.1686733738601; 
 Wed, 14 Jun 2023 02:08:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ58w+HwbaWwKHZAt1p3B0C+JtvwHZqjZISvxx+b6MeyFNPBBwxTSYad7slNHl4ES3WRCVcszuSBd0EYV84rve0=
X-Received: by 2002:a05:6808:1389:b0:39c:a986:953a with SMTP id
 c9-20020a056808138900b0039ca986953amr12173538oiw.34.1686733738382; Wed, 14
 Jun 2023 02:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
 <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
 <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
 <CALTww28UapJnK+Xfx7O9uEd5ZH2E7ufPT_7pKY6YYuzTZ0Fbdw@mail.gmail.com>
 <b96ec15b-6102-17bb-2c18-a487f224865b@huaweicloud.com>
In-Reply-To: <b96ec15b-6102-17bb-2c18-a487f224865b@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 14 Jun 2023 17:08:47 +0800
Message-ID: <CALTww2-knHOoX35NB73X-sMn1u8EJHLA=0aOnoVqVm83+fdG5Q@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgNDoyOeKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTQgMTU6NTcsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMzozOOKAr1BNIFl1IEt1YWkg
PHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+Pgo+ID4+IEhpLAo+ID4+Cj4gPj4g
5ZyoIDIwMjMvMDYvMTQgMTU6MTIsIFhpYW8gTmkg5YaZ6YGTOgo+ID4+PiBPbiBXZWQsIEp1biAx
NCwgMjAyMyBhdCAxMDowNOKAr0FNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3
cm90ZToKPiA+Pj4+Cj4gPj4+PiBIaSwKPiA+Pj4+Cj4gPj4+PiDlnKggMjAyMy8wNi8xNCA5OjQ4
LCBZdSBLdWFpIOWGmemBkzoKPiA+Pj4+Cj4gPj4+Pgo+ID4+Pj4+Pgo+ID4+Pj4+PiBJbiB0aGUg
cGF0Y2gsIHN5bmNfc2VxIGlzIGFkZGVkIGluIG1kX3JlYXBfc3luY190aHJlYWQuIEluCj4gPj4+
Pj4+IGlkbGVfc3luY190aHJlYWQsIGlmIHN5bmNfc2VxIGlzbid0IGVxdWFsCj4gPj4+Pj4+Cj4g
Pj4+Pj4+IG1kZGV2LT5zeW5jX3NlcSwgaXQgc2hvdWxkIG1lYW4gdGhlcmUgaXMgc29tZW9uZSB0
aGF0IHN0b3BzIHRoZSBzeW5jCj4gPj4+Pj4+IHRocmVhZCBhbHJlYWR5LCByaWdodD8gV2h5IGRv
Cj4gPj4+Pj4+Cj4gPj4+Pj4+IHlvdSBzYXkgJ25ldyBzdGFydGVkIHN5bmMgdGhyZWFkJyBoZXJl
Pwo+ID4+Pj4KPiA+Pj4+IElmIHNvbWVvbmUgc3RvcHMgdGhlIHN5bmMgdGhyZWFkLCBhbmQgbmV3
IHN5bmMgdGhyZWFkIGlzIG5vdCBzdGFydGVkLAo+ID4+Pj4gdGhlbiB0aGlzIHN5bmNfc2VxIHdv
bid0IG1ha2UgYSBkaWZmZXJlbmNlLCBhYm92ZSB3YWl0X2V2ZW50KCkgd2lsbCBub3QKPiA+Pj4+
IHdhaXQgYmVjYXVzZSAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2LT5yZWNv
dmVyeSkgd2lsbCBwYXNzLgo+ID4+Pj4gU28gJ3N5bmNfc2VxJyBpcyBvbmx5IHVzZWQgd2hlbiB0
aGUgb2xkIHN5bmMgdGhyZWFkIHN0b3BzIGFuZCBuZXcgc3luYwo+ID4+Pj4gdGhyZWFkIHN0YXJ0
cywgYWRkICdzeW5jX3NlcScgd2lsbCBieXBhc3MgdGhpcyBjYXNlLgo+ID4+Pgo+ID4+PiBIaQo+
ID4+Pgo+ID4+PiBJZiBhIG5ldyBzeW5jIHRocmVhZCBzdGFydHMsIHdoeSBjYW4gc3luY19zZXEg
YmUgZGlmZmVyZW50PyBzeW5jX3NlcQo+ID4+PiBpcyBvbmx5IGFkZGVkIGluIG1kX3JlYXBfc3lu
Y190aHJlYWQuIEFuZCB3aGVuIGEgbmV3IHN5bmMgcmVxdWVzdAo+ID4+PiBzdGFydHMsIGl0IGNh
bid0IHN0b3AgdGhlIHN5bmMgcmVxdWVzdCBhZ2Fpbj8KPiA+Pj4KPiA+Pj4gQWYgZmlyc3QsIHRo
ZSBzeW5jX3NlcSBpcyAwCj4gPj4+Cj4gPj4+IGFkbWluMQo+ID4+PiBlY2hvIGlkbGUgPiBzeW5j
X2FjdGlvbgo+ID4+PiBpZGxlX3N5bmNfdGhyZWFkKHN5bmNfc2VxIGlzIDEpCj4gPj4KPiA+PiBX
YWl0LCBJJ20gY29uZnVzZWQgaGVyZSwgaG93IGNhbiBzeW5jX3NlcSB0byBiZSAxIGhlcmU/IEkg
c3VwcG9zZSB5b3UKPiA+PiBtZWFuIHRoYXQgdGhlcmUgaXMgYSBzeW5jX3RocmVhZCBqdXN0IGZp
bmlzaGVkPwo+ID4KPiA+IEhpIEt1YWkKPiA+Cj4gPiBZZXMuIEJlY2F1c2UgaWRsZV9zeW5jX3Ro
cmVhZCBuZWVkcyB0byB3YWl0IHVudGlsIG1kX3JlYXBfc3luY190aHJlYWQKPiA+IGZpbmlzaGVz
LiBBbmQgbWRfcmVhcF9zeW5jX3RocmVhZCBhZGRzIHN5bmNfc2VxLiBEbyBJIHVuZGVyc3RhbmQg
eW91cgo+ID4gcGF0Y2ggcmlnaHQ/Cj4KPiBZZXMsIG5vdGVkIHRoYXQgaWRsZV9zeW5jX3RocmVh
ZCgpIHdpbGwgb25seSB3YWl0IGlmIE1EX1JFQ09WRVJZX1JVTk5JTkcKPiBpcyBzZXQuCj4KPiA+
Cj4gPj4KPiA+PiBUaGVuIHRoZSBwcm9ibGVtIGlzIHRoYXQgaWRsZV9zeW5jX3RocmVhZCgpIHJl
YWQgc3luY19zZXEgYWZ0ZXIgdGhlIG9sZAo+ID4+IHN5bmNfdGhyZWFkIGlzIGRvbmUsIGFuZCBu
ZXcgc3luY190aHJlYWQgc3RhcnQgYmVmb3JlIHdhaXRfZXZlbnQoKSBpcwo+ID4+IGNhbGxlZCwg
c2hvdWxkIHdlIHdhaXQgZm9yIHRoaXMgbmV3IHN5bmNfdGhyZWFkPwo+ID4+Cj4gPj4gTXkgYW5z
d2VyIGhlcmUgaXMgdGhhdCB3ZSBzaG91bGQsIGJ1dCBJJ20gYWxzbyBvayB0byBub3Qgd2FpdCB0
aGlzIG5ldwo+ID4+IHN5bmNfdGhyZWFkLCBJIGRvbid0IHRoaW5rIHRoaXMgYmVoYXZpb3VyIG1h
dHRlcnMuIFRoZSBrZXkgcG9pbnQgaGVyZQo+ID4+IGlzIHRoYXQgb25jZSB3YWl0X2V2ZW50KCkg
aXMgY2FsbGVkIGZyb20gaWRsZV9zeW5jX3RocmVhZCgpLCB0aGlzCj4gPj4gd2FpdF9ldmVudCgp
IHNob3VsZCBub3Qgd2FpdCBmb3IgbmV3IHN5bmNfdGhyZWFkLi4uCj4gPgo+ID4gSSB0aGluayB3
ZSBzaG91bGQgd2FpdC4gSWYgd2UgZG9uJ3Qgd2FpdCBmb3IgaXQsIHRoZXJlIGlzIGEgcHJvYmxl
bS4KPiA+IE9uZSBwZXJzb24gZWNob3MgaWRsZSB0byBzeW5jX2FjdGlvbiBhbmQgaXQgZG9lc24n
dCB3b3JrIHNvbWV0aW1lcy4KPiA+IEl0J3MgYSBzdHJhbmdlIHRoaW5nLgo+ID4KPgo+IE9rLiBJ
J2xsIGFkZCBuZXcgY29tbWVudCB0byBlbXBoYXNpemUgdGhhdCBpZGxlX3N5bmNfdGhyZWFkKCkg
d29uJ3Qgd2FpdAo+IGZvciBuZXcgc3luY190aHJlYWQgdGhhdCBpcyBzdGFydGVkIGFmdGVyIHdh
aXRfZXZlbnQoKS4KCkkgc3VnZ2VzdCByZW1vdmluZyB0aGlzIGZ1bmN0aW9uLiBXaXRob3V0IHRo
aXMgY2hhbmdlLCBpdCdzIG1vcmUKc2ltcGxlIGFuZCBpdCBjYW4gd29yayB3ZWxsIHdpdGhvdXQg
cHJvYmxlbS4gVGhlIHBlb3BsZSB0aGF0IGVjaG8gaWRsZQp0byBzeW5jX2FjdGlvbiBuZWVkcyB0
byB3YWl0IHVudGlsIHRoZSBzeW5jIGFjdGlvbiBmaW5pc2hlcy4gVGhlIGNvZGUKc2VtYW50aWMg
aXMgY2xlYXIgYW5kIHNpbXBsZS4KPgo+ID4+Cj4gPj4+IGVjaG8gcmVzeW5jID4gc3luY19hY3Rp
b24gKG5ldyBzeW5jKQo+ID4+Cj4gPj4gSWYgdGhpcyBpcyBiZWhpbmQgImVjaG8gaWRsZSA+IHN5
bmNfYWN0aW9uIiwgaWRsZV9zeW5jX3RocmVhZCBzaG91bGQgbm90Cj4gPj4gc2VlIHRoYXQgTURf
UkVDT1ZFUllfUlVOTklORyBpcyBzZXQgYW5kIHdhaXRfZXZlbnQoKSB3b24ndCB3YWl0IGF0IGFs
bC4KPiA+Cj4gPiBgZWNobyByZXN5bmMgPiBzeW5jX2FjdGlvbmAgY2FuJ3QgY2hhbmdlIHRoZSBz
eW5jX3NlcS4gU28gJ2VjaG8gaWRsZSA+Cj4gPiBzeW5jX2FjdGlvbicgc3RpbGwgd2FpdHMgdW50
aWwgTURfUkVDT1ZFUllfUlVOTklORyBpcyBjbGVhcmVkPwo+Cj4gVGhpcyBpcyBub3QgYWNjdXJh
dGUsIGlmIGBlY2hvIHJlc3luYyA+IHN5bmNfYWN0aW9uYCB0cmlnZ2VycyBhIG5ldwo+IHN5bmNf
dGhyZWFkLCB0aGVuIHN5bmNfc2VxIGlzIHVwZGF0ZWQgd2hlbiB0aGlzIHN5bmNfdGhyZWFkIGlz
IGRvbmUsCj4gZHVyaW5nIHRoaXMgcGVyaW9kLCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIHN0aWxs
IHNldCwgc28gYGVjaG8gaWRsZQo+ICA+c3luY19hY3Rpb25gIHdpbGwgd2FpdCBmb3Igc3luY190
aHJlYWQgdG8gYmUgZG9uZS4KCkkgY2FuIHVuZGVyc3RhbmQgeW91ciBjb21tZW50LCBidXQgc29y
cnksIEkgc3RpbGwgY2FuJ3QgZ2V0IGhvdwpzeW5jX3NlcSB3b3Jrcy4gQ291bGQgeW91IGdpdmUg
YSBzcGVjaWZpYyBjYXNlIHRoYXQgZXhwbGFpbnMgaG93IGl0CndvcmtzPwoKUmVnYXJkcwpYaWFv
Cj4KPiBUaGFua3MsCj4gS3VhaQo+ID4KPiA+IFJlZ2FyZHMKPiA+IFhpYW8KPiA+Cj4gPj4KPiA+
PiBUaGFua3MsCj4gPj4gS3VhaQo+ID4+Pgo+ID4+PiBUaGVuIGFkbWluMiBlY2hvcyBpZGxlID4g
c3luY19hY3Rpb24sIHN5bmNfc2VxIGlzIHN0aWxsIDEKPiA+Pj4KPiA+Pj4gUmVnYXJkcwo+ID4+
PiBYaWFvCj4gPj4+Cj4gPj4+Pgo+ID4+Pj4gVGhhbmtzLAo+ID4+Pj4gS3VhaQo+ID4+Pj4KPiA+
Pj4KPiA+Pj4gLgo+ID4+Pgo+ID4+Cj4gPgo+ID4gLgo+ID4KPgoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

