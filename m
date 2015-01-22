From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] livelock on MD RAID5
Date: Thu, 22 Jan 2015 00:00:15 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1501212355480.30616@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1501192207260.20870@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1501192207260.20870@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 19 Jan 2015, Mikulas Patocka wrote:

> Hi Neil
> 
> I saw your patch "md/raid5: avoid livelock caused by non-aligned writes". 
> That patch is only for RAID 6, but we are seeing similar livelock on RAID5 
> (mdX_raid5 is constantly looping in 
> raid5d/handle_active_stripes/handle_stripe/ops_run_io and some submitted 
> bios get stuck). The livelock happens when we issue I/O and simulate disk 
> failure.
> 
> Do you think that the same issue could happen on RAID5 too?
> 
> Do you think that the patch "md/raid5: fetch_block must fetch all the 
> blocks handle_stripe_dirtying wants." could fix it?
> 
> Mikulas

So, we verified that this RAID5 livelock was introduced in patch 
67f455486d2ea20b2d94d6adf5b9b783d079e321. A patch 
a40687ff73a5b14909d6aa522f7d778b158911c5 fixes a livelock in RAID6, but a 
similar livelock was introduced in RAID5, that is still unfixed upstream.

Mikulas
