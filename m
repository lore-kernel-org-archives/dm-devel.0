Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3093CC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 22:01:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-wyyxv6SbOBCwCiHy3PVg1g-1; Wed, 16 Mar 2022 18:01:53 -0400
X-MC-Unique: wyyxv6SbOBCwCiHy3PVg1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 389CE80348D;
	Wed, 16 Mar 2022 22:01:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DEC5455433F;
	Wed, 16 Mar 2022 22:01:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8531E1949763;
	Wed, 16 Mar 2022 22:01:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 303CC1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 22:01:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 992A4C33269; Wed, 16 Mar 2022 22:01:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D17C33260
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 22:01:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BD3B185A79C
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 22:01:49 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-Qu0J6qxMNCezlSTsXFCQwg-1; Wed, 16 Mar 2022 18:01:47 -0400
X-MC-Unique: Qu0J6qxMNCezlSTsXFCQwg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 022BA210F1;
 Wed, 16 Mar 2022 22:01:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7EDE13B64;
 Wed, 16 Mar 2022 22:01:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id LqaWKkleMmKSOAAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 16 Mar 2022 22:01:45 +0000
Message-ID: <1bec2b61cd3305cf22a07fd8ef66dc179d462201.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Mar 2022 23:01:45 +0100
In-Reply-To: <20220316201355.GG24684@octiron.msp.redhat.com>
References: <20220314213036.12074-1-mwilck@suse.com>
 <20220314213036.12074-5-mwilck@suse.com>
 <20220316201355.GG24684@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reset __delayed_reconfig
 from ev_add_map()
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-16 at 15:13 -0500, Benjamin Marzinski wrote:
> On Mon, Mar 14, 2022 at 10:30:35PM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > With the previous patch, one race condition between child() and
> > the uevent handler (ev_add_map()) remains: 1. child() sets
> > __delayed_reconfig, 2. ev_add_map() calls schedule_reconfigure()
> > and
> > thus DAEMON_CONFIGURE, 3. child() sets DAEMON_IDLE. This would
> > cause
> > the pending reconfigure request to be missed.
> >=20
> > To fix this, reset __delayed_reconfig immediately from ev_add_map()
> > (and likewise, missing_uev_wait_tick()). This way the wait loop in
> > child() terminates on the reconfigure_pending condition.
> >=20
> > Also, these schedule_reconfigure() callers don't really request a
> > reconfigure() call; they just unblock processing previously
> > requested
> > reconfigure() calls. Add a new helper, unblock_reconfigure(), that
> > does just that.
> >=20
>=20
> Doesn't unblock_reconfigure() allow us to set the state to
> DAEMON_CONFIGURE, right after the checkerloop() has set it to
> DAEMON_RUNNING.

Right. I added the __post_config_state() there in order to be sure that
child() would be woken up. But unblock_reconfigure() should only call
__post_config_state if running_state is DAEMON_IDLE, like
schedule_reconfigure(). Otherwise, it can be sure that some other
process will wake up child().

>  schedule_reconfigure() didn't update the state if it was
> DAEMON_RUNNING. Instead, it would wait till checkerloop() set the
> state
> back to DAEMON_IDLE for the reconfigure to start.

> I have also come up with a different bug that effects these fixes,
> including mine. But it will effect this fix worse. This fix assumes
> that
> when a reconfigure is delayed, it should remain delayed until either
> a
> change event happens on the multipath device (ev_add_map) or
> multipathd
> times out waiting for one (missing_uev_wait_tick). However the map
> could
> be removed before either of those things happen.=A0 It's possible that
> multipathd could get a remove uevent after the add event but before
> the
> change event. Either that or a multipathd client command could remove
> it, or a dm event could happen either removing the device, or
> updating
> it, but with __setup_multipath() removing it. Those are just the
> examples I came up with off the top of my head.


> So there's a specific problem where we don't handle clearing
> __delayed_reconfig if a map was removed. That can be handled in a
> different patch.=A0 But this, or any other oversight we might have here
> can be mitigated by being more proactive in removing
> __delayed_reconfig.
> For instance, when then main thread tries to reconfigure, it checks
> need_to_delay_reconfig(), and only does the reconfigure if this
> returns
> that it's ok.=A0 __delayed_reconfig mostly exists so that the main
> thread
> doesn't need to grab the vecs lock and loop through the the multipath
> devices to know if it need to delay, but need_to_delay_reconfig() is
> the definitive answer. When the main thread checks this, we should be
> updating __delayed_reconfig to match the result. This patch removes
> the
> "__delayed_reconfig =3D false;" line, which I think is a mistake.

Agreed. My thinking was that this is done by the uevent handler when
the state of need_to_delay_reconfig() changes. But you're right with
the "remove" special case. We should re-add this, it definitely doesn't
hurt.

> Imagine if, because a map got removed before ev_add_map() was called,
> __delayed_reconfig was true, even though there were no maps with
> mpp->wait_for_udev set. Any existing config request would still be
> delayed, but if another reconfigure was requested not only would it
> happen, but if the "__delayed_reconfig =3D false;" line was back,
> __delayed_reconfig would go back to the correct value.

So we should call unblock_reconfigure() from remove_map().
Unfortunately that requires another callback from libmultipath into
multipathd. Trying to figure it out...=20

Thanks,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

