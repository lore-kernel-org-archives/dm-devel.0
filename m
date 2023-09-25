Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E5CCE7A8B
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 02:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695610733;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zW0zGjnK7k6jPS6M6MTVjj19/pvBg7uKtXz7cM5h++k=;
	b=VQpC2yV1zsJSXB6a/uZfYCzIdUVmBRbUsfYNQ/A/hiiqUDvWKI+7OPmkq0OmLQlF+NIik8
	dOpVi8FwlhZL6s6C56Eq7/ZU63qbc5lNNaSqRGhT+T9uO80eOwUnqTibH94A2iVL2h+xX+
	jvdQ33P5nFgCMu186vcRLGyMuFJUBt8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-ZXfvBPPrN4mRxD_U3GkZEg-1; Sun, 24 Sep 2023 22:58:51 -0400
X-MC-Unique: ZXfvBPPrN4mRxD_U3GkZEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9107E29AA2D8;
	Mon, 25 Sep 2023 02:58:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF05E1004145;
	Mon, 25 Sep 2023 02:58:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9E2A1946597;
	Mon, 25 Sep 2023 02:58:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7554194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 02:58:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C743740C6E76; Mon, 25 Sep 2023 02:58:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF8C340C6EA8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 02:58:46 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CF9B8007A4
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 02:58:46 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-MxPIp2pnPqKvaeXXBV1lBA-1; Sun, 24 Sep 2023 22:58:41 -0400
X-MC-Unique: MxPIp2pnPqKvaeXXBV1lBA-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rv6yH1LyKz4f3jHc;
 Mon, 25 Sep 2023 10:58:31 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBn+dhY9xBlKB9PBQ--.3500S3;
 Mon, 25 Sep 2023 10:58:33 +0800 (CST)
To: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
Date: Mon, 25 Sep 2023 10:58:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230922030340.2eaa46bc@nvm>
X-CM-TRANSID: gCh0CgBn+dhY9xBlKB9PBQ--.3500S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF43Xr43Gw1kCF1kKrW8Crg_yoW5Gry7pr
 W0gFWakrnrXFy8Cw1kXa4kuFy0yr4aqrZrJryfZw17ZrnxWF90qan7Wa45JrnxCwsYkryj
 vw42y34DWas0qFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: Kirill Kirilenko <kirill@ultracoder.org>, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Alasdair Kergon <agk@redhat.com>,
 heinzm@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIzLzA5LzIyIDY6MDMsIFJvbWFuIE1hbWVkb3Yg0LS1wDoKPiBPbiBUaHUsIDIx
IFNlcCAyMDIzIDE3OjQ1OjI0IC0wNDAwCj4gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5v
cmc+IHdyb3RlOgo+IAo+PiBJIGp1c3QgdmVyaWZpZWQgdGhhdCA2LjUuMCBkb2VzIGhhdmUgdGhp
cyBETSBjb3JlIGZpeCAobmVlZGVkIHRvCj4+IHByZXZlbnQgZXhjZXNzaXZlIHNwbGl0dGluZyBv
ZiBkaXNjYXJkIElPLi4gd2hpY2ggY291bGQgY2F1c2UgZnN0cmltCj4+IHRvIHRha2UgbG9uZ2Vy
IGZvciBhIERNIGRldmljZSksIGJ1dCBhZ2FpbiA2LjUuMCBoYXMgdGhpcyBmaXggc28gaXQKPj4g
aXNuJ3QgcmVsZXZhbnQ6Cj4+IGJlMDRjMTRhMWJkMiBkbTogdXNlIG9wIHNwZWNpZmljIG1heF9z
ZWN0b3JzIHdoZW4gc3BsaXR0aW5nIGFibm9ybWFsIGlvCj4+Cj4+IEdpdmVuIHlvdXIgdXNlIG9m
ICd3cml0ZW1vc3RseScgSSdtIGluZmVycmluZyB5b3UncmUgdXNpbmcgbHZtMidzCj4+IHJhaWQx
IHRoYXQgdXNlcyBNRCByYWlkMSBjb2RlIGluIHRlcm1zIG9mIHRoZSBkbS1yYWlkIHRhcmdldC4K
Pj4KPj4gRGlzY2FyZHMgKG1vcmUgZ2VuZXJpYyB0ZXJtIGZvciBmc3RyaW0pIGFyZSBjb25zaWRl
cmVkIHdyaXRlcywgc28KPj4gd3JpdGVtb3N0bHkgcmVhbGx5IHNob3VsZG4ndCBtYXR0ZXIuLi4g
YnV0IEkga25vdyB0aGF0IHRoZXJlIGhhdmUgYmVlbgo+PiBpc3N1ZXMgd2l0aCBNRCdzIHdyaXRl
bW9zdGx5IGNvZGUgKGlkZW50aWZpZWQgYnkgb3RoZXJzIHJlbGF0aXZlbHkKPj4gcmVjZW50bHkp
Lgo+Pgo+PiBBbGwgc2FpZDogaG9wZWZ1bGx5IHNvbWVvbmUgbW9yZSBNRCBvcmllbnRlZCBjYW4g
cmV2aWV3IHlvdXIgcmVwb3J0Cj4+IGFuZCBoZWxwIHlvdSBmdXJ0aGVyLgo+Pgo+PiBNaWtlCj4g
Cj4gSSd2ZSByZXBvcnRlZCB0aGF0IHdyaXRlLW1vc3RseSBUUklNIGdldHMgc3BsaXQgaW50byAx
TUIgcGllY2VzLCB3aGljaCBjYW4gYmUKPiBhbiBvcmRlciBvZiBtYWduaXR1ZGUgc2xvd2VyIG9u
IHNvbWUgU1NEczogaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvcmFpZC9tc2c3MjQ3MS5o
dG1sCgpMb29rcyBsaWtlIEkgbWlzc2VkIHRoZSByZXBvcnQuCgpCYXNlZCBvbiBjb2RlIHJldmll
dywgaXQncyB2ZXJ5IGNsZWFybHkgd2hlcmUgZGlza2NhcmQgYmlvIGlzIHNwbGl0ZWQ6CgpyYWlk
MV93cml0ZV9yZXF1ZXN0CiAgZm9yIChpID0gMDsgIGkgPCBkaXNrczsgaSsrKQogICBpZiAocmRl
diAmJiB0ZXN0X2JpdChXcml0ZU1vc3RseSwgJnJkZXYtPmZsYWdzKSkKICAgIHdyaXRlX2JlaGlu
ZCA9IHRydWUKCiAgaWYgKHdyaXRlX2JlaGluZCAmJiBiaXRtYXApCiAgIG1heF9zZWN0b3JzID0g
bWluX3QoaW50LCBtYXhfc2VjdG9ycywgQklPX01BWF9WRUNTICogKFBBR0VfU0laRSA+PiA5KSkK
ICAgLy8gaW8gc2l6ZSBpcyA1MTIgKiAoMjU2ICogKDRrID4+IDkpKSA9IDFNCgogIGlmIChtYXhf
c2VjdG9ycyA8IGJpb19zZWN0b3JzKGJpbykpCiAgIGJpb19zcGxpdAoKUm9tYW4gYW5kIEtpcmls
bCwgY2FuIHlvdSB0ZXN0IHRoZSBmb2xsb3dpbmcgcGF0Y2g/CgpUaGFua3MsCkt1YWkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL3JhaWQxLmMgYi9kcml2ZXJzL21kL3JhaWQxLmMKaW5kZXggNGIz
MGExNzQyMTYyLi40OTYzZjg2NGVmOTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvcmFpZDEuYwor
KysgYi9kcml2ZXJzL21kL3JhaWQxLmMKQEAgLTEzNDUsNiArMTM0NSw3IEBAIHN0YXRpYyB2b2lk
IHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1kZGV2IAoqbWRkZXYsIHN0cnVjdCBiaW8gKmJp
bywKICAgICAgICAgaW50IGZpcnN0X2Nsb25lOwogICAgICAgICBpbnQgbWF4X3NlY3RvcnM7CiAg
ICAgICAgIGJvb2wgd3JpdGVfYmVoaW5kID0gZmFsc2U7CisgICAgICAgYm9vbCBpc19kaXNjYXJk
ID0gKGJpb19vcChiaW8pID09IFJFUV9PUF9ESVNDQVJEKTsKCiAgICAgICAgIGlmIChtZGRldl9p
c19jbHVzdGVyZWQobWRkZXYpICYmCiAgICAgICAgICAgICAgbWRfY2x1c3Rlcl9vcHMtPmFyZWFf
cmVzeW5jaW5nKG1kZGV2LCBXUklURSwKQEAgLTE0MDUsNyArMTQwNiw3IEBAIHN0YXRpYyB2b2lk
IHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1kZGV2IAoqbWRkZXYsIHN0cnVjdCBiaW8gKmJp
bywKICAgICAgICAgICAgICAgICAgKiB3cml0ZS1tb3N0bHksIHdoaWNoIG1lYW5zIHdlIGNvdWxk
IGFsbG9jYXRlIHdyaXRlIGJlaGluZAogICAgICAgICAgICAgICAgICAqIGJpbyBsYXRlci4KICAg
ICAgICAgICAgICAgICAgKi8KLSAgICAgICAgICAgICAgIGlmIChyZGV2ICYmIHRlc3RfYml0KFdy
aXRlTW9zdGx5LCAmcmRldi0+ZmxhZ3MpKQorICAgICAgICAgICAgICAgaWYgKCFpc19kaXNjYXJk
ICYmIHJkZXYgJiYgdGVzdF9iaXQoV3JpdGVNb3N0bHksIAomcmRldi0+ZmxhZ3MpKQogICAgICAg
ICAgICAgICAgICAgICAgICAgd3JpdGVfYmVoaW5kID0gdHJ1ZTsKCiAgICAgICAgICAgICAgICAg
aWYgKHJkZXYgJiYgdW5saWtlbHkodGVzdF9iaXQoQmxvY2tlZCwgJnJkZXYtPmZsYWdzKSkpIHsK
Cgo+IAo+IE5vYm9keSBjYXJlZCB0byByZXBseSwgaW52ZXN0aWdhdGUgb3IgZml4Lgo+IAo+IE1h
eWJlIHlvdXIgc3lzdGVtIGhhc24ndCBmcm96ZW4gdG9vLCBqdXN0IHRha2luZyBpdHMgdGltZSBp
biBwcm9jZXNzaW5nIGFsbAo+IHRoZSB0aW55IHNwbGl0IHJlcXVlc3RzLgo+IAoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

