Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89655C47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 22:11:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D17D61019
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 22:11:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D17D61019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-AbMDW8OjPFWXQlU-T2zBJA-1; Tue, 25 May 2021 18:11:32 -0400
X-MC-Unique: AbMDW8OjPFWXQlU-T2zBJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98BED8015F5;
	Tue, 25 May 2021 22:11:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED8D36062F;
	Tue, 25 May 2021 22:11:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 814E35534D;
	Tue, 25 May 2021 22:11:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PMBOtU006467 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 18:11:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2A1E310F8E3A; Tue, 25 May 2021 22:11:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 251631033C70
	for <dm-devel@redhat.com>; Tue, 25 May 2021 22:11:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DB58101A55F
	for <dm-devel@redhat.com>; Tue, 25 May 2021 22:11:21 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-17-fO-SG1QHMEGEhy7_PhemiQ-1; Tue, 25 May 2021 18:11:12 -0400
X-MC-Unique: fO-SG1QHMEGEhy7_PhemiQ-1
IronPort-SDR: fXaxEMgMHGlalEbhlcF00jiuD6qLIOKo3A3sIjyZ3Bhsd+Q9th97NPidQ+rQLc7AchWFYqd1Fx
	s6Nso0UnJUu+DkGMoq45Re5BGZPol1viHtzEIgYzSSRllAt3LPteZgeiN+Wpn1V56wVIEyCtDB
	B3S5Lba4W4FZV7Vy6JH5kohasMAWI3ZmwG8HaXE56LbfABkjUWItyDMANxLlHr+nnopGytIeHC
	h8IweDr/+KSuj690de3s0i/QnwaUg9ieoGvAfuhkeN1CBtgVTOt8ZWQbccks/6Kdpi4pGRUHB4
	FQ8=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="273317354"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 06:11:25 +0800
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
	by CH2PR04MB6585.namprd04.prod.outlook.com (2603:10b6:610:65::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23;
	Tue, 25 May 2021 22:11:09 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
	([fe80::4506:831d:3073:8a57]) by
	CH2PR04MB7078.namprd04.prod.outlook.com
	([fe80::4506:831d:3073:8a57%9]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 22:11:09 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Thread-Topic: [dm-devel] [PATCH] dm-kcopyd: avoid useless atomic operations
Thread-Index: AQHXUZ8ypEgajDahj0Koof5HFKVHeA==
Date: Tue, 25 May 2021 22:11:09 +0000
Message-ID: <CH2PR04MB70783B1B24BD10E2BE380D1FE7259@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <alpine.LRH.2.02.2105251548340.29706@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:11c4:96fb:3c8e:5a63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 002308f7-80c6-4262-e484-08d91fc9fffd
x-ms-traffictypediagnostic: CH2PR04MB6585:
x-microsoft-antispam-prvs: <CH2PR04MB6585BA4AE839FB8A4FA5A3C5E7259@CH2PR04MB6585.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eB1sJh4EOcMkA2EyUMJQ8EbqOmttFXWILeVnbcKEsIpOM0Sw/YexbtUhdMj6OCFj6NgBGXM1zLquD+CBTlw3l9Lm0v+j870+xTka2fp24+bKV07v8G1RPh1KWhM3asDVReMNWA7UCzfEzwPjDNahCjcZafvQewGQEOE/UzzTgcQwmjHTFyIe626gxKx1ToMDs5qoL4bbP4fstdVUyRAxWnkCYoL/O6qO3P2bw10QA4MbnIAKZqRFGwtco7jmP/TMXP697IaIkLDg6eq2F0bU4fqpGS+GsQmxk9ynJwD/40ZumLFIh4qonzNUbzk6cQpzg7aslqrDVzvB6YyQIZfbz6bCMm6h2HK6x96XzlJwXHLjJ/WAF2978v1wTczO8myEpiuEiGz+4m+JvpgJ4qVIKq9TiEoGN92BDMWZ4ZNObUMSfWQ9eHeAyTl6oF4/xbwE4TutkD1HrddEMBIU3jEP8ZPAfysAQx9hS+wGBNG0NogjJOh1Vo3iu+raw57T2BPjKWHShIUgXwxbjogNNen9tM1BhdDp7QCMh+be1oLckBBEDt2zQW7UJMT6JyN5wPQd828EpmBgl4sefMbCmIDlSFSyeuvSXyDMudqs48KzglHAe5thCY8jf9yJwn3W+Z2iGgTjsgPi6Doyz4sxzRkenxM5/zidL1klZEm2gMwzwdsI1THbJVeOkQWa4phmb/5yPC/WQL35O/fyNee3Uve0WOqyz+UKK2A+4UML9j93Gf4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB7078.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(110136005)(86362001)(478600001)(4326008)(5660300002)(450100002)(66446008)(66946007)(66556008)(76116006)(55016002)(64756008)(8936002)(2906002)(66476007)(91956017)(316002)(9686003)(71200400001)(38100700002)(122000001)(83380400001)(186003)(966005)(8676002)(6506007)(7696005)(33656002)(53546011)(52536014);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rI+V0UXiCIktot9lkm8ovSvz58cIaCYUUx5r0zbral4n2Sko/rv0zHGLTkHK?=
	=?us-ascii?Q?B3JJbkU2+wjsYxvP5KsnxkMTpLSTx3Jh+DIK8sc0BVZcbipD56terwXbU76S?=
	=?us-ascii?Q?WNwa4F7cG33MNa06v1XkzZ0JiKr6wftygnZYYBhGYq368ZvC0WJsW5Bw7NuL?=
	=?us-ascii?Q?940Mecb5nA7RldyBxrlamPXKsMPf1veZGveYU1/70asyjVexIJgtofOHxze6?=
	=?us-ascii?Q?5F5GaKj+UUhOObKhvyx2711O5f9cuuFu2QbYwA3NlxdBfWx6gnIqWiIBrhSG?=
	=?us-ascii?Q?8mB7gbbXkenH6awMcjB/DAKjwptTSvifHdv04Ssgc1cxh9VvWEoXsZhkNQc+?=
	=?us-ascii?Q?bSHI6sYtS4lVR5/r+OcWZV/1YLzOs3cRPFvbzxmF3F9baddSnSrXNq2CC6B5?=
	=?us-ascii?Q?spk9kgEFc0eWlBG9PFvkCmCGSIynAJPBYEGvNgjHUgRrZ+M2eRDe7AD9RCQ0?=
	=?us-ascii?Q?Cx9/8hsf1sPYFewLVB4FtMvSDPtOHKbjAJKSzcs/i0j/gEk3jlrMoNISw6ZK?=
	=?us-ascii?Q?+VmV866eDUVD+blc8WgvrS3KsQ6GUQbw0GXIyIX8BDUTwJyzHgr6Q6z5RVUV?=
	=?us-ascii?Q?3T2lqcZhdyFIEA4OplOjztLGYuVeJiPqR+3TTsin38SikkLqJyODdK2m2gq3?=
	=?us-ascii?Q?wqTp6UBQ88u8R8sKcphLgaAgoM3R3YIbrJF8BRKXJ/jEvR06ChbuJdPULBKZ?=
	=?us-ascii?Q?7EoWjto0DlptAXVTws6dbLmzBUMi4pQjq4o7B+55YPe5zA2t55vZGIm9gLnx?=
	=?us-ascii?Q?0yMjrFlhHwQ79XrnZmdGCLERf3oIqAAyoWX9tT1lR6o39tfxcPNusBSsETgI?=
	=?us-ascii?Q?CVSt4h3v44X5dFLgGWAckwjGrayn47l8TTp+CoZGB+4Pv/VorDbqrLsjcS+S?=
	=?us-ascii?Q?P+/pCyjIshEwRWcSy3rTEhVVuSHlcIwCUn3C+fXh87+m4moj9mVV+SSv1+nn?=
	=?us-ascii?Q?4Jh0lQQ0bAYkmdjawW5CvuyLstYTJaq8dfS0tWbSlleGEuSV9hhkHuE8mZJW?=
	=?us-ascii?Q?mtc6+IL1OSZFAqvWJPCOd/dNIDoUuIHfPUfy7LfMrBADwqITEeioWzm/Es7L?=
	=?us-ascii?Q?3iXdI4EoUY522RLjm+8trCBXoJ10ZLZbb1k6JWvmKaLt7a96kjdujqDGIQHi?=
	=?us-ascii?Q?3jTqBWOfNUHNEd3xB2xvfpBPnadPF+s4j9/LwaVxz1d52T+3B6KvbOPBNlUy?=
	=?us-ascii?Q?Dxq/jeWzz3869bfNTm9Cw7krkOcHtRLmD8Ptozq1KjftN+EQjdiTK77h/sK2?=
	=?us-ascii?Q?7EoLzvbylvQpHecHnx23qAlx9qvg5qErSla7x1BLvl0LiP2EimvgMeXaFf0d?=
	=?us-ascii?Q?xLup3JPFkM5mTzKMmZh6v0EX3jp2NxNsEsxI40aCKU3wg/tHIvj6K4SVvih2?=
	=?us-ascii?Q?ExS5WbMH6NnJ5UfQhBTjfHyhJI/PEGlFtalZsUVEC5WomVg/+A=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002308f7-80c6-4262-e484-08d91fc9fffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 22:11:09.2018 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6IcAFVzlAN1XkppBf1792hoW63V22ckdbk2IGpwjAn43jywuJWfvw0q1hZWCIEjwUQrZLxxAem6CRiOoflDGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6585
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14PMBOtU006467
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-kcopyd: avoid useless atomic operations
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/26 4:50, Mikulas Patocka wrote:
> The functions set_bit and clear_bit are atomic. We don't need atomicity
> when making flags for dm-kcopyd. So, change them to direct manipulation of
> the flags.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Index: linux-2.6/drivers/md/dm-kcopyd.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-kcopyd.c
> +++ linux-2.6/drivers/md/dm-kcopyd.c
> @@ -812,7 +812,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
>  	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
>  		for (i = 0; i < job->num_dests; i++) {
>  			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
> -				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
> +				job->flags |= 1UL << DM_KCOPYD_WRITE_SEQ;

How about using the BIT() macro ?

job->flags |= BIT(DM_KCOPYD_WRITE_SEQ);

But I know some do not like that macro :)


>  				break;
>  			}
>  		}
> @@ -823,7 +823,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
>  	 */
>  	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
>  	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags))
> -		clear_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags);
> +		job->flags &= ~(1UL << DM_KCOPYD_IGNORE_ERROR);
>  
>  	if (from) {
>  		job->source = *from;
> Index: linux-2.6/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid1.c
> +++ linux-2.6/drivers/md/dm-raid1.c
> @@ -364,7 +364,7 @@ static void recover(struct mirror_set *m
>  
>  	/* hand to kcopyd */
>  	if (!errors_handled(ms))
> -		set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
> +		flags |= 1UL << DM_KCOPYD_IGNORE_ERROR;
>  
>  	dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
>  		       flags, recovery_complete, reg);
> Index: linux-2.6/drivers/md/dm-zoned-reclaim.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zoned-reclaim.c
> +++ linux-2.6/drivers/md/dm-zoned-reclaim.c
> @@ -134,7 +134,7 @@ static int dmz_reclaim_copy(struct dmz_r
>  	dst_zone_block = dmz_start_block(zmd, dst_zone);
>  
>  	if (dmz_is_seq(dst_zone))
> -		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
> +		flags |= 1UL << DM_KCOPYD_WRITE_SEQ;
>  
>  	while (block < end_block) {
>  		if (src_zone->dev->flags & DMZ_BDEV_DYING)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

Either way, looks fine to me.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

