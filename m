Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65491EB64D8
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 01:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686705341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E6jyE/UhVBDIw2GUP2RTfLSC2niWxFbiC1FxI4LzPGY=;
	b=f1S4UvTNB6dhjwdlLrghOlffAEVVAFmed+OKyArKqGPZTvLnn2/et/yafu5fGNqjzwbcLM
	4RSq27ycNMiuCDzv74g/xb0XHWzREEX9Wi1SiOztc9c692JzubQJgUxYnIsYzbZPyssXYq
	gVaMo8e9XX4Mh1XEzyO3WY2CLlpRujk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-tN5_uw3zOwqpw3vd5IONnQ-1; Tue, 13 Jun 2023 21:15:37 -0400
X-MC-Unique: tN5_uw3zOwqpw3vd5IONnQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 133353C0F195;
	Wed, 14 Jun 2023 01:15:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4395492C1B;
	Wed, 14 Jun 2023 01:15:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CB511946A47;
	Wed, 14 Jun 2023 01:15:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6549A194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 01:15:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 418A31C558; Wed, 14 Jun 2023 01:15:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39F77178B4
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 01:15:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DE24858F1E
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 01:15:21 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-_mcUI_PePb-UsS8DJu5Nig-1; Tue, 13 Jun 2023 21:15:13 -0400
X-MC-Unique: _mcUI_PePb-UsS8DJu5Nig-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgnXW2pn9z4f3mVv;
 Wed, 14 Jun 2023 09:15:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAHcLOaFIlkEF+bLg--.21440S3;
 Wed, 14 Jun 2023 09:15:08 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-4-yukuai1@huaweicloud.com>
 <c96f2604-e1ef-c3ad-9d15-5e0efa5f222b@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <254fc651-aa75-074d-f567-49bafc437e9c@huaweicloud.com>
Date: Wed, 14 Jun 2023 09:15:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c96f2604-e1ef-c3ad-9d15-5e0efa5f222b@redhat.com>
X-CM-TRANSID: gCh0CgAHcLOaFIlkEF+bLg--.21440S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1kJrWfAr1xArW3JrWfGrg_yoW5CFWrpF
 WktFWrArZ0yws3Xr1UJwsrZay5Xr18KayDKryfGa4UJF13Cr4qqF1jgF4j9FykC3y8Cr1U
 tw18XFZ3ZF18Xr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH -next v2 3/6] md: add a mutex to synchronize
 idle and frozen in action_store()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xMyAyMjo0MywgWGlhbyBOaSDlhpnpgZM6Cj4gCj4g5ZyoIDIwMjMv
NS8yOSDkuIvljYg5OjIwLCBZdSBLdWFpIOWGmemBkzoKPj4gRnJvbTogWXUgS3VhaSA8eXVrdWFp
M0BodWF3ZWkuY29tPgo+Pgo+PiBDdXJyZW50bHksIGZvciBpZGxlIGFuZCBmcm96ZW4sIGFjdGlv
bl9zdG9yZSB3aWxsIGhvbGQgJ3JlY29uZmlnX211dGV4Jwo+PiBhbmQgY2FsbCBtZF9yZWFwX3N5
bmNfdGhyZWFkKCkgdG8gc3RvcCBzeW5jIHRocmVhZCwgaG93ZXZlciwgdGhpcyB3aWxsCj4+IGNh
dXNlIGRlYWRsb2NrIChleHBsYWluZWQgaW4gdGhlIG5leHQgcGF0Y2gpLiBJbiBvcmRlciB0byBm
aXggdGhlCj4+IHByb2JsZW0sIGZvbGxvd2luZyBwYXRjaCB3aWxsIHJlbGVhc2UgJ3JlY29uZmln
X211dGV4JyBhbmQgd2FpdCBvbgo+PiAncmVzeW5jX3dhaXQnLCBsaWtlIG1kX3NldF9yZWFkb25s
eSgpIGFuZCBkb19tZF9zdG9wKCkgZG9lcy4KPj4KPj4gQ29uc2lkZXIgdGhhdCBhY3Rpb25fc3Rv
cmUoKSB3aWxsIHNldC9jbGVhciAnTURfUkVDT1ZFUllfRlJPWkVOJwo+PiB1bmNvbmRpdGlvbmFs
bHksIHdoaWNoIG1pZ2h0IGNhdXNlIHVuZXhwZWN0ZWQgcHJvYmxlbXMsIGZvciBleGFtcGxlLAo+
PiBmcm96ZW4ganVzdCBzZXQgJ01EX1JFQ09WRVJZX0ZST1pFTicgYW5kIGlzIHN0aWxsIGluIHBy
b2dyZXNzLCB3aGlsZQo+PiAnaWRsZScgY2xlYXIgJ01EX1JFQ09WRVJZX0ZST1pFTicgYW5kIG5l
dyBzeW5jIHRocmVhZCBpcyBzdGFydGVkLCB3aGljaAo+PiBtaWdodCBzdGFydmUgaW4gcHJvZ3Jl
c3MgZnJvemVuLiBBIG11dGV4IGlzIGFkZGVkIHRvIHN5bmNocm9uaXplIGlkbGUKPj4gYW5kIGZy
b3plbiBmcm9tIGFjdGlvbl9zdG9yZSgpLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5
dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiDCoCBkcml2ZXJzL21kL21kLmMgfCA1ICsrKysr
Cj4+IMKgIGRyaXZlcnMvbWQvbWQuaCB8IDMgKysrCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJz
L21kL21kLmMKPj4gaW5kZXggMjNlOGU3ZWFlMDYyLi42M2E5OTNiNTJjZDcgMTAwNjQ0Cj4+IC0t
LSBhL2RyaXZlcnMvbWQvbWQuYwo+PiArKysgYi9kcml2ZXJzL21kL21kLmMKPj4gQEAgLTY0NCw2
ICs2NDQsNyBAQCB2b2lkIG1kZGV2X2luaXQoc3RydWN0IG1kZGV2ICptZGRldikKPj4gwqDCoMKg
wqDCoCBtdXRleF9pbml0KCZtZGRldi0+b3Blbl9tdXRleCk7Cj4+IMKgwqDCoMKgwqAgbXV0ZXhf
aW5pdCgmbWRkZXYtPnJlY29uZmlnX211dGV4KTsKPj4gwqDCoMKgwqDCoCBtdXRleF9pbml0KCZt
ZGRldi0+ZGVsZXRlX211dGV4KTsKPj4gK8KgwqDCoCBtdXRleF9pbml0KCZtZGRldi0+c3luY19t
dXRleCk7Cj4+IMKgwqDCoMKgwqAgbXV0ZXhfaW5pdCgmbWRkZXYtPmJpdG1hcF9pbmZvLm11dGV4
KTsKPj4gwqDCoMKgwqDCoCBJTklUX0xJU1RfSEVBRCgmbWRkZXYtPmRpc2tzKTsKPj4gwqDCoMKg
wqDCoCBJTklUX0xJU1RfSEVBRCgmbWRkZXYtPmFsbF9tZGRldnMpOwo+PiBAQCAtNDc4NSwxNCAr
NDc4NiwxOCBAQCBzdGF0aWMgdm9pZCBzdG9wX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRk
ZXYpCj4+IMKgIHN0YXRpYyB2b2lkIGlkbGVfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRl
dikKPj4gwqAgewo+PiArwqDCoMKgIG11dGV4X2xvY2soJm1kZGV2LT5zeW5jX211dGV4KTsKPj4g
wqDCoMKgwqDCoCBjbGVhcl9iaXQoTURfUkVDT1ZFUllfRlJPWkVOLCAmbWRkZXYtPnJlY292ZXJ5
KTsKPj4gwqDCoMKgwqDCoCBzdG9wX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoCBtdXRl
eF91bmxvY2soJm1kZGV2LT5zeW5jX211dGV4KTsKPj4gwqAgfQo+PiDCoCBzdGF0aWMgdm9pZCBm
cm96ZW5fc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPj4gwqAgewo+PiArwqDCoMKg
IG11dGV4X2luaXQoJm1kZGV2LT5kZWxldGVfbXV0ZXgpOwo+IAo+IAo+IHR5cG8gZXJyb3I/IEl0
IHNob3VsZCBiZSBtdXRleF9sb2NrKCZtZGRldi0+c3luY19tdXRleCk7ID8KPiAKClllcywgYW5k
IHRoYW5rcyBmb3Igc3BvdHRpbmcgdGhpcywgdGhpcyBsb29rcyBsaWtlIEkgZGlkIHRoaXMgd2hp
bGUKcmViYXNpbmcuCgpUaGFua3MsCkt1YWkKPiBSZWdhcmRzCj4gCj4gWGlhbwo+IAo+PiDCoMKg
wqDCoMKgIHNldF9iaXQoTURfUkVDT1ZFUllfRlJPWkVOLCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4g
wqDCoMKgwqDCoCBzdG9wX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoCBtdXRleF91bmxv
Y2soJm1kZGV2LT5zeW5jX211dGV4KTsKPj4gwqAgfQo+PiDCoCBzdGF0aWMgc3NpemVfdAo+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJpdmVycy9tZC9tZC5oCj4+IGluZGV4IGJm
ZDIzMDZiYzc1MC4uMmZhOTAzZGU1YmQwIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL21kLmgK
Pj4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4+IEBAIC01MzcsNiArNTM3LDkgQEAgc3RydWN0IG1k
ZGV2IHsKPj4gwqDCoMKgwqDCoCAvKiBQcm90ZWN0IHRoZSBkZWxldGluZyBsaXN0ICovCj4+IMKg
wqDCoMKgwqAgc3RydWN0IG11dGV4wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZWxldGVfbXV0ZXg7
Cj4+ICvCoMKgwqAgLyogVXNlZCB0byBzeW5jaHJvbml6ZSBpZGxlIGFuZCBmcm96ZW4gZm9yIGFj
dGlvbl9zdG9yZSgpICovCj4+ICvCoMKgwqAgc3RydWN0IG11dGV4wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzeW5jX211dGV4Owo+PiArCj4+IMKgwqDCoMKgwqAgYm9vbMKgwqDCoCBoYXNfc3VwZXJi
bG9ja3M6MTsKPj4gwqDCoMKgwqDCoCBib29swqDCoMKgIGZhaWxfbGFzdF9kZXY6MTsKPj4gwqDC
oMKgwqDCoCBib29swqDCoMKgIHNlcmlhbGl6ZV9wb2xpY3k6MTsKPiAKPiAuCj4gCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

