Return-Path: <SRS0=f/Jd=OH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FC6C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:33:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 76CC86103B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 76CC86103B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631860413;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3R//lIQmPwxWACdskfx5oJGtDUJzEKxCuji+d48e3MA=;
	b=HcKlQhTFoL9FtMziVJ2Rl2aLRzny1AoUCHhS9a7tvDeh/3xpuTK/bCkqHR49dOuY1Pc7cV
	3DoKhmzPpr6kfAqs9NFFGj7/uN9Io3J1QN1eehlk7ip0sg5sD8DsCEQBOa8SdHTlUhB2RJ
	6KFED84VylhGG6F9Nqdx9Nv5KiOR+hY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-jwfS8ikpP36jcqZ1x1feWQ-1; Fri, 17 Sep 2021 02:33:30 -0400
X-MC-Unique: jwfS8ikpP36jcqZ1x1feWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C3A680124F;
	Fri, 17 Sep 2021 06:33:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E795B826;
	Fri, 17 Sep 2021 06:33:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2B029180142F;
	Fri, 17 Sep 2021 06:33:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GF6nam028831 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 11:06:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 34B757A8D8; Thu, 16 Sep 2021 15:06:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EDF6781ED;
	Thu, 16 Sep 2021 15:06:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18GF6dZD012074; 
	Thu, 16 Sep 2021 10:06:39 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18GF6cr3012073;
	Thu, 16 Sep 2021 10:06:38 -0500
Date: Thu, 16 Sep 2021 10:06:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210916150638.GX3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-32-mwilck@suse.com>
	<20210916041452.GQ3087@octiron.msp.redhat.com>
	<541494688720eb07d17f73e41a7877718208ea10.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <541494688720eb07d17f73e41a7877718208ea10.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 17 Sep 2021 02:33:18 -0400
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 31/35] multipathd: uxlsnr: add idle
	notification
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 16, 2021 at 10:54:19AM +0200, Martin Wilck wrote:
> On Wed, 2021-09-15 at 23:14 -0500, Benjamin Marzinski wrote:
> > On Fri, Sep 10, 2021 at 01:41:16PM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > The previous patches added the state machine and the timeout
> > > handling,
> > > but there was no wakeup mechanism for the uxlsnr for cases where
> > > client connections were waiting for the vecs lock.
> > >=20
> > > This patch uses the previously introduced wakeup mechanism of
> > > struct mutex_lock for this purpose. Processes which unlock the
> > > "global" vecs lock send an event in an eventfd which the uxlsnr
> > > loop is polling for.
> > >=20
> > > As we are now woken up for servicing client handlers that don't
> > > wait for input but for the lock, we need to set up the pollfds
> > > differently, and iterate over all clients when handling events,
> > > not only over the ones that are receiving. The hangup handling
> > > is changed, too. We have to look at every client, even if one has
> > > hung up. Note that I don't take client_lock for the loop in
> > > uxsock_listen(), it's not necessary and will be removed elsewhere
> > > in a follow-up patch.
> > >=20
> > > With this in place, the lock need not be taken in execute_handler()
> > > any more. The uxlsnr only ever calls trylock() on the vecs lock,
> > > avoiding any waiting for other threads to finish.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0multipathd/uxlsnr.c | 211 ++++++++++++++++++++++++++++++----------=
--
> > > --
> > > =A01 file changed, 143 insertions(+), 68 deletions(-)
> > >=20
>=20
> >=20
> > I do worry that if there are, for instance, a lot of uevents coming in,
> > this could starve the uxlsnr thread, since other threads could be
> > grabbing and releasing the vecs lock, but if it's usually being held,
> > then the uxlsnr thread might never try to grab it when it's free, and
> > it
> > will keep losing its place in line. Also, every time that the vecs lock
> > is dropped between ppoll() calls, a wakeup will get triggered, even if
> > the lock was grabbed by something else before the ppoll thread runs.
>=20
> I've thought about this too. It's true that the ppoll ->
> pthread_mutex_trylock() sequence will never acquire the lock if some
> other thread calls lock() at the same time.
>=20
> If multiple processes call lock(), the "winner" of the lock is random.
> Thus in a way this change actually adds some predictablity: the uxlsnr
> will step back if some other process is actively trying to grab the
> lock. IMO that the right thing to do in almost all situations.
>=20
> We don't need to worry about "thundering herd" issues because the
> number of threads that might wait on the lock is rather small. In the
> worst case, 3 threads (checker, dmevents handler and uevent dispatcher,
> plus the uxlsnr in ppoll()) wait for the lock at the same time. Usually
> one of them will have it grabbed. On systems that lack dmevent polling,
> the number of waiter threads may be higher, but AFAICS it's a very rare
> condition to have hundreds of dmevents delivered to different maps
> simultaneously, and if it happens, it's probably correct to have them
> serviced quickly.
>=20
> The uevent dispatcher doesn't hold the lock, it's taken and released
> for every event handled. Thus uxlsnr has a real chance to jump in
> between uevents. The same holds for the dmevents thread, it takes the
> lock separately for every map affected. The only piece of code that
> holds the lock for an extended period of time (except reconfigure(),
> where it's unavoidable) is the path checker (that's bad, and next on
> the todo list).
>=20
> The really "important" commands (shutdown, reconfigure) don't take the
> lock and return immediately; the lock is no issue for them. I don't see
> any other cli command that needs to be served before uevents or dm
> events.
>=20
> I haven't been able to test this on huge configurations with 1000s of
> LUNs, but I tested with artificial delays in checker loop, uevent
> handlers, and dmevent handler, and lots of clients querying the daemon
> in parallel, and saw that clients were handled very nicely. Some
> timeouts are inevitable (e.g. if the checker simply holds the lock
> longer than the uxsock_timeout), but that is no regression.
>=20
> Bottom line: I believe that because this patch reduces the busy-wait
> time, clients will be served more reliably and more quickly than before
> (more precisely: both average and standard deviation of the service
> delay will be improved wrt before, and timeouts occur less frequently).
> I encourage everyone to experiment and see if reality shows that I'm
> wrong.
>=20
> > I suppose the only way to deal with that would be to move the locking
> > commands to a list handled by a separate thread, so that it could block
> > without stalling the non-locking commands.
>=20
> Not sure if I understand correctly, just in case: non-locking commands
> are never stalled with my patch.

I realize. I was saying that you could avoid starvation while still
allowing non-locking commands to complete by moving the locking commands
to a seperate thread, which did block on the lock. I didn't consider a
ticketing system. Ideally, the checker loop would have the lowest
priority, Since it isn't responding to any event, and ususally is just
verifiying that nothing has changed.  But you do make a good point that
when we are getting a lot of events, and the uxlsnr loop has a chance of
getting starved, we probably want to prioritize the event handling
anyway.

-Ben

>=20
> Introducing a new thread is something I wouldn't want to do. We can
> discuss adding ticketing to the lock, but I am not convinced that it'd
> be worth the effort, and I'm not even sure it's what we want (we'd need
> to make sure the uevent dispatcher isn't starved, which would be worse
> than starved clients). If you want ticketing, I'd like to put it in a
> patch on top rather than merging it into this one (it would need very
> careful engineering and take time).
>=20
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!pl.held) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: cli[%d] waiting for
> > > lock",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__func__, c->fd);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0} else
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: cli[%d] grabbed
> > > lock",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__func__, c->fd);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0set_client_state(c, C=
LT_WORK);
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* fallthrough */
> > > =A0
> >=20
> > We should never return to uxsock_listen() while the lock is held. The
> > code doesn't, but the fact that CLT_WORK is a separate state makes it
> > look like this could be possible.=A0 Since we must never be in CLT_WORK
> > without first being in CLT_WAIT_LOCK, I don't see any point for having
> > a
> > separate CLT_WAIT_LOCK state.=A0 CLT_WORK should do both the locking if
> > necessary, and calling the handler.
>=20
> The reason for adding this state was that non-locking commands switch
> to CLT_WORK immediately, and locking commands don't. But it's true that
> this state is never visible outside the state machine, so we can drop
> it. Actually the state that's never visible is CLT_WORK, because it
> switches to CLT_SEND immediately. I'll think about it and drop one.
>=20
> Regards
> Martin
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

