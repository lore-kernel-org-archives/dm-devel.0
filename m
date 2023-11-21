Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3F54BE9
	for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0N0ke0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD78FC433CA;
	Tue, 21 Nov 2023 22:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700607424;
	bh=xo0rZfEH6XOgDU8QdntjZwVzF3RfcOmi68IeS+5BMbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d0N0ke0u8nUKNqiGzOQVsNoUAQgSoLko6yZo8nn7CfW9Ie6BVukB6bX1ompRMlmE0
	 1TkBNpBJeiJ9MIW+71vtUoP9c62rm9Ecr0o4Sq1umvYuiPaR6YE7fKsE7QGWsLfuGB
	 t8M7ObSFtgwGknfFtn97LRq1uN1MV7ZKLB3sX5Ks6ilZEcTnWOeBbpOSnXQrzOEEA8
	 gDs36YtK8AN/sF8VMTKBenqQlyrLvLmiT2D9Bik4vg25eUUivRUBUOcL5Fzt5Tuhes
	 i/MtnhgzGE/bgcb9yOvEcrX0l0PUIX9azTL+9nw9ZeaVxcsrRbER9HQmBIBd8Er2aL
	 jO2/rDb8+AHrQ==
Date: Tue, 21 Nov 2023 14:57:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Wu Bo <bo.wu@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, Wu Bo <wubo.oduw@gmail.com>
Subject: Re: [PATCH 1/2] dm verity: init fec io before cleaning it
Message-ID: <20231121225702.GA2172@sol.localdomain>
References: <cover.1700555778.git.bo.wu@vivo.com>
 <419e7aa58f67d90020512892f7652623e8c9f059.1700555778.git.bo.wu@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419e7aa58f67d90020512892f7652623e8c9f059.1700555778.git.bo.wu@vivo.com>

On Tue, Nov 21, 2023 at 01:55:28AM -0700, Wu Bo wrote:
> If BIO error, it may goto verity_finish_io() before
> verity_fec_init_io(). Therefor, the fec_io->rs is not initialized and
> may crash when doing memory freeing in verity_fec_finish_io().
> 
> Crash call stack:
>  die+0x90/0x2b8
>  __do_kernel_fault+0x260/0x298
>  do_bad_area+0x2c/0xdc
>  do_translation_fault+0x3c/0x54
>  do_mem_abort+0x54/0x118
>  el1_abort+0x38/0x5c
>  el1h_64_sync_handler+0x50/0x90
>  el1h_64_sync+0x64/0x6c
>  free_rs+0x18/0xac
>  fec_rs_free+0x10/0x24
>  mempool_free+0x58/0x148
>  verity_fec_finish_io+0x4c/0xb0
>  verity_end_io+0xb8/0x150
> 
> Signed-off-by: Wu Bo <bo.wu@vivo.com>

What commit introduced this bug?  It looks like it was commit 5721d4e5a9cd ("dm
verity: Add optional "try_verify_in_tasklet" feature"), which moved the call to
verity_fec_init_io() from verity_map() to verity_work().  Do you agree?  Should
the call to verity_fec_init_io() perhaps be moved back to verity_map(), instead
of putting it in verity_end_io()?  Or maybe another call to verity_fec_init_io()
should be added only just before the call to verity_finish_io() in
verity_end_io(), given that it's not needed in the tasklet case?

In any case, please also add a Fixes tag with the appropriate commit, as well as
a "Cc stable" tag.

- Eric
