From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 18/19] io-controller: Debug hierarchical IO
	scheduling
Date: Fri, 19 Jun 2009 14:26:06 +0800
Message-ID: <4A3B2F7E.10405@cn.fujitsu.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-19-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244513342-11758-19-git-send-email-vgoyal@redhat.com>
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
> +static inline void bfq_account_for_entity_addition(struct io_entity *entity)
> +{
> +	struct io_group *iog = io_entity_to_iog(entity);
> +
> +	if (iog) {
> +		struct elv_fq_data *efqd;
> +		char path[128];
> +
> +		/*
> +		 * Keep track of how many times a group has been removed
> +		 * from active tree because it did not have any active
> +		 * backlogged ioq under it
> +		 */
> +		iog->queue++;
> +		iog->queue_start = jiffies;
> +
> +		/* Log group addition event */
> +		rcu_read_lock();
> +		efqd = rcu_dereference(iog->key);
> +		if (efqd) {
> +			io_group_path(iog, path, sizeof(path));
> +			elv_log(efqd, "add group=%s weight=%ld", path,
> +					iog->entity.weight);

Since cgroup path is already cached, why not use it. :)

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index bfa79c9..1a397c3 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -183,7 +183,6 @@ static inline void bfq_account_for_entity_addition(struct io_entity *entity)
 
 	if (iog) {
 		struct elv_fq_data *efqd;
-		char path[128];
 
 		/*
 		 * Keep track of how many times a group has been removed
@@ -197,9 +196,8 @@ static inline void bfq_account_for_entity_addition(struct io_entity *entity)
 		rcu_read_lock();
 		efqd = rcu_dereference(iog->key);
 		if (efqd) {
-			io_group_path(iog, path, sizeof(path));
-			elv_log(efqd, "add group=%s weight=%ld", path,
-					iog->entity.weight);
+			elv_log(efqd, "add group=%s weight=%ld", iog->path,
+				iog->entity.weight);
 		}
 		rcu_read_unlock();
 	}
@@ -215,7 +213,6 @@ static inline void bfq_account_for_entity_deletion(struct io_entity *entity)
 
 	if (iog) {
 		struct elv_fq_data *efqd;
-		char path[128];
 
 		iog->dequeue++;
 		/* Keep a track of how long group was on active tree */
@@ -227,9 +224,8 @@ static inline void bfq_account_for_entity_deletion(struct io_entity *entity)
 		rcu_read_lock();
 		efqd = rcu_dereference(iog->key);
 		if (efqd) {
-			io_group_path(iog, path, sizeof(path));
-			elv_log(efqd, "del group=%s weight=%ld", path,
-					iog->entity.weight);
+			elv_log(efqd, "del group=%s weight=%ld", iog->path,
+				iog->entity.weight);
 		}
 		rcu_read_unlock();
 	}
-- 
1.5.4.rc3
