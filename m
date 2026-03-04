Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE9738757C;
	Wed,  4 Mar 2026 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772614870; cv=none; b=IIvAt5H2T+AczmvESP/LhwINglV7zwwSScDBYgmhINEl9KTLkndR8LUBIRYo3csithTOk9/rCrIAlgVhmSt8y16v2FPFofByVwRnxzNOgCJpuyISlTfVij+azyjsdpczLfz2ztnguMkQ8Xnvhpc9EwOHwijA6AAUOh6mhC6fDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772614870; c=relaxed/simple;
	bh=ESzdFMKxxVwMXoACFFs7lJ42bKXGQF3nHtio6ZbiIHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhwVU/o5rBvyh69ZJYcOHWWa6ZPtTtlGJCzCvyt7kNuUBUR3pto6vNIN6LD1wyoqPru553xF3bzDuD8gMhsjrnDPmgMS66HeCPDSoLJ3GWLhwGqeu+sABNL+WUxSK7UUIbtuj46PJybi9sXYijgDRFs9VW/5DHzwQ8RzxmHN+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4dxYQ0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4dxYQ0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57339C19423;
	Wed,  4 Mar 2026 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614869;
	bh=ESzdFMKxxVwMXoACFFs7lJ42bKXGQF3nHtio6ZbiIHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F4dxYQ0LxX37XM8+EwatQPlb+PrCVvR2om+6MNwfH5QUaWtv6fj6sSUP19dB34exF
	 9C+5XpEmb411WpjHSkSgHwHLRO72vxdfeIwVk4B7Dkb3ZPZfAdehnVODUCsmCboz9x
	 /sedICIoGWypTl23Yi4zFN1u0bQJXmuYprjFFH34aK7jT1OnflOkhVfbZbcrlWZlVs
	 AHgQmuzGYhXYd/HpixyZ0z1DOb0gAF3ZOtgigiF6ZsbK20RRnoqBc0S02SqrfKIP+7
	 aarPkmFhs9OfX4omaVldku9o1TlLcZq731Y2cf28CsDQ63RQcjiHSdCG2PSe3KUNnl
	 CcUfGsewVf7iA==
Date: Wed, 4 Mar 2026 01:00:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
Message-ID: <20260304090013.GA2211@sol>
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
 <20260303201656.GE2846@sol>
 <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>

On Wed, Mar 04, 2026 at 09:25:02AM +0100, Milan Broz wrote:
> On 3/3/26 9:16 PM, Eric Biggers wrote:
> > Unfortunately the verity-compat-test script isn't in very good shape.  I
> > opened a pull request to clean it up:
> > https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/890
> 
> The testing suite was written mostly as a volunteer effort for cryptsetup
> to cover userspace interoperability, so it uses mostly parameters that
> worked properly with many ancient kernels (root=2, etc.).
> 
> The testsuite was not intended to test the kernel in the first place,
> similar to the dm-crypt one. Despite that, it has found many kernel
> bugs in the past, apparently because the kernel itself lacks proper tests.
> 
> As I am the primary author of this test and have not been paid for working
> on cryptsetup for years now, I have really enough of this "your code is shit,
> I know better" approach without even cc'ing us.
> 
> We try not to touch tests much (e.g., refactoring) unless really necessary,
> to prevent accidentally introducing regressions.
> If there is a QA team validating it, it would be much simpler, but each
> corporation cares only about its own corporate sh^W products.
> 
> Your approach is going exactly in the opposite direction, rewriting only
> parts you are interested in, according to your taste. So now we have multiple
> approaches in different scripts. I am really tempted to reject this, as it will
> add us much more effort in the future.
> 
> That said, I want to add new tests there, but please at least try to think
> about it from this point of view.

Okay, it sounds like the verity-compat-test script isn't open for
contributions then.  Would have been nice to know earlier, but thanks
for letting me know now.  I'll plan to start some new tests for
kselftests.

- Eric
