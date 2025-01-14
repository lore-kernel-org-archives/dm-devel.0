Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E07207643
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736894195; cv=none; b=G1d2mG1kLwaQ048s6AK6N9FN2lOmtrN0cWFifunjI//nuXVJTVj+kquNr6sQEsBwmLDWfRJXcrSrrZo1BdmWdpESF1XMuXo+rwThZbJGldfrbIObK5obDejM5NdJ66wRc++zCHg9Px7rNf5/LDYaBwlCcfhNOczR0uk9zTgfOmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736894195; c=relaxed/simple;
	bh=gZWVwbAtj+Gf2TA0CAz5uI2Hr9CyK9uphaD2x0w6kW4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kxoQhMo4jW1Vg/axJrW5u0broosPAWaHJD+lEGtSu08DMgLXbSG4iWbUAP8Vh7nM5mcqnKWWp45Trmzfed44DTrXnFaOQnA2w++L5vHaIcFCPZ8+SNCYniMBlbck0/goJLPcT/R33otNh5i0yLcf8inNFGVwSvIbLWuIYWR4/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DbJQw+MR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DbJQw+MR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DbJQw+MR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DbJQw+MR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 937E7211B3;
	Tue, 14 Jan 2025 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736894190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZWVwbAtj+Gf2TA0CAz5uI2Hr9CyK9uphaD2x0w6kW4=;
	b=DbJQw+MRtbgdEuDmAOK+mcmN2Leyu4SjVDYHhv66YT3FAX85M23iu86NM4ZrZPWOw8BYS6
	g5YFLo0bKnBURkWDEWpoy0Gj3ErBy3HXM/TA0cyEMgxDEH26mhK+zobxINHJjbiR1KrroI
	KKg7LBIRWRROYaPE/V583v3jfkOIWig=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DbJQw+MR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736894190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZWVwbAtj+Gf2TA0CAz5uI2Hr9CyK9uphaD2x0w6kW4=;
	b=DbJQw+MRtbgdEuDmAOK+mcmN2Leyu4SjVDYHhv66YT3FAX85M23iu86NM4ZrZPWOw8BYS6
	g5YFLo0bKnBURkWDEWpoy0Gj3ErBy3HXM/TA0cyEMgxDEH26mhK+zobxINHJjbiR1KrroI
	KKg7LBIRWRROYaPE/V583v3jfkOIWig=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62B35139CB;
	Tue, 14 Jan 2025 22:36:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JfH0Fe7mhmf8aQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 14 Jan 2025 22:36:30 +0000
Message-ID: <4cb9c9f4c4a6bd1a5053a45069bd2f57f698f1ec.camel@suse.com>
Subject: Re: [PATCH] libmultipath: add condition for enqueueing path to io
 error check
From: Martin Wilck <mwilck@suse.com>
To: chenrenhui <chenrenhui1@huawei.com>, dm-devel@lists.linux.dev
Cc: lixiaokeng@huawei.com, bmarzins@redhat.com
Date: Tue, 14 Jan 2025 23:36:29 +0100
In-Reply-To: <20250110063816.759-1-chenrenhui1@huawei.com>
References: <20250110063816.759-1-chenrenhui1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 937E7211B3
X-Spam-Level: 
X-Spamd-Result: default: False [-4.47 / 50.00];
	BAYES_HAM(-2.96)[99.83%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.47
X-Spam-Flag: NO

On Fri, 2025-01-10 at 14:38 +0800, chenrenhui wrote:
> In function io_err_stat_handle_pathfail(), path-
> >io_err_dis_reinstate_time
> is set to 0 to enqueue path to io error check as soon as possible.
> But
> multipathd can not do it within marginal_path_err_recheck_gap_time
> seconds
> after power-on, because curr_time is less than
> marginal_path_err_recheck_gap_time.
>=20
> To handle the early marginal path, we can enqueue path when
> io_err_dis_reinstate_time is 0.
>=20
> Signed-off-by: chenrenhui <chenrenhui1@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

