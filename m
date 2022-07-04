Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6965CC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656940978;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=ggQVbFJWNmZVdqKd7PrT0c2baDHZ6GIeRZpC4aX3qpP1prm3AEhucuj2vrbIK07YkCOslI
	UhXhdlaKGJRFpP1J8yU7WVRLivfLdm8oacdIko/oidoqLSZEpht/6fxZqf7tVctL1fd51I
	o10A0ICi9O42dFFcTGp74qADd1/Vq1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-PS5udiCuMZ-YBPRvD__lwg-1; Mon, 04 Jul 2022 09:22:55 -0400
X-MC-Unique: PS5udiCuMZ-YBPRvD__lwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D364D804197;
	Mon,  4 Jul 2022 13:22:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 826C02166B26;
	Mon,  4 Jul 2022 13:22:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 526E1194704D;
	Mon,  4 Jul 2022 13:22:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA64119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:22:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB8089D7F; Mon,  4 Jul 2022 13:22:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D696C18EB7
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:22:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B871A81D9CE
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:22:51 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-zD6NGiBYPLSPrPbb4sbEwg-1; Mon, 04 Jul 2022 09:22:50 -0400
X-MC-Unique: zD6NGiBYPLSPrPbb4sbEwg-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="203428298"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:22:48 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:22:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:22:47 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Index: AQHYj6P6BE4xOWjgtkKBHWnYAiVA8g==
Date: Mon, 4 Jul 2022 13:22:47 +0000
Message-ID: <PH0PR04MB7416DDEC6AF378EAED7674FF9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e4b5580-0332-4997-623f-08da5dc04965
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bQAPOW0nX14l10RrZlMlmDfMmITnlB6RACUBh1aAAMuLrEX6KqbYkIRObulhgMPZkLheWkV2GaF4dwPDShfhAgFzKpEd6goScsYkMwhRRsEGYu9uivOvNxE3ZbqIJ8IPi8iAVnupzHKoPHOUPpfzd7GaYqpCn4XFSEO2nIAx7MAJgv23eA0tBHMvbOLxS/UmGSafuouyAymOIAUIfAAq6rPwQuGHCNiy1Y8hwIi+I0sdm9X4D6L5L+qjmhZCL7VdGUXvXKONoT9Wx5Iwhc2gLBXBK75ZNQkWCu2W4zgUlnulpr/eFAadJTjCIOz2m6flF8aFejao5eGLsU+eApkMf35/laqKnOElUce/kCehp4ClHePEhuA7w+dCIxXMlCE0v7BOyzgM9Smk1wgs8bcH+b0i8CBP3ACOB3OLiuKOFPAlZN5DALPLyOZVCbgiMZ4PJg6K0sv5G8VXtTZOj8fprVmr8yOCCvbuprCwvE2931VORioHD1YXkXNVwjT8f+tO0UcBnNAXqcGS+VFW1wi20iVvsuWghE5mifaA5tB+/pH3VA3wxWnEDW86WoxQ+3DIv03DRKSd7CB19Lb9Djpvug2XLGMKOkqh3Tr58Ls4qm8hCyTfFICUjPPNq2IkDvP51drVEhYYkYjaN6bY0epcPglp5yMKG97SEP65AU6olj6NHGLS1NcisTEnrKz/Bm0AetlOXFWQ3UHIxDa/f5xdf2H0SbEZ2L9RkhnkwAqYuvMuR01DobSm0+Xc4PK/Ld2D3Imk7Gp0soCd7OdqKDqU+QTDo7p2ROKH37nniBEiMRDTKNwUUkpCS+ZQDwpbB5p8
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/OHZca6v6kIOAlS1Yrpp0Emtu2jqJKc5E6ubwiDhubQvHzBpt/JLhuAmhzzf?=
 =?us-ascii?Q?7iyttmF0bnCRjGa4fkbv3w5r9RhLTYMuzbcyS2g1aqTbYmoDCoDMWUS0X9tD?=
 =?us-ascii?Q?XDkRB3FZgphPMocGgMCtBWtz0qjePpglPZjmiOoF2O6tRqS4m5uzN2qd2O8J?=
 =?us-ascii?Q?7EBBgDZbZHiUKfXxxrdDFm/4AiFD15Ln4tlpbv83Qk0mfZcfEgvOKmbu2pKP?=
 =?us-ascii?Q?ObYzqAr67cKvBShNDykK9KGnR2p/kQaTxsX6Epbkz6vPmxIegqdgXiGgYFvM?=
 =?us-ascii?Q?Tpp9PLei7Z2PrKK3b7v1AKOtTMdHtPMCyUjThFdLAyK4WBakpGy8YkD+XhI0?=
 =?us-ascii?Q?8wdhzFHYw431fWbwEkwLvOuMoCZLWo6FjitL0J8cYmDrxsOu/5Dtr+BLBW0b?=
 =?us-ascii?Q?bkLQVB87RGD4xa2vrS+VgZ8p2mqQbo0ix4dJBtaXdR94AHLIv3cyqOJoBmnv?=
 =?us-ascii?Q?diWcA1BKYIJtpMi5j8UOaTmocTzl0xnDMsFTk+n5uRQHpSsDorKSzwRqf/zr?=
 =?us-ascii?Q?xP1ScpLX7/1RTSu/MRtYdB0AcO5AS4rSmOM4wVVAsVgucVLh1Gq9t+cYOhlw?=
 =?us-ascii?Q?sKWTsieZCp0NcEFGte4tRGlgnJ1C3epykPKgU0l9LW9IB3uAvYKt5qU6VSo7?=
 =?us-ascii?Q?exM1HJdsMJWcP6+Wdoa9m1Ljx6Q/hZkP3vzD4TDHzk7xId1AgaT3ZlliI2XX?=
 =?us-ascii?Q?PrKtBc/QcoB0odmaGnivXOi/wKKx+5gQJu6nKu5rYLHWV7YnOhLg2ik/naoZ?=
 =?us-ascii?Q?GYJwRqNnG3ZHr3nqk7z/S95w8PT+fJVZw4H7eWK9OgEF2EZLSa8Lb2pLm+kb?=
 =?us-ascii?Q?UhfYZiO72VfPOb+Sf8HrSZKyfwiPKfmE6rp0erabWPKt010EdCYvRc8UPTbS?=
 =?us-ascii?Q?fyk6QVeUeq2sxkr9FjPu3QKOW2XJvs7eOjlGPwSDu7tdbyL4t/SdeR/O3ool?=
 =?us-ascii?Q?jRAEm/+cBGkhaZc6UxGlYuwJXtX4B8bZXSI5prwrHdHk1gL8A1R0Piur15O/?=
 =?us-ascii?Q?M1+9Cid6KYk9pqjffmJkh9L0eGZmM60Q6wXlTyYO9z7bancEKpDbdBQC6Uz9?=
 =?us-ascii?Q?zhKVWzJNu1Cg/9cXYu1XvzLZ47/8IZHhY0UwEIb+gdv4wL/ewFB7nuqt7Fsg?=
 =?us-ascii?Q?XgF3MbXQ/M4bXysVTEhTajUqNStUXa1lB0CcI2oOm/3u2v12QhfIEo9UZY74?=
 =?us-ascii?Q?gqUf3KEs3JkMpCshMltyHacc0QKyd9FBxQ0N0tpuzVWo5mpGdSGqUBSeimiu?=
 =?us-ascii?Q?DLI7Kj/NgJPusR4hfQqp1qIsoXJG/pMWFopzltACERpP/Jy9YYoUTOcj2n03?=
 =?us-ascii?Q?7jAF6ydq1TrbWoT9A2g3iaCo1Ji35CBpnt5lj/KtKsVyqXsqSmOJq+1/+0xV?=
 =?us-ascii?Q?TJgvnUZmzHARJ/yeFKRFS1yFDfR/uWjFBDRVzAi+vcSx93DO0T1s9hXlnp80?=
 =?us-ascii?Q?7APGhZmbWUMpuYzSbhvLY1rqF6dzsWcsvYyXFYF83bAi12EEY2o6Dx27/+hW?=
 =?us-ascii?Q?LiMr9V1AtdJ0WDjoKpdYesLaOX8dRRi9TrdBmA+Gbbfi9LDsA0rUX424qRoe?=
 =?us-ascii?Q?4NVlvGBqxk3G1WDAt3QB6eI4w23gdLJ/rdScWYnvo66emfWOVc8zUDJet77f?=
 =?us-ascii?Q?jObFV5rDn0xqiHQSB9CW9jkQU+Lx/uu7O8ZJl7OOq5FTPisD6Hd3ML8vliD8?=
 =?us-ascii?Q?86i/O1ELmMvR4FaaAPJBhRF+pCI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4b5580-0332-4997-623f-08da5dc04965
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:22:47.2206 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MgLqrssDm37nJwNtLOqtvcvuY7TJ1MJGx0CEZFmm4AS8i/jL137Xo/AFj56C7qWDlEH1yGPnFUSPfEioEHIRXyDjhJ0z8l6yM1NZTw7jeNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 08/17] block: pass a gendisk to
 blk_queue_set_zoned
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

