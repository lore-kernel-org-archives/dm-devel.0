Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877F486126;
	Tue, 30 Apr 2024 23:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714518395; cv=none; b=EUTbVHDGgfEEHh5hkFx2ChEg7r+MYPI8LD37GIYkXBlV42gb+CNJiWjDHI0VVE2ymiGiBhnvH6et/cvdyFEnDIlMKTSfiUz1/BRr4p/EARkzk5l7McJlEtfD8cPlzSGSDCBKEXhTvBN0TfW0pPkA1IM6QE/2s6IQnTXOk+FyKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714518395; c=relaxed/simple;
	bh=S4ut/7XvqIQzLveGvtOkrN+JLgOAoBPjlRdfqvMcnkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B18ic1vuYpgU3FNl/lm++m8p/nY5lWKE59Ox4OoEB59FaeVDWHP81HJgYRnvAQYHu87VSY5Kjxh0lfXRK1djFZ5AazOwBO/ZYJs3cfxJguxRury3jyDPEwBHcMF1hxhJVVyYC2w7bpWm489P2ybmVX2GA9gsFmTtuGki58z+v4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojjtfMpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojjtfMpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BACC2BBFC;
	Tue, 30 Apr 2024 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714518395;
	bh=S4ut/7XvqIQzLveGvtOkrN+JLgOAoBPjlRdfqvMcnkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ojjtfMpZi3pMVpux+CtFjdcS9e/g/fCjkpOzb45Avs/JvinZJyhmL5V2L/SmTKk3/
	 +/+oFNofpiFQwHq7MI4cztdJUDbFTZGdljupEHK2uoyCWzx06w9kvJetquVT6WZR4T
	 BiSnHuif8kcWarsp2byvo3Y0ixFpE5NG1aPOQah+Jm24H3X2bQtvEhXTmntseaYJeD
	 90fY8uidMF0Fcpnx8Fwyko4jhsEh7G2u+KBZJPgd3PX//s+x0D+uhJkXCRlCDiETLD
	 HkPRhYpkoalSaeQrsa7CnfKnracBLgEoJrrMGwmhwOOCE1X+3+YtNoaBNLnxJF9cs1
	 a9zIsfHpzi6eg==
Message-ID: <6c974d9e-4bf4-4ddf-a593-a108c8a759f5@kernel.org>
Date: Wed, 1 May 2024 08:06:33 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] block: Do not remove zone write plugs still in use
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-8-dlemoal@kernel.org> <ZjEPdVYmPYt2ilAu@infradead.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZjEPdVYmPYt2ilAu@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 00:34, Christoph Hellwig wrote:
>> Fix this by modifying disk_should_remove_zone_wplug() to check that the
>> reference count to a zone write plug is not larger than 2, that is, that
>> the only references left on the zone are the caller held reference
>> (blk_zone_write_plug_complete_request()) and the initial extra reference
>> for the zone write plug taken when it was initialized (and that is
>> dropped when the zone write plug is removed from the hash table).
> 
> How is this atomic_read() based check not racy?

Because of how references work:
1) A valid and unused zone write plug has a ref count of 1
2) A function using a write plug always has a reference on it, so if the plug is
valid and unused, the ref count is always 2
3) Any plugged BIO and in-flight BIOs and requests hold a reference on the plug.
So if the plug is used for BIOs, the reference count is always at least 2, and
when a function is using the plug the refcount is always at least 3

Based on this, all callers of disk_should_remove_zone_wplug() will always see a
refcount of 2 if the plug is unused, or more than 2 if the plug is being used to
handle BIOs. Most of the time, checking for the BUSY (PLUGGED) flag catches the
later case. But as explained in the commit message, chained BIOs due to splits
can lead to bio_endio() execution order to change and to calls to
blk_zone_write_plug_bio_endio() to be done after
blk_zone_write_plug_finish_request() calls disk_zone_wplug_unplug_bio().
Checking that the plug refcount is not more than 2 tells us reliably that BIOs
are still holding references on the plug and that the plug should not be removed
until all BIOs completions are handled.

Does this answer your question ?

-- 
Damien Le Moal
Western Digital Research

