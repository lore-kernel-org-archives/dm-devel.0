From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Date: Fri, 25 May 2012 23:39:37 +0100
Message-ID: <20120525223937.GF5761@agk-dp.fab.redhat.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-15-git-send-email-koverstreet@google.com> <20120525204651.GA24246@redhat.com> <20120525210944.GB14196@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120525210944.GB14196-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Where's the urge to remove merge_bvec coming from?

I think it's premature to touch this, and that the other changes, if
fixed and integrated, should be allowed to bed themselves down first.


Ideally every bio would be the best size on submission and no bio would
ever need to be split.

But there is a cost involved in calculating the best size - we use
merge_bvec for this, which gives a (probable) maximum size.  It's
usually very cheap to calculate - but not always.  [In dm, we permit
some situations where the answer we give will turn out to be wrong, but
ensure dm will always fix up those particular cases itself later and
still process the over-sized bio correctly.]

Similarly there is a performance penalty incurred when the size is wrong
- the bio has to be split, requiring memory, potential delays etc.

There is a trade-off between those two, and our experience with the current
code has that tilted strongly in favour of using merge_bvec all the time.
The wasted overhead in cases where it is of no benefit seem to be
outweighed by the benefit where it does avoid lots of splitting and help
filesystems optimise their behaviour.


If the splitting mechanism is changed as proposed, then that balance
might shift.  My gut feeling though is that any shift would strengthen
the case for merge_bvec.

Alasdair
