Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B2720B0F
	for <dm-devel@lists.linux.dev>; Fri,  5 Apr 2024 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712335936; cv=none; b=hKtfOlET6dzbjwWEN/PV+WgChfKGJPhfKVB8IS/2THfXw2g+wyNuOwgJ6R6QAV+ffJ07PpLgSbyJqyQ6JjHkd7eHkWqXjcfBwVV6TN6QS62iiIafivS/6lkT3MIyDrSjw3ejAvS1cHUsaMrxgGzw/9AhfB82wzG4JjwI36Wq+zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712335936; c=relaxed/simple;
	bh=8RBynPJYbdoAhfDxqNIqcdgl17JQsHpB0UsblLA1AbE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ddLqTGFA5rx6OEl6LlRtOWqjYkUiNlo7RlFCDeq/d8b32wb6a+OWy5U9yX0RrvITj5iCYAHmVKH5hVkP9h6xdLtutUtzRm2M9ktkEduevVd+SvIugJWW9yWxxiHqNkin4Me6U1R7tei/4lUjf3wvdGsBNVuoa02hxOAdfcQJcbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pTSF51Ol; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pTSF51Ol; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pTSF51Ol";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pTSF51Ol"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C0D81F7EC;
	Fri,  5 Apr 2024 16:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712335932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RSbX2ENy9ucK2KJH3P++ZWPSQgjm0JRhFztebMCMUZY=;
	b=pTSF51Ol8zkSscM1+3qaEx1b2CLgq6vtNKenPkcPt98QXR7E7eKFYlOesQgZyEiOl79JTN
	u6h0kbdqTBFWsGd0qvDXt3uJODtdzgHZILlVO4JV2lJBb84tOsKOwvB+HeufDXRIFr4IJ/
	FsuId0wJ1qMfrg+ll2xevksHgMdJ8wY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712335932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RSbX2ENy9ucK2KJH3P++ZWPSQgjm0JRhFztebMCMUZY=;
	b=pTSF51Ol8zkSscM1+3qaEx1b2CLgq6vtNKenPkcPt98QXR7E7eKFYlOesQgZyEiOl79JTN
	u6h0kbdqTBFWsGd0qvDXt3uJODtdzgHZILlVO4JV2lJBb84tOsKOwvB+HeufDXRIFr4IJ/
	FsuId0wJ1qMfrg+ll2xevksHgMdJ8wY=
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F292139E8;
	Fri,  5 Apr 2024 16:52:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id UBzkATwsEGZAdAAAn2gu4w
	(envelope-from <mwilck@suse.com>); Fri, 05 Apr 2024 16:52:12 +0000
Message-ID: <a6df6b723524e3cffb71ec58bc6de86552878589.camel@suse.com>
Subject: Re: [PATCH] kpartx: Add -N option to allow specifying a devmapping
 name
From: Martin Wilck <mwilck@suse.com>
To: Glenn Washburn <development@efficientek.com>, DM-DEVEL ML
	 <dm-devel@lists.linux.dev>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 05 Apr 2024 18:52:07 +0200
In-Reply-To: <20240405002332.442743-1-development@efficientek.com>
References: <20240405002332.442743-1-development@efficientek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
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
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:helo,imap2.dmz-prg2.suse.org:rdns]

On Thu, 2024-04-04 at 19:23 -0500, Glenn Washburn wrote:
> Running `kpartx -a disk.img` will create device names like
> `/dev/mapper/loopNpM` where `N` and `M` are positive integers. The
> issue is
> that `loopN` is not known before hand. `losetup -f` can be used to
> figure
> out what the next loop device will be, but the loop device might be
> taken
> by something else between then and when kpartx finds the next loop
> device.
> Add a new option `-N` which takes a string argument that will be used
> as
> the base name of the devmapper device.
>=20
> Signed-off-by: Glenn Washburn <development@efficientek.com>

Thanks for the patch, this looks useful. But you should warn / error
out if "-N" was used with a real block device rather than an image (or,
alternatively, implement using the map basename for block devices,
too). If the image is already loop-mounted, the loop device _is_ known
beforehand; it needs to be clarified and documented how this option
behaves in that case (your commit description refers only to the case
in which the loop device is created by kpartx).

Also, please update the kpartx man page.

Regards,
Martin


> ---
> =C2=A0kpartx/kpartx.c | 8 ++++++--
> =C2=A01 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 46cb76bac678..750b889327e9 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -88,7 +88,7 @@ initpts(void)
> =C2=A0	addpts("ps3", read_ps3_pt);
> =C2=A0}
> =C2=A0
> -static char short_opts[] =3D "rladfgvp:t:snu";
> +static char short_opts[] =3D "rladfgvp:t:snuN:";
> =C2=A0
> =C2=A0/* Used in gpt.c */
> =C2=A0int force_gpt=3D0;
> @@ -99,7 +99,7 @@ static int
> =C2=A0usage(void) {
> =C2=A0	printf(VERSION_STRING);
> =C2=A0	printf("Usage:\n");
> -	printf("=C2=A0 kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n]
> [-v] wholedisk\n");
> +	printf("=C2=A0 kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n]
> [-v] [-N name] wholedisk\n");
> =C2=A0	printf("\t-a add partition devmappings\n");
> =C2=A0	printf("\t-r devmappings will be readonly\n");
> =C2=A0	printf("\t-d del partition devmappings\n");
> @@ -111,6 +111,7 @@ usage(void) {
> =C2=A0	printf("\t-v verbose\n");
> =C2=A0	printf("\t-n nosync mode. Return before the partitions are
> created\n");
> =C2=A0	printf("\t-s sync mode (Default). Don't return until the
> partitions are created\n");
> +	printf("\t-N use name as base name for device\n");
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> @@ -312,6 +313,9 @@ main(int argc, char **argv){
> =C2=A0		case 'u':
> =C2=A0			what =3D UPDATE;
> =C2=A0			break;
> +		case 'N':
> +			mapname =3D optarg;
> +			break;
> =C2=A0		default:
> =C2=A0			usage();
> =C2=A0			exit(1);

