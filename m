Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F33A215075;
	Mon,  9 Dec 2024 08:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732283; cv=none; b=qLqZS9bs+q+Hgq/OrsPC1jGqFd3v6cj7PNHEnZpK0CRjhX3ai0Cn+ZNzheHDL12Rbqc8vbKmHKnGLbaw8HVpJLAsKtpGnF9U2gM/1uKRJO3TkDH09KOJ8JOgo9z0j5+Ly7jlN7r1eXLm6J8MzsknKn6C8uHO+RWTkXytR2OR5D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732283; c=relaxed/simple;
	bh=02w7mC9WjFiHin72jCp1xAnQo0bjqP2GUTbaXvuKprE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mthlp9X360rsciwEXe/nLIl0Yf2p5oKgDgUi4e3EGQnLjzKb0EIoubyIpxe8OsD+S2wxjBbFQ/+C2YeTlX33+CSVulY5pFQwkOUIA3oPdQoHW/k7dpKDQXy/sxzWZ9duKo8IVc4bXmS98Pws5N9XsfcbWMwovSC/CX4RsdEUG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kR4Q6KeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kR4Q6KeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF807C4CEDF;
	Mon,  9 Dec 2024 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733732283;
	bh=02w7mC9WjFiHin72jCp1xAnQo0bjqP2GUTbaXvuKprE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kR4Q6KeYrs/mil1Ixn1//BawPPV5N1epaONgWLQwVX9gKx992IWs1fDjS/7gW41m5
	 ySVDXenVNhiWAitln1Fmsl0pQMg1TMKICRqO/W0i4L25H6idQEQk7rvBNzVRGKtkSE
	 /b89pAx8oD5K1CO90kE757zjBnXXC7xapUzaM9KP+LjmPPzVic+LFF6BkEXqKiTZph
	 K0d8kWnaoeaHc0DYhy2ZeBCoGtkmprI0keoSxSMd3vO+TCwvp9L+7NRR94hsb7MtJs
	 Y4FEicLlIJ/HUXQzSw/tWsxkBpvjMduGKIgqxMcPfc09PjWbO3FLMspshezTS2hVG/
	 knoVeB4I4Uk+g==
Message-ID: <3496570f-d434-42e9-b06f-51a1305f0555@kernel.org>
Date: Mon, 9 Dec 2024 17:18:00 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] block: Prevent potential deadlocks in zone write
 plug error recovery
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>
References: <20241208225758.219228-1-dlemoal@kernel.org>
 <20241208225758.219228-4-dlemoal@kernel.org> <20241209075743.GD24323@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241209075743.GD24323@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/9/24 16:57, Christoph Hellwig wrote:
> On Mon, Dec 09, 2024 at 07:57:57AM +0900, Damien Le Moal wrote:
>> Avoid this problem by completely getting rid of the need for executing a
>> report zone from within the zone write plugging code, instead relying on
>> the user either executing a report zones, resetting the zone or
>> finishing the zone of a failed write. This is not an unresannable
> 
> s/unresannable/unreasonable/ ?

yes.

> 
>> requirement as all well-behaved applications, FSes and device mapper
>> already use report zones to recover from write errors whenever possible.
> 
> I think the real question here is what errors the file system (or other
> submitter) can even recover from.  The next patch deals with the not
> support case for a "special" operation, and that's of course a valid one.

Yep. But even that one is actually coded in scsi to return a -EIO instead of
ENOTSUPP. We can patch that (return ENOTSUPP for an invalid opcode error), but I
am not sure if that is safe to do given that this has been like this for ages.

This is all to say that we cannot even reliably distinguish special/valid error
cases that can be recovered from actual medium/hard errors.

> The first patch already excludes EAGAIN from nowait, and the drivers
> already retry anything that they think is retryable by just resubmitting
> without bubbling it up to the submitter.  That mostly leaves fatal
> media errors as all modern hardware that supports zones just remaps
> on write media failures.  I.e. for those the most sane answer is to
> simply shut down the file system for single-device file systems, or
> treat the device as faulty for multi-device file systems.  This might
> change when we support logical depop on a per-zone basis, but I don't
> think anyone is there yet.  We also really should test this case.
> I'll add a testcase with error injection for zoned xfs, and someone
> should do the same for btrfs (including multi-device handling) and
> f2fs.

I have test cases for zonefs already. That is because zonefs has the
"recover-error" mount option which forces a recovery of a file size (== write
pointer position) if a write fails or is torn. The default even for zonefs is to
go read-only since there is indeed not much we can do about failed writes.

> Sorry for the long rant - not a comment on the code itself but maybe
> the commit log could use a little update.

OK. Will try to improve it.

> Also we probably need to recover this information somewhere in the
> docs.

Hmmm... not sure we have a good place for this. Let me figure out something.

-- 
Damien Le Moal
Western Digital Research
