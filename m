Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63E3EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 09:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686820470;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bsbi/Ou/gql4QyhsShswPBGL0Stvob6MYBnUcPj1hz8=;
	b=gPXo+nr3tHe7NuZLnW/+0nrnTEaQh0tfEJyExizcgNKUBXBzwKVqxwZCBrsBm8WgWlHEre
	sfuS6o6OE0C7TMd0eU74OUvb6UKUgGWSY/uk9cTljhX9agL2ZJWSzXuIllwbc68RbIHYmj
	GrprxejvmXpmqYk2gDt1W0/tRFQUWR4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-WYUiK9J8MPGKnZRs2bBgJw-1; Thu, 15 Jun 2023 05:14:29 -0400
X-MC-Unique: WYUiK9J8MPGKnZRs2bBgJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2B62185A795;
	Thu, 15 Jun 2023 09:14:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A41F240D1B60;
	Thu, 15 Jun 2023 09:14:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26D071946588;
	Thu, 15 Jun 2023 09:14:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 763FB1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 09:14:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E9B8492C38; Thu, 15 Jun 2023 09:14:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37A8A492C1B
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 09:14:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C0CD1C0726A
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 09:14:24 +0000 (UTC)
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-lJM0WcNNMKeNElP6ESp2Qg-1; Thu, 15 Jun 2023 05:14:22 -0400
X-MC-Unique: lJM0WcNNMKeNElP6ESp2Qg-1
Received: by mail-oi1-f197.google.com with SMTP id
 5614622812f47-39cc1b6745fso4129754b6e.0
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 02:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686820462; x=1689412462;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Tb5nOqyG703NV7P4uB0/SJ9ITcPAetTKogsQW8Hmr8c=;
 b=XAegn7EwVPHJLymrj2DGcwIv3QkRNl9Ukx/EZ4BvunFBh/BI8PisBJLbnVy9HNhxt7
 b6gFc/wGB9VZpNcOhap4ibMOgGoLJ+V4lq8UWI3UdxpGJURKHJlTtOPHsB8MzWBeOnlU
 PJssFooca5UmxxqaXbEls8txhOId9W+CEBlit5Xql9zaXL1g2kKLwp77aRYjHq2ac5z+
 q337iLtjRyHBZfm1UHp0qhSY2ex5ewxPRw7q49JPXj0dlI/tcpqbjVMQHOvQo6rcJ3me
 k2ipLSn3x0uKRzCTL2V+UQe+6aE7Db/Gvv9ohMrCY/nbnFRIEUVEKkC5+7UoNC1RkOlu
 4/pA==
X-Gm-Message-State: AC+VfDzmhbwiEOmQbKkeQGPKAuBSIm9notJYrPr4KZpJWd01rNOu0s4b
 oEIO2zNEbkvBPBacw57QpKJb3jNRSu/9eA02+jWSWoB+SAEO60N7Czs8dROAba2XK3pn8Aqub2W
 UC9P07HD/FIBFu8jV/xr+xPqvh/8FeWw=
X-Received: by 2002:a05:6808:2121:b0:39a:af56:4dda with SMTP id
 r33-20020a056808212100b0039aaf564ddamr14782869oiw.17.1686820462143; 
 Thu, 15 Jun 2023 02:14:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4I7cNI9F+cpY9YvJXebxjurS8POfuPraOH0yb1xS/M4OIsOvyYRDgu99uKmRspg+mMauITXYpyLTqFqlV35Xw=
X-Received: by 2002:a05:6808:2121:b0:39a:af56:4dda with SMTP id
 r33-20020a056808212100b0039aaf564ddamr14782854oiw.17.1686820461923; Thu, 15
 Jun 2023 02:14:21 -0700 (PDT)
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
 <CALTww2-knHOoX35NB73X-sMn1u8EJHLA=0aOnoVqVm83+fdG5Q@mail.gmail.com>
 <04700f85-62a2-1dbd-f330-80f9a13b7d2e@huaweicloud.com>
 <CALTww2-Wr8UbNFaLOyYv5Syh5q4J+hzRuo8Eakj_nOW+P4Cx7A@mail.gmail.com>
 <CALTww2_V=KVLqVVXpXZvGyrmT0N-WG1tFC+HaSEGNfHagaLHug@mail.gmail.com>
 <bacb3159-514c-76e2-ef2e-353cb1a0e30b@huaweicloud.com>
In-Reply-To: <bacb3159-514c-76e2-ef2e-353cb1a0e30b@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 15 Jun 2023 17:14:10 +0800
Message-ID: <CALTww2-C6vjiSZqd=gko84mbf3tN3UjX7izPFE2vr3VgNdaQ7g@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgNTowNeKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTUgMTY6MTcsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4+IFRoYW5rcyBmb3IgdGhlIGV4YW1wbGUuIEkgY2FuIHVuZGVyc3RhbmQg
dGhlIHVzYWdlIG9mIGl0LiBJdCdzIHRoZQo+ID4+IHNpZGUgZWZmZWN0IHRoYXQgcmVtb3ZlcyB0
aGUgbXV0ZXggcHJvdGVjdGlvbiBmb3IgaWRsZV9zeW5jX3RocmVhZC4KPiA+Pgo+ID4+IFRoZXJl
IGlzIGEgcHJvYmxlbS4gTmV3IHN5bmMgdGhyZWFkIGlzIHN0YXJ0ZWQgaW4gbWRfY2hlY2tfcmVj
b3ZlcnkuCj4gPj4gQWZ0ZXIgeW91ciBwYXRjaCwgbWRfcmVhcF9zeW5jX3RocmVhZCBpcyBjYWxs
ZWQgaW4gbWRfY2hlY2tfcmVjb3ZlcnkKPiA+PiB0b28uIFNvIGl0IGxvb2tzIGxpa2UgdGhleSBj
YW4ndCBoYXBwZW4gYXQgdGhlIHNhbWUgdGltZT8KPgo+IE9mIGNvdXJzZSB0aGV5IGNhbid0LiBt
ZF9jaGVja19yZWNvdmVyeSgpIGNhbiBvbmx5IGRvIG9uZSB0aGluZyBhdCBhCj4gdGltZS4KPgo+
ID4KPiA+IEFmdGVyIHRoaW5raW5nIGEgd2hpbGUsIHRoZXJlIGlzIHN0aWxsIGEgcmFjZSBwb3Nz
aWJpbGl0eS4KPiA+Cj4gPiBtZF9yZWFwX3N5bmNfdGhyZWFkIGlzIGNhbGxlZCBpbiBwZXJzIGRl
YW1vbiAoZS5nLiByYWlkMTBkIC0+Cj4gPiBtZF9jaGVja19yZWNvdmVyeSkgYW5kIG1kX2NoZWNr
X3JlY292ZXJ5IHJldHVybnMuIEJlZm9yZQo+ID4gaWRsZV9zeW5jX3RocmVhZCBpcyB3b2tlbiwg
dGhlIG5ldyBzeW5jIHRocmVhZCBjYW4gYmUgc3RhcnRlZCBpbgo+ID4gbWRfY2hlY2tfcmVjb3Zl
cnkgYWdhaW4uCj4gPgo+ID4gQnV0IGl0J3MgcmVhbGx5IHN0cmFuZ2UsIHdoZW4gb25lIHBlb3Bs
ZSBlY2hvIGlkbGUgdG8gc3luY19hY3Rpb24uCj4gPiBJdCdzIGJldHRlciB0byBhZGQgc29tZSBt
ZXNzYWdlcyB0byBub3RpZnkgdGhlIHVzZXJzIHRoYXQgdGhleSBuZWVkIHRvCj4gPiBlY2hvIGlk
bGUgdG8gc3luY19hY3Rpb24gYWdhaW4gdG8gaGF2ZSBhIHRyeS4gSXMgdGhlcmUgYSB3YXkgdGhh
dAo+ID4gbWRfcmVhcF9zeW5jX3RocmVhZCBjYW4gd2FpdCBpZGxlX3N5bmNfdGhyZWFkPwo+Cj4g
SSBkb24ndCB0aGluayB0aGlzIGlzIGEgcHJvYmxlbSwgZWNobyBpZGxlIG9ubHkgbWFrZSBzdXJl
IHRvIGludGVydXB0Cj4gY3VycmVudCBzeW5jX3RocmVhZCwgdGhlcmUgaXMgbm8gZ3VyYW50ZWUg
dGhhdCBzeW5jX3RocmVhZCBpcyBub3QKPiBydW5uaW5nIGFmdGVyICJlY2hvIGlkbGUiIGlzIGRv
bmUgd2l0aCBvciB3aXRob3V0IHRoaXMgcGF0Y2hzZXQsIGJlZm9yZQo+IHRoaXMgcGF0Y2hzZXQs
IG5ldyBzeW5jIHRocmVhZCBjYW4gc3RpbGwgc3RhcnQgYWZ0ZXIgdGhlIG11dGV4IGlzCj4gcmVs
ZWFzZWQuCj4KPiBVc2VyIHNob3VkICJlY2hvIGZvcnplbiIgaW5zdGVhZCBvZiAiZWNobyBpZGxl
IiBpZiB0aGV5IHJlYWxseSB3aGF0IHRvCj4gYXZvaWQgbmV3IHN5bmNfdGhyZWFkIHRvIHN0YXJ0
LgoKVGhhbmtzIGZvciBhbGwgdGhlIGV4cGxhbmF0aW9ucyBhbmQgcGF0aWVuY2UuCgpSZWdhcmRz
ClhpYW8KPgo+IFRoYW5rcywKPiBLdWFpCj4gPgo+ID4gUmVnYXJkcwo+ID4gWGlhbwo+ID4+Cj4g
Pj4gUmVnYXJkcwo+ID4+IFhpYW8KPiA+Pgo+ID4+Pgo+ID4+PiBUaGFua3MsCj4gPj4+IEt1YWkK
PiA+Pj4KPiA+Pj4gLS0KPiA+Pj4gZG0tZGV2ZWwgbWFpbGluZyBsaXN0Cj4gPj4+IGRtLWRldmVs
QHJlZGhhdC5jb20KPiA+Pj4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo+ID4KPiA+IC4KPiA+Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwK

