Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93BF3C8C5E;
	Fri, 28 Aug 2026 06:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896975; cv=none; b=QR6Jr/gNEdxTWGfGEqJHEThpYXAt7HBC7GoWyAWzbpw5GNCq/UyV+VYWQAKNeshwCEaohcDv7kKOtIqMC88CeU4elmq2kvd+E2wNuOc/8GDfFj/R26NTnqvvkobPEG3NqqZrzZfpzT+rfcyRYoEPsfKcVhsCu/ALA3XxpHYnhXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896975; c=relaxed/simple;
	bh=WPdl5sxQVXPGw9QYaw0BQZ1YTeantlMtlie4W4zjQL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuTiBm5z2TWMJnaAdQnOzx0H8KnaR2atxBdPLxpDe4Fm1g3st4vj5Bi/vgJfa4pGfsVeOZfE0kCHIGZ/5MS/CWHhzdDmAVeyULgepFs59evmU6d8r2iQyQWqylPOcjaOCANGuGa1UPnjaKTq1BEIwwDzLG2um8z/W0f4/m1/AZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gStUaeS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gStUaeS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEAB1F000E9;
	Fri, 28 Aug 2026 06:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787896974;
	bh=xoViLzP7ToxFgx92DLP8z9XB+WReuMIuaIp8gXe4/Ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gStUaeS13no71tFPvWCXfA6VCg8xgIMZaiWtg4x6SeTcIK86yZDgTsnUXGrNr9Ike
	 dqEyYK6g+OWlqvEXhcmuXuhzTSQU2z40Tc9onCrqOw7tLV9xPZS7o5PaXsJOW7pLCP
	 KTz1tTHEJACcGwVZOdXXr42JmNN6bkOaRFnSp3PA=
Date: Fri, 28 Aug 2026 08:02:52 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, falemi@asu.edu,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] UBSAN: shift-out-of-bounds in dm_integrity_map
Message-ID: <2026082856-unviable-stature-8c04@gregkh>
References: <CA+0ovCjSR_YcGORgj8Ydab6HtzJDxjOHZx9OU1L8j0PC-KSXmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovCjSR_YcGORgj8Ydab6HtzJDxjOHZx9OU1L8j0PC-KSXmw@mail.gmail.com>

On Thu, Aug 27, 2026 at 10:51:35PM -0700, Farhad Alemi wrote:
> Hello,
> 
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
> 
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/193-ubsan-shift-out-of-bounds-in-dm-integrity-map/
> 
>   UBSAN: shift-out-of-bounds in drivers/md/dm-integrity.c:2106:52
>   shift exponent 138 is too large for 32-bit type 'unsigned int'
>   Call Trace:
>    dm_integrity_map+0xe14/0xfe0 drivers/md/dm-integrity.c:2106
>    __map_bio+0x5e8/0xa60 drivers/md/dm.c:1426
>    __split_and_process_bio drivers/md/dm.c:1760 [inline]
>    dm_split_and_process_bio drivers/md/dm.c:2034 [inline]
>    dm_submit_bio+0x73f/0x2900 drivers/md/dm.c:2090
>    __submit_bio+0x475/0x880 block/blk-core.c:644
>    submit_bio_noacct_nocheck+0x467/0x990 block/blk-core.c:755
>    __block_write_full_folio+0x7ee/0xdc0 fs/buffer.c:1830
>    blkdev_writepages+0xef/0x1b0 block/fops.c:486
>   Kernel panic - not syncing: UBSAN: panic_on_warn set ...
> 
> Our reproducer.c is available upon request.
> 
> Happy to test a patch if that would help.

You seem to have sent 59 emails like this in a day....

Please slow down, learn the proper process here, before flooding
different substems with random reports like this that are not helpful at
all.

greg k-h
