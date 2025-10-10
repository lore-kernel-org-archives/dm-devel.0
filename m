Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867F28469A
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 10:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760092503; cv=none; b=S2aVSaCP6TiFV6aWtJ5+giFQwpdCBJFf6I9R+i9osJvC/zSlwXF6LRvLlacRmVbELy13SQq/s8cgbvuyuN8ZEaKvvbYwSSneifG3WG5KU7q/3nO7qINMNDnFvnGW1WvEjplaMhqFzQcPkxqTzC1hoKN0NXrANi4FqNT37J4vYeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760092503; c=relaxed/simple;
	bh=byw7z6JHfoMy/f7r9WnHqKnE760x9U+mcz/n0JrIjPY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HyTfF04X41aGUdP4qwuu5h5Akal2COeK23hhxTQa0B7Jx+EgZz5dNIVaEf8LGYYA9tleH938kTfL/JkKgjLMZGi7sY4u+qgpWptN5kn+XB52as6hCz+jMlKROCCqDzpIjpLHF+mCJdEd/liy9XEtSqXQU/SlCw9DHGbZkI94iww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=omaTXYT6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=omaTXYT6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="omaTXYT6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="omaTXYT6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1C1A421B24;
	Fri, 10 Oct 2025 10:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760092499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byw7z6JHfoMy/f7r9WnHqKnE760x9U+mcz/n0JrIjPY=;
	b=omaTXYT6GyY/SEllT+j7LwokzTXidQBa1JEy7MYHWGEi4S/zVDlj1bQ5/pagXneagsoYbv
	GFFJqf0sZCTsKth0+eYpUz2YuZjPVUp6pc42EyDBTInUes/RZAxG7CLUuCEK7jANg9ZJg5
	EgpJ8dGa8E7Pm6m3tCvpkP0pIdWskB4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=omaTXYT6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760092499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byw7z6JHfoMy/f7r9WnHqKnE760x9U+mcz/n0JrIjPY=;
	b=omaTXYT6GyY/SEllT+j7LwokzTXidQBa1JEy7MYHWGEi4S/zVDlj1bQ5/pagXneagsoYbv
	GFFJqf0sZCTsKth0+eYpUz2YuZjPVUp6pc42EyDBTInUes/RZAxG7CLUuCEK7jANg9ZJg5
	EgpJ8dGa8E7Pm6m3tCvpkP0pIdWskB4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0147913A40;
	Fri, 10 Oct 2025 10:34:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zIPOOlLh6Gi7NAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 10 Oct 2025 10:34:58 +0000
Message-ID: <3302bb87e76065f09edaf394d581d6d4fec8e882.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: Cleanup logging messages
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 12:34:58 +0200
In-Reply-To: <20251009233910.2930696-1-bmarzins@redhat.com>
References: <20251009233910.2930696-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 1C1A421B24
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On Thu, 2025-10-09 at 19:39 -0400, Benjamin Marzinski wrote:
> Adjust the logging messages and levels, and remove a unnecessary and
> confusing message.
>=20
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
