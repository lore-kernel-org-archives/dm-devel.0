Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B4C2820D1
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758567388; cv=none; b=pT/nIklu2BDw1Dh3ib4uo6U5j/Ga+nT1TL5/ZSAfUSG3mCrf9nkJs2XlAW9TMdw4omGwiqU/I80xpVkOrJz/0+mq2ExZEqjV6QHi86R+Hjeqm8UKhLlqlPEDpiFANpcH3P72RPRFiRAq215LE9XNHGfpo2rlsMNiGKf804SJquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758567388; c=relaxed/simple;
	bh=fF49wtimi/ErdezXZ2u13sEMtrtfomj3Nxk3CxTe39w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GBu5AeOPnFQ9wddFV9k9cuoGahmA+eB0FJQiWeAtn2LcJ2oRfseJMR35denlC4hQCKw2KgeX5764l0mB8NHoyVRnq3V5LgbKa6Gc8r9Z/RNaM8zIPre1Vl+jv/1iFbgjGS2DQe+Na6y13NBmT3agCGKWW64vuaUhm3cCdc0EX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gn20Oq8H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GMR5+dnV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gn20Oq8H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GMR5+dnV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5F0C1F845;
	Mon, 22 Sep 2025 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758567384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fF49wtimi/ErdezXZ2u13sEMtrtfomj3Nxk3CxTe39w=;
	b=Gn20Oq8HMwS9qXro5LHGuFkdoUzeKQ1ufBKH75EO7rsGo7ou1wTIRub1zmnYZiOIWnKn6v
	DnhrzEtqWVW5rnW9RLw34w3goJqT4+eLtf62p+m1WEnxVANKS/EVkUiU+quDVK6u84Pc+K
	SmZjDIsBB+w5gpI7iG/MRX3GieYuuAw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GMR5+dnV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758567383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fF49wtimi/ErdezXZ2u13sEMtrtfomj3Nxk3CxTe39w=;
	b=GMR5+dnVp8dTU+9V1CL3MbK4wo+tshMDWwddDIvhVTLX1xZKnYa236w75IyeoBwzm5Zajf
	acQKgVn9AvZJV53z3XB/i0BYrAji4C5M2FZnNYKjNoUWkRAQ9mt2hKd+BIJwO7CNI4T9HO
	TSpKlr3RZP9gMSjA/+Y4ZfyecybGLIU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A44161388C;
	Mon, 22 Sep 2025 18:56:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rby0Jteb0WjdYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 22 Sep 2025 18:56:23 +0000
Message-ID: <a8295cfe0ea955f6d0200ee04523cbd79eba6ca8.camel@suse.com>
Subject: Re: [PATCH 0/4] multipath-tools: add new NVMe devices to hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: Steven Schremmer <Steve.Schremmer@netapp.com>, NetApp RDAC team	
 <ng-eseries-upstream-maintainers@netapp.com>, Benjamin Marzinski	
 <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
  DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 20:56:23 +0200
In-Reply-To: <20250913130221.35073-1-xose.vazquez@gmail.com>
References: <20250913130221.35073-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
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
	FREEMAIL_TO(0.00)[gmail.com,redhat.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: D5F0C1F845
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

On Sat, 2025-09-13 at 15:02 +0200, Xose Vazquez Perez wrote:
> Even if they work with the generic NVME config. It is convenient to
> have
> them as an independent config to tweak their options, compare dm-
> multipath
> against the NVMe subsystem, ..
>=20
> Only two of them are missing ("Fujitsu ETERNUS AB/HB Series" and
> "NetApp E-Series")
> as requested by its vendor: https://marc.info/?t=3D165256933900004
>=20
> Xose Vazquez Perez (4):
> =C2=A0multipath-tools: remove checker from Huawei OceanStor NVMe
> =C2=A0multipath-tools: add HITACHI VSP NVMe to hwtable
> =C2=A0multipath-tools: add Infinidat InfiniBox NVMe to hwtable
> =C2=A0multipath-tools: add VASTData Block Subsystem NVMe to hwtable
>=20
> =C2=A0libmultipath/hwtable.c | 22 +++++++++++++++++++++-
> =C2=A01 file changed, 21 insertions(+), 1 deletion(-)
>=20
> Cc: Steven Schremmer <Steve.Schremmer@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

I realize you set .no_path_retry =3D NO_PATH_RETRY_QUEUE for all devices.
Should we use this for the generic NVMe device, too?

Martin


