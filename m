Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF2EC55178
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3A6520719
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3A6520719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-ObGhGipDOe-R38-D-2gDJw-1; Thu, 29 Oct 2020 05:07:44 -0400
X-MC-Unique: ObGhGipDOe-R38-D-2gDJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A8606414F;
	Thu, 29 Oct 2020 09:07:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D89045B4C4;
	Thu, 29 Oct 2020 09:07:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2666E5810F;
	Thu, 29 Oct 2020 09:07:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SBfeuu007163 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 07:41:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EB79E1111A75; Wed, 28 Oct 2020 11:41:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E78331016D76
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 11:41:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8630D101A540
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 11:41:36 +0000 (UTC)
Received: from mail-yb1-f195.google.com (mail-yb1-f195.google.com
	[209.85.219.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-559-G9DVHx5eOMC36Wr01IxB-Q-1; Wed, 28 Oct 2020 07:41:34 -0400
X-MC-Unique: G9DVHx5eOMC36Wr01IxB-Q-1
Received: by mail-yb1-f195.google.com with SMTP id s89so3977182ybi.12
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 04:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=9ZlXToatDcyQe4UfooUu3JrhisJTqzWvPk9UeTaykHI=;
	b=a/+rw33qtlaz0O7i+4lj9I7smeJjSzIPYA4kryIC57WjoRPtvywUJltyt4lpErn4j0
	fxr9GAZep5cOZjTe4ONRLwnzP1e5hbPrLEcsqEBiJzcR4GoNkpe4cRn6pkGcbDUfn99b
	kY6jiuhWOxxkygOD7eo77hzkZSg2bH4YqNzc4KIJ59ApNxANzlGVpgieGjo5Sq8vXgmW
	MEqbEzhNOXxJNHBqzzEQZh+1MxOsnEvAKQWOUsyvm5GyLRECHZDnFiZ8yEhKSwqamuYt
	bzmul+cT9VUryTID+GVG0n/cEy0zmPKl9R6UxfYISx/y0nxZhk5UNbRtDerGEckESJ/H
	YVbA==
X-Gm-Message-State: AOAM533bzOI21Z58kLzhpa4oOZl1ITeURG2lqj4yVceBxnrwxhCKfPjI
	hDs+MInSOepTpylNg/JaaIKhv/dI4tC5YJiBxiJ6sQ==
X-Google-Smtp-Source: ABdhPJwPEPpN0dIcKBfaGDgutMYF3sOkE6KoP9i1uddB1epbqqtMw2qCiW/gFeatIzJ1+Wk2li1pZyaWC1wQlcX+ghA=
X-Received: by 2002:a25:41d0:: with SMTP id o199mr9520447yba.276.1603885293714;
	Wed, 28 Oct 2020 04:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
	<20201026175231.GG858@sol.localdomain>
	<d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
	<20201026183936.GJ858@sol.localdomain>
	<20201026184155.GA6863@gondor.apana.org.au>
	<20201026184402.GA6908@gondor.apana.org.au>
In-Reply-To: <20201026184402.GA6908@gondor.apana.org.au>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Wed, 28 Oct 2020 13:41:28 +0200
Message-ID: <CAOtvUMf-xv5cHTjExW2Ffx6soLavFztow6DwE6Qo5pffF0N5uw@mail.gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09SBfeuu007163
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 29 Oct 2020 05:07:35 -0400
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm crypt: switch to EBOIV crypto API
	template
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBPY3QgMjYsIDIwMjAgYXQgODo0NCBQTSBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXU+IHdyb3RlOgo+Cj4gT24gVHVlLCBPY3QgMjcsIDIwMjAgYXQgMDU6NDE6
NTVBTSArMTEwMCwgSGVyYmVydCBYdSB3cm90ZToKPiA+Cj4gPiBUaGUgcG9pbnQgaXMgdGhhdCBw
ZW9wbGUgcmVidWlsZGluZyB0aGVpciBrZXJuZWwgY2FuIGVuZCB1cCB3aXRoIGEKPiA+IGJyb2tl
biBzeXN0ZW0uICBKdXN0IHNldCBhIGRlZmF1bHQgb24gRUJPSVYgaWYgZG0tY3J5cHQgaXMgb24u
Cj4KPiBUaGF0J3Mgbm90IGVub3VnaCBhcyBpdCdzIGFuIGV4aXN0aW5nIG9wdGlvbi4gIFNvIHdl
IG5lZWQgdG8KPiBhZGQgYSBuZXcgS2NvbmZpZyBvcHRpb24gd2l0aCBhIGRlZmF1bHQgZXF1YWwg
dG8gZG0tY3J5cHQuCgpTb3JyeSBpZiBJJ20gYmVpbmcgZGFmdCwgYnV0IHdoYXQgZGlkIHlvdSBy
ZWZlciB0byBiZSAiYW4gZXhpc3RpbmcKb3B0aW9uIj8gdGhlcmUgd2FzIG5vIENPTkZJR19FQk9J
ViBiZWZvcmUgbXkgcGF0Y2hzZXQsIGl0IHdhcyBzaW1wbHkKYnVpbHQgYXMgcGFydCBvZiBkbS1j
cnlwdCBzbyBpdCBzZWVtcyB0aGF0IHNldHRpbmcgQ09ORklHX0VCT0lWCmRlZmF1bHQgdG8gZG0t
Y3J5cHRvIEtjb25maWcgb3B0aW9uIHZhbHVlIGRvZXMgc29sdmVzIHRoZSBwcm9ibGVtLCBvcgpo
YXZlIEkgbWlzc2VkIHNvbWV0aGluZz8KClRoYW5rcywKR2lsYWQKCi0tIApHaWxhZCBCZW4tWW9z
c2VmCkNoaWVmIENvZmZlZSBEcmlua2VyCgp2YWx1ZXMgb2YgzrIgd2lsbCBnaXZlIHJpc2UgdG8g
ZG9tIQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

