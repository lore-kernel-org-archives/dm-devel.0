Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB263C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 08:07:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-LYP2RwobOE2JjGyt1y3buQ-1; Fri, 14 Jan 2022 03:07:32 -0500
X-MC-Unique: LYP2RwobOE2JjGyt1y3buQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 009801083F61;
	Fri, 14 Jan 2022 08:07:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFC8D1059104;
	Fri, 14 Jan 2022 08:07:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 825CC1809CB8;
	Fri, 14 Jan 2022 08:07:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20E87M6R030051 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 Jan 2022 03:07:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3B0C492D17; Fri, 14 Jan 2022 08:07:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE2CB492D4F
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 08:07:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 818D4380451E
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 08:07:22 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-380-WsX0eXnCOa-FN9EI8qwEZA-1; Fri, 14 Jan 2022 03:07:21 -0500
X-MC-Unique: WsX0eXnCOa-FN9EI8qwEZA-1
X-IronPort-AV: E=Sophos;i="5.88,287,1635177600"; d="scan'208";a="294511376"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
	by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2022 16:06:17 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5163.namprd04.prod.outlook.com (2603:10b6:5:1a::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11;
	Fri, 14 Jan 2022 08:06:16 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::e58a:8ae5:2f73:35ea]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::e58a:8ae5:2f73:35ea%9]) with mapi id 15.20.4888.012;
	Fri, 14 Jan 2022 08:06:16 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Israel Rukshin <israelr@nvidia.com>, dm-devel <dm-devel@redhat.com>
Thread-Topic: [dm-devel] [PATCH 1/1] dm crypt: Add inline encryption support
Thread-Index: AQHYCLFeIG7+7yFBCk+tJja/PF9DUQ==
Date: Fri, 14 Jan 2022 08:06:16 +0000
Message-ID: <DM6PR04MB7081756F34BC9D6AE4552709E7549@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<1642097341-6521-2-git-send-email-israelr@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27609f2d-7ba1-4cca-dcf9-08d9d734bd6c
x-ms-traffictypediagnostic: DM6PR04MB5163:EE_
x-microsoft-antispam-prvs: <DM6PR04MB516386DD9F9CE66A614419A1E7549@DM6PR04MB5163.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XrkNv2uIJUbyBCKwm24TNe8JizeqI8x2Ajv+WT9oj8KI+0lr5ovUmbO4uppd1FQtIoioZwtd4Dd7In/uWn9GZdt4ZV/D9M+m7JM75qnBs6yWpXA/mBvpm7NbptvmYHwEftBz9jx0YsUNjprD4NXTXLtcYj3afFb64Buk5d5GD0tkOjn1wn0ks23w3BbkajhajAw1p3YXYtWs162MxME7ThM+b1Ym1u/I+Mf1uG70zBwwX0ukdau1EJoIgtxhDtyimPGsKQ684nujo9m9ATeLzAYOnnAhZ/f7fTwezlYQrGHPX3g3nYk6iD9EJJ8IQ3LB1rN0WErUntBYptp9ATeiwBV98eM03UhZhYOKbNvIqgTwwlMNtBKuJRvCEVrJyf8cLRsxIJPahd+ffX2e7591DaSbuJtJwlcdbp0Bg3vguMNVaSGjortpMVBopw2jjbGrTUe04XwTTG/HH3Ao5PL3Bw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(8936002)(73894004)(621065003)(66946007)(508600001)(66446008)(64756008)(66556008)(66476007)(76116006)(91956017)(4270600006)(38070700005)(7696005)(8676002)(52536014)(9686003)(110136005)(86362001)(122000001)(6506007)(38100700002)(54906003)(55016003)(82960400001)(4326008)(186003)(71200400001)(316002)(2906002)(33656002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pUz8e0qRwLVCGqxxV5SMz7n/+EU/qhnMZSODyhOXKSHeCeqx+Z9bJ/xK2Y68?=
	=?us-ascii?Q?1asNNnt9UWYzWaXwu0AytJZiPagg+ujHbb7RJg7tcenhfaa5jhweklGxOOdP?=
	=?us-ascii?Q?Go7WLHPkzNHttn+3hnjAAILhvOStiTgVKavY4pqE/YG8uqJb2Qz11Qjg5P1U?=
	=?us-ascii?Q?GnFdkKqp7yn1hVr4tFwhbemqfPV5X55jGMrYaCKt5Qhva80+acwXSw6x9APA?=
	=?us-ascii?Q?4sMXcKueVybUnq7BUPg3dqjokkUHiQpJp8qLPxJKpaWaLGtN4W8lHvdN69eV?=
	=?us-ascii?Q?4X9hd8ACI94082zlSi9v1iFHy247C80G9gxPIG7T60TlLOXfUb9zy+jAKN3l?=
	=?us-ascii?Q?zQBJB8cyx//QcAMWkTv/YpB1ZnJ0dQy2tizbHR1rQ7WZjRHaca/ePvScU3xp?=
	=?us-ascii?Q?5G0ZXwaM9+L2RsJND4wMRkXTOAzq0BCYyb2AtByzjhWYHr68nZnLWx/4N9CI?=
	=?us-ascii?Q?zZRAV9o1x+niqAdEyCCzeNLWxu+JqRF6QVoZmS0Eban6EoMcG8p7cu3q552w?=
	=?us-ascii?Q?pKNh5C5Ngc5R/LOF7NRkqgaLgjv2d4BAHT2486IswCR6JZpWH+D/89sdLiUd?=
	=?us-ascii?Q?ce3sZ7uCjvnQN5rsNu3N5RPIcvQ/l9CTC/4PYnmpNDMY7bBWlillQJmKG/kL?=
	=?us-ascii?Q?cy1XvdgfxmgryTTrBnTI5Wo3YvpvW7qoIHkazDPqhsQw4opalnzUlxl0/7Ob?=
	=?us-ascii?Q?N229LEurHJqcWIZ5BU3/yG4C2nAguuok+Fk4/2NILxxxhQhRcoNmrGa0OVnf?=
	=?us-ascii?Q?HGgdZegp1DiAKCn7mfYawbYlHZme8Wta+uajONSOcgFhSeIoLdukxMmxWwiF?=
	=?us-ascii?Q?j0co6II+WUvylW6qaydfV+ROB6230Q1ewFLbm0cOJcFbgWMjWM61NVYRTUmi?=
	=?us-ascii?Q?TD93NLj1dfboXiXI75Bu56PBvawU71J0LfqXtDG93IceVhvDd8/yROVqH5hO?=
	=?us-ascii?Q?s4dXiplVZziyMVj379MitsfhG3/sJQfr/aXxZwXXn0iWRQEEHRyLhwOn4wyQ?=
	=?us-ascii?Q?ttxyisJuEu9+lQ/ZhRKhLl/Y+mpQo1GdrKh8+/Z/es0jVkYpqQ58yWXN2UXm?=
	=?us-ascii?Q?o5X7k/fGmKDRRLHroiZsZYcf8GVFY5HY+XHbovNfCE4ncI3XWJN4LTgxLlzC?=
	=?us-ascii?Q?Zfi6K1sTTouZFfsgjgS9z12ntCkPz5iE6R82UM53z4NhgMyTvUj4ecy5UPF9?=
	=?us-ascii?Q?9EvXS+l1vHKfBR8t+XCPM/tu6wmiuQh/HbBGJPdSs/VuhvLeakFj8NImImYQ?=
	=?us-ascii?Q?vkeq1xCO5oS5/qHL9BNtirYv608oKsKT1ZveHw/SgCiHDBCpVt3Qqdhagadi?=
	=?us-ascii?Q?+aexRXqRxr5z+RqhjZ8xfAUsvXWwS25HYOAz2jOPdMd+CJb2wkxVuZWq9Bde?=
	=?us-ascii?Q?TXBaMKc921+LQnlVOpWWpbR+NE0NVbYUXeSxb16bFrktsoQJRvI6HvgtgCve?=
	=?us-ascii?Q?4ncNQ3jUeJptaxMEH1pTOOQzj5TYa0xcJ4kWdr9tWhu92IxKplp52fWmiaC9?=
	=?us-ascii?Q?gh02tn+yc0sRFsp/K3xrKdCRfZ1aO+zRVl+x28BefTMCdmVxIWpQWZYX1weC?=
	=?us-ascii?Q?llDyqO1r+ScAcFHQ5QAajaeP3GMNiz6ytjt+06ucwAE2JL6TSA2HHa8L2fGT?=
	=?us-ascii?Q?amXEIbjBQwi/ICE1LjOc58vCw5VK5fYMjTjwmKX1czdj3uekHr3AKOUcFx0f?=
	=?us-ascii?Q?Wvm934wFnla4T5EwFlaXF7ML5kE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27609f2d-7ba1-4cca-dcf9-08d9d734bd6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 08:06:16.5310 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAXkmr7+cnjVtcGV93KIo/xXjR2DCC/fyOVTScupqiS3Oj3JICUR1wdbd9FnkIst2xv2e/KZUK4RJZK4LkVDUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5163
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20E87M6R030051
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: Re: [dm-devel] [PATCH 1/1] dm crypt: Add inline encryption support
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



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

