Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D541C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 20:04:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B100D61002
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 20:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B100D61002
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-PGQ3elFWOdaGHVPTMv1n_A-1; Mon, 17 May 2021 16:04:39 -0400
X-MC-Unique: PGQ3elFWOdaGHVPTMv1n_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26DA46D4E6;
	Mon, 17 May 2021 20:04:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F2D5C239;
	Mon, 17 May 2021 20:04:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C36A255347;
	Mon, 17 May 2021 20:04:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HK4S3V023879 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 16:04:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C05421112844; Mon, 17 May 2021 20:04:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B957A1112C3B
	for <dm-devel@redhat.com>; Mon, 17 May 2021 20:04:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4E1595F34B
	for <dm-devel@redhat.com>; Mon, 17 May 2021 20:04:22 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-91-JlnUxylfMu-Yh6WR0RdidQ-1;
	Mon, 17 May 2021 16:04:20 -0400
X-MC-Unique: JlnUxylfMu-Yh6WR0RdidQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 010C1AEB3;
	Mon, 17 May 2021 20:04:19 +0000 (UTC)
Message-ID: <addaed4d0bbb82f0a786eeb1d3066262a340ceaa.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Mon, 17 May 2021 22:04:18 +0200
In-Reply-To: <cb7300e3-9b91-df75-9343-06ae2c88d6ce@gmail.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
	<cb7300e3-9b91-df75-9343-06ae2c88d6ce@gmail.com>
User-Agent: Evolution 3.38.4
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HK4S3V023879
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/7] libdmmp: allow building without perl
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-05-17 at 21:47 +0200, Xose Vazquez Perez wrote:
> On 3/26/21 10:29 PM, mwilck@suse.com=A0wrote:
>=20
> > Add the kernel-doc generated manpages of libdmmp to git, and
> > change the libdmmp Makefile to regenerate them (only) when
> > necessary.
>=20
> Every month, nice try :-)

Hm, doesn't happen here. What are you doing differently?

$ make -C libdmmp docs/man/dmmp_strerror.3
make: Entering directory '/mnt/git/mpath-tools/libdmmp'
make: 'docs/man/dmmp_strerror.3' is up to date.
make: Leaving directory '/mnt/git/mpath-tools/libdmmp'

Likewise, "make install" won't rebuild any man pages.

Regards,
Martin


> $ git diff
> diff --git a/libdmmp/docs/man/dmmp_context_free.3
> b/libdmmp/docs/man/dmmp_context_free.3
> index 0d26f42c..9a46950e 100644
> --- a/libdmmp/docs/man/dmmp_context_free.3
> +++ b/libdmmp/docs/man/dmmp_context_free.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2021" "Device
> Mapper Multipath API - libdmmp Manual"
> +.TH "dmmp_context_free" 3 "dmmp_context_free" "May 2021" "Device
> Mapper Multipath API - libdmmp Manual"
> =A0 .SH NAME
> =A0 dmmp_context_free \- Release the memory of struct dmmp_context.
> =A0 .SH SYNOPSIS
> [...]
>=20
>=20
> $ git status
> On branch queue
> Your branch is up to date with 'origin/queue'.
>=20
> Changes not staged for commit:
> =A0=A0 (use "git add <file>..." to update what will be committed)
> =A0=A0 (use "git restore <file>..." to discard changes in working
> directory)
> =A0=A0=A0=A0=A0=A0=A0=A0 modified:=A0=A0 libdmmp/docs/man/dmmp_context_fr=
ee.3
> [...]
>=20



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

