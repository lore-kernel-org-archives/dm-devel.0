Return-Path: <SRS0=hK9d=GJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7448CC433E0
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 22:46:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F12332313B
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 22:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F12332313B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-M4ZwkLk7OwebMqWrXubBGw-1; Wed, 06 Jan 2021 17:46:01 -0500
X-MC-Unique: M4ZwkLk7OwebMqWrXubBGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 838D610051C9;
	Wed,  6 Jan 2021 22:45:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A3706A8E9;
	Wed,  6 Jan 2021 22:45:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 00767180954D;
	Wed,  6 Jan 2021 22:45:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 106MjmrQ027150 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Jan 2021 17:45:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 87D9BADF88; Wed,  6 Jan 2021 22:45:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81CEBAE7A3
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 22:45:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B792800B3B
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 22:45:45 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-235-8cWV9zMzPDq4F3psYWmeDg-1;
	Wed, 06 Jan 2021 17:45:40 -0500
X-MC-Unique: 8cWV9zMzPDq4F3psYWmeDg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9B26DAA35;
	Wed,  6 Jan 2021 22:45:38 +0000 (UTC)
Message-ID: <f74cbc725ec8cb75016e8061c46eeb628d30bb25.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Date: Wed, 06 Jan 2021 23:45:37 +0100
In-Reply-To: <85d7c08115fd50c413ddcd957f22f40db2215f19.camel@suse.com>
References: <3baec678cfdc3c8ed2024b2df2f316d1694fe699.camel@suse.com>
	<CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
	<85d7c08115fd50c413ddcd957f22f40db2215f19.camel@suse.com>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 106MjmrQ027150
X-loop: dm-devel@redhat.com
Cc: dm-devel mailing list <dm-devel@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [dm-devel] New draft openSUSE multipath-tools repo on github
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Christophe, Ben, everybody,

On Tue, 2021-01-05 at 22:45 +0100, Martin Wilck wrote:
> Hi Christophe,
>=20
> On Sat, 2020-12-19 at 11:26 +0100, Christophe Varoqui wrote:
> > Sure, nice work.
> >=20
> > Would you like to create a PR, to merge it upstream ?
> > So we can test if this process makes sense.
>=20
> Sure, will do.
>=20
> One problem that I currently have is that the openSUSE/multipath-
> tools
> repo is a fork of your old repo, and it's impossible to change the=20
> upstream repo in github, AFAICS. Therefore I can't create a PR
> directly
> from openSUSE/multipath-tools.
>=20
> I guess I'll have to re-build the openSUSE/multipath-tools repo "from
> scratch" as a fork of your new github repo before we can
> realistically
> work with github PRs. That's a bit of work because there are many
> branches, and it needs to be discussed and coordinated in our
> organization.

I've drafted the new openSUSE multipath-tools github repo now:

https://github.com/openSUSE/multipath-tools-1=A0

(the repo name will change!)

This repo is forked from Christophe's github repo and will thus allow
creating Pull Requests for Christophe.

I have simplified the branch names that matter for upstream development
wrt the old repo:

  upstream-queue -> queue
  upstream-fixes -> fixes
  upstream-tip -> tip (this one contains github CI)

Besides these, the repo contains some (open)SUSE-specific branches and
tags, but I've left out a lot of old stuff which will continue to live
on the old openSUSE repo only.

Please have a look. If I get positive feedback, I'll rename the current
openSUSE multipath-tools repo to "openSUSE/multipath-tools-pre2021" and
rename this one to "openSUSE/multipath-tools".

Best Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

