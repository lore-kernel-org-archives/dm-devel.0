Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1AB3DA7CC;
	Sun,  4 Oct 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134982; cv=none; b=g3sDLtR9N54+RfP9+Vs0s938VYsQbhdZTh+C0Aa86RiGtLXyuCrKcA8swmZj5iffwtbAv2e81ml9RFjG7iqHVCAL3/n1KNQrTztdeU2OeskejM5FF+WVEtekNPxmKYre+vye3yA2i0VY0HmBqCrL1tJt/jHxcQRipGsXwbSfOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134982; c=relaxed/simple;
	bh=9Gg0CV4F8u+OGP3kkxNT4Wqro3Q7p8v0lDtJ2w78I98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mcc1s6t3KIwd5i5s4TXJ9qkwCVna7ziVpThh4Usgr26ngtPHWXRmsgPHtr6F+Qe6ivY/nouKE/giQ2gjyyCdDXiL+XSTG6T2zrkae8HZXHqu0OYl9A0YIG2n8PbHTBU/jftDMqA46tqHcrs/3M+awQS43jyZRxT9ieIvfzlEgnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrBCAF0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrBCAF0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32141F000FF;
	Sun,  4 Oct 2026 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134980;
	bh=Pt6fR7x8I6BlCIwQDroB4QMZ4hSu7qb3GBY64qZyK3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MrBCAF0lhqrPwv3XkO8Px5NBB1kePBxfnhbbeh7cM/ys1auj/mHuhUtfJCfQCkR9r
	 84cVNCi3E3YTpDsfZ/SDiEymff8fJew/T+TzHcwOQ5yY8zAXXNC6MxgO4v5kTbCpV1
	 QdsZI6Ld8jHw965GEUOUGcp0qPlSb01i5lPXKYceAzAMI2saMukZVGy3YMxTczFlL9
	 WgPuMrh9uwnYaNtI9JUMJGCvqN912O6flsxRjMBJ+miqz9VZ+OrB6I+4NUxhmpQ350
	 W01Isnl13Q0RIMG/qxf8prHJa3RBCnaqRCtkxsQD1tjtWDRzNIZWWTSnoh7z1ifmvv
	 wMXuMtesO/q8w==
Date: Sun, 4 Oct 2026 19:29:34 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Lorenz Kofler <lorenz@sigma-star.at>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, upstream+dm@sigma-star.at,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel keyring
Message-ID: <20261004172934.GC1906@quark>
References: <20260928062734.3805458-1-lorenz@sigma-star.at>
 <20260928062734.3805458-2-lorenz@sigma-star.at>
 <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
 <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
 <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>
 <20261002201419.GA205250@google.com>
 <d737b17e-7872-4afb-b4c2-bfa8f4e119df@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d737b17e-7872-4afb-b4c2-bfa8f4e119df@gmail.com>

On Sun, Oct 04, 2026 at 09:44:57AM +0200, Milan Broz wrote:
> On 10/2/26 10:14 PM, Eric Biggers wrote:
> ...
> >  From what I understand, the point of the keyring support in
> > dm-{crypt,inlinecrypt,integrity} is:
> > 
> > - To support "trusted" keys.  But that is not what was actually
> >    implemented in dm-inlinecrypt.
> > 
> > - To avoid having the key be readable with STATUSTYPE_TABLE.  But that
> >    is not what was actually implemented in dm-inlinecrypt.  Keyrings are
> >    also unnecesary to solve that problem.
> 
> There is more to that
> 
> - to avoid key cached in dm-crypt (or other target)
> (dmsetup must be able to retrieve mapping table in the form directly
> reusable for recreating DM mapping, so raw key must be available)

It's of course still there anyway, so that the data can be encrypted or
decrypted.  crypt_config::cipher_tfm for dm-crypt, inlinecrypt_ctx::key
for dm-inlinecrypt, or dm_integrity_c::internal_shash for dm-integrity.

> - to avoid inclusion of key in DM ioctl calls (mapping table again)

Unless the "trusted" key type is being used it just makes the raw key be
passed to the kernel using a different syscall: add_key() instead of
ioctl().  It doesn't seem fundamentally different.

- Eric
