Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D968FC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 21:46:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B5D122D71
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 21:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B5D122D71
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-ILS37Q6BMY-xDhqB5KWG6Q-1; Tue, 05 Jan 2021 16:46:06 -0500
X-MC-Unique: ILS37Q6BMY-xDhqB5KWG6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9BE2800D55;
	Tue,  5 Jan 2021 21:46:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 301261349A;
	Tue,  5 Jan 2021 21:46:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FAE94BB7B;
	Tue,  5 Jan 2021 21:45:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105LjtGG027454 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 16:45:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 861156B5BA; Tue,  5 Jan 2021 21:45:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80521637A1
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 21:45:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B9F2805B2F
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 21:45:53 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-232-Nu5wjdNmNQ6sZPfbzlcIKw-1;
	Tue, 05 Jan 2021 16:45:49 -0500
X-MC-Unique: Nu5wjdNmNQ6sZPfbzlcIKw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A1921AD19;
	Tue,  5 Jan 2021 21:45:47 +0000 (UTC)
Message-ID: <85d7c08115fd50c413ddcd957f22f40db2215f19.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 05 Jan 2021 22:45:46 +0100
In-Reply-To: <CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
References: <3baec678cfdc3c8ed2024b2df2f316d1694fe699.camel@suse.com>
	<CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
User-Agent: Evolution 3.38.2
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
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] Basic Github CI for multipath-tools
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Christophe,

On Sat, 2020-12-19 at 11:26 +0100, Christophe Varoqui wrote:
> Sure, nice work.
> 
> Would you like to create a PR, to merge it upstream ?
> So we can test if this process makes sense.

Sure, will do.

One problem that I currently have is that the openSUSE/multipath-tools
repo is a fork of your old repo, and it's impossible to change the 
upstream repo in github, AFAICS. Therefore I can't create a PR directly
from openSUSE/multipath-tools.

I guess I'll have to re-build the openSUSE/multipath-tools repo "from
scratch" as a fork of your new github repo before we can realistically
work with github PRs. That's a bit of work because there are many
branches, and it needs to be discussed and coordinated in our
organization.

You'll notice when I've got to it :-)

In the meantime, please consider pulling upstream-queue, the current
state is pretty much settled between Ben and myself.

In the long run, let's handle everything that touches the actual
multipath-tools code via dm-devel as usual, and handle github-specific
things like CI via PRs. OK?

Regards and happy new year,
Martin

> 
> Regards,
> Christophe
> 
> On Sat, Dec 19, 2020 at 1:07 AM Martin Wilck <mwilck@suse.com> wrote:
> > Hi Christophe, all,
> > 
> > I have created a basic CI for multipath-tools on github:
> > 
> > https://github.com/openSUSE/multipath-tools/actions
> > 
> > It builds multipath-tools with different compilers and runs the
> > unit tests. It's currently on the "upstream-tip" branch only,
> > which is otherwise identical to upstream-queue (today, at least).
> > 
> > Christophe, would you be willing to pull this into the main
> > repo one day?
> > 
> > Regards,
> > Martin
> > 
> > 


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

