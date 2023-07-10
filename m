Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1792EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688991930;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8yQLMbpty46NvujXPIg0KaPWWHHobh7AZyO+351q6nk=;
	b=ZzUUvUJq8KUth+X15UN/6btbDVEXS+NJydMMp4smjGALMM0prwqeu/47RGP46u1/EcPGe+
	bn54+J68Si0Cf1065xdwOyYEA7Ld/zoHDGRqSjybHH3b+ukBmSoht4XlhuMrnGfnxti9aC
	ZmeLRTYYdVvToJH4xb9dn4/nPpaHwMc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-HsmyhsvvND26YK6bbOoO3g-1; Mon, 10 Jul 2023 08:25:27 -0400
X-MC-Unique: HsmyhsvvND26YK6bbOoO3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86CE4381D1E1;
	Mon, 10 Jul 2023 12:25:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B827111CB82;
	Mon, 10 Jul 2023 12:25:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2357119465A3;
	Mon, 10 Jul 2023 12:25:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58EE9194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Jul 2023 12:25:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 392244CD0C6; Mon, 10 Jul 2023 12:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31A84492C13
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 12:25:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1341B185A791
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 12:25:19 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-rXfUksD-O1iM0jz0Ezsn0Q-1; Mon, 10 Jul 2023 08:25:13 -0400
X-MC-Unique: rXfUksD-O1iM0jz0Ezsn0Q-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4R039X5Dvfz4f3nwq;
 Mon, 10 Jul 2023 20:25:04 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP2 (Coremail) with SMTP id Syh0CgBHJtSg+Ktk14FGNg--.31339S3;
 Mon, 10 Jul 2023 20:25:05 +0800 (CST)
Message-ID: <d940f160-805c-fe20-538a-e3c0c23257e6@huaweicloud.com>
Date: Mon, 10 Jul 2023 20:25:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From: yangerkun <yangerkun@huaweicloud.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
 <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
 <7f1f7798-dd56-919f-cd59-22cfcafae342@huaweicloud.com>
 <ZKhbclN3V8taEStt@redhat.com>
 <3ebebfcd-6521-efef-deef-688154f71ce1@huaweicloud.com>
In-Reply-To: <3ebebfcd-6521-efef-deef-688154f71ce1@huaweicloud.com>
X-CM-TRANSID: Syh0CgBHJtSg+Ktk14FGNg--.31339S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1rtFy5ZF17ZFyrZryDtrb_yoWxZw4UpF
 n5JF43JrW5Jr18Kr1Utr1UJry7tr18J3Z8Xr1xXF18Grs0vrySgr17Xr1vgry8Ar4kJr4U
 ZF4UJF9rZryUArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
 1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbPEf5UUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: reexport sysfs of kcryptd
 workqueue
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
Cc: tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com,
 jefflexu@linux.alibaba.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy83LzEwIDIwOjIyLCB5YW5nZXJrdW4g5YaZ6YGTOgo+IEhpIQo+IAo+IFRoYW5r
cyBhIGxvdCBmb3IgeW91ciByZW1pbmRlciEgVGhlcmUgaXMgYSB3ZWVrZW5kIGFuZCBpdCBhbHNv
IHRha2UgbWUKPiBzb21lIHRpbWUgdG8gdW5kZXJzdGFuZCB3aGF0IGhhcHBlbmVkIHJlY2VudGx5
IGluIHdvcmtxdWV1ZVsxXVsyXShJIGhhdmUKPiBhIGxpbWl0ZWQgdW5kZXJzdGFuZGluZyBvZiB3
b3JrcXVldWUsIHNvIHRoZSBmb2xsb3dpbmcgc3RhdGVtZW50IG1heSBub3QKPiBiZSBjb3JyZWN0
Li4uKSwgc29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5IQoKRm9yZ2V0IHRvIGFkZCB0aGUgbGluay4u
LiBTb3JyeS4uLgoKWzFdLiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL1pKb0ctQnB0Y0dv
SElJMzVAc2xtLmR1Y2tkbnMub3JnL1QvClsyXS4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC8yMDIzMDUxOTAwMTcwOS4yNTYzLTgtdGpAa2VybmVsLm9yZy9ULwoKPiAKPiAKPiDlnKggMjAy
My83LzggMjozNywgTWlrZSBTbml0emVyIOWGmemBkzoKPj4gW3RvcC1wb3N0aW5nIGJlY2F1c2Ug
b2YgYWxsIHRoZSBwcmV2aW91cyB0b3AtcG9zdGluZ10KPj4KPj4gSGksCj4+Cj4+IEkgY2VydGFp
bmx5IHdvdWxkIGxpa2UgdGhlIGFiaWxpdHkgdG8gYWxsb3cgY29udHJvbCBvdmVyIHRoZQo+PiB3
b3JrcXVldWVzIHVzaW5nIFdRX1NZU0ZTLsKgIEJ1dCB3aXRoIFRlanVuJ3MgbGF0ZXN0IFdRX1VO
Qk9VTkQgY2hhbmdlcwo+PiAoanVzdCBtZXJnZWQgZHVyaW5nIDYuNSBtZXJnZSB3aW5kb3cpIEkg
dGhpbmsgd2UnZCBkbyB3ZWxsIHRvIGF1ZGl0Cj4+IHRoZSBmbGFncyB3ZSdyZSB1c2luZy4KPj4K
Pj4gVGVqdW4gb2ZmZXJlZCB0aGlzIG5vdGUgaW4gaGlzIHN1bW1hcnkgcGF0Y2ggaGVhZGVyIGZv
ciBoaXMgNi41IGNoYW5nZXM6Cj4+ICJBbGFzZGFpciBLZXJnb24sIE1pa2UgU25pdHplciwgRE0g
Zm9sa3MKPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4+Cj4+IEkg
cmFuIGZpbyBvbiB0b3Agb2YgZG0tY3J5cHQgdG8gY29tcGFyZSBwZXJmb3JtYW5jZSBvZiBkaWZm
ZXJlbnQKPj4gY29uZmlndXJhdGlvbnMuIEl0IG1vc3RseSBiZWhhdmVkIGFzIGV4cGVjdGVkIGJ1
dCBwbGVhc2UgbGV0IG1lIGtub3cgaWYKPj4gYW55dGhpbmcgZG9lbnMndCBsb29rIHJpZ2h0LiBB
bHNvLCBETV9DUllQVF9TQU1FX0NQVSBjYW4gbm93IGJlIAo+PiBpbXBsZW1lbnRlZAo+PiBieSBh
cHBseWluZyBzdHJpY3QgImNwdSIgc2NvcGUgb24gdGhlIHVuYm91bmQgd29ya3F1ZXVlIGFuZCBp
dCB3b3VsZCBtYWtlCj4+IHNlbnNlIHRvIGFkZCBXUV9TWVNGUyB0byB0aGUga2NyeXB0ZCB3b3Jr
cXVldWUgc28gdGhhdCB1c2VycyBjYW4gdHVuZSB0aGUKPj4gc2V0dGluZ3Mgb24gdGhlIGZseS4i
Cj4gCj4gRG9lcyBIZWp1biBtZWFucyB0aGF0IERNX0NSWVBUX1NBTUVfQ1BVIHdpbGwgdXNlIFdR
X0NQVV9JTlRFTlNJVkUgb24KPiBib3VuZGVkIHdvcmtxdWV1ZSwgYW5kIHRoaXMgY2FuIHRyaWdn
ZXIgdGhlIHdhcm5pbmcgYWRkZWQgYnkKPiA2MzYzODQ1MDA1MjAoIndvcmtxdWV1ZTogUmVwb3J0
IHdvcmsgZnVuY3MgdGhhdCB0cmlnZ2VyIGF1dG9tYXRpYwo+IENQVV9JTlRFTlNJVkUgbWVjaGFu
aXNtIiksIHNvIGFkdmljZSBmcm9tIEhlanVuIHdhcyB0aGF0IHdlIGNhbgo+IGltcGxlbWVudCBE
TV9DUllQVF9TQU1FX0NQVSBieSBhcHBseWluZyBzdHJpY3QgImNwdSIgc2NvcGUgb24gdGhlCj4g
dW5ib3VuZCB3b3JrcXVldWU/IEJ1dCBpdCBkb2Vzbid0IHNlZW0gdmVyeSBlYXN5IHNpbmNlIHdo
YXQKPiBETV9DUllQVF9TQU1FX0NQVSB3YW50IHRvIGRvIHdhcyB1c2luZyB0aGUgZXhhY3RseSBj
cHUgd2hhdCB3ZSBjYWxsCj4gcXVldWVfd29yaywgYXBwbHlpbmcgc3RyaWN0ICJjcHUiIGNhbid0
IGFjaGlldmUgdGhlIHNhbWUgZWZmZWN0Li4uCj4gCj4+Cj4+IEFueXdheSwgSSdkIHdlbGNvbWUg
eW91IHJlYmFzaW5nIHlvdXIgcGF0Y2ggb250b3Agb2YgTGludXMncyBsYXRlc3QKPj4gbGludXgu
Z2l0LsKgIFRoZW4gd2UgKE1pa3VsYXMsIHlvdSwgYW5kL29yIEkpIGNhbiB0YWtlIGEgY2xvc2Vy
IGxvb2sgYXQKPj4gYWRkcmVzc2luZyBUZWp1bidzIERNX0NSWVBUX1NBTUVfQ1BVIHN1Z2dlc3Rp
b24uCj4gCj4gRmluZSwgSSB3aWxsIGRvIGl0IGxhdGVyLCBhbmQgdGhhbmtzIGFnYWluIGZvciB5
b3VyIHJlcGx5IQo+IAo+IFRoYW5rcywKPiBZYW5nIEVya3VuLgo+IAo+Pgo+PiBUaGFua3MsCj4+
IE1pa2UKPj4KPj4gT24gTW9uLCBKdW4gMjYgMjAyMyBhdMKgIDQ6NDNQIC0wNDAwLAo+PiB5YW5n
ZXJrdW4gPHlhbmdlcmt1bkBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+Pgo+Pj4gSGksIE1pa2Us
Cj4+Pgo+Pj4gU29ycnkgZm9yIHRoZSBub2lzZS4gVGhpcyBwYXRjaCBoYXMgYmVlbiBwcm9wb3Nl
ZCBmb3IgYSBsb25nIHRpbWUuIEkgCj4+PiB3b25kZXIKPj4+IGRvZXMgdGhlcmUgYW55IHN1Z2dl
c3Rpb24gZm9yIHRoZSBwYXRjaC4gTG9va2luZyBmb3J3YXJkIHRvIHlvdXIgcmVwbHkhCj4+Pgo+
Pj4gVGhhbmtzLAo+Pj4gWWFuZyBFcmt1bi4KPj4+Cj4+PiDlnKggMjAyMy8zLzI1IDk6MDEsIHlh
bmdlcmt1biDlhpnpgZM6Cj4+Pj4gUGluZy4uLgo+Pj4+Cj4+Pj4g5ZyoIDIwMjMvMy8xIDExOjI5
LCB5YW5nZXJrdW4g5YaZ6YGTOgo+Pj4+PiBGcm9tOiB5YW5nZXJrdW4gPHlhbmdlcmt1bkBodWF3
ZWkuY29tPgo+Pj4+Pgo+Pj4+PiBPbmNlIHRoZXJlIGlzIGEgaGVhdnkgSU8gbG9hZCwgc28gbWFu
eSBlbmNyeXB0L2RlY3J5cHQgd29yayB3aWxsIAo+Pj4+PiBvY2N1cHkKPj4+Pj4gYWxsIG9mIHRo
ZSBjcHUsIHdoaWNoIG1heSBsZWFkIHRoZSBwb29yIHBlcmZvcm1hbmNlIGZvciBvdGhlciBzZXJ2
aWNlLgo+Pj4+PiBTbyB0aGUgaWRlYSBsaWtlICdhMmI4YjJkOTc1NjcgKCJkbSBjcnlwdDogZXhw
b3J0IHN5c2ZzIG9mIGtjcnlwdGQKPj4+Pj4gd29ya3F1ZXVlIiknIHNhaWQgc2VlbXMgbmVjZXNz
YXJ5LiBXZSBjYW4gZXhwb3J0ICJrY3J5cHRkIiB3b3JrcXVldWUKPj4+Pj4gc3lzZnMsIHRoZSBl
bnRyeSBsaWtlIGNwdW1hc2svbWF4X2FjdGl2ZSBhbmQgc28gb24gY2FuIGhlbHAgdXMgdG8gCj4+
Pj4+IGxpbWl0Cj4+Pj4+IHRoZSB1c2FnZSBmb3IgZW5jcnlwdC9kZWNyeXB0IHdvcmsuCj4+Pj4+
Cj4+Pj4+IEhvd2V2ZXIsIHRoYXQgY29tbWl0IGRvZXMgbm90IGNvbnNpZGVyIHRoZSByZWxvYWQg
dGFibGUgd2lsbCBjYWxsIC5jdHIKPj4+Pj4gYmVmb3JlIC5kdHIsIHNvIHRoZSByZWxvYWQgZm9y
IGRtLWNyeXB0IHdpbGwgZmFpbCBzaW5jZSB0aGUgc2FtZSBzeXNmcwo+Pj4+PiBwcm9ibGVtLCBh
bmQgdGhlbiB3ZSByZXZlcnQgdGhhdCBjb21taXQoJzQ4YjA3NzdjZDkzZCAoIlJldmVydCAiZG0K
Pj4+Pj4gY3J5cHQ6IGV4cG9ydCBzeXNmcyBvZiBrY3J5cHRkIHdvcmtxdWV1ZSIiKScpLgo+Pj4+
Pgo+Pj4+PiBBY3R1YWxseSwgd2hhdCB3ZSBzaG91bGQgZG8gaXMgZ2l2ZSBhIHVuaXF1ZSBuYW1l
IG9uY2Ugd2UgdHJ5IHJlbG9hZAo+Pj4+PiB0YWJsZSwgd2UgY2FuIHVzZSBpZGEgdG8gZml4IHRo
ZSBwcm9ibGVtLgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiB5YW5nZXJrdW4gPHlhbmdlcmt1
bkBodWF3ZWkuY29tPgo+Pj4+PiAtLS0KPj4+Pj4gwqDCoCBkcml2ZXJzL21kL2RtLWNyeXB0LmMg
fCAyOCArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tCj4+Pj4+IMKgwqAgMSBmaWxlIGNoYW5n
ZWQsIDIzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4+Pj4+Cj4+Pj4+IHYxLT52MjoK
Pj4+Pj4gcmV3cml0dGVuIHRoZSBjb21taXQgbXNnCj4+Pj4+Cj4+Pj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL21kL2RtLWNyeXB0LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+Pj4gaW5kZXgg
NDBjYjE3MTlhZTRkLi45NDhkMWUxMWQwNjQgMTAwNjQ0Cj4+Pj4+IC0tLSBhL2RyaXZlcnMvbWQv
ZG0tY3J5cHQuYwo+Pj4+PiArKysgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+Pj4gQEAgLTQ3
LDYgKzQ3LDggQEAKPj4+Pj4gwqDCoCAjZGVmaW5lIERNX01TR19QUkVGSVggImNyeXB0Igo+Pj4+
PiArc3RhdGljIERFRklORV9JREEoY3J5cHRfcXVldWVfaWRhKTsKPj4+Pj4gKwo+Pj4+PiDCoMKg
IC8qCj4+Pj4+IMKgwqDCoCAqIGNvbnRleHQgaG9sZGluZyB0aGUgY3VycmVudCBzdGF0ZSBvZiBh
IG11bHRpLXBhcnQgY29udmVyc2lvbgo+Pj4+PiDCoMKgwqAgKi8KPj4+Pj4gQEAgLTE4MCw2ICsx
ODIsNyBAQCBzdHJ1Y3QgY3J5cHRfY29uZmlnIHsKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c3RydWN0IGNyeXB0b19hZWFkICoqdGZtc19hZWFkOwo+Pj4+PiDCoMKgwqDCoMKgwqAgfSBjaXBo
ZXJfdGZtOwo+Pj4+PiDCoMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHRmbXNfY291bnQ7Cj4+Pj4+
ICvCoMKgwqAgaW50IGNyeXB0X3F1ZXVlX2lkOwo+Pj4+PiDCoMKgwqDCoMKgwqAgdW5zaWduZWQg
bG9uZyBjaXBoZXJfZmxhZ3M7Cj4+Pj4+IMKgwqDCoMKgwqDCoCAvKgo+Pj4+PiBAQCAtMjcwNCw2
ICsyNzA3LDkgQEAgc3RhdGljIHZvaWQgY3J5cHRfZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRpKQo+
Pj4+PiDCoMKgwqDCoMKgwqAgaWYgKGNjLT5jcnlwdF9xdWV1ZSkKPj4+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZGVzdHJveV93b3JrcXVldWUoY2MtPmNyeXB0X3F1ZXVlKTsKPj4+Pj4gK8KgwqDC
oCBpZiAoY2MtPmNyeXB0X3F1ZXVlX2lkKQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWRhX2ZyZWUo
JmNyeXB0X3F1ZXVlX2lkYSwgY2MtPmNyeXB0X3F1ZXVlX2lkKTsKPj4+Pj4gKwo+Pj4+PiDCoMKg
wqDCoMKgwqAgY3J5cHRfZnJlZV90Zm1zKGNjKTsKPj4+Pj4gwqDCoMKgwqDCoMKgIGJpb3NldF9l
eGl0KCZjYy0+YnMpOwo+Pj4+PiBAQCAtMzM0MCwxMiArMzM0NiwyNCBAQCBzdGF0aWMgaW50IGNy
eXB0X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwKPj4+Pj4gdW5zaWduZWQgaW50IGFyZ2MsIGNo
YXIgKiphcmd2KQo+Pj4+PiDCoMKgwqDCoMKgwqAgfQo+Pj4+PiDCoMKgwqDCoMKgwqAgaWYgKHRl
c3RfYml0KERNX0NSWVBUX1NBTUVfQ1BVLCAmY2MtPmZsYWdzKSkKPj4+Pj4gLcKgwqDCoMKgwqDC
oMKgIGNjLT5jcnlwdF9xdWV1ZSA9IGFsbG9jX3dvcmtxdWV1ZSgia2NyeXB0ZC8lcyIsCj4+Pj4+
IFdRX0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVDTEFJTSwKPj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IGNjLT5jcnlwdF9xdWV1ZSA9IGFsbG9jX3dvcmtxdWV1ZSgia2NyeXB0ZC0lcyIsCj4+Pj4+IFdR
X0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVDTEFJTSwKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMSwgZGV2bmFtZSk7Cj4+Pj4+
IC3CoMKgwqAgZWxzZQo+Pj4+PiAtwqDCoMKgwqDCoMKgwqAgY2MtPmNyeXB0X3F1ZXVlID0gYWxs
b2Nfd29ya3F1ZXVlKCJrY3J5cHRkLyVzIiwKPj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdRX0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVD
TEFJTSB8Cj4+Pj4+IFdRX1VOQk9VTkQsCj4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBudW1fb25saW5lX2NwdXMoKSwgZGV2bmFtZSk7Cj4+
Pj4+ICvCoMKgwqAgZWxzZSB7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpbnQgaWQgPSBpZGFfYWxs
b2NfbWluKCZjcnlwdF9xdWV1ZV9pZGEsIDEsIEdGUF9LRVJORUwpOwo+Pj4+PiArCj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoCBpZiAoaWQgPCAwKSB7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHRpLT5lcnJvciA9ICJDb3VsZG4ndCBnZXQga2NyeXB0ZCBxdWV1ZSBpZCI7Cj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IGlkOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBnb3RvIGJhZDsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+Pj4gKwo+Pj4+PiArwqDCoMKg
wqDCoMKgwqAgY2MtPmNyeXB0X3F1ZXVlX2lkID0gaWQ7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBj
Yy0+Y3J5cHRfcXVldWUgPSBhbGxvY193b3JrcXVldWUoImtjcnlwdGQtJXMtJWQiLAo+Pj4+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgV1FfQ1BV
X0lOVEVOU0lWRSB8IFdRX01FTV9SRUNMQUlNIHwKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdRX1VOQk9VTkQgfCBXUV9TWVNGUywKPj4+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG51
bV9vbmxpbmVfY3B1cygpLCBkZXZuYW1lLCBpZCk7Cj4+Pj4+ICvCoMKgwqAgfQo+Pj4+PiArCj4+
Pj4+IMKgwqDCoMKgwqDCoCBpZiAoIWNjLT5jcnlwdF9xdWV1ZSkgewo+Pj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB0aS0+ZXJyb3IgPSAiQ291bGRuJ3QgY3JlYXRlIGtjcnlwdGQgcXVldWUiOwo+
Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGJhZDsKPj4+Pgo+Pj4KCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

