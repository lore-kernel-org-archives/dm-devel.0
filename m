Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AF2931DF;
	Tue, 29 Sep 2026 04:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790657346; cv=none; b=AhSt01s5dHD7U5MFv+n7KW5XgKKfrAk/sduzs/k/7vpg0tYtL4ni2HpdvlNcluMik948Sok6BpQjzmssxrB0QIjlwsyJrcP5+Po7VySzRxQ2t32kyMj6yZCWQxSk9cPGj5CdeKxQ8hYxfeELq8sF7D7RvJjMMWuUgGCW74LO7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790657346; c=relaxed/simple;
	bh=AlN/TsfvQQqYd3eS9KNXp7pO+q5hTznjqQr0RzIZ1Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyoVYYk0ALett1P1TnkKCDLRq3gdq3/tMUaOPukGBZ5fNz4zM+MD0q09z0AHOPi5x12idaiTfHAIgpVvGbijJMzIKPu5y7mP/hiU5O9LgmWYJuQpQa49DpZ/fVe7xlH6MYg3VMDVAOe1Lp6su2pwZZqNkSAaYImE12+1Wcc/Q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEX917HN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEX917HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFDC1F000FF;
	Tue, 29 Sep 2026 04:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790657345;
	bh=m73ooKDdzo67vIh630FhBJ3oWah4aJcp8g/fnjoMURM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dEX917HN2xVOSCXp1NeqaonAlOYXzBWZw6sYlRqBcWqfm+udRWUbl1SIQ2VqeneHk
	 l9DsXLabUEi0oS4fdiCBXbRkmTYMVAar6bhafRcSatILRZjKAXt1fcJUkn5skXHdNo
	 OpjH6Dk815lo562u7FgP8msLFhnJ70XxG0UeX7zY=
Date: Tue, 29 Sep 2026 06:49:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: song@kernel.org, yukuai@fygo.io, chengzhihao1@huawei.com,
	magiclinan@didiglobal.com, xiao@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] md: add a control device for array management
Message-ID: <2026092927-dominion-defeat-eed0@gregkh>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-3-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928201224.3602262-3-abd.masalkhi@gmail.com>

On Mon, Sep 28, 2026 at 08:12:24PM +0000, Abd-Alrhman Masalkhi wrote:
> Add a misc character device, /dev/md-control, with a fixed minor
> MD_CTRL_MINOR. The control device is not tied to any md device, each
> request specifies the array in the payload, either by name, by UUID or
> by device number, without the need to open the md block device.

Why is this a fixed number and not a dynamic one?  There should not eve
be a need for fixed numbers anymore.

> --- /dev/null
> +++ b/drivers/md/md-ctl.c
> @@ -0,0 +1,597 @@
> +// SPDX-License-Identifier: GPL-2.0
> +

No copyright information?

> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index fa9000f68523..0bf2870dc191 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -71,6 +71,7 @@
>  #define VHOST_VSOCK_MINOR	241
>  #define EISA_EEPROM_MINOR	241
>  #define RFKILL_MINOR		242
> +#define MD_CTRL_MINOR		243

No, please use a dynamic number instead.

thanks,

greg k-h
