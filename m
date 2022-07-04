Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA3AC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656940692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=ZHZGV+1822/HaOSZcHX6y5cwZY27axM9NWXRA6reoIYWxNFvzj+83H+xOu6tCCX6GJIx/O
	ZRWzlyDgq6aturShOI5rg7AV7S13CTfGsPwQcX0sKUNmCR21jOsUL8zfChFhjVOiYAFDA8
	Uq9P8ik73JWY2MU2ZbQDB539Dir/KxE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-UMIyM5HoPDuBV2wWTuLVSg-1; Mon, 04 Jul 2022 09:18:11 -0400
X-MC-Unique: UMIyM5HoPDuBV2wWTuLVSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBFAA85A582;
	Mon,  4 Jul 2022 13:18:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB95D1121315;
	Mon,  4 Jul 2022 13:18:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 74D131947051;
	Mon,  4 Jul 2022 13:18:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2EFED1947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:18:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0531E492CA3; Mon,  4 Jul 2022 13:18:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00245492C3B
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:18:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCCC9101A588
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:18:07 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-UraTszBRM563APM_YC_bQA-1; Mon, 04 Jul 2022 09:18:06 -0400
X-MC-Unique: UraTszBRM563APM_YC_bQA-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="205481557"
Received: from mail-bn8nam04lp2048.outbound.protection.outlook.com (HELO
 NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:18:04 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:18:02 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:18:02 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 06/17] nvmet: use blkdev_zone_mgmt_all
Thread-Index: AQHYj6QA8GLMDjcpPkii60hZ043CyA==
Date: Mon, 4 Jul 2022 13:18:02 +0000
Message-ID: <PH0PR04MB74163E993F0753B20AE554279BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-7-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1effcd6b-cbac-4607-39a4-08da5dbf9fd7
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5L+tqJL7X02V1tbb50pBRx4sqj5cOWWFf96ftum9jMmeGC62qaq2Hq5z1iWVHB/TOw+xXwcxPxqNkWCeW9xaM+tbaAU9VMbhTYtBgqsj1Ec3WEQdRuDKDtqQHh9/0pfj39XZ2UoVLLUsMdjXHaU8f2gp+e0ZJ9lsGx28sKaRyBVrS8D0DoKH7bZEb0vWDwCr4Wn5vHZt56d8P/ESpjVNEMiOGST0P92OyWYL8GnisZsLoreGkepMRq+sn8osKRYSF9Dk+b2wZ99HUxzS/hfQYV85An3flPewwlqH0m6arIjOxOfOmWay7XRC65tDYp2BBmwLNdABbsfCx/0k8UES7H3phZiOainSFMEAImEvFLM6LPzWGImE101wB8aywq0wg9zTzD0qmKlxq3ZbdnF7RJep+aCMklskVug5bWLzehgOVtUZiO87C9+RiYQIocnIHqWwBzwKr0YGr/+z9ywhJI0pRoTmM8MykCn2yFZEjKuQJgKJYtXas8PUpj55KcoDD08fueq2alQWWCIpIsVQdhereFYXXr/QkGa/vFXoN7UecX8USHuoGnOQv4N9FPCkN+YX1gemBjJcF4Sa+/o5KYzYhB+L74tDN2oCaToEir+fMnTCJVr1STINH6xoOU1KbLcI76DBPlbpi6qfaSLZoIHaSa6PbNeB5WeWlKJ8aRyCrGSEMjd4qOV/VyrVVBmp8A7c40P/ejePE/2cnIfnnfewzQgQAC0KSV6HY2q+EpU+pTFS3eCKL6Oyw+qY/nsLv/HKqfSrGe5oTUcZ1Z18XESZYH6GjwSftqm7pDT4u9bWW8aaiJrlBt6ibKxe24uJ
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(71200400001)(478600001)(91956017)(86362001)(76116006)(558084003)(186003)(33656002)(4270600006)(4326008)(110136005)(38100700002)(7696005)(38070700005)(66946007)(9686003)(41300700001)(316002)(54906003)(66556008)(8676002)(66476007)(64756008)(66446008)(6506007)(52536014)(82960400001)(55016003)(19618925003)(2906002)(8936002)(5660300002)(122000001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ByzlmdOu0V2jz1yL2h9zScaeEIRIXCdgCDtWUBKSxY+dvBkzOydww0DKvnAn?=
 =?us-ascii?Q?5NWNiBashwwdOOYT65hSjK5rK4qihKU6aoZu1y8Wj77zxLHzM7rFzX0dDp/j?=
 =?us-ascii?Q?8Rc39FbnbRirHSzuJPQ75dUfLDzeyZwqKdrUiUaKg4rAV6xreOXVmUImXlpm?=
 =?us-ascii?Q?W3bA+flo1AeMPE1yO5+xaetaHImCKToe1vOf3NyC87EpfvPQo0jXI+FA4orV?=
 =?us-ascii?Q?XhUHDgYwR2oPQ5SGPQMFDzxXvp9xhQ+DoyiDPMZElmXuMn2je+LRA8JDPepi?=
 =?us-ascii?Q?KAKfER4ykeVaYXjOYnwb4fSpOInFvql9GDBJ7J5uSi7/6BK+sKEeYcc4pbTE?=
 =?us-ascii?Q?TECtcAuRS/WWNB6qzmVzyQ97UMwod8i8NLMfbIRaImdnEiZLrl3U5k+hadkh?=
 =?us-ascii?Q?PGVjeTC/iKKAA6Pwq11zVZ3YnrsAgUIl8ndkMFG9befGGQlfDh3N0mM2h5Au?=
 =?us-ascii?Q?3YHUk+gKa8pG7F8A/lUSEZfLdqCS3laB2pOlMZtPxSka886YWVZtPst/b21w?=
 =?us-ascii?Q?oHOamrzztpkc/T/zzRAoGmcQwJecuYX/kP2tBgZbGOacqvTzG/wTqY3KHGA6?=
 =?us-ascii?Q?I+EXU/qpMV24ugeMuEKeZbtHG4FEH1eMj2wtUHU9oji7kYwaRK3bYx0GoPNN?=
 =?us-ascii?Q?QUZZvuczH66cuitdZ5lmM/EQhi6SNZG/jjhWFxglyFrB7+0bkh6WfFyXLkfi?=
 =?us-ascii?Q?JrJINRHtNFvFWnaFiugA2M/TkwYwZ/9nrsghhJNeDFO39xOAwDaLgZAOYcPx?=
 =?us-ascii?Q?O4vNMmjKyBqm2YUa+2aqzNA9akFYdigwtMDTxKkPdY4ds62UtV9cLTEtxgpx?=
 =?us-ascii?Q?x65ceGJb1ghLIvd9rTlbhmmL1ybnzVbNpv8eZHBdzMd6VWxbSFPLNLXxsaD6?=
 =?us-ascii?Q?Havb5DFoq0sibPG3g4XUfoCBYZyJEBK7/tAnKXckWZtVI1yrydoVNRCjC45t?=
 =?us-ascii?Q?ihWlP3eeLjywx9SPgdp12JbQEPocGFMf1ZjHc+kbXL4bciIdWta0lwY9EIwN?=
 =?us-ascii?Q?g6yL1KtEfXIm/EZpyZw+q0r2WqCrvOkmdvoSrj1rUkf4g0jBGAk1V1iWQ7oO?=
 =?us-ascii?Q?qO++ZxlCJ08nXHHhHA2lGMLknmqbJxYYJQo7nZFJh/br672Itv6Oqv1OzNkg?=
 =?us-ascii?Q?3atlhDknxoCHO0xQ1IzgnoE815n2c/MIJBge73zYpe3xdbSBNyQkNmPbCy6S?=
 =?us-ascii?Q?FyAq176Z5d/8wLYw1o+7x8SSnOJteYHcq3e8k0GGXthzAz7vYGJGyx4tN3zG?=
 =?us-ascii?Q?qZl4K0XBDTEPFxhl32RjPFmwqSkPaiiZuhowstcCP+6vjyZvrK9/wSbwYj14?=
 =?us-ascii?Q?yymsPIMRl1Wa0cUGuxiW/MtpwKF4+uan+u0LM6sgCbtg71bpY/Xmlb9+JFS+?=
 =?us-ascii?Q?7reLouVmfppN71zzn/zF1CzCLYJwosBcMB0VrLIZFlDzKpCTSQp4aDBBlst2?=
 =?us-ascii?Q?MHxRS/BmRwv13dyyYqFtTgizrP6qBwjwSiFoLFOwjvsoI112lM8miGyLMYvd?=
 =?us-ascii?Q?b+R9PRREgdbJrBpJe25qPGNM83Ugs2u0zEDpPH+ulkCv/hriNVcTz8Zf5gAl?=
 =?us-ascii?Q?sFx/tv6BTEB8z4DHKSgozH2Sss1+l0jf0l+V7SZGxHimb8ADzJHAFBB5ZCnM?=
 =?us-ascii?Q?xu88YOC6t5qN/2K6cOyQcsOIqTVuxHlVwz8h3avKpO4En9z7B7AKNOk5ItaC?=
 =?us-ascii?Q?pBAIT019L04D8xalZmzpSVkDFRM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1effcd6b-cbac-4607-39a4-08da5dbf9fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:18:02.7696 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bIvNKMIvMdStWI7HV12Ue3omv0A4GOuvBDOku9OJE2Rnfp2WcPUuwrp7wA6NJD3O6NePqVAM2KYt2anxHRIfQvVUbEAMjuw1C7f9b3SEcns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 06/17] nvmet: use blkdev_zone_mgmt_all
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

