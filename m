Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B370830
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760029346; cv=none; b=IgnTIok7gzilJrbfooC7XytnMu83k1AijPHiaEvTWZTykZ+7Bq2vxTMLewRDWeuyDmAUX+3y9Es6Sy1ozRaqFhN+NstutddC4kpgYVb8CqWKfa34dOZ9RcP4bmtDTXbjuptZOU+xQO2FqLYhvHfA8PMf7TPLk0iNqtsRwj7h71k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760029346; c=relaxed/simple;
	bh=TVQRebbZfcGx82DdgDm2TxQUhkS+3gCSq27N2M0L4cQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yy1+63tqGk3RQCFIyH4Va9bWorW0jeqrSa40gik3LSx9u2lRASaUMDotaAC/S63n+BuSgphgVmnw+YxMG6HKL6Ha7cakBU1nmYoy/ysXaHkf7ISMvhseDH3u2T2RwIO85GBFOCrjhSIJw+90HJPr8aNjWi6Dao2l534mJ1CjSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YsfUl06m; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YsfUl06m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YsfUl06m";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YsfUl06m"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BF40A21C47;
	Thu,  9 Oct 2025 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760029342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVQRebbZfcGx82DdgDm2TxQUhkS+3gCSq27N2M0L4cQ=;
	b=YsfUl06mXDCwYHVz/kcvzVlMZ75gJ9LlZ5G2Q+IMsBC1JufsqvLQiGOPvbRGq25UK7U/1n
	GNVYyVBjWdhaQKpt5xgNYAIRgr2oSJ8bfUWhC3DOMk84OwAAdWteYKM/kLneg6HFtTDfVi
	t28fcGZ35e8pxIaBTan9w/nmxoUC3gQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760029342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVQRebbZfcGx82DdgDm2TxQUhkS+3gCSq27N2M0L4cQ=;
	b=YsfUl06mXDCwYHVz/kcvzVlMZ75gJ9LlZ5G2Q+IMsBC1JufsqvLQiGOPvbRGq25UK7U/1n
	GNVYyVBjWdhaQKpt5xgNYAIRgr2oSJ8bfUWhC3DOMk84OwAAdWteYKM/kLneg6HFtTDfVi
	t28fcGZ35e8pxIaBTan9w/nmxoUC3gQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A01E513AA6;
	Thu,  9 Oct 2025 17:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JkENJp7q52iJWwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 09 Oct 2025 17:02:22 +0000
Message-ID: <ab0b3332f5abf1650946204def267266a5e9e14e.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add new info to multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 09 Oct 2025 19:02:22 +0200
In-Reply-To: <20250912182150.116717-1-xose.vazquez@gmail.com>
References: <20250912182150.116717-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On Fri, 2025-09-12 at 20:21 +0200, Xose Vazquez Perez wrote:
> Document the static vendor tags for nvme, and dasd devices. And
> product tag for
> the latter.
> And fix NVMe example (s/NVMe/NVME)
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
