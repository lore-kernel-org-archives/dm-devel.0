Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2723242A9
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155575; cv=none; b=nB1hW33QvELdKthC8+xhasYEYaZL1oO/kd0+1UYTQuCP6MVp4CXlVJ6z1XrSaONbo4/4i2DM2x7S5JkYdNl2clVi1of6IZ/wPpmsIX3Ia7wimFRV4Z0qSrJGUyRvB0onk7kYsbw9JWHWk5CI57sdO+rUNHjUsbiivd6hEo7vwDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155575; c=relaxed/simple;
	bh=Ya1cdQLhS9b9gefKj0DC2qAdMQWe2yNJIp0UD381WSQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E4D5WZVjBSc/iglc/xCm/7uGvPs4JbHF6y0Nsxzr4dJSdM8M+mZHs0nR2W3QjC4QwR2Td12kMGzi1itqlPTrfBU4xEiazn1GCq3x1L4yc4TJFhsm9cI9pM8XZa0kQ9tI98DoT/mvBoZcq6N1P4kb2p0uV+qG73/AVwMkLVg+Fzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D1IDomrj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D1IDomrj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D1IDomrj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D1IDomrj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96C075BD10;
	Fri, 19 Dec 2025 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766155565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ya1cdQLhS9b9gefKj0DC2qAdMQWe2yNJIp0UD381WSQ=;
	b=D1IDomrjfSGRHwU0JI7UQTob1AkM/lBZnrcWxPni2nwu8v+kSh+kcUvlaCLGdb0uDkPF+F
	zQMeztlprvX3U68MPLOK0WiAItW3zI3m6J8B85aFFzY7yl99YYKU42JhuzSewGivycL1PH
	4EAbVDXjfbETsAQ6wi1qYFFLRPOu4Uk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=D1IDomrj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766155565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ya1cdQLhS9b9gefKj0DC2qAdMQWe2yNJIp0UD381WSQ=;
	b=D1IDomrjfSGRHwU0JI7UQTob1AkM/lBZnrcWxPni2nwu8v+kSh+kcUvlaCLGdb0uDkPF+F
	zQMeztlprvX3U68MPLOK0WiAItW3zI3m6J8B85aFFzY7yl99YYKU42JhuzSewGivycL1PH
	4EAbVDXjfbETsAQ6wi1qYFFLRPOu4Uk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76E123EA63;
	Fri, 19 Dec 2025 14:46:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oAnBGy1lRWnIPQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 19 Dec 2025 14:46:05 +0000
Message-ID: <82a381769d0b1eef421244fb3e4ac10c3197ed43.camel@suse.com>
Subject: Re: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan
 paths instead of freeing them
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <martin.wilck@suse.com>
Date: Fri, 19 Dec 2025 15:46:05 +0100
In-Reply-To: <20251219144108.237928-15-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
	 <20251219144108.237928-15-mwilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Rspamd-Queue-Id: 96C075BD10
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	DWL_DNSWL_LOW(-1.00)[suse.com:dkim];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Fri, 2025-12-19 at 15:40 +0100, Martin Wilck wrote:
> If add_map_without_path() fails to set up the multipath data
> structures,
> don't free the paths associated with the map as
> cleanup_multipath_and_paths() would; just orphan the paths.
> update_pathvec_from_dm() will handle the paths and see if they
> need to be removed.
>=20
> Suggested-by: Benjamin Marzinski <bmarzins@suse.com>

Ups, sorry.=C2=A0;-)
I won't resend just for this, it's fixed on my tip branch.

Martin
