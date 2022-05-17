Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B477FC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 14:20:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-LQRyZAuKPmqzWaxxCSsvOA-1; Tue, 17 May 2022 10:20:16 -0400
X-MC-Unique: LQRyZAuKPmqzWaxxCSsvOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD9D23C138D0;
	Tue, 17 May 2022 14:20:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0B1740C1421;
	Tue, 17 May 2022 14:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F4681947057;
	Tue, 17 May 2022 14:20:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3EB4D1947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 14:20:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C2F4153AD03; Tue, 17 May 2022 14:20:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2716D153AD02
 for <dm-devel@redhat.com>; Tue, 17 May 2022 14:20:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CBB61D9F8B9
 for <dm-devel@redhat.com>; Tue, 17 May 2022 14:20:05 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-EJx-Eh5UOo2QkFBgTrdwOg-1; Tue, 17 May 2022 10:20:02 -0400
X-MC-Unique: EJx-Eh5UOo2QkFBgTrdwOg-1
X-IronPort-AV: E=Sophos;i="5.91,233,1647273600"; d="scan'208";a="205432452"
Received: from mail-bn1nam07lp2045.outbound.protection.outlook.com (HELO
 NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
 by ob1.hgst.iphmx.com with ESMTP; 17 May 2022 22:19:57 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5462.namprd04.prod.outlook.com (2603:10b6:a03:c4::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 14:19:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 14:19:56 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>, 
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>, "dsterba@suse.com"
 <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>
Thread-Topic: [PATCH v4 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
Thread-Index: AQHYaUWk3AoK5tKSj0OEio55edQW9Q==
Date: Tue, 17 May 2022 14:19:56 +0000
Message-ID: <PH0PR04MB7416FD8C80A78B635891B6339BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38@eucas1p2.samsung.com>
 <20220516165416.171196-5-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a3ba53c-3c55-45ef-079c-08da381051a4
x-ms-traffictypediagnostic: BYAPR04MB5462:EE_
x-microsoft-antispam-prvs: <BYAPR04MB5462EACD51011B87849243EA9BCE9@BYAPR04MB5462.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cuxVqwHnUBFip96+TLTaA8hbOMEeX3XAL3BXPhPaD/hxKWL3FXNQ2/ODE+/TugOIh7PlLAu8OWfhWoUT4dWy1oGFCtVCOOmPmDECKQEcQRI2gvAyF9qUlzjx59dadfk0VP6ERO2nT0nqvXnyqTn2ZhzAv8gaoiSpUBdSE8N96+s+a0TJkKzxJ5phCCwZqzqlqryQspB5e22zT1HHE48/FmmPOZyOxex/i3XyeFdaLt7IiDXSDUM0aziNhq8ofbPDQ9f2QmWyI1cYX9Dla5p3jQDel/qFn5ZEcNVP/3hnslUjjA0/oYTsp5FOYvKmd3qv9w5bEt/gM0jdn2V5SNztY6FJ7lS2D80ntLOJwxIddQcynYLL5ZHyj4pzMl9casi1pce32kPEhRUIc7MRFj5R86VCw8m8AjlYSttNFMiMf2zw1pxLNb58h/us8fyZ/F7qiUc/0J9tkSHCVTEUyocErLF+k/fygBvEX3otK1q8BGTTWMVYKk5LHc7wOWvSDugG79wYwyamR02+FOvj2Iv/SK+Qg9E31A7J+lDDwQow0bvc0IqTtNNDfXEko03CJh7UWT5xPBsOdVO86A/vn6CVge9Vl/z4LO56/MNkAHTbnVchxQDSy4HHSFqbKXfSLFFSgNx9n4+e7PhGcxFDCdsu6egvyNFf4F1ttb8BweOEa2StDWWDdl8io4gaNTtlLpot/r5ohr/5toETDJ+m+Buu3g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(110136005)(316002)(54906003)(55016003)(6506007)(4326008)(8676002)(8936002)(66446008)(9686003)(64756008)(66476007)(33656002)(86362001)(558084003)(508600001)(186003)(71200400001)(91956017)(52536014)(122000001)(38070700005)(5660300002)(7416002)(38100700002)(82960400001)(2906002)(66556008)(76116006)(66946007)(7696005);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wXyWym6rXdZ1Kj9RG+pOQuEqLgnJWYijKXDgUTDhFBCvHFCze9hnGd7GtIl4?=
 =?us-ascii?Q?FvPs6f/4RNPhlS5Qcphw7OnA29uQihbTAh4RN6ZLj4pb7qyt4g1V1A7z6Tzu?=
 =?us-ascii?Q?4IzFCEX7ngA5MXlceOZTdSmOl/jpnZhLXyeCUKh9ISgScb6LlP+O7s+fMs+Y?=
 =?us-ascii?Q?p4PmYDCotxo9BEMR2OlnTflPe0M+UQEpyiI72lW93+8Spn+Q7yoFYNEns7+W?=
 =?us-ascii?Q?4kKLiBZppSkEnK69E18dfaSAFPjvWnGk1UM1i4IdhKxIno6tOPd5fndcxWZR?=
 =?us-ascii?Q?PxVaBHqBsQyxHbJs5rb4/4JVoQK+MQIPnlkLDK6oNeTWfZM5haWZOuqnR5nx?=
 =?us-ascii?Q?cofEcCQi0APFAZdUiWCFfJPpanJfvkBSvvs5KxkgQb5JqBk7euGySoEfesOw?=
 =?us-ascii?Q?xGDFhkIZWco9PT9BYxlV/5OUlM1DIorLG9yEWHiviOtONznpxj5wkOYW/c/R?=
 =?us-ascii?Q?xEO/6LtexnKMmPsugd1k5IuXuaDIrM4b3IySlUIAJz69O69LFqIx4R0UdAfg?=
 =?us-ascii?Q?a24+FAF6ghRY11e/jwRnWTB3eyuvbw5H97VrI6h4bTQiipY8ZYaqiIGkNWg7?=
 =?us-ascii?Q?J8KqlbGyplw5QBNL7mwu9A+B7+nYXH4jDgpSs3PeWhzad6GDsBC/i/mrhAGG?=
 =?us-ascii?Q?jtW8RSCR22eGYfAbk+RZWeaggG+nOOjfAWMHtChHL40DvmdMfkn7WIDtL/PN?=
 =?us-ascii?Q?fYVEwlZwNnE6fsQYgGHJOF2Z8L06bDfDOV+gwyucCtpvvkU3auQkWmPqb7Uf?=
 =?us-ascii?Q?yWTOQbbROVLvfIa7KY5c+NHmKSSSDy5zr5YpbHEnSyTGMKukUeAaLYKSqoz8?=
 =?us-ascii?Q?3tuV93JPUd43o8MbAuZ7rlzsu+mco27Zwm9O1xQ/Dz5D3XxsgmLREML8jHAy?=
 =?us-ascii?Q?FRlu+Xyp/mcvf4/mjmCLnADVOwtdKUwZ+RLJg7XZVFWnIPT3PgjY4/cUn1cm?=
 =?us-ascii?Q?hiW8hgSMR6VKTyC8tBxp9ooXIawdSAXLQDiapVsLqOG16+6YuBYfMdC//6R8?=
 =?us-ascii?Q?zxk5+xBe2a0zBt+DN001SE+Wx7ftkpVstKZ+rAui9DiCmams5Z+ekiZQtZ3V?=
 =?us-ascii?Q?MzEoj1aL9cTM2On5f2QZUShp+DX6oAo5xdTiYggVHnuErn8Zg97IUjozu0ZB?=
 =?us-ascii?Q?PWHwzk0wN2mw8OUay6A5lYJK8T8VrrrERsy7Foy1z0+4eXnY8nCZ/7K1Q3GR?=
 =?us-ascii?Q?nsj6cZvEbGEGw62fqGNNGGbAXtfCUaWw2cD0H8L6YSHH8CZP0Lj4iQVunLsW?=
 =?us-ascii?Q?+znzJkZCpm3VRrYZAo2glNJi7i4tKAETG4X1AAVGXKp2HTrKgFQ3+hlmMcf0?=
 =?us-ascii?Q?bMFq+XLFvdZtGeDsOce7EY230p8ooh3KbyyMJbyqGBJVlrVQq0Dv3plj4wW0?=
 =?us-ascii?Q?HflhZ7TWrpasxKX0y40OWf0lZNEN55e/3Lyka2uE+1bllvWwKFMXkNUDZ35j?=
 =?us-ascii?Q?dp1fz6OcjATn/AtmhZHs1IFRXORBuiVd6inbkzxFGhLHOkXaOynR0tGaAyPj?=
 =?us-ascii?Q?sFskbvbtE7olUedyB7mEhZB5rvFQGMJPV811sYLHYQOnJmXghiyt+EcUKev2?=
 =?us-ascii?Q?vIqVCo4Omqrq8XpOVf2BxQD8/CS3xrEigjoP/5BkHMHPESKhGxX6Hf60RMT9?=
 =?us-ascii?Q?n7B7mzhAtr4q3qPQatQDqNb/69H+ZQIMyoLi2o5FGcdqjEHv3Gsbf2nfe9T7?=
 =?us-ascii?Q?If5TqlmRp6FqAIaEMnu9a1OxFMTCSEudCyr05s4ET/Uqe5fJJWHGCUtHFVAL?=
 =?us-ascii?Q?r3zIz6BBw1aqVT6WxCXvLgktMGuXW4CbJZFGr9bLCnvWQUtqH8U+r49UjRZ4?=
x-ms-exchange-antispam-messagedata-1: E+DYvtfpoHJfwfCfyeGM53tZyNW3K9Au3oiYzjj/NyJ5ZqD95cEoPJ90
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3ba53c-3c55-45ef-079c-08da381051a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 14:19:56.6058 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: It57Z7bP9Qz2ngmJ9rvHDvhOGfNGMOdaZRq8ISab8AciVLVMo/W2nI3BEcSBarV7I6p+PuLHYBZT9Qk2+B3K/UwX9yyzeInPBTi77xP54pU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5462
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
Cc: Bart Van Assche <bvanassche@acm.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I think this is useful even without the rest of the npo2 patches.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

