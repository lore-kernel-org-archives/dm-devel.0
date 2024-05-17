Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B1524AF
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 12:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715950427; cv=none; b=Z+NcOKvjLxLfP33sVDMY/VCG0VKYQsrj9oF5zg89RjXQDVfuZWYIc8rXNy2t2c9PgclTdsYnUrHt8woEVZb8IQ3N12OnTnxf0NpY2l7x6W/mK53MvxlqSnnGs3JkFZIsQedQhT//4AM6+ET1mp/2P+Csz35hGdSmeY3N7EeCYwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715950427; c=relaxed/simple;
	bh=++ylF5mAuYf7NXGIAbjfEBud2voVVTi+RbFkmWWZK2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKA4zdfWgj3okwrvrPHHD01Uw3FK1dfIrp9eis6n6LLZhu69OilHpF2rwUZLZ0DN13YDTeLC6sF7kivSROSqPjpyjO0TeO9w6hbY+nWG2PW+cLM29Ub2UDtVehTP1uQI+eEkTlRGGH2LDCxEkZ65A5hGccuRZleVG3vXSZv0nPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PDEs01bV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zSStPvfd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PDEs01bV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zSStPvfd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PDEs01bV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zSStPvfd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PDEs01bV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zSStPvfd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 651945D397;
	Fri, 17 May 2024 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715950423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqWsq0ZT1VZ7wYdqnmf3ZTv0gkAQuPpWEsY9C8w7R4=;
	b=PDEs01bVI+rxrfTsLgT52HHuTKuja2Ei6yQGR8jTwuVqhKz9816UD4gcICeMJdgfTDPUjH
	1/2/CpxAonaWNnVxq5LYVI6/Jjl+i5hPBm6txAHY4blAgbRjKP9qXED2hkVOk1SzSSFNTe
	D32eMgGxIV7aGzRa9bMPyFjplfGNFDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715950423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqWsq0ZT1VZ7wYdqnmf3ZTv0gkAQuPpWEsY9C8w7R4=;
	b=zSStPvfdaAd/XlIAVDBkq6r7fvYtCRerFp/ovJ4uV6AHhL5xhTfuXjMH/pCx/ZmEoM6QZr
	eINHvPaxY+9gNWAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715950423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqWsq0ZT1VZ7wYdqnmf3ZTv0gkAQuPpWEsY9C8w7R4=;
	b=PDEs01bVI+rxrfTsLgT52HHuTKuja2Ei6yQGR8jTwuVqhKz9816UD4gcICeMJdgfTDPUjH
	1/2/CpxAonaWNnVxq5LYVI6/Jjl+i5hPBm6txAHY4blAgbRjKP9qXED2hkVOk1SzSSFNTe
	D32eMgGxIV7aGzRa9bMPyFjplfGNFDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715950423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqWsq0ZT1VZ7wYdqnmf3ZTv0gkAQuPpWEsY9C8w7R4=;
	b=zSStPvfdaAd/XlIAVDBkq6r7fvYtCRerFp/ovJ4uV6AHhL5xhTfuXjMH/pCx/ZmEoM6QZr
	eINHvPaxY+9gNWAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EF5F13991;
	Fri, 17 May 2024 12:53:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wJtyDVdTR2Z/EgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 17 May 2024 12:53:43 +0000
Message-ID: <a3d8bab5-9293-4765-b202-d2bbecaa1f63@suse.de>
Date: Fri, 17 May 2024 14:53:42 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel namespaces for device mapper targets and block devices?
Content-Language: en-US
To: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org
References: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.29
X-Spam-Level: 
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]

On 5/17/24 02:18, Eric Wheeler wrote:
> Hello everyone,
> 
> Is there any work being done on namespaces for device-mapper targets, or
> for the block layer in general?
> 
> For example, namespaces could make `dmsetup table` or `losetup -a` see
> only devices mapped in that name space. I found this article from to 2013,
> but it is quite old:
> 	https://lwn.net/Articles/564854/
> 
> If you know any more recent work on the topic that I would be interested.
> Thank you for help!
> 
It is on my to-do list.
We sure should work on that one.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

