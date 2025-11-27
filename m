Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21B32C312
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 11:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764242600; cv=none; b=Kdb92PPMY7x5igh12DEK9nldsrA0W7seq2Fz/c6TjG/0cXBM3QDInt6qYsnwCC/9+/POJGApBhvsXyU5GRvnKI9q9C7uEIkQn080ITRlu8diSVdedzYRaEgX226lYIF+9bDbQRVf4Yy8RXFOnIZ6sx44Vtn/OvKUrBT5yvn/hTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764242600; c=relaxed/simple;
	bh=Hw2A1TzBQHhZa8V8nnkXONPgxIy9yd1P4qKg0WCVSpo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a+l9KI3uEeJT/vuSKZcFZx4D2NKeCgTwGK8iK5vt8HukvAN8tv4dPgoDcO3EnahBVUTIW9oXDxokTyyM6K4Z+zf/VP8/fEhxyQhnReg29OFOlZevb5TmLiMzkYUGwZPS0J5xBlYR7wsmmDGAqd+sQNR1ikQKtQ3EWQPFkDoGEKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MBZu2LUs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MBZu2LUs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MBZu2LUs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MBZu2LUs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6AF4533693;
	Thu, 27 Nov 2025 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764242595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1PcRiqNQhV6fcuLQkSQ1HcNmttIQZFQl99FXdfIjlI=;
	b=MBZu2LUsUzJak+8+xWA/k5DfGN2vaKy9v9KfhZif9RqGuCaq4LP+2q7Mow3yhv9juaBkR5
	af5fuvyINJ7x7hy5qPpFmXIiO0LhD+kYPpIXR2t2cH/h9op9RoUmgnn2ZthkCCaVcPmAxA
	B/gK+YE+FuEN0wAnT9lmXfVRBNxZOFo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764242595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1PcRiqNQhV6fcuLQkSQ1HcNmttIQZFQl99FXdfIjlI=;
	b=MBZu2LUsUzJak+8+xWA/k5DfGN2vaKy9v9KfhZif9RqGuCaq4LP+2q7Mow3yhv9juaBkR5
	af5fuvyINJ7x7hy5qPpFmXIiO0LhD+kYPpIXR2t2cH/h9op9RoUmgnn2ZthkCCaVcPmAxA
	B/gK+YE+FuEN0wAnT9lmXfVRBNxZOFo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 473623EA63;
	Thu, 27 Nov 2025 11:23:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 48ZDEKM0KGmWVAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 27 Nov 2025 11:23:15 +0000
Message-ID: <4a41285cac6cc55dc39f03923471c025e91f6dd6.camel@suse.com>
Subject: Re: [PATCH v2] Add purge capability to multipath-tools
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Krishna Kant <krishna.kant@purestorage.com>
Date: Thu, 27 Nov 2025 12:23:14 +0100
In-Reply-To: <20251126200004.42156-1-brian@purestorage.com>
References: <20251126200004.42156-1-brian@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,bootlin.com:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi Brian,

first of all, thanks for looking into this.=C2=A0

Please add me to CC on future patches. I'm not always up to date with
the mailing list.

On Wed, 2025-11-26 at 12:00 -0800, Brian Bunker wrote:
> In the Linux kernel when volumes are disconnected, they are left
> behind
> to be re-enabled when the connection comes back. There are many cases
> where this behavior is not desirable.
>=20
> The goal is to have paths appear when volumes are connected. This is
> handled by target initiated rescans and posting of unit attentions.
> Secondarily when volumes are disconnected at the target, paths should
> be removed.
>=20
> This was discussed here in a kernel patch:
> https://marc.info/?l=3Dlinux-scsi&m=3D164426722617834&w=3D2
>=20
> It was suggested there that userspace would be more advantageous in
> handling the device removal.
>=20
> An option was added to multipath-tools to purge devices that are
> disconnected at the target. A purge thread was implemented to handle
> the device removal when the path returns sense data (0x5/0x25/0x0)
> from
> the path checker. The option, purge_disconnected, is by default off
> but
> can be turned on by setting it to true.
>=20
> When enabled multipathd will log:
> Nov 11 18:43:24 init539-33 multipathd[52046]: sdc: mark
> (disconnected)
> path for purge
> ...
> Nov 13 09:54:17 init539-33 multipathd[69140]: purged 8 paths, 0
> failed,
> 0 pending in 0.125017 secs
>=20

No v1->v2 changelog?

> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>

I know that this has been suggested in previous discussions. However I
am not sure if multipathd is really the right actor here.=C2=A0While
multipathd already does a few things with path devices, like setting
timeouts or max_sectors_kb, actually removing them is another thing
which extends multipathd's realm quite a bit. It must be disabled by
default for all devices; users would need to enable it explicitly so
that they know what to expect.

I wonder if a separate, independent daemon which takes care of this
funtionality might be the best solution.=C2=A0Is this functionality not als=
o
desirable in non-multipath setups? multipathd already has a lot of
complexity, and it doesn't need to be directly involved, as it would
just react on "remove" uevents, as usual.=20

I get it that you leverage multipathd's existing path checker for
detecting the DISCONNECTED state. But I'd regard this mainly as an
optimization, I suppose we can find other ways to avoid extra TURs.

> ---
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 2 +
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 2 +
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0 |=C2=A0 10 ++
> =C2=A0libmultipath/config.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 2 +
> =C2=A0libmultipath/config.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 3 +
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 1 +
> =C2=A0libmultipath/defaults.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 1 +
> =C2=A0libmultipath/dict.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 14 ++
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 3 +-
> =C2=A0libmultipath/io_err_stat.c=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 16 +++
> =C2=A0libmultipath/propsel.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 10 ++
> =C2=A0multipath/multipath.conf.5.in |=C2=A0 21 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 264
> +++++++++++++++++++++++++++++++++-
> =C2=A016 files changed, 346 insertions(+), 7 deletions(-)
>=20
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index e2eda58d..bb6ad1ee 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -43,6 +43,7 @@ static const char
> *checker_state_names[PATH_MAX_STATE] =3D {
> =C2=A0	[PATH_TIMEOUT] =3D "timeout",
> =C2=A0	[PATH_REMOVED] =3D "removed",
> =C2=A0	[PATH_DELAYED] =3D "delayed",
> +	[PATH_DISCONNECTED] =3D "disconnected",
> =C2=A0};
> =C2=A0
> =C2=A0static LIST_HEAD(checkers);
> @@ -363,6 +364,7 @@ static const char
> *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] =3D {
> =C2=A0	[CHECKER_MSGID_DOWN] =3D " reports path is down",
> =C2=A0	[CHECKER_MSGID_GHOST] =3D " reports path is ghost",
> =C2=A0	[CHECKER_MSGID_UNSUPPORTED] =3D " doesn't support this
> device",
> +	[CHECKER_MSGID_DISCONNECTED] =3D " no access to this device",
> =C2=A0};
> =C2=A0
> =C2=A0const char *checker_message(const struct checker *c)
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index da91f499..903c3ebe 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -78,6 +78,7 @@ enum path_check_state {
> =C2=A0	PATH_TIMEOUT,
> =C2=A0	PATH_REMOVED,
> =C2=A0	PATH_DELAYED,
> +	PATH_DISCONNECTED,
> =C2=A0	PATH_MAX_STATE
> =C2=A0};
> =C2=A0
> @@ -113,6 +114,7 @@ enum {
> =C2=A0	CHECKER_MSGID_DOWN,
> =C2=A0	CHECKER_MSGID_GHOST,
> =C2=A0	CHECKER_MSGID_UNSUPPORTED,
> +	CHECKER_MSGID_DISCONNECTED,
> =C2=A0	CHECKER_GENERIC_MSGTABLE_SIZE,
> =C2=A0	CHECKER_FIRST_MSGID =3D 100,	/* lowest msgid for checkers
> */
> =C2=A0	CHECKER_MSGTABLE_SIZE =3D 100,	/* max msg table size for
> checkers */
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index 0010acf8..1bb9a992 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -199,6 +199,16 @@ retry:
> =C2=A0				return PATH_PENDING;
> =C2=A0			}
> =C2=A0		}
> +		else if (key =3D=3D 0x5) {
> +			/* Illegal request */
> +			if (asc =3D=3D 0x25 && ascq =3D=3D 0x00) {
> +				/*
> +				 * LOGICAL UNIT NOT SUPPORTED
> +				 */
> +				*msgid =3D CHECKER_MSGID_DISCONNECTED;
> +				return PATH_DISCONNECTED;
> +			}
> +		}
> =C2=A0		*msgid =3D CHECKER_MSGID_DOWN;
> =C2=A0		return PATH_DOWN;
> =C2=A0	}
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 8b424d18..2c66a788 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -470,6 +470,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> src)
> =C2=A0	merge_num(marginal_path_err_rate_threshold);
> =C2=A0	merge_num(marginal_path_err_recheck_gap_time);
> =C2=A0	merge_num(marginal_path_double_failed_time);
> +	merge_num(purge_disconnected);
> =C2=A0
> =C2=A0	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst-
> >product);
> =C2=A0	reconcile_features_with_options(id, &dst->features,
> @@ -517,6 +518,7 @@ merge_mpe(struct mpentry *dst, struct mpentry
> *src)
> =C2=A0	merge_num(skip_kpartx);
> =C2=A0	merge_num(max_sectors_kb);
> =C2=A0	merge_num(ghost_delay);
> +	merge_num(purge_disconnected);
> =C2=A0	merge_num(uid);
> =C2=A0	merge_num(gid);
> =C2=A0	merge_num(mode);
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 5b4ebf8c..618fa572 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -88,6 +88,7 @@ struct hwentry {
> =C2=A0	int marginal_path_err_rate_threshold;
> =C2=A0	int marginal_path_err_recheck_gap_time;
> =C2=A0	int marginal_path_double_failed_time;
> +	int purge_disconnected;
> =C2=A0	int skip_kpartx;
> =C2=A0	int max_sectors_kb;
> =C2=A0	int ghost_delay;
> @@ -130,6 +131,7 @@ struct mpentry {
> =C2=A0	int marginal_path_err_rate_threshold;
> =C2=A0	int marginal_path_err_recheck_gap_time;
> =C2=A0	int marginal_path_double_failed_time;
> +	int purge_disconnected;
> =C2=A0	int skip_kpartx;
> =C2=A0	int max_sectors_kb;
> =C2=A0	int ghost_delay;
> @@ -188,6 +190,7 @@ struct config {
> =C2=A0	int marginal_path_err_rate_threshold;
> =C2=A0	int marginal_path_err_recheck_gap_time;
> =C2=A0	int marginal_path_double_failed_time;
> +	int purge_disconnected;
> =C2=A0	int uxsock_timeout;
> =C2=A0	int strict_timing;
> =C2=A0	int retrigger_tries;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index baa13573..e4431d2f 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -355,6 +355,7 @@ int setup_map(struct multipath *mpp, char
> **params, struct vectors *vecs)
> =C2=A0	select_max_sectors_kb(conf, mpp);
> =C2=A0	select_ghost_delay(conf, mpp);
> =C2=A0	select_flush_on_last_del(conf, mpp);
> +	select_purge_disconnected(conf, mpp);
> =C2=A0
> =C2=A0	sysfs_set_scsi_tmo(conf, mpp);
> =C2=A0	marginal_pathgroups =3D conf->marginal_pathgroups;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 134b690a..d80dd7d4 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -58,6 +58,7 @@
> =C2=A0#define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
> =C2=A0#define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
> =C2=A0#define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
> +#define DEFAULT_PURGE_DISCONNECTED PURGE_DISCONNECTED_OFF
> =C2=A0/* Enable no foreign libraries by default */
> =C2=A0#define DEFAULT_ENABLE_FOREIGN "NONE"
> =C2=A0
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index a06a6138..504b28b5 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -941,6 +941,16 @@ declare_hw_snprint(skip_kpartx,
> print_yes_no_undef)
> =C2=A0declare_mp_handler(skip_kpartx, set_yes_no_undef)
> =C2=A0declare_mp_snprint(skip_kpartx, print_yes_no_undef)
> =C2=A0
> +declare_def_handler(purge_disconnected, set_yes_no_undef)
> +declare_def_snprint_defint(purge_disconnected, print_yes_no_undef,
> +	DEFAULT_PURGE_DISCONNECTED)
> +declare_ovr_handler(purge_disconnected, set_yes_no_undef)
> +declare_ovr_snprint(purge_disconnected, print_yes_no_undef)
> +declare_hw_handler(purge_disconnected, set_yes_no_undef)
> +declare_hw_snprint(purge_disconnected, print_yes_no_undef)
> +declare_mp_handler(purge_disconnected, set_yes_no_undef)
> +declare_mp_snprint(purge_disconnected, print_yes_no_undef)
> +
> =C2=A0declare_def_range_handler(remove_retries, 0, INT_MAX)
> =C2=A0declare_def_snprint(remove_retries, print_int)
> =C2=A0
> @@ -2227,6 +2237,7 @@ init_keywords(vector keywords)
> =C2=A0	install_keyword("retrigger_delay",
> &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
> =C2=A0	install_keyword("missing_uev_wait_timeout",
> &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
> =C2=A0	install_keyword("skip_kpartx", &def_skip_kpartx_handler,
> &snprint_def_skip_kpartx);
> +	install_keyword("purge_disconnected",
> &def_purge_disconnected_handler, &snprint_def_purge_disconnected);
> =C2=A0	install_keyword("disable_changed_wwids",
> &deprecated_disable_changed_wwids_handler, &snprint_deprecated);
> =C2=A0	install_keyword("remove_retries",
> &def_remove_retries_handler, &snprint_def_remove_retries);
> =C2=A0	install_keyword("max_sectors_kb",
> &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
> @@ -2310,6 +2321,7 @@ init_keywords(vector keywords)
> =C2=A0	install_keyword("marginal_path_err_recheck_gap_time",
> &hw_marginal_path_err_recheck_gap_time_handler,
> &snprint_hw_marginal_path_err_recheck_gap_time);
> =C2=A0	install_keyword("marginal_path_double_failed_time",
> &hw_marginal_path_double_failed_time_handler,
> &snprint_hw_marginal_path_double_failed_time);
> =C2=A0	install_keyword("skip_kpartx", &hw_skip_kpartx_handler,
> &snprint_hw_skip_kpartx);
> +	install_keyword("purge_disconnected",
> &hw_purge_disconnected_handler, &snprint_hw_purge_disconnected);
> =C2=A0	install_keyword("max_sectors_kb",
> &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
> =C2=A0	install_keyword("ghost_delay", &hw_ghost_delay_handler,
> &snprint_hw_ghost_delay);
> =C2=A0	install_keyword("all_tg_pt", &hw_all_tg_pt_handler,
> &snprint_hw_all_tg_pt);
> @@ -2355,6 +2367,7 @@ init_keywords(vector keywords)
> =C2=A0	install_keyword("marginal_path_double_failed_time",
> &ovr_marginal_path_double_failed_time_handler,
> &snprint_ovr_marginal_path_double_failed_time);
> =C2=A0
> =C2=A0	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler,
> &snprint_ovr_skip_kpartx);
> +	install_keyword("purge_disconnected",
> &ovr_purge_disconnected_handler, &snprint_ovr_purge_disconnected);
> =C2=A0	install_keyword("max_sectors_kb",
> &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
> =C2=A0	install_keyword("ghost_delay", &ovr_ghost_delay_handler,
> &snprint_ovr_ghost_delay);
> =C2=A0	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler,
> &snprint_ovr_all_tg_pt);
> @@ -2400,6 +2413,7 @@ init_keywords(vector keywords)
> =C2=A0	install_keyword("marginal_path_err_recheck_gap_time",
> &mp_marginal_path_err_recheck_gap_time_handler,
> &snprint_mp_marginal_path_err_recheck_gap_time);
> =C2=A0	install_keyword("marginal_path_double_failed_time",
> &mp_marginal_path_double_failed_time_handler,
> &snprint_mp_marginal_path_double_failed_time);
> =C2=A0	install_keyword("skip_kpartx", &mp_skip_kpartx_handler,
> &snprint_mp_skip_kpartx);
> +	install_keyword("purge_disconnected",
> &mp_purge_disconnected_handler, &snprint_mp_purge_disconnected);
> =C2=A0	install_keyword("max_sectors_kb",
> &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
> =C2=A0	install_keyword("ghost_delay", &mp_ghost_delay_handler,
> &snprint_mp_ghost_delay);
> =C2=A0	install_sublevel_end();
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 31db8758..46274f3f 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -2482,7 +2482,8 @@ int pathinfo(struct path *pp, struct config
> *conf, int mask)
> =C2=A0			=C2=A0=C2=A0=C2=A0 pp->state =3D=3D PATH_UNCHECKED ||
> =C2=A0			=C2=A0=C2=A0=C2=A0 pp->state =3D=3D PATH_WILD)
> =C2=A0				pp->chkrstate =3D pp->state =3D
> newstate;
> -			if (pp->state =3D=3D PATH_TIMEOUT)
> +			if (pp->state =3D=3D PATH_TIMEOUT ||
> +			=C2=A0=C2=A0=C2=A0 pp->state =3D=3D PATH_DISCONNECTED)
> =C2=A0				pp->state =3D PATH_DOWN;
> =C2=A0			if (pp->state =3D=3D PATH_UP && !pp->size) {
> =C2=A0				condlog(3, "%s: device size is 0, "
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 64054c18..acb087b7 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -397,6 +397,7 @@ static void account_async_io_state(struct
> io_err_stat_path *pp, int rc)
> =C2=A0	switch (rc) {
> =C2=A0	case PATH_DOWN:
> =C2=A0	case PATH_TIMEOUT:
> +	case PATH_DISCONNECTED:
> =C2=A0		pp->io_err_nr++;
> =C2=A0		break;
> =C2=A0	case PATH_UNCHECKED:
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 0d44a5a9..8b09b174 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -541,6 +541,8 @@ snprint_chk_state (struct strbuf *buff, const
> struct path * pp)
> =C2=A0		return append_strbuf_str(buff, "i/o timeout");
> =C2=A0	case PATH_DELAYED:
> =C2=A0		return append_strbuf_str(buff, "delayed");
> +	case PATH_DISCONNECTED:
> +		return append_strbuf_str(buff, "disconnected");
> =C2=A0	default:
> =C2=A0		return append_strbuf_str(buff, "undef");
> =C2=A0	}
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 4c0fbcf3..9a17f1ed 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -1371,6 +1371,22 @@ out:
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +int select_purge_disconnected (struct config *conf, struct multipath
> * mp)
> +{
> +	const char *origin;
> +
> +	mp_set_mpe(purge_disconnected);
> +	mp_set_ovr(purge_disconnected);
> +	mp_set_hwe(purge_disconnected);
> +	mp_set_conf(purge_disconnected);
> +	mp_set_default(purge_disconnected,
> DEFAULT_PURGE_DISCONNECTED);
> +out:
> +	condlog(3, "%s: purge_disconnected =3D %s %s", mp->alias,
> +		(mp->purge_disconnected =3D=3D PURGE_DISCONNECTED_ON)?
> "yes" : "no",
> +		origin);
> +	return 0;
> +}
> +
> =C2=A0int select_max_sectors_kb(struct config *conf, struct multipath *
> mp)
> =C2=A0{
> =C2=A0	const char *origin;
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index 55930050..c6c937c3 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -39,6 +39,7 @@ int select_marginal_path_err_rate_threshold(struct
> config *conf, struct multipat
> =C2=A0int select_marginal_path_err_recheck_gap_time(struct config *conf,
> struct multipath *mp);
> =C2=A0int select_marginal_path_double_failed_time(struct config *conf,
> struct multipath *mp);
> =C2=A0int select_ghost_delay(struct config *conf, struct multipath * mp);
> +int select_purge_disconnected (struct config *conf, struct multipath
> * mp);
> =C2=A0void reconcile_features_with_options(const char *id, char
> **features,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 int* no_path_retry,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 int *retain_hwhandler);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 9247e74f..81ac6be5 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -186,6 +186,12 @@ enum auto_resize_state {
> =C2=A0	AUTO_RESIZE_GROW_SHRINK,
> =C2=A0};
> =C2=A0
> +enum purge_disconnected_states {
> +	PURGE_DISCONNECTED_UNDEF =3D YNU_UNDEF,
> +	PURGE_DISCONNECTED_OFF =3D YNU_NO,
> +	PURGE_DISCONNECTED_ON =3D YNU_YES,
> +};
> +
> =C2=A0#define PROTOCOL_UNSET -1
> =C2=A0
> =C2=A0enum scsi_protocol {
> @@ -382,6 +388,9 @@ struct path {
> =C2=A0	int dmstate;
> =C2=A0	int chkrstate;
> =C2=A0	int oldstate;
> +	bool purge_path;
> +	int purge_retries;=C2=A0 /* number of purge attempts for this
> path */
> +	unsigned int purge_cycle;=C2=A0 /* last purge cycle that checked
> this path */
> =C2=A0	int failcount;
> =C2=A0	int priority;
> =C2=A0	int pgindex;
> @@ -483,6 +492,7 @@ struct multipath {
> =C2=A0	int ghost_delay;
> =C2=A0	int ghost_delay_tick;
> =C2=A0	int queue_mode;
> +	int purge_disconnected;
> =C2=A0	unsigned int sync_tick;
> =C2=A0	int checker_count;
> =C2=A0	enum prio_update_type prio_update;
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 3c9ae097..1f806da8 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -1306,6 +1306,21 @@ The default is: \fBno\fR
> =C2=A0.
> =C2=A0.
> =C2=A0.TP
> +.B purge_disconnected
> +If set to
> +.I yes
> +, multipathd will automatically remove paths that are in the
> disconnected state
> +by writing to the SCSI device's sysfs delete attribute.=C2=A0

This is too technical for the man page. Just say that it will auto-
remove devices in certain states. You should explain "disconnected"
state, which is not a standard, well-defined term.

> This triggers kernel-level
> +device removal. Paths are retried multiple times before being
> forcibly cleaned up
> +if the kernel removal fails. This option is useful for cleaning up
> stale paths
> +from storage arrays that have been disconnected or removed.
> +.RS
> +.TP
> +The default is: \fBno\fR
> +.RE
> +.
> +.
> +.TP
> =C2=A0.B disable_changed_wwids
> =C2=A0(Deprecated) This option is not supported anymore, and will be
> ignored.
> =C2=A0.RE
> @@ -1602,6 +1617,8 @@ section:
> =C2=A0.TP
> =C2=A0.B skip_kpartx
> =C2=A0.TP
> +.B purge_disconnected
> +.TP
> =C2=A0.B max_sectors_kb
> =C2=A0.TP
> =C2=A0.B ghost_delay
> @@ -1797,6 +1814,8 @@ section:
> =C2=A0.TP
> =C2=A0.B skip_kpartx
> =C2=A0.TP
> +.B purge_disconnected
> +.TP
> =C2=A0.B max_sectors_kb
> =C2=A0.TP
> =C2=A0.B ghost_delay
> @@ -1881,6 +1900,8 @@ the values are taken from the \fIdevices\fR or
> \fIdefaults\fR sections:
> =C2=A0.TP
> =C2=A0.B skip_kpartx
> =C2=A0.TP
> +.B purge_disconnected
> +.TP
> =C2=A0.B max_sectors_kb
> =C2=A0.TP
> =C2=A0.B ghost_delay
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d11a8576..0e7ed9b5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -137,11 +137,14 @@ static enum force_reload_types
> reconfigure_pending =3D FORCE_RELOAD_NONE;
> =C2=A0pid_t daemon_pid;
> =C2=A0static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> =C2=A0static pthread_cond_t config_cond;
> -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> dmevent_thr,
> -	fpin_thr, fpin_consumer_thr;
> -static bool check_thr_started, uevent_thr_started,
> uxlsnr_thr_started,
> -	uevq_thr_started, dmevent_thr_started, fpin_thr_started,
> -	fpin_consumer_thr_started;
> +static pthread_mutex_t purge_mutex =3D PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t purge_cond =3D PTHREAD_COND_INITIALIZER;
> +int devices_to_purge =3D 0;
> +static pthread_t check_thr, purge_thr, uevent_thr, uxlsnr_thr,
> uevq_thr,
> +	dmevent_thr, fpin_thr, fpin_consumer_thr;
> +static bool check_thr_started, purge_thr_started,
> uevent_thr_started,
> +	uxlsnr_thr_started, uevq_thr_started, dmevent_thr_started,
> +	fpin_thr_started, fpin_consumer_thr_started;
> =C2=A0static int pid_fd =3D -1;
> =C2=A0
> =C2=A0static inline enum daemon_status get_running_state(bool
> *pending_reconfig)
> @@ -1089,6 +1092,34 @@ check_path_wwid_change(struct path *pp)
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> +/*
> + * Attempt to delete a path by writing to the SCSI device's sysfs
> delete attribute.
> + * This triggers kernel-level device removal. The actual cleanup of
> the path structure
> + * from pathvec happens later when a uevent arrives (handled by
> uev_remove_path).
> + *
> + * Returns:
> + *=C2=A0=C2=A0 true=C2=A0 - sysfs write succeeded, uevent expected
> + *=C2=A0=C2=A0 false - sysfs write failed or device not found
> + */
> +static bool
> +delete_path(struct path * pp)
> +{
> +	struct udev_device *ud =3D
> udev_device_get_parent_with_subsystem_devtype(pp->udev,
> +		"scsi", "scsi_device");
> +
> +	if (ud) {
> +		if (sysfs_attr_set_value(ud, "delete", "1",
> strlen("1")) < 0) {
> +			condlog(1, "failed to remove path %s from
> %s",
> +				pp->dev_t, pp->mpp->alias);
> +			return false;

sysfs_attr_set_value() to the "delete" sysfs attribute only returns an
error if the sysfs file doesn't exist, or if the device is already in
SDEV_DEL or SDEV_CANCEL state [1]. Both of which you should treat as
success, or am I missing something?

[1] https://elixir.bootlin.com/linux/v6.17.9/C/ident/sdev_store_delete

In the opposite case, scsi_remove_device() can block, and thus writing
to the "delete" attribute can block as well (I guess that's not very
likely for disconneted devices, but it is possible and we should be
prepared for it). I wonder if we should use a non-blocking access here,
and poll sysfs (or wait for "remove" uevents) to make sure the device
is actually removed.


> +		}
> +		condlog(2, "removed path %s from %s", pp->dev_t, pp-
> >mpp->alias);
> +		pp->purge_path =3D false;
> +		return true;
> +	}
> +	return false;
> +}
> +
> =C2=A0/*
> =C2=A0 * uev_add_path can call uev_update_path, and uev_update_path can
> call
> =C2=A0 * uev_add_path
> @@ -2031,6 +2062,10 @@ reinstate_path (struct path * pp)
> =C2=A0		condlog(0, "%s: reinstate failed", pp->dev_t);
> =C2=A0	else {
> =C2=A0		condlog(2, "%s: reinstated", pp->dev_t);
> +		if (pp->purge_path) {
> +			pp->purge_path =3D false;
> +			pp->purge_retries =3D 0;
> +		}
> =C2=A0		update_queue_mode_add_path(pp->mpp);
> =C2=A0	}
> =C2=A0}
> @@ -2474,6 +2509,20 @@ get_new_state(struct path *pp)
> =C2=A0	if (newstate =3D=3D PATH_REMOVED)
> =C2=A0		newstate =3D PATH_DOWN;
> =C2=A0
> +	/*
> +	 * For PATH_DISOCONNECTED mark the path as OK to purge if
> that is

typo

> +	 * enabled. Whether or not purge is enabled mark the path as
> down.
> +	 */
> +	if (newstate =3D=3D PATH_DISCONNECTED) {
> +		if (pp->mpp->purge_disconnected =3D=3D
> PURGE_DISCONNECTED_ON &&
> +		=C2=A0=C2=A0=C2=A0 !pp->purge_path) {
> +			condlog(2, "%s: mark (%s) path for purge",
> +				pp->dev,
> checker_state_name(newstate));
> +			pp->purge_path =3D true;
> +		}
> +		newstate =3D PATH_DOWN;
> +	}
> +
> =C2=A0	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED) {
> =C2=A0		condlog(2, "%s: unusable path (%s) - checker
> failed",
> =C2=A0			pp->dev, checker_state_name(newstate));
> @@ -3022,6 +3071,25 @@ update_paths(struct vectors *vecs, int
> *num_paths_p, time_t start_secs)
> =C2=A0	return CHECKER_FINISHED;
> =C2=A0}
> =C2=A0
> +/*
> + * Check if there are newly marked paths to purge.
> + * Only returns true for paths with purge_path=3Dtrue and
> purge_retries=3D0,
> + * which indicates they were just marked for purging and haven't
> been
> + * attempted yet. This prevents signaling the purge thread
> unnecessarily
> + * for paths that are already being retried.
> + */
> +static bool
> +has_paths_to_purge(struct vectors *vecs)
> +{
> +	int i;
> +	struct path *pp;
> +
> +	vector_foreach_slot(vecs->pathvec, pp, i)
> +		if (pp->purge_path && pp->purge_retries =3D=3D 0)
> +			return true;
> +	return false;
> +}
> +
> =C2=A0static void enable_pathgroups(struct multipath *mpp)
> =C2=A0{
> =C2=A0	struct pathgroup *pgp;
> @@ -3125,6 +3193,7 @@ checkerloop (void *ap)
> =C2=A0		int num_paths =3D 0, strict_timing;
> =C2=A0		unsigned int ticks =3D 0;
> =C2=A0		enum checker_state checker_state =3D CHECKER_STARTING;
> +		bool devs_to_purge =3D false;
> =C2=A0
> =C2=A0		if (set_config_state(DAEMON_RUNNING) !=3D
> DAEMON_RUNNING)
> =C2=A0			/* daemon shutdown */
> @@ -3168,8 +3237,10 @@ checkerloop (void *ap)
> =C2=A0			if (checker_state =3D=3D CHECKER_UPDATING_PATHS)
> =C2=A0				checker_state =3D update_paths(vecs,
> &num_paths,
> =C2=A0							=C2=A0=C2=A0=C2=A0=C2=A0
> start_time.tv_sec);
> -			if (checker_state =3D=3D CHECKER_FINISHED)
> +			if (checker_state =3D=3D CHECKER_FINISHED) {
> +				devs_to_purge =3D
> has_paths_to_purge(vecs);
> =C2=A0				checker_finished(vecs, ticks);

Why not move this logic into checker_finished()?
> +			}
> =C2=A0			lock_cleanup_pop(vecs->lock);
> =C2=A0		}
> =C2=A0
> @@ -3192,6 +3263,13 @@ checkerloop (void *ap)
> =C2=A0					(long)diff_time.tv_sec);
> =C2=A0		}
> =C2=A0
> +		if (devs_to_purge) {
> +			pthread_mutex_lock(&purge_mutex);
> +			devices_to_purge =3D 1;
> +			pthread_cond_signal(&purge_cond);
> +			pthread_mutex_unlock(&purge_mutex);
> +		}
> +

Why not move this logic into checker_finished()?

> =C2=A0		if (foreign_tick =3D=3D 0) {
> =C2=A0			conf =3D get_multipath_config();
> =C2=A0			foreign_tick =3D conf->max_checkint;
> @@ -3229,6 +3307,171 @@ checkerloop (void *ap)
> =C2=A0	return NULL;
> =C2=A0}
> =C2=A0
> +/*
> + * Purge thread: removes disconnected paths by writing to sysfs.
> + *
> + * This thread is signaled by the checker thread when paths marked
> with
> + * purge_path=3Dtrue are detected. It attempts to delete these paths
> by
> + * writing "1" to their SCSI device's sysfs "delete" attribute.
> + *
> + * The actual cleanup of path structures from pathvec happens
> asynchronously
> + * when the kernel sends a remove uevent (handled by
> uev_remove_path).
> + * If the uevent doesn't arrive or the sysfs write fails, paths will
> be
> + * retried on subsequent purge cycles with a timeout mechanism.
> + *
> + * To avoid holding vecs->lock for extended periods and starving
> other threads,
> + * this function processes one path at a time: lock -> handle one
> path -> unlock.
> + * Paths track which cycle they were checked in to avoid
> reprocessing.
> + */
> +#define PURGE_TIMEOUT_CYCLES 10=C2=A0 /* ~50 seconds at 5 second check
> intervals */
> +
> +static void
> +reset_purge_cycle_stats(unsigned int *purged, unsigned int *failed,
> +			unsigned int *pending, bool *found)
> +{
> +	*purged =3D 0;
> +	*failed =3D 0;
> +	*pending =3D 0;
> +	*found =3D false;
> +}
> +
> +static void *
> +purgeloop (void *ap)
> +{
> +	struct vectors *vecs;
> +	unsigned int i;
> +	struct path *pp;
> +	unsigned int current_cycle =3D 1;
> +	unsigned int devices_purged_total =3D 0;
> +	unsigned int devices_failed_total =3D 0;
> +	unsigned int devices_pending_total =3D 0;
> +	bool found_path_this_cycle =3D false;
> +	vecs =3D (struct vectors *)ap;
> +
> +	pthread_cleanup_push(rcu_unregister, NULL);
> +	rcu_register_thread();
> +	mlockall(MCL_CURRENT | MCL_FUTURE);
> +
> +	while (1) {
> +		bool path_handled =3D false;
> +
> +		/*
> +		 * Lock and search for one path that needs
> processing.
> +		 * We search from the beginning each time since the
> list
> +		 * may have changed while we didn't hold the lock.
> +		 */
> +		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +		lock(&vecs->lock);
> +		pthread_testcancel();

I'm not happy about yet another thread taking this lock and running
a loop over all paths inside the critical section, with possibly
blocking accesses to sysfs inside.

This is another reason why I'd prefer to handle this in a separate
program.

Maybe Ben's idea to handle it without a dedicated thread works, too, if
we strictly avoid blocking.

> +
> +		vector_foreach_slot (vecs->pathvec, pp, i) {
> +			if (!pp->purge_path || pp->purge_cycle =3D=3D
> current_cycle)
> +				continue;
> +
> +			pp->purge_cycle =3D current_cycle;
> +			path_handled =3D true;
> +
> +			/* Increment timeout counter for this purge
> attempt */
> +			pp->purge_retries++;
> +
> +			if (delete_path(pp)) {
> +				/* Success: sysfs write succeeded,
> uevent expected */
> +				devices_purged_total++;
> +				pp->purge_retries =3D 0;
> +				condlog(3, "%s: path purge
> successful", pp->dev);

As I said above, I'm not sure if you are using the correct success
criteria in delete_path().

> +			} else if (pp->purge_retries >=3D
> PURGE_TIMEOUT_CYCLES) {
> +				/*
> +				 * Timeout: path couldn't be deleted
> after multiple attempts.
> +				 * Force cleanup by calling
> ev_remove_path() to properly
> +				 * remove the path from its
> multipath device and handle
> +				 * all references correctly.
> +				 */
> +				condlog(1, "%s: purge timeout after
> %d attempts, forcing removal",
> +					pp->dev, pp->purge_retries);
> +				if (ev_remove_path(pp, vecs, 1) &
> REMOVE_PATH_SUCCESS)
> +					devices_failed_total++;

Why are you doing this? You have failed to delete the path, so it
probably still exists. Force-removing it in multipathd seems wrong to
me. We strive to have the same idea of the set of existing devices
between multipathd and the kernel.

Thanks,
Martin

> +				else {
> +					/*
> +					 * ev_remove_path failed to
> remove the path immediately.
> +					 * The path is now marked
> INIT_REMOVED and will be
> +					 * cleaned up when the map
> is reloaded or removed.
> +					 */
> +					condlog(1, "%s: failed to
> remove path, marked for later removal",
> +						pp->dev);
> +					devices_failed_total++;
> +				}
> +			} else {
> +				/* Will retry on next cycle */
> +				devices_pending_total++;
> +				condlog(4, "%s: path purge failed,
> will retry (attempt %d/%d)",
> +					pp->dev, pp->purge_retries,
> +					PURGE_TIMEOUT_CYCLES);
> +			}
> +			break;
> +		}
> +
> +		lock_cleanup_pop(vecs->lock);
> +
> +		/*
> +		 * If we didn't find any path to process, we've
> completed a cycle.
> +		 * Check if we should wait for more work or start a
> new cycle.
> +		 */
> +		if (path_handled)
> +			found_path_this_cycle =3D true;
> +		else {
> +			if (found_path_this_cycle) {
> +				/* Completed a cycle, log statistics
> */
> +				condlog(2, "purge cycle %u complete:
> %u purged, %u failed, %u pending",
> +					current_cycle,
> devices_purged_total,
> +					devices_failed_total,
> devices_pending_total);
> +
> +				/* Check if we need to retry pending
> paths */
> +				if (devices_pending_total > 0) {
> +					struct timespec wait_time;
> +					struct config *conf;
> +
> +					conf =3D
> get_multipath_config();
> +					wait_time.tv_sec =3D conf-
> >checkint;
> +					wait_time.tv_nsec =3D 0;
> +					put_multipath_config(conf);
> +
> +					condlog(3, "sleeping %ld
> seconds before next purge cycle",
> +						(long)wait_time.tv_s
> ec);
> +					nanosleep(&wait_time, NULL);
> +
> +					/* Start a new cycle for
> pending paths */
> +					current_cycle++;
> +					reset_purge_cycle_stats(&dev
> ices_purged_total,
> +								&dev
> ices_failed_total,
> +								&dev
> ices_pending_total,
> +								&fou
> nd_path_this_cycle);
> +					continue;
> +				}
> +			}
> +
> +			/* No paths to process, wait for signal */
> +			pthread_mutex_lock(&purge_mutex);
> +			while (!devices_to_purge) {
> +				condlog(3, "waiting on devices to
> purge");
> +				pthread_cond_wait(&purge_cond,
> &purge_mutex);
> +			}
> +			devices_to_purge =3D 0;
> +			pthread_mutex_unlock(&purge_mutex);
> +
> +			/* Start a new cycle */
> +			current_cycle++;
> +			reset_purge_cycle_stats(&devices_purged_tota
> l,
> +						&devices_failed_tota
> l,
> +						&devices_pending_tot
> al,
> +						&found_path_this_cyc
> le);
> +			condlog(3, "starting purge cycle %u",
> current_cycle);
> +		}
> +	}
> +
> +	pthread_cleanup_pop(1);
> +	return NULL;
> +}
> +
> =C2=A0static int
> =C2=A0configure (struct vectors * vecs, enum force_reload_types
> reload_type)
> =C2=A0{
> @@ -3669,6 +3912,8 @@ static void cleanup_threads(void)
> =C2=A0
> =C2=A0	if (check_thr_started)
> =C2=A0		pthread_cancel(check_thr);
> +	if (purge_thr_started)
> +		pthread_cancel(purge_thr);
> =C2=A0	if (uevent_thr_started)
> =C2=A0		pthread_cancel(uevent_thr);
> =C2=A0	if (uxlsnr_thr_started)
> @@ -3685,6 +3930,8 @@ static void cleanup_threads(void)
> =C2=A0
> =C2=A0	if (check_thr_started)
> =C2=A0		pthread_join(check_thr, NULL);
> +	if (purge_thr_started)
> +		pthread_join(purge_thr, NULL);
> =C2=A0	if (uevent_thr_started)
> =C2=A0		pthread_join(uevent_thr, NULL);
> =C2=A0	if (uxlsnr_thr_started)
> @@ -3937,6 +4184,11 @@ child (__attribute__((unused)) void *param)
> =C2=A0		goto failed;
> =C2=A0	} else
> =C2=A0		check_thr_started =3D true;
> +	if ((rc =3D pthread_create(&purge_thr, &misc_attr, purgeloop,
> vecs))) {
> +		condlog(0,"failed to create purge loop thread: %d",
> rc);
> +		goto failed;
> +	} else
> +		purge_thr_started =3D true;
> =C2=A0	if ((rc =3D pthread_create(&uevq_thr, &misc_attr, uevqloop,
> vecs))) {
> =C2=A0		condlog(0, "failed to create uevent dispatcher: %d",
> rc);
> =C2=A0		goto failed;
