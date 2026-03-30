Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEAD27A462
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774894606; cv=none; b=DP6msAXfMq9OK2ITqqjdYjrassTLH2GwWoDaFKJSMjwlmtM5ayl87MEo+w3MpPcc6LFiNhmzysxFclQWTKukiPaMWly3ZYqbrue2/qmbL5qX4QuADfyFvOSzNx3uvDeGX1faH3c2PvPSzgvDc1PjtuNlVeXiJYBa7o2KEA1hdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774894606; c=relaxed/simple;
	bh=OPB7pUMWC9h9NUibHnPsjz8niq7+MflfBl62sPaBYa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXY4CFcjA0oJzeI0UyOuvaaeYQJPtWXgUaEksoZlVxXRdG+kuPUiRro6r01hRwxD4tfMFfyci8OUsTD+oGGqGdNIUwN/61sDYwbfMloEo6PAfHVt58LwEA+5dd5Owe86QAQ9ukeJbOKq7NOdBNb8ZcN3bgRzpi3pH/gPPCrxOJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDtiPV48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDtiPV48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7700C4CEF7;
	Mon, 30 Mar 2026 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774894606;
	bh=OPB7pUMWC9h9NUibHnPsjz8niq7+MflfBl62sPaBYa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XDtiPV48IMU30vj3os+ikwcJAlh9+KWLgbGTu08+dxx3QO+sF9s4XwKCnDPmchAoi
	 38GgaMePJ2mEhONtNQXMF+MXFdAhP0pDivvoyYB3tJkR3VbJaKLhyz/GvpKJan3F0W
	 etKLN/kRUpSaWFN/e7SREIj8gwqpS7C2AiNsD7tZorvKzJJPJZg5r8dHDGs4ph4WRN
	 F/XXCEdATLSm2iNbdo6Bp6NnWiu1CgJ0sIO6Bu9/t9N2+Vb3+2CAMCKvrjE0Oo647X
	 ILG8riOA8Bx3t0gt2kbJVdGDW2bdcG7W41fP0cTXrSyc9alIxq9BdyjLYcDjZDkftB
	 7AqF1vrVrst8w==
Date: Mon, 30 Mar 2026 12:16:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	mpatocka@redhat.com, snitzer@kernel.org
Subject: Re: [PATCH 1/3] dm-integrity: fix mismatched queue limits
Message-ID: <acq-DGNA4-QPmRUL@kbusch-mbp>
References: <20260325193608.2827042-1-kbusch@meta.com>
 <acbdfhN8AT7p4qrN@redhat.com>
 <acbqQ5YaFPMQ23UI@kbusch-mbp>
 <acq1zq78j-aS39KV@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acq1zq78j-aS39KV@redhat.com>

On Mon, Mar 30, 2026 at 01:41:34PM -0400, Benjamin Marzinski wrote:
> INVALID:
> # modprobe scsi_debug dev_size_mb=1024 lbpu=1 sector_size=4096
> # integritysetup format -s 1024 /dev/sda
> # integritysetup open --allow-discards /dev/sda integrity-test
> # cat /sys/block/sda/queue/discard_granularity
> 2048
> # cat /sys/block/dm-1/queue/discard_granularity
> 1024
> # blkdiscard -o 1024 -l 16384 /dev/mapper/integrity-test

This patch fixes that already since it overrides the physical_block_size
to match the backing device's, and blk_validate_limits() will update
dma_granularity to be at least that size as well.

But dm-integrity probably should unconditionally set it to at least the
backing device's too, just in case the backing device wants a larger
granularity than the physical block size.
