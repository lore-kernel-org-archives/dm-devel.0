Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0E15AD86
	for <dm-devel@lists.linux.dev>; Fri,  9 Aug 2024 08:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723192742; cv=none; b=Q4BoxLMnZIr8yosQdnaGN+3mH4Htm0YNnv8U+4BAQ3S1PQ5HPUxp4yWQ5DUIjEzNi51grvxfBcc/Pg38++zcG5U7qWvDxdXA62QQPcscWer+Hw3l3LJgBIr4eFeP6POBj0aXAij0Fdrqxchau1cE+d112ClUDCndy8JarcnMpxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723192742; c=relaxed/simple;
	bh=J5c8QfvalDh9PvvuHta0aYOvqjWqyTzgGf2OsczydIo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I/ignOmnvCLBHvcDZtzZTNb/bFVZ/twgolsdFvcJqvPHcqjSRBO99iWa6cYGBPZxxcz3Xhu7yzBDO6nl+8k2j/YejQFRHXFEhYpPykZg9u6hSnOWOjMuK+mdtjOnYvIEUcG7RMYp8HMZdbbrQbF6RMTkKJRQ6l06HklnQkLitNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LjdoEJqt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LjdoEJqt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LjdoEJqt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LjdoEJqt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 664C921EE6;
	Fri,  9 Aug 2024 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723192738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqfWaPJi7mhF7w2qV0O4dsoSE5uZKCycOTDWahHrUvs=;
	b=LjdoEJqt6e/x55pdu8WCkFSA9/KqLm97H0gRu7WT6nSNpDco12qsDVMqqWZiKM2x4qSg27
	zvE/eCovVoDEWBui8zWoSWrnva7j5Wofs97zOFaFzV5YP81nr5+8vSPQG9APKu/Rd9msok
	54ApRyv/mMruA26UtGdHRBNxbLaAsBw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723192738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqfWaPJi7mhF7w2qV0O4dsoSE5uZKCycOTDWahHrUvs=;
	b=LjdoEJqt6e/x55pdu8WCkFSA9/KqLm97H0gRu7WT6nSNpDco12qsDVMqqWZiKM2x4qSg27
	zvE/eCovVoDEWBui8zWoSWrnva7j5Wofs97zOFaFzV5YP81nr5+8vSPQG9APKu/Rd9msok
	54ApRyv/mMruA26UtGdHRBNxbLaAsBw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3975513A7D;
	Fri,  9 Aug 2024 08:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +XJpDKLVtWaTJwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 09 Aug 2024 08:38:58 +0000
Message-ID: <26f4b0532302bfff61bac465d9f97b8215c30d78.camel@suse.com>
Subject: Re: [PATCH v2] multipath: display the correct configuration when
 dumpping config
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Kou Wenqi <kouwenqi@kylinos.cn>
Date: Fri, 09 Aug 2024 10:38:57 +0200
In-Reply-To: <tencent_FE02DEB8FF48DD9EE156F288BCE172E25709@qq.com>
References: <tencent_FE02DEB8FF48DD9EE156F288BCE172E25709@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[qq.com,lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Mon, 2024-06-24 at 09:45 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> "multipath -t" and "multipath -T" might show the wrong
> multipathd configuration items "retrigger_tries" and
> "force_sync". Make sure they don't.
>=20
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
> ---
> =C2=A0multipath/main.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)

Thanks for the patch! I'd prefer the following, if you agree.

diff --git a/multipath/main.c b/multipath/main.c
index 4b19d2e..28e3a05 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -853,8 +853,6 @@ main (int argc, char *argv[])
        if (atexit(uninit_config))
                condlog(1, "failed to register cleanup handler for config: =
%m");
        conf =3D get_multipath_config();
-       conf->retrigger_tries =3D 0;
-       conf->force_sync =3D 1;
        if (atexit(cleanup_vecs))
                condlog(1, "failed to register cleanup handler for vecs: %m=
");
        if (atexit(cleanup_bindings))
@@ -1001,6 +999,11 @@ main (int argc, char *argv[])
=20
        libmp_udev_set_sync_support(1);
=20
+       if (cmd !=3D CMD_DUMP_CONFIG) {
+               conf->retrigger_tries =3D 0;
+               conf->force_sync =3D 1;
+       }
+
        if ((cmd =3D=3D CMD_LIST_SHORT || cmd =3D=3D CMD_LIST_LONG) && enab=
le_foreign)
                conf->enable_foreign =3D strdup("");
=20

