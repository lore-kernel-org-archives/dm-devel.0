From: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Wed, 16 Dec 2009 12:59:35 -0700
Message-ID: <20091216195935.GA551@ldl.fc.hp.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762455AbZLPT7j@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

I've no comments on the actual patch but...

* Mikulas Patocka <mpatocka@redhat.com>:
> Drop 80-character limit in checkpatch.pl
> 
> Serious issues:
> ===============
> 
> (1) The code is hard to edit with common text editors

You mention vi; most distros provide vim these days.

In my .vimrc, I have:

	set ai
	set si

That helps a bit.

> (2) Grepping the code is unreliable

Reviewers (at least in my part of the kernel) have been
requesting that user-visible (and thus developer greppable)
output be combined on one line precisely for this reason.

We've been rejecting patches that unnecessarily break up these
strings at 80 cols.

> But some maintainers take output of the script checkpatch.pl
> dogmatically, requiring that every new work must pass the
> script without a warning.

This is the real problem. And I think the solution is to lobby
your maintainer.

fwiw,
/ac
