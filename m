Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88FCEB8FAD
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 03:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693972016;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jWnRht4JaznmsQyhh1uE6a9uOSBYw82rUuFmHwS8U5k=;
	b=eSMs/XhiM7gGUX8qh4q91v4jvZS82h/1koqJmHSOsNqx/Ilj5PHib0Fq73k4jlQ49dr3k4
	1kKhNAhK9CgTA0qeKFp9R1YeRqVFqiFTdeHWPVWAG8/+DNw959GvjOzQsxcnFRbHTyK80W
	zjG8hVnVjF6FgY44JTLCiz5lHapRkSk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-Aszm1v_WOmiXwr7J-bnP7w-1; Tue, 05 Sep 2023 23:46:55 -0400
X-MC-Unique: Aszm1v_WOmiXwr7J-bnP7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 760103C025B4;
	Wed,  6 Sep 2023 03:46:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE0B200DA3D;
	Wed,  6 Sep 2023 03:46:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8F0F194658C;
	Wed,  6 Sep 2023 03:46:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED3D41946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 03:46:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA3A5400F5F; Wed,  6 Sep 2023 03:46:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D26D7400F5A
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 03:46:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B452529AA3BA
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 03:46:50 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-9HSZm6OhMAWM5FCNjJSqoQ-1; Tue, 05 Sep 2023 23:46:46 -0400
X-MC-Unique: 9HSZm6OhMAWM5FCNjJSqoQ-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.53])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RgSrp2wCJzMlCJ;
 Wed,  6 Sep 2023 11:43:22 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 6 Sep 2023 11:46:41 +0800
Message-ID: <c1da103b-3d6a-666f-d657-597adbd1d21c@huawei.com>
Date: Wed, 6 Sep 2023 11:46:41 +0800
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzgvOSAxODo0NCwgTWlrdWxhcyBQYXRvY2thIOWGmemBkzoKPgo+IE9uIFR1ZSwg
OCBBdWcgMjAyMywgTWlrdWxhcyBQYXRvY2thIHdyb3RlOgo+Cj4+IE9uIFdlZCwgMiBBdWcgMjAy
MywgTWlrZSBTbml0emVyIHdyb3RlOgo+Pgo+Pj4gW0NjJ2luZyBNaWt1bGFzIHNvIGhlIGNhbiB0
YWtlIGEgbG9vayBhdCB0aGlzIHRvby5dCj4+IEhpCj4+Cj4+IEkgc3VnZ2VzdCB0aGlzIHBhdGNo
IChidXQgaXQncyBvbmx5IGNvbXBpbGUtdGVzdGVkLCBzbyBwbGVhc2UgcnVuIHNvbWUKPj4gdGVz
dHN1aXRlIG9uIGl0KS4KPj4KPj4gTWlrdWxhcwo+IEkgc2VsZi1uYWNrIHRoYXQgcGF0Y2ggLSBp
dCBkb2Vzbid0IHdvcmsgaWYgdGhlcmUgYXJlIG11bHRpcGxlIHRhcmdldHMKPiBjYWxsaW5nIGRt
X3RhYmxlX3NldF9kZXZpY2VzX211dGV4IGluIHRoZSBzYW1lIHRhYmxlLiBUaGlzIGlzIG5vdCBh
biBpc3N1ZQo+IGZvciBtdWx0aXBhdGgsIGJ1dCBpdCB3aWxsIGJlIGEgcHJvYmxlbSBpZiBvdGhl
ciB0YXJnZXRzIHVzZSB0aGlzCj4gZnVuY3Rpb25hbGl0eS4KPgo+IEhlcmUgSSdtIHNlbmRpbmcg
YSBiZXR0ZXIgcGF0Y2ggdGhhdCBkb2Vzbid0IG5lZWQgYW55IG1vZGlmaWNhdGlvbiB0byB0aGUK
PiB0YXJnZXRzIGF0IGFsbC4KPgo+IE1pa3VsYXMKPgo+Cj4KPiBGcm9tOiBNaWt1bGFzIFBhdG9j
a2EgPG1wYXRvY2thIGF0IHJlZGhhdC5jb20+Cj4gU3ViamVjdDogW1BBVENIXSBkbTogZml4IGEg
cmFjZSBjb25kaXRpb24gaW4gcmV0cmlldmVfZGVwcwo+Cj4gVGhlcmUncyBhIHJhY2UgY29uZGl0
aW9uIGluIHRoZSBtdWx0aXBhdGggdGFyZ2V0IHdoZW4gcmV0cmlldmVfZGVwcyByYWNlcwo+IHdp
dGggbXVsdGlwYXRoX21lc3NhZ2UgY2FsbGluZyBkbV9nZXRfZGV2aWNlIGFuZCBkbV9wdXRfZGV2
aWNlLgo+IHJldHJpZXZlX2RlcHMgd2Fsa3MgdGhlIGxpc3Qgb2Ygb3BlbiBkZXZpY2VzIHdpdGhv
dXQgaG9sZGluZyBhbnkgbG9jayBidXQKPiBtdWx0aXBhdGggbWF5IGFkZCBvciByZW1vdmUgZGV2
aWNlcyB0byB0aGUgbGlzdCB3aGlsZSBpdCBpcyBydW5uaW5nLiBUaGUKPiBlbmQgcmVzdWx0IG1h
eSBiZSBtZW1vcnkgY29ycnVwdGlvbiBvciB1c2UtYWZ0ZXItZnJlZSBtZW1vcnkgYWNjZXNzLgo+
Cj4gRml4IHRoaXMgYnVnIGJ5IGludHJvZHVjaW5nIGEgbmV3IHJ3IHNlbWFwaG9yZSAiZGV2aWNl
c19sb2NrIi4gV2UgZ3JhYgo+IGRldmljZXNfbG9jayBmb3IgcmVhZCBpbiByZXRyaWV2ZV9kZXBz
IGFuZCB3ZSBncmFiIGl0IGZvciB3cml0ZSBpbgo+IGRtX2dldF9kZXZpY2UgYW5kIGRtX3B1dF9k
ZXZpY2UuCj4KPiBTaWduZWQtb2ZmLWJ5OiBNaWt1bGFzIFBhdG9ja2EgPG1wYXRvY2thQHJlZGhh
dC5jb20+Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPgo+IC0tLQo+ICAgZHJpdmVycy9t
ZC9kbS1jb3JlLmggIHwgICAgMSArCj4gICBkcml2ZXJzL21kL2RtLWlvY3RsLmMgfCAgICA3ICsr
KysrKy0KPiAgIGRyaXZlcnMvbWQvZG0tdGFibGUuYyB8ICAgMzIgKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgOSBk
ZWxldGlvbnMoLSkKPgo+IEluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9tZC9kbS1jb3JlLmgKPiA9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09Cj4gLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvbWQvZG0tY29yZS5oCj4gKysr
IGxpbnV4LTIuNi9kcml2ZXJzL21kL2RtLWNvcmUuaAo+IEBAIC0yMTQsNiArMjE0LDcgQEAgc3Ry
dWN0IGRtX3RhYmxlIHsKPiAgIAo+ICAgCS8qIGEgbGlzdCBvZiBkZXZpY2VzIHVzZWQgYnkgdGhp
cyB0YWJsZSAqLwo+ICAgCXN0cnVjdCBsaXN0X2hlYWQgZGV2aWNlczsKPiArCXN0cnVjdCByd19z
ZW1hcGhvcmUgZGV2aWNlc19sb2NrOwo+ICAgCj4gICAJLyogZXZlbnRzIGdldCBoYW5kZWQgdXAg
dXNpbmcgdGhpcyBjYWxsYmFjayAqLwo+ICAgCXZvaWQgKCpldmVudF9mbikodm9pZCAqZGF0YSk7
Cj4gSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL21kL2RtLWlvY3RsLmMKPiA9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cj4g
LS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvbWQvZG0taW9jdGwuYwo+ICsrKyBsaW51eC0yLjYv
ZHJpdmVycy9tZC9kbS1pb2N0bC5jCj4gQEAgLTE2MzAsNiArMTYzMCw4IEBAIHN0YXRpYyB2b2lk
IHJldHJpZXZlX2RlcHMoc3RydWN0IGRtX3RhYmwKPiAgIAlzdHJ1Y3QgZG1fZGV2X2ludGVybmFs
ICpkZDsKPiAgIAlzdHJ1Y3QgZG1fdGFyZ2V0X2RlcHMgKmRlcHM7Cj4gICAKPiArCWRvd25fcmVh
ZCgmdGFibGUtPmRldmljZXNfbG9jayk7Cj4gKwo+ICAgCWRlcHMgPSBnZXRfcmVzdWx0X2J1ZmZl
cihwYXJhbSwgcGFyYW1fc2l6ZSwgJmxlbik7Cj4gICAKPiAgIAkvKgo+IEBAIC0xNjQ0LDcgKzE2
NDYsNyBAQCBzdGF0aWMgdm9pZCByZXRyaWV2ZV9kZXBzKHN0cnVjdCBkbV90YWJsCj4gICAJbmVl
ZGVkID0gc3RydWN0X3NpemUoZGVwcywgZGV2LCBjb3VudCk7Cj4gICAJaWYgKGxlbiA8IG5lZWRl
ZCkgewo+ICAgCQlwYXJhbS0+ZmxhZ3MgfD0gRE1fQlVGRkVSX0ZVTExfRkxBRzsKPiAtCQlyZXR1
cm47Cj4gKwkJZ290byBvdXQ7Cj4gICAJfQo+ICAgCj4gICAJLyoKPiBAQCAtMTY1Niw2ICsxNjU4
LDkgQEAgc3RhdGljIHZvaWQgcmV0cmlldmVfZGVwcyhzdHJ1Y3QgZG1fdGFibAo+ICAgCQlkZXBz
LT5kZXZbY291bnQrK10gPSBodWdlX2VuY29kZV9kZXYoZGQtPmRtX2Rldi0+YmRldi0+YmRfZGV2
KTsKPiAgIAo+ICAgCXBhcmFtLT5kYXRhX3NpemUgPSBwYXJhbS0+ZGF0YV9zdGFydCArIG5lZWRl
ZDsKPiArCj4gK291dDoKPiArCXVwX3JlYWQoJnRhYmxlLT5kZXZpY2VzX2xvY2spOwo+ICAgfQo+
ICAgCj4gICBzdGF0aWMgaW50IHRhYmxlX2RlcHMoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCBk
bV9pb2N0bCAqcGFyYW0sIHNpemVfdCBwYXJhbV9zaXplKQo+IEluZGV4OiBsaW51eC0yLjYvZHJp
dmVycy9tZC9kbS10YWJsZS5jCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+IC0tLSBsaW51eC0yLjYub3JpZy9kcml2
ZXJzL21kL2RtLXRhYmxlLmMKPiArKysgbGludXgtMi42L2RyaXZlcnMvbWQvZG0tdGFibGUuYwo+
IEBAIC0xMzUsNiArMTM1LDcgQEAgaW50IGRtX3RhYmxlX2NyZWF0ZShzdHJ1Y3QgZG1fdGFibGUg
KipyZQo+ICAgCQlyZXR1cm4gLUVOT01FTTsKPiAgIAo+ICAgCUlOSVRfTElTVF9IRUFEKCZ0LT5k
ZXZpY2VzKTsKPiArCWluaXRfcndzZW0oJnQtPmRldmljZXNfbG9jayk7Cj4gICAKPiAgIAlpZiAo
IW51bV90YXJnZXRzKQo+ICAgCQludW1fdGFyZ2V0cyA9IEtFWVNfUEVSX05PREU7Cj4gQEAgLTM1
OSwxNiArMzYwLDIwIEBAIGludCBfX3JlZiBkbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQK
PiAgIAlpZiAoZGV2ID09IGRpc2tfZGV2dCh0LT5tZC0+ZGlzaykpCj4gICAJCXJldHVybiAtRUlO
VkFMOwo+ICAgCj4gKwlkb3duX3dyaXRlKCZ0LT5kZXZpY2VzX2xvY2spOwo+ICsKPiAgIAlkZCA9
IGZpbmRfZGV2aWNlKCZ0LT5kZXZpY2VzLCBkZXYpOwo+ICAgCWlmICghZGQpIHsKPiAgIAkJZGQg
PSBrbWFsbG9jKHNpemVvZigqZGQpLCBHRlBfS0VSTkVMKTsKPiAtCQlpZiAoIWRkKQo+IC0JCQly
ZXR1cm4gLUVOT01FTTsKPiArCQlpZiAoIWRkKSB7Cj4gKwkJCXIgPSAtRU5PTUVNOwo+ICsJCQln
b3RvIHVubG9ja19yZXRfcjsKPiArCQl9Cj4gICAKPiAgIAkJciA9IGRtX2dldF90YWJsZV9kZXZp
Y2UodC0+bWQsIGRldiwgbW9kZSwgJmRkLT5kbV9kZXYpOwo+ICAgCQlpZiAocikgewo+ICAgCQkJ
a2ZyZWUoZGQpOwo+IC0JCQlyZXR1cm4gcjsKPiArCQkJZ290byB1bmxvY2tfcmV0X3I7Cj4gICAJ
CX0KPiAgIAo+ICAgCQlyZWZjb3VudF9zZXQoJmRkLT5jb3VudCwgMSk7Cj4gQEAgLTM3OCwxMiAr
MzgzLDE3IEBAIGludCBfX3JlZiBkbV9nZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQKPiAgIAl9
IGVsc2UgaWYgKGRkLT5kbV9kZXYtPm1vZGUgIT0gKG1vZGUgfCBkZC0+ZG1fZGV2LT5tb2RlKSkg
ewo+ICAgCQlyID0gdXBncmFkZV9tb2RlKGRkLCBtb2RlLCB0LT5tZCk7Cj4gICAJCWlmIChyKQo+
IC0JCQlyZXR1cm4gcjsKPiArCQkJZ290byB1bmxvY2tfcmV0X3I7Cj4gICAJfQo+ICAgCXJlZmNv
dW50X2luYygmZGQtPmNvdW50KTsKPiAgIG91dDoKPiArCXVwX3dyaXRlKCZ0LT5kZXZpY2VzX2xv
Y2spOwo+ICAgCSpyZXN1bHQgPSBkZC0+ZG1fZGV2Owo+ICAgCXJldHVybiAwOwo+ICsKPiArdW5s
b2NrX3JldF9yOgo+ICsJdXBfd3JpdGUoJnQtPmRldmljZXNfbG9jayk7Cj4gKwlyZXR1cm4gcjsK
PiAgIH0KPiAgIEVYUE9SVF9TWU1CT0woZG1fZ2V0X2RldmljZSk7Cj4gICAKPiBAQCAtNDE5LDkg
KzQyOSwxMiBAQCBzdGF0aWMgaW50IGRtX3NldF9kZXZpY2VfbGltaXRzKHN0cnVjdCBkCj4gICB2
b2lkIGRtX3B1dF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBkbV9kZXYgKmQp
Cj4gICB7Cj4gICAJaW50IGZvdW5kID0gMDsKPiAtCXN0cnVjdCBsaXN0X2hlYWQgKmRldmljZXMg
PSAmdGktPnRhYmxlLT5kZXZpY2VzOwo+ICsJc3RydWN0IGRtX3RhYmxlICp0ID0gdGktPnRhYmxl
Owo+ICsJc3RydWN0IGxpc3RfaGVhZCAqZGV2aWNlcyA9ICZ0LT5kZXZpY2VzOwo+ICAgCXN0cnVj
dCBkbV9kZXZfaW50ZXJuYWwgKmRkOwo+ICAgCj4gKwlkb3duX3dyaXRlKCZ0LT5kZXZpY2VzX2xv
Y2spOwo+ICsKPiAgIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGRkLCBkZXZpY2VzLCBsaXN0KSB7Cj4g
ICAJCWlmIChkZC0+ZG1fZGV2ID09IGQpIHsKPiAgIAkJCWZvdW5kID0gMTsKPiBAQCAtNDMwLDE0
ICs0NDMsMTcgQEAgdm9pZCBkbV9wdXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLAo+ICAg
CX0KPiAgIAlpZiAoIWZvdW5kKSB7Cj4gICAJCURNRVJSKCIlczogZGV2aWNlICVzIG5vdCBpbiB0
YWJsZSBkZXZpY2VzIGxpc3QiLAo+IC0JCSAgICAgIGRtX2RldmljZV9uYW1lKHRpLT50YWJsZS0+
bWQpLCBkLT5uYW1lKTsKPiAtCQlyZXR1cm47Cj4gKwkJICAgICAgZG1fZGV2aWNlX25hbWUodC0+
bWQpLCBkLT5uYW1lKTsKPiArCQlnb3RvIHVubG9ja19yZXQ7Cj4gICAJfQo+ICAgCWlmIChyZWZj
b3VudF9kZWNfYW5kX3Rlc3QoJmRkLT5jb3VudCkpIHsKPiAtCQlkbV9wdXRfdGFibGVfZGV2aWNl
KHRpLT50YWJsZS0+bWQsIGQpOwo+ICsJCWRtX3B1dF90YWJsZV9kZXZpY2UodC0+bWQsIGQpOwo+
ICAgCQlsaXN0X2RlbCgmZGQtPmxpc3QpOwo+ICAgCQlrZnJlZShkZCk7Cj4gICAJfQo+ICsKPiAr
dW5sb2NrX3JldDoKPiArCXVwX3dyaXRlKCZ0LT5kZXZpY2VzX2xvY2spOwo+ICAgfQo+ICAgRVhQ
T1JUX1NZTUJPTChkbV9wdXRfZGV2aWNlKTsKPiAgIApUZXN0ZWQtYnk6IExpIExpbmdmZW5nIDxs
aWxpbmdmZW5nM0BodWF3ZWkuY29tPgo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

