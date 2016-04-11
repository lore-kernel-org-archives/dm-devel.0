From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entry for LVM
Date: Mon, 11 Apr 2016 16:03:45 -0700
Message-ID: <1460415825.1800.100.camel@perches.com>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <20160411155147.GB9288@agk-dp.fab.redhat.com> <570BCD85.6090807@gmail.com>
	 <20160411162306.GC9288@agk-dp.fab.redhat.com> <570BD354.2000100@gmail.com>
	 <570BF1DB.1040700@youngman.org.uk> <1460408934.1800.87.camel@perches.com>
	 <570C2468.7050608@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <570C2468.7050608@youngman.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 2016-04-11 at 23:25 +0100, Wols Lists wrote:
> On 11/04/16 22:08, Joe Perches wrote:
> > 
> > I'm a native English speaker and I think that's a not
> > a good argument.
> > 
> > Having the same entry for M: and L: where M: isn't an
> > actual person is not a great idea.
> > 
> > The list is not a maintainer.
> > 
> > 
> Depends on your definition of maintainer ...
> 
> To me, it means "should be notified of anything maintenance-related".

I think that's not a particularly good definition.
MAINTAINERS describes the M: entry as:

	M: Mail patches to: FullName <address@domain>

That _person_ is generally responsible for vetting patches
and bug fixing.

> By that definition the list is a maintainer.

Not given there's a specific L: entry that's described

	L: Mailing list that is relevant to this area

> And what do you do if you
> don't have a person designated as maintainer?

Then you don't have a maintainer

>  Do you send everything to /dev/null?

Patches are sent to lkml.

> A list is for general discussion, advice, whatever. Those two
> definitions are not mutually exclusive, and therefore the list email
> address may need to be identified as both/and, hence the two entries.

disagree.

cheers, Joe
