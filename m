From: Tim Burgess <tim.burgess@anu.edu.au>
Subject: block offset shift, mirroring bug resolved?
Date: Mon, 14 Feb 2005 12:42:38 +1100
Message-ID: <4210020E.4010408@anu.edu.au>
References: <420D8A00.4080900@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <420D8A00.4080900@anu.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've tried Kevin Corry's patches (with my extra modification to 
do_write, as quoted below), and the mirroring problem seems resolved.  I 
might have a poke around and see if I can figure out why it was happening...

The setup I had was:

#!/bin/sh
dmsetup remove_all

dmsetup create mirror <<EOF
0 16777216 mirror core 1 2048 2 /dev/sdd 0 /dev/sdt 0
16777216 16777216 mirror core 1 2048 2 /dev/sde 0 /dev/sdu 0
33554432 16777216 mirror core 1 2048 2 /dev/sdf 0 /dev/sdv 0
50331648 16777216 mirror core 1 2048 2 /dev/sdg 0 /dev/sdw 0
67108864 16777216 mirror core 1 2048 2 /dev/sdp 0 /dev/sdae 0
83886080 16777216 mirror core 1 2048 2 /dev/sdq 0 /dev/sdaf 0
100663296 16777216 mirror core 1 2048 2 /dev/sdr 0 /dev/sdag 0
117440512 16777216 mirror core 1 2048 2 /dev/sds 0 /dev/sdah 0
EOF

dmsetup create reliable <<EOF
0 134217728 striped 8 512 /dev/mapper/mirror 0 /dev/mapper/mirror 
16777216 /dev/mapper/mirror 33554432 /dev/mapper/mirror 50331648 
/dev/mapper/mirror 67108864 /dev/mapper/mirror 83886080 
/dev/mapper/mirror 100663296 /dev/mapper/mirror 117440512
EOF

Writing to /dev/mapper/reliable in the above configuration caused i/o to 
/dev/sd[defgpqrs] (the primary legs) and /dev/sdt but none of the other 
secondary mirror legs.

As I said before though, Kevin's patch + the extra bit fixes this.  I'd 
post a patch but since I'm running an older version there's probably not 
much point.

I'm seeing kernel panics using the mirror target though - another post 
follows.

Cheers,
Tim

The extra change (haven't tested without, it just made sense to change 
this too - correct me if I'm wrong here!) was:

function do_write() in dm-raid1.c

Old:

         for (i = 0; i < ms->nr_mirrors; i++) {
                 m = ms->mirror + i;

                 io[i].bdev = m->dev->bdev;
                 io[i].sector = m->offset + (bio->bi_sector - 
ms->ti->begin);
                 io[i].count = bio->bi_size >> 9;
         }


New:

         for (i = 0; i < ms->nr_mirrors; i++) {
                 m = ms->mirror + i;

                 io[i].bdev = m->dev->bdev;
                 io[i].sector = m->offset + bio->bi_sector;
                 io[i].count = bio->bi_size >> 9;
         }



Tim Burgess wrote:

> Re the patch from Kevin:
> 
> there looks like there is another reference to ti->begin in dm-raid1.c
> that the patch does not remove (in do_write).  I wasn't sure whether to 
> leave it there or not, since you were talking about making each target 
> unaware of its position within the overall mapped device...?
> 
> (note that my copy is not the latest - it's SUSE SLES SP1, so I
> apologise if anything I say is not 100% true for the latest code :S)
> 
> Related:
> 
> I noticed that a similar collection of concatenated raid1 devices
> (description below) was behaving strangely also, and splitting each
> raid1 map into its own table fixed the problem...
> 
> For some reason, each of the mirror pairs was writing to its primary 
> leg, but only the first one listed in the file was writing to its second 
> leg...  (note that this is before Kevin's patches - will try them in a 
> moment!).
> 
> 
> 
>> On Thursday 10 February 2005 11:18 am, Alasdair G Kergon wrote:
>>
>>> On Thu, Feb 10, 2005 at 04:02:28PM +1100, Tim Burgess wrote:
>>> > However, dm appears to be trying
>>> > to map the range 286749488-573498975 of the dm device to the same
>>> > offsets in the sde/sdm device.
>>> >
>>> > Is this what was intended?
>>>
>>> No.
>>>
>>> In dm-mpath.c try adding to multipath_map() at the top of the function:
>>>
>>>   bio->bi_sector = (bio->bi_sector - ti->begin);
>>
>>
>> Actually, now that you point this out, I think this responsibility should
>> really be handled by the core driver's I/O path instead of each target
>> module. There's really no reason for the target modules to care or even
>> know about the presence of multiple targets within a device table. We can
>> move this line into the core's __map_bio() and get rid of a lot of
>> duplicate code. Here's a patch to demonstrate what I'm talking about.
>>
> 

-- 
--------------------------------------------------------------------------
                                     ANU Supercomputer Facility
    tim.burgess@anu.edu.au           and APAC National Facility
    Phone: +61 2 6125 1431           Leonard Huxley Bldg (No. 56)
    Fax:   +61 2 6125 8199           Australian National University
                                     Canberra, ACT, 0200, Australia
--------------------------------------------------------------------------
   "Money can buy bandwidth, but latency is forever" -- John Mashey
--------------------------------------------------------------------------

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
