Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A2FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 06:54:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-bQFc1ZgsMM-FRmYzxfcCEg-1; Tue, 17 May 2022 02:54:52 -0400
X-MC-Unique: bQFc1ZgsMM-FRmYzxfcCEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABB45185A794;
	Tue, 17 May 2022 06:54:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FE761121315;
	Tue, 17 May 2022 06:54:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 597F8194705F;
	Tue, 17 May 2022 06:54:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28CCD1947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 06:54:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0134A1121315; Tue, 17 May 2022 06:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F00F21121314
 for <dm-devel@redhat.com>; Tue, 17 May 2022 06:54:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3DC9299E75D
 for <dm-devel@redhat.com>; Tue, 17 May 2022 06:54:48 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-T2S24TTVPeW_ZNwEanqETQ-1; Tue, 17 May 2022 02:54:47 -0400
X-MC-Unique: T2S24TTVPeW_ZNwEanqETQ-1
X-IronPort-AV: E=Sophos;i="5.91,232,1647273600"; d="scan'208";a="312507637"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO
 NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
 by ob1.hgst.iphmx.com with ESMTP; 17 May 2022 14:53:42 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB5337.namprd04.prod.outlook.com (2603:10b6:5:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 06:53:40 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 06:53:40 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>, 
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>, "dsterba@suse.com"
 <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>
Thread-Topic: [PATCH v4 06/13] btrfs: zoned: Make sb_zone_number function non
 power of 2 compatible
Thread-Index: AQHYaUWnfgxv+u/BDkiy20kzzzkazg==
Date: Tue, 17 May 2022 06:53:40 +0000
Message-ID: <PH0PR04MB741673F9764EFCA93F1932809BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9@eucas1p1.samsung.com>
 <20220516165416.171196-7-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 883b5050-2326-41ad-b1de-08da37d1f9f0
x-ms-traffictypediagnostic: DM6PR04MB5337:EE_
x-microsoft-antispam-prvs: <DM6PR04MB5337CFDE45BDDDA2230668489BCE9@DM6PR04MB5337.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GDpNr5HzpLRyrCme5FwTGIGoQbbjLN8Wk0xZDmtOvyI5p7TDOrvvurK4XBfPU7HuLh6YcUYY6ODAwfzpVC8sE6RPu1Pb677LP74m/vUXIIeedh0E5kS0x+pGRNC3GdgmN1Ay5gwtGLczBkeFZlc5OLg+9C4vqnfzw2VP2iTrGxMmFnXfEborE/QUpRZUd0a8V6PveAUSHhYKm6L9wYglkbKKHWICuFT1C6Qrc7cLTtyEQ1x5/O27Y0ws6QKJxS07CzlZDLedfpZ5FJ1edN7FbSOo+XZKUfipUdaiDk2RTMipfvUVAyBOVvNIVgHJf6zFyXzZhdE08f0+6+pA6stqlDGvJHyaFiEd7T74bCgYyLZjHlEwSIFVoAvsylSGduCf1hM9EKGHoVd473jsnZLL6drwe5OEzjrugqt+hxIQdfvS604bllKlDnnzyzM1QkpltE4IMLvW8rm9fSZGCrBPJ++OsyDrjn9Bqdie8fv8gqc6f9BGooJY2viMITMmahWpiJmwKg2drOYTt3PF34WG9FceFKU3/QtVqKQ2CNcEgrUZjsW5BU4gtdh8lcyBlGnGKpZfopn4zgu5GZrDMlwxH6x07C3oq0spCOfpZt4oir/1vleGC0QxG6JO1AhHUZmK31WkvfOZe5i9YJvvoLv9s4/N4TMcr5uV9bznPeshUxVX9JP2BD29/pikrI0v88lehBH05a0COXfsHKOedBKSvw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(122000001)(186003)(38070700005)(38100700002)(82960400001)(53546011)(66476007)(5660300002)(33656002)(4326008)(7416002)(55016003)(2906002)(52536014)(4744005)(8936002)(110136005)(66446008)(86362001)(54906003)(71200400001)(7696005)(91956017)(8676002)(6506007)(9686003)(66946007)(76116006)(64756008)(66556008)(316002)(508600001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9ot6Frx+D7LF9ROH4NIBfvSsW/jPWplk9rG4i3xC9nNksOr2f9C8ui3kCacG?=
 =?us-ascii?Q?evHhnxPim+8449MFXNdNZMdjL3YzSCY7majK2FqWwW3FcaEMDAPzIBnotwdY?=
 =?us-ascii?Q?/+ppZ0E5lJqsBexNBfXJGUYfFX1AUp0UwcXF4PGrdmUY4wAc5VotuGf1g151?=
 =?us-ascii?Q?IZf01U6L9H3lth4FFM6qvIwye2juf0vuLnmdt0QzPHqTxMdNiCsAmsbPAxmC?=
 =?us-ascii?Q?z761X5r5mWjnMvlO4tdZGN++6b+JdQy7v+z/Ti/9hII+027UUmc1LBa5MsE1?=
 =?us-ascii?Q?nej4BpWe76kv8qIFI8/CjKuypSQG3Wucpkf1e1gQ7D/bXH8YR3QAptJrqkCU?=
 =?us-ascii?Q?Xk5Cuq1Ab3V06ATJ0zo8GZMHAqyB7KlOIDIi+DO0nM6mqSKKNpytW2TJFag4?=
 =?us-ascii?Q?anxD1KVY2tbYAblHAc8NE3QECm5LrfNr/0bW0afQ/BMhSyj/ryJzY9ZuKgEa?=
 =?us-ascii?Q?9i6lv00oMfJEr5n1VoXXjxNLTfsS461BgAM11x3cwvHK4e5ivNewioc6gQV7?=
 =?us-ascii?Q?dBlejXapDpkqvMxgH9aWHCuJMkOgZFpS73IKxv+2hbhyTZQR0Ajed1vSIEj4?=
 =?us-ascii?Q?EPfH8U0r9Poql61LxZzkr28SqkxqYczt9NsXJTAWBoyeseNa974TaN3GmyNV?=
 =?us-ascii?Q?O/Ca1ez2Tz5vo5abuhQJZcWOxFos8silW7KHduT9hvt0hl0lWgSEovsqeVC2?=
 =?us-ascii?Q?Yr0bLV3B0tXKs+08m5RXBXtle5lYB6or6fPyLlF8tb56hKqUqdEmgyx9rnwk?=
 =?us-ascii?Q?r9ObM6kKlf837oMQzeD717hBLTgm6xUbkTQHM9R0xUdoklzVSlL2X6gltzKf?=
 =?us-ascii?Q?0nF7vB6MFmK8ABj+0c2VCHzYLylRqTZ1/gde4fkbVdHGHrFBUzrZrCQI0daU?=
 =?us-ascii?Q?BfwFn9U3kn7O+NsUNaH7zjdqMb7Uj6bgVFNNmbEw9yKvcfCoJW0DqYbF1uM9?=
 =?us-ascii?Q?hdrRzyAI2QgPX8i3Ly0EghOxJOAARR0cBgMSXkNPbD+8bX/T99zBTQSMkpuL?=
 =?us-ascii?Q?X69pZFidRKsGBh17dnDIBwf2hjqcJNRu0iwRUv7d5mCIj5yXZrOwJwFJkDdv?=
 =?us-ascii?Q?dxG9rCaPhPh78acHe35ehruqpYi16zmmOiC96p0BmayXxOD49dV/k0sSnh/s?=
 =?us-ascii?Q?I0DAKp8d7nUgiGA/ajS5h474xolrtSkXb//iU8o8V00gvamQgKGOMit+QkCe?=
 =?us-ascii?Q?MScP92fd1x9DUFPr3Xfl5QGHvNUp64hpW27j7jF3T6c+TIGESq621Q3M1jhs?=
 =?us-ascii?Q?0PBmZIHzkVYC41AlKQuUbA39B0uSVFELB5SM475+4dEahsNL74mk2+iCyGZe?=
 =?us-ascii?Q?IrCdS33xav/Z7R8ID2Y5Vaeqia4TejKmAgVXb0wqFcS73gBGT3wKCsnSgLTY?=
 =?us-ascii?Q?oNLww4ryvlESMHzhFwdBAQC5ohassbd5VuWRssDGJVY7zyZdlpSyhlG03Eaz?=
 =?us-ascii?Q?+GNm6v4B5FnN3jY5FpIIF41J0xrMDYZPF3mlPkXZTFqSmxtMbtHVZKFgmNJD?=
 =?us-ascii?Q?NilXvhScagGJV6i59qa38gFVWK8+aF5IHdWbKIHDIRvj6p3nsNLZJDfk2djW?=
 =?us-ascii?Q?YszeABB3CFAMMBx+aO3IqJ97Z4RExS4q/4M+5PxQFPQgcq+kSRbD+9jnpPa6?=
 =?us-ascii?Q?eEsYIlOqxyYr0ZwZU7kXMwAvU0vBw71bnEtradotKLm221l/Cg/IHkgO94+1?=
 =?us-ascii?Q?gRqb/NPxIne4rJh3KNeRYZ+69SKMFPvcCQewdVY1xi+606bywNgJYwf24Qz9?=
 =?us-ascii?Q?XOVFdDyEzibqjFmTWTbtL1kpmwE5ruatxX2fofeQ8voa6C2GB14PzRSzxGvE?=
x-ms-exchange-antispam-messagedata-1: ajreH7aLRyqHTJIkwRTJxnz29tvgNl9nUzwTyDqADyFYMyI2onl963AF
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883b5050-2326-41ad-b1de-08da37d1f9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 06:53:40.6871 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wqm/sFYx+iNsRlhyo7IvZ6/835EFHPrVZMx6wHK0RuxnIJlGXvfw/IlGQtqpBFpFFt3NzMvikciCM7JKwp7uZQX0zrR01tBk+GgjSzjVDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5337
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 06/13] btrfs: zoned: Make sb_zone_number
 function non power of 2 compatible
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
Cc: "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 16/05/2022 18:54, Pankaj Raghav wrote:
>  	/* Cache the sb zone number */
>  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
>  		zone_info->sb_zone_location[i] =
> -			sb_zone_number(zone_info->zone_size_shift, i);
> +			sb_zone_number(bdev, i);

I think this easily fits on one line now, doesn't it? But given David's
statement, it'll probably can go away anyways.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

