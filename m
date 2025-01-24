Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF11DD520
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 21:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737754435; cv=none; b=GOwiXQRzOWE9CNeAfBv0mAxFtfFh72kWsu+IhvY6+oEA3816bY0KnrCwMYI/JqY7KGYNJ6O2s1hTk6e9vb4yncaUakSrbl3oQ7BhpDiHEcbsamWzu/ThaH0pMlMvTTdjCiNy2htoLDLIdooGN6zexfUALf2JwQJz/UuAPlyg9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737754435; c=relaxed/simple;
	bh=fnvdKhvI/bwbSGkqtK3JmZ0MW/RgQCg1rRF5OjWoj9M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MUWE+tQNoN19T2Nu7WKSVpmkXXjfwhmbzXmUEeMiH9m5ZU/yr+Dwba2NSh3h7eJFH+92gXWBUBOEz4wSPdXp56VB5dYJK/FaLMuTEGzgbaY3y0I4HBxZ0tL/5xepHo9g1vSIxbkW/fkFenjLY6oQbCCZdJrIB0x2ExOwJVP2kQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iMCegQJ7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iMCegQJ7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iMCegQJ7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iMCegQJ7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1130D1F443;
	Fri, 24 Jan 2025 21:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737754431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fnvdKhvI/bwbSGkqtK3JmZ0MW/RgQCg1rRF5OjWoj9M=;
	b=iMCegQJ7T48H06ALWLy6IkzqcWJ21XiYFRzaAA6D8ihmotc6krQpu3CVz00qMbbAXEKdgk
	6UuNpvY9C/ISUH2hLotrv2pF3RFRQsjvvUUdPvBNz3laGYXCp7FmrzMXYu0cYseXzdD4ny
	GCYSMo9s/q8dlPl4baRQILwmCLmeO3o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737754431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fnvdKhvI/bwbSGkqtK3JmZ0MW/RgQCg1rRF5OjWoj9M=;
	b=iMCegQJ7T48H06ALWLy6IkzqcWJ21XiYFRzaAA6D8ihmotc6krQpu3CVz00qMbbAXEKdgk
	6UuNpvY9C/ISUH2hLotrv2pF3RFRQsjvvUUdPvBNz3laGYXCp7FmrzMXYu0cYseXzdD4ny
	GCYSMo9s/q8dlPl4baRQILwmCLmeO3o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBE17139CB;
	Fri, 24 Jan 2025 21:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 94TXMz4HlGfdagAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 24 Jan 2025 21:33:50 +0000
Message-ID: <d266e648a153a2b7dd6bdbd764c18c5a414ff77c.camel@suse.com>
Subject: Re: [PATCH] multipathd: trigger uevents for blacklisted paths in
 reconfigure
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 24 Jan 2025 22:33:50 +0100
In-Reply-To: <Z5QAgyfmjl5XXCKO@redhat.com>
References: <20250123221212.123833-1-mwilck@suse.com>
	 <Z5QAgyfmjl5XXCKO@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, 2025-01-24 at 16:05 -0500, Benjamin Marzinski wrote:
> On Thu, Jan 23, 2025 at 11:12:12PM +0100, Martin Wilck wrote:
> > If multipathd has already configured maps, and the user changes the
> > blacklist or other parameters that cause currently multipathed
> > devices to be skipped, and then runs "multipathd reconfigure"
> > or restarts multipathd, multipathd flushes the maps in question,
> > but doesn't trigger uevents for the now-blacklisted paths.
> >=20
> > This is because the blacklisted paths are removed from the
> > discovered
> > maps internally when update_pathvec_from_dm() is called through
> > map_discovery() and update_multipath_table(); when later
> > trigger_paths_udev_change() is called from coalesce_maps(), the
> > map contains no paths for which an uevent could be triggered.
> >=20
> > The map_discovery() code flow is special, because we will call
> > coalesce_paths() afterwards anyway and reconstruct the mpvec.
> > Unlike the
> > regular code flow, we don't want the maps to be "corrected" in this
> > case, because the maps discovered here aren't going to be reloaded.
> > We just want update_pathvec_from_dm() to populate the pathvec.
> >=20
> > Therefore add a new flag DI_DISCOVERY, which is only set when
> > update_multipath_table() is called from map_discovery(), and if
> > this flag is set, keep PATHINFO_SKIPPED paths in the map's table in
> > update_pathvec_from_dm(). Later on, the paths will still be visible
> > in the old mpp (ompp) in coalesce_maps(), and uevents will be
> > triggered for them to release them to systemd.
> >=20
> > We can't always do this for PATHINFO_SKIPPED, because in some cases
> > paths may be accepted in a map first and SKIPPED later (for example
> > if
> > the WWID wasn't yet available at startup). Therefore the special
> > case for DI_DISCOVERY is necessary.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks ... I just realized that this patch doesn't apply on "queue"
because I had written it on top of some other work I was doing on my
"tip" branch. It can be easily rebased though.

Martin

