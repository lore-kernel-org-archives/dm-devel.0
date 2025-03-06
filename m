Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8121494B5
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281482; cv=none; b=IabmBp0yJ1wz6jteJd5hrWdcgDEVxdmILt3hvKlPMWHIZTHBOPtSZabXhhRzKu+7XzCTIyR2QN5eiIU7fWyzox0DOBOt6MnLwdQqGKddZbEhjx7izP4+YJkJeOoeBIlAyJ+F+mT2vbftLMtFTUCpSHHVxMjELrE5K4Xfq8PN7qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281482; c=relaxed/simple;
	bh=xiQzZ7G45axxS2HdReDP3+kUszA2ryNtSbD2+n96DMY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sQ+3JBcqYzaEY7Rnp6OjGxondU7+nhkiGRyo/28jM+KLyFqHASVQWwjh0+2/VGgNwqLX4/wVOUGYDyR+1peudsfL6+ZkmeA+S6X0aP0pO+ZvG/YkW6/DPUrG1tnps9XZqkoQPBFiSS4jEjbmsaRDWhRsGYjButbMfJ4+l6PVxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=omEIoahZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=omEIoahZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="omEIoahZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="omEIoahZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F66B1F745;
	Thu,  6 Mar 2025 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741281479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xiQzZ7G45axxS2HdReDP3+kUszA2ryNtSbD2+n96DMY=;
	b=omEIoahZywYDZYdEfGQ1zNHhL/kahDBp5pNiiLLzZTSiYV2nGy9SlzMzinO995pDV3t/Q8
	DFKgZu3QJZ8m8XkAT8IgBRkKwItPl1h7ROmg0WD3hVXlhEIALSo/0j+u5M7h132Q1r6tAL
	6S502aY/h1dRRPR3pdWgJr/RN3cq5DM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741281479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xiQzZ7G45axxS2HdReDP3+kUszA2ryNtSbD2+n96DMY=;
	b=omEIoahZywYDZYdEfGQ1zNHhL/kahDBp5pNiiLLzZTSiYV2nGy9SlzMzinO995pDV3t/Q8
	DFKgZu3QJZ8m8XkAT8IgBRkKwItPl1h7ROmg0WD3hVXlhEIALSo/0j+u5M7h132Q1r6tAL
	6S502aY/h1dRRPR3pdWgJr/RN3cq5DM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE01913A61;
	Thu,  6 Mar 2025 17:17:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wA7PMMbYyWfqOAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 06 Mar 2025 17:17:58 +0000
Message-ID: <2a3d5b4d3ca97d183d971108dc1c472f5093492c.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: delete unreachable maintainers
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Thu, 06 Mar 2025 18:17:58 +0100
In-Reply-To: <20250306163924.459944-1-xose.vazquez@gmail.com>
References: <20250306163924.459944-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,linux.dev:email,oracle.com:email]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Thu, 2025-03-06 at 17:39 +0100, Xose Vazquez Perez wrote:
> email bounced:
> Shyam Sundar <g.shyamsundar@yahoo.co.in>
> PJ Waskiewicz <pj.waskiewicz@netapp.com>
> Srinivasan Ramani <srinivas.ramani@oracle.com>
> Arnon Yaari <arnony@infinidat.com>
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

