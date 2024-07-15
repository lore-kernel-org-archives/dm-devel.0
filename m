Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA58A18EFDA
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721055491; cv=none; b=WxZtjUsMbSA4rppaXE15QG0SdaOM80BlHuvh1IdPA3UOCvyuQuln0gXbzjMOr1YaanP0f56mXgwdpgy03PLEToacmZrO9CecVt5mgCY5AWC2suw/EZc//RyBjILjHOUXoCnJGbZ+yCj8Xyo8IuGl+WkUUhL7CohDCdUuRF6YpRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721055491; c=relaxed/simple;
	bh=lzCHFDvwobviN0UfV+OHigyh8Sd13qsODFrc4hA/im4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YHZDmmIc+KeYrjjH968CvAjvSslirG5iP1Gofh8U+pn1PU1mT2L+vjVPYFAtBwSBxykuaBZq86SgHJrEhUpFBditufaj4vwU6abzQfA+N2fIjlmnkXR9jareiy6yItQmXzfO4BQXl7e3YJxUySmDriUBUjSEn27NKlMsZ89FXbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ILjZPs8h; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JkZaWchm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ILjZPs8h";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JkZaWchm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9CDE21BB0;
	Mon, 15 Jul 2024 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1721055488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzCHFDvwobviN0UfV+OHigyh8Sd13qsODFrc4hA/im4=;
	b=ILjZPs8hrP3Lqomx8puxg/fXkq5nBSIH3LktHyv+QmhYiwxNjp0MukEzFX3to0fyfKS41a
	mJPue3bl48ZhVFrEEK+MaI7SWICjRtwkUCnzvOWeAfaLrnCOA+Xvzpehqtifuj/YwNB5eQ
	E70S/kFWy96sBiQ+CgKjCzJwd0Po2ww=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=JkZaWchm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1721055486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzCHFDvwobviN0UfV+OHigyh8Sd13qsODFrc4hA/im4=;
	b=JkZaWchm38v+ISG1sYno3EKO3CerYwGuCQ2Ggo6xUhf9sMnWE86yFcZ3yoWI1JY71wCdC0
	gCeGSBwoXcJeHnqhY/2d6SgmRGaFaiRoFDk/LeIrkRsmvXsOUgade7F+YebTiD1tiwFM/+
	1KZgi6JgykS14D2mEaUy43znSX5wWSI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADA51134AB;
	Mon, 15 Jul 2024 14:58:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id utjUKP44lWaGcgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jul 2024 14:58:06 +0000
Message-ID: <0749c21047e6725f49e4f74f5547991c01e17b2d.camel@suse.com>
Subject: Re: [PATCH 0/2] multipath-tools: add more HUAWEI devices and
 vendors IDs
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 16:58:06 +0200
In-Reply-To: <20240713111025.104048-1-xose.vazquez@gmail.com>
References: <20240713111025.104048-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,huawei.com:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: D9CDE21BB0

On Sat, 2024-07-13 at 13:10 +0200, Xose Vazquez Perez wrote:
> Taken from Huawei UltraPath multipathing doc:
> https://support.huawei.com/enterprise/en/doc/EDOC1100362072/4a563777/show=
ing-array-models-supported-by-the-ultrapath
>=20

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

