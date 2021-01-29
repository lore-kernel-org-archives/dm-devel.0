Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CB8C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 01:53:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A076D64DFD
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 01:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A076D64DFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-l0OdOgSWObCdt1HeHA1mgQ-1; Thu, 28 Jan 2021 20:52:59 -0500
X-MC-Unique: l0OdOgSWObCdt1HeHA1mgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0722259;
	Fri, 29 Jan 2021 01:52:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13F3B10023AB;
	Fri, 29 Jan 2021 01:52:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD3FD1809C9F;
	Fri, 29 Jan 2021 01:52:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10T1kNge014216 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 20:46:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9689C10D16B6; Fri, 29 Jan 2021 01:46:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 905EC11701CB
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 01:46:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D164800B3A
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 01:46:21 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-371-t812gyy5P12Ul3EGk9jYEQ-1; Thu, 28 Jan 2021 20:46:16 -0500
X-MC-Unique: t812gyy5P12Ul3EGk9jYEQ-1
IronPort-SDR: m8gQ32k+VgyFmAkzh1UOeWXZthpPLCKBijq/uJDdVsLZ8NQq+uQet9tLb5W4pjyd3IvknZgFE0
	uQu6XOp3ohkAY5Z+O9nxRktlG7JnH/brtkczeJA6jqNSDS76FdhcVpQREiEwZatvVYi6uzAqe9
	2D2EZNkR5Ek1/ozGT4jm9ee2ywusI6ttfWyMmjh5Qfsx/jBCQAfGXSbMAFoMS6yVsVN3hjXDcX
	HlI0T0hEAgKBcDPPHJ9qrhVvC9MFB2ZMVFLSCMUF5oeu9ELALTvJkWHdCNKGsAh2pfb6qh91nZ
	rzE=
X-IronPort-AV: E=Sophos;i="5.79,384,1602518400"; d="scan'208";a="159773025"
Received: from mail-sn1nam02lp2054.outbound.protection.outlook.com (HELO
	NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.54])
	by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2021 09:46:15 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6445.namprd04.prod.outlook.com (2603:10b6:208:1a2::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Fri, 29 Jan 2021 01:46:11 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Fri, 29 Jan 2021 01:46:11 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>, "hare@suse.de" <hare@suse.de>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>, "agk@redhat.com"
	<agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Thread-Topic: [dm-devel] [PATCH 2/2] [dm] blk_interposer for dm-linear
Thread-Index: AQHW9ZpW4Iaa29J5rk6ywazmgLTyFQ==
Date: Fri, 29 Jan 2021 01:46:11 +0000
Message-ID: <BL0PR04MB65142B7F22234EFC710148C8E7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<1611853955-32167-3-git-send-email-sergei.shtepa@veeam.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a2e3377-137a-4885-39aa-08d8c3f7a821
x-ms-traffictypediagnostic: MN2PR04MB6445:
x-microsoft-antispam-prvs: <MN2PR04MB64452D63B9E966B86D26E6E4E7B99@MN2PR04MB6445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: sW9hN7Bbuy/spxTOjC52j34HjKzLz4ZVnxv6myIRsPgQzsm2WF6KHzDMZi6xvTv2Py17lFgwXSzkIc6urKighitXRk5dfcgZkjNfxXdn51roXupZTe028Te/faXb9Y0N4SW/E2okqnZ4UHjzmvmJ64cgrUTJjTZvPAPyBT4i7p5cxEKpXdqm5g68NW2VAG+qmodJD9+sQ+MrXDbZtni60JU5AOOwlQSE2OVVBcSCGtYCai8dUxy9cMcF1ztZhIUltvJ+23Dh8sWpUjyJnkD9qLB5XLN1dExhDUU+ac0dcuL4W7RtnrkQeRmN6bLiaOyCzHoH626WKgfRUG1qRAGHodojpISpXOnI1tzSpv4nbRrGY113Nemv5WVkGSmjcOHLWwbuLaevBcIN7hOFmTtqZElaeaLxpJ0fEFG16Tv40K6dYQHnQK3J9sjAUQJi/qFD6LaRQn7FBKvsNwGQs3+Rv2JKflTaQV+WsTDFRs0L6z1195rLtFCi8RU8tHnL39V9rPmT7f3913PdgyE6H7rcfQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(4326008)(71200400001)(2906002)(7696005)(110136005)(9686003)(83380400001)(55016002)(478600001)(66446008)(8676002)(64756008)(66476007)(66946007)(66556008)(76116006)(8936002)(5660300002)(53546011)(52536014)(4001150100001)(30864003)(91956017)(33656002)(6506007)(186003)(86362001)(316002)(579004)(559001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aGV/JDoIM3MY6bIjAxMAL1CqzfqNyTwAq5hS39uVjNGvL2lczYHILy/PiV3u?=
	=?us-ascii?Q?DrSndyfEMeQeqLd+06BVAlaiaTQy5lgqFkmFXZ290dgP+tCKjgkn1BKFyCkN?=
	=?us-ascii?Q?8mMkXuu9/tdasDgVSwSivjvgStK2FO8NXm13S9obc6sIvcZdbqfkAUcLj//Z?=
	=?us-ascii?Q?MM1LD7B40ZdsZUMXODmBy+mahgMQBiOH977EdZXPvqYdZwZ4Dm15SUCkZjtx?=
	=?us-ascii?Q?df84sOK1rFJD/GxSiOWTrQWR4NyaWlWgzPDZVrDXJGRJfLCHYz97D1RkMzAo?=
	=?us-ascii?Q?ao6CRxlwmEYVVg3xLntCGyZ7zPwGb7r1PLdD4KvoTZJLz4fJ7J3+aepYpaKR?=
	=?us-ascii?Q?z5cTzxj2OfmzNUAtnI2Zb6EOdxSm05DeK+6jBZFTVdqtwt0AqrQRce2IPcgi?=
	=?us-ascii?Q?eCrLyua/FwzEsw+RjCuZjDXmw2H9jI8CC9KSvwooPotNLzRZXjMQlAcCggyr?=
	=?us-ascii?Q?T9c31zKPjhZ3MFCXo6zs2vhgbp6M/gMfIc2AG6fweCNl8YCPvU+lcqQZ82sD?=
	=?us-ascii?Q?Ad3swAtbOe4/V0OdLpoX+jNJswdaB/8GNqwVRNubE5F2z/IMNrckYsiHMGLt?=
	=?us-ascii?Q?n8TJvgKlFDjpQsR59F8YAAGr4DxGpjn9FyWWLM9Fuybg6kmweqhrNGeDNdRy?=
	=?us-ascii?Q?a/xcDRMyFXXg9PMiwGwTZTtbUTF7bQ0VAADEcWYZb8H10Wfk6XBGct1BC4Bo?=
	=?us-ascii?Q?YT2FmWGX0G/JKQZyoUbP9PZ85NIek6idvk76/p5No/+/H7PH4ZHWFcPUcZxP?=
	=?us-ascii?Q?gFbnAjKLjE3O7qW2PCESep44EMe9H/mVohtuG2iydTBB1z6rGuiA0R8shcnW?=
	=?us-ascii?Q?sg3rTcAssEmeCNe2Cdq2ixH+4dB23AWUsnH3HyxiI8mP+7a8HFCJ7rLjDqqF?=
	=?us-ascii?Q?RS0qrBmC258WiGLWkfwGETIwuS5+soYEIWs/KSeU0+xdQsbofCJRhBIlte87?=
	=?us-ascii?Q?aiig+T5sQIwvIHm18uw177cyl8PSm48hKyW4qmxXaNoeb2z1jDyumqHrZplM?=
	=?us-ascii?Q?nvxy0UVDEgLCKHnHcVztZhm7bTlWlMHjiCMQrS3fve2QAt2D3IxuMCz28aHW?=
	=?us-ascii?Q?cwHAA2mT0OQNm8g2rRfg05TIPc+jTlzRn9I62XP7DPsngqprVqNqdio/nZid?=
	=?us-ascii?Q?fo6f6urpy5Fg49U7jvLCJKTNy0rT9HO26Q=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a2e3377-137a-4885-39aa-08d8c3f7a821
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 01:46:11.6624 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9bH1Xi4QlVEz/lDB0vDSvrVVsTB7vfLB8VPkObCpdPMIgqvrvlMJiDgfscKsyHw5M8/FmV126f28ClY1m7A4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6445
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10T1kNge014216
X-loop: dm-devel@redhat.com
Cc: "pavel.tide@veeam.com" <pavel.tide@veeam.com>
Subject: Re: [dm-devel] [PATCH 2/2] [dm] blk_interposer for dm-linear
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/29 2:23, Sergei Shtepa wrote:
> Implement a block interposer for device-mapper to attach
> to an existing block layer stack. Using the interposer,
> we can connect the dm-linear to a device with a mounted
> file system.
> 
> changes:
>   * the new dm_interposer structure contains blk_interposer
>     to intercept bio from the interposed disk and interval tree
>     of block devices on this disk.
>   * the new interval tree for device mapper.
>   * the dm_submit_bio_interposer_fn() function implements
>     the bio interception logic.
>   * the functions dm_interposer_attach_dev() &
>     dm_interposer_detach_dev() allow to attach and detach devices
>     to dm_interposer.
>   * the new parameter 'noexcl' allows to create dm-linear to device
>     with an already mounted file system.
>   * the non_exclusive parameter in dm_target structure - it`s a sign
>     that target device should be opened without FMODE_EXCL mode.
>   * the new ioctl IOCTL_DEV_REMAP allow to attach dm device to
>     a regular block device.

Same comment about changelog as in the previous patch.

> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> ---
>  drivers/md/dm-core.h          |  46 +++-
>  drivers/md/dm-ioctl.c         |  39 ++++
>  drivers/md/dm-linear.c        |  17 +-
>  drivers/md/dm-table.c         |  12 +-
>  drivers/md/dm.c               | 383 ++++++++++++++++++++++++++++++++--
>  drivers/md/dm.h               |   2 +-
>  include/linux/device-mapper.h |   7 +
>  include/uapi/linux/dm-ioctl.h |  15 +-
>  8 files changed, 493 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 086d293c2b03..0f870b1d4be4 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -13,7 +13,7 @@
>  #include <linux/ktime.h>
>  #include <linux/genhd.h>
>  #include <linux/blk-mq.h>
> -

whiteline change.

> +#include <linux/rbtree.h>
>  #include <trace/events/block.h>
>  
>  #include "dm.h"
> @@ -109,6 +109,9 @@ struct mapped_device {
>  	bool init_tio_pdu:1;
>  
>  	struct srcu_struct io_barrier;
> +
> +	/* interposer device for remap */
> +	struct dm_interposed_dev *ip_dev;
>  };
>  
>  void disable_discard(struct mapped_device *md);
> @@ -164,6 +167,47 @@ struct dm_table {
>  	struct dm_md_mempools *mempools;
>  };
>  
> +/*
> + * Interval tree for device mapper
> + */
> +struct dm_rb_range {
> +	struct rb_node node;
> +	sector_t start;		/* start sector of rb node */
> +	sector_t last;		/* end sector of rb node */
> +	sector_t _subtree_last; /* highest sector in subtree of rb node */
> +};
> +
> +void dm_rb_insert(struct dm_rb_range *node, struct rb_root_cached *root);
> +void dm_rb_remove(struct dm_rb_range *node, struct rb_root_cached *root);
> +
> +struct dm_rb_range *dm_rb_iter_first(struct rb_root_cached *root, sector_t start, sector_t last);
> +struct dm_rb_range *dm_rb_iter_next(struct dm_rb_range *node, sector_t start, sector_t last);
> +
> +/*
> + * For connecting blk_interposer and dm-targets devices.

Is this comment about the callback or the structure ? I think the latter, so it
is in the worng place. Please also add a comment for the callback definition
explaining what it should be doing.

> + */
> +typedef void (*dm_interpose_bio_t) (void *context, struct dm_rb_range *node,  struct bio *bio);
> +
> +struct dm_interposed_dev {
> +	struct gendisk *disk;
> +	struct dm_rb_range node;
> +	void *context;
> +	dm_interpose_bio_t dm_interpose_bio;
> +
> +	atomic64_t ip_cnt; /*for debug purpose*/
> +};
> +
> +struct dm_interposed_dev *dm_interposer_new_dev(struct gendisk *disk,
> +						sector_t ofs, sector_t len,
> +						void *context,
> +						dm_interpose_bio_t dm_interpose_bio_t);
> +void dm_interposer_free_dev(struct dm_interposed_dev *ip_dev);
> +int dm_interposer_attach_dev(struct dm_interposed_dev *ip_dev);
> +int dm_interposer_detach_dev(struct dm_interposed_dev *ip_dev);
> +
> +int dm_remap_install(struct mapped_device *md, const char *donor_device_name);
> +int dm_remap_uninstall(struct mapped_device *md);
> +
>  static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
>  {
>  	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 5e306bba4375..2944d442c256 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1649,6 +1649,44 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
>  	return r;
>  }
>  
> +static inline int dev_remap_start(struct mapped_device *md, uint8_t *params)
> +{
> +	char *donor_device_name = (char *)params;
> +
> +	return dm_remap_install(md, donor_device_name);
> +}
> +static int dev_remap_finish(struct mapped_device *md)
> +{
> +	return dm_remap_uninstall(md);
> +}
> +
> +static int dev_remap(struct file *filp, struct dm_ioctl *param, size_t param_size)
> +{
> +	int ret = 0;
> +	struct mapped_device *md;
> +	void *bin_data;
> +	struct dm_remap_param *remap_param;
> +
> +	md = find_device(param);
> +	if (!md)
> +		return -ENXIO;
> +
> +	bin_data = (void *)(param) + param->data_start;
> +	remap_param = bin_data;
> +
> +	if (remap_param->cmd == REMAP_START_CMD)
> +		ret = dev_remap_start(md, remap_param->params);
> +	else if (remap_param->cmd == REMAP_FINISH_CMD)
> +		ret = dev_remap_finish(md);
> +	else {
> +		DMWARN("Invalid remap command, %d", remap_param->cmd);
> +		ret = -EINVAL;
> +	}
> +
> +	dm_put(md);
> +	return ret;
> +}
> +
>  /*
>   * The ioctl parameter block consists of two parts, a dm_ioctl struct
>   * followed by a data buffer.  This flag is set if the second part,
> @@ -1691,6 +1729,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
>  		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
>  		{DM_DEV_ARM_POLL, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
>  		{DM_GET_TARGET_VERSION, 0, get_target_version},
> +		{DM_DEV_REMAP_CMD, 0, dev_remap},
>  	};
>  
>  	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 00774b5d7668..ffb8b5ca4d10 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -28,12 +28,13 @@ struct linear_c {
>   */
>  static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  {
> +	fmode_t mode;
>  	struct linear_c *lc;
>  	unsigned long long tmp;
>  	char dummy;
>  	int ret;
>  
> -	if (argc != 2) {
> +	if ((argc < 2) || (argc > 3)) {
>  		ti->error = "Invalid argument count";
>  		return -EINVAL;
>  	}
> @@ -51,7 +52,19 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  	lc->start = tmp;
>  
> -	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
> +	ti->non_exclusive = false;
> +	if (argc > 2) {
> +		if (strcmp("noexcl", argv[2]) == 0)
> +			ti->non_exclusive = true;
> +		else if (strcmp("excl", argv[2]) == 0)
> +			ti->non_exclusive = false;

It already is false.

> +		else {
> +			ti->error = "Invalid exclusive option";
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ret = dm_get_device(ti, argv[0], mode, &lc->dev);

Where is mode initialized ? Why remove dm_table_get_mode(ti->table) ?

>  	if (ret) {
>  		ti->error = "Device lookup failed";
>  		goto bad;

I would prefer to see this change to dm-linear in its own patch, following this
one, with a clear explanation in the commit message how this change relates to
interposer since the explanation for this "exclusive" change is nowhere to be
seen. Also please check if there is a file describing dm-linear options under
Documentation/ (I can't remember if there is one). If there is one, it will need
to be updated too.

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4acf2342f7ad..f15bc2171f25 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -322,7 +322,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>   * device and not to touch the existing bdev field in case
>   * it is accessed concurrently.
>   */
> -static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
> +static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode, bool non_exclusive,
>  			struct mapped_device *md)
>  {
>  	int r;
> @@ -330,7 +330,7 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
>  
>  	old_dev = dd->dm_dev;
>  
> -	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
> +	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev, non_exclusive,
>  				dd->dm_dev->mode | new_mode, &new_dev);
>  	if (r)
>  		return r;
> @@ -387,7 +387,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		if (!dd)
>  			return -ENOMEM;
>  
> -		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> +		r = dm_get_table_device(t->md, dev, mode, ti->non_exclusive, &dd->dm_dev);
> +		if (r) {
>  			kfree(dd);
>  			return r;
>  		}
> @@ -396,8 +397,9 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		list_add(&dd->list, &t->devices);
>  		goto out;
>  
> -	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> -		r = upgrade_mode(dd, mode, t->md);
> +	} else if ((dd->dm_dev->mode != (mode | dd->dm_dev->mode)) &&
> +		   (dd->dm_dev->non_exclusive != ti->non_exclusive)) {
> +		r = upgrade_mode(dd, mode, ti->non_exclusive, t->md);
>  		if (r)
>  			return r;
>  	}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7bac564f3faa..3b871d98b7b6 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -28,6 +28,7 @@
>  #include <linux/refcount.h>
>  #include <linux/part_stat.h>
>  #include <linux/blk-crypto.h>
> +#include <linux/interval_tree_generic.h>
>  
>  #define DM_MSG_PREFIX "core"
>  
> @@ -56,6 +57,8 @@ static struct workqueue_struct *deferred_remove_workqueue;
>  atomic_t dm_global_event_nr = ATOMIC_INIT(0);
>  DECLARE_WAIT_QUEUE_HEAD(dm_global_eventq);
>  
> +static DEFINE_MUTEX(interposer_mutex); /* synchronizing access to blk_interposer */

Why not dm_interposer_mutex as the name ? And the comment is not very useful: a
mutex is always for synchronizing :)

> +
>  void dm_issue_global_event(void)
>  {
>  	atomic_inc(&dm_global_event_nr);
> @@ -162,6 +165,26 @@ struct table_device {
>  	struct dm_dev dm_dev;
>  };
>  
> +/*
> + * Device mapper`s interposer.
> + */
> +struct dm_interposer {
> +	struct blk_interposer blk_ip;
> +	struct mapped_device *md;
> +
> +	struct kref kref;
> +	struct rw_semaphore ip_devs_lock;
> +	struct rb_root_cached ip_devs_root; /* dm_interposed_dev tree */
> +};
> +
> +/*
> + * Interval tree for device mapper
> + */
> +#define START(node) ((node)->start)
> +#define LAST(node) ((node)->last)
> +INTERVAL_TREE_DEFINE(struct dm_rb_range, node, sector_t, _subtree_last,
> +		     START, LAST,, dm_rb);
> +
>  /*
>   * Bio-based DM's mempools' reserved IOs set by the user.
>   */
> @@ -733,28 +756,340 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
>  	rcu_read_unlock();
>  }
>  
> +static void dm_submit_bio_interposer_fn(struct bio *bio)
> +{
> +	struct dm_interposer *ip;
> +	unsigned int noio_flag = 0;
> +	sector_t start;
> +	sector_t last;
> +	struct dm_rb_range *node;
> +
> +	ip = container_of(bio->bi_disk->interposer, struct dm_interposer, blk_ip);
> +	start = bio->bi_iter.bi_sector;
> +	last = start + dm_sector_div_up(bio->bi_iter.bi_size, SECTOR_SIZE);
> +
> +	noio_flag = memalloc_noio_save();
> +	down_read(&ip->ip_devs_lock);
> +	node = dm_rb_iter_first(&ip->ip_devs_root, start, last);
> +	while (node) {
> +		struct dm_interposed_dev *ip_dev =
> +			container_of(node, struct dm_interposed_dev, node);
> +
> +		atomic64_inc(&ip_dev->ip_cnt);
> +		ip_dev->dm_interpose_bio(ip_dev->context, node, bio);
> +
> +		node = dm_rb_iter_next(node, start, last);
> +	}
> +	up_read(&ip->ip_devs_lock);
> +	memalloc_noio_restore(noio_flag);
> +}
> +
> +static void free_interposer(struct kref *kref)
> +{
> +	struct dm_interposer *ip = container_of(kref, struct dm_interposer, kref);
> +
> +	blk_interposer_detach(&ip->blk_ip, dm_submit_bio_interposer_fn);

No queue freeze ?

> +
> +	kfree(ip);
> +}
> +
> +static struct dm_interposer *new_interposer(struct gendisk *disk)
> +{
> +	int ret = 0;
> +	struct dm_interposer *ip;
> +
> +	ip = kzalloc(sizeof(struct dm_interposer), GFP_NOIO);
> +	if (!ip)
> +		return ERR_PTR(-ENOMEM);
> +
> +	kref_init(&ip->kref);
> +	init_rwsem(&ip->ip_devs_lock);
> +	ip->ip_devs_root = RB_ROOT_CACHED;
> +
> +	ret = blk_interposer_attach(disk, &ip->blk_ip, dm_submit_bio_interposer_fn);

No queue freeze ?

> +	if (ret) {
> +		DMERR("Failed to attack blk_interposer");
> +		kref_put(&ip->kref, free_interposer);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return ip;
> +}
> +
> +static struct dm_interposer *get_interposer(struct gendisk *disk)
> +{
> +	struct dm_interposer *ip;
> +
> +	if (!blk_has_interposer(disk))
> +		return NULL;
> +
> +	if (disk->interposer->ip_submit_bio != dm_submit_bio_interposer_fn) {
> +		DMERR("Disks interposer slot already occupied.");
> +		return ERR_PTR(-EBUSY);

This is weird... If there is an interposer, why not get a ref on that one. That
is what the function name suggests at least.

> +	}
> +
> +	ip = container_of(disk->interposer, struct dm_interposer, blk_ip);
> +
> +	kref_get(&ip->kref);
> +	return ip;
> +}
> +
> +struct dm_interposed_dev *dm_interposer_new_dev(struct gendisk *disk, sector_t ofs, sector_t len,
> +						void *context, dm_interpose_bio_t dm_interpose_bio)
> +{
> +	sector_t start = ofs;
> +	sector_t last =  ofs + len - 1;
> +	struct dm_interposed_dev *ip_dev = NULL;
> +
> +	/* Allocate new ip_dev */
> +	ip_dev = kzalloc(sizeof(struct dm_interposed_dev), GFP_KERNEL);
> +	if (!ip_dev)
> +		return NULL;
> +
> +	ip_dev->disk = disk;
> +	ip_dev->node.start = start;
> +	ip_dev->node.last = last;
> +
> +	ip_dev->context = context;
> +	ip_dev->dm_interpose_bio = dm_interpose_bio;
> +
> +	atomic64_set(&ip_dev->ip_cnt, 0);
> +
> +	return ip_dev;
> +}
> +
> +void dm_interposer_free_dev(struct dm_interposed_dev *ip_dev)
> +{
> +	kfree(ip_dev);
> +}

Make this inline may be ?

> +
> +static inline void dm_disk_freeze(struct gendisk *disk)
> +{
> +	blk_mq_freeze_queue(disk->queue);
> +	blk_mq_quiesce_queue(disk->queue);

I think you can replace this with blk_mq_freeze_queue_wait().

> +}
> +
> +static inline void dm_disk_unfreeze(struct gendisk *disk)
> +{
> +	blk_mq_unquiesce_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue);
> +}
> +
> +int dm_interposer_attach_dev(struct dm_interposed_dev *ip_dev)
> +{
> +	int ret = 0;
> +	struct dm_interposer *ip = NULL;
> +	unsigned int noio_flag = 0;
> +
> +	if (!ip_dev)
> +		return -EINVAL;
> +
> +	dm_disk_freeze(ip_dev->disk);
> +	mutex_lock(&interposer_mutex);
> +	noio_flag = memalloc_noio_save();
> +
> +	ip = get_interposer(ip_dev->disk);
> +	if (ip == NULL)
> +		ip = new_interposer(ip_dev->disk);
> +	if (IS_ERR(ip)) {
> +		ret = PTR_ERR(ip);
> +		goto out;
> +	}
> +
> +	/* Attach dm_interposed_dev to dm_interposer */
> +	down_write(&ip->ip_devs_lock);
> +	do {
> +		struct dm_rb_range *node;
> +
> +		/* checking that ip_dev already exists for this region */
> +		node = dm_rb_iter_first(&ip->ip_devs_root, ip_dev->node.start, ip_dev->node.last);
> +		if (node) {
> +			DMERR("Disk part form [%llu] to [%llu] already have interposer",
> +			      node->start, node->last);
> +
> +			ret = -EBUSY;
> +			break;
> +		}
> +
> +		/* insert ip_dev to ip tree */
> +		dm_rb_insert(&ip_dev->node, &ip->ip_devs_root);
> +		/* increment ip reference counter */
> +		kref_get(&ip->kref);
> +	} while (false);
> +	up_write(&ip->ip_devs_lock);
> +
> +	kref_put(&ip->kref, free_interposer);
> +
> +out:
> +	memalloc_noio_restore(noio_flag);
> +	mutex_unlock(&interposer_mutex);
> +	dm_disk_unfreeze(ip_dev->disk);
> +
> +	return ret;
> +}
> +
> +int dm_interposer_detach_dev(struct dm_interposed_dev *ip_dev)
> +{
> +	int ret = 0;
> +	struct dm_interposer *ip = NULL;
> +	unsigned int noio_flag = 0;
> +
> +	if (!ip_dev)
> +		return -EINVAL;
> +
> +	dm_disk_freeze(ip_dev->disk);
> +	mutex_lock(&interposer_mutex);
> +	noio_flag = memalloc_noio_save();
> +
> +	ip = get_interposer(ip_dev->disk);
> +	if (IS_ERR(ip)) {
> +		ret = PTR_ERR(ip);
> +		DMERR("Interposer not found");
> +		goto out;
> +	}
> +	if (unlikely(ip == NULL)) {
> +		ret = -ENXIO;
> +		DMERR("Interposer not found");
> +		goto out;
> +	}
> +
> +	down_write(&ip->ip_devs_lock);
> +	do {
> +		dm_rb_remove(&ip_dev->node, &ip->ip_devs_root);
> +		/* the reference counter here cannot be zero */
> +		kref_put(&ip->kref, free_interposer);
> +
> +	} while (false);
> +	up_write(&ip->ip_devs_lock);
> +
> +	/* detach and free interposer if it`s not needed */

s/`/'/

> +	kref_put(&ip->kref, free_interposer);
> +out:
> +	memalloc_noio_restore(noio_flag);
> +	mutex_unlock(&interposer_mutex);
> +	dm_disk_unfreeze(ip_dev->disk);
> +
> +	return ret;
> +}
> +
> +static void dm_remap_fn(void *context, struct dm_rb_range *node, struct bio *bio)
> +{
> +	struct mapped_device *md = context;
> +
> +	/* Set acceptor device. */
> +	bio->bi_disk = md->disk;
> +
> +	/* Remap disks offset */
> +	bio->bi_iter.bi_sector -= node->start;
> +
> +	/*
> +	 * bio should be resubmitted.
> +	 * We can just add bio to bio_list of the current process.
> +	 * current->bio_list must be initialized when this function is called.
> +	 * If call submit_bio_noacct(), the bio will be checked twice.
> +	 */
> +	BUG_ON(!current->bio_list);
> +	bio_list_add(&current->bio_list[0], bio);
> +}
> +
> +int dm_remap_install(struct mapped_device *md, const char *donor_device_name)
> +{
> +	int ret = 0;
> +	struct block_device *donor_bdev;
> +	fmode_t mode = FMODE_READ | FMODE_WRITE;
> +
> +	DMDEBUG("Dm remap install for mapped device %s and donor device %s",
> +		md->name, donor_device_name);
> +
> +	donor_bdev = blkdev_get_by_path(donor_device_name, mode, "device-mapper remap");
> +	if (IS_ERR(donor_bdev)) {
> +		DMERR("Cannot open device [%s]", donor_device_name);
> +		return PTR_ERR(donor_bdev);
> +	}
> +
> +	do {
> +		sector_t ofs = get_start_sect(donor_bdev);
> +		sector_t len = bdev_nr_sectors(donor_bdev);
> +
> +		md->ip_dev = dm_interposer_new_dev(donor_bdev->bd_disk, ofs, len, md, dm_remap_fn);
> +		if (!md->ip_dev) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		DMDEBUG("New interposed device 0x%p", md->ip_dev);
> +		ret = dm_interposer_attach_dev(md->ip_dev);
> +		if (ret) {
> +			dm_interposer_free_dev(md->ip_dev);
> +
> +			md->ip_dev = NULL;
> +			DMERR("Failed to attach dm interposer");
> +			break;
> +		}
> +
> +		DMDEBUG("Attached successfully.");
> +	} while (false);
> +
> +	blkdev_put(donor_bdev, mode);
> +
> +	return ret;
> +}
> +
> +int dm_remap_uninstall(struct mapped_device *md)
> +{
> +	int ret = 0;
> +
> +	DMDEBUG("Dm remap uninstall for mapped device %s ip_dev=0x%p", md->name, md->ip_dev);
> +
> +	if (!md->ip_dev) {
> +		DMERR("Cannot detach dm interposer");
> +		return -EINVAL;
> +	}
> +
> +	ret = dm_interposer_detach_dev(md->ip_dev);
> +	if (ret) {
> +		DMERR("Failed to detach dm interposer");
> +		return ret;
> +	}
> +
> +	DMDEBUG("Detached successfully. %llu bios was interposed",
> +		atomic64_read(&md->ip_dev->ip_cnt));
> +	dm_interposer_free_dev(md->ip_dev);
> +	md->ip_dev = NULL;
> +
> +	return 0;
> +}
> +
>  static char *_dm_claim_ptr = "I belong to device-mapper";
>  
>  /*
>   * Open a table device so we can use it as a map destination.
>   */
>  static int open_table_device(struct table_device *td, dev_t dev,
> -			     struct mapped_device *md)
> +			     struct mapped_device *md, bool non_exclusive)
>  {
>  	struct block_device *bdev;
> -
> -	int r;
> +	int ret;
>  
>  	BUG_ON(td->dm_dev.bdev);
>  
> -	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
> -	if (IS_ERR(bdev))
> -		return PTR_ERR(bdev);
> +	if (non_exclusive)
> +		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode, NULL);
> +	else
> +		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
>  
> -	r = bd_link_disk_holder(bdev, dm_disk(md));
> -	if (r) {
> -		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
> -		return r;
> +	if (IS_ERR(bdev)) {
> +		ret = PTR_ERR(bdev);
> +		if (ret != -EBUSY)
> +			return ret;
> +	}
> +
> +	if (!non_exclusive) {
> +		ret = bd_link_disk_holder(bdev, dm_disk(md));
> +		if (ret) {
> +			blkdev_put(bdev, td->dm_dev.mode);
> +			return ret;
> +		}
>  	}
>  
>  	td->dm_dev.bdev = bdev;
> @@ -770,33 +1105,38 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
>  	if (!td->dm_dev.bdev)
>  		return;
>  
> -	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> -	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> +	if (td->dm_dev.mode & FMODE_EXCL)
> +		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> +
> +	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
> +
>  	put_dax(td->dm_dev.dax_dev);
>  	td->dm_dev.bdev = NULL;
>  	td->dm_dev.dax_dev = NULL;
>  }
>  
>  static struct table_device *find_table_device(struct list_head *l, dev_t dev,
> -					      fmode_t mode)
> +					      fmode_t mode, bool non_exclusive)
>  {
>  	struct table_device *td;
>  
>  	list_for_each_entry(td, l, list)
> -		if (td->dm_dev.bdev->bd_dev == dev && td->dm_dev.mode == mode)
> +		if (td->dm_dev.bdev->bd_dev == dev &&
> +		    td->dm_dev.mode == mode &&
> +		    td->dm_dev.non_exclusive == non_exclusive)
>  			return td;
>  
>  	return NULL;
>  }
>  
> -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
>  			struct dm_dev **result)
>  {
>  	int r;
>  	struct table_device *td;
>  
>  	mutex_lock(&md->table_devices_lock);
> -	td = find_table_device(&md->table_devices, dev, mode);
> +	td = find_table_device(&md->table_devices, dev, mode, non_exclusive);
>  	if (!td) {
>  		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
>  		if (!td) {
> @@ -807,7 +1147,8 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
>  		td->dm_dev.mode = mode;
>  		td->dm_dev.bdev = NULL;
>  
> -		if ((r = open_table_device(td, dev, md))) {
> +		r = open_table_device(td, dev, md, non_exclusive);
> +		if (r) {
>  			mutex_unlock(&md->table_devices_lock);
>  			kfree(td);
>  			return r;
> @@ -2182,6 +2523,14 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
>  
>  	might_sleep();
>  
> +	if (md->ip_dev) {
> +		if (dm_interposer_detach_dev(md->ip_dev))
> +			DMERR("Failed to detach dm interposer");
> +
> +		dm_interposer_free_dev(md->ip_dev);
> +		md->ip_dev = NULL;
> +	}
> +
>  	spin_lock(&_minor_lock);
>  	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
>  	set_bit(DMF_FREEING, &md->flags);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index fffe1e289c53..7bf20fb2de74 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -179,7 +179,7 @@ int dm_open_count(struct mapped_device *md);
>  int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred);
>  int dm_cancel_deferred_remove(struct mapped_device *md);
>  int dm_request_based(struct mapped_device *md);
> -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
>  			struct dm_dev **result);
>  void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
>  
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 61a66fb8ebb3..70002363bfc0 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -150,6 +150,7 @@ struct dm_dev {
>  	struct block_device *bdev;
>  	struct dax_device *dax_dev;
>  	fmode_t mode;
> +	bool non_exclusive;
>  	char name[16];
>  };
>  
> @@ -325,6 +326,12 @@ struct dm_target {
>  	 * whether or not its underlying devices have support.
>  	 */
>  	bool discards_supported:1;
> +
> +	/*
> +	 * Set if this target needs to open device without FMODE_EXCL
> +	 * mode.
> +	 */
> +	bool non_exclusive:1;
>  };
>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
> index 4933b6b67b85..08d7dbff80f4 100644
> --- a/include/uapi/linux/dm-ioctl.h
> +++ b/include/uapi/linux/dm-ioctl.h
> @@ -214,6 +214,15 @@ struct dm_target_msg {
>  	char message[0];
>  };
>  
> +enum {
> +	REMAP_START_CMD = 1,
> +	REMAP_FINISH_CMD,
> +};
> +
> +struct dm_remap_param {
> +	uint8_t cmd;
> +	uint8_t params[0];
> +};
>  /*
>   * If you change this make sure you make the corresponding change
>   * to dm-ioctl.c:lookup_ioctl()
> @@ -244,6 +253,7 @@ enum {
>  	DM_DEV_SET_GEOMETRY_CMD,
>  	DM_DEV_ARM_POLL_CMD,
>  	DM_GET_TARGET_VERSION_CMD,
> +	DM_DEV_REMAP_CMD
>  };
>  
>  #define DM_IOCTL 0xfd
> @@ -259,6 +269,7 @@ enum {
>  #define DM_DEV_STATUS    _IOWR(DM_IOCTL, DM_DEV_STATUS_CMD, struct dm_ioctl)
>  #define DM_DEV_WAIT      _IOWR(DM_IOCTL, DM_DEV_WAIT_CMD, struct dm_ioctl)
>  #define DM_DEV_ARM_POLL  _IOWR(DM_IOCTL, DM_DEV_ARM_POLL_CMD, struct dm_ioctl)
> +#define DM_DEV_REMAP     _IOWR(DM_IOCTL, DM_DEV_REMAP_CMD, struct dm_ioctl)
>  
>  #define DM_TABLE_LOAD    _IOWR(DM_IOCTL, DM_TABLE_LOAD_CMD, struct dm_ioctl)
>  #define DM_TABLE_CLEAR   _IOWR(DM_IOCTL, DM_TABLE_CLEAR_CMD, struct dm_ioctl)
> @@ -272,9 +283,9 @@ enum {
>  #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
>  
>  #define DM_VERSION_MAJOR	4
> -#define DM_VERSION_MINOR	43
> +#define DM_VERSION_MINOR	44
>  #define DM_VERSION_PATCHLEVEL	0
> -#define DM_VERSION_EXTRA	"-ioctl (2020-10-01)"
> +#define DM_VERSION_EXTRA	"-ioctl (2020-12-25)"
>  
>  /* Status bits */
>  #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

