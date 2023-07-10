Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB360EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688991828;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4An3aDiXJXDzd9NWalJziy7FqflYDGA7dTzoigRmHzQ=;
	b=icitf/BwT50sp0i4OOza4AlRFyI1xq0injvF2rZqOfODfm1csq8I9XXrCC1ZS3X4Jg3OQy
	xzKxTvUGuxWmuoObiUfzdNwvm1YYpSTAMFOK8bukCNGorUTafb4qa7J/iDQM5QocnFVHue
	Nta1QphtzagYHUWvbGcSaaAWcuKBoFg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-Io_deyqwOVKlO26DwHsEXA-1; Mon, 10 Jul 2023 08:23:45 -0400
X-MC-Unique: Io_deyqwOVKlO26DwHsEXA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27EF2381D1E3;
	Mon, 10 Jul 2023 12:23:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AABC1492B01;
	Mon, 10 Jul 2023 12:23:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7324919465A3;
	Mon, 10 Jul 2023 12:23:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B995D194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Jul 2023 12:23:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7E7F40C2070; Mon, 10 Jul 2023 12:23:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFF0F40C206F
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 12:23:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5983F3C0FC87
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 12:23:00 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-DVOIBTbVNJO4vLGtJcqIYw-1; Mon, 10 Jul 2023 08:22:56 -0400
X-MC-Unique: DVOIBTbVNJO4vLGtJcqIYw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R036y0f9dz4f3lD1;
 Mon, 10 Jul 2023 20:22:50 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP2 (Coremail) with SMTP id Syh0CgA33eoZ+KtkoGJGNg--.16491S3;
 Mon, 10 Jul 2023 20:22:50 +0800 (CST)
Message-ID: <3ebebfcd-6521-efef-deef-688154f71ce1@huaweicloud.com>
Date: Mon, 10 Jul 2023 20:22:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Mike Snitzer <snitzer@kernel.org>
References: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
 <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
 <7f1f7798-dd56-919f-cd59-22cfcafae342@huaweicloud.com>
 <ZKhbclN3V8taEStt@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <ZKhbclN3V8taEStt@redhat.com>
X-CM-TRANSID: Syh0CgA33eoZ+KtkoGJGNg--.16491S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFW8ZFy8tryUuFW7Kw13XFb_yoWxXFW5pF
 s5JF43JrW5Jr18Kr1jqr1UJr9Fyr18J3Z8Jr1xXF18Jr4YvrySgr17Xr1vgry8Ars5Jr4U
 ZF4UJFZrury5ArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkhCgpUaGFua3MgYSBsb3QgZm9yIHlvdXIgcmVtaW5kZXIhIFRoZXJlIGlzIGEgd2Vla2VuZCBh
bmQgaXQgYWxzbyB0YWtlIG1lCnNvbWUgdGltZSB0byB1bmRlcnN0YW5kIHdoYXQgaGFwcGVuZWQg
cmVjZW50bHkgaW4gd29ya3F1ZXVlWzFdWzJdKEkgaGF2ZQphIGxpbWl0ZWQgdW5kZXJzdGFuZGlu
ZyBvZiB3b3JrcXVldWUsIHNvIHRoZSBmb2xsb3dpbmcgc3RhdGVtZW50IG1heSBub3QKYmUgY29y
cmVjdC4uLiksIHNvcnJ5IGZvciB0aGUgbGF0ZSByZXBseSEKCgrlnKggMjAyMy83LzggMjozNywg
TWlrZSBTbml0emVyIOWGmemBkzoKPiBbdG9wLXBvc3RpbmcgYmVjYXVzZSBvZiBhbGwgdGhlIHBy
ZXZpb3VzIHRvcC1wb3N0aW5nXQo+IAo+IEhpLAo+IAo+IEkgY2VydGFpbmx5IHdvdWxkIGxpa2Ug
dGhlIGFiaWxpdHkgdG8gYWxsb3cgY29udHJvbCBvdmVyIHRoZQo+IHdvcmtxdWV1ZXMgdXNpbmcg
V1FfU1lTRlMuICBCdXQgd2l0aCBUZWp1bidzIGxhdGVzdCBXUV9VTkJPVU5EIGNoYW5nZXMKPiAo
anVzdCBtZXJnZWQgZHVyaW5nIDYuNSBtZXJnZSB3aW5kb3cpIEkgdGhpbmsgd2UnZCBkbyB3ZWxs
IHRvIGF1ZGl0Cj4gdGhlIGZsYWdzIHdlJ3JlIHVzaW5nLgo+IAo+IFRlanVuIG9mZmVyZWQgdGhp
cyBub3RlIGluIGhpcyBzdW1tYXJ5IHBhdGNoIGhlYWRlciBmb3IgaGlzIDYuNSBjaGFuZ2VzOgo+
ICJBbGFzZGFpciBLZXJnb24sIE1pa2UgU25pdHplciwgRE0gZm9sa3MKPiAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAKPiBJIHJhbiBmaW8gb24gdG9wIG9mIGRtLWNy
eXB0IHRvIGNvbXBhcmUgcGVyZm9ybWFuY2Ugb2YgZGlmZmVyZW50Cj4gY29uZmlndXJhdGlvbnMu
IEl0IG1vc3RseSBiZWhhdmVkIGFzIGV4cGVjdGVkIGJ1dCBwbGVhc2UgbGV0IG1lIGtub3cgaWYK
PiBhbnl0aGluZyBkb2Vucyd0IGxvb2sgcmlnaHQuIEFsc28sIERNX0NSWVBUX1NBTUVfQ1BVIGNh
biBub3cgYmUgaW1wbGVtZW50ZWQKPiBieSBhcHBseWluZyBzdHJpY3QgImNwdSIgc2NvcGUgb24g
dGhlIHVuYm91bmQgd29ya3F1ZXVlIGFuZCBpdCB3b3VsZCBtYWtlCj4gc2Vuc2UgdG8gYWRkIFdR
X1NZU0ZTIHRvIHRoZSBrY3J5cHRkIHdvcmtxdWV1ZSBzbyB0aGF0IHVzZXJzIGNhbiB0dW5lIHRo
ZQo+IHNldHRpbmdzIG9uIHRoZSBmbHkuIgoKRG9lcyBIZWp1biBtZWFucyB0aGF0IERNX0NSWVBU
X1NBTUVfQ1BVIHdpbGwgdXNlIFdRX0NQVV9JTlRFTlNJVkUgb24KYm91bmRlZCB3b3JrcXVldWUs
IGFuZCB0aGlzIGNhbiB0cmlnZ2VyIHRoZSB3YXJuaW5nIGFkZGVkIGJ5CjYzNjM4NDUwMDUyMCgi
d29ya3F1ZXVlOiBSZXBvcnQgd29yayBmdW5jcyB0aGF0IHRyaWdnZXIgYXV0b21hdGljCkNQVV9J
TlRFTlNJVkUgbWVjaGFuaXNtIiksIHNvIGFkdmljZSBmcm9tIEhlanVuIHdhcyB0aGF0IHdlIGNh
bgppbXBsZW1lbnQgRE1fQ1JZUFRfU0FNRV9DUFUgYnkgYXBwbHlpbmcgc3RyaWN0ICJjcHUiIHNj
b3BlIG9uIHRoZQp1bmJvdW5kIHdvcmtxdWV1ZT8gQnV0IGl0IGRvZXNuJ3Qgc2VlbSB2ZXJ5IGVh
c3kgc2luY2Ugd2hhdApETV9DUllQVF9TQU1FX0NQVSB3YW50IHRvIGRvIHdhcyB1c2luZyB0aGUg
ZXhhY3RseSBjcHUgd2hhdCB3ZSBjYWxsCnF1ZXVlX3dvcmssIGFwcGx5aW5nIHN0cmljdCAiY3B1
IiBjYW4ndCBhY2hpZXZlIHRoZSBzYW1lIGVmZmVjdC4uLgoKPiAKPiBBbnl3YXksIEknZCB3ZWxj
b21lIHlvdSByZWJhc2luZyB5b3VyIHBhdGNoIG9udG9wIG9mIExpbnVzJ3MgbGF0ZXN0Cj4gbGlu
dXguZ2l0LiAgVGhlbiB3ZSAoTWlrdWxhcywgeW91LCBhbmQvb3IgSSkgY2FuIHRha2UgYSBjbG9z
ZXIgbG9vayBhdAo+IGFkZHJlc3NpbmcgVGVqdW4ncyBETV9DUllQVF9TQU1FX0NQVSBzdWdnZXN0
aW9uLgoKRmluZSwgSSB3aWxsIGRvIGl0IGxhdGVyLCBhbmQgdGhhbmtzIGFnYWluIGZvciB5b3Vy
IHJlcGx5IQoKVGhhbmtzLApZYW5nIEVya3VuLgoKPiAKPiBUaGFua3MsCj4gTWlrZQo+IAo+IE9u
IE1vbiwgSnVuIDI2IDIwMjMgYXQgIDQ6NDNQIC0wNDAwLAo+IHlhbmdlcmt1biA8eWFuZ2Vya3Vu
QGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gCj4+IEhpLCBNaWtlLAo+Pgo+PiBTb3JyeSBmb3Ig
dGhlIG5vaXNlLiBUaGlzIHBhdGNoIGhhcyBiZWVuIHByb3Bvc2VkIGZvciBhIGxvbmcgdGltZS4g
SSB3b25kZXIKPj4gZG9lcyB0aGVyZSBhbnkgc3VnZ2VzdGlvbiBmb3IgdGhlIHBhdGNoLiBMb29r
aW5nIGZvcndhcmQgdG8geW91ciByZXBseSEKPj4KPj4gVGhhbmtzLAo+PiBZYW5nIEVya3VuLgo+
Pgo+PiDlnKggMjAyMy8zLzI1IDk6MDEsIHlhbmdlcmt1biDlhpnpgZM6Cj4+PiBQaW5nLi4uCj4+
Pgo+Pj4g5ZyoIDIwMjMvMy8xIDExOjI5LCB5YW5nZXJrdW4g5YaZ6YGTOgo+Pj4+IEZyb206IHlh
bmdlcmt1biA8eWFuZ2Vya3VuQGh1YXdlaS5jb20+Cj4+Pj4KPj4+PiBPbmNlIHRoZXJlIGlzIGEg
aGVhdnkgSU8gbG9hZCwgc28gbWFueSBlbmNyeXB0L2RlY3J5cHQgd29yayB3aWxsIG9jY3VweQo+
Pj4+IGFsbCBvZiB0aGUgY3B1LCB3aGljaCBtYXkgbGVhZCB0aGUgcG9vciBwZXJmb3JtYW5jZSBm
b3Igb3RoZXIgc2VydmljZS4KPj4+PiBTbyB0aGUgaWRlYSBsaWtlICdhMmI4YjJkOTc1NjcgKCJk
bSBjcnlwdDogZXhwb3J0IHN5c2ZzIG9mIGtjcnlwdGQKPj4+PiB3b3JrcXVldWUiKScgc2FpZCBz
ZWVtcyBuZWNlc3NhcnkuIFdlIGNhbiBleHBvcnQgImtjcnlwdGQiIHdvcmtxdWV1ZQo+Pj4+IHN5
c2ZzLCB0aGUgZW50cnkgbGlrZSBjcHVtYXNrL21heF9hY3RpdmUgYW5kIHNvIG9uIGNhbiBoZWxw
IHVzIHRvIGxpbWl0Cj4+Pj4gdGhlIHVzYWdlIGZvciBlbmNyeXB0L2RlY3J5cHQgd29yay4KPj4+
Pgo+Pj4+IEhvd2V2ZXIsIHRoYXQgY29tbWl0IGRvZXMgbm90IGNvbnNpZGVyIHRoZSByZWxvYWQg
dGFibGUgd2lsbCBjYWxsIC5jdHIKPj4+PiBiZWZvcmUgLmR0ciwgc28gdGhlIHJlbG9hZCBmb3Ig
ZG0tY3J5cHQgd2lsbCBmYWlsIHNpbmNlIHRoZSBzYW1lIHN5c2ZzCj4+Pj4gcHJvYmxlbSwgYW5k
IHRoZW4gd2UgcmV2ZXJ0IHRoYXQgY29tbWl0KCc0OGIwNzc3Y2Q5M2QgKCJSZXZlcnQgImRtCj4+
Pj4gY3J5cHQ6IGV4cG9ydCBzeXNmcyBvZiBrY3J5cHRkIHdvcmtxdWV1ZSIiKScpLgo+Pj4+Cj4+
Pj4gQWN0dWFsbHksIHdoYXQgd2Ugc2hvdWxkIGRvIGlzIGdpdmUgYSB1bmlxdWUgbmFtZSBvbmNl
IHdlIHRyeSByZWxvYWQKPj4+PiB0YWJsZSwgd2UgY2FuIHVzZSBpZGEgdG8gZml4IHRoZSBwcm9i
bGVtLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogeWFuZ2Vya3VuIDx5YW5nZXJrdW5AaHVhd2Vp
LmNvbT4KPj4+PiAtLS0KPj4+PiAgwqAgZHJpdmVycy9tZC9kbS1jcnlwdC5jIHwgMjggKysrKysr
KysrKysrKysrKysrKysrKystLS0tLQo+Pj4+ICDCoCAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0
aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+IHYxLT52MjoKPj4+PiByZXdyaXR0ZW4g
dGhlIGNvbW1pdCBtc2cKPj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWNyeXB0
LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+PiBpbmRleCA0MGNiMTcxOWFlNGQuLjk0OGQx
ZTExZDA2NCAxMDA2NDQKPj4+PiAtLS0gYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+PiArKysg
Yi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4+PiBAQCAtNDcsNiArNDcsOCBAQAo+Pj4+ICDCoCAj
ZGVmaW5lIERNX01TR19QUkVGSVggImNyeXB0Igo+Pj4+ICtzdGF0aWMgREVGSU5FX0lEQShjcnlw
dF9xdWV1ZV9pZGEpOwo+Pj4+ICsKPj4+PiAgwqAgLyoKPj4+PiAgwqDCoCAqIGNvbnRleHQgaG9s
ZGluZyB0aGUgY3VycmVudCBzdGF0ZSBvZiBhIG11bHRpLXBhcnQgY29udmVyc2lvbgo+Pj4+ICDC
oMKgICovCj4+Pj4gQEAgLTE4MCw2ICsxODIsNyBAQCBzdHJ1Y3QgY3J5cHRfY29uZmlnIHsKPj4+
PiAgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBjcnlwdG9fYWVhZCAqKnRmbXNfYWVhZDsKPj4+
PiAgwqDCoMKgwqDCoCB9IGNpcGhlcl90Zm07Cj4+Pj4gIMKgwqDCoMKgwqAgdW5zaWduZWQgaW50
IHRmbXNfY291bnQ7Cj4+Pj4gK8KgwqDCoCBpbnQgY3J5cHRfcXVldWVfaWQ7Cj4+Pj4gIMKgwqDC
oMKgwqAgdW5zaWduZWQgbG9uZyBjaXBoZXJfZmxhZ3M7Cj4+Pj4gIMKgwqDCoMKgwqAgLyoKPj4+
PiBAQCAtMjcwNCw2ICsyNzA3LDkgQEAgc3RhdGljIHZvaWQgY3J5cHRfZHRyKHN0cnVjdCBkbV90
YXJnZXQgKnRpKQo+Pj4+ICDCoMKgwqDCoMKgIGlmIChjYy0+Y3J5cHRfcXVldWUpCj4+Pj4gIMKg
wqDCoMKgwqDCoMKgwqDCoCBkZXN0cm95X3dvcmtxdWV1ZShjYy0+Y3J5cHRfcXVldWUpOwo+Pj4+
ICvCoMKgwqAgaWYgKGNjLT5jcnlwdF9xdWV1ZV9pZCkKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWRh
X2ZyZWUoJmNyeXB0X3F1ZXVlX2lkYSwgY2MtPmNyeXB0X3F1ZXVlX2lkKTsKPj4+PiArCj4+Pj4g
IMKgwqDCoMKgwqAgY3J5cHRfZnJlZV90Zm1zKGNjKTsKPj4+PiAgwqDCoMKgwqDCoCBiaW9zZXRf
ZXhpdCgmY2MtPmJzKTsKPj4+PiBAQCAtMzM0MCwxMiArMzM0NiwyNCBAQCBzdGF0aWMgaW50IGNy
eXB0X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwKPj4+PiB1bnNpZ25lZCBpbnQgYXJnYywgY2hh
ciAqKmFyZ3YpCj4+Pj4gIMKgwqDCoMKgwqAgfQo+Pj4+ICDCoMKgwqDCoMKgIGlmICh0ZXN0X2Jp
dChETV9DUllQVF9TQU1FX0NQVSwgJmNjLT5mbGFncykpCj4+Pj4gLcKgwqDCoMKgwqDCoMKgIGNj
LT5jcnlwdF9xdWV1ZSA9IGFsbG9jX3dvcmtxdWV1ZSgia2NyeXB0ZC8lcyIsCj4+Pj4gV1FfQ1BV
X0lOVEVOU0lWRSB8IFdRX01FTV9SRUNMQUlNLAo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBjYy0+Y3J5
cHRfcXVldWUgPSBhbGxvY193b3JrcXVldWUoImtjcnlwdGQtJXMiLAo+Pj4+IFdRX0NQVV9JTlRF
TlNJVkUgfCBXUV9NRU1fUkVDTEFJTSwKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEsIGRldm5hbWUpOwo+Pj4+IC3CoMKgwqAgZWxz
ZQo+Pj4+IC3CoMKgwqDCoMKgwqDCoCBjYy0+Y3J5cHRfcXVldWUgPSBhbGxvY193b3JrcXVldWUo
ImtjcnlwdGQvJXMiLAo+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBXUV9DUFVfSU5URU5TSVZFIHwgV1FfTUVNX1JFQ0xBSU0gfAo+Pj4+IFdR
X1VOQk9VTkQsCj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIG51bV9vbmxpbmVfY3B1cygpLCBkZXZuYW1lKTsKPj4+PiArwqDCoMKgIGVsc2Ug
ewo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpbnQgaWQgPSBpZGFfYWxsb2NfbWluKCZjcnlwdF9xdWV1
ZV9pZGEsIDEsIEdGUF9LRVJORUwpOwo+Pj4+ICsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGlk
IDwgMCkgewo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRpLT5lcnJvciA9ICJDb3VsZG4n
dCBnZXQga2NyeXB0ZCBxdWV1ZSBpZCI7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
ID0gaWQ7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBiYWQ7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgIH0KPj4+PiArCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGNjLT5jcnlwdF9xdWV1ZV9p
ZCA9IGlkOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBjYy0+Y3J5cHRfcXVldWUgPSBhbGxvY193b3Jr
cXVldWUoImtjcnlwdGQtJXMtJWQiLAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBXUV9DUFVfSU5URU5TSVZFIHwgV1FfTUVNX1JFQ0xBSU0g
fAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBXUV9VTkJPVU5EIHwgV1FfU1lTRlMsCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG51bV9vbmxpbmVfY3B1cygpLCBkZXZuYW1lLCBpZCk7
Cj4+Pj4gK8KgwqDCoCB9Cj4+Pj4gKwo+Pj4+ICDCoMKgwqDCoMKgIGlmICghY2MtPmNyeXB0X3F1
ZXVlKSB7Cj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCB0aS0+ZXJyb3IgPSAiQ291bGRuJ3QgY3Jl
YXRlIGtjcnlwdGQgcXVldWUiOwo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBiYWQ7Cj4+
Pgo+PgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

