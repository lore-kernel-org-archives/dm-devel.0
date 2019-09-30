From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v4 2/2] mdadm: Introduce new array state
 'broken' for raid0/linear
Date: Mon, 30 Sep 2019 15:36:15 -0400
Message-ID: <608284db-7b82-6545-74bf-7a9f1d578c2f@gmail.com>
References: <20190903194901.13524-1-gpiccoli@canonical.com>
	<20190903194901.13524-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190903194901.13524-2-gpiccoli@canonical.com>
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
Cc: nfbrown@suse.com, Song Liu <songliubraving@fb.com>, liu.song.a23@gmail.com, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

On 9/3/19 3:49 PM, Guilherme G. Piccoli wrote:
> Currently if a md raid0/linear array gets one or more members removed while
> being mounted, kernel keeps showing state 'clean' in the 'array_state'
> sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
> cannot issue the STOP_ARRAY ioctl successfully, given the array is mounted.
> 
> Nothing else hints that something is wrong (except that the removed devices
> don't show properly in the output of mdadm 'detail' command). There is no
> other property to be checked, and if user is not performing reads/writes
> to the array, even kernel log is quiet and doesn't give a clue about the
> missing member.
> 
> This patch is the mdadm counterpart of kernel new array state 'broken'.
> The 'broken' state mimics the state 'clean' in every aspect, being useful
> only to distinguish if an array has some member missing. All necessary
> paths in mdadm were changed to deal with 'broken' state, and in case the
> tool runs in a kernel that is not updated, it'll work normally, i.e., it
> doesn't require the 'broken' state in order to work.
> Also, this patch changes the way the array state is showed in the 'detail'
> command (for raid0/linear only) - now it takes the 'array_state' sysfs
> attribute into account instead of only rely in the MD_SB_CLEAN flag.
> 
> Cc: Jes Sorensen <jes.sorensen@gmail.com>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---

Applied thanks!

I fixed up one minor nit rather than having to do the merry-go-round by 
email one more time:

> diff --git a/Monitor.c b/Monitor.c
> index 036103f..cf0610b 100644
> --- a/Monitor.c
> +++ b/Monitor.c
[snip]

> @@ -1116,7 +1119,8 @@ int WaitClean(char *dev, int verbose)
>   			rv = read(state_fd, buf, sizeof(buf));
>   			if (rv < 0)
>   				break;
> -			if (sysfs_match_word(buf, clean_states) <= 4)
> +			if (sysfs_match_word(buf, clean_states)
> +			    < (int)ARRAY_SIZE(clean_states)-1)

I moved the < up to the correct line where it belongs, and added spaces 
") - 1)"

Cheers,
Jes
