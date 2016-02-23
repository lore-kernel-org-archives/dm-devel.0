From: Ming Lei <ming.lei@canonical.com>
Subject: Re: 4.4-final: 28 bioset threads on small notebook
Date: Tue, 23 Feb 2016 10:55:48 +0800
Message-ID: <CACVXFVNMMhR-uOSYvV+VLrSFtmQZUmoQBSAwKFcXcSvB_HUO-A@mail.gmail.com>
References: <20151211140841.GA22873@redhat.com>
	<20160220174035.GA16459@amd>
	<20160220184258.GA3753@amd>
	<20160220195136.GA27149@redhat.com>
	<20160220200432.GB22120@amd>
	<20160220203856.GB27149@redhat.com>
	<20160220205519.GA14108@amd>
	<20160221041540.GA24735@kmo-pixel>
	<3A47B4705F6BE24CBB43C61AA73286211B3AA6A9@SSIEXCH-MB3.ssi.samsung.com>
	<CACVXFVPav3D2MzNFR-b4YadFMM6_KcyEYQ7dx4t1r9fMOLDaFw@mail.gmail.com>
	<20160222225818.GA2675@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160222225818.GA2675@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Ming Lin-SSI <ming.l@ssi.samsung.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, "neilb@suse.de" <neilb@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dpark@posteo.net" <dpark@posteo.net>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "geoff@infradead.org" <geoff@infradead.org>, "jim@jtan.com" <jim@jtan.com>, "pjk1939@linux.vnet.ibm.com" <pjk1939@linux.vnet.ibm.com>, "minchan@kernel.org" <minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>, "oleg.drokin@intel.com" <oleg.drokin@intel.com>, "andreas.dilger@intel.com" <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Tue, Feb 23, 2016 at 6:58 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Sun, Feb 21, 2016 at 05:40:59PM +0800, Ming Lei wrote:
>> On Sun, Feb 21, 2016 at 2:43 PM, Ming Lin-SSI <ming.l@ssi.samsung.com> wrote:
>> >>-----Original Message-----
>> >
>> > So it's almost already "per request_queue"
>>
>> Yes, that is because of the following line:
>>
>> q->bio_split = bioset_create(BIO_POOL_SIZE, 0);
>>
>> in blk_alloc_queue_node().
>>
>> Looks like this bio_set doesn't need to be per-request_queue, and
>> now it is only used for fast-cloning bio for splitting, and one global
>> split bio_set should be enough.
>
> It does have to be per request queue for stacking block devices (which includes
> loopback).

In commit df2cb6daa4(block: Avoid deadlocks with bio allocation by
stacking drivers), deadlock in this situation has been avoided already.
Or are there other issues with global bio_set? I appreciate if you may
explain it a bit if there are.

Thanks,
Ming Lei
