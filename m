Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BB7C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Mar 2022 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647023836;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v5j8j///sLaSKlHODPehnwWBYrQUiiY7YXcjrwbAJ2c=;
	b=X1/fC+tOyW+HmFhhBglVPeci5YVgwrw+CgXonQFzMPtFBjkY+X8lsi08pUGZywPzpIaHuQ
	feR5eSuRANX5KKsKKcs7rjDxXMjxEGtrup41WU2oSgCBaoabUGFpy0Mx0KtZTDNwOlYt+h
	1+lA04s5cNrEnrV7jEeQxjfRAE/9xiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-oo6RQGOeP2KsUxFNWCzF3g-1; Fri, 11 Mar 2022 13:37:12 -0500
X-MC-Unique: oo6RQGOeP2KsUxFNWCzF3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 907C7811E75;
	Fri, 11 Mar 2022 18:37:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54F5D141DC2B;
	Fri, 11 Mar 2022 18:37:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07D3F1940349;
	Fri, 11 Mar 2022 18:37:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 635031940341
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Mar 2022 18:37:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24AC486B58; Fri, 11 Mar 2022 18:37:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDC2D86B55;
 Fri, 11 Mar 2022 18:37:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22BIb25r005330;
 Fri, 11 Mar 2022 12:37:03 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22BIb29K005329;
 Fri, 11 Mar 2022 12:37:02 -0600
Date: Fri, 11 Mar 2022 12:37:01 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220311183701.GF24684@octiron.msp.redhat.com>
References: <1646964130-21800-1-git-send-email-bmarzins@redhat.com>
 <1646964130-21800-3-git-send-email-bmarzins@redhat.com>
 <d7f3a8ffe6fc59195beda878e59389c4a546dad9.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d7f3a8ffe6fc59195beda878e59389c4a546dad9.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: don't keep looping when
 config is delayed
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "guozh88@chinatelecom.cn" <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 11, 2022 at 10:21:29AM +0000, Martin Wilck wrote:
> On Thu, 2022-03-10 at 20:02 -0600, Benjamin Marzinski wrote:
> > If a reconfigure is delayed because multipathd is waiting on a change
> > uevent for a new multipath device, the main thread will not pause,
> > but
> > will keep looping and rechecking to see if it can reconfigure.
> >=20
> > To solve this, when __post_config_state(DAEMON_IDLE) is called, if
> > __delayed_reconfig is set we really do want to switch to the
> > DAEMON_IDLE state, even if there is a pending reconfigure, since it's
> > being delayed. When the last change uevent for a new map arrives (or
> > we time out waiting for it), a reconfigure will get triggered.
>=20
> I had thought about something like this, too. I think there's one good
> reason to switch to DAEMON_IDLE even if reconfigure is delayed: if we
> don't, and forever reason the uevents we expect arrive with large delay
> or not at all, we risk being killed by systemd, which will kill
> processes that stay in "RELOADING=3D1" state for more than
> TimeoutStartSec seconds. It's unlikely, but I think we should try to
> avoid it if we can, because we have no control about systemd's timeout
> configuration.
>=20
> > However, we need to avoid a race where the main thread calls
> > enable_delayed_reconfig() and sets __delayed_reconfig, and then the
> > uevent thread processes a change uevent that sets the state to
> > DAEMON_CONFIGURE, an then the main thread calls post_config_state().
> > In this case, multipathd would move to DAEMON_IDLE, even though
> > the reconfigure should no longer be delayed. To avoid this, when
> > schedule_reconfigure() is called and the daemon is currently in
> > DAEMON_CONFIGURE or DAEMON_RUNNING, __delayed_reconfig should be
> > cleared, so switching to DAEMON_IDLE will instead become
> > DAEMON_CONFIGURE.
>=20
> I suppose this would work. The part I don't like so much is that the
> DAEMON_CONFIGURE logic remains complex and distributed over different
> functions (__post_config_state(), schedule_reconfigure(), child())
> which interact in non-obvious ways. I noticed that while looking into
> Guozhonghua's problem yesterday - the logic is hard to grok, even
> though I wrote a significant part of it myself. In particular, I have
> started to dislike the complexity we added in __post_config_state(),
> which today doesn't do what a caller would expect it does (which is:
> simply setting the state passed to it). I'm aware that this complexity
> was created by my own commit 250708c :-)
>=20
> By adding extra semantics to the DAEMON_RUNNING state (which used to
> simply mean "checkers running"), the logic gets even harder to
> understand, IMO.
>=20
> Please have a look at my alternative approach (@dm-devel: only posted
> off-list so far). If you think that'd be a viable solution too, I'd
> prefer it, because it moves most of the logic into a single place
> (child()).
>=20

Err.. Patch 2 is still borken. The child process will only stop waiting
in the DAEMON_IDLE state and perform the reconfigure if
__delayed_reconfig is false. The only way that __delayed_reconfig can be
set to false is when a reconfigure actually happens. So you can fail to
reconfig if:

- main thread notices that it needs to delay the reconfigure(), and sets
  __delayed_reconfig to true.
- the uevent thread processes a change event on the last device that was
  delaying the reconfigure and calls schedule_reconfigure(), which sets
  reconfigure_pending, but doesn't set __delayed_reconfig to false
- the main thread calls post_config_state(DAEMON_IDLE)

The solution is to set __delayed_reconfig to false in
schedule_reconfigure().

Patch 3 looks fine.

While we're looking at this, does running_state need to be a volatile,
given that we only ever access it while holding the config_lock?=20

-Ben
> Regards,
> Martin
>=20
>=20
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0multipathd/main.c | 2 ++
> > =A01 file changed, 2 insertions(+)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 86b1745a..9bd1f530 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -309,6 +309,7 @@ static void __post_config_state(enum
> > daemon_status state)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * again and start anot=
her reconfigure cycle.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending=
 !=3D FORCE_RELOAD_NONE &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !__delayed_reco=
nfig &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state =3D=3D =
DAEMON_IDLE &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (old_state =
=3D=3D DAEMON_CONFIGURE ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 old_state =
=3D=3D DAEMON_RUNNING)) {
> > @@ -353,6 +354,7 @@ void schedule_reconfigure(enum force_reload_types
> > requested_type)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_CONFIGURE:
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_RUNNING:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D fa=
lse;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D=
 type;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0default:
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

