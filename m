Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88ACC77B76
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 01:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681435626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LpjOqXfFZ4bhvBXHwF/oLjnH2Wd980llu546qWnV2qU=;
	b=L82hyLTM1O4qJSjFqyzzVlc0XNIUOTwNhKZKgyF9NZzBzyzAuuOT84RxyFM/vAyDHlLTV5
	5YySxwjk3AE2IjtRvYm9Tjo+X2b1xMNPCs0lsxZgeAnQqFNNgB9/mfqrnutzblYVMBGTx+
	JGbea6xBgklMbwK4MyDZSwaMthDZFuM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-mCDecsmKOv2tMsdw7d1DbA-1; Thu, 13 Apr 2023 21:27:05 -0400
X-MC-Unique: mCDecsmKOv2tMsdw7d1DbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDA7B1871DA8;
	Fri, 14 Apr 2023 01:27:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A0FC1121320;
	Fri, 14 Apr 2023 01:27:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 69D2C19465B7;
	Fri, 14 Apr 2023 01:26:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8387419465B6
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 01:26:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 282982166B29; Fri, 14 Apr 2023 01:26:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FF6A2166B26
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 01:26:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01BF68996F1
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 01:26:45 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-RbhAC2a6MU2nG_0N_7AP0A-1; Thu, 13 Apr 2023 21:26:42 -0400
X-MC-Unique: RbhAC2a6MU2nG_0N_7AP0A-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PyJgv6gHLz4f3v5d
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 09:26:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgDX0R_LqzhkaVQBGw--.6718S3;
 Fri, 14 Apr 2023 09:26:37 +0800 (CST)
To: Logan Gunthorpe <logang@deltatee.com>, Yu Kuai <yukuai1@huaweicloud.com>, 
 dm-devel@redhat.com, song@kernel.org
References: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
 <20230413113217.1934353-6-yukuai1@huaweicloud.com>
 <961691d0-7224-caad-6c19-d9c8ca07a801@deltatee.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <720261bf-2dfd-1298-4664-853a8e5cf132@huaweicloud.com>
Date: Fri, 14 Apr 2023 09:26:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <961691d0-7224-caad-6c19-d9c8ca07a801@deltatee.com>
X-CM-TRANSID: _Ch0CgDX0R_LqzhkaVQBGw--.6718S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7GF4ktrWfKw48ZF13urg_yoWrCw15pa
 yIga43CrWUAr4xur47Xa4DZFW5tw10gFWUKry7C34fZ3Wq9rZxXFyUGF9xZr1DCFyrXFsF
 qr15Kw4DuFWDKw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
 Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
 UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v6 5/5] md: protect md_thread with rcu
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
Cc: linux-raid@vger.kernel.org, "yukuai \(C\)" <yukuai3@huawei.com>,
 yangerkun@huawei.com, linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNC8xMyAyMzoxMCwgTG9nYW4gR3VudGhvcnBlIOWGmemBkzoKPiAKPiAK
PiBPbiAyMDIzLTA0LTEzIDA1OjMyLCBZdSBLdWFpIHdyb3RlOgo+PiBGcm9tOiBZdSBLdWFpIDx5
dWt1YWkzQGh1YXdlaS5jb20+Cj4+Cj4+IE91ciB0ZXN0IHJlcG9ydHMgYSB1YWYgZm9yICdtZGRl
di0+c3luY190aHJlYWQnOgo+Pgo+PiBUMSAgICAgICAgICAgICAgICAgICAgICBUMgo+PiBtZF9z
dGFydF9zeW5jCj4+ICAgbWRfcmVnaXN0ZXJfdGhyZWFkCj4+ICAgLy8gbWRkZXYtPnN5bmNfdGhy
ZWFkIGlzIHNldAo+PiAJCQlyYWlkMWQKPj4gCQkJIG1kX2NoZWNrX3JlY292ZXJ5Cj4+IAkJCSAg
bWRfcmVhcF9zeW5jX3RocmVhZAo+PiAJCQkgICBtZF91bnJlZ2lzdGVyX3RocmVhZAo+PiAJCQkg
ICAga2ZyZWUKPj4KPj4gICBtZF93YWtldXBfdGhyZWFkCj4+ICAgIHdha2VfdXAKPj4gICAgLT5z
eW5jX3RocmVhZCB3YXMgZnJlZWQKPj4KPj4gUm9vdCBjYXVzZSBpcyB0aGF0IHRoZXJlIGlzIGEg
c21hbGwgd2luZG93biBiZXR3ZWVuIHJlZ2lzdGVyIHRocmVhZCBhbmQKPj4gd2FrZSB1cCB0aHJl
YWQsIHdoZXJlIHRoZSB0aHJlYWQgY2FuIGJlIGZyZWVkIGNvbmN1cnJlbnRseS4KPj4KPj4gQ3Vy
cmVudGx5LCBhIGdsb2JhbCBzcGlubG9jayAncGVyc19sb2NrJyBpcyBib3Jyb3dlZCB0byBwcm90
ZWN0Cj4+ICdtZGRldi0+dGhyZWFkJywgdGhpcyBwcm9ibGVtIGNhbiBiZSBmaXhlZCBsaWtld2lz
ZSwgaG93ZXZlciwgdGhlcmUgYXJlCj4+IHNpbWlsYXIgcHJvYmxlbXMgZWxzZXdoZXJlLCBhbmQg
dXNlIGEgZ2xvYmFsIGxvY2sgZm9yIGFsbCB0aGUgY2FzZXMgaXMKPj4gbm90IGdvb2QuCj4+Cj4+
IFRoaXMgcGF0Y2ggcHJvdGVjdCBhbGwgbWRfdGhyZWFkIHdpdGggcmN1Lgo+Pgo+PiBTaWduZWQt
b2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiAgIGRyaXZlcnMv
bWQvbWQtYml0bWFwLmMgICAgfCAxMCArKysrLS0KPj4gICBkcml2ZXJzL21kL21kLWNsdXN0ZXIu
YyAgIHwgIDcgKystLQo+PiAgIGRyaXZlcnMvbWQvbWQtbXVsdGlwYXRoLmMgfCAgNCArLS0KPj4g
ICBkcml2ZXJzL21kL21kLmMgICAgICAgICAgIHwgNjkgKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCj4+ICAgZHJpdmVycy9tZC9tZC5oICAgICAgICAgICB8ICA4ICsrLS0t
Cj4+ICAgZHJpdmVycy9tZC9yYWlkMS5jICAgICAgICB8ICA3ICsrLS0KPj4gICBkcml2ZXJzL21k
L3JhaWQxLmggICAgICAgIHwgIDIgKy0KPj4gICBkcml2ZXJzL21kL3JhaWQxMC5jICAgICAgIHwg
MjEgKysrKysrKy0tLS0tCj4+ICAgZHJpdmVycy9tZC9yYWlkMTAuaCAgICAgICB8ICAyICstCj4+
ICAgZHJpdmVycy9tZC9yYWlkNS1jYWNoZS5jICB8IDIyICsrKysrKysrLS0tLS0KPj4gICBkcml2
ZXJzL21kL3JhaWQ1LmMgICAgICAgIHwgMTUgKysrKystLS0tCj4+ICAgZHJpdmVycy9tZC9yYWlk
NS5oICAgICAgICB8ICAyICstCj4+ICAgMTIgZmlsZXMgY2hhbmdlZCwgOTEgaW5zZXJ0aW9ucygr
KSwgNzggZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLWJpdG1h
cC5jIGIvZHJpdmVycy9tZC9tZC1iaXRtYXAuYwo+PiBpbmRleCAyOWZkNDFlZjU1YTYuLmFiMjdm
NjZkYmIxZiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9tZC1iaXRtYXAuYwo+PiArKysgYi9k
cml2ZXJzL21kL21kLWJpdG1hcC5jCj4+IEBAIC0xMjIxLDEzICsxMjIxLDE5IEBAIHN0YXRpYyBi
aXRtYXBfY291bnRlcl90ICptZF9iaXRtYXBfZ2V0X2NvdW50ZXIoc3RydWN0IGJpdG1hcF9jb3Vu
dHMgKmJpdG1hcCwKPj4gICBzdGF0aWMgdm9pZCBtZGRldl9zZXRfdGltZW91dChzdHJ1Y3QgbWRk
ZXYgKm1kZGV2LCB1bnNpZ25lZCBsb25nIHRpbWVvdXQsCj4+ICAgCQkJICAgICAgYm9vbCBmb3Jj
ZSkKPj4gICB7Cj4+IC0Jc3RydWN0IG1kX3RocmVhZCAqdGhyZWFkID0gbWRkZXYtPnRocmVhZDsK
Pj4gKwlzdHJ1Y3QgbWRfdGhyZWFkICp0aHJlYWQ7Cj4+ICsKPj4gKwlyY3VfcmVhZF9sb2NrKCk7
Cj4+ICsJdGhyZWFkID0gcmN1X2RlcmVmZXJlbmNlKG1kZGV2LT50aHJlYWQpOwo+PiAgIAo+PiAg
IAlpZiAoIXRocmVhZCkKPj4gLQkJcmV0dXJuOwo+PiArCQlnb3RvIG91dDsKPj4gICAKPj4gICAJ
aWYgKGZvcmNlIHx8IHRocmVhZC0+dGltZW91dCA8IE1BWF9TQ0hFRFVMRV9USU1FT1VUKQo+PiAg
IAkJdGhyZWFkLT50aW1lb3V0ID0gdGltZW91dDsKPj4gKwo+PiArb3V0Ogo+PiArCXJjdV9yZWFk
X3VubG9jaygpOwo+PiAgIH0KPj4gICAKPj4gICAvKgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9tZC1jbHVzdGVyLmMgYi9kcml2ZXJzL21kL21kLWNsdXN0ZXIuYwo+PiBpbmRleCAxMGUwYzUz
ODFkMDEuLjY3MmRmYTZhNDBlYyAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9tZC1jbHVzdGVy
LmMKPj4gKysrIGIvZHJpdmVycy9tZC9tZC1jbHVzdGVyLmMKPj4gQEAgLTM2Miw4ICszNjIsOCBA
QCBzdGF0aWMgdm9pZCBfX3JlY292ZXJfc2xvdChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBpbnQgc2xv
dCkKPj4gICAKPj4gICAJc2V0X2JpdChzbG90LCAmY2luZm8tPnJlY292ZXJ5X21hcCk7Cj4+ICAg
CWlmICghY2luZm8tPnJlY292ZXJ5X3RocmVhZCkgewo+PiAtCQljaW5mby0+cmVjb3ZlcnlfdGhy
ZWFkID0gbWRfcmVnaXN0ZXJfdGhyZWFkKHJlY292ZXJfYml0bWFwcywKPj4gLQkJCQltZGRldiwg
InJlY292ZXIiKTsKPj4gKwkJcmN1X2Fzc2lnbl9wb2ludGVyKGNpbmZvLT5yZWNvdmVyeV90aHJl
YWQsCj4+ICsJCQltZF9yZWdpc3Rlcl90aHJlYWQocmVjb3Zlcl9iaXRtYXBzLCBtZGRldiwgInJl
Y292ZXIiKSk7Cj4+ICAgCQlpZiAoIWNpbmZvLT5yZWNvdmVyeV90aHJlYWQpIHsKPj4gICAJCQlw
cl93YXJuKCJtZC1jbHVzdGVyOiBDb3VsZCBub3QgY3JlYXRlIHJlY292ZXJ5IHRocmVhZFxuIik7
Cj4+ICAgCQkJcmV0dXJuOwo+PiBAQCAtODg5LDcgKzg4OSw4IEBAIHN0YXRpYyBpbnQgam9pbihz
dHJ1Y3QgbWRkZXYgKm1kZGV2LCBpbnQgbm9kZXMpCj4+ICAgCX0KPj4gICAJLyogSW5pdGlhdGUg
dGhlIGNvbW11bmljYXRpb24gcmVzb3VyY2VzICovCj4+ICAgCXJldCA9IC1FTk9NRU07Cj4+IC0J
Y2luZm8tPnJlY3ZfdGhyZWFkID0gbWRfcmVnaXN0ZXJfdGhyZWFkKHJlY3ZfZGFlbW9uLCBtZGRl
diwgImNsdXN0ZXJfcmVjdiIpOwo+PiArCXJjdV9hc3NpZ25fcG9pbnRlcihjaW5mby0+cmVjdl90
aHJlYWQsCj4+ICsJCQltZF9yZWdpc3Rlcl90aHJlYWQocmVjdl9kYWVtb24sIG1kZGV2LCAiY2x1
c3Rlcl9yZWN2IikpOwo+PiAgIAlpZiAoIWNpbmZvLT5yZWN2X3RocmVhZCkgewo+IAo+IFRoaXMg
bG9va3MgbGlrZSBpdCdsbCBoaXQgc3BhcnNlIHdhcm5pbmdzLiB3aXRob3V0IGFuCj4gcmN1X2Fj
Y2Vzc19wb2ludGVyKCkuIE1pZ2h0IGJlIG5pY2VyIHRvIHVzZSBhIHRlbXBvcmFyeSB2YXJpYWJs
ZSwgY2hlY2sKPiB0aGF0IGl0J3Mgbm90IG51bGwsIHRoZW4gY2FsbCByY3VfYXNzaWduX3BvaW50
ZXIoKS4KClNvcnJ5IHRoaXMgaXMgYmVjYXVzZSBJIG1pc3NlZCBmb2xsb3dpbmcgY2hhbmdlOgoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQtY2x1c3Rlci5jIGIvZHJpdmVycy9tZC9tZC1jbHVz
dGVyLmMKaW5kZXggNjcyZGZhNmE0MGVjLi4yZjY0NjczYjZlZDIgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbWQvbWQtY2x1c3Rlci5jCisrKyBiL2RyaXZlcnMvbWQvbWQtY2x1c3Rlci5jCkBAIC03NSwx
NCArNzUsMTQgQEAgc3RydWN0IG1kX2NsdXN0ZXJfaW5mbyB7CiAgICAgICAgIHNlY3Rvcl90IHN1
c3BlbmRfaGk7CiAgICAgICAgIGludCBzdXNwZW5kX2Zyb207IC8qIHRoZSBzbG90IHdoaWNoIGJy
b2FkY2FzdCBzdXNwZW5kX2xvL2hpICovCgotICAgICAgIHN0cnVjdCBtZF90aHJlYWQgKnJlY292
ZXJ5X3RocmVhZDsKKyAgICAgICBzdHJ1Y3QgbWRfdGhyZWFkIF9fcmN1ICpyZWNvdmVyeV90aHJl
YWQ7CiAgICAgICAgIHVuc2lnbmVkIGxvbmcgcmVjb3ZlcnlfbWFwOwogICAgICAgICAvKiBjb21t
dW5pY2F0aW9uIGxvYyByZXNvdXJjZXMgKi8KICAgICAgICAgc3RydWN0IGRsbV9sb2NrX3Jlc291
cmNlICphY2tfbG9ja3JlczsKICAgICAgICAgc3RydWN0IGRsbV9sb2NrX3Jlc291cmNlICptZXNz
YWdlX2xvY2tyZXM7CiAgICAgICAgIHN0cnVjdCBkbG1fbG9ja19yZXNvdXJjZSAqdG9rZW5fbG9j
a3JlczsKICAgICAgICAgc3RydWN0IGRsbV9sb2NrX3Jlc291cmNlICpub19uZXdfZGV2X2xvY2ty
ZXM7Ci0gICAgICAgc3RydWN0IG1kX3RocmVhZCAqcmVjdl90aHJlYWQ7CisgICAgICAgc3RydWN0
IG1kX3RocmVhZCBfX3JjdSAqcmVjdl90aHJlYWQ7CiAgICAgICAgIHN0cnVjdCBjb21wbGV0aW9u
IG5ld2Rpc2tfY29tcGxldGlvbjsKICAgICAgICAgd2FpdF9xdWV1ZV9oZWFkX3Qgd2FpdDsKICAg
ICAgICAgdW5zaWduZWQgbG9uZyBzdGF0ZTsKClRoYW5rcywKS3VhaQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

