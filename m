Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84914EB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/9bHE6Mv/Xlzt7RCtcE5YVp7s1jEZ+Pf8fvWS0XcJ1o=;
	b=HNCFI1Jw2p4a0+JsXwnzyc8zBGrlU4Pxn5gzUWb6pRskULQRCDrQKbWpSkf6+XjxwiePvo
	6e+DL+97x00poomVpv7VuWEt3jwvj+3xVfu0Z7O47wN9GH86fbalFh3HyaVAU5KRqRau+1
	rt9ykWpR1TwGycisV4zWFIRCMI9/36I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-g8_BUKfCOPqYqR1gDK_OtA-1; Mon, 10 Jul 2023 02:47:05 -0400
X-MC-Unique: g8_BUKfCOPqYqR1gDK_OtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 076AF1C31C4A;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E86D04087C76;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20697194973D;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4D4231946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 13:30:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D0A8200BA86; Mon, 26 Jun 2023 13:30:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25A1A200B680
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 13:30:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E285D1C17100
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 13:30:54 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533---Jb4RFWNDuxmn5eFtkX3A-1; Mon,
 26 Jun 2023 09:30:51 -0400
X-MC-Unique: --Jb4RFWNDuxmn5eFtkX3A-1
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MzTPQ-1prh7G0ZHc-00vJUl; Mon, 26
 Jun 2023 15:30:46 +0200
Message-ID: <c1b84520-94d2-2c5c-6eed-2a0697c086a4@web.de>
Date: Mon, 26 Jun 2023 15:30:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Demi Marie Obenour <demi@invisiblethingslab.com>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de> <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
X-Provags-ID: V03:K1:PWV1X48nKTiaPJnby9LWHPIXiY/KFzAgQJzZCIDJr2bpJ7lmnfp
 BiSuw4GF3q0yqn6Vtk4gEcgqkVGK0vZxf9hcgC0dXYcYDM3wfFvM9d09m065xvWfWwvkdXX
 X1Y3rbPAOCQPWgtc+7n3sgeZhZuZm2YiRpsiXIxfBrEfOJAtkjgU2CMy0p7nt8ogT9BqqYI
 AYNBE4xL0P4rLkAo6CDfQ==
UI-OutboundReport: notjunk:1;M01:P0:eJsgLYDFf74=;cy0cr0jyYdJ/dT16JaCx599d90j
 lQwhv0e7nn5beC0kRpB8YSfpICmfuz1+MuF1VFjJVElJHTV6d2VK0CWlH0yv91mIjZryyPhMF
 G2RZ8nWsLWLuIKRlAFJR2tT9s07kQeejg+sKz0QE4eURznCk+cv8ipGIPv+P5daC4M4OYXC1o
 Kf7GDaX7Up7v1M1BGmuxV98e6QiFFY99VmNrEKEvOT89rKUvDs13YIO26j1KVjSDcKaLKkRPB
 bMwCI9f2xMOfHb0pmcsjYeLOA78esC8EoXjgmLOu6KMi/7sk5Fa4suwhzmd1HRBjkIBWrDc3k
 clhlkGOXxhQtVIrMxB06nGTzHelFTxk8oblmJwOM6Mce5Dij9qHTwi0eOS96QUEQ8L3ZMHeuM
 Dfafdp8drReMhQU6f95MUk6zjcyZfo9UhzzCugWso26/vudYHDD5wIZ7A2IqbrCWtuAVYJMs5
 WipJkwbrfCn30g5f+Wq18XHPml5UOeAqyG5bW9ajO5mjc3eg3/HG0b2Lg4zXRGEN2+yXUenu/
 Xjv22CypXNTWTO0G6L0uTskwPYUsKrJ5QwmbTwHE2hJv9XQxhJi8KeBp0fCQJIDEbM81/Glps
 KMPxp/TdPE8WwYG5PLOt6UE2l0eS0kKfSgqlcFjDqQWIqkNNYmIhyO6rifd/zKOUZbDtgtEFz
 PgUHh9hPUPVGDFvdS6stQt3SvRUH2q/priC6+C8no8rmrjz7f7n9cwSLQukgd/E+rJ4KBMAQt
 TV19gRFUi1ELNTcxb2SsGwcFZE/GBuPpxHKqL4C6t4URxFcfN0Yw1/j/VpEWra+IyRoDDjj6T
 KgMiwduQM9wv09AC4EWWUwnRFkYjtQE7S7P3PpLngeyfQ/0LlPYBRORmjSxImRQ/Dl/LB/Pep
 POnDQWHWg3I1OSwfEw/L/C00vZEK75TBSBg7hybI1cbYlydcXN/qAOflAN9si4kL5PVpTfPZh
 jA2Pfg==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: web.de
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBNYXJrdXMsIHN0b3AgYm90aGVyaW5nIHBlb3BsZSBhYm91dCB0cml2aWFsIG5vbnNlbnNlLgoK
SSBzdWdnZXN0IHRvIHJlY29uc2lkZXIgc3VjaCBmZWVkYmFjayBhIGJpdCBtb3JlLgoKSSBnb3Qg
dGhlIGltcHJlc3Npb24gdGhhdCBhbiBpbmZvcm1hdGlvbiBsaWtlIOKAnERlc2NyaWJlIHlvdXIg
Y2hhbmdlcyBpbiBpbXBlcmF0aXZlIG1vb2TigJ0KYmVsb25ncyB0byBhIGJhc2ljIHJlcXVpcmVt
ZW50LgpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2
YWxkcy9saW51eC5naXQvdHJlZS9Eb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc3VibWl0dGluZy1wYXRj
aGVzLnJzdD9oPXY2LjQjbjk0CgoKWW91IHNoYXJlZCB5b3VyIHNwZWNpYWwgb3BpbmlvbnMgZm9y
IHRoaXMgdG9waWMgYWxzbyBhdCBvdGhlciBwbGFjZXMgcmVjZW50bHksCmRpZG4ndCB5b3U/CgoK
PiBJJ3ZlIHNhaWQgdGhpcyB0byB5b3UgYmVmb3JlLCB0aGF0IGlmIHlvdSBzcG90IGEgYnVnIGlu
IGEgcGF0Y2gKCkkgZ290IHRyYWluZWQgdG8gdGFrZSBhbHNvIGFub3RoZXIgbG9vayBhdCB2YXJp
b3VzIGNoYW5nZSBkZXNjcmlwdGlvbnMuCgoKPiB0aGF0J3Mgd2VsY29tZSBmZWVkYmFjawoKRnVy
dGhlciBkZXRhaWxzIGNhbiBvY2Nhc2lvbmFsbHkgYmUgaW1wcm92ZWQgYnkgdGhlIG1lYW5zIG9m
IHBhdGNoIHJldmlld3MuCgoKPiBidXQgaWYgeW91IGp1c3QgaGF2ZSBjb21tZW50cyBhYm91dCBn
cmFtbWFyIHRoZW4gbm8gb25lIHdhbnRzIHRoYXQuCgpJIGtub3cgdGhhdCBzb21lIGNvbnRyaWJ1
dG9ycyBhbmQgbWFpbnRhaW5lcnMgd291bGQgbGlrZSB0byBjYXJlIGZvciBuaWNlciB3b3JkaW5n
cy4KClJlZ2FyZHMsCk1hcmt1cwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

