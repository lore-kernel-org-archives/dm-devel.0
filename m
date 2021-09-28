Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1464FC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 08:26:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 692C4611C3
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 08:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 692C4611C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-ZRS6PjNYPWOssfBSbIgHhg-1; Tue, 28 Sep 2021 04:26:16 -0400
X-MC-Unique: ZRS6PjNYPWOssfBSbIgHhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA5B801B3D;
	Tue, 28 Sep 2021 08:26:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E90585D740;
	Tue, 28 Sep 2021 08:26:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1A4E84E58F;
	Tue, 28 Sep 2021 08:26:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18S8Q8Lj010017 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 04:26:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 190082166BCC; Tue, 28 Sep 2021 08:26:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1333B2167D64
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 08:25:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC03899EC0
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 08:25:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-241-uK-ubK_xO5-kUyEnx1t0wQ-1; Tue, 28 Sep 2021 04:25:52 -0400
X-MC-Unique: uK-ubK_xO5-kUyEnx1t0wQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 222BE201D9;
	Tue, 28 Sep 2021 08:25:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E13BD13AC9;
	Tue, 28 Sep 2021 08:25:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id qqu3NI7RUmGsAgAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 28 Sep 2021 08:25:50 +0000
Message-ID: <aa1fee729c2b6547784dfeafdbfd837ca95d1613.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	<xose.vazquez@gmail.com>
Date: Tue, 28 Sep 2021 10:25:50 +0200
In-Reply-To: <20210927151115.GE3087@octiron.msp.redhat.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<9bf07d41-44e3-0f44-0cff-59b7379fc490@gmail.com>
	<20210927151115.GE3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18S8Q8Lj010017
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/4] Add "reconfigure all" multipath command
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-09-27 at 10:11 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 24, 2021 at 10:44:46PM +0200, Xose Vazquez Perez wrote:
> > On 9/21/21 01:21, Benjamin Marzinski wrote:
> >=20
> > > This patchset is supposed to replace Martin's
> > >=20
> > > multipathd: add "force_reconfigure" option
> > >=20
> > > patch from his uxlsnr overhaul patchset. It also makes the
> > > default
> > > reconfigure be a weak reconfigure, but instead of adding a
> > > configuration
> > > option to control this, it adds a new multipathd command,
> > > "reconfigure all", to do a full reconfigure. The HUP signal is
> > > left
> > > doing only weak reconfigures.
> > > In order to keep from having two states that are handled nearly
> > > identically, the code adds an extra variable to track the type of
> > > configuration that was selected, but this could easily be switch
> > > to
> > > use a new DAEMON_CONFIGURE_ALL state instead.
> > > The final patch, that added the new command, is meant to apply on
> > > top of
> > > Martin's changed client handler code. I can send one that works
> > > with the
> > > current client handler code, if people would rather review that.
> >=20
> > This change is going to affect some places, raw search:
>=20
> Yes. I specifically broke the code that actually changes how
> multipathd
> operates from a user' point of view into a seperate patch (4/4)
> because
> distributions might need to revert in, if they want to pull in recent
> upstream changes, but don't what this kind of change in multipathd's
> behavior.
>=20
> I admit, this patchset needs to include documentation to mention the
> changed behavior. I'll add that.=A0

Well, the idea is that there is actually no difference between "weak"
and "hard" reconfigure in terms of the end result. If a change must be
applied to reconcile kernel state and user settings, "weak" reconfigure
will do it. The documentation should express that and avoid stipulating
doubt among users. The main difference is that "hard" reconfigure
always executes a reload operation, which comes down to a
suspend/reload/resume, and thus a) is slow and b) unnecessarily
interrupts IO on the map for a few fractions of a second.

My personal PoV is that we should consider it a bug if a user reports a
situation where a "hard" reconfigure has a different outcome than a
"weak" one. Of course distros need to think twice when any defaults
change, and therefore the way Ben split the patch set makes a lot of
sense. Yet if we had serious doubts that "weak" reconfigure works, we
shouldn't switch to it upstream, either. I personally don't have such
doubts any more. Xose, if I'm missing something, let me know.

Cheers,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

