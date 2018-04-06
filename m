From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: multipath-tools licenses (was Re: [PATCH]
 multipath-tools: replace FSF address with a www pointer)
Date: Fri, 6 Apr 2018 18:25:41 +0200
Message-ID: <20180406162541.GB26812@kroah.com>
References: <1521495458.3798.138.camel@suse.com>
	<1a0b44c5-c7a6-85fa-b2dd-1bd542efbb76@gmail.com>
	<1521837017.13100.106.camel@suse.com>
	<20180326130447.3114ef2f@pentland.suse.de>
	<1522067788.19335.55.camel@suse.com>
	<1522073719.19335.66.camel@suse.com>
	<20180326160705.GM3103@octiron.msp.redhat.com>
	<904fd737-b8ff-016f-e33a-5d833ef33c3a@gmail.com>
	<1522250068.5251.46.camel@suse.com>
	<e82ecffd-c7ce-b623-d94a-a3867edae136@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e82ecffd-c7ce-b623-d94a-a3867edae136@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Gris Ge <fge@redhat.com>, dm ML <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Fri, Apr 06, 2018 at 06:10:48PM +0200, Xose Vazquez Perez wrote:
> On 03/28/2018 05:14 PM, Martin Wilck wrote:
> 
> > On Wed, 2018-03-28 at 00:24 +0200, Xose Vazquez Perez wrote:
> 
> > Multiple licenses are acceptable for multipath-tools, too. Yet we need
> > to understand, and clearly communicate, which license applies to which
> > source file, and what that means for the binaries and libraries that
> > are part of the package. And, needless to say, reducing the number of
> > licenses and getting rid of the obsolete LGPL-2.0 would simplify
> > matters significantly, both for us and other parties.
> 
> It would be nice to have the old cvs repo, from 2003-09-18 multipath-0.0.1 to
> 2005-05-23 multipath-tools-0.4.5, online. Or converted to git.
> 
> >> And the SPDX License Identifier is being used:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr
> >> ee/Documentation/process/license-rules.rst
> > 
> > Yeah, it's probably a good idea to do that. I'm not sure if it should
> > replace the boilerplate license header or just be added on top of it.
> > Either way, when we do this, we should make sure that we understand
> > which license covers the individual files, in particular those that
> > currently have no license header. We're assuming that these are covered
> > by COPYING, but is that actually true for all 130+ files?
> > 
> > This shouldn't be taken too lightly. Assume you add an "LGPL-2.1" SPDX
> > header to some file. Company X links to the file in it's proprietary
> > product. Later, company Y finds some of its own GPL-2.0 licensed code
> > in the same file and sues X over 100 million for GPL breakage. Now X
> > claims the money back from the person who inserted the misleading
> > license header in the file ...
> > 
> > That sounds paranoid and exaggerated, but I've heard exactly arguments
> > like this in discussions about proprietary software using FLOSS. It's
> > the kind of thing Black Duck and similar companies make money with.
> 
> 
> Kernel guys are replacing boiler plate text with a SPDX tag.
> I suppose, by advice and with assistance of the lawyers of The Linux Foundation.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b24413180f5600bcb3bb70fbed5cf186b60864bd
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a04c7278d3042cb30c8a66197d900209a4f2417c

Not just the LF lawyers, but the lawyers from almost all major Linux
copyright holders (Intel, Google, Red Hat, IBM, and so on...)

Here's the rules for how we structure the tags and why:
	https://www.kernel.org/doc/html/latest/process/license-rules.html

If you are going to use SPDX for your tools (and you should!), you might
want to look at the REUSE Initiative:
	https://reuse.software/

That provides a great framework for how you should probably tag things
in your codebase.

Hope this helps,

greg k-h
