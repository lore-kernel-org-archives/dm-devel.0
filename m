Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529EEEB8FA4
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693966603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q7vxqQX4WpawacoR162+XKBwjKHZL+bQVB/wTTQW6Ao=;
	b=KqAcxlqEeTo+7IVhXOk4PxoeqduCj1I3vh8mOpu/fdQrQ4rehrMtCdRI0mtzcvrPXzS6Oo
	wruaLoiyqZurlCbA7aAIOIP6dKL17/HM7wHUlCwnXpOy/Cmle3hRAcNttP+7ko2YhYxVXJ
	Zlmq/N6RCPSwu4JTFfwDn9yYAopQPbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-3I7oSs4bNbi7jH1EaR0FPw-1; Tue, 05 Sep 2023 22:16:39 -0400
X-MC-Unique: 3I7oSs4bNbi7jH1EaR0FPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D963E18DA722;
	Wed,  6 Sep 2023 02:16:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E393B2026D4B;
	Wed,  6 Sep 2023 02:16:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96B41194658C;
	Wed,  6 Sep 2023 02:16:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 388F71946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 02:16:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16E1C140E965; Wed,  6 Sep 2023 02:16:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F9E4140E966
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 02:16:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E56E9803C96
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 02:16:33 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-X9pLgxvBMdqV2l_8Nuamzg-1; Tue, 05 Sep 2023 22:16:31 -0400
X-MC-Unique: X9pLgxvBMdqV2l_8Nuamzg-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RgQrF57SFzNnBq;
 Wed,  6 Sep 2023 10:12:45 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 6 Sep 2023 10:16:25 +0800
Message-ID: <31a54071-e583-34bb-dc50-a774ae40688a@huawei.com>
Date: Wed, 6 Sep 2023 10:16:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
 <Y02zebNyn73/MN1d@redhat.com>
 <eb9e1d80-c62c-c62f-4fc2-5be21fc75472@huawei.com>
 <ZMqFVGX/ZbVABDJ6@redhat.com>
 <a508359-734b-35c9-a393-42c27870a1fa@redhat.com>
 <a8a3f458-d7d1-e5b6-d672-45c8a8c072ad@redhat.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <a8a3f458-d7d1-e5b6-d672-45c8a8c072ad@redhat.com>
X-Originating-IP: [10.174.179.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
 multipath_message()
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
Cc: ejt@redhat.com, Luo Meng <luomeng@huaweicloud.com>, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkKClRoYW5rcyB0byBNaWt1bGFzIGZvciB0aGUgcGF0Y2guIEkgaGF2ZSB0ZXN0IHRoZSBwYXRj
aCBhbmQgaXQgY2FuIGZpeCAKdGhlIHByb2JsZW0uCkNhbiB0aGlzIHBhdGNoIGJlIGFwcGxpZWQg
dG8gbWFpbmxpbmU/CgpUaGFua3MuCgrlnKggMjAyMy84LzkgMTg6NDQsIE1pa3VsYXMgUGF0b2Nr
YSDlhpnpgZM6Cj4KPiBPbiBUdWUsIDggQXVnIDIwMjMsIE1pa3VsYXMgUGF0b2NrYSB3cm90ZToK
Pgo+PiBPbiBXZWQsIDIgQXVnIDIwMjMsIE1pa2UgU25pdHplciB3cm90ZToKPj4KPj4+IFtDYydp
bmcgTWlrdWxhcyBzbyBoZSBjYW4gdGFrZSBhIGxvb2sgYXQgdGhpcyB0b28uXQo+PiBIaQo+Pgo+
PiBJIHN1Z2dlc3QgdGhpcyBwYXRjaCAoYnV0IGl0J3Mgb25seSBjb21waWxlLXRlc3RlZCwgc28g
cGxlYXNlIHJ1biBzb21lCj4+IHRlc3RzdWl0ZSBvbiBpdCkuCj4+Cj4+IE1pa3VsYXMKPiBJIHNl
bGYtbmFjayB0aGF0IHBhdGNoIC0gaXQgZG9lc24ndCB3b3JrIGlmIHRoZXJlIGFyZSBtdWx0aXBs
ZSB0YXJnZXRzCj4gY2FsbGluZyBkbV90YWJsZV9zZXRfZGV2aWNlc19tdXRleCBpbiB0aGUgc2Ft
ZSB0YWJsZS4gVGhpcyBpcyBub3QgYW4gaXNzdWUKPiBmb3IgbXVsdGlwYXRoLCBidXQgaXQgd2ls
bCBiZSBhIHByb2JsZW0gaWYgb3RoZXIgdGFyZ2V0cyB1c2UgdGhpcwo+IGZ1bmN0aW9uYWxpdHku
Cj4KPiBIZXJlIEknbSBzZW5kaW5nIGEgYmV0dGVyIHBhdGNoIHRoYXQgZG9lc24ndCBuZWVkIGFu
eSBtb2RpZmljYXRpb24gdG8gdGhlCj4gdGFyZ2V0cyBhdCBhbGwuCj4KPiBNaWt1bGFzCj4KPgo+
Cj4gRnJvbTogTWlrdWxhcyBQYXRvY2thIDxtcGF0b2NrYSBhdCByZWRoYXQuY29tPgo+IFN1Ympl
Y3Q6IFtQQVRDSF0gZG06IGZpeCBhIHJhY2UgY29uZGl0aW9uIGluIHJldHJpZXZlX2RlcHMKPgo+
IFRoZXJlJ3MgYSByYWNlIGNvbmRpdGlvbiBpbiB0aGUgbXVsdGlwYXRoIHRhcmdldCB3aGVuIHJl
dHJpZXZlX2RlcHMgcmFjZXMKPiB3aXRoIG11bHRpcGF0aF9tZXNzYWdlIGNhbGxpbmcgZG1fZ2V0
X2RldmljZSBhbmQgZG1fcHV0X2RldmljZS4KPiByZXRyaWV2ZV9kZXBzIHdhbGtzIHRoZSBsaXN0
IG9mIG9wZW4gZGV2aWNlcyB3aXRob3V0IGhvbGRpbmcgYW55IGxvY2sgYnV0Cj4gbXVsdGlwYXRo
IG1heSBhZGQgb3IgcmVtb3ZlIGRldmljZXMgdG8gdGhlIGxpc3Qgd2hpbGUgaXQgaXMgcnVubmlu
Zy4gVGhlCj4gZW5kIHJlc3VsdCBtYXkgYmUgbWVtb3J5IGNvcnJ1cHRpb24gb3IgdXNlLWFmdGVy
LWZyZWUgbWVtb3J5IGFjY2Vzcy4KPgo+IEZpeCB0aGlzIGJ1ZyBieSBpbnRyb2R1Y2luZyBhIG5l
dyBydyBzZW1hcGhvcmUgImRldmljZXNfbG9jayIuIFdlIGdyYWIKPiBkZXZpY2VzX2xvY2sgZm9y
IHJlYWQgaW4gcmV0cmlldmVfZGVwcyBhbmQgd2UgZ3JhYiBpdCBmb3Igd3JpdGUgaW4KPiBkbV9n
ZXRfZGV2aWNlIGFuZCBkbV9wdXRfZGV2aWNlLgo+Cj4gU2lnbmVkLW9mZi1ieTogTWlrdWxhcyBQ
YXRvY2thIDxtcGF0b2NrYUByZWRoYXQuY29tPgo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
Cj4KPiAtLS0KPiAgIGRyaXZlcnMvbWQvZG0tY29yZS5oICB8ICAgIDEgKwo+ICAgZHJpdmVycy9t
ZC9kbS1pb2N0bC5jIHwgICAgNyArKysrKystCj4gICBkcml2ZXJzL21kL2RtLXRhYmxlLmMgfCAg
IDMyICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCj4gICAzIGZpbGVzIGNoYW5nZWQs
IDMxIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCj4KPiBJbmRleDogbGludXgtMi42L2Ry
aXZlcnMvbWQvZG0tY29yZS5oCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+IC0tLSBsaW51eC0yLjYub3JpZy9kcml2
ZXJzL21kL2RtLWNvcmUuaAo+ICsrKyBsaW51eC0yLjYvZHJpdmVycy9tZC9kbS1jb3JlLmgKPiBA
QCAtMjE0LDYgKzIxNCw3IEBAIHN0cnVjdCBkbV90YWJsZSB7Cj4gICAKPiAgIAkvKiBhIGxpc3Qg
b2YgZGV2aWNlcyB1c2VkIGJ5IHRoaXMgdGFibGUgKi8KPiAgIAlzdHJ1Y3QgbGlzdF9oZWFkIGRl
dmljZXM7Cj4gKwlzdHJ1Y3Qgcndfc2VtYXBob3JlIGRldmljZXNfbG9jazsKPiAgIAo+ICAgCS8q
IGV2ZW50cyBnZXQgaGFuZGVkIHVwIHVzaW5nIHRoaXMgY2FsbGJhY2sgKi8KPiAgIAl2b2lkICgq
ZXZlbnRfZm4pKHZvaWQgKmRhdGEpOwo+IEluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9tZC9kbS1p
b2N0bC5jCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQo+IC0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL21kL2RtLWlv
Y3RsLmMKPiArKysgbGludXgtMi42L2RyaXZlcnMvbWQvZG0taW9jdGwuYwo+IEBAIC0xNjMwLDYg
KzE2MzAsOCBAQCBzdGF0aWMgdm9pZCByZXRyaWV2ZV9kZXBzKHN0cnVjdCBkbV90YWJsCj4gICAJ
c3RydWN0IGRtX2Rldl9pbnRlcm5hbCAqZGQ7Cj4gICAJc3RydWN0IGRtX3RhcmdldF9kZXBzICpk
ZXBzOwo+ICAgCj4gKwlkb3duX3JlYWQoJnRhYmxlLT5kZXZpY2VzX2xvY2spOwo+ICsKPiAgIAlk
ZXBzID0gZ2V0X3Jlc3VsdF9idWZmZXIocGFyYW0sIHBhcmFtX3NpemUsICZsZW4pOwo+ICAgCj4g
ICAJLyoKPiBAQCAtMTY0NCw3ICsxNjQ2LDcgQEAgc3RhdGljIHZvaWQgcmV0cmlldmVfZGVwcyhz
dHJ1Y3QgZG1fdGFibAo+ICAgCW5lZWRlZCA9IHN0cnVjdF9zaXplKGRlcHMsIGRldiwgY291bnQp
Owo+ICAgCWlmIChsZW4gPCBuZWVkZWQpIHsKPiAgIAkJcGFyYW0tPmZsYWdzIHw9IERNX0JVRkZF
Ul9GVUxMX0ZMQUc7Cj4gLQkJcmV0dXJuOwo+ICsJCWdvdG8gb3V0Owo+ICAgCX0KPiAgIAo+ICAg
CS8qCj4gQEAgLTE2NTYsNiArMTY1OCw5IEBAIHN0YXRpYyB2b2lkIHJldHJpZXZlX2RlcHMoc3Ry
dWN0IGRtX3RhYmwKPiAgIAkJZGVwcy0+ZGV2W2NvdW50KytdID0gaHVnZV9lbmNvZGVfZGV2KGRk
LT5kbV9kZXYtPmJkZXYtPmJkX2Rldik7Cj4gICAKPiAgIAlwYXJhbS0+ZGF0YV9zaXplID0gcGFy
YW0tPmRhdGFfc3RhcnQgKyBuZWVkZWQ7Cj4gKwo+ICtvdXQ6Cj4gKwl1cF9yZWFkKCZ0YWJsZS0+
ZGV2aWNlc19sb2NrKTsKPiAgIH0KPiAgIAo+ICAgc3RhdGljIGludCB0YWJsZV9kZXBzKHN0cnVj
dCBmaWxlICpmaWxwLCBzdHJ1Y3QgZG1faW9jdGwgKnBhcmFtLCBzaXplX3QgcGFyYW1fc2l6ZSkK
PiBJbmRleDogbGludXgtMi42L2RyaXZlcnMvbWQvZG0tdGFibGUuYwo+ID09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPiAt
LS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9tZC9kbS10YWJsZS5jCj4gKysrIGxpbnV4LTIuNi9k
cml2ZXJzL21kL2RtLXRhYmxlLmMKPiBAQCAtMTM1LDYgKzEzNSw3IEBAIGludCBkbV90YWJsZV9j
cmVhdGUoc3RydWN0IGRtX3RhYmxlICoqcmUKPiAgIAkJcmV0dXJuIC1FTk9NRU07Cj4gICAKPiAg
IAlJTklUX0xJU1RfSEVBRCgmdC0+ZGV2aWNlcyk7Cj4gKwlpbml0X3J3c2VtKCZ0LT5kZXZpY2Vz
X2xvY2spOwo+ICAgCj4gICAJaWYgKCFudW1fdGFyZ2V0cykKPiAgIAkJbnVtX3RhcmdldHMgPSBL
RVlTX1BFUl9OT0RFOwo+IEBAIC0zNTksMTYgKzM2MCwyMCBAQCBpbnQgX19yZWYgZG1fZ2V0X2Rl
dmljZShzdHJ1Y3QgZG1fdGFyZ2V0Cj4gICAJaWYgKGRldiA9PSBkaXNrX2RldnQodC0+bWQtPmRp
c2spKQo+ICAgCQlyZXR1cm4gLUVJTlZBTDsKPiAgIAo+ICsJZG93bl93cml0ZSgmdC0+ZGV2aWNl
c19sb2NrKTsKPiArCj4gICAJZGQgPSBmaW5kX2RldmljZSgmdC0+ZGV2aWNlcywgZGV2KTsKPiAg
IAlpZiAoIWRkKSB7Cj4gICAJCWRkID0ga21hbGxvYyhzaXplb2YoKmRkKSwgR0ZQX0tFUk5FTCk7
Cj4gLQkJaWYgKCFkZCkKPiAtCQkJcmV0dXJuIC1FTk9NRU07Cj4gKwkJaWYgKCFkZCkgewo+ICsJ
CQlyID0gLUVOT01FTTsKPiArCQkJZ290byB1bmxvY2tfcmV0X3I7Cj4gKwkJfQo+ICAgCj4gICAJ
CXIgPSBkbV9nZXRfdGFibGVfZGV2aWNlKHQtPm1kLCBkZXYsIG1vZGUsICZkZC0+ZG1fZGV2KTsK
PiAgIAkJaWYgKHIpIHsKPiAgIAkJCWtmcmVlKGRkKTsKPiAtCQkJcmV0dXJuIHI7Cj4gKwkJCWdv
dG8gdW5sb2NrX3JldF9yOwo+ICAgCQl9Cj4gICAKPiAgIAkJcmVmY291bnRfc2V0KCZkZC0+Y291
bnQsIDEpOwo+IEBAIC0zNzgsMTIgKzM4MywxNyBAQCBpbnQgX19yZWYgZG1fZ2V0X2RldmljZShz
dHJ1Y3QgZG1fdGFyZ2V0Cj4gICAJfSBlbHNlIGlmIChkZC0+ZG1fZGV2LT5tb2RlICE9IChtb2Rl
IHwgZGQtPmRtX2Rldi0+bW9kZSkpIHsKPiAgIAkJciA9IHVwZ3JhZGVfbW9kZShkZCwgbW9kZSwg
dC0+bWQpOwo+ICAgCQlpZiAocikKPiAtCQkJcmV0dXJuIHI7Cj4gKwkJCWdvdG8gdW5sb2NrX3Jl
dF9yOwo+ICAgCX0KPiAgIAlyZWZjb3VudF9pbmMoJmRkLT5jb3VudCk7Cj4gICBvdXQ6Cj4gKwl1
cF93cml0ZSgmdC0+ZGV2aWNlc19sb2NrKTsKPiAgIAkqcmVzdWx0ID0gZGQtPmRtX2RldjsKPiAg
IAlyZXR1cm4gMDsKPiArCj4gK3VubG9ja19yZXRfcjoKPiArCXVwX3dyaXRlKCZ0LT5kZXZpY2Vz
X2xvY2spOwo+ICsJcmV0dXJuIHI7Cj4gICB9Cj4gICBFWFBPUlRfU1lNQk9MKGRtX2dldF9kZXZp
Y2UpOwo+ICAgCj4gQEAgLTQxOSw5ICs0MjksMTIgQEAgc3RhdGljIGludCBkbV9zZXRfZGV2aWNl
X2xpbWl0cyhzdHJ1Y3QgZAo+ICAgdm9pZCBkbV9wdXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQg
KnRpLCBzdHJ1Y3QgZG1fZGV2ICpkKQo+ICAgewo+ICAgCWludCBmb3VuZCA9IDA7Cj4gLQlzdHJ1
Y3QgbGlzdF9oZWFkICpkZXZpY2VzID0gJnRpLT50YWJsZS0+ZGV2aWNlczsKPiArCXN0cnVjdCBk
bV90YWJsZSAqdCA9IHRpLT50YWJsZTsKPiArCXN0cnVjdCBsaXN0X2hlYWQgKmRldmljZXMgPSAm
dC0+ZGV2aWNlczsKPiAgIAlzdHJ1Y3QgZG1fZGV2X2ludGVybmFsICpkZDsKPiAgIAo+ICsJZG93
bl93cml0ZSgmdC0+ZGV2aWNlc19sb2NrKTsKPiArCj4gICAJbGlzdF9mb3JfZWFjaF9lbnRyeShk
ZCwgZGV2aWNlcywgbGlzdCkgewo+ICAgCQlpZiAoZGQtPmRtX2RldiA9PSBkKSB7Cj4gICAJCQlm
b3VuZCA9IDE7Cj4gQEAgLTQzMCwxNCArNDQzLDE3IEBAIHZvaWQgZG1fcHV0X2RldmljZShzdHJ1
Y3QgZG1fdGFyZ2V0ICp0aSwKPiAgIAl9Cj4gICAJaWYgKCFmb3VuZCkgewo+ICAgCQlETUVSUigi
JXM6IGRldmljZSAlcyBub3QgaW4gdGFibGUgZGV2aWNlcyBsaXN0IiwKPiAtCQkgICAgICBkbV9k
ZXZpY2VfbmFtZSh0aS0+dGFibGUtPm1kKSwgZC0+bmFtZSk7Cj4gLQkJcmV0dXJuOwo+ICsJCSAg
ICAgIGRtX2RldmljZV9uYW1lKHQtPm1kKSwgZC0+bmFtZSk7Cj4gKwkJZ290byB1bmxvY2tfcmV0
Owo+ICAgCX0KPiAgIAlpZiAocmVmY291bnRfZGVjX2FuZF90ZXN0KCZkZC0+Y291bnQpKSB7Cj4g
LQkJZG1fcHV0X3RhYmxlX2RldmljZSh0aS0+dGFibGUtPm1kLCBkKTsKPiArCQlkbV9wdXRfdGFi
bGVfZGV2aWNlKHQtPm1kLCBkKTsKPiAgIAkJbGlzdF9kZWwoJmRkLT5saXN0KTsKPiAgIAkJa2Zy
ZWUoZGQpOwo+ICAgCX0KPiArCj4gK3VubG9ja19yZXQ6Cj4gKwl1cF93cml0ZSgmdC0+ZGV2aWNl
c19sb2NrKTsKPiAgIH0KPiAgIEVYUE9SVF9TWU1CT0woZG1fcHV0X2RldmljZSk7Cj4gICAKPgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

