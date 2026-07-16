Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28733CFF72
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191292; cv=none; b=QrRSAyD4BQ2NDov8fYpkNxAMEC2TLDwKoRXjtgkMjLDHZzA0JOOPiOFBRUBVYMFmF4TMuq7dkjB4moa0xCPMxMq9QOFAOOmEoTBEm1hzrNoQTIbAwpJ0m2A3tvt3p8Q6zkkIp8rXy4wlSC9EgO93bj7si5KkPhxRdML+YicblmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191292; c=relaxed/simple;
	bh=jjWK3BV9pWqS4gURT9kMJohgpi7TAZMNZhjkkzOB9xo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q67XrDXNqLU5Sm2j6UobdcptxaW0/0eAOlGXaS2V7v7+EzSyA0LLnfZfdqy8Hu3geN7aM8xQylihYC69UkCmkYTOJt4CX3qP73RTSxTjPVf8XTLer/ZbihTeVsQLW0+kbExlCTjAtubgFYNCC8dKxBR91seDB2vaEH9fT9Fk0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UU791LQB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UU791LQB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UU791LQB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UU791LQB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AC8233E3D;
	Thu, 16 Jul 2026 08:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784191287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CXCaOqFVhZkjxHH/8VghUtKWVENlKnyudw42+HkCnU=;
	b=UU791LQBXWEv7Iu3a8CvaY01IjlbKJHlOfJL59AVh0Ky5ey4Ut2XiywJaFNWp9WrveCd2N
	eIYkzi/6U3W75x6Z5bMrbbF02hgBXhvC10gXzOJerByRLmkjAIHXGgURWhSPZiWIDg3qSq
	H7u+rx261r8oecSymCLnHx6yxEDq1Cc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UU791LQB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784191287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CXCaOqFVhZkjxHH/8VghUtKWVENlKnyudw42+HkCnU=;
	b=UU791LQBXWEv7Iu3a8CvaY01IjlbKJHlOfJL59AVh0Ky5ey4Ut2XiywJaFNWp9WrveCd2N
	eIYkzi/6U3W75x6Z5bMrbbF02hgBXhvC10gXzOJerByRLmkjAIHXGgURWhSPZiWIDg3qSq
	H7u+rx261r8oecSymCLnHx6yxEDq1Cc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90D71779AD;
	Thu, 16 Jul 2026 08:41:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Aq8mIjeZWGpYZAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 16 Jul 2026 08:41:27 +0000
Message-ID: <33a65ffb59df981e93d9eb638249dc77fdabf38f.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <mwilck@suse.com>
To: Cykang <cykang4830@gmail.com>, dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Jul 2026 10:41:27 +0200
In-Reply-To: <20260711033107.2318-1-cykang4830@gmail.com>
References: <20260711033107.2318-1-cykang4830@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AC8233E3D
X-Spam-Score: -4.51

Thanks for your patch!

On Sat, 2026-07-11 at 11:31 +0800, Cykang wrote:
> According to the SCSI-3 Persistent Reservations specification, when a
> self-preemption is performed with a key that does not currently hold
> an active reservation, the operation should be treated as an
> unregister
> and should not fail.
>=20
> The current code in do_mpath_persistent_reserve_out() does not check
> whether the preempting key has a reservation before invoking the
> self-preemption path. It unconditionally calls preempt_self() and
> re-registers the key on the local paths, even when the key has no
> reservation. This violates the SCSI-3 PR spec and can lead to
> incorrect reservation states.
>=20
> This patch moves the self-preemption check inside the conditional
> block so that it only executes when the key matches, but does not
> bypass the general preemption path for keys without a reservation.
> With this change, the code will fall through to the common PR_OUT
> handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> reserved, allowing the storage target to properly process the
> operation as an unregister.
>=20
> Signed-off-by: Cykang <cykang4830@gmail.com>

Your patch would cause PREEMPT to do nothing at all when it doesn't own
the reservation (more precisely, when sa_key doesn't match the mpp's
key). That seems wrong to me. You are right that in this case the keys
shouldn't be re-registered. But we must take care that the mpp's key is
unregistered on all paths. AFAICS, this is the effect of the command

	status =3D mpath_prout_common(mpp, rq_servact, rq_scope,
rq_type,
				    &paramp, noisy, &pp, NULL);

in preempt_self(), if and only if this command was successful and the
key of the mpp doesn't hold the current reservation. (According to SPC-
6, in this case the storage server should "remove the registrations for
all I_T nexuses specified by the SERVICE ACTION RESERVATION KEY
field").

So IMO what we should do is simply resume and return in preempt_self()
after the above command if we don't hold the reservation, which we
should check using check_holding_reservation().

I guess this requires a new PREE_WORK_ enum value.

I'll leave the final verdict to Ben, who knows the logic of our PR code
better than me.

Regards
Martin


> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 13 +++++++------
> =C2=A01 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 3091c5c2..2ee7fe68 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -960,14 +960,15 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0				ret =3D preempt_all(mpp, rq_servact,
> rq_scope,
> =C2=A0						=C2=A0 rq_type, noisy);
> =C2=A0				break;
> +			}
> +					/* if we are preempting
> ourself */
> +			if (memcmp(paramp->sa_key, paramp->key, 8)
> =3D=3D 0) {
> +				ret =3D preempt_self(mpp, rq_servact,
> rq_scope, rq_type,
> +						noisy,
> PREE_WORK_NONE);
> +				break;
> =C2=A0			}
> =C2=A0		}
> -		/* if we are preempting ourself */
> -		if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D 0) {
> -			ret =3D preempt_self(mpp, rq_servact,
> rq_scope, rq_type,
> -					=C2=A0=C2=A0 noisy, PREE_WORK_NONE);
> -			break;
> -		}
> +
> =C2=A0		/* fallthrough */
> =C2=A0	case MPATH_PROUT_RES_SA:
> =C2=A0	case MPATH_PROUT_CLEAR_SA: {

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
