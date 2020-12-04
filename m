Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA80C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:28:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 829A122517
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 829A122517
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-4tyAhl8kOVKMP0IdsiZK7g-1; Thu, 03 Dec 2020 22:28:30 -0500
X-MC-Unique: 4tyAhl8kOVKMP0IdsiZK7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 447395185;
	Fri,  4 Dec 2020 03:28:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA04B60854;
	Fri,  4 Dec 2020 03:28:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97F3B4A7C6;
	Fri,  4 Dec 2020 03:28:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B43SNft011877 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 22:28:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2B56C2166B2F; Fri,  4 Dec 2020 03:28:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FDE92166B27
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:28:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDA97103B802
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:28:20 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-96-aVgzRzJgNI-ep5brI5hdNA-1; Thu, 03 Dec 2020 22:28:18 -0500
X-MC-Unique: aVgzRzJgNI-ep5brI5hdNA-1
IronPort-SDR: yUq91tqXF2LsarP7EtILDOBsI4RalTlpr+6bx0CUT+/p6GVafo94M3ZrpNYw67lW8IQgiT7W9u
	km3dx4nkAyirCKVxRkOTqzJZx8O9QEh9nWPbcCAgLXfXhsRUv3Flwb7erp1QyFEZAYiCsZuPwj
	Y61lC7VZ7023690lHXAqRIHks8MQXUt5ridAJREtC6u/GB7KHMnm5ZiV9P+gLuRNwn8Jbiqrob
	GLx8Dw37AzZsob0lcPj2cyhM9or0OszzR7svXGNOIJkM9s4KZDDg5Rf4J3XxBplnRhz80FveWe
	HGY=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="154367154"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:27:14 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 03:27:13 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Fri, 4 Dec 2020 03:27:13 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 4/5] block: remove the request_queue argument to the
	block_bio_remap tracepoint
Thread-Index: AQHWyZEJoVE+oQs4z0qWLLn8W3RcJw==
Date: Fri, 4 Dec 2020 03:27:13 +0000
Message-ID: <BYAPR04MB496575248C66C4AB2877445986F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68c24a4c-f4b2-48b0-48d0-08d898047e3f
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123388399DA578319F5129486F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ePi2l043tN8CtI5QSJRecw050P7c/r84tFQIc6e9QM1RetHr0pUL2ZXkpzXlgBsjvcTWs/R4X6IwTsIf7gz/d+k4DqnM0Bq0yU1k7Byga+0ALKX0SfjXim7VBLzLXT1mkWjCjQy7GVUwUwhjo7aa3D5dMJ2LRBnsJ9TK2TZwHcQt1x+dxLPkj+W+NXbBavHMnH95YzlJtDSFtLEzB/W4mdcTKMAjopQEaXWJQORvYyUz40M4qsxalqxG0u2DE/gVl7stzvTgQrEwfhbvrL3SGv5iX70i5sNDthVE8LyBCZCk5/k5m+8DwCHqQk8LhHEE2Dmxp0EiEizaBu8L6ST7XA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UP1o6D+b4Ihym0hj217FRpSNmpmUzpEwAhCoBaqMYHZ6ubcKPk8Es5t2kctR?=
	=?us-ascii?Q?DClV54C0ru6+fy4LbMJnwZmvyfVLX9wEShZtZL+GvfpBYI8EiOiK9mzOkpTB?=
	=?us-ascii?Q?Pm5pjGxY2gU/vzpUuRgWHa6LF7dEdbVlek5o/W5xXZV67g2xnD3oLxZNJzDf?=
	=?us-ascii?Q?A46RJS+NHKyd4flZLzmhrrLvBVSI4lzdP6ad6brdVC6XfQXC1qJurcb+vhJA?=
	=?us-ascii?Q?0buwVqmoII1nCrwgXrAYIgiKxvsuAjCrRPPSfxlN5iOYWXk1wXIRqxtSCrZS?=
	=?us-ascii?Q?079BgwrR1kQMBYOx/caTYA2I8YxNCgUOdJWECaGygsy+7tk17bYeTxhplD4X?=
	=?us-ascii?Q?tH0I0meyU/Odk1CFCdSXE3Aqkfdl24JRL7pkkLOHsBKprNTlmrZ5UrLeLsYJ?=
	=?us-ascii?Q?YS0U7r3hTj4OfaMbtiQZeWKLGjs7Ex8+E3Ac477sjPv7Ttgk6sitGCFIgSgi?=
	=?us-ascii?Q?5Fx72MjTpnDW+XMbKtyYpT7hNK3JJBDdBc6EZIXMeD6Z+zdkEY7Mkrx44pMW?=
	=?us-ascii?Q?tN+fY7XYLXwwWp+oRpSmjBN7eVGFTH0KG69aMnNrI/mAKX9AFCkEfDnKE3MS?=
	=?us-ascii?Q?1BtH4qBI0kcuUHqhdG9Q9sM8BKtbbKplkRnMSkERfuR38qEPhx1fSl/EDo6x?=
	=?us-ascii?Q?Z1y//SxWFaahSnDge6ChSHGWOIVtnhRd5H1y71f3bMo033eTpgqGSB7Elaj2?=
	=?us-ascii?Q?Y0dGx3ZKyv3Bb2FdiRKJx8d9yAsRppjx48aKEqiT4wD3Z5Ak82OUKsLVrKg7?=
	=?us-ascii?Q?dR0CbEYWqkQcllFQQOkr626eOk8fkBZOBECd/UKh2yWiMlNJRzb3LpaE+qL2?=
	=?us-ascii?Q?iOj+aKlvfPfhnlY0lG5Ewqf7jzXRijK9IYxF8DNNncsGQ4xlnswS+tRbzTVv?=
	=?us-ascii?Q?yL0le+9rgNyPdc3/0I+U+6k9veN4KcB4I9efneIOenwcuBzX8OA/6AMe2Jd/?=
	=?us-ascii?Q?lu6TVB+8uJfml5XX/DbPME2Kx+wbJwB9vU/JeDjbq4hSiTUEE/5xnvJeO2we?=
	=?us-ascii?Q?KFJQ?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c24a4c-f4b2-48b0-48d0-08d898047e3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:27:13.7173 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LBtDKIFQLlcIfmYgchMeh3j1swFuVC2I2k3lAVErrnVdZNuXGLWxjm40YinIjc0xW+BMhn2UZQu1/ZOqziFIIoopg5hd2KMDq6GjWbWJqJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B43SNft011877
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/3/20 08:26, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

