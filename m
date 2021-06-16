Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABECC48BE6
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 09:57:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9A28460FF1
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 09:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A28460FF1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-zikRy8hhNyimzc6xemcCKw-1; Wed, 16 Jun 2021 05:57:00 -0400
X-MC-Unique: zikRy8hhNyimzc6xemcCKw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B829719253C3;
	Wed, 16 Jun 2021 09:56:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72A8518A69;
	Wed, 16 Jun 2021 09:56:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 336D61809CAD;
	Wed, 16 Jun 2021 09:56:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15G9uDYc012896 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 05:56:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E60C2103CDA; Wed, 16 Jun 2021 09:56:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFEC6104823
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 09:56:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7733818E0921
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 09:56:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-tU3wMmh5PJe4oMnj8J8I_Q-1; Wed, 16 Jun 2021 05:56:06 -0400
X-MC-Unique: tU3wMmh5PJe4oMnj8J8I_Q-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D9CF1FD49;
	Wed, 16 Jun 2021 09:56:04 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 4477D118DD;
	Wed, 16 Jun 2021 09:56:04 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id OUUzD7TKyWDUOwAALh3uQQ
	(envelope-from <mwilck@suse.com>); Wed, 16 Jun 2021 09:56:04 +0000
Message-ID: <d0f55a18ddb925d9e5f9f8e5f9e5b857144fcd96.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche
	<bart.vanassche@sandisk.com>
Date: Wed, 16 Jun 2021 11:56:03 +0200
In-Reply-To: <YMjfGh9hJjLkol9V@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
	<20210611202509.5426-3-mwilck@suse.com> <YMjfGh9hJjLkol9V@redhat.com>
User-Agent: Evolution 3.40.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15G9uDYc012896
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO -
 failover for SG_IO on dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Di, 2021-06-15 at 13:10 -0400, Mike Snitzer wrote:
> On Fri, Jun 11 2021 at=A0 4:25P -0400,
> mwilck@suse.com=A0<mwilck@suse.com> wrote:
>=20
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > In virtual deployments, SCSI passthrough over dm-multipath devices is
> > a
> > common setup. The qemu "pr-helper" was specifically invented for it.
> > I
> > believe that this is the most important real-world scenario for
> > sending
> > SG_IO ioctls to device-mapper devices.
> >=20
> > In this configuration, guests send SCSI IO to the hypervisor in the
> > form of
> > SG_IO ioctls issued by qemu. But on the device-mapper level, these
> > SCSI
> > ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm
> > mpath:
> > switch paths in dm_blk_ioctl() code path"), no path switching was
> > done at
> > all. Worse though, if an SG_IO call fails because of a path error,
> > dm-multipath doesn't retry the IO on a another path; rather, the
> > failure is
> > passed back to the guest, and paths are not marked as faulty.=A0 This
> > is in
> > stark contrast with regular block IO of guests on dm-multipath
> > devices, and
> > certainly comes as a surprise to users who switch to SCSI passthrough
> > in
> > qemu. In general, users of dm-multipath devices would probably expect
> > failover
> > to work at least in a basic way.
> >=20
> > This patch fixes this by taking a special code path for SG_IO on
> > request-
> > based device mapper targets if CONFIG_DM_MULTIPATH_SG_IO is set.=A0
> > Rather then
> > just choosing a single path, sending the IO to it, and failing to the
> > caller
> > if the IO on the path failed, it retries the same IO on another path
> > for
> > certain error codes, using blk_path_error() to determine if a retry
> > would
> > make sense for the given error code. Moreover, it sends a message to
> > the
> > multipath target to mark the path as failed.
> >=20
> > One problem remains open: if all paths in a multipath map are failed,
> > normal multipath IO may switch to queueing mode (depending on
> > configuration). This isn't possible for SG_IO, as SG_IO requests
> > can't
> > easily be queued like regular block I/O. Thus in the "no path" case,
> > the
> > guest will still see an error.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0block/scsi_ioctl.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 5 +-
> > =A0drivers/md/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 11 ++++
> > =A0drivers/md/Makefile=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 ++
> > =A0drivers/md/dm-core.h=A0=A0=A0=A0=A0=A0 |=A0=A0 5 ++
> > =A0drivers/md/dm-rq.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 11 ++++
> > =A0drivers/md/dm-scsi_ioctl.c | 127
> > +++++++++++++++++++++++++++++++++++++
> > =A0drivers/md/dm.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 20 +++++-
> > =A0include/linux/blkdev.h=A0=A0=A0=A0 |=A0=A0 2 +
> > =A08 files changed, 180 insertions(+), 5 deletions(-)
> > =A0create mode 100644 drivers/md/dm-scsi_ioctl.c
> >=20
> > diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> > index b39e0835600f..38771f4bcf18 100644
> > --- a/block/scsi_ioctl.c
> > +++ b/block/scsi_ioctl.c
> > @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request
> > *rq, struct sg_io_hdr *hdr,
> > =A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > =A0}
> > =A0
> > -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct sg_io_hdr *hdr, fm=
ode_t mode)
> > +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> > +=A0=A0=A0=A0=A0=A0=A0=A0 struct sg_io_hdr *hdr, fmode_t mode)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned long start_time;
> > =A0=A0=A0=A0=A0=A0=A0=A0ssize_t ret =3D 0;
> > @@ -365,6 +365,7 @@ static int sg_io(struct request_queue *q, struct
> > gendisk *bd_disk,
> > =A0=A0=A0=A0=A0=A0=A0=A0blk_put_request(rq);
> > =A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > =A0}
> > +EXPORT_SYMBOL_GPL(sg_io);
> > =A0
> > =A0/**
> > =A0 * sg_scsi_ioctl=A0 --=A0 handle deprecated SCSI_IOCTL_SEND_COMMAND
> > ioctl
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index f2014385d48b..f28f29e3bd11 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -473,6 +473,17 @@ config DM_MULTIPATH_IOA
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 If unsure, say N.
> > =A0
> > +config DM_MULTIPATH_SG_IO
> > +=A0=A0=A0=A0=A0=A0 bool "Retry SCSI generic I/O on multipath devices"
> > +=A0=A0=A0=A0=A0=A0 depends on DM_MULTIPATH && BLK_SCSI_REQUEST
> > +=A0=A0=A0=A0=A0=A0 help
> > +=A0=A0=A0=A0=A0=A0=A0 With this option, SCSI generic (SG) requests iss=
ued on
> > multipath
> > +=A0=A0=A0=A0=A0=A0=A0 devices will behave similar to regular block I/O=
: upon
> > failure,
> > +=A0=A0=A0=A0=A0=A0=A0 they are repeated on a different path, and the e=
rroring
> > device
> > +=A0=A0=A0=A0=A0=A0=A0 is marked as failed.
> > +
> > +=A0=A0=A0=A0=A0=A0=A0 If unsure, say N.
> > +
>=20
> Given how this is all about multipath, there is no reason to bolt this
> on to DM core and then play games to issuing multipath target specific
> DM message ("fail_path") from generic code.
>=20
> So the SG_IO ioctl handling code should be in dm-mpath.c and the DM
> target interface extended as needed.

Ok.


>=20
> > =A0config DM_DELAY
> > =A0=A0=A0=A0=A0=A0=A0=A0tristate "I/O delaying target"
> > =A0=A0=A0=A0=A0=A0=A0=A0depends on BLK_DEV_DM
> > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > index ef7ddc27685c..187ea469f64a 100644
> > --- a/drivers/md/Makefile
> > +++ b/drivers/md/Makefile
> > @@ -88,6 +88,10 @@ ifeq ($(CONFIG_DM_INIT),y)
> > =A0dm-mod-objs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0+=3D dm-init.o
> > =A0endif
> > =A0
> > +ifeq ($(CONFIG_DM_MULTIPATH_SG_IO),y)
> > +dm-mod-objs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0+=3D dm-scsi_ioctl.o
> > +endif
> > +
> > =A0ifeq ($(CONFIG_DM_UEVENT),y)
> > =A0dm-mod-objs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0+=3D dm-uevent.o
> > =A0endif
> > diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> > index 5953ff2bd260..8bd8a8e3916e 100644
> > --- a/drivers/md/dm-core.h
> > +++ b/drivers/md/dm-core.h
> > @@ -189,4 +189,9 @@ extern atomic_t dm_global_event_nr;
> > =A0extern wait_queue_head_t dm_global_eventq;
> > =A0void dm_issue_global_event(void);
> > =A0
> > +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct=
 block_device **bdev,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct=
 dm_target **target);
> > +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx);
> > +
> > =A0#endif
> > diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> > index 1eea0da641db..c6d2853e4d1d 100644
> > --- a/drivers/md/dm-rq.h
> > +++ b/drivers/md/dm-rq.h
> > @@ -44,4 +44,15 @@ ssize_t
> > dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md,
> > ch
> > =A0ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct
> > mapped_device *md,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 const char *buf,
> > size_t count);
> > =A0
> > +#ifdef CONFIG_DM_MULTIPATH_SG_IO
> > +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int cmd, =
unsigned long uarg);
> > +#else
> > +static inline int dm_sg_io_ioctl(struct block_device *bdev, fmode_t
> > mode,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int cmd, unsigned long
> > uarg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return -ENOTTY;
> > +}
> > +#endif
> > +
> > =A0#endif
>=20
> There is no reason, that I can see, why bio-based dm-multipath
> shouldn't handle SG_IO too.=A0 Why did you constrain it to
> request-based?

I couldn't figure out a better way to check if the target in question
was multipath (in my experience, multipath is practically always
request based). With your suggestions below, I'll be able to get rid of
this admittedly odd logic. Thanks.


I'm not sure about SG_IO on bio-based dm-multipath. My feeling was that
it wouldn't work, but I haven't tried or analyzed it in detail.

>=20
> > diff --git a/drivers/md/dm-scsi_ioctl.c b/drivers/md/dm-scsi_ioctl.c
> > new file mode 100644
> > index 000000000000..a696e2a6557e
> > --- /dev/null
> > +++ b/drivers/md/dm-scsi_ioctl.c
> > @@ -0,0 +1,127 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2021 Martin Wilck, SUSE LLC
> > + */
> > +
> > +#include "dm-core.h"
> > +#include <linux/types.h>
> > +#include <linux/errno.h>
> > +#include <linux/kernel.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/blk_types.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/device-mapper.h>
> > +#include <scsi/sg.h>
> > +#include <scsi/scsi_cmnd.h>
> > +
> > +#define DM_MSG_PREFIX "sg_io"
> > +
> > +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int cmd, =
unsigned long uarg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct mapped_device *md =3D bdev->bd_disk->priva=
te_data;
> > +=A0=A0=A0=A0=A0=A0=A0struct sg_io_hdr hdr;
> > +=A0=A0=A0=A0=A0=A0=A0void __user *arg =3D (void __user *)uarg;
> > +=A0=A0=A0=A0=A0=A0=A0int rc, srcu_idx;
> > +=A0=A0=A0=A0=A0=A0=A0char path_name[BDEVNAME_SIZE];
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (cmd !=3D SG_IO)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOTTY;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (copy_from_user(&hdr, arg, sizeof(hdr)))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EFAULT;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (hdr.interface_id !=3D 'S')
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->b=
d_disk-
> > >queue) << 9))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EIO;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0for (;;) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct dm_target *tgt;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct sg_io_hdr rhdr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D __dm_prepare_ioctl=
(md, &srcu_idx, &bdev, &tgt);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rc < 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0D=
MERR("%s: failed to get path: %d",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 __func__, rc);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rhdr =3D hdr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D sg_io(bdev->bd_dis=
k->queue, bdev->bd_disk,
> > &rhdr, mode);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0DMDEBUG("SG_IO via %s: rc=
 =3D %d D%02xH%02xM%02xS%02x",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
devname(bdev, path_name), rc,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
hdr.driver_status, rhdr.host_status,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
hdr.msg_status, rhdr.status);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Errors resulting from =
invalid parameters shouldn't
> > be retried
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * on another path.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch (rc) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case -ENOIOCTLCMD:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case -EFAULT:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case -EINVAL:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case -EPERM:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0default:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rhdr.info & SG_INFO_C=
HECK) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
nt result;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
lk_status_t sts;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
esult =3D rhdr.status |
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(rhdr.msg_status << 8) |
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(rhdr.host_status << 16) |
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(rhdr.driver_status << 24);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
ts =3D __scsi_result_to_blk_status(&result,
> > result);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
hdr.host_status =3D host_byte(result);
>=20
> It is the open-coded SCSI specific sg_io_hdr and result work that
> feels like it doesn't belong open-coded in DM.=A0 So maybe the above
> code from this SG_INFO_CHECK block could go into an
> block/scsi_ioctl.c:sg_io_info_check() method?

Ok. I'll see if I can shape this code in a way that addresses both your
concerns and Bart's.

> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* See if this is a target or path error. */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (sts =3D=3D BLK_STS_OK)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse if (blk_path_error(sts))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -EIO;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D blk_status_to_errno(sts);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* success */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (copy_to_user(arg, &rhdr, sizeof(rhdr)))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -EFAULT;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Failure - fail path by=
 sending a message to the
> > target */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!tgt->type->message) =
{
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0D=
MWARN("invalid target!");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
c =3D -EIO;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
har bdbuf[BDEVT_SIZE];
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
har *argv[2] =3D { "fail_path", bdbuf };
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
cnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 MAJOR(bdev->bd_dev), MINOR(bdev-
> > >bd_dev));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0D=
MDEBUG("sending \"%s %s\" to target",
> > argv[0], argv[1]);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
c =3D tgt->type->message(tgt, 2, argv, NULL,
> > 0);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (rc < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> If you factor things how I suggest below (introducing
> dm-mpath.c:dm_mpath_ioctl) then you'll have direct access to
> dm-mpath.c:fail_path() so need need to mess around with constructing
> DM messages from kernel code.

Sure.

>=20
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_unprepare_ioctl(md, sr=
cu_idx);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +out:
> > +=A0=A0=A0=A0=A0=A0=A0dm_unprepare_ioctl(md, srcu_idx);
> > +=A0=A0=A0=A0=A0=A0=A0return rc;
> > +}
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index ca2aedd8ee7d..29b93fb3929e 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -522,8 +522,9 @@ static int dm_blk_report_zones(struct gendisk
> > *disk, sector_t sector,
> > =A0#define dm_blk_report_zones=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0NULL
> > =A0#endif /* CONFIG_BLK_DEV_ZONED */
> > =A0
> > -static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 struct block_device **bdev)
> > +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct=
 block_device **bdev,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct=
 dm_target **target)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct dm_target *tgt;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct dm_table *map;
> > @@ -553,10 +554,19 @@ static int dm_prepare_ioctl(struct
> > mapped_device *md, int *srcu_idx,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto retry;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (r >=3D 0 && target)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*target =3D tgt;
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0return r;
> > =A0}
>=20
> For dm-multipath you can leverage md->immutable_target always being
> multipath.

Ok, this was what I'd been missing. Can I trust that this will hold in
the future?

>=20
> So after dm_blk_ioctl's dm_prepare_ioctl:=20
>=20
> if (cmd =3D=3D SG_IO && md->immutable_target &&
> =A0=A0=A0 md->immutable_target->ioctl)
> =A0=A0=A0 r =3D md->immutable_target->ioctl(bdev, mode, cmd, arg);
>=20
> (doing check for SG_IO here just avoids needless call into ->ioctl for
> now, but it could be other ioctls will need specialization in future
> so checking 'cmd' should be pushed down to md->immutable_target->ioctl
> at that time?)
>=20
> But I'm not following you use of a for (;;) in dm_sg_io_ioctl() --
> other than to retry infinitely (you aren't checking for no paths!?,
> etc).

multipath's prepare_ioctl() method returns an error if no path could be
found, in which case I break the loop.


>=20
> Anyway, best to have md->immutable_target->ioctl return
> -EAGAIN and goto top of dm_blk_ioctl as needed?

That would be similar to Hannes' suggestion.

>=20
> > =A0
> > -static void dm_unprepare_ioctl(struct mapped_device *md, int
> > srcu_idx)
> > +static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 struct block_device **bdev)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return __dm_prepare_ioctl(md, srcu_idx, bdev, NUL=
L);
> > +}
> > +
> > +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0dm_put_live_table(md, srcu_idx);
> > =A0}
> > @@ -567,6 +577,10 @@ static int dm_blk_ioctl(struct block_device
> > *bdev, fmode_t mode,
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mapped_device *md =3D bdev->bd_disk->pri=
vate_data;
> > =A0=A0=A0=A0=A0=A0=A0=A0int r, srcu_idx;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if ((dm_get_md_type(md) =3D=3D DM_TYPE_REQUEST_BA=
SED) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((r =3D dm_sg_io_ioctl(bdev, mode, cmd,=
 arg)) !=3D -ENOTTY))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return r;
> > +
>=20
> Again, bio-based multipath should work fine with SG_IO too.
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_prepare_ioctl(md, &srcu_idx, &bdev);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (r < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 48497a77428d..b8f1d603cc7a 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -923,6 +923,8 @@ extern int scsi_cmd_ioctl(struct request_queue *,
> > struct gendisk *, fmode_t,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 unsigned int, void __user *);
> > =A0extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *,
> > fmode_t,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct scsi_ioctl_command __user *);
> > +extern int sg_io(struct request_queue *, struct gendisk *,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct sg_io_hdr *, fmod=
e_t);
> > =A0extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user
> > *argp);
> > =A0extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user
> > *argp);
> > =A0
> > --=20
> > 2.31.1
> >=20
>=20
> Think adding block/scsi_ioctl.c:sg_io_info_check() and exporting it
> and sg_io() via blkdev.h should be done as a separate patch 2.
>=20
> Then patch 3 is purely DM changes to use sg_io() and
> sg_io_info_check()

Thanks a lot for the detailed review. I think this should get me
forward.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

