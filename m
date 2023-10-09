Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C81BA34
	for <dm-devel@lists.linux.dev>; Mon,  9 Oct 2023 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P98TQ5Yy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7W85zxx1"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F70A1F895;
	Mon,  9 Oct 2023 06:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1696832141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xxp6hA+yU/4V79q6FFEdUIzcg6h5OMqdfDtbQWiKmLI=;
	b=P98TQ5YyusC2bOf9F5je3fq/uVi68iRSzYNxN/iMDXsEyTB68iuq60AGr4k5cN+pSZHWn8
	ZiuxT8GqlPm+wL7PAzKyLeyS5WN/3f57daOUxMKX8e/1V4IExQLXVIoh/4klpcEMoNv5vY
	zliN3tbvjXYWvEIrT0pH5LNJQZNTjfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1696832141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xxp6hA+yU/4V79q6FFEdUIzcg6h5OMqdfDtbQWiKmLI=;
	b=7W85zxx1wIzvTj7Bzpc7NbZIvuMvcWeBao0A+i/UWzRzFewYiG9P2EKC0fevotD4GZuh+e
	pf8qUlmHm9ZWJ6Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4BC3D13586;
	Mon,  9 Oct 2023 06:15:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 1AOdDo2aI2VofwAAMHmgww
	(envelope-from <hare@suse.de>); Mon, 09 Oct 2023 06:15:41 +0000
Message-ID: <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
Date: Mon, 9 Oct 2023 08:15:40 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To: charlesfdotz@tutanota.com, Dm Devel <dm-devel@lists.linux.dev>
References: <NgGvkdW--3-9@tutanota.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <NgGvkdW--3-9@tutanota.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
> Hello,
> 
> I would like to request a new device manager layer be added that accepts trim requests for sectors and instead
> writes zeros to those sectors.
> 
> This would be useful to deal with SMR (shingled magnetic recording) drives that do not support trim. Currently
> after an SMR drive has had enough data written to it the performance drops dramatically because the disk must
> shuffle around data as if it were full and without trim support there is no way to inform the disk which sectors
> are no longer used. Currently there's no way to "fix" or reset this without doing an ATA secure erase despite
> many of these disk being sold without informing customers that they were SMR drives (western digital was sued
> for selling SMR drives as NAS drives).
> 
Gosh, no, please don't.
SMR drives have a write pointer, and if the zone needs to be reset you 
just reset the write pointer. Writing zeroes will result in the 
opposite; the zone continues to be full, and no writes can happen there.

Which drive is this?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

