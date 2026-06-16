Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF14466B4C;
	Tue, 16 Jun 2026 18:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635700; cv=none; b=fN1ODT9bhLQfrHe+oL9jzCbFuyjWhWylIwZde/UqHdVPnWZGXZdNRv8elLtl0Tu5KFkcBnbXlI7RrFnfSrdgylH1Corxu9bNOl6am+TwfwKHNfq2BumZo+4Xjrg24V7mKasz7Lcnr1bA+mVt69dYfbl1TZ91+ozgsV7mZ42sCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635700; c=relaxed/simple;
	bh=BqfZzQsSF2SyRHZYOKlNan1KD9WqH5NU4lfrePIQU9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oChXsVZiBLTk2d2vJaT4wXCN7dIqA9A0dQXCnGs8VHz0eZX2f1uc7O0slFxJPA21W1Z05u1Bn6ec/XGrCV0wf8ZQrhIwVrn6nv9BLOr/BwuPlDJ1WbRHiwLXwtMzgyhKuiiVnnZBIZVBj9zWeGj04jQFRrUM4p439gUX7AHzOvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0ppEo5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0ppEo5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914071F00A3A;
	Tue, 16 Jun 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781635699;
	bh=QjjDY9zFKjmU80q6cIbTst8A6/lIZ2Mta9dX+pIDsQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F0ppEo5KykfVn/4ROmvhVDA4D5+5ZI0Chyv/RXK1TE7BK9rGrSQU0pZnuoRpiEqUR
	 ZxW7C6Flqwd07PxevokextBzOTM1ettdFzE+sdup+ZGfLYxtfNTzZDiQdRQDt/qmxO
	 VRKe0mYOhCiodytQN3t37JIDvZgGZ65CM6R1nL0NO3cY9sd4v40FwT41Du9+4n8ODR
	 AxnxNs2Kq+mwUzijsbDwczI4Q+SASzl8gL2k0i/S6GRU+CiOkQTaPG8NFqWoU7p30c
	 /kL3N7WVljymNAobttzmVai1qX0s9XZwoaTvwRyLcxDFeJ63CNBzqa4BtalakjeTHY
	 jxjgsnrsYm1zg==
Date: Tue, 16 Jun 2026 12:48:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajGacnaCZ6v6VE1B@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGN1OKun3qyvqMc@gallifrey>

On Tue, Jun 16, 2026 at 05:54:28PM +0000, Dr. David Alan Gilbert wrote:
> OK, for this pair I think would be fair for a Tested-by me as well;
> they certainly resolve the hang and the WARN/BUGs.
> I still see the errors as EIO on my tests, and on the older mirror type

Could you share your reproducer? I'm just using the original recipe you
sent here:

https://lore.kernel.org/linux-block/ai7rnH20IYeSmY8s@gallifrey/

And I'm seeing EINVAL instead EIO.

> get the stuck resync on write, and on the newer mirror I see the write
> apparently succeed (did it really?)

There was a time when ext4 used to fallback to buffered io for writes
but not for reads, but looks like that was fixed since 6.18, so should
be returning error.

I tried testing it with a modification to your original read test, and
it is still failing with EINVAL for me:

  pread of 4096 said: -1 (Invalid argument)
  pwrite of 4096 said: -1 (Invalid argument)

---
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

const char* path="/mnt/tmp/testfile";
static char buf[8192];

int main()
{
  int fd=open(path, O_RDWR|O_DIRECT|O_CLOEXEC);

  errno=0;
  int res3=pread(fd, buf, 4096, 0);
  printf("pread of 4096 said: %d (%m)\n", res3);
  res3=pwrite(fd, buf, 4096, 0);
  printf("pwrite of 4096 said: %d (%m)\n", res3);
}
--
