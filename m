Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9EE6D1CD
	for <dm-devel@lists.linux.dev>; Tue,  5 Dec 2023 19:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMN623sV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701804505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/f9Xdc/To8aevqbtv6UAj9NOfFRliXBZ7Ftsl2qoWFs=;
	b=ZMN623sVsdnpxvPKebjGfZFKRqq5Onzo7MapIYZ8w68pdfAesE4JqrBp01Uw/qBNDfw2x+
	LpD/DsWOqVbusWX4+rdamVqWhwj6Re5716rgdpESF3EnEyq+S9Pvt3iV+4zGN+E4nusCsO
	YhFpbTlApXrBXZ/ai/XdC+g/kECLbFA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-_vNZ55GJP3OkafRnmy_yzA-1; Tue, 05 Dec 2023 14:28:24 -0500
X-MC-Unique: _vNZ55GJP3OkafRnmy_yzA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF5785A58E;
	Tue,  5 Dec 2023 19:28:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 62C362166B35;
	Tue,  5 Dec 2023 19:28:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3B5JSNep352668
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 5 Dec 2023 14:28:23 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3B5JSMoR352667;
	Tue, 5 Dec 2023 14:28:22 -0500
Date: Tue, 5 Dec 2023 14:28:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
Message-ID: <ZW951oB3ANEs16z0@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
 <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
 <ZW4v8bZSDSypdv42@bmarzins-01.fast.rdu2.eng.redhat.com>
 <094991ab4257ab76755d83a8738676f76327d1ec.camel@suse.com>
 <ZW5aQ7T+znP/3N56@bmarzins-01.fast.rdu2.eng.redhat.com>
 <00ea66aa2aa83176d6db9609f5173bbd5e294381.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <00ea66aa2aa83176d6db9609f5173bbd5e294381.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Dec 05, 2023 at 03:57:13PM +0100, Martin Wilck wrote:
> On Mon, 2023-12-04 at 18:01 -0500, Benjamin Marzinski wrote:
> > On Mon, Dec 04, 2023 at 09:43:58PM +0100, Martin Wilck wrote:
> > > On Mon, 2023-12-04 at 15:00 -0500, Benjamin Marzinski wrote:
> > > > On Mon, Dec 04, 2023 at 03:38:03PM +0100, Martin Wilck wrote:
> > > > > On Mon, 2023-11-27 at 16:54 -0500, Benjamin Marzinski wrote:
> > > > > > If a multipath device has no_path_retry set to a number and
> > > > > > has
> > > > > > lost
> > > > > > all
> > > > > > paths, gone into recovery mode, and timed out, it will
> > > > > > disable
> > > > > > queue_if_no_paths. After that, if one of those failed paths
> > > > > > is
> > > > > > removed,
> > > > > > when the device is reloaded, queue_if_no_paths will be re-
> > > > > > enabled. 
> > > > > > When
> > > > > > set_no_path_retry() is then called to update the queueing
> > > > > > state,
> > > > > > it
> > > > > > will
> > > > > > not disable queue_if_no_paths, since the device is still in
> > > > > > the
> > > > > > recovery
> > > > > > state, so it believes no work needs to be done. The device
> > > > > > will
> > > > > > remain
> > > > > > in the recovery state, with retry_ticks at 0, and queueing
> > > > > > enabled,
> > > > > > even though there are no usable paths.
> > > > > > 
> > > > > > To fix this, in set_no_path_retry(), if no_path_retry is set
> > > > > > to a
> > > > > > number
> > > > > > and the device is queueing but it is in recovery mode and out
> > > > > > of
> > > > > > retries with no usable paths, manually disable
> > > > > > queue_if_no_path.
> > > > > > 
> > > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > > 
> > > > > Thanks, this makes sense. I am just wondering if this logic
> > > > > should
> > > > > be moved to enter_recovery_mode() / leave_recovery_mode()
> > > > > instead.
> > > > > That pair of functions is also called from
> > > > > update_queue_mode{add,del}_path(), where the same reasoning
> > > > > would
> > > > > apply, afaics. Am I overlooking something?
> > > > 
> > > > In general, I think it's safe to only do this in
> > > > set_no_path_retry().
> > > > The functions that call update_queue_mode{add,del}_path() are:
> > > > fail_path()
> > > > reinstate_path()
> > > > update_multipath()
> > > > io_err_stat_handle_pathfail()
> > > > 
> > > > fail_path() and reinstate_path() will always call the
> > > > update_queue_mode_* function after calling set_no_path_retry(),
> > > > so
> > > > the
> > > > device will already be in the correct state. update_multipath()
> > > > usually
> > > > will as well (except when it's called by a command line handler),
> > > > and
> > > > further, it will only call update_queue_mode_del_path() when it
> > > > is
> > > > actually failing a path, so the multipath device shouldn't
> > > > already be
> > > > in recovery_mode. The same goes for
> > > > io_err_stat_handle_pathfail().
> > > > 
> > > > Also we need to make sure that mpp->features is uptodate before
> > > > doing
> > > > these checks, so that we know what the current queueing state is.
> > > > io_err_stat_handle_pathfail() doesn't update mpp->features before
> > > > calling update_queue_mode_del_path(), so it could end up doing
> > > > the
> > > > wrong
> > > > thing.
> > > > 
> > > > And set_no_path_retry() will be called (after updating mpp-
> > > > >features)
> > > > the next time the path checker completes for a path in the
> > > > device, so
> > > > devices won't remain in a bad state long, no matter what.
> > > > 
> > > > What looking at this did make me realize is that
> > > > cli_restore_queueing()
> > > > and cli_restore_all_queueing() don't update the device strings
> > > > before
> > > > calling set_no_path_retry(). Thinking about this, it seems like
> > > > they
> > > > should call update_multipath(vecs, mpp->alias, 1) instead, to
> > > > trigger
> > > > the set_no_path_retry() call after updating mpp->features.
> > > > 
> > > > I'll send another patch to fix cli_restore_queueing() and
> > > > cli_restore_all_queueing(). If you think it's necessary, I can
> > > > also
> > > > send
> > > > one to make io_err_stat_handle_pathfail() call update_multipath()
> > > > and
> > > > then move the code to manually change the queueing state to
> > > > enter_recovery_mode() and leave_recovery_mode(), instead of doing
> > > > it
> > > > in
> > > > set_no_path_retry().
> > > > 
> > > 
> > > Thanks for working out all the different cases. Personally, I would
> > > like to have this logic in one place, if possible. I'll leave it to
> > > your judgement, as you've taken a closer look than myself.
> > > 
> > > I'm not sure what you mean with "mpp->features is up to date"; are
> > > you
> > > considering some entity applying changes to the mpp features
> > > without
> > > involving multipathd, e.g. by using direct DM ioctls or dmsetup?
> > 
> > Or right after multipathd calls dm_queue_if_no_path(). We don't
> > immediately update mpp->features to reflect the changed
> > queue_if_no_paths setting of the device. So there are windows after
> > someone, including multipathd, has changed the queue_if_no_paths
> > setting
> > of the device, during which checking mpp->features won't give the
> > correct answer unless we first reread the device table. Obviously, if
> > something other than multipathd has changed this, then there's always
> > the possiblity of a race, but we can make sure that we don't race
> > with
> > ourselves.
> > 
> > For instance, the way things are right now, running:
> > 
> > # multipathd disablequeueing maps; multipathd restorequeueing maps
> > 
> > will occasionally leave the devices not queueing until the next time
> > a
> > path in them is checked, and set_no_path_retry actually restores
> > queueing.  But I'm actually going to deal with this differently. I'll
> > send a patchset shortly.
> 
> You are right, I see. It's actually an inconsistency that I would like
> to get rid of. I suggest that we ditch mpp->features entirely, and just
> keep track of the map's features using an abstract representation using
> booleans and ints. We should never apply kernel status changes that are
> inconsistent with our own representation of the map's features, IMO.

I don't agree with ditching it entirely. The existance of mpp->features
allows people to use a kernel feature with a version of the userspace
tools that wasn't doesn't know about it. This means that if a new
feature is added to the kernel, the existing multipath userspace tools
can be used to test it.

We need to provide users the option of setting features, and for
backwards compatibility, we need to accept strings in the feature line
that we also have other options to set. And we still need to build up a
features line to pass into the kernel. So we will still need the code to
reconcile the features line with other options.  I'm not sure we would
gain much by converting it to a set of variables and then back again.

The one case where we really need to track our current value separate
from the features line is queue_if_no_path, and it does make sense to
track that as a variable, so we can easily update it when we make
changes to it. But even there, the current value is not necessarily the
value we want to put in the features line we pass to the kernel. If we
aren't queueing, and then add a working path, when we reload the device
we want to use the configured no_path_retry value, and not our current
queueing state.

One thing that would be nice would be tweaking the queue_if_no_path
value in the features string that we pass to the kernel based on the
current queueing state and the current path states. If we are reloading
a device, and we know that all the paths in that device are down, and we
currently aren't queueing, we shouldn't pass in a features string that
tells the kernel to enable queueing, which is what we currently do. The
patch I posted which started this conversation exists because we don't
do this, and we need to fix the queueing state afterwards.
 
> Along a similar line of reasoning, let me emphasize again why I would
> like to have the logic for enabling or disabling queueing in one place.
> Your previous post nicely distinguished the various cases and call
> chains which change the queueing and recovery mode, but it would be
> better if that kind of assessment wasn't necessary, and instead it was
> possible to inspect the code in just a block of (say) 50 code lines
> that would decide whether or not a given map should be queueing and /
> or in recovery mode.
> 
> It's an unfortunate property of the multipath-tools code base that
> important logic is dispersed over multiple functions and source files,
> making a correct assessment of the code flow difficult and cumbersome.
> It can't be completely avoided given the complexity of the subject, but
> it would be nice to try.
> 
> I'm looking forward to your new patch set ;-)

Unfortunately, my new patchset doesn't change the first patch. It just
builds on it to clean how the interactive client commands call things, to
reduce the callers of some of our functions, and keep the client
commands from doing more work than they should be. After the changes,
the only things calling set_no_path_retry() are functions that are
updating the multipath device due to external events, and the check_path
code.  

The update_queue_mode{add,del}_path() functions should be (and based on
my code examination, are) able to assume a device in the correct queuing
and recovery state, and just do the work of entering or leaving the
recovery mode, based on a change in the number of active paths. 

If we move the code that checks if the our queuing state is wrong out of
set_no_path_retry() into the update_queue_mode{add,del}_path(), then we
add a requirement that callers of those functions refresh the current
queueing state. Otherwise we can't actually guarantee that they do the
right thing. With the current callers, this doesn't really matter,
because we don't need them to fix the queueing state. But why not keep
the code that fixes the queueing state in a function that's called when
it could be wrong, and also is (after my new patchset) only called after
we have refreshed the state so it will do the right thing.

So, I would prefer if we go with my first patch, as is.  I'm open to the
idea of moving this code into update_queue_mode{add,del}_path() as part
of a future patchset where we switch to tracking the current queueing
state outside of mpp->features, and updating it whenever we actually
enable or disable queueing. I can work on this if you want.

-Ben 

> Thanks,
> Martin
> 
> 
> 
> 

