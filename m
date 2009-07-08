From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 11/25] io-controller: Export disk time used
 and nr sectors dipatched through cgroups
Date: Wed, 08 Jul 2009 10:16:44 +0800
Message-ID: <4A54018C.5090804@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-12-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-12-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>  
> +static int io_cgroup_disk_time_read(struct cgroup *cgroup,
> +				struct cftype *cftype, struct seq_file *m)
> +{
> +	struct io_cgroup *iocg;
> +	struct io_group *iog;
> +	struct hlist_node *n;
> +
> +	if (!cgroup_lock_live_group(cgroup))
> +		return -ENODEV;
> +
> +	iocg = cgroup_to_io_cgroup(cgroup);
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> +		/*
> +		 * There might be groups which are not functional and
> +		 * waiting to be reclaimed upon cgoup deletion.
> +		 */
> +		if (iog->key) {
> +			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +					MINOR(iog->dev),
> +					iog->entity.total_service);

Hi Vivek,

Let io.disk_*'s outputs conform with io.policy's.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 7c83d1e..29392e7 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1631,7 +1631,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev),
 					iog->entity.total_service);
 		}
@@ -1661,7 +1661,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev),
 					iog->entity.total_sector_service);
 		}
@@ -1692,7 +1692,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev), iog->queue,
 					iog->queue_duration);
 		}
@@ -1722,7 +1722,7 @@ static int io_cgroup_disk_dequeue_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev), iog->dequeue);
 		}
 	}
-- 
1.5.4.rc3
