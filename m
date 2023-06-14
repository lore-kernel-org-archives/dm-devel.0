Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164CFEB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686729491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4WJ23XVS4i8sjN8C0md5gBJxhU0S/X/8B46HOp0Udxs=;
	b=GG07CEoev9f7bzCWYDn3ng3N4yQwxTaMBfqfyX7WWAMXi7BtMn0f/dF8IefzoAuNIFM+uI
	xUZmp4t1Rv31xxM7iP6tYluK6aFv/EEik4SOmO9pQsJzDRViUyzy62qJ5cv1akjKjaWXi4
	YBeaQYWO2pjnf4Mfd7xjuuvwUrzgeRQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-6knVK29lNKqgFmwAmXDnug-1; Wed, 14 Jun 2023 03:58:10 -0400
X-MC-Unique: 6knVK29lNKqgFmwAmXDnug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85893810BBD;
	Wed, 14 Jun 2023 07:58:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0F41415102;
	Wed, 14 Jun 2023 07:58:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB1E419459F1;
	Wed, 14 Jun 2023 07:58:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2712F194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:58:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01746492CAE; Wed, 14 Jun 2023 07:58:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDD98492CAC
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:58:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D16061018AA1
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:58:06 +0000 (UTC)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-ecYiWmY5MN2MF-KpbfAkNw-1; Wed, 14 Jun 2023 03:58:05 -0400
X-MC-Unique: ecYiWmY5MN2MF-KpbfAkNw-1
Received: by mail-pj1-f70.google.com with SMTP id
 98e67ed59e1d1-25c115a2440so927214a91.3
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 00:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686729484; x=1689321484;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YcAMEaHdVXOHx/SWlAZvp5j/GEODCn66k3Tb3qtjpuM=;
 b=R3/oe3xjAj4huSiMFDHz5oCPVzvdUCnJOmvKBAWtm9HwiZpBoU4y1rLz4P/rPsQViT
 exj3AuLbIILeCCE2aaEUw4MCQ9BJafMXrkgz7xhWiwnpxSfeHogIGsmT0KTmFUgXndks
 +/LvnbFgBV6IsyUjkWtG711nBQygJLFCf+JpWkjZr0TdrjMTSnVeAyZZGTIVnxkOu7+a
 phkOU2844B9Us7TDVpd1Nzmp7eCS5/zThAxI18t7Ra9cFNwdNZk3prJYmgqQ7zwML6Hv
 EQbfFon5sho8ARzJYfVhxiz3/aaWNrC4I3tgQg9JZBVxaInBuo0v1X3UlYN08yRN2WUg
 8AdA==
X-Gm-Message-State: AC+VfDwwmOTKjHS3B3xtOWCSkcaZx5/JXVlugBTLgdhtJVvjr5v8wG33
 Vm5evSfBhF2odVKlrQoZQudZVXDRegoLStpSTZYNOoiWtPYMY30gKroC4UOfCFB9bETrZO0u5q2
 Lyw7yfT3FJexmPhqKUusLzQFw5IWolF8=
X-Received: by 2002:a17:90a:19c4:b0:25b:8bed:d13b with SMTP id
 4-20020a17090a19c400b0025b8bedd13bmr592562pjj.39.1686729484461; 
 Wed, 14 Jun 2023 00:58:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5WG/pWp7t9cmCjQuztIbIJnaTsFT1OU7Z9VL4N1ItOAF7I8tbmj8Xz9Buo8LI1Wbd+AjqUHNCjv3CTQe40Oks=
X-Received: by 2002:a17:90a:19c4:b0:25b:8bed:d13b with SMTP id
 4-20020a17090a19c400b0025b8bedd13bmr592549pjj.39.1686729484159; Wed, 14 Jun
 2023 00:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
 <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
 <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
In-Reply-To: <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 14 Jun 2023 15:57:53 +0800
Message-ID: <CALTww28UapJnK+Xfx7O9uEd5ZH2E7ufPT_7pKY6YYuzTZ0Fbdw@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMzozOOKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTQgMTU6MTIsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFp
IDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gPj4KPiA+PiBIaSwKPiA+Pgo+ID4+
IOWcqCAyMDIzLzA2LzE0IDk6NDgsIFl1IEt1YWkg5YaZ6YGTOgo+ID4+Cj4gPj4KPiA+Pj4+Cj4g
Pj4+PiBJbiB0aGUgcGF0Y2gsIHN5bmNfc2VxIGlzIGFkZGVkIGluIG1kX3JlYXBfc3luY190aHJl
YWQuIEluCj4gPj4+PiBpZGxlX3N5bmNfdGhyZWFkLCBpZiBzeW5jX3NlcSBpc24ndCBlcXVhbAo+
ID4+Pj4KPiA+Pj4+IG1kZGV2LT5zeW5jX3NlcSwgaXQgc2hvdWxkIG1lYW4gdGhlcmUgaXMgc29t
ZW9uZSB0aGF0IHN0b3BzIHRoZSBzeW5jCj4gPj4+PiB0aHJlYWQgYWxyZWFkeSwgcmlnaHQ/IFdo
eSBkbwo+ID4+Pj4KPiA+Pj4+IHlvdSBzYXkgJ25ldyBzdGFydGVkIHN5bmMgdGhyZWFkJyBoZXJl
Pwo+ID4+Cj4gPj4gSWYgc29tZW9uZSBzdG9wcyB0aGUgc3luYyB0aHJlYWQsIGFuZCBuZXcgc3lu
YyB0aHJlYWQgaXMgbm90IHN0YXJ0ZWQsCj4gPj4gdGhlbiB0aGlzIHN5bmNfc2VxIHdvbid0IG1h
a2UgYSBkaWZmZXJlbmNlLCBhYm92ZSB3YWl0X2V2ZW50KCkgd2lsbCBub3QKPiA+PiB3YWl0IGJl
Y2F1c2UgIXRlc3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpIHdp
bGwgcGFzcy4KPiA+PiBTbyAnc3luY19zZXEnIGlzIG9ubHkgdXNlZCB3aGVuIHRoZSBvbGQgc3lu
YyB0aHJlYWQgc3RvcHMgYW5kIG5ldyBzeW5jCj4gPj4gdGhyZWFkIHN0YXJ0cywgYWRkICdzeW5j
X3NlcScgd2lsbCBieXBhc3MgdGhpcyBjYXNlLgo+ID4KPiA+IEhpCj4gPgo+ID4gSWYgYSBuZXcg
c3luYyB0aHJlYWQgc3RhcnRzLCB3aHkgY2FuIHN5bmNfc2VxIGJlIGRpZmZlcmVudD8gc3luY19z
ZXEKPiA+IGlzIG9ubHkgYWRkZWQgaW4gbWRfcmVhcF9zeW5jX3RocmVhZC4gQW5kIHdoZW4gYSBu
ZXcgc3luYyByZXF1ZXN0Cj4gPiBzdGFydHMsIGl0IGNhbid0IHN0b3AgdGhlIHN5bmMgcmVxdWVz
dCBhZ2Fpbj8KPiA+Cj4gPiBBZiBmaXJzdCwgdGhlIHN5bmNfc2VxIGlzIDAKPiA+Cj4gPiBhZG1p
bjEKPiA+IGVjaG8gaWRsZSA+IHN5bmNfYWN0aW9uCj4gPiBpZGxlX3N5bmNfdGhyZWFkKHN5bmNf
c2VxIGlzIDEpCj4KPiBXYWl0LCBJJ20gY29uZnVzZWQgaGVyZSwgaG93IGNhbiBzeW5jX3NlcSB0
byBiZSAxIGhlcmU/IEkgc3VwcG9zZSB5b3UKPiBtZWFuIHRoYXQgdGhlcmUgaXMgYSBzeW5jX3Ro
cmVhZCBqdXN0IGZpbmlzaGVkPwoKSGkgS3VhaQoKWWVzLiBCZWNhdXNlIGlkbGVfc3luY190aHJl
YWQgbmVlZHMgdG8gd2FpdCB1bnRpbCBtZF9yZWFwX3N5bmNfdGhyZWFkCmZpbmlzaGVzLiBBbmQg
bWRfcmVhcF9zeW5jX3RocmVhZCBhZGRzIHN5bmNfc2VxLiBEbyBJIHVuZGVyc3RhbmQgeW91cgpw
YXRjaCByaWdodD8KCj4KPiBUaGVuIHRoZSBwcm9ibGVtIGlzIHRoYXQgaWRsZV9zeW5jX3RocmVh
ZCgpIHJlYWQgc3luY19zZXEgYWZ0ZXIgdGhlIG9sZAo+IHN5bmNfdGhyZWFkIGlzIGRvbmUsIGFu
ZCBuZXcgc3luY190aHJlYWQgc3RhcnQgYmVmb3JlIHdhaXRfZXZlbnQoKSBpcwo+IGNhbGxlZCwg
c2hvdWxkIHdlIHdhaXQgZm9yIHRoaXMgbmV3IHN5bmNfdGhyZWFkPwo+Cj4gTXkgYW5zd2VyIGhl
cmUgaXMgdGhhdCB3ZSBzaG91bGQsIGJ1dCBJJ20gYWxzbyBvayB0byBub3Qgd2FpdCB0aGlzIG5l
dwo+IHN5bmNfdGhyZWFkLCBJIGRvbid0IHRoaW5rIHRoaXMgYmVoYXZpb3VyIG1hdHRlcnMuIFRo
ZSBrZXkgcG9pbnQgaGVyZQo+IGlzIHRoYXQgb25jZSB3YWl0X2V2ZW50KCkgaXMgY2FsbGVkIGZy
b20gaWRsZV9zeW5jX3RocmVhZCgpLCB0aGlzCj4gd2FpdF9ldmVudCgpIHNob3VsZCBub3Qgd2Fp
dCBmb3IgbmV3IHN5bmNfdGhyZWFkLi4uCgpJIHRoaW5rIHdlIHNob3VsZCB3YWl0LiBJZiB3ZSBk
b24ndCB3YWl0IGZvciBpdCwgdGhlcmUgaXMgYSBwcm9ibGVtLgpPbmUgcGVyc29uIGVjaG9zIGlk
bGUgdG8gc3luY19hY3Rpb24gYW5kIGl0IGRvZXNuJ3Qgd29yayBzb21ldGltZXMuCkl0J3MgYSBz
dHJhbmdlIHRoaW5nLgoKPgo+ID4gZWNobyByZXN5bmMgPiBzeW5jX2FjdGlvbiAobmV3IHN5bmMp
Cj4KPiBJZiB0aGlzIGlzIGJlaGluZCAiZWNobyBpZGxlID4gc3luY19hY3Rpb24iLCBpZGxlX3N5
bmNfdGhyZWFkIHNob3VsZCBub3QKPiBzZWUgdGhhdCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIHNl
dCBhbmQgd2FpdF9ldmVudCgpIHdvbid0IHdhaXQgYXQgYWxsLgoKYGVjaG8gcmVzeW5jID4gc3lu
Y19hY3Rpb25gIGNhbid0IGNoYW5nZSB0aGUgc3luY19zZXEuIFNvICdlY2hvIGlkbGUgPgpzeW5j
X2FjdGlvbicgc3RpbGwgd2FpdHMgdW50aWwgTURfUkVDT1ZFUllfUlVOTklORyBpcyBjbGVhcmVk
PwoKUmVnYXJkcwpYaWFvCgo+Cj4gVGhhbmtzLAo+IEt1YWkKPiA+Cj4gPiBUaGVuIGFkbWluMiBl
Y2hvcyBpZGxlID4gc3luY19hY3Rpb24sIHN5bmNfc2VxIGlzIHN0aWxsIDEKPiA+Cj4gPiBSZWdh
cmRzCj4gPiBYaWFvCj4gPgo+ID4+Cj4gPj4gVGhhbmtzLAo+ID4+IEt1YWkKPiA+Pgo+ID4KPiA+
IC4KPiA+Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

