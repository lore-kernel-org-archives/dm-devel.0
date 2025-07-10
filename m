Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F772FCE24;
	Thu, 10 Jul 2025 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752170890; cv=none; b=McTLCniVPVwDvW21FjJMMljwBBSS6lsL6VhI9v6HIg5MWItka+W/SifEVsI6b+FYazzbiPsxnpwC4kjtgbK+MeQ4gkoWeGHkEcnsyvXqdtMDXX217WpDeKsFNPbjmnAJgR8vqn79y3nuy2r7VUotiSsn2biUL1fAUKwsk/wjGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752170890; c=relaxed/simple;
	bh=0iGEbhoJG1uhY9KwlCIXdql0VXqhqY9Lo9DxoN9jeOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qwbm/P3msKzNU1Tkj6UxrtoV4iFFi+Gq0KR7Utka29XdHzkXPAugbfpaRxKzPET8Cz61MmQUY6Avh5zJyPDIpz5ZynOhCPRZap8XYocZbT/a9qOEc/k1UJq77i5ewZAK6jsXIQ5lH1nllue7J1iBxXkc43HOWAx8795XSOjTLnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdx2uRFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdx2uRFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07FDC4CEE3;
	Thu, 10 Jul 2025 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752170890;
	bh=0iGEbhoJG1uhY9KwlCIXdql0VXqhqY9Lo9DxoN9jeOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sdx2uRFpAN20nq6wJ9TO4OukUaUHv+IMnFZem8vrTZ8Iedz6nBUo7OGPdiqZEj5u4
	 22Gj+EN15Vw0N5xT/26ZQ0nYm3QobuPVdt1yDAzEwWXVHh5/JBbDZuhTrAnQWI5vDl
	 prWWviHXjUtHDAXomjYtnC1bpCrSF67Ix6rHkqZArbzXAnHZc+VmZxFyG2X1M3Ajhf
	 bUMcC4XPQrC4oVdZsoVlrrmjHaQe1Psg6rbgYLBOxDXE7clus2g978L2bN4SxmYcBj
	 qwbT/dSEuWgSu9PlGaM+CBn4tmP2rGZvv3eTMNCOFM1kqCV2fZodPu92MlslJy/dpl
	 4Jd8Gdb7OdhAw==
Date: Thu, 10 Jul 2025 18:08:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
Message-ID: <20250710180808.GA2233502@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>

On Thu, Jul 10, 2025 at 10:28:55AM +0200, Milan Broz wrote:
> Just one nitpick - could you please increase minor version of dm-verity target,
> so we have information in debug log that it is a patched version?

I see this is already in linux-dm/for-next with the version updated from
{1, 11, 0} to {1, 12, 0}.  So I won't bother sending a v3 with just that
change.  Thanks!

- Eric
