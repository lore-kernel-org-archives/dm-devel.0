From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 14:09:13 +0100
Message-ID: <20111129130913.GE5635@quack.suse.cz>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz>
 <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz>
 <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Valerie Aurora <val@vaaconsulting.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Christopher Chaltain <christopher.chaltain@canonical.com>, esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>
List-Id: dm-devel.ids

On Tue 29-11-11 07:54:28, Mikulas Patocka wrote:
> > > This is technically impossible to achieve on ext2, fat or other 
> > > non-transactional filesystems. These filesystems have no locks around code 
> > > paths that set data or inodes dirty. And you still need working sync for 
> > > ext2. So the best thing to do in sync is to wait until the filesystem is 
> > > unfrozen.
> >   Then suspend is effectively unsupported on the filesystem and should
> > return EOPNOTSUPP? At least that's what I'd expect...
> 
> LVM uses suspend every time it changes layout of the logical volume. For 
> example when it converts to/from mirrored format, extends/shrinks the 
> volume, moves the volume to a different disk, takes a snapshots, merges a 
> snapshot back, on mirror or multipath failover.
> 
> For most of these actions (except taking a snapshot) it is irrelevant if 
> there are dirty data in the filesystem cache or not while it is suspended. 
  Hmm, then why do these operations suspend the filesystem if they
apparently don't need it? Sorry for my ignorance, I never seriously worked
with LVM code...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
