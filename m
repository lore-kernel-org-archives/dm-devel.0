Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6E6C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 23:58:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-VpLpJfDoOResQbt_VwwPVw-1; Mon, 11 Apr 2022 19:58:28 -0400
X-MC-Unique: VpLpJfDoOResQbt_VwwPVw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 547A6185A79C;
	Mon, 11 Apr 2022 23:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41F90403375;
	Mon, 11 Apr 2022 23:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD7E51949762;
	Mon, 11 Apr 2022 23:58:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D85E11949762
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 23:58:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5B6E407E1C2; Mon, 11 Apr 2022 23:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1A93407F78B
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:58:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99BC085A5BE
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:58:24 +0000 (UTC)
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk
 [46.235.227.227]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-mVsMpnqUNkaXAUaC6SX73Q-1; Mon, 11 Apr 2022 19:58:22 -0400
X-MC-Unique: mVsMpnqUNkaXAUaC6SX73Q-1
Received: from [127.0.0.1] (localhost [127.0.0.1])
 (Authenticated sender: krisman) with ESMTPSA id 847731F43D1B
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: Khazhismel Kumykov <khazhy@google.com>
Organization: Collabora
References: <20220411220335.1235363-1-khazhy@google.com>
Date: Mon, 11 Apr 2022 19:48:53 -0400
In-Reply-To: <20220411220335.1235363-1-khazhy@google.com> (Khazhismel
 Kumykov's message of "Mon, 11 Apr 2022 15:03:35 -0700")
Message-ID: <87wnfvxjtm.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] dm mpath: fixup sched_clock() usage in
 historical selector
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Khazhismel Kumykov <khazhy@google.com> writes:

> mixing sched_clock() and ktime_get_ns() will give bad results, don't do
> it
>
> Fixes: 2613eab11996 ("dm mpath: add Historical Service Time Path Selector")
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Looks good.

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


> ---
>  drivers/md/dm-ps-historical-service-time.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
> index 875bca30a0dd..82f2a06153dc 100644
> --- a/drivers/md/dm-ps-historical-service-time.c
> +++ b/drivers/md/dm-ps-historical-service-time.c
> @@ -27,7 +27,6 @@
>  #include <linux/blkdev.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> -#include <linux/sched/clock.h>
>  
>  
>  #define DM_MSG_PREFIX	"multipath historical-service-time"
> @@ -433,7 +432,7 @@ static struct dm_path *hst_select_path(struct path_selector *ps,
>  {
>  	struct selector *s = ps->context;
>  	struct path_info *pi = NULL, *best = NULL;
> -	u64 time_now = sched_clock();
> +	u64 time_now = ktime_get_ns();
>  	struct dm_path *ret = NULL;
>  	unsigned long flags;
>  
> @@ -474,7 +473,7 @@ static int hst_start_io(struct path_selector *ps, struct dm_path *path,
>  
>  static u64 path_service_time(struct path_info *pi, u64 start_time)
>  {
> -	u64 sched_now = ktime_get_ns();
> +	u64 now = ktime_get_ns();
>  
>  	/* if a previous disk request has finished after this IO was
>  	 * sent to the hardware, pretend the submission happened
> @@ -483,11 +482,11 @@ static u64 path_service_time(struct path_info *pi, u64 start_time)
>  	if (time_after64(pi->last_finish, start_time))
>  		start_time = pi->last_finish;
>  
> -	pi->last_finish = sched_now;
> -	if (time_before64(sched_now, start_time))
> +	pi->last_finish = now;
> +	if (time_before64(now, start_time))
>  		return 0;
>  
> -	return sched_now - start_time;
> +	return now - start_time;
>  }
>  
>  static int hst_end_io(struct path_selector *ps, struct dm_path *path,

-- 
Gabriel Krisman Bertazi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

