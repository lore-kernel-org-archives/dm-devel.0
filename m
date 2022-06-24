Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102DBC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 24 Jun 2022 07:08:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-Jx0N6O3pMbmySVJZW0X7nA-1; Fri, 24 Jun 2022 03:08:52 -0400
X-MC-Unique: Jx0N6O3pMbmySVJZW0X7nA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E00A8032E7;
	Fri, 24 Jun 2022 07:08:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E85D416171;
	Fri, 24 Jun 2022 07:08:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43D24194B948;
	Fri, 24 Jun 2022 07:08:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 85287194B945
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Jun 2022 07:08:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C982400E89A; Fri, 24 Jun 2022 07:08:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48C0440149A6
 for <dm-devel@redhat.com>; Fri, 24 Jun 2022 07:08:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3109718E0044
 for <dm-devel@redhat.com>; Fri, 24 Jun 2022 07:08:47 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-0uZ2GH_7M3Goa9z1JtNF_A-1; Fri, 24 Jun 2022 03:08:42 -0400
X-MC-Unique: 0uZ2GH_7M3Goa9z1JtNF_A-1
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTnms2Zn7zgYhm;
 Fri, 24 Jun 2022 14:50:05 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 14:51:49 +0800
Received: from [10.174.176.127] (10.174.176.127) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 14:51:48 +0800
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
 <ejt@redhat.com>
References: <20220415085631.3613813-1-luomeng12@huawei.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <fc4c2bfd-a5f3-2451-e3f6-0daa742bab11@huawei.com>
Date: Fri, 24 Jun 2022 14:51:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20220415085631.3613813-1-luomeng12@huawei.com>
X-Originating-IP: [10.174.176.127]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Cc: yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

cGluZy4uLgoK1NogMjAyMi80LzE1IDE2OjU2LCBMdW8gTWVuZyDQtLXAOgo+IElmIGRtX2dldF9k
ZXZpY2UoKSBjcmVhdGUgZGQgaW4gbXVsdGlwYXRoX21lc3NhZ2UoKSwKPiBhbmQgdGhlbiBjYWxs
IHRhYmxlX2RlcHMoKSBhZnRlciBkbV9wdXRfdGFibGVfZGV2aWNlKCksCj4gaXQgd2lsbCBsZWFk
IHRvIGNvbmN1cnJlbmN5IFVBRiBidWdzLgo+IAo+IE9uZSBvZiB0aGUgY29uY3VycmVuY3kgVUFG
IGNhbiBiZSBzaG93biBhcyBiZWxvdzoKPiAKPiAgICAgICAgICAgKFVTRSkgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgIChGUkVFKQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgIHRhcmdldF9tZXNzYWdlCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgICBtdWx0aXBhdGhfbWVzc2FnZQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgICBkbV9wdXRfZGV2aWNlCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgZG1fcHV0X3RhYmxlX2RldmljZSAjCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICBrZnJlZSh0ZCkg
ICMgdGFibGVfZGV2aWNlICp0ZAo+IGlvY3RsICMgRE1fVEFCTEVfREVQU19DTUQgICAgICAgICAg
ICAgfCAgICAgICAgIC4uLgo+ICAgIHRhYmxlX2RlcHMgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAgICAgICAuLi4KPiAgICBkbV9nZXRfbGl2ZV9vcl9pbmFjdGl2ZV90YWJsZSAgICAgICB8
ICAgICAgICAgLi4uCj4gICAgICByZXRyaWV2ZV9kZXAgICAgICAgICAgICAgICAgICAgICAgfCAg
ICAgICAgIC4uLgo+ICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeSAgICAgICAgICAgICAgIHwgICAg
ICAgICAuLi4KPiAgICAgICAgZGVwcy0+ZGV2W2NvdW50KytdID0gICAgICAgICAgICB8ICAgICAg
ICAgLi4uCj4gICAgICAgICAgICBodWdlX2VuY29kZV9kZXYgICAgICAgICAgICAgfCAgICAgICAg
IC4uLgo+ICAgICAgICAgICAgKGRkLT5kbV9kZXYtPmJkZXYtPmJkX2RldikgIHwgICAgICAgIGxp
c3RfZGVsKCZkZC0+bGlzdCkKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAgICAgICBrZnJlZShkZCkgIyBkbV9kZXZfaW50ZXJuYWwKPiAKPiBUaGUgcm9vdCBjYXVz
ZSBvZiBVQUYgYnVncyBpcyB0aGF0IGZpbmRfZGV2aWNlKCkgZmFpbGVkIGluCj4gZG1fZ2V0X2Rl
dmljZSgpIGFuZCB3aWxsIGNyZWF0ZSBkZCBhbmQgcmVmY291bnQgc2V0IDEsIGtmcmVlKCkKPiBp
biBkbV9wdXRfdGFibGUoKSBpcyBub3QgcHJvdGVjdGVkLiBXaGVuIHRkLCB3aGljaCB0aGVyZSBh
cmUKPiBzdGlsbCBwb2ludGVycyBwb2ludCB0bywgaXMgcmVsZWFzZWQsIHRoZSBjb25jdXJyZW5j
eSBVQUYgYnVnCj4gd2lsbCBoYXBwZW4uCj4gCj4gVGhpcyBwYXRjaCBhZGQgYSBmbGFnIHRvIGRl
dGVybWluZSB3aGV0aGVyIHRvIGNyZWF0ZSBhIG5ldyBkZC4KPiAKPiBGaXhlczogODIxNWQ2ZWM1
ZmVlKGRtIHRhYmxlOiByZW1vdmUgdW51c2VkIGRtX2dldF9kZXZpY2UgcmFuZ2UgcGFyYW1ldGVy
cykKPiBTaWduZWQtb2ZmLWJ5OiBMdW8gTWVuZyA8bHVvbWVuZzEyQGh1YXdlaS5jb20+Cj4gLS0t
Cj4gICBkcml2ZXJzL21kL2RtLW1wYXRoLmMgICAgICAgICB8ICAyICstCj4gICBkcml2ZXJzL21k
L2RtLXRhYmxlLmMgICAgICAgICB8IDQzICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tCj4gICBpbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaCB8ICAyICsrCj4gICAzIGZpbGVz
IGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL21kL2RtLW1wYXRoLmMgYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKPiBpbmRl
eCA2ZWQ5ZDI3MzEyNTQuLmFkNjNkNzI5ZmY4MSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2Rt
LW1wYXRoLmMKPiArKysgYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKPiBAQCAtMTk5NSw3ICsxOTk1
LDcgQEAgc3RhdGljIGludCBtdWx0aXBhdGhfbWVzc2FnZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwg
dW5zaWduZWQgYXJnYywgY2hhciAqKmFyZ3YsCj4gICAJCWdvdG8gb3V0Owo+ICAgCX0KPiAgIAo+
IC0JciA9IGRtX2dldF9kZXZpY2UodGksIGFyZ3ZbMV0sIGRtX3RhYmxlX2dldF9tb2RlKHRpLT50
YWJsZSksICZkZXYpOwo+ICsJciA9IF9fZG1fZ2V0X2RldmljZSh0aSwgYXJndlsxXSwgZG1fdGFi
bGVfZ2V0X21vZGUodGktPnRhYmxlKSwgJmRldiwgZmFsc2UpOwo+ICAgCWlmIChyKSB7Cj4gICAJ
CURNV0FSTigibWVzc2FnZTogZXJyb3IgZ2V0dGluZyBkZXZpY2UgJXMiLAo+ICAgCQkgICAgICAg
YXJndlsxXSk7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tdGFibGUuYyBiL2RyaXZlcnMv
bWQvZG0tdGFibGUuYwo+IGluZGV4IDAzNTQxY2ZjMjMxNy4uOWRiYzBiYTM3YWU2IDEwMDY0NAo+
IC0tLSBhL2RyaXZlcnMvbWQvZG0tdGFibGUuYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0tdGFibGUu
Ywo+IEBAIC0zMzksMTIgKzMzOSw4IEBAIGRldl90IGRtX2dldF9kZXZfdChjb25zdCBjaGFyICpw
YXRoKQo+ICAgfQo+ICAgRVhQT1JUX1NZTUJPTF9HUEwoZG1fZ2V0X2Rldl90KTsKPiAgIAo+IC0v
Kgo+IC0gKiBBZGQgYSBkZXZpY2UgdG8gdGhlIGxpc3QsIG9yIGp1c3QgaW5jcmVtZW50IHRoZSB1
c2FnZSBjb3VudCBpZgo+IC0gKiBpdCdzIGFscmVhZHkgcHJlc2VudC4KPiAtICovCj4gLWludCBk
bV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9k
ZV90IG1vZGUsCj4gLQkJICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0KQo+ICtpbnQgX19kbV9nZXRf
ZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1v
ZGUsCj4gKwkJICAgIHN0cnVjdCBkbV9kZXYgKipyZXN1bHQsIGJvb2wgY3JlYXRlX2RkKQo+ICAg
ewo+ICAgCWludCByOwo+ICAgCWRldl90IGRldjsKPiBAQCAtMzY4LDE5ICszNjQsMjEgQEAgaW50
IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZt
b2RlX3QgbW9kZSwKPiAgIAo+ICAgCWRkID0gZmluZF9kZXZpY2UoJnQtPmRldmljZXMsIGRldik7
Cj4gICAJaWYgKCFkZCkgewo+IC0JCWRkID0ga21hbGxvYyhzaXplb2YoKmRkKSwgR0ZQX0tFUk5F
TCk7Cj4gLQkJaWYgKCFkZCkKPiAtCQkJcmV0dXJuIC1FTk9NRU07Cj4gLQo+IC0JCWlmICgociA9
IGRtX2dldF90YWJsZV9kZXZpY2UodC0+bWQsIGRldiwgbW9kZSwgJmRkLT5kbV9kZXYpKSkgewo+
IC0JCQlrZnJlZShkZCk7Cj4gLQkJCXJldHVybiByOwo+IC0JCX0KPiArCQlpZiAoY3JlYXRlX2Rk
KSB7Cj4gKwkJCWRkID0ga21hbGxvYyhzaXplb2YoKmRkKSwgR0ZQX0tFUk5FTCk7Cj4gKwkJCWlm
ICghZGQpCj4gKwkJCQlyZXR1cm4gLUVOT01FTTsKPiAgIAo+IC0JCXJlZmNvdW50X3NldCgmZGQt
PmNvdW50LCAxKTsKPiAtCQlsaXN0X2FkZCgmZGQtPmxpc3QsICZ0LT5kZXZpY2VzKTsKPiAtCQln
b3RvIG91dDsKPiArCQkJaWYgKChyID0gZG1fZ2V0X3RhYmxlX2RldmljZSh0LT5tZCwgZGV2LCBt
b2RlLCAmZGQtPmRtX2RldikpKSB7Cj4gKwkJCQlrZnJlZShkZCk7Cj4gKwkJCQlyZXR1cm4gcjsK
PiArCQkJfQo+ICAgCj4gKwkJCXJlZmNvdW50X3NldCgmZGQtPmNvdW50LCAxKTsKPiArCQkJbGlz
dF9hZGQoJmRkLT5saXN0LCAmdC0+ZGV2aWNlcyk7Cj4gKwkJCWdvdG8gb3V0Owo+ICsJCX0gZWxz
ZQo+ICsJCQlyZXR1cm4gLUVOT0RFVjsKPiAgIAl9IGVsc2UgaWYgKGRkLT5kbV9kZXYtPm1vZGUg
IT0gKG1vZGUgfCBkZC0+ZG1fZGV2LT5tb2RlKSkgewo+ICAgCQlyID0gdXBncmFkZV9tb2RlKGRk
LCBtb2RlLCB0LT5tZCk7Cj4gICAJCWlmIChyKQo+IEBAIC0zOTEsNiArMzg5LDE3IEBAIGludCBk
bV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9k
ZV90IG1vZGUsCj4gICAJKnJlc3VsdCA9IGRkLT5kbV9kZXY7Cj4gICAJcmV0dXJuIDA7Cj4gICB9
Cj4gK0VYUE9SVF9TWU1CT0woX19kbV9nZXRfZGV2aWNlKTsKPiArCj4gKy8qCj4gKyAqIEFkZCBh
IGRldmljZSB0byB0aGUgbGlzdCwgb3IganVzdCBpbmNyZW1lbnQgdGhlIHVzYWdlIGNvdW50IGlm
Cj4gKyAqIGl0J3MgYWxyZWFkeSBwcmVzZW50Lgo+ICsgKi8KPiAraW50IGRtX2dldF9kZXZpY2Uo
c3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiAr
CQkgIHN0cnVjdCBkbV9kZXYgKipyZXN1bHQpCj4gK3sKPiArCXJldHVybiBfX2RtX2dldF9kZXZp
Y2UodGksIHBhdGgsIG1vZGUsIHJlc3VsdCwgdHJ1ZSk7Cj4gK30KPiAgIEVYUE9SVF9TWU1CT0wo
ZG1fZ2V0X2RldmljZSk7Cj4gICAKPiAgIHN0YXRpYyBpbnQgZG1fc2V0X2RldmljZV9saW1pdHMo
c3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBkbV9kZXYgKmRldiwKPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggYi9pbmNsdWRlL2xpbnV4L2RldmljZS1tYXBw
ZXIuaAo+IGluZGV4IGMyYTM3NThjNGFhYS4uNmVhNTQyZTE4MDQ4IDEwMDY0NAo+IC0tLSBhL2lu
Y2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oCj4gKysrIGIvaW5jbHVkZS9saW51eC9kZXZpY2Ut
bWFwcGVyLmgKPiBAQCAtMTY4LDYgKzE2OCw4IEBAIGRldl90IGRtX2dldF9kZXZfdChjb25zdCBj
aGFyICpwYXRoKTsKPiAgIGludCBkbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBj
b25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1vZGUsCj4gICAJCSAgc3RydWN0IGRtX2RldiAqKnJl
c3VsdCk7Cj4gICB2b2lkIGRtX3B1dF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVj
dCBkbV9kZXYgKmQpOwo+ICtpbnQgX19kbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRp
LCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1vZGUsCj4gKwkJICAgIHN0cnVjdCBkbV9kZXYg
KipyZXN1bHQsIGJvb2wgY3JlYXRlX2RkKTsKPiAgIAo+ICAgLyoKPiAgICAqIEluZm9ybWF0aW9u
IGFib3V0IGEgdGFyZ2V0IHR5cGUKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

