Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82A8C4363A
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 06C63206DC
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06C63206DC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-bArhTxsqOriAKDNQjuoIqg-1; Tue, 27 Oct 2020 05:04:48 -0400
X-MC-Unique: bArhTxsqOriAKDNQjuoIqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E02F1009E2D;
	Tue, 27 Oct 2020 09:04:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FE0D60FC2;
	Tue, 27 Oct 2020 09:04:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18EDB5810F;
	Tue, 27 Oct 2020 09:04:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09R6rJwC008362 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 02:53:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E8996202278E; Tue, 27 Oct 2020 06:53:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3D58207B457
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 06:53:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE3F4185A78B
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 06:53:15 +0000 (UTC)
Received: from mail-yb1-f196.google.com (mail-yb1-f196.google.com
	[209.85.219.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-78-92MHlgXcPfSnJGAICloN6A-1; Tue, 27 Oct 2020 02:53:10 -0400
X-MC-Unique: 92MHlgXcPfSnJGAICloN6A-1
Received: by mail-yb1-f196.google.com with SMTP id s89so330442ybi.12
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 23:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=jjdl2dhuJDpqYsWLtlxuvUmg+zpTbJsyzx07rWA+3Bc=;
	b=ZGtFnreZMZzBoApGMUkDnG5SNVFhfclcIgNfTjoT/g0ubF8k3R6W7p4PmAfO43mb5d
	iD7zpFWBVO+XS05rT3dm64QdY5g/Epc6SEGldASZJBhkYwHtAur+Rg/+hbzn1Op6LLtk
	90zfTWWF7xsGXO4a6QsQCBKtopXwzA7JAQFapMEgSsIEeWUvR+Z+1wcAkYz86a32kGaO
	UmSLqS3dPCZy+Mzr3n5ZmiERG5XiiHJWm/Vx93xBnBC9VyB+ywvgpqYjUyYk8yAgQF5J
	GMBc0GAGHXXNmbM/lhS8FMt5n5tN1NOdAZo3kwA4aDNNwB6s8eS7zxvUA5qfI1C1okyL
	R0KQ==
X-Gm-Message-State: AOAM530Lb+TVhsFJDmRln9JLu9dLKtcHDV8pCKSf23e+hewmWncJtVF0
	FveIUxcxn6CSNBPMOYAQGkbn2RZBdyuLBUKDnwmQO/8eNxQ0FQ==
X-Google-Smtp-Source: ABdhPJxG5Y81UbMg7yEAt0cjolVbinIPl2JL51jHpZOjbo4cTYsOAAhcLTlsA0vigb1dxR69f3JTQzU4O+5S2/bIvPE=
X-Received: by 2002:a25:774f:: with SMTP id s76mr1026683ybc.235.1603781589825; 
	Mon, 26 Oct 2020 23:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-2-gilad@benyossef.com>
	<20201026182448.GH858@sol.localdomain>
	<20201026182628.GI858@sol.localdomain>
In-Reply-To: <20201026182628.GI858@sol.localdomain>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Tue, 27 Oct 2020 08:53:04 +0200
Message-ID: <CAOtvUMe=KnRahskJtEh1pgyBfGoeZw0Vsq00Hvh+A_enVFVwZQ@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09R6rJwC008362
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 1/4] crypto: add eboiv as a crypto API
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBPY3QgMjYsIDIwMjAgYXQgODoyNiBQTSBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGtl
cm5lbC5vcmc+IHdyb3RlOgoKPgo+IEhlcmUncyB0aGUgdmVyc2lvbiBvZiBlYm9pdl9jcmVhdGUo
KSBJIHJlY29tbWVuZCAodW50ZXN0ZWQpOgo+Cj4gc3RhdGljIGludCBlYm9pdl9jcmVhdGUoc3Ry
dWN0IGNyeXB0b190ZW1wbGF0ZSAqdG1wbCwgc3RydWN0IHJ0YXR0ciAqKnRiKQo+IHsKPiAgICAg
ICAgIHN0cnVjdCBza2NpcGhlcl9pbnN0YW5jZSAqaW5zdDsKPiAgICAgICAgIHN0cnVjdCBlYm9p
dl9pbnN0YW5jZV9jdHggKmljdHg7Cj4gICAgICAgICBzdHJ1Y3Qgc2tjaXBoZXJfYWxnICphbGc7
Cj4gICAgICAgICB1MzIgbWFzazsKPiAgICAgICAgIGludCBlcnI7Ci4uLgoKVGhhbmsgeW91IHZl
cnkgbXVjaCBmb3IgdGhlIHJldmlldyBhbmQgYXNzaXN0YW5jZS4gSSB3aWxsIHNlbmQgb3V0IGEK
cmV2aXNlZCB2ZXJzaW9uLgoKVGhhbmtzLApHaWxhZAotLSAKR2lsYWQgQmVuLVlvc3NlZgpDaGll
ZiBDb2ZmZWUgRHJpbmtlcgoKdmFsdWVzIG9mIM6yIHdpbGwgZ2l2ZSByaXNlIHRvIGRvbSEKCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

