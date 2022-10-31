Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8FFC38A02
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8yFS+7PqtcV5/sgcPGIM+TTVSHkd0tWxPieo18Bm/XY=;
	b=SbaMkMpUVk00vNTs9yha1+kF3hd3WdTNaqH9YYI0sUdlcWycSpSU+WfifgoBe87gKGsUXP
	HWEDI4NvJ9z//C2GS1bEt8VY+tOH1xlwiYDJRdx9zepHlfbUSRLOUZy9Bbon/8jVbbu07u
	FN9KreHvv1WCkmjbsCUrx43bT58wtvQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-XC93eWMaNKeTzmKBfskMmQ-1; Mon, 31 Oct 2022 02:39:02 -0400
X-MC-Unique: XC93eWMaNKeTzmKBfskMmQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B04282DFC7;
	Mon, 31 Oct 2022 06:38:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 293134B400F;
	Mon, 31 Oct 2022 06:38:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E65219465A2;
	Mon, 31 Oct 2022 06:38:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE5CA1946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 31 Oct 2022 01:52:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96F601415123; Mon, 31 Oct 2022 01:52:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F1B1140EBF3
 for <dm-devel@redhat.com>; Mon, 31 Oct 2022 01:52:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD82811E75
 for <dm-devel@redhat.com>; Mon, 31 Oct 2022 01:52:24 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-qecsJ1FMO46jcasPokS4Xg-1; Sun, 30 Oct 2022 21:52:12 -0400
X-MC-Unique: qecsJ1FMO46jcasPokS4Xg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N0x105l7wzl9hk;
 Mon, 31 Oct 2022 09:49:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgC3E+ZFKl9jpbbdAQ--.1600S3;
 Mon, 31 Oct 2022 09:52:06 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
Date: Mon, 31 Oct 2022 09:52:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221030153120.1045101-8-hch@lst.de>
X-CM-TRANSID: gCh0CgC3E+ZFKl9jpbbdAQ--.1600S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWxKw4UGF17GF1DtrWDArb_yoW5Cr1DpF
 Z8XFyxtrW8Ga1UWw4jgw47uFyjvryYq3W8CFyI9ryS9rZ8Jr1vkr13Jr1UJFWxGrZ7trs0
 qF47Xws8AF4qkFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
 6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
 DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGkKCtTaIDIwMjIvMTAvMzAgMjM6MzEsIENocmlzdG9waCBIZWxsd2lnINC0tcA6Cj4gV2UgaG9s
ZCBhIHJlZmVyZW5jZSB0byB0aGUgaG9sZGVyIGtvYmplY3QgZm9yIGVhY2ggYmRfaG9sZGVyX2Rp
c2ssCj4gc28gdG8gbWFrZSB0aGUgY29kZSBhIGJpdCBtb3JlIHJvYnVzdCwgdXNlIGEgcmVmZXJl
bmNlIHRvIGl0IGluc3RlYWQKPiBvZiB0aGUgYmxvY2tfZGV2aWNlLiAgQXMgbG9uZyBhcyBubyBv
bmUgY2xlYXJzIC0+YmRfaG9sZGVyX2RpciBpbgo+IGJlZm9yZSBmcmVlaW5nIHRoZSBkaXNrLCB0
aGlzIGlzbid0IHN0cmljdGx5IHJlcXVpcmVkLCBidXQgaXQgZG9lcwo+IG1ha2UgdGhlIGNvZGUg
bW9yZSBjbGVhciBhbmQgbW9yZSByb2J1c3QuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3Bo
IEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBibG9jay9ob2xkZXIuYyB8IDIzICsrKysr
KysrKystLS0tLS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwg
MTMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2hvbGRlci5jIGIvYmxvY2sv
aG9sZGVyLmMKPiBpbmRleCBkZDkzMjdiNDNjZTA1Li5hOGMzNTViOWQwODA2IDEwMDY0NAo+IC0t
LSBhL2Jsb2NrL2hvbGRlci5jCj4gKysrIGIvYmxvY2svaG9sZGVyLmMKPiBAQCAtNCw3ICs0LDcg
QEAKPiAgIAo+ICAgc3RydWN0IGJkX2hvbGRlcl9kaXNrIHsKPiAgIAlzdHJ1Y3QgbGlzdF9oZWFk
CWxpc3Q7Cj4gLQlzdHJ1Y3QgYmxvY2tfZGV2aWNlCSpiZGV2Owo+ICsJc3RydWN0IGtvYmplY3QJ
CSpob2xkZXJfZGlyOwo+ICAgCWludAkJCXJlZmNudDsKPiAgIH07Cj4gICAKPiBAQCAtMTQsNyAr
MTQsNyBAQCBzdGF0aWMgc3RydWN0IGJkX2hvbGRlcl9kaXNrICpiZF9maW5kX2hvbGRlcl9kaXNr
KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4gICAJc3RydWN0IGJkX2hvbGRlcl9kaXNrICpo
b2xkZXI7Cj4gICAKPiAgIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGhvbGRlciwgJmRpc2stPnNsYXZl
X2JkZXZzLCBsaXN0KQo+IC0JCWlmIChob2xkZXItPmJkZXYgPT0gYmRldikKPiArCQlpZiAoaG9s
ZGVyLT5ob2xkZXJfZGlyID09IGJkZXYtPmJkX2hvbGRlcl9kaXIpCj4gICAJCQlyZXR1cm4gaG9s
ZGVyOwo+ICAgCXJldHVybiBOVUxMOwo+ICAgfQo+IEBAIC04MiwyNyArODIsMjQgQEAgaW50IGJk
X2xpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRp
c2sgKmRpc2spCj4gICAJfQo+ICAgCj4gICAJSU5JVF9MSVNUX0hFQUQoJmhvbGRlci0+bGlzdCk7
Cj4gLQlob2xkZXItPmJkZXYgPSBiZGV2Owo+ICAgCWhvbGRlci0+cmVmY250ID0gMTsKPiArCWhv
bGRlci0+aG9sZGVyX2RpciA9IGtvYmplY3RfZ2V0KGJkZXYtPmJkX2hvbGRlcl9kaXIpOwoKSSB3
b25kZXIgaXMgdGhpcyBzYWZlIGhlcmUsIGlmIGtvYmplY3QgcmVmZXJlbmNlIGlzIDAgaGVyZSBh
bmQKYmRfaG9sZGVyX2RpciBpcyBhYm91dCB0byBiZSBmcmVlZC4gSGVyZSBpbiBrb2JqZWN0X2dl
dCwga3JlZl9nZXQoKSB3aWxsCndhcm4gYWJvdXQgdWFmLCBhbmQga29iamVjdF9nZXQgd2lsbCBy
ZXR1cm4gYSBhZGRyZXNzIHRoYXQgaXMgYWJvdXQgdG8KYmUgZnJlZWQuCgpUaGFuc2ssCkt1YWkK
PiArCj4gICAJcmV0ID0gYWRkX3N5bWxpbmsoZGlzay0+c2xhdmVfZGlyLCBiZGV2X2tvYmooYmRl
dikpOwo+ICAgCWlmIChyZXQpCj4gLQkJZ290byBvdXRfZnJlZV9ob2xkZXI7Cj4gLQlyZXQgPSBh
ZGRfc3ltbGluayhiZGV2LT5iZF9ob2xkZXJfZGlyLCAmZGlza190b19kZXYoZGlzayktPmtvYmop
Owo+ICsJCWdvdG8gb3V0X3B1dF9ob2xkZXJfZGlyOwo+ICsJcmV0ID0gYWRkX3N5bWxpbmsoaG9s
ZGVyLT5ob2xkZXJfZGlyLCAmZGlza190b19kZXYoZGlzayktPmtvYmopOwo+ICAgCWlmIChyZXQp
Cj4gICAJCWdvdG8gb3V0X2RlbF9zeW1saW5rOwo+ICAgCWxpc3RfYWRkKCZob2xkZXItPmxpc3Qs
ICZkaXNrLT5zbGF2ZV9iZGV2cyk7Cj4gICAKPiAtCS8qCj4gLQkgKiBkZWxfZ2VuZGlzayBkcm9w
cyB0aGUgaW5pdGlhbCByZWZlcmVuY2UgdG8gYmRfaG9sZGVyX2Rpciwgc28gd2UgbmVlZAo+IC0J
ICogdG8ga2VlcCBvdXIgb3duIGhlcmUgdG8gYWxsb3cgZm9yIGNsZWFudXAgcGFzdCB0aGF0IHBv
aW50Lgo+IC0JICovCj4gLQlrb2JqZWN0X2dldChiZGV2LT5iZF9ob2xkZXJfZGlyKTsKPiAgIAlt
dXRleF91bmxvY2soJmRpc2stPm9wZW5fbXV0ZXgpOwo+ICAgCXJldHVybiAwOwo+ICAgCj4gICBv
dXRfZGVsX3N5bWxpbms6Cj4gICAJZGVsX3N5bWxpbmsoZGlzay0+c2xhdmVfZGlyLCBiZGV2X2tv
YmooYmRldikpOwo+IC1vdXRfZnJlZV9ob2xkZXI6Cj4gK291dF9wdXRfaG9sZGVyX2RpcjoKPiAr
CWtvYmplY3RfcHV0KGhvbGRlci0+aG9sZGVyX2Rpcik7Cj4gICAJa2ZyZWUoaG9sZGVyKTsKPiAg
IG91dF91bmxvY2s6Cj4gICAJbXV0ZXhfdW5sb2NrKCZkaXNrLT5vcGVuX211dGV4KTsKPiBAQCAt
MTMxLDggKzEyOCw4IEBAIHZvaWQgYmRfdW5saW5rX2Rpc2tfaG9sZGVyKHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+ICAgCWhvbGRlciA9IGJkX2ZpbmRf
aG9sZGVyX2Rpc2soYmRldiwgZGlzayk7Cj4gICAJaWYgKCFXQVJOX09OX09OQ0UoaG9sZGVyID09
IE5VTEwpICYmICEtLWhvbGRlci0+cmVmY250KSB7Cj4gICAJCWRlbF9zeW1saW5rKGRpc2stPnNs
YXZlX2RpciwgYmRldl9rb2JqKGJkZXYpKTsKPiAtCQlkZWxfc3ltbGluayhiZGV2LT5iZF9ob2xk
ZXJfZGlyLCAmZGlza190b19kZXYoZGlzayktPmtvYmopOwo+IC0JCWtvYmplY3RfcHV0KGJkZXYt
PmJkX2hvbGRlcl9kaXIpOwo+ICsJCWRlbF9zeW1saW5rKGhvbGRlci0+aG9sZGVyX2RpciwgJmRp
c2tfdG9fZGV2KGRpc2spLT5rb2JqKTsKPiArCQlrb2JqZWN0X3B1dChob2xkZXItPmhvbGRlcl9k
aXIpOwo+ICAgCQlsaXN0X2RlbF9pbml0KCZob2xkZXItPmxpc3QpOwo+ICAgCQlrZnJlZShob2xk
ZXIpOwo+ICAgCX0KPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

