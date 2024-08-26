Received: from albert.telenet-ops.be (albert.telenet-ops.be [195.130.137.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C9213AD32
	for <dm-devel@lists.linux.dev>; Mon, 26 Aug 2024 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724659731; cv=none; b=mt3eyRRLnhxvTsUTWRzNNQIx5/LYEwZ48VYYN1ZZMUAtYBSY5n8hwBM2RTiC/evT9uXC36s3T6s28BO/5wWlARXGNWLNz2O2SwvbKF/mNkNQ3rcTVprFG/xfeeLGO5xTwha7RMIyCVH1f+tWHvNSl7s0CpsD47TUgJpR1HNmAuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724659731; c=relaxed/simple;
	bh=rSJrgsmfUsElrCODWDV1oJPTLGA/DsgUQ52abwDQqcE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qIAivYkrYIIBjFvu2bF9djAmoph4P65cfbBfvoa7tcD0kECcps2n2G6xxORn+nlfXpIGd/f+yPPp/Hx2m3IEtLV3qR9YyYMitRTJgyR0r3vkRzpmFvUFi8KYjOgsuLuhcWQfLbMuC0EkUuXBujvSsZxjJtaEPmJuDLDUs1OCLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:344c:fc9f:aaa5:f9d2])
	by albert.telenet-ops.be with cmsmtp
	id 4Y8h2D00N3GuYDE06Y8hia; Mon, 26 Aug 2024 10:08:41 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1siUmH-0011af-He;
	Mon, 26 Aug 2024 10:08:41 +0200
Date: Mon, 26 Aug 2024 10:08:41 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] dm-integrity: introduce the Inline mode
In-Reply-To: <c994d5e-cc3d-d7f5-ce3-fd2cf91e850@redhat.com>
Message-ID: <512a07c-d41a-27c4-b1f9-8fe19352d1f@linux-m68k.org>
References: <c994d5e-cc3d-d7f5-ce3-fd2cf91e850@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Mikulas,

On Tue, 25 Jun 2024, Mikulas Patocka wrote:
> This commit introduces a new 'I' mode for dm-integrity.
>
> The 'I' mode may be selected if the underlying device has non-power-of-2
> sector size. In this mode, dm-integrity will store integrity data
> directly in device's sectors and it will not use journal.
>
> This mode improves performance and reduces flash wear because there would
> be no journal writes.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Thanks for your patch, which is now commit fb0987682c629c1d
("dm-integrity: introduce the Inline mode") in v6.11-rc1.

> @@ -4433,9 +4737,12 @@ static int dm_integrity_ctr(struct dm_ta
> 		ti->error = "Block size doesn't match the information in superblock";
> 		goto bad;
> 	}
> -	if (!le32_to_cpu(ic->sb->journal_sections)) {
> +	if (!le32_to_cpu(ic->sb->journal_sections) != (ic->mode == 'I')) {

As reporting before in e.g. [1], this is causing build failures with
gcc-5 and -Werror:

     drivers/md/dm-integrity.c:4718:52: error: logical not is only applied to the left hand side of comparison [-Werror=logical-not-parentheses]
       if (!le32_to_cpu(ic->sb->journal_sections) != (ic->mode == 'I')) {
 							^

I could reproduce the issue with gcc-5(Ubuntu 5.5.0-12ubuntu1) on x86 .

The condition indeed looks hard to read. Perhaps it should be rewritten as
"le32_to_cpu(ic->sb->journal_sections) == (ic->mode == 'I')"?

> 		r = -EINVAL;
> -		ti->error = "Corrupted superblock, journal_sections is 0";
> +		if (ic->mode != 'I')
> +			ti->error = "Corrupted superblock, journal_sections is 0";
> +		else
> +			ti->error = "Corrupted superblock, journal_sections is not 0";
> 		goto bad;
> 	}
> 	/* make sure that ti->max_io_len doesn't overflow */

[1] https://lore.kernel.org/20240729092807.2235937-1-geert@linux-m68k.org

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
