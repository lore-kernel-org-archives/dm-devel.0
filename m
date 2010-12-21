From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Tue, 21 Dec 2010 14:14:43 +1100
Message-ID: <20101221141443.5aea0b12@notabene.brown>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, 20 Dec 2010 21:37:37 -0500 Mike Snitzer <snitzer@redhat.com> wrote:

> I reviewed all patches and adjusted patch headers in preparation for
> inclusion in Alasdair's tree (upstream target being v2.6.38).  The 2
> md/bitmap changes can obviously go through Neil's MD tree if that is
> preferred.
> 
> - added Copyright to the top of dm-raid.c
> - fixed drivers/md/Kconfig so that DM_RAID will select MD_RAID456
> - removed unused 'conf' variable in raid_status()
> - few misc style and whitespace changes
> 
> Neil,
> Hopefully you're comfortable with the authorship of most of these
> patches still being attributed to you (despite Jon's changes to your
> original patches).
> 
> Please advise, thanks!

I haven't had a chance to have a proper look yet, and I'm about to go on
leave for a couple of weeks.
I'm probably happy with the authorship remaining as-is, but I reserve the
right to change my mind (about anything) once I've had a chance to have a
proper look.

Thanks,
NeilBrown


> Mike
> 
> Jonathan Brassow (2):
>   md/bitmap: revert dm-dirty-log preparation
>   md/raid5: use sysfs_notify_dirent_safe to avoid NULL pointer
> 
> NeilBrown (6):
>   md/bitmap: use DIV_ROUND_UP in bitmap_init_from_disk
>   dm raid: skeleton raid456 target support
>   dm: introduce target callbacks and congestion fn
>   dm: unplug callback
>   dm raid: add iterate_devices and io_hints functions
>   dm raid: add suspend and resume functions
> 
>  drivers/md/Kconfig            |   23 ++
>  drivers/md/Makefile           |    1 +
>  drivers/md/bitmap.c           |  139 +++------
>  drivers/md/bitmap.h           |    5 -
>  drivers/md/dm-raid.c          |  664 +++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-table.c         |   19 ++
>  drivers/md/md.h               |    5 -
>  drivers/md/raid5.c            |    2 +-
>  include/linux/device-mapper.h |   13 +
>  9 files changed, 766 insertions(+), 105 deletions(-)
>  create mode 100644 drivers/md/dm-raid.c
> 
