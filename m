Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87176C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:12:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB43C61A24
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB43C61A24
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-INekoiamN7KdPzdoHmFxMA-1; Fri, 26 Mar 2021 13:12:50 -0400
X-MC-Unique: INekoiamN7KdPzdoHmFxMA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E3A11005D54;
	Fri, 26 Mar 2021 17:12:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 359AD5DDAD;
	Fri, 26 Mar 2021 17:12:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FB821809C83;
	Fri, 26 Mar 2021 17:12:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QHCZYo006445 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 13:12:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63DA72026D11; Fri, 26 Mar 2021 17:12:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F6602026D65
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:12:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1422800C5B
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:12:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-368-r-hUPkmVPsiCdnBrkgd1sQ-1;
	Fri, 26 Mar 2021 13:12:24 -0400
X-MC-Unique: r-hUPkmVPsiCdnBrkgd1sQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id AF578AD8D;
	Fri, 26 Mar 2021 17:12:22 +0000 (UTC)
Message-ID: <3ea650fd67ddea9a4145985e687dcff29134a37c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.com>
Date: Fri, 26 Mar 2021 18:12:21 +0100
In-Reply-To: <20210325151407.GA17059@redhat.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
	<20210322081155.GE1946905@infradead.org>
	<20210322142207.GB30698@redhat.com>
	<cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
	<20210325151407.GA17059@redhat.com>
User-Agent: Evolution 3.38.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QHCZYo006445
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>, Christoph Hellwig <hch@infradead.org>,
	linux-scsi@vger.kernel.org,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
	dm-devel@redhat.com, agk@redhat.com, "wubo \(T\)" <wubo40@huawei.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 11:14 -0400, Mike Snitzer wrote:
> On Wed, Mar 24 2021 at=A0 9:21pm -0400,
> Zhiqiang Liu <liuzhiqiang26@huawei.com> wrote:
>=20
> >=20
> >=20
> > On 2021/3/22 22:22, Mike Snitzer wrote:
> > > On Mon, Mar 22 2021 at=A0 4:11am -0400,
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > >=20
> > > > On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> > > > > From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > >=20
> > > > > When we make IO stress test on multipath device, there will
> > > > > be a metadata err because of wrong path. In the test, we
> > > > > concurrent execute 'iscsi device login|logout' and
> > > > > 'multipath -r' command with IO stress on multipath device.
> > > > > In some case, systemd-udevd may have not time to process
> > > > > uevents of iscsi device logout|login, and then 'multipath -r'
> > > > > command triggers multipathd daemon calls ioctl to load table
> > > > > with incorrect old device info from systemd-udevd.
> > > > > Then, one iscsi path may be incorrectly attached to another
> > > > > multipath which has different uuid. Finally, the metadata err
> > > > > occurs when umounting filesystem to down write metadata on
> > > > > the iscsi device which is actually not owned by the multipath
> > > > > device.
> > > > >=20
> > > > > So we need to check whether all pgpaths of one multipath have
> > > > > the same uuid, if not, we should throw a error.
> > > > >=20
> > > > > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > > > > Signed-off-by: linfeilong <linfeilong@huawei.com>
> > > > > Signed-off-by: Wubo <wubo40@huawei.com>
> > > > > ---
> > > > > =A0drivers/md/dm-mpath.c=A0=A0 | 52
> > > > > +++++++++++++++++++++++++++++++++++++++++
> > > > > =A0drivers/scsi/scsi_lib.c |=A0 1 +
> > > > > =A02 files changed, 53 insertions(+)
> > > > >=20
> > > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > > index bced42f082b0..f0b995784b53 100644
> > > > > --- a/drivers/md/dm-mpath.c
> > > > > +++ b/drivers/md/dm-mpath.c
> > > > > @@ -24,6 +24,7 @@
> > > > > =A0#include <linux/workqueue.h>
> > > > > =A0#include <linux/delay.h>
> > > > > =A0#include <scsi/scsi_dh.h>
> > > > > +#include <linux/dm-ioctl.h>
> > > > > =A0#include <linux/atomic.h>
> > > > > =A0#include <linux/blk-mq.h>
> > > > >=20
> > > > > @@ -1169,6 +1170,45 @@ static int parse_features(struct
> > > > > dm_arg_set *as, struct multipath *m)
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0return r;
> > > > > =A0}
> > > > >=20
> > > > > +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> > > > > +#define MPATH_UUID_PREFIX_LEN 7
> > > > > +static int check_pg_uuid(struct priority_group *pg, char
> > > > > *md_uuid)
> > > > > +{
> > > > > +=A0=A0=A0=A0=A0=A0=A0char pgpath_uuid[DM_UUID_LEN] =3D {0};
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct request_queue *q;
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct pgpath *pgpath;
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct scsi_device *sdev;
> > > > > +=A0=A0=A0=A0=A0=A0=A0ssize_t count;
> > > > > +=A0=A0=A0=A0=A0=A0=A0int r =3D 0;
> > > > > +
> > > > > +=A0=A0=A0=A0=A0=A0=A0list_for_each_entry(pgpath, &pg->pgpaths, l=
ist) {
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0q =3D bdev_get_queu=
e(pgpath->path.dev->bdev);
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sdev =3D scsi_devic=
e_from_queue(q);
> > > >=20
> > > > Common dm-multipath code should never poke into scsi
> > > > internals.=A0 This
> > > > is something for the device handler to check.=A0 It probably also
> > > > won't
> > > > work for all older devices.
> > >=20
> > > Definitely.
> > >=20
> > > But that aside, userspace (multipathd) _should_ be able to do
> > > extra
> > > validation, _before_ pushing down a new table to the kernel,
> > > rather than
> > > forcing the kernel to do it.
> >=20
> > As your said, it is better to do extra validation in userspace
> > (multipathd).
> > However, in some cases, the userspace cannot see the real-time
> > present devices
> > info as Martin (committer of multipath-tools) said.
> > In addition, the kernel can see right device info in the table at
> > any time,
> > so the uuid check in kernel can ensure one multipath is composed
> > with paths mapped to
> > the same device.
> >=20
> > Considering the severity of the wrong path in multipath, I think it
> > worths more
> > checking.
>=20
> As already said: this should be fixable in userspace.=A0 Please work
> with
> multipath-tools developers to address this.

I agree this patch won't help, because the kernel doesn't (re)attach
devices to multipath maps by itself. If multipathd actively adds a
device to a map, it must check the WWID beforehand, and so it does (and
has been doing so for years).

But in general, it's hard to avoid WWID mismatches entirely in user
space. We have no problem if a device is removed an re-added. But if it
looks like a device just having been offline or unreachable for some
time and then reappear, it gets tricky. We might even miss the fact
that the device was temporarily away. multipathd can't constantly poll
devices just to detect changes - and what if the sysfs vpd attributes
stay the same because the kernel didn't even notice?

It would be great if userspace could rely on the kernel to deliver
events in such cases. I want look into monitoring SCSI UNIT ATTENTION
events, which multipathd currently doesn't. That might cover many
situations. But I've been told that in some situations really no event
arrived in user space, and I'm not sure if that was a fault of the
storage involved (no UNIT ATTENTION sent) or something else.

Another possibility would be that the kernel used sysfs_notify() for
the inquiry or vpd_pgXY attributes for SCSI (and similar attirbutes for
other device types).

Regards
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

