Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB6FEB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jun 2023 06:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686897743;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VGdofpO9yibCfHphM2FIAFtizbQ13upw+KNgVXiio9M=;
	b=Mrm0JT3SD5/Y7lkgDBx/dX2Y2rmP5F0GO7bWQ26b59iVBOifAZZSf0WXmFPp096Pxqd3sr
	PLUiHJkG79DJxhZeO7KSyIg4ZkaU6gTmZ3vrqRp0wkm78tuiLswj8OER0XEJr3XaLwPT/d
	IiTV8XOIG/Y8MI4MY+ts2a0UOgQmp2w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-TOwE-6wtPHCNOK2TDa0Slg-1; Fri, 16 Jun 2023 02:42:17 -0400
X-MC-Unique: TOwE-6wtPHCNOK2TDa0Slg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AF6A3802269;
	Fri, 16 Jun 2023 06:42:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39A2F1410F01;
	Fri, 16 Jun 2023 06:42:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10A9B1946594;
	Fri, 16 Jun 2023 06:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB0FF1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Jun 2023 06:42:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A758C515542; Fri, 16 Jun 2023 06:42:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F37048FB01
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 06:42:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 816321C03D88
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 06:42:03 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-Htdtz3DdPZC-hp24wGt5Hg-1; Fri, 16 Jun 2023 02:41:59 -0400
X-MC-Unique: Htdtz3DdPZC-hp24wGt5Hg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 66C5E61E3B;
 Fri, 16 Jun 2023 06:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6894C433CA;
 Fri, 16 Jun 2023 06:41:57 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id
 2adb3069b0e04-4f649db9b25so372674e87.0; 
 Thu, 15 Jun 2023 23:41:57 -0700 (PDT)
X-Gm-Message-State: AC+VfDygGTl10Y5sgjSFHbK2Y3I5ZSzp6kCjzf3bYA2D3VSPxhxHW2yz
 HhKortR+Gc4jKbb0MgVVQgZPXqaWB0f7uULpjPw=
X-Google-Smtp-Source: ACHHUZ4Wg122FV+dsoalr3CT9nTUFfF3JCY4jxnldzEwjXLvc+KYP8fZMeQfaopTPmrrq1uIutQVSMBQWMKoG3YHqTQ=
X-Received: by 2002:a19:660a:0:b0:4f6:424c:4fa8 with SMTP id
 a10-20020a19660a000000b004f6424c4fa8mr493140lfc.17.1686897715724; Thu, 15 Jun
 2023 23:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-4-yukuai1@huaweicloud.com>
 <c96f2604-e1ef-c3ad-9d15-5e0efa5f222b@redhat.com>
 <254fc651-aa75-074d-f567-49bafc437e9c@huaweicloud.com>
In-Reply-To: <254fc651-aa75-074d-f567-49bafc437e9c@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 15 Jun 2023 23:41:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5nyv0=e3WR+B4gQmHo9O0cDBmzpEOZwXTLbvPzjX5iDw@mail.gmail.com>
Message-ID: <CAPhsuW5nyv0=e3WR+B4gQmHo9O0cDBmzpEOZwXTLbvPzjX5iDw@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH -next v2 3/6] md: add a mutex to synchronize
 idle and frozen in action_store()
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
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMTMsIDIwMjMgYXQgNjoxNeKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTMgMjI6NDMsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4KPiA+IOWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnp
gZM6Cj4gPj4gRnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+ID4+Cj4gPj4gQ3Vy
cmVudGx5LCBmb3IgaWRsZSBhbmQgZnJvemVuLCBhY3Rpb25fc3RvcmUgd2lsbCBob2xkICdyZWNv
bmZpZ19tdXRleCcKPiA+PiBhbmQgY2FsbCBtZF9yZWFwX3N5bmNfdGhyZWFkKCkgdG8gc3RvcCBz
eW5jIHRocmVhZCwgaG93ZXZlciwgdGhpcyB3aWxsCj4gPj4gY2F1c2UgZGVhZGxvY2sgKGV4cGxh
aW5lZCBpbiB0aGUgbmV4dCBwYXRjaCkuIEluIG9yZGVyIHRvIGZpeCB0aGUKPiA+PiBwcm9ibGVt
LCBmb2xsb3dpbmcgcGF0Y2ggd2lsbCByZWxlYXNlICdyZWNvbmZpZ19tdXRleCcgYW5kIHdhaXQg
b24KPiA+PiAncmVzeW5jX3dhaXQnLCBsaWtlIG1kX3NldF9yZWFkb25seSgpIGFuZCBkb19tZF9z
dG9wKCkgZG9lcy4KPiA+Pgo+ID4+IENvbnNpZGVyIHRoYXQgYWN0aW9uX3N0b3JlKCkgd2lsbCBz
ZXQvY2xlYXIgJ01EX1JFQ09WRVJZX0ZST1pFTicKPiA+PiB1bmNvbmRpdGlvbmFsbHksIHdoaWNo
IG1pZ2h0IGNhdXNlIHVuZXhwZWN0ZWQgcHJvYmxlbXMsIGZvciBleGFtcGxlLAo+ID4+IGZyb3pl
biBqdXN0IHNldCAnTURfUkVDT1ZFUllfRlJPWkVOJyBhbmQgaXMgc3RpbGwgaW4gcHJvZ3Jlc3Ms
IHdoaWxlCj4gPj4gJ2lkbGUnIGNsZWFyICdNRF9SRUNPVkVSWV9GUk9aRU4nIGFuZCBuZXcgc3lu
YyB0aHJlYWQgaXMgc3RhcnRlZCwgd2hpY2gKPiA+PiBtaWdodCBzdGFydmUgaW4gcHJvZ3Jlc3Mg
ZnJvemVuLiBBIG11dGV4IGlzIGFkZGVkIHRvIHN5bmNocm9uaXplIGlkbGUKPiA+PiBhbmQgZnJv
emVuIGZyb20gYWN0aW9uX3N0b3JlKCkuCj4gPj4KPiA+PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFp
IDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gPj4gLS0tCj4gPj4gICBkcml2ZXJzL21kL21kLmMgfCA1
ICsrKysrCj4gPj4gICBkcml2ZXJzL21kL21kLmggfCAzICsrKwo+ID4+ICAgMiBmaWxlcyBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKykKPiA+Pgo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21k
LmMgYi9kcml2ZXJzL21kL21kLmMKPiA+PiBpbmRleCAyM2U4ZTdlYWUwNjIuLjYzYTk5M2I1MmNk
NyAxMDA2NDQKPiA+PiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPiA+PiArKysgYi9kcml2ZXJzL21k
L21kLmMKPiA+PiBAQCAtNjQ0LDYgKzY0NCw3IEBAIHZvaWQgbWRkZXZfaW5pdChzdHJ1Y3QgbWRk
ZXYgKm1kZGV2KQo+ID4+ICAgICAgIG11dGV4X2luaXQoJm1kZGV2LT5vcGVuX211dGV4KTsKPiA+
PiAgICAgICBtdXRleF9pbml0KCZtZGRldi0+cmVjb25maWdfbXV0ZXgpOwo+ID4+ICAgICAgIG11
dGV4X2luaXQoJm1kZGV2LT5kZWxldGVfbXV0ZXgpOwo+ID4+ICsgICAgbXV0ZXhfaW5pdCgmbWRk
ZXYtPnN5bmNfbXV0ZXgpOwo+ID4+ICAgICAgIG11dGV4X2luaXQoJm1kZGV2LT5iaXRtYXBfaW5m
by5tdXRleCk7Cj4gPj4gICAgICAgSU5JVF9MSVNUX0hFQUQoJm1kZGV2LT5kaXNrcyk7Cj4gPj4g
ICAgICAgSU5JVF9MSVNUX0hFQUQoJm1kZGV2LT5hbGxfbWRkZXZzKTsKPiA+PiBAQCAtNDc4NSwx
NCArNDc4NiwxOCBAQCBzdGF0aWMgdm9pZCBzdG9wX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAq
bWRkZXYpCj4gPj4gICBzdGF0aWMgdm9pZCBpZGxlX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAq
bWRkZXYpCj4gPj4gICB7Cj4gPj4gKyAgICBtdXRleF9sb2NrKCZtZGRldi0+c3luY19tdXRleCk7
Cj4gPj4gICAgICAgY2xlYXJfYml0KE1EX1JFQ09WRVJZX0ZST1pFTiwgJm1kZGV2LT5yZWNvdmVy
eSk7Cj4gPj4gICAgICAgc3RvcF9zeW5jX3RocmVhZChtZGRldik7Cj4gPj4gKyAgICBtdXRleF91
bmxvY2soJm1kZGV2LT5zeW5jX211dGV4KTsKPiA+PiAgIH0KPiA+PiAgIHN0YXRpYyB2b2lkIGZy
b3plbl9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+ID4+ICAgewo+ID4+ICsgICAg
bXV0ZXhfaW5pdCgmbWRkZXYtPmRlbGV0ZV9tdXRleCk7Cj4gPgo+ID4KPiA+IHR5cG8gZXJyb3I/
IEl0IHNob3VsZCBiZSBtdXRleF9sb2NrKCZtZGRldi0+c3luY19tdXRleCk7ID8KPiA+Cj4KPiBZ
ZXMsIGFuZCB0aGFua3MgZm9yIHNwb3R0aW5nIHRoaXMsIHRoaXMgbG9va3MgbGlrZSBJIGRpZCB0
aGlzIHdoaWxlCj4gcmViYXNpbmcuCgpJIGZpeGVkIHRoaXMgb25lIGFuZCBhcHBsaWVkIHRoZSBz
ZXQgdG8gbWQtbmV4dC4KClRoYW5rcywKU29uZwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

