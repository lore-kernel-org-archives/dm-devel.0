Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE63C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:07:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-CsujjFicOnuSCYNmGTVkdQ-1; Wed, 01 Dec 2021 07:07:04 -0500
X-MC-Unique: CsujjFicOnuSCYNmGTVkdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60658760C1;
	Wed,  1 Dec 2021 12:07:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 417945DAA5;
	Wed,  1 Dec 2021 12:06:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE23D4BB7C;
	Wed,  1 Dec 2021 12:06:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1C6qH3005704 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:06:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 15799492C3B; Wed,  1 Dec 2021 12:06:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10F1D492C38
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:06:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9203106655A
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:06:51 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-532-D8RrWjgdN5yHEgQh8YhN1A-1; Wed, 01 Dec 2021 07:06:48 -0500
X-MC-Unique: D8RrWjgdN5yHEgQh8YhN1A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD812212BB;
	Wed,  1 Dec 2021 12:06:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8636F1348A;
	Wed,  1 Dec 2021 12:06:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id bPDTHlZlp2FOGQAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:06:46 +0000
Message-ID: <1e0efe64215f399ca2f248590b48b4ec5024d8ed.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 01 Dec 2021 13:06:45 +0100
In-Reply-To: <c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
	<d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
	<20211130165251.GK19591@octiron.msp.redhat.com>
	<c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-11-30 at 21:28 +0100, Martin Wilck wrote:
> On Tue, 2021-11-30 at 10:52 -0600, Benjamin Marzinski wrote:
> > On Mon, Nov 29, 2021 at 09:52:49PM +0100, Martin Wilck wrote:
> > > I agree. Also, I realize that we've bumped the library version
> > > too
> > > often in the past. If we add a function, we don't need to bump.
> > > Because
> > > a program that needs the added function will require e.g.
> > > foo@LIBMULTIPATH_10.0.0, and this will fail for a library that
> > > doesn't
> > > export foo (which is what we want). Likewise for function
> > > deletion
> > > - a
> > > program that calls the deleted function will fail to link with
> > > the
> > > updated library. OTOH, programs that use this version of the ABI
> > > *without* using the functions which are added or removed are
> > > unaffected
> > > by the addition / removal.
> > > 
> > > The only case in which the ABI version must be bumped is when we
> > > have
> > > changed functions or data structures.
> > > 
> > > Furthermore, I believe now that the habit (which I introduced) to
> > > list
> > > added functions at the end of the .version files, with comments
> > > indicating when they were added, is useless. We should rather
> > > keep
> > > the
> > > .version file ordered alphabetically.
> > 
> > So we not use the minor version anymore? 
> 
> Perhaps we'll encounter another use case for it, or we find a flaw in
> my reasoning above. I wouldn't remove the digit.

And here's the flaw: While my argument above is valid for ld.so, it's
not for package management tools like rpm. Here on openSUSE, we got rpm
Requires like "libmultipath.so.0(LIBMULTIPATH_13.0.0)(64bit)". As
distributors, we prefer incompatibilities to be detected at
installation time rather than at runtime. So, we do need the minor
version bumps.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

