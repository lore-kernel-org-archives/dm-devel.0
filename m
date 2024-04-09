Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8E6130A6C
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712670960; cv=none; b=uDNOzV5H405ATP6I2hvnisTnLvzeFd0T6g3TQCYvbH7hNtPjFVmCcT6UGUeopzOB1LAjSpszt8sujqpEL7iMLsULsC1qtE7X4eXd0NofsKL+evRS7NlRRU1LyF9KJmu74EZ/pDk6s1Q5iLrRMJGqhm4oSfFiqlLODZKOZHfQS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712670960; c=relaxed/simple;
	bh=TP1P+YsLOsTgZobQ/Sxw1VMQvOrMEzWShDz8R/u32y4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kq8XSzpZZFkzVinKZuymFBDTgeZoRG9w/B9LntIL/ngY3+pm/uKLj3e4E/WVZ5BNp+8OXz03tdnotanylM9TzOeHeMDPXjaqtx9jTEns/ZJSM9mjhYigMTHlpeNPL47Zm7fV3k0wNdsUe5+WcofrUHoFVo9OSsgWiy/D37nvhL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fo7WvWnD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fo7WvWnD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fo7WvWnD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fo7WvWnD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D430E33A12;
	Tue,  9 Apr 2024 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712670956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TP1P+YsLOsTgZobQ/Sxw1VMQvOrMEzWShDz8R/u32y4=;
	b=Fo7WvWnDhd1d6GeSVcOXQPVKRgGhWpAWzy4dP6fhKsKXqTb0rD8/DVIsYf5v8E9WhRkdwq
	xpgrzwvm5E5Gr9INPRCT7rsWHO0JEqF5yNfu3J2k45CerJTTkbs9a4UrfCZ7e3NljUalLO
	3CeskMRotXGQFtfhzh8gMSyYQOVuzzM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712670956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TP1P+YsLOsTgZobQ/Sxw1VMQvOrMEzWShDz8R/u32y4=;
	b=Fo7WvWnDhd1d6GeSVcOXQPVKRgGhWpAWzy4dP6fhKsKXqTb0rD8/DVIsYf5v8E9WhRkdwq
	xpgrzwvm5E5Gr9INPRCT7rsWHO0JEqF5yNfu3J2k45CerJTTkbs9a4UrfCZ7e3NljUalLO
	3CeskMRotXGQFtfhzh8gMSyYQOVuzzM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A677E136D9;
	Tue,  9 Apr 2024 13:55:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Li78JuxIFWb0JQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 09 Apr 2024 13:55:56 +0000
Message-ID: <3235505f5f6f5e744cfa2ad4c19c64bacc3731b5.camel@suse.com>
Subject: Re: [PATCH v2 08/11] 11-dm-mpath.rules: replace DM_NOSCAN by
 .DM_NOSCAN
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 09 Apr 2024 15:55:56 +0200
In-Reply-To: <ZhQ7yrm3jfG4v4zc@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
	 <20240404173814.3143-9-mwilck@suse.com>
	 <ZhQ7yrm3jfG4v4zc@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.58 / 50.00];
	BAYES_HAM(-1.28)[89.87%];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -2.58
X-Spam-Flag: NO

On Mon, 2024-04-08 at 14:47 -0400, Benjamin Marzinski wrote:
> > =C2=A0
> > +# device-mapper rules v2 compatibility for 13-dm-disk.rules
> > +ENV{DM_UDEV_RULES_VSN}!=3D"3", ENV{DM_NOSCAN}=3D"$env{.DM_NOSCAN}"
> > +
>=20
> You missed a DM_UDEV_RULES_VSN change here.

Thanks!

Martin

