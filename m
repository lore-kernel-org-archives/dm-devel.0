From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 17/19] io-controller: Support per cgroup per device weights
 and io class
Date: Wed, 10 Jun 2009 15:44:42 +0800
Message-ID: <4A2F646A.8070403@cn.fujitsu.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-18-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757163AbZFJHqc@vger.kernel.org>
In-Reply-To: <1244513342-11758-18-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>  
> @@ -1233,6 +1254,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
>  		elv_get_iog(iog);
>  
>  		iog->iocg_id = css_id(&iocg->css);
> +		io_group_init_entity(iocg, iog, iog->dev);

Hi Vivek,

A regression occurs in io.policy handling. IO Controller completely stops working when i use 
this interface. 
Make sure that we initialize entity after iog->dev is setting up properly.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 6b30c36..a516dce 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1451,7 +1451,6 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
 		elv_get_iog(iog);
 
 		iog->iocg_id = css_id(&iocg->css);
-		io_group_init_entity(iocg, iog, iog->dev);
 		iog->my_entity = &iog->entity;
 
 		if (bio) {
@@ -1459,6 +1458,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
 			iog->dev = MKDEV(disk->major, disk->first_minor);
 		}
 
+		io_group_init_entity(iocg, iog, iog->dev);
+
 		blk_init_request_list(&iog->rl);
 #ifdef CONFIG_DEBUG_GROUP_IOSCHED
 		io_group_path(iog, iog->path, sizeof(iog->path));
-- 
1.5.4.rc3
