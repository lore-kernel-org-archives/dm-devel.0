Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F06D2EC54D
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 12:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765196862; cv=none; b=OTlBZEE1xAngNt5v4HuH1Rfh7V8LQJllA4vohTcdoSu/2sq4mYUpN/kIToiTvGTUwaV3XfU+5UfP/bKXrX/g8wVk7HK6aQpIBGljlzzYLDH2dEGvZ6s2M9f4vI1mxBEAcxSTBgq0d4IIZ0ufrVTjHi+7NLIhRKNzjvhv8RG3NFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765196862; c=relaxed/simple;
	bh=D3LonfO8PiUqWcBqSAWWLfd37NYaxhjTgRfzVlvrpb4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EIBQyVBpf/UCWEgOF4kvQUOvs7pgAQc8ABvK30qT3V0BeQchsAJRWxxRyyOmb8q0BS2OOBSxojHzO8KWLkLu9fHfA/7pqJ8Ghc4qftc1rcZgr3/eIujIeoLJQk7BJWb2IfUcf3n+9uP94OgG2yH1iIoUHFJBQgdF5gS/QX8CH0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZuksUELA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZuksUELA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZuksUELA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZuksUELA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C62EB5BF07;
	Mon,  8 Dec 2025 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765196852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExbjLKszk0ESS4IZsgiyk0CZJjOJHieUjTPptJIQQWA=;
	b=ZuksUELA5a0KCstMxIJPqsDk6+lG4mVgraU2BwZqgSuNJ/MiLbyLz0eFH1zNaa0jccVnfY
	YAr5PwdqD5zDuSF2pVLqVe1aRChQUgOY3vnBzf418PeknOE/gwJLjwypOozkfZtu125Ogm
	EZaszgfn9NSKIHfLpjpRxUfXRBkMpFo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765196852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExbjLKszk0ESS4IZsgiyk0CZJjOJHieUjTPptJIQQWA=;
	b=ZuksUELA5a0KCstMxIJPqsDk6+lG4mVgraU2BwZqgSuNJ/MiLbyLz0eFH1zNaa0jccVnfY
	YAr5PwdqD5zDuSF2pVLqVe1aRChQUgOY3vnBzf418PeknOE/gwJLjwypOozkfZtu125Ogm
	EZaszgfn9NSKIHfLpjpRxUfXRBkMpFo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6DD13EA63;
	Mon,  8 Dec 2025 12:27:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6b6fJzTENmnMRAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 08 Dec 2025 12:27:32 +0000
Message-ID: <8a93aa8d60eb620469c0e0f4dc535ddc8eb3c7b1.camel@suse.com>
Subject: Re: [PATCH v3] mulitpath-tools Add purge capability to
 multipath-tools
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Krishna Kant <krishna.kant@purestorage.com>
Date: Mon, 08 Dec 2025 13:27:32 +0100
In-Reply-To: <aTHiDRgQ2A3rjaKS@redhat.com>
References: <20251203161933.90318-1-brian@purestorage.com>
	 <aTHiDRgQ2A3rjaKS@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.811];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.26

On Thu, 2025-12-04 at 14:33 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 03, 2025 at 08:19:33AM -0800, Brian Bunker wrote:

> How about a simplifying the purge thread slightly. When the checker
> gets
> a path it is supposed to purge, it sets purge_path, just like now. I
> don't think we need to track purge_retries at all. When the purge
> loop
> is triggered, it locks the vecs lock, and finds a single path to
> purge,
> like now. The only info it needs to save is the udev device (with a
> new
> refcount taken like now) and a dup of pp->fd (You need this to
> guarantee
> that the devnode won't get reused if the device is deleted and a new
> one
> is re-added). You could also save the name, but
> udev_device_get_devnode() will get it for you.=C2=A0 Like I mentioned
> above,
> you need to have a pthread cleanup handler that gets run to clean
> these
> up if they are set and the thread is cancelled, just like how the
> vecs
> lock is handled. Then purgeloop() clears pp->purge_path, drops the
> vecs
> lock, does the sysfs delete, and cleans up the purge_info by calling
> pthread_cleanup_pop(). Finally it loops back to reacquiring the vecs
> lock and finding the next path to delete. I don't really see a value
> in
> all the stats tracking. If it goes through all the paths, and doesn't
> find one in need of purging, it waits, just like now.

I'd go one step further and suggest an approach similar to what we do
in the uevent handler, for which we have a separate list of uevents
that shares no data with the main multipath threads.

Roughly like this:

enum purge_state {
    PURGE_REQUESTED =3D 1,
    PURGE_DONE,
    PURGE_ERROR
};

struct path_to_purge {
        struct list_head queue;
	struct udev_device *udev; /* one ref taken while on the list
*/
	int fd;                   /* dup of pp->fd */
        enum purge_state state;
};

// global list_head for the queue of paths to be purged.
static LIST_HEAD(purge_queue);

If multipathd detects a path to purge in the checker thread, it
allocates and adds a path_to_purge entry with state PURGE_REQUESTED to
the queue and triggers the purge thread e.g. with a pthreads condition
variable.

The purge thread then walks through the list (without modifying the
list itself), sends a delete request to the kernel and atomically sets
the state field to PURGE_DONE when successful.

multipathd's checker thread walks the list next time and removes
entries that have state !=3D PURGE_REQUESTED, closing the fd and unref-
ing the struct udev.=C2=A0IOW the resource allocation/freeing for this list
and its elements would be handled by the checker alone. The checker
would not immediately drop internal references to the path; this would
be handled by the remove uevent handler as usual.

The purge thread would never write to the list, except to the state
attribute of list members (which we could protect from being freed via
RCU).

This would make the purge thread almost an independent process.

Opinions?

Martin
