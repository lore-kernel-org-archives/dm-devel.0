Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA22232861B
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 07:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769586652; cv=none; b=t72Jk1R0nCO9t34btybjD3Q1vpPlF/YYaANyOaKRlV6UC9GgH1MOrEz9I0fRsUMJwYLmABGpB2CD8waALHioZNLdD/i2WfliKU7rymDUq7QNuBJEqAPciprgK31B+xtrEbOH5W5Tzh5zz3SVWwQ7nUswsb0RaSPycMXRSppGwkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769586652; c=relaxed/simple;
	bh=s2AZIeXw3yE8vPZTLScYcU0kA43KZE2Rrz8TOwhmSBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z8E7Q0HGGjII0WtMFmZa3uku1lijhakKjsOKuY3CsPagsHx/XAxMHpgscOmdKguNQJiNf1olS1DW+AVGmp3QqZr6wRMn0YUtdSFVG46l+FlCA1xcFCEYOvK+drvCuiv2VEC5lx4gx3OxmqPDRQse3P2v2D9Im0PU5kmc7Ceylvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AOR9Jr15; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AOR9Jr15; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AOR9Jr15";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AOR9Jr15"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D69D95BCD1;
	Wed, 28 Jan 2026 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769586648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2AZIeXw3yE8vPZTLScYcU0kA43KZE2Rrz8TOwhmSBw=;
	b=AOR9Jr15Wgkrw9fa2nzQyh0Y1Ijn27rvvi5gXeujc7tDdPy3DBkSnkhfq8gzjFVGNgxIgQ
	dlr1o2BX6b7/57q7PAhEY/w2clqEB8yLLyuV5B01AmnhM7OvBSeVDhEaegjzrjEbTr3DWd
	y1hMDGmyjH3oYpE5Anlg4wS4J0afkfY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=AOR9Jr15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769586648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2AZIeXw3yE8vPZTLScYcU0kA43KZE2Rrz8TOwhmSBw=;
	b=AOR9Jr15Wgkrw9fa2nzQyh0Y1Ijn27rvvi5gXeujc7tDdPy3DBkSnkhfq8gzjFVGNgxIgQ
	dlr1o2BX6b7/57q7PAhEY/w2clqEB8yLLyuV5B01AmnhM7OvBSeVDhEaegjzrjEbTr3DWd
	y1hMDGmyjH3oYpE5Anlg4wS4J0afkfY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABFC03EA61;
	Wed, 28 Jan 2026 07:50:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kfjoKNi/eWlqewAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 28 Jan 2026 07:50:48 +0000
Message-ID: <32f01f9d270fcaa364a82e9af0c5f4ef09ac4050.camel@suse.com>
Subject: Re: [PATCH 3/3] dm mpath: make pg_init_delay_msecs settable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka
	 <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Date: Wed, 28 Jan 2026 08:50:48 +0100
In-Reply-To: <20260128001224.462746-4-bmarzins@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
	 <20260128001224.462746-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: D69D95BCD1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Tue, 2026-01-27 at 19:12 -0500, Benjamin Marzinski wrote:
> "pg_init_delay_msecs X" can be passed as a feature in the multipath
> table and is used to set m->pg_init_delay_msecs in parse_features().
> However, alloc_multipath_stage2(), which is called after
> parse_features(), resets m->pg_init_delay_msecs to its default value.
> Instead, set m->pg_init_delay_msecs in alloc_multipath(), which is
> called before parse_features(), to avoid overwriting a value passed
> in
> by the table.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Fixes: 848b8aefd44d ("dm mpath: optimize NVMe bio-based support")

?
