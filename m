From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: SMR 512e drive firmware advertising misleading
 limits? [was: Re: [RFC PATCH 1/1] dm: add dust target]
Date: Thu, 10 Jan 2019 04:58:11 +0000
Message-ID: <BYAPR04MB581640F5ED066B99EBC824B8E7840@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
	<1546889483-6341-2-git-send-email-bgurney@redhat.com>
	<20190108001049.GM11315@octiron.msp.redhat.com>
	<CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
	<20190108162314.GA16936@redhat.com>
	<CAHhmqcTfKniu1eP+fBwHf4gohOfUaz_cgaC3EUezNauUAk6O-Q@mail.gmail.com>
	<BYAPR04MB581645C55BCC328E193D3DBEE78B0@BYAPR04MB5816.namprd04.prod.outlook.com>
	<20190109142913.GA26563@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: John Dorminy <jdorminy@redhat.com>, Shimkus <jshimkus@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Joe, "tjaskiew@redhat.com" <tjaskiew@redhat.com>, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Mike,

On 2019/01/09 23:29, Mike Snitzer wrote:
> On Tue, Jan 08 2019 at  8:03pm -0500,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>  
>> You may want to check against the physical_block_size, and not the logical. SMR
>> disks that are 512 e (512B logical and 4K physical) can handle reads in 512B
>> units but writes have to be 4K. These are exceptions though and kind of breaking
>> all LBA definitions known to men... This check on the physical_block_size can be
>> limited to setups where the underlying disk is SMR.
> 
> Damien, this sounds like a serious issue with SMR firmware.  If the
> 512e SMR drive cannot handle 512b writes then it has no business
> advertising 512B logical.  It should be advertising 4K logical.
> 
> What am I missing?

You are absolutely correct, and I am with you on this one ! 512e disks are an
insanity for SMR and should not exist. But unfortunately, they do. The problem
is not the disk firmware, but the specs. ZBC and ZAC clearly state that writes
into sequential zones have to be aligned on physical sector boundaries. This
constraint applies only to sequential zones. Conventional zones can and should
handle any write request, even those not aligned on 4K boundaries on 512e disks.

Form ZBC r05:

"4.4.3.4.1 Writing in sequential write required zones
[...]
If the device server processes a write command with:
	a) the starting LBA in a sequential write required zone set to a value
	   that is in the write required zone but
	   that is not equal to the write pointer; or
	b) an ending LBA that is not equal to the last logical block within a
	   physical block (see SBC-4),
then the device server shall not write any data and shall terminate the command
with CHECK CONDITION status, with the sense key set to ILLEGAL REQUEST, and the
additional sense code set to UNALIGNED WRITE COMMAND."

This kind of make sense considering that track shingling allows sectors to be
written only once, but it seems that nobody in the standard committee clearly
realized the implications of this on 512e disk models. And so we end up with
this situation were everything is fine for 512n and 4Kn, but 512e is definitely
broken.

Disk FW implementation could handle partial 4K sector writes with some caching
since only the physical sectors containing the LBA pointed by zone write
pointers need caching. That is at most as many sectors as the number of
sequential zones. But the specs are like this now, and the disk FW
implementation has no choice but to follow the text.

Note that we discussed in the past adding checks in the block stack or scsi
stack for writes that are not 4K aligned on 512e SMR disks, but in the end
decided against it. That does not buy us anything and so we let the drive fail
these unaligned writes instead of failing the commands before dispatching.
Luckily, all the in kernel software we have supporting SMR use 4K writes (f2fs,
btrfs prototype and dm-zoned). So this problem never really triggers.

Best regards.

-- 
Damien Le Moal
Western Digital Research
