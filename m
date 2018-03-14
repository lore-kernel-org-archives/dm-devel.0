From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: fix passing integrity data
Date: Wed, 14 Mar 2018 15:44:01 -0400
Message-ID: <20180314194401.GA9609@redhat.com>
References: <20180314143306.98405-1-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180314143306.98405-1-maier@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-s390@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Fedor Loshakov <loshakov@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: dm-devel.ids

On Wed, Mar 14 2018 at 10:33am -0400,
Steffen Maier <maier@linux.vnet.ibm.com> wrote:

> After v4.12 commit e2460f2a4bc7 ("dm: mark targets that pass integrity
> data"), dm-multipath, e.g. on DIF+DIX SCSI disk paths, does not support
> block integrity any more. So add it to the whitelist.
> 
> This is also a pre-requisite to use block integrity with other dm layer(s)
> on top of multipath, such as kpartx partitions (dm-linear) or LVM.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Bisected-by: Fedor Loshakov <loshakov@linux.vnet.ibm.com>
> Fixes: e2460f2a4bc7 ("dm: mark targets that pass integrity data")
> Cc: <stable@vger.kernel.org> #4.12+
> ---
>  drivers/md/dm-mpath.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 3fde9e9faddd..c174f0c53dc9 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2023,7 +2023,8 @@ static int multipath_busy(struct dm_target *ti)
>  static struct target_type multipath_target = {
>  	.name = "multipath",
>  	.version = {1, 12, 0},
> -	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
> +	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
> +		    DM_TARGET_PASSES_INTEGRITY,
>  	.module = THIS_MODULE,
>  	.ctr = multipath_ctr,
>  	.dtr = multipath_dtr,

Thanks, I've queued this for 4.16-rc6, will send to Linus tomorrow.
