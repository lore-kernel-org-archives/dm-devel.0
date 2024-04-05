Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A303316C858
	for <dm-devel@lists.linux.dev>; Fri,  5 Apr 2024 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712335179; cv=none; b=UaoJk0m21MgJijOl3S/IjzhnnYAtImVs8rtPBmNi3TdKL1my6Kd6rxRhGszK6dyBUafQIg/KxYPWkKDnjUmpstSwqNTOEwBnwz6x9VYg5JWzfsUVqezOOzWPNgqIVDQe6AbrDTFbvwhit29HwUplRRg9D9QItdk98ORuyI3yIGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712335179; c=relaxed/simple;
	bh=602x/4DsXgUy1RfWQGxWaZzOSNI68VSBjIn49erFkwI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tqN78M8SaiBfK/pY3bMkKfL8CzG/6tFqVsexusQfJLrN33CH6Qix0xgYVv5aAIQWOTOSGz2kBgvRp/MhydArjICy5B+3bVT6G5B3UihI6+IQzEZ9EQuXL5ks7E3cfgH7mjv+JO48T6KnRwv1urKwX36jvJ4p/w3VZO4lv0h+suw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dSbtUEpA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dSbtUEpA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dSbtUEpA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dSbtUEpA"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ABD2C21AB6;
	Fri,  5 Apr 2024 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712335175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=602x/4DsXgUy1RfWQGxWaZzOSNI68VSBjIn49erFkwI=;
	b=dSbtUEpAcgRHshO0D6AEm9x8IGG7byO2Drtq8AxY1XwNcxVqM78oLwnSau6l1EGA4M+aVx
	8nAbn5+/HbW4MtrmEzgy3sBon9+l4kd+eg603HsKdE6lMX87biXCjO3sfsArdfgRDDUTBD
	waoGI68lAz5gDl6nVrl7cX7Dz2U+ZwU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712335175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=602x/4DsXgUy1RfWQGxWaZzOSNI68VSBjIn49erFkwI=;
	b=dSbtUEpAcgRHshO0D6AEm9x8IGG7byO2Drtq8AxY1XwNcxVqM78oLwnSau6l1EGA4M+aVx
	8nAbn5+/HbW4MtrmEzgy3sBon9+l4kd+eg603HsKdE6lMX87biXCjO3sfsArdfgRDDUTBD
	waoGI68lAz5gDl6nVrl7cX7Dz2U+ZwU=
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 77B23139E8;
	Fri,  5 Apr 2024 16:39:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id fYwkG0cpEGaHcAAAn2gu4w
	(envelope-from <mwilck@suse.com>); Fri, 05 Apr 2024 16:39:35 +0000
Message-ID: <437475d23f5ba85cfc7a31bcf795a0594fd694cf.camel@suse.com>
Subject: Re: [PATCH] README.md: Add libmount to list of build prerequisites
From: Martin Wilck <mwilck@suse.com>
To: Glenn Washburn <development@efficientek.com>, DM-DEVEL ML
	 <dm-devel@lists.linux.dev>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 05 Apr 2024 18:39:34 +0200
In-Reply-To: <20240405001446.442390-1-development@efficientek.com>
References: <20240405001446.442390-1-development@efficientek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.78 / 50.00];
	BAYES_HAM(-1.48)[91.53%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:helo,imap2.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Score: -2.78
X-Spam-Flag: NO

On Thu, 2024-04-04 at 19:14 -0500, Glenn Washburn wrote:
> On Debian based systems the libmount development package (ie.
> libmount-dev)
> is required to build. Add it to the list in the README.md.
>=20
> Signed-off-by: Glenn Washburn <development@efficientek.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

