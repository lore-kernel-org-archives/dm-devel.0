Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E38C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 19 Oct 2022 06:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666160327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=821wLHQrnMhwybB10KyCPFlkmB/KvDqo+oyhvc1TpdU=;
	b=c2uxXqqUl/DtlcZny1clzMBCBR28J3v++3/YNdijvteaEdGH3wKJNKoe5iCg+p9N1JCah1
	69Yh6cXz4X1FgPXFr5WABxpUjdlilOGdtLGGmb/aihCO4jDPLpY6m99nV/LCbzStrCbthn
	yLU6efB4Yz0N+Ct0pF3cCMSAFRKJnLQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-2A7k_zylPjO6Ekc3jMXABg-1; Wed, 19 Oct 2022 02:18:46 -0400
X-MC-Unique: 2A7k_zylPjO6Ekc3jMXABg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AA158027EB;
	Wed, 19 Oct 2022 06:18:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 657F44099B40;
	Wed, 19 Oct 2022 06:18:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E41B19465A0;
	Wed, 19 Oct 2022 06:18:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 214BC194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 08:17:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0317CC15BA5; Tue, 18 Oct 2022 08:17:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF966C15BA4
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 08:17:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FC5F811E81
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 08:17:28 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-X2A3k-mUP3aW9OBnrvrb2Q-1; Tue, 18 Oct 2022 04:17:23 -0400
X-MC-Unique: X2A3k-mUP3aW9OBnrvrb2Q-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ms6952x3WzKDmg;
 Tue, 18 Oct 2022 16:14:49 +0800 (CST)
Received: from [10.174.176.127] (unknown [10.174.176.127])
 by APP2 (Coremail) with SMTP id Syh0CgDHX9QFYU5jBcDTAQ--.65525S2;
 Tue, 18 Oct 2022 16:17:11 +0800 (CST)
To: Mike Snitzer <snitzer@redhat.com>
References: <20221010143905.240306-1-luomeng@huaweicloud.com>
 <Y02vOFnwZOHPrVY8@redhat.com>
From: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <bab8c5aa-9b12-b330-9c3b-fdd5ce4cd1b8@huaweicloud.com>
Date: Tue, 18 Oct 2022 16:17:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <Y02vOFnwZOHPrVY8@redhat.com>
X-CM-TRANSID: Syh0CgDHX9QFYU5jBcDTAQ--.65525S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCF1rZr47CFW5WFW8Gr1UGFg_yoWrAF4Up3
 yrJa9Iya95XF1jkwn2vw48AFy0yF4Sy3yUCr13Cayfu3s3ZryfAayxXF95WFZ8ZFy8Jrs3
 XFy3t39xuF1jyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 19 Oct 2022 06:18:39 +0000
Subject: Re: [dm-devel] dm: Fix UAF in run_timer_softirq()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

CgrU2iAyMDIyLzEwLzE4IDM6MzgsIE1pa2UgU25pdHplciDQtLXAOgo+IE9uIE1vbiwgT2N0IDEw
IDIwMjIgYXQgMTA6MzlQIC0wNDAwLAo+IEx1byBNZW5nIDxsdW9tZW5nQGh1YXdlaWNsb3VkLmNv
bT4gd3JvdGU6Cj4gCj4+IEZyb206IEx1byBNZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbT4KPj4K
Pj4gV2hlbiBkbV9yZXN1bWUoKSBhbmQgZG1fZGVzdHJveSgpIGFyZSBjb25jdXJyZW50LCBpdCB3
aWxsCj4+IGxlYWQgdG8gVUFGLgo+Pgo+PiBPbmUgb2YgdGhlIGNvbmN1cnJlbmN5IFVBRiBjYW4g
YmUgc2hvd24gYXMgYmVsb3c6Cj4+Cj4+ICAgICAgICAgIHVzZSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBmcmVlCj4+IGRvX3Jlc3VtZSAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwKPj4gICAgX19maW5kX2RldmljZV9oYXNoX2NlbGwgICAgICAgICAgIHwKPj4gICAgICBkbV9n
ZXQgICAgICAgICAgICAgICAgICAgICAgICAgIHwKPj4gICAgICAgIGF0b21pY19pbmMoJm1kLT5o
b2xkZXJzKSAgICAgIHwKPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ZG1fZGVzdHJveQo+PiAJCQkJICAgIHwgICBfX2RtX2Rlc3Ryb3kKPj4gCQkJCSAgICB8ICAgICBp
ZiAoIWRtX3N1c3BlbmRlZF9tZChtZCkpCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgICBhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMpCj4+IAkJCQkgICAgfCAgICAg
bXNsZWVwKDEpCj4+ICAgIGRtX3Jlc3VtZSAgICAgICAgICAgICAgICAgICAgICAgICB8Cj4+ICAg
ICAgX19kbV9yZXN1bWUgICAgICAgICAgICAgICAgICAgICB8Cj4+ICAgICAgICBkbV90YWJsZV9y
ZXN1bWVfdGFyZ2V0cyAgICAgICB8Cj4+IAlwb29sX3Jlc3VtZSAgICAgICAgICAgICAgICAgfAo+
PiAJICBkb193YWtlciAgI2FkZCBkZWxheSB3b3JrIHwKPj4gCQkJCSAgICB8ICAgICBkbV90YWJs
ZV9kZXN0cm95Cj4+IAkJCQkgICAgfCAgICAgICBwb29sX2R0cgo+PiAJCQkJICAgIHwgICAgICAg
ICBfX3Bvb2xfZGVjCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAg
ICAgICAgICBfX3Bvb2xfZGVzdHJveQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICBkZXN0cm95X3dvcmtxdWV1ZQo+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICBrZnJlZShwb29sKSAjIGZyZWUgcG9v
bAo+PiAJdGltZSBvdXQKPj4gX19kb19zb2Z0aXJxCj4+ICAgIHJ1bl90aW1lcl9zb2Z0aXJxICMg
cG9vbCBoYXMgYWxyZWFkeSBiZWVuIGZyZWVkCj4+Cj4+IFRoaXMgY2FuIGJlIGVhc2lseSByZXBy
b2R1Y2VkIHVzaW5nOgo+PiAgICAxLiBjcmVhdGUgdGhpbi1wb29sCj4+ICAgIDIuIGRtc2V0dXAg
c3VzcGVuZCBwb29sCj4+ICAgIDMuIGRtc2V0dXAgcmVzdW1lIHBvb2wKPj4gICAgNC4gZG1zZXR1
cCByZW1vdmVfYWxsICMgQ29uY3VycmVudCB3aXRoIDMKPj4KPj4gVGhlIHJvb3QgY2F1c2Ugb2Yg
VUFGIGJ1Z3MgaXMgdGhhdCBkbV9yZXN1bWUoKSBhZGRzIHRpbWVyIGFmdGVyCj4+IGRtX2Rlc3Ry
b3koKSBza2lwcyBjYW5jZWwgdGltZXIgYmVhdXNlIG9mIHN1c3BlbmQgc3RhdHVzLiBBZnRlcgo+
PiB0aW1lb3V0LCBpdCB3aWxsIGNhbGwgcnVuX3RpbWVyX3NvZnRpcnEoKSwgaG93ZXZlciBwb29s
IGhhcyBhbHJlYWR5Cj4+IGJlZW4gZnJlZWQuIFRoZSBjb25jdXJyZW5jeSBVQUYgYnVnIHdpbGwg
aGFwcGVuLgo+Pgo+PiBUaGVyZWZvcmUsIGNhbmNlbGluZyB0aW1lciBpcyBtb3ZlZCBhZnRlciBt
ZC0+aG9sZGVycyBpcyB6ZXJvLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBMdW8gTWVuZyA8bHVvbWVu
ZzEyQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiAgIGRyaXZlcnMvbWQvZG0uYyB8IDI2ICsrKysrKysr
KysrKystLS0tLS0tLS0tLS0tCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyks
IDEzIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJp
dmVycy9tZC9kbS5jCj4+IGluZGV4IDYwNTQ5YjY1Yzc5OS4uMzc5NTI1MzEzNjI4IDEwMDY0NAo+
PiAtLS0gYS9kcml2ZXJzL21kL2RtLmMKPj4gKysrIGIvZHJpdmVycy9tZC9kbS5jCj4+IEBAIC0y
NDIwLDYgKzI0MjAsMTkgQEAgc3RhdGljIHZvaWQgX19kbV9kZXN0cm95KHN0cnVjdCBtYXBwZWRf
ZGV2aWNlICptZCwgYm9vbCB3YWl0KQo+PiAgIAo+PiAgIAlibGtfbWFya19kaXNrX2RlYWQobWQt
PmRpc2spOwo+PiAgIAo+PiArCS8qCj4+ICsJICogUmFyZSwgYnV0IHRoZXJlIG1heSBiZSBJL08g
cmVxdWVzdHMgc3RpbGwgZ29pbmcgdG8gY29tcGxldGUsCj4+ICsJICogZm9yIGV4YW1wbGUuICBX
YWl0IGZvciBhbGwgcmVmZXJlbmNlcyB0byBkaXNhcHBlYXIuCj4+ICsJICogTm8gb25lIHNob3Vs
ZCBpbmNyZW1lbnQgdGhlIHJlZmVyZW5jZSBjb3VudCBvZiB0aGUgbWFwcGVkX2RldmljZSwKPj4g
KwkgKiBhZnRlciB0aGUgbWFwcGVkX2RldmljZSBzdGF0ZSBiZWNvbWVzIERNRl9GUkVFSU5HLgo+
PiArCSAqLwo+PiArCWlmICh3YWl0KQo+PiArCQl3aGlsZSAoYXRvbWljX3JlYWQoJm1kLT5ob2xk
ZXJzKSkKPj4gKwkJCW1zbGVlcCgxKTsKPj4gKwllbHNlIGlmIChhdG9taWNfcmVhZCgmbWQtPmhv
bGRlcnMpKQo+PiArCQlETVdBUk4oIiVzOiBGb3JjaWJseSByZW1vdmluZyBtYXBwZWRfZGV2aWNl
IHN0aWxsIGluIHVzZSEgKCVkIHVzZXJzKSIsCj4+ICsJCSAgICAgICBkbV9kZXZpY2VfbmFtZSht
ZCksIGF0b21pY19yZWFkKCZtZC0+aG9sZGVycykpOwo+PiArCj4+ICAgCS8qCj4+ICAgCSAqIFRh
a2Ugc3VzcGVuZF9sb2NrIHNvIHRoYXQgcHJlc3VzcGVuZCBhbmQgcG9zdHN1c3BlbmQgbWV0aG9k
cwo+PiAgIAkgKiBkbyBub3QgcmFjZSB3aXRoIGludGVybmFsIHN1c3BlbmQuCj4+IEBAIC0yNDM2
LDE5ICsyNDQ5LDYgQEAgc3RhdGljIHZvaWQgX19kbV9kZXN0cm95KHN0cnVjdCBtYXBwZWRfZGV2
aWNlICptZCwgYm9vbCB3YWl0KQo+PiAgIAlkbV9wdXRfbGl2ZV90YWJsZShtZCwgc3JjdV9pZHgp
Owo+PiAgIAltdXRleF91bmxvY2soJm1kLT5zdXNwZW5kX2xvY2spOwo+PiAgIAo+PiAtCS8qCj4+
IC0JICogUmFyZSwgYnV0IHRoZXJlIG1heSBiZSBJL08gcmVxdWVzdHMgc3RpbGwgZ29pbmcgdG8g
Y29tcGxldGUsCj4+IC0JICogZm9yIGV4YW1wbGUuICBXYWl0IGZvciBhbGwgcmVmZXJlbmNlcyB0
byBkaXNhcHBlYXIuCj4+IC0JICogTm8gb25lIHNob3VsZCBpbmNyZW1lbnQgdGhlIHJlZmVyZW5j
ZSBjb3VudCBvZiB0aGUgbWFwcGVkX2RldmljZSwKPj4gLQkgKiBhZnRlciB0aGUgbWFwcGVkX2Rl
dmljZSBzdGF0ZSBiZWNvbWVzIERNRl9GUkVFSU5HLgo+PiAtCSAqLwo+PiAtCWlmICh3YWl0KQo+
PiAtCQl3aGlsZSAoYXRvbWljX3JlYWQoJm1kLT5ob2xkZXJzKSkKPj4gLQkJCW1zbGVlcCgxKTsK
Pj4gLQllbHNlIGlmIChhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMpKQo+PiAtCQlETVdBUk4oIiVz
OiBGb3JjaWJseSByZW1vdmluZyBtYXBwZWRfZGV2aWNlIHN0aWxsIGluIHVzZSEgKCVkIHVzZXJz
KSIsCj4+IC0JCSAgICAgICBkbV9kZXZpY2VfbmFtZShtZCksIGF0b21pY19yZWFkKCZtZC0+aG9s
ZGVycykpOwo+PiAtCj4+ICAgCWRtX3RhYmxlX2Rlc3Ryb3koX191bmJpbmQobWQpKTsKPj4gICAJ
ZnJlZV9kZXYobWQpOwo+PiAgIH0KPj4gLS0gCj4+IDIuMzEuMQo+Pgo+IAo+IFRoYW5rcyBmb3Ig
dGhlIHJlcG9ydCBidXQgeW91ciBmaXggc2VlbXMgd3JvbmcuICBBIHRoaW4tcG9vbCBzcGVjaWZp
Ywo+IGZpeCBzZWVtcyBtdWNoIG1vcmUgYXBwcm9wcmlhdGUuICBEb2VzIHRoaXMgZml4IHRoZSBp
c3N1ZT8KPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9kcml2ZXJzL21k
L2RtLXRoaW4uYwo+IGluZGV4IGU3NmM5NmM3NjBhOS4uZGMyNzFjMTA3ZmI1IDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvbWQvZG0tdGhpbi5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS10aGluLmMKPiBA
QCAtMjg4OSw2ICsyODg5LDggQEAgc3RhdGljIHZvaWQgX19wb29sX2Rlc3Ryb3koc3RydWN0IHBv
b2wgKnBvb2wpCj4gICAJZG1fYmlvX3ByaXNvbl9kZXN0cm95KHBvb2wtPnByaXNvbik7Cj4gICAJ
ZG1fa2NvcHlkX2NsaWVudF9kZXN0cm95KHBvb2wtPmNvcGllcik7Cj4gICAKPiArCWNhbmNlbF9k
ZWxheWVkX3dvcmtfc3luYygmcG9vbC0+d2FrZXIpOwo+ICsJY2FuY2VsX2RlbGF5ZWRfd29ya19z
eW5jKCZwb29sLT5ub19zcGFjZV90aW1lb3V0KTsKPiAgIAlpZiAocG9vbC0+d3EpCj4gICAJCWRl
c3Ryb3lfd29ya3F1ZXVlKHBvb2wtPndxKTsKPiAgIAo+IApUaGFua3MgZm9yIHlvdXIgcmVwbHku
CgpIb3dldmVyIHRoaXMgaXNzdWUgZXhpdHMgbm90IG9ubHkgaW4gdGhpbi1wb29sLCBjYWNoZV90
YXJnZXQgYWxzbyBoYXMgCnRoaXNpc3N1cy4gIEdlbmVyaWMgZml4IG1heWJlIG1vcmUgYXBwcm9w
cmlhdGUuCgpBZnRlciBhZGRpbmcgY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCkgaW4gX19wb29s
X2Rlc3Ryb3koKSwgdGhpcyB3aWxsIAptYWtlIGl0IHBvc3NpYmxlIHRvIGNhbGwgY2FuY2VsX2Rl
bGF5ZWRfd29ya19zeW5jKCZwb29sLT53YWtlcikgdHdpY2UgCndoZW4gZG0gaXMgbm90IHN1c3Bl
bmQuCgpMdW8gTWVuZwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

