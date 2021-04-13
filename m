Return-Path: <SRS0=RJDn=JK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEF8C433B4
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 18:38:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B02B6613C7
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 18:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B02B6613C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-FCfsqlduPHCAeBunZnhE8w-1; Tue, 13 Apr 2021 14:38:17 -0400
X-MC-Unique: FCfsqlduPHCAeBunZnhE8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 541BE6D4E3;
	Tue, 13 Apr 2021 18:38:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 790665D9D0;
	Tue, 13 Apr 2021 18:38:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ACBE11806D15;
	Tue, 13 Apr 2021 18:37:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13DIbvUK031805 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 13 Apr 2021 14:37:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9566920148F1; Tue, 13 Apr 2021 18:37:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E63C20148F8
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 18:37:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03339100DE7A
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 18:37:55 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-548-_bdPfGg4NQ-AEcEAvLLUTA-1; Tue, 13 Apr 2021 14:37:52 -0400
X-MC-Unique: _bdPfGg4NQ-AEcEAvLLUTA-1
IronPort-SDR: wIA1KIacVeS4Hvqog9ySjbZa/cZctLWFdoYxhoaX6Tij8PqMsjrMU4IjFZJPVVMeeE4B8yw74m
	wxRH/ZWn7lhgLqRidhBwSAJ1HXg05q7/g5dFWQZ4QXSOSOauLDflQAXepKQ/6SbeZb1NEJu/oq
	yIx8arVS31WhCF6ItXZzzDDHKwdm0V2PXneRJF8jpSjWEJ3Sy1bj4vybuyFzLVwEF79CSxQ3FZ
	/nW+he5zOkd1A9M/qDefJT4zl7WTddQS/wK9lC3Y/7HliWdz0UyqzDbXE9DW7dnxH7IWtpCvKT
	UzE=
X-IronPort-AV: E=Sophos;i="5.82,220,1613404800"; d="scan'208";a="164633132"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
	by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2021 02:36:40 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5831.namprd04.prod.outlook.com (2603:10b6:a03:10d::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18;
	Tue, 13 Apr 2021 18:36:22 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.4020.022;
	Tue, 13 Apr 2021 18:36:22 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Thread-Topic: [RFC PATCH v5 0/4] add simple copy support
Thread-Index: AQHXByxPYjd3lKFugEyHev6iOAHEsg==
Date: Tue, 13 Apr 2021 18:36:21 +0000
Message-ID: <BYAPR04MB4965A79071C8DC9DA9D49FC8864F9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
	<5BE5E1D9-675F-4122-A845-B0A29BB74447@javigon.com>
	<c7848f1c-c2c1-6955-bf20-f413a44f9969@nvidia.com>
	<20210411192641.ya6ntxannk3gjyl5@mpHalley.localdomain>
	<3a52cc06-27ce-96a4-b180-60fc269719ba@nvidia.com>
	<20210413182558.v2lynge6aleazgbv@mpHalley.localdomain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07d44658-af8d-42c8-1008-08d8feab094c
x-ms-traffictypediagnostic: BYAPR04MB5831:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB583150F9937AF4B9E369E0CB864F9@BYAPR04MB5831.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JBr7pG6TnGVl6YdKYyIZ4BhOioPkmcuNaUz7klkiqHAYb54p8fwqXp0C2DKZA/vfdfvjcED4RDCzOwkbws+aMlhcWzcZWz4tIJxrJ6bux0J0QoPhughkFKwqB29ObDMaYMlVlx1Hz1aTSnYVMnjdxkA3Z91rA4a2AVgfPhfD8FnFFnJNGtcTxmbqfeI9wV2MvXeRYKBJTVCBbwQbIxSF4XquAsi/G7TMhG3h81r/MJrliUrqmrOgZrcnvE6zmWDWCY1nP0u4gndHsJtP+5Uh5KLCqFU5zEo27NIS1jIqYfaElNJtkT+6XzyU2Z986VY498TZgZculD59Pro+33EJIZ0KhBeFWIXEio5ONCaboOLfOCjEhE8nPuQ0/dzYfmCvtmcWHe6rqm0mPrfN1CKAU8FFaoRSPBkwKDLFLL3uo7x8zLO8ExiASy3NPNjZG9NbYqTSuJbvh49tTP6FzdrRbKUP/5upo5d38VySNtfOJtQfXyKoUPoERe6bY9UYh9m3Z4NVUrSkRM35naE6o+YusMErFIMkRel1S7F+KSTD2Yy218MxXpyH8jUC1+2bHHTFWQqG9VcnnDWLRfXuAoFvXPBN8Y9vSctXyrBL3WN2HPQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(6506007)(7696005)(55016002)(53546011)(8676002)(8936002)(110136005)(33656002)(316002)(2906002)(478600001)(54906003)(71200400001)(26005)(66446008)(86362001)(52536014)(66946007)(76116006)(122000001)(9686003)(66476007)(5660300002)(4744005)(66556008)(186003)(64756008)(7416002)(4326008)(38100700002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?M5TpDuBSP8cM9nhAeCTpefAVq13+lWPJeQs8R5A+RbOAs5J0Tz0mr9AQ4L?=
	=?iso-8859-1?Q?F81EoaDFoMJdNNkr7ssJTSRljTk9SD6tWfO8ms+E/WdWbJQy3WzM6faSPc?=
	=?iso-8859-1?Q?M2y2e1b9W+6plqeaIXJQem9/DbBL9TswHAqGtox5ldaYLjIyOIF/O8KXgF?=
	=?iso-8859-1?Q?R540QX2pWui4cDA47CfnfbFNKnnooEnBg2yy8CuZUYaUFiUdwKo/BdLbFE?=
	=?iso-8859-1?Q?XKAfCT0cFXFDEaZXWNHuV/SVThjvzjxArFy72b4AadATx0lsgpnejAJ64e?=
	=?iso-8859-1?Q?h0AsUp3+UE5FUXZBMFAawHkuybQJAjSA69dvKhMlowJnDUcCuasEAFT0Ps?=
	=?iso-8859-1?Q?wK2eDhP5Jv+gzqVwgrc+IXxqG7hiU9l2FmXL2dnYbGzZd7hWGXPTdCRxNz?=
	=?iso-8859-1?Q?uDvvnjH5PgRrAARQUWefEZDvsKyLTsi928F/KUlH93Gliy2djrYLZJx8o1?=
	=?iso-8859-1?Q?kYmQRY4UDXj4zcye2r02r3up3DabvwQcD+rz8SIo9ePgysoIEnDk5p7Zi8?=
	=?iso-8859-1?Q?Pt3G4vGI4S7pkQ1HMWllSlMCf0aKvxNN7RBeoLvQVJKmImXb2VWBzLxMGm?=
	=?iso-8859-1?Q?RCnbBDJVu3YMkLvd+Hd28Zxrqti4Z7PC8/iBWU4FLzjwoHJaHsD5MVC65d?=
	=?iso-8859-1?Q?LP04d8MBTAk5Zhmie9KrErEAmz6vAhNQ+EhXlme77VK4Zhg0XCMZQYWOvJ?=
	=?iso-8859-1?Q?tO9cJXgvNbs/sndAum7e4h/WFvyWr5kr3vKBO7bbi6hkZKUZxSa/Jml9Kl?=
	=?iso-8859-1?Q?RDyWvl0IV74VlYi7bp+77X/Xi2ywtYVLTgJiVoMafoMNZa+DVMvkhzf2XK?=
	=?iso-8859-1?Q?D2/QW8B1KBFexCLMkJ1UOml/kwrcQaJ0mfUbBYIGz1Zlp67ieLxEKkNlTn?=
	=?iso-8859-1?Q?XCDw/iytrrGmOVS+pexg5U45EE92g4875iydhZiNY9XV0Da0RiyEdcBKJK?=
	=?iso-8859-1?Q?/rnymwfJ05VRU/n7AjlbNQG2BAmRRi5D7W8K8FHaCy6O1oeQ7iEGe/Eiq1?=
	=?iso-8859-1?Q?P/itxnsIuK+AiiAGaZRWwJtBDwp9pZJMl6jAfOexbhdDPsYvZOCJfhTj9f?=
	=?iso-8859-1?Q?ncI0WhXERQG2VgTC3XGfFzja+XQX2heEgSSIFgi0cG58XGUthi/61uNTMj?=
	=?iso-8859-1?Q?zfJP3i5xqUxAvzKdSrMbvzSXEVAhd/bcOdLTW6Nu9Z7uyqfodCpitW6TJO?=
	=?iso-8859-1?Q?leJq0Z53OUHjGFi1Sya501gAYWiC/eVj5uat+372iN7UTD/vvLw4mzl+05?=
	=?iso-8859-1?Q?oM4kRSg0NaIx2EkDarpl5heJou0cu4NvQ0mFr8ZPA5suqTWnR39pu0IweP?=
	=?iso-8859-1?Q?rpsAoi8yzEno7WbF8yrpSKp/Gg2W7fDhum/pfrNT7oRabJYx0HQJT6UXkl?=
	=?iso-8859-1?Q?A+6rdS8nq5?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d44658-af8d-42c8-1008-08d8feab094c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 18:36:21.9379 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQk3lW+pLtNEJaw5UIPu+n5AFE/A8oQRNwDjAjm6oHMAyu0LP9WmDOsb68NccbHEFTRPO9hMVwBDlSjMkOBsdMPgv/Qe81f99GpO9FE2oXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5831
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13DIbvUK031805
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Le Moal <Damien.LeMoal@wdc.com>,
	"kch@kernel.org" <kch@kernel.org>, SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>, Damien,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"hch@lst.de" <hch@lst.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 4/13/21 11:26, Javier Gonz=E1lez wrote:
>>> I believe there is space for extensions to simple copy. But given the
>>> experience with XCOPY, I can imagine that changes will be incremental,
>>> based on very specific use cases.
>>>
>>> I think getting support upstream and bringing deployed cases is a very
>>> good start.
>> Copying data (files) within the controller/subsystem from ns_A to ns_B=
=20
>> using NVMf will reduce network BW and memory BW in the host server.
>>
>> This feature is well known and the use case is well known.
> Definitely.
>

I've a working code for nvmet for simple copy, I'm waiting to resolve
the host interface for REQ_OP_COPY so I can post it with this series.

Let me know if someone wants to collaborate offline on that.

IMHO we first need to sort out the host side interface which is
a challenge for years and it is not that easy to get it right
based on the history.





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

