From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
	data integrity
Date: Fri, 26 Jun 2009 19:36:34 -0300
Message-ID: <20090626223634.GG5913@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar> <87my91qsn4.fsf@frosties.localdomain> <20090525174630.GI1376@blitiri.com.ar> <8763fop31e.fsf@frosties.localdomain> <20090526125252.GL1376@blitiri.com.ar> <878wkhyqj3.fsf@frosties.localdomain> <37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Fri, Jun 26, 2009 at 12:56:42PM +0530, SandeepKsinha wrote:
> Hi Alberto,
> 
> + * TODO: would it be better to have M1 and M2 apart, to improve the chances of
> + * recovery in case of a failure?
> + *
> 
> How do you guarantee consistency in case of any lost writes? Your
> checksum might hold an updated value while your data block might be
> lost or written to a wrong destination?

The module aims to detect corruption, not prevent or recover from it. If the
write bio returns an error, it should be properly handled and propagated to
the upper layers.

If it returns success but writes the wrong data to the disk, then there will
be a mismatch between the checksum and the data at the destination, which will
be detected when it is read.

If a write returns success but no write ever takes place on the disk, then
dm-csum (as it is now) will not detect it; although I'm not sure if that
qualifies as on-disk data corruption or is it a disk controller issue.


> When implementing such integrity solutions, IMO, it is always
> advisable to handle such error conditions else this might lead to
> issues. Since, checksums  are very tightly coupled with the data and
> any misleading can be quite dangerous unlike parity which can be
> recovered.

The code considers the possibility of bios failing, and propagates this
information to the upper layers. If you see any part of the code that lacks
error handling, please let me know so I can fix it.


> Calculate the data's CRC, and compare it to the one found in M1. If they
> + *    match, the reading is successful. If not, compare it to the one found in
> + *    M2. If they match, the reading is successful;
> 
> Also, I hope by M1 and M2 you refer to the entry for a particular
> block in the respective IMD sector. What kind of mechanism do you use

M1 and M2 refer to whole IMD sectors.


> to determine which is younger?
> Is it the timestamp or some generation count?
>
> I assume information is per_block_entry in the IMD sectors. Which I
> don't see in your implementation?

It's per IMD sector. More specifically, struct imd_sector_header's
last_updated contains the generation count for the entire IMD sector, which is
used to determine which one is younger for updating purposes.

On reads, both IMD sectors are loaded and CRCs are verified against both.

Thanks a lot,
		Alberto

