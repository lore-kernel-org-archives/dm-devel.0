From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
Date: Fri, 21 Aug 2009 09:54:02 +0800
Message-ID: <4A8DFE3A.6030503@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754552AbZHUByy@vger.kernel.org>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +
> +static void put_prev_io_entity(struct io_entity *entity)
> +{
> +	struct io_service_tree *st = entity->st;
> +	struct io_sched_data *sd = io_entity_sched_data(entity);
> +
> +	st->active_entity = NULL;
> +	sd->active_entity = NULL;
> +
> +	if (unlikely(entity->ioprio_changed)) {
> +		dequeue_io_entity(entity);
> +		io_entity_update_prio(entity);

Hi Vivek,

we don't need to update prio here for the following enqueue_io_entity() 
is already taking care of it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 201543e..b720139 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -607,7 +607,6 @@ static void put_prev_io_entity(struct io_entity *entity)
 
 	if (unlikely(entity->ioprio_changed)) {
 		dequeue_io_entity(entity);
-		io_entity_update_prio(entity);
 		enqueue_io_entity(entity);
 	} else
 		__enqueue_io_entity(st, entity);
-- 
1.5.4.rc3
