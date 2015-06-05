From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Thu, 4 Jun 2015 22:21:24 -0700
Message-ID: <CAF1ivSZpwXiW+DtW2oGEmprLD9+LKqbj99qkFmr8GoJZ5EUxOg@mail.gmail.com>
References: <1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
	<CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
	<20150528003627.GD32216@agk-dp.fab.redhat.com>
	<1433138551.11778.4.camel@hasee>
	<CAF1ivSY_7M1OhrMuXg0OKu7BPy=SbTHSHCk+2q6vfEVgvJL8YA@mail.gmail.com>
	<20150604210617.GA23710@redhat.com>
	<CAF1ivSa_U5LFNWMdw8dBadoWVU6uk+ph_NP5jQztLWYHyRz-MQ@mail.gmail.com>
	<20150605000636.GA24611@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150605000636.GA24611-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jun 4, 2015 at 5:06 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Jun 04 2015 at  6:21pm -0400,
> Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> On Thu, Jun 4, 2015 at 2:06 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > We need to test on large HW raid setups like a Netapp filer (or even
>> > local SAS drives connected via some SAS controller).  Like a 8+2 drive
>> > RAID6 or 8+1 RAID5 setup.  Testing with MD raid on JBOD setups with 8
>> > devices is also useful.  It is larger RAID setups that will be more
>> > sensitive to IO sizes being properly aligned on RAID stripe and/or chunk
>> > size boundaries.
>>
>> I'll test it on large HW raid setup.
>>
>> Here is HW RAID5 setup with 19 278G HDDs on Dell R730xd(2sockets/48
>> logical cpus/264G mem).
>> http://minggr.net/pub/20150604/hw_raid5.jpg
>>
>> The stripe size is 64K.
>>
>> I'm going to test ext4/btrfs/xfs on it.
>> "bs" set to 1216k(64K * 19 = 1216k)
>> and run 48 jobs.
>
> Definitely an odd blocksize (though 1280K full stripe is pretty common
> for 10+2 HW RAID6 w/ 128K chunk size).

I can change it to 10 HDDs HW RAID6 w/ 128K chunk size, then use bs=1280K

>
>> [global]
>> ioengine=libaio
>> iodepth=64
>> direct=1
>> runtime=1800
>> time_based
>> group_reporting
>> numjobs=48
>> rw=read
>>
>> [job1]
>> bs=1216K
>> directory=/mnt
>> size=1G
>
> How does time_based relate to size=1G?  It'll rewrite the same 1 gig
> file repeatedly?

Above job file is for read.
For write, I think so.
Do is make sense for performance test?

>
>> Or do you have other suggestions of what tests I should run?
>
> You're welcome to run this job but I'll also check with others here to
> see what fio jobs we used in the recent past when assessing performance
> of the dm-crypt parallelization changes.

That's very helpful.

>
> Also, a lot of care needs to be taken to eliminate jitter in the system
> while the test is running.  We got a lot of good insight from Bart Van
> Assche on that and put it to practice.  I'll see if we can (re)summarize
> that too.

Very helpful too.

Thanks.

>
> Mike
