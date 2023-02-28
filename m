Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBA5C7EE30
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677571148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=drKljz/hsg/cTUUtVgG7qvoCyqzvjCcSAUMza5hJVxg=;
	b=HkccHrB/7HV+rRE7v4pxhR7qNqfs7BOHSsmX1IhfV/Sj1rW+s7IdN02vkFmlwEbuUFJbAM
	gjiWH3AxK/81vzdRDygZ2MQ4qYLx605hTYkJOOOrRHpGCaK/KkDHri5/7jQwOFuSgcQduP
	wM5aI4xEZ8SumVhBv2pIPtiEnw8fEMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-DQ4BOtG_MduYg7cvEbOEJg-1; Tue, 28 Feb 2023 02:59:04 -0500
X-MC-Unique: DQ4BOtG_MduYg7cvEbOEJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA745857A89;
	Tue, 28 Feb 2023 07:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B76112026D68;
	Tue, 28 Feb 2023 07:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DEBD19465B5;
	Tue, 28 Feb 2023 07:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE8591946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 01:41:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C03022026D68; Tue, 28 Feb 2023 01:41:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B84302026D4B
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:41:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 525E33C0F184
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:41:07 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-cNJkRx8COUyE4llgKWXM_Q-1; Mon, 27 Feb 2023 20:41:02 -0500
X-MC-Unique: cNJkRx8COUyE4llgKWXM_Q-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PQg7C3chQz4f3mJN;
 Tue, 28 Feb 2023 09:40:55 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgD3X7OoW_1jyQTOEQ--.60491S3;
 Tue, 28 Feb 2023 09:40:57 +0800 (CST)
Message-ID: <3e31584c-b0f3-fc9a-3657-935fc51db74e@huaweicloud.com>
Date: Tue, 28 Feb 2023 09:40:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Mike Snitzer <snitzer@kernel.org>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com> <Y/zwVCNDrdAbzC7a@redhat.com>
 <Y/zxI4wK8trtuJgV@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <Y/zxI4wK8trtuJgV@redhat.com>
X-CM-TRANSID: gCh0CgD3X7OoW_1jyQTOEQ--.60491S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWrXFyDAry3Xw4UuF4kZwb_yoW5XrW3pF
 Z5WFy5KFWUtr10gwnFga18ZFyFkr17Ga43XrWrW3ZrXr9FvrnagFy7uws0gw1DJFWxCryS
 vF4rZ3srZFy7A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 28 Feb 2023 07:59:00 +0000
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com,
 Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8yLzI4IDI6MDYsIE1pa2UgU25pdHplciDlhpnpgZM6Cj4gT24gTW9uLCBGZWIg
MjcgMjAyMyBhdCAgMTowM1AgLTA1MDAsCj4gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5v
cmc+IHdyb3RlOgo+IAo+PiBPbiBNb24sIEZlYiAyNyAyMDIzIGF0IDEyOjU1UCAtMDUwMCwKPj4g
TWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+Pgo+Pj4gT24gU3VuLCBG
ZWIgMjYgMjAyMyBhdCAgODozMVAgLTA1MDAsCj4+PiB5YW5nZXJrdW4gPHlhbmdlcmt1bkBodWF3
ZWljbG91ZC5jb20+IHdyb3RlOgo+Pj4KPj4+Pgo+Pj4+Cj4+Pj4g5ZyoIDIwMjMvMi8yNiAxMDow
MSwgQmFydCBWYW4gQXNzY2hlIOWGmemBkzoKPj4+Pj4gT24gMi8yMi8yMyAxOToxOSwgeWFuZ2Vy
a3VuIHdyb3RlOgo+Pj4+Pj4gQEAgLTE5MjQsNiArMTkyNiwxMCBAQCBzdGF0aWMgaW50IGRtY3J5
cHRfd3JpdGUodm9pZCAqZGF0YSkKPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgQlVHX09OKHJi
X3BhcmVudCh3cml0ZV90cmVlLnJiX25vZGUpKTsKPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAo
dGltZV9pc19iZWZvcmVfamlmZmllcyhzdGFydF90aW1lICsgSFopKSB7Cj4+Pj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzY2hlZHVsZSgpOwo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3RhcnRfdGltZSA9IGppZmZpZXM7Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgfQo+Pj4+Pgo+
Pj4+PiBXaHkgc2NoZWR1bGUoKSBpbnN0ZWFkIG9mIGNvbmRfcmVzY2hlZCgpPwo+Pj4+Cj4+Pj4g
Y29uZF9yZXNjaGVkIG1heSBub3QgcmVhbGx5IHNjaGVkdWxlLCB3aGljaCBtYXkgdHJpZ2dlciB0
aGUgcHJvYmxlbSB0b28sIGJ1dAo+Pj4+IGl0IHNlZW1zIGFmdGVyIDEgc2Vjb25kLCBpdCBtYXkg
bmV2ZXIgaGFwcGVuZD8KPj4+Cj4+PiBJIGhhZCB0aGUgc2FtZSBxdWVzdGlvbiBhcyBCYXJ0IHdo
ZW4gcmV2aWV3aW5nIHlvdXIgaG9tZWdyb3duCj4+PiBjb25kaXRpb25hbCBzY2hlZHVsZSgpLiAg
SG9wZWZ1bGx5IHlvdSBjYW4gcmVwcm9kdWNlIHRoaXMgaXNzdWU/ICBJZgo+Pj4gc28sIHBsZWFz
ZSBzZWUgaWYgc2ltcGx5IHVzaW5nIGNvbmRfcmVzY2hlZCgpIGZpeGVzIHRoZSBpc3N1ZS4KPj4K
Pj4gVGhpcyBzZWVtcyBsaWtlIGEgbW9yZSBhcHByb3ByaWF0ZSBwYXRjaDoKPj4KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+PiBp
bmRleCA4N2M1NzA2MTMxZjIuLmZhYmExYmU1NzJmOSAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9t
ZC9kbS1jcnlwdC5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+PiBAQCAtMTkzNyw2
ICsxOTM3LDcgQEAgc3RhdGljIGludCBkbWNyeXB0X3dyaXRlKHZvaWQgKmRhdGEpCj4+ICAgCQkJ
aW8gPSBjcnlwdF9pb19mcm9tX25vZGUocmJfZmlyc3QoJndyaXRlX3RyZWUpKTsKPj4gICAJCQly
Yl9lcmFzZSgmaW8tPnJiX25vZGUsICZ3cml0ZV90cmVlKTsKPj4gICAJCQlrY3J5cHRkX2lvX3dy
aXRlKGlvKTsKPj4gKwkJCWNvbmRfcmVzY2hlZCgpOwo+PiAgIAkJfSB3aGlsZSAoIVJCX0VNUFRZ
X1JPT1QoJndyaXRlX3RyZWUpKTsKPj4gICAJCWJsa19maW5pc2hfcGx1ZygmcGx1Zyk7Cj4+ICAg
CX0KPiAKPiAKPiBvcjoKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jIGIv
ZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4gaW5kZXggODdjNTcwNjEzMWYyLi4zYmEyZmQzZTQzNTgg
MTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4gKysrIGIvZHJpdmVycy9tZC9k
bS1jcnlwdC5jCj4gQEAgLTE5MzQsNiArMTkzNCw3IEBAIHN0YXRpYyBpbnQgZG1jcnlwdF93cml0
ZSh2b2lkICpkYXRhKQo+ICAgCQkgKi8KPiAgIAkJYmxrX3N0YXJ0X3BsdWcoJnBsdWcpOwo+ICAg
CQlkbyB7Cj4gKwkJCWNvbmRfcmVzY2hlZCgpOwo+ICAgCQkJaW8gPSBjcnlwdF9pb19mcm9tX25v
ZGUocmJfZmlyc3QoJndyaXRlX3RyZWUpKTsKPiAgIAkJCXJiX2VyYXNlKCZpby0+cmJfbm9kZSwg
JndyaXRlX3RyZWUpOwo+ICAgCQkJa2NyeXB0ZF9pb193cml0ZShpbyk7CgpIaSwKClRoYW5rcyBh
IGxvdCBmb3IgeW91ciByZXZpZXchCgpJdCdzIG9rIHRvIGZpeCB0aGUgc29mdGxvY2t1cCwgYnV0
IGZvciBhc3luYyB3cml0ZSBlbmNyeXB0LCAKa2NyeXB0ZF9jcnlwdF93cml0ZV9pb19zdWJtaXQg
d2lsbCBhZGQgYmlvIHRvIHdyaXRlX3RyZWUsIGFuZCBvbmNlIHdlIApjYWxsIGNvbmRfcmVzY2hl
ZCBiZWZvcmUgZXZlcnkga2NyeXB0ZF9pb193cml0ZSwgdGhlIHdyaXRlIHBlcmZvcm1hbmNlIApt
YXkgYmUgcG9vciB3aGlsZSB3ZSBtZWV0IGEgaGlnaCBjcHUgdXNhZ2Ugc2NlbmUuCgprY3J5cHRk
X2NyeXB0X3dyaXRlX2lvX3N1Ym1pdCB3aWxsIHdha2V1cCB3cml0ZV90aHJlYWQgb25jZSB0aGVy
ZSBpcyBhIAplbXB0eSB3cml0ZV90cmVlLCBhbmQgZG1jcnlwdF93cml0ZSB3aWxsIHBlZWwgdGhl
IG9sZCB3cml0ZV90cmVlIHRvIApzdWJtaXQgYmlvLCBzbyB0aGVyZSBjYW4gbm90IGV4aXN0IHRv
byBtYW55IGJpbyBpbiB3cml0ZV90cmVlLiBUaGVuIEkgCmNob29zZSB5aWVsZCBjcHUgYmVmb3Jl
IHRoZSAnd2hpbGUnIHRoYXQgc3VibWl0IGJpby4uLgoKVGhhbmtzLApLdW4uCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

