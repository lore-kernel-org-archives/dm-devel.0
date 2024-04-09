Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD50012FF63
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712672067; cv=none; b=hb/bsW2rWKc4qFVNatp5jJBiIsgxreCjvrwBzCn/ICAgO1kRtSAFyWnP393iQJTGMhbQ0jh9YoUuM3Ve4ngDHxFdb1oxP/QETLzHtlZhwwgsfx8tybwAbFp77h0qu5S6YpDAbbAFyo3Rhpg9i1pryJ8E+2ZIDirHzHbMjAFRkdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712672067; c=relaxed/simple;
	bh=QIfpGm7J+WwfFlL9gy1QTIfDuvzdoXCEml7Xxpg0MCk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IuGuUVS1GLgIVPc7OwZ6ZT0U+bKvtBO81PdrOlMltKmWYXTUNcms6gHPb1ndQPdv/06M/hB/k8vCswY+m+7dCpa6PKoYpsyD1qmKfdHtsWQK15H+4uVsAyyTaLCTEPBtqfOxyUtg8UxBFJsOF94KXPgXqmuP/9evdYO3hOw8WhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ue245Bj2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ue245Bj2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ue245Bj2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ue245Bj2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C5A5B20A38;
	Tue,  9 Apr 2024 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712672063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIfpGm7J+WwfFlL9gy1QTIfDuvzdoXCEml7Xxpg0MCk=;
	b=ue245Bj2pifFhnc88aH5dM5oVSieiBf9WNegwGzFAG9evy+w1sYN75sQsDcvxAC7v9n+qM
	+REOWHpgTkRxajS0CmyCsFCvBsuyULPL0frRYYpEIi+YJ9sdL4JFtwbhA5OLcSuDn6Hxzn
	s9Vm+DS1BAPqapmUqatrJDB24wGgwGE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712672063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIfpGm7J+WwfFlL9gy1QTIfDuvzdoXCEml7Xxpg0MCk=;
	b=ue245Bj2pifFhnc88aH5dM5oVSieiBf9WNegwGzFAG9evy+w1sYN75sQsDcvxAC7v9n+qM
	+REOWHpgTkRxajS0CmyCsFCvBsuyULPL0frRYYpEIi+YJ9sdL4JFtwbhA5OLcSuDn6Hxzn
	s9Vm+DS1BAPqapmUqatrJDB24wGgwGE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B566136D9;
	Tue,  9 Apr 2024 14:14:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IatGID9NFWZbKwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 09 Apr 2024 14:14:23 +0000
Message-ID: <4a439f1cd43860de587de64f89def83bed495b10.camel@suse.com>
Subject: Re: [PATCH v3 00/12] multipath udev rules changes for dm rules V3
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 09 Apr 2024 16:14:19 +0200
In-Reply-To: <20240409140813.26774-1-mwilck@suse.com>
References: <20240409140813.26774-1-mwilck@suse.com>
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
X-Spamd-Result: default: False [-2.17 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	BAYES_HAM(-0.87)[85.69%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -2.17
X-Spam-Flag: NO

On Tue, 2024-04-09 at 16:08 +0200, Martin Wilck wrote:
> This patch set adapts the multipath rules to the pending changes
> for device mapper rules that update DM_UDEV_RULES_VSN to 3, and
> applies some additional clean-ups to the rules files.
>=20
> Changes v2 -> v3:
> * 08/11 replaced another UDEV_RULES_VSN test (Benjamin Marzinski)
>=20
> (not resending the patches that have already been acked by Ben)

There is no patch 12 in this series. Sorry for the mistake in the
subject line.

Martin

