Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A11C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658471341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IDDx3q1qGIjaOHOcJ7v43+U6yYbRKnrONE6R7KUBmjI=;
	b=J2Yt3GWCRUZ1XvGJMtBh/nsVLdR08VUHnZjYxBrm+oEmcwZF1UcXt4MdcWUKIoeexYbWSF
	JQVNa/mT+OOZBcuOt91enfemep4WxM6Z+LxtMmdl4uAhiCAYW5qS+8VZUij6Rst88WbqzM
	qwQYXGchO/9jpty1/VUTBN3558c1zEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-UNnw7Qz5NuytIzValIlx-Q-1; Fri, 22 Jul 2022 02:28:53 -0400
X-MC-Unique: UNnw7Qz5NuytIzValIlx-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10440802D2C;
	Fri, 22 Jul 2022 06:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F01340F9D42;
	Fri, 22 Jul 2022 06:28:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43BAB194704D;
	Fri, 22 Jul 2022 06:28:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E22D31947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 06:28:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0D61401E92; Fri, 22 Jul 2022 06:28:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7F0401473
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 06:28:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61DB9280F2A0
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 06:28:47 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272--n0JcPF4MC-bLWsgEDnY7w-1; Fri, 22 Jul 2022 02:28:36 -0400
X-MC-Unique: -n0JcPF4MC-bLWsgEDnY7w-1
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LpzwG6zglzkWyt;
 Fri, 22 Jul 2022 14:26:06 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Jul 2022 14:28:32 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Jul 2022 14:28:31 +0800
Message-ID: <929fa115-25c7-3335-cd18-4d359b5116d6@huawei.com>
Date: Fri, 22 Jul 2022 14:28:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
 <20220721143410.GZ10602@octiron.msp.redhat.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20220721143410.GZ10602@octiron.msp.redhat.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [Question] multipathd add/remove paths takes a long
 time
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
Cc: lixiaokeng@huawei.com, liuxing108@huawei.com, zhangying134@huawei.com,
 chenmao2@huawei.com, liuzhiqiang26@huawei.com, linfeilong@huawei.com,
 dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 mwilck@suse.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgrlnKggMjAyMi83LzIxIDIyOjM0LCBCZW5qYW1pbiBNYXJ6aW5za2kg5YaZ6YGTOgo+IE9uIFR1
ZSwgSnVsIDE5LCAyMDIyIGF0IDA4OjEzOjM5UE0gKzA4MDAsIFd1IEd1YW5naGFvIHdyb3RlOgo+
PiBUaGUgc3lzdGVtIGhhcyAxSyBtdWx0aXBhdGggZGV2aWNlcywgZWFjaCBkZXZpY2UgaGFzIDE2
IHBhdGhzLgo+PiBFeGVjdXRlIG11bHRpcGF0aGQgYWRkL211bHRpcGF0aGQgcmVtb3ZlIG9yIHVl
dl9hZGRfcGF0aC8KPj4gdWV2X3JlbW92ZV9wYXRoIHRvIGFkZC9yZW1vdmUgcGF0aHMsIHdoaWNo
IHRha2VzIG92ZXIgMjBzLgo+PiBXaGF0J3MgbW9yZSwgdGhlIHNlY29uZCBjaGVja2xvb3AgbWF5
IGJlIGV4ZWNlZCBpbW1lZGlhdGVseQo+PiBhZnRlciBmaW5pc2hpbmcgZmlyc3QgY2hlY2tsb29w
LiBJdCdzIHRvbyBsb25nLgo+Pgo+PiBXZSBmb3VuZCB0aGF0IHRpbWUgd2FzIG1vc3RseSBzcGVu
dCB3YWl0aW5nIGZvciBsb2Nrcy4KPj4KPj4gY2hlY2tlcmxvb3AoKXsKPj4gCS4uLgo+PiAJbG9j
aygmdmVjcy0+bG9jayk7Cj4+IAl2ZWN0b3JfZm9yZWFjaF9zbG90ICh2ZWNzLT5wYXRodmVjLCBw
cCwgaSkgewo+PiAJCXJjID0gY2hlY2tfcGF0aCguLi4pOyAvLyBUb28gbWFueSBwYXRocywgaXQg
dGFrZXMgYSBsb25nIHRpbWUKPj4gCQkuLi4KPj4gCX0KPj4gCWxvY2tfY2xlYW51cF9wb3AodmVj
cy0+bG9jayk7Cj4+IAkuLi4KPj4gfQo+Pgo+PiBDYW4gdGhlIHJhbmdlIG9mIHZlY3MtPmxvY2sg
bG9ja3MgYmUgYWRqdXN0ZWQgdG8gcmVkdWNlIHRoZSB0aW1lIGNvbnN1bWluZwo+PiB3aGVuIGFk
ZGluZy9yZW1vdmluZyBwYXRocz8KPiAKPiBBcyBsb25nIGFzIHdlIG1ha2Ugc3VyZSBub3QgdG8g
c2tpcCBhbnkgcGF0aHMgb3IgZG91YmxlLWNoZWNrIGFueSBwYXRocywKPiB3ZSBkb24ndCBuZWVk
IHRvIGhvbGQgdGhlIHZlY3MtPmxvY2sgYmV0d2VlbiBjaGVja2luZyBwYXRocy4gVGhlcmUgaXMK
PiBjZXJ0YWlubHkgc29tZSBvcHRpbWl6YXRpb24gdGhhdCBjb3VsZCBnZXQgZG9uZSBoZXJlLgo+
IAo+IGNvdWxkIHlvdSBwb3N0IHRoZSBvdXRwdXQgb2Y6Cj4gCj4gIyBtdWx0aXBhdGggLWwgPHNh
bXBsZV9tdWx0aXBhdGhfZGV2aWNlPgo+ICMgbXVsdGlwYXRoZCBzaG93IGNvbmZpZyBsb2NhbAo+
IAoKVGhpcyBpcyB0aGUgb3V0cHV0IGFuZCB0aW1lIGNvbnN1bWluZyBvZiAnbXVsdGlwYXRoIC1s
JwoKIyB0aW1lIG11bHRpcGF0aCAtbCAzNjRjZjU1YjEwMDk3Njk5ZTAxYTljNGQ0MDAwMDAzYzQK
MTc0MTgxLjMyOTQzNSB8IGxvYWRpbmcgL2xpYjY0L211bHRpcGF0aC9saWJjaGVja3R1ci5zbyBj
aGVja2VyCjM2NGNmNTViMTAwOTc2OTllMDFhOWM0ZDQwMDAwMDNjNCBkbS02MDQgSFVBV0VJLFhT
RzEKc2l6ZT0xLjBHIGZlYXR1cmVzPScxIHF1ZXVlX2lmX25vX3BhdGgnIGh3aGFuZGxlcj0nMCcg
d3A9cncKYC0rLSBwb2xpY3k9J3NlcnZpY2UtdGltZSAwJyBwcmlvPTAgc3RhdHVzPWFjdGl2ZQog
IHwtIDI3OjA6MDo1OTEgIHNkbGdmIDcwOjgzNjggICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwt
IDI4OjA6MDo1OTEgIHNkbGhzIDEyOTo4MjI0ICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDM5
OjA6MDo1OTEgIHNkbHN0IDEzMTo4NDY0ICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDI0OjA6
MDo1OTEgIHNkbWR2IDEzMzo4NzIwICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDQwOjA6MDo1
OTEgIHNkbWVqIDEzMzo4OTQ0ICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDI5OjA6MDo1OTEg
IHNkbWVzIDEzNDo4ODMyICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDM3OjA6MDo1OTEgIHNk
bWhsIDY2OjkyMDAgICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDM4OjA6MDo1OTEgIHNkbWp1
IDcwOjkxNTIgICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDI2OjA6MDo1OTEgIHNkbWp4IDcw
OjkyMDAgICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDQxOjA6MDo1OTEgIHNkbnJlIDEzMzo5
NzI4ICBhY3RpdmUgdW5kZWYgcnVubmluZwogIHwtIDQzOjA6MDo1OTEgIHNkbnJ6IDEzNDo5ODA4
ICBhY3RpdmUgdW5kZWYgcnVubmluZwogIGAtIDQyOjA6MDo1OTEgIHNkbnNwIDEzNTo5ODA4ICBh
Y3RpdmUgdW5kZWYgcnVubmluZwoKcmVhbCAgICAwbTM3LjU3MHMKdXNlciAgICAwbTI4LjY3NnMK
c3lzICAgICAwbTguMTEycwoKVGhpcyBpcyB0aGUgb3V0cHV0IG9mICdtdWx0aXBhdGhkIHNob3cg
Y29uZmlnIGxvY2FsJwoKdGltZW91dApkZWZhdWx0cyB7Cgl2ZXJib3NpdHkgMgoJcG9sbGluZ19p
bnRlcnZhbCA1CgltYXhfcG9sbGluZ19pbnRlcnZhbCAyMAoJcmVhc3NpZ25fbWFwcyAibm8iCglt
dWx0aXBhdGhfZGlyICIvbGliNjQvbXVsdGlwYXRoIgoJcGF0aF9zZWxlY3RvciAic2VydmljZS10
aW1lIDAiCglwYXRoX2dyb3VwaW5nX3BvbGljeSAiZ3JvdXBfYnlfcHJpbyIKCXVpZF9hdHRyaWJ1
dGUgIklEX1NFUklBTCIKCXByaW8gImNvbnN0IgoJcHJpb19hcmdzICIiCglmZWF0dXJlcyAiMCIK
CXBhdGhfY2hlY2tlciAidHVyIgoJYWxpYXNfcHJlZml4ICJtcGF0aCIKCWZhaWxiYWNrICJpbW1l
ZGlhdGUiCglycl9taW5faW8gMTAwMAoJcnJfbWluX2lvX3JxIDEKCW1heF9mZHMgIm1heCIKCXJy
X3dlaWdodCAidW5pZm9ybSIKCW5vX3BhdGhfcmV0cnkgMTgKCXF1ZXVlX3dpdGhvdXRfZGFlbW9u
ICJubyIKCWZsdXNoX29uX2xhc3RfZGVsICJubyIKCXVzZXJfZnJpZW5kbHlfbmFtZXMgIm5vIgoJ
ZmFzdF9pb19mYWlsX3RtbyA1CgliaW5kaW5nc19maWxlICIvZXRjL211bHRpcGF0aC9iaW5kaW5n
cyIKCXd3aWRzX2ZpbGUgIi9ldGMvbXVsdGlwYXRoL3d3aWRzIgoJcHJrZXlzX2ZpbGUgIi9ldGMv
bXVsdGlwYXRoL3Bya2V5cyIKCWxvZ19jaGVja2VyX2VyciBvbmNlCglyZXNlcnZhdGlvbl9rZXkg
ZmlsZQoJYWxsX3RnX3B0ICJubyIKCXJldGFpbl9hdHRhY2hlZF9od19oYW5kbGVyICJ5ZXMiCglk
ZXRlY3RfcHJpbyAieWVzIgoJZGV0ZWN0X2NoZWNrZXIgInllcyIKCWZvcmNlX3N5bmMgIm5vIgoJ
c3RyaWN0X3RpbWluZyAibm8iCglkZWZlcnJlZF9yZW1vdmUgInllcyIKCWNvbmZpZ19kaXIgIi9l
dGMvbXVsdGlwYXRoL2NvbmYuZCIKCWRlbGF5X3dhdGNoX2NoZWNrcyAibm8iCglkZWxheV93YWl0
X2NoZWNrcyAibm8iCglzYW5fcGF0aF9lcnJfdGhyZXNob2xkICJubyIKCXNhbl9wYXRoX2Vycl9m
b3JnZXRfcmF0ZSAibm8iCglzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSAibm8iCgltYXJnaW5h
bF9wYXRoX2Vycl9zYW1wbGVfdGltZSAibm8iCgltYXJnaW5hbF9wYXRoX2Vycl9yYXRlX3RocmVz
aG9sZCAibm8iCgltYXJnaW5hbF9wYXRoX2Vycl9yZWNoZWNrX2dhcF90aW1lICJubyIKCW1hcmdp
bmFsX3BhdGhfZG91YmxlX2ZhaWxlZF90aW1lICJubyIKCWZpbmRfbXVsdGlwYXRocyAib2ZmIgoJ
dXhzb2NrX3RpbWVvdXQgNDAwMAoJcmV0cmlnZ2VyX3RyaWVzIDMKCXJldHJpZ2dlcl9kZWxheSAx
MAoJbWlzc2luZ191ZXZfd2FpdF90aW1lb3V0IDMwCglza2lwX2twYXJ0eCAibm8iCglkaXNhYmxl
X2NoYW5nZWRfd3dpZHMgaWdub3JlZAoJcmVtb3ZlX3JldHJpZXMgMAoJZ2hvc3RfZGVsYXkgIm5v
IgoJZmluZF9tdWx0aXBhdGhzX3RpbWVvdXQgLTEwCgllbmFibGVfZm9yZWlnbiAiIgoJbWFyZ2lu
YWxfcGF0aGdyb3VwcyAibm8iCn0KYmxhY2tsaXN0IHsKCWRldm5vZGUgIl4ocmFtfHpyYW18cmF3
fGxvb3B8ZmR8bWR8ZG0tfHNyfHNjZHxzdHxkY3NzYmxrKVswLTldIgoJZGV2bm9kZSAiXih0ZHxo
ZHx2ZClbYS16XSIKCWRldmljZSB7CgkJdmVuZG9yICJTR0kiCgkJcHJvZHVjdCAiVW5pdmVyc2Fs
IFhwb3J0IgoJfQoJZGV2aWNlIHsKCQl2ZW5kb3IgIl5ER0MiCgkJcHJvZHVjdCAiTFVOWiIKCX0K
CWRldmljZSB7CgkJdmVuZG9yICJFTUMiCgkJcHJvZHVjdCAiTFVOWiIKCX0KCWRldmljZSB7CgkJ
dmVuZG9yICJERUxMIgoJCXByb2R1Y3QgIlVuaXZlcnNhbCBYcG9ydCIKCX0KCWRldmljZSB7CgkJ
dmVuZG9yICJJQk0iCgkJcHJvZHVjdCAiVW5pdmVyc2FsIFhwb3J0IgoJfQoJZGV2aWNlIHsKCQl2
ZW5kb3IgIkxFTk9WTyIKCQlwcm9kdWN0ICJVbml2ZXJzYWwgWHBvcnQiCgl9CglkZXZpY2UgewoJ
CXZlbmRvciAiKE5FVEFQUHxMU0l8RU5HRU5JTykiCgkJcHJvZHVjdCAiVW5pdmVyc2FsIFhwb3J0
IgoJfQoJZGV2aWNlIHsKCQl2ZW5kb3IgIlNUSyIKCQlwcm9kdWN0ICJVbml2ZXJzYWwgWHBvcnQi
Cgl9CglkZXZpY2UgewoJCXZlbmRvciAiU1VOIgoJCXByb2R1Y3QgIlVuaXZlcnNhbCBYcG9ydCIK
CX0KCWRldmljZSB7CgkJdmVuZG9yICIoSW50ZWx8SU5URUwpIgoJCXByb2R1Y3QgIlZUcmFrIFYt
TFVOIgoJfQoJZGV2aWNlIHsKCQl2ZW5kb3IgIlByb21pc2UiCgkJcHJvZHVjdCAiVlRyYWsgVi1M
VU4iCgl9CglkZXZpY2UgewoJCXZlbmRvciAiUHJvbWlzZSIKCQlwcm9kdWN0ICJWZXNzIFYtTFVO
IgoJfQoJZGV2aWNlIHsKCQl2ZW5kb3IgIklCTSIKCQlwcm9kdWN0ICJTLzM5MC4qIgoJfQp9CmJs
YWNrbGlzdF9leGNlcHRpb25zIHsKfQpkZXZpY2VzIHsKCWRldmljZSB7CgkJdmVuZG9yICJIVUFX
RUkiCgkJcHJvZHVjdCAiWFNHMSIKCQlwYXRoX2dyb3VwaW5nX3BvbGljeSAiZ3JvdXBfYnlfcHJp
byIKCQlwcmlvICJhbHVhIgoJfQp9Cm92ZXJyaWRlcyB7Cn0KbXVsdGlwYXRocyB7CgltdWx0aXBh
dGggewoJCXd3aWQgIjM2NGNmNTViMTAwOTc2OTllMDE5NzMyMDMwMDAwMDE3NCIKCX0KCW11bHRp
cGF0aCB7CgkJd3dpZCAiMzY0Y2Y1NWIxMDA5NzY5OWUwMThkOWQ5NTAwMDAwMTcxIgoJfQoJLi4u
Cn0KPiAtQmVuCj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

