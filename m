Return-Path: <SRS0=f/Jd=OH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C1FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:43:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AE64610C7
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4AE64610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Bwpx1oRHN3COM8pCfoBYDg-1; Fri, 17 Sep 2021 02:33:48 -0400
X-MC-Unique: Bwpx1oRHN3COM8pCfoBYDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E8D31084681;
	Fri, 17 Sep 2021 06:33:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54F036D988;
	Fri, 17 Sep 2021 06:33:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27E1F1805989;
	Fri, 17 Sep 2021 06:33:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GFsLv2032163 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 11:54:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 99A8221EE59D; Thu, 16 Sep 2021 15:54:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9425120F4759
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 15:54:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACBCF899ED4
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 15:54:18 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-x9YKcXcpOVmkH9eg67QSQQ-1; Thu, 16 Sep 2021 11:54:16 -0400
X-MC-Unique: x9YKcXcpOVmkH9eg67QSQQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 804F81FEF0;
	Thu, 16 Sep 2021 15:54:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35E8513CFE;
	Thu, 16 Sep 2021 15:54:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id CzqeCqdoQ2HpNwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 15:54:15 +0000
Message-ID: <c48267143dc267427c5578e881cf0eaafc2e382d.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 17:54:14 +0200
In-Reply-To: <20210916150638.GX3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-32-mwilck@suse.com>
	<20210916041452.GQ3087@octiron.msp.redhat.com>
	<541494688720eb07d17f73e41a7877718208ea10.camel@suse.com>
	<20210916150638.GX3087@octiron.msp.redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18GFsLv2032163
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-09-16 at 10:06 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 16, 2021 at 10:54:19AM +0200, Martin Wilck wrote:
> > On Wed, 2021-09-15 at 23:14 -0500, Benjamin Marzinski wrote:
> > > On Fri, Sep 10, 2021 at 01:41:16PM +0200, mwilck@suse.com=A0wrote:
> > > > From: Martin Wilck <mwilck@suse.com>
> > > >=20
> > > > The previous patches added the state machine and the timeout
> > > > handling,
> > > > but there was no wakeup mechanism for the uxlsnr for cases
> > > > where
> > > > client connections were waiting for the vecs lock.
> > > >=20
> > > > This patch uses the previously introduced wakeup mechanism of
> > > > struct mutex_lock for this purpose. Processes which unlock the
> > > > "global" vecs lock send an event in an eventfd which the uxlsnr
> > > > loop is polling for.
> > > >=20
> > > > As we are now woken up for servicing client handlers that don't
> > > > wait for input but for the lock, we need to set up the pollfds
> > > > differently, and iterate over all clients when handling events,
> > > > not only over the ones that are receiving. The hangup handling
> > > > is changed, too. We have to look at every client, even if one
> > > > has
> > > > hung up. Note that I don't take client_lock for the loop in
> > > > uxsock_listen(), it's not necessary and will be removed
> > > > elsewhere
> > > > in a follow-up patch.
> > > >=20
> > > > With this in place, the lock need not be taken in
> > > > execute_handler()
> > > > any more. The uxlsnr only ever calls trylock() on the vecs
> > > > lock,
> > > > avoiding any waiting for other threads to finish.
> > > >=20
> > > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > > ---
> > > > =A0multipathd/uxlsnr.c | 211 ++++++++++++++++++++++++++++++------
> > > > ------
> > > > --
> > > > =A01 file changed, 143 insertions(+), 68 deletions(-)
> > > >=20
> >=20
> > >=20
> > > I do worry that if there are, for instance, a lot of uevents
> > > coming in,
> > > this could starve the uxlsnr thread, since other threads could be
> > > grabbing and releasing the vecs lock, but if it's usually being
> > > held,
> > > then the uxlsnr thread might never try to grab it when it's free,
> > > and
> > > it
> > > will keep losing its place in line. Also, every time that the
> > > vecs lock
> > > is dropped between ppoll() calls, a wakeup will get triggered,
> > > even if
> > > the lock was grabbed by something else before the ppoll thread
> > > runs.
> >=20
> > I've thought about this too. It's true that the ppoll ->
> > pthread_mutex_trylock() sequence will never acquire the lock if
> > some
> > other thread calls lock() at the same time.
> >=20
> > If multiple processes call lock(), the "winner" of the lock is
> > random.
> > Thus in a way this change actually adds some predictablity: the
> > uxlsnr
> > will step back if some other process is actively trying to grab the
> > lock. IMO that the right thing to do in almost all situations.
> >=20
> > We don't need to worry about "thundering herd" issues because the
> > number of threads that might wait on the lock is rather small. In
> > the
> > worst case, 3 threads (checker, dmevents handler and uevent
> > dispatcher,
> > plus the uxlsnr in ppoll()) wait for the lock at the same time.
> > Usually
> > one of them will have it grabbed. On systems that lack dmevent
> > polling,
> > the number of waiter threads may be higher, but AFAICS it's a very
> > rare
> > condition to have hundreds of dmevents delivered to different maps
> > simultaneously, and if it happens, it's probably correct to have
> > them
> > serviced quickly.
> >=20
> > The uevent dispatcher doesn't hold the lock, it's taken and
> > released
> > for every event handled. Thus uxlsnr has a real chance to jump in
> > between uevents. The same holds for the dmevents thread, it takes
> > the
> > lock separately for every map affected. The only piece of code that
> > holds the lock for an extended period of time (except
> > reconfigure(),
> > where it's unavoidable) is the path checker (that's bad, and next
> > on
> > the todo list).
> >=20
> > The really "important" commands (shutdown, reconfigure) don't take
> > the
> > lock and return immediately; the lock is no issue for them. I don't
> > see
> > any other cli command that needs to be served before uevents or dm
> > events.
> >=20
> > I haven't been able to test this on huge configurations with 1000s
> > of
> > LUNs, but I tested with artificial delays in checker loop, uevent
> > handlers, and dmevent handler, and lots of clients querying the
> > daemon
> > in parallel, and saw that clients were handled very nicely. Some
> > timeouts are inevitable (e.g. if the checker simply holds the lock
> > longer than the uxsock_timeout), but that is no regression.
> >=20
> > Bottom line: I believe that because this patch reduces the busy-
> > wait
> > time, clients will be served more reliably and more quickly than
> > before
> > (more precisely: both average and standard deviation of the service
> > delay will be improved wrt before, and timeouts occur less
> > frequently).
> > I encourage everyone to experiment and see if reality shows that
> > I'm
> > wrong.
> >=20
> > > I suppose the only way to deal with that would be to move the
> > > locking
> > > commands to a list handled by a separate thread, so that it could
> > > block
> > > without stalling the non-locking commands.
> >=20
> > Not sure if I understand correctly, just in case: non-locking
> > commands
> > are never stalled with my patch.
>=20
> I realize. I was saying that you could avoid starvation while still
> allowing non-locking commands to complete by moving the locking
> commands
> to a seperate thread, which did block on the lock. I didn't consider
> a
> ticketing system. Ideally, the checker loop would have the lowest
> priority, Since it isn't responding to any event, and ususally is
> just
> verifiying that nothing has changed.=A0 But you do make a good point
> that
> when we are getting a lot of events, and the uxlsnr loop has a chance
> of
> getting starved, we probably want to prioritize the event handling
> anyway.
>=20

I have also thought about using additional threads for handling cli
commands. One could either use a single thread, similar to the udev
listener/dispatcher pair (your suggestion IIUC), or one thread per
(blocking) client.

Moving client handling into separate thread(s) avoids the complexity of
the state machine and the eventfd-based wakeup. But on the back side,
it introduces new multithreading-related complexity (of which we
already have our fair share).=A0Client tasks running lock(&vecs->lock) in
order to serve commands like "multipathd show paths" might now starve
event handling, which would be worse than vice versa, IMO.

Eventually, I found the idea of the poll/wakeup loop with no additional
threads more appealing, and more suitable for the task. But I admit
that it's a matter of personal taste. I tend to try to use pthreads as
little as possible ;-).

So how do we proceed?=20

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

