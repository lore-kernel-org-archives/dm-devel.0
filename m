Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6844FC7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HX/MpJOn4YMUod/2t4fgvzyowI8N+xGTUzJ3Fata6/s=;
	b=H5ucNm0CSwYYKZ7avZw+B9kxUvONlfxpiGJq7W07S2K7D671a4vatHnRmWDIOfA1EO6MOD
	nL6anIvfjwHBuqyxDMmjiMkeiIM5/OINxfMpZ8PnGFNmxGWhkRJcLwojQm327Ftk6w9z0y
	v6aSD/uVk4iBNX9yPX/JpIzLKLu85vE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-uvdX02EZNp6Gzv1Yga1UUw-1; Mon, 05 Jun 2023 01:00:36 -0400
X-MC-Unique: uvdX02EZNp6Gzv1Yga1UUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC7B61C060DD;
	Mon,  5 Jun 2023 05:00:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B3239E75;
	Mon,  5 Jun 2023 05:00:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B28119465A0;
	Mon,  5 Jun 2023 05:00:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 685D91946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:00:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B2C640C6CDF; Mon,  5 Jun 2023 05:00:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0395740C6EC4
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:00:31 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD83C8032E4
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:00:31 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-EVfQpJ35OQCO97dLtsdB9Q-1; Mon, 05 Jun 2023 01:00:28 -0400
X-MC-Unique: EVfQpJ35OQCO97dLtsdB9Q-1
Received: by mail-qv1-f47.google.com with SMTP id
 6a1803df08f44-62606e67c0dso39702926d6.2; 
 Sun, 04 Jun 2023 22:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941228; x=1688533228;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eMHK7oKJtfxrboWZ+YOCD56wMtQusnOlExjiceVji6Y=;
 b=NjiRouKX2vobuc+VGXd1JOEvUH03nj5R8vdT4y/DJuT9SQnNI7dO4zry5sLVld6LXL
 q8ylRKZ2xzAQs2oC+++rHB6GCJviFWQWXhDgudnSutWuBOP1I9spnZoOeBjPuV6pytOE
 KDRBm62lmrm9bF2+p1j21Fje8e9VrbcDmAjW81S+sJMKsxxGmGefPCbGrLhIjgaIcWof
 6F5JiAAmE5c1v3xKj6OICjaBUyScJan3FXisJb6gp/vR1iiRvkoEAODDFgAv+zW4OAT0
 bVLTfDAxe8VmRTGZKDkjJXxg/GvGAwp9/B9xRbPNY/K/KV8AwUkZ9bcxKwshYEyCaHyJ
 OzTQ==
X-Gm-Message-State: AC+VfDz98Hc7IK3y8nzmb5TslM5+AyTaqREzCVGy9ZLYceyAS6dJA0ur
 mrsvPLPxhv5pjl5nzFT5+qjuyLAI2tpd7Ud0usg=
X-Google-Smtp-Source: ACHHUZ42OzC/oLGiNPIulQMfSLig/7ajfXq5lFb82JYgKGctpqoUgJqy30JOKEeygfLpptL1GCLver3IVpkuBCN0/nA=
X-Received: by 2002:a05:6214:2603:b0:621:451b:6e1c with SMTP id
 gu3-20020a056214260300b00621451b6e1cmr7970582qvb.6.1685941227669; Sun, 04 Jun
 2023 22:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-2-eatnumber1@gmail.com>
 <ZH1Qh90x9ncsBTik@debian.me>
In-Reply-To: <ZH1Qh90x9ncsBTik@debian.me>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sun, 4 Jun 2023 22:00:00 -0700
Message-ID: <CA+zrezQT88K85YHuiD3TSmBN-cqhgfSjMp6zo7DoH-AdR3j8yg@mail.gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 1/4] Fix minor grammatical error in
 dm-integrity.rst.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKdW4gNCwgMjAyMyBhdCA4OjAz4oCvUE0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3Rt
ZUBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gT24gU3VuLCBKdW4gMDQsIDIwMjMgYXQgMTI6MDY6MDFQ
TSAtMDcwMCwgUnVzc2VsbCBIYXJtb24gd3JvdGU6Cj4gPiAid2hlcmUgZG0taW50ZWdyaXR5IHVz
ZXMgYml0bWFwIiBiZWNvbWVzICJ3aGVyZSBkbS1pbnRlZ3JpdHkgdXNlcyBhCj4gPiBiaXRtYXAi
Cj4KPiBEbyB5b3UgcmVmZXIgdG8gb25lIGJpdG1hcCBvciB1bmNvdW50YWJsZSBiaXRtYXBzPwo+
Cj4gSSdtIGNvbmZ1c2VkLi4uCgpUaGVyZSBpcyBvbmx5IG9uZSBiaXRtYXAgb24tZGlzaywgd3Jp
dHRlbiB0byBieSBiaXRtYXBfZmx1c2hfd29yayBbMV0uCkluLW1lbW9yeSB0aGVyZSdzIG1hbnkg
KGl0J3Mgc3RvcmVkIGFzIGEgbGlua2VkIGxpc3Qgb2YgcGFnZXMpLCBidXQKdGhlIGRvY3Mgc2Vl
bSB0byBiZSBpbXBsaWNpdGx5IHJlZmVycmluZyB0byB0aGUgb24tZGlzawpyZXByZXNlbnRhdGlv
biwgc28gdGhpcyB3b3VsZCB0aGVyZWZvcmUgYmUgcmVmZXJyaW5nIHRvIGEgc2luZ3VsYXIgbWFw
Cm9mIGJpdHMsIG9yICJhIGJpdG1hcC4iCgpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxk
cy9saW51eC9ibG9iL21hc3Rlci9kcml2ZXJzL21kL2RtLWludGVncml0eS5jI0wyODc2LUwyODc3
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

