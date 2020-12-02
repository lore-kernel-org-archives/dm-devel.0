Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50721C71155
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 797AE22203
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 797AE22203
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-K4J1WEnbPMONiE2_xoFsHQ-1; Wed, 02 Dec 2020 04:55:37 -0500
X-MC-Unique: K4J1WEnbPMONiE2_xoFsHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C80A1016CE4;
	Wed,  2 Dec 2020 09:55:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E43645D9CA;
	Wed,  2 Dec 2020 09:55:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B9A1750031;
	Wed,  2 Dec 2020 09:55:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B28Twcn030242 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 03:29:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 068911004149; Wed,  2 Dec 2020 08:29:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03121112D190
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 08:29:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0AD4185A794
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 08:29:54 +0000 (UTC)
Received: from mail-yb1-f193.google.com (mail-yb1-f193.google.com
	[209.85.219.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-36-lWvSMGUdMTSvcImoF2SPcw-1; Wed, 02 Dec 2020 03:29:52 -0500
X-MC-Unique: lWvSMGUdMTSvcImoF2SPcw-1
Received: by mail-yb1-f193.google.com with SMTP id r127so851637yba.10
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 00:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=S+qYG3f+zkwp5W/+x0WfTqqNUJfNcCEhpNZcMzYMnsY=;
	b=rQiLoqTu+7rgWha0LdyIYId8vkSzRro1ZgYZmnTLg339htgj3IBddOhxOksc0wKSiG
	gvsWYVJBaUYTF4I3lZKx6HdYsGaZGWUlvPTyIU3HudIXp5I623dSX9RmQsuUzGpOKGmn
	U9UMgJA9+xB8SBscdJ3uotjpJ1IIebuMioASACxdr1B51QEAh0McP+Y2WmpfBaIz8omn
	oh4EHSTi64A0o3xXo8nIKKW62snkQplv6rB/2HWX21WnyllaTMSvkOkKv1vIquBqoMnY
	dDwQ/yggKppXBtzffd8VjUKxD24Cq8jOhhLNHtOHbcLkUYECYQvlNF5E1Fe4RCLDgYeW
	qniw==
X-Gm-Message-State: AOAM532ia0dcB+bpU2RKZA5OTxD7mWg+BJDnu/Ha70EwTpxRXgz0GhuU
	kb1yiHXyPwKyW9cpOxuS1bF6+nUOXwbvNNA0qSqPag==
X-Google-Smtp-Source: ABdhPJwV3FBwA2qFAdWGwaboQeEdSyY6bd0OBIdiWDaYOWd2f5VfmP8Cw4XzNOSvkR+6seDUsZ9PNk8W4ihWppS45Gs=
X-Received: by 2002:a25:45:: with SMTP id 66mr2335941yba.81.1606897791936;
	Wed, 02 Dec 2020 00:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20201029100546.28686-1-gilad@benyossef.com>
In-Reply-To: <20201029100546.28686-1-gilad@benyossef.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Wed, 2 Dec 2020 10:29:40 +0200
Message-ID: <CAOtvUMcGMTp78XnZ+zK=s3_-MtvDVrUV0PJeG9MWUOJSpAw5=g@mail.gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B28Twcn030242
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Dec 2020 04:55:04 -0500
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Milan Broz <gmazyland@gmail.com>, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH v3 0/4] crypto: switch to crypto API for
	EBOIV generation
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpPbiBUaHUsIE9jdCAyOSwgMjAyMCBhdCAxMjowNSBQTSBHaWxhZCBCZW4tWW9zc2VmIDxn
aWxhZEBiZW55b3NzZWYuY29tPiB3cm90ZToKPgo+Cj4gVGhpcyBzZXJpZXMgY3JlYXRlcyBhbiBF
Qk9JViB0ZW1wbGF0ZSB0aGF0IHByb2R1Y2VzIGEgc2tjaXBoZXIKPiB0cmFuc2Zvcm0gd2hpY2gg
cGFzc2VzIHRocm91Z2ggYWxsIG9wZXJhdGlvbnMgdG8gdGhlIHNrY2lwaGVyLCB3aGlsZQo+IHVz
aW5nIHRoZSBzYW1lIHNrY2lwaGVyIGFuZCBrZXkgdG8gZW5jcnlwdCB0aGUgaW5wdXQgSVYsIHdo
aWNoIGlzCj4gYXNzdW1lZCB0byBiZSBhIHNlY3RvciBvZmZzZXQsIGFsdGhvdWdoIHRoaXMgaXMg
bm90IGVuZm9yY2VkLgoKSSBob3BlIEkgZGlkbid0IG1pc3MgYW55dGhpbmcsIGJ1dCBpdCBzZWVt
cyBJIGRpZG4ndCBnZXQgYW4gQUNLLCBOQUNLCm9yIHJlcXVlc3Qgb2YgY2hhbmdlcyB0byB0aGUg
bGF0ZXN0IGl0ZXJhdGlvbi4KCkFueSBmZWVkYmFjayBpcyB2ZXJ5IG11Y2ggd2VsY29tZS4KClRo
YW5rcywKR2lsYWQKCgotLSAKR2lsYWQgQmVuLVlvc3NlZgpDaGllZiBDb2ZmZWUgRHJpbmtlcgoK
dmFsdWVzIG9mIM6yIHdpbGwgZ2l2ZSByaXNlIHRvIGRvbSEKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

