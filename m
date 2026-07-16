Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22A92F7EEF
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187589; cv=none; b=P4KQS+U0fr+C6LJGFGLz4NDDNJBY4KsuQgeTVhZe1El16QRRliedggYbVQ83/KjCFtOj4ub1M1s/bIbnvATPPROtNP1MiM6aYg74Vkh0VgY8wtxwCZDT7q/0jqYDHkT5LasD9VPH7l7CDdorBrCkl8s7vf6dzg5iLzLKfgRNIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187589; c=relaxed/simple;
	bh=fboe85JuX1SIbIvF44ywR68b9ew0O67cgl+40VjZVBQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u/5qInPxngq6ioweCsykBcIHgHjT8T7D5D0J4M4o3FguOf6FC0RL5896Crkt+Yp3F4CLTHw41nv+MRW+22SkLGqj1mfbrvPT+olphPTNimPYfzrIDOjhfqT6rKoJp/YcHwSo3VpW12Np+N7DSJLKpduJRcC+7mNhi/9INN6p3z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j51NQPMt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j51NQPMt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j51NQPMt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j51NQPMt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D41476BEF;
	Thu, 16 Jul 2026 07:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784187583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAFOvnYm+iDtFxB8qRAFwvxgPhti+cB+X1Vj0bG9dp4=;
	b=j51NQPMtKWcWoIOrJiISqy5CxhfB+ofM9K12NcwTwzWVbDuJpME013FhdMUykUtMcltymw
	ttrCwM9gQK2j27zG9tBAYNlOry41Iy9Poe5cMDWs7ntn/ALa5crIKo91B0NyQIetX/QLhJ
	KOUYzVsm2RwLJ/uKLiIjo1qX13UVCow=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784187583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAFOvnYm+iDtFxB8qRAFwvxgPhti+cB+X1Vj0bG9dp4=;
	b=j51NQPMtKWcWoIOrJiISqy5CxhfB+ofM9K12NcwTwzWVbDuJpME013FhdMUykUtMcltymw
	ttrCwM9gQK2j27zG9tBAYNlOry41Iy9Poe5cMDWs7ntn/ALa5crIKo91B0NyQIetX/QLhJ
	KOUYzVsm2RwLJ/uKLiIjo1qX13UVCow=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12491779AD;
	Thu, 16 Jul 2026 07:39:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mq0uA7+KWGplJwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 16 Jul 2026 07:39:43 +0000
Message-ID: <0594c64fe12ae0ea0ecee5b032f50e6842b120ed.camel@suse.com>
Subject: Re: [PATCH v2] kpartx: fix crash and truncated device creation with
 long -p delimiter
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com
Cc: bmarzins@redhat.com, dm-devel@lists.linux.dev, kouwenqi@kylinos.cn
Date: Thu, 16 Jul 2026 09:39:42 +0200
In-Reply-To: <tencent_D3139F3D56868836E0EEE2BB029AB9EB4809@qq.com>
References: <f7fbd9be3b9552031f49caf6eb86a031154052c0.camel@suse.com>
	 <tencent_D3139F3D56868836E0EEE2BB029AB9EB4809@qq.com>
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
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[qq.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Level: 

On Thu, 2026-07-16 at 14:39 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> When the -p delimiter is long enough to make the formatted partition
> name exceed PARTNAME_SIZE (128 bytes), three issues occur:
>=20
> 1. format_partname() fails but snprintf has already written a
> truncated
> =C2=A0=C2=A0 name into the buffer. dm_find_part() returns 0 and the calle=
r
> =C2=A0=C2=A0 proceeds to dm_addmap() with the truncated name, creating a =
device
> =C2=A0=C2=A0 that was never intended.
>=20
> 2. dm_find_part() returns early without setting *part_uuid. The
> =C2=A0=C2=A0 uninitialized local variable part_uuid then gets passed to
> =C2=A0=C2=A0 check_uuid() -> strchr(), causing a SIGSEGV.
>=20
> 3. The callers cannot distinguish between "partition not found,
> create
> =C2=A0=C2=A0 new" and "name construction failed" since both return 0.
>=20
> Fix by:
> - Having dm_find_part() return -1 when format_partname() fails, so
> =C2=A0 that callers can test the return value directly (negative for
> error,
> =C2=A0 0 for not found, positive for found)
> - In the ADD/UPDATE loops (both main and container), checking the
> =C2=A0 return value: negative means name too long (skip with error
> message),
> =C2=A0 0 means not found (create), positive means found (reload)
> - In the DELETE loop, only proceeding with removal when
> dm_find_part()
> =C2=A0 returns positive (partition found), skipping when it returns zero
> =C2=A0 (not found) or negative (error)
> - Initializing part_uuid to NULL in all three partition loop bodies
> =C2=A0 (ADD/UPDATE main loop, container partition loop, DELETE loop) so
> =C2=A0 that the "if (part_uuid && uuid)" guard correctly skips the UUID
> =C2=A0 check when dm_find_part() returns early
>=20
> Reproduce steps:
>=20
> =C2=A0 # Create test image
> =C2=A0 dd if=3D/dev/zero of=3D/tmp/vhlg-test.img bs=3D1M count=3D10
> =C2=A0 parted /tmp/vhlg-test.img mklabel msdos
> =C2=A0 parted /tmp/vhlg-test.img mkpart primary ext4 1MiB 5MiB
>=20
> =C2=A0 # Reproduce
> =C2=A0 kpartx -a -p $(python3 -c "print('A'*200)") /tmp/vhlg-test.img
>=20
> =C2=A0 # Cleanup
> =C2=A0 kpartx -d /tmp/vhlg-test.img
> =C2=A0 rm -f /tmp/vhlg-test.img
>=20
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
> ---
> =C2=A0kpartx/devmapper.c |=C2=A0 2 +-
> =C2=A0kpartx/kpartx.c=C2=A0=C2=A0=C2=A0 | 52 ++++++++++++++++++++++++++++=
++++------------
> --
> =C2=A02 files changed, 37 insertions(+), 17 deletions(-)
>=20
> diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
> index 45dac585..c50d6368 100644
> --- a/kpartx/devmapper.c
> +++ b/kpartx/devmapper.c
> @@ -646,7 +646,7 @@ int dm_find_part(const char *parent, const char
> *delim, int part,
> =C2=A0	if (!format_partname(name, namesiz, parent, delim, part)) {
> =C2=A0		if (verbose)
> =C2=A0			fprintf(stderr, "partname too small\n");
> -		return 0;
> +		return -1;
> =C2=A0	}
> =C2=A0
> =C2=A0	r =3D dm_map_present(name, part_uuid);
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index cfd82128..72f0bb70 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -437,7 +437,7 @@ main(int argc, char **argv){
> =C2=A0		case UPDATE:
> =C2=A0			/* ADD and UPDATE share the same code that
> adds new partitions. */
> =C2=A0			for (j =3D 0, c =3D 0; j < n; j++) {
> -				char *part_uuid, *reason;
> +				char *part_uuid =3D NULL, *reason;
> =C2=A0
> =C2=A0				if (slices[j].size =3D=3D 0)
> =C2=A0					continue;
> @@ -454,10 +454,20 @@ main(int argc, char **argv){
> =C2=A0					exit(1);
> =C2=A0				}
> =C2=A0
> -				op =3D (dm_find_part(mapname, delim, j
> + 1, uuid,
> -						=C2=A0=C2=A0 partname,
> sizeof(partname),
> -						=C2=A0=C2=A0 &part_uuid,
> verbose) ?
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DM_DEVICE_RELOAD :
> DM_DEVICE_CREATE);
> +				int res =3D dm_find_part(mapname,
> delim, j + 1, uuid,
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 partname,
> sizeof(partname),
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &part_uuid,
> verbose);
> +				if (res < 0) {
> +					fprintf(stderr,
> +						"partition name too
> long for partition %d, skipping\n",
> +						j + 1);

Please move this message to dm_find_part() as well.

Thanks
Martin

> +					r++;
> +					continue;
> +				} else if (res =3D=3D 0) {
> +					op =3D DM_DEVICE_CREATE;
> +				} else {
> +					op =3D DM_DEVICE_RELOAD;
> +				}
> =C2=A0
> =C2=A0				if (part_uuid && uuid) {
> =C2=A0					if (check_uuid(uuid,
> part_uuid, &reason) !=3D 0) {
> @@ -500,7 +510,7 @@ main(int argc, char **argv){
> =C2=A0			d =3D c;
> =C2=A0			while (c) {
> =C2=A0				for (j =3D 0; j < n; j++) {
> -					char *part_uuid, *reason;
> +					char *part_uuid =3D NULL,
> *reason;
> =C2=A0					int k =3D slices[j].container
> - 1;
> =C2=A0
> =C2=A0					if (slices[j].size =3D=3D 0)
> @@ -526,11 +536,21 @@ main(int argc, char **argv){
> =C2=A0						exit(1);
> =C2=A0					}
> =C2=A0
> -					op =3D (dm_find_part(mapname,
> delim, j + 1, uuid,
> -							=C2=A0=C2=A0 partname,
> -							=C2=A0=C2=A0
> sizeof(partname),
> -							=C2=A0=C2=A0
> &part_uuid, verbose) ?
> -					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DM_DEVICE_RELOAD :
> DM_DEVICE_CREATE);
> +					int res =3D
> dm_find_part(mapname, delim, j + 1, uuid,
> +								part
> name,
> +								size
> of(partname),
> +								&par
> t_uuid, verbose);
> +					if (res < 0) {
> +						fprintf(stderr,
> +							"partition
> name too long for partition %d, skipping\n",
> +							j + 1);
> +						r++;
> +						continue;
> +					} else if (res =3D=3D 0) {
> +						op =3D
> DM_DEVICE_CREATE;
> +					} else {
> +						op =3D
> DM_DEVICE_RELOAD;
> +					}
> =C2=A0
> =C2=A0					if (part_uuid && uuid) {
> =C2=A0						if (check_uuid(uuid,
> part_uuid, &reason) !=3D 0) {
> @@ -570,11 +590,11 @@ main(int argc, char **argv){
> =C2=A0			}
> =C2=A0
> =C2=A0			for (j =3D MAXSLICES-1; j >=3D 0; j--) {
> -				char *part_uuid, *reason;
> -				if (slices[j].size ||
> -				=C2=A0=C2=A0=C2=A0 !dm_find_part(mapname, delim, j
> + 1, uuid,
> -						=C2=A0 partname,
> sizeof(partname),
> -						=C2=A0 &part_uuid,
> verbose))
> +				char *part_uuid =3D NULL, *reason;
> +				int res =3D dm_find_part(mapname,
> delim, j + 1, uuid,
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 partname,
> sizeof(partname),
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &part_uuid,
> verbose);
> +				if (slices[j].size || res <=3D 0)
> =C2=A0					continue;
> =C2=A0
> =C2=A0				if (part_uuid && uuid) {

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
