From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Thu, 22 Aug 2019 10:49:52 +0200
Message-ID: <ca2096ca-8cb2-468f-89d4-24cd059b8a6b@cloud.ionos.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190816134059.29751-1-gpiccoli@canonical.com>
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
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, dm-devel@redhat.com, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>
List-Id: dm-devel.ids

Hi,

On 8/16/19 3:40 PM, Guilherme G. Piccoli wrote:
> +static bool linear_is_missing_dev(struct mddev *mddev)
> +{
> +	struct md_rdev *rdev;
> +	static int already_missing;
> +	int def_disks, work_disks = 0;
> +
> +	def_disks = mddev->raid_disks;
> +	rdev_for_each(rdev, mddev)
> +		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
> +			work_disks++;
> +
> +	if (unlikely(def_disks - work_disks)) {

If my understanding is correct, after enter the branch,

> +		if (already_missing < (def_disks - work_disks)) {

the above is always true since already_missing should be '0', right?
If so, maybe the above checking is pointless.

> +			already_missing = def_disks - work_disks;
> +			pr_warn("md: %s: linear array has %d missing/failed members\n",
> +				mdname(mddev), already_missing);
> +		}
> +		return true;
> +	}
> +
> +	already_missing = 0;
> +	return false;
> +}
> +.

I'd suggest something like, just FYI.

bool already_missing = false;
int missing_disks;

missing_disks = def_disks - work_disks;
if (unlikely(missing_disks)) {
	already_missing = true;
	pr_warn("md: %s: linear array has %d missing/failed members\n", mdname(mddev), missing_disks);
}
return already_missing;


Thanks,
Guoqing
