Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268B0C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 06:25:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-44FwEoJBMpqmvJpGhRvzWQ-1; Mon, 28 Feb 2022 01:25:23 -0500
X-MC-Unique: 44FwEoJBMpqmvJpGhRvzWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A161091DA0;
	Mon, 28 Feb 2022 06:25:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E700B62D56;
	Mon, 28 Feb 2022 06:25:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68BC41809CB4;
	Mon, 28 Feb 2022 06:25:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21NCYhKM021583 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Feb 2022 07:34:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F0CDBC080A6; Wed, 23 Feb 2022 12:34:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECF10C0809C
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 12:34:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDFF5381AA07
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 12:34:42 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-387-QSPuE1lVOkGx2Og5VhAV6A-1; Wed, 23 Feb 2022 07:34:40 -0500
X-MC-Unique: QSPuE1lVOkGx2Og5VhAV6A-1
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K3b696cgkz9svL;
	Wed, 23 Feb 2022 20:32:49 +0800 (CST)
Received: from [10.174.178.134] (10.174.178.134) by
	canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Wed, 23 Feb 2022 20:34:33 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20220209093751.2986716-1-yi.zhang@huawei.com>
	<YhUrH7UfBN3Uw5HP@redhat.com>
From: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <dc2af2ca-5e4c-d149-46fc-ae82dd56a121@huawei.com>
Date: Wed, 23 Feb 2022 20:34:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YhUrH7UfBN3Uw5HP@redhat.com>
X-Originating-IP: [10.174.178.134]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
	canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21NCYhKM021583
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Feb 2022 01:25:13 -0500
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
	agk@redhat.com, yukuai3@huawei.com
Subject: Re: [dm-devel] dm: make sure dm_table is binded before queue request
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi8yLzIzIDI6MjcsIE1pa2UgU25pdHplciB3cm90ZToKPiBPbiBXZWQsIEZlYiAwOSAy
MDIyIGF0ICA0OjM3UCAtMDUwMCwKPiBaaGFuZyBZaSA8eWkuemhhbmdAaHVhd2VpLmNvbT4gd3Jv
dGU6Cj4gCj4+IFdlIGZvdW5kIGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIHByb2JsZW0gd2hl
biB1c2luZyBkbS1tcGF0aCB0YXJnZXQuCj4+IFRoZSBwcm9ibGVtIGlzIGlmIHdlIHN1Ym1pdCBJ
TyBiZXR3ZWVuIGxvYWRpbmcgYW5kIGJpbmRpbmcgdGhlIHRhYmxlLAo+PiB3ZSBjb3VsZCBuZWl0
aGVyIGdldCBhIHZhbGlkIGRtX3RhcmdldCBub3IgYSB2YWxpZCBkbSB0YWJsZSB3aGVuCj4+IHN1
Ym1pdHRpbmcgcmVxdWVzdCBpbiBkbV9tcV9xdWV1ZV9ycSgpLiBCSU8gYmFzZWQgZG0gdGFyZ2V0
IGNvdWxkCj4+IGhhbmRsZSB0aGlzIGNhc2UgaW4gZG1fc3VibWl0X2JpbygpLiBUaGlzIHBhdGNo
IGZpeCB0aGlzIGJ5IGNoZWNraW5nCj4+IHRoZSBtYXBwaW5nIHRhYmxlIGJlZm9yZSBzdWJtaXR0
aW5nIHJlcXVlc3QuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFlpIDx5aS56aGFuZ0BodWF3
ZWkuY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvbWQvZG0tcnEuYyB8IDExICsrKysrKysrKy0tCj4+
ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Pgo+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1ycS5jIGIvZHJpdmVycy9tZC9kbS1ycS5jCj4+IGlu
ZGV4IDU3OWFiNjE4M2Q0ZC4uYWYyY2Y3MTUxOWU5IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21k
L2RtLXJxLmMKPj4gKysrIGIvZHJpdmVycy9tZC9kbS1ycS5jCj4+IEBAIC00OTksOCArNDk5LDE1
IEBAIHN0YXRpYyBibGtfc3RhdHVzX3QgZG1fbXFfcXVldWVfcnEoc3RydWN0IGJsa19tcV9od19j
dHggKmhjdHgsCj4+ICAKPj4gIAlpZiAodW5saWtlbHkoIXRpKSkgewo+PiAgCQlpbnQgc3JjdV9p
ZHg7Cj4+IC0JCXN0cnVjdCBkbV90YWJsZSAqbWFwID0gZG1fZ2V0X2xpdmVfdGFibGUobWQsICZz
cmN1X2lkeCk7Cj4+IC0KPj4gKwkJc3RydWN0IGRtX3RhYmxlICptYXA7Cj4+ICsKPj4gKwkJbWFw
ID0gZG1fZ2V0X2xpdmVfdGFibGUobWQsICZzcmN1X2lkeCk7Cj4+ICsJCWlmICghbWFwKSB7Cj4+
ICsJCQlETUVSUl9MSU1JVCgiJXM6IG1hcHBpbmcgdGFibGUgdW5hdmFpbGFibGUsIGVycm9yaW5n
IGlvIiwKPj4gKwkJCQkgICAgZG1fZGV2aWNlX25hbWUobWQpKTsKPj4gKwkJCWRtX3B1dF9saXZl
X3RhYmxlKG1kLCBzcmN1X2lkeCk7Cj4+ICsJCQlyZXR1cm4gQkxLX1NUU19JT0VSUjsKPj4gKwkJ
fQo+PiAgCQl0aSA9IGRtX3RhYmxlX2ZpbmRfdGFyZ2V0KG1hcCwgMCk7Cj4+ICAJCWRtX3B1dF9s
aXZlX3RhYmxlKG1kLCBzcmN1X2lkeCk7Cj4+ICAJfQo+PiAtLSAKPj4gMi4zMS4xCj4+Cj4gCj4g
SSB0aGluayBib3RoIGRtX3N1Ym1pdF9iaW8oKSBhbmQgbm93IGRtX21xX3F1ZXVlX3JxKCkgc2hv
dWxkIF9ub3RfCj4gZXJyb3IgdGhlIElPLiAgVGhpcyBpcyBzdWNoIGEgbmFycm93IHJhY2UgZHVy
aW5nIGRldmljZSBzZXR1cCB0aGF0IGl0Cj4gYmVzdCB0byByZXF1ZXVlIHRoZSBJTy4KPiAKClll
c++8jG1ha2Ugc2Vuc2UsIHRoYW5rcyBmb3IgdGhlIGZpeC4KClRoYW5rcywKWWkuCgo+IEknbGwg
cXVldWUgdGhpcyBmb3IgNS4xODoKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1ycS5j
IGIvZHJpdmVycy9tZC9kbS1ycS5jCj4gaW5kZXggNjk0OGQ1ZGI5MDkyLi4zZGQwNDBhNTYzMTgg
MTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9kbS1ycS5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS1y
cS5jCj4gQEAgLTQ5MSw4ICs0OTEsMTMgQEAgc3RhdGljIGJsa19zdGF0dXNfdCBkbV9tcV9xdWV1
ZV9ycShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKPiAgCj4gIAlpZiAodW5saWtlbHkoIXRp
KSkgewo+ICAJCWludCBzcmN1X2lkeDsKPiAtCQlzdHJ1Y3QgZG1fdGFibGUgKm1hcCA9IGRtX2dl
dF9saXZlX3RhYmxlKG1kLCAmc3JjdV9pZHgpOwo+ICsJCXN0cnVjdCBkbV90YWJsZSAqbWFwOwo+
ICAKPiArCQltYXAgPSBkbV9nZXRfbGl2ZV90YWJsZShtZCwgJnNyY3VfaWR4KTsKPiArCQlpZiAo
dW5saWtlbHkoIW1hcCkpIHsKPiArCQkJZG1fcHV0X2xpdmVfdGFibGUobWQsIHNyY3VfaWR4KTsK
PiArCQkJcmV0dXJuIEJMS19TVFNfUkVTT1VSQ0U7Cj4gKwkJfQo+ICAJCXRpID0gZG1fdGFibGVf
ZmluZF90YXJnZXQobWFwLCAwKTsKPiAgCQlkbV9wdXRfbGl2ZV90YWJsZShtZCwgc3JjdV9pZHgp
Owo+ICAJfQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMK
PiBpbmRleCAwODIzNjZkMGFkNDkuLmM3MGJlNmU1ZWQ1NSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L21kL2RtLmMKPiArKysgYi9kcml2ZXJzL21kL2RtLmMKPiBAQCAtMTUzMywxNSArMTUzMywxMCBA
QCBzdGF0aWMgdm9pZCBkbV9zdWJtaXRfYmlvKHN0cnVjdCBiaW8gKmJpbykKPiAgCXN0cnVjdCBk
bV90YWJsZSAqbWFwOwo+ICAKPiAgCW1hcCA9IGRtX2dldF9saXZlX3RhYmxlKG1kLCAmc3JjdV9p
ZHgpOwo+IC0JaWYgKHVubGlrZWx5KCFtYXApKSB7Cj4gLQkJRE1FUlJfTElNSVQoIiVzOiBtYXBw
aW5nIHRhYmxlIHVuYXZhaWxhYmxlLCBlcnJvcmluZyBpbyIsCj4gLQkJCSAgICBkbV9kZXZpY2Vf
bmFtZShtZCkpOwo+IC0JCWJpb19pb19lcnJvcihiaW8pOwo+IC0JCWdvdG8gb3V0Owo+IC0JfQo+
ICAKPiAtCS8qIElmIHN1c3BlbmRlZCwgcXVldWUgdGhpcyBJTyBmb3IgbGF0ZXIgKi8KPiAtCWlm
ICh1bmxpa2VseSh0ZXN0X2JpdChETUZfQkxPQ0tfSU9fRk9SX1NVU1BFTkQsICZtZC0+ZmxhZ3Mp
KSkgewo+ICsJLyogSWYgc3VzcGVuZGVkLCBvciBtYXAgbm90IHlldCBhdmFpbGFibGUsIHF1ZXVl
IHRoaXMgSU8gZm9yIGxhdGVyICovCj4gKwlpZiAodW5saWtlbHkodGVzdF9iaXQoRE1GX0JMT0NL
X0lPX0ZPUl9TVVNQRU5ELCAmbWQtPmZsYWdzKSkgfHwKPiArCSAgICB1bmxpa2VseSghbWFwKSkg
ewo+ICAJCWlmIChiaW8tPmJpX29wZiAmIFJFUV9OT1dBSVQpCj4gIAkJCWJpb193b3VsZGJsb2Nr
X2Vycm9yKGJpbyk7Cj4gIAkJZWxzZSBpZiAoYmlvLT5iaV9vcGYgJiBSRVFfUkFIRUFEKQo+IAo+
IC4KPiAKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

