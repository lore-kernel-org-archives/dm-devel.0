Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA2DC47096
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 00:09:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDF396140A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 00:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDF396140A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-NoLjlYJPNeKW24do54uCRA-1; Thu, 03 Jun 2021 20:09:08 -0400
X-MC-Unique: NoLjlYJPNeKW24do54uCRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02C9B107ACCA;
	Fri,  4 Jun 2021 00:09:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FD2260C17;
	Fri,  4 Jun 2021 00:09:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C02651800FFC;
	Fri,  4 Jun 2021 00:09:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15408vAw020761 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 20:08:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C2E1F2114D0D; Fri,  4 Jun 2021 00:08:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDA0A21144FC
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 00:08:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FA5C1857F29
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 00:08:54 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-45-2hNtDPwjNo2mXc8y6AdQbQ-1; Thu, 03 Jun 2021 20:08:50 -0400
X-MC-Unique: 2hNtDPwjNo2mXc8y6AdQbQ-1
IronPort-SDR: lSo//Xilr/84uDypFzmhOjvDZz7NkFPqU6OhizK4d8dXQfz4SkJI4hZSSgsVDsbhLYMf4ZK3xt
	YCvRrc4KIBJp2lZzexwD9oMKNAnCLhWn/ezE49EgB7vQC19Rhzmb6thLQUOLWKGDGgfCBYDTEo
	stzdM+LaIHH0vCTIWZaEc6W2j2z3nOle3i7WKM7dOxcG4Xo56dDnrdt0+OSiX49xNTNYPdSu8a
	oH8jiUFVLg2/p4yDjMUMZNz9XIW94e1r9uUVEqdoD052rzGNErJHUfrQUsotZgr26wb8utDh7D
	UgQ=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; d="scan'208";a="282058977"
Received: from mail-dm3nam07lp2047.outbound.protection.outlook.com (HELO
	NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.47])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 08:08:48 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5163.namprd04.prod.outlook.com (2603:10b6:5:1a::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27;
	Fri, 4 Jun 2021 00:08:47 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.035;
	Fri, 4 Jun 2021 00:08:47 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Colin Ian King <colin.king@canonical.com>
Thread-Topic: dm: Forbid requeue of writes to zones
Thread-Index: AQHXWMY2crVy6LmSRk+Dbf+Tih0t2g==
Date: Fri, 4 Jun 2021 00:08:47 +0000
Message-ID: <DM6PR04MB708127E21C618C8F5F6B3DB6E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <7e7530a9-7939-2ad6-bfe1-d3aeeeed1f77@canonical.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:f9bc:fd30:41b8:96f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49b71c6f-3832-4ec1-5b8c-08d926ececbe
x-ms-traffictypediagnostic: DM6PR04MB5163:
x-microsoft-antispam-prvs: <DM6PR04MB5163FF7EE964262C66B68FE2E73B9@DM6PR04MB5163.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1388
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YNJBMxT6aSS9V/7/9DmcwBzdXlPRfXt78QC7xDQh0v/NOG/XLfnPO7iGlwAwtOC505mL/AbZoQE8ia4UeBjExHlDRKD341+rsXxSwWCfv+p5+uNVqbpt/tXiABKHlg2RVAP4Df4QwU3bfA+M02IlMGZ8u0HBpoJ6j4nid3g3nVIVCaWnW/aRZcNPZIbJ/495BDLG9Jo+vDFdl05znV5eGtyVithpVav5ZvjIFgszqTyRIfbiy76Do4Fcfx3YG1jozPKBbj9HQV8QLpFUzqwoDZ0DW5kMI/kmz+Nz/4Osw+q7TYRiQpbqSOULrehNb6IewgzreBGS+FpzDaFJh2B5tgsVBZpzvmNHsqvjsz2qa1wSxkbxflK+w3QWiCi+nhwY6vq8Tno8QvSlpyoWx9nURQ9783uS8osMOlIA2gWBEv7/QRH4Vlu0nEVddCIwV1lj4wq8MOfhPN99blhV0tGM8Nwndvfd+suk5RrLjswBH19iWsBTciiJkx4u89JDjD0pSqlZnARYRyz8DTrEP8Yhx3ujmpGDq7YKeNxh0BQB2Xdo3KPpKhjfIwXebssE74OieqbZxXMbA3DueAFWpWPc2H74I4PK9f09kwfSxVeCSINvyfl8VMmoyfbQF0OBb9g0dHETDmsi0iaZVtVxXDL54Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(316002)(8676002)(71200400001)(6916009)(8936002)(54906003)(66476007)(52536014)(86362001)(91956017)(38100700002)(4326008)(76116006)(33656002)(186003)(122000001)(478600001)(66446008)(5660300002)(53546011)(64756008)(9686003)(55016002)(6506007)(7696005)(66946007)(2906002)(66556008)(83380400001)(309714004);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2DwNYlaXI2LxISLrvP8biIHsDXeDuwOzVC15pnEylAspL/m/kMZacCAEHu60?=
	=?us-ascii?Q?cqyJJ8WVD1I6tdYU0oqsGTtX5vLs3g+k4r8KzAzI5tSKjyGRYugbhvkLqtVi?=
	=?us-ascii?Q?49Q7x3R7+Zu92Cs9YJBhFQy77N2pb5SbSqRWK0GmJHLNkOWOnN3CoLnOQ1pi?=
	=?us-ascii?Q?NyZsOcOILbRlMHr4CpjaYj9PPLQsynjMxptCwtKd4VVHyt9Cvst8svyEglE9?=
	=?us-ascii?Q?CRHTPcZigmYJeo0A9WYRs5CSjlbIgDe491ARHfS+b4/k5aDkyUR81Gf1SEA7?=
	=?us-ascii?Q?tHApk0PSUuVSQh92n4qtlqAFf6TeDyaNZ/DgJs8fi3EO66GuI4SOt/eb27Fu?=
	=?us-ascii?Q?LBOUrBfkmKn455nibbqONt22f8kBvq9dG0Gte/iMJHaFZ5/cdqbKJ0JtXkw9?=
	=?us-ascii?Q?8m02UmTBAfpNKJYEZHJegZXEmN4/BHHZmluLDTzunuVCSRaRLWrShFjsqWUm?=
	=?us-ascii?Q?QdXp+JZrEZOgfgJdFC88nKA4Wz+WJD52S2+pdpQ8HD15sA1xDfxDBfyYz6il?=
	=?us-ascii?Q?kVbyI80Et/FHuQHzKN3fL0mZJ5On9dVqhDxcghxPPIgpWZE0/YHV2C7ZDJ3I?=
	=?us-ascii?Q?3JRWyBhTnI0om7p2zpKGfyWhsvherDyGkEKS0pHKmPTd1KxlXRf7fhZHb37J?=
	=?us-ascii?Q?DCbPQ5PwnX8Jw6NDDDYBG5xn7ZCV/fLusT5fQ1IWKCafQSn8l4ENY8XrvZxz?=
	=?us-ascii?Q?vec6ygJozz5nK5ztdGxt33KW4ZIV8uJyfk00tWaQb9J7juat6vDyFrtN5sRl?=
	=?us-ascii?Q?oRqzp+CQ/lDBux5fXGNRyL3FPjHIX3AoIR2TCOZbQRTa+zTN0L12NKiSZ2Io?=
	=?us-ascii?Q?tr8SYJgDabJlaOI47cGtzXP4/YkkUHMFLF3MDCB3+JjoOZ6KzcgifOSfIqkk?=
	=?us-ascii?Q?7M+1QdsKqA8PfC4fMRE5yslIRPLo8/MI+MDY4qC4ysd2dtKsJzonwcTG9Ymk?=
	=?us-ascii?Q?+dbuGU62jets8QbmopCk2HpNfpjw1Sr/r1Xupc4xwuck5pIKozpe7XWVxjNZ?=
	=?us-ascii?Q?NXqoNRd2uPyXf4DJUzB0V7Sgr5dMsO6ds0mYA0Wx0FA9eNHnEviHccbgDuYf?=
	=?us-ascii?Q?faJt9IcquwQCAiT7djeIm8mNGFr4C7NhOwGJ9gLL7Raxvh6KqiKvXBbdctAC?=
	=?us-ascii?Q?RupPmSMcKXIxFAo69AUo7UHuBftr6SCuuH6KSywqbDttAzA76dbR2iFzWdWn?=
	=?us-ascii?Q?ZAZ8CpVsqLo/j+dd0268oaxTS1LyvMRsvIte+qf9xxdLQfjb/egqfIw6dCMy?=
	=?us-ascii?Q?9rESuq8aH4dwKSNkq/h+xobf1RhJrN+3YsigIiEo0BKJHqhpMBc3oOoQIdAt?=
	=?us-ascii?Q?9OSy2SKFAcNiY5O+TbEC6XRwI/fqdEr9u8DV4R0cLHXFpkXcBAMBfMDKfTyt?=
	=?us-ascii?Q?1yb4wo8Vqu+lU29OsXbz78SDRXlnNb8K81Pmrbz91vZMLDXnwQ=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b71c6f-3832-4ec1-5b8c-08d926ececbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 00:08:47.4705 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tqm2tSZr4khb6BmC/T0NaBccCSVNRl0Q4VVvnpkLd3iI2B4lySV3kh0cabXHHBQbs1X6m/Vk+gLTK7e8iBSaFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5163
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15408vAw020761
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] dm: Forbid requeue of writes to zones
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/06/04 7:17, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity on Linux next has found and issue in
> drivers/md/dm.c with the following commit:
> 
> commit 2c243153d1d4be4e23735cd10984ac17c7a54531
> Author: Damien Le Moal <damien.lemoal@wdc.com>
> Date:   Wed May 26 06:24:58 2021 +0900
> 
>     dm: Forbid requeue of writes to zones
> 
> The analysis is as follows:
> 
>  828 static void dec_pending(struct dm_io *io, blk_status_t error)
>  829 {
>  830        unsigned long flags;
>  831        blk_status_t io_error;
> 
>     1. var_decl: Declaring variable bio without initializer.

This one is related to #7.

> 
>  832        struct bio *bio;
>  833        struct mapped_device *md = io->md;
>  834
>  835        /* Push-back supersedes any I/O errors */
> 
>     2. Condition !!error, taking true branch.
> 
>  836        if (unlikely(error)) {
>  837                spin_lock_irqsave(&io->endio_lock, flags);
> 
>     3. Condition io->status == 11 /* (blk_status_t)11 */, taking false
> branch.
> 
>  838                if (!(io->status == BLK_STS_DM_REQUEUE &&
> __noflush_suspending(md)))
>  839                        io->status = error;
>  840                spin_unlock_irqrestore(&io->endio_lock, flags);
>  841        }
>  842

My patch does not touch these hunks. They are as is. So that is not new.

> 
>     4. Condition atomic_dec_and_test(&io->io_count), taking true branch.
> 
>  843        if (atomic_dec_and_test(&io->io_count)) {
> 
>     5. Condition io->status == 11 /* (blk_status_t)11 */, taking true
> branch.
> 
>  844                if (io->status == BLK_STS_DM_REQUEUE) {
>  845                        /*
>  846                         * Target requested pushing back the I/O.
>  847                         */
>  848                        spin_lock_irqsave(&md->deferred_lock, flags);
> 
>     6. Condition __noflush_suspending(md), taking true branch.
> 
>  849                        if (__noflush_suspending(md) &&

I do not understand this one, nor #4.

> 
> Uninitialized pointer read
>     7. uninit_use_in_call: Using uninitialized value bio when calling
> dm_is_zone_write.
> 
>  850                            !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>  851                                /* NOTE early return due to
> BLK_STS_DM_REQUEUE below */
>  852                                bio_list_add_head(&md->deferred,
> io->orig_bio);

The kernel build robot signaled this one already. Will send an incremental patch
asap today.

> 
> The pointer bio is not initialized and yet is being used in the call to
> function dm_is_zone_write where pointer bio is being accessed. I'm not
> sure what the original intent was, but this looks incorrect.
> 
> Colin
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

