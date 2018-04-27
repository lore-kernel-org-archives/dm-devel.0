From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm/raid1: Remove VLA usage
Date: Fri, 27 Apr 2018 10:38:59 -0400
Message-ID: <20180427143859.GA26647@redhat.com>
References: <20180411044315.GA46144@beast>
 <CAGXu5jLUTF0c3DLGjFFnSwJ3FJmiOMYRu3vqTqNVEBQehyn4KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLUTF0c3DLGjFFnSwJ3FJmiOMYRu3vqTqNVEBQehyn4KA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Tycho Andersen <tycho@tycho.ws>, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 26 2018 at  7:31pm -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Apr 10, 2018 at 9:43 PM, Kees Cook <keescook@chromium.org> wrote:
> > On the quest to remove all VLAs from the kernel[1], this avoids VLAs
> > in dm-raid1.c by just using the maximum size for the stack arrays.
> > The nr_mirrors value was already capped at 9, so this makes it a trivial
> > adjustment to the array sizes.
> >
> > [1] https://lkml.org/lkml/2018/3/7/621
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Friendly ping... can someone take this, or should this go via another tree?

It needs further review but it is on my radar.

But please consider it claimed and proceeding upstream for 4.18 via
linux-dm.git

Thanks,
Mike
