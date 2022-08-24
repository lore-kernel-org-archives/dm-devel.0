Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E9DC38142
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661309258;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xbiO0YyWtXeeJ5+BZSZ5vNZb4wuV9T913P3o5Lr1mEU=;
	b=OJPNA1CfgrRdV8e7fPTk5DklALpddYDm+R9w8+SmcUMkmqiCY/ITa2wLCcQoolMLBE+cQg
	9nhQkLEbrePrE3bPnamuFi0UOZ2vAEMtxFCDu5MeknjxODIvAT8gEwotLlhSkaZPktoTn8
	SqggUHfH2LO/BuGI1YvMXBkxrytLSWY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-XbgQDTu1O1uxYY2Amhejvg-1; Tue, 23 Aug 2022 22:47:35 -0400
X-MC-Unique: XbgQDTu1O1uxYY2Amhejvg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 923403C0D868;
	Wed, 24 Aug 2022 02:47:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 146C0492C3B;
	Wed, 24 Aug 2022 02:47:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E52781946A41;
	Wed, 24 Aug 2022 02:47:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58AB61946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 02:47:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4A2DC18EA8; Wed, 24 Aug 2022 02:47:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 469F9945D2
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 02:47:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BA3585A58A
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 02:47:31 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-_wGX9GHCOPCFiQ-RiH4Beg-1; Tue, 23 Aug 2022 22:47:27 -0400
X-MC-Unique: _wGX9GHCOPCFiQ-RiH4Beg-1
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MC9Qd5ZGrzkWPV;
 Wed, 24 Aug 2022 10:43:53 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 24 Aug 2022 10:47:23 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 24 Aug 2022 10:47:23 +0800
Message-ID: <69ed6e09-e5d5-5e6a-0326-35adc57ec220@huawei.com>
Date: Wed, 24 Aug 2022 10:47:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Martin Wilck <martin.wilck@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <1660769316-5302-4-git-send-email-bmarzins@redhat.com>
 <e0f0516a08bf8fe5dddf058e5b9c9fad494340ba.camel@suse.com>
 <20220822174632.GT10602@octiron.msp.redhat.com>
 <7eb895de329e17fcf0a788844c8418ea309d62da.camel@suse.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <7eb895de329e17fcf0a788844c8418ea309d62da.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH V2 3/6] multipathd: Occasionally allow
 waiters to interrupt checking paths
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgrlnKggMjAyMi84LzIzIDI6MTEsIE1hcnRpbiBXaWxjayDlhpnpgZM6Cj4gT24gTW9uLCAyMDIy
LTA4LTIyIGF0IDEyOjQ2IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3JvdGU6Cj4+IE9uIE1v
biwgQXVnIDIyLCAyMDIyIGF0IDA0OjE1OjAxUE0gKzAwMDAsIE1hcnRpbiBXaWxjayB3cm90ZToK
Pj4+Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgaWYgKGkgPj0gVkVDVE9SX1NJWkUodmVjcy0KPj4+Pj4gcGF0aHZlYykp
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGkgPSBWRUNUT1JfU0laRSh2ZWNzLQo+Pj4+PiBw
YXRodmVjKSAtIDE7Cj4+Pgo+Pj4gV2hhdCBpZiBWRUNUT1JfU0laRSh2ZWNzLT5wYXRodmVjKSA9
PSAwPyBNYXliZSB5b3Ugc2hvdWxkIGNhdGNoCj4+PiB0aGF0IGluCj4+PiB0aGUgd2hpbGUgKCkg
Y29uZGl0aW9uIGFib3ZlPwo+Pgo+PiBJIGNvdWxkIGZvciBjbGFyaXR5IGlmIHlvdSB3YW50LCBi
dXQgdGhlIGNvZGUgaXMgY29ycmVjdCBhcyBpcy4gSWYKPj4gVkVDVE9SX1NJWkUoKSBpcyAwLCB0
aGVuIGkgd2lsbCBzdGFydCBhdCAtMS4gVGhpcyB3aWxsIGNhdXNlIHRoZQo+PiB3aGlsZSgpCj4+
IGxvb3AgdG8gaW1tZWRpYXRlbHkgZXhpdCwgc2luY2UgVkVDVE9SX1NMT1QoKSBjaGVja3MgZm9y
IGkgPCAwLiBSaWdodAo+PiBhZnRlciB0aGUgd2hpbGUgbG9vcCwgaSBnZXRzIGJ1bXBlZCB1cCB0
byBzdGFydCBjaGVja2luZyBhdCB0aGUgZmlyc3QKPj4gZGV2aWNlICh3aGljaCBvZiBjb3Vyc2Ug
aXNuJ3QgdGhlcmUpLsKgIEl0J3MgdGhlIHNhbWUgbG9naWMgYXMgd2hhdAo+PiBoYXBwZW5zIGlm
IHRoZSB3aGlsZSgpIGxvb3Agc2VhcmNoZXMgdGhyb3VnaCB0aGUgZW50aXJlIHBhdGh2ZWMsIGFu
ZAo+PiBkb2Vzbid0IGZpbmQgYW55IGNoZWNrZWQgcGF0aHMuwqAgT2J2aW91c2x5LCB0aGUgZW1w
dHkgdmVjdG9yIGNhc2UKPj4gZG9lcyBhCj4+IGJpdCBvZiB1bm5lY2Vzc2FyeSB3b3JrIGFmdGVy
IGZpbmRpbmcgb3V0IHRoYXQgdGhlIHZlY3RvciBpcyBlbXB0eSwKPj4gYW5kCj4+IEkgY291bGQg
YWRkIHNvbWV0aGluZyBsaWtlCj4+Cj4+IGlmIChWRUNUT1JfU0laRSh2ZWNzLT5wYXRodmVjKSA9
PSAwKSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqBjaGVja2VyX3N0YXRlID0gQ0hFQ0tFUl9GSU5JU0hF
RDsKPj4gwqDCoMKgwqDCoMKgwqDCoGdvdG8gdW5sb2NrOwo+PiB9Cj4+Cj4+IElmIHlvdSdkIHBy
ZWZlci4KPiAKPiBObywgaXQncyBmaW5lLiBJIHJlYWxpemVkIHRoYXQgeW91ciBjb2RlIHdhcyBj
b3JyZWN0IGFmdGVyIEknZCBoaXQKPiAiU2VuZCIgOi0vCj4gCj4gV3UgR3VhbmdoYWhvLCBoYXZl
IHlvdSBhbHJlYWR5IHNvbWUgcmVzdWx0cyB0byByZXBvcnQ/Cj4gClRoZSB0ZXN0IGVudmlyb25t
ZW50IGlzIG5vdCByZWFkeSwgaXQgbWF5IHRha2UgbmV4dCB3ZWVrIHRvIGhhdmUgcmVzdWx0cy4K
PiBNYXJ0aW4KPiAKPiAKPiAuCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

