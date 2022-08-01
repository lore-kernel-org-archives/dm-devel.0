Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E181AC00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659361969;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EmvDQleb3uZZcn7jbzqAvh4URKeVVuHedCZ9zSN8UWc=;
	b=I1UeoPzOPl3QAgx4dczLwUCJwV5ta45hymuGvz971wscgFB4Be+bVqkup1NlCspY8DUe0p
	jAmNFygGchpZ8doBN/R2lR2OAbmpSB94UoaVfbUtXE23y9Q8UhKJiSaTLMZmfIdg3gX1DT
	3PrU8RGN/KD5QBwNSrpMwPOzW5jJoDw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-TqPT2yi4NdaPhD5zjuBkPA-1; Mon, 01 Aug 2022 09:52:46 -0400
X-MC-Unique: TqPT2yi4NdaPhD5zjuBkPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AB67280D204;
	Mon,  1 Aug 2022 13:52:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C9EF1121314;
	Mon,  1 Aug 2022 13:52:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BA721946A41;
	Mon,  1 Aug 2022 13:52:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9A051946A40
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 13:52:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AECC1415118; Mon,  1 Aug 2022 13:52:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96E8A1415116
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:52:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7410B1C16B44
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:52:41 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-3xR18ezcPPaxDMfv07yzDQ-1; Mon, 01 Aug 2022 09:52:39 -0400
X-MC-Unique: 3xR18ezcPPaxDMfv07yzDQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 24D58CE16B1;
 Mon,  1 Aug 2022 13:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D669CC433C1;
 Mon,  1 Aug 2022 13:43:08 +0000 (UTC)
Date: Mon, 1 Aug 2022 15:43:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <YufYastRAp72PWGo@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
 <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
 <YufSdhzXq/Fmozdw@kroah.com>
 <b10dc9e7-5219-289d-c25d-da7e9464d3ef@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <b10dc9e7-5219-289d-c25d-da7e9464d3ef@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH stable 5.10 1/3] block: look up holders by
 bdev
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
Cc: axboe@kernel.dk, snitzer@redhat.com, yi.zhang@huawei.com,
 stable@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgMDEsIDIwMjIgYXQgMDk6Mzk6MzBQTSArMDgwMCwgWXUgS3VhaSB3cm90ZToK
PiBIaSwgR3JlZwo+IAo+IOWcqCAyMDIyLzA4LzAxIDIxOjE3LCBHcmVnIEtIIOWGmemBkzoKPiA+
IE9uIE1vbiwgQXVnIDAxLCAyMDIyIGF0IDA4OjI1OjI3UE0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6
Cj4gPiA+IEhpLCBHcmVnCj4gPiA+IAo+ID4gPiDlnKggMjAyMi8wOC8wMSAxOToxOSwgR3JlZyBL
SCDlhpnpgZM6Cj4gPiA+ID4gT24gRnJpLCBKdWwgMjksIDIwMjIgYXQgMDI6MjM6NTRQTSArMDgw
MCwgWXUgS3VhaSB3cm90ZToKPiA+ID4gPiA+IEZyb206IENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBjb21taXQgMGRiY2ZlMjQ3ZjIyYTZkNzMzMDJk
ZmE2OTFjNDhiM2MxNGQzMWM0YyB1cHN0cmVhbS4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gSW52ZXJ0
IHRoZXkgd2F5IHRoZSBob2xkZXIgcmVsYXRpb25zIGFyZSB0cmFja2VkLiAgVGhpcyB2ZXJ5Cj4g
PiA+ID4gPiBzbGlnaHRseSByZWR1Y2VzIHRoZSBtZW1vcnkgb3ZlcmhlYWQgZm9yIHBhcnRpdGlv
bmVkIGRldmljZXMuCj4gPiA+ID4gPiAKPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogWXUgS3VhaSA8
eXVrdWFpM0BodWF3ZWkuY29tPgo+ID4gPiA+ID4gLS0tCj4gPiA+ID4gPiAgICBibG9jay9nZW5o
ZC5jICAgICAgICAgICAgIHwgIDMgKysrCj4gPiA+ID4gPiAgICBmcy9ibG9ja19kZXYuYyAgICAg
ICAgICAgIHwgMzEgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQo+ID4gPiA+ID4gICAg
aW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCB8ICAzIC0tLQo+ID4gPiA+ID4gICAgaW5jbHVkZS9s
aW51eC9nZW5oZC5oICAgICB8ICA0ICsrKy0KPiA+ID4gPiA+ICAgIDQgZmlsZXMgY2hhbmdlZCwg
MjUgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCj4gPiA+ID4gPiAKPiA+ID4gPiA+IGRp
ZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2svZ2VuaGQuYwo+ID4gPiA+ID4gaW5kZXgg
Nzk2YmFmNzYxMjAyLi4yYjExYTI3MzUyODUgMTAwNjQ0Cj4gPiA+ID4gPiAtLS0gYS9ibG9jay9n
ZW5oZC5jCj4gPiA+ID4gPiArKysgYi9ibG9jay9nZW5oZC5jCj4gPiA+ID4gPiBAQCAtMTc2MCw2
ICsxNzYwLDkgQEAgc3RydWN0IGdlbmRpc2sgKl9fYWxsb2NfZGlza19ub2RlKGludCBtaW5vcnMs
IGludCBub2RlX2lkKQo+ID4gPiA+ID4gICAgCWRpc2tfdG9fZGV2KGRpc2spLT5jbGFzcyA9ICZi
bG9ja19jbGFzczsKPiA+ID4gPiA+ICAgIAlkaXNrX3RvX2RldihkaXNrKS0+dHlwZSA9ICZkaXNr
X3R5cGU7Cj4gPiA+ID4gPiAgICAJZGV2aWNlX2luaXRpYWxpemUoZGlza190b19kZXYoZGlzaykp
Owo+ID4gPiA+ID4gKyNpZmRlZiBDT05GSUdfU1lTRlMKPiA+ID4gPiA+ICsJSU5JVF9MSVNUX0hF
QUQoJmRpc2stPnNsYXZlX2JkZXZzKTsKPiA+ID4gPiA+ICsjZW5kaWYKPiA+ID4gPiA+ICAgIAly
ZXR1cm4gZGlzazsKPiA+ID4gPiA+ICAgIG91dF9mcmVlX3BhcnQwOgo+ID4gPiA+ID4gZGlmZiAt
LWdpdCBhL2ZzL2Jsb2NrX2Rldi5jIGIvZnMvYmxvY2tfZGV2LmMKPiA+ID4gPiA+IGluZGV4IDI5
ZjAyMGM0YjJkMC4uYTIwMmM3NmZjZjdmIDEwMDY0NAo+ID4gPiA+ID4gLS0tIGEvZnMvYmxvY2tf
ZGV2LmMKPiA+ID4gPiA+ICsrKyBiL2ZzL2Jsb2NrX2Rldi5jCj4gPiA+ID4gPiBAQCAtODIzLDkg
KzgyMyw2IEBAIHN0YXRpYyB2b2lkIGluaXRfb25jZSh2b2lkICpmb28pCj4gPiA+ID4gPiAgICAJ
bWVtc2V0KGJkZXYsIDAsIHNpemVvZigqYmRldikpOwo+ID4gPiA+ID4gICAgCW11dGV4X2luaXQo
JmJkZXYtPmJkX211dGV4KTsKPiA+ID4gPiA+IC0jaWZkZWYgQ09ORklHX1NZU0ZTCj4gPiA+ID4g
PiAtCUlOSVRfTElTVF9IRUFEKCZiZGV2LT5iZF9ob2xkZXJfZGlza3MpOwo+ID4gPiA+ID4gLSNl
bmRpZgo+ID4gPiA+ID4gICAgCWJkZXYtPmJkX2JkaSA9ICZub29wX2JhY2tpbmdfZGV2X2luZm87
Cj4gPiA+ID4gPiAgICAJaW5vZGVfaW5pdF9vbmNlKCZlaS0+dmZzX2lub2RlKTsKPiA+ID4gPiA+
ICAgIAkvKiBJbml0aWFsaXplIG11dGV4IGZvciBmcmVlemUuICovCj4gPiA+ID4gPiBAQCAtMTE4
OCw3ICsxMTg1LDcgQEAgRVhQT1JUX1NZTUJPTChiZF9hYm9ydF9jbGFpbWluZyk7Cj4gPiA+ID4g
PiAgICAjaWZkZWYgQ09ORklHX1NZU0ZTCj4gPiA+ID4gPiAgICBzdHJ1Y3QgYmRfaG9sZGVyX2Rp
c2sgewo+ID4gPiA+ID4gICAgCXN0cnVjdCBsaXN0X2hlYWQJbGlzdDsKPiA+ID4gPiA+IC0Jc3Ry
dWN0IGdlbmRpc2sJCSpkaXNrOwo+ID4gPiA+ID4gKwlzdHJ1Y3QgYmxvY2tfZGV2aWNlCSpiZGV2
Owo+ID4gPiA+ID4gICAgCWludAkJCXJlZmNudDsKPiA+ID4gPiA+ICAgIH07Cj4gPiA+ID4gPiBA
QCAtMTE5Nyw4ICsxMTk0LDggQEAgc3RhdGljIHN0cnVjdCBiZF9ob2xkZXJfZGlzayAqYmRfZmlu
ZF9ob2xkZXJfZGlzayhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LAo+ID4gPiA+ID4gICAgewo+
ID4gPiA+ID4gICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVyOwo+ID4gPiA+ID4gLQls
aXN0X2Zvcl9lYWNoX2VudHJ5KGhvbGRlciwgJmJkZXYtPmJkX2hvbGRlcl9kaXNrcywgbGlzdCkK
PiA+ID4gPiA+IC0JCWlmIChob2xkZXItPmRpc2sgPT0gZGlzaykKPiA+ID4gPiA+ICsJbGlzdF9m
b3JfZWFjaF9lbnRyeShob2xkZXIsICZkaXNrLT5zbGF2ZV9iZGV2cywgbGlzdCkKPiA+ID4gPiA+
ICsJCWlmIChob2xkZXItPmJkZXYgPT0gYmRldikKPiA+ID4gPiA+ICAgIAkJCXJldHVybiBob2xk
ZXI7Cj4gPiA+ID4gPiAgICAJcmV0dXJuIE5VTEw7Cj4gPiA+ID4gPiAgICB9Cj4gPiA+ID4gPiBA
QCAtMTI0NCw5ICsxMjQxLDEzIEBAIHN0YXRpYyB2b2lkIGRlbF9zeW1saW5rKHN0cnVjdCBrb2Jq
ZWN0ICpmcm9tLCBzdHJ1Y3Qga29iamVjdCAqdG8pCj4gPiA+ID4gPiAgICBpbnQgYmRfbGlua19k
aXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlz
aykKPiA+ID4gPiA+ICAgIHsKPiA+ID4gPiA+ICAgIAlzdHJ1Y3QgYmRfaG9sZGVyX2Rpc2sgKmhv
bGRlcjsKPiA+ID4gPiA+ICsJc3RydWN0IGJsb2NrX2RldmljZSAqYmRldl9ob2xkZXIgPSBiZGdl
dF9kaXNrKGRpc2ssIDApOwo+ID4gPiA+ID4gICAgCWludCByZXQgPSAwOwo+ID4gPiA+ID4gLQlt
dXRleF9sb2NrKCZiZGV2LT5iZF9tdXRleCk7Cj4gPiA+ID4gPiArCWlmIChXQVJOX09OX09OQ0Uo
IWJkZXZfaG9sZGVyKSkKPiA+ID4gPiA+ICsJCXJldHVybiAtRU5PRU5UOwo+ID4gPiA+ID4gKwo+
ID4gPiA+ID4gKwltdXRleF9sb2NrKCZiZGV2X2hvbGRlci0+YmRfbXV0ZXgpOwo+ID4gPiA+ID4g
ICAgCVdBUk5fT05fT05DRSghYmRldi0+YmRfaG9sZGVyKTsKPiA+ID4gPiA+IEBAIC0xMjY3LDcg
KzEyNjgsNyBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiA+ID4gPiA+ICAgIAl9Cj4gPiA+ID4gPiAgICAJ
SU5JVF9MSVNUX0hFQUQoJmhvbGRlci0+bGlzdCk7Cj4gPiA+ID4gPiAtCWhvbGRlci0+ZGlzayA9
IGRpc2s7Cj4gPiA+ID4gPiArCWhvbGRlci0+YmRldiA9IGJkZXY7Cj4gPiA+ID4gPiAgICAJaG9s
ZGVyLT5yZWZjbnQgPSAxOwo+ID4gPiA+ID4gICAgCXJldCA9IGFkZF9zeW1saW5rKGRpc2stPnNs
YXZlX2RpciwgJnBhcnRfdG9fZGV2KGJkZXYtPmJkX3BhcnQpLT5rb2JqKTsKPiA+ID4gPiA+IEBA
IC0xMjgzLDcgKzEyODQsNyBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiA+ID4gPiA+ICAgIAkgKi8KPiA+
ID4gPiA+ICAgIAlrb2JqZWN0X2dldChiZGV2LT5iZF9wYXJ0LT5ob2xkZXJfZGlyKTsKPiA+ID4g
PiA+IC0JbGlzdF9hZGQoJmhvbGRlci0+bGlzdCwgJmJkZXYtPmJkX2hvbGRlcl9kaXNrcyk7Cj4g
PiA+ID4gPiArCWxpc3RfYWRkKCZob2xkZXItPmxpc3QsICZkaXNrLT5zbGF2ZV9iZGV2cyk7Cj4g
PiA+ID4gPiAgICAJZ290byBvdXRfdW5sb2NrOwo+ID4gPiA+ID4gICAgb3V0X2RlbDoKPiA+ID4g
PiA+IEBAIC0xMjkxLDcgKzEyOTIsOCBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3Qg
YmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiA+ID4gPiA+ICAgIG91
dF9mcmVlOgo+ID4gPiA+ID4gICAgCWtmcmVlKGhvbGRlcik7Cj4gPiA+ID4gPiAgICBvdXRfdW5s
b2NrOgo+ID4gPiA+ID4gLQltdXRleF91bmxvY2soJmJkZXYtPmJkX211dGV4KTsKPiA+ID4gPiA+
ICsJbXV0ZXhfdW5sb2NrKCZiZGV2X2hvbGRlci0+YmRfbXV0ZXgpOwo+ID4gPiA+ID4gKwliZHB1
dChiZGV2X2hvbGRlcik7Cj4gPiA+ID4gPiAgICAJcmV0dXJuIHJldDsKPiA+ID4gPiA+ICAgIH0K
PiA+ID4gPiA+ICAgIEVYUE9SVF9TWU1CT0xfR1BMKGJkX2xpbmtfZGlza19ob2xkZXIpOwo+ID4g
PiA+ID4gQEAgLTEzMDksOCArMTMxMSwxMiBAQCBFWFBPUlRfU1lNQk9MX0dQTChiZF9saW5rX2Rp
c2tfaG9sZGVyKTsKPiA+ID4gPiA+ICAgIHZvaWQgYmRfdW5saW5rX2Rpc2tfaG9sZGVyKHN0cnVj
dCBibG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+ID4gPiA+ID4gICAg
ewo+ID4gPiA+ID4gICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVyOwo+ID4gPiA+ID4g
KwlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2X2hvbGRlciA9IGJkZ2V0X2Rpc2soZGlzaywgMCk7
Cj4gPiA+ID4gPiAtCW11dGV4X2xvY2soJmJkZXYtPmJkX211dGV4KTsKPiA+ID4gPiA+ICsJaWYg
KFdBUk5fT05fT05DRSghYmRldl9ob2xkZXIpKQo+ID4gPiA+ID4gKwkJcmV0dXJuOwo+ID4gPiA+
ID4gKwo+ID4gPiA+ID4gKwltdXRleF9sb2NrKCZiZGV2X2hvbGRlci0+YmRfbXV0ZXgpOwo+ID4g
PiA+ID4gICAgCWhvbGRlciA9IGJkX2ZpbmRfaG9sZGVyX2Rpc2soYmRldiwgZGlzayk7Cj4gPiA+
ID4gPiBAQCAtMTMyMyw3ICsxMzI5LDggQEAgdm9pZCBiZF91bmxpbmtfZGlza19ob2xkZXIoc3Ry
dWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4gPiA+ID4gPiAg
ICAJCWtmcmVlKGhvbGRlcik7Cj4gPiA+ID4gPiAgICAJfQo+ID4gPiA+ID4gLQltdXRleF91bmxv
Y2soJmJkZXYtPmJkX211dGV4KTsKPiA+ID4gPiA+ICsJbXV0ZXhfdW5sb2NrKCZiZGV2X2hvbGRl
ci0+YmRfbXV0ZXgpOwo+ID4gPiA+ID4gKwliZHB1dChiZGV2X2hvbGRlcik7Cj4gPiA+ID4gPiAg
ICB9Cj4gPiA+ID4gPiAgICBFWFBPUlRfU1lNQk9MX0dQTChiZF91bmxpbmtfZGlza19ob2xkZXIp
Owo+ID4gPiA+ID4gICAgI2VuZGlmCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9ibGtfdHlwZXMuaCBiL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmgKPiA+ID4gPiA+IGluZGV4
IGQ5YjY5YmJkZTVjYy4uMWI4NGVjYjM0YzE4IDEwMDY0NAo+ID4gPiA+ID4gLS0tIGEvaW5jbHVk
ZS9saW51eC9ibGtfdHlwZXMuaAo+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9ibGtfdHlw
ZXMuaAo+ID4gPiA+ID4gQEAgLTI5LDkgKzI5LDYgQEAgc3RydWN0IGJsb2NrX2RldmljZSB7Cj4g
PiA+ID4gPiAgICAJdm9pZCAqCQkJYmRfaG9sZGVyOwo+ID4gPiA+ID4gICAgCWludAkJCWJkX2hv
bGRlcnM7Cj4gPiA+ID4gPiAgICAJYm9vbAkJCWJkX3dyaXRlX2hvbGRlcjsKPiA+ID4gPiA+IC0j
aWZkZWYgQ09ORklHX1NZU0ZTCj4gPiA+ID4gPiAtCXN0cnVjdCBsaXN0X2hlYWQJYmRfaG9sZGVy
X2Rpc2tzOwo+ID4gPiA+ID4gLSNlbmRpZgo+ID4gPiA+ID4gICAgCXN0cnVjdCBibG9ja19kZXZp
Y2UgKgliZF9jb250YWluczsKPiA+ID4gPiA+ICAgIAl1OAkJCWJkX3BhcnRubzsKPiA+ID4gPiA+
ICAgIAlzdHJ1Y3QgaGRfc3RydWN0ICoJYmRfcGFydDsKPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2dlbmhkLmggYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKPiA+ID4gPiA+IGlu
ZGV4IDAzZGEzZjYwM2QzMC4uM2U1MDQ5YTUyN2U2IDEwMDY0NAo+ID4gPiA+ID4gLS0tIGEvaW5j
bHVkZS9saW51eC9nZW5oZC5oCj4gPiA+ID4gPiArKysgYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgK
PiA+ID4gPiA+IEBAIC0xOTUsNyArMTk1LDkgQEAgc3RydWN0IGdlbmRpc2sgewo+ID4gPiA+ID4g
ICAgI2RlZmluZSBHRF9ORUVEX1BBUlRfU0NBTgkJMAo+ID4gPiA+ID4gICAgCXN0cnVjdCByd19z
ZW1hcGhvcmUgbG9va3VwX3NlbTsKPiA+ID4gPiA+ICAgIAlzdHJ1Y3Qga29iamVjdCAqc2xhdmVf
ZGlyOwo+ID4gPiA+ID4gLQo+ID4gPiA+ID4gKyNpZmRlZiBDT05GSUdfU1lTRlMKPiA+ID4gPiA+
ICsJc3RydWN0IGxpc3RfaGVhZAlzbGF2ZV9iZGV2czsKPiA+ID4gPiA+ICsjZW5kaWYKPiA+ID4g
PiAKPiA+ID4gPiBUaGlzIGlzIHZlcnkgZGlmZmVyZW50IGZyb20gdGhlIHVwc3RyZWFtIHZlcnNp
b24sIGFuZCBmb3JjZXMgdGhlIGNoYW5nZQo+ID4gPiA+IG9udG8gZXZlcnlvbmUsIG5vdCBqdXN0
IHRob3NlIHdobyBoYWQgQ09ORklHX0JMT0NLX0hPTERFUl9ERVBSRUNBVEVECj4gPiA+ID4gZW5h
YmxlZCBsaWtlIHdhcyBkb25lIGluIHRoZSBtYWluIGtlcm5lbCB0cmVlLgo+ID4gPiA+IAo+ID4g
PiA+IFdoeSBmb3JjZSB0aGlzIG9uIGFsbCBhbmQgbm90IGp1c3QgdXNlIHRoZSBzYW1lIG9wdGlv
bj8KPiA+ID4gPiAKPiA+ID4gPiBJIHdvdWxkIG5lZWQgYSBzdHJvbmcgQUNLIGZyb20gdGhlIG9y
aWdpbmFsIGRldmVsb3BlcnMgYW5kIG1haW50YWluZXJzCj4gPiA+ID4gb2YgdGhlc2Ugc3Vic3lz
dGVtcyBiZWZvcmUgYmVpbmcgYWJsZSB0byB0YWtlIHRoZXNlIGludG8gdGhlIDUuMTAgdHJlZS4K
PiA+ID4gCj4gPiA+IFllcywgSSBhZ3JlZSB0aGF0IENocmlzdG9waCBtdXN0IHRha2UgYSBsb29r
IGZpcnN0Lgo+ID4gPiA+IAo+ID4gPiA+IFdoYXQgcHJldmVudHMgeW91IGZyb20ganVzdCB1c2lu
ZyA1LjE1IGZvciB0aG9zZSBzeXN0ZW1zIHRoYXQgcnVuIGludG8KPiA+ID4gPiB0aGVzZSBpc3N1
ZXM/Cj4gPiA+IAo+ID4gPiBUaGUgbnVsbCBwb2ludGVyIHByb2JsZW0gaXMgcmVwb3J0ZWQgYnkg
b3VyIHByb2R1Y3QocmVsYXRlZCB0byBkbS0KPiA+ID4gbXBhdGgpLCBhbmQgdGhleSBoYWQgYmVl
biB1c2luZyA1LjEwIGZvciBhIGxvbmcgdGltZS4gQW5kIHN3aXRjaGluZwo+ID4gPiBrZXJuZWwg
Zm9yIGNvbW1lcmNpYWwgd2lsbCByZXF1aXJlIGxvdHMgb2Ygd29yaywgaXQncyBub3QgYW4gb3B0
aW9uCj4gPiA+IGZvciBub3cuCj4gPiAKPiA+IEl0IHNob3VsZCBiZSB0aGUgc2FtZSB2YWxpZGF0
aW9uIGFuZCB2ZXJpZmljYXRpb24gYW5kIHRlc3RpbmcgcGF0aCBmb3IKPiA+IDUuMTUueSBhcyBm
b3IgYW4gaW50cnVzaXZlIGtlcm5lbCBjaGFuZ2UgYXMgdGhpcyBvbmUsIHJpZ2h0PyAgV2hhdCBt
YWtlcwo+ID4gaXQgYW55IGRpZmZlcmVudCB0byBwcmV2ZW50IDUuMTUgZnJvbSBiZWluZyB1c2Vk
Pwo+IAo+IE5vLCB0aGV5IGFyZSBub3QgdGhlIHNhbWUsIGlmIHdlIHRyeSB0byB1c2UgNS4xNS55
LCB3ZSBoYXZlIHRvIHRlc3QgYWxsCj4gb3RoZXIgc3R1ZmYgdGhhdCBvdXIgcHJvZHVjdCBpcyB1
c2VkIGN1cnJlbnRseShleHQ0LCBibG9jaywgc2NzaSBhbmQKPiBsb3RzIG9mIG90aGVyIG1vZHVs
ZXMpLiBXaXRoIHRoaXMgcGF0Y2gsIHdlIG9ubHkgbmVlZCB0byBtYWtlIHN1cmUKPiBkbSB3b3Jr
cyBmaW5lLgoKVGhhdCBpcyBhIHZlcnkgb2RkIHdheSB0byB0ZXN0IGEgbW9ub2xpdGhpYyBrZXJu
ZWwgaW1hZ2UsIHdoZXJlIGFueQpjaGFuZ2UgaW4gYW55IHBhcnQgY2FuIGFmZmVjdCBhbnkgb3Ro
ZXIgcGFydCBvZiB0aGUga2VybmVsLiAgWW91IHRvdWNoZWQKdGhlIGJsb2NrIGxheWVyLCB3aHkg
eW91IHdvdWxkbid0IHRoaW5rIHRoYXQgYWxsIGJsb2NrLXJlbGF0ZWQgdGhpbmdzCndvdWxkIGFs
c28gaGF2ZSB0byBiZSB0ZXN0ZWQgaXMgdmVyeSBzdHJhbmdlIHRvIG1lIGFzIHRob3NlIGFyZSBk
aXJlY3RseQpyZWxhdGVkLiAgQW5kIHdoaWxlIHlvdSBhcmUgYXQgaXQsIHlvdSBzaG91bGQgdGVz
dCBhbGwgb3RoZXIgc3Vic3lzdGVtcwphcyB0aGUgc3lzdGVtIGlzIHJlbGVhc2VkIGFzIGEgd2hv
bGUsIG5vdCBhcyBpbmRpdmlkdWFsIGNoYW5nZXMgdGhhdCBhcmUKbm90IHVucmVsYXRlZC4KCkkg
dGhpbmsgeW91IG5lZWQgdG8gcmV2aXNpdCB5b3VyIHRlc3Rpbmcgc3RyYXRlZ3ksIGdvb2QgbHVj
ayEKCmdyZWcgay1oCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

