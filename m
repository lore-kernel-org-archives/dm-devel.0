From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Need some help on dmraid RAID5
Date: Wed, 31 May 2006 11:09:45 +0200
Message-ID: <20060531090945.GB2232@redhat.com>
References: <A6A77F954AFACF42928F5E931ABDB18F481DB2@bgsmsx411.gar.corp.intel.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A6A77F954AFACF42928F5E931ABDB18F481DB2@bgsmsx411.gar.corp.intel.com>
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

On Mon, May 29, 2006 at 04:19:55PM +0530, Srinivas, Vidya wrote:
> Hi,

Hi Vidya.

> 
> I am checking dmraid functionality for RAID5 with 3 disks. I am using
> the latest available patch on
> http://people.redhat.com/heinzm/sw/dm/dm-raid45/
> I have some confusion in the same.
> 
> The target length in the function raid_ctr in dm-raid4-5.c is being
> displayed to me as the smallest disk sectors.

No.

> However, I understand that
> the target length should be the total sectors (of all available disks)
> available for data (which in my case should be 2 disk sectors since 1
> disk sectors would be utilized for parity)

Yes, it's 'number of disks - 1' with a minimum of 3 disks.

> 
> What I understand is, in the user level dmraid, in
> lib/activate/activate.c, under dm_raid45, sectors value is calculated
> by:
> 
> Sectors = _smallest(lc,rs,0)
> 
> And, the same sectors value is passed to _dm_raid45_bol.
> 
> Whatever goes from this _dm_raid45_bol directly goes to the kernel
> dm-raid4-5.c and under raid_ctr gets printed as ti->len right? So, the
> smallest sectors (of all the devices) goes to ti->len. In my case also,
> the smallest disk sectors is being printed as ti->len and not the total
> data sectors. Am I wrong?

If so, it would be wrong.
The _smallest() calculation identifies the smallest of the deveices
in a RAID set in order to make up sane mappings (i.e. all disks mapped
to in a target line must have this minumum size).

> 
> 
> Also, I had another doubt in dm-raid4-5.c, under static struct raid_type
> raid_types[], values for raid5_ls is:
> 
> {Raid5_ls. "RAID5 (left symmetric), 1, 3, raid5, left_sym}, where the
> number of parity devices (being the 3rd parameter) is taken as 1.

Well, that number indicates the capacity being used for parity chunks
(i.e. 1 device).

> 
> But, I feel, since there isn't any dedicated parity device for RAID5,
> shouldn't this be taken as 0. When I take this as 1, I am getting the
> error, target length not divisable by number of devices. 

Can you send me your metadata (files created by 'dmraid -rD', tar'ed/bzip2'ed
into Srinivas_Vidya-raid5.tar.bz2), please.

> 
> When I take it as 0, my RAID volume is being created and things seem to
> work.

Strange. Will lokk into this once I got your metadata.

> 
> Any suggestions would be helpful
> 
> Thanks
> Vidya
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 

Regards,
Heinz    -- The LVM Guy --

*** Software bugs are stupid.
    Nevertheless it needs not so stupid people to solve them ***

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
