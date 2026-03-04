Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B957C3CCA10;
	Wed,  4 Mar 2026 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646400; cv=none; b=Lyu5DHtjVxCdps+sj1ewz+o9NTSZqtgh637f7WyYBb4biOnk1c2rfgHLNUMHXXUJK4qxL5Q0fIziKFU/tQ7IoV7xIA2Oq6bTSBGGU0d6Vk1p8FXMVxqWVNOy2o77wOcIxipYfrW9a2SPegKEYeu9ntmURgP/DwuRRgfve/Ykwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646400; c=relaxed/simple;
	bh=lC84N1xq7LDTboIOf9iX2y7ygpiWxBSj2AaE7lgbTTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZgjS7k0OwWvNNEH927fRpPl38+ZYVsUCtThLiRiI8k1/XICF9VEwSjqXltwozNM6f6PcinxVrS2AxikRyAqzqNO63FyoAEn8WGkCa8+E+NOSSpR5SH0VsxRrsQH3mH8JjI90Udo+Ij/TQIYgdylwwZ002Ww5KKf5Up3DMQDkp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrD3dr8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrD3dr8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E72C4CEF7;
	Wed,  4 Mar 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772646400;
	bh=lC84N1xq7LDTboIOf9iX2y7ygpiWxBSj2AaE7lgbTTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrD3dr8FxTLDqAa+X5PmyI0UMqDW4VxypDtf6rLRoi5DFdYINWsYEs84qCQBlBOyy
	 YeqeOkC3j5mDFFls3QwaOzzoPe12pNHFlNIHqp3CaLnVIm3EIMcgYdgIhRJfJWjQGr
	 JIIK1UuPE8Ud4FbcwQrTRU88iClNGrNHDqCDHwVANsHljJ6rV0kVqBycM+B4foVj/S
	 auRLxQK9XM9dxHdJ2JNi+wGmWAuCclUHzainMcR8aryCIS1UcHE+9SiwPhWdxDwYoT
	 AopkwSoFH2ZijDiEZXTjhRP45LRlLXD3gVYgegcKQdAxFPaF59x3TjuEvvJ2X0/qtG
	 YF9UDI8A4FVsg==
Date: Wed, 4 Mar 2026 09:45:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
Message-ID: <20260304174544.GA3342@sol>
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
 <20260303201656.GE2846@sol>
 <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>
 <20260304090013.GA2211@sol>
 <32e6883d-3818-4e7c-b626-4e4f609928a2@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32e6883d-3818-4e7c-b626-4e4f609928a2@gmail.com>

On Wed, Mar 04, 2026 at 10:34:37AM +0100, Milan Broz wrote:
> On 3/4/26 10:00 AM, Eric Biggers wrote:
> > On Wed, Mar 04, 2026 at 09:25:02AM +0100, Milan Broz wrote:
> 
> > Okay, it sounds like the verity-compat-test script isn't open for
> > contributions then.  Would have been nice to know earlier, but thanks
> > for letting me know now.  I'll plan to start some new tests for
> > kselftests.
> 
> That's not what I said, just I would prefer adding new test without
> the need to completely reformatting the test.

Adding new test cases to that script naturally requires understanding a
lot of the existing code so the new cases can be properly integrated.
For example new test cases logically should use the existing helper
functions, common global variables, and failure reporting mechanism; and
they shouldn't duplicate or interfere with the existing test cases.  And
in some cases a new test case may be much more easily handled as an
extension or fix to an existing one; for example the easiest way to test
fec_roots != 2 probably would be to just fix check_fec() to honor its
existing fec_roots parameter as seems to have been intended.

But with the existing script not following modern shell-scripting
practices like naming parameters, using local variables, and passing
'shellcheck', I found that to be a challenge for understanding the
existing code and adding new code.  Especially when these practices are
causing bugs, like the ones my merge request would have fixed.

So that's why I thought a broader cleanup of this test script would be
really useful first.  And I was glad to do that, which I did.  None of
this was meant of a criticism of you; I'm just trying to help.

But it's clear I wasted my time and should focus my efforts on the
kernel, kselftests, and other userspace projects.  So I'll continue to
do that and leave cryptsetup alone.  Sorry for trying to contribute.

- Eric
