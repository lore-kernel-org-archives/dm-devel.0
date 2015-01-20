From: Mikulas Patocka <mpatocka@redhat.com>
Subject: livelock on MD RAID5
Date: Mon, 19 Jan 2015 22:24:25 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1501192207260.20870@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Neil

I saw your patch "md/raid5: avoid livelock caused by non-aligned writes". 
That patch is only for RAID 6, but we are seeing similar livelock on RAID5 
(mdX_raid5 is constantly looping in 
raid5d/handle_active_stripes/handle_stripe/ops_run_io and some submitted 
bios get stuck). The livelock happens when we issue I/O and simulate disk 
failure.

Do you think that the same issue could happen on RAID5 too?

Do you think that the patch "md/raid5: fetch_block must fetch all the 
blocks handle_stripe_dirtying wants." could fix it?

Mikulas
