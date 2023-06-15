Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4058BEB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 08:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686817537;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uRRGK4bCiOhymZcvR3OYSkvzBTQsKaf0/Xv3GyIQFNU=;
	b=F1WyCRxcOARaagjoFAzEHlUOf3WZ0eUQ0mFK5Q775DY+tHLUtP6WuEOwYfgRxQVp8RIx6W
	FPzCBnQrfTOohkPOA4zI6whYrCXWArXKSjv2vMXuawX2C1fuJPRRUF+uXNaMcCNRor7VU2
	HbH+rA3zNmd99evg27hLdf8J3UdZBwQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675--QuFZCugMMyRZbyYcyEL6A-1; Thu, 15 Jun 2023 04:25:33 -0400
X-MC-Unique: -QuFZCugMMyRZbyYcyEL6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54FE0282CCB3;
	Thu, 15 Jun 2023 08:25:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24B779E93;
	Thu, 15 Jun 2023 08:25:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB74A194658D;
	Thu, 15 Jun 2023 08:25:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7003A1946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 08:25:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 607FB141511F; Thu, 15 Jun 2023 08:18:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57B631410F01
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 08:18:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C0773C02B88
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 08:18:02 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-wOHhqxMkMp2DIIaa6s5LtQ-1; Thu, 15 Jun 2023 04:17:59 -0400
X-MC-Unique: wOHhqxMkMp2DIIaa6s5LtQ-1
Received: by mail-qv1-f71.google.com with SMTP id
 6a1803df08f44-62def0f1f57so3722996d6.1
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 01:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686817079; x=1689409079;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zMyYdaiPVzt79XchYsz5ru3F3M/jxlIaMf8ri/dWnFM=;
 b=MfkX4/so1CzbYQ8bTjOvVnd4I3XpwDsayCBZapbu6lrK6YUOvIPE/io5hi8GwzABz8
 laQ8BB/EYQ/nSaEnccb1+W4X+XBRaz8Cz1Dxf6K2vfuNBgIEGNTxVhJOx6Xr3VHTnBNU
 E37izAEXs4JthZkuLtKAlG1cpTbda+rYxCgQQTsUYDqpFX2gHo1D2zdOODQNvpTTZrVh
 3UcCUzd46/ddoTsIzYvs7JQqON2bFHJ5cM/rg6B9/DxXXomcOuIh18q/NJWJ5Jj2hjVc
 9YZqzrX7MQi8ODs2DvlnjHMIAx+zpMsDtNGKWCOB9qdg4oTAne2pRJCDFBV1UR6ciIn2
 fRdA==
X-Gm-Message-State: AC+VfDz9KB3paDZouRXJgypHI/Hf89CxQnQPRWNkdintn7LFgMwqiqBo
 sNHRjPhBf566KTNqUtm/8aCmFvxdIMY8UgH1nKDEnciudcb1EhEgdCcl9RHbsTqm6x0867n2KHG
 3+7KfIQ5ln7B8zy6T02ihsWjdrdloJwE=
X-Received: by 2002:a05:6214:1243:b0:625:b491:7911 with SMTP id
 r3-20020a056214124300b00625b4917911mr4592643qvv.21.1686817078978; 
 Thu, 15 Jun 2023 01:17:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6thK2JiCQjK9CdIrR8vFpzmLYrsZeb8U44C8Yf3HZLZey0Ddkiu0hBtZqB2KZ0swm4KHK1asIeAJQXLA/ZdQ0=
X-Received: by 2002:a05:6214:1243:b0:625:b491:7911 with SMTP id
 r3-20020a056214124300b00625b4917911mr4592632qvv.21.1686817078719; Thu, 15 Jun
 2023 01:17:58 -0700 (PDT)
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
In-Reply-To: <CALTww2-Wr8UbNFaLOyYv5Syh5q4J+hzRuo8Eakj_nOW+P4Cx7A@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 15 Jun 2023 16:17:46 +0800
Message-ID: <CALTww2_V=KVLqVVXpXZvGyrmT0N-WG1tFC+HaSEGNfHagaLHug@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgNDowMeKAr1BNIFhpYW8gTmkgPHhuaUByZWRoYXQuY29t
PiB3cm90ZToKPgo+IE9uIFRodSwgSnVuIDE1LCAyMDIzIGF0IDk6MjnigK9BTSBZdSBLdWFpIDx5
dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gPgo+ID4gSGksCj4gPgo+ID4g5ZyoIDIw
MjMvMDYvMTQgMTc6MDgsIFhpYW8gTmkg5YaZ6YGTOgo+ID4gPiBPbiBXZWQsIEp1biAxNCwgMjAy
MyBhdCA0OjI54oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+
ID4gPj4KPiA+ID4+IEhpLAo+ID4gPj4KPiA+ID4+IOWcqCAyMDIzLzA2LzE0IDE1OjU3LCBYaWFv
IE5pIOWGmemBkzoKPiA+ID4+PiBPbiBXZWQsIEp1biAxNCwgMjAyMyBhdCAzOjM44oCvUE0gWXUg
S3VhaSA8eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4gPj4+Pgo+ID4gPj4+PiBI
aSwKPiA+ID4+Pj4KPiA+ID4+Pj4g5ZyoIDIwMjMvMDYvMTQgMTU6MTIsIFhpYW8gTmkg5YaZ6YGT
Ogo+ID4gPj4+Pj4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5
dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gPiA+Pj4+Pj4KPiA+ID4+Pj4+PiBIaSwK
PiA+ID4+Pj4+Pgo+ID4gPj4+Pj4+IOWcqCAyMDIzLzA2LzE0IDk6NDgsIFl1IEt1YWkg5YaZ6YGT
Ogo+ID4gPj4+Pj4+Cj4gPiA+Pj4+Pj4KPiA+ID4+Pj4+Pj4+Cj4gPiA+Pj4+Pj4+PiBJbiB0aGUg
cGF0Y2gsIHN5bmNfc2VxIGlzIGFkZGVkIGluIG1kX3JlYXBfc3luY190aHJlYWQuIEluCj4gPiA+
Pj4+Pj4+PiBpZGxlX3N5bmNfdGhyZWFkLCBpZiBzeW5jX3NlcSBpc24ndCBlcXVhbAo+ID4gPj4+
Pj4+Pj4KPiA+ID4+Pj4+Pj4+IG1kZGV2LT5zeW5jX3NlcSwgaXQgc2hvdWxkIG1lYW4gdGhlcmUg
aXMgc29tZW9uZSB0aGF0IHN0b3BzIHRoZSBzeW5jCj4gPiA+Pj4+Pj4+PiB0aHJlYWQgYWxyZWFk
eSwgcmlnaHQ/IFdoeSBkbwo+ID4gPj4+Pj4+Pj4KPiA+ID4+Pj4+Pj4+IHlvdSBzYXkgJ25ldyBz
dGFydGVkIHN5bmMgdGhyZWFkJyBoZXJlPwo+ID4gPj4+Pj4+Cj4gPiA+Pj4+Pj4gSWYgc29tZW9u
ZSBzdG9wcyB0aGUgc3luYyB0aHJlYWQsIGFuZCBuZXcgc3luYyB0aHJlYWQgaXMgbm90IHN0YXJ0
ZWQsCj4gPiA+Pj4+Pj4gdGhlbiB0aGlzIHN5bmNfc2VxIHdvbid0IG1ha2UgYSBkaWZmZXJlbmNl
LCBhYm92ZSB3YWl0X2V2ZW50KCkgd2lsbCBub3QKPiA+ID4+Pj4+PiB3YWl0IGJlY2F1c2UgIXRl
c3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpIHdpbGwgcGFzcy4K
PiA+ID4+Pj4+PiBTbyAnc3luY19zZXEnIGlzIG9ubHkgdXNlZCB3aGVuIHRoZSBvbGQgc3luYyB0
aHJlYWQgc3RvcHMgYW5kIG5ldyBzeW5jCj4gPiA+Pj4+Pj4gdGhyZWFkIHN0YXJ0cywgYWRkICdz
eW5jX3NlcScgd2lsbCBieXBhc3MgdGhpcyBjYXNlLgo+ID4gPj4+Pj4KPiA+ID4+Pj4+IEhpCj4g
PiA+Pj4+Pgo+ID4gPj4+Pj4gSWYgYSBuZXcgc3luYyB0aHJlYWQgc3RhcnRzLCB3aHkgY2FuIHN5
bmNfc2VxIGJlIGRpZmZlcmVudD8gc3luY19zZXEKPiA+ID4+Pj4+IGlzIG9ubHkgYWRkZWQgaW4g
bWRfcmVhcF9zeW5jX3RocmVhZC4gQW5kIHdoZW4gYSBuZXcgc3luYyByZXF1ZXN0Cj4gPiA+Pj4+
PiBzdGFydHMsIGl0IGNhbid0IHN0b3AgdGhlIHN5bmMgcmVxdWVzdCBhZ2Fpbj8KPiA+ID4+Pj4+
Cj4gPiA+Pj4+PiBBZiBmaXJzdCwgdGhlIHN5bmNfc2VxIGlzIDAKPiA+ID4+Pj4+Cj4gPiA+Pj4+
PiBhZG1pbjEKPiA+ID4+Pj4+IGVjaG8gaWRsZSA+IHN5bmNfYWN0aW9uCj4gPiA+Pj4+PiBpZGxl
X3N5bmNfdGhyZWFkKHN5bmNfc2VxIGlzIDEpCj4gPiA+Pj4+Cj4gPiA+Pj4+IFdhaXQsIEknbSBj
b25mdXNlZCBoZXJlLCBob3cgY2FuIHN5bmNfc2VxIHRvIGJlIDEgaGVyZT8gSSBzdXBwb3NlIHlv
dQo+ID4gPj4+PiBtZWFuIHRoYXQgdGhlcmUgaXMgYSBzeW5jX3RocmVhZCBqdXN0IGZpbmlzaGVk
Pwo+ID4gPj4+Cj4gPiA+Pj4gSGkgS3VhaQo+ID4gPj4+Cj4gPiA+Pj4gWWVzLiBCZWNhdXNlIGlk
bGVfc3luY190aHJlYWQgbmVlZHMgdG8gd2FpdCB1bnRpbCBtZF9yZWFwX3N5bmNfdGhyZWFkCj4g
PiA+Pj4gZmluaXNoZXMuIEFuZCBtZF9yZWFwX3N5bmNfdGhyZWFkIGFkZHMgc3luY19zZXEuIERv
IEkgdW5kZXJzdGFuZCB5b3VyCj4gPiA+Pj4gcGF0Y2ggcmlnaHQ/Cj4gPiA+Pgo+ID4gPj4gWWVz
LCBub3RlZCB0aGF0IGlkbGVfc3luY190aHJlYWQoKSB3aWxsIG9ubHkgd2FpdCBpZiBNRF9SRUNP
VkVSWV9SVU5OSU5HCj4gPiA+PiBpcyBzZXQuCj4gPiA+Pgo+ID4gPj4+Cj4gPiA+Pj4+Cj4gPiA+
Pj4+IFRoZW4gdGhlIHByb2JsZW0gaXMgdGhhdCBpZGxlX3N5bmNfdGhyZWFkKCkgcmVhZCBzeW5j
X3NlcSBhZnRlciB0aGUgb2xkCj4gPiA+Pj4+IHN5bmNfdGhyZWFkIGlzIGRvbmUsIGFuZCBuZXcg
c3luY190aHJlYWQgc3RhcnQgYmVmb3JlIHdhaXRfZXZlbnQoKSBpcwo+ID4gPj4+PiBjYWxsZWQs
IHNob3VsZCB3ZSB3YWl0IGZvciB0aGlzIG5ldyBzeW5jX3RocmVhZD8KPiA+ID4+Pj4KPiA+ID4+
Pj4gTXkgYW5zd2VyIGhlcmUgaXMgdGhhdCB3ZSBzaG91bGQsIGJ1dCBJJ20gYWxzbyBvayB0byBu
b3Qgd2FpdCB0aGlzIG5ldwo+ID4gPj4+PiBzeW5jX3RocmVhZCwgSSBkb24ndCB0aGluayB0aGlz
IGJlaGF2aW91ciBtYXR0ZXJzLiBUaGUga2V5IHBvaW50IGhlcmUKPiA+ID4+Pj4gaXMgdGhhdCBv
bmNlIHdhaXRfZXZlbnQoKSBpcyBjYWxsZWQgZnJvbSBpZGxlX3N5bmNfdGhyZWFkKCksIHRoaXMK
PiA+ID4+Pj4gd2FpdF9ldmVudCgpIHNob3VsZCBub3Qgd2FpdCBmb3IgbmV3IHN5bmNfdGhyZWFk
Li4uCj4gPiA+Pj4KPiA+ID4+PiBJIHRoaW5rIHdlIHNob3VsZCB3YWl0LiBJZiB3ZSBkb24ndCB3
YWl0IGZvciBpdCwgdGhlcmUgaXMgYSBwcm9ibGVtLgo+ID4gPj4+IE9uZSBwZXJzb24gZWNob3Mg
aWRsZSB0byBzeW5jX2FjdGlvbiBhbmQgaXQgZG9lc24ndCB3b3JrIHNvbWV0aW1lcy4KPiA+ID4+
PiBJdCdzIGEgc3RyYW5nZSB0aGluZy4KPiA+ID4+Pgo+ID4gPj4KPiA+ID4+IE9rLiBJJ2xsIGFk
ZCBuZXcgY29tbWVudCB0byBlbXBoYXNpemUgdGhhdCBpZGxlX3N5bmNfdGhyZWFkKCkgd29uJ3Qg
d2FpdAo+ID4gPj4gZm9yIG5ldyBzeW5jX3RocmVhZCB0aGF0IGlzIHN0YXJ0ZWQgYWZ0ZXIgd2Fp
dF9ldmVudCgpLgo+ID4gPgo+ID4gPiBJIHN1Z2dlc3QgcmVtb3ZpbmcgdGhpcyBmdW5jdGlvbi4g
V2l0aG91dCB0aGlzIGNoYW5nZSwgaXQncyBtb3JlCj4gPiA+IHNpbXBsZSBhbmQgaXQgY2FuIHdv
cmsgd2VsbCB3aXRob3V0IHByb2JsZW0uIFRoZSBwZW9wbGUgdGhhdCBlY2hvIGlkbGUKPiA+ID4g
dG8gc3luY19hY3Rpb24gbmVlZHMgdG8gd2FpdCB1bnRpbCB0aGUgc3luYyBhY3Rpb24gZmluaXNo
ZXMuIFRoZSBjb2RlCj4gPiA+IHNlbWFudGljIGlzIGNsZWFyIGFuZCBzaW1wbGUuCj4gPiA+Pgo+
ID4gPj4+Pgo+ID4gPj4+Pj4gZWNobyByZXN5bmMgPiBzeW5jX2FjdGlvbiAobmV3IHN5bmMpCj4g
PiA+Pj4+Cj4gPiA+Pj4+IElmIHRoaXMgaXMgYmVoaW5kICJlY2hvIGlkbGUgPiBzeW5jX2FjdGlv
biIsIGlkbGVfc3luY190aHJlYWQgc2hvdWxkIG5vdAo+ID4gPj4+PiBzZWUgdGhhdCBNRF9SRUNP
VkVSWV9SVU5OSU5HIGlzIHNldCBhbmQgd2FpdF9ldmVudCgpIHdvbid0IHdhaXQgYXQgYWxsLgo+
ID4gPj4+Cj4gPiA+Pj4gYGVjaG8gcmVzeW5jID4gc3luY19hY3Rpb25gIGNhbid0IGNoYW5nZSB0
aGUgc3luY19zZXEuIFNvICdlY2hvIGlkbGUgPgo+ID4gPj4+IHN5bmNfYWN0aW9uJyBzdGlsbCB3
YWl0cyB1bnRpbCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIGNsZWFyZWQ/Cj4gPiA+Pgo+ID4gPj4g
VGhpcyBpcyBub3QgYWNjdXJhdGUsIGlmIGBlY2hvIHJlc3luYyA+IHN5bmNfYWN0aW9uYCB0cmln
Z2VycyBhIG5ldwo+ID4gPj4gc3luY190aHJlYWQsIHRoZW4gc3luY19zZXEgaXMgdXBkYXRlZCB3
aGVuIHRoaXMgc3luY190aHJlYWQgaXMgZG9uZSwKPiA+ID4+IGR1cmluZyB0aGlzIHBlcmlvZCwg
TURfUkVDT1ZFUllfUlVOTklORyBpcyBzdGlsbCBzZXQsIHNvIGBlY2hvIGlkbGUKPiA+ID4+ICAg
PnN5bmNfYWN0aW9uYCB3aWxsIHdhaXQgZm9yIHN5bmNfdGhyZWFkIHRvIGJlIGRvbmUuCj4gPiA+
Cj4gPiA+IEkgY2FuIHVuZGVyc3RhbmQgeW91ciBjb21tZW50LCBidXQgc29ycnksIEkgc3RpbGwg
Y2FuJ3QgZ2V0IGhvdwo+ID4gPiBzeW5jX3NlcSB3b3Jrcy4gQ291bGQgeW91IGdpdmUgYSBzcGVj
aWZpYyBjYXNlIHRoYXQgZXhwbGFpbnMgaG93IGl0Cj4gPiA+IHdvcmtzPwo+ID4KPiA+IE9rLCB0
aGUgcHJvYmxlbSBpcyB0aGF0IGVjaG8gaWxkZSBpcyBzdXBwb3NlZCB0byBpbnRlcnJ1cHQgc3lu
Y190aHJlYWQKPiA+IGFuZCBzdG9wIHN5bmNfdGhyZWFkIHF1aWNrbHkuIE5vdyB0aGF0IHdlIGRv
bid0IGhvbGQgbXV0ZXggaGVyZSwgd2UKPiA+IGNhbid0IHByZXZlbnQgbmV3IHN5bmNfdGhyZWFk
IHRvIHN0YXJ0LiBGb3IgZXhhcG1sZToKPiA+Cj4gPiAxKSBhIHN5bmNfdGhyZWFkIEEgaXMgcnVu
aW5nLCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIHNldDsKPiA+Cj4gPiAyKSBlY2hvIGlkbGUsIEEg
d2lsbCBiZSBpbnRlcnJ1cHRlZCwgbXV0ZXggaXMgbm90IGhvbGQgYW5kCj4gPiBpZGxlX3N5bmNf
dGhyZWFkKCkgaXMgd2FpdGluZyBmb3IgTURfUkVDT1ZFUllfUlVOTklORyB0byBiZSBjbGVhcmVk
Lgo+ID4KPiA+IDMpIEEgaXMgaW50ZXJydXB0ZWQsIGl0J2xsIGNsZWFyIE1EX1JFQ09WRVJZX1JV
Tk5JTkcgYW5kIHRyeSB0byB3YWtldXAKPiA+IGlkbGVfc3luY190aHJlYWQoKSwgaG93ZXZlciwg
YmVmb3JlIGlkbGVfc3luY190aHJlYWQoKSBpcyB3b2tlbiwgQSBjYW4KPiA+IGJlIGRvbmUgYW5k
IGEgbmV3IHN5bmNfdGhyZWFkIEIgY2FuIGJlIHN0YXJ0ZWQsIGFuZCBNRF9SRUNPVkVSWV9SVU5O
SU5HCj4gPiB3aWxsIGJlIHNldCBhZ2Fpbi4KPiA+Cj4gPiA0KSBpZGxlX3N5bmNfdGhyZWFkKCkg
ZmluaWFsbHkgd2FrZSB1cCwgaG93ZXZlciwgTURfUkVDT1ZFUllfUlVOTklORyBpcwo+ID4gc2V0
IGFuZCBpdCB3aWxsIHN0aWxsIHdhaXRpbmcuIEFuZCB0aGlzIHRpbWUgQiB3b24ndCBiZSBpbnRl
cnJ1cHRlZC4KPgo+IFRoYW5rcyBmb3IgdGhlIGV4YW1wbGUuIEkgY2FuIHVuZGVyc3RhbmQgdGhl
IHVzYWdlIG9mIGl0LiBJdCdzIHRoZQo+IHNpZGUgZWZmZWN0IHRoYXQgcmVtb3ZlcyB0aGUgbXV0
ZXggcHJvdGVjdGlvbiBmb3IgaWRsZV9zeW5jX3RocmVhZC4KPgo+IFRoZXJlIGlzIGEgcHJvYmxl
bS4gTmV3IHN5bmMgdGhyZWFkIGlzIHN0YXJ0ZWQgaW4gbWRfY2hlY2tfcmVjb3ZlcnkuCj4gQWZ0
ZXIgeW91ciBwYXRjaCwgbWRfcmVhcF9zeW5jX3RocmVhZCBpcyBjYWxsZWQgaW4gbWRfY2hlY2tf
cmVjb3ZlcnkKPiB0b28uIFNvIGl0IGxvb2tzIGxpa2UgdGhleSBjYW4ndCBoYXBwZW4gYXQgdGhl
IHNhbWUgdGltZT8KCkFmdGVyIHRoaW5raW5nIGEgd2hpbGUsIHRoZXJlIGlzIHN0aWxsIGEgcmFj
ZSBwb3NzaWJpbGl0eS4KCm1kX3JlYXBfc3luY190aHJlYWQgaXMgY2FsbGVkIGluIHBlcnMgZGVh
bW9uIChlLmcuIHJhaWQxMGQgLT4KbWRfY2hlY2tfcmVjb3ZlcnkpIGFuZCBtZF9jaGVja19yZWNv
dmVyeSByZXR1cm5zLiBCZWZvcmUKaWRsZV9zeW5jX3RocmVhZCBpcyB3b2tlbiwgdGhlIG5ldyBz
eW5jIHRocmVhZCBjYW4gYmUgc3RhcnRlZCBpbgptZF9jaGVja19yZWNvdmVyeSBhZ2Fpbi4KCkJ1
dCBpdCdzIHJlYWxseSBzdHJhbmdlLCB3aGVuIG9uZSBwZW9wbGUgZWNobyBpZGxlIHRvIHN5bmNf
YWN0aW9uLgpJdCdzIGJldHRlciB0byBhZGQgc29tZSBtZXNzYWdlcyB0byBub3RpZnkgdGhlIHVz
ZXJzIHRoYXQgdGhleSBuZWVkIHRvCmVjaG8gaWRsZSB0byBzeW5jX2FjdGlvbiBhZ2FpbiB0byBo
YXZlIGEgdHJ5LiBJcyB0aGVyZSBhIHdheSB0aGF0Cm1kX3JlYXBfc3luY190aHJlYWQgY2FuIHdh
aXQgaWRsZV9zeW5jX3RocmVhZD8KClJlZ2FyZHMKWGlhbwo+Cj4gUmVnYXJkcwo+IFhpYW8KPgo+
ID4KPiA+IFRoYW5rcywKPiA+IEt1YWkKPiA+Cj4gPiAtLQo+ID4gZG0tZGV2ZWwgbWFpbGluZyBs
aXN0Cj4gPiBkbS1kZXZlbEByZWRoYXQuY29tCj4gPiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

