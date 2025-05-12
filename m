Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4A52949FD
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747054928; cv=none; b=iRopCGQKF1YXMOE34rvX9MEs1rjimGJmcUBO8em0TjVeiU33o5FjlqerDkk+iEJejyGmucg8Qe3pjhh6EqoIH2XJO95wOFKK2iWpIg4+zYw6TrbHrAX6B8hncjg89h2+valHkWfwXLX0vgicX6bVwbK6ZpSsfusJmUfoDgNB2vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747054928; c=relaxed/simple;
	bh=Tm6LBNBicejdH9HcSdeE5PgNMGg9RENzhzd2gVC7dH0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CrVtGH9Tgv6r3aQzf973Zf4Z1XKKo/6mZjx9oKK9U94ZE4bhjS1i87gfzsBJaFFs4Z5RCZntFwXYMzU4WfAvUgImgiW0thxSFD9mjxt9uYQNezXWooSfTq/q2u4oizmcsbfmZNEjpK9EyXA+BZFMvsNzaVaVoJct9u6K38mgffk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XuCmPz+R; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XuCmPz+R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XuCmPz+R";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XuCmPz+R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A6CB1F387;
	Mon, 12 May 2025 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747054923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm6LBNBicejdH9HcSdeE5PgNMGg9RENzhzd2gVC7dH0=;
	b=XuCmPz+RwlIJUhHoxkcWzJWDFvojkH0bmfdvEo3uMlj1BLeM2x2I4lBOToP7HIKDwC5B0v
	u3tCXv3HR+ZsBfrRaFeRAjIwUmJIwO94gFD8OvlqxICNbIyvChnHPLQ9N4k85+3uoa7/a6
	dKd7+vVz4m99A8TDdAikL5MV88hfo3o=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XuCmPz+R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747054923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm6LBNBicejdH9HcSdeE5PgNMGg9RENzhzd2gVC7dH0=;
	b=XuCmPz+RwlIJUhHoxkcWzJWDFvojkH0bmfdvEo3uMlj1BLeM2x2I4lBOToP7HIKDwC5B0v
	u3tCXv3HR+ZsBfrRaFeRAjIwUmJIwO94gFD8OvlqxICNbIyvChnHPLQ9N4k85+3uoa7/a6
	dKd7+vVz4m99A8TDdAikL5MV88hfo3o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C29F137D2;
	Mon, 12 May 2025 13:02:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qof+EEvxIWg3HAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 12 May 2025 13:02:03 +0000
Message-ID: <1bcf98dc882d8c8b84c7172bef038721c4fa816c.camel@suse.com>
Subject: Re: [PATCH v2] multipath-tools: update Path Selector descriptions
 on the man page
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Mon, 12 May 2025 15:02:02 +0200
In-Reply-To: <20250509214502.334826-1-xose.vazquez@gmail.com>
References: <20250509214502.334826-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 7A6CB1F387
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,linux.dev:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -3.01

On Fri, 2025-05-09 at 23:45 +0200, Xose Vazquez Perez wrote:
> v2:
> at Martin's suggestion:
> - change round-robin description
> - replace "I/Os" with "I/O requests"
> - fix "dinamyc" typo
> - remove all path selectors parameters
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> BTW, service-'time' is a very confusing name.

AFAICT the thinking is that I/O will be sent to the queue in which the
expected "time" until it's "serviced" is lowest, and I believe that
most people have an intuitive understanding of that meaning. In any
case, this name has stood for decades and won't change, neither in the
kernel nor in multipath-tools.

Regards,
Martin
