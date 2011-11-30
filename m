From: Jan Kara <jack@suse.cz>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Wed, 30 Nov 2011 17:53:39 +0100
Message-ID: <20111130165339.GF4541@quack.suse.cz>
References: <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz>
 <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
 <20111129130913.GE5635@quack.suse.cz>
 <20111129131811.GS7595@agk-dp.fab.redhat.com>
 <20111129133239.GA9926@quack.suse.cz>
 <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com>
 <20111130111657.GA4541@quack.suse.cz>
 <Pine.LNX.4.64.1111300700190.27712@hs20-bc2-1.build.redhat.com>
 <20111130130514.GU7595@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111130130514.GU7595@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jan Kara <jack@suse.cz>, esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

On Wed 30-11-11 13:05:14, Alasdair G Kergon wrote:
> On Wed, Nov 30, 2011 at 07:14:18AM -0500, Mikulas Patocka wrote:
> > On Wed, 30 Nov 2011, Jan Kara wrote:
> > > > So if you skip sync of frozen filesystems, you introduce a data
> > > > corruption if someone takes a snapshot of ext2.
> > >   Yes, because ext2 cannot really be frozen, it is (errorneously) marked
> > > as such but it is not frozen...
> 
> This is just getting into semantics.  AFAIK (and it was before my involvement)
> LVM used the term 'lockfs' for this operation when it was introduced to ext2.
> It later got renamed in-kernel to 'frozen' to bring it into line with newer
> filesystems.  But userspace and the interface still retain the original
> 'lockfs' name.
> 
> There is no further I/O sent to the filesystem during the 'lockfs' operation:
> LVM uses dm to block that.
  OK, so can we (at least in this discussion) discussion distinguish two
things?
a) Filesystems is frozen/locked - means filesystem is in a consistent state
  and disallows new dirty data to be created until fs is thawed/unlocked.
b) Device is frozen/locked - device does not process incoming writes, they
  are held in the queue until the device is thawed/unlocked.

  They are two different things and we seem to conflate them in the
discussion. In particular you can freeze a device under any filesystem
while you cannot freeze every filesystem. Freezing the device is enough for
LVM operations (e.g. snapshot) but if filesystem is not frozen, you have
to run fsck / journal replay to make result usable. Do we agree here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
