Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFB9C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795302;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jqw5stGu1kuvMQeoplId236jIwWdP2CcwMfMvXhkawA=;
	b=LsQ8ynd4F7lue4h5Eu0juieW8gQ54IwkO68NG43rzCoTbXp+g40Y212Rk83vD4HkbYjHwX
	q2FXd7O5C298o4xfkHsK66Gfu0AvMIXF1YFv9SHw045ig5oAi74To/mABtQ/H7Gif31wkI
	YTJl/VpFOx4evTlPsMAgcHrsFvjs8DI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-aMIIJY4HOsiJuGy4gqUt6w-1; Wed, 30 Nov 2022 03:01:38 -0500
X-MC-Unique: aMIIJY4HOsiJuGy4gqUt6w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D313E811E7A;
	Wed, 30 Nov 2022 08:01:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B9DD492B1A;
	Wed, 30 Nov 2022 08:01:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC6BD19465B8;
	Wed, 30 Nov 2022 08:01:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7D5F1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 09:03:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77AEB2028DC1; Tue, 29 Nov 2022 09:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7079F2028CE4
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 09:03:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02124380664A
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 09:03:19 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-bNHFW8h-OJaL86G8aaD4Gg-1; Tue, 29 Nov 2022 04:03:15 -0500
X-MC-Unique: bNHFW8h-OJaL86G8aaD4Gg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NLxFR1lsfz4f3jYd;
 Tue, 29 Nov 2022 17:03:07 +0800 (CST)
Received: from [10.174.176.127] (unknown [10.174.176.127])
 by APP4 (Coremail) with SMTP id gCh0CgAHK9jMyoVjZOhkBQ--.27481S2;
 Tue, 29 Nov 2022 17:03:10 +0800 (CST)
To: Mike Snitzer <snitzer@redhat.com>
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
 <Y02zebNyn73/MN1d@redhat.com>
From: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <20f3b1f0-ee0a-5abe-d45e-46198a0bd56b@huaweicloud.com>
Date: Tue, 29 Nov 2022 17:03:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <Y02zebNyn73/MN1d@redhat.com>
X-CM-TRANSID: gCh0CgAHK9jMyoVjZOhkBQ--.27481S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWkZryxCFykAF4ftw48tFb_yoW7AF17pF
 45XF90kFy8XrZFgw1Ivr40kry2qw42kw1Ykry7C3y29wn09ryrJFy8GrW5Za95AF9rWF1f
 uFyjqr4kCF48XFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
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
Cc: snitzer@kernel.org, ejt@redhat.com, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

CgrU2iAyMDIyLzEwLzE4IDM6NTYsIE1pa2UgU25pdHplciDQtLXAOgo+IE9uIE1vbiwgT2N0IDEw
IDIwMjIgYXQgMTA6NDFQIC0wNDAwLAo+IEx1byBNZW5nIDxsdW9tZW5nQGh1YXdlaWNsb3VkLmNv
bT4gd3JvdGU6Cj4gCj4+IEZyb206IEx1byBNZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbT4KPj4K
Pj4gSWYgZG1fZ2V0X2RldmljZSgpIGNyZWF0ZSBkZCBpbiBtdWx0aXBhdGhfbWVzc2FnZSgpLAo+
PiBhbmQgdGhlbiBjYWxsIHRhYmxlX2RlcHMoKSBhZnRlciBkbV9wdXRfdGFibGVfZGV2aWNlKCks
Cj4+IGl0IHdpbGwgbGVhZCB0byBjb25jdXJyZW5jeSBVQUYgYnVncy4KPj4KPj4gT25lIG9mIHRo
ZSBjb25jdXJyZW5jeSBVQUYgY2FuIGJlIHNob3duIGFzIGJlbG93Ogo+Pgo+PiAgICAgICAgICAg
KFVTRSkgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIChGUkVFKQo+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICB0YXJnZXRfbWVzc2FnZQo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIG11bHRpcGF0aF9tZXNzYWdlCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICBkbV9wdXRfZGV2aWNl
Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgIGRtX3B1
dF90YWJsZV9kZXZpY2UgIwo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAgICAgICAgIGtmcmVlKHRkKSAgIyB0YWJsZV9kZXZpY2UgKnRkCj4+IGlvY3RsICMgRE1f
VEFCTEVfREVQU19DTUQgICAgICAgICAgICAgfCAgICAgICAgIC4uLgo+PiAgICB0YWJsZV9kZXBz
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgLi4uCj4+ICAgIGRtX2dldF9saXZl
X29yX2luYWN0aXZlX3RhYmxlICAgICAgIHwgICAgICAgICAuLi4KPj4gICAgICByZXRyaWV2ZV9k
ZXAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgIC4uLgo+PiAgICAgIGxpc3RfZm9yX2Vh
Y2hfZW50cnkgICAgICAgICAgICAgICB8ICAgICAgICAgLi4uCj4+ICAgICAgICBkZXBzLT5kZXZb
Y291bnQrK10gPSAgICAgICAgICAgIHwgICAgICAgICAuLi4KPj4gICAgICAgICAgICBodWdlX2Vu
Y29kZV9kZXYgICAgICAgICAgICAgfCAgICAgICAgIC4uLgo+PiAgICAgICAgICAgIChkZC0+ZG1f
ZGV2LT5iZGV2LT5iZF9kZXYpICB8ICAgICAgICBsaXN0X2RlbCgmZGQtPmxpc3QpCj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgIGtmcmVlKGRkKSAjIGRt
X2Rldl9pbnRlcm5hbAo+Pgo+PiBUaGUgcm9vdCBjYXVzZSBvZiBVQUYgYnVncyBpcyB0aGF0IGZp
bmRfZGV2aWNlKCkgZmFpbGVkIGluCj4+IGRtX2dldF9kZXZpY2UoKSBhbmQgd2lsbCBjcmVhdGUg
ZGQgYW5kIHJlZmNvdW50IHNldCAxLCBrZnJlZSgpCj4+IGluIGRtX3B1dF90YWJsZSgpIGlzIG5v
dCBwcm90ZWN0ZWQuIFdoZW4gdGQsIHdoaWNoIHRoZXJlIGFyZQo+PiBzdGlsbCBwb2ludGVycyBw
b2ludCB0bywgaXMgcmVsZWFzZWQsIHRoZSBjb25jdXJyZW5jeSBVQUYgYnVnCj4+IHdpbGwgaGFw
cGVuLgo+Pgo+PiBUaGlzIHBhdGNoIGFkZCBhIGZsYWcgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgdG8g
Y3JlYXRlIGEgbmV3IGRkLgo+Pgo+PiBGaXhlczogODIxNWQ2ZWM1ZmVlKGRtIHRhYmxlOiByZW1v
dmUgdW51c2VkIGRtX2dldF9kZXZpY2UgcmFuZ2UgcGFyYW1ldGVycykKPj4gU2lnbmVkLW9mZi1i
eTogTHVvIE1lbmcgPGx1b21lbmcxMkBodWF3ZWkuY29tPgo+PiAtLS0KPj4gICBkcml2ZXJzL21k
L2RtLW1wYXRoLmMgICAgICAgICB8ICAyICstCj4+ICAgZHJpdmVycy9tZC9kbS10YWJsZS5jICAg
ICAgICAgfCA0MyArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQo+PiAgIGluY2x1
ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oIHwgIDIgKysKPj4gICAzIGZpbGVzIGNoYW5nZWQsIDI5
IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5jCj4+IGluZGV4IDBlMzI1NDY5
YTI1Mi4uMWY1MTA1OTUyMGFjIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL2RtLW1wYXRoLmMK
Pj4gKysrIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5jCj4+IEBAIC0yMDAxLDcgKzIwMDEsNyBAQCBz
dGF0aWMgaW50IG11bHRpcGF0aF9tZXNzYWdlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25l
ZCBhcmdjLCBjaGFyICoqYXJndiwKPj4gICAJCWdvdG8gb3V0Owo+PiAgIAl9Cj4+ICAgCj4+IC0J
ciA9IGRtX2dldF9kZXZpY2UodGksIGFyZ3ZbMV0sIGRtX3RhYmxlX2dldF9tb2RlKHRpLT50YWJs
ZSksICZkZXYpOwo+PiArCXIgPSBfX2RtX2dldF9kZXZpY2UodGksIGFyZ3ZbMV0sIGRtX3RhYmxl
X2dldF9tb2RlKHRpLT50YWJsZSksICZkZXYsIGZhbHNlKTsKPj4gICAJaWYgKHIpIHsKPj4gICAJ
CURNV0FSTigibWVzc2FnZTogZXJyb3IgZ2V0dGluZyBkZXZpY2UgJXMiLAo+PiAgIAkJICAgICAg
IGFyZ3ZbMV0pOwo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10YWJsZS5jIGIvZHJpdmVy
cy9tZC9kbS10YWJsZS5jCj4+IGluZGV4IGQ4MDM0ZmYwY2IyNC4uYWQxOGE0MWYxNjA4IDEwMDY0
NAo+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMKPj4gKysrIGIvZHJpdmVycy9tZC9kbS10
YWJsZS5jCj4+IEBAIC0zMzgsMTIgKzMzOCw4IEBAIGRldl90IGRtX2dldF9kZXZfdChjb25zdCBj
aGFyICpwYXRoKQo+PiAgIH0KPj4gICBFWFBPUlRfU1lNQk9MX0dQTChkbV9nZXRfZGV2X3QpOwo+
PiAgIAo+PiAtLyoKPj4gLSAqIEFkZCBhIGRldmljZSB0byB0aGUgbGlzdCwgb3IganVzdCBpbmNy
ZW1lbnQgdGhlIHVzYWdlIGNvdW50IGlmCj4+IC0gKiBpdCdzIGFscmVhZHkgcHJlc2VudC4KPj4g
LSAqLwo+PiAtaW50IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNo
YXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPj4gLQkJICBzdHJ1Y3QgZG1fZGV2ICoqcmVzdWx0KQo+
PiAraW50IF9fZG1fZ2V0X2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgY29uc3QgY2hhciAq
cGF0aCwgZm1vZGVfdCBtb2RlLAo+PiArCQkgICAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCwgYm9v
bCBjcmVhdGVfZGQpCj4+ICAgewo+PiAgIAlpbnQgcjsKPj4gICAJZGV2X3QgZGV2Owo+PiBAQCAt
MzY3LDE5ICszNjMsMjEgQEAgaW50IGRtX2dldF9kZXZpY2Uoc3RydWN0IGRtX3RhcmdldCAqdGks
IGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPj4gICAKPj4gICAJZGQgPSBmaW5kX2Rl
dmljZSgmdC0+ZGV2aWNlcywgZGV2KTsKPj4gICAJaWYgKCFkZCkgewo+PiAtCQlkZCA9IGttYWxs
b2Moc2l6ZW9mKCpkZCksIEdGUF9LRVJORUwpOwo+PiAtCQlpZiAoIWRkKQo+PiAtCQkJcmV0dXJu
IC1FTk9NRU07Cj4+IC0KPj4gLQkJaWYgKChyID0gZG1fZ2V0X3RhYmxlX2RldmljZSh0LT5tZCwg
ZGV2LCBtb2RlLCAmZGQtPmRtX2RldikpKSB7Cj4+IC0JCQlrZnJlZShkZCk7Cj4+IC0JCQlyZXR1
cm4gcjsKPj4gLQkJfQo+PiArCQlpZiAoY3JlYXRlX2RkKSB7Cj4+ICsJCQlkZCA9IGttYWxsb2Mo
c2l6ZW9mKCpkZCksIEdGUF9LRVJORUwpOwo+PiArCQkJaWYgKCFkZCkKPj4gKwkJCQlyZXR1cm4g
LUVOT01FTTsKPj4gICAKPj4gLQkJcmVmY291bnRfc2V0KCZkZC0+Y291bnQsIDEpOwo+PiAtCQls
aXN0X2FkZCgmZGQtPmxpc3QsICZ0LT5kZXZpY2VzKTsKPj4gLQkJZ290byBvdXQ7Cj4+ICsJCQlp
ZiAoKHIgPSBkbV9nZXRfdGFibGVfZGV2aWNlKHQtPm1kLCBkZXYsIG1vZGUsICZkZC0+ZG1fZGV2
KSkpIHsKPj4gKwkJCQlrZnJlZShkZCk7Cj4+ICsJCQkJcmV0dXJuIHI7Cj4+ICsJCQl9Cj4+ICAg
Cj4+ICsJCQlyZWZjb3VudF9zZXQoJmRkLT5jb3VudCwgMSk7Cj4+ICsJCQlsaXN0X2FkZCgmZGQt
Pmxpc3QsICZ0LT5kZXZpY2VzKTsKPj4gKwkJCWdvdG8gb3V0Owo+PiArCQl9IGVsc2UKPj4gKwkJ
CXJldHVybiAtRU5PREVWOwo+PiAgIAl9IGVsc2UgaWYgKGRkLT5kbV9kZXYtPm1vZGUgIT0gKG1v
ZGUgfCBkZC0+ZG1fZGV2LT5tb2RlKSkgewo+PiAgIAkJciA9IHVwZ3JhZGVfbW9kZShkZCwgbW9k
ZSwgdC0+bWQpOwo+PiAgIAkJaWYgKHIpCj4+IEBAIC0zOTAsNiArMzg4LDE3IEBAIGludCBkbV9n
ZXRfZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90
IG1vZGUsCj4+ICAgCSpyZXN1bHQgPSBkZC0+ZG1fZGV2Owo+PiAgIAlyZXR1cm4gMDsKPj4gICB9
Cj4+ICtFWFBPUlRfU1lNQk9MKF9fZG1fZ2V0X2RldmljZSk7Cj4+ICsKPj4gKy8qCj4+ICsgKiBB
ZGQgYSBkZXZpY2UgdG8gdGhlIGxpc3QsIG9yIGp1c3QgaW5jcmVtZW50IHRoZSB1c2FnZSBjb3Vu
dCBpZgo+PiArICogaXQncyBhbHJlYWR5IHByZXNlbnQuCj4+ICsgKi8KPj4gK2ludCBkbV9nZXRf
ZGV2aWNlKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBjb25zdCBjaGFyICpwYXRoLCBmbW9kZV90IG1v
ZGUsCj4+ICsJCSAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCkKPj4gK3sKPj4gKwlyZXR1cm4gX19k
bV9nZXRfZGV2aWNlKHRpLCBwYXRoLCBtb2RlLCByZXN1bHQsIHRydWUpOwo+PiArfQo+PiAgIEVY
UE9SVF9TWU1CT0woZG1fZ2V0X2RldmljZSk7Cj4+ICAgCj4+ICAgc3RhdGljIGludCBkbV9zZXRf
ZGV2aWNlX2xpbWl0cyhzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IGRtX2RldiAqZGV2LAo+
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggYi9pbmNsdWRlL2xp
bnV4L2RldmljZS1tYXBwZXIuaAo+PiBpbmRleCAwNGM2YWNmN2ZhYWEuLmVmNDAzMWE4NDRiNiAx
MDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmgKPj4gKysrIGIvaW5j
bHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmgKPj4gQEAgLTE3OCw2ICsxNzgsOCBAQCBkZXZfdCBk
bV9nZXRfZGV2X3QoY29uc3QgY2hhciAqcGF0aCk7Cj4+ICAgaW50IGRtX2dldF9kZXZpY2Uoc3Ry
dWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwKPj4gICAJ
CSAgc3RydWN0IGRtX2RldiAqKnJlc3VsdCk7Cj4+ICAgdm9pZCBkbV9wdXRfZGV2aWNlKHN0cnVj
dCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgZG1fZGV2ICpkKTsKPj4gK2ludCBfX2RtX2dldF9kZXZp
Y2Uoc3RydWN0IGRtX3RhcmdldCAqdGksIGNvbnN0IGNoYXIgKnBhdGgsIGZtb2RlX3QgbW9kZSwK
Pj4gKwkJICAgIHN0cnVjdCBkbV9kZXYgKipyZXN1bHQsIGJvb2wgY3JlYXRlX2RkKTsKPj4gICAK
Pj4gICAvKgo+PiAgICAqIEluZm9ybWF0aW9uIGFib3V0IGEgdGFyZ2V0IHR5cGUKPj4gLS0gCj4+
IDIuMzEuMQo+Pgo+IAo+IFRoaXMgcGF0Y2ggaXMgdHJlYXRpbmcgdGhlIG9uZSBtdWx0aXBhdGgg
Y2FzZSBsaWtlIGl0IGlzIG9ubHkgY29uc3VtZXIKPiBvZiBkbV9nZXRfZGV2aWNlKCkgdGhhdCBt
aWdodCBoYXZlIHRoaXMgaXNzdWUuIEl0IGZlZWxzIHRvbyBmb2N1c2VkIG9uCj4gYW4gaW5zdGFu
Y2Ugd2hlcmUgZG1fZ2V0X2RldmljZSgpJ3Mgc2lkZS1lZmZlY3Qgb2YgY3JlYXRpbmcgdGhlIGRl
dmljZQo+IGlzIHVud2VsY29tZS4gRmVlbHMgbGlrZSB5b3UncmUgdHJlYXRpbmcgdGhlIHN5bXB0
b20gcmF0aGVyIHRoYW4gdGhlCj4gcHJvYmxlbSAoZS5nLiB0aGF0IHRoZSAia2ZyZWUoKSBpbiBk
bV9wdXRfdGFibGUoKSBpcyBub3QgcHJvdGVjdGVkIj8pCj4gCj4gTWlrZQo+IApUaGFua3MgZm9y
IHlvdXIgcmVwbHkuIEkga25vdyBpdCBpcyBub3QgdGhlIGJlc3Qgd2F5IHRvIHNsb3ZlIHRoZSAK
cHJvYmxlbSwgaG93ZXZlciBJIGhhdmUgbm8gaWRlYSBhYm91dCBpdC4gIERvIHlvdSBoYXZlIGEg
YmV0dGVyIHdheSB0byAKZml4IGl0PwoKTHVvIE1lbmcKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

