From: Kalpak Shah <kalpak@linsyssoft.com>
Subject: Re: Breaking of large IO requests into small bios by
	device-mapper
Date: Wed, 22 Nov 2006 14:25:19 +0800
Message-ID: <1164176719.2956.13.camel@garfield>
References: <1164108010.2925.15.camel@garfield>
	<1164132122.4874.14.camel@linux-cxyg.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1164132122.4874.14.camel@linux-cxyg.rtp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dave.wysochanski@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Thanks for your reply Dave.

I am not using a striped target. The command I used for creating the
logical volume was: 

1) lvcreate -nMDT -s500M volLustre
2) lvcreate -nOST0 -s500M volLustre

Then I created snapshot LVs for the above two LVs.

1) lvcreate -L200M -s -n MDTb1 /dev/volLustre/MDT
2) lvcreate -L200M -s -n OST0b1 /dev/volLustre/OST0
 
I tried to give a chunksize of 1024 but the lvcreate command segfaults.
I googled and found that it works only uptil 512K(1024 sectors). 

Let me explain the problem in depth. Lustre sends writes of 1MB, which
are getting broken down (max size could be 512KB) into smaller sizes
reducing the overall throughput. In function max_io_len() I returned len
as it was without splitting it further. In that case the writes/reads
sent by Lustre do not get broken down and performance improves
considerably. Note that the reads/writes may be bigger in some cases.

Thanks,
Kalpak.

On Tue, 2006-11-21 at 13:02 -0500, Dave Wysochanski wrote:
> On Tue, 2006-11-21 at 19:20 +0800, Kalpak Shah wrote:
> > Hi,ate
> > 
> > Hi I am checking if device-mapper breaks down the reads/writes which are
> > sent by the file system. For example if an FS like Lustre sends a 1MB
> > read/write whether the request goes to the disk as a single request or
> > is it broken down into many small requests.
> > 
> It depends how you create the logical volume on which you put the
> filesystem.
> 
> > I have put some printks in __map_bio, __split_bio, etc. It seems that
> > even though 1 MB writes are sent to the device mapper the bios that are
> > sent to generic_make_request in __map_bio are at max 8k in size. In
> > function max_io_len(), ti->split_io is just 16 sectors at max, hich is
> > why the requests get broken down.
> > 
> > Why is this ->split_io variable set to 16 sectors? Can it  be more (arnd
> > 2048 sectors) without affecting the stability?
> > 
> 
> That sounds like you created a logical volume with stripe size (in
> device mapper it's termed "chunk size") of 8KB.
> What is the output of "dmsetup table" for the volume in question?
> 
> The default stripe size is 64KB (128 sectors) but you can change it when
> you create the lv.  An example on my setup I got this for one lv I
> created (notice the 16 in the output):
> # lvcreate -L 296M -i 2 --stripesize 8K -n lv0 vg0
>   Logical volume "lv0" created
> # dmsetup table
> vg0-lv0: 0 606208 striped 2 16 7:3 384 7:4 384
> 
> The format for the striped target is:
> /*
>  * Construct a striped mapping.
>  * <number of stripes> <chunk size (2^^n)> [<dev_path> <offset>]+
>  */
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
