Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB7D149C7B;
	Tue,  3 Mar 2026 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772569072; cv=none; b=jzVCeaIJJxNlauzaeu637jxjBC0F2jRnUHkC2xmGz65eZpVqms5abY1VtLon2d+iz6XVdX7aMkBgg0ksaquXMnwt1Y8r82EwH4n1J2VI/g12iOfIPWP3+rXFUu9lJn4Up1WcmYm8jOQghMfXQU+pqNT3i5tCHfh10+rnqe2W4PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772569072; c=relaxed/simple;
	bh=u3dNGvXC26ETICo5jJCfeJ8Yg70Gdd4NDPFa8bCpAuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx+7BkMeCINieAV5XbqKFsD6ixPP4hmqClWjTDAbvl+FXsdffPLhAlBW5hAW7uy2ESzaLj/f1MZTFqIYtBUhSX2TI9ZEk3d2D/w+35Hw/Mg+yet+z2tSsIUXppAyx1AoFDER0LkPL+SduZOe1g+DX0x9WL9SWPJW+knQ33Z38FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/IzHq2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/IzHq2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985EDC116C6;
	Tue,  3 Mar 2026 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772569071;
	bh=u3dNGvXC26ETICo5jJCfeJ8Yg70Gdd4NDPFa8bCpAuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/IzHq2qM5pFKopFFC/Qce4sjLDefOoG6fglrpibYTiFRstSABep4y4h/KaVL7bz1
	 jpIPoNJOzr3R5hnSvm74zwkMaqa7TznuI//dqnw8Vdm6VdKTGoIwSC8aDhxDUZIeu3
	 uSO8l6CQgXugQIEDmcCcZuP5tEhtGuCgHOjIczXoAgPd17PE91kzT3RpicZtmEJBOs
	 2T3zIjN7Q2xJ2WHqPKdFe2Q4FHAiOHo2+HVOJSXcdgZ7bCNyKfDOR7ips8yN6n64qB
	 noaSFVHmjOOQN0sdfDEaUFnBNkUBGV6QBwCtKjeanG9t/+KxmfroO7TjDInL4OvQY4
	 eRkqcStb9cDJQ==
Date: Tue, 3 Mar 2026 12:16:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
Message-ID: <20260303201656.GE2846@sol>
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>

On Wed, Feb 11, 2026 at 02:29:28PM -0800, Sami Tolvanen wrote:
> Hi Eric,
> 
> On Thu, Feb 5, 2026 at 9:01 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This series applies to linux-dm/for-next.  It can also be retrieved from:
> >
> >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git dm-verity-fec-2026-02-05
> >
> > Patches 1-5 fix bugs in dm-verity's forward error correction (FEC):
> >
> > - FEC and hash devices that are too small were not rejected.
> >
> > - Corrected blocks could be multiple-counted in statistics.
> >
> > - The erasures array was significantly oversized for its use case.
> >
> > - An out-of-bounds read could occur when decoding an RS codeword whose
> >   parity bytes span a block boundary.
> 
> Thanks for the fixes, these look correct to me. It would be nice to
> have tests for the edge cases though. Perhaps in the
> verity-compat-test script that's included in the cryptsetup repo?
> 
> > Patches 6-22 clean up the FEC implementation to be easier to understand
> > and improve documentation and log messages.
> 
> The clean-ups also look reasonable. For the series:
> 
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> 
> Sami

"FEC and hash devices that are too small were not rejected" should be
fairly straightforward to test.

Testing "Corrected blocks could be multiple-counted in statistics" and
"An out-of-bounds read could occur when decoding an RS codeword whose
parity bytes span a block boundary" would require injecting kmalloc
failures.  It might be possible using the fault injection framework.

"The erasures array was significantly oversized for its use case" just
changes the size of an internal structure.  Not testable from userspace.

Unfortunately the verity-compat-test script isn't in very good shape.  I
opened a pull request to clean it up:
https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/890

After that I'll add test cases for at least the "FEC and hash devices
that are too small were not rejected" bug.

I noticed verity-compat-test also never tests fec_roots != 2, even
though it contains code that seems to have been intended to.  So I'll
plan to fix that too, though unless we're able to add fault injection
too it won't specifically cover the bug fixed by this series.

Anyway, point is, I'm indeed working on improving the test script.  I
think these patches can be applied for 7.1 either way though.

- Eric
