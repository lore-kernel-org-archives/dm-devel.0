From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
 'broken' and fail BIOs if a member is gone
Date: Thu, 22 Aug 2019 21:55:23 +0000
Message-ID: <73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190822161318.26236-1-gpiccoli@canonical.com>
Content-Language: en-US
Content-ID: <9EB021AC02A93A41880C260032233E66@namprd15.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids



> On Aug 22, 2019, at 9:13 AM, Guilherme G. Piccoli <gpiccoli@canonical.com> wrote:
> 
> Currently md raid0/linear are not provided with any mechanism to validate
> if an array member got removed or failed. The driver keeps sending BIOs
> regardless of the state of array members, and kernel shows state 'clean'
> in the 'array_state' sysfs attribute. This leads to the following
> situation: if a raid0/linear array member is removed and the array is
> mounted, some user writing to this array won't realize that errors are
> happening unless they check dmesg or perform one fsync per written file.
> Despite udev signaling the member device is gone, 'mdadm' cannot issue the
> STOP_ARRAY ioctl successfully, given the array is mounted.

[...]

> drivers/md/md-linear.c |  9 +++++++++
> drivers/md/md.c        | 22 ++++++++++++++++++----
> drivers/md/md.h        |  3 +++
> drivers/md/raid0.c     | 10 ++++++++++
> 4 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 7354466ddc90..0479ccdbdeeb 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -258,6 +258,15 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
> 		     bio_sector < start_sector))
> 		goto out_of_bounds;
> 
> +	if (unlikely(!(tmp_dev->rdev->bdev->bd_disk->flags & GENHD_FL_UP))) {
> +		if (!test_bit(MD_BROKEN, &mddev->flags))
> +			pr_warn("md: %s: linear array has a missing/failed member\n",
> +				mdname(mddev));
> +		set_bit(MD_BROKEN, &mddev->flags);
> +		bio_io_error(bio);
> +		return true;
> +	}
> +

Maybe we can somehow put this block in a helper and use it in both raid0
and linear code?

Otherwise, looks good to me. 

Thanks,
Song
