Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A8DC38A02
	for <dm-devel@archiver.kernel.org>; Wed, 26 Oct 2022 03:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666756044;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OAtYUWHCMothhNWTxUrEH83AiQGvr2l+LPMiVhmsjpQ=;
	b=HsFmoz+AWs2ztTZ3F+pZzNMsOHB9SRkcDBxGWpbOfWDiMSlPEblFp8jSc5c2tnFYwjNqLN
	NK/dbYuDY1F2z04vRL/sRgwBCkjTomOqioBN/qHxCkjsWCxvAwMoQ9WPePfe2RnBAs4/in
	1UEZiotk4BRKN9gWuGtZJt06M10d0LQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-s6-UVrINMLGQJqOz4PQ6Bw-1; Tue, 25 Oct 2022 23:47:20 -0400
X-MC-Unique: s6-UVrINMLGQJqOz4PQ6Bw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C187B185A7A3;
	Wed, 26 Oct 2022 03:47:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68DD22027064;
	Wed, 26 Oct 2022 03:47:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A55C19465A4;
	Wed, 26 Oct 2022 03:47:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C9C31946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 03:47:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D90B2166B35; Wed, 26 Oct 2022 03:47:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 263202166B2B
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 03:47:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07EAD811E84
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 03:47:14 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-yVNS-G6GNjSGhpQ13s-Idw-1; Tue, 25 Oct 2022 23:47:12 -0400
X-MC-Unique: yVNS-G6GNjSGhpQ13s-Idw-1
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MxvnK3VLjzJn9h;
 Wed, 26 Oct 2022 11:44:21 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 11:47:07 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 11:47:07 +0800
Message-ID: <9c6635c0-ae13-397e-5634-423dc6cbe884@huawei.com>
Date: Wed, 26 Oct 2022 11:47:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Martin Wilck <martin.wilck@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
 <20220915181754.GA23693@octiron.msp.redhat.com>
 <2686cb11-3955-e3f0-5f42-647dc9cfed36@huawei.com>
 <1be59335-9ba8-607e-efc2-90feb66901fe@huawei.com>
 <363ff8ee-21f1-92fb-27b9-6c8bfa937543@huawei.com>
 <1aa29975832df778754367c8099fa2f3ddccc812.camel@suse.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <1aa29975832df778754367c8099fa2f3ddccc812.camel@suse.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
Cc: "linfeilong@huawei.com" <linfeilong@huawei.com>,
 "lixiaokeng@huawei.com" <lixiaokeng@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgrlnKggMjAyMi8xMC8yNCAxNTo1OSwgTWFydGluIFdpbGNrIOWGmemBkzoKPiBIZWxsbyBXdSBH
dWFuZ2hhbywKPiAKPiBPbiBNb24sIDIwMjItMTAtMjQgYXQgMTA6MjIgKzA4MDAsIFd1IEd1YW5n
aGFvIHdyb3RlOgo+PiBGcmllbmRseSBwaW5nIC4uLgo+PiBJcyB0aGUgc2VyaWVzIG9mIHBhdGNo
ZXMgZm9yIHZlY3MtPmxvY2sgcmVhZHkgdG8gYmUgbWVyZ2VkIGludG8KPj4gbWFpbmxpbmU/Cj4+
IFRoYW5rcwo+IAo+IEJlbidzIHNlcmllcyBoYXMgYmVlbiBtZXJnZWQgaW4gMC45LjEgYWxyZWFk
eS4gVGhlcmUgaGF2ZSBiZWVuIG5vCj4gcmV2aWV3ZWQgcGF0Y2hlcyBvbiB0b3Agb2YgaXQsIHVu
bGVzcyBJIGFtIG1pc3Rha2VuLgoKWWVzLCBpdCBoYXMgYmVlbiBtZXJnZWQsIHNvcnJ5LgoKPiBC
dHcsIEkgbmV2ZXIgcmVjZWl2ZWQgYW4gYW5zd2VyIGZyb20geW91IGFib3V0IG15IHN1Z2dlc3Rp
b24gZnJvbcKgCj4gU2VwLiAyMDoKPiAKPj4+IFRoZSB2ZXJzaW9uIHdlIGFyZSBjdXJyZW50bHkg
dGVzdGluZyBpcyAwLjguNCwgc28gd2Ugb25seSBtZXJnZSB0aGUKPj4+IGZpcnN0IDMgcGF0Y2hl
cyBpbiB0aGlzIHNlcmllcyBvZiBwYXRjaGVzLiBUaGVuIGFmdGVyIHRoZSBhY3R1YWwKPj4+IHRl
c3QsCj4+PiBpdCB3YXMgZm91bmQgdGhhdCB0aGUgZWZmZWN0IGltcHJvdmVtZW50IGlzIG5vdCB2
ZXJ5IG9idmlvdXMuCj4+Pgo+Pgo+PiBXaGljaCBwYXRoIGNoZWNrZXIgYXJlIHlvdSB1c2luZz8g
Cj4+IElmIGl0J3MgVFVSLCBjb3VsZCB5b3UgdHJ5IHRvIHNpbXBseSBjaGFuZ2UgdGhlIHN5bmMg
d2FpdCB0aW1lPwo+Pgo+PiBzdGF0aWMgdm9pZCB0dXJfdGltZW91dChzdHJ1Y3QgdGltZXNwZWMg
KnRzcCkKPj4gewo+PiAJZ2V0X21vbm90b25pY190aW1lKHRzcCk7Cj4+IAl0c3AtPnR2X25zZWMg
Kz0gMTAwMCAqIDEwMDA7IC8qIDEgbWlsbGlzZWNvbmQgKi8KPj4gCW5vcm1hbGl6ZV90aW1lc3Bl
Yyh0c3ApOwo+PiB9Cj4+CgpXZSBhcmUgcmVhZHkgdG8gc3RhcnQgdGhlIHRlc3QgYW5kIHdpbGwg
Z2l2ZSB5b3UgZmVlZGJhY2sgb24gdGhlCnRlc3QgcmVzdWx0cyBsYXRlci4KCj4+IENoYW5nZSB0
aGUgMSBtaWxsaXNlY29uZCBhYm92ZSB0byBlLmcuIG9uZSBtaWNyb3NlY29uZC4gVGhhdCBzaG91
bGQKPj4gc3BlZWQgdXAgdGhlIGNoZWNrZXIgc2lnbmlmaWNhbnRseS4gWW91IHdpbGwgZ2V0IGEg
aGlnaGVyIHJhdGUgb2YKPj4gInBlbmRpbmciIHBhdGggc3RhdGVzLCBidXQgdGhhdCBzaG91bGRu
J3QgbWF0dGVyIG11Y2guCj4+Cj4gCj4gUmVnYXJkcywKPiBNYXJ0aW4KPiAKPiAuCj4gCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

