From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: creating a dm-linear.ko in a current kernel.
Date: Tue, 25 Feb 2014 10:53:16 +0000
Message-ID: <530C761C.5010809@redhat.com>
References: <8A51900D08212F40B3DE22453052F6980B97CF4E@wdscexmb02>
	<8A51900D08212F40B3DE22453052F6980B97CFA3@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8A51900D08212F40B3DE22453052F6980B97CFA3@wdscexmb02>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: John Utz <John.Utz@wdc.com>
List-Id: dm-devel.ids

On 02/24/2014 10:44 PM, John Utz wrote:
> Solved my own issue methinks, the name of the module that i am
> finding in drivers/md/ is linear.ko, not dm-linear.ko. that was

That's the MD linear personality not the device-mapper linear target. It
allows you to build JBOD (concatentation) arrays using the MD RAID
subsystem.

> unexpected. i note further that there are other non 'dm- decorated'
> lkms in md as well, such as multipath, faulty, raid0, etc.

These are also MD personalities.

> is there an implication associated with things decorated with dm- vs
> things not decorated with dm- in the md directory?

The device-mapper targets all have a dm-* prefix (there are other files
in drivers/md with names beginning with 'dm', e.g. dm.c, dm-table.c but
those are part of the device-mapper core).

The dm-linear target is always built into the core dm-mod - see the
Makefile rules in drivers/md/Makefile for details. The device-mapper
bits are right at the top.

Regards,
Bryn.
