Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176D522D4D6
	for <dm-devel@lists.linux.dev>; Thu,  8 May 2025 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746712218; cv=none; b=LMtWaCeqsP2sa0ws+5rBOzdYwMjuH1ItAT4KMILuKg/XWcKPlVe7H2aHQG9Apc/Y2+b845jsQQ3de5AxvZIR16hO3VtwSp72PeTlQZjr0v9fXDN7xTJFPUSnf8i4E89HbuvI7sJfqEHgRis6acoChm6qx6e6u+TEbmzK+WlmUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746712218; c=relaxed/simple;
	bh=L98kzA/S1gVcG3tKfXm5VAvJL8bkz+KMHUt7l8hT7bs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5lpPecBmlyIhnmiIpN41CceXG0lSy01zu/D2nO1WqxCwNSNKiOKSrOtufC/cKdzeGevwdFcdPR8HB85X9apdeblZHPbTIPArzb6W1PNHOn+t2s2ngd0tjWEU+TMS/FajBG8Qh+Zdg8qXjMzF/yGsZhE2B/5znhAWcRPWXmeybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m/wawiMS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZPvO9vkQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m/wawiMS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZPvO9vkQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0041211EB;
	Thu,  8 May 2025 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746712214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L98kzA/S1gVcG3tKfXm5VAvJL8bkz+KMHUt7l8hT7bs=;
	b=m/wawiMS44QAeIgTxQxnbLU+XlmIPxOF/gXjsRIecdEjQ6/TgGBIfFghGqTaZc20e1iIja
	vMXKAq3ed+JmPkXPTWfb4tj3RdxalSSPyJ833Rorl4jz+mrvg/eyekVzWJGxc1IFMypYTg
	s8yr9vQledqGiOshJhCORlDOvNe2Ojg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746712213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L98kzA/S1gVcG3tKfXm5VAvJL8bkz+KMHUt7l8hT7bs=;
	b=ZPvO9vkQKc/JtV6FLq5R9mO+jqtkr4shYs8hPo8q2TgKmoWoOP2752ej0yB/YNfEywjf4x
	/5/7h7SsmXlMfBxEbA7gxj86BaDX0rdBY8s8N17t1Y8Y+Gboftyptz6pB/O4xQb7VVcpKU
	oD0dehu71fptGfDmdH+T381F37Rf3g8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A619413712;
	Thu,  8 May 2025 13:50:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bBsBJ5W2HGgVPwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 08 May 2025 13:50:13 +0000
Message-ID: <f7b1688f2a17165ff5bfee7cc892c0067af7a9ca.camel@suse.com>
Subject: Re: [PATCH 1/2] dm: Allow .prepare_ioctl to handle ioctls directly
From: Martin Wilck <mwilck@suse.com>
To: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev
Cc: hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org, 
	bmarzins@redhat.com, linux-kernel@vger.kernel.org, Hannes Reinecke
 <hare@suse.com>
Date: Thu, 08 May 2025 15:50:13 +0200
In-Reply-To: <20250429165018.112999-2-kwolf@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
		 <20250429165018.112999-2-kwolf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]

On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
> This adds a 'bool *forward' parameter to .prepare_ioctl, which allows
> device mapper targets to accept ioctls to themselves instead of the
> underlying device. If the target already fully handled the ioctl, it
> sets *forward to false and device mapper won't forward it to the
> underlying device any more.
>=20
> In order for targets to actually know what the ioctl is about and how
> to
> handle it, pass also cmd and arg.
>=20
> As long as targets restrict themselves to interpreting ioctls of type
> DM_IOCTL, this is a backwards compatible change because previously,
> any
> such ioctl would have been passed down through all device mapper
> layers
> until it reached a device that can't understand the ioctl and would
> return an error.
>=20
> Signed-off-by: Kevin Wolf <kwolf@redhat.com>
> ---
> =C2=A0include/linux/device-mapper.h |=C2=A0 9 ++++++++-
> =C2=A0drivers/md/dm-dust.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 4 +++-
> =C2=A0drivers/md/dm-ebs-target.c=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/md/dm-flakey.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 +++-
> =C2=A0drivers/md/dm-linear.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 +++-
> =C2=A0drivers/md/dm-log-writes.c=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++-
> =C2=A0drivers/md/dm-mpath.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 4 +++-
> =C2=A0drivers/md/dm-switch.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 +++-
> =C2=A0drivers/md/dm-verity-target.c |=C2=A0 4 +++-
> =C2=A0drivers/md/dm-zoned-target.c=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/md/dm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 17 +++++++++++------
> =C2=A011 files changed, 44 insertions(+), 16 deletions(-)
>=20
> diff --git a/include/linux/device-mapper.h b/include/linux/device-
> mapper.h
> index bcc6d7b69470..cb95951547ab 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -93,7 +93,14 @@ typedef void (*dm_status_fn) (struct dm_target
> *ti, status_type_t status_type,
> =C2=A0typedef int (*dm_message_fn) (struct dm_target *ti, unsigned int
> argc, char **argv,
> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char *result, unsigned int maxlen);
> =C2=A0
> -typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct
> block_device **bdev);
> +/*
> + * Called with *forward =3D=3D true. If it remains true, the ioctl
> should be
> + * forwarded to bdev. If it is reset to false, the target already
> fully handled
> + * the ioctl and the return value is the return value for the whole
> ioctl.
> + */
> +typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct
> block_device **bdev,
> + =C2=A0=C2=A0=C2=A0 unsigned int cmd, unsigned long arg,
> + =C2=A0=C2=A0=C2=A0 bool *forward);
> =C2=A0
> =C2=A0#ifdef CONFIG_BLK_DEV_ZONED
> =C2=A0typedef int (*dm_report_zones_fn) (struct dm_target *ti,
> diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> index 1a33820c9f46..e75310232bbf 100644
> --- a/drivers/md/dm-dust.c
> +++ b/drivers/md/dm-dust.c
> @@ -534,7 +534,9 @@ static void dust_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 }
> =C2=A0}
> =C2=A0
> -static int dust_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int dust_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int cmd, unsigned long arg,
> + =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool *forward)
> =C2=A0{
> =C2=A0 struct dust_device *dd =3D ti->private;
> =C2=A0 struct dm_dev *dev =3D dd->dev;
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index b19b0142a690..6abb31ca9662 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -415,7 +415,8 @@ static void ebs_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 }
> =C2=A0}
> =C2=A0
> -static int ebs_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int ebs_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int cmd, unsigned long arg, bool *for=
ward)
> =C2=A0{
> =C2=A0 struct ebs_c *ec =3D ti->private;
> =C2=A0 struct dm_dev *dev =3D ec->dev;
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index b690905ab89f..0fceb08f4622 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -638,7 +638,9 @@ static void flakey_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 }
> =C2=A0}
> =C2=A0
> -static int flakey_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int flakey_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + unsigned int cmd, unsigned long arg,
> + bool *forward)
> =C2=A0{
> =C2=A0 struct flakey_c *fc =3D ti->private;
> =C2=A0
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 66318aba4bdb..15538ec58f8e 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -119,7 +119,9 @@ static void linear_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 }
> =C2=A0}
> =C2=A0
> -static int linear_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int linear_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + unsigned int cmd, unsigned long arg,
> + bool *forward)
> =C2=A0{
> =C2=A0 struct linear_c *lc =3D ti->private;
> =C2=A0 struct dm_dev *dev =3D lc->dev;
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index 8d7df8303d0a..d484e8e1d48a 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -818,7 +818,9 @@ static void log_writes_status(struct dm_target
> *ti, status_type_t type,
> =C2=A0}
> =C2=A0
> =C2=A0static int log_writes_prepare_ioctl(struct dm_target *ti,
> - =C2=A0=C2=A0=C2=A0 struct block_device **bdev)
> + =C2=A0=C2=A0=C2=A0 struct block_device **bdev,
> + =C2=A0=C2=A0=C2=A0 unsigned int cmd, unsigned long arg,
> + =C2=A0=C2=A0=C2=A0 bool *forward)
> =C2=A0{
> =C2=A0 struct log_writes_c *lc =3D ti->private;
> =C2=A0 struct dm_dev *dev =3D lc->dev;
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 6c98f4ae5ea9..909ed6890ba5 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2022,7 +2022,9 @@ static int multipath_message(struct dm_target
> *ti, unsigned int argc, char **arg
> =C2=A0}
> =C2=A0
> =C2=A0static int multipath_prepare_ioctl(struct dm_target *ti,
> - =C2=A0=C2=A0 struct block_device **bdev)
> + =C2=A0=C2=A0 struct block_device **bdev,
> + =C2=A0=C2=A0 unsigned int cmd, unsigned long arg,
> + =C2=A0=C2=A0 bool *forward)
> =C2=A0{
> =C2=A0 struct multipath *m =3D ti->private;
> =C2=A0 struct pgpath *pgpath;
> diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> index dfd9fb52a6f3..bb1a70b5a215 100644
> --- a/drivers/md/dm-switch.c
> +++ b/drivers/md/dm-switch.c
> @@ -517,7 +517,9 @@ static void switch_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 *
> =C2=A0 * Passthrough all ioctls to the path for sector 0
> =C2=A0 */
> -static int switch_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int switch_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + unsigned int cmd, unsigned long arg,
> + bool *forward)
> =C2=A0{
> =C2=A0 struct switch_ctx *sctx =3D ti->private;
> =C2=A0 unsigned int path_nr;
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-
> target.c
> index 4de2c226ac9d..34a9f9fbd0d1 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -994,7 +994,9 @@ static void verity_status(struct dm_target *ti,
> status_type_t type,
> =C2=A0 }
> =C2=A0}
> =C2=A0
> -static int verity_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int verity_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + unsigned int cmd, unsigned long arg,
> + bool *forward)
> =C2=A0{
> =C2=A0 struct dm_verity *v =3D ti->private;
> =C2=A0
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-
> target.c
> index 6141fc25d842..5da3db06da10 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1015,7 +1015,8 @@ static void dmz_io_hints(struct dm_target *ti,
> struct queue_limits *limits)
> =C2=A0/*
> =C2=A0 * Pass on ioctl to the backend device.
> =C2=A0 */
> -static int dmz_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev)
> +static int dmz_prepare_ioctl(struct dm_target *ti, struct
> block_device **bdev,
> + =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int cmd, unsigned long arg, bool *for=
ward)
> =C2=A0{
> =C2=A0 struct dmz_target *dmz =3D ti->private;
> =C2=A0 struct dmz_dev *dev =3D &dmz->dev[0];
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ccccc098b30e..1726f0f828cc 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -411,7 +411,8 @@ static int dm_blk_getgeo(struct block_device
> *bdev, struct hd_geometry *geo)
> =C2=A0}
> =C2=A0
> =C2=A0static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx=
,
> - =C2=A0=C2=A0=C2=A0 struct block_device **bdev)
> + =C2=A0=C2=A0=C2=A0 struct block_device **bdev, unsigned int cmd,
> + =C2=A0=C2=A0=C2=A0 unsigned long arg, bool *forward)
> =C2=A0{
> =C2=A0 struct dm_target *ti;
> =C2=A0 struct dm_table *map;
> @@ -434,8 +435,8 @@ static int dm_prepare_ioctl(struct mapped_device
> *md, int *srcu_idx,
> =C2=A0 if (dm_suspended_md(md))
> =C2=A0 return -EAGAIN;
> =C2=A0
> - r =3D ti->type->prepare_ioctl(ti, bdev);
> - if (r =3D=3D -ENOTCONN && !fatal_signal_pending(current)) {
> + r =3D ti->type->prepare_ioctl(ti, bdev, cmd, arg, forward);
> + if (r =3D=3D -ENOTCONN && *forward && !fatal_signal_pending(current)) {
> =C2=A0 dm_put_live_table(md, *srcu_idx);
> =C2=A0 fsleep(10000);
> =C2=A0 goto retry;
> @@ -454,9 +455,10 @@ static int dm_blk_ioctl(struct block_device
> *bdev, blk_mode_t mode,
> =C2=A0{
> =C2=A0 struct mapped_device *md =3D bdev->bd_disk->private_data;
> =C2=A0 int r, srcu_idx;
> + bool forward =3D true;
> =C2=A0
> - r =3D dm_prepare_ioctl(md, &srcu_idx, &bdev);
> - if (r < 0)
> + r =3D dm_prepare_ioctl(md, &srcu_idx, &bdev, cmd, arg, &forward);
> + if (!forward || r < 0)
> =C2=A0 goto out;
> =C2=A0
> =C2=A0 if (r > 0) {
> @@ -3630,10 +3632,13 @@ static int dm_pr_clear(struct block_device
> *bdev, u64 key)
> =C2=A0 struct mapped_device *md =3D bdev->bd_disk->private_data;
> =C2=A0 const struct pr_ops *ops;
> =C2=A0 int r, srcu_idx;
> + bool forward =3D true;
> =C2=A0
> - r =3D dm_prepare_ioctl(md, &srcu_idx, &bdev);
> + /* Not a real ioctl, but targets must not interpret non-DM ioctls
> */
> + r =3D dm_prepare_ioctl(md, &srcu_idx, &bdev, 0, 0, &forward);
> =C2=A0 if (r < 0)
> =C2=A0 goto out;
> + WARN_ON_ONCE(!forward);
> =C2=A0
> =C2=A0 ops =3D bdev->bd_disk->fops->pr_ops;
> =C2=A0 if (ops && ops->pr_clear)
