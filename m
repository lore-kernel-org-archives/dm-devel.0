From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Wed, 30 Nov 2011 12:03:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1111301155200.5759@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111130140913.GX7595@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111130140913.GX7595@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jan Kara <jack@suse.cz>, esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

> The sync only needs to block on a particular fs if there is data to flush.
> 
> A sync that originated in a way that can only be independent of any
> application that is changing the fs may skip that fs if it is frozen.
> 
> It's the user's responsibility only to freeze filesystems for very brief
> periods of time if they are still being changed.

The problem is that the process that is freezing filesystem (lvm) is 
totally independent on the process that is writing data to the filesystem 
and syncing it.

For example, you have a transactional database running in userspace and 
that database is writing and syncing and you take a snapshot at the same 
time. --- so you cannot make these two processes cooperate in any way. You 
can't tell to the database server "please don't write now, I am suspending 
to make a snapshot". The database server still writes and still assumes 
that sync() commits to permanent storage, regardless on what is going on 
in lvm.

Mikulas

> ?
>  
> Alasdair
