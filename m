Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0F1DFDE
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747400231; cv=none; b=Abd5lHKv6lwlA0m7mXpr+XSeiLJ4W12n3g9hEfCnmqXF+czOCc9KXajIe9joB36pTLLGWvixPmhdylqhTNlLKgbVEBbwNiuIk/k7Bp5M9ymRcsuC6GHdIfgXQ4cknqnq9yH9cj//tFlfbOCVFJF0fhjQhOWSxmBzMGZphfaSz2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747400231; c=relaxed/simple;
	bh=nxwVYZEot3ZvklTuhuVs0w0AE9F6GHodIv0IxaYP+vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNi6oseLL+xny8Z/wNAjns6bd4VWbH2/FOhCClOUN4VkdXVOPp6m3GLiR/YEtMvlrDowcKP5EYT/m11yCGSnOG/8d+FKUbQnFU1lUY0YUZOjA3AyafhPtR52SlHUZoGfqusx/Q2o6VMCFhpU+QHjRfEJJEEfFRerlO3ZuvtZB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=1Dhdwz7y; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="1Dhdwz7y"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4ZzRtT4VLnz9tKZ;
	Fri, 16 May 2025 14:57:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1747400225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=THn6E50DS9Qud9iyvxS3CqKZepivbtdlHTOmUUOFMWc=;
	b=1Dhdwz7yqacA2jfQN66Qi+LXU1+0l13Fxr2onEIWD86UPegibqrjfkTgt+q0Awz/RTkfld
	ygYcGcTcb32XPIiJuYZISUSDaeN+K6QWNvf5gL97h2gSyLP2R26KGTIp8TeFnHugLVh5Ty
	Y+7S/+3bqz5TzloF/2DcIhpKpTsDS6VfQuNgrdWzNJDxdXyQf4xUAEdK6fCiMdB9aXMfFt
	E961kA+1U/QljCnbvjNHcFHOt/XlZE3SV7lXIaI8UcVnQJZJ81KBviMqwXkThXp6ZojlDI
	I++XlDE8UnWWr0whm7R5RIlLcE5mwPMmH+Bonav1gO4nYJje1d0Vi1x15u064w==
Date: Fri, 16 May 2025 14:56:43 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Damien Le Moal <dlemoal@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2] dm-zone: Use bdev_*() helper functions where
 applicable
Message-ID: <4auwqhrenu7abik7lpswz3ivhcevn7jjb44fgsskb6pyxizwcj@lvolofdjqkhz>
References: <20250514205033.2108129-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514205033.2108129-1-bvanassche@acm.org>

On Wed, May 14, 2025 at 01:50:33PM -0700, Bart Van Assche wrote:
> Improve code readability by using bdev_is_zone_aligned() and
> bdev_offset_from_zone_start() where applicable. No functionality
> has been changed.
> 
> This patch is a reworked version of a patch from Pankaj Raghav.
> 
> See also https://lore.kernel.org/linux-block/20220923173618.6899-11-p.raghav@samsung.com/.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
