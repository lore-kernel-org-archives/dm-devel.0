Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651FB2EF9DF;
	Thu, 10 Jul 2025 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163490; cv=none; b=qV/jDmhYZs4tMdmc0wnC+wL+uD9p+mzy72Oxz7aX7u6EzNjqsKrsFUqMo5Hz0373E2gCAxmQPvdAlkJwAcdi/pfJpc9QrTzJ8GHqM+3lAAZASJ5B1y4KSjysXqPSpdzPGvAlqloDSMYpRblMZOsBIDXgVJU78N4YTlugMh71fKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163490; c=relaxed/simple;
	bh=CftxzH/NKt8m3JLBkgxyZRS8nFbNISXN12iWjy2Y8Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEF28U3KJHFxma1pgUMY1nw8MeIaWa2eZctQid3kN3RM8eadRQARdHBMEtIGFXBmkeUAUdb/qzrD3jDDD8brJggxXMUSqboTDmKPjQXs9lsavjlhB9SianKtlnqK80w5k0fqN2psaTH1X9/6il0t90Xt4uQAJ9W+DiKKK11suRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7kUziul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7kUziul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B1FC4CEE3;
	Thu, 10 Jul 2025 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752163490;
	bh=CftxzH/NKt8m3JLBkgxyZRS8nFbNISXN12iWjy2Y8Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7kUziulQrYU470pvtIa9d/YiplLX+E1qLd/h1Pr7s8sThDmq/ni2yhgtgofxMV33
	 gHvYe6Oz2afSOiLsLkxv+M6papA/W2QHF36P5d16Cx0wdAwBr61ukp/3mG7KPm6eVL
	 mYMzSKFA9DXvOdMs1CuYzMfq1L7zwS73FAcGWm/2Atq8t5Y3sM9Aq9Frw1wEcM27bG
	 muHFRMfQ57ErmRh7nzB07Sn+2fGQ90PZTR2/XY7FqdHcGJpBHlYiI+QQnWvBQOTWvr
	 6VrdzeFHG8oxrT4hWpWcPPZZD7tMie3qY3bbKbAbzOhzb9az5MvJ05Hd9z1vv+/n/F
	 iPCV8ivMqhGjQ==
Date: Thu, 10 Jul 2025 16:04:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
Message-ID: <20250710160447.GA604603@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
 <48bd1925-94b6-4913-9cbc-f348e4dc4ae6@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bd1925-94b6-4913-9cbc-f348e4dc4ae6@acm.org>

On Thu, Jul 10, 2025 at 08:55:31AM -0700, Bart Van Assche wrote:
> On 7/10/25 1:28 AM, Milan Broz wrote:
> > Just one nitpick - could you please increase minor version of dm-
> > verity target, so we have information in debug log that it is a
> > patched version?
> Others are convinced that version numbers have no place in the upstream
> kernel and that all version information should be removed from upstream
> kernel drivers.

As long as it's there, we might as well update it.  But yes, the
device-mapper version numbers don't work all that well.

- Eric
