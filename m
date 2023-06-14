Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E08EB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 08:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686731354;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RTeZXh4giqL/NhffwpBZc0EPgdw7xZl4XqlECOXEplQ=;
	b=jMz7Z5rcRkrszsBgOhEio8DcqQ8XZv5RWtWMM9mOq7aO1sKP9WddbQjB3OnTixAwinQi4y
	ac66pu4nogQuVor2Mf1Y6ZxYuc/Nms0k5o+vhyQv6IK4Gc/9eNs78wRmM8z+Fw8idtlcD+
	+xv+izhnQdV4aKzcgVH4649rfntlOGU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-mJtRFlEXNF-Cm2tKmskTxQ-1; Wed, 14 Jun 2023 04:29:11 -0400
X-MC-Unique: mJtRFlEXNF-Cm2tKmskTxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 377D71C05ABC;
	Wed, 14 Jun 2023 08:29:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D9A82026D6A;
	Wed, 14 Jun 2023 08:29:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC9A919459F1;
	Wed, 14 Jun 2023 08:29:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD966194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 08:29:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD3942026D6A; Wed, 14 Jun 2023 08:29:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A57212026D49
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 08:29:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88E241C05AB6
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 08:29:06 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-SDdTpAjTPW-Oqf91K9V8_w-1; Wed, 14 Jun 2023 04:29:02 -0400
X-MC-Unique: SDdTpAjTPW-Oqf91K9V8_w-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qgz9405FZz4f48CH;
 Wed, 14 Jun 2023 16:28:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBn0LNHeolkEHGzLg--.64311S3;
 Wed, 14 Jun 2023 16:28:56 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
 <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
 <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
 <CALTww28UapJnK+Xfx7O9uEd5ZH2E7ufPT_7pKY6YYuzTZ0Fbdw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b96ec15b-6102-17bb-2c18-a487f224865b@huaweicloud.com>
Date: Wed, 14 Jun 2023 16:28:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww28UapJnK+Xfx7O9uEd5ZH2E7ufPT_7pKY6YYuzTZ0Fbdw@mail.gmail.com>
X-CM-TRANSID: gCh0CgBn0LNHeolkEHGzLg--.64311S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGrWfXw45WFyrury5GF45KFg_yoW5ur4Dpr
 y8ZF1Utr4jyr4xZ3y0q3WjvrW0y34UXF15Xr9xJry3Jwn5Kw4ftFW7CFW5uFyDZF95Jw4j
 k395tF4fJFZFyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
 dm-devel@redhat.com, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xNCAxNTo1NywgWGlhbyBOaSDlhpnpgZM6Cj4gT24gV2VkLCBKdW4g
MTQsIDIwMjMgYXQgMzozOOKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3
cm90ZToKPj4KPj4gSGksCj4+Cj4+IOWcqCAyMDIzLzA2LzE0IDE1OjEyLCBYaWFvIE5pIOWGmemB
kzoKPj4+IE9uIFdlZCwgSnVuIDE0LCAyMDIzIGF0IDEwOjA04oCvQU0gWXUgS3VhaSA8eXVrdWFp
MUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+Pj4+Cj4+Pj4gSGksCj4+Pj4KPj4+PiDlnKggMjAy
My8wNi8xNCA5OjQ4LCBZdSBLdWFpIOWGmemBkzoKPj4+Pgo+Pj4+Cj4+Pj4+Pgo+Pj4+Pj4gSW4g
dGhlIHBhdGNoLCBzeW5jX3NlcSBpcyBhZGRlZCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkLiBJbgo+
Pj4+Pj4gaWRsZV9zeW5jX3RocmVhZCwgaWYgc3luY19zZXEgaXNuJ3QgZXF1YWwKPj4+Pj4+Cj4+
Pj4+PiBtZGRldi0+c3luY19zZXEsIGl0IHNob3VsZCBtZWFuIHRoZXJlIGlzIHNvbWVvbmUgdGhh
dCBzdG9wcyB0aGUgc3luYwo+Pj4+Pj4gdGhyZWFkIGFscmVhZHksIHJpZ2h0PyBXaHkgZG8KPj4+
Pj4+Cj4+Pj4+PiB5b3Ugc2F5ICduZXcgc3RhcnRlZCBzeW5jIHRocmVhZCcgaGVyZT8KPj4+Pgo+
Pj4+IElmIHNvbWVvbmUgc3RvcHMgdGhlIHN5bmMgdGhyZWFkLCBhbmQgbmV3IHN5bmMgdGhyZWFk
IGlzIG5vdCBzdGFydGVkLAo+Pj4+IHRoZW4gdGhpcyBzeW5jX3NlcSB3b24ndCBtYWtlIGEgZGlm
ZmVyZW5jZSwgYWJvdmUgd2FpdF9ldmVudCgpIHdpbGwgbm90Cj4+Pj4gd2FpdCBiZWNhdXNlICF0
ZXN0X2JpdChNRF9SRUNPVkVSWV9SVU5OSU5HLCAmbWRkZXYtPnJlY292ZXJ5KSB3aWxsIHBhc3Mu
Cj4+Pj4gU28gJ3N5bmNfc2VxJyBpcyBvbmx5IHVzZWQgd2hlbiB0aGUgb2xkIHN5bmMgdGhyZWFk
IHN0b3BzIGFuZCBuZXcgc3luYwo+Pj4+IHRocmVhZCBzdGFydHMsIGFkZCAnc3luY19zZXEnIHdp
bGwgYnlwYXNzIHRoaXMgY2FzZS4KPj4+Cj4+PiBIaQo+Pj4KPj4+IElmIGEgbmV3IHN5bmMgdGhy
ZWFkIHN0YXJ0cywgd2h5IGNhbiBzeW5jX3NlcSBiZSBkaWZmZXJlbnQ/IHN5bmNfc2VxCj4+PiBp
cyBvbmx5IGFkZGVkIGluIG1kX3JlYXBfc3luY190aHJlYWQuIEFuZCB3aGVuIGEgbmV3IHN5bmMg
cmVxdWVzdAo+Pj4gc3RhcnRzLCBpdCBjYW4ndCBzdG9wIHRoZSBzeW5jIHJlcXVlc3QgYWdhaW4/
Cj4+Pgo+Pj4gQWYgZmlyc3QsIHRoZSBzeW5jX3NlcSBpcyAwCj4+Pgo+Pj4gYWRtaW4xCj4+PiBl
Y2hvIGlkbGUgPiBzeW5jX2FjdGlvbgo+Pj4gaWRsZV9zeW5jX3RocmVhZChzeW5jX3NlcSBpcyAx
KQo+Pgo+PiBXYWl0LCBJJ20gY29uZnVzZWQgaGVyZSwgaG93IGNhbiBzeW5jX3NlcSB0byBiZSAx
IGhlcmU/IEkgc3VwcG9zZSB5b3UKPj4gbWVhbiB0aGF0IHRoZXJlIGlzIGEgc3luY190aHJlYWQg
anVzdCBmaW5pc2hlZD8KPiAKPiBIaSBLdWFpCj4gCj4gWWVzLiBCZWNhdXNlIGlkbGVfc3luY190
aHJlYWQgbmVlZHMgdG8gd2FpdCB1bnRpbCBtZF9yZWFwX3N5bmNfdGhyZWFkCj4gZmluaXNoZXMu
IEFuZCBtZF9yZWFwX3N5bmNfdGhyZWFkIGFkZHMgc3luY19zZXEuIERvIEkgdW5kZXJzdGFuZCB5
b3VyCj4gcGF0Y2ggcmlnaHQ/CgpZZXMsIG5vdGVkIHRoYXQgaWRsZV9zeW5jX3RocmVhZCgpIHdp
bGwgb25seSB3YWl0IGlmIE1EX1JFQ09WRVJZX1JVTk5JTkcKaXMgc2V0LgoKPiAKPj4KPj4gVGhl
biB0aGUgcHJvYmxlbSBpcyB0aGF0IGlkbGVfc3luY190aHJlYWQoKSByZWFkIHN5bmNfc2VxIGFm
dGVyIHRoZSBvbGQKPj4gc3luY190aHJlYWQgaXMgZG9uZSwgYW5kIG5ldyBzeW5jX3RocmVhZCBz
dGFydCBiZWZvcmUgd2FpdF9ldmVudCgpIGlzCj4+IGNhbGxlZCwgc2hvdWxkIHdlIHdhaXQgZm9y
IHRoaXMgbmV3IHN5bmNfdGhyZWFkPwo+Pgo+PiBNeSBhbnN3ZXIgaGVyZSBpcyB0aGF0IHdlIHNo
b3VsZCwgYnV0IEknbSBhbHNvIG9rIHRvIG5vdCB3YWl0IHRoaXMgbmV3Cj4+IHN5bmNfdGhyZWFk
LCBJIGRvbid0IHRoaW5rIHRoaXMgYmVoYXZpb3VyIG1hdHRlcnMuIFRoZSBrZXkgcG9pbnQgaGVy
ZQo+PiBpcyB0aGF0IG9uY2Ugd2FpdF9ldmVudCgpIGlzIGNhbGxlZCBmcm9tIGlkbGVfc3luY190
aHJlYWQoKSwgdGhpcwo+PiB3YWl0X2V2ZW50KCkgc2hvdWxkIG5vdCB3YWl0IGZvciBuZXcgc3lu
Y190aHJlYWQuLi4KPiAKPiBJIHRoaW5rIHdlIHNob3VsZCB3YWl0LiBJZiB3ZSBkb24ndCB3YWl0
IGZvciBpdCwgdGhlcmUgaXMgYSBwcm9ibGVtLgo+IE9uZSBwZXJzb24gZWNob3MgaWRsZSB0byBz
eW5jX2FjdGlvbiBhbmQgaXQgZG9lc24ndCB3b3JrIHNvbWV0aW1lcy4KPiBJdCdzIGEgc3RyYW5n
ZSB0aGluZy4KPiAKCk9rLiBJJ2xsIGFkZCBuZXcgY29tbWVudCB0byBlbXBoYXNpemUgdGhhdCBp
ZGxlX3N5bmNfdGhyZWFkKCkgd29uJ3Qgd2FpdApmb3IgbmV3IHN5bmNfdGhyZWFkIHRoYXQgaXMg
c3RhcnRlZCBhZnRlciB3YWl0X2V2ZW50KCkuCgo+Pgo+Pj4gZWNobyByZXN5bmMgPiBzeW5jX2Fj
dGlvbiAobmV3IHN5bmMpCj4+Cj4+IElmIHRoaXMgaXMgYmVoaW5kICJlY2hvIGlkbGUgPiBzeW5j
X2FjdGlvbiIsIGlkbGVfc3luY190aHJlYWQgc2hvdWxkIG5vdAo+PiBzZWUgdGhhdCBNRF9SRUNP
VkVSWV9SVU5OSU5HIGlzIHNldCBhbmQgd2FpdF9ldmVudCgpIHdvbid0IHdhaXQgYXQgYWxsLgo+
IAo+IGBlY2hvIHJlc3luYyA+IHN5bmNfYWN0aW9uYCBjYW4ndCBjaGFuZ2UgdGhlIHN5bmNfc2Vx
LiBTbyAnZWNobyBpZGxlID4KPiBzeW5jX2FjdGlvbicgc3RpbGwgd2FpdHMgdW50aWwgTURfUkVD
T1ZFUllfUlVOTklORyBpcyBjbGVhcmVkPwoKVGhpcyBpcyBub3QgYWNjdXJhdGUsIGlmIGBlY2hv
IHJlc3luYyA+IHN5bmNfYWN0aW9uYCB0cmlnZ2VycyBhIG5ldwpzeW5jX3RocmVhZCwgdGhlbiBz
eW5jX3NlcSBpcyB1cGRhdGVkIHdoZW4gdGhpcyBzeW5jX3RocmVhZCBpcyBkb25lLApkdXJpbmcg
dGhpcyBwZXJpb2QsIE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgc3RpbGwgc2V0LCBzbyBgZWNobyBp
ZGxlCiA+c3luY19hY3Rpb25gIHdpbGwgd2FpdCBmb3Igc3luY190aHJlYWQgdG8gYmUgZG9uZS4K
ClRoYW5rcywKS3VhaQo+IAo+IFJlZ2FyZHMKPiBYaWFvCj4gCj4+Cj4+IFRoYW5rcywKPj4gS3Vh
aQo+Pj4KPj4+IFRoZW4gYWRtaW4yIGVjaG9zIGlkbGUgPiBzeW5jX2FjdGlvbiwgc3luY19zZXEg
aXMgc3RpbGwgMQo+Pj4KPj4+IFJlZ2FyZHMKPj4+IFhpYW8KPj4+Cj4+Pj4KPj4+PiBUaGFua3Ms
Cj4+Pj4gS3VhaQo+Pj4+Cj4+Pgo+Pj4gLgo+Pj4KPj4KPiAKPiAuCj4gCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

