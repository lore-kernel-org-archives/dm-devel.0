From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Multi-device dm-log-writes
Date: Fri, 1 Sep 2017 16:05:33 -0400
Message-ID: <20170901200532.GA18524@redhat.com>
References: <20170901183110.qjyxjrrksnub7y4a@destiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170901183110.qjyxjrrksnub7y4a@destiny>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josef Bacik <josef@toxicpanda.com>
Cc: amir73il@gmail.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, clm@fb.com, osandov@fb.com, rwareing@fb.com
List-Id: dm-devel.ids

On Fri, Sep 01 2017 at  2:31pm -0400,
Josef Bacik <josef@toxicpanda.com> wrote:

> Hello,
> 
> I'm looking at extending dm-log-writes to support multiple devices to log to a
> single log.  The benefit for this is testing things like btrfs's raid code, the
> xfs realtime device thing, and even mdraid.  I left room in the log format to
> change it as needed with this use case in mind, so I'm not worried about that.
> I'm more looking for verification that my plan doesn't suck, or if it does suck
> what would be a better approach.  I'll lay out the different parts to try and
> make this as quick and concise as possible.
> 
> 1) Add a "log-writes-log" target that just takes the single device we are going
> to use as the log.  This will do the work of taking the log IO from the actual
> "log-writes" target and putting it in the log.
> 
> 2) Extend the "log-writes" target table format to include an "id" at the end of
> the table line that will be used to indicate which device the log entry will be
> fore.  In this case the "log device" portion will point at the "log-writes-log"
> device mapper target.  Everything would work normally, except in this mode we
> send the log bio's down with bi_sector = 0 and let the "log-writes-log" target
> do the actual mapping for the bio.
> 
> So to test with multiple devices you would have to do something like
> 
> dmsetup create log --table "0 <size> log-writes-log <log device>"
> dmsetup create lw1 --table "0 <size> log-writes <device> /dev/mapper/log 0"
> dmsetup create lw2 --table "0 <size> log-writes <device> /dev/mapper/log 1"
> mkfs.btrfs -d raid1 -m raid1 /dev/mapper/lw1 /dev/mapper/lw2
> mount /dev/mapper/lw1 /mnt
> <do whatever>
> umount /mnt
> dmsetup remove lw1
> dmsetup remove lw2
> dmsetup remove log

This example illustrates the need for a separate log device nicely.

Though I'm not following why you'd want to override the bio's bi_sector
to be 0 when issuing the IO to the "log-writes-log" target device.
 
> Mike, I would simply add a new struct target_type for log-writes-log that would
> do it's own ->map function to re-route the bio's coming into them.  I'd also
> change the ->ctr function of the log-writes target_type to handle the new id
> field and do the new fancy thing if we have that field populated.  Does that
> sound reasonable from an implementation point of view?
>
> Any comments or suggestions are welcome.  I haven't written any code yet so I'm
> open to other ideas.  Thanks,

I'm still missing what type of mapping the "log-writes-log" target would
be doing if it just receives bios that have bi_sector of 0... I must be
missing something basic?  But wouldn't it be useful to preserve the
original bio offset for the IO and somehow encode which dev "id" the IO
came from (possibly as part of the per-bio-data) and use that as part of
the new ->map method?

Mike
