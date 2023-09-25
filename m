Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB55CCE7A81
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 07:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695626656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pHwes63/JL+nzInMH2TwsxRH6TojsonjmIveZZ08K4U=;
	b=RwQ3qRw7jeRUt9HdMV2cYoajBURBBByK7JGqb66NI95OpiZgpjMZYTZUaKme+F/FwrlIEs
	Lay2TMzw9O4suAQ01kHNuAGw3zMdBVYtiC9+qCBB3n1gMtT/wgYlf8zINW7F1hetul3Teb
	uloKHyoRae7EXlEGIEfvF+/xy2mFPv8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-1gJ8N9aZM5mvt3MBlyRaCA-1; Mon, 25 Sep 2023 03:24:12 -0400
X-MC-Unique: 1gJ8N9aZM5mvt3MBlyRaCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E502E3821355;
	Mon, 25 Sep 2023 07:24:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD0719A;
	Mon, 25 Sep 2023 07:24:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 97EF01946597;
	Mon, 25 Sep 2023 07:24:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CF62194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 07:24:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4A5A640C6E76; Mon, 25 Sep 2023 07:24:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 42C7240C6EA8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 07:24:09 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24116185A78E
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 07:24:09 +0000 (UTC)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-d5cirUaOM0iFTC5fOEy-7Q-1; Mon, 25 Sep 2023 03:24:07 -0400
X-MC-Unique: d5cirUaOM0iFTC5fOEy-7Q-1
Received: by mail-pj1-f71.google.com with SMTP id
 98e67ed59e1d1-277277fd56aso2205162a91.2
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 00:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695626646; x=1696231446;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rBYVDv59hkrAfmI0h5SRhnoDO8K6NGX5hpGfXWLtREA=;
 b=hkTtnyg7FRYHqaur7DoZgpWyka8Hl9AtRXcVhb0UHpg9k6kIMPK/RP/CgcCvkExLdX
 Czsrdz14drTa8svKOjaU836/7pnG0AX8RjsSOMkBUUiuLJBkAAntHqMCPFcHt6Eeag4U
 wT29+SXWrZIOHY0DIhfSNFfZjAb61/mm6dcyzCTlr2epLWF1AkkGm0LUTbUq5Cvd5c15
 flQpOw/W9TNytYAGbO4yKgk23XiRsR7xeRx2H0w1WFcR4X/s5q6gcT4tHeVM2G/Dnf5a
 V/e+9Zz7JufHqUrRTIR7DRINPuJuprmGnBUeYO3JBlsFcU0mmNax+RlUsiWdkcnwJUVh
 h0uw==
X-Gm-Message-State: AOJu0Yxf9hK2WVL3UkKj7Aa76RHWu+uP1zMEfZoP2YdwFxfhhs0sGnJu
 WNSpYDtkvujMfA+9vmcwURyDBWkykFZAITrcji+nTKKQJBrxCEM6mNuBeIb6m8pEpWpbOpTBc+O
 jV7B/+G7nlsUa7c2NAI2fvbVmAfq09DM=
X-Received: by 2002:a17:90a:bc8f:b0:274:6f67:e7a8 with SMTP id
 x15-20020a17090abc8f00b002746f67e7a8mr3492878pjr.45.1695626646533; 
 Mon, 25 Sep 2023 00:24:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhzuwiDu+C3Qa+Azw1g/b0tA+ssVnU7jrLFt/a/nt4NNBzTQg2Ww8KFDbh0FHMsHITpWO2zDNu3lPYhux5+ss=
X-Received: by 2002:a17:90a:bc8f:b0:274:6f67:e7a8 with SMTP id
 x15-20020a17090abc8f00b002746f67e7a8mr3492869pjr.45.1695626646245; Mon, 25
 Sep 2023 00:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-4-yukuai1@huaweicloud.com>
 <CALTww2-5F=C5N6YZ-3weD9xSWhpT6Mx8NkaevfXZWqR6=Bwc4A@mail.gmail.com>
In-Reply-To: <CALTww2-5F=C5N6YZ-3weD9xSWhpT6Mx8NkaevfXZWqR6=Bwc4A@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 25 Sep 2023 15:23:54 +0800
Message-ID: <CALTww2_VHCihAYBj39abNCO+M+HuHybnzVh6T_jf25NiBBLZ-g@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH -next v2 03/28] md: add new helpers to
 suspend/resume array
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
 dm-devel@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBTZXAgMjUsIDIwMjMgYXQgMzoyMeKAr1BNIFhpYW8gTmkgPHhuaUByZWRoYXQuY29t
PiB3cm90ZToKPgo+IE9uIE1vbiwgQXVnIDI4LCAyMDIzIGF0IDEwOjA04oCvQU0gWXUgS3VhaSA8
eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4KPiA+IEZyb206IFl1IEt1YWkgPHl1
a3VhaTNAaHVhd2VpLmNvbT4KPiA+Cj4gPiBBZHZhbnRhZ2VzIGZvciBuZXcgYXBpczoKPiA+ICAt
IHJlY29uZmlnX211dGV4IGlzIG5vdCByZXF1aXJlZDsKPiA+ICAtIHRoZSB3ZWlyZCBsb2dpY2Fs
IHRoYXQgc3VzcGVuZCBhcnJheSBob2xkICdyZWNvbmZpZ19tdXRleCcgZm9yCj4gPiAgICBtZGRl
dl9jaGVja19yZWNvdmVyeSgpIHRvIHVwZGF0ZSBzdXBlcmJsb2NrIGlzIG5vdCBuZWVkZWQ7Cj4g
PiAgLSB0aGUgc3BlY2FpbCBoYW5kbGluZywgJ3BlcnMtPnByZXBhcmVfc3VzcGVuZCcsIGZvciBy
YWlkNDU2IGlzIG5vdAo+ID4gICAgbmVlZGVkOwo+ID4gIC0gSXQncyBzYWZlIHRvIGJlIGNhbGxl
ZCBhdCBhbnkgdGltZSBvbmNlIG1kZGV2IGlzIGFsbG9jYXRlZCwgYW5kIGl0J3MKPiA+ICAgIGRl
c2lnbmVkIHRvIGJlIHVzZWQgZnJvbSBzbG93IHBhdGggd2hlcmUgYXJyYXkgY29uZmlndXJhdGlv
biBpcyBjaGFuZ2VkOwo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVh
d2VpLmNvbT4KPiA+IC0tLQo+ID4gIGRyaXZlcnMvbWQvbWQuYyB8IDg1ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KPiA+ICBkcml2ZXJzL21kL21kLmgg
fCAgMyArKwo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgODYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKPiA+Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9t
ZC5jCj4gPiBpbmRleCA3ZmEzMTFhMTQzMTcuLjYyMzZlMmUzOTVjMSAxMDA2NDQKPiA+IC0tLSBh
L2RyaXZlcnMvbWQvbWQuYwo+ID4gKysrIGIvZHJpdmVycy9tZC9tZC5jCj4gPiBAQCAtNDQzLDEy
ICs0NDMsMjIgQEAgdm9pZCBtZGRldl9zdXNwZW5kKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICBsb2NrZGVwX2lzX2hlbGQoJm1kZGV2LT5yZWNvbmZpZ19t
dXRleCkpOwo+ID4KPiA+ICAgICAgICAgV0FSTl9PTl9PTkNFKHRocmVhZCAmJiBjdXJyZW50ID09
IHRocmVhZC0+dHNrKTsKPiA+IC0gICAgICAgaWYgKG1kZGV2LT5zdXNwZW5kZWQrKykKPiA+ICsK
PiA+ICsgICAgICAgLyogY2FuJ3QgY29uY3VycmVudCB3aXRoIF9fbWRkZXZfc3VzcGVuZCgpIGFu
ZCBfX21kZGV2X3Jlc3VtZSgpICovCj4gPiArICAgICAgIG11dGV4X2xvY2soJm1kZGV2LT5zdXNw
ZW5kX211dGV4KTsKPiA+ICsgICAgICAgaWYgKG1kZGV2LT5zdXNwZW5kZWQrKykgewo+ID4gKyAg
ICAgICAgICAgICAgIG11dGV4X3VubG9jaygmbWRkZXYtPnN1c3BlbmRfbXV0ZXgpOwo+ID4gICAg
ICAgICAgICAgICAgIHJldHVybjsKPiA+ICsgICAgICAgfQo+ID4gKwo+ID4gICAgICAgICB3YWtl
X3VwKCZtZGRldi0+c2Jfd2FpdCk7Cj4gPiAgICAgICAgIHNldF9iaXQoTURfQUxMT1dfU0JfVVBE
QVRFLCAmbWRkZXYtPmZsYWdzKTsKPiA+ICAgICAgICAgcGVyY3B1X3JlZl9raWxsKCZtZGRldi0+
YWN0aXZlX2lvKTsKPiA+Cj4gPiArICAgICAgIC8qCj4gPiArICAgICAgICAqIFRPRE86IGNsZWFu
dXAgJ3BlcnMtPnByZXBhcmVfc3VzcGVuZCBhZnRlciBhbGwgY2FsbGVycyBhcmUgcmVwbGFjZWQK
PiA+ICsgICAgICAgICogYnkgX19tZGRldl9zdXNwZW5kKCkuCj4gPiArICAgICAgICAqLwo+ID4g
ICAgICAgICBpZiAobWRkZXYtPnBlcnMgJiYgbWRkZXYtPnBlcnMtPnByZXBhcmVfc3VzcGVuZCkK
PiA+ICAgICAgICAgICAgICAgICBtZGRldi0+cGVycy0+cHJlcGFyZV9zdXNwZW5kKG1kZGV2KTsK
PiA+Cj4gPiBAQCAtNDU5LDE0ICs0NjksMjEgQEAgdm9pZCBtZGRldl9zdXNwZW5kKHN0cnVjdCBt
ZGRldiAqbWRkZXYpCj4gPiAgICAgICAgIGRlbF90aW1lcl9zeW5jKCZtZGRldi0+c2FmZW1vZGVf
dGltZXIpOwo+ID4gICAgICAgICAvKiByZXN0cmljdCBtZW1vcnkgcmVjbGFpbSBJL08gZHVyaW5n
IHJhaWQgYXJyYXkgaXMgc3VzcGVuZCAqLwo+ID4gICAgICAgICBtZGRldi0+bm9pb19mbGFnID0g
bWVtYWxsb2Nfbm9pb19zYXZlKCk7Cj4gPiArCj4gPiArICAgICAgIG11dGV4X3VubG9jaygmbWRk
ZXYtPnN1c3BlbmRfbXV0ZXgpOwo+ID4gIH0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChtZGRldl9z
dXNwZW5kKTsKPiA+Cj4gPiAgdm9pZCBtZGRldl9yZXN1bWUoc3RydWN0IG1kZGV2ICptZGRldikK
PiA+ICB7Cj4gPiAgICAgICAgIGxvY2tkZXBfYXNzZXJ0X2hlbGQoJm1kZGV2LT5yZWNvbmZpZ19t
dXRleCk7Cj4gPiAtICAgICAgIGlmICgtLW1kZGV2LT5zdXNwZW5kZWQpCj4gPiArCj4gPiArICAg
ICAgIC8qIGNhbid0IGNvbmN1cnJlbnQgd2l0aCBfX21kZGV2X3N1c3BlbmQoKSBhbmQgX19tZGRl
dl9yZXN1bWUoKSAqLwo+ID4gKyAgICAgICBtdXRleF9sb2NrKCZtZGRldi0+c3VzcGVuZF9tdXRl
eCk7Cj4gPiArICAgICAgIGlmICgtLW1kZGV2LT5zdXNwZW5kZWQpIHsKPiA+ICsgICAgICAgICAg
ICAgICBtdXRleF91bmxvY2soJm1kZGV2LT5zdXNwZW5kX211dGV4KTsKPiA+ICAgICAgICAgICAg
ICAgICByZXR1cm47Cj4gPiArICAgICAgIH0KPiA+Cj4gPiAgICAgICAgIC8qIGVudHJlZCB0aGUg
bWVtYWxsb2Mgc2NvcGUgZnJvbSBtZGRldl9zdXNwZW5kKCkgKi8KPiA+ICAgICAgICAgbWVtYWxs
b2Nfbm9pb19yZXN0b3JlKG1kZGV2LT5ub2lvX2ZsYWcpOwo+ID4gQEAgLTQ3Nyw5ICs0OTQsNzIg
QEAgdm9pZCBtZGRldl9yZXN1bWUoc3RydWN0IG1kZGV2ICptZGRldikKPiA+ICAgICAgICAgc2V0
X2JpdChNRF9SRUNPVkVSWV9ORUVERUQsICZtZGRldi0+cmVjb3ZlcnkpOwo+ID4gICAgICAgICBt
ZF93YWtldXBfdGhyZWFkKG1kZGV2LT50aHJlYWQpOwo+ID4gICAgICAgICBtZF93YWtldXBfdGhy
ZWFkKG1kZGV2LT5zeW5jX3RocmVhZCk7IC8qIHBvc3NpYmx5IGtpY2sgb2ZmIGEgcmVzaGFwZSAq
Lwo+ID4gKwo+ID4gKyAgICAgICBtdXRleF91bmxvY2soJm1kZGV2LT5zdXNwZW5kX211dGV4KTsK
PiA+ICB9Cj4gPiAgRVhQT1JUX1NZTUJPTF9HUEwobWRkZXZfcmVzdW1lKTsKPiA+Cj4gPiArdm9p
ZCBfX21kZGV2X3N1c3BlbmQoc3RydWN0IG1kZGV2ICptZGRldikKPiA+ICt7Cj4gPiArCj4gPiAr
ICAgICAgIC8qCj4gPiArICAgICAgICAqIGhvbGQgcmVjb25maWdfbXV0ZXggdG8gd2FpdCBmb3Ig
bm9ybWFsIGlvIHdpbGwgZGVhZGxvY2ssIGJlY2F1c2UKPiA+ICsgICAgICAgICogb3RoZXIgY29u
dGV4dCBjYW4ndCB1cGRhdGUgc3VwZXJfYmxvY2ssIGFuZCBub3JtYWwgaW8gY2FuIHJlbHkgb24K
PiA+ICsgICAgICAgICogdXBkYXRpbmcgc3VwZXJfYmxvY2suCj4gPiArICAgICAgICAqLwo+ID4g
KyAgICAgICBsb2NrZGVwX2Fzc2VydF9ub3RfaGVsZCgmbWRkZXYtPnJlY29uZmlnX211dGV4KTsK
PiA+ICsKPiA+ICsgICAgICAgbXV0ZXhfbG9jaygmbWRkZXYtPnN1c3BlbmRfbXV0ZXgpOwo+ID4g
Kwo+ID4gKyAgICAgICBpZiAobWRkZXYtPnN1c3BlbmRlZCkgewo+ID4gKyAgICAgICAgICAgICAg
IFdSSVRFX09OQ0UobWRkZXYtPnN1c3BlbmRlZCwgbWRkZXYtPnN1c3BlbmRlZCArIDEpOwo+ID4g
KyAgICAgICAgICAgICAgIG11dGV4X3VubG9jaygmbWRkZXYtPnN1c3BlbmRfbXV0ZXgpOwo+ID4g
KyAgICAgICAgICAgICAgIHJldHVybjsKPiA+ICsgICAgICAgfQo+ID4gKwo+ID4gKyAgICAgICBw
ZXJjcHVfcmVmX2tpbGwoJm1kZGV2LT5hY3RpdmVfaW8pOwo+ID4gKyAgICAgICB3YWl0X2V2ZW50
KG1kZGV2LT5zYl93YWl0LCBwZXJjcHVfcmVmX2lzX3plcm8oJm1kZGV2LT5hY3RpdmVfaW8pKTsK
PiA+ICsKPiA+ICsgICAgICAgLyoKPiA+ICsgICAgICAgICogRm9yIHJhaWQ0NTYsIGlvIG1pZ2h0
IGJlIHdhaXRpbmcgZm9yIHJlc2hhcGUgdG8gbWFrZSBwcm9ncmVzcywKPiA+ICsgICAgICAgICog
YWxsb3cgbmV3IHJlc2hhcGUgdG8gc3RhcnQgd2hpbGUgd2FpdGluZyBmb3IgaW8gdG8gYmUgZG9u
ZSB0bwo+ID4gKyAgICAgICAgKiBwcmV2ZW50IGRlYWRsb2NrLgo+ID4gKyAgICAgICAgKi8KPiA+
ICsgICAgICAgV1JJVEVfT05DRShtZGRldi0+c3VzcGVuZGVkLCBtZGRldi0+c3VzcGVuZGVkICsg
MSk7Cj4KPiBJdCBjaGFuZ2VzIHRoZSBvcmRlciBvZiBzZXR0aW5nIHN1c3BlbmRlZCBhbmQgY2hl
Y2tpbmcgYWN0aXZlX2lvLgo+IHN1c3BlbmRlZCBpcyB1c2VkIHRvIHN0b3AgSS9PLiBOb3cgaXQg
Y2hlY2tzIGFjdGl2ZV9pbyBmaXJzdCBhbmQgdGhlbgo+IGFkZHMgc3VzcGVuZGVkLCBpZiB0aGUg
aS9vIGRvZXNuJ3Qgc3RvcCwgaXQgbG9va3MgbGlrZSBhY3RpdmVfaW8gY2FuJ3QKPiBiZSAwLiBT
byBpdCB3aWxsIHN0dWNrIGF0IHdhaXRpbmcgYWN0aXZlX2lvIHRvIGJlIDA/CgpBaCwgSSBjLCB5
b3UgYWRkIHRoZSBzdGF0ZSBvZiBhY3RpdmVfaW8gdG8ganVkZ2UgaWYgYSByYWlkIGlzIHN1c3Bl
bmRlZC4KClJlZ2FyZHMKWGlhbwo+Cj4gQmVzdCBSZWdhcmRzCj4gWGlhbwo+Cj4gPiArCj4gPiAr
ICAgICAgIGRlbF90aW1lcl9zeW5jKCZtZGRldi0+c2FmZW1vZGVfdGltZXIpOwo+ID4gKyAgICAg
ICAvKiByZXN0cmljdCBtZW1vcnkgcmVjbGFpbSBJL08gZHVyaW5nIHJhaWQgYXJyYXkgaXMgc3Vz
cGVuZCAqLwo+ID4gKyAgICAgICBtZGRldi0+bm9pb19mbGFnID0gbWVtYWxsb2Nfbm9pb19zYXZl
KCk7Cj4gPiArCj4gPiArICAgICAgIG11dGV4X3VubG9jaygmbWRkZXYtPnN1c3BlbmRfbXV0ZXgp
Owo+ID4gK30KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChfX21kZGV2X3N1c3BlbmQpOwo+ID4gKwo+
ID4gK3ZvaWQgX19tZGRldl9yZXN1bWUoc3RydWN0IG1kZGV2ICptZGRldikKPiA+ICt7Cj4gPiAr
ICAgICAgIGxvY2tkZXBfYXNzZXJ0X25vdF9oZWxkKCZtZGRldi0+cmVjb25maWdfbXV0ZXgpOwo+
ID4gKwo+ID4gKyAgICAgICBtdXRleF9sb2NrKCZtZGRldi0+c3VzcGVuZF9tdXRleCk7Cj4gPiAr
ICAgICAgIFdSSVRFX09OQ0UobWRkZXYtPnN1c3BlbmRlZCwgbWRkZXYtPnN1c3BlbmRlZCAtIDEp
Owo+ID4gKyAgICAgICBpZiAobWRkZXYtPnN1c3BlbmRlZCkgewo+ID4gKyAgICAgICAgICAgICAg
IG11dGV4X3VubG9jaygmbWRkZXYtPnN1c3BlbmRfbXV0ZXgpOwo+ID4gKyAgICAgICAgICAgICAg
IHJldHVybjsKPiA+ICsgICAgICAgfQo+ID4gKwo+ID4gKyAgICAgICAvKiBlbnRyZWQgdGhlIG1l
bWFsbG9jIHNjb3BlIGZyb20gX19tZGRldl9zdXNwZW5kKCkgKi8KPiA+ICsgICAgICAgbWVtYWxs
b2Nfbm9pb19yZXN0b3JlKG1kZGV2LT5ub2lvX2ZsYWcpOwo+ID4gKwo+ID4gKyAgICAgICBwZXJj
cHVfcmVmX3Jlc3VycmVjdCgmbWRkZXYtPmFjdGl2ZV9pbyk7Cj4gPiArICAgICAgIHdha2VfdXAo
Jm1kZGV2LT5zYl93YWl0KTsKPiA+ICsKPiA+ICsgICAgICAgc2V0X2JpdChNRF9SRUNPVkVSWV9O
RUVERUQsICZtZGRldi0+cmVjb3ZlcnkpOwo+ID4gKyAgICAgICBtZF93YWtldXBfdGhyZWFkKG1k
ZGV2LT50aHJlYWQpOwo+ID4gKyAgICAgICBtZF93YWtldXBfdGhyZWFkKG1kZGV2LT5zeW5jX3Ro
cmVhZCk7IC8qIHBvc3NpYmx5IGtpY2sgb2ZmIGEgcmVzaGFwZSAqLwo+ID4gKwo+ID4gKyAgICAg
ICBtdXRleF91bmxvY2soJm1kZGV2LT5zdXNwZW5kX211dGV4KTsKPiA+ICt9Cj4gPiArRVhQT1JU
X1NZTUJPTF9HUEwoX19tZGRldl9yZXN1bWUpOwo+ID4gKwo+ID4gIC8qCj4gPiAgICogR2VuZXJp
YyBmbHVzaCBoYW5kbGluZyBmb3IgbWQKPiA+ICAgKi8KPiA+IEBAIC02NjcsNiArNzQ3LDcgQEAg
aW50IG1kZGV2X2luaXQoc3RydWN0IG1kZGV2ICptZGRldikKPiA+ICAgICAgICAgbXV0ZXhfaW5p
dCgmbWRkZXYtPm9wZW5fbXV0ZXgpOwo+ID4gICAgICAgICBtdXRleF9pbml0KCZtZGRldi0+cmVj
b25maWdfbXV0ZXgpOwo+ID4gICAgICAgICBtdXRleF9pbml0KCZtZGRldi0+c3luY19tdXRleCk7
Cj4gPiArICAgICAgIG11dGV4X2luaXQoJm1kZGV2LT5zdXNwZW5kX211dGV4KTsKPiA+ICAgICAg
ICAgbXV0ZXhfaW5pdCgmbWRkZXYtPmJpdG1hcF9pbmZvLm11dGV4KTsKPiA+ICAgICAgICAgSU5J
VF9MSVNUX0hFQUQoJm1kZGV2LT5kaXNrcyk7Cj4gPiAgICAgICAgIElOSVRfTElTVF9IRUFEKCZt
ZGRldi0+YWxsX21kZGV2cyk7Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJp
dmVycy9tZC9tZC5oCj4gPiBpbmRleCBmYjNiMTIzZjE2ZGQuLjExMDNlNmIwOGFkOSAxMDA2NDQK
PiA+IC0tLSBhL2RyaXZlcnMvbWQvbWQuaAo+ID4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4gPiBA
QCAtMzE2LDYgKzMxNiw3IEBAIHN0cnVjdCBtZGRldiB7Cj4gPiAgICAgICAgIHVuc2lnbmVkIGxv
bmcgICAgICAgICAgICAgICAgICAgc2JfZmxhZ3M7Cj4gPgo+ID4gICAgICAgICBpbnQgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHN1c3BlbmRlZDsKPiA+ICsgICAgICAgc3RydWN0IG11dGV4
ICAgICAgICAgICAgICAgICAgICBzdXNwZW5kX211dGV4Owo+ID4gICAgICAgICBzdHJ1Y3QgcGVy
Y3B1X3JlZiAgICAgICAgICAgICAgIGFjdGl2ZV9pbzsKPiA+ICAgICAgICAgaW50ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBybzsKPiA+ICAgICAgICAgaW50ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzeXNmc19hY3RpdmU7IC8qIHNldCB3aGVuIHN5c2ZzIGRlbGV0ZXMKPiA+IEBA
IC04MTEsNiArODEyLDggQEAgZXh0ZXJuIHZvaWQgbWRfcmRldl9jbGVhcihzdHJ1Y3QgbWRfcmRl
diAqcmRldik7Cj4gPiAgZXh0ZXJuIHZvaWQgbWRfaGFuZGxlX3JlcXVlc3Qoc3RydWN0IG1kZGV2
ICptZGRldiwgc3RydWN0IGJpbyAqYmlvKTsKPiA+ICBleHRlcm4gdm9pZCBtZGRldl9zdXNwZW5k
KHN0cnVjdCBtZGRldiAqbWRkZXYpOwo+ID4gIGV4dGVybiB2b2lkIG1kZGV2X3Jlc3VtZShzdHJ1
Y3QgbWRkZXYgKm1kZGV2KTsKPiA+ICtleHRlcm4gdm9pZCBfX21kZGV2X3N1c3BlbmQoc3RydWN0
IG1kZGV2ICptZGRldik7Cj4gPiArZXh0ZXJuIHZvaWQgX19tZGRldl9yZXN1bWUoc3RydWN0IG1k
ZGV2ICptZGRldik7Cj4gPgo+ID4gIGV4dGVybiB2b2lkIG1kX3JlbG9hZF9zYihzdHJ1Y3QgbWRk
ZXYgKm1kZGV2LCBpbnQgcmFpZF9kaXNrKTsKPiA+ICBleHRlcm4gdm9pZCBtZF91cGRhdGVfc2Io
c3RydWN0IG1kZGV2ICptZGRldiwgaW50IGZvcmNlKTsKPiA+IC0tCj4gPiAyLjM5LjIKPiA+Cgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

