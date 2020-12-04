Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A1CC4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:26:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FFA022513
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FFA022513
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-QOZH7yRlN2KkeIyHlq_-xw-1; Thu, 03 Dec 2020 22:25:57 -0500
X-MC-Unique: QOZH7yRlN2KkeIyHlq_-xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58B488015A5;
	Fri,  4 Dec 2020 03:25:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1194C5D9CA;
	Fri,  4 Dec 2020 03:25:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 872DF180954D;
	Fri,  4 Dec 2020 03:25:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B43PlUb011619 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 22:25:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD55510D1786; Fri,  4 Dec 2020 03:25:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8F9310D1784
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:25:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 704708007D9
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:25:45 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-43-iVPAdBeBO5m0FYwzVxuIoA-1; Thu, 03 Dec 2020 22:25:43 -0500
X-MC-Unique: iVPAdBeBO5m0FYwzVxuIoA-1
IronPort-SDR: O9LN1l2oY9cZQakA+qQcogrRIeadm3DIscpuadbFTjZ5wItaKY9ewSqXCjl1+eOpkMUQFFIi7y
	KS2re6rvYWk2t5sjjCwSuTbHRwTNqGQPEi3TAzNlPh7Y13OIyKmuLFYT6Wi0HPyK+h0SqgFlZ7
	QKX5udFYbegLf8DGK4YBip8aomBevwGNGkm+AT2h9Tf405DhdniUe6nWD8v2+Xz3PQb+PAVBYm
	fVaAqCuYr/H/tx7EbDpwBfY7ntf03PoJWmpQe5RoLxBqCN5O/f9Nsl9H6qXOQQI9SQ5DxgEonq
	ibs=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="158871665"
Received: from mail-cys01nam02lp2051.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.51])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:25:41 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 03:25:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Fri, 4 Dec 2020 03:25:40 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 2/5] block: simplify and extend the block_bio_merge
	tracepoint class
Thread-Index: AQHWyZEHILLHp+PoBkqSaJmYfzy5PQ==
Date: Fri, 4 Dec 2020 03:25:40 +0000
Message-ID: <BYAPR04MB4965479E53991BCE68F1139386F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac388c11-9e74-4781-5a86-08d8980446e5
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123C6F9E3F0FD169FCF49A586F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: vfB7oPv/185w2bm/l30Fscpz2nhXNa+DngFtjep4noRPtLXbBbnIgG+HjmcN9obpc4zjKg8n6tGwTz+ZkuD2OiejZm+o+Y3+gFuUUZpDLyCR5XHAY6Gw0WMo8ry70lhYVE0IjFDXS44aXDfPZY/+tHWhrczoTlTdYZ6bNuDEy4Igrh16znKD4W5qfI6xpdAWVGy/lJMr367KfKL/qlD043ESf5yavlhI5ojZbI97wMPbGYxV1oCYDbXIlgC/gutsENwpi9TVqVWSVQGK7oe2Cx8rIocr4MPlsbeKoOaMA1glsq0/dlDQhAzU7/dDYSyNpbgmgzxOiDaicXEsAENppw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4744005)(4326008)(54906003)(316002)(110136005)(26005)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pCGITpCFpePEjcgAI/h+eeaeUlrHCXP1rHBleEBsIho8OqmsXqX2oxphHNWy?=
	=?us-ascii?Q?WGMgJ6Cw7wWksZ/3kks0wHEuiGY08EPddgfZxglkgByNMJZbFxzAci8S8BiN?=
	=?us-ascii?Q?gO+XgDM7sZAIEfdhXky3etzuzctJ9tiI3ynmeG3BVVWW9xw9OtLAShiOjTRu?=
	=?us-ascii?Q?DpJEM0quzd1Zh/KAUa5hy4+91clUy/NSWs5xzDqbtyGKqQGcJEC+Wekx4Eqp?=
	=?us-ascii?Q?DFd0Qrrg9nOQrw9q9eCFMevpWeQcTDMM1peGDrkyA6jX5aFeyw2mF8i+oKFw?=
	=?us-ascii?Q?Og7kE8r+NlRFxK+r+0FOGSPX3EZ0vL++q+FR96R05TX6O8O+jgzGZOKL8/ev?=
	=?us-ascii?Q?osFiojUxLnQtBLIYb+U5frGo3Gyj6OoygpJr4L/9L/yok3gP2skqLBKViZXW?=
	=?us-ascii?Q?JMVwdPfEd4LxZCRhIvpWI624BQHMLjps1Il09uo1khFvk5amddvOpoQBqnUu?=
	=?us-ascii?Q?LzVjeNede0aa5tz5RKrYBTGZk2vik+y1DcNprg6qFQlx601KV+Szw9pKuhu7?=
	=?us-ascii?Q?mZRDqScjyPQ2jCRByIypFMAvM1W/IQwihd/A1uMU6s83gXmwrTm1391q58XD?=
	=?us-ascii?Q?UMuIJtZMB3rl/R7t2UjWwGcXrfgoq8IZjZ6EPRlB7dKxuS5/xSufyB/v0XjW?=
	=?us-ascii?Q?YfU+KFbgUpb8oyOPTkRf+yvCyCWPRXAxo4LxlFazmpMAXM07ftyBMmUBHafe?=
	=?us-ascii?Q?IQiFDldydjzCfLAjIUb9se7vJ5VVQHgfFhF4mgO/JuEGb0ObuzQWU4iE+B7Y?=
	=?us-ascii?Q?v542c0BRA/LiQIxEeDzasFNbADx/v4ymVHyGxM+s0hXPA5VBVpOZQIAPiycM?=
	=?us-ascii?Q?wyqJqISD40XkpYmXToLc6egkdHQDg0MOASn8z4+K4yWllBybqVaQ0zF/5tGw?=
	=?us-ascii?Q?OP27fO+9Pfp4SRT0Tp1FJSZErDgoftqHEoeUGv7zEqEjnf/PaQ14BJaNwG+7?=
	=?us-ascii?Q?yLsv33S7X/f8NK+upMzwcmkS3itpSwpq2HVGZ2dqKG4okrjv6rfouMKFNOuH?=
	=?us-ascii?Q?G5Vi?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac388c11-9e74-4781-5a86-08d8980446e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:25:40.9002 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vJ5Fcen7HhPxLGdM0BQLmC8yeSosIiQZXBSJv+zrHvPW0Yu8AoDW6bBd5/AYH1rUY2Mx1Cn5nHqLumma7q+8CgLt1dfuEMjuj3a6XNSZks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B43PlUb011619
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 2/5] block: simplify and extend the
 block_bio_merge tracepoint class
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/3/20 08:26, Christoph Hellwig wrote:
> The block_bio_merge tracepoint class can be reused for most bio-based
> tracepoints.  For that it just needs to lose the superfluous q and rq
> parameters.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

