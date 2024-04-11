Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B521E892
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712857325; cv=none; b=Rh1C7lRhAeKXV42IT8Ob0Hy6QcX2vAM8t7bktBbuRFKInqLgjWLTJznPtiWTXVYwUy5L5POroE0s5XdLPVIJiKQNOMOjIZVbqpu2eNl425kbcaPAvameHAtqF/3hgu9SjY2tOEGn0qMKPZPmGoP0z04LAhch+PKfKg00/NVk0p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712857325; c=relaxed/simple;
	bh=23pgYwuyzOLEHch0MHEttvr/sYmq5SIbg94MkexXTNY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SOUAJRvqTqI/+2zvwhXhvnDsXLOIclBE8AVwK/cA/TpCpJq9OYJk5hMAa+bJFgouqMJxSpM0CK/VSRVqaIA+IoBO6fuSBkOQrLqRse7aMKq16gM01NOuoOtTTTWla48yjp+k/IPD5aDYxGNAhxrFAD8oNiy/tux8QIonxrHbzu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Zs4glm0O; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Zs4glm0O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Zs4glm0O";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Zs4glm0O"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ACA2237786;
	Thu, 11 Apr 2024 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712857320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxMrH4IaH40+LOfRu4d/aPn7QpiXdv99ykS+uG9ceTY=;
	b=Zs4glm0OesFMLLLci/xOzPEUlfWzWx4/qox6WULexxplY8vMWpjt3zo8Ivb75bhE3fJ+2V
	DFC+J6EI/XxfnG7u4QwvO07rfxut0Fgu0gx21xVNRBO/FUJYbNZ3lz9WyPCogO4b82NXw5
	voOfYIbzyUli/C55nHKwpNOQAs6xoAE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Zs4glm0O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712857320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxMrH4IaH40+LOfRu4d/aPn7QpiXdv99ykS+uG9ceTY=;
	b=Zs4glm0OesFMLLLci/xOzPEUlfWzWx4/qox6WULexxplY8vMWpjt3zo8Ivb75bhE3fJ+2V
	DFC+J6EI/XxfnG7u4QwvO07rfxut0Fgu0gx21xVNRBO/FUJYbNZ3lz9WyPCogO4b82NXw5
	voOfYIbzyUli/C55nHKwpNOQAs6xoAE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69CED1368B;
	Thu, 11 Apr 2024 17:42:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XF6aF+ggGGYjCAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 11 Apr 2024 17:42:00 +0000
Message-ID: <7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com>
Subject: Problem with [PATCH] libmultipath: fix max_sectors_kb on adding path
From: Martin Wilck <mwilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, Etienne Aujames
	 <eaujames@ddn.com>
Cc: Hannes Reinecke <hare@suse.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, nilesh.javali@marvell.com, DM-DEVEL ML
	 <dm-devel@lists.linux.dev>
Date: Thu, 11 Apr 2024 19:41:59 +0200
In-Reply-To: <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
References: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
	 <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ACA2237786
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,ddn.com:email,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.com:+]

Hello Ben, hello Etienne,=20

On Wed, 2023-08-23 at 21:51 +0200, Martin Wilck wrote:
> On Wed, 2023-08-23 at 16:24 +0000, Etienne Aujames wrote:
> > From: Etienne AUJAMES <eaujames@ddn.com>
> >=20
> > A user can change the value of max_sectors_kb on the multipath
> > device
> > and its path devices.
> > So when a path is deleted and then re-added, its value will not be
> > the
> > same as the multipath device. In that case the IOs could be mis-
> > sized.
> >=20
> > On reload, this patch re-apply max_sectors_kb value of the
> > multipath
> > device on its path devices.
> >=20
> > Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
>=20
> Looks good to me.
> Reviewed-by: Martin Wilck <mwilck@suse.com>

We've seen issues in our beta-testing with this patch.

Consider a device with an odd max_sectors number (in 512 byte blocks).
If you look through the kernel sources, you'll see that there are quite
a few devices with odd max_sectors defaults. In our testing, we used
bnx2i (max_sectors =3D 127).=C2=A0

When a multipath map is set up, the kernel will call
blk_stack_limits(), making sure that the map has a max_sectors value
that doesn't exceed the max of all path devices.
The map will have max_sectors =3D 127 in the bnx2i case.

When a device is added, multipathd will read max_sectors_kb from sysfs,
and obtain (127 >> 1) =3D=3D 63. It will then write this value to the path
devices, causing the kernel-internal max_sectors value to be set to=C2=A0
(63 << 1) =3D 126. But the map's max_sectors is still 127. The path
devices have now a lower limit than the map. This leads to errors like
this:

[  254.652934][  T820] blk_insert_cloned_request: over max size limit. (127=
 > 126)

If the map was reloaded after that, the kernel would fix this
discrepancy autmatically through the blk_stack_limits() algorithm. But
as long as this doesn't happen, the blk_insert_cloned_request() error
will repeat and possibly cause the system to hang, and even if a reload
happens, if the map is currently active, there will be a race window
during which IO may fail.

I'm working on a fix for this. My first idea was just to revert
Etienne's patch bbb77f3 ("libmultipath: fix max_sectors_kb on adding
path"). The code that exhibits the above issue is actually from 8fd4868
("libmultipath: don't set max_sectors_kb on reloads").

My thoughts so far:

1) We must strictly avoid max_sectors(path) < max_sectors(map).
2) max_sectors(path) > max_sectors(map) doesn't hurt.
3) We currently have no way to tell if the kernel value for max_sectors
of a path device is even or odd.=C2=A0
4) As soon as we or someone else writes anything to max_sectors_kb, the
kernel internal value will be even. This applies to both path and map
devices.
5) The max_sectors value of a map device will be equal to the lowest
max_sectors of all path devices after each reload.
6) Therefore, if max_sectors_kb is set in multipath.conf and we have
set it at least once in a reload, we're on the safe side wrt the
scenario above. This is why we see no issue with 8fd4868
("libmultipath: don't set max_sectors_kb on reloads"), even though that
commit introduced the code that rounds the max_sectors value down.
7) Arguably, the kernel should be patched to provide the raw
max_sectors value to user space, but that will take time.
8) If users change max_sectors_kb, either for path devices or for map
devices or other stacked devices, after the mapping has been set up,
they are asking for trouble. We can't avoid errors resulting from such
user actions, and I believe it's futile to try. This is not a
multipath-specific problem, it applies to any stacked block device.

AFAIU, bbb77f3 ("libmultipath: fix max_sectors_kb on adding path") just
"fixes" a scenario where a user had manipulated max_sectors_kb, which
is a situation we can't correctly deal with anyway (see (8)). So
perhaps just reverting bbb77f3 is enough.

OTOH, 8fd4868 is somewhat inconsistent. If it's correct to set
max_sectors_kb when path devices are added to make the value consistent
with the map, it should also be correct if max_sectors_kb was not
configured. This is what bbb77f3 tried to fix.

In light of (2) above, I think we shouldn't change a path devices'
max_sectors_kb unless it's smaller than the value of the map.
If we do it this way, the scenario above couldn't occur.

Thoughts / comments?

Martin

