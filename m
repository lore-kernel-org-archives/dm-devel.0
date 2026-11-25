Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606599;
	b=rKDKJ9nF+cVJ4pgSMy5xb3GfWIV1/HaH5+G740AWUqCSAg5lmQ/ZMopVcRPD41QCKmm+
	 Sa3HsQwz8IVxXqSn+NJsubPWDuegA0QmUR30nNgUbzKaW42UHKaB8gFlXkM+LUfAELmgm
	 Xra4G/qD7yPIj4aeIDQsBnc5scovMHQPH7ZBOWfeds2MaFSJ8zGm5h45eA0FSdAJ4JtJu
	 Q0ZQIAAWx6cpPRNRClZ1tqZZ+bqwctT45DsRNwLNY58KcTIO+6npzDrCf+sBXAGfXfzkq
	 tf7vqV0/3LTCPIKHoVUuUXKqweQSZsLL6HUVaBx/iL9QXGTLeXkpYqm4ol8r9qfAEiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606599;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=sLmZBMAVmmaJw67QCxAYxx8WC+tzLZE8eqkkhiO5ocY=;
	b=b72dF3HMKYNZjHs34gPSHH2EZp6NfAtr8fwOK2haIQ6yk96t8O5x0K2oNPfK33B+py/b
	 6MYu0/k6O8v8Vntiag9MNsX9U+R8jAK94EfyBSERGXhbp7afjPpyoilzuUFfG5PsnegYU
	 pWkSq2Vwd8l9eNovudMuD1WTSaq3zYFyJiAvSQGQkQ5QR7zJQMv54kBcnvV9y9rL1R8ns
	 3B7YoOYvcax0jyPORgBi5LNM+Jtx+nUej6L5KPkvP8Eq8C8zCdsckoIwk83XuFANf4XVM
	 WeJedYd1AiMY+ROicvF4J+VLWCYd33Gnzr71x9rKBmI3Y5T2UwTcX+juLDDhiRApcTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="GYdVXU/n";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="GYdVXU/n";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D15606A323
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 11:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3D15606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GYdVXU/n;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GYdVXU/n
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE51B22113;
	Wed, 25 Nov 2026 11:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795606596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLmZBMAVmmaJw67QCxAYxx8WC+tzLZE8eqkkhiO5ocY=;
	b=GYdVXU/ndjHFyNqB1YaDezxIj2SelFxr7WFMebEQed57res1bJLlNqMBb73FtW1BOuAJKO
	zxOrKLiYtZZiIABI6ms375TG1sIpaXZwB6eWnUqqvnN7gfZYlDyYGQqgUwxxnlPMyY8Tr4
	UswykJ84lNQnFK8Bl3V/8waFGwqRh6w=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795606596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLmZBMAVmmaJw67QCxAYxx8WC+tzLZE8eqkkhiO5ocY=;
	b=GYdVXU/ndjHFyNqB1YaDezxIj2SelFxr7WFMebEQed57res1bJLlNqMBb73FtW1BOuAJKO
	zxOrKLiYtZZiIABI6ms375TG1sIpaXZwB6eWnUqqvnN7gfZYlDyYGQqgUwxxnlPMyY8Tr4
	UswykJ84lNQnFK8Bl3V/8waFGwqRh6w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D5C31339F;
	Wed, 25 Nov 2026 11:36:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RWInHUTIBmteLwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 25 Nov 2026 11:36:36 +0000
Message-ID: <89db7e4d1245afe989c69163fd940335ff8db9a6.camel@suse.com>
Subject: Re: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc
 WARNINGs
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM_DEVEL-ML
	 <dm-devel@lists.linux.dev>
Date: Wed, 25 Nov 2026 12:36:36 +0100
In-Reply-To: <e35c05f4-e5d4-4394-b4a0-7222d3bb0753@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
	 <20261113125549.504780-2-xose.vazquez@gmail.com>
	 <avt3vc307mk4FHZK@redhat.com>
	 <ac29a29d-9932-495a-b75f-1fe4fe7948c7@gmail.com>
	 <av80EsBawOfxfHXK@redhat.com>
	 <e35c05f4-e5d4-4394-b4a0-7222d3bb0753@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email];
	FREEMAIL_TO(0.00)[gmail.com,redhat.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

On Wed, 2026-11-25 at 11:24 +0100, Xose Vazquez Perez wrote:
> Restoring the previous layout, as I think it reads better.

Thanks. I'll apply this as a fixup (with your authorship and s-o-b), as
I have already applied your series to the "tip" branch.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
