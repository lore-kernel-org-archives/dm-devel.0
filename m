Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C958B7260A
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752936658; cv=none; b=jixlerjGa49LWg9hszyNJXZtsY2Fg0xUhP2pDtwcZRm4G+1qqPVgd/mvsqveYnmI1t2tBqmKkh6qDCHlYAfSRDq8G/htqhjkWK1qErf7bV9vhmyriczHfqHh3J/PPFB5AT2tqRQt4JsRSRIqoC+ar6vc3E0AV2D/KffUBRN5wl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752936658; c=relaxed/simple;
	bh=1nBUHfOe+a/Wqu0yUu7RYugHdn6VdWwk5T5cZ35mYM0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M8MUTMKFp3wGHxmJm7iWPkCuAkbIwB1eUnv8esD1Qs7TFxMVsHIqN/e7QEmNTgCJcT3Ge4w9Xhf8v+p3sdLl1af0LRwTRxQAOBodbPI+GzZ38hiEmeQb72VLunXWlyg7+fu6G1bM10RwQOAnQ5UfNjdNfHm93oUB2MK/9I36CX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ulu/YTjM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gSZ2g+G1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ulu/YTjM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gSZ2g+G1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EED4E1F76B;
	Sat, 19 Jul 2025 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752936655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nBUHfOe+a/Wqu0yUu7RYugHdn6VdWwk5T5cZ35mYM0=;
	b=ulu/YTjMTtzcRThO7h3C0xMnbo7ajDUOeOLXieIXzP4KXmC6mg2N5W9vm2O99cBpOrSBQ7
	BWAm6m0taS8mmCNquxwot7AzB3Y50Kb7N2LXAJnvKXHb0imgMrq1VnSQexHWe2j1lA5+AH
	yn6ANPan7YloIS53qVERmpjTbeK/sTg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752936654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nBUHfOe+a/Wqu0yUu7RYugHdn6VdWwk5T5cZ35mYM0=;
	b=gSZ2g+G1JmMU1V2nmfmvVJh7DILW2CmeNFAwLau6VF3X0PagiElv7PKz0XfTjNcEVlCdW+
	2dIwCNkT9cnH7HeWCstphqa1hY5YhAJkapAntZd64FvSpBu6fcpNsyNr84N2TrVwj3I0/E
	tR+LKGs+1a6wTuIfBhN8Apq9gBkzgh0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96E981392A;
	Sat, 19 Jul 2025 14:50:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NpBEI86we2gJEwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sat, 19 Jul 2025 14:50:54 +0000
Message-ID: <7176294e034298fc53ff1f9822a2e9d839abae32.camel@suse.com>
Subject: Re: [PATCH v2] multipath-tools: add a comment about DASD arrays
 vendors
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Stefan Haberland <sth@linux.ibm.com>, Nigel Hislop
 <hislop_nigel@emc.com>,  Nigel Hislop <hislop_nigel@dell.com>, Matthias
 Rudolph <Matthias.Rudolph@hitachivantara.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev	
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Hannes
 Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>, S390-ML
 <linux-s390@vger.kernel.org>, DM-DEVEL-ML	 <dm-devel@lists.linux.dev>
Date: Sat, 19 Jul 2025 16:50:54 +0200
In-Reply-To: <20250719134619.331400-1-xose.vazquez@gmail.com>
References: <20250719134619.331400-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80

On Sat, 2025-07-19 at 15:46 +0200, Xose Vazquez Perez wrote:
> vendorid for DASD devices is always identified as "IBM". But EMC, HDS
> (HITACHI),
> or any other PAV (STK (StorageTek), AM1 (Amdahl) ???) array vendor,
> are also
> supported.
>=20
> v2 - remove list of vendors from the comment

I already pushed this (without the vendor list, as you'd suggested
before) to https://github.com/openSUSE/multipath-tools

Martin
