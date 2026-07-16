Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A163F1ABF
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 08:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191387; cv=none; b=DsZ3dEBKMYtWBE+BGtDBnzMoSXg4MZVqfsheejI4Zptb/x0EAz4r0igjRzJBwucEQvtSm51toeoFuqXCVEVSqpNH/4hlrKNZV10RhMeiSMt8n8pB0Y/MaDpkvuGZq8gNOlcWSeLrQkeSJPW1GAaviRv+8bHKQj1bb4qjPQrfQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191387; c=relaxed/simple;
	bh=bjaDDjLBjQWb/0JPpjg/bD0rxErItnlw/ctiyN+So7c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HPGivndJG2Y+WIQaRtvIRcbbIY6hAPVAMj3gXrx3oRqOTNtDS9OdkExTORGThAWK9zjwSDvx8wX/hMQZxtVkeFZ0Wouz6lQ/PXkM9U4dywVQIer2dPtFGZgUXmxIR7MsoToIHgmup8qG9mZSk1LbG0KBNcCHJvkeBwGEp1pqLcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CzEsrQ7h; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CzEsrQ7h; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CzEsrQ7h";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CzEsrQ7h"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F06378883;
	Thu, 16 Jul 2026 08:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784191379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjaDDjLBjQWb/0JPpjg/bD0rxErItnlw/ctiyN+So7c=;
	b=CzEsrQ7hRpw68V4D83WuFa/qBf06JpOvXHYmxcUi/U9tZ1RSxpXiyPgaBenUiwLN9QQMfP
	emKK0gAIPQoNhM37ArD1OQjFhtskWzO1Fi3wnkq8vf234alMGxC+JQTZ+F9s0rWOE41ahS
	rgW8bdzRB1JEX/BZU9uO4T7YO3vihXI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CzEsrQ7h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784191379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjaDDjLBjQWb/0JPpjg/bD0rxErItnlw/ctiyN+So7c=;
	b=CzEsrQ7hRpw68V4D83WuFa/qBf06JpOvXHYmxcUi/U9tZ1RSxpXiyPgaBenUiwLN9QQMfP
	emKK0gAIPQoNhM37ArD1OQjFhtskWzO1Fi3wnkq8vf234alMGxC+JQTZ+F9s0rWOE41ahS
	rgW8bdzRB1JEX/BZU9uO4T7YO3vihXI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2779E779AD;
	Thu, 16 Jul 2026 08:42:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gLqSCJOZWGo0ZgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 16 Jul 2026 08:42:59 +0000
Message-ID: <09208d1582bf36a58f09ac78b20050fa8d793aa6.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <mwilck@suse.com>
To: Cykang <cykang4830@gmail.com>, dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Jul 2026 10:42:58 +0200
In-Reply-To: <33a65ffb59df981e93d9eb638249dc77fdabf38f.camel@suse.com>
References: <20260711033107.2318-1-cykang4830@gmail.com>
	 <33a65ffb59df981e93d9eb638249dc77fdabf38f.camel@suse.com>
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
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3F06378883
X-Spam-Score: -4.51

On Thu, 2026-07-16 at 10:41 +0200, Martin Wilck wrote:
>=20
> So IMO what we should do is simply resume and return in
> preempt_self()
> after the above command if we don't hold the reservation, which we
> should check using check_holding_reservation().

... and we also need to clear mpp->reservation_key.

Martin
