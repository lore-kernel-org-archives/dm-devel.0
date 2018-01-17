From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 16:37:36 -0500
Message-ID: <20180117213736.GB6756@redhat.com>
References: <a096db4d-1c32-4682-844d-4a7fc02d47da@email.android.com>
	<1516218304.2820.51.camel@wdc.com>
	<20180117201417.GA6455@redhat.com>
	<1516224450.2820.59.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516224450.2820.59.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  4:27pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Wed, 2018-01-17 at 15:14 -0500, Mike Snitzer wrote:
> > BUT my broader point stands: you aren't testing the dm-4.16 changes.  By
> > just reverting that commit you're creating a self-fulfilling prophecy
> > (that you'll see hangs without it).
> > 
> > Fact is you should pull all of dm-4.16 in, see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16
> > 
> > But these dm-4.16 changes are particularly important:
> > 050af08ffb1b dm mpath: return DM_MAPIO_REQUEUE on blk-mq rq allocation failure
> > 459b54019cfe dm mpath: return DM_MAPIO_DELAY_REQUEUE if QUEUE_IO or PG_INIT_REQUIRED
> > ec3eaf9a6731 dm mpath: don't call blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE
> > 4dd6edd23e7e dm mpath: delay the retry of a request if the target responded as busy
> > 
> > This last one is the commit that _should_ serve as a proper replacement
> > for the change you manually reverted in your branch.
> > 
> > Please re-test after pulling in dm-4.16 and let us know how things fair.
> 
> Hello Mike,
> 
> If I replace the patch I referred to in my previous e-mail with your dm-4.16
> branch then I see the following:
> * Without I/O scheduler: dm path removal at the end of the test fails. This
>   succeeded reliably in the past so I think this is a regression:
>   # srp-test/run_tests -c -d -r 10 -q 1 -t 02-mq
>   [ ... ]
>   Unmounting /root/mnt1 from /dev/mapper/mpathb
>   SRP LUN /sys/class/scsi_device/4:0:0:0 / sdc: removing /dev/dm-1: done
>   SRP LUN /sys/class/scsi_device/4:0:0:1 / sde: removing /dev/dm-2: done
>   SRP LUN /sys/class/scsi_device/4:0:0:2 / sdd: removing /dev/dm-0: dm=$(dev_to_mpath "/dev/dm-0"): failed
>   [ ... ]

So no IO hangs?  Just removal of a dm device fails at the end?  Anything
in the kernel log that might give a hint as to why?  I'll need to
appreciate what the test is doing.

Like why is a single SRP scsi device being used to create a dm device?
What type of DM device?

> * With the Kyber I/O scheduler: I/O hangs.
>   # srp-test/run_tests -c -d -r 10 -q 1 -t 02-mq -e kyber
>   [ ... ]
>   Using /dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000 -> ../../dm-0
>   (hangs)

Again this says little to me.  But hopefully I'll find time to dig in
further and in parallel Laurence will be able to reproduce on his
testbed.

How critical is it to have the latest SCSI changes that are queued for
4.16?

Thanks,
Mike
