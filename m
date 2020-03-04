From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [dm-devel] [git pull] device mapper fixes for 5.6-rc5
Date: Wed, 4 Mar 2020 15:02:50 -0500
Message-ID: <20200304200250.GE74069@mit.edu>
References: <20200304150257.GA19885@redhat.com>
 <CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
 <20200304192335.GA24296@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200304192335.GA24296@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Hou Tao <houtao1@huawei.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 04, 2020 at 02:23:35PM -0500, Mike Snitzer wrote:
> 
> These versions are for userspace's benefit (be it lvm2, cryptsetup,
> multipath-tools, etc).  But yes, these versions are bogus even for
> that -- primarily because it requires userspace to know when a
> particular feature/fix it cares about was introduced.  In addition: if
> fixes, that also bump version, are marked for stable@ then we're quickly
> in versioning hell -- which is why I always try to decouple version
> bumps from fixes.
> 
> Others have suggested setting feature flags.  I expect you'd hate those
> too.  I suspect I quickly would too given flag bits are finite and
> really tedious to deal with.
> 
> I'll think further about this issue and consult with userspace
> developers and see what we might do.

What I do for e2fsprogs is that it looks for the existence of files in
/sys/fs/ext4/features:

% ls /sys/fs/ext4/features/
total 0
0 batched_discard  0 encryption        0 meta_bg_resize      0 verity
0 casefold         0 lazy_itable_init  0 metadata_csum_seed

I started this because sometimes ext4 features get backported
(sometimes to ancient 3.18 kernels for Android, sigh, but also once or
twice for enterprise distro kernels), and so this relieves e2fsprogs
from testing kernel versions when deciding which defaults at mke2fs
time (for example).

						- Ted
