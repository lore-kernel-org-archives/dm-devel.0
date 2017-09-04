From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [RFC] Multi-device dm-log-writes
Date: Mon, 4 Sep 2017 16:42:53 +0200
Message-ID: <b32fb3c9-cb93-f3ee-74b7-37884e24b580@redhat.com>
References: <20170901183110.qjyxjrrksnub7y4a@destiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170901183110.qjyxjrrksnub7y4a@destiny>
Content-Language: de-CH
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josef Bacik <josef@toxicpanda.com>, snitzer@redhat.com, amir73il@gmail.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, clm@fb.com, osandov@fb.com, rwareing@fb.com
List-Id: dm-devel.ids

Josef,

using the current log-writes target, would a device tree with a single large
logged device sliced up into N linear mappings used by btrfs/md/... work to?
Or would that miss any semantics as of your design?

Heinz


On 09/01/2017 08:31 PM, Josef Bacik wrote:
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
>
> Mike, I would simply add a new struct target_type for log-writes-log that would
> do it's own ->map function to re-route the bio's coming into them.  I'd also
> change the ->ctr function of the log-writes target_type to handle the new id
> field and do the new fancy thing if we have that field populated.  Does that
> sound reasonable from an implementation point of view?
>
> Any comments or suggestions are welcome.  I haven't written any code yet so I'm
> open to other ideas.  Thanks,
>
> Josef
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
