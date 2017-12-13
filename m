From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix a recently introduced reference counting bug
Date: Wed, 13 Dec 2017 18:12:52 -0500
Message-ID: <20171213231252.GB6507@redhat.com>
References: <20171213214618.21767-1-bart.vanassche@wdc.com>
 <20171213225708.GA6507@redhat.com>
 <1513206147.2413.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513206147.2413.17.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "elena.reshetova@intel.com" <elena.reshetova@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Dec 13 2017 at  6:02pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Wed, 2017-12-13 at 17:57 -0500, Mike Snitzer wrote:
> > I've had a fix for this staged in linux-next for a while.  Will be
> > sending it to Linus tomorrow, see:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.15&id=afc567a4977b2d798e05153dd131a3c8d4758c0c
> > 
> > BTW, there was no need to cc: stable given that it'll get fixed in 4.15
> > (issue was introduced during the 4.15 merge).
> 
> Had that patch already been posted on the dm-devel mailing list? If not, I
> think that's unfortunate.

There was an exchange on dm-devel about the issue, see:
"[PATCH 3/4] dm: convert dm_dev_internal.count from atomic_t to refcount_t"

I staged a bogus fix initially and then a proper fix.

> Anyway, would it be possible to elaborate the commit message? Others also
> ran into this bug. See e.g. https://marc.info/?l=linux-block&m=151215418123126&w=2.

No, I'm not rebasing at this point.  Too much has stacked above it (not
just 4.15, I've already staged a lot for 4.16).

Not to mention, rebasing immediately before sending a pull request to
Linus is a recipe for trouble.

Mike
