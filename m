Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E53919644B
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728481139; cv=none; b=L6ouMdVDG27MtRHW5RwmQYYq1I+75tErtq8hjwtn/N+KCIMVfaEaw0S0WURAaybmry5+f8ZFPDCvDeaT+l5SQeQkqe/uH3IMI+QDeUFfjQRuNJ4n5DeotU7Z2+kkd7itlIwBFxM61aIoWIOAyyiTk3nqINVDDhExnAgpcnZnDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728481139; c=relaxed/simple;
	bh=MDp0vrHyK8HEFh+hTdVDLcB4F0B8rdwctv7U6Ek3tzE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hCHoOsPm3BG16Ua3CqEXHgRp7Fuv45fmSoAd96voPLFAyByXvopit1GrrghD2uzNpBfXPenklZK5ellJt0h9fq90riUHGnu0Eo9nxqx1ODEmwCWEz2NIPMA89LH1uSUSRLO6lqWbwR+rz/N7jA4hYt44gyQUaBR/SKncogID3Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KHJUEhn9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KHJUEhn9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KHJUEhn9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KHJUEhn9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F38541F791;
	Wed,  9 Oct 2024 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1728481134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDp0vrHyK8HEFh+hTdVDLcB4F0B8rdwctv7U6Ek3tzE=;
	b=KHJUEhn9DPCf2WYvxdCTdKAbdWDQZw5GakbRaXYjCEji7m5TY6Njn55gdfLR9/X5QRWweY
	YrNDkZ8mUQIcq1NSnXSg6K5NJ2/LJW3fqiJUh6Lvz9A6vSEp6rwX14UgxXDXfQhArSCn8i
	2d7fStbxUcwRba5m30ru88awHLX65gw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1728481134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDp0vrHyK8HEFh+hTdVDLcB4F0B8rdwctv7U6Ek3tzE=;
	b=KHJUEhn9DPCf2WYvxdCTdKAbdWDQZw5GakbRaXYjCEji7m5TY6Njn55gdfLR9/X5QRWweY
	YrNDkZ8mUQIcq1NSnXSg6K5NJ2/LJW3fqiJUh6Lvz9A6vSEp6rwX14UgxXDXfQhArSCn8i
	2d7fStbxUcwRba5m30ru88awHLX65gw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C762813A58;
	Wed,  9 Oct 2024 13:38:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IBUaL22HBmfEMwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 09 Oct 2024 13:38:53 +0000
Message-ID: <6fd2438ba87b97154a7a117fff2028182f2a6d06.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: update comments in hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Wed, 09 Oct 2024 15:38:53 +0200
In-Reply-To: <20241008213241.144185-1-xose.vazquez@gmail.com>
References: <20241008213241.144185-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-10-08 at 23:32 +0200, Xose Vazquez Perez wrote:
> Update description of Alletra NVMe.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

