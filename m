Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB952206BB
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742554900; cv=none; b=P/v2sprfyjREmOPCWi3A49oQr77La36bA+2OvJ6PRBPXpeAE5zkwY5uDkcrCeQTWe4LMRkCx1JO8x+w31eaWL7oSYmYdTNmzUCi4TSmJ0DaiW/zuMagd+8N6h6ojuPk3sGYO0so92L+aEc19va3QPspgV76tHPZMlR4sjqvtExQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742554900; c=relaxed/simple;
	bh=CvacOxYkInDwzPo+klv18DBDR3tvODIi4Qs6OdMRbmY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fKwhFzc/Q+Rd0E9AYA1wtHqAGyMGwIMoVjMH5dHvtvbxNd+VNtTH7orhYgjYuGWFGadhlxwiMgRFEeQc9OXbqM5eAwl+F7rd6WlVP7UG1w3J35CaaKFV31gkNhFxyuE1ufUBWIluSGNj/blRR/UU5EZoQhE+6JGot3Z8PoUL8Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AfNCMnTe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J7nvL6rb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AfNCMnTe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J7nvL6rb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1F871F78F;
	Fri, 21 Mar 2025 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742554897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BX1Z+4zqvoHGX1QpuB4HWZANQ1QEW7EGlsotW/FeUTQ=;
	b=AfNCMnTeO5ds3nP06ut9qdnoGKx21N8xPKL2N2blEa4OGb7DmgBIFit9YaQ7iajtq19rQ3
	Rs2/bmjymMzsW6dYZje4VsMyltfAHLUoxaPhdYiOGUS4uZTxWoWoKvBDbsoepDO3dVCQKe
	ChTzn0NBMsAJYYiI9uHYZD6iiMPBCxQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=J7nvL6rb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742554895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BX1Z+4zqvoHGX1QpuB4HWZANQ1QEW7EGlsotW/FeUTQ=;
	b=J7nvL6rbb1BPeHurDikI78V1KtlJbC5BKgx7S4GIjffq4BLgK5ykPLX+uvlByN7M25+X0O
	TNziZHaSrPr6mk22jzmAVF0VoSl5dk7ZGgr4PFGX89WYWE2T5xU5H8mcORtshx+afagNoi
	/6Q5mqDq5TPzT/etiWWV5gNo/RYEJRA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4849139AA;
	Fri, 21 Mar 2025 11:01:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FmSVJg9H3WdiOQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 21 Mar 2025 11:01:35 +0000
Message-ID: <b80419a951e9f02b422b392f859d0b27368cf27b.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add .b4-config
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 21 Mar 2025 12:01:34 +0100
In-Reply-To: <20250321085441.16968-1-xose.vazquez@gmail.com>
References: <20250321085441.16968-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: D1F871F78F
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensvc.com:email,suse.com:dkim,suse.com:mid,suse.com:email,linux.dev:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, 2025-03-21 at 09:54 +0100, Xose Vazquez Perez wrote:
> docs: https://b4.docs.kernel.org
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Looks ok to me, but I'm not a b4 user, so I can't judge with
confidence.

Martin

> ---
> =C2=A0.b4-config | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
> =C2=A0create mode 100644 .b4-config
>=20
> diff --git a/.b4-config b/.b4-config
> new file mode 100644
> index 00000000..cd440059
> --- /dev/null
> +++ b/.b4-config
> @@ -0,0 +1,5 @@
> +# Configuration for the `b4` tool
> +# See https://git.kernel.org/pub/scm/utils/b4/b4.git/about/
> +[b4]
> +	send-series-to =3D Martin Wilck <mwilck@suse.com>, Benjamin
> Marzinski <bmarzins@redhat.com>
> +	send-series-cc =3D DM-DEVEL ML <dm-devel@lists.linux.dev>,
> Christophe Varoqui <christophe.varoqui@opensvc.com>

