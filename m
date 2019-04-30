From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [RFC] [PATCH V2 0/1] Introduce emergency raid0 stop
 for mounted arrays
Date: Tue, 30 Apr 2019 19:41:11 -0300
Message-ID: <b39b96ea-2540-a407-2232-1af91e3e6658@canonical.com>
References: <20190418220448.7219-1-gpiccoli@canonical.com>
	<CAPhsuW4k5zz2pJBPL60VzjTcj6NTnhBh-RjvWASLcOxAk+yDEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW4k5zz2pJBPL60VzjTcj6NTnhBh-RjvWASLcOxAk+yDEw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Song Liu <liu.song.a23@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, kernel@gpiccoli.net, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, jay.vosburgh@canonical.com, gavin.guo@canonical.com
List-Id: dm-devel.ids

> On 19/04/2019 14:08, Song Liu wrote:
> [...]
> I read through the discussion in V1, and I would agree with Neil that
> current behavior is reasonable.
> 
> For the following example:
> 
> fd = open("file", "w");
> write(fd, buf, size);
> ret = fsync(fd);
> 
> If "size" is big enough, the write is not expected to be atomic for
> md or other drives. If we remove the underlining block device
> after write() and before fsync(), the file could get corrupted. This
> is the same for md or NVMe/SCSI drives.
> 
> The application need to check "ret" from fsync(), the data is safe
> only when fsync() returns 0.
> 
> Does this make sense?
> 

Hi Song, thanks for your quick response, and sorry for my delay.
I've noticed after v4.18 kernel started to crash when we remove one
raid0 member while writing, so I was investigating this
before perform your test (in fact, found 2 issues [0]), hence my delay.

Your test does make sense; in fact I've tested your scenario with the
following code (with the patches from [0]):
https://pastebin.ubuntu.com/p/cyqpDqpM7x/

Indeed, fsync returns -1 in this case.
Interestingly, when I do a "dd if=<some_file> of=<raid0_mount>" and try
to "sync -f <some_file>" and "sync", it succeeds and the file is
written, although corrupted.

Do you think this behavior is correct? In other devices, like a pure
SCSI disk or NVMe, the 'dd' write fails.
Also, what about the status of the raid0 array in mdadm - it shows as
"clean" even after the member is removed, should we change that?


> Also, could you please highlight changes from V1 (if more than
> just rebase)?

No changes other than rebase. Worth mentioning here that a kernel bot
(and Julia Lawall) found an issue in my patch; I forgot a
"mutex_lock(&mddev->open_mutex);" in line 6053, which caused the first
caveat (hung mdadm and persistent device in /dev). Thanks for pointing
this silly mistake from me! in case this patch gets some traction, I'll
re-submit with that fixed.

Cheers,


Guilherme

[0] https://marc.info/?l=linux-block&m=155666385707413

> 
> Thanks,
> Song
> 
