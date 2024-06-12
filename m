Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9998EB651
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 07:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178176; cv=none; b=j9/xhMHP4fKnUzSSOy/34YrCctJaeiRhptGZolt1uiuM3n8f+R2BMA8i1xriDCUyVKqVkFGRYaQ1bUM8UbuS0HC1auI8YxwU8EG6WZfcYyKWIuFTgcCnTAxFu812CwTMlU4OiFyM4p4nriiZxWmEwrJ7w4i5ZlRGZuwBzVS1vC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178176; c=relaxed/simple;
	bh=9VTzSOPH/Dwel5+Nnpo7rE2T0j5I9l0Fa/7+mL15OvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SsgHb0TE7xFXslh/pCDoWJcflg3WnXA31IrLaH+reP/Vy93rsuGXsUN+USH9tLUapN6OTtixSxnbuvOZZYMPu76Y3R3CXUY+F3sQUd7lS0/vpl5tNLys5/RjzMwbZvC5WK04s4ShfsL8LRviJRHvaBWoFJ262UgSvY4Ceu/LRKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Wyba1DhD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Wyba1DhD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wyba1DhD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wyba1DhD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8851234079;
	Wed, 12 Jun 2024 07:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1718178172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VTzSOPH/Dwel5+Nnpo7rE2T0j5I9l0Fa/7+mL15OvY=;
	b=Wyba1DhDkoolns320eqc+q0jngnqxHATXyF4oztFkCYlvacTo4ZrVzVos9ciIR7gY4L3p1
	zCPFyQPLggvLHOwYuqwe5u0jqgqlkgHY4HFnMSQTOJqg51U478ubnzuYbfo1HanaDpF1ts
	CKbGh1dASXJlWzN/uQUOh9A2GO8ZLC8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1718178172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VTzSOPH/Dwel5+Nnpo7rE2T0j5I9l0Fa/7+mL15OvY=;
	b=Wyba1DhDkoolns320eqc+q0jngnqxHATXyF4oztFkCYlvacTo4ZrVzVos9ciIR7gY4L3p1
	zCPFyQPLggvLHOwYuqwe5u0jqgqlkgHY4HFnMSQTOJqg51U478ubnzuYbfo1HanaDpF1ts
	CKbGh1dASXJlWzN/uQUOh9A2GO8ZLC8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C7E91372E;
	Wed, 12 Jun 2024 07:42:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id prv0FHxRaWa/TgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 12 Jun 2024 07:42:52 +0000
Message-ID: <fa3c9e3e8c32604b12f69aeac9bfd7f767407df3.camel@suse.com>
Subject: Re: [PATCH] multipath.conf.5: fix the description of prio_args for
 path_latency prio
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Kou Wenqi <kouwenqi@kylinos.cn>
Date: Wed, 12 Jun 2024 09:42:51 +0200
In-Reply-To: <tencent_28B810D5C1E1C6C30580729B90CA3CBFAF0A@qq.com>
References: <tencent_28B810D5C1E1C6C30580729B90CA3CBFAF0A@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.08
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.08 / 50.00];
	BAYES_HAM(-2.78)[99.03%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[qq.com,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Wed, 2024-06-12 at 14:18 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> This aligns the description of prio_args for path_latency prio and
> the actual code.
>=20
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>

Thanks!

Reviewed-by: Martin Wilck <mwilck@suse.com>

