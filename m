Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E64C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:50:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D52A461954
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D52A461954
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617094225;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9nn+exBdaoVykzUb5wbKOo6KbtUq324hkVp8lEJEoc4=;
	b=JPZZin20O8bHdatfqURjHAFZ2Oz+XdzOMeNEj7e5Go/kjOq+2XuqZRVuvFjcQGBa/6IFp3
	xj4dQycoRs/gD0rzPbNYnR2MXlFlXjK2AYOOHF5IJM+6OmOzoe12CgJpX4vrU7qxxcApSo
	Et9GkoUDV64aFyuBm/ZwwjR127iJU5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-xipkRjXTM46n6zkinPVMRQ-1; Tue, 30 Mar 2021 04:50:23 -0400
X-MC-Unique: xipkRjXTM46n6zkinPVMRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D907A81746D;
	Tue, 30 Mar 2021 08:50:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FB5850441;
	Tue, 30 Mar 2021 08:50:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A2964BB7C;
	Tue, 30 Mar 2021 08:50:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U8oD7B022253 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 04:50:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DF561669F3; Tue, 30 Mar 2021 08:50:13 +0000 (UTC)
Received: from T590 (ovpn-13-69.pek2.redhat.com [10.72.13.69])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E4B754272;
	Tue, 30 Mar 2021 08:49:56 +0000 (UTC)
Date: Tue, 30 Mar 2021 16:49:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YGLmMVAImqorRZup@T590>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-12-ming.lei@redhat.com>
	<162f000f-7f86-8988-4a15-2c3bf70de1b7@suse.de>
	<a213b9b1-992d-3deb-200d-c74eac500747@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <a213b9b1-992d-3deb-200d-c74eac500747@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 11/12] block: add poll_capable method to
 support bio-based IO polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 02:50:51PM +0800, JeffleXu wrote:
>=20
>=20
> On 3/30/21 2:26 PM, Hannes Reinecke wrote:
> > On 3/29/21 5:26 PM, Ming Lei wrote:
> >> From: Jeffle Xu <jefflexu@linux.alibaba.com>
> >>
> >> This method can be used to check if bio-based device supports IO polli=
ng
> >> or not. For mq devices, checking for hw queue in polling mode is
> >> adequate, while the sanity check shall be implementation specific for
> >> bio-based devices. For example, dm device needs to check if all
> >> underlying devices are capable of IO polling.
> >>
> >> Though bio-based device may have done the sanity check during the
> >> device initialization phase, cacheing the result of this sanity check
> >> (such as by cacheing in the queue_flags) may not work. Because for dm
> >> devices, users could change the state of the underlying devices throug=
h
> >> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this cas=
e,
> >> the cached result of the very beginning sanity check could be
> >> out-of-date. Thus the sanity check needs to be done every time 'io_pol=
l'
> >> is to be modified.
> >>
> >> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> ---
> >> =A0 block/blk-sysfs.c=A0=A0=A0=A0=A0 | 14 +++++++++++---
> >> =A0 include/linux/blkdev.h |=A0 1 +
> >> =A0 2 files changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> >> index db3268d41274..c8e7e4af66cb 100644
> >> --- a/block/blk-sysfs.c
> >> +++ b/block/blk-sysfs.c
> >> @@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct
> >> request_queue *q, const char *page,
> >> =A0=A0=A0=A0=A0 unsigned long poll_on;
> >> =A0=A0=A0=A0=A0 ssize_t ret;
> >> =A0 -=A0=A0=A0 if (!q->tag_set || q->tag_set->nr_maps <=3D HCTX_TYPE_P=
OLL ||
> >> -=A0=A0=A0=A0=A0=A0=A0 !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
> >> -=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >> +=A0=A0=A0 if (queue_is_mq(q)) {
> >> +=A0=A0=A0=A0=A0=A0=A0 if (!q->tag_set || q->tag_set->nr_maps <=3D HCT=
X_TYPE_POLL ||
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !q->tag_set->map[HCTX_TYPE_POLL].nr=
_queues)
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >> +=A0=A0=A0 } else {
> >> +=A0=A0=A0=A0=A0=A0=A0 struct gendisk *disk =3D queue_to_disk(q);
> >> +
> >> +=A0=A0=A0=A0=A0=A0=A0 if (!disk->fops->poll_capable ||
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !disk->fops->poll_capable(disk))
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >> +=A0=A0=A0 }
> >> =A0 =A0=A0=A0=A0=A0 ret =3D queue_var_store(&poll_on, page, count);
> >> =A0=A0=A0=A0=A0 if (ret < 0)
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index bfab74b45f15..a46f975f2a2f 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -1881,6 +1881,7 @@ struct block_device_operations {
> >> =A0=A0=A0=A0=A0 int (*report_zones)(struct gendisk *, sector_t sector,
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int nr_zones, report_=
zones_cb cb, void *data);
> >> =A0=A0=A0=A0=A0 char *(*devnode)(struct gendisk *disk, umode_t *mode);
> >> +=A0=A0=A0 bool (*poll_capable)(struct gendisk *disk);
> >> =A0=A0=A0=A0=A0 struct module *owner;
> >> =A0=A0=A0=A0=A0 const struct pr_ops *pr_ops;
> >> =A0 };
> >>
> > I really wonder how this would work for nvme multipath; but I guess it
> > doesn't change the current situation.

It should work for nvme multipath since the approach covers this case,
and bio submitted to underlying NVMe is marked with REQ_HIPRI and
REQ_POLL_CTX too.

>=20
> I wonder, at least, md/dm, which is built upon other devices, or
> 'virtual device' in other words, should be distinguished from other
> 'original' bio-based device (e.g., nvme multipath) then. Maybe one extra
> flag or something.

There is REQ_NVME_MPATH, but not sure we need to deal with that.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

