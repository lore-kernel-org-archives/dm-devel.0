Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80075C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:18:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1D7B61185
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:18:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1D7B61185
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-Sh-H4xozPba4x4ZTJumGBg-1; Thu, 16 Sep 2021 03:18:45 -0400
X-MC-Unique: Sh-H4xozPba4x4ZTJumGBg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0561E1966320;
	Thu, 16 Sep 2021 07:18:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 763CA100164C;
	Thu, 16 Sep 2021 07:18:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D6B374EA29;
	Thu, 16 Sep 2021 07:18:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G7H78W017712 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 03:17:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 321D1F9AAD; Thu, 16 Sep 2021 07:17:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1868EF97E6
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:17:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D1AC1881210
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:17:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-553-vod3gdNxOGCaXt5uc5y3Sw-1; Thu, 16 Sep 2021 03:17:02 -0400
X-MC-Unique: vod3gdNxOGCaXt5uc5y3Sw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BE021FEA7;
	Thu, 16 Sep 2021 07:17:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5DADD13CA4;
	Thu, 16 Sep 2021 07:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 6MHwFGzvQmGHDAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 07:17:00 +0000
Message-ID: <306fab51015089a11f3537eff88c0b26bbea95ab.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 09:16:59 +0200
In-Reply-To: <20210915230045.GS3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-8-mwilck@suse.com>
	<20210915230045.GS3087@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18G7H78W017712
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 07/35] multipathd: improve delayed reconfigure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-09-15 at 18:00 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:40:52PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > When a reconfigure operation is requested, either by the admin
> > or by some condition multipathd encounters, the current code
> > attempts to set DAEMON_CONFIGURE state and gives up after a second
> > if it doesn't succeed. Apart from shutdown, this happens only
> > if multipathd is either already reconfiguring, or busy in the
> > path checker loop.
> >=20
> > This patch modifies the logic as follows: rather than waiting,
> > we set a flag that requests a reconfigure operation asap, i.e.
> > when the current operation is finished and the status switched
> > to DAEMON_IDLE. In this case, multipathd will not switch to IDLE
> > but start another reconfigure cycle.
> >=20
> > This assumes that if a reconfigure is requested while one is
> > already
> > running, the admin has made some (additional) changes and wants
> > multipathd to pull them in. As we can't be sure that the currently
> > running reconfigure has seen the configuration changes, we need
> > to start over again.
> >=20
> > A positive side effect is less waiting in clients and multipathd.
> >=20
> > After this change, the only caller of set_config_state() is
> > checkerloop(). Waking up every second just to see that
> > DAEMON_RUNNING
> > couldn't be set makes no sense. Therefore set_config_state() is
> > changed to wait "forever", or until shutdown is requested. Unless
> > multipathd completely hangs, the wait will terminate sooner or
> > later.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/cli_handlers.c | 10 +----
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 92 +++++++++++++++++++++=
++++++++------
> > ----
> > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +-
> > =A03 files changed, 71 insertions(+), 34 deletions(-)
> >=20
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 6d3a0ae..44f76ee 100644
> >=20

> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reset log (=
signal)");
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index bc1f938..23ce919 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -37,6 +37,7 @@ void exit_daemon(void);
> > =A0const char * daemon_status(void);
> > =A0enum daemon_status wait_for_state_change_if(enum daemon_status
> > oldstate,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long =
ms);
> > +void schedule_reconfigure(void);
> > =A0int need_to_delay_reconfig (struct vectors *);
> > =A0int reconfigure (struct vectors *);
> > =A0int ev_add_path (struct path *, struct vectors *, int);
> > @@ -44,7 +45,7 @@ int ev_remove_path (struct path *, struct vectors
> > *, int);
> > =A0int ev_add_map (char *, const char *, struct vectors *);
> > =A0int ev_remove_map (char *, char *, int, struct vectors *);
> > =A0int flush_map(struct multipath *, struct vectors *, int);
> > -int set_config_state(enum daemon_status);
> > +enum daemon_status set_config_state(enum daemon_status);
>=20
> Can't we just remove set_config_state from main.h, and make it
> static?
> Other than that, everything looks fine.

Good point, will do.

Thanks, Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

