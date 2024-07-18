Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167DA145339
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321111; cv=none; b=jSdMkFFzTiFAg+VYhMa9gqYCZZjnTKuAnydIWODVrXX4+7aBDFnA3AJDr7aYUk+eSfB1qG3sa31Xm/KD79Kdl7S3nRAyTCDLZRBfamXvCL1Z64ybsNt1zqINAHvhz+Bsf+Du6+rPX6pZIg9G9yuW9qjvtrR+lx4+HbDnprcCkvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321111; c=relaxed/simple;
	bh=gKyACgFhidfEJrJUrGpQ4Kmf4WIPPh6/EYcufkRXQiM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UGOW173sttF79D4VJvZAGpzrrWFzsULIoa/pV5f1G4pP33A5+H1c76PUWI7F7jfn+BSYX+VyDrXiaHygMbrxX8eoAuLodSYNxLsQ0Yds2ThNWLKUGl5tt0aBWS/IlskQA18eXY92l6k5oizUNGIP+EXl3QuM6pAVkZbi8pDaukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qn2tYoF4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hD51B/k0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qn2tYoF4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hD51B/k0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F31B1FBFA;
	Thu, 18 Jul 2024 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1721321108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gKyACgFhidfEJrJUrGpQ4Kmf4WIPPh6/EYcufkRXQiM=;
	b=Qn2tYoF4RruzBCmCq209qXnxeiXbno7jpQXCA+SQU5Cr9DRxQrxgPy0bjYjsJ8TA4sQCE/
	kOJ7ROplfZLm4UwNJuRDatmEiuW6WScanCuCXMPOTpl9UhXBoIhKq1KwlM5RliiKGLWCgP
	ItsdN6eRkk0LmAi5p6QPrg4T3mXOGjI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="hD51B/k0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1721321107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gKyACgFhidfEJrJUrGpQ4Kmf4WIPPh6/EYcufkRXQiM=;
	b=hD51B/k0Y6odX7o7gisRblFTRjriukY0oGEa4KyvBC3u055xyu9ip8TPx3N9fjURkgrafx
	Xxwra6yuhnqQT2jVmilgdRxt/fEIN5Dgu1/fOBSu438LdTKYXFX9aMDzescGORkRWAXSoP
	Y7hDPM+vFGbDVAec40V0m4fWkgZussE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40DF1136F7;
	Thu, 18 Jul 2024 16:45:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YMBDC5JGmWZdQgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 18 Jul 2024 16:45:06 +0000
Message-ID: <988f20dd0957c54cdc06bb15bbb26f2de25fa563.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: remove duplicate headers
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Thu, 18 Jul 2024 18:45:05 +0200
In-Reply-To: <20240717095108.120782-1-xose.vazquez@gmail.com>
References: <20240717095108.120782-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 0F31B1FBFA
X-Spam-Flag: NO
X-Spam-Score: 0.99
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [0.99 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensvc.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:email,suse.com:dkim,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Spamd-Bar: /

On Wed, 2024-07-17 at 11:51 +0200, Xose Vazquez Perez wrote:
> Minimal cleaning done with scripts/checkincludes.pl
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

