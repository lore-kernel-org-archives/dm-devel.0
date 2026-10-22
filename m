Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655882;
	b=1YuR72IhQCJN8y6qeReMxZCcZCJcTuEy70t/ZWYeVeONqodjlfKqXlqXcW0Av4he/HRT
	 4KxUYtQBKRVq2uwGmtvxCwfeRnM0XYZRpltgrAVR8qahWLi/vAacLlmdxMdD6/haUsgNp
	 CejYOk3UwbPRpSUnJeQhMZhjLvUI89aR3naJ+yQiY6BalBKIRKbgBl82qg7DtG8PjpTa1
	 7tyiI/1C7mElcneVdqW77brH0K+RhB+U9XKZK6wgh7WxGG3RQaqhfCfmwRvC3z+mVoi9s
	 hfLJkPXFKyg5j5vvWMhBy9C1btqFa9mCe5wpHGSC3qyhaVxrv2VCyIK2DFVzwnDE7oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655882;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=al8LwFXKhQMtvebVFFNkSePOwM1a+nny9q2UkN6c8qQ=;
	b=PmUQp14TQgvPbXEY6otMDRh79jRtnOa4B7YjWXtc8u6zk8Y4kmF6J0wRJD1VoEE4DsOw
	 Q76hj/fjwuAjBwQjwgrcd3ZnFvpSMK9l5CVlV09ciQE9HMZcVRuz6O5lROFBW0arxB3sw
	 Stj//vFURMd8CxI7nMb7/DOGeLY+az3A8WBitvYy2kMpZKhUWg6elfc1Hrr7Q+g8KXd7F
	 SjzddwNQTC6vGLd1zWwtNPY8CrGoM4Tq42vwH/euif048G9hwEnRDvPTVYViiFPWDjVyG
	 6QoCkRnC8KyPBZyzB1+t+6+P0Ubb0pVCC+2vQRtbDi/vhDSjUpGT3anwBrtDTJmdqQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MN+AbLU1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80F606A31B;
	Thu, 22 Oct 2026 07:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MN+AbLU1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7D31F000C3;
	Thu, 22 Oct 2026 07:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792655881;
	bh=al8LwFXKhQMtvebVFFNkSePOwM1a+nny9q2UkN6c8qQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MN+AbLU1PaXtQMdHTbIw9lN2dZHitBsiJyxN9RFxBjlIR/IyvxbIQWOMxrfU797R5
	 2S06k9AsMgZk3UAEHtD67h8rt1G8O3bEL6ZmbFlETGW+MxQjf7egNoogt1aI5Yvb4a
	 omIqB66NL8P7tg8jN28ej/LAO00kTQJlnY94wvsY0qIuwI2O/xZQyDI6d1qKNfc7dY
	 3FSoXyakPbW6lzVzjoYN97QIH5zOi2Ejw/zp8wIyh5Vx2Aph6CD7H6NCPwUJ/rsIri
	 sDmE7hjoqKSLKA4ZA++CcFfmBiuR26UwTZNIrVJcqgsdW01BOCxzsqFqyfPWT2mHfR
	 bNn4nQGbrhWZg==
Message-ID: <ff60b44b-e85d-433e-9c08-450474c7af09@kernel.org>
Date: Thu, 22 Oct 2026 09:57:58 +0200
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: fix infinite loop in dm_blk_do_report_zones()
To: Mark Bundschuh <mkbund@amazon.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 stable@vger.kernel.org
References: <20261019192819.3962873-1-mkbund@amazon.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261019192819.3962873-1-mkbund@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/19 21:28, Mark Bundschuh wrote:
> If the device underlying a zoned target is removed, its capacity is set
> to 0 and blkdev_report_zones() returns 0 without reporting any zones.
> The mapped device keeps its old capacity, so args->zone_idx and
> args->next_sector never advance and dm_blk_do_report_zones() loops
> forever. On non-preemptible kernels this causes soft lockups and RCU
> stalls.
> 
> The following sequence of commands triggers the hang:
> 
> modprobe scsi_debug zbc=managed dev_size_mb=1024 zone_size_mb=64
> udevadm settle
> echo '0 2097152 linear /dev/sda 0' | dmsetup create lin
> echo 1 > /sys/block/sda/device/delete
> blkzone report -o 0 -c 1 /dev/mapper/lin
> 
> Fix this by returning -EIO when a target reports no zones. The target
> always maps args->next_sector, so a zero return means the underlying
> device no longer covers that sector.
> 
> Fixes: d41003513e61 ("block: rework zone reporting")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark Bundschuh <mkbund@amazon.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
