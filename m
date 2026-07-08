Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EC13BAD92;
	Wed,  8 Jul 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783533453; cv=none; b=qkP6AVXC0TpVNxQtPb4n5XgL2XXNRtNaWq9kpEpAF60ZtVOT5poyVx9qiPAkLQtwU6eimWkzip0cTsErosHgvix9z17Sxnji5zhKIair8zg11nAlWq8Z0ca1uRpwUUSsTtC5EgegfR0Hp6r3Qv3fvlmndGqJ6dqV3ep7H4JOGiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783533453; c=relaxed/simple;
	bh=G56W4DDJLZuXrS1a33xgAAxV4nxbUwT6OtmNicP29y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NwwsXd9dtR595TpOGZ0M5Jp5cvs7EgHEMZ9l5pcFItcoi4PKxA7aMyrC4uxUO7ejIVhOTDq32Xgbtbm1CviEj8nMPiJFcpjJx6fT4NmfAoan6tJTsSpooinarDzkFX3p34Y1UXBX/lwWdfQtrHXxAex6BNI5D0DlMYihZenn0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol6ZiYjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol6ZiYjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3836D1F000E9;
	Wed,  8 Jul 2026 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783533452;
	bh=2rAvJWDeCi5BChdLlz7Z6aK49JC/EG/G+aQ0mH42jqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ol6ZiYjRsrzqvpHeGalmlSLZ+/yb07HzaeR33kTCk+OCHwwSBPQeSgx8vT6kQvP8Y
	 3s3CQW7Va7/6T+bhy8leYPRGI38wKHzi6RuR+gVqrfeHO3enemDjUnE97vJdOv86R4
	 P2O8nBvImx1yXr5OHHIds//jlRpmUAo0o+NMuAdc1iOpmN6hW5+ESjZaSmpSFw39PZ
	 Yj5735q6uNk98mp51bqzOvPhtOpjczePv+gpUp6ZKjGNB7R//3SMFnPDTMDdeKH0Vp
	 8P8V3ZrjA2uFmA5hYx75kGNvNewHIl8Y0MHK4uWOxBslsu6l9k0vY6TA54AIbDosGF
	 /Bn0Js3TwUbXQ==
Date: Wed, 8 Jul 2026 11:57:30 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: axboe@kernel.dk, Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ak6Pire-LnJeHMHa@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <ajFyuoMqnvQm738z@kbusch-mbp>
 <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
 <akwVkSnXtyl6rBdh@kbusch-mbp>
 <ak1XNlyFC34W47iP@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak1XNlyFC34W47iP@kernel.org>

On Tue, Jul 07, 2026 at 03:44:54PM -0400, Mike Snitzer wrote:
> So where does dm-raid1 and dm-crypt stand relative to these DIO memory
> alignment changes?  Inferring they are pretty exposed.

dm-raid1 currently has a gap in handling badly behaved direct-io
applications. Worst case it may return success to a failed write command
that used to return an appropriate error before, so a silent corruption.
On reads, it can cause the array to be considered degraded when there's
nothing wrong with it.

There's no errors with dm-crypt today that I know of. I just want to
make it to be more aligned to the backing hardware.
