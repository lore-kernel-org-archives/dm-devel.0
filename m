Return-Path: <SRS0=txmc=K3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21021C47080
	for <dm-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:57:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 95669613BD
	for <dm-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95669613BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-MoPDDZAXMOqakgJV-poEjw-1; Tue, 01 Jun 2021 18:57:27 -0400
X-MC-Unique: MoPDDZAXMOqakgJV-poEjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AE52180FD64;
	Tue,  1 Jun 2021 22:57:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A80001A865;
	Tue,  1 Jun 2021 22:57:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73ED244A5A;
	Tue,  1 Jun 2021 22:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 151MvDsN008125 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Jun 2021 18:57:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 258BAAECAC; Tue,  1 Jun 2021 22:57:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F79BAEC95
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 22:57:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D08C180D0E0
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 22:57:10 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-113-eN3BI5afOHevYH_lTG2GJg-1; Tue, 01 Jun 2021 18:57:06 -0400
X-MC-Unique: eN3BI5afOHevYH_lTG2GJg-1
IronPort-SDR: 3Sk7pd7BYa3+vlOYX2wdzww/CD3u5KnfiKsyOn56zYpP6pweDPYt1M1SFBQoTIvhROgoZtIIb0
	8ZD3t/CZNCp1VMNuBboNBCZhPfdv0KIckxFOU+gOiV00NEZMhrBkV6qmrEKiC6xE/J2jO60O3E
	6Y1tSIaMun3l/B9SFgC+jebiKWkhFNUpfSSoCKPt+tZoukvGL1GHXDjIV32NxTOPkWRj7SIouv
	TXEYnG+w9WEW8lQpDfT1K/+IfNT5cb5v23xTrgjCW39NYaEMKDvYSxerzpuSCP3m1ygz/Q5JVV
	AXQ=
X-IronPort-AV: E=Sophos;i="5.83,241,1616428800"; d="scan'208";a="274211773"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
	by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2021 06:57:12 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB4826.namprd04.prod.outlook.com (2603:10b6:5:29::17) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24;
	Tue, 1 Jun 2021 22:57:03 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.030;
	Tue, 1 Jun 2021 22:57:03 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer
	<snitzer@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH v5 00/11] dm: Improve zoned block device support
Thread-Index: AQHXUaxyAuyK4c4Z+0yqEP2QqnaCJA==
Date: Tue, 1 Jun 2021 22:57:03 +0000
Message-ID: <DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:8d7b:9386:76d5:60d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c0f75cd-f9b2-4b95-9587-08d92550925f
x-ms-traffictypediagnostic: DM6PR04MB4826:
x-microsoft-antispam-prvs: <DM6PR04MB48263B9C1729C5600F71F622E73E9@DM6PR04MB4826.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1060
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Qh6mA7erlg7tVeBdR2B1LyLA5tUJGQb7RpUIHxiZRajK8zPvQK+4hAi5Ggu5cPy4ED+ynD9Cfc4Mp8b3j4tt0/iF2pyfbvonh1/NsNZz1E9E2oYLBWREvQ4R1WiyHzGeeN39BDaFhFVDkZd++fsHwFaCYh204F3cSKL4kZuVnb90JKviWt3FnMnjz3OW0pcLIauTzFH2vCp415EW6GpbSUPusDbMlS4Odpbe9NORKbyx7DbMWROPOgdKG6nNSnK05dd0PEpy++Twd69/bXtsZkTHX7kzcoppNop5jnv6zmwJ47XJ5qhkf4ZWFy0QiI9GpXe5PO+cYtztAgCzPjA9tSxRC5aWZzjLU8fvcq93d5H/JfI1bRHOznwNm/dskjjiWOF+0BX+ZIlyjj1DOnWAj2cD38rvzvyZ05K7lihGLxg54xPHg+tIPPzsBXM7u/usGLLpgcJ8ERPRM7LCNkPbpJR5b3EzEjAaUHFNcBwpAmwCFIRYkuJgIhgLOBSlSfRRXiBcU/RlCwCaHoF+WcGaugD1teyH2bhGmCPmkNAvHtnnUzjR5vrN76OgZgUqE5PTU+oq7XQN3XDZ6vsvbwr3B2v67eS7bhOenyTo7FGsnJE8MA2TmvLjUjFu6tLMKFRY8F05s9T8065MEus90Vv6/w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(55016002)(8936002)(53546011)(8676002)(71200400001)(478600001)(66556008)(2906002)(64756008)(9686003)(76116006)(110136005)(66476007)(7696005)(122000001)(66446008)(5660300002)(38100700002)(33656002)(316002)(91956017)(86362001)(52536014)(83380400001)(66946007)(6506007)(186003)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?s9gxgBUuxKbh6qpahKDOI87/KpEljevV+WbHeGpRV2ImI5nPUU/HAZkDXqsY?=
	=?us-ascii?Q?ZoJTeVgzz1YnBHM3jlXbRGFwAAU1GMeICpDaf5c8ttJQer0UlM3Mqq9pAcdY?=
	=?us-ascii?Q?/UWgEQ58X8Rz3yv1WlUbU8a951NKcTJq4UwOzIxbOBtIFaaFpkszA3kXRftm?=
	=?us-ascii?Q?HSVHNcdwE4t4wuBHfHo1InN3ExP9BUFChxJIk0cljIclj7163xgpK8izKnva?=
	=?us-ascii?Q?Y4th7ehWreTWfJ9RjiNErMm1HlAwT2ga5yCtqXOKP7M1Xokn7ADJAuWN6wJf?=
	=?us-ascii?Q?zZfVXJ7ZZkrtGZ6r9KiPxOp1suMpFAMO/q2WFNcu/mDY6ST8ougpeY8+SoCd?=
	=?us-ascii?Q?zSlhAQdxOvBUSddq+FkYJ4+x9Qfgms+F0rZhE2tT+lKHPRIEATiTzOPGZprL?=
	=?us-ascii?Q?j4KMuGnuWScbpglCe8d2fmMtTFjhdYxW5ouDXNmFEaoQeoDocgxI03KGkgvo?=
	=?us-ascii?Q?bLaRZjeMna9ge+CWYVFqguAg27+umr4+l/ithehPL2ADjWdOQdUETK90TFOF?=
	=?us-ascii?Q?chqOWC1QTyOdxHJ6ny6Wzzgmq7XeajcHamc/9m8JG4ksBzwO06YvPWf010l5?=
	=?us-ascii?Q?lV5VUHV/k06FyKGHlRoFFF6ZdADRLtK204L15NFG1gLZ/KoRhrQuYZOxMWBn?=
	=?us-ascii?Q?rt4M7REV2S4sVAbZS4xOBxUftl5ZZnlxl+vH//3LxWXcC676pSVIc/NLgKS0?=
	=?us-ascii?Q?wjktXFkRIya5NRXXeD4xEJy/Og0sM+5lmj+sF2r/Z2xRHoYXvwiiCxCj1BwP?=
	=?us-ascii?Q?PGqi5HHZnO6H3J/reKfjoYENt0jfeZvAmMBsYnjS0JFV9a32sOtalLcKLIpM?=
	=?us-ascii?Q?JlS8TrChVPO1E0KUzEUKD6uXLb4LTdpEvqR6wHGO87JH95Hb1ODiH5oGO/SN?=
	=?us-ascii?Q?nlLFM3mE9SoBqKX0rKVICgLaCmVbKWgrvdJoyqqhc7D/jGFlmG5AfdJdEgIA?=
	=?us-ascii?Q?oBZKdYyzlniZDurBBNoanMQVpIR+c3I21a6OJye73etuYFdtBQVyq/Qcgk5s?=
	=?us-ascii?Q?KQWJ8V0qZyNuDlBnZlvGv57OiKuR1Vh9VP+SXuMy4SXLW1rh2R0dUQtoUEO7?=
	=?us-ascii?Q?we3MVotwoyVwHXtTCB+cixTveqxGhPqm4M8OO9guudLWWYoqZ/qyXeUx4GsE?=
	=?us-ascii?Q?dgRCYqloYOlX+5vXkNxyZw2QuVMxdBOO3QIwH+ZKZRUuTDgDx1nb0NxMSaT9?=
	=?us-ascii?Q?FpJYY/T8sbY9ngsH9nKOZikbys9wfvjMAwPVTw4zhSYhrIVu/zALEW4jfFJY?=
	=?us-ascii?Q?rHbsO6+inCXvEEOvKtsy3fNb47JARUuHB/7CukuIty/yIlqRuLnp7pIFSSaB?=
	=?us-ascii?Q?9PaeXOfue2GEeEp4QGp+wOL04uRX5k3eKn4OPbJybdHACgHPjk4auy9S5utE?=
	=?us-ascii?Q?xwWy32DiLj3gaG72z7lD1TWoo17k/CEHXYy33Y02RfI/2ZHPGw=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0f75cd-f9b2-4b95-9587-08d92550925f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 22:57:03.1690 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxsFi+1eEhsR4hr8jSzOiCQOf6Q7HVs4MLul2PXLbyDQCTE7GuNKQsI8d4lDiNtGCjKiIuBXhFBorRi7GcHSag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4826
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 151MvDsN008125
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v5 00/11] dm: Improve zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/26 6:25, Damien Le Moal wrote:
> This series improve device mapper support for zoned block devices and
> of targets exposing a zoned device.

Mike, Jens,

Any feedback regarding this series ?

> 
> The first patch improve support for user requests to reset all zones of
> the target device. With the fix, such operation behave similarly to
> physical block devices implementation based on the single zone reset
> command with the ALL bit set.
> 
> The following 2 patches are preparatory block layer patches.
> 
> Patch 4 and 5 are 2 small fixes to DM core zoned block device support.
> 
> Patch 6 reorganizes DM core code, moving conditionally defined zoned
> block device code into the new dm-zone.c file. This avoids sprinkly DM
> with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.
> 
> Patch 7 improves DM zone report helper functions for target drivers.
> 
> Patch 8 fixes a potential problem with BIO requeue on zoned target.
> 
> Finally, patch 9 to 11 implement zone append emulation using regular
> writes for target drivers that cannot natively support this BIO type.
> The only target currently needing this emulation is dm-crypt. With this
> change, a zoned dm-crypt device behaves exactly like a regular zoned
> block device, correctly executing user zone append BIOs.
> 
> This series passes the following tests:
> 1) zonefs tests on top of dm-crypt with a zoned nullblk device
> 2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
> 3) btrfs fstests on top of dm-crypt with zoned nullblk devices.
> 
> Comments are as always welcome.
> 
> Changes from v4:
> * Remove useless extra space in variable initialization in patch 1
> * Shorten dm_accept_partial_bio() documentation comment in patch 4
> * Added reviewed-by tags
> 
> Changes from v3:
> * Fixed missing variable initialization in
>   blkdev_zone_reset_all_emulated() in patch 1.
> * Rebased on rc3
> * Added reviewed-by tags
> 
> Changes from v2:
> * Replace use of spinlock to protect the zone write pointer offset
>   array in patch 11 with READ_ONCE/WRITE_ONCE as suggested by Hannes.
> * Added reviewed-by tags
> 
> Changes from v1:
> * Use Christoph proposed approach for patch 1 (split reset all
>   processing into different functions)
> * Changed helpers introduced in patch 2 to remove the request_queue
>   argument
> * Improve patch 3 commit message as suggested by Christoph (explaining
>   that the flag is a special case that cannot use a REQ_XXX flag)
> * Changed DMWARN() into DMDEBUG in patch 11 as suggested by Milan
> * Added reviewed-by tags
> 
> Damien Le Moal (11):
>   block: improve handling of all zones reset operation
>   block: introduce bio zone helpers
>   block: introduce BIO_ZONE_WRITE_LOCKED bio flag
>   dm: Fix dm_accept_partial_bio()
>   dm: cleanup device_area_is_invalid()
>   dm: move zone related code to dm-zone.c
>   dm: Introduce dm_report_zones()
>   dm: Forbid requeue of writes to zones
>   dm: rearrange core declarations
>   dm: introduce zone append emulation
>   dm crypt: Fix zoned block device support
> 
>  block/blk-zoned.c             | 119 +++++--
>  drivers/md/Makefile           |   4 +
>  drivers/md/dm-core.h          |  65 ++++
>  drivers/md/dm-crypt.c         |  31 +-
>  drivers/md/dm-flakey.c        |   7 +-
>  drivers/md/dm-linear.c        |   7 +-
>  drivers/md/dm-table.c         |  21 +-
>  drivers/md/dm-zone.c          | 654 ++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c               | 201 +++--------
>  drivers/md/dm.h               |  30 +-
>  include/linux/blk_types.h     |   1 +
>  include/linux/blkdev.h        |  12 +
>  include/linux/device-mapper.h |   9 +-
>  13 files changed, 954 insertions(+), 207 deletions(-)
>  create mode 100644 drivers/md/dm-zone.c
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

