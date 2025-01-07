Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB011CAF;
	Tue,  7 Jan 2025 17:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736270659; cv=none; b=so22KrkCHN0jjzFhJLWVW6uAmsOa5UqxJ8vo5kZOOogjqea+EpgfXG5b9VzjylhxEod3J0Ods2/9JMnEx9hwAQj92YSavu9KjVrRKyUoL4hE29OsnYDhn2XoRfu/XH7wByZqhDwvdcERVhX5E9LTIjEfyMcco6h+l3ai0LccmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736270659; c=relaxed/simple;
	bh=zAHjEo90s8AQe1Ukw3ETz+enBvik3LzwMi+KNu7Eth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vq2UHg8eKROGg0CyHOWmiIjAkwSwsuEw2fPiRjxMKMUYh0jtLuJzaIQ39QVZbX2uE+a8fN+KUfcyP99u7cDzbf64x1VagErlNfVAECA4dhAuRaocrhgu+rALJ/3u7y6aHkQk78CWdJHetMC/et6TPYyekVQV0HCujYaf3fPKNMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZ6E3lbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZ6E3lbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF7DC4CED6;
	Tue,  7 Jan 2025 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736270658;
	bh=zAHjEo90s8AQe1Ukw3ETz+enBvik3LzwMi+KNu7Eth4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZ6E3lbGr5uzAJNdK43Ms4NKmSsdNrraqsxgh0Wi2WeszOj65WlfOKWZKhT3ALWT6
	 nUiz8eyhkSIiSCOizVIAEAY/l5blST+xtwLSeMimAYkg3iCQxX726wLiumYkMwD6B1
	 AxaW/MKokZUv8sxku8QNG+Tnc/SOTemC9MHuxxj4BNE8CwmHRzyARm9j9Hivd0rlwh
	 XjV8p+N5GMgg1UK9LYj9Gjdj4AVTTAk1PJZNQa9m/vgUuCTzoOOVMzcTD9hM+f7fKp
	 wMv09S03QTSpc6sY/DFLV8wdaAvmGwi8/xHDvCQwYTEoh7uktWmTWDdVfH7jhvNmEZ
	 tWtvGYb8M4Ung==
Date: Tue, 7 Jan 2025 12:24:17 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, thetanix@gmail.com, colyli@suse.de,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, dm-devel@lists.linux.dev,
	axboe@kernel.dk, linux-block@vger.kernel.org
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
Message-ID: <Z31jQT4Fwba4HJKW@kernel.org>
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102112841.1227111-1-yukuai1@huaweicloud.com>

On Thu, Jan 02, 2025 at 07:28:41PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecated
> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
> time.
> 
> However, md-linear is used widely for underlying disks with different size,
> sadly we didn't know this until now, and it's true useful to create
> partitions and assemble multiple raid and then append one to the other.
> 
> People have to use dm-linear in this case now, however, they will prefer
> to minimize the number of involved modules.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

I agree with reinstating md-linear.  If/when we do remove md-linear
(again) we first need a seamless upgrade/conversion option (e.g. mdadm
updated to use dm-linear in the backend instead of md-linear).

This patch's header should probably also have this Fixes tag (unclear
if linux-stable would pick it up but it really is a regression given
there was no upgrade path offered to md-linear users):

Fixes: 849d18e27be9 md: Remove deprecated CONFIG_MD_LINEAR

Acked-by: Mike Snitzer <snitzer@kernel.org>
