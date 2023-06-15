Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC437EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 08:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686816138;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MzBYbXGgxtgrQE2s6d+7CinbMucSaMPgpJS3YyTe4MA=;
	b=cJEveKM0vFkgOCQdgmt8d/OX9e14jzBNoVq7nPTwL0/HVahSJiRojtHijNlf/HqjnrvV0o
	l/SMXAcKK7LFEGMaHiQX+nAfO3e/8PQlIVjT3JXrkJb7zPqnMIOIKhZhLcsYwyH28KIzCt
	xN5IEupY39Li3+p9nNbh/MQiJDtxfiw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-feEsk8gRNiurGXwnOLe9bQ-1; Thu, 15 Jun 2023 04:02:15 -0400
X-MC-Unique: feEsk8gRNiurGXwnOLe9bQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6629F186E125;
	Thu, 15 Jun 2023 08:02:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41DF42166B25;
	Thu, 15 Jun 2023 08:02:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 60100194973F;
	Thu, 15 Jun 2023 08:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 369361946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 08:01:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F1302166B27; Thu, 15 Jun 2023 08:01:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 15A6E2166B25
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 08:01:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED349380606F
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 08:01:31 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-NpACcn5YP96o7c8CEhKWgQ-1; Thu, 15 Jun 2023 04:01:30 -0400
X-MC-Unique: NpACcn5YP96o7c8CEhKWgQ-1
Received: by mail-qv1-f70.google.com with SMTP id
 6a1803df08f44-62fe9513320so14472996d6.3
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 01:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686816089; x=1689408089;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=yQWDXrZbWAVoRYBMaKcwwAPg+tUuAljoMwPz6OAacLc=;
 b=hGMiqkzdKtmTzjkZodL9QX7w9ZtsLMQEq9QuHTNK3Xi5mMYkAdp0njA6NQai/JRFu6
 53YTKpMMJ7CHOonwnm1eyxXSSfpmIRfZH8zyFdLvYwrpW/95l+3hStmQKfFmrXKtijOz
 lUc4pT1eqcKGDIF0iPADtkF0Gc9XcCjjRSjZc6m/yBGO+xjOz3qeDd2Bl0eT6l/nmmDE
 VWmkOTqZQ6SPuOrPglvQudIGvsCaigumUre6o2F3t2UaAi6SAo/X/Psv+17xwTzuLcb7
 SFq8dWjslzVSDj6WfWptfbUBfH8c0RoX+FMJx439q4P3xbKQHgBzYawy78r0H4w5FLz4
 L3jw==
X-Gm-Message-State: AC+VfDwawr9KEybCmss1QXyH8LfiVFvxynRmFF4ym0xRJODIPPJkwJmS
 3Bxpe+fBcqfdiGlC6AczO9GriGWxD3/PYqHo+ecTqs5c6T7juborzfGTxmu+YyiOk+Fbh5GGFyf
 HT80XU64gt3aqaY6lYZDgqF9mdQPBQk1/axthuQ3ygGqL
X-Received: by 2002:a05:6214:b6c:b0:626:1fe8:bbc9 with SMTP id
 ey12-20020a0562140b6c00b006261fe8bbc9mr17232592qvb.32.1686816088992; 
 Thu, 15 Jun 2023 01:01:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4KCE4A+SKvSwxPT5wW/pwzpT/V0TAa+G9BMizaSX7JkXMUCmL9Ijl1gAGyeKyyyshbQxicyahmJM2R2vQgcYM=
X-Received: by 2002:a05:6214:b6c:b0:626:1fe8:bbc9 with SMTP id
 ey12-20020a0562140b6c00b006261fe8bbc9mr17232576qvb.32.1686816088739; Thu, 15
 Jun 2023 01:01:28 -0700 (PDT)
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
In-Reply-To: <04700f85-62a2-1dbd-f330-80f9a13b7d2e@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 15 Jun 2023 16:01:17 +0800
Message-ID: <CALTww2-Wr8UbNFaLOyYv5Syh5q4J+hzRuo8Eakj_nOW+P4Cx7A@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgOToyOeKAr0FNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTQgMTc6MDgsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgNDoyOeKAr1BNIFl1IEt1YWkg
PHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+Pgo+ID4+IEhpLAo+ID4+Cj4gPj4g
5ZyoIDIwMjMvMDYvMTQgMTU6NTcsIFhpYW8gTmkg5YaZ6YGTOgo+ID4+PiBPbiBXZWQsIEp1biAx
NCwgMjAyMyBhdCAzOjM44oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdy
b3RlOgo+ID4+Pj4KPiA+Pj4+IEhpLAo+ID4+Pj4KPiA+Pj4+IOWcqCAyMDIzLzA2LzE0IDE1OjEy
LCBYaWFvIE5pIOWGmemBkzoKPiA+Pj4+PiBPbiBXZWQsIEp1biAxNCwgMjAyMyBhdCAxMDowNOKA
r0FNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+Pj4+Pj4KPiA+
Pj4+Pj4gSGksCj4gPj4+Pj4+Cj4gPj4+Pj4+IOWcqCAyMDIzLzA2LzE0IDk6NDgsIFl1IEt1YWkg
5YaZ6YGTOgo+ID4+Pj4+Pgo+ID4+Pj4+Pgo+ID4+Pj4+Pj4+Cj4gPj4+Pj4+Pj4gSW4gdGhlIHBh
dGNoLCBzeW5jX3NlcSBpcyBhZGRlZCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkLiBJbgo+ID4+Pj4+
Pj4+IGlkbGVfc3luY190aHJlYWQsIGlmIHN5bmNfc2VxIGlzbid0IGVxdWFsCj4gPj4+Pj4+Pj4K
PiA+Pj4+Pj4+PiBtZGRldi0+c3luY19zZXEsIGl0IHNob3VsZCBtZWFuIHRoZXJlIGlzIHNvbWVv
bmUgdGhhdCBzdG9wcyB0aGUgc3luYwo+ID4+Pj4+Pj4+IHRocmVhZCBhbHJlYWR5LCByaWdodD8g
V2h5IGRvCj4gPj4+Pj4+Pj4KPiA+Pj4+Pj4+PiB5b3Ugc2F5ICduZXcgc3RhcnRlZCBzeW5jIHRo
cmVhZCcgaGVyZT8KPiA+Pj4+Pj4KPiA+Pj4+Pj4gSWYgc29tZW9uZSBzdG9wcyB0aGUgc3luYyB0
aHJlYWQsIGFuZCBuZXcgc3luYyB0aHJlYWQgaXMgbm90IHN0YXJ0ZWQsCj4gPj4+Pj4+IHRoZW4g
dGhpcyBzeW5jX3NlcSB3b24ndCBtYWtlIGEgZGlmZmVyZW5jZSwgYWJvdmUgd2FpdF9ldmVudCgp
IHdpbGwgbm90Cj4gPj4+Pj4+IHdhaXQgYmVjYXVzZSAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUlVO
TklORywgJm1kZGV2LT5yZWNvdmVyeSkgd2lsbCBwYXNzLgo+ID4+Pj4+PiBTbyAnc3luY19zZXEn
IGlzIG9ubHkgdXNlZCB3aGVuIHRoZSBvbGQgc3luYyB0aHJlYWQgc3RvcHMgYW5kIG5ldyBzeW5j
Cj4gPj4+Pj4+IHRocmVhZCBzdGFydHMsIGFkZCAnc3luY19zZXEnIHdpbGwgYnlwYXNzIHRoaXMg
Y2FzZS4KPiA+Pj4+Pgo+ID4+Pj4+IEhpCj4gPj4+Pj4KPiA+Pj4+PiBJZiBhIG5ldyBzeW5jIHRo
cmVhZCBzdGFydHMsIHdoeSBjYW4gc3luY19zZXEgYmUgZGlmZmVyZW50PyBzeW5jX3NlcQo+ID4+
Pj4+IGlzIG9ubHkgYWRkZWQgaW4gbWRfcmVhcF9zeW5jX3RocmVhZC4gQW5kIHdoZW4gYSBuZXcg
c3luYyByZXF1ZXN0Cj4gPj4+Pj4gc3RhcnRzLCBpdCBjYW4ndCBzdG9wIHRoZSBzeW5jIHJlcXVl
c3QgYWdhaW4/Cj4gPj4+Pj4KPiA+Pj4+PiBBZiBmaXJzdCwgdGhlIHN5bmNfc2VxIGlzIDAKPiA+
Pj4+Pgo+ID4+Pj4+IGFkbWluMQo+ID4+Pj4+IGVjaG8gaWRsZSA+IHN5bmNfYWN0aW9uCj4gPj4+
Pj4gaWRsZV9zeW5jX3RocmVhZChzeW5jX3NlcSBpcyAxKQo+ID4+Pj4KPiA+Pj4+IFdhaXQsIEkn
bSBjb25mdXNlZCBoZXJlLCBob3cgY2FuIHN5bmNfc2VxIHRvIGJlIDEgaGVyZT8gSSBzdXBwb3Nl
IHlvdQo+ID4+Pj4gbWVhbiB0aGF0IHRoZXJlIGlzIGEgc3luY190aHJlYWQganVzdCBmaW5pc2hl
ZD8KPiA+Pj4KPiA+Pj4gSGkgS3VhaQo+ID4+Pgo+ID4+PiBZZXMuIEJlY2F1c2UgaWRsZV9zeW5j
X3RocmVhZCBuZWVkcyB0byB3YWl0IHVudGlsIG1kX3JlYXBfc3luY190aHJlYWQKPiA+Pj4gZmlu
aXNoZXMuIEFuZCBtZF9yZWFwX3N5bmNfdGhyZWFkIGFkZHMgc3luY19zZXEuIERvIEkgdW5kZXJz
dGFuZCB5b3VyCj4gPj4+IHBhdGNoIHJpZ2h0Pwo+ID4+Cj4gPj4gWWVzLCBub3RlZCB0aGF0IGlk
bGVfc3luY190aHJlYWQoKSB3aWxsIG9ubHkgd2FpdCBpZiBNRF9SRUNPVkVSWV9SVU5OSU5HCj4g
Pj4gaXMgc2V0Lgo+ID4+Cj4gPj4+Cj4gPj4+Pgo+ID4+Pj4gVGhlbiB0aGUgcHJvYmxlbSBpcyB0
aGF0IGlkbGVfc3luY190aHJlYWQoKSByZWFkIHN5bmNfc2VxIGFmdGVyIHRoZSBvbGQKPiA+Pj4+
IHN5bmNfdGhyZWFkIGlzIGRvbmUsIGFuZCBuZXcgc3luY190aHJlYWQgc3RhcnQgYmVmb3JlIHdh
aXRfZXZlbnQoKSBpcwo+ID4+Pj4gY2FsbGVkLCBzaG91bGQgd2Ugd2FpdCBmb3IgdGhpcyBuZXcg
c3luY190aHJlYWQ/Cj4gPj4+Pgo+ID4+Pj4gTXkgYW5zd2VyIGhlcmUgaXMgdGhhdCB3ZSBzaG91
bGQsIGJ1dCBJJ20gYWxzbyBvayB0byBub3Qgd2FpdCB0aGlzIG5ldwo+ID4+Pj4gc3luY190aHJl
YWQsIEkgZG9uJ3QgdGhpbmsgdGhpcyBiZWhhdmlvdXIgbWF0dGVycy4gVGhlIGtleSBwb2ludCBo
ZXJlCj4gPj4+PiBpcyB0aGF0IG9uY2Ugd2FpdF9ldmVudCgpIGlzIGNhbGxlZCBmcm9tIGlkbGVf
c3luY190aHJlYWQoKSwgdGhpcwo+ID4+Pj4gd2FpdF9ldmVudCgpIHNob3VsZCBub3Qgd2FpdCBm
b3IgbmV3IHN5bmNfdGhyZWFkLi4uCj4gPj4+Cj4gPj4+IEkgdGhpbmsgd2Ugc2hvdWxkIHdhaXQu
IElmIHdlIGRvbid0IHdhaXQgZm9yIGl0LCB0aGVyZSBpcyBhIHByb2JsZW0uCj4gPj4+IE9uZSBw
ZXJzb24gZWNob3MgaWRsZSB0byBzeW5jX2FjdGlvbiBhbmQgaXQgZG9lc24ndCB3b3JrIHNvbWV0
aW1lcy4KPiA+Pj4gSXQncyBhIHN0cmFuZ2UgdGhpbmcuCj4gPj4+Cj4gPj4KPiA+PiBPay4gSSds
bCBhZGQgbmV3IGNvbW1lbnQgdG8gZW1waGFzaXplIHRoYXQgaWRsZV9zeW5jX3RocmVhZCgpIHdv
bid0IHdhaXQKPiA+PiBmb3IgbmV3IHN5bmNfdGhyZWFkIHRoYXQgaXMgc3RhcnRlZCBhZnRlciB3
YWl0X2V2ZW50KCkuCj4gPgo+ID4gSSBzdWdnZXN0IHJlbW92aW5nIHRoaXMgZnVuY3Rpb24uIFdp
dGhvdXQgdGhpcyBjaGFuZ2UsIGl0J3MgbW9yZQo+ID4gc2ltcGxlIGFuZCBpdCBjYW4gd29yayB3
ZWxsIHdpdGhvdXQgcHJvYmxlbS4gVGhlIHBlb3BsZSB0aGF0IGVjaG8gaWRsZQo+ID4gdG8gc3lu
Y19hY3Rpb24gbmVlZHMgdG8gd2FpdCB1bnRpbCB0aGUgc3luYyBhY3Rpb24gZmluaXNoZXMuIFRo
ZSBjb2RlCj4gPiBzZW1hbnRpYyBpcyBjbGVhciBhbmQgc2ltcGxlLgo+ID4+Cj4gPj4+Pgo+ID4+
Pj4+IGVjaG8gcmVzeW5jID4gc3luY19hY3Rpb24gKG5ldyBzeW5jKQo+ID4+Pj4KPiA+Pj4+IElm
IHRoaXMgaXMgYmVoaW5kICJlY2hvIGlkbGUgPiBzeW5jX2FjdGlvbiIsIGlkbGVfc3luY190aHJl
YWQgc2hvdWxkIG5vdAo+ID4+Pj4gc2VlIHRoYXQgTURfUkVDT1ZFUllfUlVOTklORyBpcyBzZXQg
YW5kIHdhaXRfZXZlbnQoKSB3b24ndCB3YWl0IGF0IGFsbC4KPiA+Pj4KPiA+Pj4gYGVjaG8gcmVz
eW5jID4gc3luY19hY3Rpb25gIGNhbid0IGNoYW5nZSB0aGUgc3luY19zZXEuIFNvICdlY2hvIGlk
bGUgPgo+ID4+PiBzeW5jX2FjdGlvbicgc3RpbGwgd2FpdHMgdW50aWwgTURfUkVDT1ZFUllfUlVO
TklORyBpcyBjbGVhcmVkPwo+ID4+Cj4gPj4gVGhpcyBpcyBub3QgYWNjdXJhdGUsIGlmIGBlY2hv
IHJlc3luYyA+IHN5bmNfYWN0aW9uYCB0cmlnZ2VycyBhIG5ldwo+ID4+IHN5bmNfdGhyZWFkLCB0
aGVuIHN5bmNfc2VxIGlzIHVwZGF0ZWQgd2hlbiB0aGlzIHN5bmNfdGhyZWFkIGlzIGRvbmUsCj4g
Pj4gZHVyaW5nIHRoaXMgcGVyaW9kLCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIHN0aWxsIHNldCwg
c28gYGVjaG8gaWRsZQo+ID4+ICAgPnN5bmNfYWN0aW9uYCB3aWxsIHdhaXQgZm9yIHN5bmNfdGhy
ZWFkIHRvIGJlIGRvbmUuCj4gPgo+ID4gSSBjYW4gdW5kZXJzdGFuZCB5b3VyIGNvbW1lbnQsIGJ1
dCBzb3JyeSwgSSBzdGlsbCBjYW4ndCBnZXQgaG93Cj4gPiBzeW5jX3NlcSB3b3Jrcy4gQ291bGQg
eW91IGdpdmUgYSBzcGVjaWZpYyBjYXNlIHRoYXQgZXhwbGFpbnMgaG93IGl0Cj4gPiB3b3Jrcz8K
Pgo+IE9rLCB0aGUgcHJvYmxlbSBpcyB0aGF0IGVjaG8gaWxkZSBpcyBzdXBwb3NlZCB0byBpbnRl
cnJ1cHQgc3luY190aHJlYWQKPiBhbmQgc3RvcCBzeW5jX3RocmVhZCBxdWlja2x5LiBOb3cgdGhh
dCB3ZSBkb24ndCBob2xkIG11dGV4IGhlcmUsIHdlCj4gY2FuJ3QgcHJldmVudCBuZXcgc3luY190
aHJlYWQgdG8gc3RhcnQuIEZvciBleGFwbWxlOgo+Cj4gMSkgYSBzeW5jX3RocmVhZCBBIGlzIHJ1
bmluZywgTURfUkVDT1ZFUllfUlVOTklORyBpcyBzZXQ7Cj4KPiAyKSBlY2hvIGlkbGUsIEEgd2ls
bCBiZSBpbnRlcnJ1cHRlZCwgbXV0ZXggaXMgbm90IGhvbGQgYW5kCj4gaWRsZV9zeW5jX3RocmVh
ZCgpIGlzIHdhaXRpbmcgZm9yIE1EX1JFQ09WRVJZX1JVTk5JTkcgdG8gYmUgY2xlYXJlZC4KPgo+
IDMpIEEgaXMgaW50ZXJydXB0ZWQsIGl0J2xsIGNsZWFyIE1EX1JFQ09WRVJZX1JVTk5JTkcgYW5k
IHRyeSB0byB3YWtldXAKPiBpZGxlX3N5bmNfdGhyZWFkKCksIGhvd2V2ZXIsIGJlZm9yZSBpZGxl
X3N5bmNfdGhyZWFkKCkgaXMgd29rZW4sIEEgY2FuCj4gYmUgZG9uZSBhbmQgYSBuZXcgc3luY190
aHJlYWQgQiBjYW4gYmUgc3RhcnRlZCwgYW5kIE1EX1JFQ09WRVJZX1JVTk5JTkcKPiB3aWxsIGJl
IHNldCBhZ2Fpbi4KPgo+IDQpIGlkbGVfc3luY190aHJlYWQoKSBmaW5pYWxseSB3YWtlIHVwLCBo
b3dldmVyLCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzCj4gc2V0IGFuZCBpdCB3aWxsIHN0aWxsIHdh
aXRpbmcuIEFuZCB0aGlzIHRpbWUgQiB3b24ndCBiZSBpbnRlcnJ1cHRlZC4KClRoYW5rcyBmb3Ig
dGhlIGV4YW1wbGUuIEkgY2FuIHVuZGVyc3RhbmQgdGhlIHVzYWdlIG9mIGl0LiBJdCdzIHRoZQpz
aWRlIGVmZmVjdCB0aGF0IHJlbW92ZXMgdGhlIG11dGV4IHByb3RlY3Rpb24gZm9yIGlkbGVfc3lu
Y190aHJlYWQuCgpUaGVyZSBpcyBhIHByb2JsZW0uIE5ldyBzeW5jIHRocmVhZCBpcyBzdGFydGVk
IGluIG1kX2NoZWNrX3JlY292ZXJ5LgpBZnRlciB5b3VyIHBhdGNoLCBtZF9yZWFwX3N5bmNfdGhy
ZWFkIGlzIGNhbGxlZCBpbiBtZF9jaGVja19yZWNvdmVyeQp0b28uIFNvIGl0IGxvb2tzIGxpa2Ug
dGhleSBjYW4ndCBoYXBwZW4gYXQgdGhlIHNhbWUgdGltZT8KClJlZ2FyZHMKWGlhbwoKPgo+IFRo
YW5rcywKPiBLdWFpCj4KPiAtLQo+IGRtLWRldmVsIG1haWxpbmcgbGlzdAo+IGRtLWRldmVsQHJl
ZGhhdC5jb20KPiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

