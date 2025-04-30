Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968320C469
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998343; cv=none; b=Hlww5Phc0wk5E+Vt/ZtiFkQLgi0jdGhLIsv0nMsV/Zevs84+Xdc834KQoj9BP6uIaRMiGEY/amVx6Dqbx/jRRa2gX3FJXEIBcNW1r4dAzhFKCoMa7DnbZIIgeDRLHHlPFXOV+watl+OxKMJ7mEk+mAtnwh86s/KrLPlMQuMU6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998343; c=relaxed/simple;
	bh=SwXtXUHJqC+xibrl2WmJgycowPtaebc0LO5TP1bpv3g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QHBGJLVLNnyej9IGId9Lhn+GAhmWr2cc+49OHvcO3nv0XrLRM4QKruDP8wE0J0nTsgvlq0oJcMJdHbwFXflvAld2SNsyJLOrrgN69/iSHlQ8YD8egnT0quSmC+pedXqVZ7HuVqjptOB4QR7kFQY1t8xHnZzcTuvX5vI8IEEufds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZsMFjQxo; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZsMFjQxo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZsMFjQxo";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZsMFjQxo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8598C1F7BD;
	Wed, 30 Apr 2025 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745998338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SwXtXUHJqC+xibrl2WmJgycowPtaebc0LO5TP1bpv3g=;
	b=ZsMFjQxoj4k77XpH9ZNEL3s4W/cjCPxyg0bHYgANU+EdTgUE9D4zbip9iLCf3IsCZNLMRa
	o959gpvkxNiRwzeSqzKKUMCVbf1XZCcbB3Gmv+wRx0spi1wwYgK/z94r4uKDIE+GXIpDtp
	ZQ4kkQyN9asjwH771lLrrdQQLcqHuZw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ZsMFjQxo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745998338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SwXtXUHJqC+xibrl2WmJgycowPtaebc0LO5TP1bpv3g=;
	b=ZsMFjQxoj4k77XpH9ZNEL3s4W/cjCPxyg0bHYgANU+EdTgUE9D4zbip9iLCf3IsCZNLMRa
	o959gpvkxNiRwzeSqzKKUMCVbf1XZCcbB3Gmv+wRx0spi1wwYgK/z94r4uKDIE+GXIpDtp
	ZQ4kkQyN9asjwH771lLrrdQQLcqHuZw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C04513A25;
	Wed, 30 Apr 2025 07:32:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rrxxEALSEWhifQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 30 Apr 2025 07:32:18 +0000
Message-ID: <76f588fbfdc13f39c8829221dcef46102e2e9301.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add Quantum devices to hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Wed, 30 Apr 2025 09:32:17 +0200
In-Reply-To: <20250425134609.186615-1-xose.vazquez@gmail.com>
References: <20250425134609.186615-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 8598C1F7BD
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,linux.dev:email,quantum.com:url];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, 2025-04-25 at 15:46 +0200, Xose Vazquez Perez wrote:
> Info from:
> https://qsupport.quantum.com/kb/Flare/Content/appliances/common/InfoHubDo=
cSite/shared_SN_appliances/Topics/overview-MultipathConf.htm
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
