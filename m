From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Wed, 30 Nov 2011 11:36:11 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1111301134450.5759@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111130133332.GV7595@agk-dp.fab.redhat.com>
 <20111130134834.GW7595@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111130134834.GW7595@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jan Kara <jack@suse.cz>, esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

On Wed, 30 Nov 2011, Alasdair G Kergon wrote:

> On Wed, Nov 30, 2011 at 01:33:32PM +0000, Alasdair G Kergon wrote:
> > Have I missed something in this
> > reasoning, Mikulas?
>  
> Ah - counter-example: mmap?
> So sync might indeed be required to block on the filesystem iff there
> are newly-dirtied pages.
> 
> Alasdair

On non-journaled filesystem, both write and mmap can create dirty pages 
when suspended.

On ext4 I actually tested mmap, but it blocks any writes to mmaped pages 
while suspended.

Mikulas
