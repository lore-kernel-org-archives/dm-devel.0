Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DC828F3
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 00:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745366583; cv=none; b=Ncj43od0xQsFa1STRtzEGaYoB0uqLm8kELMZODchwpfBpHGg0k57QbxQPwtFwrJ/F4PyFHFbjB3IeAQenEPD1YVqZ7T830IUv9xColOyTaIwew3oAJtTa9UbHNYppv46hhXGVvUj1JUBiqD1MyAeMviVKbgXGyvw1lZY2gCBpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745366583; c=relaxed/simple;
	bh=h4i1bjxfj4uv/hyp7/7EZeqIcT9yAvRA5kst3c4ARjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcjlAaKMaxaoZ/hgnCw4DtpsZSDvdfQw/fSMmTW8RI+w7xgofXbi98dxrUyGhqC6dhiboOoRnWWp/8+U3G6mU4Z80vwWodjIov6zEXODK14mewECvtEwfEWKPjWFTz/RbvvVmyi/FsFcC5AqrUWUUIJJhcAici2xmSvYFMqTU7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qXVgN54P; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qXVgN54P"
Date: Tue, 22 Apr 2025 20:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745366578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27hoE/H1wr8ED+ByTXSzm/9n0+g6fzfnFjisHX9UJrk=;
	b=qXVgN54PP4RiHW4+wPkUvW8xR2uhWhgQNLmk2k2UnBLVeXkjJT1XKtyju8qOjJu1ibPR8V
	wjGu9lkVZJT1y6fsSJlhgGiNzdBL3nw17TJL8L1WtugG2zJbe8VVJQhDugxTI4ye9wfMG2
	7FpzJd+LMqdepL8BhMiJ7SjviTr9Zi8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/4] dm-flakey fixes
Message-ID: <gdw3hv5qnvnrusmh6lt3kfrqlwsmf7o7azdx2sfwlebbqsecla@djyd6a7f3ag2>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422234738.1654052-1-bmarzins@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 22, 2025 at 07:47:34PM -0400, Benjamin Marzinski wrote:
> This patchset handles some dm-flakey issues reported by Kent Overstreet.
> It fixes some issues with dm-flakey's parsing and feature interactions
> and makes corrupting read bios work.
> 
> Benjamin Marzinski (4):
>   dm-flakey: Clean up parsing messages
>   dm-flakey: error all IOs when num_features is absent
>   dm-flakey: remove useless ERROR_READS check in flakey_end_io
>   dm-flakey: make corrupting read bios work
> 
>  drivers/md/dm-flakey.c | 114 ++++++++++++++++++++++-------------------
>  1 file changed, 62 insertions(+), 52 deletions(-)

Does it have tests now?
