From: Mike Snitzer <snitzer@redhat.com>
Subject: reproducer for DM on MD flush deadlock? (was: Re: [PULL REQUEST] md
 bug fixes)
Date: Fri, 17 Dec 2010 13:13:47 -0500
Message-ID: <AANLkTi=H3-GrEZVWzmHyHvyx93HU6x=t_n6TBqCiEwxX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 14, 2010 at 2:22 AM, Neil Brown <neilb@suse.de> wrote:
>
>
> Hi Linus,
> =A0here are a few bug fixes for md.
> =A0Some of the patches are actually clean-up rather than bug-fix,
> =A0but I that make the bugfix simpler to review.
>
> Thanks,
> NeilBrown
>
>
> The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e8=
3937b6:
>
> =A0Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and '=
sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)
>
> are available in the git repository at:
>
> =A0git://neil.brown.name/md/ for-linus
>
> NeilBrown (5):
> =A0 =A0 =A0md: remove handling of flush_pending in md_submit_flush_da=
ta
> =A0 =A0 =A0md: move code in to submit_flushes.
> =A0 =A0 =A0md: fix possible deadlock in handling flush requests.

Hi Neil,

Thanks for fixing this DM on MD flush issue.  But my attempts to
reproduce it have been unsuccessful.

I've tried ext4 w/ barriers to a DM device above a 2 member MD RAID1.
The DM device has a table with 2 linear targets to the same md0
device:

# dmsetup table
multiple_targets: 0 24576 linear 9:0 2048
multiple_targets: 24576 49152 linear 9:0 26624

No amount of IO with flushes has enabled me to hit a deadlock (in
md_flush_request,  md_write_start, etc).

Do you have a simple reproducer for this issue?

Mike
