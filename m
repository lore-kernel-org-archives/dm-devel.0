Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D8ECE7A91
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 01:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695605707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QVsyk8JifuWIDw94Nl3FLW7+uMlVOmSljQ41dl2HmQI=;
	b=Qd5b8iD9TwyvpAvZNvgy+O3Pf7yZOscdeuE7xJLflAMEY3yneA7QAtRth+VQPLMUyCnyfC
	vummFjx/8lxcvLWLIZvOAeLITMO8cev0uZkclv5gdcCI/WCnXRfYfKMseSbVe3GvbJv+3N
	UlYMdeVx3mEehByFfGIDm8bs7HMdAac=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-nQKiukPANwidycnez30nwA-1; Sun, 24 Sep 2023 21:35:03 -0400
X-MC-Unique: nQKiukPANwidycnez30nwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEF753C176E0;
	Mon, 25 Sep 2023 01:35:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F05A40C2070;
	Mon, 25 Sep 2023 01:35:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 116C91946597;
	Mon, 25 Sep 2023 01:35:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED4BF194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 01:34:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B87DA2026D68; Mon, 25 Sep 2023 01:34:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0CE42026D4B
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 01:34:59 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91F53811E7D
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 01:34:59 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-gup2IcZENIewwb13oOOj1g-1; Sun, 24 Sep 2023 21:34:55 -0400
X-MC-Unique: gup2IcZENIewwb13oOOj1g-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rv55j338sz4f3jZJ;
 Mon, 25 Sep 2023 09:34:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgDHXd244xBlPSFKBQ--.7589S3;
 Mon, 25 Sep 2023 09:34:50 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-3-yukuai1@huaweicloud.com>
 <CALTww29iHX_GHogGFEfzdaDjohBr8ycfiz2=E_ru4JYvmrTYdA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1407f90d-d608-6059-7381-adb230585e3d@huaweicloud.com>
Date: Mon, 25 Sep 2023 09:34:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww29iHX_GHogGFEfzdaDjohBr8ycfiz2=E_ru4JYvmrTYdA@mail.gmail.com>
X-CM-TRANSID: gCh0CgDHXd244xBlPSFKBQ--.7589S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1rKrW5AF15ZrWUurW5trb_yoW5KF17p3
 yIqFWYyrWUJF9Ik3yDtw1kua45uwn8KrW0yr9xW3W7C3W3Wr1rGF4furs8Xr1vk3Z3Gw1D
 Ja1Ut34fAF109FJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
 Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
 BIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
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
Subject: Re: [dm-devel] [PATCH -next v2 02/28] md: use 'mddev->suspended'
 for is_md_suspended()
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8yMCAxNjo0NiwgWGlhbyBOaSDlhpnpgZM6Cj4gT24gTW9uLCBBdWcg
MjgsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4g
d3JvdGU6Cj4+Cj4+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4KPj4gJ3Bl
cnMtPnByZXBhcmVfc3VzcGVuZCcgaXMgaW50cm9kdWNlZCB0byBwcmV2ZW50IGEgZGVhZGxvY2sg
Zm9yIHJhaWQ0NTYsCj4+IHRoaXMgY2hhbmdlIHByZXBhcmVzIHRvIGNsZWFuIHRoaXMgdXAgaW4g
bGF0ZXIgcGF0Y2hlcyB3aGlsZSByZWZhY3RvcmluZwo+PiBtZGRldl9zdXNwZW5kKCkuIFNwZWNp
ZmljYWxseSBhbGxvdyByZXNoYXBlIHRvIG1ha2UgcHJvZ3Jlc3Mgd2hpbGUKPj4gd2FpdGluZyBm
b3IgJ2FjdGl2ZV9pbycgdG8gYmUgMC4KPiAKPiBIaSBLdWFpCj4gCj4+RnJvbSBteSBzaWRlLCBJ
IGNhbid0IHVuZGVyc3RhbmQgdGhlIGNvbW1lbnRzLiBUaGUgY2hhbmdlIGhhcwo+IHJlbGF0aW9u
c2hpcCB3aXRoIHBlcnMtPnByZXBhcmVfc3VzcGVuZD8gQW5kIHdoeSB0aGlzIGNoYW5nZSBjYW4K
PiBhZmZlY3QgcmVzaGFwZT8gSWYgdGhpcyBjaGFuZ2UgaW5kZWVkIGNhbiBhZmZlY3QgdGhlc2Ug
dHdvIHRoaW5ncywgY2FuCj4geW91IGV4cGxhaW4gbW9yZT8KCkZpcnN0IG9mIGFsbCwgJ3ByZXBh
cmVfc3VzcGVuZCcgaXMgdXNlZCB0byBmaXggYSBkZWFkbG9jayBpbiByYWlkNDU2OgoKMSkgc3Vz
cGVuZCBpcyB3YWl0aW5nIGZvciBub3JtYWwgaW8gdG8gYmUgZG9uZS4KCm1kZGV2X3N1c3BlbmQK
ICBtZGRldi0+c3VzcGVuZGVkKysgLT4gbmV3IHN5bmNfdGhyZWFkIGNhbid0IHN0YXJ0CiAgcGVy
Y3B1X3JlZl9raWxsKGFjdGl2ZV9pbykKICB3YWl0X2V2ZW50KHBlcmNwdV9yZWZfaXNfemVybyhh
Y3RpdmVfaW8pKQoKMikgbm9ybWFsIGlvIGlzIHdhaXRpbmcgZm9yIHJlc2hhcGUgdG8gbWFrZSBw
cm9ncmVzcy4KMykgcmVzaGFwZSBpcyB3YWl0aW5nIGZvciBzdXNwZW5kZWQgYXJyYXkgdG8gYmUg
cmVzdW1lZC4KCm1kX2NoZWNrX3JlY292ZXJ5CiAgaWYgKGlzX21kX3N1c3BlbmRlZChtZGRldikp
CiAgIHJldHVybgoKVGhlbiBwcmVwYXJlX3N1c3BlbmQgd2lsbCBmYWlsZWQgdGhlIGlvIHRoYXQg
aXMgd2FpdGluZyBmb3IgcmVzaGFwZSB0bwptYWtlIHByb2dyZXNzOgoKbWRkZXZfc3VzcGVuZAog
IG1kZGV2LT5zdXNwZW5kZWQrKwogIHBlcmNwdV9yZWZfa2lsbChhY3RpdmVfaW8pCiAgIC0+IG5l
dyBpbyB3aWxsIGJlIHN0dWNrIGluIG1kX2hhbmRsZV9yZXF1ZXN0CiAgcGVycy0+cHJlcGFyZV9z
dXNwZW5kKCkgLT4gcmFpZDVfcHJlcGFyZV9zdXNwZW5kCiAgIC0+IHdha2VfdXAod2FpdF9mb3Jf
b3ZlcmxhcCkKCQkvLyB3b2tlIHVwCgkJcmFpZDVfbWFrZV9yZXF1ZXN0CgkJIG1ha2Vfc3RyaXBl
X3JlcXVlc3QKCQkgICFyZXNoYXBlX2lucHJvZ3Jlc3MobWRkZXYpICYmIHJlc2hhcGVfZGlzYWJs
ZWQobWRkZXYpCgkJICAgLy8gcmV0dXJuIGlvIGVycm9yIGZvciB0aGUgaW8gdGhhdCBpcyB3YWl0
aW5nIGZvcgoJCSAgIC8vIHJlc2hhcGUgdG8gbWFrZSBwcm9ncmVzcwoKICB3YWl0X2V2ZW50KHBl
cmNwdV9yZWZfaXNfemVybyhhY3RpdmVfaW8pKQoKV2l0aCB0aGlzIHBhdGNoIGFuZCB0aGUgbmV3
IGFwaSB0byBzdXNwZW5kIGFycmF5OgoKbWRkZXZfc3VzcGVuZAogIHBlcmNwdV9yZWZfa2lsbChh
Y3RpdmVfaW8pCiAgd2FpdF9ldmVudChwZXJjcHVfcmVmX2lzX3plcm8oYWN0aXZlX2lvKSkKICAt
PiB3aGlsZSB3YWl0aW5nIGZvciBub3JtYWwgaW8gdG8gYmUgZG9uZSwgbmV3IHN5bmNfdGhyZWFk
IGNhbiBzdGlsbAogICAgIHN0YXJ0LCBhbmQgcmVzaGFwZSBjYW4gc3RpbGwgbWFrZSBwcm9ncmVz
cy4KICBtZGRldi0+c3VzcGVuZGVkKysKCj4gCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFl1IEt1YWkg
PHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4gLS0tCj4+ICAgZHJpdmVycy9tZC9tZC5jIHwgMiArLQo+
PiAgIGRyaXZlcnMvbWQvbWQuaCB8IDIgKy0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQu
YyBiL2RyaXZlcnMvbWQvbWQuYwo+PiBpbmRleCA5ZDhkZmY5ZDkyM2MuLjdmYTMxMWExNDMxNyAx
MDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9tZC5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvbWQuYwo+
PiBAQCAtMzU1LDcgKzM1NSw3IEBAIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0soYWxsX21kZGV2c19s
b2NrKTsKPj4gICAgKi8KPj4gICBzdGF0aWMgYm9vbCBpc19zdXNwZW5kZWQoc3RydWN0IG1kZGV2
ICptZGRldiwgc3RydWN0IGJpbyAqYmlvKQo+PiAgIHsKPj4gLSAgICAgICBpZiAoaXNfbWRfc3Vz
cGVuZGVkKG1kZGV2KSkKPj4gKyAgICAgICBpZiAoaXNfbWRfc3VzcGVuZGVkKG1kZGV2KSB8fCBw
ZXJjcHVfcmVmX2lzX2R5aW5nKCZtZGRldi0+YWN0aXZlX2lvKSkKPiAKPiBJZiB3ZSB1c2UgbWRk
ZXYtPnN1c3BlbmRlZCB0byBqdWRnZSBpZiB0aGUgcmFpZCBpcyBzdXNwZW5kZWQsIGl0Cj4gc2hv
dWxkIGJlIGVub3VnaD8gQmVjYXVzZSBtZGRldi0+c3VzcGVuZGVkIG11c3QgYmUgdHJ1ZSB3aGVu
IGFjdGl2ZV9pbwo+IGlzIGR5aW5nLgoKSW4gdGhlIG5ldyBhcGksIGFjdGl2ZV9pbyBpcyBraWxs
ZWQgYmVmb3JlIGluY3JlYXNpbmcgc3VzcGVuZGVkLCBhbmQgdGhlCmRpZmZlcmVuY2UgaXMgdGhh
dCB0aGUgdGltaW5nIHRoYXQgYXJyYXkgaXMgc3VzcGVuZGVkIHdpbGwgYmUgZGVsYXllZApmcm9t
IHRoZSBzdGFydCBvZiBtZGRldl9zdXNwZW5kKCkgdG8gd2hlbiBhbGwgZGlzcGF0Y2hlZCBpbyBp
cyBkb25lLgoKSSB0aGluayB0aGlzIGlzIE9LIGJlY2F1c2UgdGhpcyBkb2Vzbid0IGNoYW5nZSBi
ZWhhdmlvdXIgd2hlbgptZGRldl9zdXNwZW5kKCkgcmV0dXJucy4KClRoYW5rcywKS3VhaQpgCj4g
Cj4gQmVzdCBSZWdhcmRzCj4gWGlhbwo+PiAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOwo+
PiAgICAgICAgICBpZiAoYmlvX2RhdGFfZGlyKGJpbykgIT0gV1JJVEUpCj4+ICAgICAgICAgICAg
ICAgICAgcmV0dXJuIGZhbHNlOwo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJp
dmVycy9tZC9tZC5oCj4+IGluZGV4IGI2MjhjMjkyNTA2ZS4uZmIzYjEyM2YxNmRkIDEwMDY0NAo+
PiAtLS0gYS9kcml2ZXJzL21kL21kLmgKPj4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4+IEBAIC01
ODQsNyArNTg0LDcgQEAgc3RhdGljIGlubGluZSBib29sIG1kX2lzX3Jkd3Ioc3RydWN0IG1kZGV2
ICptZGRldikKPj4KPj4gICBzdGF0aWMgaW5saW5lIGJvb2wgaXNfbWRfc3VzcGVuZGVkKHN0cnVj
dCBtZGRldiAqbWRkZXYpCj4+ICAgewo+PiAtICAgICAgIHJldHVybiBwZXJjcHVfcmVmX2lzX2R5
aW5nKCZtZGRldi0+YWN0aXZlX2lvKTsKPj4gKyAgICAgICByZXR1cm4gUkVBRF9PTkNFKG1kZGV2
LT5zdXNwZW5kZWQpOwo+PiAgIH0KPj4KPj4gICBzdGF0aWMgaW5saW5lIGludCBfX211c3RfY2hl
Y2sgbWRkZXZfbG9jayhzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+PiAtLQo+PiAyLjM5LjIKPj4KPiAK
PiAuCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

