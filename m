Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A282DC38A2D
	for <dm-devel@archiver.kernel.org>; Wed, 26 Oct 2022 07:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666767780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UORver32/ZffRF0k+QtaoiHgu5UMdKOZAZlY/JetoS0=;
	b=JpyvDkdFXQXAaoz0S5eCvXUx5M+RfUgaMHcguJqmEzgJJ0qZB/r3j6bAJVmjHnQscRyKBn
	KgMLuZ1E/KQubYcOYDoIQxKRAdaJyuYkT9fyYyZ+cRy5CHHxzg1raGwK0dsFvnFRuucKt0
	iTHejGQoUX7sXqBkVhB9RzWV9lOOUYo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-Yvl-Y621NUWy_v0Nqx6vEg-1; Wed, 26 Oct 2022 03:02:58 -0400
X-MC-Unique: Yvl-Y621NUWy_v0Nqx6vEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64351810B3E;
	Wed, 26 Oct 2022 07:02:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 027FF4EA55;
	Wed, 26 Oct 2022 07:02:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D8F119465A4;
	Wed, 26 Oct 2022 07:02:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6B7B1946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Oct 2022 14:00:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B427A20290A2; Tue, 25 Oct 2022 14:00:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACD672028E98
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 14:00:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B8BE1C0A10F
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 14:00:54 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-nkjQDMnKP6OkJbs2pb5xQA-1; Tue, 25 Oct 2022 10:00:49 -0400
X-MC-Unique: nkjQDMnKP6OkJbs2pb5xQA-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MxYS75FVkz6SBTS;
 Tue, 25 Oct 2022 21:58:15 +0800 (CST)
Received: from [10.174.176.127] (unknown [10.174.176.127])
 by APP2 (Coremail) with SMTP id Syh0CgDnzdII7FdjpuBNAw--.20681S2;
 Tue, 25 Oct 2022 22:00:42 +0800 (CST)
To: Mike Snitzer <snitzer@redhat.com>
References: <20221010143905.240306-1-luomeng@huaweicloud.com>
 <Y02vOFnwZOHPrVY8@redhat.com>
 <bab8c5aa-9b12-b330-9c3b-fdd5ce4cd1b8@huaweicloud.com>
 <Y1BSo+9D7QP0y/Pi@redhat.com>
From: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <b8b38a03-17da-0809-5050-6edb39b53a53@huaweicloud.com>
Date: Tue, 25 Oct 2022 22:00:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <Y1BSo+9D7QP0y/Pi@redhat.com>
X-CM-TRANSID: Syh0CgDnzdII7FdjpuBNAw--.20681S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw1fAr4kuFW3Cr1kGFyDZFb_yoW7GF1xp3
 yrGayjkw4rXr1jkw1vqw4jvF10yayftayUWr15JFyfu3s2vry3JFyUJFy5WF95ZFy8Jr4S
 qF15tay3uFyYyF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 26 Oct 2022 07:02:40 +0000
Subject: Re: [dm-devel] dm: Fix UAF in run_timer_softirq()
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
Cc: snitzer@kernel.org, ejt@redhat.com, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMi8xMC8yMCAzOjQwLCBNaWtlIFNuaXR6ZXIg5YaZ6YGTOgo+IE9uIFR1ZSwgT2N0
IDE4IDIwMjIgYXQgIDQ6MTdQIC0wNDAwLAo+IEx1byBNZW5nIDxsdW9tZW5nQGh1YXdlaWNsb3Vk
LmNvbT4gd3JvdGU6Cj4gCj4+Cj4+Cj4+IOWcqCAyMDIyLzEwLzE4IDM6MzgsIE1pa2UgU25pdHpl
ciDlhpnpgZM6Cj4+PiBPbiBNb24sIE9jdCAxMCAyMDIyIGF0IDEwOjM5UCAtMDQwMCwKPj4+IEx1
byBNZW5nIDxsdW9tZW5nQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4+Pgo+Pj4+IEZyb206IEx1
byBNZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbT4KPj4+Pgo+Pj4+IFdoZW4gZG1fcmVzdW1lKCkg
YW5kIGRtX2Rlc3Ryb3koKSBhcmUgY29uY3VycmVudCwgaXQgd2lsbAo+Pj4+IGxlYWQgdG8gVUFG
Lgo+Pj4+Cj4+Pj4gT25lIG9mIHRoZSBjb25jdXJyZW5jeSBVQUYgY2FuIGJlIHNob3duIGFzIGJl
bG93Ogo+Pj4+Cj4+Pj4gICAgICAgICAgIHVzZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBmcmVlCj4+Pj4gZG9fcmVzdW1lICAgICAgICAgICAgICAgICAgICAgICAgICAgfAo+Pj4+
ICAgICBfX2ZpbmRfZGV2aWNlX2hhc2hfY2VsbCAgICAgICAgICAgfAo+Pj4+ICAgICAgIGRtX2dl
dCAgICAgICAgICAgICAgICAgICAgICAgICAgfAo+Pj4+ICAgICAgICAgYXRvbWljX2luYygmbWQt
PmhvbGRlcnMpICAgICAgfAo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCBkbV9kZXN0cm95Cj4+Pj4gCQkJCSAgICB8ICAgX19kbV9kZXN0cm95Cj4+Pj4gCQkJCSAg
ICB8ICAgICBpZiAoIWRtX3N1c3BlbmRlZF9tZChtZCkpCj4+Pj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgICBhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMpCj4+Pj4g
CQkJCSAgICB8ICAgICBtc2xlZXAoMSkKPj4+PiAgICAgZG1fcmVzdW1lICAgICAgICAgICAgICAg
ICAgICAgICAgIHwKPj4+PiAgICAgICBfX2RtX3Jlc3VtZSAgICAgICAgICAgICAgICAgICAgIHwK
Pj4+PiAgICAgICAgIGRtX3RhYmxlX3Jlc3VtZV90YXJnZXRzICAgICAgIHwKPj4+PiAJcG9vbF9y
ZXN1bWUgICAgICAgICAgICAgICAgIHwKPj4+PiAJICBkb193YWtlciAgI2FkZCBkZWxheSB3b3Jr
IHwKPj4+PiAJCQkJICAgIHwgICAgIGRtX3RhYmxlX2Rlc3Ryb3kKPj4+PiAJCQkJICAgIHwgICAg
ICAgcG9vbF9kdHIKPj4+PiAJCQkJICAgIHwgICAgICAgICBfX3Bvb2xfZGVjCj4+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICBfX3Bvb2xfZGVzdHJv
eQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAg
ICBkZXN0cm95X3dvcmtxdWV1ZQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICBrZnJlZShwb29sKSAjIGZyZWUgcG9vbAo+Pj4+IAl0aW1lIG91
dAo+Pj4+IF9fZG9fc29mdGlycQo+Pj4+ICAgICBydW5fdGltZXJfc29mdGlycSAjIHBvb2wgaGFz
IGFscmVhZHkgYmVlbiBmcmVlZAo+Pj4+Cj4+Pj4gVGhpcyBjYW4gYmUgZWFzaWx5IHJlcHJvZHVj
ZWQgdXNpbmc6Cj4+Pj4gICAgIDEuIGNyZWF0ZSB0aGluLXBvb2wKPj4+PiAgICAgMi4gZG1zZXR1
cCBzdXNwZW5kIHBvb2wKPj4+PiAgICAgMy4gZG1zZXR1cCByZXN1bWUgcG9vbAo+Pj4+ICAgICA0
LiBkbXNldHVwIHJlbW92ZV9hbGwgIyBDb25jdXJyZW50IHdpdGggMwo+Pj4+Cj4+Pj4gVGhlIHJv
b3QgY2F1c2Ugb2YgVUFGIGJ1Z3MgaXMgdGhhdCBkbV9yZXN1bWUoKSBhZGRzIHRpbWVyIGFmdGVy
Cj4+Pj4gZG1fZGVzdHJveSgpIHNraXBzIGNhbmNlbCB0aW1lciBiZWF1c2Ugb2Ygc3VzcGVuZCBz
dGF0dXMuIEFmdGVyCj4+Pj4gdGltZW91dCwgaXQgd2lsbCBjYWxsIHJ1bl90aW1lcl9zb2Z0aXJx
KCksIGhvd2V2ZXIgcG9vbCBoYXMgYWxyZWFkeQo+Pj4+IGJlZW4gZnJlZWQuIFRoZSBjb25jdXJy
ZW5jeSBVQUYgYnVnIHdpbGwgaGFwcGVuLgo+Pj4+Cj4+Pj4gVGhlcmVmb3JlLCBjYW5jZWxpbmcg
dGltZXIgaXMgbW92ZWQgYWZ0ZXIgbWQtPmhvbGRlcnMgaXMgemVyby4KPj4+Pgo+Pj4+IFNpZ25l
ZC1vZmYtYnk6IEx1byBNZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbT4KPj4+PiAtLS0KPj4+PiAg
ICBkcml2ZXJzL21kL2RtLmMgfCAyNiArKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQo+Pj4+ICAg
IDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkKPj4+Pgo+
Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKPj4+PiBp
bmRleCA2MDU0OWI2NWM3OTkuLjM3OTUyNTMxMzYyOCAxMDA2NDQKPj4+PiAtLS0gYS9kcml2ZXJz
L21kL2RtLmMKPj4+PiArKysgYi9kcml2ZXJzL21kL2RtLmMKPj4+PiBAQCAtMjQyMCw2ICsyNDIw
LDE5IEBAIHN0YXRpYyB2b2lkIF9fZG1fZGVzdHJveShzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQs
IGJvb2wgd2FpdCkKPj4+PiAgICAJYmxrX21hcmtfZGlza19kZWFkKG1kLT5kaXNrKTsKPj4+PiAr
CS8qCj4+Pj4gKwkgKiBSYXJlLCBidXQgdGhlcmUgbWF5IGJlIEkvTyByZXF1ZXN0cyBzdGlsbCBn
b2luZyB0byBjb21wbGV0ZSwKPj4+PiArCSAqIGZvciBleGFtcGxlLiAgV2FpdCBmb3IgYWxsIHJl
ZmVyZW5jZXMgdG8gZGlzYXBwZWFyLgo+Pj4+ICsJICogTm8gb25lIHNob3VsZCBpbmNyZW1lbnQg
dGhlIHJlZmVyZW5jZSBjb3VudCBvZiB0aGUgbWFwcGVkX2RldmljZSwKPj4+PiArCSAqIGFmdGVy
IHRoZSBtYXBwZWRfZGV2aWNlIHN0YXRlIGJlY29tZXMgRE1GX0ZSRUVJTkcuCj4+Pj4gKwkgKi8K
Pj4+PiArCWlmICh3YWl0KQo+Pj4+ICsJCXdoaWxlIChhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMp
KQo+Pj4+ICsJCQltc2xlZXAoMSk7Cj4+Pj4gKwllbHNlIGlmIChhdG9taWNfcmVhZCgmbWQtPmhv
bGRlcnMpKQo+Pj4+ICsJCURNV0FSTigiJXM6IEZvcmNpYmx5IHJlbW92aW5nIG1hcHBlZF9kZXZp
Y2Ugc3RpbGwgaW4gdXNlISAoJWQgdXNlcnMpIiwKPj4+PiArCQkgICAgICAgZG1fZGV2aWNlX25h
bWUobWQpLCBhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMpKTsKPj4+PiArCj4+Pj4gICAgCS8qCj4+
Pj4gICAgCSAqIFRha2Ugc3VzcGVuZF9sb2NrIHNvIHRoYXQgcHJlc3VzcGVuZCBhbmQgcG9zdHN1
c3BlbmQgbWV0aG9kcwo+Pj4+ICAgIAkgKiBkbyBub3QgcmFjZSB3aXRoIGludGVybmFsIHN1c3Bl
bmQuCj4+Pj4gQEAgLTI0MzYsMTkgKzI0NDksNiBAQCBzdGF0aWMgdm9pZCBfX2RtX2Rlc3Ryb3ko
c3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kLCBib29sIHdhaXQpCj4+Pj4gICAgCWRtX3B1dF9saXZl
X3RhYmxlKG1kLCBzcmN1X2lkeCk7Cj4+Pj4gICAgCW11dGV4X3VubG9jaygmbWQtPnN1c3BlbmRf
bG9jayk7Cj4+Pj4gLQkvKgo+Pj4+IC0JICogUmFyZSwgYnV0IHRoZXJlIG1heSBiZSBJL08gcmVx
dWVzdHMgc3RpbGwgZ29pbmcgdG8gY29tcGxldGUsCj4+Pj4gLQkgKiBmb3IgZXhhbXBsZS4gIFdh
aXQgZm9yIGFsbCByZWZlcmVuY2VzIHRvIGRpc2FwcGVhci4KPj4+PiAtCSAqIE5vIG9uZSBzaG91
bGQgaW5jcmVtZW50IHRoZSByZWZlcmVuY2UgY291bnQgb2YgdGhlIG1hcHBlZF9kZXZpY2UsCj4+
Pj4gLQkgKiBhZnRlciB0aGUgbWFwcGVkX2RldmljZSBzdGF0ZSBiZWNvbWVzIERNRl9GUkVFSU5H
Lgo+Pj4+IC0JICovCj4+Pj4gLQlpZiAod2FpdCkKPj4+PiAtCQl3aGlsZSAoYXRvbWljX3JlYWQo
Jm1kLT5ob2xkZXJzKSkKPj4+PiAtCQkJbXNsZWVwKDEpOwo+Pj4+IC0JZWxzZSBpZiAoYXRvbWlj
X3JlYWQoJm1kLT5ob2xkZXJzKSkKPj4+PiAtCQlETVdBUk4oIiVzOiBGb3JjaWJseSByZW1vdmlu
ZyBtYXBwZWRfZGV2aWNlIHN0aWxsIGluIHVzZSEgKCVkIHVzZXJzKSIsCj4+Pj4gLQkJICAgICAg
IGRtX2RldmljZV9uYW1lKG1kKSwgYXRvbWljX3JlYWQoJm1kLT5ob2xkZXJzKSk7Cj4+Pj4gLQo+
Pj4+ICAgIAlkbV90YWJsZV9kZXN0cm95KF9fdW5iaW5kKG1kKSk7Cj4+Pj4gICAgCWZyZWVfZGV2
KG1kKTsKPj4+PiAgICB9Cj4+Pj4gLS0gCj4+Pj4gMi4zMS4xCj4+Pj4KPj4+Cj4+PiBUaGFua3Mg
Zm9yIHRoZSByZXBvcnQgYnV0IHlvdXIgZml4IHNlZW1zIHdyb25nLiAgQSB0aGluLXBvb2wgc3Bl
Y2lmaWMKPj4+IGZpeCBzZWVtcyBtdWNoIG1vcmUgYXBwcm9wcmlhdGUuICBEb2VzIHRoaXMgZml4
IHRoZSBpc3N1ZT8KPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9k
cml2ZXJzL21kL2RtLXRoaW4uYwo+Pj4gaW5kZXggZTc2Yzk2Yzc2MGE5Li5kYzI3MWMxMDdmYjUg
MTAwNjQ0Cj4+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXRoaW4uYwo+Pj4gKysrIGIvZHJpdmVycy9t
ZC9kbS10aGluLmMKPj4+IEBAIC0yODg5LDYgKzI4ODksOCBAQCBzdGF0aWMgdm9pZCBfX3Bvb2xf
ZGVzdHJveShzdHJ1Y3QgcG9vbCAqcG9vbCkKPj4+ICAgIAlkbV9iaW9fcHJpc29uX2Rlc3Ryb3ko
cG9vbC0+cHJpc29uKTsKPj4+ICAgIAlkbV9rY29weWRfY2xpZW50X2Rlc3Ryb3kocG9vbC0+Y29w
aWVyKTsKPj4+ICsJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZwb29sLT53YWtlcik7Cj4+PiAr
CWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmcG9vbC0+bm9fc3BhY2VfdGltZW91dCk7Cj4+PiAg
ICAJaWYgKHBvb2wtPndxKQo+Pj4gICAgCQlkZXN0cm95X3dvcmtxdWV1ZShwb29sLT53cSk7Cj4+
Pgo+PiBUaGFua3MgZm9yIHlvdXIgcmVwbHkuCj4+Cj4+IEhvd2V2ZXIgdGhpcyBpc3N1ZSBleGl0
cyBub3Qgb25seSBpbiB0aGluLXBvb2wsIGNhY2hlX3RhcmdldCBhbHNvIGhhcwo+PiB0aGlzaXNz
dXMuICBHZW5lcmljIGZpeCBtYXliZSBtb3JlIGFwcHJvcHJpYXRlLgo+IAo+IE5vLCB5b3UndmUg
cG9pbnRlZCBvdXQgYSBwcm9ibGVtIHdpdGggZG0tdGhpbnAgbm90IHByb3Blcmx5IHRlYXJpbmcK
PiBkb3duIGl0cyByZXNvdXJjZXMuIFNhbWUgZm9yIGRtLWNhY2hlLiBTbyBhIGdlbmVyaWMgZml4
IGRvZXNuJ3QgbWFrZQo+IHNlbnNlLiAgQW5kIHlvdXIgcGFydGljdWxhciBnZW5lcmljIGZpeCBt
ZXJlbHkgcGFwZXJzIG92ZXIgdGhlCj4gcmVzb3VyY2UgbGVhaywgd2hpbGUgYWxzbyBjYXVzaW5n
IERNIGNvcmUgdG8gbm8gbG9uZ2VyIHByb3Blcmx5IHdhaXQKPiBmb3Igb3V0c3RhbmRpbmcgSU8g
dG8gY29tcGxldGUuCj4gCj4+IEFmdGVyIGFkZGluZyBjYW5jZWxfZGVsYXllZF93b3JrX3N5bmMo
KSBpbiBfX3Bvb2xfZGVzdHJveSgpLCB0aGlzIHdpbGwgbWFrZQo+PiBpdCBwb3NzaWJsZSB0byBj
YWxsIGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmcG9vbC0+d2FrZXIpIHR3aWNlIHdoZW4gZG0g
aXMKPj4gbm90IHN1c3BlbmQuCj4gCj4gVGhhdCdzIG5vdCBhIHByb2JsZW0sIHRoYXQncyB0aGUg
Y29zdCBvZiBwcm9wZXJseSBhY2NvdW50aW5nIGZvcgo+IHJlc291cmNlcyB3aGVyZSB3ZSBtdXN0
Lgo+IApUaGFua3MuCkkgd2lsbCBzZW5kIHYyIHNvb24uCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

