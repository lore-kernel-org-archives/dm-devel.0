Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830D6C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 10 May 2022 01:19:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-LpC60bK0N9yK2ntwwSMvLw-1; Mon, 09 May 2022 21:19:26 -0400
X-MC-Unique: LpC60bK0N9yK2ntwwSMvLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D0A829ABA03;
	Tue, 10 May 2022 01:19:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CF67C15E73;
	Tue, 10 May 2022 01:19:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3CEB1947052;
	Tue, 10 May 2022 01:19:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D5661947051
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 01:19:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 693432024CDA; Tue, 10 May 2022 01:19:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 648FD2024CB7
 for <dm-devel@redhat.com>; Tue, 10 May 2022 01:19:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FCAC29ABA01
 for <dm-devel@redhat.com>; Tue, 10 May 2022 01:19:14 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-Y-Kb7kWsNFS8UXug-zoBhw-1; Mon, 09 May 2022 21:19:10 -0400
X-MC-Unique: Y-Kb7kWsNFS8UXug-zoBhw-1
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ky0SD0WbLzCsYH;
 Tue, 10 May 2022 09:14:20 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 09:19:06 +0800
Received: from [10.174.176.127] (10.174.176.127) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 09:19:05 +0800
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
 <ejt@redhat.com>
References: <20220415085631.3613813-1-luomeng12@huawei.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <aa9125b5-0e49-2a78-3fd6-5f74d3c92bb9@huawei.com>
Date: Tue, 10 May 2022 09:19:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20220415085631.3613813-1-luomeng12@huawei.com>
X-Originating-IP: [10.174.176.127]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] dm mpath: fix UAF in multipath_message()
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

ZnJpZW5kbHkgcGluZy4KCtTaIDIwMjIvNC8xNSAxNjo1NiwgTHVvIE1lbmcg0LS1wDoKPiBJZiBk
bV9nZXRfZGV2aWNlKCkgY3JlYXRlIGRkIGluIG11bHRpcGF0aF9tZXNzYWdlKCksCj4gYW5kIHRo
ZW4gY2FsbCB0YWJsZV9kZXBzKCkgYWZ0ZXIgZG1fcHV0X3RhYmxlX2RldmljZSgpLAo+IGl0IHdp
bGwgbGVhZCB0byBjb25jdXJyZW5jeSBVQUYgYnVncy4KPiAKPiBPbmUgb2YgdGhlIGNvbmN1cnJl
bmN5IFVBRiBjYW4gYmUgc2hvd24gYXMgYmVsb3c6Cj4gCj4gICAgICAgICAgIChVU0UpICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgICAoRlJFRSkKPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICB0YXJnZXRfbWVzc2FnZQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgbXVsdGlwYXRoX21lc3NhZ2UKPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgZG1fcHV0X2RldmljZQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgIGRtX3B1dF90YWJsZV9kZXZpY2Ug
Iwo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAga2Zy
ZWUodGQpICAjIHRhYmxlX2RldmljZSAqdGQKPiBpb2N0bCAjIERNX1RBQkxFX0RFUFNfQ01EICAg
ICAgICAgICAgIHwgICAgICAgICAuLi4KPiAgICB0YWJsZV9kZXBzICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgICAgICAgLi4uCj4gICAgZG1fZ2V0X2xpdmVfb3JfaW5hY3RpdmVfdGFibGUg
ICAgICAgfCAgICAgICAgIC4uLgo+ICAgICAgcmV0cmlldmVfZGVwICAgICAgICAgICAgICAgICAg
ICAgIHwgICAgICAgICAuLi4KPiAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkgICAgICAgICAgICAg
ICB8ICAgICAgICAgLi4uCj4gICAgICAgIGRlcHMtPmRldltjb3VudCsrXSA9ICAgICAgICAgICAg
fCAgICAgICAgIC4uLgo+ICAgICAgICAgICAgaHVnZV9lbmNvZGVfZGV2ICAgICAgICAgICAgIHwg
ICAgICAgICAuLi4KPiAgICAgICAgICAgIChkZC0+ZG1fZGV2LT5iZGV2LT5iZF9kZXYpICB8ICAg
ICAgICBsaXN0X2RlbCgmZGQtPmxpc3QpCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgICAgICAga2ZyZWUoZGQpICMgZG1fZGV2X2ludGVybmFsCj4gCj4gVGhlIHJv
b3QgY2F1c2Ugb2YgVUFGIGJ1Z3MgaXMgdGhhdCBmaW5kX2RldmljZSgpIGZhaWxlZCBpbgo+IGRt
X2dldF9kZXZpY2UoKSBhbmQgd2lsbCBjcmVhdGUgZGQgYW5kIHJlZmNvdW50IHNldCAxLCBrZnJl
ZSgpCj4gaW4gZG1fcHV0X3RhYmxlKCkgaXMgbm90IHByb3RlY3RlZC4gV2hlbiB0ZCwgd2hpY2gg
dGhlcmUgYXJlCj4gc3RpbGwgcG9pbnRlcnMgcG9pbnQgdG8sIGlzIHJlbGVhc2VkLCB0aGUgY29u
Y3VycmVuY3kgVUFGIGJ1Zwo+IHdpbGwgaGFwcGVuLgo+IAo+IFRoaXMgcGF0Y2ggYWRkIGEgZmxh
ZyB0byBkZXRlcm1pbmUgd2hldGhlciB0byBjcmVhdGUgYSBuZXcgZGQuCj4gCj4gRml4ZXM6IDgy
MTVkNmVjNWZlZShkbSB0YWJsZTogcmVtb3ZlIHVudXNlZCBkbV9nZXRfZGV2aWNlIHJhbmdlIHBh
cmFtZXRlcnMpCj4gU2lnbmVkLW9mZi1ieTogTHVvIE1lbmcgPGx1b21lbmcxMkBodWF3ZWkuY29t
Pgo+IC0tLQo+ICAgZHJpdmVycy9tZC9kbS1tcGF0aC5jICAgICAgICAgfCAgMiArLQo+ICAgZHJp
dmVycy9tZC9kbS10YWJsZS5jICAgICAgICAgfCA0MyArKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLQo+ICAgaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggfCAgMiArKwo+ICAg
MyBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKPiAKPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1tcGF0aC5jIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5j
Cj4gaW5kZXggNmVkOWQyNzMxMjU0Li5hZDYzZDcyOWZmODEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5jCj4gQEAgLTE5OTUs
NyArMTk5NSw3IEBAIHN0YXRpYyBpbnQgbXVsdGlwYXRoX21lc3NhZ2Uoc3RydWN0IGRtX3Rhcmdl
dCAqdGksIHVuc2lnbmVkIGFyZ2MsIGNoYXIgKiphcmd2LAo+ICAgCQlnb3RvIG91dDsKPiAgIAl9
Cj4gICAKPiAtCXIgPSBkbV9nZXRfZGV2aWNlKHRpLCBhcmd2WzFdLCBkbV90YWJsZV9nZXRfbW9k
ZSh0aS0+dGFibGUpLCAmZGV2KTsKPiArCXIgPSBfX2RtX2dldF9kZXZpY2UodGksIGFyZ3ZbMV0s
IGRtX3RhYmxlX2dldF9tb2RlKHRpLT50YWJsZSksICZkZXYsIGZhbHNlKTsKPiAgIAlpZiAocikg
ewo+ICAgCQlETVdBUk4oIm1lc3NhZ2U6IGVycm9yIGdldHRpbmcgZGV2aWNlICVzIiwKPiAgIAkJ
ICAgICAgIGFyZ3ZbMV0pOwo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMgYi9k
cml2ZXJzL21kL2RtLXRhYmxlLmMKPiBpbmRleCAwMzU0MWNmYzIzMTcuLjlkYmMwYmEzN2FlNiAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMKPiArKysgYi9kcml2ZXJzL21kL2Rt
LXRhYmxlLmMKPiBAQCAtMzM5LDEyICszMzksOCBAQCBkZXZfdCBkbV9nZXRfZGV2X3QoY29uc3Qg
Y2hhciAqcGF0aCkKPiAgIH0KPiAgIEVYUE9SVF9TWU1CT0xfR1BMKGRtX2dldF9kZXZfdCk7Cj4g
ICAKPiAtLyoKPiAtICogQWRkIGEgZGV2aWNlIHRvIHRoZSBsaXN0LCBvciBqdXN0IGluY3JlbWVu
dCB0aGUgdXNhZ2UgY291bnQgaWYKPiAtICogaXQncyBhbHJlYWR5IHByZXNlbnQuCj4gLSAqLwo+
IC1pbnQgZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgY29uc3QgY2hhciAqcGF0
aCwgZm1vZGVfdCBtb2RlLAo+IC0JCSAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCkKPiAraW50IF9f
ZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgY29uc3QgY2hhciAqcGF0aCwgZm1v
ZGVfdCBtb2RlLAo+ICsJCSAgICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0LCBib29sIGNyZWF0ZV9k
ZCkKPiAgIHsKPiAgIAlpbnQgcjsKPiAgIAlkZXZfdCBkZXY7Cj4gQEAgLTM2OCwxOSArMzY0LDIx
IEBAIGludCBkbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpw
YXRoLCBmbW9kZV90IG1vZGUsCj4gICAKPiAgIAlkZCA9IGZpbmRfZGV2aWNlKCZ0LT5kZXZpY2Vz
LCBkZXYpOwo+ICAgCWlmICghZGQpIHsKPiAtCQlkZCA9IGttYWxsb2Moc2l6ZW9mKCpkZCksIEdG
UF9LRVJORUwpOwo+IC0JCWlmICghZGQpCj4gLQkJCXJldHVybiAtRU5PTUVNOwo+IC0KPiAtCQlp
ZiAoKHIgPSBkbV9nZXRfdGFibGVfZGV2aWNlKHQtPm1kLCBkZXYsIG1vZGUsICZkZC0+ZG1fZGV2
KSkpIHsKPiAtCQkJa2ZyZWUoZGQpOwo+IC0JCQlyZXR1cm4gcjsKPiAtCQl9Cj4gKwkJaWYgKGNy
ZWF0ZV9kZCkgewo+ICsJCQlkZCA9IGttYWxsb2Moc2l6ZW9mKCpkZCksIEdGUF9LRVJORUwpOwo+
ICsJCQlpZiAoIWRkKQo+ICsJCQkJcmV0dXJuIC1FTk9NRU07Cj4gICAKPiAtCQlyZWZjb3VudF9z
ZXQoJmRkLT5jb3VudCwgMSk7Cj4gLQkJbGlzdF9hZGQoJmRkLT5saXN0LCAmdC0+ZGV2aWNlcyk7
Cj4gLQkJZ290byBvdXQ7Cj4gKwkJCWlmICgociA9IGRtX2dldF90YWJsZV9kZXZpY2UodC0+bWQs
IGRldiwgbW9kZSwgJmRkLT5kbV9kZXYpKSkgewo+ICsJCQkJa2ZyZWUoZGQpOwo+ICsJCQkJcmV0
dXJuIHI7Cj4gKwkJCX0KPiAgIAo+ICsJCQlyZWZjb3VudF9zZXQoJmRkLT5jb3VudCwgMSk7Cj4g
KwkJCWxpc3RfYWRkKCZkZC0+bGlzdCwgJnQtPmRldmljZXMpOwo+ICsJCQlnb3RvIG91dDsKPiAr
CQl9IGVsc2UKPiArCQkJcmV0dXJuIC1FTk9ERVY7Cj4gICAJfSBlbHNlIGlmIChkZC0+ZG1fZGV2
LT5tb2RlICE9IChtb2RlIHwgZGQtPmRtX2Rldi0+bW9kZSkpIHsKPiAgIAkJciA9IHVwZ3JhZGVf
bW9kZShkZCwgbW9kZSwgdC0+bWQpOwo+ICAgCQlpZiAocikKPiBAQCAtMzkxLDYgKzM4OSwxNyBA
QCBpbnQgZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgY29uc3QgY2hhciAqcGF0
aCwgZm1vZGVfdCBtb2RlLAo+ICAgCSpyZXN1bHQgPSBkZC0+ZG1fZGV2Owo+ICAgCXJldHVybiAw
Owo+ICAgfQo+ICtFWFBPUlRfU1lNQk9MKF9fZG1fZ2V0X2RldmljZSk7Cj4gKwo+ICsvKgo+ICsg
KiBBZGQgYSBkZXZpY2UgdG8gdGhlIGxpc3QsIG9yIGp1c3QgaW5jcmVtZW50IHRoZSB1c2FnZSBj
b3VudCBpZgo+ICsgKiBpdCdzIGFscmVhZHkgcHJlc2VudC4KPiArICovCj4gK2ludCBkbV9nZXRf
ZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1v
ZGUsCj4gKwkJICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0KQo+ICt7Cj4gKwlyZXR1cm4gX19kbV9n
ZXRfZGV2aWNlKHRpLCBwYXRoLCBtb2RlLCByZXN1bHQsIHRydWUpOwo+ICt9Cj4gICBFWFBPUlRf
U1lNQk9MKGRtX2dldF9kZXZpY2UpOwo+ICAgCj4gICBzdGF0aWMgaW50IGRtX3NldF9kZXZpY2Vf
bGltaXRzKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgZG1fZGV2ICpkZXYsCj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oIGIvaW5jbHVkZS9saW51eC9kZXZp
Y2UtbWFwcGVyLmgKPiBpbmRleCBjMmEzNzU4YzRhYWEuLjZlYTU0MmUxODA0OCAxMDA2NDQKPiAt
LS0gYS9pbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaAo+ICsrKyBiL2luY2x1ZGUvbGludXgv
ZGV2aWNlLW1hcHBlci5oCj4gQEAgLTE2OCw2ICsxNjgsOCBAQCBkZXZfdCBkbV9nZXRfZGV2X3Qo
Y29uc3QgY2hhciAqcGF0aCk7Cj4gICBpbnQgZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSwgY29uc3QgY2hhciAqcGF0aCwgZm1vZGVfdCBtb2RlLAo+ICAgCQkgIHN0cnVjdCBkbV9k
ZXYgKipyZXN1bHQpOwo+ICAgdm9pZCBkbV9wdXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRp
LCBzdHJ1Y3QgZG1fZGV2ICpkKTsKPiAraW50IF9fZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFy
Z2V0ICp0aSwgY29uc3QgY2hhciAqcGF0aCwgZm1vZGVfdCBtb2RlLAo+ICsJCSAgICBzdHJ1Y3Qg
ZG1fZGV2ICoqcmVzdWx0LCBib29sIGNyZWF0ZV9kZCk7Cj4gICAKPiAgIC8qCj4gICAgKiBJbmZv
cm1hdGlvbiBhYm91dCBhIHRhcmdldCB0eXBlCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

