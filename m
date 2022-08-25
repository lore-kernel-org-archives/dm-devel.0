Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF430C28D13
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661440242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=geyBafCUSYy06fhqHYhw7unbseBRswi02OqFUutWAT0=;
	b=Y0JXVDAeOc7eyM93mn/Psu/heoL9xrjDdZicPz1as6ABpkUK58Ba1KkoxckgxLNd3aq1B/
	OIrzK49OU3XuThhis5qStcouNwTqdN6IAZLyxAgXmmriHoCptqYoD95dIz9vMy8K9E5wqf
	0LtvK9uBIOxY4XXr6NTDNcGe0gOM5J4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-16LoltmtO5yWkQvrBkI5Jw-1; Thu, 25 Aug 2022 11:10:38 -0400
X-MC-Unique: 16LoltmtO5yWkQvrBkI5Jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8DD11C06ECF;
	Thu, 25 Aug 2022 15:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E6A52166B26;
	Thu, 25 Aug 2022 15:10:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BC5F1946A5A;
	Thu, 25 Aug 2022 15:10:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACCE21946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 15:10:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80E6C112131E; Thu, 25 Aug 2022 15:10:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4D11121319
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 15:10:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61100101E98A
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 15:10:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-178-r_LOoL2nOtSNGKoqzyKiuA-1; Thu,
 25 Aug 2022 11:10:29 -0400
X-MC-Unique: r_LOoL2nOtSNGKoqzyKiuA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 7F02933A73;
 Thu, 25 Aug 2022 15:10:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4894113ADD;
 Thu, 25 Aug 2022 15:10:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id LSIvBeKQB2NNXwAAMHmgww
 (envelope-from <colyli@suse.de>); Thu, 25 Aug 2022 15:10:26 +0000
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
From: Coly Li <colyli@suse.de>
In-Reply-To: <7e9083d9-36c8-5bc5-8787-77bec7cf5314@redhat.com>
Date: Thu, 25 Aug 2022 23:10:23 +0800
Message-Id: <E29CD60E-8E0B-4CE7-8F85-3CEC6684E28C@suse.de>
References: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
 <alpine.LRH.2.02.2208241530300.1585@file01.intranet.prod.int.rdu2.redhat.com>
 <790dbd9d-bc22-9814-2823-8882a95ec57c@gmail.com>
 <alpine.LRH.2.02.2208250909450.22325@file01.intranet.prod.int.rdu2.redhat.com>
 <7e9083d9-36c8-5bc5-8787-77bec7cf5314@redhat.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
 Zdenek Kabelac <zdenek.kabelac@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cgo+IDIwMjLlubQ45pyIMjXml6UgMjE6NDnvvIxaZGVuZWsgS2FiZWxhYyA8emthYmVsYWNAcmVk
aGF0LmNvbT4g5YaZ6YGT77yaCj4gCj4gRG5lIDI1LiAwOC4gMjIgdiAxNTozMiBNaWt1bGFzIFBh
dG9ja2EgbmFwc2FsKGEpOgo+PiAKPj4gT24gVGh1LCAyNSBBdWcgMjAyMiwgWmRlbmVrIEthYmVs
YWMgd3JvdGU6Cj4+IAo+Pj4gU2luY2UgcmVwcm9kdWNpbmcgdGhpcyBpc3N1ZSBpcyByYXRoZXIg
J3RyaXZhbCcgLSBzaW5jZSBjcmVhdGlvbiBvZiBzaW1wbGUKPj4+IGxpbmVhciBETSBkZXZpY2Ug
YW5kIHJlbG9hZGluZyBpdCB3aXRoICdzZWxmLXJlZmVyZW5jZScgdGFibGUgbGluZSBpcyBlYXN5
IEknZAo+Pj4gYWR2b2NhdGUgZm9yIHNvbWUgc2ltcGxpc3RpYyBjaGVjayBvbiBrZXJuZWwgc2lk
ZSAtIGFzIHN1Y2ggJ2NyYXNoJyBjYW4ndCBiZQo+Pj4gZXZlbiByZWJvb3RlZCB3aXRoIFN5c1JR
K0IgKG9uIG15IGxhcHRvcCkuCj4+PiAKPj4+IEkgZ3Vlc3Mgc29tZSAnYml0bWFwL3RyZWUnIG9m
IGFscmVhZHkgdmlzaXRlZCBkZXZpY2UgZHVyaW5nIHNvbWUgY2hlY2sgbWlnaHQKPj4+IGF2b2lk
IGVuZGxlc3MgbG9vcCBhbHRob3VnaCBpdCdzIHF1aXRlICd1Z2x5JyB0aGlzIGNoZWNrIG5lZWRz
IHRvIGhhcHBlbiBvbgo+Pj4gJ3Jlc3VtZScgcGhhc2UgLSBzbyB0aGUgZmFpbHVyZSBoZXJlIGlz
IGhhcmQgdG8gZGVhbCB3aXRoIC0gc3RpbGwgYmV0dGVyIHRoYW4KPj4+IHRoaXMga2VybmVsIGJ1
c3kgbG9vcC4KPj4+IAo+Pj4gWmRlbmVrCj4+IERldGVjdGluZyBkbSB0YWJsZSBzZWxmLXJlZmVy
ZW5jZSBpcyBlYXN5LCBidXQgZGV0ZWN0aW5nIGEgbG9vcCBpbiB0aGUKPj4gZGVwZW5kZW5jeSBn
cmFwaCBpcyBjb21wbGljYXRlZCBhbmQgSSB3b3VsZCd0IGRvIGl0Lgo+PiAKPj4gVGhlcmUgaXMg
YW5vdGhlciAobW9yZSBzZXJpb3VzKSBwcm9ibGVtIC0gdGhlIHVzZXIgY2FuIGNyYXNoIHRoZSBr
ZXJuZWwgYnkKPj4gY3JlYXRpbmcgZGVlcC1lbm91Z2ggbm9uLXJlY3Vyc2l2ZSBtYXBwaW5nLiBX
ZSBkbyBub3Qgc3BlY2lmeSBhbnkgbWF4aW11bQo+PiB0cmVlIGRlcHRoIHRoYXQgaXMgZ3VhcmFu
dGVlZCB0byB3b3JrLiBQZXJoYXBzIHdlIHNob3VsZCBzcGVjaWZ5IHN1Y2gKPj4gZGVwdGggYW5k
IGF1ZGl0IHRoZSBjb2RlIHNvIHRoYXQgdGhpcyBtYXhpbXVtIGRldmljZSBkZXB0aCBkb2Vzbid0
Cj4+IG92ZXJmbG93IHRoZSBzdGFjay4KPiAKPiAKPiB5ZXAgLSBJJ2Qgbm90IG1pbmQgaWYgdGhl
cmUgaXMgYSB0b3RhbCBjaGFpbmluZyBsaW1pdCBlbmZvcmNlZCBvbiBjcmVhdGlvbiBzaWRlIGFz
IHdlbGwuCj4gCj4gU2luY2UgdGhlICdrZXJuZWwgc3RhY2sgc2l6ZScgaXMgbGltaXQgLSB0aGUg
YW1vdW50IG9mIHJlY3Vyc2l2ZSBjYWxscyBpcyBhbHNvIGxpbWl0ZWQgLSBzbyBoYXZpbmcgc3Vj
aCBsaW1pdGF0aW9uIGV4cG9zZWQgb24gJ2NyZWF0aW9uJyB0aW1lIHNlZW1zIGxpa2UgZmFpciBw
YXRoIC0gY29tcGFyZWQgd2l0aCBjcmFzaGluZyBrZXJuZWwgZHVyaW5nICBjaGFpbmcgcHJvY2Vz
c2luZy4uLi4KCkFsdGhvdWdoIEkgZG9u4oCZdCBoYXZlIGRlZXAgdW5kZXJzdGFuZCB0byBkZXZp
Y2UgbWFwcGVyLCBJIGFncmVlIHRoYXQgaXQgc291bmRzIGFzIGEgc2ltcGxlIGFuZCB3b3JraW5n
IHdheSB0byBmaXguCgpUaGFua3MuCgpDb2x5IExpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

