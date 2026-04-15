Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB74538AC7D;
	Wed, 15 Apr 2026 07:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776238826; cv=none; b=MzE7KK/3ImGpI3q6eXnH3ZJBZ3vCV5Vx14Mrwi0+nzSSuwBkPlw5r7Q/rUrYN/CDTMbSsnXpDQSHDVt2uEbdUhVlVi84xg6soSU7ixRz/NIzJRLKv+Rk7nBUg+qntiiz8lIZ7kw4oBLBfDU6dOSf/qKIJ928nptnLAXQRolWlWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776238826; c=relaxed/simple;
	bh=FVy8jCFlUIveZkRvfAIgAH4jdv76uLaL71KeKyWWa0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDmgt0vUBD6lMePu3/+cLZCuS174JxuXY0I5/ZXtt1Go/uQclbD4hoFg+kg0jendx1u/fz316liD3fxAQtdILi7azijKos+awsFEPVAvTOrk6YlneSQQzu6ql2g28BIFzlcolYFXZWkkCKZUWAUf1B4G59YXav0uZARzpW8ZAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GRC7t/3b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GRC7t/3b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NQ3FGyj3bB3s3TzgG2AxlTj+u1qB1K3Y0IxoIVLKrvk=; b=GRC7t/3bI7JrNSLxeAMHgwX0K3
	xAtrXImzdHW7DjijCOvWl5uo9/a2L4na/HS9F/pxZocXEzRMU9/3W/DbnhQtfjmntUMumfaekHgVs
	JkymKksYscQDAWhsY7kaP5ZNlpkKxH790qgELBntdnQznef/Q7gbpvWEjZjYwEWaDeBReSTC31Vz9
	0/CNYrcSJDjOUbJO0e8rx/bKOLGKBkSTdCrQ4PvelVDl+p7o76807HnUjeXj973wAqCmNGzxM63WD
	75DdlQQAK05ZULtWENPz2ItUB2af6iD5mfwoGpmuXIYGFtnoqIRoCIa0Grmtn6PPrY8x33yj9B1cg
	ULLy052g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCur6-00000000k4p-0j2C;
	Wed, 15 Apr 2026 07:40:12 +0000
Date: Wed, 15 Apr 2026 00:40:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
	sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
	rostedt@goodmis.org, mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <ad9A3JahjIcVkkQG@infradead.org>
References: <20260415070137.17860-1-chensong_2000@189.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 15, 2026 at 03:01:37PM +0800, chensong_2000@189.cn wrote:
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 132a9df98471..b776dbd5a382 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -56,7 +56,6 @@ static int tts_notify_reboot(struct notifier_block *this,
>  
>  static struct notifier_block tts_notifier = {
>  	.notifier_call	= tts_notify_reboot,
> -	.next		= NULL,
>  	.priority	= 0,

IFF this becomes important for some reason (and right now I don't see
it), please start by using proper wrappers for notifiers so that the
implementation details don't leak into the users.  That would actually
be useful on it's own even.

