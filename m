Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CF7C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:11:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17BEA611C1
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17BEA611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-oOgJR6X3PEWOKGjOWpLypw-1; Mon, 17 May 2021 17:11:22 -0400
X-MC-Unique: oOgJR6X3PEWOKGjOWpLypw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45159802575;
	Mon, 17 May 2021 21:11:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EF3C1899A;
	Mon, 17 May 2021 21:11:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21BEB4EE76;
	Mon, 17 May 2021 21:11:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HLBDMx030117 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 17:11:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AFF0F6E1DE; Mon, 17 May 2021 21:11:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1857D2B4
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:11:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9291E80D0E4
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:11:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-342-9w_E-SHyMK2u1UkiTXQQjQ-1;
	Mon, 17 May 2021 17:11:08 -0400
X-MC-Unique: 9w_E-SHyMK2u1UkiTXQQjQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 74687B136;
	Mon, 17 May 2021 21:11:06 +0000 (UTC)
Message-ID: <8fa6e9a5206e7b923811257f5badc1f73d65c0ee.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Mon, 17 May 2021 23:10:58 +0200
In-Reply-To: <db3fb4b8-8179-661e-00b1-8fa8dd574b3c@gmail.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
	<cb7300e3-9b91-df75-9343-06ae2c88d6ce@gmail.com>
	<addaed4d0bbb82f0a786eeb1d3066262a340ceaa.camel@suse.com>
	<db3fb4b8-8179-661e-00b1-8fa8dd574b3c@gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HLBDMx030117
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-05-17 at 22:08 +0200, Xose Vazquez Perez wrote:
> On 5/17/21 10:04 PM, Martin Wilck wrote:
>=20
> > On Mon, 2021-05-17 at 21:47 +0200, Xose Vazquez Perez wrote:
> > > On 3/26/21 10:29 PM, mwilck@suse.com=A0wrote:
> > >=20
> > > > Add the kernel-doc generated manpages of libdmmp to git, and
> > > > change the libdmmp Makefile to regenerate them (only) when
> > > > necessary.
> > >=20
> > > Every month, nice try :-)
> >=20
> > Hm, doesn't happen here. What are you doing differently?
> >=20
> > $ make -C libdmmp docs/man/dmmp_strerror.3
> > make: Entering directory '/mnt/git/mpath-tools/libdmmp'
> > make: 'docs/man/dmmp_strerror.3' is up to date.
> > make: Leaving directory '/mnt/git/mpath-tools/libdmmp'
> >=20
> > Likewise, "make install" won't rebuild any man pages.
>=20
> Just:
> $ git clone -b queue=A0 https://github.com/openSUSE/multipath-tools
> $ make
> $ git diff
>=20

Ok, you create new clones all the time. Why don't you just fetch?
Anyway, I'll post a patch that should fix this.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

