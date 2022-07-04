Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EA1C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656940640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=T9+ZNGgtTqaNxV3Tl9e6b6swOI3lPvS4sEEgMjxIoBb+11IUqitIV2saYUC6M+veA66uDW
	PW6Zr4cr8k7BsINHm6vlvMBevBw1kYkQcDRbUjCQ7Csq4tHyc1Oz3t512dYHINwWYOd6Og
	KyXnlIlJ1X1XwhB0/MPrWMhWhp7F4cQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-jTnqiW29OPiDHTqg3NbU6Q-1; Mon, 04 Jul 2022 09:17:17 -0400
X-MC-Unique: jTnqiW29OPiDHTqg3NbU6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603FA85A580;
	Mon,  4 Jul 2022 13:17:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EDF3400EA94;
	Mon,  4 Jul 2022 13:17:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15E56194704D;
	Mon,  4 Jul 2022 13:17:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7CA8719466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:17:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B4F21415130; Mon,  4 Jul 2022 13:17:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56483141510F
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:17:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EB2B3C0ED5C
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:17:14 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-SaaVWAfjPf2m2THy0hJ6hQ-1; Mon, 04 Jul 2022 09:17:12 -0400
X-MC-Unique: SaaVWAfjPf2m2THy0hJ6hQ-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="205481516"
Received: from mail-bn8nam04lp2043.outbound.protection.outlook.com (HELO
 NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:17:10 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:17:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:17:09 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Thread-Index: AQHYj6P1rQgmgQLRK0yBIpbU1T8JTw==
Date: Mon, 4 Jul 2022 13:17:09 +0000
Message-ID: <PH0PR04MB7416ABBFC6E55FF41B2AF8F99BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73c5c2f0-9548-4d38-4440-08da5dbf7fec
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8xZ/ckm0bKpes0ZfCYy6AJS4ayKJ+FvYQ7jIjWpxTeC6rCGQL3JcIiDD9ycOQHv+ZA+A8xjosvHALWo4Urpn5pEAQGegUZe19cNPVY8d7gswNveRlQtXA400OaqYHlKzQS6Vuh3DqigltaFEzrSpZ41SQipDkbQfX7HMT+rpwzSk8olmqGa/PAdgPJBoaEwnfQXBoku33grzLImn2gRUg6/J4pV2HxqgSaaibbbhWOowDAY4DcDxCYSxtktwaVrbELwaVIp1jkzZSdRKW/w2dwG6fLBInThXRJzxCFQx0LUzHdbdZgQYp/5f5+Z5S0qadRQm3FOjQfZcvFuBC77dfeXdAvCsieF/QZGMkgTc7iypf38J4XeHa3CIZOTlg00M1q1u9YYOUtPq7mHXcV6W2dnkJeCJY0cjIje7MxzWmMHKTYXJAQpyYcvLBAXICmpAPfwgsj4gPMzhA0rVxZz+pK4wPGPt/QeR9ymIBepDeTZHTflLkTT4JXD51OnWzjN7KlX3aa3FOxQVVY2AGrRR0tRthaRCxy/6mstwf2zD4VpwlNpEK4pCl95v7jpq5aTH+PuEeRi2RA3aMS70vlgvlLCf+B+0TOz/GWSLQ+iazJKr3sJfDCSgeViUr9PCTtEmfeiBel41NorhzZtO2ShR314aPeIJO4Qsm+UKPWlym1UJeh4oDQD6rj/hmYq8bGxns8BVEdxp4f4HsZudt/uk+5ykMFYsgg1dXu7ySUyJIhf7qFqXVK3PPEVyqI0P1WIUxbSLNz3bwdlYt7LQO65RqFDSyR3hM/WKlpYtrllFmbQrznYdCE9bx0L2Bdyqb6AU
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(71200400001)(478600001)(91956017)(86362001)(76116006)(558084003)(186003)(33656002)(4270600006)(4326008)(110136005)(38100700002)(7696005)(38070700005)(66946007)(9686003)(41300700001)(316002)(54906003)(66556008)(8676002)(66476007)(64756008)(66446008)(6506007)(52536014)(82960400001)(55016003)(19618925003)(2906002)(8936002)(5660300002)(122000001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PRkf3MOM+RdH4rGUQ+W+TnQmbWp44ZeuyrmVaBFZjMxd+dkVSVILIOuHV9Qc?=
 =?us-ascii?Q?sTbL1gvemGC0McABTZNdvIbd5+Z1qcBsPXB0ySQf+wqy/AH1S+yo6WQF2ews?=
 =?us-ascii?Q?3B5T2q2sEmbgk9KibpOYXC8fNKbh5irjUJPzL1Td46fdM5U367xvnACdNaw5?=
 =?us-ascii?Q?OvtEIjeMpxcLxhBjB/c1U5OJQ+wPvISmnEuf5tP0ha+csIeBiK8cSCSOIVw+?=
 =?us-ascii?Q?LlN0LcHIoqS2vNbzM3IBbW25DFUSzxBEhgUypfGNwEt+6+7/iJF428rI3LQ7?=
 =?us-ascii?Q?zPOfLLIAPKcSb40VH5+9eZwKOYi96IzvrOugbjvPaZMVZZW+vIjT/w7A7W1G?=
 =?us-ascii?Q?/zMtCDc1qzdmy7NT8DdLWxE18xT6cG2HpT8LqAGnQWsRNifYIGCriuCl2tgz?=
 =?us-ascii?Q?uEN/Mjz/epjgmYEDK8jJsLC+k+G1XuskBqoHTSOFfOTkEADsBjC5xN/OrR1w?=
 =?us-ascii?Q?P9PqOMEmVB4EIP/81Vsk/W7Bc1BAHLAaabIKwxPkljZO9kAEwYpxkZ+ZBMPK?=
 =?us-ascii?Q?DkdH2thC9An2sb17STjs+VEp64WuBf4Re5n8Orjp3BOdEFwW2A3y7vg6XreN?=
 =?us-ascii?Q?ADcuFoRXeV+R9nZTotsOMjmUAH7Q2pLBkLlGM6Mc147L+miWv1Ze7PYjcnt2?=
 =?us-ascii?Q?GBOCGxy3pkK7HUHH3yd3oC0hM9sD5zNxWo+pL9IlDVb3JhxhngjK6QwtMqwH?=
 =?us-ascii?Q?KkIJEEc3jNllOz809iZVZhBXy8VrLyWk8+tGIbkD2FqEdHszFKU4g+FRK8PO?=
 =?us-ascii?Q?Wdbp1pKVBunctkBMUax1zyWUoXnGTqR8IiY6T7xgCgBypAx1X0KIma6eKuY0?=
 =?us-ascii?Q?uddmDU8pBOKWmH53IaqxyXTHXgmLUJdf0Zhb3TCRVdXd1Us2D0VkniodyEH+?=
 =?us-ascii?Q?gIu2U08iGAw56OXJg+lu6wuNK3cRjG8a3ggNiR9decVWvl0ELcx7gZZUzCaE?=
 =?us-ascii?Q?sbNOLkucV/JepwgCZq+8K7/LI8FWnKe611ErNGYyNd6jeEKBF0IQfcqHVT0a?=
 =?us-ascii?Q?ArgNkXPadWPpXOhtiLdO6d73K3zLIZDZglalAFE8ps4S7KZy+a3CKRp5X+VH?=
 =?us-ascii?Q?z6vUUcCjjIp5Fu5KnFBd8ShvXYD1q32487s5gb8HlJAITE3q8JGfjlGESUkH?=
 =?us-ascii?Q?rmK1bwroVAQnL1bPy91KdplegBsco7wzBsWPgtz3ZeKKmzU6XQo+mf4wAyMO?=
 =?us-ascii?Q?4qimCqo5yChNZXvpzr+3EYtGCXw5aO+5DPU8hbFx5tGYcBOtqZC1Kg7FUnDA?=
 =?us-ascii?Q?7sOU6JnK0ELOL8VVMSjHmgMw8yXgbKIC3+G7s3rXzKsG01KOKALa+amCRBMD?=
 =?us-ascii?Q?lPPF0F2dgQfkgCo5nQC8XPViveEG8/bSzaXOwYNUL72RX6QQSZ9AsGerMPaj?=
 =?us-ascii?Q?xsnL9+B1ua30fY860uVOpfeTLS4hOjrv0ogchHg5EY6FHSa7aBC4wrPFXWAp?=
 =?us-ascii?Q?mTqVTI5w6rDngfBtQinI9Ygrk/z+dhI7sEx+fv9OUn/FbiCBvU69hOBekyf3?=
 =?us-ascii?Q?6UK0iF+aOGpAu7oLYf9vX0gziDRLEnGsHTmoQybxIQR+ACcu46u0hYmK7hkF?=
 =?us-ascii?Q?mf5Fj61cawHap4kmA8eo7PvCj+3/EL63QQKmU/2fjaQi9GHjOXhth5SSPbv5?=
 =?us-ascii?Q?c/YZBZ3VpiVi2RE7oK/vjs4NWPYSF36DbeRVF0M87n/jf44VD2KdbA4kznSm?=
 =?us-ascii?Q?MSnAGtTcJ+emsv1xnr5C3OQc2eM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c5c2f0-9548-4d38-4440-08da5dbf7fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:17:09.2361 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ithajeacdzdJNp/J+bqv85d+VSjLxj19uzS1Vw+QhUjBMiYXIfFtFOOl36SHCSGoMsu48eKYAmnakmTPfTEjaLeqESHPW97BnftVAtOIKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 05/17] block: export blkdev_zone_mgmt_all
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
https://listman.redhat.com/mailman/listinfo/dm-devel

