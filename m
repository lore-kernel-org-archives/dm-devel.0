Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB73264F80;
	Wed, 30 Apr 2025 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746031839; cv=none; b=AdZYQ6sDtTNCfIlmTu5Tnr9S4ew3u3sqAtQrteeMz15ad7YXdg7ZxrUZZLUuaW1BzvlyEvC6hou7isTfH3kpph8TtRy3+6qYPSTqgmoi/1B6MOPswUeQRyp0vCZGqPdHben8g5aW74k8tsr8QZcAUgDY3ZUP/mYNmg6kzyoTXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746031839; c=relaxed/simple;
	bh=7FLyNQqLAXLRXt+26yk0XhCNT6yZ4k2r44O6UnXDvrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6vAH/7a4GCsDcK7gVpuXcXr3Qk/d7b6cNtOkEMVSM3HVNpn9yrKuTjKA7AYTyjotd4GISpf/w0h8BhDBBqZyvimYEYDoItiLwN3rNuKHWb51n5pCorWzVIBvjn0h4iCwFzlv1EhHvR71WC+qwdvnAdd/acIaM+BNHZjKEdqr48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJ4EWD9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJ4EWD9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7CAC4CEE7;
	Wed, 30 Apr 2025 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746031839;
	bh=7FLyNQqLAXLRXt+26yk0XhCNT6yZ4k2r44O6UnXDvrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OJ4EWD9bGkACtycMYEy7H4W8INkGUBV1aN4iL6c3IZ0Qrl11jhh65CIau8EoPUBx1
	 79KkOd8bIfhnNEJZsyqDBEtsU7n4QFUd7vEgSvmiN9ebp/ptwk/1dp9/QOwZMugdHV
	 GmQEmfc/BfSZyDb79vGi1/zMRCaZdQaz/0MGKHYk4twpjsrB9SrmkogR31MmRGlhaI
	 W/qbCpXoNVdI1vdAReStSJ6ISkif3fsveqeAbnvqZI9J989O80ghwVxMEHpOZ1wgMk
	 +cKVoxU1krTDnJ9rucm4rI0hhsZPNDrSbqSuyCIZmpR7OWULr2ARmo/Hxos+IV5xtk
	 Y6ylLSAo9YwJw==
Date: Wed, 30 Apr 2025 09:50:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Satya Tangirala <satyat@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] dm: add missing unlock on in dm_keyslot_evict()
Message-ID: <20250430165037.GA1958@sol.localdomain>
References: <aBHZ4puON8GNK0vw@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBHZ4puON8GNK0vw@stanley.mountain>

On Wed, Apr 30, 2025 at 11:05:54AM +0300, Dan Carpenter wrote:
> We need to call dm_put_live_table() even if dm_get_live_table() returns
> NULL.
> 
> Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/md/dm-table.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

But that's an awfully error-prone API.

dm_blk_report_zones() gets this wrong too.

- Eric
