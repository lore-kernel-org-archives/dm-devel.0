Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C887C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:19:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 252F161380
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 252F161380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-DoWuhjzSNU6yBJRly1pSxw-1; Tue, 08 Jun 2021 14:19:14 -0400
X-MC-Unique: DoWuhjzSNU6yBJRly1pSxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E3AF1927810;
	Tue,  8 Jun 2021 18:19:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7297A60853;
	Tue,  8 Jun 2021 18:19:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1ED911801265;
	Tue,  8 Jun 2021 18:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IJ6Wr031189 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:19:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DE5E1200E669; Tue,  8 Jun 2021 18:19:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8F7421EE56B
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:19:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D025A182506A
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:19:02 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-514-BUHFhY4CNrep1aVnYotkCw-1; Tue, 08 Jun 2021 14:19:00 -0400
X-MC-Unique: BUHFhY4CNrep1aVnYotkCw-1
IronPort-SDR: aTGnzPY4efArGnJmTnYPjJwD8L2XqK4S11bzILJRAHQ5WruZ5y/+UDEz7YiOFiXtzs6bjgkwfS
	i6RlS6AvIss7zztYUIQc4Pl24pe7OpQ3IQanyHYvaRATTNCU3mHs1WlM4iFDk2YBrCTgHC5JH0
	XMI1rkSwVsjmUuekMQKBHH4ETDE/oNaV2NZhi1MZHpU4B/dq1FU8FpwQML9TnzJ6hPWkGkq/GB
	3G2D2LNmPu+Mno26H3MfCitN1CEHS8Q7OQvAoPyB3gqUljEfq5P0YKonjk3Zy3T/f3yWZM7EBs
	Tno=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="175946872"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:18:56 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB6282.namprd04.prod.outlook.com (2603:10b6:5:1ec::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4219.20; Tue, 8 Jun 2021 18:18:56 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:18:56 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 04/16] bvec: add a bvec_kmap_local helper
Thread-Index: AQHXXIBKuzXRKdg1xEu3AM/eJuOS8w==
Date: Tue, 8 Jun 2021 18:18:56 +0000
Message-ID: <DM6PR04MB4972E31296A75C338342A9C486379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fef6021a-c832-4828-aad5-08d92aa9e14d
x-ms-traffictypediagnostic: DM6PR04MB6282:
x-microsoft-antispam-prvs: <DM6PR04MB6282A8B37C40A4A39F3EC9CB86379@DM6PR04MB6282.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HXqweQSAtZQb89123JePJrcKHXLbzo5V/ddycV8JqXC0jo6LqnGabzr5WhPgFQgc5HZKwJrk7KHSa9pDrlnz/jTwt0RwxgTVeGEYvwdxmrMSJuq7hMx5SPjsFTc0kmEGSnGN0mmmcY61dfg2zf2lDcVi9Qi0IlloGK6ZBf0l59PuvQoK8ZzPlww9s1zMRNL3QzHrlXCk3moVHxrecZifbKX4Gaj0PP0tq1ASGCWCsk3aMKAe09x6gviZ1oammOvHOdYjRpYwoP1h/rii7Ku/ArfMgq7fxo2qj9wtaKBT/ycc0HJlvvUSxdy0+i3CXfIsPEoJSkIN7SfelvblPRnWaoHzo+JLPT+SuS+nGcQTdrBlr3vy1ESC11jD5AZRne6HQBiMwM6mufB5fvROUk617pWpwSP6o0IhIWd7wgyyEpCGRs4IdixzgBKN4CBxixzGSOFfYiQha3LSZ8UqXr3sIlm1FHYy/400hTLORZTKL920xnY99CrnB2Pa2uE99hX9kOk1960OtzIL7L0AaaQ4M9XEmxQSNGIrHfnTqXmNisiNVpd8CSRw4UB3qQUtMrL0nV2xDVy4LbrOZ5P6s0aXhHRyqQneZxYlZM4FeZeOsMs=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(66946007)(91956017)(76116006)(52536014)(7416002)(86362001)(558084003)(66556008)(33656002)(64756008)(54906003)(4326008)(66476007)(66446008)(38100700002)(5660300002)(316002)(110136005)(122000001)(6506007)(8936002)(9686003)(7696005)(55016002)(26005)(2906002)(478600001)(53546011)(8676002)(71200400001)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d5ZAg2vkrWHYkLyztsAo1/L5ZnLWIP6fGCDN1077tmwggYtQ5cyUsVgKvtax?=
	=?us-ascii?Q?Kdvy4k6Zbp109wcnqM1a0J8a1m9AV1VycBkeSBD9Xt6ASiEWERWQ/hFuDIgK?=
	=?us-ascii?Q?1z1JprpJuPDEoBYKD2tv0fLhc5/ZJzOeEMb3j7sjTeXR8qLDhxlHHn3QrclL?=
	=?us-ascii?Q?6X9Fetgs5T8OchjMAoMF6PxMOAwihCxCz1jA2K9NQXgENS8kZKRFTIEHgYMU?=
	=?us-ascii?Q?vWePKXAtK8GS1Hr45WD/txK1yQAQ96M3gYiq1Ds7vbyJWibRxgRrXjHtqe2D?=
	=?us-ascii?Q?Fg+QCCznUWkIfTwLp/ONzs4uo2vJYXzyUvMHd0v97tlZp/hABBpl2Y3fGKo7?=
	=?us-ascii?Q?nRBGQj3VUDJporQV+YhuWWLRYZE9mvKIKidoxAe3jplPdmnxuikjuOGcixot?=
	=?us-ascii?Q?asereL6MQvULqON8UWSS+O5sTVq1038zqYG/dvllIgiaWq4EyfNGOoPW43cW?=
	=?us-ascii?Q?UYwg5naaLe05Ra8wCtx16VtwLNHGcKWycZqGaoBbGO7aDyK7JI54yRBFN9Od?=
	=?us-ascii?Q?Y/uXa3STQ33e9FhgsYa0lVV/wKD4WwPmJPiqgazxFtmeJC28x90AgvF+z2D/?=
	=?us-ascii?Q?epgh9jH2hYzAS3Uo2hXL5J5lphZaRGOBthKPQhrW4IZ594zMM57puE2XPYqf?=
	=?us-ascii?Q?BnDcZ+8oFaZS/BUuQ2yRfetiVeN+/tlYoKtfnIyAzdFEHPmeu/0beyPBkELt?=
	=?us-ascii?Q?QmUnYDja1YAIzPTjN54KycKJqk4Oe9RaQMRpN98NT0m3jRkRdLtFKt96d0FY?=
	=?us-ascii?Q?5M6KSvBOf9IJ6+UzjK7ov6TeWQFQ85gdleIbqebwY6D7exVXNJWXTyI5fUkE?=
	=?us-ascii?Q?r+I7U/eT/TGjBTN41dI/HpsU02FvPhjSGWUhz6aKnWpoAt00x9TuJ8BGeZw7?=
	=?us-ascii?Q?6ql47vNh4Zf+j/ea7c8f3EkjjeW0HYkeqj0wsAX8QEsW9bm8RrjjqP4/6gqj?=
	=?us-ascii?Q?iG+ltpN+/HoESqLe9sbsGFr8au2XlN2iXHm/SVQbpTv36g9ukrT0kGJE32ij?=
	=?us-ascii?Q?usVQERhJ4gqSSx7DNsxkeXJfkWtxm6XuZgf4lJjp6wWEp7R5fWAhnF8tePgR?=
	=?us-ascii?Q?HApCJjj0pcjXPzmoiZ6Nay4249xmoiDD3Q1xg6Y7T1GSbOUnp0vyycZb2xcR?=
	=?us-ascii?Q?ar29p+fC36Ly0A5YzGuoXClJ0BWdkztmroI9pajsCAhLJ6TeNRkAAXH3/rMy?=
	=?us-ascii?Q?p6HVXL29HNlvlKNliYjNnJ+C/bTsFCdrPsbvoI1zDobU4FDED0wrKxmf7hFn?=
	=?us-ascii?Q?Pp52ozc32tJAHCEgZrySKWS4aEMwqRQ2VWoXlR+EL7K5IMCHEk/5lxMRNovy?=
	=?us-ascii?Q?nx6hArfVSmB+v1tN8DgurnCD?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef6021a-c832-4828-aad5-08d92aa9e14d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:18:56.5730 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVzqEFL2CtnZheHAwPBCOEf6UAQaZly2VnuX2jt8ImzHpnNgU/BEtg0CM1sUDOdoovk1Hmf2FW+2/YWdKPFH7sA1E2xwsOhidtCY4/VkBOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6282
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IJ6Wr031189
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 04/16] bvec: add a bvec_kmap_local helper
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

On 6/8/21 09:06, Christoph Hellwig wrote:
> Add a helper to call kmap_local_page on a bvec.  There is no need for
> an unmap helper given that kunmap_local accept any address in the mapped
> page.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

