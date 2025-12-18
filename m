Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA531F7098
	for <dm-devel@lists.linux.dev>; Thu, 18 Dec 2025 23:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766101209; cv=none; b=uWhLSgdxxBRV9e+mdRQtCP3HbQdKIf9FPNquT+UN4OAp9aFAPFWtbUHPuhf5zq70o/Q8Cqvvs1L1St/+jJf9r4Jr7LOskA3cV6UaO9PexrcDZ9ufPAU1jrVvJbE4lrJn7y2tW6YDuHlGz+LWATmY0eYue7HXftIpQt0RCMF5CtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766101209; c=relaxed/simple;
	bh=9NMZBd7c2rtTUZrxo/MRL8d3Uo1YU0nyUmUjJgXqtKg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QMeKf6XouHq18sEDhdBAf8slCWpN61R1l5bWl4Opvli9/tMw596tiRzq5mlulQs3sQnE32PXgY0Hxx31heYpRgTlW1hNE//t4pIjt7orCllCPP1EPWUXwSIh6IT+hg0uvblsEjBVQ/CHHkF0oHo8SfucyEgfVIOhHq52o0105ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u83krIUk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u83krIUk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u83krIUk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u83krIUk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01B5B5BCFB;
	Thu, 18 Dec 2025 23:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766101203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NMZBd7c2rtTUZrxo/MRL8d3Uo1YU0nyUmUjJgXqtKg=;
	b=u83krIUkRlXB/8MDryXHSI/FRmMiFXggxlZrKb+g88OV87vs/+DWo5daYlXW49CDz5+eE9
	ETyM2eYGWDrHMQHZxYM5t0FWUZ9n86ZqRV9ehgZHaJcxAGX75HyAQWigdC+dqD7fdm7Hye
	cRI5UjCPH+HtZ30GBoPJIp9w6+2Omsc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766101203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NMZBd7c2rtTUZrxo/MRL8d3Uo1YU0nyUmUjJgXqtKg=;
	b=u83krIUkRlXB/8MDryXHSI/FRmMiFXggxlZrKb+g88OV87vs/+DWo5daYlXW49CDz5+eE9
	ETyM2eYGWDrHMQHZxYM5t0FWUZ9n86ZqRV9ehgZHaJcxAGX75HyAQWigdC+dqD7fdm7Hye
	cRI5UjCPH+HtZ30GBoPJIp9w6+2Omsc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D654B3EA63;
	Thu, 18 Dec 2025 23:40:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m1HrMtKQRGl2fAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 18 Dec 2025 23:40:02 +0000
Message-ID: <180473d754981a358e9a65fb439295238b755916.camel@suse.com>
Subject: Re: [PATCH 03/21] multipathd: free paths in checker_finished()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Dec 2025 00:40:02 +0100
In-Reply-To: <aUSPcsNAzvD5rj4M@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
	 <20251217212113.234959-4-mwilck@suse.com> <aUSPcsNAzvD5rj4M@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.25
X-Spam-Level: 
X-Spamd-Result: default: False [-4.25 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.15)[-0.753];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]

On Thu, 2025-12-18 at 18:34 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 17, 2025 at 10:20:55PM +0100, Martin Wilck wrote:
> > Modifying the pathvec in a deep call stack is unexpected and
> > error-prone. Free paths in the checkerloop instead, after
> > having synced all maps.
>=20
> I'm not fond of the fact that this leaves paths around, when callers
> expect that the path will be removed. For instance, right now
> cli_add_path() and uev_add_path() can call ev_remove_path to handle
> INIT_REMOVED paths, and expect that success means the path is
> removed.

Thanks for pointing this out.

> They can end up storing duplicate paths with this code.

I'm not sure if that really hurts, as long as multipathd basically=20
ignores INIT_REMOVED paths, and eventually frees them. But I agree that
it's awkward and should be avoided if possible.

> What do you think about having calls to ev_remove_path() actually
> remove
> the path if multipath device successfully orphans it.

Sure, that should be possible. I'll think about it.
I just want to stop removing paths somewhere deep in the stack.

Thanks,
Martin
