From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] MAINTAINERS: correct entry for LVM
Date: Tue, 12 Apr 2016 00:31:51 +0100
Message-ID: <570C33E7.2060906@youngman.org.uk>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160411155147.GB9288@agk-dp.fab.redhat.com> <570BCD85.6090807@gmail.com>
 <20160411162306.GC9288@agk-dp.fab.redhat.com> <570BD354.2000100@gmail.com>
 <570BF1DB.1040700@youngman.org.uk> <1460408934.1800.87.camel@perches.com>
 <570C2468.7050608@youngman.org.uk> <1460415825.1800.100.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460415825.1800.100.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On 12/04/16 00:03, Joe Perches wrote:
> I think that's not a particularly good definition.
> MAINTAINERS describes the M: entry as:
> 
> 	M: Mail patches to: FullName <address@domain>
> 
> That _person_ is generally responsible for vetting patches
> and bug fixing.

Ahh ... you are ASS U ME ing that it is a personal email address. Why?

And that person is going to get overwhelmed if the system is busy ...

I can't speak for anyone else, but if I were a maintainer I would more
consider myself an integrator. If patches are NOT sent to the list, then
there are two *likely* scenarios. Either

Good patches get dropped because there is no discussion, or

Bad patches get forwarded because there is no discussion.

(And on linux-raid, where I'm reading this, I think this is very much
the current state of affairs. Neil Brown has stepped down, and iirc the
person who has taken over actively wants the list to review things.)

You are assuming that "FullName" refers to a person. If I were a
maintainer I would personally be very upset with that state of affairs.
Why shouldn't "FullName" be the full name of a mailing list?

If I were a maintainer, it would be "not vetted by the mailing list? Not
going nowhere, nohow". Patches get sent to the mailing list, or they get
ignored.

Cheers,
Wol
