Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C9AC6FD18
	for <dm-devel@archiver.kernel.org>; Tue, 25 Apr 2023 08:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682410944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eFTXDBEZ+WJ0wF8yXSXfwKFYyj9+15H9DCcfuu/AEuU=;
	b=Uq73v+o9zwzW57kc5ORWHiFLVWxUFPKQQEA/CN0Jfn+ddSdj0sDtkrCoqviD27HnyOzyts
	smj+vzIYOyHQkm7/+pz13SDyZtXhv/d+QzEcSOgY7AQxWOt1j9t1Hl+Nfn2Y5P4F6jHuRg
	v89rsJh3rryIiC7j8gyaK1wEx3affOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-kzgDRsmvMxacTf7OoWpCaw-1; Tue, 25 Apr 2023 04:22:21 -0400
X-MC-Unique: kzgDRsmvMxacTf7OoWpCaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0696A0F383;
	Tue, 25 Apr 2023 08:22:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6475C40C201F;
	Tue, 25 Apr 2023 08:22:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0AD031946594;
	Tue, 25 Apr 2023 08:22:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA713194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Apr 2023 08:22:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7BF07492C14; Tue, 25 Apr 2023 08:22:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 74071492C13
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 08:22:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E728101A552
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 08:22:16 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-5UGMVGJPM1CAiteGq2dMfA-1; Tue, 25 Apr 2023 04:22:13 -0400
X-MC-Unique: 5UGMVGJPM1CAiteGq2dMfA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q5FNH47qKz4f3wtd
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 16:22:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgD3rLCujUdkd9xzIA--.34816S3;
 Tue, 25 Apr 2023 16:22:08 +0800 (CST)
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
 <20230112010554.qmjuqtjoai3qqaj7@shindev>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
Date: Tue, 25 Apr 2023 16:22:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230112010554.qmjuqtjoai3qqaj7@shindev>
X-CM-TRANSID: gCh0CgD3rLCujUdkd9xzIA--.34816S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4fGF4fCF15Kr4rGF18uFg_yoWrGF1kpa
 yjkF4Ykrs7AF12yF1avw17ua4rAw4fCr45Cr13Kr1UZrW3Zr1kGa47Kr47CryfXrZYqa97
 Z3Wvqrn5ur4jyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH blktests] dm: add a regression test
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "yukuai \(C\)" <yukuai3@huawei.com>, Li Lingfeng <lilingfeng3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIzLzAxLzEyIDk6MDUsIFNoaW5pY2hpcm8gS2F3YXNha2kg0LS1wDoKPiBIZWxs
byBZdSwgdGhhbmtzIGZvciB0aGUgcGF0Y2guIEkgdGhpbmsgaXQgaXMgZ29vZCB0byBoYXZlIHRo
aXMgdGVzdCBjYXNlIHRvCj4gYXZvaWQgcmVwZWF0aW5nIHRoZSBzYW1lIHJlZ3Jlc3Npb24uIFBs
ZWFzZSBmaW5kIG15IGNvbW1lbnRzIGluIGxpbmUuCj4gCj4gQ0MrOiBNaWtlLCBkbS1kZXZlbCwK
PiAKPiBNaWtlLCBjb3VsZCB5b3UgdGFrZSBhIGxvb2sgaW4gdGhpcyBuZXcgdGVzdCBjYXNlPyBJ
dCBhZGRzICJkbSIgdGVzdCBncm91cCB0bwo+IGJsa3Rlc3RzLiBJZiB5b3UgaGF2ZSB0aG91Z2h0
cyBvbiBob3cgdG8gYWRkIGRldmljZS1tYXBwZXIgcmVsYXRlZCB0ZXN0IGNhc2VzCj4gdG8gYmxr
dGVzdHMsIHBsZWFzZSBzaGFyZSAoT3Igd2UgbWF5IGJlIGFibGUgdG8gZGlzY3VzcyBsYXRlciBh
dCBMU0YgMjAyMykuCgpDYW4gd2UgYWRkICJkbSIgdGVzdCBncm91cCB0byBibGt0ZXN0cz8gSSds
bCBzZW5kIGEgbmV3IHZlcnNpb24gaWYgd2UKY2FuLgoKVGhhbmtzLApLdWFpCj4gCj4gT24gRGVj
IDMwLCAyMDIyIC8gMTQ6NTQsIFl1IEt1YWkgd3JvdGU6Cj4+IEZyb206IFl1IEt1YWkgPHl1a3Vh
aTNAaHVhd2VpLmNvbT4KPj4KPj4gVmVyaWZ5IHRoYXQgcmVsb2FkIGEgZG0gd2l0aCBpdHNlbGYg
d29uJ3QgY3Jhc2ggdGhlIGtlcm5lbC4KPiAKPiBXaXRoIHRoaXMgdGVzdCBjYXNlLCBJIG9ic2Vy
dmVkIHRoZSBzeXN0ZW0gY3Jhc2ggb24gRmVkb3JhIGRlZmF1bHQga2VybmVsCj4gNi4wLjE4LTMw
MC5mYzM3LiBXaWxsIHRoZSBrZXJuZWwgZml4IGJlIGRlbGl2ZXJlZCB0byBzdGFibGUga2VybmVs
cz8gSWYgbm90LAo+IGl0IHdvdWxkIGJlIHRoZSBiZXR0ZXIgdG8gcmVxdWlyZSBrZXJuZWwgdmVy
c2lvbiA2LjIgZm9yIHRoaXMgdGVzdCBjYXNlIG5vdAo+IHRvIHN1cnByaXNlIHRoZSBibGt0ZXN0
cyB1c2Vycy4KPiAKPiBSZWdhcmRpbmcgdGhlIHdvcmRpbmcsICJyZWxvYWQgYSBkbSB3aXRoIGl0
c2VsZiIgaXMgYSBiaXQgY29uZnVzaW5nIGZvciBtZS4KPiBIb3cgYWJvdXQgInJlbG9hZCBhIGRt
IHdpdGggbWFwcyB0byBpdHNlbGYiPwo+IAo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5
dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiAgIHRlc3RzL2RtLzAwMSAgICAgfCAyNyArKysr
KysrKysrKysrKysrKysrKysrKysrKysKPj4gICB0ZXN0cy9kbS8wMDEub3V0IHwgIDQgKysrKwo+
PiAgIHRlc3RzL2RtL3JjICAgICAgfCAxMSArKysrKysrKysrKwo+PiAgIDMgZmlsZXMgY2hhbmdl
ZCwgNDIgaW5zZXJ0aW9ucygrKQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDc1NSB0ZXN0cy9kbS8wMDEK
Pj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvZG0vMDAxLm91dAo+PiAgIGNyZWF0ZSBtb2Rl
IDEwMDY0NCB0ZXN0cy9kbS9yYwo+Pgo+PiBkaWZmIC0tZ2l0IGEvdGVzdHMvZG0vMDAxIGIvdGVz
dHMvZG0vMDAxCj4+IG5ldyBmaWxlIG1vZGUgMTAwNzU1Cj4+IGluZGV4IDAwMDAwMDAuLjU1ZTA3
ZjMKPj4gLS0tIC9kZXYvbnVsbAo+PiArKysgYi90ZXN0cy9kbS8wMDEKPj4gQEAgLTAsMCArMSwy
NyBAQAo+PiArIyEvYmluL2Jhc2gKPj4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0z
LjArCj4+ICsjIENvcHlyaWdodCAoQykgMjAyMiBZdSBLdWFpCj4+ICsjCj4+ICsjIFJlZ3Jlc3Np
b24gdGVzdCBmb3IgY29tbWl0IDA3N2E0MDMzNTQxZiAoImJsb2NrOiBkb24ndCBhbGxvdyBhIGRp
c2sgbGluawo+PiArIyBob2xkZXIgdG8gaXRzZWxmIikKPj4gKwo+PiArLiB0ZXN0cy9kbS9yYwo+
PiArCj4+ICtERVNDUklQVElPTj0icmVsb2FkIGEgZG0gd2l0aCBpdHNlbGYiCj4gCj4gU2FtZSBj
b21tZW50IG9uIHdvcmRpbmcgYXMgdGhlIGNvbW1pdCBtZXNzYWdlLgo+IAo+PiArUVVJQ0s9MQo+
PiArCj4+ICtyZXF1aXJlcygpIHsKPj4gKwlfaGF2ZV9wcm9ncmFtIGRtc2V0dXAgJiYgX2hhdmVf
ZHJpdmVyIGRtLW1vZAo+IAo+IEkgc3VnZ2VzdCB0byBtb3ZlIHRoZXNlIGNoZWNrcyB0byBncm91
cF9yZXF1aXJlcyBpbiBkbS9yYywgc2luY2UgZnV0dXJlIG5ldyB0ZXN0Cj4gY2FzZXMgaW4gZG0g
Z3JvdXAgd2lsbCByZXF1aXJlIHRoZW0gYWxzby4KPiAKPiBOaXQ6ICcmJicgaXMgbm8gbG9uZ2Vy
IHJlcXVpcmVkIHRvIGNoZWNrIG11bHRpcGxlIHJlcXVpcmVtZW50cy4gSnVzdCwKPiAKPiAJX2hh
dmVfcHJvZ3JhbSBkbXNldHVwCj4gCV9oYXZlX2RyaXZlciBkbS1tb2QKPiAKPiBpcyBmaW5lIGFu
ZCBhIGJpdCBiZXR0ZXIuCj4gCj4+ICt9Cj4+ICsKPj4gK3Rlc3RfZGV2aWNlKCkgewo+PiArCWVj
aG8gIlJ1bm5pbmcgJHtURVNUX05BTUV9Igo+PiArCj4+ICsJZG1zZXR1cCBjcmVhdGUgdGVzdCAt
LXRhYmxlICIwIDgxOTIgbGluZWFyICR7VEVTVF9ERVZ9IDAiCj4+ICsJZG1zZXR1cCBzdXNwZW5k
IHRlc3QKPj4gKwlkbXNldHVwIHJlbG9hZCB0ZXN0IC0tdGFibGUgIjAgODE5MiBsaW5lYXIgL2Rl
di9tYXBwZXIvdGVzdCAwIgo+PiArCWRtc2V0dXAgcmVzdW1lIHRlc3QKPj4gKwlkbXNldHVwIHJl
bW92ZSB0ZXN0Cj4+ICsKPj4gKwllY2hvICJUZXN0IGNvbXBsZXRlIgo+PiArfQo+PiBkaWZmIC0t
Z2l0IGEvdGVzdHMvZG0vMDAxLm91dCBiL3Rlc3RzL2RtLzAwMS5vdXQKPj4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKPj4gaW5kZXggMDAwMDAwMC4uMjNjZjFmMAo+PiAtLS0gL2Rldi9udWxsCj4+ICsr
KyBiL3Rlc3RzL2RtLzAwMS5vdXQKPj4gQEAgLTAsMCArMSw0IEBACj4+ICtSdW5uaW5nIGRtLzAw
MQo+PiArZGV2aWNlLW1hcHBlcjogcmVsb2FkIGlvY3RsIG9uIHRlc3QgZmFpbGVkOiBJbnZhbGlk
IGFyZ3VtZW50Cj4+ICtDb21tYW5kIGZhaWxlZAo+PiArVGVzdCBjb21wbGV0ZQo+IAo+IFdpdGgg
bXkgdGVzdCBzeXN0ZW0gYW5kIGtlcm5lbCB2Ni4yLXJjMywgdGhlIG1lc3NhZ2VzIGFib3ZlIHdl
cmUgc2xpZ2h0bHkKPiBkaWZmcmVudC4gVG8gbWFrZSB0aGUgdGVzdCBjYXNlIHBhc3MsIEkgbmVl
ZGVkIGNoYW5nZXMgYmVsb3c6Cj4gCj4gZGlmZiAtLWdpdCBhL3Rlc3RzL2RtLzAwMS5vdXQgYi90
ZXN0cy9kbS8wMDEub3V0Cj4gaW5kZXggMjNjZjFmMC4uNTQzYjFkYiAxMDA2NDQKPiAtLS0gYS90
ZXN0cy9kbS8wMDEub3V0Cj4gKysrIGIvdGVzdHMvZG0vMDAxLm91dAo+IEBAIC0xLDQgKzEsNCBA
QAo+ICAgUnVubmluZyBkbS8wMDEKPiAtZGV2aWNlLW1hcHBlcjogcmVsb2FkIGlvY3RsIG9uIHRl
c3QgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50Cj4gLUNvbW1hbmQgZmFpbGVkCj4gK2RldmljZS1t
YXBwZXI6IHJlbG9hZCBpb2N0bCBvbiB0ZXN0ICBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQKPiAr
Q29tbWFuZCBmYWlsZWQuCj4gICBUZXN0IGNvbXBsZXRlCj4gCj4gCj4+IGRpZmYgLS1naXQgYS90
ZXN0cy9kbS9yYyBiL3Rlc3RzL2RtL3JjCj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0Cj4+IGluZGV4
IDAwMDAwMDAuLmUxYWQ2YzYKPj4gLS0tIC9kZXYvbnVsbAo+PiArKysgYi90ZXN0cy9kbS9yYwo+
PiBAQCAtMCwwICsxLDExIEBACj4+ICsjIS9iaW4vYmFzaAo+PiArIyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogR1BMLTMuMCsKPj4gKyMgQ29weXJpZ2h0IChDKSAyMDIyIFl1IEt1YWkKPj4gKyMK
Pj4gKyMgVE9ETzogcHJvdmlkZSBhIGJyaWVmIGRlc2NyaXB0aW9uIG9mIHRoZSBncm91cCBoZXJl
Lgo+IAo+IExldCdzIG5vdCBsZWF2ZSB0aGlzIFRPRE8uIEhvdyBhYm91dCAiIyBUZXN0cyBmb3Ig
ZGV2aWNlLW1hcHBlci4iPwo+IAo+PiArCj4+ICsuIGNvbW1vbi9yYwo+PiArCj4+ICtncm91cF9y
ZXF1aXJlcygpIHsKPj4gKwlfaGF2ZV9yb290Cj4+ICt9Cj4+IC0tIAo+PiAyLjMxLjEKPj4KPiAK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

