Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2F53F1071
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458739; cv=none; b=ClsVH8ZowlirP90vombVMRnWWBKWidoico0q1aiKYz/JVNEV8DutxnO/TXrqIAF8keSN4ZfM0mMoOkrP2VrggU3dgjB3IpMbFQvzEJXdn1hM0OtmiQCgy47j+Wes7jJIz3Ccsndv0pI/IaXyNP+5tlTbZQrfSI9bH2K392KSgUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458739; c=relaxed/simple;
	bh=sRtV+ggoSUDHhyjvQe0JjelSizPnSQBDqSv6nBp96n8=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=UGYbbwDTTiDB4uxN2f+byNOtGsCWQBTM3KwlMbJeYGJgLxEhCl2/1Rv4YJKKwxrsLDoirvqC3DQREZSusoiiwG/tPnZxBkvzs08EfnhFmdGp/GUpZlAVVZZiglSDeuer5Xij7+9CC9H2EkqO551DAfSi7E3p0VKyAb4c0D4E4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QkKsulzX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=C8YzlxJM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QkKsulzX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="C8YzlxJM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C191721B3C;
	Thu,  8 Oct 2026 11:25:35 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791458735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VT03T4JTqzuNmHs+IsPk/c1JrQv3Ig7F23ZZEVBHf+k=;
	b=QkKsulzXKqkgt4agzySK6mgEKbIzf7JwxuU/ppffd9kvSjMoNU8rmnnQjcdgAKrCbfiWlV
	KUn/JnXjPFgkvA3OwLE1bunrGuf5osVCO9eP9MZtPB5SbFXebG38LAaSnSS1nXg/OR8ASx
	RDNwAusm41Xa2Hfk4jlws8SwdWVxnAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791458735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VT03T4JTqzuNmHs+IsPk/c1JrQv3Ig7F23ZZEVBHf+k=;
	b=C8YzlxJMexZb/Fu9iQ0zOaY0dCvAdr89tzj03g4psxq30HKhrPqclv8dSYi8ZU9g9u4CTQ
	P2dK66eQayrBMeAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8831813354;
	Thu,  8 Oct 2026 11:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jLbhNJ99x2qufQAAD6G6ig
	(envelope-from <mwilck@suse.de>); Thu, 08 Oct 2026 11:25:35 +0000
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/2] libmultipath: fix leaked device-mapper suspend
 after a failed remove
From: mwilck@suse.de
To: Suresh Thelkar <suresh.thelkar@yahoo.com>
Cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>, 
 Martin Wilck <mwilck@suse.com>
In-Reply-To: <20261008043749.23389-1-suresh.thelkar@yahoo.com>
References: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
 <20261008043749.23389-1-suresh.thelkar@yahoo.com>
Date: Thu, 08 Oct 2026 13:25:15 +0200
Message-Id: <179145871550.102814.3206399299732374875.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=718; i=mwilck@suse.com;
 h=from:subject:message-id; bh=sRtV+ggoSUDHhyjvQe0JjelSizPnSQBDqSv6nBp96n8=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBqx32g7r3e8Y16BHU9363//SY6isn8XfBHmkzsJ
 NSg+VNK8rWJAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCasd9oBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/NsCTQwAmLqofzp13L3rVKODjl+VXChnNL3G9jc
 m2dsQxgGgiBzzZODipT7ECaLQp0groufKRVb5OpCNUtpbG3mvD4wGbN+Owx0ajxxXOVAuGqxuic
 I3pxQHjawaAVP/xyOoT2KUy9sF5VXkWVpDbcnDRzyuUjJt8/86vJnSbqZvcfq7N7EOvv3NTCg2F
 A1c3/BNDPM8TuqwUaVXD5w7GObC7Mu5lyq8RVx9/bPyUF9mXfZgRokSpNGURDwb10+FCAGbO6gE
 IAa93WEagE88MoXC9kC8rJpea9436hh5Ojdb6Y0I2ecH3lUS4hbQMXb7NYY0XOJflKIyNSnt0R6
 DG+W1O+Ks1vvyzm6/LiFGEXvhPkpqDy+LoO8/p0pCNVNOfw0HZ+TxaA2vTsTQE6p0p9R75uTUag
 k1OUbZRcTkjokA0Opau2rkg7EykmOXQGLx6YIpTTojtdBbyHB6D5+G9qOCi5OgoDi6BlpILBUKW
 KyOlbxQ7AlUwkygNSc+OHMYO+T1LRN7
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason

On Thu, 08 Oct 2026 04:37:47 +0000, Suresh Thelkar <suresh.thelkar@yahoo.com> wrote:
> libmultipath: fix leaked device-mapper suspend after a failed remove
> 
> Under heavy device-mapper ioctl load (e.g. LUN-number recycling combined
> with ALUA transitions), dm_flush_map__() could leave a multipath map
> suspended indefinitely after a failed DM_DEVICE_REMOVE. A suspended map
> wedges any later task that touches it in uninterruptible D state, and
> because sync() walks every block device, this can hang I/O node-wide
> until reboot. The storage itself is healthy; the defect is entirely in
> user space.
> 
> [...]

Reviewed-by: Martin Wilck <mwilck@suse.com>

-- 
Martin Wilck <mwilck@suse.com>
