Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5418CC4707F
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:15:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2F1861419
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2F1861419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-uIWbv_ryNXW9Pnr4vLF44g-1; Tue, 25 May 2021 02:15:46 -0400
X-MC-Unique: uIWbv_ryNXW9Pnr4vLF44g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363091005D53;
	Tue, 25 May 2021 06:15:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D85F6EF41;
	Tue, 25 May 2021 06:15:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E235F1C99;
	Tue, 25 May 2021 06:15:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P6FYF0012485 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 02:15:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E95F200ACD7; Tue, 25 May 2021 06:15:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6908921417F7
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:15:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D03EA10334A1
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:15:31 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-181-SgUsM1r2Pu2O8ce82SFU4Q-1; Tue, 25 May 2021 02:15:28 -0400
X-MC-Unique: SgUsM1r2Pu2O8ce82SFU4Q-1
IronPort-SDR: nBnUEcTa8WxE7NGQzN8paYuI9UTWCHFCemhiGK93wwUTHIIPXVrrYXwC6eA370bCwLy7+KFtCV
	CgQ7/g2O4cXQEa60gihoqucKJle3lHppSeUwkIaiyDtbMZ/8C+7cWPY+eCv1tsXvTSyWeY2WWf
	52Im4NDCPrZZumnpFZ22YqZUegyAu31oFaEjCE9fyjiiuYtw/FMXpv1+TlD9GWGA7VQ7lk938+
	x5yO7QkES5iknD0BoXMiJ8Ve0lH3nR0Siooq+W6uYkYQSDuxY1GQ4WlU4iFkbfU8LSru1A3ppM
	GIc=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="168633722"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 14:15:27 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (52.135.233.89) by
	SJ0PR04MB7456.namprd04.prod.outlook.com (20.181.254.203) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4150.27; Tue, 25 May 2021 06:15:26 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 06:15:26 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v4 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXUQ1F6jb1VNqY+kaEwGILkKYOng==
Date: Tue, 25 May 2021 06:15:25 +0000
Message-ID: <BYAPR04MB4965719E20B551FF85B8E5D886259@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-2-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.175.137.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1625eaa-57ee-429e-377e-08d91f447ce2
x-ms-traffictypediagnostic: SJ0PR04MB7456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7456ED9BBB2730072036EEBA86259@SJ0PR04MB7456.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2331
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BuRLs4TOiXNS4k/Fzr/yUKJ0QmgUenKKWg6ADRVW1Guj8xjLAxEKe9X779ItNvDM6jOV27Czo0ZiVFQwfms1Jl7MQG3n9X/tTwo4iKinjq3bsCjV4ogT2Z7oLx3dYyS3rdyMBj7cp/Hc/gqV/hGRmmGhdYKTqhFGdYJzdHWU2gPrb9cjNfiQW7/ikCAP0PDg3scMmGXtCCVxdNQMiAk45wxbT1qo9bNj3haDwCBiahnm23ECLkvGZfhzTHH9x3chjznFxcAojXVMYzkeH/Jse+wZ105Jw/OqtD7mAbBWM82TePAs1CJzLizf8Qe2GuP9xHEv/8ubdxkFaezjDfx1fIeHX7ZvlA64VhL3Ho2azCizT9ihUhIk39n5gS2+dFDTgM3N1F4YKoEfLp6HZg8zmS8FHUn4tDbs4POG2jdeXCp7mVMZVIfgkfhhPJFSp8p6roQCFOQmiZhEM7DEJDE2/Woz2s/WVlTFOHnTuY4NbrmKN6k6kWuBiXEG9VYlPiY6f4yWuwdtqyJqWVSUx76Nxmu6/JnGj4CLTgukb8dekogoTH4nZtKxHnSOrGRI+Kunn6zpgPzYhqXkvqcHhM7npoZF78DMvXR1TgjbLLgdF9E=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(39850400004)(136003)(366004)(376002)(66476007)(76116006)(66446008)(66946007)(9686003)(8936002)(64756008)(66556008)(558084003)(71200400001)(86362001)(186003)(478600001)(110136005)(7696005)(6506007)(52536014)(8676002)(5660300002)(122000001)(38100700002)(2906002)(55016002)(26005)(33656002)(53546011)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E+gIl1vlrclBt9+i/rkyWG4w8gVfsqjq5SlGUHXVUj/qZEXbCHABTw/oglD/?=
	=?us-ascii?Q?3TbJxU8663lzYdqCnW8XempZBInUheAH6hsIIfHiRSbOAFjSdO2PiTYt+gbo?=
	=?us-ascii?Q?8ia28LE6v08RemhwB+29qa0RPBqULw9v0d4bQ9rOiotmg8JZm4tDBd5ah/ZS?=
	=?us-ascii?Q?HUbywTNHbGoBOb7bmLpm1ZzMR/QeLxG2vJo6OtEgiG2Z7WU7csu1E8L4Uw28?=
	=?us-ascii?Q?W0N2TO245OQblCwbbgn8sAL9BeUJsFIEhf7BzpLEqvvRdrEJeilachnx4IO7?=
	=?us-ascii?Q?zA/iQ/AkXRHjFx8BINmyvEpepo3RvXpNVrLlKU1wwCkq/Pg8CLLVM6lacwB6?=
	=?us-ascii?Q?Qod/tmGxA8WrsFmgjS8Ht8wpK/UtFp08YHgv+dqSebEhiAz9KB4Xj3TWBKhi?=
	=?us-ascii?Q?3wI6VpF3ZpFKQY0JVZ5hEOq4lNkjK1avqQVZNrrAPehSP1RTD8Ap7pkK8jIJ?=
	=?us-ascii?Q?vYIbTCbjmjCJrcQ66jXOHwBvXTAXsAiW41wwg/tdGCS0KITcsKz7hPWcif/S?=
	=?us-ascii?Q?EyrAj/8v3ce19PCFG7DkhCOh5TzrY4+NzOrEYJF6iXokakP5I6ohe40jnJtw?=
	=?us-ascii?Q?U2X/XO6X+aFXSbw0ERHeTiOh5FGsuZuthjwXcJhPL2OrwOtDCN29pgfFuUr+?=
	=?us-ascii?Q?u6ocey4gQvRSBvocQkVZZ9DfzU4xzGXrko+XvxiQH8nZ1UoUAMcFPVro9fLZ?=
	=?us-ascii?Q?p9bw+5ZJphEBZXAhXMeQ1GZ+zUVToNc1xOfYZnFO8pqMAQRDqwmgU4XGybO2?=
	=?us-ascii?Q?XjIeUzO4ujLBqrOKc5DfhiALw/B13NmBS28fMwYMMNHU/MEgdYOyAgp3aA1I?=
	=?us-ascii?Q?i/3a5ZcRyW4G2vthsqh+LJ1hVko9VP2xPCmygopoTgsqrkflgxdEmTYOPsLZ?=
	=?us-ascii?Q?5R0b815RNwnrMdZQ062RPdrC2KJPT/Qh4GqAUkNmNTWb+dfQy4jVe4VbSzMx?=
	=?us-ascii?Q?tJLcNsaxqr0TFRCZ0N4TL5jj6rK/c8UbvkEZ253BzWfDQls7Tlqp0mZhG2Ri?=
	=?us-ascii?Q?2nWhDCW1yojvr6QPbFSV+OiimmlAiOiO8Ubnt88avtVZfiPNotjkzU2BRNaV?=
	=?us-ascii?Q?XcK5sFRzRREXFMYZs1CO8BZVyzBIsco3ZCyAsW/2SgaVHCsTC4HHTYUT31wB?=
	=?us-ascii?Q?GekDhmwcXDg+gwyLFA7k5fG1GSMZFFgUch2duPzJG0k2mpEUvxYiWTYo/5At?=
	=?us-ascii?Q?rs0geDXbL430qXopMfxHdhO9qr8glgzn4+jgfat+A3E06u8AFwHpxyw4Q5KV?=
	=?us-ascii?Q?9GoJ0waFMbS0CWF7eoUQPk3SYBm+Wmk2pNKSqWbeb67VhnwjABf0ubNWA2rr?=
	=?us-ascii?Q?jXDYNhepxtwE394SHFqOUAqvrj7wI33rNG0SlSljeZEhDg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1625eaa-57ee-429e-377e-08d91f447ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 06:15:26.0924 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qe7RfpY+4eI0HITtQwdJhf67KuXlSE2y62eSeLFGNHtOj0ZxGrgAjWEGVj8SDoto5dglS57PBJbqIiSRBwnyrNmTmCYC9hO6kUQmLT5gFIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7456
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14P6FYF0012485
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v4 01/11] block: improve handling of all
 zones reset operation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/24/21 7:25 PM, Damien Le Moal wrote:
> +	sector_t sector =  0;

nit:- I think there is an extra space here after = .





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

