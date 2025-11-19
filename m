Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C3A2D949E
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 06:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763532646; cv=none; b=SED5lJ8BEnA5Etj5p0RaqtVTBeP3ri3T4aLjpGWYIPLg/M2YS6Q9lK7LwxZAYf+5QgD5j08OTjJ29SRl8uGlTzQalAiPxND1bdso+gMVrJ2A+AaFjeBVDcF/7JZILkS9x+Ha0/NVe+xn8EW1iUYqsfIDPU1JF19srI38A5kn59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763532646; c=relaxed/simple;
	bh=mbnjbvfgZwQL1h96YIT6UrOfGPL9jY9S7p+5yuhBx0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s7+1WJDdw3buKjd1Tw6nTOTYl+I8VURa8iswsXzRTSl0DhpOYLfHk2h6F7jwDh2QQfqdf5FjnRyTfT3tZaG/6EB/oi+t5xz+XNL3vjOPvCxTZeRF2de0AqZOkh2zee9X7ZBN8TLUVUASUElEuIfZ34GMGvB3I5KnB4N299o0Weg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LfNqRQJJ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LfNqRQJJ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dBB1H5M7jzlgqVg;
	Wed, 19 Nov 2025 06:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763532642; x=1766124643; bh=o52d9pMMXTP+R7kvE2xC2eyA
	JhyGMmFWCcVgXK1K1ik=; b=LfNqRQJJ9jc7PGTwvaxyApA+O9BVLN16Tj+Eqg4r
	1ZdUkZriFjRTPzJO+90PyC2MiU4iTlWXtBi3FOzg4ehcJH+/lNF50to7efAtQz5j
	/1tpfLsoFxo+xGkpUIC2Pd1Eh5LPvXU+DHv4KQnaynW9HidRe4W4gE59uit6utm3
	OGtYbX/keywir679yAcHcMB9GuQz2J459tkM1FgpyeFaU2cm5yck41QNCqVof1Vq
	4GqxetIK6luO1UxYiVGG8AjCWZrOSLxLfua9QenQ6Gx8nBsnzLjXocgrAp+/TOjL
	KWdCXZ3CtrL+ERTHV+QkhBpW6gvofCFZA01IgeBgpmU1UA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Cm0uNvIGlaz3; Wed, 19 Nov 2025 06:10:42 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dBB180DPDzlgqVS;
	Wed, 19 Nov 2025 06:10:35 +0000 (UTC)
Message-ID: <f385de59-5bef-4ddf-b363-edf76f88d855@acm.org>
Date: Tue, 18 Nov 2025 22:10:33 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: add a flag to allow underordered zoned writes
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <20251118070321.2367097-1-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251118070321.2367097-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/25 11:03 PM, Christoph Hellwig wrote:
> currently writes to sequential write zones either need to use Zone
> Append, or have a local queue list to order writes before the
> submission, just for the block layer than having another ordered list
> in the zwplug to issue them one at a time.
> 
> This series allows to leverage the zwplug list to create ordering when
> the submitter guarantees that it will fill any resulting gap, i.e. unless
> an I/O error happens there will be no missing I/Os.  Users of zoned
> devices have to do that anyway as they can't leave gaps, but we can't
> guaranteed that for user I/O.  Kernel I/O on the other is trusted and can
> set this flag.
> 
> This series adds the support and converts dm-kcopyd as the most trivial
> user.  File system conversion will be a bit more complex as the
> call chains are bit more complex and need a full audit.

Hi Christoph,

Is the following deadlock inherent to this approach?
- Several bios are present on zwplug->bio_list and these bios cannot be
   submitted because their starting offset is past the write pointer.
- No new bios can be allocated because all memory is in use.
- A deadlock occurs because none of the queued bios can be submitted
   and no new bio can be allocated.

Thanks,

Bart.
