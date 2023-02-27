Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA60C7EE2E
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677521226;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w8Q3yu1z33WQRdz/XYZOjyWF+ZxX6yLAdwtjpOfNIiE=;
	b=d1aJ3ItV9+Jaizqj2/msF9iWAsgn3WjF87/G4I72NtoG6B6EbttwDAs1Kp52GQnOCyvQ4T
	qW94wyqP5neb8cf9Urk0nIr9Si2vvI7i5wc12opQ5di24cGxgSB5stmNPLHBwUwr/0QZp6
	xwQVUN4VHyHDwFDPPsEYMu4IG8lbDBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-qQAtYTBHP_ebCqL--6PK8w-1; Mon, 27 Feb 2023 13:07:02 -0500
X-MC-Unique: qQAtYTBHP_ebCqL--6PK8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62CB0802D2F;
	Mon, 27 Feb 2023 18:07:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FB9D2026D4B;
	Mon, 27 Feb 2023 18:07:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 193E51946587;
	Mon, 27 Feb 2023 18:07:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA42A1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 18:06:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12506492B11; Mon, 27 Feb 2023 18:06:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B27B492B0F
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 18:06:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E23152A5957C
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 18:06:32 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-457-xq8q8oZ3O2Sy1mFv5lkKXA-1; Mon, 27 Feb 2023 13:06:30 -0500
X-MC-Unique: xq8q8oZ3O2Sy1mFv5lkKXA-1
Received: by mail-qt1-f169.google.com with SMTP id w23so7630534qtn.6
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 10:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=zADyGnNyOErx9hmIHfm8O2Vrmx1efQHxt2G9Laj8Ti8=;
 b=wS3QAwFhYmEc8BM5qgxvwRceGpRiPK1aHOIOpptnIvUTeG/ducatN1rQCciErkBWhq
 ZskSmuOpSkG6ku5TnKNY7UMv+w4FmQ93o0ZLP0GZ7kObL57ssA3I2cMdsA/QYm1KxKz+
 2bTexjwBgU+TKm9++RJR5V25uW8yp3oIdYSuF0aeKVd407/F1uoRyZG8eIbdOtMjomX9
 HzbCACSCrz3xXqz9FYpZWQTK0kFkEtQ0l4Rf5Hn3LlLjQeMhg92TviddJ+UL/tE4UbHi
 MN5JTWOhIYLYP2lLcMdf7X8oxiWOnjx7OoJmi/YuoLWRUD7vzO7Sz1Bn8Ak6FxQkfFxQ
 9X8A==
X-Gm-Message-State: AO0yUKWZvtTiSr+N3ZChoZDefFCI/CZbp/OQ0eHhG1sJHmNAQG+9Rvvg
 guQFP81gkjjM439olX5GMniYjmg=
X-Google-Smtp-Source: AK7set9cKfjmba0uRmSZQKKnN5ZdDPO7IIpXqCZ07/wW4Xbym9wenQJUgQQLXH6xjCaYVeyCgfFrjw==
X-Received: by 2002:a05:622a:48f:b0:3bf:c961:9309 with SMTP id
 p15-20020a05622a048f00b003bfc9619309mr270182qtx.37.1677521189270; 
 Mon, 27 Feb 2023 10:06:29 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d26-20020ac851da000000b003b9a73cd120sm4961320qtn.17.2023.02.27.10.06.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Feb 2023 10:06:28 -0800 (PST)
Date: Mon, 27 Feb 2023 13:06:27 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: yangerkun <yangerkun@huaweicloud.com>
Message-ID: <Y/zxI4wK8trtuJgV@redhat.com>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com> <Y/zwVCNDrdAbzC7a@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y/zwVCNDrdAbzC7a@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com,
 Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBGZWIgMjcgMjAyMyBhdCAgMTowM1AgLTA1MDAsCk1pa2UgU25pdHplciA8c25pdHpl
ckBrZXJuZWwub3JnPiB3cm90ZToKCj4gT24gTW9uLCBGZWIgMjcgMjAyMyBhdCAxMjo1NVAgLTA1
MDAsCj4gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+IAo+ID4gT24g
U3VuLCBGZWIgMjYgMjAyMyBhdCAgODozMVAgLTA1MDAsCj4gPiB5YW5nZXJrdW4gPHlhbmdlcmt1
bkBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4gCj4gPiA+IAo+ID4gPiAKPiA+ID4g5ZyoIDIw
MjMvMi8yNiAxMDowMSwgQmFydCBWYW4gQXNzY2hlIOWGmemBkzoKPiA+ID4gPiBPbiAyLzIyLzIz
IDE5OjE5LCB5YW5nZXJrdW4gd3JvdGU6Cj4gPiA+ID4gPiBAQCAtMTkyNCw2ICsxOTI2LDEwIEBA
IHN0YXRpYyBpbnQgZG1jcnlwdF93cml0ZSh2b2lkICpkYXRhKQo+ID4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgIEJVR19PTihyYl9wYXJlbnQod3JpdGVfdHJlZS5yYl9ub2RlKSk7Cj4gPiA+ID4g
PiArwqDCoMKgwqDCoMKgwqAgaWYgKHRpbWVfaXNfYmVmb3JlX2ppZmZpZXMoc3RhcnRfdGltZSAr
IEhaKSkgewo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2NoZWR1bGUoKTsKPiA+
ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0YXJ0X3RpbWUgPSBqaWZmaWVzOwo+ID4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgIH0KPiA+ID4gPiAKPiA+ID4gPiBXaHkgc2NoZWR1bGUoKSBp
bnN0ZWFkIG9mIGNvbmRfcmVzY2hlZCgpPwo+ID4gPiAKPiA+ID4gY29uZF9yZXNjaGVkIG1heSBu
b3QgcmVhbGx5IHNjaGVkdWxlLCB3aGljaCBtYXkgdHJpZ2dlciB0aGUgcHJvYmxlbSB0b28sIGJ1
dAo+ID4gPiBpdCBzZWVtcyBhZnRlciAxIHNlY29uZCwgaXQgbWF5IG5ldmVyIGhhcHBlbmQ/Cj4g
PiAKPiA+IEkgaGFkIHRoZSBzYW1lIHF1ZXN0aW9uIGFzIEJhcnQgd2hlbiByZXZpZXdpbmcgeW91
ciBob21lZ3Jvd24KPiA+IGNvbmRpdGlvbmFsIHNjaGVkdWxlKCkuICBIb3BlZnVsbHkgeW91IGNh
biByZXByb2R1Y2UgdGhpcyBpc3N1ZT8gIElmCj4gPiBzbywgcGxlYXNlIHNlZSBpZiBzaW1wbHkg
dXNpbmcgY29uZF9yZXNjaGVkKCkgZml4ZXMgdGhlIGlzc3VlLgo+IAo+IFRoaXMgc2VlbXMgbGlr
ZSBhIG1vcmUgYXBwcm9wcmlhdGUgcGF0Y2g6Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQv
ZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+IGluZGV4IDg3YzU3MDYxMzFmMi4u
ZmFiYTFiZTU3MmY5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ICsrKyBi
L2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+IEBAIC0xOTM3LDYgKzE5MzcsNyBAQCBzdGF0aWMgaW50
IGRtY3J5cHRfd3JpdGUodm9pZCAqZGF0YSkKPiAgCQkJaW8gPSBjcnlwdF9pb19mcm9tX25vZGUo
cmJfZmlyc3QoJndyaXRlX3RyZWUpKTsKPiAgCQkJcmJfZXJhc2UoJmlvLT5yYl9ub2RlLCAmd3Jp
dGVfdHJlZSk7Cj4gIAkJCWtjcnlwdGRfaW9fd3JpdGUoaW8pOwo+ICsJCQljb25kX3Jlc2NoZWQo
KTsKPiAgCQl9IHdoaWxlICghUkJfRU1QVFlfUk9PVCgmd3JpdGVfdHJlZSkpOwo+ICAJCWJsa19m
aW5pc2hfcGx1ZygmcGx1Zyk7Cj4gIAl9CgoKb3I6CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9k
bS1jcnlwdC5jIGIvZHJpdmVycy9tZC9kbS1jcnlwdC5jCmluZGV4IDg3YzU3MDYxMzFmMi4uM2Jh
MmZkM2U0MzU4IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMKKysrIGIvZHJpdmVy
cy9tZC9kbS1jcnlwdC5jCkBAIC0xOTM0LDYgKzE5MzQsNyBAQCBzdGF0aWMgaW50IGRtY3J5cHRf
d3JpdGUodm9pZCAqZGF0YSkKIAkJICovCiAJCWJsa19zdGFydF9wbHVnKCZwbHVnKTsKIAkJZG8g
eworCQkJY29uZF9yZXNjaGVkKCk7CiAJCQlpbyA9IGNyeXB0X2lvX2Zyb21fbm9kZShyYl9maXJz
dCgmd3JpdGVfdHJlZSkpOwogCQkJcmJfZXJhc2UoJmlvLT5yYl9ub2RlLCAmd3JpdGVfdHJlZSk7
CiAJCQlrY3J5cHRkX2lvX3dyaXRlKGlvKTsKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

