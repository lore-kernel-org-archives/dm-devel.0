From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: next-20200514 - build issue in drivers/md/dm-zoned-target.c
Date: Mon, 18 May 2020 12:44:49 -0400
Message-ID: <20200518164449.GA24518@redhat.com>
References: <367320.1589627953@turing-police>
 <7bb0d1c8-b164-d5f3-0218-5c71047c3a8c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7bb0d1c8-b164-d5f3-0218-5c71047c3a8c@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18 2020 at  2:25am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 5/16/20 1:19 PM, Valdis Klētnieks wrote:
> >Am seeing a build error in next-0514.  -0420 built OK.
> >building a 'make allmodconfig' on a RPi4 in 32-bit mode.
> >
> >   MODPOST 7575 modules
> >ERROR: modpost: "__aeabi_uldivmod" [drivers/md/dm-zoned.ko] undefined!
> >
> >objdump and 'make drivers/md/dm-zoned-target.s' tells
> >me that the problem is in function dmz_fixup_devices(), near here:
> >
> >@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
> >         ldr     r0, [r6, #56]   @ reg_dev_166->capacity, reg_dev_166->capacity
> >         adds    r1, r3, r1      @ tmp316, _227, reg_dev_166->capacity
> >         adc     r0, r2, r0      @ tmp315, _227, reg_dev_166->capacity
> >         subs    r1, r1, #1      @, tmp316,
> >@ drivers/md/dm-zoned-target.c:805:             reg_dev->zone_nr_sectors = zoned_dev->zone_nr_sectors;
> >         strd    r2, [r6, #80]   @, reg_dev,
> >@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
> >         sbc     r0, r0, #0      @, tmp315,
> >         bl      __aeabi_uldivmod                @
> >@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
> >         str     r1, [r6, #64]   @ tmp306, reg_dev_166->nr_zones
> >
> >git blame points at this commit:
> >
> >commit 70978208ec91d798066f4c291bc98ff914bea222
> >Author: Hannes Reinecke <hare@suse.de>
> >Date:   Mon May 11 10:24:30 2020 +0200
> >
> >     dm zoned: metadata version 2
> >
> >Reverting that commit lets the build complete.
> >
> >
> I thought I've send a patch to fix that up; DIV_ROUND_UP() needs to
> be changed to DIV_ROUND_UP_ULL().
> I'll be checking and will be sending a patch if necessary.

Unless I'm missing something it was fixed up with this commit last
wednesday (13th):

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=81a3a1453ec4e5da081e1395732801a600feb352
