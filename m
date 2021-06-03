Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE5C4708F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:03:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEC5060E0C
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEC5060E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-cqf9vLl-PBGeeoOTOs3ZrA-1; Wed, 02 Jun 2021 20:03:25 -0400
X-MC-Unique: cqf9vLl-PBGeeoOTOs3ZrA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 291B2180FD6E;
	Thu,  3 Jun 2021 00:03:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03EA0100760F;
	Thu,  3 Jun 2021 00:03:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5582544A5A;
	Thu,  3 Jun 2021 00:03:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15303Dmm010997 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 20:03:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C19D1054586; Thu,  3 Jun 2021 00:03:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17052105457A
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:03:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA1CF801E8D
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:03:10 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-556-zZ0-1SS_OW-gzh2nZTaAdQ-1; Wed, 02 Jun 2021 20:03:06 -0400
X-MC-Unique: zZ0-1SS_OW-gzh2nZTaAdQ-1
IronPort-SDR: W+pM9c3WEE3G8gLrmlWjspm2iaURqDBu8wLzFjIKApQy9aOJz/cmwvfxmR/WYgARgB87BnzuX4
	jmpUzyjCuU7ReG2dtWniCfHie1jXMktOfUWk0XHS1g8XvtiHOV1GB8ZLie9H7RSUAFxGYlDT9K
	LQNWqBMuabmbv3L7br5CNQWMCrPKuIeeSPkBgMKH/0t96aqImFaLmecw8kPI3QsWpViWrXQxXD
	eWPY9QKDPmTm5n5kPGZa+6mfE5/EJp9agF1xA+8FecEMTuj3Z5aMCpSJL0/Z9mgVZ5dGdDJ0OG
	VIk=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; d="scan'208";a="274374623"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
	by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 08:03:26 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5164.namprd04.prod.outlook.com (2603:10b6:5:12::18) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22;
	Thu, 3 Jun 2021 00:02:53 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.030;
	Thu, 3 Jun 2021 00:02:53 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>
Thread-Topic: [dm:for-next 20/20] drivers/md/dm.c:850:43: warning: variable
	'bio' is uninitialized when used here
Thread-Index: AQHXV/Xjk92bICUcwEOz9raR25geFw==
Date: Thu, 3 Jun 2021 00:02:53 +0000
Message-ID: <DM6PR04MB70816EEC41ADCB7C4B18F9B5E73C9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <202106030532.LdwnXhpq-lkp@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:467:7587:9599:cace]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 250b47dd-ecf0-4fae-eb61-08d92622ef1f
x-ms-traffictypediagnostic: DM6PR04MB5164:
x-microsoft-antispam-prvs: <DM6PR04MB51640DBA475B647BE77E783FE73C9@DM6PR04MB5164.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pTGMz0PfNtpEso37lLlWNIStyR9GdQOU6hkvytWlubDKiPiZSmXPEIykaZv4BvSF1tNE00bC6Jz2T0B/XsnDIoJytn+HwicK0G6Gz7gnOIzOtSmLbHe6b6GpKQldxmrOZDuUS6MELzfru3orQtZP6hCTsuVyGEJ/O8sFr8RUVESfRAisoADKLHnIWwPNgPutNZJW6nE/SB0Qo7jyuLFgW57Sih+5BxZdjaojiyb1WtCIED+kAwsxlq4tWRFaD8MG8vbie8Z/WZJFwKuUmsq6s+Gxr7c+9N8DjHc88R04YfjruHWoOX4Qh0ssELrOvTnppzb7D/4E//RTFmA8gOiRSPW+wIuAGdLpBUuKlPeMSOGKZnth6yHPwfsYdW7xErsrLxN/ZxUau4PeVQsWEw+QhE6HMoeBDAryv4b/Yve9dQAv1cLCJTUAMaqgaedZrVhgvR0gZ8VHs/vmI+3Uusv7SnFE6XjbfRXcCnam30hdNJQa1rXp/vfwwOGfRGZ8oCbCyabNFd7ZaBsYkghApsyxNdFdy+4gCkyl6ZM8TmThLoQFWrAa0ZwE4+3FdrEyjKTS1hqDOGzh2/oQ7PRW0o/xJ0CAcSU7fAXj/yRJNC/CEu7+3NcNzjTmuXNDfCSBcbBiDyZQn6XhdcVqQLN/hSd+xXonx2PcDUmelj8Sgtz8RIfyhagrDlVF8KY39q/BRi7IXoxNBXNylQROp5jjanMusZUXw0tcVPGrDooO192uJFMBzusYdnN74t8bcZK5vXEICzfXUdcefkdeAAJGK55o8Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(55016002)(122000001)(66476007)(110136005)(54906003)(478600001)(8936002)(7696005)(316002)(38100700002)(6506007)(5660300002)(9686003)(71200400001)(83380400001)(8676002)(52536014)(86362001)(186003)(4326008)(966005)(76116006)(66556008)(66446008)(64756008)(53546011)(33656002)(91956017)(2906002)(66946007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JCTsg8hfReXbDmFI6NN65UVqwa7/ijyA8YnyaZ0BWfIX2yREwORpWscga4G9?=
	=?us-ascii?Q?CrAyDrigHw32wVT/tCGCppx1/Qe3x6oWRxRLnhauu2N/4xtHx1sdexMvnS5p?=
	=?us-ascii?Q?lOOnKn2gLUUfFi1dpn35dEInXBOuxZFh55jek5mgoLD4K1YCVbDSJT/4zX/w?=
	=?us-ascii?Q?UC72XtDQA5Mfy6jC31RaotM2lEAdEuSwgdsUlo1U7ug4H/2suKXXTkmcqcEs?=
	=?us-ascii?Q?a0YA1C7OZIsT0VoUOdPxtsrT6Hke68yuFwCs6h+UKewfd/Z7umTznBt6mEbe?=
	=?us-ascii?Q?6d3h+d/Po1E7ZaOdxuzM6bjCpzBdn/W9EMJuzKxIHqGljBhUh0RTiU5Yz/Yb?=
	=?us-ascii?Q?cTUqfJ8UBmyKPodCVc56abogqa9k/qTdd7BqJy+ta3atyHMxfWkVQCO45AnR?=
	=?us-ascii?Q?nAYDBGLusi7/SmUtOoNxkWd+o3ccji9nWGh2dzPd8mCNDT4myXvg4EMTgA3l?=
	=?us-ascii?Q?hdnKS+gQPkbm5vTn6Nvb1DAkQT1Q0i6KHpafjyoCw3tCSYacm685OW+dloIm?=
	=?us-ascii?Q?PCAtk9QQgpadMcAFJMyYdPbT1qtdT5KeKGL5C0P4BQVA8K2CxgK9Xx1WrlvZ?=
	=?us-ascii?Q?lbAeHjTAPaIu6aQUFyS1msloyS1NYOPF5ad6Sv6G0X/CTs9oRRgmeG404hWg?=
	=?us-ascii?Q?8lVaLfFk4X5lBlC5Nweo9jPpmvvIJwKPtAeYK1Ei68fgmEkfSFKY+qKyvFUy?=
	=?us-ascii?Q?3OlhLoEiNB/JS3Wmh1/FOEvHniK/2x6emNQoDmGebtjTmL41SVc3Dy3YjwQx?=
	=?us-ascii?Q?wn6tfJNGKM8lvVu+c7W0pjifAhRLK1AJ2VVN78m2/mdBOV4ciDsDaIf7SI4X?=
	=?us-ascii?Q?rWpXrp7E3DirMNJssQ0RlC2pBPqbi/rmV1lTO5/mC5CL2gCU9mmVqocZ/62i?=
	=?us-ascii?Q?PyOLZxHe7CwVoNUUPX/3ruLeTp2mslp+DhvuZAPPegx5ugGcWQ8vRG/9gjdY?=
	=?us-ascii?Q?AvIUhhsQNUtvMewfnyz8hC2Na8+E2t9lL0wlX3qAwgJQ+4wmCvwXE2508BHZ?=
	=?us-ascii?Q?a1enVcHF9BBPs7iYF9A0F0/TmCHhQCJBM2dCNvAACK8WNkqV7VYNMiR5cwib?=
	=?us-ascii?Q?kyW22ZIxpaRKv5RJc+T5aX8tJVIsXtoN3VQXIDTDT71K2zlzMQl/xXBcVUnO?=
	=?us-ascii?Q?AuiGM5jlCNLWKznZTE4bxfIVJKKtlqFqV6WIJ9YKO7f6gvnuAmffYjavfb51?=
	=?us-ascii?Q?vAYatRQX8gWK/cdKuyisHEjH5nT9cFFHdnmJHUmCFXh462VZos3KsYyM9e3T?=
	=?us-ascii?Q?pzevPnGSRZCJ3auzXFqkAJ70CS8RtHTC0umDfHL/J+3MPTwi14JMopFtznaT?=
	=?us-ascii?Q?2n1ihfrU0ztKYSXjAnUgojooAc0RkNyIgbG/+WUlI6o/PerZIKq1fe/nYZ7x?=
	=?us-ascii?Q?k7qimV7OzD4hPOMnccrTKf/zfKpEKLtoaijfFL66Glenhbs0/A=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250b47dd-ecf0-4fae-eb61-08d92622ef1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:02:53.1280 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7PrMJCykdnD+ya9DzoA036FdHQViguTyT1QjUPjEOCwlZDCzO4c9J/g0dXnVDztCBcXToRqVM0neMtDga9HroQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5164
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15303Dmm010997
X-loop: dm-devel@redhat.com
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [dm-devel] [dm:for-next 20/20] drivers/md/dm.c:850:43: warning:
 variable 'bio' is uninitialized when used here
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/06/03 6:26, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   2c243153d1d4be4e23735cd10984ac17c7a54531
> commit: 2c243153d1d4be4e23735cd10984ac17c7a54531 [20/20] dm: Forbid requeue of writes to zones
> config: riscv-randconfig-r011-20210602 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project d41cb6bb2607fa5c7a9df2b3dab361353657d225)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=2c243153d1d4be4e23735cd10984ac17c7a54531
>         git remote add dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>         git fetch --no-tags dm for-next
>         git checkout 2c243153d1d4be4e23735cd10984ac17c7a54531
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=riscv 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> drivers/md/dm.c:850:43: warning: variable 'bio' is uninitialized when used here [-Wuninitialized]
>                                !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>                                                                   ^~~
>    include/asm-generic/bug.h:102:25: note: expanded from macro 'WARN_ON_ONCE'
>            int __ret_warn_on = !!(condition);                      \
>                                   ^~~~~~~~~
>    drivers/md/dm.c:832:17: note: initialize the variable 'bio' to silence this warning
>            struct bio *bio;
>                           ^
>                            = NULL
>    1 warning generated.
> 
> 
> vim +/bio +850 drivers/md/dm.c
> 
>    823	
>    824	/*
>    825	 * Decrements the number of outstanding ios that a bio has been
>    826	 * cloned into, completing the original io if necc.
>    827	 */
>    828	static void dec_pending(struct dm_io *io, blk_status_t error)
>    829	{
>    830		unsigned long flags;
>    831		blk_status_t io_error;
>    832		struct bio *bio;
>    833		struct mapped_device *md = io->md;
>    834	
>    835		/* Push-back supersedes any I/O errors */
>    836		if (unlikely(error)) {
>    837			spin_lock_irqsave(&io->endio_lock, flags);
>    838			if (!(io->status == BLK_STS_DM_REQUEUE && __noflush_suspending(md)))
>    839				io->status = error;
>    840			spin_unlock_irqrestore(&io->endio_lock, flags);
>    841		}
>    842	
>    843		if (atomic_dec_and_test(&io->io_count)) {
>    844			if (io->status == BLK_STS_DM_REQUEUE) {
>    845				/*
>    846				 * Target requested pushing back the I/O.
>    847				 */
>    848				spin_lock_irqsave(&md->deferred_lock, flags);
>    849				if (__noflush_suspending(md) &&
>  > 850				    !WARN_ON_ONCE(dm_is_zone_write(md, bio)))

Mike,

This needs to be WARN_ON_ONCE(dm_is_zone_write(md, io->orig_bio)).
Or better, we can move line 863 below right after the
"if (atomic_dec_and_test(&io->io_count)) {" above.

Do you want me to resend ? Or can you fix it up ?

Thanks !


>    851					/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>    852					bio_list_add_head(&md->deferred, io->orig_bio);
>    853				else
>    854					/*
>    855					 * noflush suspend was interrupted or this is
>    856					 * a write to a zoned target.
>    857					 */
>    858					io->status = BLK_STS_IOERR;
>    859				spin_unlock_irqrestore(&md->deferred_lock, flags);
>    860			}
>    861	
>    862			io_error = io->status;
>    863			bio = io->orig_bio;
>    864			end_io_acct(io);
>    865			free_io(md, io);
>    866	
>    867			if (io_error == BLK_STS_DM_REQUEUE)
>    868				return;
>    869	
>    870			if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
>    871				/*
>    872				 * Preflush done for flush with data, reissue
>    873				 * without REQ_PREFLUSH.
>    874				 */
>    875				bio->bi_opf &= ~REQ_PREFLUSH;
>    876				queue_io(md, bio);
>    877			} else {
>    878				/* done with normal IO or empty flush */
>    879				if (io_error)
>    880					bio->bi_status = io_error;
>    881				bio_endio(bio);
>    882			}
>    883		}
>    884	}
>    885	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

