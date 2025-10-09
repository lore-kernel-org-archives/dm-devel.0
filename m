Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BADD2D8785
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760003839; cv=none; b=hfJtiOH98c+vLgWyVTCen671W+/3WtNBfjSa8GG1kIYAJcn1SOWat9E9VmjlO3ibcxTREMisHU7EkYOnc1NqJ5gpse/rSJwUc8IQEbRGGS+qkZOulhAK6yUsCUnlmiq59qdNPXzodHGMWxqIKaQUbY2TWYGRDkpV9GMZE3ipziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760003839; c=relaxed/simple;
	bh=O+LhWHgHsKQMiPmQe5PPch640Iq05HFeaS3jqhuQAw0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mFZuKbWNPmvAN9RFctWTa3WJ7SL6AgJztSv6pldZkij9XScD5wkUr8U4uuxw/p31Qve9TbRzxAwiyMGr3qs5yfehYqgLw9y5/pQ/6og8IYH88qSUhQz0pMZNSKanK0v1RftFzgXyF8TrRLlrTZS04SjqLWKDCa9+OA9Ux9kqgnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=X1K3uJVs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rEStoVGA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="X1K3uJVs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rEStoVGA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E50C91F74A;
	Thu,  9 Oct 2025 09:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760003829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5va3xcWLyjfc7byFc4/Mv7yxe0FpLzbpXt6vSO5Qnlw=;
	b=X1K3uJVs4mb7EsKj9gLgJNlKunbElbOGGCzbtJNntehz/3EG+kv9sHfVOlfemEdmwwul72
	uH9+igKedFL28HJCQ2JVXVYBmGGu7aXgNUg5sI1utOdmeIZo0laixssMhkgd7L5hldffm6
	Qz8ELIvM0JM2kghyQuDa3c6XnbM9vAw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760003828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5va3xcWLyjfc7byFc4/Mv7yxe0FpLzbpXt6vSO5Qnlw=;
	b=rEStoVGAmfVaZ029fp05fHC4zus/bpiFtQh3TRnd7FDojR22dWAYasg9ejPvC0VWK0YzoQ
	qeI6sQ4OvDBqt/JowTM/jvqZ7cHSSYcIxgTCJTcDUI7OpiJHSgEpoAkglFBHbOsFVXxDFR
	6T8g9UmajrH3F2y7e8nPB3Cf9IreaOc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF89C13AAC;
	Thu,  9 Oct 2025 09:57:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iA2tLfSG52huNQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 09 Oct 2025 09:57:08 +0000
Message-ID: <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka
	 <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Date: Thu, 09 Oct 2025 11:57:08 +0200
In-Reply-To: <20251009030431.2895495-1-bmarzins@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Wed, 2025-10-08 at 23:04 -0400, Benjamin Marzinski wrote:
> Request-based devices (dm-multipath) queue I/O in blk-mq on noflush
> suspends. Any queued IO will make it impossible to freeze the queue.
> If
> a process attempts to update the queue limits while there is queued
> IO,
> it can be get stuck holding the limits lock, while unable to freeze
> the
> queue. If device-mapper then attempts to update the limits during a
> table swap, it will deadlock trying to grab the limits lock while
> making
> it impossible to flush the IO.
>=20
> Disallow updating the queue limits during a table swap, when updating
> an
> immutable request-based dm device (dm-multipath) during a noflush
> suspend. It is userspace's responsibility to make sure that the new
> table uses the same limits as the existing table if it asks for a
> noflush suspend.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0drivers/md/dm-table.c |=C2=A0 4 ++++
> =C2=A0drivers/md/dm-thin.c=C2=A0 |=C2=A0 7 ++-----
> =C2=A0drivers/md/dm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 35 ++++++++++=
+++++++++++++------------
> =C2=A03 files changed, 29 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index ad0a60a07b93..0522cd700e0e 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -2043,6 +2043,10 @@ bool dm_table_supports_size_change(struct
> dm_table *t, sector_t old_size,
> =C2=A0	return true;
> =C2=A0}
> =C2=A0
> +/*
> + * This function will be skipped by noflush reloads of immutable
> request
> + * based devices (dm-mpath).
> + */
> =C2=A0int dm_table_set_restrictions(struct dm_table *t, struct
> request_queue *q,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct queue_limits *limits)
> =C2=A0{
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index c84149ba4e38..6f98936f0e05 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -4383,11 +4383,8 @@ static void thin_postsuspend(struct dm_target
> *ti)
> =C2=A0{
> =C2=A0	struct thin_c *tc =3D ti->private;
> =C2=A0
> -	/*
> -	 * The dm_noflush_suspending flag has been cleared by now,
> so
> -	 * unfortunately we must always run this.
> -	 */
> -	noflush_work(tc, do_noflush_stop);
> +	if (dm_noflush_suspending(ti))
> +		noflush_work(tc, do_noflush_stop);
> =C2=A0}
> =C2=A0
> =C2=A0static int thin_preresume(struct dm_target *ti)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3ede5ba4cf7e..87e65c48dd04 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2439,7 +2439,6 @@ static struct dm_table *__bind(struct
> mapped_device *md, struct dm_table *t,
> =C2=A0{
> =C2=A0	struct dm_table *old_map;
> =C2=A0	sector_t size, old_size;
> -	int ret;
> =C2=A0
> =C2=A0	lockdep_assert_held(&md->suspend_lock);
> =C2=A0
> @@ -2454,11 +2453,13 @@ static struct dm_table *__bind(struct
> mapped_device *md, struct dm_table *t,
> =C2=A0
> =C2=A0	set_capacity(md->disk, size);
> =C2=A0
> -	ret =3D dm_table_set_restrictions(t, md->queue, limits);
> -	if (ret) {
> -		set_capacity(md->disk, old_size);
> -		old_map =3D ERR_PTR(ret);
> -		goto out;
> +	if (limits) {
> +		int ret =3D dm_table_set_restrictions(t, md->queue,
> limits);
> +		if (ret) {
> +			set_capacity(md->disk, old_size);
> +			old_map =3D ERR_PTR(ret);
> +			goto out;
> +		}
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> @@ -2836,6 +2837,7 @@ static void dm_wq_work(struct work_struct
> *work)
> =C2=A0
> =C2=A0static void dm_queue_flush(struct mapped_device *md)
> =C2=A0{
> +	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> =C2=A0	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
> =C2=A0	smp_mb__after_atomic();
> =C2=A0	queue_work(md->wq, &md->work);
> @@ -2848,6 +2850,7 @@ struct dm_table *dm_swap_table(struct
> mapped_device *md, struct dm_table *table)
> =C2=A0{
> =C2=A0	struct dm_table *live_map =3D NULL, *map =3D ERR_PTR(-EINVAL);
> =C2=A0	struct queue_limits limits;
> +	bool update_limits =3D true;
> =C2=A0	int r;
> =C2=A0
> =C2=A0	mutex_lock(&md->suspend_lock);
> @@ -2856,20 +2859,31 @@ struct dm_table *dm_swap_table(struct
> mapped_device *md, struct dm_table *table)
> =C2=A0	if (!dm_suspended_md(md))
> =C2=A0		goto out;
> =C2=A0
> +	/*
> +	 * To avoid a potential deadlock locking the queue limits,
> disallow
> +	 * updating the queue limits during a table swap, when
> updating an
> +	 * immutable request-based dm device (dm-multipath) during a
> noflush
> +	 * suspend. It is userspace's responsibility to make sure
> that the new
> +	 * table uses the same limits as the existing table, if it
> asks for a
> +	 * noflush suspend.
> +	 */
> +	if (dm_request_based(md) && md->immutable_target &&
> +	=C2=A0=C2=A0=C2=A0 __noflush_suspending(md))
> +		update_limits =3D false;
> =C2=A0	/*
> =C2=A0	 * If the new table has no data devices, retain the existing
> limits.
> =C2=A0	 * This helps multipath with queue_if_no_path if all paths
> disappear,
> =C2=A0	 * then new I/O is queued based on these limits, and then
> some paths
> =C2=A0	 * reappear.
> =C2=A0	 */
> -	if (dm_table_has_no_data_devices(table)) {
> +	else if (dm_table_has_no_data_devices(table)) {
> =C2=A0		live_map =3D dm_get_live_table_fast(md);
> =C2=A0		if (live_map)
> =C2=A0			limits =3D md->queue->limits;
> =C2=A0		dm_put_live_table_fast(md);
> =C2=A0	}
> =C2=A0
> -	if (!live_map) {
> +	if (update_limits && !live_map) {
> =C2=A0		r =3D dm_calculate_queue_limits(table, &limits);
> =C2=A0		if (r) {
> =C2=A0			map =3D ERR_PTR(r);
> @@ -2877,7 +2891,7 @@ struct dm_table *dm_swap_table(struct
> mapped_device *md, struct dm_table *table)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	map =3D __bind(md, table, &limits);
> +	map =3D __bind(md, table, update_limits ? &limits : NULL);
> =C2=A0	dm_issue_global_event();
> =C2=A0
> =C2=A0out:
> @@ -2930,7 +2944,6 @@ static int __dm_suspend(struct mapped_device
> *md, struct dm_table *map,
> =C2=A0
> =C2=A0	/*
> =C2=A0	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
> -	 * This flag is cleared before dm_suspend returns.
> =C2=A0	 */
> =C2=A0	if (noflush)
> =C2=A0		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> @@ -2993,8 +3006,6 @@ static int __dm_suspend(struct mapped_device
> *md, struct dm_table *map,
> =C2=A0	if (!r)
> =C2=A0		set_bit(dmf_suspended_flag, &md->flags);
> =C2=A0
> -	if (noflush)
> -		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> =C2=A0	if (map)
> =C2=A0		synchronize_srcu(&md->io_barrier);

This moves the clear_bit() behind synchronize_rcu(). Is that safe?

In general, I'm wondering whether we need a more generic solution to
this problem. Therefore I've added linux-block to cc.

The way I see it, if a device has queued IO without any means to
perform the IO, it can't be frozen. We'd either need to fail all queued
IO in this case, or refuse attempts to freeze the queue.

Thanks,
Martin
