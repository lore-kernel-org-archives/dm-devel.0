From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 11/25] io-controller: Export disk time used
	and nr sectors dipatched through cgroups
Date: Wed, 8 Jul 2009 10:00:25 -0400
Message-ID: <20090708140025.GC24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-12-git-send-email-vgoyal@redhat.com>
	<4A54018C.5090804@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A54018C.5090804@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 10:16:44AM +0800, Gui Jianfeng wrote:
[..]
> 
> Hi Vivek,
> 
> Let io.disk_*'s outputs conform with io.policy's.
> 

Sure. Queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 7c83d1e..29392e7 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1631,7 +1631,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev),
>  					iog->entity.total_service);
>  		}
> @@ -1661,7 +1661,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev),
>  					iog->entity.total_sector_service);
>  		}
> @@ -1692,7 +1692,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev), iog->queue,
>  					iog->queue_duration);
>  		}
> @@ -1722,7 +1722,7 @@ static int io_cgroup_disk_dequeue_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev), iog->dequeue);
>  		}
>  	}
> -- 
> 1.5.4.rc3
> 
