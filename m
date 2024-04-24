Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7616E1772F
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 20:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713991331; cv=none; b=c20n9FvtKOaSEnSA936uKDsDNYeOs1yq0WM4CHfVKx8JMyfNh0oGjW4A0H+8EWKmlDRwCljoc0+Pun3RR0gjxaTkzapYtba3jsFOwFLeSPBVO7UgVyuw3bweWReKm9vvu05v2jQvOmuQdSwbkKcKfOPdxUYouGJsjHunQ3gjB9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713991331; c=relaxed/simple;
	bh=wxnqJqXNzoEmSo/ofXM+7S8PuqARmX7cslfsHaaFhcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MEWP29pBb6stVnt82tT/twr8Z9G4WtBsl8RaW2pfg6VOouqSNGAjDz3Q6OBTWkOgQoeHOd2K+UTWH+fsqsUDCejIdkHXmkMZABjZWj20PTIh/6WkBBIR6BkgMzrQCGp/3laC5LW1drVeq3O8Lqj1BfcGXLoYDWh0RzzIJZojyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5hApepA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5hApepA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713991328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C2CJEC9Y8d3n6ZvIdH5vaIjsHN284CJCmfRYzQUYHnI=;
	b=M5hApepAzpMnTKB595TDBFAuDH59mE8c21c17LnNIqfyA9wvI63dzZfojDeh0km2lGszZb
	0e34cnTxXaBUe1vQMGvaXR4IozP65XOWtgvKjmWwZPjv1oelYFowDsssTxzPTwZysnSMsi
	5kEgNi5n2WjtkAEP254tW/tfDJOKnG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-E2cV5JVEOeOGmAvP8Gg3Nw-1; Wed, 24 Apr 2024 16:42:05 -0400
X-MC-Unique: E2cV5JVEOeOGmAvP8Gg3Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0DD58021A5;
	Wed, 24 Apr 2024 20:42:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2FB02024512;
	Wed, 24 Apr 2024 20:42:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43OKg4FS2108831
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 16:42:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43OKg4pj2108830;
	Wed, 24 Apr 2024 16:42:04 -0400
Date: Wed, 24 Apr 2024 16:42:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/3] libmultipath: change flush_on_last_del to fix a
 multipathd hang
Message-ID: <ZilunDUSAH8jnBNT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
 <20240423222536.2096486-3-bmarzins@redhat.com>
 <439b76a2cdc7d044d2588315663bcca3a21063e2.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <439b76a2cdc7d044d2588315663bcca3a21063e2.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 24, 2024 at 06:34:35PM +0200, Martin Wilck wrote:
> On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> > Commit 9bd3482e ("multipathd: make flush_map() delete maps like the
> > multipath command") Fixed an issue where deleting a queueing
> > multipath
> > device through multipathd could hang because the multipath device had
> > outstanding IO, even thought the only openers of it at the time of
> 
> typo: "thought"

oops.

> 
> > deletion were the kpartx partition devices. However it is still
> > possible
> > to hang multipathd, because autoremoving the device when all paths
> > have
> > been deleted doesn't disable queueing. To reproduce this hang:
> > 
> > 1. create a multipath device with a kpartx partition on top of it and
> > no_path_retry set to either "queue" or something long enough to run
> > all
> > the commands in the reproduce before it expires.
> > 2. disable all the paths to the device with something like

# echo offline > /sys/block/<path_dev>/device/state

> > 3. Write directly to the multipath device with something like

# dd if=/dev/zero of=/dev/mapper/<mpath_dev> bs=4K count=1

> > 4. delete all the paths to the device with something like

# echo 1 > /sys/block/<path_dev>/device/delete

> something like what?

oops again. Forgot that starting my commands with # turned them into
commit comments.


> 
> > Multipathd will be hung trying to delete the kpartx device because,
> > as
> > the last opener, it must flush the multipath device before closing
> > it.
> > Because it hangs holding the vecs_lock, multipathd will never disable
> > queueing on the device, so it will hang forever, even if
> > no_path_retry
> > is set to a number.
> > 
> > Mulitpath can currently be configured to avoid this hang by setting
> > 
> > flush_on_last_del yes
> > 
> > However there are good reasons why users wouldn't want to set that.
> > They
> > may need to be able to survive having all paths temporarily get
> > deleted.
> > I should note that this is a pretty rare corner case, since multipath
> > automatically sets dev_loss_tmo so that it should not trigger before
> > queueing is disabled.
> > 
> > This commit avoids the hang by changing the possible values for
> > flush_on_last_del to "never", "unused", and "always", and sets the
> > default to "unused".  "always" works like "yes" did, "never" will not
> > disable queueing, and "unused" will only disable queueing if nothing
> > has
> > the kpartx devices or the multipath device open. In order to be safe,
> > if
> > the device has queue_if_no_paths set, and the remove is not a
> > deferred
> > one (and in case of "unused", the device is in-use) the autoremove
> > will
> > be skipped. Also, instead of just trusting the lack of
> > "queue_if_no_paths" in the current mpp->features, multipathd will
> > tell
> > the kernel to disable queueing, just to be sure it actually is.
> > 
> > I chose "unused" as the default because this should generally only
> > cause
> > multipathd to work differently from the users perspective when
> > nothing
> > has the multipath device open but it is queueing and there is
> > outstanding IO. Without this change, it would have hung instead of
> > failing the outstanding IO. However, I do understand that an argument
> > could be made that "never" makes more sense as default, even though
> > it
> > will cause multipathd to skip autoremoves in cases where it wouldn't
> > before.
> 
> How important is the autoremove feature, actually? I have do confess I
> don't like it too much, anyway.
> 
> I'd actually vote to set the default to "never", even if that means a
> change in the default behavior, unless someone convinces me that
> autoremoving unused maps with no paths is actually the right thing to
> do.

If we changed the default behavior, we'd find out how much users rely on
it. My guess is "more than they should".  Ideally, users would shut down
their multipath device before removing their underlying path devices.
In practice, I bet that a significant number do not. Since deleting path
devices isn't a common thing, and we can argue that we are just
enforcing good behavior, it's probably o.k. to change it, but I'm pretty
sure some users would complain or file bugs. Off the top of my head, one
thing that could potentially go wrong (although I hope this isn't likely
in the real world) is:

1. User removes the LUNs under an unused multipath device. The
   multipath device isn't removed
2. User creates new LUNs with a different size. The array gives these
   new LUNs the same WWID as the old ones (I don't know how often this
   happens. I hope rarely, if at all)
3. Multipathd tries to add these new LUNs to the existing multipath
   device and fails because the size doesn't match.

Also, our current dev_loss_tmo resetting seems pretty racy. It's set to
exactly the same length of time as the we should retry for. If
multipathd is slow in its retries, paths can get deleted while we are
still queueing, making it more likely that you would have pathless
multipath devices hanging around. In theory, we could add another check
to see if a device has no paths and isn't in use when we disable
queueing, but I don't see a reason why we should expand autoremoving,
and we can easily pad the dev_loss_tmo value to reduce the race.

> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/defaults.h       |  2 +-
> >  libmultipath/dict.c           | 72 +++++++++++++++++++++++++++++++--
> > --
> >  libmultipath/dict.h           |  1 +
> >  libmultipath/hwtable.c        |  6 +--
> >  libmultipath/propsel.c        |  4 +-
> >  libmultipath/structs.h        |  7 ++--
> >  multipath/multipath.conf.5.in | 20 +++++++---
> >  multipathd/main.c             | 42 +++++++++++++++++---
> >  8 files changed, 127 insertions(+), 27 deletions(-)
> > 
> > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > index 64b633f2..ed08c251 100644
> > --- a/libmultipath/defaults.h
> > +++ b/libmultipath/defaults.h
> > @@ -43,7 +43,7 @@
> >  #define DEFAULT_PRIO		PRIO_CONST
> >  #define DEFAULT_PRIO_ARGS	""
> >  #define DEFAULT_CHECKER		TUR
> > -#define DEFAULT_FLUSH		FLUSH_DISABLED
> > +#define DEFAULT_FLUSH		FLUSH_UNUSED
> >  #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
> >  #define DEFAULT_FORCE_SYNC	0
> >  #define UNSET_PARTITION_DELIM "/UNSET/"
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 5af036b7..546103f2 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -791,14 +791,70 @@ declare_def_snprint(checker_timeout,
> > print_nonzero)
> >  declare_def_handler(allow_usb_devices, set_yes_no)
> >  declare_def_snprint(allow_usb_devices, print_yes_no)
> >  
> > -declare_def_handler(flush_on_last_del, set_yes_no_undef)
> > -declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef,
> > DEFAULT_FLUSH)
> > -declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
> > -declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
> > -declare_hw_handler(flush_on_last_del, set_yes_no_undef)
> > -declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
> > -declare_mp_handler(flush_on_last_del, set_yes_no_undef)
> > -declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
> > +
> > +static const char * const flush_on_last_del_optvals[] = {
> > +	[FLUSH_NEVER] = "never",
> > +	[FLUSH_ALWAYS] = "always",
> > +	[FLUSH_UNUSED] = "unused",
> > +};
> > +
> > +static int
> > +set_flush_on_last_del(vector strvec, void *ptr, const char *file,
> > int line_nr)
> > +{
> > +	int i;
> > +	int *flush_val_ptr = (int *)ptr;
> > +	char *buff;
> > +
> > +	buff = set_value(strvec);
> > +	if (!buff)
> > +		return 1;
> > +
> > +	for (i = FLUSH_NEVER; i <= FLUSH_UNUSED; i++) {
> > +		if (flush_on_last_del_optvals[i] != NULL &&
> > +		    !strcmp(buff, flush_on_last_del_optvals[i])) {
> > +			*flush_val_ptr = i;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (i > FLUSH_UNUSED) {
> > +		bool deprecated = true;
> > +		if (strcmp(buff, "no") == 0 || strcmp(buff, "0") ==
> > 0)
> > +			*flush_val_ptr = FLUSH_UNUSED;
> > +		else if (strcmp(buff, "yes") == 0 || strcmp(buff,
> > "1") == 0)
> > +			*flush_val_ptr = FLUSH_ALWAYS;
> > +		else {
> > +			deprecated = false;
> > +			condlog(1, "%s line %d, invalid value for
> > flush_on_last_del: \"%s\"",
> > +				file, line_nr, buff);
> > +		}
> > +		if (deprecated)
> > +			condlog(2, "%s line %d, \"%s\" is a
> > deprecated value for flush_on_last_del and is treated as \"%s\"",
> > +				file, line_nr, buff,
> > +				flush_on_last_del_optvals[*flush_val
> > _ptr]);
> > +	}
> > +
> > +	free(buff);
> > +	return 0;
> > +}
> > +
> > +int
> > +print_flush_on_last_del(struct strbuf *buff, long v)
> > +{
> > +	if (v == FLUSH_UNDEF)
> > +		return 0;
> > +	return append_strbuf_quoted(buff,
> > flush_on_last_del_optvals[(int)v]);
> > +}
> > +
> > +declare_def_handler(flush_on_last_del, set_flush_on_last_del)
> > +declare_def_snprint_defint(flush_on_last_del,
> > print_flush_on_last_del,
> > +			   DEFAULT_FLUSH)
> > +declare_ovr_handler(flush_on_last_del, set_flush_on_last_del)
> > +declare_ovr_snprint(flush_on_last_del, print_flush_on_last_del)
> > +declare_hw_handler(flush_on_last_del, set_flush_on_last_del)
> > +declare_hw_snprint(flush_on_last_del, print_flush_on_last_del)
> > +declare_mp_handler(flush_on_last_del, set_flush_on_last_del)
> > +declare_mp_snprint(flush_on_last_del, print_flush_on_last_del)
> >  
> >  declare_def_handler(user_friendly_names, set_yes_no_undef)
> >  declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
> > diff --git a/libmultipath/dict.h b/libmultipath/dict.h
> > index 7e2dfbe0..e1794537 100644
> > --- a/libmultipath/dict.h
> > +++ b/libmultipath/dict.h
> > @@ -18,4 +18,5 @@ int print_undef_off_zero(struct strbuf *buff, long
> > v);
> >  int print_dev_loss(struct strbuf *buff, unsigned long v);
> >  int print_off_int_undef(struct strbuf *buff, long v);
> >  int print_auto_resize(struct strbuf *buff, long v);
> > +int print_flush_on_last_del(struct strbuf *buff, long v);
> >  #endif /* _DICT_H */
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 640bf347..ce600030 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -60,7 +60,7 @@
> >  		.no_path_retry = NO_PATH_RETRY_UNDEF,
> >  		.minio         = 1000,
> >  		.minio_rq      = 1,
> > -		.flush_on_last_del = FLUSH_DISABLED,
> > +		.flush_on_last_del = FLUSH_UNUSED,
> >  		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> >  		.fast_io_fail  = 5,
> >  		.dev_loss      = 600,
> > @@ -829,7 +829,7 @@ static struct hwentry default_hw[] = {
> >  		.no_path_retry = NO_PATH_RETRY_QUEUE,
> >  		.pgpolicy      = GROUP_BY_PRIO,
> >  		.pgfailback    = -FAILBACK_IMMEDIATE,
> > -		.flush_on_last_del = FLUSH_ENABLED,
> > +		.flush_on_last_del = FLUSH_ALWAYS,
> 
> How much sense do these hwtable entries make? In view of your commit
> description, this seems to be a dangerous device default. It has the
> surprising side effect that users who don't want flush_on_last_del will
> need to set in either in the overrides section or in a dedicated device
> section for the device at hand. This can be changed in a separate patch
> of course.

I remember NetApp having strong feelings about their configs. They are
the only user of the devices section user_friendly_names option. IIRC
the only reason this option exists in the devices section is because
they pushed for it.

But the way they have things set up, I don't see it as dangerous. They
set dev_loss_tmo to "infinity" so their path devices should never
disappear, unless someone chooses to remove them. They also set
no_path_retry to "queue", since they don't want IO to ever fail on their
devices unless someone manually disables queueing. It's odd, but nobody
has ever complained that the builtin config for NetApp devices doesn't
work like the other builtin configs, so it's just remained that way.
Again, it seems like it's more trouble than it's worth to change it now.

On the other hand, the Infinidat config already sets no_path_retry to
"fail", so there's not much point in also setting flush_on_last_del to
"always".

> >  		.dev_loss      = MAX_DEV_LOSS_TMO,
> >  		.prio_name     = PRIO_ONTAP,
> >  		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> > @@ -1160,7 +1160,7 @@ static struct hwentry default_hw[] = {
> >  		.no_path_retry = NO_PATH_RETRY_FAIL,
> >  		.minio         = 1,
> >  		.minio_rq      = 1,
> > -		.flush_on_last_del = FLUSH_ENABLED,
> > +		.flush_on_last_del = FLUSH_ALWAYS,
> >  		.fast_io_fail  = 15,
> >  	},
> >  	/*
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 44241e2a..e2dcb316 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -963,6 +963,7 @@ out:
> >  int select_flush_on_last_del(struct config *conf, struct multipath
> > *mp)
> >  {
> >  	const char *origin;
> > +	STRBUF_ON_STACK(buff);
> >  
> >  	mp_set_mpe(flush_on_last_del);
> >  	mp_set_ovr(flush_on_last_del);
> > @@ -970,8 +971,9 @@ int select_flush_on_last_del(struct config *conf,
> > struct multipath *mp)
> >  	mp_set_conf(flush_on_last_del);
> >  	mp_set_default(flush_on_last_del, DEFAULT_FLUSH);
> >  out:
> > +	print_flush_on_last_del(&buff, mp->flush_on_last_del);
> >  	condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
> > -		(mp->flush_on_last_del == FLUSH_ENABLED)? "yes" :
> > "no", origin);
> > +		get_strbuf_str(&buff), origin);
> >  	return 0;
> >  }
> >  
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 734905e2..a32f6d41 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -109,9 +109,10 @@ enum marginal_pathgroups_mode {
> >  };
> >  
> >  enum flush_states {
> > -	FLUSH_UNDEF = YNU_UNDEF,
> > -	FLUSH_DISABLED = YNU_NO,
> > -	FLUSH_ENABLED = YNU_YES,
> > +	FLUSH_UNDEF,
> > +	FLUSH_NEVER,
> > +	FLUSH_ALWAYS,
> > +	FLUSH_UNUSED,
> >  };
> >  
> >  enum log_checker_err_states {
> > diff --git a/multipath/multipath.conf.5.in
> > b/multipath/multipath.conf.5.in
> > index c788c180..1463e1ea 100644
> > --- a/multipath/multipath.conf.5.in
> > +++ b/multipath/multipath.conf.5.in
> > @@ -707,12 +707,22 @@ The default is: \fBno\fR
> >  .TP
> >  .B flush_on_last_del
> >  If set to
> > -.I yes
> > +.I always
> >  , multipathd will disable queueing when the last path to a device
> > has been
> > -deleted.
> > -.RS
> > -.TP
> > -The default is: \fBno\fR
> > +deleted. If set to
> > +.I never
> > +, multipathd will not disable queueing when the last path to a
> > device has
> > +been deleted. Since multipath cannot safely remove a device while
> > queueing
> > +is enabled, setting this to \fInever\fR means that multipathd will
> > not
> > +automatically remove an unused multipath device whose paths are all
> > deleted if
> > +it is currently set to queue_if_no_path. If set to
> > +.I unused
> > +, multipathd will only disable queueing when the last path is
> > removed if
> > +nothing currently has the multipath device or any of the kpartx
> > parition
> > +devices on top of it open.
> > +.RS
> > +.TP
> > +The default is: \fBunused\fR
> >  .RE
> >  .
> >  .
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index dd17d5c3..20780e7c 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -583,13 +583,43 @@ int update_multipath (struct vectors *vecs,
> > char *mapname)
> >  
> >  static bool
> >  flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
> > -	int r;
> > -
> > +	int r, in_use = 1;
> > +	int deferred_remove = 0;
> > +	bool is_queueing = true;
> > +
> > +	if (mpp->features)
> > +		is_queueing = strstr(mpp->features,
> > "queue_if_no_path");
> > +
> > +	#ifdef LIBDM_API_DEFERRED
> > +	deferred_remove = mpp->deferred_remove;
> > +	#endif
> 
> Unusual indentation of the cpp directives here, and rather ugly in
> general. Maybe we should implement a get_deferred_remove(mpp) helper.

sure.
 
> > +
> > +	/* It's not safe to do a non-deferred remove of a map that
> > has
> > +	 * "queue_if_no_path" set, since there could be outstanding
> > IO which
> > +	 * will cause multipathd to hang while attempting the remove
> > */
> > +	if (mpp->flush_on_last_del == FLUSH_NEVER &&
> > +	    !do_deferred(deferred_remove) && is_queueing) {
> > +		condlog(2, "%s: map is queueing, can't remove", mpp-
> > >alias);
> > +		return false;
> > +	}
> 
> Just a thought: Why don't we just pretend that deferred_remove is on if
> flush_on_last_del is set to "never"? Wouldn't that avoid our issues?
> In the same context, why haven't we made deferred_remove the default
> yet?

I'm not sure we want to change the default multipath behavior without a
good reason.  Users don't expect that removing a multipath device can
succeed, but the device will still be there.

Worse, I just tested and found out that my test will still hang
multipathd with my new code if you have deferred_remove turned on.  This
is because there is no opener of the kpartx device, so device-mapper
tries to immediately remove it. Apparently, it's also not safe to
trigger a deferred remove without disabling queueing.

> > +	if (mpp->flush_on_last_del == FLUSH_UNUSED &&
> > +	    !do_deferred(deferred_remove) &&
> > +            (in_use = partmap_in_use(mpp->alias, NULL)) &&
> > is_queueing) {
> > +		condlog(2, "%s: map in use and queueing, can't
> > remove",
> > +			mpp->alias);
> > +		return false;
> > +	}
> 
> Same reasoning as above, why not just defer?
> 
> >  	/*
> > -	 * flush_map will fail if the device is open
> > +	 * This will flush FLUSH_NEVER devices and FLUSH_UNUSED
> > devices
> > +	 * that are in use, but only if this is not a deferred
> > remove, and
> 
> "that are not in use" ?

This *will* disable queue_if_no_path on in-use devices. But like I said,
only if, according to mulitpathd, the device is already set to
queue_if_no_path.  This is just to make sure the mpp->features isn't out
of date, since getting this wrong and hanging multipathd is a bad thing.
Alternatively, I could call update_multipath_table() to make sure
mpp->features is up to date. This way does less work, and if multipathd
thinks that the device shouldn't be queueing, then it really shouldn't
be queueing.
 
> > +	 * they are already marked as not queueing. That is just to
> > make
> > +	 * absolutely certain that they really are not queueing like
> > they
> > +	 * claim.
> >  	 */
> > -	if (mpp->flush_on_last_del == FLUSH_ENABLED) {
> > -		condlog(2, "%s Last path deleted, disabling
> > queueing",
> > +	if (mpp->flush_on_last_del == FLUSH_ALWAYS ||
> > +	    !do_deferred(deferred_remove) || !in_use) {
> > +		condlog(is_queueing ? 2 : 3,
> > +			"%s Last path deleted, disabling queueing",
> >  			mpp->alias);
> >  		mpp->retry_tick = 0;
> >  		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
> > @@ -597,7 +627,7 @@ flush_map_nopaths(struct multipath *mpp, struct
> > vectors *vecs) {
> >  		mpp->stat_map_failures++;
> >  		dm_queue_if_no_path(mpp, 0);
> >  	}
> > -	r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
> > +	r = dm_flush_map_nopaths(mpp->alias, deferred_remove);
> 
> AFAIU, this line should only be executed if either disabling queueing
> above succeeded, or do_deferred(deferred_remove) is true.
> This code doesn't guarantee that, or am I overlooking something?

Oops. Good catch.
 
> Regards,
> Martin
> 
> 
> >  	if (r != DM_FLUSH_OK) {
> >  		if (r == DM_FLUSH_DEFERRED) {
> >  			condlog(2, "%s: devmap deferred remove",
> > mpp->alias);

