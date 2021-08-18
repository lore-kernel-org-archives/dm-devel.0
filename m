Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21111C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 15:53:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A74AC6103E
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 15:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A74AC6103E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-HDjn-QxHNYedfq0_0onYpA-1; Wed, 18 Aug 2021 11:53:05 -0400
X-MC-Unique: HDjn-QxHNYedfq0_0onYpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656F618C89CF;
	Wed, 18 Aug 2021 15:53:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2F746A8FA;
	Wed, 18 Aug 2021 15:52:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 162921826D01;
	Wed, 18 Aug 2021 15:52:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17IFqq1x018342 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 11:52:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6465E206901D; Wed, 18 Aug 2021 15:52:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60E78207AD3D
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 15:52:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48A9480158D
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 15:52:49 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-254-bEZ4KhmWP6aafb54M1SDkQ-1;
	Wed, 18 Aug 2021 11:52:47 -0400
X-MC-Unique: bEZ4KhmWP6aafb54M1SDkQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C8F6103E;
	Wed, 18 Aug 2021 15:52:45 +0000 (UTC)
Date: Wed, 18 Aug 2021 08:52:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <20210818155245.GE12664@magnolia>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
MIME-Version: 1.0
In-Reply-To: <78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, snitzer@redhat.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2021 at 11:08:40PM -0700, Jane Chu wrote:
>=20
> On 8/17/2021 10:43 PM, Jane Chu wrote:
> > More information -
> >=20
> > On 8/16/2021 10:20 AM, Jane Chu wrote:
> > > Hi, ShiYang,
> > >=20
> > > So I applied the v6 patch series to my 5.14-rc3 as it's what you
> > > indicated is what v6 was based at, and injected a hardware poison.
> > >=20
> > > I'm seeing the same problem that was reported a while ago after the
> > > poison was consumed - in the SIGBUS payload, the si_addr is missing:
> > >=20
> > > ** SIGBUS(7): canjmp=3D1, whichstep=3D0, **
> > > ** si_addr(0x(nil)), si_lsb(0xC), si_code(0x4, BUS_MCEERR_AR) **
> > >=20
> > > The si_addr ought to be 0x7f6568000000 - the vaddr of the first page
> > > in this case.
> >=20
> > The failure came from here :
> >=20
> > [PATCH RESEND v6 6/9] xfs: Implement ->notify_failure() for XFS
> >=20
> > +static int
> > +xfs_dax_notify_failure(
> > ...
> > +=A0=A0=A0 if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +=A0=A0=A0=A0=A0=A0=A0 xfs_warn(mp, "notify_failure() needs rmapbt enab=
led!");
> > +=A0=A0=A0=A0=A0=A0=A0 return -EOPNOTSUPP;
> > +=A0=A0=A0 }
> >=20
> > I am not familiar with XFS, but I have a few questions I hope to get
> > answers -
> >=20
> > 1) What does it take and cost to make
> >  =A0=A0 xfs_sb_version_hasrmapbt(&mp->m_sb) to return true?

mkfs.xfs -m rmapbt=3D1

> > 2) For a running environment that fails the above check, is it
> >  =A0=A0 okay to leave the poison handle in limbo and why?
> >=20
> > 3) If the above regression is not acceptable, any potential remedy?
>=20
> How about moving the check to prior to the notifier registration?
> And register only if the check is passed?  This seems better
> than an alternative which is to fall back to the legacy memory_failure
> handling in case the filesystem returns -EOPNOTSUPP.

"return -EOPNOTSUPP;" is the branching point where a future patch could
probe the (DRAM) buffer cache to bwrite the contents to restore the pmem
contents.  Right now the focus should be on landing the core code
changes without drawing any more NAKs from Dan.

--D

> thanks,
> -jane
>=20
> >=20
> > thanks!
> > -jane
> >=20
> >=20
> > >=20
> > > Something is not right...
> > >=20
> > > thanks,
> > > -jane
> > >=20
> > >=20
> > > On 8/5/2021 6:17 PM, Jane Chu wrote:
> > > > The filesystem part of the pmem failure handling is at minimum buil=
t
> > > > on PAGE_SIZE granularity - an inheritance from general
> > > > memory_failure handling.=A0 However, with Intel's DCPMEM
> > > > technology, the error blast
> > > > radius is no more than 256bytes, and might get smaller with future
> > > > hardware generation, also advanced atomic 64B write to clear the po=
ison.
> > > > But I don't see any of that could be incorporated in, given that th=
e
> > > > filesystem is notified a corruption with pfn, rather than an exact
> > > > address.
> > > >=20
> > > > So I guess this question is also for Dan: how to avoid unnecessaril=
y
> > > > repairing a PMD range for a 256B corrupt range going forward?
> > > >=20
> > > > thanks,
> > > > -jane
> > > >=20
> > > >=20
> > > > On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > > > > When memory-failure occurs, we call this function which is implem=
ented
> > > > > by each kind of devices.=A0 For the fsdax case, pmem device drive=
r
> > > > > implements it.=A0 Pmem device driver will find out the
> > > > > filesystem in which
> > > > > the corrupted page located in.=A0 And finally call filesystem han=
dler to
> > > > > deal with this error.
> > > > >=20
> > > > > The filesystem will try to recover the corrupted data if necessar=
y.
> > > >=20
> > >=20
> >=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

