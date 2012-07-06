From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0 of 5] MD: prepare RAID10 for inclusion in dm-raid.c
Date: Fri, 6 Jul 2012 14:32:22 -0500
Message-ID: <A1932867-ECAD-4720-A30D-DCF906AC25F0@redhat.com>
References: <1340700259.19015.10.camel@f16> <CAGqmV7osZiY+Bv5vn0gtQ_1-j9KnS8dJxoZKm6WJHYaoDrtTBw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7osZiY+Bv5vn0gtQ_1-j9KnS8dJxoZKm6WJHYaoDrtTBw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids


On Jul 6, 2012, at 3:40 AM, CoolCold wrote:

> 
> 
> On Tue, Jun 26, 2012 at 12:44 PM, Jonathan Brassow <jbrassow@redhat.com> wrote:
> Neil,
> 
> Here's a couple patches that are necessary for MD before I can add
> RAID10 to the list of supported personalities through dm-raid.c:
>         1) md-raid10-rename-mirror_info.patch
>         2) md-raid1-rename-mirror_info.patch
>         3) md-move-IO_BLOCKED-to-md_h.patch
>         4) md-export-md_raid10_congested.patch
> 
> I'll send the patch that enables raid10 as a separate patch that depends
> on this patch set and a couple of DM patches.
> 
> Can you explain a bit more detailed for me, what is this about? I.e. from my point of view dm-raid and md-raid and fully separated but looks like I'm wrong and missing something.

drivers/md/dm-raid.c is a device-mapper target that provides access to the MD personalities.  So far, MD's RAID 1/4/5/6 have been made available to the device-mapper interface through this module.  We are laying the ground work here for RAID10 to be made available in the same way.

You may wish to have a look at linux/Documentation/device-mapper/dm-raid.txt for additional information.  Also note that in "[PATCH 4 of 4] MD RAID10: Export md_raid10_congested", I referenced a couple of other times that these types of changes were necessary.

Thanks,
 brassow 

