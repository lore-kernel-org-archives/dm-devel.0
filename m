Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B504ECCA479
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=SiwnGhL2/ZdqiqCbrjD1hbS4tGcYvMMsSpZWYtXvoPbbuF6Ebv4mObHRxlNysRZ149QjLg
	zEQoWtSP2/W8l2bj5ZmoQDRUPF2G5tBZomK+deIokdN8rP5SUq9AgQza3PYVHZs3YeA6iE
	RyPbObR6t1GLtk2caRi2AW7tCjtLNfI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-1DJtEt_LPJWG3skcs5fKJQ-1; Mon, 04 Jul 2022 09:31:44 -0400
X-MC-Unique: 1DJtEt_LPJWG3skcs5fKJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4568339A2;
	Mon,  4 Jul 2022 13:31:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3A25141510F;
	Mon,  4 Jul 2022 13:31:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 700B41947041;
	Mon,  4 Jul 2022 13:31:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 31E3119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:31:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E61B40334D; Mon,  4 Jul 2022 13:31:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08DAC416362
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:31:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5864101A588
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:31:40 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-cKIJxR1LO0aX9MwEC0D1vA-1; Mon, 04 Jul 2022 09:31:39 -0400
X-MC-Unique: cKIJxR1LO0aX9MwEC0D1vA-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="205482310"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO
 NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:31:36 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5111.namprd04.prod.outlook.com (2603:10b6:a03:44::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:31:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:31:34 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 17/17] block: move zone related fields to struct gendisk
Thread-Index: AQHYj6QTmt5LLNqexkS8cDe15DahjA==
Date: Mon, 4 Jul 2022 13:31:34 +0000
Message-ID: <PH0PR04MB7416A7146F81E75CAAF879869BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-18-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 900f1234-a566-443f-6880-08da5dc183ca
x-ms-traffictypediagnostic: BYAPR04MB5111:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JekAKW7EfhXRTMYR/u1T5t4hFuB5Hsg606sSlX9rXqHOvq4TrHmkRa4Jk5jhrJlVOyeJIx677B83eSdKYmZKZwQQcxVMN27pGzDZgsZfnmtPBGDJath+WMdsZMcQWrqdFaKqMyK0pRvoIGPNiLEhrQI3VIdh1Ibm3gcRQIzj27b/nqd62JxwwIG/yUO8CwHE0gl/Ng5xVGekZiLnXpMQoJ1iW3TeFF/pH503IBGEWm5NCsz53SnBTaC/RqcK3T/B0RL97aBSTvHoo6b+CBQ/b/kTqQDPnyl/FXP72EkiRUKZLk3hME+L7IdSiagBhb5Ak8ByA8rxHBxfubAoxiMZ7zjY3ox0FcxWemsVp5yh+auUIufsdQdLYqIfY9fX+fdOtQ9QEwgH+NC5gp+WIWsrIq1Tt2PWbnxBYKA1BatUPGVqf709szKZ8sa7A6m4cx6qGwRSiru1o18l8sc4Z82k0b1PCTXfPCvkHAbeTOgv/EYC6OlNhcFf/VkS/JRKNaF0ot3QqL0yN0U9bkufdeejH0fePFelWO8oNnvilrop8njJ8brhqxblcGaLdR8dawswjxKKl/EW5wgWtfcMAxHZBhWvMOqI2iLRQyRyibMyi8RRT26gmBbq14j6b7RIYcU9D+ZC8MgxG1aRG3hdOor3K+b0TIDWC7mj/YUsJsXWrZ2LsdxIMKZLtmNt7erIAHLDkGY+Lj11X33yZCXyIFBlj3Kq7U0Yp8SxMNRpQFwjZPOVUZD8750CS9PHQ5DjdXFd1w9wQLtkh9xowoDClyFNf+SYB22uO/FBWo/sjCNeWbcxkVijzPYMLdIof0C0OMtN
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(64756008)(66556008)(66446008)(4326008)(8676002)(66946007)(66476007)(76116006)(71200400001)(558084003)(54906003)(110136005)(478600001)(316002)(8936002)(5660300002)(7696005)(91956017)(52536014)(33656002)(186003)(19618925003)(55016003)(82960400001)(38070700005)(41300700001)(2906002)(86362001)(122000001)(4270600006)(6506007)(38100700002)(9686003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7RIjXXLV4nmW+PXnIbxEs+4aV9H6zExEAW3HS6Bsjjxa1Cs0X8m0SQZLaQon?=
 =?us-ascii?Q?8L0WuyVKS/JCLrCJNPcWkhsTV+urO4myTtbDUYLxW7X0cfiGYWxcLHulnAQy?=
 =?us-ascii?Q?zB3aMdenHTOkkRr2nLyoMhDk3SGan70dfCofMaerbIxCCWwjEAj/5nGhpDyT?=
 =?us-ascii?Q?Cuite8UbQiendwndAwKc6sUMM96P7FaPveNVRP9t78Hrau8VHa2juMDhhs/q?=
 =?us-ascii?Q?G361vEq1Iyiu79kICwa5rm+9j2uH/RZaV75lULfj0UPeARozBpjU3mPpsdIk?=
 =?us-ascii?Q?23kBH3ENhLEMecZcVtp7a96nolyXeELS7GdLSuLpGEEhwD/fXyT1/IwkE1bG?=
 =?us-ascii?Q?XUlFl4jDiu2I2aLW3F6gO+4TjSEy8VnY7R8ah+ErIF3n1GM2EzWTY4De1Crz?=
 =?us-ascii?Q?GWGOgsgFql/XWcYQWiuN4ynrbvo8SGu0VwsKB9zkAlOpB4ZUHtujaIAumji1?=
 =?us-ascii?Q?UHwEE/x59J6M3bPI4CfEM6gf9VkErBd6+ORLs4eXNSGLJXzORw+CqN/60few?=
 =?us-ascii?Q?T0wiNJgfhzS9GnIqLFRhohII4PjMs8Ue8/4TjofkudOki6fulqkrdnvvhi7j?=
 =?us-ascii?Q?Wod9Ov/6N/ohSgi9aAovkRg2VCOd53VVfj0Qk4KKPdTJJ5Lr617kWGwfdOsM?=
 =?us-ascii?Q?31vgyytN2+YRdGLaUd1nBmTHMOHRmpv2zyCftDj/yiG55/tdiJaCFhlgrLQB?=
 =?us-ascii?Q?jJ2RPFm4kgpnhFE+b9RWhbFQd+J+Gz/DzQPh979YGdBNhAe0uXikrP761YJI?=
 =?us-ascii?Q?nmNRyPxK93JIrIJnEJSUyYJ93vnpyB4NMQYeAleW9DJVw3/V/bSgcV26g/eD?=
 =?us-ascii?Q?0e4GiKldF25S+iAb1shK5Reqh2t1rbOiHAfyYIUHyBhVicBxoujpMka3AHFB?=
 =?us-ascii?Q?xYAOg6Nzw/adKk21sSNRw7CKZM9LhS0Lkavy1e5hm/c76TTeEOI0lK1uxBVP?=
 =?us-ascii?Q?dGDrf5IUnLuqZLydW3Il/vS3ksPDpy8t0y9vnWvMZeWuuEXwsRcTWUkAeJAb?=
 =?us-ascii?Q?XmTcguHpBteV+97E8wJaYUF5C9ynxy/f7ElkqPoDENTCbQMAPlAv9Xzb1kym?=
 =?us-ascii?Q?zzZ7mJ6b5DbI9SLArr6KwtVN5n9SQandN/qpoayCIWAvbo10zWpkL2S9hBD1?=
 =?us-ascii?Q?a4tYiEjDlXwxLjhT9EcAUCPuKTMkENElRshBSUME+Q5Xa91YxaZpm9NCRKSH?=
 =?us-ascii?Q?kyORXLZIfhiJ1Axg2qTC2F0v8UCbuw1DoHqLwIjqJQxvhLtUT191azaZ1+lL?=
 =?us-ascii?Q?ppCmN6GklZmLwu6LgRFQh0HLvozUY1pOH9cCeyqY8Q1qL7g1YZQKhfpZM3WM?=
 =?us-ascii?Q?NeN2gw5uAcptdUjtLKPvI1LNNlAR+XZEUM/T0ui2GcuMWB2GO4ogqLgIko6p?=
 =?us-ascii?Q?HmAy99eu4Eq2hL7LS7LVuo/a/7cyrZnhC3egqn9rWlSCd9GPg0iD2lWC8doM?=
 =?us-ascii?Q?IpPDkM8Ry/O5nPsXirNXQnwSdD2K+CtxzJksldOnZzu576910TWxzFC/D3A5?=
 =?us-ascii?Q?pUybqpdssFXeRF5IBLxAg9pXDJBgTEHsw40IEjakIRixOFIAFfBpc3YSoc0Y?=
 =?us-ascii?Q?pu9di8dOE1hTxyXpSK8QtK6ztdZs2vvwReQVB15f063sV5gsYlATtfSiwD/i?=
 =?us-ascii?Q?Ck22W3uNlAGeMtYRiaWBOHUAQSoQ4YWTYd4iTgPd7eCbQo6jp5Nw4EIeKdyA?=
 =?us-ascii?Q?Y6V6nGTXgdE8QAuams4MK8VORrM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900f1234-a566-443f-6880-08da5dc183ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:31:34.7342 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uAvGSDH2pJRMHlflwm7oMp3vdnjMwoFBtLspUuUDi3FvXQjcMC51DXdnbl+L5j80a3b+wejqJONRLXPlf2oPX4JGVWA0wIpDsmbuV7fDct4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5111
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 17/17] block: move zone related fields to
 struct gendisk
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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

