Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4275114B965
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746180809; cv=none; b=jIMP7a/+WcmLzOF+75Daw7Czos9ng+UMRIK9IShtkOH/n0Po9qlyMc0qIA840aSodfHno7I7+la7ZIiSed1NIdZxqPw8PBu3SxAtAQ3LsxFYjA2/zVceIRzJnLz8fTDDAaySldLe43z9a2oPn6IV3NfbC7fLXZtaGHDq0/gh+88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746180809; c=relaxed/simple;
	bh=7cFtfQfdck01Jsgj3vY7kYq6yK/EBai3ry3aTC3KAjQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RoYcGMUfwNz+vBrF1v4jD+mHdb+b/nhKfz6n/O1P0AF2j4h7qHqWx4nFXrqaUbjOLdMza60SMWfxis4O/fTrMJjcvFkyGGpM2MG3HtwoLsZlOM0OXaCoTB049yYi6nPttq7AE89qKCFIxwQy6ElBJGw4WVlMvdPy73ByxkV1TJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fI6qG+T3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fI6qG+T3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fI6qG+T3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fI6qG+T3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47EBD1F387;
	Fri,  2 May 2025 10:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746180805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cFtfQfdck01Jsgj3vY7kYq6yK/EBai3ry3aTC3KAjQ=;
	b=fI6qG+T3MRXeYL00ZroNPD3GM+Lwn4Y8yp1pqqdmq9N5RTM/qbeJdygsPtVLYqIY77PZzV
	FGlhxTUbLcF030CksmefajO1Q/MZBIunJ8lPM4u+7+7FCa0x3ltBHZL18LuQNhHKNXvxv1
	H/Wbz0a2aSDpZ84We3ofZd3utxZHB5c=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=fI6qG+T3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746180805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cFtfQfdck01Jsgj3vY7kYq6yK/EBai3ry3aTC3KAjQ=;
	b=fI6qG+T3MRXeYL00ZroNPD3GM+Lwn4Y8yp1pqqdmq9N5RTM/qbeJdygsPtVLYqIY77PZzV
	FGlhxTUbLcF030CksmefajO1Q/MZBIunJ8lPM4u+7+7FCa0x3ltBHZL18LuQNhHKNXvxv1
	H/Wbz0a2aSDpZ84We3ofZd3utxZHB5c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B9381372E;
	Fri,  2 May 2025 10:13:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Co8vBcWaFGhdZQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 02 May 2025 10:13:25 +0000
Message-ID: <e80e7e7df2ebd92da296847dacd31eba27d9448e.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: hwtable: change AStor/NeoSapphire
 to work also with ALUA
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 02 May 2025 12:13:24 +0200
In-Reply-To: <20250430134528.82361-2-xose.vazquez@gmail.com>
References: <20250430134528.82361-1-xose.vazquez@gmail.com>
	 <20250430134528.82361-2-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 47EBD1F387
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On Wed, 2025-04-30 at 15:45 +0200, Xose Vazquez Perez wrote:
> Some devices supoorts also ALUA
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
