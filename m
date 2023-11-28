Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1829941C9B
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aclCz1Lr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701195529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nH27GOJf86emF4DkDf5Plw19q6Eb5HQXNDdupgpnaxI=;
	b=aclCz1Lrj25l2DHmnpnFikBEMCl9HsCP7M5HdqIQUZA3TJLkY6x9MtfC4IqqBAsUcdEozM
	grZmrNAvAAGDqPu6lSoNm3dudJMmELiwqL2tgBe0sHsbAd78L4pPW7l+kiQ2kOy5AoVkVD
	pFo3USJIp+BdRq9Av433frthRaXJ0aY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-374-XoPWRWSLMomU45PahReAyw-1; Tue,
 28 Nov 2023 13:18:47 -0500
X-MC-Unique: XoPWRWSLMomU45PahReAyw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28F663804522;
	Tue, 28 Nov 2023 18:18:47 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E3BB492BE7;
	Tue, 28 Nov 2023 18:18:47 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3ASIIkV8279934
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 13:18:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3ASIIk9F279933;
	Tue, 28 Nov 2023 13:18:46 -0500
Date: Tue, 28 Nov 2023 13:18:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
Message-ID: <ZWYvBvK7+mJglGjH@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
 <CAAMCDeer-7Nw72UBdQGeT_EsGfXUj=L5RshvDsPCp+5QNY2eyQ@mail.gmail.com>
 <ZWYfxODHbb0Jag66@bmarzins-01.fast.rdu2.eng.redhat.com>
 <CAAMCDefHt9bKpdmK+zfz5dP0fjy6T=vzEuCyfTF4QsdDHWKvfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAAMCDefHt9bKpdmK+zfz5dP0fjy6T=vzEuCyfTF4QsdDHWKvfQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 28, 2023 at 11:59:55AM -0600, Roger Heflin wrote:
> Thank you.  That makes it clear.    Yes, we are setting it to "queue"
> so it won't change behavior with that setting.
> 
> It also makes it clear that if we say set it no_path_retry to say
> 100000 that once all paths fail and it goes into recovery mode then
> queuing would be disabled.

Well, it wouldn't disable queueing until it had been in recovery mode
for over 100000 path checker retries. At a retry every 5 seconds, that's
getting close to 6 days. Before those 100000 retries had passed, if the
device got reloaded, queueing would still not get disabled with my patch
appled, even if there were no usable paths. The change only applies to
devices in recovery mode that have run out of retries.

If you've noticed something that I've overlooked, and this change could
disable queuing when it shouldn't, please let me know.

-Ben

> 
> 
> On Tue, Nov 28, 2023 at 11:13 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> >
> > On Mon, Nov 27, 2023 at 04:07:46PM -0600, Roger Heflin wrote:
> > > How long does recovery take?     I am unclear on when the explictly
> > > set queue_if_no_path is being overridden, and why disabling it is
> > > useful.
> >
> > To be clear here. This fix shouldn't cause multipath to disable queueing
> > in cases where it wasn't configured to do so. Previously, we were not
> > always respecting no_path_retry. This fix makes sure that we are.
> >
> > This change only applies to the case where no_path_retry is set to
> > a specific number of retries. When configuring multipath, if
> > no_path_reties is set, it always takes precedence over
> > "queue_if_no_path" set in the features line. So if a multipath device
> > isn't configured to queue for a limited number of retries and then
> > disable queueing, the fix changes nothing.
> >
> > When no_path_retry is set to a number of retries, if the last path is
> > lost, the device goes into recovery mode. When a device goes into
> > recovery mode, multipathd sets a counter to the value of no_path_retry.
> > After every loop of the path checker through all the devices, that
> > counter ticks down. If the counter hits zero, multipathd disables
> > queueing on the device. When a path becomes usable, the device leaves
> > recovery mode, stopping the countdown or restoring queueing as
> > necessary.
> >
> > The problem that this patch fixes happens if the multipath device is
> > reloaded after that count has hit zero, and queueing has been disabled.
> > When reloading a device with no_path_retry set to anything other than
> > "fail", multipathd will automatically enable queueing.  After reloading
> > the device, multipathd checks the number of usable paths. If there are
> > no usable paths, it tries to enter recovery mode.  However, in this
> > case, the device already is in recovery mode, so nothing happens. And
> > since the countdown has already completed, nothing will happen to
> > disable queueing in the future. Now you are left with a device stuck
> > indefinitely in recovery mode with queueing enabled and no usable paths,
> > even though you configured it to only queue for a limited number of
> > retries. This is bad.
> >
> > The solution the patch implements is to check if you are in this
> > situation:
> > 1. The device has no_path_retry set to a number of retries.
> > 2. The device has no usable paths
> > 3. The device is already in recovery mode
> > 4. The retry counter for the device has already reached 0
> > 5. The device is currently queueing IO.
> >
> > In this case, we clearly shouldn't be queueing, and calling
> > enter_recovery_mode() will do nothing. So, we just tell the device to
> > disable queueing.
> >
> > The change I made is in set_no_path_retry() which does get called in
> > other cases besides after a device reload. However, if we are ever in
> > the situation outlined above, we should not be queueing, so it is
> > correct to disable it. The code I added in this patch is the mirror of
> > the code directly above it in set_no_path_retry(). Here is that code.
> >
> > if (count_active_paths(mpp) > 0) {
> >         /*
> >          * If in_recovery is set, leave_recovery_mode() takes
> >          * care of dm_queue_if_no_path. Otherwise, do it here.
> >          */
> >         if ((!mpp->features || !is_queueing) &&
> >             !mpp->in_recovery)
> >                 dm_queue_if_no_path(mpp->alias, 1);
> >         leave_recovery_mode(mpp);
> >
> > It this case, we should be queueing, but we're not, and since we aren't
> > in recovery mode, calling leave_recovery_mode() doesn't do anything.
> > Instead we just directly enable queueing.
> >
> > > Typically we are setting queue_if_no_path to forever with the intent
> > > that it will survive longer storage and/or disk issues without
> > > returning an error to the application and/or corrupting fses if the
> > > storage issue can be fixed.
> > >
> > > We generally expect it to recover when the storage comes back, but
> > > that the storage could be experiencing significant issues for a
> > > significant period of time >10 minutes.   Since the storage has to be
> > > fixed to get things working again, there is a lot of negative value
> > > that requires manual recovery steps when an error gets returned (fsck,
> > > loss of data).
> > >
> > > We also manually disable queueing if we need to remove the mpath
> > > devices (paths are already gone as they were non-responsive > 24 hours
> > > and removed via tmo_timeout), and/or forcible reboot the nodes when we
> > > determine storage is not coming back.
> >
> > If you are setting no_path_retry to "queue" (the recommended way) or
> > adding "queue_if_no_path" to the features line while leaving
> > no_path_retry unset (the deprecated way. See the man page) this change
> > will not effect you. You will not ever get to this code in
> > set_no_path_retry().
> >
> > Does that clear things up?
> >
> > -Ben
> >
> > >
> > > On Mon, Nov 27, 2023 at 3:54 PM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> > > >
> > > > If a multipath device has no_path_retry set to a number and has lost all
> > > > paths, gone into recovery mode, and timed out, it will disable
> > > > queue_if_no_paths. After that, if one of those failed paths is removed,
> > > > when the device is reloaded, queue_if_no_paths will be re-enabled.  When
> > > > set_no_path_retry() is then called to update the queueing state, it will
> > > > not disable queue_if_no_paths, since the device is still in the recovery
> > > > state, so it believes no work needs to be done. The device will remain
> > > > in the recovery state, with retry_ticks at 0, and queueing enabled,
> > > > even though there are no usable paths.
> > > >
> > > > To fix this, in set_no_path_retry(), if no_path_retry is set to a number
> > > > and the device is queueing but it is in recovery mode and out of
> > > > retries with no usable paths, manually disable queue_if_no_path.
> > > >
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >  libmultipath/structs_vec.c | 12 +++++++++++-
> > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > > > index 0e8a46e7..3cb23c73 100644
> > > > --- a/libmultipath/structs_vec.c
> > > > +++ b/libmultipath/structs_vec.c
> > > > @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
> > > >                             !mpp->in_recovery)
> > > >                                 dm_queue_if_no_path(mpp->alias, 1);
> > > >                         leave_recovery_mode(mpp);
> > > > -               } else if (pathcount(mpp, PATH_PENDING) == 0)
> > > > +               } else if (pathcount(mpp, PATH_PENDING) == 0) {
> > > > +                       /*
> > > > +                        * If in_recovery is set, enter_recovery_mode does
> > > > +                        * nothing. If the device is already in recovery
> > > > +                        * mode and has already timed out, manually call
> > > > +                        * dm_queue_if_no_path to stop it from queueing.
> > > > +                        */
> > > > +                       if ((!mpp->features || is_queueing) &&
> > > > +                           mpp->in_recovery && mpp->retry_tick == 0)
> > > > +                               dm_queue_if_no_path(mpp->alias, 0);
> > > >                         enter_recovery_mode(mpp);
> > > > +               }
> > > >                 break;
> > > >         }
> > > >  }
> > > > --
> > > > 2.41.0
> > > >
> > > >
> >

