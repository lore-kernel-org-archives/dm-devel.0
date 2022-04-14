Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1E4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 01:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-ilqZgXnKPx6qxZylN_NCXA-1; Wed, 13 Apr 2022 21:12:35 -0400
X-MC-Unique: ilqZgXnKPx6qxZylN_NCXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0E801018AA4;
	Thu, 14 Apr 2022 01:12:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A9CB200BCBC;
	Thu, 14 Apr 2022 01:12:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 361CD1940347;
	Thu, 14 Apr 2022 01:12:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90A841940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 01:12:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80B9A53CF; Thu, 14 Apr 2022 01:12:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C94553CD
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 01:12:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 298AF296A624
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 01:12:25 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-gzMuA8vIOmqD59PSNVgpvg-1; Wed, 13 Apr 2022 21:12:23 -0400
X-MC-Unique: gzMuA8vIOmqD59PSNVgpvg-1
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kf1bm4ZlVzgYkh;
 Thu, 14 Apr 2022 09:10:28 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 09:12:18 +0800
Received: from [10.174.176.127] (10.174.176.127) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 09:12:18 +0800
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>
References: <20220309094148.2164043-1-luomeng12@huawei.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <fcd9805e-9a07-a80d-0ea6-6dc7605f3f7f@huawei.com>
Date: Thu, 14 Apr 2022 09:12:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20220309094148.2164043-1-luomeng12@huawei.com>
X-Originating-IP: [10.174.176.127]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PTACH] dm-mpath: fix UAF in multipath_message()
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
Cc: yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

cGluZy4uLgoK1NogMjAyMi8zLzkgMTc6NDEsIEx1byBNZW5nINC0tcA6Cj4gSWYgZG1fZ2V0X2Rl
dmljZSgpIGNyZWF0ZSBkZCBpbiBtdWx0aXBhdGhfbWVzc2FnZSgpLAo+IGFuZCB0aGVuIGNhbGwg
dGFibGVfZGVwcygpIGFmdGVyIGRtX3B1dF90YWJsZV9kZXZpY2UoKSwKPiBpdCB3aWxsIGxlYWQg
dG8gY29uY3VycmVuY3kgVUFGIGJ1Z3MuCj4gCj4gT25lIG9mIHRoZSBjb25jdXJyZW5jeSBVQUYg
Y2FuIGJlIHNob3duIGFzIGJlbG93Ogo+IAo+ICAgICAgICAgICAoVVNFKSAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgKEZSRUUpCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgdGFyZ2V0X21lc3NhZ2UKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgIG11bHRpcGF0aF9tZXNzYWdlCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICAgIGRtX3B1dF9kZXZpY2UKPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgICAgICBkbV9wdXRfdGFibGVfZGV2aWNlICMKPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgIGtmcmVlKHRkKSAg
IyB0YWJsZV9kZXZpY2UgKnRkCj4gaW9jdGwgIyBETV9UQUJMRV9ERVBTX0NNRCAgICAgICAgICAg
ICB8ICAgICAgICAgLi4uCj4gICAgdGFibGVfZGVwcyAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICAgICAgIC4uLgo+ICAgIGRtX2dldF9saXZlX29yX2luYWN0aXZlX3RhYmxlICAgICAgIHwg
ICAgICAgICAuLi4KPiAgICAgIHJldHJpZXZlX2RlcCAgICAgICAgICAgICAgICAgICAgICB8ICAg
ICAgICAgLi4uCj4gICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5ICAgICAgICAgICAgICAgfCAgICAg
ICAgIC4uLgo+ICAgICAgICBkZXBzLT5kZXZbY291bnQrK10gPSAgICAgICAgICAgIHwgICAgICAg
ICAuLi4KPiAgICAgICAgICAgIGh1Z2VfZW5jb2RlX2RldiAgICAgICAgICAgICB8ICAgICAgICAg
Li4uCj4gICAgICAgICAgICAoZGQtPmRtX2Rldi0+YmRldi0+YmRfZGV2KSAgfCAgICAgICAgbGlz
dF9kZWwoJmRkLT5saXN0KQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAgICAgIGtmcmVlKGRkKSAjIGRtX2Rldl9pbnRlcm5hbAo+IAo+IFRoZSByb290IGNhdXNl
IG9mIFVBRiBidWdzIGlzIHRoYXQgZmluZF9kZXZpY2UoKSBmYWlsZWQgaW4KPiBkbV9nZXRfZGV2
aWNlKCkgYW5kIHdpbGwgY3JlYXRlIGRkIGFuZCByZWZjb3VudCBzZXQgMSwga2ZyZWUoKQo+IGlu
IGRtX3B1dF90YWJsZSgpIGlzIG5vdCBwcm90ZWN0ZWQuIFdoZW4gdGQsIHdoaWNoIHRoZXJlIGFy
ZQo+IHN0aWxsIHBvaW50ZXJzIHBvaW50IHRvLCBpcyByZWxlYXNlZCwgdGhlIGNvbmN1cnJlbmN5
IFVBRiBidWcKPiB3aWxsIGhhcHBlbi4KPiAKPiBUaGlzIHBhdGNoIGFkZCBhIGZsYWcgdG8gZGV0
ZXJtaW5lIHdoZXRoZXIgdG8gY3JlYXRlIGEgbmV3IGRkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEx1
byBNZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbWQvZG0tbXBh
dGguYyAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvbWQvZG0tdGFibGUuYyAgICAgICAgIHwg
NDMgKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0KPiAgIGluY2x1ZGUvbGludXgv
ZGV2aWNlLW1hcHBlci5oIHwgIDIgKysKPiAgIDMgZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9u
cygrKSwgMTggZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tbXBh
dGguYyBiL2RyaXZlcnMvbWQvZG0tbXBhdGguYwo+IGluZGV4IGY0NzE5YjY1ZTVlMy4uMWY4YjI5
ZWQ3OTc5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvZG0tbXBhdGguYwo+ICsrKyBiL2RyaXZl
cnMvbWQvZG0tbXBhdGguYwo+IEBAIC0xOTk5LDcgKzE5OTksNyBAQCBzdGF0aWMgaW50IG11bHRp
cGF0aF9tZXNzYWdlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25lZCBhcmdjLCBjaGFyICoq
YXJndiwKPiAgIAkJZ290byBvdXQ7Cj4gICAJfQo+ICAgCj4gLQlyID0gZG1fZ2V0X2RldmljZSh0
aSwgYXJndlsxXSwgZG1fdGFibGVfZ2V0X21vZGUodGktPnRhYmxlKSwgJmRldik7Cj4gKwlyID0g
X19kbV9nZXRfZGV2aWNlKHRpLCBhcmd2WzFdLCBkbV90YWJsZV9nZXRfbW9kZSh0aS0+dGFibGUp
LCAmZGV2LCBmYWxzZSk7Cj4gICAJaWYgKHIpIHsKPiAgIAkJRE1XQVJOKCJtZXNzYWdlOiBlcnJv
ciBnZXR0aW5nIGRldmljZSAlcyIsCj4gICAJCSAgICAgICBhcmd2WzFdKTsKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9kbS10YWJsZS5jIGIvZHJpdmVycy9tZC9kbS10YWJsZS5jCj4gaW5kZXgg
ZTQzMDk2Y2ZlOWUyLi5iOGZjN2UwYWZiODQgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9kbS10
YWJsZS5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS10YWJsZS5jCj4gQEAgLTM0MCwxMiArMzQwLDgg
QEAgZGV2X3QgZG1fZ2V0X2Rldl90KGNvbnN0IGNoYXIgKnBhdGgpCj4gICB9Cj4gICBFWFBPUlRf
U1lNQk9MX0dQTChkbV9nZXRfZGV2X3QpOwo+ICAgCj4gLS8qCj4gLSAqIEFkZCBhIGRldmljZSB0
byB0aGUgbGlzdCwgb3IganVzdCBpbmNyZW1lbnQgdGhlIHVzYWdlIGNvdW50IGlmCj4gLSAqIGl0
J3MgYWxyZWFkeSBwcmVzZW50Lgo+IC0gKi8KPiAtaW50IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRt
X3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiAtCQkgIHN0cnVj
dCBkbV9kZXYgKipyZXN1bHQpCj4gK2ludCBfX2RtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3Rhcmdl
dCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiArCQkgICAgc3RydWN0IGRt
X2RldiAqKnJlc3VsdCwgYm9vbCBjcmVhdGVfZGQpCj4gICB7Cj4gICAJaW50IHI7Cj4gICAJZGV2
X3QgZGV2Owo+IEBAIC0zNjksMTkgKzM2NSwyMSBAQCBpbnQgZG1fZ2V0X2RldmljZShzdHJ1Y3Qg
ZG1fdGFyZ2V0ICp0aSwgY29uc3QgY2hhciAqcGF0aCwgZm1vZGVfdCBtb2RlLAo+ICAgCj4gICAJ
ZGQgPSBmaW5kX2RldmljZSgmdC0+ZGV2aWNlcywgZGV2KTsKPiAgIAlpZiAoIWRkKSB7Cj4gLQkJ
ZGQgPSBrbWFsbG9jKHNpemVvZigqZGQpLCBHRlBfS0VSTkVMKTsKPiAtCQlpZiAoIWRkKQo+IC0J
CQlyZXR1cm4gLUVOT01FTTsKPiAtCj4gLQkJaWYgKChyID0gZG1fZ2V0X3RhYmxlX2RldmljZSh0
LT5tZCwgZGV2LCBtb2RlLCAmZGQtPmRtX2RldikpKSB7Cj4gLQkJCWtmcmVlKGRkKTsKPiAtCQkJ
cmV0dXJuIHI7Cj4gLQkJfQo+ICsJCWlmIChjcmVhdGVfZGQpIHsKPiArCQkJZGQgPSBrbWFsbG9j
KHNpemVvZigqZGQpLCBHRlBfS0VSTkVMKTsKPiArCQkJaWYgKCFkZCkKPiArCQkJCXJldHVybiAt
RU5PTUVNOwo+ICAgCj4gLQkJcmVmY291bnRfc2V0KCZkZC0+Y291bnQsIDEpOwo+IC0JCWxpc3Rf
YWRkKCZkZC0+bGlzdCwgJnQtPmRldmljZXMpOwo+IC0JCWdvdG8gb3V0Owo+ICsJCQlpZiAoKHIg
PSBkbV9nZXRfdGFibGVfZGV2aWNlKHQtPm1kLCBkZXYsIG1vZGUsICZkZC0+ZG1fZGV2KSkpIHsK
PiArCQkJCWtmcmVlKGRkKTsKPiArCQkJCXJldHVybiByOwo+ICsJCQl9Cj4gICAKPiArCQkJcmVm
Y291bnRfc2V0KCZkZC0+Y291bnQsIDEpOwo+ICsJCQlsaXN0X2FkZCgmZGQtPmxpc3QsICZ0LT5k
ZXZpY2VzKTsKPiArCQkJZ290byBvdXQ7Cj4gKwkJfSBlbHNlCj4gKwkJCXJldHVybiAtRU5PREVW
Owo+ICAgCX0gZWxzZSBpZiAoZGQtPmRtX2Rldi0+bW9kZSAhPSAobW9kZSB8IGRkLT5kbV9kZXYt
Pm1vZGUpKSB7Cj4gICAJCXIgPSB1cGdyYWRlX21vZGUoZGQsIG1vZGUsIHQtPm1kKTsKPiAgIAkJ
aWYgKHIpCj4gQEAgLTM5Miw2ICszOTAsMTcgQEAgaW50IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRt
X3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiAgIAkqcmVzdWx0
ID0gZGQtPmRtX2RldjsKPiAgIAlyZXR1cm4gMDsKPiAgIH0KPiArRVhQT1JUX1NZTUJPTChfX2Rt
X2dldF9kZXZpY2UpOwo+ICsKPiArLyoKPiArICogQWRkIGEgZGV2aWNlIHRvIHRoZSBsaXN0LCBv
ciBqdXN0IGluY3JlbWVudCB0aGUgdXNhZ2UgY291bnQgaWYKPiArICogaXQncyBhbHJlYWR5IHBy
ZXNlbnQuCj4gKyAqLwo+ICtpbnQgZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwg
Y29uc3QgY2hhciAqcGF0aCwgZm1vZGVfdCBtb2RlLAo+ICsJCSAgc3RydWN0IGRtX2RldiAqKnJl
c3VsdCkKPiArewo+ICsJcmV0dXJuIF9fZG1fZ2V0X2RldmljZSh0aSwgcGF0aCwgbW9kZSwgcmVz
dWx0LCB0cnVlKTsKPiArfQo+ICAgRVhQT1JUX1NZTUJPTChkbV9nZXRfZGV2aWNlKTsKPiAgIAo+
ICAgc3RhdGljIGludCBkbV9zZXRfZGV2aWNlX2xpbWl0cyhzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwg
c3RydWN0IGRtX2RldiAqZGV2LAo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RldmljZS1t
YXBwZXIuaCBiL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oCj4gaW5kZXggYjI2ZmVjZjZj
OGU4Li5hMWI0NDc4OWUzZGMgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFw
cGVyLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaAo+IEBAIC0xNjgsNiAr
MTY4LDggQEAgZGV2X3QgZG1fZ2V0X2Rldl90KGNvbnN0IGNoYXIgKnBhdGgpOwo+ICAgaW50IGRt
X2dldF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2Rl
X3QgbW9kZSwKPiAgIAkJICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0KTsKPiAgIHZvaWQgZG1fcHV0
X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IGRtX2RldiAqZCk7Cj4gK2ludCBf
X2RtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZt
b2RlX3QgbW9kZSwKPiArCQkgICAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCwgYm9vbCBjcmVhdGVf
ZGQpOwo+ICAgCj4gICAvKgo+ICAgICogSW5mb3JtYXRpb24gYWJvdXQgYSB0YXJnZXQgdHlwZQo+
IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

