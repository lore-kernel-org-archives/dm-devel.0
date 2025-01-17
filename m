Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C31FF7D5
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737122097; cv=none; b=oTmaTppoScFuaH4TLqwaYimR+mp73YPkKIo+fPL5+gL3wwn4LaGSaKjihxPG/k+aeWzZyMtqpoJjwcNbFyGax7OtSq/jwTr6BWicIV7WcUs57eU8RYDcXh/l9jky78AaU9sJOxe1rvwWAs3F/gNlzxQxBNPlvgiZt6gvtqubc2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737122097; c=relaxed/simple;
	bh=JFsGie3jDd9wOt+Pxs6z0nJDuFkQ/eBWwzZ3sxGKWrk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PlyK0LE3zw0CjtunaqUpTu2zxDa8cv1i+Cfq4KR6FCs1uvw3tlF9svF0+sPRhjQv7hy2yGXZ80B8AH44rwQTx2Es9JG9vTQMeSuS7hb4VtIujbV66fRfl8x7/vumP8qoBwHju3fJgsy5jtdh63ixed7CP+jsBkPVXgIPAVh0z2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aBr1gjH+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bVgpSyX2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aBr1gjH+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bVgpSyX2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E611821181;
	Fri, 17 Jan 2025 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737122093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFsGie3jDd9wOt+Pxs6z0nJDuFkQ/eBWwzZ3sxGKWrk=;
	b=aBr1gjH+GEmolGmPHd6nmG6nExKelGgfdlEUNVmLvVrlXtkuKF05kzBBQrwicjxr3BjZGX
	CbrCTRbCbcbjJjL6dAdvFu1k5n2JHyQWrzviX/kNh9zSQ19qqVrNsb5YVoVk66T7NLqJle
	FWJ4wIFIoMCBgARhggWoeAm/pF80Edw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737122092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFsGie3jDd9wOt+Pxs6z0nJDuFkQ/eBWwzZ3sxGKWrk=;
	b=bVgpSyX2tizUuorRO5rQ5NLSyctEMxQU0hlJaeNn0F+r3UToSJlN7+dgRi6CF/F2K5snwA
	i8PocMPoZVd7OUoy4PRq5UMOnnqUoHjFyrCs64xaBejSJeJpsg5uDY22Q7IkO0Yw7ODET0
	yzdnA4IyMeCifyXTb2/hwoLbxnuCDnQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC6A2139CB;
	Fri, 17 Jan 2025 13:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XU6LLCxhimeaZwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 17 Jan 2025 13:54:52 +0000
Message-ID: <5a2e75c50ce9d9e639f60377481adf6bf116460f.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: Merge Infinidat with Lenovo in hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 17 Jan 2025 14:54:52 +0100
In-Reply-To: <20250116230427.17740-1-xose.vazquez@gmail.com>
References: <20250116230427.17740-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-1.89 / 50.00];
	BAYES_HAM(-2.09)[95.57%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -1.89
X-Spam-Flag: NO

On Fri, 2025-01-17 at 00:04 +0100, Xose Vazquez Perez wrote:
> Lenovo to acquire Infinidat:
> https://www.infinidat.com/en/news/press-releases/lenovo-acquire-infinidat=
-further-expanding-enterprise-storage-portfolio
>=20

Does our hwtable have to reflect company acquisitions?

Martin


