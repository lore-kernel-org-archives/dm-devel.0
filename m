Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97F1C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 23:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639526082;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=236aYA93s8RpWI6JhlCPqu60aedn9qv87P8/O1j4jR0=;
	b=DSIFQyCljzK3D0XBLY1EJ5QmMe0OokGZtwVO9bpDtARUNadmqkexze+K+lJE/A4ywS31X9
	MvY1UMzg2wTIC4HL2EcpHk6bS3hyNcuwgbwqaFvmeMUzSZTGeHwK0j5S9sSWi3DQ7nCNO/
	xpo0W1IREI01MPQMyKMOUAHn49AvGeY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-OjG3uq3pMyKB9j4Umhi58w-1; Tue, 14 Dec 2021 18:54:39 -0500
X-MC-Unique: OjG3uq3pMyKB9j4Umhi58w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56D59100C661;
	Tue, 14 Dec 2021 23:54:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4835C5BD3B;
	Tue, 14 Dec 2021 23:54:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC3671806D2B;
	Tue, 14 Dec 2021 23:54:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BENPbTE030355 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 18:25:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 65F425BE36; Tue, 14 Dec 2021 23:25:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7FC25F6B7;
	Tue, 14 Dec 2021 23:25:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BENPSfG005447; 
	Tue, 14 Dec 2021 17:25:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BENPQ10005446;
	Tue, 14 Dec 2021 17:25:26 -0600
Date: Tue, 14 Dec 2021 17:25:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20211214232526.GB19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
	<d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
	<20211130165251.GK19591@octiron.msp.redhat.com>
	<c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
	<1e0efe64215f399ca2f248590b48b4ec5024d8ed.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <1e0efe64215f399ca2f248590b48b4ec5024d8ed.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 01, 2021 at 01:06:45PM +0100, Martin Wilck wrote:
> On Tue, 2021-11-30 at 21:28 +0100, Martin Wilck wrote:
> > On Tue, 2021-11-30 at 10:52 -0600, Benjamin Marzinski wrote:
> > > On Mon, Nov 29, 2021 at 09:52:49PM +0100, Martin Wilck wrote:
> > > > I agree. Also, I realize that we've bumped the library version
> > > > too
> > > > often in the past. If we add a function, we don't need to bump.
> > > > Because
> > > > a program that needs the added function will require e.g.
> > > > foo@LIBMULTIPATH_10.0.0, and this will fail for a library that
> > > > doesn't
> > > > export foo (which is what we want). Likewise for function
> > > > deletion
> > > > - a
> > > > program that calls the deleted function will fail to link with
> > > > the
> > > > updated library. OTOH, programs that use this version of the ABI
> > > > *without* using the functions which are added or removed are
> > > > unaffected
> > > > by the addition / removal.
> > > > 
> > > > The only case in which the ABI version must be bumped is when we
> > > > have
> > > > changed functions or data structures.
> > > > 
> > > > Furthermore, I believe now that the habit (which I introduced) to
> > > > list
> > > > added functions at the end of the .version files, with comments
> > > > indicating when they were added, is useless. We should rather
> > > > keep
> > > > the
> > > > .version file ordered alphabetically.
> > > 
> > > So we not use the minor version anymore? 
> > 
> > Perhaps we'll encounter another use case for it, or we find a flaw in
> > my reasoning above. I wouldn't remove the digit.
> 
> And here's the flaw: While my argument above is valid for ld.so, it's
> not for package management tools like rpm. Here on openSUSE, we got rpm
> Requires like "libmultipath.so.0(LIBMULTIPATH_13.0.0)(64bit)". As
> distributors, we prefer incompatibilities to be detected at
> installation time rather than at runtime. So, we do need the minor
> version bumps.

So where does this leave us. Are we bumping versions once per merge to
Christophe's offical branch, and if distributions put out multiple
releases between these, they are responsible for any version bumps that
they need.  Or are we bumping versions once per patchset if needed?

-Ben

> 
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

