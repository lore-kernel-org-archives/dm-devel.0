Return-Path: <SRS0=txDK=IU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D338C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 08:38:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 000C261919
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 08:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 000C261919
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-NEA0uQ-ZNOWG6AHTSaawJw-1; Mon, 22 Mar 2021 04:38:45 -0400
X-MC-Unique: NEA0uQ-ZNOWG6AHTSaawJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D883801817;
	Mon, 22 Mar 2021 08:38:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0EBE10023B2;
	Mon, 22 Mar 2021 08:38:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 78DF41809C81;
	Mon, 22 Mar 2021 08:38:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12M8cXDg022285 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Mar 2021 04:38:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 951A02026D6B; Mon, 22 Mar 2021 08:38:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B5402026D7F
	for <dm-devel@redhat.com>; Mon, 22 Mar 2021 08:38:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A52810334AF
	for <dm-devel@redhat.com>; Mon, 22 Mar 2021 08:38:31 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-548-WdlY1LEYO52z1_Kk1ci5SA-1; Mon, 22 Mar 2021 04:38:29 -0400
X-MC-Unique: WdlY1LEYO52z1_Kk1ci5SA-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lOFfH-008Btj-KA; Mon, 22 Mar 2021 08:12:09 +0000
Date: Mon, 22 Mar 2021 08:11:55 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <20210322081155.GE1946905@infradead.org>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
MIME-Version: 1.0
In-Reply-To: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>, "wubo \(T\)" <wubo40@huawei.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	snitzer@redhat.com, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
	dm-devel@redhat.com, linux-scsi@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] md/dm-mpath: check whether all pgpaths have
 same uuid in multipath_ctr()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> When we make IO stress test on multipath device, there will
> be a metadata err because of wrong path. In the test, we
> concurrent execute 'iscsi device login|logout' and
> 'multipath -r' command with IO stress on multipath device.
> In some case, systemd-udevd may have not time to process
> uevents of iscsi device logout|login, and then 'multipath -r'
> command triggers multipathd daemon calls ioctl to load table
> with incorrect old device info from systemd-udevd.
> Then, one iscsi path may be incorrectly attached to another
> multipath which has different uuid. Finally, the metadata err
> occurs when umounting filesystem to down write metadata on
> the iscsi device which is actually not owned by the multipath
> device.
> 
> So we need to check whether all pgpaths of one multipath have
> the same uuid, if not, we should throw a error.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: linfeilong <linfeilong@huawei.com>
> Signed-off-by: Wubo <wubo40@huawei.com>
> ---
>  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c |  1 +
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index bced42f082b0..f0b995784b53 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -24,6 +24,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/delay.h>
>  #include <scsi/scsi_dh.h>
> +#include <linux/dm-ioctl.h>
>  #include <linux/atomic.h>
>  #include <linux/blk-mq.h>
> 
> @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>  	return r;
>  }
> 
> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> +#define MPATH_UUID_PREFIX_LEN 7
> +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
> +{
> +	char pgpath_uuid[DM_UUID_LEN] = {0};
> +	struct request_queue *q;
> +	struct pgpath *pgpath;
> +	struct scsi_device *sdev;
> +	ssize_t count;
> +	int r = 0;
> +
> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
> +		q = bdev_get_queue(pgpath->path.dev->bdev);
> +		sdev = scsi_device_from_queue(q);

Common dm-multipath code should never poke into scsi internals.  This
is something for the device handler to check.  It probably also won't
work for all older devices.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

