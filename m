From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper fixes for 5.6-rc5
Date: Wed, 4 Mar 2020 14:23:35 -0500
Message-ID: <20200304192335.GA24296@redhat.com>
References: <20200304150257.GA19885@redhat.com>
 <CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Wed, Mar 04 2020 at  2:06pm -0500,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Mar 4, 2020 at 9:03 AM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > - Bump the minor version for DM core and all target versions that have
> >   seen interface changes or important fixes during the 5.6 cycle.
> 
> Can we please remove these pointless version markers entirely?
> 
> They make no sense. The kernel doesn't allow backwards incompatible
> changes anyway, so the whole point of using some kind of interface
> versioning is entirely bogus.
> 
> The way you test if a new feature exists or not is to just use it, and
> if you're running on an old kernel that doesn't support that
> operation, then it should return an error.

These versions are for userspace's benefit (be it lvm2, cryptsetup,
multipath-tools, etc).  But yes, these versions are bogus even for
that -- primarily because it requires userspace to know when a
particular feature/fix it cares about was introduced.  In addition: if
fixes, that also bump version, are marked for stable@ then we're quickly
in versioning hell -- which is why I always try to decouple version
bumps from fixes.

Others have suggested setting feature flags.  I expect you'd hate those
too.  I suspect I quickly would too given flag bits are finite and
really tedious to deal with.

I'll think further about this issue and consult with userspace
developers and see what we might do.

Thanks (for the needed kick in the ass).
Mike
