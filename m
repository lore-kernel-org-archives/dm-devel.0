Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CF883F
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536866; cv=none; b=DdT+sG5hC317CWaePJZ63VGQoA9lFOpIl4V+YyYxRkLAPzZizOHD09W5VCs4A2JAqr49O0OtrbJczDk7bfewTYaqSAuCNDnCa1eoZi84Wtl1C2PY+1GPNAGV9prTn+cadZ1dJf6p4alPgMPff9Mo6eN9CH224KugXbFIIjP18IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536866; c=relaxed/simple;
	bh=9vGdxVNaTHAlheHKY0/lhtp8XrTgpIVWUz0tJIGmebw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eec42C1lXcYRxGYV8ga0wwf/8Rmy8D4FWU7V2owab+lDWT4EhJtC2fPU2W8XHnoUYSNq0yeKMAMtT312fNDlz/wZis76TPX9cKX++ImWsOGfdWg98cmv40xF0jvhUX4kCMHVeoxDhUhSBX/rylF/S/3DqLD9sl4y8PK0OhGoZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WXxFlXxi; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WXxFlXxi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WXxFlXxi";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WXxFlXxi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A365B3E09;
	Mon, 20 Jul 2026 08:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784536862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vGdxVNaTHAlheHKY0/lhtp8XrTgpIVWUz0tJIGmebw=;
	b=WXxFlXxikBkMv1qzh3XC3cIAyemOybYqTdTmSxfQMEy57ZNLYf2e8PyzYCQK9HfHauW06b
	X1YfcyckESIOk6VuU3efco4SIIKLFZN8jqAcaHskxGkbSrPWMk9xS8QqNAavURkIeI/9Ez
	yQNACqgBchCPfmns8AcMgr74WaTERhA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WXxFlXxi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784536862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vGdxVNaTHAlheHKY0/lhtp8XrTgpIVWUz0tJIGmebw=;
	b=WXxFlXxikBkMv1qzh3XC3cIAyemOybYqTdTmSxfQMEy57ZNLYf2e8PyzYCQK9HfHauW06b
	X1YfcyckESIOk6VuU3efco4SIIKLFZN8jqAcaHskxGkbSrPWMk9xS8QqNAavURkIeI/9Ez
	yQNACqgBchCPfmns8AcMgr74WaTERhA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DD17779AA;
	Mon, 20 Jul 2026 08:41:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hTKZHR7fXWovdAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 20 Jul 2026 08:41:02 +0000
Message-ID: <f6054dd1579a59b7771cb5c12f3f206a4d67e165.camel@suse.com>
Subject: Re: [PATCH tip] multipath-tools: iet prio; update header comments
 and style
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>, Benjamin Marzinski	
 <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
  DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 20 Jul 2026 10:41:02 +0200
In-Reply-To: <d273e9ae-4a32-42cd-b204-a61a6f030bef@gmail.com>
References: <20260717111512.63662-1-xose.vazquez@gmail.com>
	 <d273e9ae-4a32-42cd-b204-a61a6f030bef@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A365B3E09
X-Spam-Score: -3.01

On Fri, 2026-07-17 at 13:27 +0200, Xose Vazquez Perez wrote:
> On 7/17/26 1:15 PM, Xose Vazquez Perez wrote:
>=20
> > Update the header comment to accurately reflect that the device IP
> > is now
> > obtained from udev's ID_PATH property.
> > Additionally, move the header comment block to the top of the file,
> > remove
> > redundant empty comments, and convert style to c++.
> >=20
> > Cc: Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> > =C2=A0 libmultipath/prioritizers/iet.c | 65 +++++++++++++--------------=
-
> > -----
> > =C2=A0 1 file changed, 26 insertions(+), 39 deletions(-)
>=20
> TODO: update multipath/multipath.conf.5.in

Yes, I already communicated that to Arnaldo.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
