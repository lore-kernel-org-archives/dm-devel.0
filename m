Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F384EC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 00:24:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21CDF64DDB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 00:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21CDF64DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-OdopCyelOYyeVLhXZw8i2A-1; Thu, 28 Jan 2021 19:24:30 -0500
X-MC-Unique: OdopCyelOYyeVLhXZw8i2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4C378030AB;
	Fri, 29 Jan 2021 00:24:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A88BE5C1B4;
	Fri, 29 Jan 2021 00:24:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0912A4A7C7;
	Fri, 29 Jan 2021 00:24:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10T0IUJC004407 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 19:18:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7E06F10D179A; Fri, 29 Jan 2021 00:18:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 791F210D1787
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 00:18:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7832F1875049
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 00:18:27 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-310-IdpgLvjYOpG2tsFqcHTqow-1; Thu, 28 Jan 2021 19:18:23 -0500
X-MC-Unique: IdpgLvjYOpG2tsFqcHTqow-1
IronPort-SDR: P57JIXpfDbk2LIXUMRdIR7J0zRiOz5bYFNPzRcArU8ShxXn8fRbariqSrQWWYcYBXr7AeAEX/c
	PYJvU+szREbBy62JAlc8P/2x+GuyB7PlKKIXWe40N9oLLMuN2EsWdIUiNWP1mpIX0VswzvPt0g
	yfiNprHP9AMBlHfpsMFl1G8ScDFXxWMzx4Xwx5Ck6+9NRBp2gkJbF38EtG5qjGmih3VIFQr42L
	QHR66h56GikH8bwNwj5WI3kjlI+z8sbAWB1gb4KwFmouHJoNLZNd+rm2zNofrkQZQSobF/oti9
	o+g=
X-IronPort-AV: E=Sophos;i="5.79,384,1602518400"; d="scan'208";a="158587777"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO
	NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
	by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2021 08:18:20 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6671.namprd04.prod.outlook.com (2603:10b6:208:1f0::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Fri, 29 Jan 2021 00:18:19 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Fri, 29 Jan 2021 00:18:19 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>, "hare@suse.de" <hare@suse.de>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>, "agk@redhat.com"
	<agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Thread-Topic: [dm-devel] [PATCH 0/2] block: blk_interposer v3
Thread-Index: AQHW9ZpYOoPcS4N3gE2Od1Hg8ibopw==
Date: Fri, 29 Jan 2021 00:18:19 +0000
Message-ID: <BL0PR04MB6514A510F37C59F52D87E2EDE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8103a45-f76a-4589-c4c5-08d8c3eb61aa
x-ms-traffictypediagnostic: MN2PR04MB6671:
x-microsoft-antispam-prvs: <MN2PR04MB667116131FAF1F092C2002B4E7B99@MN2PR04MB6671.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YxS/bunBBSIB9Mv8/6ICFgDQzMer68QYJxbrYTm8PsUApQ2M3XZnMZMTO3WWkRqTHfCFz8pFFYCdhu3Blxff+IjJ+YxMfD1XxcZ1+PN+WouEwDvYh61GoRgP/gRSiH/+GtFTQoUhSxQLFAUQMMkC4x6idtgaZ9l+jnIVfUkAd8WgjI5DToussKrokU2XGm0EmKdnbwHgkz00THk/MZUNCsdii3H81MLS+5/o8q1rTqxWzfXSwrF3xWrWAtzgf+ApEimmdK8tZqSTIVud7C11GZQKWx7i6XHHlARFbJR/ziopbzIhQiTw0WOgesqm3dX2lVBYAjMum2EUTlcIP2OwejX/qOwnBQcMd3IJT+MWltc8xDsWXFx5zBcf8pL7GOG41S0Hl5n91j9UwGHSMYaQhuQTA/C1C3ksHnddADxx/sZrRZka+MYH9EoZsGnXEzvQ8c/zjyKTYEy3l5xRv4xlSYc4DjH3/eaQfkZs9fQ/A6p7yJsTRaKejkQwtLJexjVIWXLNcONEBMEnwQ9QoCUrPA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(55016002)(9686003)(71200400001)(478600001)(8936002)(86362001)(2906002)(52536014)(4326008)(7696005)(33656002)(8676002)(53546011)(64756008)(66946007)(66476007)(66556008)(186003)(110136005)(76116006)(66446008)(6506007)(83380400001)(5660300002)(316002)(91956017);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wGKJIzdFKn80dlBxH38hcZUW0LUhQsdWSCpfECTDDIDCrNjLMzVJ8i3cos/G?=
	=?us-ascii?Q?/csJF4SVMvp8pCy5rha62MrUaNN8UheTLK1DcD5O8S4K1flNMYgZ5kpsuAUN?=
	=?us-ascii?Q?2gCrgmrF3lEqxkLovKZHdivlZsvyW5CGGK0j6VdWbHcb8SfnStV6FUvqC6GN?=
	=?us-ascii?Q?LsMJ/osBcM9UDxY35Jil1o89ek6Iw93T7y5NU+/RS3zelBOzu6bltloTXqny?=
	=?us-ascii?Q?FvyVVJxVwq9DR97gL5C6hkpeisSfKZHOhrlDGm7GugjBu9pUpnMiv2diQdCx?=
	=?us-ascii?Q?MRxcc4lEG9XrnNEdImLXaGZRMeUKpC7MAHdxlnS5AjZWtRz3pQ1rTom3VRZ6?=
	=?us-ascii?Q?rc52onk8FDKwGOE6TR2TR99JPX/Fapzl+1zVYCwf046y9BZR9DQkjEaRhhcI?=
	=?us-ascii?Q?4Ew5RfJ10X0hJlawWWb2a6jxtFNmeWIi/mMn14BWsTrXhv5p6tjuuIKyN3Om?=
	=?us-ascii?Q?/SZsb6Ye3tYJOy03jXNKwpqMJdxXaCzkT7ExJ8czkO21ZWqbqfqzGPb5iwHf?=
	=?us-ascii?Q?dtXkFvXiVty82XCmDwLmEGDhUriFQ6z+rX8xrJ95LHe05S2TutpmjQCpJfjF?=
	=?us-ascii?Q?lyrf2jzCPpd/rJpgWFAjxkvxZv2nnmOFpav5WOVV7y/TDixNhxPHj5Noe7EF?=
	=?us-ascii?Q?tIMCcGEoPdimoSAcmZAHTGeq9xlPnsh665GPDf8sjmoMOVreNiLDFQs9FRLC?=
	=?us-ascii?Q?RniLOJRIoJLcFMrpM0rX69TAtjZjf+aUMKKqf88C0nFOCuaKSfqLhWYihPP8?=
	=?us-ascii?Q?490VrcPkDyNI1/wFDqR4Zh9E2Vl67Lx2kWFE3UVHNJ+lpioM1h5+k2UTgUKt?=
	=?us-ascii?Q?PdBY4w4PcmZ9mjNBP5G0aqzLIEnbG+N83eSLc3QB9h7F2/V3Ar3lzVMElUTr?=
	=?us-ascii?Q?zDI0sM52cJMpp6+lgui/LAvlSOPfVSXRFhQ94VJ7uaNgby7h6Bs1nHZv9iwW?=
	=?us-ascii?Q?LPXe43E3LWVq6/AdFZyqNhabtnyhtoV850zlML2+BH6JDyW6vMD0KketnD9C?=
	=?us-ascii?Q?a3tv9ZqjOWr2mTd0gPwv7BsGam16aSul4T41yv9/33TmyTLCt++TZ6vtUOCb?=
	=?us-ascii?Q?dRDFlBGfOzJnDFYiLdf6JftGZ8wsk5j4YbGSp9yaJIBD34oyneIbBO6SChEE?=
	=?us-ascii?Q?Amb9JF+03SA9RR+PH90HyaDgFueFnP5I/w=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8103a45-f76a-4589-c4c5-08d8c3eb61aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 00:18:19.5002 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0NKIxynenoZEVZAtAy/CnX7erBkC0mBxFjLw/Dmjjs0NjNGBf0nplG09i4+aOgkiAV7+pwQoU8qJXfLWDcsMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6671
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10T0IUJC004407
X-loop: dm-devel@redhat.com
Cc: "pavel.tide@veeam.com" <pavel.tide@veeam.com>
Subject: Re: [dm-devel] [PATCH 0/2] block: blk_interposer v3
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/29 2:23, Sergei Shtepa wrote:
> Hi all,
> 
> I`m ready to suggest the blk_interposer again.
> blk_interposer allows to intercept bio requests, remap bio to
> another devices or add new bios.
> 
> This version has support from device mapper.
> 
> For the dm-linear device creation command, the `noexcl` parameter
> has been added, which allows to open block devices without
> FMODE_EXCL mode. It allows to create dm-linear device on a block
> device with an already mounted file system.
> The new ioctl DM_DEV_REMAP allows to enable and disable bio
> interception.
> 
> Thus, it is possible to add the dm-device to the block layer stack
> without reconfiguring and rebooting.

Please add the changelog here instead of adding it in each patch. And keep the
changelog for previous versions too (i.e. v1->v2 in this case) so that the
changes overall can be tracked.

The proper formatting for the title should be [PATCH v3 X/Y] instead of adding
v3 in the title itself. With git format-patch, you can use "-v 3" option to
format this for you, or --subject-prefix="PATCH v3" option.

> 
> 
> Sergei Shtepa (2):
>   block: blk_interposer
>   [dm] blk_interposer for dm-linear
> 
>  block/bio.c                   |   2 +
>  block/blk-core.c              |  29 +++
>  block/blk-mq.c                |  13 ++
>  block/genhd.c                 |  82 ++++++++
>  drivers/md/dm-core.h          |  46 +++-
>  drivers/md/dm-ioctl.c         |  39 ++++
>  drivers/md/dm-linear.c        |  17 +-
>  drivers/md/dm-table.c         |  12 +-
>  drivers/md/dm.c               | 383 ++++++++++++++++++++++++++++++++--
>  drivers/md/dm.h               |   2 +-
>  include/linux/blk-mq.h        |   1 +
>  include/linux/blk_types.h     |   6 +-
>  include/linux/device-mapper.h |   7 +
>  include/linux/genhd.h         |  19 ++
>  include/uapi/linux/dm-ioctl.h |  15 +-
>  15 files changed, 643 insertions(+), 30 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

