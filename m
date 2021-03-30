Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DC6C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 09:01:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07FF661959
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 09:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07FF661959
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-EO5LNvt3PLurvkwywFgWMw-1; Tue, 30 Mar 2021 05:01:22 -0400
X-MC-Unique: EO5LNvt3PLurvkwywFgWMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 123E0501F8;
	Tue, 30 Mar 2021 09:01:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E692A9654A;
	Tue, 30 Mar 2021 09:01:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5A584BB7C;
	Tue, 30 Mar 2021 09:01:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U914B2023018 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 05:01:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8CF082026D07; Tue, 30 Mar 2021 09:01:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8824C2026D6B
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 09:01:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34DC981DAAE
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 09:01:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-97-tjme-jrxOdKg_IGTcMEqug-1;
	Tue, 30 Mar 2021 05:00:58 -0400
X-MC-Unique: tjme-jrxOdKg_IGTcMEqug-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5CA2CAEB6;
	Tue, 30 Mar 2021 09:00:57 +0000 (UTC)
Message-ID: <fd0d2c96c9603c8835e83b771e7b2cb96dcec32f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>
Date: Tue, 30 Mar 2021 11:00:56 +0200
In-Reply-To: <20210330032329.GM15006@octiron.msp.redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-4-mwilck@suse.com>
	<20210330032329.GM15006@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U914B2023018
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH 3/7] github workflows: add containerized /
 multi-arch tests
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-03-29 at 22:23 -0500, Benjamin Marzinski wrote:
> On Fri, Mar 26, 2021 at 10:29:40PM +0100, mwilck@suse.com=A0wrote:
> >=20
> > Tell me if you want this in the multipath-tools repo, and if you're
> > ok
> > with hosting the images in my docker hub repo.
>=20
> I don't have problems with this setup. I haven't really looked into
> github actions, and so really don't know how easy it setup rules to run
> actions on events other that pushes, pull requests, etc. It seems
> reasonable to store those in a seperate repository. It would probably
> be
> good to have Christophe weigh in as well before adding these. Although
> I
> suppose it's always possible to disable these actions in other repos.

The events and branches are specified in the job file (YAML file). When
an event occurs on a github repository, github looks at the associated
commit (SHA), and considers the workflows _included in the tree for
this commit_. AFAIU, for "push" events, this means that if a branch B
is pushed with tip commit C, only workflows that exist in C _and_
reference branch B will be run.
(see https://docs.github.com/en/actions/reference/events-that-trigger-workf=
lows)

@Christophe, you will need to consider how he would like to set this up
in your repo. Different repos may have different policies, and it's
possible that you'll have to tweak or amend when you merge pull
requests from myself or other people that include changes to github
actions. For example, you may want to run CI on a different selection
of branches. I currently have little need for CI runs on pull requests,
but for you, that may be exactly what you need. Thinking about it, I'll
add pull-request triggers.

In general, I will separate github related changes from other code
changes, as discussed before. The reason I didn't in this patch set was
that I wanted to advertise my github-action-related work ;-)

Cheers,
Martin














--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

