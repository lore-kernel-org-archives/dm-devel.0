Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAA1A2875;
	Tue, 10 Sep 2024 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988804; cv=none; b=TPheUsBDprncCzpsohrnKkc8tSW6GJY2pGc9AwGJg7MNo73xbuFRreE/av7qO2/A3NZBqjaLXZRJViCoIXYuDcoaK1L72qZ5edzMPat3ZYg6qeJxuujh7zm65a21iIoxdppafP6mGQkC7pCypVt0TZn9QMTfp/sXIk8t4IKOunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988804; c=relaxed/simple;
	bh=TvaB6J4SPaO1w4vDtpj2zNE8JWO+8r1xf8HiEUcu1xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUANcE93nofGveDODO+D2iCQk4Y4rFaf9zijBdtoJV7zLX5k6+WoaMdT6o4rNnecxFMXmaPULymn7FiicmA5dFKBDi9AEU5EJBptu+0HpZrfOVSSlRqxJy6DGre1xtSdvZ3ntw3TgYIETPdh55LjZXLs0jHRiF+kh4YCJ4BAEYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKlsUtqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKlsUtqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45769C4CEC3;
	Tue, 10 Sep 2024 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725988803;
	bh=TvaB6J4SPaO1w4vDtpj2zNE8JWO+8r1xf8HiEUcu1xM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oKlsUtqjBxe9ewO+kBetG3hSNfCwXfigGim7srXmxu3ikqBMLUeL07dcBc+H13ZWr
	 hyqLMpeBDI3h1zXJQliHtZeT3Rj3iTse2jtsU5BUaMooI6UBu1vHtqwiP3AKMWtg6Y
	 xgPyys2WP3y7oSPbyq+pzBr3EEvEJ5p633EtOWqCUF/dZ8QCRqgxsmUUMPj8QEoVOU
	 +epCFf2DMuKroLqg0rPFXbuApZZ2XTgnEJ8NhBsr7G/fl92Kkk0YlSGZAxSJifpmAm
	 IvKM5fc4EuIWCnxJXZsUhvaggesPsBq1yqfnDApzX375T+/FfCdT/fNvxM00pSAUlF
	 iOh3JGEQALfnA==
Date: Tue, 10 Sep 2024 10:20:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: drivers/md/dm-integrity.c:521 sb_mac() error: __builtin_memcmp()
 'actual_mac' too small (64 vs 448)
Message-ID: <20240910172001.GD2642@sol.localdomain>
References: <e8c80d61-2c74-4b50-ab50-2cf1291df9bc@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8c80d61-2c74-4b50-ab50-2cf1291df9bc@stanley.mountain>

[+Cc dm-devel@lists.linux.dev]

On Tue, Sep 10, 2024 at 10:31:56AM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   b831f83e40a24f07c8dcba5be408d93beedc820f
> commit: 070bb43ab01e891db1b742d4ddd7291c7f8d7022 dm integrity: use crypto_shash_digest() in sb_mac()

This commit seems unrelated, as the alleged issue existed in the code before
that commit too (maybe smatch just didn't notice it yet).

> date:   10 months ago
> config: i386-randconfig-141-20240906 (https://download.01.org/0day-ci/archive/20240906/202409061401.44rtN1bh-lkp@intel.com/config)
> compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202409061401.44rtN1bh-lkp@intel.com/
> 
> smatch warnings:
> drivers/md/dm-integrity.c:521 sb_mac() error: __builtin_memcmp() 'actual_mac' too small (64 vs 448)
> 
> vim +/actual_mac +521 drivers/md/dm-integrity.c
> 
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  492  static int sb_mac(struct dm_integrity_c *ic, bool wr)
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  493  {
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  494  	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  495  	int r;
> 070bb43ab01e89 Eric Biggers      2023-10-28  496  	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
> 070bb43ab01e89 Eric Biggers      2023-10-28  497  	__u8 *sb = (__u8 *)ic->sb;
> 070bb43ab01e89 Eric Biggers      2023-10-28  498  	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  499  
> 070bb43ab01e89 Eric Biggers      2023-10-28  500  	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT) {
> 
> This is paired with the line before and prevents the subtraction from going
> negative.  It limits the mac_size to 0-448.  Is it reasonable to have a mac_size
> which is > HASH_MAX_DIGESTSIZE (64)?

crypto_shash_digestsize() cannot return a value greater than HASH_MAX_DIGESTSIZE
because the crypto API doesn't allow registering any hash algorithms with
digests larger than that.  That's the whole point of HASH_MAX_DIGESTSIZE.

> This buffer is only 64 bytes.

Yes.

> 0ef0b4717aa684 Heinz Mauelshagen 2023-02-01  515  
> 070bb43ab01e89 Eric Biggers      2023-10-28  516  		r = crypto_shash_digest(desc, sb, mac - sb, actual_mac);
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  517  		if (unlikely(r < 0)) {
> 070bb43ab01e89 Eric Biggers      2023-10-28  518  			dm_integrity_io_error(ic, "crypto_shash_digest", r);
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  519  			return r;
> 09d85f8d8909ec Mikulas Patocka   2021-01-21  520  		}
> 070bb43ab01e89 Eric Biggers      2023-10-28 @521  		if (memcmp(mac, actual_mac, mac_size)) {
>                                                                                 ^^^^^^^^^^
> Read overflow.

No, because mac_size <= 64.

We might as well explicitly check that in the code to suppress the static
analysis warning (I'll send a patch), but it's not fixing an actual bug.

- Eric
