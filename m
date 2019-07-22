From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [RFC PATCH 0/3] md: export internal stats through debugfs
Date: Mon, 22 Jul 2019 14:31:20 -0700
Message-ID: <CAPhsuW6yH7np1=+e5Rgutp3m1VA0TPvtANeX=0ZdpJaRKEvBkQ@mail.gmail.com>
References: <20190702132918.114818-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702132918.114818-1-houtao1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hou Tao <houtao1@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Jul 2, 2019 at 6:25 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> There are so many io counters, stats and flags in md, so I think
> export these info to userspace will be helpful for online-debugging,
> especially when the vmlinux file and the crash utility are not
> available. And these info can also be utilized during code
> understanding.
>
> MD has already exported some stats through sysfs files under
> /sys/block/mdX/md, but using sysfs file to export more internal
> stats are not a good choice, because we need to create a single
> sysfs file for each internal stat according to the use convention
> of sysfs and there are too many internal stats. Further, the
> newly-created sysfs files would become APIs for userspace tools,
> but that is not we wanted, because these files are related with
> internal stats and internal stats may change from time to time.
>
> And I think debugfs is a better choice. Because we can show multiple
> related stats in a debugfs file, and the debugfs file will never be
> used as an userspace API.
>
> Two debugfs files are created to expose these internal stats:
> * iostat: io counters and io related stats (e.g., mddev->active_io,
>         r1conf->nr_pending, or r1confi->retry_list)
> * stat: normal stats/flags (e.g., mddev->recovery, conf->array_frozen)
>
> Because internal stats are spreaded all over md-core and md-personality,
> so both md-core and md-personality will create these two debugfs files
> under different debugfs directory.
>
> Patch 1 factors out the debugfs files creation routine for md-core and
> md-personality, patch 2 creates two debugfs files: iostat & stat under
> /sys/kernel/debug/block/mdX for md-core, and patch 3 creates two debugfs
> files: iostat & stat under /sys/kernel/debug/block/mdX/raid1 for md-raid1=
.
>
> The following lines show the hierarchy and the content of these debugfs
> files for a RAID1 device:
>
> $ pwd
> /sys/kernel/debug/block/md0
> $ tree
> .
> =E2=94=9C=E2=94=80=E2=94=80 iostat
> =E2=94=9C=E2=94=80=E2=94=80 raid1
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 iostat
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 stat
> =E2=94=94=E2=94=80=E2=94=80 stat
>
> $ cat iostat
> active_io 0
> sb_wait 0 pending_writes 0
> recovery_active 0
> bitmap pending_writes 0
>
> $ cat stat
> flags 0x20
> sb_flags 0x0
> recovery 0x0
>
> $ cat raid1/iostat
> retry_list active 0
> bio_end_io_list active 0
> pending_bio_list active 0 cnt 0
> sync_pending 0
> nr_pending 0
> nr_waiting 0
> nr_queued 0
> barrier 0

Hi,

Sorry for the late reply.

I think these information are really debug information that we should not
show in /sys. Once we expose them in /sys, we need to support them
because some use space may start searching data from them.

Thanks,
Song
