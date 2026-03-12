Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812DE3FB7E1
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334093; cv=none; b=E3EdRctDusWwWxGJfQVabkrO51YHHak2Wqq3MtwqfNZbSYtqORNORx+fUJRoUvY7jgfHvNGrKa4W+KjJHDZg9A/LwKbU0byCB5jz2sgwePWGwHIe/Pf9kraiJvYkbNwslPJuJGrzUxg3na57YVA3SorD0/sDRIHIxHHNh3BFI/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334093; c=relaxed/simple;
	bh=G8ZcrArS0PK+7OGxgFfZECOZUJEB4mjcLerOY1bweVU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z4Tv62O53xFHCtVc3VERPCBhmKA205bPqP5IaxADMUQaynQqKRGcsX2AUQT+NUDSt7xJRKzoxUb2aeFFDuAWw8cXoUKE9tWHOkPllourUVO4qBx/6vKsRQ1F9olAb9hzHC4/VG65I8JW20jZBnTEFW/lY+UvA5c0KbZoBVDf3vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZFA//Vea; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZFA//Vea; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZFA//Vea";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZFA//Vea"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 711675C05E;
	Thu, 12 Mar 2026 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773334084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8ZcrArS0PK+7OGxgFfZECOZUJEB4mjcLerOY1bweVU=;
	b=ZFA//VeapdvY3YpPLPe73XoFctEkItGYR0PqRMm8fJD8Wh7BpnxAuFk8IDNnS4k6dL9fcD
	qHxb16lvfS249LQqrEjV+3PzPpKuGKxfxBipkYFKiDF1BsvIOaT5HZEoNGm3ikhDDhUJzc
	9oDYXFYy7+HhxVCYSzeWZ5T/dIE0tJ4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="ZFA//Vea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773334084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8ZcrArS0PK+7OGxgFfZECOZUJEB4mjcLerOY1bweVU=;
	b=ZFA//VeapdvY3YpPLPe73XoFctEkItGYR0PqRMm8fJD8Wh7BpnxAuFk8IDNnS4k6dL9fcD
	qHxb16lvfS249LQqrEjV+3PzPpKuGKxfxBipkYFKiDF1BsvIOaT5HZEoNGm3ikhDDhUJzc
	9oDYXFYy7+HhxVCYSzeWZ5T/dIE0tJ4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 544DA40082;
	Thu, 12 Mar 2026 16:48:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pxdpE0Tusml0CQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Mar 2026 16:48:04 +0000
Message-ID: <bc54bb449129d0a026e69a502d82ef54793f33cc.camel@suse.com>
Subject: Re: [PATCH 0/1] checkers: add alua path checker
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Brian Bunker <brian@purestorage.com>, 
	bmarzins@redhat.com, dm-devel@lists.linux.dev
Date: Thu, 12 Mar 2026 17:48:03 +0100
In-Reply-To: <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
References: <20260312001642.53321-1-brian@purestorage.com>
	 <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 711675C05E

On Thu, 2026-03-12 at 08:10 +0100, Hannes Reinecke wrote:
> >=20
>=20
> Hmm. Some array vendor have been less than happy when I
> tried a similar thing during development of the ALUA
> device handler.
> Problem is that RTPG requires a cluster callout on the
> array side, as it needs to contain information about
> the _entire_ target system. Which, for distributed systems,
> is a costly operation. So using this as a path
> checker is not making certain array vendors happy.
>=20

I wonder if we could avoid this problem by listening to=20
SDEV_EVT_ALUA_STATE_CHANGE_REPORTED uevents in multipathd.

Actually, multipathd could use TUR for checking unless we=C2=A0receive an
event of this type. multipathd could listen to those events and then
retrieve the new device state(s) from sysfs, without sending an RTPG
command itself.

We wouldn't switch to the alua checker by default anyway, so the
vendors that prefer the sysfs prioritizer won't be hurt even
if that doesn't work.

> However: as you might have followed the discussion
> about scsi multipathing, maybe we can turn this around
> to profit both sides:
> Can't we move ALUA state handling into the generic
> code, leaving the device handler only to deal with
> explicit ALUA?

When you say "generic code", I suppose you are talking about
the SCSI midlayer. It isn't clear to me how multipathd would benefit
from handling ALUA there, other than being able to read state from
sysfs, as it already does.

Regards
Martin

> That way we can intercept sense codes and send RTPG
> only when required, such that the ALUA state of
> the scsi device is correct.
> And the the ALUA path checker just has to evaluate
> the information in sysfs.
> _And_ scsi multipathing can use that information, too.
>=20
> Hmm?
>=20
> Cheers,
>=20
> Hannes
