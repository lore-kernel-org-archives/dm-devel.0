Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8563236938
	for <dm-devel@lists.linux.dev>; Thu, 12 Dec 2024 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021969; cv=none; b=tdlAVuHwLlDVTZe1os0kZY0iM+jCiaq8eWCGzdaE6eaxZk2Yglv9IqXhvUrcJNnVQkMNffn77E8wp5e7qgZ60hCdH0MUSo2DqiVQxXbNQ0lX82ePDiJbwYtRjy+HBYnJwXCI4j08TNVek8jDUpSd76TmOLORGzNdxZ+76g8il1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021969; c=relaxed/simple;
	bh=P6oMbLJnrGLUQUUMuqOqCv+ESf1L23xH3Rcv42SX628=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FIe/OifL2cmECQIFihsKsYkPyFhPi3YqY4MRbzBlZNQq7E96q34W/tbuvvrLOg1aF99QTfZ/2Oeu/Rn3H8z0WiDhtltB47bp/BlJDpNOVfNmQP+7lQGPhWLUjrML2Qz44AbP3gsUpwQX2jFgcQD10sJH543ZQH9F+DGk2RvXu2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ro6rNhFl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jbvfHfHu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ro6rNhFl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jbvfHfHu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C63151F37C;
	Thu, 12 Dec 2024 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1734021964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6oMbLJnrGLUQUUMuqOqCv+ESf1L23xH3Rcv42SX628=;
	b=Ro6rNhFl0OAQiZ+/7HjcN6XNWNR9C0XANa0nyptmaztVrCJQ3VtPLynokSiTtcFol7HALd
	q6SjKa3zBvDrLkXIWHPKWWw6U6u8D8IfsqVrCxjM7nICCGQMRS4GtF32oKqxrIVn3Ll1hL
	vbo7drhe4t6qTWiv4VqfujcDRGgFcpc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jbvfHfHu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1734021963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6oMbLJnrGLUQUUMuqOqCv+ESf1L23xH3Rcv42SX628=;
	b=jbvfHfHuBmQQxvAmo1CtybslY59PibaAZNwvQfyfnDkIuOEcvp/yq3+CgOfdMOnsWML04P
	F/8eYZxLMgL1g5v/rzx53iw6DDwRvNnEo9ex/HlhGolp32gk2swLxv4wMdPdygdRvLtRBG
	9vC1fevQ0HeUpOcAJxnWJGdap8H8Ll4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 927CF13939;
	Thu, 12 Dec 2024 16:46:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0AIsIksTW2eAGwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Dec 2024 16:46:03 +0000
Message-ID: <9c8c2fa621b71e25ec07acb169aa4787d4a8472c.camel@suse.com>
Subject: Re: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to
 hwtable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Jon Paul <Jon.Paul@hpe.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Thu, 12 Dec 2024 17:46:03 +0100
In-Reply-To: <Z1odYq4fnXv-8VZu@redhat.com>
References: <20241205224917.7104-1-xose.vazquez@gmail.com>
	 <Z1odYq4fnXv-8VZu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: C63151F37C
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,opensvc.com:email,hpe.com:url,hpe.com:email,linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_ALL(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,linux.dev:email,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 2024-12-11 at 18:16 -0500, Benjamin Marzinski wrote:
> On Thu, Dec 05, 2024 at 11:49:16PM +0100, Xose Vazquez Perez wrote:
> > https://support.hpe.com/connect/s/product?kmpmoid=3D1014856412
> >=20
> > Just guessing, confirmation from manufacturer is needed.
> >=20
> > Cc: Jon Paul <Jon.Paul@hpe.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

I've already pushed this patch the "queue" branch, as Jon had ack'd it.

Martin

