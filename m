From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
 'broken' for raid0
Date: Tue, 30 Jul 2019 14:20:34 +0800
Message-ID: <d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190729203135.12934-2-gpiccoli@canonical.com>
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
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, dm-devel@redhat.com, songliubraving@fb.com, neilb@suse.com
List-Id: dm-devel.ids

On 7/30/19 4:31 AM, Guilherme G. Piccoli wrote:
> Currently if a md/raid0 array gets one or more members removed while
> being mounted, kernel keeps showing state 'clean' in the 'array_state'
> sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
> cannot issue the STOP_ARRAY ioctl successfully, given the array is mounted.
> 
> Nothing else hints that something is wrong (except that the removed devices
> don't show properly in the output of 'mdadm detail' command). There is no
> other property to be checked, and if user is not performing reads/writes
> to the array, even kernel log is quiet and doesn't give a clue about the
> missing member.
> 
> This patch changes this behavior; when 'array_state' is read we introduce
> a non-expensive check (only for raid0) that relies in the comparison of
> the total number of disks when array was assembled with gendisk flags of> those devices to validate if all members are available and functional.
> A new array state 'broken' was added: it mimics the state 'clean' in every
> aspect, being useful only to distinguish if such array has some member
> missing. Also, we show a rate-limited warning in kernel log in such case.
> 
> This patch has no proper functional change other than adding a 'clean'-like
> state; it was tested with ext4 and xfs filesystems. It requires a 'mdadm'
> counterpart to handle the 'broken' state.
> 
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>  drivers/md/md.c    | 23 +++++++++++++++++++----
>  drivers/md/md.h    |  2 ++
>  drivers/md/raid0.c | 26 ++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fba49918d591..b80f36084ec1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4160,12 +4160,18 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
>   * active-idle
>   *     like active, but no writes have been seen for a while (100msec).
>   *
> + * broken
> + *     RAID0-only: same as clean, but array is missing a member.
> + *     It's useful because RAID0 mounted-arrays aren't stopped
> + *     when a member is gone, so this state will at least alert
> + *     the user that something is wrong.


Curious why only raid0 has this issue? 

Thanks, -Bob

> + *
>   */
>  enum array_state { clear, inactive, suspended, readonly, read_auto, clean, active,
> -		   write_pending, active_idle, bad_word};
> +		   write_pending, active_idle, broken, bad_word};
>  static char *array_states[] = {
>  	"clear", "inactive", "suspended", "readonly", "read-auto", "clean", "active",
> -	"write-pending", "active-idle", NULL };
> +	"write-pending", "active-idle", "broken", NULL };
>  
>  static int match_word(const char *word, char **list)
>  {
> @@ -4181,7 +4187,7 @@ array_state_show(struct mddev *mddev, char *page)
>  {
>  	enum array_state st = inactive;
>  
> -	if (mddev->pers)
> +	if (mddev->pers) {
>  		switch(mddev->ro) {
>  		case 1:
>  			st = readonly;
> @@ -4201,7 +4207,15 @@ array_state_show(struct mddev *mddev, char *page)
>  				st = active;
>  			spin_unlock(&mddev->lock);
>  		}
> -	else {
> +
> +		if ((mddev->pers->level == 0) &&
> +		   ((st == clean) || (st == broken))) {
> +			if (mddev->pers->is_missing_dev(mddev))
> +				st = broken;
> +			else
> +				st = clean;
> +		}
> +	} else {
>  		if (list_empty(&mddev->disks) &&
>  		    mddev->raid_disks == 0 &&
>  		    mddev->dev_sectors == 0)
> @@ -4315,6 +4329,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>  		break;
>  	case write_pending:
>  	case active_idle:
> +	case broken:
>  		/* these cannot be set */
>  		break;
>  	}
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 41552e615c4c..e7b42b75701a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -590,6 +590,8 @@ struct md_personality
>  	int (*congested)(struct mddev *mddev, int bits);
>  	/* Changes the consistency policy of an active array. */
>  	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
> +	/* Check if there is any missing/failed members - RAID0 only for now. */
> +	bool (*is_missing_dev)(struct mddev *mddev);
>  };
>  
>  struct md_sysfs_entry {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 58a9cc5193bf..79618a6ae31a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -455,6 +455,31 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
>  	}
>  }
>  
> +bool raid0_is_missing_dev(struct mddev *mddev)
> +{
> +	struct md_rdev *rdev;
> +	static int already_missing;
> +	int def_disks, work_disks = 0;
> +	struct r0conf *conf = mddev->private;
> +
> +	def_disks = conf->strip_zone[0].nb_dev;
> +	rdev_for_each(rdev, mddev)
> +		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
> +			work_disks++;
> +
> +	if (unlikely(def_disks - work_disks)) {
> +		if (!already_missing) {
> +			already_missing = 1;
> +			pr_warn("md: %s: raid0 array has %d missing/failed members\n",
> +				mdname(mddev), (def_disks - work_disks));
> +		}
> +		return true;
> +	}
> +
> +	already_missing = 0;
> +	return false;
> +}
> +
>  static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r0conf *conf = mddev->private;
> @@ -789,6 +814,7 @@ static struct md_personality raid0_personality=
>  	.takeover	= raid0_takeover,
>  	.quiesce	= raid0_quiesce,
>  	.congested	= raid0_congested,
> +	.is_missing_dev	= raid0_is_missing_dev,
>  };
>  
>  static int __init raid0_init (void)
> 
