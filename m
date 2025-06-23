Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E499226CF0
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 08:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750668483; cv=none; b=h+wp8jId2mNUJkNXglP/59oBx4nc9rX/lKvw45XxemgC1YwbfPn2ijBpK++oTuK7x+dsB76E5UH6C7SlxD/Z0rmenKoS/Foy3n2DRQNsKVwlHiSd94ekr6SoEqV3Y7+C2AvI9dWKMECQxn8jH+fgQLEF2Qzgcg95Wkm5XYytTSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750668483; c=relaxed/simple;
	bh=WF5A2txiNmF64+W+yONxw4ppw1eUR0McrKFU8myrDlU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pXZO7VfLHj5U0NNmdojzTOE0eHnVkpx2fLi0jeKkpqt+ztc6uv8fNqFMQ7VUEJ213WiZH4CmfNiIIlY0mzFD8et1PDx9bXp1FXgxp3Cpl0RbfnmN/bvYCuM7wf2kOzb5+QvxAbH/Up6ZluM3+1d0ZzNUMyGijHLewfqM8UwUk3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tCxf3lzM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tCxf3lzM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tCxf3lzM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tCxf3lzM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 30B4C21186;
	Mon, 23 Jun 2025 08:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1750668479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WF5A2txiNmF64+W+yONxw4ppw1eUR0McrKFU8myrDlU=;
	b=tCxf3lzM+PDvGhw3tITc/WesQxdlsw77t5T2GUVyJans/Q8XLnkgBbLe/Fk+/fALDjvt3o
	JptN2CZcRziiGv++4B4Bv/HGZg5CtOFSnDRfzFn0IgVleJTOZedsxGg5Ew4H5i9n3i/bGg
	yHRtQMnitNf35jfQh3RKyKytWGGoEcM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1750668479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WF5A2txiNmF64+W+yONxw4ppw1eUR0McrKFU8myrDlU=;
	b=tCxf3lzM+PDvGhw3tITc/WesQxdlsw77t5T2GUVyJans/Q8XLnkgBbLe/Fk+/fALDjvt3o
	JptN2CZcRziiGv++4B4Bv/HGZg5CtOFSnDRfzFn0IgVleJTOZedsxGg5Ew4H5i9n3i/bGg
	yHRtQMnitNf35jfQh3RKyKytWGGoEcM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04F6313485;
	Mon, 23 Jun 2025 08:47:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cs8zO74UWWiqegAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 23 Jun 2025 08:47:58 +0000
Message-ID: <0a67db0f805d01c0648265b7b63122f1e1417dd9.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: remove extra hyphen from GCC std option
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Mon, 23 Jun 2025 10:47:57 +0200
In-Reply-To: <20250623070514.203888-1-xose.vazquez@gmail.com>
References: <20250623070514.203888-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,gnu.org:url,opensvc.com:email,linux.dev:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Mon, 2025-06-23 at 09:05 +0200, Xose Vazquez Perez wrote:
> https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html#index-std-1
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Thanks!

Reviewed-by: Martin Wilck <mwilck@suse.com>
