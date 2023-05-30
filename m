Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C63C7EE31
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A4d/PYecyOLmiF2eJtIj95lZaI2aWCOhd6vohJUHG9M=;
	b=F7JqIXkG/iUAAX/GIuWYdDUwl4LYR0p9HgIAKKr8NxWi+e5bYEB2RGS8GoOb/Wy2iDwHnu
	kzufwHgSW2ID7BBkOhq5aGXdvtn15Q7P6LL6rEEvjQACIQHgvr21sa6aIUhbeM4KOK5ECh
	4g37UL/SFRhi1la1jDUHyV/LkZrs+cI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-inwxYftGNbqiQAcdBlM-3w-1; Tue, 30 May 2023 16:54:40 -0400
X-MC-Unique: inwxYftGNbqiQAcdBlM-3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2921F101B42F;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BAF35111F3C7;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04DD819451F0;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2821019465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C983492B00; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0495048205E
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD139101A531
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-QM5_bhufOP-VBWuk9LR8vQ-1; Tue, 30 May 2023 16:40:53 -0400
X-MC-Unique: QM5_bhufOP-VBWuk9LR8vQ-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 32CF03200962;
 Tue, 30 May 2023 16:32:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Tue, 30 May 2023 16:32:18 -0400
X-ME-Sender: <xms:UV12ZJsB7-6thDBOW04ZBm8dwA1w8OqPQmWsHPIsTD85Gotn6oCtAQ>
 <xme:UV12ZCcND6TvIARXd8QOOkdba5asaIVOCge4bX4g8CQ5jmO5RYFcsdAxDLYUr6xpT
 K7j0UTQ4KOSnXg>
X-ME-Received: <xmr:UV12ZMz7jUkHkkTvC4PaB0pWjhII28OE1-d4VoJYh3Rk5KoK5polsbsvSHQ6A82D-keKTXHm8f0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepffgv
 mhhiucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhih
 hnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepkeefieekhfdtgeeuueelleeg
 vdetieehgfejteduvedvvdejudetudelfedukefhnecuffhomhgrihhnpehinhguihhrvg
 gtthdrnhhrpdhinhguihhrvggtthdrihgunecuvehluhhsthgvrhfuihiivgeptdenucfr
 rghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
 grsgdrtghomh
X-ME-Proxy: <xmx:UV12ZAPqoC6ugOyhqw12hilSeplCRnKjnOlJfmhYkOVrSOBnWerfZA>
 <xmx:UV12ZJ8Zyv2sMdGJ8yUkzVbNcYb8OnOE3NDfnKK7_d4J77we3bDJpQ>
 <xmx:UV12ZAVfjKO8vuRkhvcAjXEFakWAjuI2n5mclwt9ec30GFsNgGodag>
 <xmx:UV12ZCMvAk4xGoCgzeqg5Gt0J8JIuCFJuktUAcqyZrosY5iMdZIIaw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:16 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:15 -0400
Message-Id: <20230530203116.2008-16-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 15/16] xen-blkback: Minor cleanups
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhpcyBhZGRzIGEgY291cGxlIG9mIEJVSUxEX0JVR19PTigpcyBhbmQgbW92ZXMgc29tZSBhcml0
aG1ldGljIGFmdGVyCnRoZSB2YWxpZGF0aW9uIGNvZGUgdGhhdCBjaGVja3MgdGhlIGFyaXRobWV0
aWPigJlzIHByZWNvbmRpdGlvbnMuICBUaGUKcHJldmlvdXMgY29kZSB3YXMgY29ycmVjdCBidXQg
Y291bGQgcG90ZW50aWFsbHkgdHJpcCBzYW5pdGl6ZXJzIHRoYXQKY2hlY2sgZm9yIHVuc2lnbmVk
IGludGVnZXIgd3JhcGFyb3VuZC4KClNpZ25lZC1vZmYtYnk6IERlbWkgTWFyaWUgT2Jlbm91ciA8
ZGVtaUBpbnZpc2libGV0aGluZ3NsYWIuY29tPgotLS0KIGRyaXZlcnMvYmxvY2sveGVuLWJsa2Jh
Y2svYmxrYmFjay5jIHwgOCArKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNr
L2Jsa2JhY2suYyBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svYmxrYmFjay5jCmluZGV4IGMz
NjJmNGFkODBhYjA3YmZiNThjYWZmMGVkN2RhMzdkYzE0ODRmYzUuLmFjNzYwYTA4ZDU1OTA4NWFi
ODc1Nzg0ZjFjNThjZGYyZWFkOTVhNDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYmxvY2sveGVuLWJs
a2JhY2svYmxrYmFjay5jCisrKyBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svYmxrYmFjay5j
CkBAIC0xMzQyLDYgKzEzNDIsOCBAQCBzdGF0aWMgaW50IGRpc3BhdGNoX3J3X2Jsb2NrX2lvKHN0
cnVjdCB4ZW5fYmxraWZfcmluZyAqcmluZywKIAluc2VnID0gcmVxLT5vcGVyYXRpb24gPT0gQkxL
SUZfT1BfSU5ESVJFQ1QgPwogCSAgICAgICByZXEtPnUuaW5kaXJlY3QubnJfc2VnbWVudHMgOiBy
ZXEtPnUucncubnJfc2VnbWVudHM7CiAKKwlCVUlMRF9CVUdfT04ob2Zmc2V0b2Yoc3RydWN0IGJs
a2lmX3JlcXVlc3QsIHUucncuaWQpICE9IDgpOworCUJVSUxEX0JVR19PTihvZmZzZXRvZihzdHJ1
Y3QgYmxraWZfcmVxdWVzdCwgdS5pbmRpcmVjdC5pZCkgIT0gOCk7CiAJaWYgKHVubGlrZWx5KG5z
ZWcgPT0gMCAmJiBvcGVyYXRpb25fZmxhZ3MgIT0gUkVRX1BSRUZMVVNIKSB8fAogCSAgICB1bmxp
a2VseSgocmVxLT5vcGVyYXRpb24gIT0gQkxLSUZfT1BfSU5ESVJFQ1QpICYmCiAJCSAgICAgKG5z
ZWcgPiBCTEtJRl9NQVhfU0VHTUVOVFNfUEVSX1JFUVVFU1QpKSB8fApAQCAtMTM2NSwxMyArMTM2
NywxMyBAQCBzdGF0aWMgaW50IGRpc3BhdGNoX3J3X2Jsb2NrX2lvKHN0cnVjdCB4ZW5fYmxraWZf
cmluZyAqcmluZywKIAkJcHJlcS5zZWN0b3JfbnVtYmVyICAgICA9IHJlcS0+dS5ydy5zZWN0b3Jf
bnVtYmVyOwogCQlmb3IgKGkgPSAwOyBpIDwgbnNlZzsgaSsrKSB7CiAJCQlwYWdlc1tpXS0+Z3Jl
ZiA9IHJlcS0+dS5ydy5zZWdbaV0uZ3JlZjsKLQkJCXNlZ1tpXS5uc2VjID0gcmVxLT51LnJ3LnNl
Z1tpXS5sYXN0X3NlY3QgLQotCQkJCXJlcS0+dS5ydy5zZWdbaV0uZmlyc3Rfc2VjdCArIDE7Ci0J
CQlzZWdbaV0ub2Zmc2V0ID0gKHJlcS0+dS5ydy5zZWdbaV0uZmlyc3Rfc2VjdCA8PCA5KTsKIAkJ
CWlmICgocmVxLT51LnJ3LnNlZ1tpXS5sYXN0X3NlY3QgPj0gKFhFTl9QQUdFX1NJWkUgPj4gOSkp
IHx8CiAJCQkgICAgKHJlcS0+dS5ydy5zZWdbaV0ubGFzdF9zZWN0IDwKIAkJCSAgICAgcmVxLT51
LnJ3LnNlZ1tpXS5maXJzdF9zZWN0KSkKIAkJCQlnb3RvIGZhaWxfcmVzcG9uc2U7CisJCQlzZWdb
aV0ubnNlYyA9IHJlcS0+dS5ydy5zZWdbaV0ubGFzdF9zZWN0IC0KKwkJCQlyZXEtPnUucncuc2Vn
W2ldLmZpcnN0X3NlY3QgKyAxOworCQkJc2VnW2ldLm9mZnNldCA9IChyZXEtPnUucncuc2VnW2ld
LmZpcnN0X3NlY3QgPDwgOSk7CiAJCQlwcmVxLm5yX3NlY3RzICs9IHNlZ1tpXS5uc2VjOwogCQl9
CiAJfSBlbHNlIHsKLS0gClNpbmNlcmVseSwKRGVtaSBNYXJpZSBPYmVub3VyIChzaGUvaGVyL2hl
cnMpCkludmlzaWJsZSBUaGluZ3MgTGFiCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

