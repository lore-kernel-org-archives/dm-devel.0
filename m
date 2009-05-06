From: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
Subject: Re: [PATCH 18/18] io-controller: Debug hierarchical IO scheduling
Date: Wed, 06 May 2009 17:40:43 -0400
Message-ID: <4A0203DB.1090809@ds.jp.nec.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-19-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760727AbZEFVou@vger.kernel.org>
In-Reply-To: <1241553525-28095-19-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,

Patching and compilation error occurred on the 18/18 patch.
I know this is a patch for debug but report them in case.


Vivek Goyal wrote:
> @@ -2203,6 +2241,25 @@ EXPORT_SYMBOL(elv_get_slice_idle);
>  void elv_ioq_served(struct io_queue *ioq, bfq_service_t served)
>  {
>  	entity_served(&ioq->entity, served, ioq->nr_sectors);

Patch failed due to this line.  I guess this should be

	entity_served(&ioq->entity, served);


> +
> +#ifdef CONFIG_DEBUG_GROUP_IOSCHED
> +		{
> +			struct elv_fq_data *efqd = ioq->efqd;
> +			char path[128];
> +			struct io_group *iog = ioq_to_io_group(ioq);
> +			io_group_path(iog, path, sizeof(path));
> +			elv_log_ioq(efqd, ioq, "ioq served: QSt=0x%lx QSs=0x%lx"
> +				" QTt=0x%lx QTs=0x%lx grp=%s GTt=0x%lx "
> +				" GTs=0x%lx rq_queued=%d",
> +				served, ioq->nr_sectors,
> +				ioq->entity.total_service,
> +				ioq->entity.total_sector_service,
> +				path,
> +				iog->entity.total_service,
> +				iog->entity.total_sector_service,
> +				ioq->nr_queued);
> +		}
> +#endif
>  }

Because
  io_entity::total_service
and
  io_entity::total_sector_service
are not defined, compilation failed if CONFIG_DEBUG_GROUP_IOSCHED=y
here. (and everywhere referencing entity.total_service or  entity.total_sector_service)
They need to be defined like:

diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 1ea4ff3..6d0a735 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -147,6 +147,10 @@ struct io_entity {
        unsigned short ioprio_class, new_ioprio_class;
 
        int ioprio_changed;
+
+#ifdef CONFIG_DEBUG_GROUP_IOSCHED
+       unsigned long total_service, total_sector_service;
+#endif
 };
 
 /*

Unfortunately I couldn't figure out where and how the members
should be calculated, sorry.


-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com
