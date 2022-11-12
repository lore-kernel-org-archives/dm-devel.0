Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE54AC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 14 Nov 2022 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668410020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SXjKnyvPTlJKDh8QLF11ovUfXFazgV/vQ0pen3q9IS4=;
	b=CZxmReNcCdvMQ+2ubu5TVTsepFJzP6i3KugThcJa5Au97CQ3j4m3kRjj3Wswg72+V70svD
	f9kpzaKrusX7PETNu4VnP0UXR5ZdbP1EDCxFaXj6RLIl0eTaxNSK5z62HlpLhSNg9R2RxY
	NhX75vx42v2oxoxjsXOAQ8CtW4B5wQw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-z8_zO6i8M5WVg_AWREWYnQ-1; Mon, 14 Nov 2022 02:13:37 -0500
X-MC-Unique: z8_zO6i8M5WVg_AWREWYnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C0C858F17;
	Mon, 14 Nov 2022 07:13:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E222F2166B2B;
	Mon, 14 Nov 2022 07:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D86B19465B2;
	Mon, 14 Nov 2022 07:13:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 858EC1946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 12 Nov 2022 06:23:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 67ADE202323C; Sat, 12 Nov 2022 06:23:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 600E1202322E
 for <dm-devel@redhat.com>; Sat, 12 Nov 2022 06:23:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4214685A583
 for <dm-devel@redhat.com>; Sat, 12 Nov 2022 06:23:53 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-kTod1uFgOumKu6w_ewsDrQ-1; Sat, 12 Nov 2022 01:23:50 -0500
X-MC-Unique: kTod1uFgOumKu6w_ewsDrQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N8QWL1phKz4f3jJM;
 Sat, 12 Nov 2022 14:23:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP1 (Coremail) with SMTP id cCh0CgBHPazwO29jtC94AQ--.18697S3;
 Sat, 12 Nov 2022 14:23:45 +0800 (CST)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-6-hch@lst.de>
 <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
 <20221109082645.GA14093@lst.de> <Y20+UNI0KV2VjUSi@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6230db62-9ad0-6f81-aafb-0fcb160d294d@huaweicloud.com>
Date: Sat, 12 Nov 2022 14:23:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y20+UNI0KV2VjUSi@redhat.com>
X-CM-TRANSID: cCh0CgBHPazwO29jtC94AQ--.18697S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyfCrWUGw4UAF4fuFyDKFg_yoW5ArWxpF
 WrKFW7KrZ8Gw43uwn2vw4j9Fy5t34FkayrJFyrGryI9wn8AF9YvFW3tFW3Xa4kJrn5KF1Y
 qFW2q3yrZF4vyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
 6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9
 -UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 14 Nov 2022 07:13:32 +0000
Subject: Re: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations
 in DM
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

CgrU2iAyMDIyLzExLzExIDI6MDksIE1pa2UgU25pdHplciDQtLXAOgo+IE9uIFdlZCwgTm92IDA5
IDIwMjIgYXQgIDM6MjZQIC0wNTAwLAo+IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3
cm90ZToKPiAKPj4gT24gV2VkLCBOb3YgMDksIDIwMjIgYXQgMTA6MDg6MTRBTSArMDgwMCwgWXUg
S3VhaSB3cm90ZToKPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9t
ZC9kbS5jCj4+Pj4gaW5kZXggMjkxNzcwMGIxZTE1Yy4uN2IwZDZkYzk1NzU0OSAxMDA2NDQKPj4+
PiAtLS0gYS9kcml2ZXJzL21kL2RtLmMKPj4+PiArKysgYi9kcml2ZXJzL21kL2RtLmMKPj4+PiBA
QCAtNzUxLDkgKzc1MSwxNiBAQCBzdGF0aWMgc3RydWN0IHRhYmxlX2RldmljZSAqb3Blbl90YWJs
ZV9kZXZpY2Uoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kLAo+Pj4+ICAgIAkJZ290byBvdXRfZnJl
ZV90ZDsKPj4+PiAgICAJfQo+Pj4+ICAgIC0JciA9IGJkX2xpbmtfZGlza19ob2xkZXIoYmRldiwg
ZG1fZGlzayhtZCkpOwo+Pj4+IC0JaWYgKHIpCj4+Pj4gLQkJZ290byBvdXRfYmxrZGV2X3B1dDsK
Pj4+PiArCS8qCj4+Pj4gKwkgKiBXZSBjYW4gYmUgY2FsbGVkIGJlZm9yZSB0aGUgZG0gZGlzayBp
cyBhZGRlZC4gIEluIHRoYXQgY2FzZSB3ZSBjYW4ndAo+Pj4+ICsJICogcmVnaXN0ZXIgdGhlIGhv
bGRlciByZWxhdGlvbiBoZXJlLiAgSXQgd2lsbCBiZSBkb25lIG9uY2UgYWRkX2Rpc2sgd2FzCj4+
Pj4gKwkgKiBjYWxsZWQuCj4+Pj4gKwkgKi8KPj4+PiArCWlmIChtZC0+ZGlzay0+c2xhdmVfZGly
KSB7Cj4+PiBJZiBkZXZpY2VfYWRkX2Rpc2soKSBvciBkZWxfZ2VuZGlzaygpIGNhbiBjb25jdXJy
ZW50IHdpdGggdGhpcywgSXQgc2VlbXMKPj4+IHRvIG1lIHRoYXQgdXNpbmcgJ3NsYXZlX2Rpcicg
aXMgbm90IHNhZmUuCj4+Pgo+Pj4gSSdtIG5vdCBxdWl0ZSBmYW1pbGlhciB3aXRoIGRtLCBjYW4g
d2UgZ3VhcmFudGVlIHRoYXQgdGhleSBjYW4ndAo+Pj4gY29uY3VycmVudD8KPj4KPj4gSSBhc3N1
bWVkIGRtIHdvdWxkIG5vdCBnZXQgaXRzZWxmIGludG8gdGVycml0b3J5IHdlcmUgY3JlYXRpbmcg
Lwo+PiBkZWxldGluZyB0aGUgZGV2aWNlIGNvdWxkIHJhY2Ugd2l0aCBhZGRpbmcgY29tcG9uZW50
IGRldmljZXMsIGJ1dAo+PiBkaWdnaW5nIGRlZXBlciBJIGNhbid0IGZpbmQgYW55dGhpbmcuICBU
aGlzIGNvdWxkIGJlIGRvbmUKPj4gYnkgaG9sZGluZyB0YWJsZV9kZXZpY2VzX2xvY2sgYXJvdW5k
IGFkZF9kaXNrL2RlbF9nZW5kaXNrLCBidXQKPj4gSSdtIG5vdCB0aGF0IGZhbWlsYXIgd2l0aCB0
aGUgZG0gY29kZS4KPj4KPj4gTWlrZSwgY2FuIHlvdSBoZWxwIG91dCBvbiB0aGlzPwo+IAo+IE1h
eWJlIDovCj4gCj4gVW5kZXJseWluZyBjb21wb25lbnQgZGV2aWNlcyBjYW4gY2VydGFpbmx5IGNv
bWUgYW5kIGdvIGF0IGFueQo+IHRpbWUuIEFuZCB0aGVyZSBpcyBubyBETSBjb2RlIHRoYXQgY2Fu
LCBvciBzaG91bGQsIHByZXZlbnQgdGhhdC4gQWxsCj4gd2UgY2FuIGRvIGlzIGNvcGUgd2l0aCB1
bmF2YWlsYWJpbGl0eSBvZiBkZXZpY2VzLiBCdXQgcHJldHR5IHN1cmUgdGhhdAo+IGlzbid0IHRo
ZSBxdWVzdGlvbi4KPiAKPiBJJ20gdW5jbGVhciBhYm91dCB0aGUgc3BlY2lmaWMgcmFjZSBpbiBx
dWVzdGlvbjoKPiBpZiBvcGVuX3RhYmxlX2RldmljZSgpIGRvZXNuJ3Qgc2VlIHNsYXZlX2RpciBp
dCBpcyB0aGUgZmlyc3QgdGFibGUKPiBsb2FkLiBPdGhlcndpc2UsIHRoZSBETSBkZXZpY2UgKGFu
ZCBhc3NvY2lhdGVkIGdlbmRpc2spIHNob3VsZG4ndCBoYXZlCj4gYmVlbiB0b3JuIGRvd24gd2hp
bGUgYSB0YWJsZSBpcyBhY3RpdmVseSBiZWluZyBsb2FkZWQgZm9yIGl0LiBCdXQKPiBfd2hlcmVf
IHRoZSBjb2RlIGxpdmVzLCB0byBlbnN1cmUgdGhhdCwgaXMgYWxzbyBlbHVkaW5nIG1lLi4uCj4g
Cj4gWW91IGNvdWxkIHVzZSBhIGJpZyBsb2NrICh0YWJsZV9kZXZpY2VzX2xvY2spIHRvIGRpc2Fs
bG93IGNoYW5nZXMgdG8KPiBETSByZWxhdGlvbnMgd2hpbGUgbG9hZGluZyB0aGUgdGFibGUuIEJ1
dCBJIHdvdWxkbid0IHRoaW5rIGl0IG5lZWRlZAoKSG93IGFib3V0IHVzaW5nIHRhYmxlX2Rldmlj
ZXNfbG9jayB0byBwcm90ZWN0IGRldmljZSBhZGRpdGlvbiBhbmQKcmVtb3ZhbCB0byBmb3JiaWQg
dGFibGUgbG9hZCByYWNlIHdpdGggY3JlYXRpbmcgYW5kIGRlbGV0aW5nIGV4cGxpY3RpbHksCmFz
IENocmlzdG9waCBzdWdnZXN0ZWQ/CgpUaGFua3MsCkt1YWkKCj4gYXMgbG9uZyBhcyB0aGUgZ2Vu
ZGlzaydzIGxpZmVjeWNsZSBpcyBwcm90ZWN0ZWQgdnMgdGFibGUgbG9hZHMgKG9yCj4gb3RoZXIg
Y29uY3VycmVudCBhY3Rpb25zIGxpa2UgdGFibGUgbG9hZCB2cyBkbSBkZXZpY2UgcmVtb3ZhbCku
IEFnYWluLAo+IG1vcmUgY29kZSBpbnNwZWN0aW9uIG5lZWRlZCB0byBwYWdlIGFsbCB0aGlzIGJh
Y2sgaW50byBteSBoZWFkLgo+IAo+IFRoZSBjb25jZXJuIGZvciByYWNlIGFzaWRlOgo+IEkgYW0g
Y29uY2VybmVkIHRoYXQgeW91ciByZWR1bmRhbnQgYmRfbGlua19kaXNrX2hvbGRlcigpIChmaXJz
dCBpbgo+IG9wZW5fdGFibGVfZGV2aWNlIGFuZCBsYXRlciBpbiBkbV9zZXR1cF9tZF9xdWV1ZSkg
d2lsbCByZXN1bHQgaW4KPiBkYW5nbGluZyByZWZjb3VudCAoZS5nLiBpbmNyZWFzZSBvZiAyIHdo
ZW4gaXQgc2hvdWxkIG9ubHkgYmUgYnkgMSkgLS0KPiBnaXZlbiBiZF9saW5rX2Rpc2tfaG9sZGVy
IHdpbGwgZ2xhZGx5IGp1c3QgYnVtcCBpdHMgaG9sZGVyLT5yZWZjbnQgaWYKPiBiZF9maW5kX2hv
bGRlcl9kaXNrKCkgcmV0dXJucyBhbiBleGlzdGluZyBob2xkZXIuIFRoaXMgd291bGQgb2NjdXIg
aWYKPiBhIERNIHRhYmxlIGlzIGFscmVhZHkgbG9hZGVkIChhbmQgRE0gZGV2aWNlJ3MgZ2VuZGlz
ayBleGlzdHMpIGFuZCBhCj4gbmV3IERNIHRhYmxlIGlzIGJlaW5nIGxvYWRlZC4KPiAKPiBNaWtl
Cj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

