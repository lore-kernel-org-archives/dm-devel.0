Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DE2C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 17:13:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2CD1960FE6
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 17:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CD1960FE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-KG-a1zWMM02bjt3TM8ioBw-1; Wed, 18 Aug 2021 13:13:48 -0400
X-MC-Unique: KG-a1zWMM02bjt3TM8ioBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6D1E184B7E9;
	Wed, 18 Aug 2021 17:13:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2F7560657;
	Wed, 18 Aug 2021 17:13:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D73B1826D05;
	Wed, 18 Aug 2021 17:13:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17IHB9Ab025407 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 13:11:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 273F810087E1; Wed, 18 Aug 2021 17:11:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2293E1007A2A
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 17:11:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D1A118A01A5
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 17:11:05 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
	[209.85.210.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-455-KZIxyheWPJWjFTCZ_czeiA-1; Wed, 18 Aug 2021 13:11:03 -0400
X-MC-Unique: KZIxyheWPJWjFTCZ_czeiA-1
Received: by mail-pf1-f172.google.com with SMTP id m26so2795398pff.3
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 10:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=a0h+TEUN+dwMuxMWfVo3bvlWUMIfpZXCfROxPjF14kk=;
	b=lG6/ZhU213Blk1rQJKoj0ptMFFRZzWCg8xDSM8XPybkvGqE7dV6IPo/Z2jne9ZaH34
	Dz86MrlVHsdTbLYDh5FqwOHF+IZdGMbtihvgkRwLmwrFxQcwHERR5jDPHubsLMBzSSNu
	L7pf6fRjfkK3g5GoIYXY0gaRKLUN5IdKp59rLkladyR+vW0SRQSygBKmWUsMXBWc7Lhv
	XTSse/MRw5G4FmiWYqcsw2z8UT64Vwe8uH6MN/VdFogXv7pvLM6F+T0l5e0jtpB7VYKO
	UOG1/r0dZKRmdIbEfPIY5Jj0BifSvjKlcIKEXyjjpG6IjYGDlqpvtI0Q1gDKvGq03sNJ
	EytA==
X-Gm-Message-State: AOAM532kor3HD2QZIqN+R4cYHAK7AW37C5C7/MUrFwh07kH1R8da+A/s
	OiYQcsS4Q4Tno+aDGruptBXTQY56W4flhTTa0vD5hg==
X-Google-Smtp-Source: ABdhPJzdnb/dj0te4AmEpXNnOuagyYA3beOwcj2486U3TAeBRF2kxocNgKDFE/I3ReZg4NnJJpeR0A7dwtzSQubN+nk=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
	l6-20020a056a0016c6b029032de1909dd0mr10326420pfc.70.1629306662392;
	Wed, 18 Aug 2021 10:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
	<OSBPR01MB2920AD0C7FD02E238D0C387AF4FF9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB2920AD0C7FD02E238D0C387AF4FF9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Aug 2021 10:10:51 -0700
Message-ID: <CAPcyv4gS=sYbC3gzMN0uQ5SAhDJ8CAC81tz7AtMueqLfuzGDOw@mail.gmail.com>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 18, 2021 at 12:52 AM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jane Chu <jane.chu@oracle.com>
> > Subject: Re: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
> >
> >
> > On 8/17/2021 10:43 PM, Jane Chu wrote:
> > > More information -
> > >
> > > On 8/16/2021 10:20 AM, Jane Chu wrote:
> > >> Hi, ShiYang,
> > >>
> > >> So I applied the v6 patch series to my 5.14-rc3 as it's what you
> > >> indicated is what v6 was based at, and injected a hardware poison.
> > >>
> > >> I'm seeing the same problem that was reported a while ago after the
> > >> poison was consumed - in the SIGBUS payload, the si_addr is missing:
> > >>
> > >> ** SIGBUS(7): canjmp=1, whichstep=0, **
> > >> ** si_addr(0x(nil)), si_lsb(0xC), si_code(0x4, BUS_MCEERR_AR) **
> > >>
> > >> The si_addr ought to be 0x7f6568000000 - the vaddr of the first page
> > >> in this case.
> > >
> > > The failure came from here :
> > >
> > > [PATCH RESEND v6 6/9] xfs: Implement ->notify_failure() for XFS
> > >
> > > +static int
> > > +xfs_dax_notify_failure(
> > > ...
> > > +    if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > > +        xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
> > > +        return -EOPNOTSUPP;
> > > +    }
> > >
> > > I am not familiar with XFS, but I have a few questions I hope to get
> > > answers -
> > >
> > > 1) What does it take and cost to make
> > >     xfs_sb_version_hasrmapbt(&mp->m_sb) to return true?
>
> Enable rmpabt feature when making xfs filesystem
>    `mkfs.xfs -m rmapbt=1 /path/to/device`
> BTW, reflink is enabled by default.
>
> > >
> > > 2) For a running environment that fails the above check, is it
> > >     okay to leave the poison handle in limbo and why?
> It will fall back to the old handler.  I think you have already known it.
>
> > >
> > > 3) If the above regression is not acceptable, any potential remedy?
> >
> > How about moving the check to prior to the notifier registration?
> > And register only if the check is passed?  This seems better than an
> > alternative which is to fall back to the legacy memory_failure handling in case
> > the filesystem returns -EOPNOTSUPP.
>
> Sounds like a nice solution.  I think I can add an is_notify_supported() interface in dax_holder_ops and check it when register dax_holder.

Shouldn't the fs avoid registering a memory failure handler if it is
not prepared to take over? For example, shouldn't this case behave
identically to ext4 that will not even register a callback?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

