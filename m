Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4577ECAAD3
	for <dm-devel@archiver.kernel.org>; Thu, 15 Sep 2022 07:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663225403;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zwNULC473/DA1nZYHhpyEBLPuDBm1ed+nI/ACivunhU=;
	b=YXvUlQxX0cuZ0GrVOhQlIXLozZtBTAcf5F7JqbVpQZtazG5ULVEQu/NGrrMgRqBfkiPgV7
	1uFh8GdYVqoMHdlOr7IdQ0bXMSIAPjWSc9lxQFCKo0wJ1jS2zSIUV+U7TljknFkVabS1ON
	zjdZPnnBJdkYvuUt2w3eatWA/IBlr1s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-PcUnA-TJP5qKvtwmhlDXTQ-1; Thu, 15 Sep 2022 03:03:20 -0400
X-MC-Unique: PcUnA-TJP5qKvtwmhlDXTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBCF3805AC5;
	Thu, 15 Sep 2022 07:03:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63A01492B18;
	Thu, 15 Sep 2022 07:03:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 413EE1946587;
	Thu, 15 Sep 2022 07:03:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3754B1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 07:03:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76A332166B35; Thu, 15 Sep 2022 06:56:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72F122166B26
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 06:56:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17A0D858F17
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 06:56:50 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-Eca4reTGNwunMa7U6rVKZA-1; Thu, 15 Sep 2022 02:56:45 -0400
X-MC-Unique: Eca4reTGNwunMa7U6rVKZA-1
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSntm3F5fzNm5c;
 Thu, 15 Sep 2022 14:52:00 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 14:56:36 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 14:56:36 +0800
Message-ID: <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
Date: Thu, 15 Sep 2022 14:56:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From: Wu Guanghao <wuguanghao3@huawei.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH V2 0/6] allowing path checking to be
 interrupted.
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
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

U29ycnkgZm9yIHRoZSBsYXRlIGZlZWRiYWNrLgoKVGhlIHZlcnNpb24gd2UgYXJlIGN1cnJlbnRs
eSB0ZXN0aW5nIGlzIDAuOC40LCBzbyB3ZSBvbmx5IG1lcmdlIHRoZQpmaXJzdCAzIHBhdGNoZXMg
aW4gdGhpcyBzZXJpZXMgb2YgcGF0Y2hlcy4gVGhlbiBhZnRlciB0aGUgYWN0dWFsIHRlc3QsCml0
IHdhcyBmb3VuZCB0aGF0IHRoZSBlZmZlY3QgaW1wcm92ZW1lbnQgaXMgbm90IHZlcnkgb2J2aW91
cy4KClRlc3QgZW52aXJvbm1lbnQ6IDEwMDAgbXVsdGlwYXRoIGRldmljZXMsIDE2IHBhdGhzIHBl
ciBkZXZpY2UKVGVzdCBjb21tYW5kOiAgQWdncmVnYXRlIG11bHRpcGF0aCBkZXZpY2VzIHVzaW5n
IG11bHRpcGF0aGQgYWRkIHBhdGgKVGltZSBjb25zdW1pbmcg77yIdGltZSBmb3IgMTYgcGF0aHMg
dG8gYWdncmVnYXRlIDEgbXVsdGlwYXRoIGRldmljZSk6CjEuIE9yaWdpbmFsOgoJPCA0czogICA3
Ni45JTsKCTRzfjEwczogMTguNCU7Cgk+MTBzOgkgNC43JTsKMi4gQWZ0ZXIgdXNpbmcgdGhlIHBh
dGNoZXM6Cgk8IDRzOgk3OS4xJTsKCTRzfjEwczogMTguMiU7Cgk+MTBzOgkgMi43JTsKCkZyb20g
dGhlIHJlc3VsdHMsIHRoZSB0aW1lLWNvbnN1bWluZyBpbXByb3ZlbWVudCBvZiB0aGUgcGF0Y2gg
aXMgbm90IG9idmlvdXMsCnNvIHdlIG1hZGUgYSBmZXcgY2hhbmdlcyB0byB0aGUgcGF0Y2ggYW5k
IGl0IHdvcmtlZCBhcyBleHBlY3RlZC4gVGhlIG1vZGlmaWNhdGlvbgpvZiB0aGUgcGF0Y2ggaXMg
YXMgZm9sbG93czoKClBhdGhzX2NoZWNrZWQgaXMgY2hhbmdlZCB0byBjb25maWd1cmFibGUsIGN1
cnJlbnQgc2V0dGluZyBuID0gMi4KUmVtb3ZlZCBqdWRnbWVudCBvbiBkaWZmX3RpbWUuClNsZWVw
IGNoYW5nZSBmcm9tIDEwdXMgdG8gNW1zCgppZiAoKytwYXRoc19jaGVja2VkICUgbiA9PSAwICYm
Cglsb2NrX2hhc193YWl0ZXJzKCZ2ZWNzLT5sb2NrKSkgewoJCWdldF9tb25vdG9uaWNfdGltZSgm
ZW5kX3RpbWUpOwoJCXRpbWVzcGVjc3ViKCZlbmRfdGltZSwgJmNoa19zdGFydF90aW1lLAoJCQkg
ICAgJmRpZmZfdGltZSk7CgkJaWYgKGRpZmZfdGltZS50dl9zZWMgPiAwKSAvLyBEZWxldGUgdGhl
IGNvZGUsIGdvdG8gZGlyZWN0bHkKCQkJZ290byB1bmxvY2s7Cn0KCmlmIChjaGVja2VyX3N0YXRl
ICE9IENIRUNLRVJfRklOSVNIRUQpIHsKCS8qIFlpZWxkIHRvIHdhaXRlcnMgKi8KCS8vc3RydWN0
IHRpbWVzcGVjIHdhaXQgPSB7IC50dl9uc2VjID0gMTAwMDAsIH07CgkvL25hbm9zbGVlcCgmd2Fp
dCwgTlVMTCk7Cgl1c2xlZXAoNTAwMCk7ICAvLyBzbGVlcCBjaGFuZ2UgZnJvbSAxMHVzIHRvIDVt
cwp9CgpUaW1lIGNvbnN1bWluZ++8iEFmdGVyIG1ha2luZyB0aGUgYWJvdmUgY2hhbmdlcyB0byB0
aGUgcGF0Y2jvvIk6CjwgNHM6IDk5LjUlOwo9IDRzOiAwLjUlOwo+IDRzOiAwJTsKCuWcqCAyMDIy
LzgvMTggNDo0OCwgQmVuamFtaW4gTWFyemluc2tpIOWGmemBkzoKPiBXaGVuIHRoZXJlIGFyZSBh
IGh1Z2UgbnVtYmVyIG9mIHBhdGhzICg+IDEwMDAwKSBUaGUgYW1vdW50IG9mIHRpbWUgdGhhdAo+
IHRoZSBjaGVja2VybG9vcCBjYW4gaG9sZCB0aGUgdmVjcyBsb2NrIGZvciB3aGlsZSBjaGVja2lu
ZyB0aGUgcGF0aHMgY2FuCj4gZ2V0IHRvIGJlIGxhcmdlIGVub3VnaCB0aGF0IGl0IHN0YXJ2ZXMg
b3RoZXIgdmVjcyBsb2NrIHVzZXJzLiAgSWYgcGF0aAo+IGNoZWNraW5nIHRha2VzIGxvbmcgZW5v
dWdoLCBpdCdzIHBvc3NpYmxlIHRoYXQgdXhsc25yIHRocmVhZHMgd2lsbCBuZXZlcgo+IHJ1bi4g
VG8gZGVhbCB3aXRoIHRoaXMsIHRoaXMgcGF0Y2hzZXQgbWFrZXMgaXQgcG9zc2libGUgdG8gZHJv
cCB0aGUgdmVjcwo+IGxvY2sgd2hpbGUgY2hlY2tpbmcgdGhlIHBhdGhzLCBhbmQgdGhlbiByZWFj
cXVpcmUgaXQgYW5kIGNvbnRpbnVlIHdpdGgKPiB0aGUgbmV4dCBwYXRoIHRvIGNoZWNrLgo+IAo+
IE15IGNob2ljZSBvZiBvbmx5IGNoZWNraW5nIGlmIHRoZXJlIGFyZSB3YWl0ZXJzIGV2ZXJ5IDEy
OCBwYXRocyBjaGVja2VkCj4gYW5kIG9ubHkgaW50ZXJydXB0aW5nIGlmIHBhdGggY2hlY2tpbmcg
aGFzIHRha2VuIG1vcmUgdGhhbiBhIHNlY29uZCBhcmUKPiBhcmJpdHJhcnkuIEkgZGlkbid0IHdh
bnQgdG8gc2xvdyBkb3duIHBhdGggY2hlY2tpbmcgaW4gdGhlIGNvbW1vbiBjYXNlCj4gd2hlcmUg
dGhpcyBpc24ndCBhbiBpc3N1ZSwgYW5kIEkgd2FudGVkIHRvIGF2b2lkIHBhdGggY2hlY2tpbmcg
Z2V0dGluZwo+IHN0YXJ2ZWQgYnkgb3RoZXIgdmVjcy0+bG9jayB1c2Vycy4gSGF2aW5nIHRoZSBj
aGVja2VybG9vcCB3YWl0IGZvciAxMDAwMAo+IG5zZWMgd2FzIGJhc2VkIG9uIG15IG93biB0ZXN0
aW5nIHdpdGggYSBzZXR1cCB1c2luZyA0SyBtdWx0aXBhdGggZGV2aWVzCj4gd2l0aCA0IHBhdGhz
IGVhY2guIFRoaXMgd2FzIGFsbW9zdCBhbHdheXMgbG9uZyBlbm91Z2ggZm9yIHRoZSB1ZXZlbnQg
b3IKPiB1eGxzbnIgY2xpZW50IHRvIGdyYWIgdGhlIHZlY3MgbG9jaywgYnV0IEknbSBub3Qgc3Vy
ZSBob3cgZGVwZW5kZW50IHRoaXMKPiBpcyBvbiBkZXRhaWxzIG9mIHRoZSBzeXN0ZW0uIEZvciBp
bnN0YW5jZSB3aXRoIG15IHNldHVwIGluIG5ldmVyIHRvb2sKPiBtb3JlIHRoYW4gMjAgc2Vjb25k
cyB0byBjaGVjayB0aGUgcGF0aHMuIGFuZCB1c3VhbGx5LCBhIGxvb3BpbmcgdGhyb3VnaAo+IGFs
bCB0aGUgcGF0aHMgdG9vayB3ZWxsIHVuZGVyIDEwIHNlY29uZHMsIG1vc3Qgb2Z0ZW4gdW5kZXIg
NS4gSSB3b3VsZAo+IG9ubHkgb2NjYXNpb25hbGx5IHJ1biBpbnRvIHNpdHVhdGlvbnMgd2hlcmUg
YSB1eGxzbnIgY2xpZW50IHdvdWxkIHRpbWUKPiBvdXQuCj4gCj4gVjIgQ2hhbmdlczoKPiAwMDAz
OiBTd2l0Y2hlZCB0byBhIHNpbXBsZXIgbWV0aG9kIG9mIGRldGVybWluaW5nIHRoZSBwYXRoIHRv
IGNvbnRpbnVlCj4gICAgICAgY2hlY2tpbmcgYXQsIGFzIHN1Z2dlc3RlZCBieSBNYXJ0aW4gV2ls
Y2suIEFsc28gZml4ZWQgYSBidWcgd2hlbgo+ICAgICAgIHRoZSBwcmV2aW91cyBpbmRleCB3YXMg
bGFyZ2VyIHRoYW4gdGhlIGN1cnJlbnQgdmVjdG9yIHNpemUuCj4gCj4gQmVuamFtaW4gTWFyemlu
c2tpICg2KToKPiAgIG11bHRpcGF0aGQ6IFVzZSByZWd1bGFyIHB0aHJlYWRfbXV0ZXhfdCBmb3Ig
d2FpdGVyX2xvY2sKPiAgIG11bHRpcGF0aGQ6IHRyYWNrIHdhaXRlcnMgZm9yIG11dGV4X2xvY2sK
PiAgIG11bHRpcGF0aGQ6IE9jY2FzaW9uYWxseSBhbGxvdyB3YWl0ZXJzIHRvIGludGVycnVwdCBj
aGVja2luZyBwYXRocwo+ICAgbXVsdGlwYXRoZDogYWxsb3cgdXhsc25yIGNsaWVudHMgdG8gaW50
ZXJydXB0IGNoZWNraW5nIHBhdGhzCj4gICBtdWx0aXBhdGhkOiBmaXggdXhsc25yIHRpbWVvdXQK
PiAgIG11bHRpcGF0aGQ6IERvbid0IGNoZWNrIGlmIHRpbWVzcGVjLnR2X3NlYyBpcyB6ZXJvCj4g
Cj4gIGxpYm11bHRpcGF0aC9sb2NrLmggICAgfCAgMTYgKysrKysKPiAgbGlibXVsdGlwYXRoL3N0
cnVjdHMuaCB8ICAgMSArCj4gIG11bHRpcGF0aGQvbWFpbi5jICAgICAgfCAxNDcgKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KPiAgbXVsdGlwYXRoZC91eGxzbnIuYyAg
ICB8ICAyMyArKysrKy0tCj4gIG11bHRpcGF0aGQvdXhsc25yLmggICAgfCAgIDEgKwo+ICBtdWx0
aXBhdGhkL3dhaXRlci5jICAgIHwgIDE0ICsrLS0KPiAgNiBmaWxlcyBjaGFuZ2VkLCAxMzYgaW5z
ZXJ0aW9ucygrKSwgNjYgZGVsZXRpb25zKC0pCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

