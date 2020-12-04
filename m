Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58985C4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8997F22513
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8997F22513
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-0PbC0jXcNw6H9SH4ipydYA-1; Thu, 03 Dec 2020 22:26:56 -0500
X-MC-Unique: 0PbC0jXcNw6H9SH4ipydYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00B3E107ACE3;
	Fri,  4 Dec 2020 03:26:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D18B51A7D9;
	Fri,  4 Dec 2020 03:26:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCF00180954D;
	Fri,  4 Dec 2020 03:26:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B43QnnP011755 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 22:26:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 18AC93322D; Fri,  4 Dec 2020 03:26:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1249249B0C
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:26:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82830103B806
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:26:45 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-274-UV4KHYFPOY-J8ajCRUH2mA-1; Thu, 03 Dec 2020 22:26:43 -0500
X-MC-Unique: UV4KHYFPOY-J8ajCRUH2mA-1
IronPort-SDR: YXlJoeMZRlFvpnNuov4S3+4RSS3+fsNmDrW+FpcU16ytnMvEwdu2rxW0oFdbTSBeDUiWu/4Nme
	/ZrajKu0OKBuFVa+cluOkBRTDCXpvyVvsJgfkQPk1WB1AZrO/E3m2M9Tk2uABan1mk/D2TOTW/
	iotjUoBFpV225xZAzR0YdjBDeri5ERAg4ulSftAOpHvGOx8gmt1lrQikMosqkxX9oJetdwZFQF
	rsWFmZJKkC/woB1jDlFSEWGb+Y90kWsf1eUYCedh8BgmDrp3gZ4M+RdbaEY5V2AUXWo1/x8JPk
	jWc=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="158871714"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:26:41 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 03:26:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Fri, 4 Dec 2020 03:26:40 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 5/5] block: remove the request_queue to argument request
	based tracepoints
Thread-Index: AQHWyZEH9I3HmpQdbEaAKFJpCqVEAw==
Date: Fri, 4 Dec 2020 03:26:40 +0000
Message-ID: <BYAPR04MB49652797046268186CCD404286F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ddbe082-2b03-4175-3ea3-08d898046aa2
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123CB88A4B36159ED4555E886F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LlyA0bFNcOTanvc7/1m93CKrT5Cg00O6926GiSUGT/+bTGzWe3FRonO7M05O4GWaqHGV0nbsh0CLngsT9F1b2c1RpI+02SgxBej7ofeteprgi6nqpfwt+esO0nmB7/ov+bIixlGXQbarGHWU+O9OJ3mX+I/ILmE+a4o8ZVSnf6m1/rYiKztwzepci0ZHWR3jGqE725A7Rjk0K+Ea3T/NPdBs9AEIacK32Byr5QfIFkUPZsWTa6kWW8s6ftk5FJ+C2Flu0CRzQXBmKeCo9GiVUUNZDb0+xln1O5atcr3aLOB4sm5K+T1n+DKSk11zVZd3oViu+a+Iqms/X6N2tHEz7g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jehvkHj44GzbPPhJiu2rVqCyEtd9gao9KwB/nFR4yyp5+KkLu5HslmR2S4i5?=
	=?us-ascii?Q?aMf71l53ySFYec3C+AA0GdU2LAq15HgHFTqa+lqE/uHb1HJ0BFS2X36b3Vd3?=
	=?us-ascii?Q?dmGUl2TuE9QyBc145yNJv+zHUWBCYdJ/mW2ZysVin3j8tdOL1Ne6I1sxqaTe?=
	=?us-ascii?Q?GRQhQr5v2mCi0gl4K9z6layiRdAqqD6diYycypgkx81bDqOTXQ7XNZxYH73L?=
	=?us-ascii?Q?dcC6wrtpJJ3Syj/w90SmsYp4NkrgcN3xfdpoCY7yVn5ojk7VOGEqPyRSBSoM?=
	=?us-ascii?Q?PorBt2T6uo4/q3H9yiRqH3kYnoq552OGkZ0X2colPmS0pAozKNM5fuJ+z+fk?=
	=?us-ascii?Q?Cpyv5LqvOrAkJkCVEQbs5jH9VMPhmZ+uQ41bEuKbusnB2K34nZeQDtfhWoEL?=
	=?us-ascii?Q?NLXZ0jqzP9j4Jy6zJhr2du7PJry2zbsKsOyH9edFEcWXWjyytNA8YK6TDsUO?=
	=?us-ascii?Q?6eDXDYvsBmEP67tyaqeOQXypqs8dPIicvbpiRL8F8ygD75mUEro1r7QvMv+i?=
	=?us-ascii?Q?WemKEGgmfvwcsCGr9HCfwxqz+hhehKW7runWzUUgSdvfoLAt868FBbFsMis4?=
	=?us-ascii?Q?LY1xMuwCdsg5t2R3PyIMLA/mouPn1sCJ+3qT1OI4prl/vzf9VYP+W+FGU21+?=
	=?us-ascii?Q?KMaO5W4tmJxnUKEmNSKcTwttvwSYcdppCelTeHMEFzfT5OBXi25UTRL6M1Jz?=
	=?us-ascii?Q?XXorpEdkSa0TOYDwb4kk/YRc/loebj9hpOP83mFJPMPCCT5qgzdS7+c+r8rj?=
	=?us-ascii?Q?EJEyMk+XNSoIUbHaYq6P6RVGj5iAmA95se8hK/xxzNujYM5oK8bDCrHa0S3z?=
	=?us-ascii?Q?67/ApvmA6ijt1dswYnT666zz+85P8mp9NGxHNcC0ov6lKvPGhwxbAbZpmeh6?=
	=?us-ascii?Q?/vq7b9dbXEN6akgXATVivjX2flz79HNBMDbIuDZfVTRSO+j+OfrMCBQmL95R?=
	=?us-ascii?Q?Dlas8PqqPlUdrOLFG19DmegW9Gwemo/b0xk58JJJsj4rsFu8JPw65iUOr4Ah?=
	=?us-ascii?Q?cVrH?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddbe082-2b03-4175-3ea3-08d898046aa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:26:40.8794 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kkx3FLELLfmQBOqX6XmzcsGGKoYAUnrl/yFty+PBxSBW1XeD6oi0RJTxU2M+rsV+ifPNliF40tyf2/7lnrkaChmyz3qsy7DXyRynrFBOTkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B43QnnP011755
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 5/5] block: remove the request_queue to
 argument request based tracepoints
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/3/20 08:26, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the request.
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

