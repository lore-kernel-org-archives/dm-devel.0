From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] dm-integrity: recalculate checksums
Date: Tue, 3 Jul 2018 09:21:16 -0400
Message-ID: <20180703132115.GA28076@redhat.com>
References: <20180606153440.580394316@debian.vm>
	<30799a62-b825-4ce4-7b10-044ce8e030da@redhat.com>
	<7af22076-53fe-67d0-fa6e-09acbb145f36@gmail.com>
	<alpine.LRH.2.02.1806271046370.17497@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806271046370.17497@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Mon, Jul 02 2018 at  9:07pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Sun, 17 Jun 2018, Milan Broz wrote:
> 
> > Hi Mikulas,
> > 
> > I have some questions for the last dm-integrity recalculation patch (copied below).
> > 
> > - The "recalculate" dm table attribute is never visible in "dmsetup table",
> > it is parsed only on table dm-ioctl input.
> > I think if sb flags has SB_FLAG_RECALCULATING, it should appear there.
> 
> I'll fix it - I will return the value from the target line.
> 
> > - So, SB_FLAG_RECALCULATING bit is persistent and never disappears?
> > Is it intentional, that after recalculation is done, it is not cleared?
> > (Is it because or later resize recalc the rest of block?)
> 
> It is intentional, because someone may extend the device and then, 
> recalculating must continue.
> 
> > - What about monitoring progress - for now, we can only read superblock
> > and parse recalc_sector (not sure if you want this). What about status line option?
> 
> I will add the progress counter to the status line.

SO like <completed>/<total> ?

> > - How can I stop/restart recalculation (activate device without it / clear sb flag)?
> > Shouldn't this be connected to the presence of "recalculate" flag in mapping table?
> 
> Should we even have the possibility to stop recalculating?
> 
> If the device was recalculating and we activate it without the 
> "recalculate" flag, what should it do? If the user reads data that haven't 
> been recalculated yet, we could:
> 1. return an error
> 2. ignore the non-recalculated checksum and return data
> 3. continue with recalculating even if the flag "recalculate" is not present
> 
> In my opinion, the option 3 is the best. Option 1 makes the device 
> unreliable and option 2 makes the device silently lose the integrity 
> protection.

Yes, option 3.  But you could even error out on table load; though that
may be too unforgiving.. reality is userspace needs to account for
staying in recalculating mode until it is complete.

But to do that they'd need to monitor (similar to how snapshot-merge
polls progress?)

Mike
