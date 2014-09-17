From: "Liuhua Wang" <lwang@suse.com>
Subject: Re: [PATCH] fix mirror device creation with lvcreate
 failed
Date: Tue, 16 Sep 2014 23:11:35 -0600
Message-ID: <54198887020000A00000CFC2@soto.provo.novell.com>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140916232104.GC2407@agk-dp.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Neil F Brown <NFBrown@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Alasdair

>>> On 9/17/2014 at 07:21 AM, in message
<20140916232104.GC2407@agk-dp.fab.redhat.com>, Alasdair G Kergon
<agk@redhat.com> wrote: 
> On Wed, Aug 27, 2014 at 04:18:25PM +0800, Liuhua Wang wrote:
> >  On some devices, 
> 
> Which devices?  What is the necessary condition to trigger the problem?
> 
When using dasd device formated with bocksize of 4096bytes.
the problem occurs, while formated with blocksie of 512bytes,
no problem.

> > when create mirror device with lvcreate, it fails.
> >  device-mapper: reload ioctl on  failed: Invalid argument
> >  Failed to activate new LV.
>  
> What exactly causes this error?
> - Do you get a kernel error message too?
There are error messages:
---------------------
[22798.077877] end_request: I/O error, dev dasdd, sector 2240
[22798.077902] device-mapper: raid: Failed to read superblock of device at position 1
[23087.875420] type=1006 audit(1404313201.346:28): pid=1596 uid=0 old auid=4294967295 new auid=0 old ses=4294967295 new ses=27 res=1
[23127.707296] dasd-eckd.d2bf98: 0.0.141d: ERP 0000000036ab1e40 has run out of retries and failed
----------------------

> >  We can use read size 4096 since md always use 4096.
>  
> How is that connected to problem?
> Why does it fix it?
> 
> > +++ b/drivers/md/dm-raid.c
> > @@ -860,7 +860,7 @@ static int super_load(struct md_rdev *rdev, struct 
> md_rdev *refdev)
> >  	rdev->sb_start = 0;
> >  	rdev->sb_size = sizeof(*sb);
>   
> What should sb_size really be?
512bytes
> 
> > -	ret = read_disk_sb(rdev, rdev->sb_size);
> > +	ret = read_disk_sb(rdev, 4096);
> 
> Why aren't they both MD_SB_BYTES?
> (Strictly, does sb_size need recalculating after the read?)
> 
> Alasdair
> 

Best regards,
Liuhua 
