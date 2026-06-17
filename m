Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722545BD41;
	Wed, 17 Jun 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708900; cv=none; b=bOxBUNHjMen0GlIowd29c03gGxVPVrkMKmKSchEBxQytaThyjlBp94zalyHIha8MODwqq6VrdcJOzcfSAD3hjGAbK1mr/uzScMBtjpw0XxNN1BDd/9c2z2aaz79XJxYC2Kmb/DQS0DzzD01fbAiu8s15WpMLBsYvSVpafpS1LqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708900; c=relaxed/simple;
	bh=vAFuvvV6eQ+bAQlbJ43Rq7O6AdiiGSTwixRgiRnczso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7h7NgJWkVG3evoNUlAAb8wKHZmFk8PRM60Q8CQnyYdvncYFktWdDkeoh5TQnfqDbn9VlFyTEcLZYGm23q/1HnudWgaSrFS/91YsD7EEHqcBt0MthZaU7x8UxNQYyiJ9E4RkTqM/0Jhb26EvpnHAAaVKsUa9URVlntqO5eVHgCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fr6lxUZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fr6lxUZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181C11F000E9;
	Wed, 17 Jun 2026 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781708899;
	bh=aNrhUmf4g+PusUhtLm7bXgfd+WMkwottZtapLy1tiD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fr6lxUZvNt3ihYhqJC8VrFsgmhC/as5G7k4cWA1j20ksGbkzo6ii3V0b/I0br2Hhb
	 rZKW75OfJLBtjPF5xiEulCW/urlFYR+6GUX4vMttYBFtl2698ZKwDByBXy5BB4mJSR
	 5kqJH07z0sy4suTu2W6+d13yNjdkvn3xoKetrtw45p0iGREWgyL7Wyuk8hQESphnLq
	 UpeAx2KOf4aH0iLgnFYEoO5ZU31+4POjw6D2Mxsldfq0oQA/cPmhll1/z69XFPzs3e
	 rCgr/gbCZn2mx/BZvOo6HD1+mRunqpEd5W11W6GrXffkQBQEx3PIkJMcP7ygbrXX7+
	 ZcwRixoamjREw==
Date: Wed, 17 Jun 2026 09:08:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajK4YacvP7eQ-S2o@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGtbuJ2kXo1GZ1d@gallifrey>

On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2

So this is a subtle difference from your original report which ran
lvcreate a little differently:

  # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2

This patch series address problems with the original report with the
"--type mirror" parameter, which uses dm-raid1.c instead of md/raid1.c.
Knowing that detail makes this a trivial matter to fix now, so I'll send
a separate patch for that. But this series should be good to go for the
original issue on the legacy dm mirror.
