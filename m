From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: Multi-device dm-log-writes
Date: Sat, 2 Sep 2017 05:54:53 -0400
Message-ID: <20170902095451.rlu5ha34qq5lyxtc@destiny>
References: <20170901183110.qjyxjrrksnub7y4a@destiny>
 <20170901200532.GA18524@redhat.com>
 <20170902001035.wqnlxxzbf5hsvubg@destiny>
 <CAOQ4uxgP=yUytPkfVQkKfoGjRDb+ha6uhZptSXrcA2W0=Dbr0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgP=yUytPkfVQkKfoGjRDb+ha6uhZptSXrcA2W0=Dbr0g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@fb.com, Chris Mason <clm@fb.com>, osandov@fb.com, rwareing@fb.com
List-Id: dm-devel.ids

On Sat, Sep 02, 2017 at 11:12:17AM +0300, Amir Goldstein wrote:
> On Sat, Sep 2, 2017 at 3:10 AM, Josef Bacik <josef@toxicpanda.com> wrote:
> > On Fri, Sep 01, 2017 at 04:05:33PM -0400, Mike Snitzer wrote:
> >> On Fri, Sep 01 2017 at  2:31pm -0400,
> >> Josef Bacik <josef@toxicpanda.com> wrote:
> >>
> >> > Hello,
> >> >
> >> > I'm looking at extending dm-log-writes to support multiple devices to log to a
> >> > single log.  The benefit for this is testing things like btrfs's raid code, the
> >> > xfs realtime device thing, and even mdraid.  I left room in the log format to
> >> > change it as needed with this use case in mind, so I'm not worried about that.
> >> > I'm more looking for verification that my plan doesn't suck, or if it does suck
> >> > what would be a better approach.  I'll lay out the different parts to try and
> >> > make this as quick and concise as possible.
> >> >
> >> > 1) Add a "log-writes-log" target that just takes the single device we are going
> >> > to use as the log.  This will do the work of taking the log IO from the actual
> >> > "log-writes" target and putting it in the log.
> >> >
> >> > 2) Extend the "log-writes" target table format to include an "id" at the end of
> >> > the table line that will be used to indicate which device the log entry will be
> >> > fore.  In this case the "log device" portion will point at the "log-writes-log"
> >> > device mapper target.  Everything would work normally, except in this mode we
> >> > send the log bio's down with bi_sector = 0 and let the "log-writes-log" target
> >> > do the actual mapping for the bio.
> >> >
> >> > So to test with multiple devices you would have to do something like
> >> >
> >> > dmsetup create log --table "0 <size> log-writes-log <log device>"
> >> > dmsetup create lw1 --table "0 <size> log-writes <device> /dev/mapper/log 0"
> >> > dmsetup create lw2 --table "0 <size> log-writes <device> /dev/mapper/log 1"
> >> > mkfs.btrfs -d raid1 -m raid1 /dev/mapper/lw1 /dev/mapper/lw2
> >> > mount /dev/mapper/lw1 /mnt
> >> > <do whatever>
> >> > umount /mnt
> >> > dmsetup remove lw1
> >> > dmsetup remove lw2
> >> > dmsetup remove log
> >>
> >> This example illustrates the need for a separate log device nicely.
> >>
> >> Though I'm not following why you'd want to override the bio's bi_sector
> >> to be 0 when issuing the IO to the "log-writes-log" target device.
> >>
> >> > Mike, I would simply add a new struct target_type for log-writes-log that would
> >> > do it's own ->map function to re-route the bio's coming into them.  I'd also
> >> > change the ->ctr function of the log-writes target_type to handle the new id
> >> > field and do the new fancy thing if we have that field populated.  Does that
> >> > sound reasonable from an implementation point of view?
> >> >
> >> > Any comments or suggestions are welcome.  I haven't written any code yet so I'm
> >> > open to other ideas.  Thanks,
> >>
> >> I'm still missing what type of mapping the "log-writes-log" target would
> >> be doing if it just receives bios that have bi_sector of 0... I must be
> >> missing something basic?  But wouldn't it be useful to preserve the
> >> original bio offset for the IO and somehow encode which dev "id" the IO
> >> came from (possibly as part of the per-bio-data) and use that as part of
> >> the new ->map method?
> >>
> >
> > Yeah sorry the bio's going to the "log-writes-log" target will be the log entry
> > with the original sector information and device id plus the actual data that was
> > written.  The bi_sector will be 0 because "log-writes-log" is going to put it
> > where it actually goes, it's just a log so starts at sector 1 and goes on from
> > there based on whatever we're logging.  See the lc->next_sector part we
> > currently have, in this new setup the lc->next_sector would only matter for the
> > "log-writes-log" target, and is what would be used to populate the bio that we
> > are logging.  Thanks,
> >
> 
> Me too was confused about the need for log-writes-log, but now I understand
> its purpose is to have a single logging kthread per log device.
> So basically, you could do the same thing without the need to setup the
> log-writes-log explicitly by the user and set it up / tear it down implicitly
> from log-writes device when setting up target for a new log device.
>

Well that's the thing, if we just did something like

dmsetup create lw1 --table "0 <size> <device> /dev/sdb 0"
dmsetup create lw2 --table "0 <size> <device> /dev/sdb 1"

There would be no way to coordinate writing to /dev/sdb since there's no shared
state between lw1 and lw2.  Creating the specialized target means that we can
have lw1 and lw2 use all of the current code for the normal log-writes
operations, and then the "log-writes-log" handles making sure that the log
entries get written sequentially to the log.

My original thought was something like

dmsetup create lw --table "0 <size> <num devices> <device1> <device2> /dev/sdb"

But then we'd have to create lw1..lw<num devices> from the target itself, and
I'm not sure how kosher it is for a dm target to create multiple dm devices from
a single table.  Thus the specialized target to solve the need for shared state.

> I have no objection at all for the explicit setup step as long as we understand
> there is an alternative.
> 
> Regarding the format of the log entry, please include in v2 format some sort
> of magic in entry header, I found it useful to detect log corruption
> during replay.
> I also found that if entry had hdr_len (the offset where hdr_data
> begins) if would
> have been easier for me to insert extra debugging fields (magic) into the header
> without breaking unmodified replay-log. (I added add magic after data,
> but that's
> just a simple example).
> 

Yup I'll add all that to the v2 log entry, thanks,

Josef
