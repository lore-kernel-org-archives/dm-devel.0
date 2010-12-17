From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][rfc] md: Close mem leak in userspace_ctr()
Date: Fri, 17 Dec 2010 13:18:55 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012171315330.4638@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net> <20101214221816.GA14227@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101214221816.GA14227@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 14 Dec 2010, Mike Snitzer wrote:

> On Mon, Dec 13 2010 at  6:40pm -0500,
> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > Hi,
> > 
> > There's a small memory leak in 
> > drivers/md/dm-log-userspace-base.c::userspace_ctr().
> > 
> > The call to build_constructor_string() dynamically allocates memory for 
> > its last argument, but we do not always clean up that allocated memory.
> 
> I'm not seeing a leak.
> 
> The kfree() that you've added to the build_constructor_string() failure
> path isn't needed because build_constructor_string() only returns error
> if the kzalloc() failed.
> 

Hmm, that's true, assuming that there are no bugs (and never will be) in 
strlen() or sprintf() that result in 'str_size' becoming negative the code 
is safe. That's probably a safe assumption ;-)

Sorry about the noise.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
