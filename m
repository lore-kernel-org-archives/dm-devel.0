Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AF9314B8F;
	Wed, 25 Mar 2026 18:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774463690; cv=none; b=p8eS303kcX5Scqf2TY515ruVTIBZModL0gQCznQkkFP2GHTSDzGFUpBVDY5eY9lAGegNqFJOqlXCyEkXNzPs/v/5zzgC3kixpN8CaWQkesINcloBbq3+51pR8LxIivuEwEhp3u8Mpyi75sI675pq0yy6CTBCEhba4+nO4ITwLD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774463690; c=relaxed/simple;
	bh=gFdhIT7zohDFHph+YzuIffzKIM3BcR+OhAMRrbLwYmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tn1Np6aduL1yqE+8N+aI1yNehVMHoMfKytciAg7peoyN2Jhdf2T+e0QrUikaa278ux2NtliN2PDzw6fjHpjey3sBtHVU+ven72jzpyUniYo6YeWXqofFjhVAl7uziUXFtABr7kgp4b/dMdwps59m6Zc2PPxHxoVxO3cMaGo657U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGXd8KxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGXd8KxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E72C19423;
	Wed, 25 Mar 2026 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774463689;
	bh=gFdhIT7zohDFHph+YzuIffzKIM3BcR+OhAMRrbLwYmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MGXd8KxYJf4fgBG6VwiOt5iufYXHRH7MWHTrzV2OIbYeBM7yRbx1RK/h1WjVojN3L
	 LDl/ABFiCgesosTt0C3A7sr8SE71c6JqHzg0j/azYeARRTRWojpQfXnbk+AOKMPqq7
	 ZUJDlbFXtVb15z8vszsX8CxIS3FzHOeSQmAbsc5itkWnJNDlt6PNxUWudYlppJ7nOk
	 ySg3rkj4M1+gXkofITpBHiDcrwtx9Gmj/WGuJFD6VJut0dMfUpjTduXyVkP1P92HM6
	 POqTNq40OMKGUDteQ/rWZqZXwsXQttFZy1fVm+CTxLJrWhyAT6JZ38SL7JLvATdDFo
	 La+0Nhmdjd52A==
Date: Wed, 25 Mar 2026 12:34:47 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for
 direct io
Message-ID: <acQqx_gCjHmP8BGR@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <7cc4892a-5a2f-09b7-1f32-320acac4c797@redhat.com>
 <abrjgdttXBHCFh34@kbusch-mbp>
 <fa0978af-398b-a212-73bc-80f0f2c375a4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa0978af-398b-a212-73bc-80f0f2c375a4@redhat.com>

On Wed, Mar 18, 2026 at 07:06:40PM +0100, Mikulas Patocka wrote:
> 
> If we have dm-integrity with 512-byte sector size on the top of a device 
> that has dma_alignment less than 512, the code would set 
> limits->dma_alignment to the value of the underlying block device and 
> break dm-integrity (which assumes sector-aligned bios).
> 
> But that's a problem of dm-integrity - this "if (ic->sectors_per_block > 
> 1)" condition in dm_integrity_io_hints is weird, it should be dropped and 
> the limits should be properly merged.

Looks like dm-integrity is a bit weird for other reasons, too. If a user
creates a dm-integrity device with block size of 1k or 2k, but the
backing device is 4k logical size, we'll have a mismatch from what the
dm-integrity block device reports compared to what it can actually do.

The pattern needed to get it right is repeated several times, so a
helper is probably warranted. I'll put a series together as a prep and
fix up.
