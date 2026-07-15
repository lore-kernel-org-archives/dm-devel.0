Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EB13644A4
	for <dm-devel@lists.linux.dev>; Wed, 15 Jul 2026 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784148683; cv=none; b=UsRbfMpjq+Sw1/M+snaxKdrBacEKBRIdDJE4tQ0P4l91Nxt9gczv9X9JDc5Kjc2xpjXUR9c8SJzpPXk+A9gCx5/eNFE+Wjgg2cMxKgTaStHJYOHZf0ULOLJSBIAXB/sHAvYBf8h28k5i8jw5gKCtfGFM9D8Vfz0oEwPWtD2Yxkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784148683; c=relaxed/simple;
	bh=+H1kNsxGPgcmibZot3ItegSIRpUCp4zRnS5uO7LoirE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oa//19wi08F7eHfemQnL6UPNr/4mLv3E7tDsGsrS/NcgVbXEXra9NtUl4ig0rKbQmqDWuJ2f/IEl9+e4/2/myE6imbqSwTROwK963qtdRpTLQvd141VFt/J5liUH+S3Ny4X4wQtuz4nqXPKXXSktOVCIlW72C36OLIY9jOlfbeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WIWDTlW4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AuFkEoP+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WIWDTlW4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AuFkEoP+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D864B3E33;
	Wed, 15 Jul 2026 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784148680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aQNLdgPPvnZJ6eHYN3bplzlB3e4YVjC5kSe8WrW6DcI=;
	b=WIWDTlW47vd8nU/EHmXHkIVa3qZTp9U4NA2FuyG3rVNUHwPVLExMAK0BcpCvcNLqHvMkL9
	6/ALcTOJJUwQ+vJ2LSYtJc8kL0Vfna6vAZqAtL07gU4TExLC9CDtvWLDgho7H6qTGhHjcn
	r39SCm0ygyUfXEGAkSKq9SP20pLZBgo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784148678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aQNLdgPPvnZJ6eHYN3bplzlB3e4YVjC5kSe8WrW6DcI=;
	b=AuFkEoP+vjao+wIFvyiJq6L11vR8dI+MLFHY/zVVKZYhvo4DS41MnC5M1Ntr+kePofTa9P
	M7zmdLqIfzVlPS2R9SVz30wqiAm89osReAOY8ppINioCEGbizpSHfmf9oA/rAiZU7Gi7PI
	tkx2BZgbAkOL/hPe8b+aeh3XUD2NwkI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1CA9779AD;
	Wed, 15 Jul 2026 20:51:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DnvBKcbyV2rmQgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 15 Jul 2026 20:51:18 +0000
Message-ID: <f7fbd9be3b9552031f49caf6eb86a031154052c0.camel@suse.com>
Subject: Re: [PATCH] kpartx: fix crash and truncated device creation with
 long -p delimiter
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Kou Wenqi <kouwenqi@kylinos.cn>
Date: Wed, 15 Jul 2026 22:51:18 +0200
In-Reply-To: <tencent_1439656590A8038E3E7E20A0961B8C34E805@qq.com>
References: <tencent_1439656590A8038E3E7E20A0961B8C34E805@qq.com>
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
X-Spam-Score: -4.24
X-Spamd-Result: default: False [-4.24 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.14)[-0.675];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[qq.com,lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,suse.com:email,suse.com:mid,kylinos.cn:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Wed, 2026-07-15 at 17:36 +0800, 303146950@qq.com wrote:
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
> - Clearing the name buffer in format_partname() on overflow, so that
> =C2=A0 callers can detect the failure by checking partname[0]
> - In the ADD/UPDATE loops, after dm_find_part() returns 0, checking
> =C2=A0 whether partname is empty and skipping the partition with an error
> =C2=A0 message instead of proceeding with dm_addmap()
> - Initializing part_uuid to NULL in all three partition loop bodies
> =C2=A0 (ADD/UPDATE main loop, container partition loop, DELETE loop) so
> =C2=A0 that the "if (part_uuid && uuid)" guard correctly skips the UUID
> =C2=A0 check when dm_find_part() returns early

Thanks for the patch! It looks good to me, but I'd suggest to add an
error return to dm_find_part() of testing partname[0] in the callers.

Regards
Martin

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
> =C2=A0kpartx/devmapper.c |=C2=A0 4 +++-
> =C2=A0kpartx/kpartx.c=C2=A0=C2=A0=C2=A0 | 44 ++++++++++++++++++++++++++++=
++++------------
> =C2=A02 files changed, 35 insertions(+), 13 deletions(-)
>=20
> diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
> index 45dac585..9eb6eeca 100644
> --- a/kpartx/devmapper.c
> +++ b/kpartx/devmapper.c
> @@ -113,8 +113,10 @@ strip_slash (char * device)
> =C2=A0static int format_partname(char *buf, size_t bufsiz,
> =C2=A0			=C2=A0=C2=A0 const char *mapname, const char *delim,
> int part)
> =C2=A0{
> -	if (safe_snprintf(buf, bufsiz, "%s%s%d", mapname, delim,
> part))
> +	if (safe_snprintf(buf, bufsiz, "%s%s%d", mapname, delim,
> part)) {
> +		buf[0] =3D '\0';
> =C2=A0		return 0;
> +	}
> =C2=A0	strip_slash(buf);
> =C2=A0	return 1;
> =C2=A0}
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index cfd82128..5972a251 100644
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
> +				if (!dm_find_part(mapname, delim, j
> + 1, uuid,
> +							partname,
> sizeof(partname),
> +							&part_uuid,
> verbose)) {
> +					if (partname[0] =3D=3D '\0') {
> +						fprintf(stderr,
> +							"partition
> name too long for partition %d, skipping\n",
> +							j + 1);
> +						r++;
> +						continue;
> +					}
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
> +					if (!dm_find_part(mapname,
> delim, j + 1, uuid,
> +								part
> name,
> +								size
> of(partname),
> +								&par
> t_uuid, verbose)) {
> +						if (partname[0] =3D=3D
> '\0') {
> +							fprintf(stde
> rr,
> +								"par
> tition name too long for partition %d, skipping\n",
> +								j +
> 1);
> +							r++;
> +							continue;
> +						}
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
> @@ -570,7 +590,7 @@ main(int argc, char **argv){
> =C2=A0			}
> =C2=A0
> =C2=A0			for (j =3D MAXSLICES-1; j >=3D 0; j--) {
> -				char *part_uuid, *reason;
> +				char *part_uuid =3D NULL, *reason;
> =C2=A0				if (slices[j].size ||
> =C2=A0				=C2=A0=C2=A0=C2=A0 !dm_find_part(mapname, delim, j
> + 1, uuid,
> =C2=A0						=C2=A0 partname,
> sizeof(partname),

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
