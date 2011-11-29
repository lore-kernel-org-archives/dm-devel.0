From: Jan Kara <jack@suse.cz>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 14:32:39 +0100
Message-ID: <20111129133239.GA9926@quack.suse.cz>
References: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz>
 <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
 <20111129130913.GE5635@quack.suse.cz>
 <20111129131811.GS7595@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111129131811.GS7595@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>, esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

On Tue 29-11-11 13:18:11, Alasdair G Kergon wrote:
> On Tue, Nov 29, 2011 at 02:09:13PM +0100, Jan Kara wrote:
> >   Hmm, then why do these operations suspend the filesystem if they
> > apparently don't need it? Sorry for my ignorance, I never seriously worked
> > with LVM code...
> 
> They don't suspend it if they don't need to.
> 
> dm-ioctl.h:
> /*
>  * Set this to avoid attempting to freeze any filesystem when suspending.
>  */
> #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
  Thanks. I was now checking in detail and indeed FIFREEZE fails if
->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
and gfs2 provide this function. So I was correct in assuming that when
filesystem supports FIFREEZE it must make sure no modifications happen to
the filesystem. So I believe that my original plan for sync to skip frozen
filesystem is correct.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
