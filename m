Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907220;
	b=WRfbHp2oIP+qix9cku67N0k8OU1xVU+bBV4jCkItCvZ5LdRpsWY3GQXU4uah5iwgZtzp
	 N92+SCWbZL4S9YC7vTMgsAdDoBpRL1uuuUZTviStsio5Fr19g5kR/VuKPOvLcsJwD1m8M
	 o0C4J3q34YOse7tRGE7+u5y/1W+C5arPv7DUzU/1q+bdUAIA4y5CIkXAT+BHb1h6xeLnn
	 l2Q68oU6YCKc230tBWsLy8ims5sjEsc5NiglD7a/MUXuLcXSwg+rx1vlKTh+BkuRsZNGe
	 fUQ5PDU12uOlCfl2baNRPs6je/2jht1UeoPBJ8AJ/6xuZSy47IGj5PfK2QRDT/rb9qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907220;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XbhAnP/ILmrqrHVcsIMgwEAju1oHG3WmXGNKBJobHD4=;
	b=StHRWHI/Bub4Q030c6M398n84GWPzZKmVzpgYmKLeAdJFT4e8bQvrWpr6WyHpG4q0yjZ
	 OR82x86//QOO3sm9lfLPrCIAZkc2iD63XbFBM9OOjZHE9UsuXb+U0B6xoo4EmQZ3aaf/i
	 i6aTTqFaGVGCukdf/idG8eAmreUhEMYcl/Iu4DPuwLK+6Jd4H0OW49O6M8USGw6SQNcyH
	 r/hGJvaH0e5sDOCR/hzANaQNpT3PcX4G+AmTA3EU3I6gk3xN+HGE9NIiW+ofQj3fXZvG4
	 ZcQe0QcKR9Y2JeP5fwRK6pdrj7IbzD1VsEX09sXEdf2v1k8YNf7tIMTqzSaLh3oj/Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrLoezKO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD43606A335;
	Thu,  5 Nov 2026 19:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrLoezKO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4201F000E0;
	Thu,  5 Nov 2026 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907219;
	bh=XbhAnP/ILmrqrHVcsIMgwEAju1oHG3WmXGNKBJobHD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GrLoezKOzShcBQLOKvcfucBO6REFy5MhJrmOrbkY13/Ul2Twvv4PbjWauaKr3JXrZ
	 8VMic7xYvekP3HDGPnCl3WvcGcIiqWoGMUzdbkj2b3eSYxCdsFdFfr+xLOeE4bzJdA
	 r1ECZoj3qLcAM7dr74EVBEfH/1zfiZ0lvfz2ErzOwCGsUDjBVW9OG7wi5Ai8zVILDO
	 PuyL7lPIKbWhkifkUVWfCNI7Ks9728Gx1KvYMifWNoRr5qU0Xj9h8vqG4gYPcWeSpU
	 q6EtYyKogjRAO72NeNBpneGGjPJKGwtFCcwKwmHnCUz4x8U+oiu0qZxURsBW6Iud8r
	 CLb3fTxcKZO7Q==
Date: Thu, 5 Nov 2026 19:33:37 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10/5.15] dm-verity: fix buffer overflow in FEC
 calculation
Message-ID: <20261105193337.GB3266627@google.com>
References: <20261105091903.1866-1-mdmitrichenko@astralinux.ru>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105091903.1866-1-mdmitrichenko@astralinux.ru>

On Thu, Nov 05, 2026 at 12:19:01PM +0300, Mikhail Dmitrichenko wrote:
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> [mdmitrichenko: Omit the erasures array size cleanup. The older
>  implementation already allocates 253 entries, more than the
>  maximum of 24 roots.]
> Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
> ---
> Backport fix for CVE-2026-72098.

Looks fine.  I would have mentioned that 6.1 needs this too, but the
same backport was already released there without dm-devel being Cc'ed
anyway.

- Eric
