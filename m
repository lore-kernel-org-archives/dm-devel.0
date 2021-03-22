Return-Path: <SRS0=txDK=IU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3558C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:23:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B78A6197F
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:23:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B78A6197F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616423006;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zmzu/C0uzMSO0pOPRqdIKTW/YeTMdbyUgm52JJBz5yg=;
	b=aF7sDQPXWhqPReyckszc64mb9sVJ5PMZBd5I98RpvRp0BHxbCAON+FPPyo/JL+ja/athk1
	gPTRSQMRUIJwGrTYWX8DrPxWFx3H4+x6k85U2WF39DPGXwnuF7tyQuTgh3fHP74YCykU1k
	PN7yLHkRPvRcVw0mZTBVc6Bm/z0N49k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-P0hARX5YN4uFMnP6ysMZwg-1; Mon, 22 Mar 2021 10:23:23 -0400
X-MC-Unique: P0hARX5YN4uFMnP6ysMZwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22E1E881287;
	Mon, 22 Mar 2021 14:23:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB2F01007606;
	Mon, 22 Mar 2021 14:23:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E449F4A7C8;
	Mon, 22 Mar 2021 14:23:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12MEMBMJ031307 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Mar 2021 10:22:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EE3C65C1A3; Mon, 22 Mar 2021 14:22:11 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67B613697;
	Mon, 22 Mar 2021 14:22:08 +0000 (UTC)
Date: Mon, 22 Mar 2021 10:22:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
	Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <20210322142207.GB30698@redhat.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
	<20210322081155.GE1946905@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210322081155.GE1946905@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>, "wubo \(T\)" <wubo40@huawei.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
	dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] md/dm-mpath: check whether all pgpaths have same
 uuid in multipath_ctr()
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

On Mon, Mar 22 2021 at  4:11am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> > From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > 
> > When we make IO stress test on multipath device, there will
> > be a metadata err because of wrong path. In the test, we
> > concurrent execute 'iscsi device login|logout' and
> > 'multipath -r' command with IO stress on multipath device.
> > In some case, systemd-udevd may have not time to process
> > uevents of iscsi device logout|login, and then 'multipath -r'
> > command triggers multipathd daemon calls ioctl to load table
> > with incorrect old device info from systemd-udevd.
> > Then, one iscsi path may be incorrectly attached to another
> > multipath which has different uuid. Finally, the metadata err
> > occurs when umounting filesystem to down write metadata on
> > the iscsi device which is actually not owned by the multipath
> > device.
> > 
> > So we need to check whether all pgpaths of one multipath have
> > the same uuid, if not, we should throw a error.
> > 
> > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > Signed-off-by: linfeilong <linfeilong@huawei.com>
> > Signed-off-by: Wubo <wubo40@huawei.com>
> > ---
> >  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/scsi_lib.c |  1 +
> >  2 files changed, 53 insertions(+)
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index bced42f082b0..f0b995784b53 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/workqueue.h>
> >  #include <linux/delay.h>
> >  #include <scsi/scsi_dh.h>
> > +#include <linux/dm-ioctl.h>
> >  #include <linux/atomic.h>
> >  #include <linux/blk-mq.h>
> > 
> > @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> >  	return r;
> >  }
> > 
> > +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> > +#define MPATH_UUID_PREFIX_LEN 7
> > +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
> > +{
> > +	char pgpath_uuid[DM_UUID_LEN] = {0};
> > +	struct request_queue *q;
> > +	struct pgpath *pgpath;
> > +	struct scsi_device *sdev;
> > +	ssize_t count;
> > +	int r = 0;
> > +
> > +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
> > +		q = bdev_get_queue(pgpath->path.dev->bdev);
> > +		sdev = scsi_device_from_queue(q);
> 
> Common dm-multipath code should never poke into scsi internals.  This
> is something for the device handler to check.  It probably also won't
> work for all older devices.

Definitely.

But that aside, userspace (multipathd) _should_ be able to do extra
validation, _before_ pushing down a new table to the kernel, rather than
forcing the kernel to do it.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

