Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5865D18F2D4
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 10:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723544277; cv=none; b=CfYcA7Gq2BdkmAUO56Nb60NVbTTqE4gkV1o7YldMPJNeSxNSIVJxLsEdlCFd0WUYG7tbwrOgT83q/bpqTxcQ91XXVP/AhVJa2K9XuwtOM1hHTfIB0A81OS9DZQJ11i6TrLHS25KkQCuBRZ4bIym7QfgQhcgMWq7tH+kZg7sgPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723544277; c=relaxed/simple;
	bh=KlRCIrmS/69Wi74Y0ZUNYcmqEmRp8d9UeFgmeZ3clE8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q12bVDN+URDVz3aygG2Nlf+RHvIij4fDgnxVgAMhKluzqxYJ1eE+5DLMi3W+sL3ae4URT3yfEWmgflDvEWrobF9PErEz45uqJt3yPLPzle3hecIucgPLZ1KILr1Qdmm48603GlWl6VV/x5eT8M5OGpXaBREAIi4ypuY37P8axns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m411JSBd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m411JSBd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m411JSBd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m411JSBd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B63C22773;
	Tue, 13 Aug 2024 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723544272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KlRCIrmS/69Wi74Y0ZUNYcmqEmRp8d9UeFgmeZ3clE8=;
	b=m411JSBdEa9LB2JNm38wKxfLBA3uhe3l3ZmxtpDG9PbljO9FqhdDa+oLNzuFiHJCF4Q4+r
	/mmke3NWG9TEV5F8WFLhIimJ70AwxGc/1rvNA52GHkprFniQ1/DseEW17gbKwP/WoKs9l8
	Aiw5VmaS3Uqa3qVQpAiU/oM1hZALZjE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=m411JSBd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723544272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KlRCIrmS/69Wi74Y0ZUNYcmqEmRp8d9UeFgmeZ3clE8=;
	b=m411JSBdEa9LB2JNm38wKxfLBA3uhe3l3ZmxtpDG9PbljO9FqhdDa+oLNzuFiHJCF4Q4+r
	/mmke3NWG9TEV5F8WFLhIimJ70AwxGc/1rvNA52GHkprFniQ1/DseEW17gbKwP/WoKs9l8
	Aiw5VmaS3Uqa3qVQpAiU/oM1hZALZjE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FC4213983;
	Tue, 13 Aug 2024 10:17:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RHGwDdAyu2bHVwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 Aug 2024 10:17:52 +0000
Message-ID: <7b7b84b847949819d11ef7b88a5fbf4c5c557d0c.camel@suse.com>
Subject: Re: [PATCH v3] multipath: display the correct configuration when
 dumpping config
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Kou Wenqi <kouwenqi@kylinos.cn>
Date: Tue, 13 Aug 2024 12:17:51 +0200
In-Reply-To: <tencent_C349DF9EE757FA8936E17CE2F90388B8B909@qq.com>
References: <26f4b0532302bfff61bac465d9f97b8215c30d78.camel@suse.com>
	 <tencent_C349DF9EE757FA8936E17CE2F90388B8B909@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6B63C22773
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.42 / 50.00];
	BAYES_HAM(-2.91)[99.61%];
	DWL_DNSWL_MED(-2.00)[suse.com:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[qq.com,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -6.42
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-08-13 at 10:12 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> Thanks for your review and revised opinion. Here is the new patch.
>=20
> "multipath -t" and "multipath -T" might show the wrong
> multipathd configuration items "retrigger_tries" and
> "force_sync". Make sure they don't.
>=20
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
>=20

Reviewed-by: Martin Wilck <mwilck@suse.com>

