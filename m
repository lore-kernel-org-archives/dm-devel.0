Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5A7C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:58:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED4C522AEC
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED4C522AEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-BYX04gCLPMOh4ffBC_0xhw-1; Mon, 25 Jan 2021 08:57:54 -0500
X-MC-Unique: BYX04gCLPMOh4ffBC_0xhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D533A9CDA0;
	Mon, 25 Jan 2021 13:57:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A26D960C0F;
	Mon, 25 Jan 2021 13:57:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 918F41809CA0;
	Mon, 25 Jan 2021 13:57:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PDsWrV001107 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 08:54:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 564A85AB8C; Mon, 25 Jan 2021 13:54:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FA4E2EF86
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 13:54:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22976811E85
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 13:54:30 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-257-fw50nKkvMp-EeLJO1jy8kA-1; Mon, 25 Jan 2021 08:54:28 -0500
X-MC-Unique: fw50nKkvMp-EeLJO1jy8kA-1
IronPort-SDR: w9f7yEUHTBwXH9ZtLOs5/TOVOPlLhmMnitvBAcZH78kFCm5hRy37eqUkH32WYLvd0wuuvundny
	JUjSb4iKAorYOruy22KO4j5kXm5DSPE10b3LRvWffh137kdw7tMsdcRVqU+2eJVfc+PWz+o8C+
	wnO/AMVGbs6J8RlyeuqsEczMUgZ2fJ3tcj4NUp3GDoh5vnOwQH6zAnOILIieaKdX4p3Ge1tKs2
	wz5UVKeuuhGsBGVhktQEarEoqwwe9xWZlSdKQalGvBv5gmJ/LZpSesfpC11dGVT9cJ6Hdhj34V
	lVc=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; d="scan'208";a="262261185"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
	by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 21:59:11 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
	(2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11;
	Mon, 25 Jan 2021 13:52:20 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017;
	Mon, 25 Jan 2021 13:52:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 02/10] dcssblk: remove the end of device check in
	dcssblk_submit_bio
Thread-Index: AQHW8jiwHN0LZhsDiEuvFiOYbsXH2A==
Date: Mon, 25 Jan 2021 13:52:20 +0000
Message-ID: <SN4PR0401MB3598F6894E3789B7D3FCB7679BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1e656bc-f908-4935-389d-08d8c1386f73
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-microsoft-antispam-prvs: <SA2PR04MB761269F9E0177D9E9267E7D59BBD9@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bU5R9tm9gvsBNXwaTw7lhZWx8a3ybA0DpqZLEQ5vuCd0GbwvvliXQ1Zcz7aRVsBwnudvUh9IyMRb94R/r1DC7Mc2nkztLx4jnPB8k9cLnlhsxo2X/tGwY9MSJ/43HZGMOyOaknzujG2bwmP7xRt6MTS1t1Ub/vJccUp6FE//bYpyUUtcfa/RgsiQfN4tI0mAbRySo0EgntHNhTK9aMolg3vULSVbYUx7D2Mq8PHBTb4H2ObQFGVb/1WQIdwMS8aC9hNR9uDIH39CoIBQmKWuI0+VERppoh7OXSuSMj1ssd23sD3FtMFx47xi9lfOC1EWd2EOM+y9CGJW5gjFQO7FdwZj9n69zFDcGgOAYd0DT67tVpZn5TRkqUkw9kqcgaCbo5VrrRf9NPF6dTpvn4cAoA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(64756008)(186003)(5660300002)(4326008)(86362001)(7416002)(316002)(8936002)(52536014)(2906002)(33656002)(66446008)(66556008)(6506007)(4270600006)(66476007)(55016002)(110136005)(66946007)(8676002)(558084003)(76116006)(9686003)(478600001)(26005)(71200400001)(19618925003)(54906003)(7696005)(91956017);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lDHqkrQZVyGZ31ML1d+IhfEcdPEiXrPozKBjdBevBrp1zpl2XoidpNz2mXTE?=
	=?us-ascii?Q?6/3WStXkE+FSLY8+H0V6yFVgE55XlWaToz4fvdYixnUNZHlu3JnJf8n9xKLf?=
	=?us-ascii?Q?WoJOR/lTCKliSW6wi+8ZnrJhw77ct+Nf9fvUt2qUFjFYvwOzEKNkcjO/0UfY?=
	=?us-ascii?Q?DTjfkYFJgl+d/2olcMOUtYqKaCa9piBrIATbU5zJichvf67oRdL3d4kjVtud?=
	=?us-ascii?Q?W5BkAo9PYzU1TpfcGyuDox8ipXSBAEwV4V5s5BEpFMCGQb6ffamau+h45y+d?=
	=?us-ascii?Q?k/g9e4/YuyJDsnNFKgHmg161493sJutWrBkIegyqz7NI/Ybj1SUBdYcdEd5Q?=
	=?us-ascii?Q?qjSJLlV/+JJjE9dRaAVyS/dhLUjC4f218fn6rCzGBNVQibzUQLdZgAMxtPSQ?=
	=?us-ascii?Q?jSGGD/QcWf4xkCnAUW4Z9Q8HhOYSxiveujCSJskhfdcMlJz7KNnQt9gHBsYo?=
	=?us-ascii?Q?aJIUyUKAjWbmJDWxkCA//ZQbn7/bdnxVSilYIU3YXg6GrpCij4hLMFsLe54i?=
	=?us-ascii?Q?DHjeS6s8QhFHyRP9hv22rwFS6sN3tnQfkzSWp8VMCs4p+fXVDmSYf0+7vH2m?=
	=?us-ascii?Q?CzeEM5ZFgldTFeuBpw8jKB7kDuPHfileuYYuK4XUDLxlS6QZy5xsj22vpk7L?=
	=?us-ascii?Q?WAy7d5rBm+96PHxnpnVSCyJqKZDfIiqM8cQiwk6I0a7/0SnzsEtGs4IYt0FB?=
	=?us-ascii?Q?NlZvHPzsowE2Br3d7ZuHMr713Hn1PArjvlD8x8k8wZMvoEFVxYj1MYJvIuFj?=
	=?us-ascii?Q?+yo41/bbTC3N9+wMoiEczrV9E5SywMRR0MIHBcmwSbnMhDURnABRxuVWfrga?=
	=?us-ascii?Q?SqZ2wo7S2L3vyFXE7Sx7g2g9/Jf1lUTN5dtMeOzcITLOnMBfBX1vjBZeotoy?=
	=?us-ascii?Q?S15nHBW15drWRG78GsnEDMxEFI6w+OJr/hty1rSC/25m0/fvU+UHXZJmwNPC?=
	=?us-ascii?Q?Bw1QawKtheMInGW4gxGvqE24WKa1fOtgQhu6FXUNLln19F1ddlMNC+MDTg+z?=
	=?us-ascii?Q?oywG1pcmKG73YoufraIiF4Zv0NC+jAkI1sICjrZEItLHz4s0u57a0R//2RCn?=
	=?us-ascii?Q?XiDd4M+sH2ypNbN1pGOzVPvhXmf7qA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e656bc-f908-4935-389d-08d8c1386f73
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 13:52:20.4127 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cg1G7xyT10MPoHu/nOwo5LbZhouchgS3A+abYpZxs+RvkR1G/A5gL8sBR27JsumSYIw638q9hWajJ3kcMMiE5JBNWe7gKtPKidupxFHsrFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10PDsWrV001107
X-loop: dm-devel@redhat.com
Cc: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 02/10] dcssblk: remove the end of device
 check in dcssblk_submit_bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

