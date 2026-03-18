Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384AC3DFC78;
	Wed, 18 Mar 2026 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858908; cv=none; b=bBmLej7ZnbiXlrOMiFlryhc1CVkW0YPooyIXuv9FUprCBtmsogw4c6e4klsYwJ6oSqE/E8G4OEXg6IzozbjApsHEp4K66n0vIFsPAvP0Cih1zpmlg3/S6WR/tEQFSqRDfMC6C8iJ+zSxXF9CBVVjiDGy4c2OlRL1THl3Adp4i4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858908; c=relaxed/simple;
	bh=LwjaP8XB4LkKQzj2/P+R3BFCg9h8zQP6/zHh0PfwI88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zly7TAcWr8Li+0iR7ppoSyIpu84Pmjz4rE+SLNvgwbYVfTC+/v3BWiExJBUIuA/A3cKsGtEO3XgnYtgSeGl2FW2NF/q+DqqaU3iwFx2dZuc1iwZzCPixMfZtOllkOoorfxK1b7ffbOrVwDmm4tId7yo6AmLcV4ykodGlxxNFgXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLwP8EgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLwP8EgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBDEC19421;
	Wed, 18 Mar 2026 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773858907;
	bh=LwjaP8XB4LkKQzj2/P+R3BFCg9h8zQP6/zHh0PfwI88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLwP8EgY/jRjDUPgqqprx+v8dP+JYkPZJxXJhg2Lcd5uEMycxTXtoedzjtg8xhfwB
	 pmnPbn0q/LchiBA2X27eZS3vBlaGa69g8H/cGFjCBkDLqH3dvJnSjFw9v1kOSR3edU
	 4NzYdEJ0jif7uddWUd6b4Y5JWkfc5ELH+SBwLmT7HoYhTR57MbDNmdv2KXMR0NrRn4
	 RMi+/LL1c3ViKC9gkaIb7ynI73GtX3ef+T0JfEuuZ5qkIunWtAbEKbltM6i+9f7iRw
	 Rb5ykio0mUdGj/oEMYfAzP1iTcQ991LXNEgBqvJK3lvlZFoXBpNNOAUNR3oxhU7CIF
	 5hk6Gfdf5PBug==
Date: Wed, 18 Mar 2026 12:35:05 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for
 direct io
Message-ID: <abrwWQUm8-etR7gS@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <7cc4892a-5a2f-09b7-1f32-320acac4c797@redhat.com>
 <abrjgdttXBHCFh34@kbusch-mbp>
 <fa0978af-398b-a212-73bc-80f0f2c375a4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa0978af-398b-a212-73bc-80f0f2c375a4@redhat.com>

On Wed, Mar 18, 2026 at 07:06:40PM +0100, Mikulas Patocka wrote:
> > It doesn't matter what the underlying block device reports because
> > dm-crypt bounces the incoming plain text buffers to something aligned to
> > the backing device for the cypher text.
> 
> dm-crypt bounces writes, but doesn't bounce reads. When doing reads, it 
> reads the data into the target buffer and decompresses them in place.

Oh, thanks. It's been a while since I developed this, so I'll need a
moment double check for any mistaken assumptions. It may be I just used
backing devices that also had similar alignment constraints and missed
something.
