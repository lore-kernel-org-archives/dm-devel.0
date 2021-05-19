Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA920C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 75B5861364
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B5861364
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-YBnjcMfiMECK4frocthSnA-1; Wed, 19 May 2021 03:44:21 -0400
X-MC-Unique: YBnjcMfiMECK4frocthSnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A8B79EC5;
	Wed, 19 May 2021 07:44:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BABF25D74D;
	Wed, 19 May 2021 07:44:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F5E955352;
	Wed, 19 May 2021 07:44:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7bI8b022382 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:37:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B478E208AB91; Wed, 19 May 2021 07:37:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEB352087A59
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:37:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E0C101A531
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:37:15 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-93-EpmPRWqCM9KCZKwfczEOCA-1; Wed, 19 May 2021 03:37:11 -0400
X-MC-Unique: EpmPRWqCM9KCZKwfczEOCA-1
IronPort-SDR: gwUu7oYxS2oA0o5VD+pBu28qFy1Q/2V+B7Ni+XqoXtgrRpe+NR333GDEDxNAJWbpvNLleaBOGM
	Qw3HXAD1Asmf5fiwXgPu0qQW8Qe3PTIkQKO75mEbDmyoDeyJFlB/cFOwseriKjET3JBK+A+s9w
	TZgwr8Rua9FMZwj7dVKPV6ljrKNsuZhS8kKUxW1srfXVVLF75m6hTr5leoJlZW4WT/D+JNg6yF
	Fg397lGekqYxPkqxuSPlPSDpkK9xUfx8da5T5C5kSlewgHSc+IEAZgYzxzKywPznWAQUHP/YqL
	xhA=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="272618306"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:37:20 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7608.namprd04.prod.outlook.com (2603:10b6:510:53::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27;
	Wed, 19 May 2021 07:37:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:37:06 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH 04/11] dm: Fix dm_accept_partial_bio()
Thread-Index: AQHXTFqBI7R+p1e8XEaDRzyOjNXBNQ==
Date: Wed, 19 May 2021 07:37:06 +0000
Message-ID: <PH0PR04MB74168B8BB05002AC0445C6FA9B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-5-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:95b:718f:422f:1ec2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 069d437c-8c73-4383-f7a1-08d91a98e70e
x-ms-traffictypediagnostic: PH0PR04MB7608:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB760814F4380C6B8338E88B159B2B9@PH0PR04MB7608.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ixCQxuYM6glNg0Imem0DTUUtQlYH0a6++meLdwimMjBd7dAQAWSPEA9ZKbJ26dm31XMPSy/wbzP0DA18vFk+l69cYDwsgE/MdPJdI1xTw8kv2kWM9H5ACacPGl21ZdlFGim5tCF8xzw9COleIyLBZ1j8yJ7udyArU6j2xKqsXD+BRWsr5q/HP4z4jzd1iT0FaMNUtMh6pQzEhQDaofE8IOpzKwpnAIBHJqyC9qgnIm+OPtt2ttNLu9Y8RRM39O11Q/lhBgHLQDkvTxdjN8Cq47UBcQD47TZHoMjyslWCirJOm84mTgUJo+7wR2QLXIXjDPHYg3K2oBoZqbFTTdHK9e054Oiqwcd9/lM1o7/htL2aiqhIsooMU4z6rp0hDvpmYsSC6DTfBgDp5vqANPPKbyxEQJZgsWnygImQnev+sZAqBO0Ppey9pWvKpy4JdlJYfYRPbpi8qtIh0i9VSlhZLS52jY2V1r0cF4LkFBOm8z/xCrH0oqNtkMjH9J/tPEpEX1Qrpun1r+aV0rkOvNzd5QhzaVVzD8Ce+BumfxU4DFnD6Q2FSnjTUdUm/ztv23dK8dMem0qUWU3gaUw0pbL8zHmXwCcEMjwphViy2N7m2dY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(136003)(346002)(39850400004)(376002)(66946007)(52536014)(66476007)(5660300002)(19618925003)(316002)(55016002)(76116006)(91956017)(64756008)(66556008)(66446008)(7696005)(186003)(86362001)(9686003)(558084003)(122000001)(38100700002)(33656002)(6506007)(8936002)(478600001)(110136005)(71200400001)(8676002)(2906002)(4270600006);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fRBuW7YwdJ9KITnICCK43LAby6jbSIwhZdrck4KSRUv3LgGy+6xpnMYORNfr?=
	=?us-ascii?Q?nIWng6RFifObWjEiWLzALgVVsN9/gcYMbV3wAkCeui56SHtNs0zHx2uwL52v?=
	=?us-ascii?Q?nL0UQNdfSp7GSw/eZLHE21/kwxlAN7dAuZRS6jjsqXVulYGBvKdXygbWZMmv?=
	=?us-ascii?Q?3oIZxr9WPdIbJdQ277j3zBVWweAZMnbICqqMWbSu9ElfDlU9xHyGDy6ACaPC?=
	=?us-ascii?Q?us4TRtMSs6FasJI9IZZ/8uIP0c/je35Sm9uOnGujkW4ggY2Pnil0W7kt6edJ?=
	=?us-ascii?Q?ZZGRLWVDzPhXNszdXlrrxc7+nBtbPHXDN6sh69thso5dn4TYl50nT60QkpmY?=
	=?us-ascii?Q?CIKUkgK+eGnqoQpewVNzkKqEaC7+xHifOcdHTL9i/2owNVy8xpeyOye+ikNs?=
	=?us-ascii?Q?WhcGPh+PH6wi28/sscErGGc0YYdX1TotWxaKDy4t5/IIWbxFEovStzGbPvT+?=
	=?us-ascii?Q?7yZaJ8qCyy5YzGBfD86FvHZAX4Xyj5sF6UF/f0RTn2Avyzi3lev0K3V2L7xi?=
	=?us-ascii?Q?iO1D6TUJ/s/Hl2bRXV18cIrTBEQY+s/4rRFp/pdcPEGmQMCCENXoxVSMSy8H?=
	=?us-ascii?Q?8Nvsvgq7MslIXb2qBM9hFknxH5r7u/n8ViyRHpfV0cpIX9f+iaUHKnLi+muF?=
	=?us-ascii?Q?p9WfeJySMhg4wDYO54WuCfw588OVP+V3j/ZxhXODqsPTE9m1HYSIMa+uU11w?=
	=?us-ascii?Q?1sKODNYkb2ioZJB6rOEm5wBe1xxv6cax/ZPflKYrGG73ZEXlKcEtGw/qwzS1?=
	=?us-ascii?Q?1wAPn2Q2HIvdzsetq/KNy7rvomuPb7d+d5R+kxmTv7+vpC/weB2G19sPyU4N?=
	=?us-ascii?Q?l5GTn06aRgk+eJ/2idnVxH4UwKUKDhGkcbtcRfdEqAwi0AEnqdmagrIM8tiP?=
	=?us-ascii?Q?tLLYEtoqtIMLXyFeekI/WL/M4ewa06ejvP8lq4ATu5ThXewgf1aBuA6y2u08?=
	=?us-ascii?Q?CJwuSPFUrZPQ6jXTRXZcgEysc6uq9nUCBzpLpgfICL+pX3ZtbqSk9XTaGBCV?=
	=?us-ascii?Q?XHhI2Y1Npbq9cUkESg1c21OlGPyUvkniqowVBzhHjwkzXt+HXm2c+Y5kgmgW?=
	=?us-ascii?Q?9hTLQ+tWhx2w3JxmuwQ423ge0Fp6i6J4J9X0VQKKydNFWtOEX7+6VMGWlyoN?=
	=?us-ascii?Q?zMe4kwBtbm8MmUhwtWO0N9l7sBqjmgs67UvnH7bFuuYfqKWYBorw4xYQkcO5?=
	=?us-ascii?Q?1Q8ned1gaYKknVGxcpgpwAV/iZj7dzOAIXqB/ry+PMOFbxrDFumdkZRAdgUY?=
	=?us-ascii?Q?IIuGGND7TFclUGdrGm+TM1xvVg5Nguvqq0Gu2qf4Fw7hA25g/gQlHJZXoamo?=
	=?us-ascii?Q?YnjgvqLIxhapjQd3HsM38u2pnXH3rZnXxKMnwhiEQ3Wd0PXad1/KnHWfTuYL?=
	=?us-ascii?Q?ceIxqQ7Eyzx9xU9N2EL3y17P64HvmeaEmptnGO2Sq3yo3ldMug=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 069d437c-8c73-4383-f7a1-08d91a98e70e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:37:06.1911 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJmMABwpMnN3mOy9RhU0H8l00BDCZ1Hno4SBwgkaSFq+/2Fnoyiaj0jTns8rANitD9abV6HRsykDsPnN4S0ESnbsbtKDOf+3uWJ1cwi2GOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7608
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7bI8b022382
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 04/11] dm: Fix dm_accept_partial_bio()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

