From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 12:11:36 +0100
Message-ID: <20111129111136.GC5635@quack.suse.cz>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz>
 <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Valerie Aurora <val@vaaconsulting.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Christopher Chaltain <christopher.chaltain@canonical.com>, esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>
List-Id: dm-devel.ids

On Tue 29-11-11 06:06:21, Mikulas Patocka wrote:
> On Tue 29-11-11 11:19:01, Jan Kara wrote:
> >   Hi,
> > 
> > On Mon 28-11-11 18:32:18, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > Where can I get that patch set?
> > > > 
> > > > We are experiencing other similar deadlocks on RHEL-6, caused by sync or 
> > > > background writeback (these code paths take s_umount and wait trying to do 
> > > > I/O), but I wasn't able to reproduce these deadlocks on upstream kernel? 
> > > > Are there other known deadlock possibilities?
> > > 
> > > I found some patch named "[RFC PATCH 1/3] VFS: Fix s_umount thaw/write 
> > > deadlock" (I couldn't find the next two parts of the patch in the 
> > > archives). And the patch looks wrong:
> >   Yes, that seems to be the series. I generally agree with you that the
> > last iteration still had some problems and some changes were requested.
> > That's why it's not merged yet after all...
> > 
> > > - down_read_trylock(&sb->s_umount) doesn't fix anything. The lock is not 
> > > held when the filesystem is frozen and it is taken for write when thawing. 
> > > Consequently, any task can succeed with down_read_trylock(&sb->s_umount) 
> > > on a frozen filesystem and if this tasks attempts to do an I/O that is 
> > > waiting for thaw, it may still deadlock.
> >   Agreed.
> > 
> > > - skipping sync on frozen filesystem violates sync semantics. 
> > > Applications, such as databases, assume that when sync finishes, data were 
> > > written to stable storage. If we skip sync when the filesystem is frozen, 
> > > we can cause data corruption in these applications (if the system crashes 
> > > after we skipped a sync).
> >   Here I don't agree. Filesystem must guarantee there are no dirty data on
> > a frozen filesystem.
> 
> This is technically impossible to achieve on ext2, fat or other 
> non-transactional filesystems. These filesystems have no locks around code 
> paths that set data or inodes dirty. And you still need working sync for 
> ext2. So the best thing to do in sync is to wait until the filesystem is 
> unfrozen.
  Then suspend is effectively unsupported on the filesystem and should
return EOPNOTSUPP? At least that's what I'd expect...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
