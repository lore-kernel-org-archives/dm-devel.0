Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB3BC54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665669;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8vtiAhDK+kvxqng4JLDw4z0a4N6Ktm7BKEVe1OWEMso=;
	b=if5CKdZbHpmKA8XKpTYHXq8VqPkuXbSH2QQHJrjX+9lPewNAzX6SD5kEG8+HsLt+7kwgD2
	fkhkxATpdyDRybi6hDHy6Flh3ynk1sjGp7EQznJGJrTcw34c3xOG/ph4BHYDFtx4keM6Id
	NaHiqutvIBCjl65EFFMVGKcxgIBajC0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-d74ogmDnMNebwZUjfoLqBg-1; Tue, 20 Sep 2022 05:21:06 -0400
X-MC-Unique: d74ogmDnMNebwZUjfoLqBg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83D593C01E01;
	Tue, 20 Sep 2022 09:21:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 349BB40C2086;
	Tue, 20 Sep 2022 09:21:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 147F319465A3;
	Tue, 20 Sep 2022 09:21:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DC2319465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:21:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3046140C2064; Tue, 20 Sep 2022 09:21:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2993F40C2066
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:21:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D3878027F5
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:21:02 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-_F8JpLgqMs-lnrD8t-bFwA-1; Tue, 20 Sep 2022 05:20:59 -0400
X-MC-Unique: _F8JpLgqMs-lnrD8t-bFwA-1
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MWwsn4bGkzcnf9;
 Tue, 20 Sep 2022 17:17:01 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 17:20:55 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 17:20:55 +0800
Message-ID: <2686cb11-3955-e3f0-5f42-647dc9cfed36@huawei.com>
Date: Tue, 20 Sep 2022 17:20:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
 <20220915181754.GA23693@octiron.msp.redhat.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20220915181754.GA23693@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgrlnKggMjAyMi85LzE2IDI6MTcsIEJlbmphbWluIE1hcnppbnNraSDlhpnpgZM6Cj4gT24gVGh1
LCBTZXAgMTUsIDIwMjIgYXQgMDI6NTY6MzZQTSArMDgwMCwgV3UgR3VhbmdoYW8gd3JvdGU6Cj4+
IFNvcnJ5IGZvciB0aGUgbGF0ZSBmZWVkYmFjay4KPj4KPj4gVGhlIHZlcnNpb24gd2UgYXJlIGN1
cnJlbnRseSB0ZXN0aW5nIGlzIDAuOC40LCBzbyB3ZSBvbmx5IG1lcmdlIHRoZQo+PiBmaXJzdCAz
IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgb2YgcGF0Y2hlcy4gVGhlbiBhZnRlciB0aGUgYWN0dWFs
IHRlc3QsCj4+IGl0IHdhcyBmb3VuZCB0aGF0IHRoZSBlZmZlY3QgaW1wcm92ZW1lbnQgaXMgbm90
IHZlcnkgb2J2aW91cy4KPj4KPj4gVGVzdCBlbnZpcm9ubWVudDogMTAwMCBtdWx0aXBhdGggZGV2
aWNlcywgMTYgcGF0aHMgcGVyIGRldmljZQo+PiBUZXN0IGNvbW1hbmQ6ICBBZ2dyZWdhdGUgbXVs
dGlwYXRoIGRldmljZXMgdXNpbmcgbXVsdGlwYXRoZCBhZGQgcGF0aAo+PiBUaW1lIGNvbnN1bWlu
ZyDvvIh0aW1lIGZvciAxNiBwYXRocyB0byBhZ2dyZWdhdGUgMSBtdWx0aXBhdGggZGV2aWNlKToK
Pj4gMS4gT3JpZ2luYWw6Cj4+IAk8IDRzOiAgIDc2LjklOwo+PiAJNHN+MTBzOiAxOC40JTsKPj4g
CT4xMHM6CSA0LjclOwo+PiAyLiBBZnRlciB1c2luZyB0aGUgcGF0Y2hlczoKPj4gCTwgNHM6CTc5
LjElOwo+PiAJNHN+MTBzOiAxOC4yJTsKPj4gCT4xMHM6CSAyLjclOwo+Pgo+PiA+RnJvbSB0aGUg
cmVzdWx0cywgdGhlIHRpbWUtY29uc3VtaW5nIGltcHJvdmVtZW50IG9mIHRoZSBwYXRjaCBpcyBu
b3Qgb2J2aW91cywKPj4gc28gd2UgbWFkZSBhIGZldyBjaGFuZ2VzIHRvIHRoZSBwYXRjaCBhbmQg
aXQgd29ya2VkIGFzIGV4cGVjdGVkLiBUaGUgbW9kaWZpY2F0aW9uCj4+IG9mIHRoZSBwYXRjaCBp
cyBhcyBmb2xsb3dzOgo+Pgo+PiBQYXRoc19jaGVja2VkIGlzIGNoYW5nZWQgdG8gY29uZmlndXJh
YmxlLCBjdXJyZW50IHNldHRpbmcgbiA9IDIuCj4+IFJlbW92ZWQganVkZ21lbnQgb24gZGlmZl90
aW1lLgo+PiBTbGVlcCBjaGFuZ2UgZnJvbSAxMHVzIHRvIDVtcwo+IAo+IEkgd29ycnkgdGhhdCB0
aGlzIGlzIGdpdmluZyB0b28gbXVjaCBkZWZlcmVuY2UgdG8gdGhlIHVldmVudHMuIElmIHRoZXJl
Cj4gaXMgYSB1ZXZlbnQgc3Rvcm0sIGNoZWNraW5nIHdpbGwgc3RvcCBmb3IgNW1zIGV2ZXJ5IDIg
cGF0aHMgY2hlY2tlZC4gSSdtCj4gd29ycmllZCB0aGF0IHRoaXMgd2lsbCBtYWtlIGl0IHRha2Ug
c2lnbmlmaWNhbnRseSBsb25nZXIgZm9yIHRoZSB0aGUKPiBwYXRoIGNoZWNrZXIgdG8gY29tcGxl
dGUgYSBjeWNsZS4gIE1ha2luZyBwYXRoc19jaGVja2VkIGNvbmZpZ3VyYWJsZSwgc28KPiB0aGF0
IHRoaXMgZG9lc24ndCB0cmlnZ2VyIHRvbyBvZnRlbiBkb2VzIGhlbHAgdG8gYXZvaWQgdGhlIGlz
c3VlIHRoYXQKPiBjaGVja2luZyB0aGUgdGltZSBmcm9tIGNoa19zdGFydF90aW1lIHdhcyBkZWFs
aW5nIHdpdGgsIGFuZCBtYWtlcyB0aGUKPiBtZWNoYW5pY3Mgb2YgdGhpcyBzaW1wbGVyLiAgQnV0
IDVtcyBzZWVtcyBsaWtlIGEgbG9uZyB0aW1lIHRvIGhhdmUgdG8KPiB3YWl0LCBqdXN0IHRvIG1h
a2Ugc3VyZSB0aGF0IGFub3RoZXIgcHJvY2VzcyBoYWQgdGhlIHRpbWUgdG8gZ3JhYiB0aGUKPiB2
ZWNzIGxvY2suICBQZXJoYXBzIGl0IHdvdWxkIGJlIGJldHRlciB0byBzbGVlcCBmb3IgYSBzaG9y
dGVyIGxlbmd0aCBvZgo+IHRpbWUsIGJ1dCBpbiBhIGxvb3AsIHdoZXJlIHdlIGNhbiBjaGVjayB0
byBzZWUgaWYgcHJvZ3Jlc3MgaGFzIGJlZW4KPiBtYWRlLCBwZXJoYXBzIGJ5IGNoZWNraW5nIHNv
bWUgY291bnRlciBvZiBldmVudHMgYW5kIHVzZXIgY29tbWFuZHMKPiBzZXJ2aWNlZC4gVGhpcyB3
YXksIHdlIGFyZW4ndCBzbGVlcGluZyB0b28gbG9uZyBmb3Igbm8gZ29vZCByZWFzb24uCj4gSSBh
Z3JlZSB3aXRoIHRoaXMsIHdlIGFyZSBhbHNvIGdvaW5nIHRvIGFkanVzdCB0aGUgc2xlZXAgdGlt
ZSwgYW5kIHRoZW4KY29udGludWUgdGhlIHRlc3QuCgo+PiBpZiAoKytwYXRoc19jaGVja2VkICUg
biA9PSAwICYmCj4+IAlsb2NrX2hhc193YWl0ZXJzKCZ2ZWNzLT5sb2NrKSkgewo+PiAJCWdldF9t
b25vdG9uaWNfdGltZSgmZW5kX3RpbWUpOwo+PiAJCXRpbWVzcGVjc3ViKCZlbmRfdGltZSwgJmNo
a19zdGFydF90aW1lLAo+PiAJCQkgICAgJmRpZmZfdGltZSk7Cj4+IAkJaWYgKGRpZmZfdGltZS50
dl9zZWMgPiAwKSAvLyBEZWxldGUgdGhlIGNvZGUsIGdvdG8gZGlyZWN0bHkKPj4gCQkJZ290byB1
bmxvY2s7Cj4+IH0KPj4KPj4gaWYgKGNoZWNrZXJfc3RhdGUgIT0gQ0hFQ0tFUl9GSU5JU0hFRCkg
ewo+PiAJLyogWWllbGQgdG8gd2FpdGVycyAqLwo+PiAJLy9zdHJ1Y3QgdGltZXNwZWMgd2FpdCA9
IHsgLnR2X25zZWMgPSAxMDAwMCwgfTsKPj4gCS8vbmFub3NsZWVwKCZ3YWl0LCBOVUxMKTsKPj4g
CXVzbGVlcCg1MDAwKTsgIC8vIHNsZWVwIGNoYW5nZSBmcm9tIDEwdXMgdG8gNW1zCj4+IH0KPj4K
Pj4gVGltZSBjb25zdW1pbmfvvIhBZnRlciBtYWtpbmcgdGhlIGFib3ZlIGNoYW5nZXMgdG8gdGhl
IHBhdGNo77yJOgo+PiA8IDRzOiA5OS41JTsKPj4gPSA0czogMC41JTsKPj4+IDRzOiAwJTsKPiAK
PiBTaW5jZSBJIGJlbGlldmUgdGhhdCB0aGlzIGlzIGxpa2VseSBjYXVzaW5nIGEgcmVhbCBpbXBh
Y3Qgb24gdGhlIGNoZWNrZXIKPiBzcGVlZCwgSSdtIG5vdCBzdXJlIHRoYXQgd2UncmUgbG9va2lu
ZyBmb3IgcmVzdWx0cyBsaWtlIHRoaXMuIEFyZSB5b3UKPiBzZWVpbmcgVGhhdCAicGF0aCBjaGVj
a2VycyB0b29rIGxvbmdlciB0aGFuIC4uLiIgbWVzc2FnZT8gSG93IGxvbmcgZG9lcwo+IGl0IHNh
eSB0aGUgY2hlY2tlciBpcyB0YWtpbmcgKGFuZCB3aGF0IGRvIHlvdSBoYXZlIG1heF9wb2xsaW5n
X2ludGVydmFsCj4gc2V0IHRvKT8KPiBZZXMsIEkgc2F3IHRoaXMgbWVzc2FnZS4gSW4gdGhlIGN1
cnJlbnQgdGVzdCBlbnZpcm9ubWVudCwgdXNpbmcgdGhlIG9yaWdpbmFsCmNvZGUsIGFsbCBwYXRo
IGNoZWNrcyB0YWtlIGF0IGxlYXN0IDUwcyB0byBjb21wbGV0ZS4gV2UgY3VycmVudGx5IHNldApt
YXhfcG9sbGluZ19pbnRlcnZhbD0yMHMsIHNvIGl0IG11c3QgcHJpbnQgdGhpcyBtZXNzYWdlLiBB
ZGRpbmcgc2xlZXAganVzdAptYWtlcyB0aGlzIG1lc3NhZ2UgcHJpbnQgbW9yZSBvZnRlbi4KCj4g
LUJlbgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

