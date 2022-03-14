Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37DDC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Mar 2022 07:03:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-N0JQKQ4MPPiRn0bArRlHTg-1; Mon, 14 Mar 2022 03:03:17 -0400
X-MC-Unique: N0JQKQ4MPPiRn0bArRlHTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AD3F899EC5;
	Mon, 14 Mar 2022 07:03:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7942115230AC;
	Mon, 14 Mar 2022 07:02:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 066F6194E018;
	Mon, 14 Mar 2022 07:02:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9593C194037A
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Mar 2022 07:02:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6765240149AF; Mon, 14 Mar 2022 07:02:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 634F9403D188
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 07:02:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BADD800B24
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 07:02:31 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-LsnAUknsPnikVfVUIHD5rg-1; Mon, 14 Mar 2022 03:02:27 -0400
X-MC-Unique: LsnAUknsPnikVfVUIHD5rg-1
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KH6mP6W2rzcb5w;
 Mon, 14 Mar 2022 14:57:25 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 15:02:21 +0800
Received: from [10.174.176.127] (10.174.176.127) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 15:02:20 +0800
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>
References: <20220309094148.2164043-1-luomeng12@huawei.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <9756e8b2-ee9b-20b3-bc97-818f3a81bd60@huawei.com>
Date: Mon, 14 Mar 2022 15:02:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20220309094148.2164043-1-luomeng12@huawei.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

ZnJpZW5kbHkgcGluZy4KCtTaIDIwMjIvMy85IDE3OjQxLCBMdW8gTWVuZyDQtLXAOgo+IElmIGRt
X2dldF9kZXZpY2UoKSBjcmVhdGUgZGQgaW4gbXVsdGlwYXRoX21lc3NhZ2UoKSwKPiBhbmQgdGhl
biBjYWxsIHRhYmxlX2RlcHMoKSBhZnRlciBkbV9wdXRfdGFibGVfZGV2aWNlKCksCj4gaXQgd2ls
bCBsZWFkIHRvIGNvbmN1cnJlbmN5IFVBRiBidWdzLgo+IAo+IE9uZSBvZiB0aGUgY29uY3VycmVu
Y3kgVUFGIGNhbiBiZSBzaG93biBhcyBiZWxvdzoKPiAKPiAgICAgICAgICAgKFVTRSkgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgIChGUkVFKQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwgIHRhcmdldF9tZXNzYWdlCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICBtdWx0aXBhdGhfbWVzc2FnZQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICBkbV9wdXRfZGV2aWNlCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgZG1fcHV0X3RhYmxlX2RldmljZSAj
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICBrZnJl
ZSh0ZCkgICMgdGFibGVfZGV2aWNlICp0ZAo+IGlvY3RsICMgRE1fVEFCTEVfREVQU19DTUQgICAg
ICAgICAgICAgfCAgICAgICAgIC4uLgo+ICAgIHRhYmxlX2RlcHMgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgICAgICAuLi4KPiAgICBkbV9nZXRfbGl2ZV9vcl9pbmFjdGl2ZV90YWJsZSAg
ICAgICB8ICAgICAgICAgLi4uCj4gICAgICByZXRyaWV2ZV9kZXAgICAgICAgICAgICAgICAgICAg
ICAgfCAgICAgICAgIC4uLgo+ICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeSAgICAgICAgICAgICAg
IHwgICAgICAgICAuLi4KPiAgICAgICAgZGVwcy0+ZGV2W2NvdW50KytdID0gICAgICAgICAgICB8
ICAgICAgICAgLi4uCj4gICAgICAgICAgICBodWdlX2VuY29kZV9kZXYgICAgICAgICAgICAgfCAg
ICAgICAgIC4uLgo+ICAgICAgICAgICAgKGRkLT5kbV9kZXYtPmJkZXYtPmJkX2RldikgIHwgICAg
ICAgIGxpc3RfZGVsKCZkZC0+bGlzdCkKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgICAgICBrZnJlZShkZCkgIyBkbV9kZXZfaW50ZXJuYWwKPiAKPiBUaGUgcm9v
dCBjYXVzZSBvZiBVQUYgYnVncyBpcyB0aGF0IGZpbmRfZGV2aWNlKCkgZmFpbGVkIGluCj4gZG1f
Z2V0X2RldmljZSgpIGFuZCB3aWxsIGNyZWF0ZSBkZCBhbmQgcmVmY291bnQgc2V0IDEsIGtmcmVl
KCkKPiBpbiBkbV9wdXRfdGFibGUoKSBpcyBub3QgcHJvdGVjdGVkLiBXaGVuIHRkLCB3aGljaCB0
aGVyZSBhcmUKPiBzdGlsbCBwb2ludGVycyBwb2ludCB0bywgaXMgcmVsZWFzZWQsIHRoZSBjb25j
dXJyZW5jeSBVQUYgYnVnCj4gd2lsbCBoYXBwZW4uCj4gCj4gVGhpcyBwYXRjaCBhZGQgYSBmbGFn
IHRvIGRldGVybWluZSB3aGV0aGVyIHRvIGNyZWF0ZSBhIG5ldyBkZC4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBMdW8gTWVuZyA8bHVvbWVuZzEyQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21k
L2RtLW1wYXRoLmMgICAgICAgICB8ICAyICstCj4gICBkcml2ZXJzL21kL2RtLXRhYmxlLmMgICAg
ICAgICB8IDQzICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tCj4gICBpbmNsdWRl
L2xpbnV4L2RldmljZS1tYXBwZXIuaCB8ICAyICsrCj4gICAzIGZpbGVzIGNoYW5nZWQsIDI5IGlu
c2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLW1wYXRoLmMgYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKPiBpbmRleCBmNDcxOWI2NWU1ZTMu
LjFmOGIyOWVkNzk3OSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2RtLW1wYXRoLmMKPiArKysg
Yi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKPiBAQCAtMTk5OSw3ICsxOTk5LDcgQEAgc3RhdGljIGlu
dCBtdWx0aXBhdGhfbWVzc2FnZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgYXJnYywg
Y2hhciAqKmFyZ3YsCj4gICAJCWdvdG8gb3V0Owo+ICAgCX0KPiAgIAo+IC0JciA9IGRtX2dldF9k
ZXZpY2UodGksIGFyZ3ZbMV0sIGRtX3RhYmxlX2dldF9tb2RlKHRpLT50YWJsZSksICZkZXYpOwo+
ICsJciA9IF9fZG1fZ2V0X2RldmljZSh0aSwgYXJndlsxXSwgZG1fdGFibGVfZ2V0X21vZGUodGkt
PnRhYmxlKSwgJmRldiwgZmFsc2UpOwo+ICAgCWlmIChyKSB7Cj4gICAJCURNV0FSTigibWVzc2Fn
ZTogZXJyb3IgZ2V0dGluZyBkZXZpY2UgJXMiLAo+ICAgCQkgICAgICAgYXJndlsxXSk7Cj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tdGFibGUuYyBiL2RyaXZlcnMvbWQvZG0tdGFibGUuYwo+
IGluZGV4IGU0MzA5NmNmZTllMi4uYjhmYzdlMGFmYjg0IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMv
bWQvZG0tdGFibGUuYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0tdGFibGUuYwo+IEBAIC0zNDAsMTIg
KzM0MCw4IEBAIGRldl90IGRtX2dldF9kZXZfdChjb25zdCBjaGFyICpwYXRoKQo+ICAgfQo+ICAg
RVhQT1JUX1NZTUJPTF9HUEwoZG1fZ2V0X2Rldl90KTsKPiAgIAo+IC0vKgo+IC0gKiBBZGQgYSBk
ZXZpY2UgdG8gdGhlIGxpc3QsIG9yIGp1c3QgaW5jcmVtZW50IHRoZSB1c2FnZSBjb3VudCBpZgo+
IC0gKiBpdCdzIGFscmVhZHkgcHJlc2VudC4KPiAtICovCj4gLWludCBkbV9nZXRfZGV2aWNlKHN0
cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1vZGUsCj4gLQkJ
ICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0KQo+ICtpbnQgX19kbV9nZXRfZGV2aWNlKHN0cnVjdCBk
bV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1vZGUsCj4gKwkJICAgIHN0
cnVjdCBkbV9kZXYgKipyZXN1bHQsIGJvb2wgY3JlYXRlX2RkKQo+ICAgewo+ICAgCWludCByOwo+
ICAgCWRldl90IGRldjsKPiBAQCAtMzY5LDE5ICszNjUsMjEgQEAgaW50IGRtX2dldF9kZXZpY2Uo
c3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiAg
IAo+ICAgCWRkID0gZmluZF9kZXZpY2UoJnQtPmRldmljZXMsIGRldik7Cj4gICAJaWYgKCFkZCkg
ewo+IC0JCWRkID0ga21hbGxvYyhzaXplb2YoKmRkKSwgR0ZQX0tFUk5FTCk7Cj4gLQkJaWYgKCFk
ZCkKPiAtCQkJcmV0dXJuIC1FTk9NRU07Cj4gLQo+IC0JCWlmICgociA9IGRtX2dldF90YWJsZV9k
ZXZpY2UodC0+bWQsIGRldiwgbW9kZSwgJmRkLT5kbV9kZXYpKSkgewo+IC0JCQlrZnJlZShkZCk7
Cj4gLQkJCXJldHVybiByOwo+IC0JCX0KPiArCQlpZiAoY3JlYXRlX2RkKSB7Cj4gKwkJCWRkID0g
a21hbGxvYyhzaXplb2YoKmRkKSwgR0ZQX0tFUk5FTCk7Cj4gKwkJCWlmICghZGQpCj4gKwkJCQly
ZXR1cm4gLUVOT01FTTsKPiAgIAo+IC0JCXJlZmNvdW50X3NldCgmZGQtPmNvdW50LCAxKTsKPiAt
CQlsaXN0X2FkZCgmZGQtPmxpc3QsICZ0LT5kZXZpY2VzKTsKPiAtCQlnb3RvIG91dDsKPiArCQkJ
aWYgKChyID0gZG1fZ2V0X3RhYmxlX2RldmljZSh0LT5tZCwgZGV2LCBtb2RlLCAmZGQtPmRtX2Rl
dikpKSB7Cj4gKwkJCQlrZnJlZShkZCk7Cj4gKwkJCQlyZXR1cm4gcjsKPiArCQkJfQo+ICAgCj4g
KwkJCXJlZmNvdW50X3NldCgmZGQtPmNvdW50LCAxKTsKPiArCQkJbGlzdF9hZGQoJmRkLT5saXN0
LCAmdC0+ZGV2aWNlcyk7Cj4gKwkJCWdvdG8gb3V0Owo+ICsJCX0gZWxzZQo+ICsJCQlyZXR1cm4g
LUVOT0RFVjsKPiAgIAl9IGVsc2UgaWYgKGRkLT5kbV9kZXYtPm1vZGUgIT0gKG1vZGUgfCBkZC0+
ZG1fZGV2LT5tb2RlKSkgewo+ICAgCQlyID0gdXBncmFkZV9tb2RlKGRkLCBtb2RlLCB0LT5tZCk7
Cj4gICAJCWlmIChyKQo+IEBAIC0zOTIsNiArMzkwLDE3IEBAIGludCBkbV9nZXRfZGV2aWNlKHN0
cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1vZGUsCj4gICAJ
KnJlc3VsdCA9IGRkLT5kbV9kZXY7Cj4gICAJcmV0dXJuIDA7Cj4gICB9Cj4gK0VYUE9SVF9TWU1C
T0woX19kbV9nZXRfZGV2aWNlKTsKPiArCj4gKy8qCj4gKyAqIEFkZCBhIGRldmljZSB0byB0aGUg
bGlzdCwgb3IganVzdCBpbmNyZW1lbnQgdGhlIHVzYWdlIGNvdW50IGlmCj4gKyAqIGl0J3MgYWxy
ZWFkeSBwcmVzZW50Lgo+ICsgKi8KPiAraW50IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3Rhcmdl
dCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPiArCQkgIHN0cnVjdCBkbV9k
ZXYgKipyZXN1bHQpCj4gK3sKPiArCXJldHVybiBfX2RtX2dldF9kZXZpY2UodGksIHBhdGgsIG1v
ZGUsIHJlc3VsdCwgdHJ1ZSk7Cj4gK30KPiAgIEVYUE9SVF9TWU1CT0woZG1fZ2V0X2RldmljZSk7
Cj4gICAKPiAgIHN0YXRpYyBpbnQgZG1fc2V0X2RldmljZV9saW1pdHMoc3RydWN0IGRtX3Rhcmdl
dCAqdGksIHN0cnVjdCBkbV9kZXYgKmRldiwKPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9k
ZXZpY2UtbWFwcGVyLmggYi9pbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaAo+IGluZGV4IGIy
NmZlY2Y2YzhlOC4uYTFiNDQ3ODllM2RjIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvZGV2
aWNlLW1hcHBlci5oCj4gKysrIGIvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmgKPiBAQCAt
MTY4LDYgKzE2OCw4IEBAIGRldl90IGRtX2dldF9kZXZfdChjb25zdCBjaGFyICpwYXRoKTsKPiAg
IGludCBkbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRo
LCBmbW9kZV90IG1vZGUsCj4gICAJCSAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCk7Cj4gICB2b2lk
IGRtX3B1dF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBkbV9kZXYgKmQpOwo+
ICtpbnQgX19kbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpw
YXRoLCBmbW9kZV90IG1vZGUsCj4gKwkJICAgIHN0cnVjdCBkbV9kZXYgKipyZXN1bHQsIGJvb2wg
Y3JlYXRlX2RkKTsKPiAgIAo+ICAgLyoKPiAgICAqIEluZm9ybWF0aW9uIGFib3V0IGEgdGFyZ2V0
IHR5cGUKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

