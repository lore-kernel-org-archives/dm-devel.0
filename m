Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88E189B85
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732490; cv=none; b=U3Qk8F20qYm0z5D8H/Xo3SHlEzpQ3nIVj9DrQAYoGug5A42amv4VXR7sd+G0Nab3goifsrkJ/bgqVlJNnApDHJhiAqaqVbd1eRpvzg01gPwopP5RzAjNinLorXdsRJc0taZc04SwnUm/zKUU/apXBXIr0H2xImeU59unkrNGm9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732490; c=relaxed/simple;
	bh=zgFbBlWRkMJYqaGp8CUjR10eu8MnI68VhLIMBBTLrh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YswB4p9jrinOHNstGKbfPo/qfJGnmsRitvf46rKjGfXIx+87OFXP0YsHhJFaV5uSNqKv8qEN+PxirjeAeDBV+ylmreURyh7899IB0mUQ8938NNVh4+W2m4mY7iEBXII1YsCiyxyfVgdGewF7kE5CY7EFDsw4Cds8L0vFmwWD8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D4D4168AA6; Mon,  9 Dec 2024 09:21:24 +0100 (CET)
Date: Mon, 9 Dec 2024 09:21:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 3/4] block: Prevent potential deadlocks in zone
 write plug error recovery
Message-ID: <20241209082124.GA25530@lst.de>
References: <20241208225758.219228-1-dlemoal@kernel.org> <20241208225758.219228-4-dlemoal@kernel.org> <20241209075743.GD24323@lst.de> <3496570f-d434-42e9-b06f-51a1305f0555@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3496570f-d434-42e9-b06f-51a1305f0555@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 05:18:00PM +0900, Damien Le Moal wrote:
> 
> Yep. But even that one is actually coded in scsi to return a -EIO instead of
> ENOTSUPP. We can patch that (return ENOTSUPP for an invalid opcode error), but I
> am not sure if that is safe to do given that this has been like this for ages.
> 
> This is all to say that we cannot even reliably distinguish special/valid error
> cases that can be recovered from actual medium/hard errors.

I think we can't change the return value, as the whole thing is messy.
I just meant EOPNOTSUP-like.  The exact error should not matter for
the handling anyway, just reasoning about use cases.

> I have test cases for zonefs already. That is because zonefs has the
> "recover-error" mount option which forces a recovery of a file size (== write
> pointer position) if a write fails or is torn. The default even for zonefs is to
> go read-only since there is indeed not much we can do about failed writes.

Yes, that іs the sensible way to handle errors as far as I'm conerned.

