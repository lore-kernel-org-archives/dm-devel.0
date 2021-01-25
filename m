Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2235C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:15:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A49A2145D
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A49A2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-ajYwBXcaPo-i3XHj55iqMg-1; Mon, 25 Jan 2021 09:15:26 -0500
X-MC-Unique: ajYwBXcaPo-i3XHj55iqMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B581E1927807;
	Mon, 25 Jan 2021 14:15:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 822AF60936;
	Mon, 25 Jan 2021 14:15:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12D7318095FF;
	Mon, 25 Jan 2021 14:15:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PEFHAb003688 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 09:15:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1A441111422; Mon, 25 Jan 2021 14:15:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8441111A7D
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 14:15:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAA93800B3B
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 14:15:13 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-45-6bYZNWjNMZ2lUbFCRgoGjQ-1; Mon, 25 Jan 2021 09:15:11 -0500
X-MC-Unique: 6bYZNWjNMZ2lUbFCRgoGjQ-1
IronPort-SDR: qTagf3ki+EPA/XAMm7uptzJnwMYd+FUpsoAUPAXs2F5/7oAFJMPCspjzJygQU86vKC2ccoGWuF
	Kh4S0i8WG3GQ5l6hOkJT1og4TGqGI04ektdvdIDO16ww5lpXrtAwgZPD47DpNMS2eWswyhk//x
	gjVYby7OeRUokKDO61m8cIzVxlll39W3LMFcvCRl5/wmDf+hY3vYE9bJqp3uk2o7efDjOm0sVp
	5Sj+v6UljCw5GESobRnMrhJa5u1ff5MnUiWTpRr5Vwpu/1UxH/0cebkSB14088mRAY7JC4tORm
	d/c=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; d="scan'208";a="162701801"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
	by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 22:14:08 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4319.namprd04.prod.outlook.com
	(2603:10b6:805:31::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16;
	Mon, 25 Jan 2021 14:14:06 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017;
	Mon, 25 Jan 2021 14:14:06 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 08/10] block: add a disk_uevent helper
Thread-Index: AQHW8jkXIqNElehhEEiDCcJeiMg69A==
Date: Mon, 25 Jan 2021 14:14:06 +0000
Message-ID: <SN4PR0401MB35987817DFEC3A6344C34E0D9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 485e63bb-7c3f-4581-5bc0-08d8c13b7a01
x-ms-traffictypediagnostic: SN6PR04MB4319:
x-microsoft-antispam-prvs: <SN6PR04MB4319C6923F6CBB53E34518EF9BBD9@SN6PR04MB4319.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bCk6Jb8+QfXyraTfaRPSO0Z4tOap/NHbwVyo7Ed7Jsgx8xTRxqHvWq7y6zJP8fEExTQYQKRUQK1ld+pb0WwwG+gjCh4sQDsJz5WjOlXIu+p+nVDv3oMS+KadBoXNvZqdA5Ee6A0cfNHjItEy0zpotJIZr57k9/2tt8qnt/jfXlLHdwZ1ctQ1EAklQi8u2K+zEyOTDWBmOzjq1JzJFbMrXW5gO+F2oYQ5PUI7ePcGsF4SIKo4aecLTz1ixW+J3i9zfpB0bjlH/0sbJB3/JeGb/AlyxErjif/dXCn6S2hZacoDE0EF5hwO+a9ZzejOMdbHNKxTzeEWaXO8QmMxHeQObU2LW9MXjS55Upr63mcztFFZYvy3B6RgflkbTTA1vv6OeMj3EIKKtEceP7Dw831l4g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(4270600006)(71200400001)(54906003)(8676002)(110136005)(8936002)(316002)(33656002)(7696005)(5660300002)(2906002)(66946007)(91956017)(76116006)(86362001)(64756008)(66446008)(558084003)(66556008)(4326008)(66476007)(7416002)(52536014)(186003)(9686003)(19618925003)(26005)(55016002)(478600001)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DY4V+TmXM55i/Akra5XOIzLfrUZf+oUb1MrkLQUi8EmFMZfVUQJ95xWLANBG?=
	=?us-ascii?Q?+KsioA+tJf1dA6Ee+9jFMVVIsUVA38uB9jCDhGmS7Upr8IEobkLNawH0hhGO?=
	=?us-ascii?Q?tmzxMBs1DGutZfFxxW9/2lgG6v7X4EUhN/2NO2Ah1zECZftXg8j86vS+3Kp3?=
	=?us-ascii?Q?nLQhOYeRuszHqCL3TaYTT8NKCSxL6JbFt+/KGzkBJC0zkRM/9Hpvt9FdC47z?=
	=?us-ascii?Q?eukQfCgzRrxUyfSzKvtbpE+vO5gpZsnVxxe0RCtMBIYjzCppJ6l73Y9MEFKL?=
	=?us-ascii?Q?RHxPth6r8J7jGV+f9GF4dt/3vIvrtsZ/1b7o4lrQVKNtx7p1/wex9R+4G/AP?=
	=?us-ascii?Q?/2J/Mtn5ayzuoWfcma3iVYhvv0J0twtUZwRgRS1VqtzR5TM06Jk5JouP9PMm?=
	=?us-ascii?Q?ny1xJGODZJeWmPwAP+W9ByPoOdKOWZK/CjdtqU3CBb1dYsJXiTl29S9No27M?=
	=?us-ascii?Q?SvdF5d6Nr1Uy52DMPhUWplgE0dapsfhnUAa9LZpj+zhKno2QIo3WoU/aaK3K?=
	=?us-ascii?Q?3a81Dp8MnJ039V78Xwt2zrF6Oo0r2DvOPz3JueRia+3jOqObr+R0/qT+ooOs?=
	=?us-ascii?Q?9PXVOjkoHZVClX3n/O9bKYsLgv49mx6mKMAL0R0wWSkSGQiPgW1VXhKdQxVL?=
	=?us-ascii?Q?vT74q2KgF76BgyQNCrrF5U9BnCuZxoGEAew/KWGoA8ZD02U0RtIsC8W3bBwY?=
	=?us-ascii?Q?Tmy6J6HHIW1mlnMOo1u++1IqmSmio8zp+2hf1orJKEwltWkuIu34yBEA54Di?=
	=?us-ascii?Q?nVgIhHiTn39toJwchB73wvTFYXOG6MXuGc3vhkdmxEmMzD5ATJdoYFNvCczV?=
	=?us-ascii?Q?LeTfCGoKqxJbMDJySrR1W3Y//7qH18Leusieco2hQ4ZHK0405YDPS6i3LKu6?=
	=?us-ascii?Q?2ZkQSBORQ565A3EtRUTYVRTW6SZXQwv199sUWbz9mv3PlZ/1wXN4Tu9Jwc5v?=
	=?us-ascii?Q?0xd3QYONjsDGRWq7U61V2b89guhlJvzgaP+R9C/8K7O4YAidWRtSz7Ikz1RN?=
	=?us-ascii?Q?JRbERlmLkbXdVjB8IuJFFve5gpoD4nYEnCBarx6/Xadh5B7//fZ5OZ5R0jY6?=
	=?us-ascii?Q?/xUsOE2ObhYYtSNSiRBNiM3HQmXFag=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485e63bb-7c3f-4581-5bc0-08d8c13b7a01
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 14:14:06.6516 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EC4IJ1mPr5agF1kGHk101F2P1wfJRJTDjk2KyI7YmzH+lFZX8NEXxI2XkX7EFkR8eHiF+gjMi+E2/FJZke38g/gRXuu5GTvCKgL88N6T7UM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4319
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10PEFHAb003688
X-loop: dm-devel@redhat.com
Cc: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 08/10] block: add a disk_uevent helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

