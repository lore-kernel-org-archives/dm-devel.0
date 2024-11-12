Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870CE20B212
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400916; cv=none; b=h9MjavsWf3Fb7adRD7cF2mnRZC8XMihIMJZUkf2TWmKgSJSbUblsGffw8FeNC5OK7nBDh+wn4NhotaFR1OFAXvVFtNREVNbTvlgSrMuyxiMo7dXrflri869C/3brMhCovf+MGtK6VUBVgXaFdInzztrOlF1PymDe4FdO+f1BTJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400916; c=relaxed/simple;
	bh=/J0h5cDNK1At/SqbtUwRe0uWXhjGM4bpxD7wevo/Kc4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MWalPLa4NCeO5rn+xXwSDToKY8Mh82JLBEuPNPSi13Blr7AWZ724q7VMP1HhWTT6rREP0y6+tQPU3WG1Kytar6WFy6qV4VksjU/UMpi5skgmGhjHlSh/e24cdmNeoufG+q6gMBKsgEVJdwHg7VbZrXHQvGojpcT6y7yerOCOgtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pYNlQlTV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pYNlQlTV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pYNlQlTV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pYNlQlTV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AC4111F396;
	Tue, 12 Nov 2024 08:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731400912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/J0h5cDNK1At/SqbtUwRe0uWXhjGM4bpxD7wevo/Kc4=;
	b=pYNlQlTVP0RT3ODJMy6wab67x5kPHNCnxmLFyQLqXnmphj2AQW9kxVmfMbkSDLOGQb/91j
	/ShCsY9SOMCpmA4k/9s14HXan2lgpmozst1g3BtooA4hfLUi+YSQaaosx4F2Y8T5nKYiG6
	JAiUNKHUTTTwq38wJ2Z6nMKTVQ5JDZ8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731400912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/J0h5cDNK1At/SqbtUwRe0uWXhjGM4bpxD7wevo/Kc4=;
	b=pYNlQlTVP0RT3ODJMy6wab67x5kPHNCnxmLFyQLqXnmphj2AQW9kxVmfMbkSDLOGQb/91j
	/ShCsY9SOMCpmA4k/9s14HXan2lgpmozst1g3BtooA4hfLUi+YSQaaosx4F2Y8T5nKYiG6
	JAiUNKHUTTTwq38wJ2Z6nMKTVQ5JDZ8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F88C13301;
	Tue, 12 Nov 2024 08:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J+aGHdAUM2dTDQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 12 Nov 2024 08:41:52 +0000
Message-ID: <90880b0f6cbf613b11508cd2ce2d9d018897229a.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: refresh fsf licences
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Tue, 12 Nov 2024 09:41:51 +0100
In-Reply-To: <20241108094015.383481-1-xose.vazquez@gmail.com>
References: <20241108094015.383481-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Fri, 2024-11-08 at 10:40 +0100, Xose Vazquez Perez wrote:
> Old licences have been modified, because FSF postal address was
> changed:
> https://lists.gnu.org/archive/html/info-gnu/2024-09/msg00000.html
> https://www.fsf.org/blogs/community/fsf-office-closing-party
>=20
> https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
> https://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
> https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

