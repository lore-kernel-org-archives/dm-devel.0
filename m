Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ED1139D07
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732619846; cv=none; b=BMMAlgluu0aXBGP2l2ywx78FK9UR7oBnGFmqbnIyNMSHrkqM4nDWJ4McUy0sU+xm758Nz8XYCpt3mHwolqlbI9AJ8WDtVLLZdCLvyB1bbNC6RS8aqyh+riCHcBLv6JfjtTRn7O/WySPLhOr8zevaspkiAE8eub4QVu+xS3v/7ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732619846; c=relaxed/simple;
	bh=kqlvu0K3mQ9EWSNWavT3PNi2lPgAS12mOlSVFCsVufI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fvEtsMEiDKQ5+SGse1urepaIh6srOWERABGh9lIt6+g/VhtfVMRrH50h44O/hJomZBoofBB1Dq7C5udUBqyFk5Y/cQBD/0QaasCVbaGhx6or+k9MkzPYEiTE0rFxmjoqVXOhJu7o3YQbvmj6wbAsR7BamCgx1TuQVpxqXD/vt4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k0Oum614; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k0Oum614; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k0Oum614";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k0Oum614"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AAF921164;
	Tue, 26 Nov 2024 11:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqlvu0K3mQ9EWSNWavT3PNi2lPgAS12mOlSVFCsVufI=;
	b=k0Oum614mZ9i4uv1kht//PwURMDhjkxVZvA7lE7peIZtqFkt7I0dM3l+hMdcuBwpnzOtIM
	0VWkR4c0OMHs+G3I9MQYv5r7fUnGCkoNMWDZ4qLkdvk8SAbLhx5etl8iUA/FqsTZWvFeyh
	mLPOayf5uxF/ZDR6oY2tkfLEhBUlOyw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqlvu0K3mQ9EWSNWavT3PNi2lPgAS12mOlSVFCsVufI=;
	b=k0Oum614mZ9i4uv1kht//PwURMDhjkxVZvA7lE7peIZtqFkt7I0dM3l+hMdcuBwpnzOtIM
	0VWkR4c0OMHs+G3I9MQYv5r7fUnGCkoNMWDZ4qLkdvk8SAbLhx5etl8iUA/FqsTZWvFeyh
	mLPOayf5uxF/ZDR6oY2tkfLEhBUlOyw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06DBE13890;
	Tue, 26 Nov 2024 11:17:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZYEfAEOuRWcSNwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 26 Nov 2024 11:17:23 +0000
Message-ID: <6304d93aa5e83623d79a1d7e23a8ded6762db40c.camel@suse.com>
Subject: Re: [PATCH 2/3] libmultipath: pgcmp(): compare number of paths
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 26 Nov 2024 12:17:22 +0100
In-Reply-To: <6cd4e709400b0169d745a4f9a25159bd47c44904.camel@suse.com>
References: <20241125143224.51934-1-mwilck@suse.com>
		 <20241125143224.51934-3-mwilck@suse.com> <Z0Tm7AJeGdZs5WIS@redhat.com>
	 <6cd4e709400b0169d745a4f9a25159bd47c44904.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-11-26 at 12:15 +0100, Martin Wilck wrote:
>=20
> IMO my patch is a valid fix for a minor issue which needs redesign in
> a
> future release.

I meant to say:

IMO=C2=A0my patch is a valid fix for a minor issue in a flawed design which
needs redesign in a future release.

Sorry,
Martin


