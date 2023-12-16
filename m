Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F806FAA
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 07:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7AnDIVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D83C433C8;
	Sat, 16 Dec 2023 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702712186;
	bh=BmIVPCw6yfSWKWiYA5ID6VE4j57nPO0VQ2Q98GS1HAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A7AnDIVfG3z/4byEegqhHDpvY6ddidwOTnCKl4PyLT/bhT1NVjI5qJmKJK6OiYzKW
	 NVxZXQxKA/3qFMDq2uFKj+JteTJhmpa5zDX73yZzvXKZRC8GkGL3kiNwLFRbnOXMFz
	 2JGK4OzURxdUU1uJgbmC7Z9Be9lVs1uESRsF4Qjk=
Date: Sat, 16 Dec 2023 08:36:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Yang, Chenyuan" <cy54@illinois.edu>
Cc: "security@kernel.org" <security@kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
	"Zhang, Lingming" <lingming@illinois.edu>,
	"Marinov, Darko" <marinov@illinois.edu>,
	"Zhao, Zijie" <zijie4@illinois.edu>
Subject: Re: [LInux Kernel Crash] "WARNING: kmalloc bug in ctl_ioctl"
Message-ID: <2023121655-exporter-deed-6fcb@gregkh>
References: <PH7PR11MB576877FF72A9B2D43EAA1AEBA093A@PH7PR11MB5768.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH7PR11MB576877FF72A9B2D43EAA1AEBA093A@PH7PR11MB5768.namprd11.prod.outlook.com>

On Fri, Dec 15, 2023 at 09:47:17PM +0000, Yang, Chenyuan wrote:
> Hello Linux Kernel community,
> 
> We encountered a crash bug when testing the driver implemented in `drivers/md/dm-ioctl.c` by using Syzkaller. Notably, we generate the spec for this driver by ourselves and Syzkaller doesn’t have specification for it.
> 
> Based on our understanding, this bug is caused by `dmi = kvmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH);` in ` drivers/md/dm-ioctl.c` (https://github.com/torvalds/linux/blob/3bd7d748816927202268cb335921f7f68b3ca723/drivers/md/dm-ioctl.c#L1966), which `kvmalloc` a size more than INT_MAX.
> 
> A possible patch is to have a more strict check for the `param_kernel->data_size` in `copy_params` before calling `kvmalloc` while currently it only checks minimal size (https://github.com/torvalds/linux/blob/3bd7d748816927202268cb335921f7f68b3ca723/drivers/md/dm-ioctl.c#L1944).

Great, submit a patch based on this and see if it solves the issue you
reported!

thanks,

greg k-h
