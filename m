Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E57221461
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733424093; cv=none; b=VTmhYEqcBkEmgZVejekYPctS1SpeQn5pUX0RhIF3RX8M6GweIa5KuTY7o4+yerCrbVLTF7ggHCC+QOeQsR2HmZp7DX8a0bKcP/7LEaDSNxF8U70ZyfpdrlcwwZUfgNWtsv5UUwUoAKjMkxu2pegxyB9yRVTWaD5QtU8AHlQ8J+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733424093; c=relaxed/simple;
	bh=nYjPO8KvYKp/t+Fp+oX5rtEpQR3WBCV5AqQuSZiwtps=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qUW10pfWRIZyvzuMnfAOI3NTZdmQYi9Pm08FI1OYKio3xzNbpODPDhhTZwwDtuhYkWZm0BcQa6uIKGp7JxicohKJvM+uEFXoBMq3xrEsZ7zeeIjWKcu+GiaWI05HGs0e8LtdItb41I5DpgAbaV+ju81IXw4DlQhyKZJTqmy6jb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c/XAe0my; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c/XAe0my; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c/XAe0my";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c/XAe0my"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 068F21F38F;
	Thu,  5 Dec 2024 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733424089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ubKy7S4X2cEak+9Hsz842h2I/c6GipB08+T+NFLShOA=;
	b=c/XAe0myITEJk/ukISUKFXezkHZifbvbaAzv8DUHI7T6NSVYK1NePr6jZg8Yhwrz7qBBoO
	d5ngB/Qynpw8JOyjdj5SrKrzrUnE/s/QDISKb68XJ3AF2Bn8pWrzeqfZhvNcV/hX2KI9fi
	eVGcHsULkCJk4NxVXI0tsgyN0no5oEw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733424089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ubKy7S4X2cEak+9Hsz842h2I/c6GipB08+T+NFLShOA=;
	b=c/XAe0myITEJk/ukISUKFXezkHZifbvbaAzv8DUHI7T6NSVYK1NePr6jZg8Yhwrz7qBBoO
	d5ngB/Qynpw8JOyjdj5SrKrzrUnE/s/QDISKb68XJ3AF2Bn8pWrzeqfZhvNcV/hX2KI9fi
	eVGcHsULkCJk4NxVXI0tsgyN0no5oEw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3CEA132EB;
	Thu,  5 Dec 2024 18:41:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lH4KMtjzUWd6MwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 05 Dec 2024 18:41:28 +0000
Message-ID: <8665d6bd9ca83d5674139e43345926be7a4b1e3e.camel@suse.com>
Subject: Re: [PATCH 2/3] multipathd: reload maps in checkerloop() if
 necessary.
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 05 Dec 2024 19:41:28 +0100
In-Reply-To: <20241205035638.1218953-3-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
	 <20241205035638.1218953-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 2024-12-04 at 22:56 -0500, Benjamin Marzinski wrote:
> update_pathvec_from_dm() may set mpp->need_reload if it finds
> inconsistent settings. In this case, the map should be reloaded, but
> so
> far we don't do this reliably. Add a call to reload_and_sync_map()
> when updating the maps at the end of a loop in checkerloop().
>=20
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 5 ++++-
> =C2=A01 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index fcab1ed3..c1ae44f2 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3038,7 +3038,10 @@ checkerloop (void *ap)
> =C2=A0							=C2=A0=C2=A0=C2=A0=C2=A0
> start_time.tv_sec);
> =C2=A0			if (checker_state =3D=3D CHECKER_FINISHED) {
> =C2=A0				vector_foreach_slot(vecs->mpvec,
> mpp, i) {
> -					if (update_mpp_prio(vecs,
> mpp) =3D=3D 2) {
> +					if (update_mpp_prio(vecs,
> mpp) =3D=3D 2 ||
> +					=C2=A0=C2=A0=C2=A0 (mpp->need_reload &&
> +					=C2=A0=C2=A0=C2=A0=C2=A0 mpp->synced_count > 0
> &&
> +					=C2=A0=C2=A0=C2=A0=C2=A0
> reload_and_sync_map(mpp, vecs) =3D=3D 2)) {
> =C2=A0						/* multipath device
> deleted */
> =C2=A0						i--;
>=20


The general logic is ok, but as noted on
https://github.com/opensvc/multipath-tools/issues/105), I believe that
do_sync_mpp() is the more natural point in the code to attempt the
reload, but I think it doesn't hurt to do both.

What I don't like so much about this patch is that from this point in
the code, we can call reload_and_sync_map() directly, or indirectly
through update_mpp_prio(). I find that confusing. I think we should
change update_mpp_prio() to just set the need_reload() flag, and then
simply look at the flag in checkerloop(). The "minor" actions in
update_mpp_prio, such as switching path group, can still be done
directly from there.

I can send a patch on top of yours if that's ok with you.

I have some questions. I've spent some time today pulling my hair over
the many functions in the multipath-tools code that are related to=20
syncing states. I'm kind of wound up in my own thinking, perhaps you
can help me break out of the loop :-)

1) I observe that update_map() and reload_and_sync_map() are very
similar. They both set up the map from multipathd's internal state,
reload it, and then update multipathd's state. The differences are as
follows:
   - update_map() calls adopt_paths() and verify_paths() before
setup_map(), while reload_map() only calls update_mpp_paths().=C2=A0
     - It looks like an oversight to me that we don't call
update_mpp_paths() in update_map(), what do you think?
     - What about verify_paths(), why do we call it only in the
update_map() code path?
   - update_map() retries, while reload_and_sync_map() does not.
   - update_map() calls the persistent-reservation related code.
These differences are few enough I think update_map() could actually
call reload_and_sync_map() as a helper.

2) update_map() is called from missing_uev_wait_tick() and
ghost_delay_tick(), while deferred_failback_tick() and the
update_mpp_prio() code path above "only" call reload_and_sync_map().
Is this intentional? If yes, I am missing the rationale (I believe that
just calling reload_and_sync_map() from all the _tick() functions would
be sufficient, but I may be overlooking something).

I'd love it if we could integrate the various _tick() calls with the
rest of the map-reload logic. Ideally the checkerloop and the tick()
functions would just set the need_reload flag, and then we'd do the
reload once at the end of the loop.

Regards,
Martin


