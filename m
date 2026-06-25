Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0402C3C09E2
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368904; cv=none; b=hKaDkv3V3arycCGqTpBmbwgd+8rKOttAMMBiuHKXaC/N8ornSNtSztJ4tKISGNd2GLIiPfNL9JZ4XlsnFOZaYAASQI7cAJpC+Y/mp7gw2ohfpf+q1izaBoee0TscZw4WUhfRXxzeS98j9h46fKDtLoJRRE6hyWY6wpEA1q/7Z0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368904; c=relaxed/simple;
	bh=0M9b9MEPq1z/kXNItE5PRl014Mi6+b1gzm92Rcg6eJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VbzxvFzjdZf7nbM2oIMUH9Adh36qo3K6jO06lFGdnLD4qUUasv4CcFTE02V/nb/nIX8HPhhPCxWbP5TDyv8+eUus1yLl8OX2abLWPB6hj4zHxg7kM4DKvk2KjbT6ZKIXa3vLLVxfANgqeAne3BY9cap4Zd/uUIDPO3pFQQ6hZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SH6GH3ng; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HnGwcIOc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SH6GH3ng; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HnGwcIOc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SH6GH3ng";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HnGwcIOc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SH6GH3ng";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HnGwcIOc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 680F375D61;
	Thu, 25 Jun 2026 06:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqyRnCdWwD5/GhVDobjbRRcNZYuZHaOkqJjnDII62Dk=;
	b=SH6GH3ng03EIq1CoU5ah4tXsJtUzLoksHndIMu2mK5MeTxAODmSYagJjmYIgfpvOTbHAWJ
	NBdLZYXyiBy136pW5XYR0ASVLRwe+LulHJjsLbWxwpzPS/6csunCyjZCjpLGsKEk8r5it6
	/jVxs2YcNejROzCqIMBGNCIxW5wiPsE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqyRnCdWwD5/GhVDobjbRRcNZYuZHaOkqJjnDII62Dk=;
	b=HnGwcIOcIz3W16xC7aIKe2+P2MZLOPimFzZ8m1wmEBEuIBegYP89DN+cxLUcR4nrR0WSty
	byVX+1YuB7kRgCCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqyRnCdWwD5/GhVDobjbRRcNZYuZHaOkqJjnDII62Dk=;
	b=SH6GH3ng03EIq1CoU5ah4tXsJtUzLoksHndIMu2mK5MeTxAODmSYagJjmYIgfpvOTbHAWJ
	NBdLZYXyiBy136pW5XYR0ASVLRwe+LulHJjsLbWxwpzPS/6csunCyjZCjpLGsKEk8r5it6
	/jVxs2YcNejROzCqIMBGNCIxW5wiPsE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqyRnCdWwD5/GhVDobjbRRcNZYuZHaOkqJjnDII62Dk=;
	b=HnGwcIOcIz3W16xC7aIKe2+P2MZLOPimFzZ8m1wmEBEuIBegYP89DN+cxLUcR4nrR0WSty
	byVX+1YuB7kRgCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BF4C779A8;
	Thu, 25 Jun 2026 06:28:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LwzuAIXKPGqTRwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:28:21 +0000
Message-ID: <e49bf04f-2004-4ff8-995f-6a17a54b57fa@suse.de>
Date: Thu, 25 Jun 2026 08:28:20 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] block: validate user space vectors during
 extraction
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
 Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260624170905.3972095-6-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624170905.3972095-6-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/24/26 7:09 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The bio-based drivers don't necessarily check the alignment split, and
> stacking block drivers don't always handle a misalignment detected after
> submitting the bio. Validate user vectors against the device's
> dma_alignment as the bio is built from the iov_iter, rejecting
> misaligned early with -EINVAL.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
> Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/bio.c          | 56 +++++++++++++++++++++++++++++++++++++++++---
>   block/blk-map.c      |  2 +-
>   block/fops.c         |  2 +-
>   fs/iomap/direct-io.c |  1 +
>   include/linux/bio.h  |  2 +-
>   include/linux/uio.h  | 10 +++++++-
>   lib/iov_iter.c       |  9 ++++++-
>   7 files changed, 74 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
