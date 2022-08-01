Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC61C00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659359877;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+UCiGwGt55Lz6eFC5WYmyln7IzrK2xaCIvL6Ovr7T/s=;
	b=G6yFnTYB8P4auQuly5wV/6k7tgiFUZLlTT46XwrKrqVsubemo9uq9vR5LmsL1gwewu+Z/5
	G9eDzQB1HGuZj5aACQIN9XR7Da6IF4MKXxBHyFWCntXN3dfwJBh5f5z4+PG1804XHMCwo0
	8oPeBCtAnDqCVIY0nPmC6q4jEK9oh9Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-0n9C_FdOMX2redq9oGcxkg-1; Mon, 01 Aug 2022 09:17:55 -0400
X-MC-Unique: 0n9C_FdOMX2redq9oGcxkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D3B811766;
	Mon,  1 Aug 2022 13:17:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2AD940CF8ED;
	Mon,  1 Aug 2022 13:17:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 67D971946A41;
	Mon,  1 Aug 2022 13:17:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C89A71946A40
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 13:17:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DAD62026D07; Mon,  1 Aug 2022 13:17:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 78E9A2026D64
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:17:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43BCD85A584
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:17:50 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343--fLyyGh6OxiFnd-v2j0QsA-1; Mon, 01 Aug 2022 09:17:46 -0400
X-MC-Unique: -fLyyGh6OxiFnd-v2j0QsA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 73B0E61254;
 Mon,  1 Aug 2022 13:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BAEC433C1;
 Mon,  1 Aug 2022 13:17:44 +0000 (UTC)
Date: Mon, 1 Aug 2022 15:17:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <YufSdhzXq/Fmozdw@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
 <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgMDEsIDIwMjIgYXQgMDg6MjU6MjdQTSArMDgwMCwgWXUgS3VhaSB3cm90ZToK
PiBIaSwgR3JlZwo+IAo+IOWcqCAyMDIyLzA4LzAxIDE5OjE5LCBHcmVnIEtIIOWGmemBkzoKPiA+
IE9uIEZyaSwgSnVsIDI5LCAyMDIyIGF0IDAyOjIzOjU0UE0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6
Cj4gPiA+IEZyb206IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+ID4gPiAKPiA+ID4g
Y29tbWl0IDBkYmNmZTI0N2YyMmE2ZDczMzAyZGZhNjkxYzQ4YjNjMTRkMzFjNGMgdXBzdHJlYW0u
Cj4gPiA+IAo+ID4gPiBJbnZlcnQgdGhleSB3YXkgdGhlIGhvbGRlciByZWxhdGlvbnMgYXJlIHRy
YWNrZWQuICBUaGlzIHZlcnkKPiA+ID4gc2xpZ2h0bHkgcmVkdWNlcyB0aGUgbWVtb3J5IG92ZXJo
ZWFkIGZvciBwYXJ0aXRpb25lZCBkZXZpY2VzLgo+ID4gPiAKPiA+ID4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IFl1IEt1
YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPiA+ID4gLS0tCj4gPiA+ICAgYmxvY2svZ2VuaGQuYyAg
ICAgICAgICAgICB8ICAzICsrKwo+ID4gPiAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgfCAz
MSArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tCj4gPiA+ICAgaW5jbHVkZS9saW51eC9i
bGtfdHlwZXMuaCB8ICAzIC0tLQo+ID4gPiAgIGluY2x1ZGUvbGludXgvZ2VuaGQuaCAgICAgfCAg
NCArKystCj4gPiA+ICAgNCBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxNiBkZWxl
dGlvbnMoLSkKPiA+ID4gCj4gPiA+IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2sv
Z2VuaGQuYwo+ID4gPiBpbmRleCA3OTZiYWY3NjEyMDIuLjJiMTFhMjczNTI4NSAxMDA2NDQKPiA+
ID4gLS0tIGEvYmxvY2svZ2VuaGQuYwo+ID4gPiArKysgYi9ibG9jay9nZW5oZC5jCj4gPiA+IEBA
IC0xNzYwLDYgKzE3NjAsOSBAQCBzdHJ1Y3QgZ2VuZGlzayAqX19hbGxvY19kaXNrX25vZGUoaW50
IG1pbm9ycywgaW50IG5vZGVfaWQpCj4gPiA+ICAgCWRpc2tfdG9fZGV2KGRpc2spLT5jbGFzcyA9
ICZibG9ja19jbGFzczsKPiA+ID4gICAJZGlza190b19kZXYoZGlzayktPnR5cGUgPSAmZGlza190
eXBlOwo+ID4gPiAgIAlkZXZpY2VfaW5pdGlhbGl6ZShkaXNrX3RvX2RldihkaXNrKSk7Cj4gPiA+
ICsjaWZkZWYgQ09ORklHX1NZU0ZTCj4gPiA+ICsJSU5JVF9MSVNUX0hFQUQoJmRpc2stPnNsYXZl
X2JkZXZzKTsKPiA+ID4gKyNlbmRpZgo+ID4gPiAgIAlyZXR1cm4gZGlzazsKPiA+ID4gICBvdXRf
ZnJlZV9wYXJ0MDoKPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL2Jsb2NrX2Rldi5jIGIvZnMvYmxvY2tf
ZGV2LmMKPiA+ID4gaW5kZXggMjlmMDIwYzRiMmQwLi5hMjAyYzc2ZmNmN2YgMTAwNjQ0Cj4gPiA+
IC0tLSBhL2ZzL2Jsb2NrX2Rldi5jCj4gPiA+ICsrKyBiL2ZzL2Jsb2NrX2Rldi5jCj4gPiA+IEBA
IC04MjMsOSArODIzLDYgQEAgc3RhdGljIHZvaWQgaW5pdF9vbmNlKHZvaWQgKmZvbykKPiA+ID4g
ICAJbWVtc2V0KGJkZXYsIDAsIHNpemVvZigqYmRldikpOwo+ID4gPiAgIAltdXRleF9pbml0KCZi
ZGV2LT5iZF9tdXRleCk7Cj4gPiA+IC0jaWZkZWYgQ09ORklHX1NZU0ZTCj4gPiA+IC0JSU5JVF9M
SVNUX0hFQUQoJmJkZXYtPmJkX2hvbGRlcl9kaXNrcyk7Cj4gPiA+IC0jZW5kaWYKPiA+ID4gICAJ
YmRldi0+YmRfYmRpID0gJm5vb3BfYmFja2luZ19kZXZfaW5mbzsKPiA+ID4gICAJaW5vZGVfaW5p
dF9vbmNlKCZlaS0+dmZzX2lub2RlKTsKPiA+ID4gICAJLyogSW5pdGlhbGl6ZSBtdXRleCBmb3Ig
ZnJlZXplLiAqLwo+ID4gPiBAQCAtMTE4OCw3ICsxMTg1LDcgQEAgRVhQT1JUX1NZTUJPTChiZF9h
Ym9ydF9jbGFpbWluZyk7Cj4gPiA+ICAgI2lmZGVmIENPTkZJR19TWVNGUwo+ID4gPiAgIHN0cnVj
dCBiZF9ob2xkZXJfZGlzayB7Cj4gPiA+ICAgCXN0cnVjdCBsaXN0X2hlYWQJbGlzdDsKPiA+ID4g
LQlzdHJ1Y3QgZ2VuZGlzawkJKmRpc2s7Cj4gPiA+ICsJc3RydWN0IGJsb2NrX2RldmljZQkqYmRl
djsKPiA+ID4gICAJaW50CQkJcmVmY250Owo+ID4gPiAgIH07Cj4gPiA+IEBAIC0xMTk3LDggKzEx
OTQsOCBAQCBzdGF0aWMgc3RydWN0IGJkX2hvbGRlcl9kaXNrICpiZF9maW5kX2hvbGRlcl9kaXNr
KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4gPiA+ICAgewo+ID4gPiAgIAlzdHJ1Y3QgYmRf
aG9sZGVyX2Rpc2sgKmhvbGRlcjsKPiA+ID4gLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGhvbGRlciwg
JmJkZXYtPmJkX2hvbGRlcl9kaXNrcywgbGlzdCkKPiA+ID4gLQkJaWYgKGhvbGRlci0+ZGlzayA9
PSBkaXNrKQo+ID4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkoaG9sZGVyLCAmZGlzay0+c2xhdmVf
YmRldnMsIGxpc3QpCj4gPiA+ICsJCWlmIChob2xkZXItPmJkZXYgPT0gYmRldikKPiA+ID4gICAJ
CQlyZXR1cm4gaG9sZGVyOwo+ID4gPiAgIAlyZXR1cm4gTlVMTDsKPiA+ID4gICB9Cj4gPiA+IEBA
IC0xMjQ0LDkgKzEyNDEsMTMgQEAgc3RhdGljIHZvaWQgZGVsX3N5bWxpbmsoc3RydWN0IGtvYmpl
Y3QgKmZyb20sIHN0cnVjdCBrb2JqZWN0ICp0bykKPiA+ID4gICBpbnQgYmRfbGlua19kaXNrX2hv
bGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiA+
ID4gICB7Cj4gPiA+ICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVyOwo+ID4gPiArCXN0
cnVjdCBibG9ja19kZXZpY2UgKmJkZXZfaG9sZGVyID0gYmRnZXRfZGlzayhkaXNrLCAwKTsKPiA+
ID4gICAJaW50IHJldCA9IDA7Cj4gPiA+IC0JbXV0ZXhfbG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+
ID4gPiArCWlmIChXQVJOX09OX09OQ0UoIWJkZXZfaG9sZGVyKSkKPiA+ID4gKwkJcmV0dXJuIC1F
Tk9FTlQ7Cj4gPiA+ICsKPiA+ID4gKwltdXRleF9sb2NrKCZiZGV2X2hvbGRlci0+YmRfbXV0ZXgp
Owo+ID4gPiAgIAlXQVJOX09OX09OQ0UoIWJkZXYtPmJkX2hvbGRlcik7Cj4gPiA+IEBAIC0xMjY3
LDcgKzEyNjgsNyBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiA+ID4gICAJfQo+ID4gPiAgIAlJTklUX0xJ
U1RfSEVBRCgmaG9sZGVyLT5saXN0KTsKPiA+ID4gLQlob2xkZXItPmRpc2sgPSBkaXNrOwo+ID4g
PiArCWhvbGRlci0+YmRldiA9IGJkZXY7Cj4gPiA+ICAgCWhvbGRlci0+cmVmY250ID0gMTsKPiA+
ID4gICAJcmV0ID0gYWRkX3N5bWxpbmsoZGlzay0+c2xhdmVfZGlyLCAmcGFydF90b19kZXYoYmRl
di0+YmRfcGFydCktPmtvYmopOwo+ID4gPiBAQCAtMTI4Myw3ICsxMjg0LDcgQEAgaW50IGJkX2xp
bmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sg
KmRpc2spCj4gPiA+ICAgCSAqLwo+ID4gPiAgIAlrb2JqZWN0X2dldChiZGV2LT5iZF9wYXJ0LT5o
b2xkZXJfZGlyKTsKPiA+ID4gLQlsaXN0X2FkZCgmaG9sZGVyLT5saXN0LCAmYmRldi0+YmRfaG9s
ZGVyX2Rpc2tzKTsKPiA+ID4gKwlsaXN0X2FkZCgmaG9sZGVyLT5saXN0LCAmZGlzay0+c2xhdmVf
YmRldnMpOwo+ID4gPiAgIAlnb3RvIG91dF91bmxvY2s7Cj4gPiA+ICAgb3V0X2RlbDoKPiA+ID4g
QEAgLTEyOTEsNyArMTI5Miw4IEBAIGludCBiZF9saW5rX2Rpc2tfaG9sZGVyKHN0cnVjdCBibG9j
a19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+ID4gPiAgIG91dF9mcmVlOgo+
ID4gPiAgIAlrZnJlZShob2xkZXIpOwo+ID4gPiAgIG91dF91bmxvY2s6Cj4gPiA+IC0JbXV0ZXhf
dW5sb2NrKCZiZGV2LT5iZF9tdXRleCk7Cj4gPiA+ICsJbXV0ZXhfdW5sb2NrKCZiZGV2X2hvbGRl
ci0+YmRfbXV0ZXgpOwo+ID4gPiArCWJkcHV0KGJkZXZfaG9sZGVyKTsKPiA+ID4gICAJcmV0dXJu
IHJldDsKPiA+ID4gICB9Cj4gPiA+ICAgRVhQT1JUX1NZTUJPTF9HUEwoYmRfbGlua19kaXNrX2hv
bGRlcik7Cj4gPiA+IEBAIC0xMzA5LDggKzEzMTEsMTIgQEAgRVhQT1JUX1NZTUJPTF9HUEwoYmRf
bGlua19kaXNrX2hvbGRlcik7Cj4gPiA+ICAgdm9pZCBiZF91bmxpbmtfZGlza19ob2xkZXIoc3Ry
dWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4gPiA+ICAgewo+
ID4gPiAgIAlzdHJ1Y3QgYmRfaG9sZGVyX2Rpc2sgKmhvbGRlcjsKPiA+ID4gKwlzdHJ1Y3QgYmxv
Y2tfZGV2aWNlICpiZGV2X2hvbGRlciA9IGJkZ2V0X2Rpc2soZGlzaywgMCk7Cj4gPiA+IC0JbXV0
ZXhfbG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+ID4gPiArCWlmIChXQVJOX09OX09OQ0UoIWJkZXZf
aG9sZGVyKSkKPiA+ID4gKwkJcmV0dXJuOwo+ID4gPiArCj4gPiA+ICsJbXV0ZXhfbG9jaygmYmRl
dl9ob2xkZXItPmJkX211dGV4KTsKPiA+ID4gICAJaG9sZGVyID0gYmRfZmluZF9ob2xkZXJfZGlz
ayhiZGV2LCBkaXNrKTsKPiA+ID4gQEAgLTEzMjMsNyArMTMyOSw4IEBAIHZvaWQgYmRfdW5saW5r
X2Rpc2tfaG9sZGVyKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpk
aXNrKQo+ID4gPiAgIAkJa2ZyZWUoaG9sZGVyKTsKPiA+ID4gICAJfQo+ID4gPiAtCW11dGV4X3Vu
bG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+ID4gPiArCW11dGV4X3VubG9jaygmYmRldl9ob2xkZXIt
PmJkX211dGV4KTsKPiA+ID4gKwliZHB1dChiZGV2X2hvbGRlcik7Cj4gPiA+ICAgfQo+ID4gPiAg
IEVYUE9SVF9TWU1CT0xfR1BMKGJkX3VubGlua19kaXNrX2hvbGRlcik7Cj4gPiA+ICAgI2VuZGlm
Cj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9s
aW51eC9ibGtfdHlwZXMuaAo+ID4gPiBpbmRleCBkOWI2OWJiZGU1Y2MuLjFiODRlY2IzNGMxOCAx
MDA2NDQKPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+ID4gPiArKysgYi9p
bmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCj4gPiA+IEBAIC0yOSw5ICsyOSw2IEBAIHN0cnVjdCBi
bG9ja19kZXZpY2Ugewo+ID4gPiAgIAl2b2lkICoJCQliZF9ob2xkZXI7Cj4gPiA+ICAgCWludAkJ
CWJkX2hvbGRlcnM7Cj4gPiA+ICAgCWJvb2wJCQliZF93cml0ZV9ob2xkZXI7Cj4gPiA+IC0jaWZk
ZWYgQ09ORklHX1NZU0ZTCj4gPiA+IC0Jc3RydWN0IGxpc3RfaGVhZAliZF9ob2xkZXJfZGlza3M7
Cj4gPiA+IC0jZW5kaWYKPiA+ID4gICAJc3RydWN0IGJsb2NrX2RldmljZSAqCWJkX2NvbnRhaW5z
Owo+ID4gPiAgIAl1OAkJCWJkX3BhcnRubzsKPiA+ID4gICAJc3RydWN0IGhkX3N0cnVjdCAqCWJk
X3BhcnQ7Cj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2dlbmhkLmggYi9pbmNsdWRl
L2xpbnV4L2dlbmhkLmgKPiA+ID4gaW5kZXggMDNkYTNmNjAzZDMwLi4zZTUwNDlhNTI3ZTYgMTAw
NjQ0Cj4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvZ2VuaGQuaAo+ID4gPiArKysgYi9pbmNsdWRl
L2xpbnV4L2dlbmhkLmgKPiA+ID4gQEAgLTE5NSw3ICsxOTUsOSBAQCBzdHJ1Y3QgZ2VuZGlzayB7
Cj4gPiA+ICAgI2RlZmluZSBHRF9ORUVEX1BBUlRfU0NBTgkJMAo+ID4gPiAgIAlzdHJ1Y3Qgcndf
c2VtYXBob3JlIGxvb2t1cF9zZW07Cj4gPiA+ICAgCXN0cnVjdCBrb2JqZWN0ICpzbGF2ZV9kaXI7
Cj4gPiA+IC0KPiA+ID4gKyNpZmRlZiBDT05GSUdfU1lTRlMKPiA+ID4gKwlzdHJ1Y3QgbGlzdF9o
ZWFkCXNsYXZlX2JkZXZzOwo+ID4gPiArI2VuZGlmCj4gPiAKPiA+IFRoaXMgaXMgdmVyeSBkaWZm
ZXJlbnQgZnJvbSB0aGUgdXBzdHJlYW0gdmVyc2lvbiwgYW5kIGZvcmNlcyB0aGUgY2hhbmdlCj4g
PiBvbnRvIGV2ZXJ5b25lLCBub3QganVzdCB0aG9zZSB3aG8gaGFkIENPTkZJR19CTE9DS19IT0xE
RVJfREVQUkVDQVRFRAo+ID4gZW5hYmxlZCBsaWtlIHdhcyBkb25lIGluIHRoZSBtYWluIGtlcm5l
bCB0cmVlLgo+ID4gCj4gPiBXaHkgZm9yY2UgdGhpcyBvbiBhbGwgYW5kIG5vdCBqdXN0IHVzZSB0
aGUgc2FtZSBvcHRpb24/Cj4gPiAKPiA+IEkgd291bGQgbmVlZCBhIHN0cm9uZyBBQ0sgZnJvbSB0
aGUgb3JpZ2luYWwgZGV2ZWxvcGVycyBhbmQgbWFpbnRhaW5lcnMKPiA+IG9mIHRoZXNlIHN1YnN5
c3RlbXMgYmVmb3JlIGJlaW5nIGFibGUgdG8gdGFrZSB0aGVzZSBpbnRvIHRoZSA1LjEwIHRyZWUu
Cj4gCj4gWWVzLCBJIGFncmVlIHRoYXQgQ2hyaXN0b3BoIG11c3QgdGFrZSBhIGxvb2sgZmlyc3Qu
Cj4gPiAKPiA+IFdoYXQgcHJldmVudHMgeW91IGZyb20ganVzdCB1c2luZyA1LjE1IGZvciB0aG9z
ZSBzeXN0ZW1zIHRoYXQgcnVuIGludG8KPiA+IHRoZXNlIGlzc3Vlcz8KPiAKPiBUaGUgbnVsbCBw
b2ludGVyIHByb2JsZW0gaXMgcmVwb3J0ZWQgYnkgb3VyIHByb2R1Y3QocmVsYXRlZCB0byBkbS0K
PiBtcGF0aCksIGFuZCB0aGV5IGhhZCBiZWVuIHVzaW5nIDUuMTAgZm9yIGEgbG9uZyB0aW1lLiBB
bmQgc3dpdGNoaW5nCj4ga2VybmVsIGZvciBjb21tZXJjaWFsIHdpbGwgcmVxdWlyZSBsb3RzIG9m
IHdvcmssIGl0J3Mgbm90IGFuIG9wdGlvbgo+IGZvciBub3cuCgpJdCBzaG91bGQgYmUgdGhlIHNh
bWUgdmFsaWRhdGlvbiBhbmQgdmVyaWZpY2F0aW9uIGFuZCB0ZXN0aW5nIHBhdGggZm9yCjUuMTUu
eSBhcyBmb3IgYW4gaW50cnVzaXZlIGtlcm5lbCBjaGFuZ2UgYXMgdGhpcyBvbmUsIHJpZ2h0PyAg
V2hhdCBtYWtlcwppdCBhbnkgZGlmZmVyZW50IHRvIHByZXZlbnQgNS4xNSBmcm9tIGJlaW5nIHVz
ZWQ/Cgp0aGFua3MsCgpncmVnIGstaAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=

