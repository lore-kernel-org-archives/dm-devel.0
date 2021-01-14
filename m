Return-Path: <SRS0=q6c7=GR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5603C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jan 2021 16:51:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3237523B1C
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jan 2021 16:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3237523B1C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-TeeUQpm6Pkmduy2XtUd-bg-1; Thu, 14 Jan 2021 11:51:26 -0500
X-MC-Unique: TeeUQpm6Pkmduy2XtUd-bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 721DA1075646;
	Thu, 14 Jan 2021 16:51:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D8C75D71D;
	Thu, 14 Jan 2021 16:51:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E00CA180954D;
	Thu, 14 Jan 2021 16:51:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10EGpJKf010296 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Jan 2021 11:51:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9794E2166B2E; Thu, 14 Jan 2021 16:51:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 910262166B31
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 16:51:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46314803DCE
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 16:51:17 +0000 (UTC)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
	[209.85.208.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-343-uJz9H_oZNuqkad_UeQYDmA-1; Thu, 14 Jan 2021 11:51:15 -0500
X-MC-Unique: uJz9H_oZNuqkad_UeQYDmA-1
Received: by mail-ed1-f46.google.com with SMTP id dj23so3832226edb.13
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 08:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=G3k27iIjxC7sh/PZO3qnIJ/sRNHZDFHKlX0RIApltSw=;
	b=t9YFQYkmQGMLWRzTBIt2XAwcSByNJeBqbzvXFyWaR2cADEKaHW5KNJ39kpojjm6wpN
	jVJgdb1GzsIBgBYF8DkjfQDA9ZZ69I07gxjEc02e2/57+EJ0lQA3L95vdTCsRFvOtSKr
	uv0gDr9e5ClFU/GLexr2QyLJreTS0XkdsP3xleuwtf0JA9/G+sD5AviHSwF85Qj+W3me
	0RULOBifTtseebqF951/pSEDKVIpuCavEVTmLSUiy9qc6tcUPMHLHs2Ec+iUC6rt10Xw
	66lSAELZhW5AcUqkdgTtPJZU9+I9jPjDvs+gqS6dcJmOWqVJ4GmCnNWFJ7wGWaJ5YrK+
	O5dA==
X-Gm-Message-State: AOAM532sKu82sAz+edZ9FY7jjQxHVvCbhGhyKF7muP75rI76L8cbAymW
	mTPZ/Zfi6kpOZgf7KPMMGKwvH8uA8vPL6i4U9TW+
X-Google-Smtp-Source: ABdhPJxVa0+vM3ja4ugH1NHGsj5G/TvBdvxpArXXBfbbVXq6GgudnkGd4EwXJ3xfYUrJh1qmQ92BanBPsrs11HCj/Pk=
X-Received: by 2002:aa7:d7d8:: with SMTP id e24mr6250325eds.135.1610643073181; 
	Thu, 14 Jan 2021 08:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
	<20210108040708.8389-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSJk0wG=WzO3bwsueiy19mMi9m6MamTrQfH8C=gXUtvGw@mail.gmail.com>
	<97328fc71687a0e1c327f6821548be9ba35bb193.camel@linux.ibm.com>
	<CAHC9VhTzaQ_q8gJ0oeok_yJ54XLETNvOuhhKnyRwgqsqvpBLCw@mail.gmail.com>
	<71cddb6c8676ccd63c89364d805cfca76d32cb6e.camel@linux.ibm.com>
	<CAHC9VhRhYWEcK7TepZ=LK1m=9Zn_gtOZyAYfamP-TFU3rRH+zw@mail.gmail.com>
	<e29a618645b0e73ec06960a02b6da465614689ff.camel@linux.ibm.com>
	<CAHC9VhTHqwKem=MyQBY4TNAq-DOVhwEZS8pjrSE=4OxdEVm-GA@mail.gmail.com>
	<3746bc7673df25354411151442a7772b867be396.camel@linux.ibm.com>
	<fc80b1a1-ff4d-3bf2-59bd-2cb56135bf0f@linux.microsoft.com>
	<99be76345f375bb2f485f08a53dcb8ed806dc538.camel@linux.ibm.com>
In-Reply-To: <99be76345f375bb2f485f08a53dcb8ed806dc538.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 14 Jan 2021 11:51:02 -0500
Message-ID: <CAHC9VhTrxCi=H0ezR6eXjXnHH+atU9ieSZWy6pybOE9eAKnrMQ@mail.gmail.com>
To: Mimi Zohar <zohar@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Sasha Levin <sashal@kernel.org>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	dm-devel@redhat.com, snitzer@redhat.com, selinux@vger.kernel.org,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v10 8/8] selinux: include a consumer of the
 new IMA critical data hook
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 14, 2021 at 11:44 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> [Cc'ing Sasha]
>
> Hi Lakshmi,
>
> On Thu, 2021-01-14 at 08:22 -0800, Lakshmi Ramasubramanian wrote:
> > On 1/13/21 6:49 PM, Mimi Zohar wrote:
>
> > >>> Lakshmi is trying to address the situation where an event changes a
> > >>> value, but then is restored to the original value.  The original and
> > >>> subsequent events are measured, but restoring to the original value
> > >>> isn't re-measured.  This isn't any different than when a file is
> > >>> modified and then reverted.
> > >>>
> > >>> Instead of changing the name like this, which doesn't work for files,
> > >>> allowing duplicate measurements should be generic, based on policy.
> > >>
> > >> Perhaps it is just the end of the day and I'm a bit tired, but I just
> > >> read all of the above and I have no idea what your current thoughts
> > >> are regarding this patch.
> > >
> > > Other than appending the timestamp, which is a hack, the patch is fine.
> > > Support for re-measuring an event can be upstreamed independently.
> > >
> >
> > Thanks for clarifying the details related to duplicate measurement
> > detection and re-measuring.
> >
> > I will keep the timestamp for the time being, even though its a hack, as
> > it helps with re-measuring state changes in SELinux. We will add support
> > for "policy driven" re-measurement as a subsequent patch series.
>
> Once including the timestamp is upstreamed, removing it will be
> difficult, especially if different userspace applications are dependent
> on it.  Unless everyone is on board that removing the timestamp
> wouldn't be considered a regression, it cannot be upstreamed.

I'm not a fan of merging things which are known to be broken only with
the promise of fixing it later.  That goes double when the proper fix
will result in a user visible breaking change.

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

