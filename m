Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43DD2773E9
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766140733; cv=none; b=U43lXJfsZo8AV25Z1I2K93anNKKr38wri/pc5OlMTemnlgocQ+kopmnHuF1Iu39vZURrc+jmGfUxXUWKBJsrAhLGq9yCh5LYrA+hALsEM25H1uF8FM3N5nF+6muhmQXpcumPAp/PA/Kbl/2HPjbmb5RZXvN23BeVRRWGt+o49mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766140733; c=relaxed/simple;
	bh=SbJrwSwPpynknUoIcbBxAQIbSlVgDHawZPrRSrYFhU8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wrj6R6ephQ9IOjKu6eVIEVM4je1ECRB2DWfCyn8J28KOhaQIko8Ze7wd1YiWWxxwvkCD8tRQDz/YV+rXPwidL9+Abamj7/JV1YIZG9enDJwy11cwU7+4CeA4uNNoSx43PD2J5fvYjNYoeXhxqY/AtSExACLDlHW7V6p2P1BEWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=klUz+Xat; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NjEd6fTO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="klUz+Xat";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NjEd6fTO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48375336B8;
	Fri, 19 Dec 2025 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766140723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbJrwSwPpynknUoIcbBxAQIbSlVgDHawZPrRSrYFhU8=;
	b=klUz+XatLbSHyoabZ4ULF6EROULoxucalG5istiBg7bNA1u6R1nwaRSMNHTmvGQ/8MgSUP
	q3ygXDVdVQUbJiNEebtoZ9b/27HF1Odes9vUPqdE8kQiI5eTAddLmlfqJIGbx8AdZfi+QI
	Ozf4gcb64xYcBi60tdj8VDBga+KhOt8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NjEd6fTO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766140722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbJrwSwPpynknUoIcbBxAQIbSlVgDHawZPrRSrYFhU8=;
	b=NjEd6fTOjk/UhfjQaukRJh4FX0i737IngebwZI0flTQjmLqbe2d3hyFkVcIyIpBbrFReWm
	Kb02kOlMxF+J5fJsWdz+PxO/3ttbC4qoOK+AcI+9+VLsJ1U3OOSv4Cfz7hWdrriFVzB7pA
	HZUyJIR+WzAutO+Qhmg/A/VgNSzO9lg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F64B3EA63;
	Fri, 19 Dec 2025 10:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t7OiBjIrRWlqDwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 19 Dec 2025 10:38:42 +0000
Message-ID: <9414610a0245004fa82e8d6c6fbf168f94956f02.camel@suse.com>
Subject: Re: [PATCH 03/21] multipathd: free paths in checker_finished()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Dec 2025 11:38:41 +0100
In-Reply-To: <180473d754981a358e9a65fb439295238b755916.camel@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
		 <20251217212113.234959-4-mwilck@suse.com> <aUSPcsNAzvD5rj4M@redhat.com>
	 <180473d754981a358e9a65fb439295238b755916.camel@suse.com>
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
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 48375336B8
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Fri, 2025-12-19 at 00:40 +0100, Martin Wilck wrote:
> On Thu, 2025-12-18 at 18:34 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 17, 2025 at 10:20:55PM +0100, Martin Wilck wrote:
> > > Modifying the pathvec in a deep call stack is unexpected and
> > > error-prone. Free paths in the checkerloop instead, after
> > > having synced all maps.
> >=20
> > I'm not fond of the fact that this leaves paths around, when
> > callers
> > expect that the path will be removed. For instance, right now
> > cli_add_path() and uev_add_path() can call ev_remove_path to handle
> > INIT_REMOVED paths, and expect that success means the path is
> > removed.
>=20
> Thanks for pointing this out.
>=20
> > They can end up storing duplicate paths with this code.
>=20
> I'm not sure if that really hurts, as long as multipathd basically=20
> ignores INIT_REMOVED paths, and eventually frees them. But I agree
> that
> it's awkward and should be avoided if possible.
>=20
> > What do you think about having calls to ev_remove_path() actually
> > remove
> > the path if multipath device successfully orphans it.
>=20
> Sure, that should be possible. I'll think about it.
> I just want to stop removing paths somewhere deep in the stack.

Thinking about it, I believe we should keep the call to
check_removed_paths() in sync_paths(). We've put it there for a reason.
We just need to be sure from where to call it.

Martin
