Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587EFC54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 13 Sep 2022 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663080362;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jzYG9GKkaptXv/4gulUIi16P7Q6TCTPZPXmJxxXVvMY=;
	b=OhzqztJuaFw+FuyFFUhoxFKdNjz+ppwp/Gu99LQcdiX/Snu/yF8VAjSU4i/7xlEYCtMMej
	rEkFFt0Qi/9rGDzdSkebxJqfDGsSxTRfmzpL3tEpflOMdhkuNQM8RFCVEtjchHJ4PxbTvI
	BPUfSI8gfBmkxXEOHqTdSQihabowMao=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-yScWLOvJPBKbBZ9vbuoIVQ-1; Tue, 13 Sep 2022 10:45:57 -0400
X-MC-Unique: yScWLOvJPBKbBZ9vbuoIVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B232811E9B;
	Tue, 13 Sep 2022 14:45:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5521C10EB8;
	Tue, 13 Sep 2022 14:45:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34C8E1946A43;
	Tue, 13 Sep 2022 14:45:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 774991946A41
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Sep 2022 14:45:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4943849BB68; Tue, 13 Sep 2022 14:45:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FF7B49BB63
 for <dm-devel@redhat.com>; Tue, 13 Sep 2022 14:45:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D7AC1C006BA
 for <dm-devel@redhat.com>; Tue, 13 Sep 2022 14:45:50 +0000 (UTC)
Received: from forward108j.mail.yandex.net (forward108j.mail.yandex.net
 [5.45.198.253]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-HEm7dpH1O12x_gXQ6L7lsg-1; Tue, 13 Sep 2022 10:45:48 -0400
X-MC-Unique: HEm7dpH1O12x_gXQ6L7lsg-1
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net
 [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
 by forward108j.mail.yandex.net (Yandex) with ESMTP id 253BC3F22886
 for <dm-devel@redhat.com>; Tue, 13 Sep 2022 17:37:48 +0300 (MSK)
Received: from vla3-23c3b031fed5.qloud-c.yandex.net
 (vla3-23c3b031fed5.qloud-c.yandex.net
 [IPv6:2a02:6b8:c15:2582:0:640:23c3:b031])
 by forward102q.mail.yandex.net (Yandex) with ESMTP id 2041CBF00002
 for <dm-devel@redhat.com>; Tue, 13 Sep 2022 17:37:48 +0300 (MSK)
Received: by vla3-23c3b031fed5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA
 id unx9pDVs0j-bli4fmjp; Tue, 13 Sep 2022 17:37:47 +0300
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client certificate not present)
X-Yandex-Fwd: 1
Message-ID: <919bbae705f5a5351274292713dfacbf011971e6.camel@yandex.ru>
From: Konstantin Kharlamov <hi-angel@yandex.ru>
To: dm-devel@redhat.com
Date: Tue, 13 Sep 2022 17:37:40 +0300
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] =?utf-8?q?How_to_debug_missing_devices_in_=60multipat?=
 =?utf-8?b?aCAtbGAgKGFuZCDigKZgLWxsYCk=?=
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8hIFNvcnJ5IGlmIGl0J3MgdGhlIHdyb25nIGxpc3QsIGl0IGlzIHJlZmVycmVkIHRvIGJ5
IG11bHRpcGF0aC10b29scwp3aXRob3V0IHNheWluZyBpdCdzICJkZXZlbCIsIHNvIEkgcHJlc3Vt
ZSB1c2VyIHF1ZXN0aW9ucyBhcmUgb2theeKApj8KCkhvdyB0byBkZWJ1ZyBhIGxhY2sgb2YgZGV2
aWNlcyBpbiBgbXVsdGlwYXRoIC1sYCBhbmQgYOKApiAtbGxgIG91dHB1dHM/IEknbQpzdHVkeWlu
ZyBgbXVsdGlwYXRoZCAtZHY1YCBsb2dzLCBidXQgaXQncyBub3QgYXQgYWxsIGNsZWFyIHRvIG1l
IGFzIHRvIHdoYXQgdG8KbG9vayBmb3IuCgpBdCAkV09SSyBJJ20gdHJ5aW5nIHRvIHJlcGxhY2Ug
dGhlIG9sZGVyIFVidW50dSBzaGlwcGVkIG11bHRpcGF0aC10b29scyB3aXRoIHRoZQp1cHN0cmVh
bSBvbmUuIFRoZW4sIGdpdmVuIGEgc3lzdGVtIHdpdGggdGhlIHVwc3RyZWFtIGBtdWx0aXBhdGgt
dG9vbHNgCnByZWluc3RhbGxlZCBhbmQgYG11bHRpcGF0aGRgIHJ1bm5pbmcsIG5vbmUgb2YgdGhl
IGBtdWx0aXBhdGggLWxgIG9yIGBtdWx0aXBhdGgKLWxsYCBzaG93IG91dHB1dC4gVGhlbiwgaWYg
SSBkb3duZ3JhZGUgYG11bHRpcGF0aC10b29sc2AgdG8gdGhlIG9uZSBmcm9tIFVidW50dQpyZXBv
c2l0b3J5IGFuZCByZXN0YXJ0IGBtdWx0aXBhdGhkYCwgZGV2aWNlcyBkbyBhcHBlYXIuCgpUaGVu
IGl0IGdldHMgd2VpcmQ6IGlmIEkgdXBncmFkZSBgbXVsdGlwYXRoLXRvb2xzYCBiYWNrIHRvIHRo
ZSBsYXRlc3Qgb25lCnVwc3RyZWFtLCBhbmQgcmVib290LCBkZXZpY2VzIGFyZSBzdGlsbCB0aGVy
ZSEgSXQgc3RhcnRzIHdvcmtpbmchCgpBdCB0aGlzIHBvaW50IEkgZm91bmQgdGhlIGAvZXRjL211
bHRpcGF0aC93d2lkc2Agd2hpY2ggbWlnaHQgYmUgdGhlIHJlYXNvbi4gSQpwcmVzdW1lIGBtdWx0
aXBhdGhkYCBwdXRzIGRldmljZXMgdGhlcmUgdW5kZXIgc29tZSBjb25kaXRpb25zLiBCdXQgd2hl
cmUgY2FuIEkKc2VlIGhvdyBpdCBkZWNpZGVzIHdoZXRoZXIgdG8gd29yayB3aXRoIGRldmljZXMg
b3IgdG8gaWdub3JlIHRoZW0/IEknbSBsb29raW5nCnRocm91Z2ggLXY1IHN0YXJ0dXAgbG9ncyB3
aGVuIGl0J3Mgd29ya2luZyBhbmQgd2hlbiBpdCBkb2Vzbid0LCB0aGVyZSdzIGEgbG90IG9mCm91
dHB1dCwgYnV0IGl0J3MgaGFyZCB0byBgZGlmZmAgdGhlIG9sZGVyICh3b3JraW5nKSBhbmQgdGhl
IG5ld2VyIChub3Qgd29ya2luZykKb3V0cHV0IOKAlCBhIGxvdCBvZiBzdHlsZSBjaGFuZ2VzLiBF
bnRyaWVzIEkgZmluZCBzdXNwaWNpb3VzIGFyZSByZXBlYXRlZCBpbiBib3RoCmNhc2VzLgoKSSBm
aWd1cmVkLCBpdCBtaWdodCBhc2sgaGVyZSBmb3IgcG9pbnRlcnMsIGlzIHRoZXJlIHNvbWV0aGlu
ZyBzcGVjaWZpYyB0byBsb29rCmZvcj8KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

