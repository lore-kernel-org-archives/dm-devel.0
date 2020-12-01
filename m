Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AD5C64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:25:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4DE7206E3
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4DE7206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-m4_7FQ7sOyW5EW9v1OxiQw-1; Tue, 01 Dec 2020 06:25:52 -0500
X-MC-Unique: m4_7FQ7sOyW5EW9v1OxiQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C43F6612A7;
	Tue,  1 Dec 2020 11:25:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5D1260C0F;
	Tue,  1 Dec 2020 11:25:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55C16180954D;
	Tue,  1 Dec 2020 11:25:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1BNHGf023338 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 06:23:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42E052166B2B; Tue,  1 Dec 2020 11:23:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C7812166B2C
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 11:23:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C367A800B3A
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 11:23:14 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-417-77N0rhMfPjSnrhzH4CfMTw-1; Tue, 01 Dec 2020 06:23:12 -0500
X-MC-Unique: 77N0rhMfPjSnrhzH4CfMTw-1
IronPort-SDR: eahwF8SWnh/Hv8xy97UnlXEEvznijJhOAvkIThBxO0y3+yTxCV3dm3Tb+RBIg55/xgjs7W4Ody
	ZffIvvGQ+L1Z0YfHB77YqXnVkSXgmkUtnlTCHmYKX1wdclAuNph4o5gacwXJWYDZ5CBb8nqDK5
	TEWxM8+PIb9W80ndQMAZMPtcoxWjvCaPR6eZdyX31oSuXtKrhUtCL2whd4aSQa9dG/fUDOOKDf
	BJSsO5mVzvQOQ04A/FNNs7dGbU+svfYZnlwvZjRIMipTAwK9pmVz7lydS4p6SDObV5sC0AHQ+G
	fjE=
X-IronPort-AV: E=Sophos;i="5.78,384,1599494400"; d="scan'208";a="153978449"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
	by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2020 19:22:06 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24;
	Tue, 1 Dec 2020 11:22:05 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Tue, 1 Dec 2020 11:22:05 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH 0/2] add simple copy support
Thread-Index: AQHWx7FKsGlRN3mkpEWADJoApLvJfQ==
Date: Tue, 1 Dec 2020 11:22:05 +0000
Message-ID: <CH2PR04MB652240A4A23F89B26118FD66E7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <CGME20201201054049epcas5p2e0118abda14aaf8d8bdcfb543bc330fc@epcas5p2.samsung.com>
	<20201201053949.143175-1-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9559c890-4a7e-4a12-6363-08d895eb5540
x-ms-traffictypediagnostic: CH2PR04MB7078:
x-microsoft-antispam-prvs: <CH2PR04MB70788C861CE322D927581D98E7F40@CH2PR04MB7078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Vy4O5uA5xSZ2jnv+8sdStr744QazMtMkzFdi8cmDEpG/yXIbW71nrY4edvfMQlyaW2EFy3OB12AiX11neGuBsVmSZciYx6xepFOuwFdiZvDnJvAjM1HGXrZaFQJC7HILdIrmrwdjO9jci5vmzN8bhnZRxoVKRuxHJnS+LAFzPA8VsaAddAe2gNGtOCCPfhLJpI5sFX59MiGSiwUXDGDBXLR/xGPoEcuRai2kjKwZ2bMoG0HfGPOYeGaY61KIcGnSlJUGGog0EkhRXCLJCr+6oqIp6m6sEKQ+31IIEo0vBl+L8lTEvuAXSTXKHsZP8y5xehA+9Yyy9dyjX0hjONphJJ6tRenGsLkzGImMBLktOPJ25NN8+mIk0LnmRSBJZ8p4fncO6QrBjdPQY+Kf4i5nkGOkmXrtEpLujkZWl2vtkMde6TQk8A9NX32Xcjou4pfnHlJqPExdlHMW9f0iwSr7oF2PsKLWMdRZNmITOTWzR9Q=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(76116006)(86362001)(478600001)(83380400001)(316002)(9686003)(7696005)(4326008)(966005)(186003)(66946007)(91956017)(64756008)(53546011)(55016002)(26005)(71200400001)(8936002)(110136005)(7416002)(66476007)(66556008)(5660300002)(2906002)(54906003)(8676002)(52536014)(6506007)(33656002)(66446008)(15398625002)(43620500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Vi+2VLbt6Lae9lJVrI7n+y3zWjrxj72pWpL9n+aOzlKot8nIxJ9gZ7SNXxxi?=
	=?us-ascii?Q?+QnH6JfNoNMmNDXQ9gnNw7U0SU93a65zzRElyy6cPMzIyNN3XuCJHTZro5Xs?=
	=?us-ascii?Q?egqgIiSUIz9u8tygD6QQmp3gdwBpAG6op5ze7KZSl1fQpd4I8vXnyNSW5y7j?=
	=?us-ascii?Q?h7NLp5P91nBxP6LC3PmAwUTCwzG1Ki/kP3/n4BQnvvmr1/vEmcboCuFnViNM?=
	=?us-ascii?Q?j0gfX1ZRQxHxeHuvCM8meFR4HwLUcp74L6M+qDXOO6NfBUZuWAaD/NpwcMzX?=
	=?us-ascii?Q?CLEld6DQ+zEAIrN0bR7WthW8mYyjVD7LzHe5a+U4ekI3FaqFmWbH/uIAVZ0q?=
	=?us-ascii?Q?eHrZJbjEYSSuj/Zd5cGyO5usSTjG1V/jyfFqZiEGjGIWsO6nmrSVYYWf4oAS?=
	=?us-ascii?Q?MGi19TOGlZcs71uRzX5IHRv7bDt3LPX5SHHbk5Bqy7dSKKuMBO/DS7k0wja4?=
	=?us-ascii?Q?4MdUabYitJOgbnupmTQoPwMcrzlUQ2nos0o9VWflqvTPWLQOlMtuwS/8ex8k?=
	=?us-ascii?Q?SJnWM2Rj/bgB1VjGgIEGuAookE801sDRL5dlVQ6DitJEwMCIUcRddAG3YLNT?=
	=?us-ascii?Q?8y/i3ip38b4fTpLLb2zfQUYlMVuia46lmai6euXZYTeC/ioRNYQ8kpkqw6Z3?=
	=?us-ascii?Q?GV5tD5qGNNbE/daMh3iU+T5HiS+lYTTKHM4qNoVjoPgO4o6I30xJ+6PYJ8dW?=
	=?us-ascii?Q?iX7t/FVcQgVfZPFZZ7yZKtQm5ikgOLPoh7qsetd5O7OwN22IQ2KuuMCZueBw?=
	=?us-ascii?Q?jurYAyd7NBWqObqaV4vZJdy0cy5E3d+3E1TcpDgFlF7PCnUxeyaMSxmQdrrv?=
	=?us-ascii?Q?wcXnY1j2faLLFcl+D+Qx2es6//Wl2lGkdZ9pa3tYQKcPKua4lrYos5o3ju8O?=
	=?us-ascii?Q?2zOHT7Vbn2BcI/x05e6sJVwVTS2PlvDcnOwz9f/qmdfbqSN+hUkHycyOzRG0?=
	=?us-ascii?Q?h/CVWiF4IcD6FK/s+0a7V75i7iXiHO8IattFpIFvUOuBMLbZ0DTYG1f4T5my?=
	=?us-ascii?Q?5J5+?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9559c890-4a7e-4a12-6363-08d895eb5540
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 11:22:05.1617 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zUSIFR9OMhMbkPUTP+K8GbMD2lwk56toMULEUMsAu1Bbf+G7xSXdLDQbHhSMS7LHNkV99kjysNUvPUxlW2xp+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7078
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B1BNHGf023338
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

+ Mike and DM list

On 2020/12/01 16:12, SelvaKumar S wrote:
> This patchset tries to add support for TP4065a ("Simple Copy Command"),
> v2020.05.04 ("Ratified")
> 
> The Specification can be found in following link.
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
> 
> This is an RFC. Looking forward for any feedbacks or other alternate
> designs for plumbing simple copy to IO stack.
> 
> Simple copy command is a copy offloading operation and is  used to copy
> multiple contiguous ranges (source_ranges) of LBA's to a single destination
> LBA within the device reducing traffic between host and device.
> 
> This implementation accepts destination, no of sources and arrays of
> source ranges from application and attach it as payload to the bio and
> submits to the device.
> 
> Following limits are added to queue limits and are exposed in sysfs
> to userspace
> 	- *max_copy_sectors* limits the sum of all source_range length
> 	- *max_copy_nr_ranges* limits the number of source ranges
> 	- *max_copy_range_sectors* limit the maximum number of sectors
> 		that can constitute a single source range.

This is interesting. I think there are several possible use in the kernel in
various components: FS (btrfs rebalance, f2fs GC, liklely others) and DM at the
very least.

However, your patches add support only for NVMe devices that have native support
for simple copy, leaving all other block devices out. That seriously limits the
use cases and also does not make this solution attractive since any use of it
would need to be conditional on the underlying drive capabilities. That means
more code for the file systems or device mapper developers and maintainers, not
less.

To avoid this, I would suggest that this code be extended to add emulation for
drives that do not implement simple copy natively. This would allow this
interface to work on any block device, including SAS & SATA HDDs and RAID arrays.

The emulation part of this copy service could I think be based on dm-kcopyd. See
include/linux/dm-kcopyd.h for the interface. The current dm-kcopyd interface
takes one source and multiple destination, the reverse of simple copy. But it
would be fairly straightforward to also allow multiple sources and one
destination. Simple copy native support would accelerate this case, everything
else using the regular BIO read+write interface. Moving dm-kcopyd from DM
infrastructure into the block layer as a set a generic block device sector copy
service would allow its use in more places. And SCSI XCOPY could also be
integrated in there as a different drive native support command.

> 
> 
> SelvaKumar S (2):
>   block: add simple copy support
>   nvme: add simple copy support
> 
>  block/blk-core.c          | 104 +++++++++++++++++++++++++++++++---
>  block/blk-lib.c           | 116 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |   2 +
>  block/blk-settings.c      |  11 ++++
>  block/blk-sysfs.c         |  23 ++++++++
>  block/blk-zoned.c         |   1 +
>  block/bounce.c            |   1 +
>  block/ioctl.c             |  43 ++++++++++++++
>  drivers/nvme/host/core.c  |  91 ++++++++++++++++++++++++++++++
>  drivers/nvme/host/nvme.h  |   4 ++
>  include/linux/bio.h       |   1 +
>  include/linux/blk_types.h |   7 +++
>  include/linux/blkdev.h    |  15 +++++
>  include/linux/nvme.h      |  45 +++++++++++++--
>  include/uapi/linux/fs.h   |  21 +++++++
>  15 files changed, 473 insertions(+), 12 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

