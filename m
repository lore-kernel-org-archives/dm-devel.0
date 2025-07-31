Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581BA23E329
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753986622; cv=none; b=FOkkYjKH5sz4mwZ9XkDhHnA4wVCXELiYqwquciXNkaqytMqPh22+sElEnNPjJQXFx+uXtHkbxJRVlzCgAq1Gr2aFJNY7NOZmhMjSaZhmXtlf3m3DLMmo0YQpS8r5B7h9Vwl6zneYFugz2j3MgPMxRPBtAQzexnSp/W/4YLUNLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753986622; c=relaxed/simple;
	bh=2XrwKn6pf54wJzlzE1xULFvPxNfY/Wp4BB0vn4cN0VY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3iQIOgu06vKGRcZiPEyIUkIesi12dsZXmeTFbNSRb2xZD0/XEA7WzSgjAPZbRxF99jzilSu5v4+Xf2Zre2tP+hyuiYFob7vI2L1q3bl9U2QwjigQtD/+nPyaMd7E65PYCtZIapehb7ZWhw8kaMzUYADnZij8X9PDtt3o1TwCcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ew+c3kOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ew+c3kOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7FCC4CEEF;
	Thu, 31 Jul 2025 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753986621;
	bh=2XrwKn6pf54wJzlzE1xULFvPxNfY/Wp4BB0vn4cN0VY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ew+c3kOykseIyUuSil0+vvIqqfz15V+7rChFonxq0ac1k4QA3QKSGEilUtbLHP54x
	 Goe59HhYw38fczyLSwM7OQmuKzTSsZifJwJxKMyiIb9WqSZG9C6tK99rG9A2+HjKDF
	 Q9sPJ0XkH9xA1gXF0dxjkPUGLlctJQqoD4IuwbDU09ePBLUWCUvfgK4otSsyzNN80y
	 u7lKo8IVoZanc5DU/3Cl31dYiCiiQciR3RVbAZuiDVl7xCHu0GxypxIEYH6a/oz3Zs
	 cTzvBT6cMytqw4DsQeLmZOL14JV1qoseEViWpa3Lv0J/nyom8XcoaHNZ+KxPLQ19Lx
	 a8TQ0JyfR1jAg==
Date: Thu, 31 Jul 2025 11:30:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: LongPing Wei <weilongping@oppo.com>, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
Message-ID: <20250731183020.GA1312@quark>
References: <20250730061718.1966686-1-weilongping@oppo.com>
 <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
 <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
 <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com>
 <72f54b80-2e66-4692-a635-0882e9d11631@oppo.com>
 <99a2ab74-55f3-5609-c887-e6c2d5df6228@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99a2ab74-55f3-5609-c887-e6c2d5df6228@redhat.com>

On Thu, Jul 31, 2025 at 06:04:52PM +0200, Mikulas Patocka wrote:
> 
> 
> On Wed, 30 Jul 2025, LongPing Wei wrote:
> 
> > Hi, Mikulas
> > 
> > For example:
> > 
> > F2FS/EXT4
> > ----
> > dm-thin
> > ----
> > dm-thin-pool
> > ----
> > pool data
> > 
> > 1. There is a block of testfile in F2FS/EXT4.
> > 2. The offset of this block is n.
> > 3. The position in the dm-thin device is m.
> > 4. The position in the pool data is x.
> > 
> > The IV is only be affectted by offset in file and the ino of this file.
> > 
> > Even if we change m by defrag or change x by COW, IV won't changed.
> > 
> > The upper layer will only read the decrypted blocks with the same key and
> > continous IV in one bio.
> > 
> > If the upper layer read the full chunk with mixed blocks for GC purpose, key
> > and IV won't be passed in. Then the upper layer just get the encrypted blocks.
> > 
> > LongPing Wei
> 
> Yes - so if the IV is calculated from inode and offset, it seems safe to 
> support it on dm-thin. So, I accepted the patch (and increased the target 
> version).
> 
> BTW. what happens if someone uses FALLOC_FL_COLLAPSE_RANGE or 
> FALLOC_FL_INSERT_RANGE on a file with inline encryption? That changes file 
> offsets of existing data, so it should be disallowed when using inline 
> encryption - but I don't see a test for this in the functions 
> ext4_collapse_range and ext4_insert_range.

This seems to be a question about fscrypt, not about inline encryption
per se.  FALLOC_FL_COLLAPSE_RANGE and FALLOC_FL_INSERT_RANGE fail with
EOPNOTSUPP on encrypted files, as is documented in
Documentation/filesystems/fscrypt.rst.  For ext4, the check happens at
the beginning of ext4_fallocate().

- Eric
