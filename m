From: Ming Lin-SSI <ming.l@ssi.samsung.com>
Subject: RE: 4.4-final: 28 bioset threads on small notebook
Date: Sun, 21 Feb 2016 06:43:24 +0000
Message-ID: <3A47B4705F6BE24CBB43C61AA73286211B3AA6A9@SSIEXCH-MB3.ssi.samsung.com>
References: <20151211104937.GA23165@amd> <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd> <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com> <20160220200432.GB22120@amd>
 <20160220203856.GB27149@redhat.com> <20160220205519.GA14108@amd>
 <20160221041540.GA24735@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160221041540.GA24735@kmo-pixel>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, "neilb@suse.de" <neilb@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dpark@posteo.net" <dpark@posteo.net>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "ming.lei@canonical.com" <ming.lei@canonical.com>, "agk@redhat.com" <agk@redhat.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "geoff@infradead.org" <geoff@infradead.org>, "jim@jtan.com" <jim@jtan.com>, "pjk1939@linux.vnet.ibm.com" <pjk1939@linux.vnet.ibm.com>, "minchan@kernel.org" <minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>, "oleg.drokin@intel.com" <oleg.drokin@intel.com>, "andreas.dilger@intel.com" <andreas.dilger@intel.com>
List-Id: dm-devel.ids

>-----Original Message-----
>From: Kent Overstreet [mailto:kent.overstreet@gmail.com]
>
>On Sat, Feb 20, 2016 at 09:55:19PM +0100, Pavel Machek wrote:
>> Hi!
>>
>> > > > You're directing this concern to the wrong person.
>> > > >
>> > > > I already told you DM is _not_ contributing any extra "bioset" threads
>> > > > (ever since commit dbba42d8a).
>> > >
>> > > Well, sorry about that. Note that l-k is on the cc list, so hopefully
>> > > the right person sees it too.
>> > >
>> > > Ok, let me check... it seems that
>> > > 54efd50bfd873e2dbf784e0b21a8027ba4299a3e is responsible, thus Kent
>> > > Overstreet <kent.overstreet@gmail.com> is to blame.
>> > >
>> > > Um, and you acked the patch, so you are partly responsible.
>> >
>> > You still haven't shown you even understand the patch so don't try to
>> > blame me for one aspect you don't like.
>>
>> Well, I don't have to understand the patch to argue its wrong.
>>
>> > > > But in general, these "bioset" threads are a side-effect of the
>> > > > late-bio-splitting support.  So is your position on it: "I don't like
>> > > > that feature if it comes at the expense of adding resources I can _see_
>> > > > for something I (naively?) view as useless"?
>> > >
>> > > > Just seems... naive... but you could be trying to say something else
>> > > > entirely.
>> > >
>> > > > Anyway, if you don't like something: understand why it is there and
>then
>> > > > try to fix it to your liking (without compromising why it was there to
>> > > > begin with).
>> > >
>> > > Well, 28 kernel threads on a notebook is a bug, plain and simple. Do
>> > > you argue it is not?
>> >
>> > Just implies you have 28 request_queues right?  You clearly have
>> > something else going on on your notebook than the average notebook
>> > user.
>>
>> I'm not using the modules, but otherwise I'm not doing anything
>> special. How many request_queues should I expect? How many do you
>have
>> on your notebook?
>
>It's one rescuer thread per bio_set, not one per request queue, so 28 is more
>than I'd expect but there's lots of random bio_sets so it's not entirely
>unexpected.
>
>It'd be better to have the rescuers be per request_queue, just someone is
>going
>to have to write the code.

I boot a VM and it also has 28 bioset threads.

That's because I have 27 block devices.

root@wheezy:~# ls /sys/block/
loop0  loop2  loop4  loop6  ram0  ram10  ram12  ram14  ram2  ram4  ram6  ram8  sr0  vdb
loop1  loop3  loop5  loop7  ram1  ram11  ram13  ram15  ram3  ram5  ram7  ram9  vda

And the additional one comes from init_bio

[    0.329627] Call Trace:
[    0.329970]  [<ffffffff813b132c>] dump_stack+0x63/0x87
[    0.330531]  [<ffffffff81377e7e>] __bioset_create+0x29e/0x2b0
[    0.331127]  [<ffffffff81d97896>] ? ca_keys_setup+0xa6/0xa6
[    0.331735]  [<ffffffff81d97937>] init_bio+0xa1/0xd1
[    0.332284]  [<ffffffff8100213d>] do_one_initcall+0xcd/0x1f0
[    0.332883]  [<ffffffff810972b6>] ? parse_args+0x296/0x480
[    0.333460]  [<ffffffff81d56297>] kernel_init_freeable+0x16f/0x1fa
[    0.334131]  [<ffffffff81d55999>] ? initcall_blacklist+0xba/0xba
[    0.334747]  [<ffffffff8177d970>] ? rest_init+0x80/0x80
[    0.335301]  [<ffffffff8177d97e>] kernel_init+0xe/0xf0
[    0.335842]  [<ffffffff81789dcf>] ret_from_fork+0x3f/0x70
[    0.336371]  [<ffffffff8177d970>] ? rest_init+0x80/0x80

So it's almost already "per request_queue"
