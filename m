From: Tim Burgess <tim.burgess@anu.edu.au>
Subject: Re: Multipath target does not shift block offset?
Date: Sat, 12 Feb 2005 15:45:52 +1100
Message-ID: <420D8A00.4080900@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Re the patch from Kevin:

there looks like there is another reference to ti->begin in dm-raid1.c
that the patch does not remove (in do_write).  I wasn't sure whether to 
leave it there or not, since you were talking about making each target 
unaware of its position within the overall mapped device...?

(note that my copy is not the latest - it's SUSE SLES SP1, so I
apologise if anything I say is not 100% true for the latest code :S)

Related:

I noticed that a similar collection of concatenated raid1 devices
(description below) was behaving strangely also, and splitting each
raid1 map into its own table fixed the problem...

For some reason, each of the mirror pairs was writing to its primary 
leg, but only the first one listed in the file was writing to its second 
leg...  (note that this is before Kevin's patches - will try them in a 
moment!).



> On Thursday 10 February 2005 11:18 am, Alasdair G Kergon wrote:
>> On Thu, Feb 10, 2005 at 04:02:28PM +1100, Tim Burgess wrote:
>> > However, dm appears to be trying
>> > to map the range 286749488-573498975 of the dm device to the same
>> > offsets in the sde/sdm device.
>> >
>> > Is this what was intended?
>>
>> No.
>>
>> In dm-mpath.c try adding to multipath_map() at the top of the function:
>>
>>   bio->bi_sector = (bio->bi_sector - ti->begin);
> 
> Actually, now that you point this out, I think this responsibility should
> really be handled by the core driver's I/O path instead of each target
> module. There's really no reason for the target modules to care or even
> know about the presence of multiple targets within a device table. We can
> move this line into the core's __map_bio() and get rid of a lot of
> duplicate code. Here's a patch to demonstrate what I'm talking about.
> 

-- 
--------------------------------------------------------------------------
                                     ANU Supercomputer Facility
    tim.burgess@anu.edu.au           and APAC National Facility
    Phone: +61 2 6125 1431           Leonard Huxley Bldg (No. 56)
    Fax:   +61 2 6125 8199           Australian National University
                                     Canberra, ACT, 0200, Australia
--------------------------------------------------------------------------


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
