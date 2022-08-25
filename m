Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE2CC64990
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661435408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G9PTh6ThxjjE354sft6IYXvdTf9XSIL+GvkAwGp4pVI=;
	b=HAZwHj6ZKcqLApHr+tvz1OiLuILHnvleN1X+p0L/LQI3q8LzFRMyzsx1YeRm6SyfiPt/HJ
	Xu44AMqgyMC1Ps5YvMhXQ8lm9XgSY+DCjJbFCAZAo1uWY2pqDG2AT23RyJgeSAn06tTucH
	pvGRBUOOFVQ7e6rFiBqfFkpnLXB7dTU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-0gJMNlEvPYGQH7MPQ85cPQ-1; Thu, 25 Aug 2022 09:50:07 -0400
X-MC-Unique: 0gJMNlEvPYGQH7MPQ85cPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3FCD1C16B67;
	Thu, 25 Aug 2022 13:49:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47890112131B;
	Thu, 25 Aug 2022 13:49:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31F061946A5A;
	Thu, 25 Aug 2022 13:49:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 341FE1946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 13:49:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0665F1121315; Thu, 25 Aug 2022 13:49:57 +0000 (UTC)
Received: from [10.43.17.48] (unknown [10.43.17.48])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 484031121319;
 Thu, 25 Aug 2022 13:49:56 +0000 (UTC)
Message-ID: <7e9083d9-36c8-5bc5-8787-77bec7cf5314@redhat.com>
Date: Thu, 25 Aug 2022 15:49:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
To: Mikulas Patocka <mpatocka@redhat.com>,
 Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
 <alpine.LRH.2.02.2208241530300.1585@file01.intranet.prod.int.rdu2.redhat.com>
 <790dbd9d-bc22-9814-2823-8882a95ec57c@gmail.com>
 <alpine.LRH.2.02.2208250909450.22325@file01.intranet.prod.int.rdu2.redhat.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2208250909450.22325@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] A kernel panic (or soft lockup) due to stack
 overflow by recursive dm-table reload
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
 Coly Li <colyli@suse.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDI1LiAwOC4gMjIgdiAxNTozMiBNaWt1bGFzIFBhdG9ja2EgbmFwc2FsKGEpOgo+Cj4gT24g
VGh1LCAyNSBBdWcgMjAyMiwgWmRlbmVrIEthYmVsYWMgd3JvdGU6Cj4KPj4gU2luY2UgcmVwcm9k
dWNpbmcgdGhpcyBpc3N1ZSBpcyByYXRoZXIgJ3RyaXZhbCcgLSBzaW5jZSBjcmVhdGlvbiBvZiBz
aW1wbGUKPj4gbGluZWFyIERNIGRldmljZSBhbmQgcmVsb2FkaW5nIGl0IHdpdGggJ3NlbGYtcmVm
ZXJlbmNlJyB0YWJsZSBsaW5lIGlzIGVhc3kgSSdkCj4+IGFkdm9jYXRlIGZvciBzb21lIHNpbXBs
aXN0aWMgY2hlY2sgb24ga2VybmVsIHNpZGUgLSBhcyBzdWNoICdjcmFzaCcgY2FuJ3QgYmUKPj4g
ZXZlbiByZWJvb3RlZCB3aXRoIFN5c1JRK0IgKG9uIG15IGxhcHRvcCkuCj4+Cj4+IEkgZ3Vlc3Mg
c29tZSAnYml0bWFwL3RyZWUnIG9mIGFscmVhZHkgdmlzaXRlZCBkZXZpY2UgZHVyaW5nIHNvbWUg
Y2hlY2sgbWlnaHQKPj4gYXZvaWQgZW5kbGVzcyBsb29wIGFsdGhvdWdoIGl0J3MgcXVpdGUgJ3Vn
bHknIHRoaXMgY2hlY2sgbmVlZHMgdG8gaGFwcGVuIG9uCj4+ICdyZXN1bWUnIHBoYXNlIC0gc28g
dGhlIGZhaWx1cmUgaGVyZSBpcyBoYXJkIHRvIGRlYWwgd2l0aCAtIHN0aWxsIGJldHRlciB0aGFu
Cj4+IHRoaXMga2VybmVsIGJ1c3kgbG9vcC4KPj4KPj4gWmRlbmVrCj4gRGV0ZWN0aW5nIGRtIHRh
YmxlIHNlbGYtcmVmZXJlbmNlIGlzIGVhc3ksIGJ1dCBkZXRlY3RpbmcgYSBsb29wIGluIHRoZQo+
IGRlcGVuZGVuY3kgZ3JhcGggaXMgY29tcGxpY2F0ZWQgYW5kIEkgd291bGQndCBkbyBpdC4KPgo+
IFRoZXJlIGlzIGFub3RoZXIgKG1vcmUgc2VyaW91cykgcHJvYmxlbSAtIHRoZSB1c2VyIGNhbiBj
cmFzaCB0aGUga2VybmVsIGJ5Cj4gY3JlYXRpbmcgZGVlcC1lbm91Z2ggbm9uLXJlY3Vyc2l2ZSBt
YXBwaW5nLiBXZSBkbyBub3Qgc3BlY2lmeSBhbnkgbWF4aW11bQo+IHRyZWUgZGVwdGggdGhhdCBp
cyBndWFyYW50ZWVkIHRvIHdvcmsuIFBlcmhhcHMgd2Ugc2hvdWxkIHNwZWNpZnkgc3VjaAo+IGRl
cHRoIGFuZCBhdWRpdCB0aGUgY29kZSBzbyB0aGF0IHRoaXMgbWF4aW11bSBkZXZpY2UgZGVwdGgg
ZG9lc24ndAo+IG92ZXJmbG93IHRoZSBzdGFjay4KCgp5ZXAgLSBJJ2Qgbm90IG1pbmQgaWYgdGhl
cmUgaXMgYSB0b3RhbCBjaGFpbmluZyBsaW1pdCBlbmZvcmNlZCBvbiBjcmVhdGlvbiAKc2lkZSBh
cyB3ZWxsLgoKU2luY2UgdGhlICdrZXJuZWwgc3RhY2sgc2l6ZScgaXMgbGltaXQgLSB0aGUgYW1v
dW50IG9mIHJlY3Vyc2l2ZSBjYWxscyBpcyBhbHNvIApsaW1pdGVkIC0gc28gaGF2aW5nIHN1Y2gg
bGltaXRhdGlvbiBleHBvc2VkIG9uICdjcmVhdGlvbicgdGltZSBzZWVtcyBsaWtlIGZhaXIgCnBh
dGggLSBjb21wYXJlZCB3aXRoIGNyYXNoaW5nIGtlcm5lbCBkdXJpbmfCoCBjaGFpbmcgcHJvY2Vz
c2luZy4uLi4KClNvIHllYWggLSBwb3NzaWJseSBjaGVja2luZyByZW1haW5pbmcgZnJlZSBzcGFj
ZSBvbiBzdGFjayBtaWdodCBiZSBhbiBlYXN5IHdheSAKaG93IHRvIGRldGVjdCB1bnN1cHBvcnRh
YmxlICdkZXZpY2Ugc3RhY2tpbmcnIGNvbmZpZ3VyYXRpb24uCgoKWmRlbmVrCgoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

