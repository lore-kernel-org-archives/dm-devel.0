Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A822318
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 08:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015991; cv=none; b=OohgAKeUT+cRW/TCA4Ky5eIkhnip02skJRvBhYfGyzHCt+0F3vfeOl8j2mY8IjF9hXulkxElhZVvl7niN2eLRtGsVym7+tYvN5eT3hXaolmdahEiSfwrGaRRfmFKgVpowtrAmy3pOv+KZgRP8HFigDS7GJhduURnJWRNR8SFMIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015991; c=relaxed/simple;
	bh=OX+RPB8MLMP3VbjHoWJSOWl+MEq8C9Iz1Xt3rR1m+DQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dKHpjW4zVNlvaZHPjhHE0NHCjxETpuhVaDNNBLzMsRTGT/KccUcLVsRxbfEu8E885wT3qm5TEAsa3mYo1o5Qs7+KGacD7YQHMZIF9CzYB5W8VOaIzLUxLg4tcu9Iv0HRnZygFbCLZWfiXoDqdiwcBUp2RkQcNXZv4vev37uJQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kv3MXWys; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kv3MXWys; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kv3MXWys";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kv3MXWys"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 04EB91F38D;
	Mon,  7 Apr 2025 08:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744015988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9i6mFH/TjvHpfv0Xx/L9qTyMbeYGkAd8RIFCyBDo9Wg=;
	b=Kv3MXWys01FJXd6wu3G69mWWEvpLZfW7PZdMZf5UwYsJA6qIQFrtPNzb4iREZrCt0aZVtu
	4lIiHm0fsb5Oya56Y04i4A+YR6+prstHyb4g2CyvL9gBc2eJJbT8jnHxecd8hN+HHfR4f6
	lD0FOjmEgyQ3HC8/CXLgfELJg4WnGpU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744015988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9i6mFH/TjvHpfv0Xx/L9qTyMbeYGkAd8RIFCyBDo9Wg=;
	b=Kv3MXWys01FJXd6wu3G69mWWEvpLZfW7PZdMZf5UwYsJA6qIQFrtPNzb4iREZrCt0aZVtu
	4lIiHm0fsb5Oya56Y04i4A+YR6+prstHyb4g2CyvL9gBc2eJJbT8jnHxecd8hN+HHfR4f6
	lD0FOjmEgyQ3HC8/CXLgfELJg4WnGpU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C590B13691;
	Mon,  7 Apr 2025 08:53:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZzGrLnOS82cmNgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 07 Apr 2025 08:53:07 +0000
Message-ID: <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target
 docs/man/dmmp_strerror.3 to .PHONY list
From: Martin Wilck <mwilck@suse.com>
To: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
	 <kelefa.sane@smile.fr>, Yoann Congal <yoann.congal@smile.fr>
Date: Mon, 07 Apr 2025 10:53:07 +0200
In-Reply-To: <20250404122902.2750036-2-sofiane.hamam@smile.fr>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
	 <20250404122902.2750036-2-sofiane.hamam@smile.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
>=20
> When checking out the git repos, sometimes, target
> docs/man/dmmp_strerror.3 is newer that the prerequisite
> libdmmp/libdmmp.h this leads to a non reproducible behavior:
> Sometimes, the timestamps are updated in the manpages, sometimes not.
>=20
> Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> ---
> =C2=A0libdmmp/Makefile | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 7e0e2509..187bcb8c 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -fvisibility=3Dhidden
> =C2=A0LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir) =
-
> lmpathcmd -lpthread
> =C2=A0
> =C2=A0all: $(LIBS) doc
> -.PHONY:	doc clean install uninstall check speed_test
> dep_clean
> +.PHONY:	doc clean install uninstall check speed_test
> dep_clean docs/man/dmmp_strerror.3
> =C2=A0

I've seen the issue you refer to, but this is not the right solution.
It will cause the time stamps of the man pages to be regenerated on
every build.

Martin

> =C2=A0$(LIBS): $(OBJS)
> =C2=A0	$(Q)$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D$@ -o $@
> $(OBJS) $(LIBDEPS)
