Return-Path: <SRS0=Ppzu=GG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8157BC433E0
	for <dm-devel@archiver.kernel.org>; Sun,  3 Jan 2021 23:13:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E052A20784
	for <dm-devel@archiver.kernel.org>; Sun,  3 Jan 2021 23:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E052A20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-hO_o0nhmMkq4k_niiTLpTQ-1; Sun, 03 Jan 2021 18:13:39 -0500
X-MC-Unique: hO_o0nhmMkq4k_niiTLpTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2449110055A8;
	Sun,  3 Jan 2021 23:13:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4F3D6A8E6;
	Sun,  3 Jan 2021 23:13:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6069D4A7C6;
	Sun,  3 Jan 2021 23:13:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 103NDOCA001816 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 3 Jan 2021 18:13:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E76919E61; Sun,  3 Jan 2021 23:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE7FF8145
	for <dm-devel@redhat.com>; Sun,  3 Jan 2021 23:13:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3EF6858EEC
	for <dm-devel@redhat.com>; Sun,  3 Jan 2021 23:13:21 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-413-4dA_y3AoNfyXh6yKvIsfqg-1; Sun, 03 Jan 2021 18:13:17 -0500
X-MC-Unique: 4dA_y3AoNfyXh6yKvIsfqg-1
IronPort-SDR: ix4I4ViaQhlRwSbxKpQr155lohJS61922tKx59scDaTCELuhUFQg68aQe9K/O5kO9/JwzZI6et
	H3CKRS/pODO+rwu/bNBAPGfK4JYTBwErY5f/AWLcSojl//AdzRFfM07vPzqCHggVwHAsCgzWpu
	JHSDy69QylAHgERp2wb//QvsRzPHNuig6C0p+rlbaCZoIKX+V5wFBY2eZrJ/rVyUosueCK03z7
	90RmCSYMy/vxrmM5GaTjNSlkRorDzNoPW1hJw41Ccc0s22LbgkZ44SfsipEBIwgHtt98BTGPjP
	Jb8=
X-IronPort-AV: E=Sophos;i="5.78,472,1599494400"; d="scan'208";a="157644129"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 07:13:14 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4643.namprd04.prod.outlook.com (2603:10b6:208:4c::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19;
	Sun, 3 Jan 2021 23:13:12 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024;
	Sun, 3 Jan 2021 23:13:12 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Arnd Bergmann <arnd@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike
	Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Song Liu <song@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Hannes
	Reinecke <hare@suse.com>
Thread-Topic: [PATCH] dm zoned: select CONFIG_CRC32
Thread-Index: AQHW4hk3MoWMUn1z2kOBENbDHLE7zw==
Date: Sun, 3 Jan 2021 23:13:12 +0000
Message-ID: <BL0PR04MB651478B53B0D808BC1C557ABE7D30@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210103214129.1996037-1-arnd@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcf0a944-d935-4b7c-104f-08d8b03d24ae
x-ms-traffictypediagnostic: BL0PR04MB4643:
x-microsoft-antispam-prvs: <BL0PR04MB4643BB72E81F068A8D3EB216E7D30@BL0PR04MB4643.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AVpDQq84GWyrVmbEU/odaPd3bOKQeaIqI19nDgM1MNX9mlE1X6e+b62JMrL/i3BdN0w8zp0BkHha+1j+2g7TUHFIHROmww0SI+8xdgkQbj/WJFGniFBFo4FT8VdD9fILrlJRBaIZLShaxNSQzOZ/CotCGLFWz01IEza3yTt1QK7xTpW+qKeHifBvbmesWiEdpHCQ/jw/I8R52AmVLphxZThKuDmEgZrs0fcL1KbbdjUA7YBKrPPtE/ZyzhYkBRKkFe1K3c8uirXEoreaeNVQG5uXS4GY8oSHvgRhKssPkEPYVmCDPS/qWMQnWLR9phxzmZ0zDenIyidWFtVX5LEloF+OwRhjoAt2meA7c58kw19daQqt5TVC+XHPU69Uu2gMFlKD4uSLY28gBGNBh+a/Mw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(316002)(52536014)(64756008)(66476007)(110136005)(5660300002)(8936002)(7696005)(66946007)(76116006)(6506007)(53546011)(2906002)(91956017)(66556008)(7416002)(86362001)(66446008)(54906003)(186003)(33656002)(8676002)(55016002)(9686003)(4326008)(478600001)(83380400001)(71200400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XuBcuqftDGm4qs+Nt1qGUa9lQGRW/x66oQRiR8bfYij4ut3G3KbEfMOPb3YA?=
	=?us-ascii?Q?y4mK+htE4QuA7nUf1syxYObydmbYG96vmZaQLm/kW+vbQ9851Rde3fbZEIyd?=
	=?us-ascii?Q?aVzIh+7LBPYwDwnCryTL8Kx8tpg2/p5LfBn4W+M7Ko6SLPZaJK38mr1e1DBe?=
	=?us-ascii?Q?GwQjTAvpogEoxHkZiXm1ihTDeQSqcPQRkOJ2lQ3fYc0hOyoNc00MOd0yy6pW?=
	=?us-ascii?Q?kVk+edEVsLsLzNexcWTIVB5C0xKedn/vEIO0DUptM5RIJN99KehGY0DnbXq5?=
	=?us-ascii?Q?64e+Ru9LvqpR5rCzA1xwMrB/C/0bffGVoPQpz9DXx5siilJ4uAi9Q+1zSc6F?=
	=?us-ascii?Q?niwfxrdGxXJnnzWJZbGyNtwF5sEK5fBxsed01hnsnSjjXXbxnrfZo+SZUo3L?=
	=?us-ascii?Q?Xzyqpaf2UPUiSZ/dVyT7YmF7IuflzKCFoRAwMeKBqMcCN2FNmYTJjIF8sefP?=
	=?us-ascii?Q?ZiSvE1dmxgsgoyumaddhTkUA/7BxcVS9hKNWR3dTfTnEVchY47fOFZ47Ak1l?=
	=?us-ascii?Q?e6/zX9G8bHbMi6ZHn2/8edEgfZPIt030H0yXcrSkx0YX0hV6WquzzzcbDIuA?=
	=?us-ascii?Q?lc2WqeSe1R4In3tRNGbS0efX+N3HyR24/+OvJGTPt8BhtTqmQgLRjUGGfb6w?=
	=?us-ascii?Q?NH2FhoVWdMyQcAEIYP4T++vZCJrpNzzkKfmR+8u6saND8bw7T+wZ0QMu0lBG?=
	=?us-ascii?Q?YswigN6zLZN1uBUxnLnFdtpUj4SkWiDvYetGifTJcaY4zy3kUhqG8REc/r5n?=
	=?us-ascii?Q?Y9ahDpnvI6vl7R2lybRfwpJ8BbsGUsaF/vHGIDVg2WF66qjtygnXf/BHg+pd?=
	=?us-ascii?Q?/1ZJGqQAmY/sVSCjAJhRs4wi1+kGgNtpa7sv5gmHB6kwXIdvesqL49iyaFtf?=
	=?us-ascii?Q?Ow8p4zL3RQ/NMrCOPde8RRhEgzVUbVtVmCorjkLDxKP/pSzHdual3s1Yg4Ll?=
	=?us-ascii?Q?sASLpbcKiriX8ztzjuJQPoD7MpLBu7vVi61RL0YjU+L947H1Fo4Tawba6glN?=
	=?us-ascii?Q?jc1uObxW5e/U9thzxS19SxzGLS2xsmVNV7Z2hhXFnEs5PRknm+aHsPLP8W2E?=
	=?us-ascii?Q?UukPQhzW?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf0a944-d935-4b7c-104f-08d8b03d24ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2021 23:13:12.6511 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oW+Xs+2hgAMM+c/LEG4Jw049dHHjNgf0gc4rq7vK8Wny8tCCsTLOMv2bpWvluYBQRkz3/1TBWulrdEst7b0gOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4643
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 103NDOCA001816
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [dm-devel] [PATCH] dm zoned: select CONFIG_CRC32
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/04 6:41, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without crc32 support, this driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_write_sb':
> dm-zoned-metadata.c:(.text+0xe98): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_check_sb':
> dm-zoned-metadata.c:(.text+0x7978): undefined reference to `crc32_le'
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index b7e2d9666614..a67b9ed3ca89 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -622,6 +622,7 @@ config DM_ZONED
>  	tristate "Drive-managed zoned block device target support"
>  	depends on BLK_DEV_DM
>  	depends on BLK_DEV_ZONED
> +	select CRC32
>  	help
>  	  This device-mapper target takes a host-managed or host-aware zoned
>  	  block device and exposes most of its capacity as a regular block
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

