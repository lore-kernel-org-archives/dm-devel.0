From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 13/16] Make generic_make_request handle arbitrarily
	large bios
Date: Fri, 25 May 2012 23:58:52 +0100
Message-ID: <20120525225852.GG5761@agk-dp.fab.redhat.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-14-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337977539-16977-14-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 25, 2012 at 01:25:36PM -0700, Kent Overstreet wrote:
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could

Complexity - yes - but if people didn't observe a genuine benefit, why
did they go to the trouble of writing this and getting it included?

> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. 

> Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.

A theoretical argument.  Perhaps it's the right assessment of this
issue.  Perhaps it's not.  Or perhaps it depends on the use-case.

I made a theoretical argument from a different point of view in my last email.

I think a body of *empirical* evidence should provide the justification
for this particular change, and until such evidence is forthcoming we
should keep the status quo.

Alasdair
