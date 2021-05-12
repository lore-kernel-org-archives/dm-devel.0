Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98418C43460
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 327A8601FA
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 327A8601FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-1WD2ZmNsOWaMonIZoiiEEg-1; Mon, 17 May 2021 03:51:26 -0400
X-MC-Unique: 1WD2ZmNsOWaMonIZoiiEEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 591B66D5A0;
	Mon, 17 May 2021 07:51:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2191417F72;
	Mon, 17 May 2021 07:51:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8DDF55350;
	Mon, 17 May 2021 07:51:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CHQIhe024735 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 13:26:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63F1621144D5; Wed, 12 May 2021 17:26:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C4FA21144F0
	for <dm-devel@redhat.com>; Wed, 12 May 2021 17:26:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4458F9124D2
	for <dm-devel@redhat.com>; Wed, 12 May 2021 17:26:15 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-196-XHmKo8vrOg2sUv1-RRwKWA-1; Wed, 12 May 2021 13:26:09 -0400
X-MC-Unique: XHmKo8vrOg2sUv1-RRwKWA-1
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14CFipVM172540; Wed, 12 May 2021 15:45:40 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38djkmjfg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 May 2021 15:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14CFK3MM023529; Wed, 12 May 2021 15:45:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
	by userp3020.oracle.com with ESMTP id 38fh3ycxf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 May 2021 15:45:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24;
	Wed, 12 May 2021 15:45:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025;
	Wed, 12 May 2021 15:45:36 +0000
From: Himanshu Madhani <himanshu.madhani@oracle.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaKrf/70A
Date: Wed, 12 May 2021 15:45:36 +0000
Message-ID: <E391FC6C-9D66-4ACB-B2B4-DA971119361F@oracle.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0eeb3c67-0a20-4b34-8683-08d9155cfcac
x-ms-traffictypediagnostic: SN6PR10MB2701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB27015CC6ACA81A68758C55E4E6529@SN6PR10MB2701.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TUo2pFe290LAuClbz8hADKrbdtUg9k/xCIzQmwdsiFZpwq/8D0KXs4e2Z+cjxWxujciqOlWe9HXiamCF/6JuyEku2MHP48kYfgoa9H6QxVEMYQN7YcgArhHT6PrHRgd0TcrPoCF84nO3e8rGGJqjeeWaGnMO2rzf0Xtpb3mXtCSS31OiqtEtqpDxhS9vF7IzOu+rE/y6+GvqWF1yowuVX9m7f5uNqaojtI9rUejs/PwOqZV5BSLYNDG3hswF0Svxc8VqKDAHaId4/Gj7N5UAL1ljFXI05SV7gvz8BlDIodRUIL2oglG//vQdMfs6jtwIrUyQd5zQwgRH3zUjAQ1wU5pVSvsv7+ihZIyWEFN2cA2rNiuw8+atvVhHMXV+fZTccF5tbsbJf/SA8jKQkKzAn8IQlO+D7DXQvIYlDK+SDZxcEM154t3N7CS57bO7AXcVUf3oLiwoJr9uME7rT9k7ytdOhNAaieUKAunzFDD3q3RW+llTMwQoCRAIlmB6ctmwATt0ORD+QP1n2n3TNkFSM49tVaMK9nb067RPgzJk9gZ9vm/zfbIC8yXOYJols8yJjyjOjfFLkBZ4UQjkxItFGdsDy+vMa1ZCUEHeoF1alJ/KgBrDke4m5O1K+MbzYYcm/QaRz2P5/GIo8jUUCkuRsK8s3ooMgJrU1zmnFdLHrDY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(6512007)(8936002)(44832011)(4744005)(186003)(86362001)(4326008)(33656002)(6486002)(478600001)(316002)(26005)(76116006)(71200400001)(36756003)(66446008)(66556008)(66946007)(6916009)(64756008)(66476007)(7416002)(54906003)(6506007)(2616005)(8676002)(38100700002)(83380400001)(122000001)(5660300002)(2906002)(53546011)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dGVS2hXk5lpdYOTSii6aGApeMWuCDn7YJ3gonqRGzbc481lxHyFaN7sLO898?=
	=?us-ascii?Q?O/HdeLmb9G5Mq73CUhtOGSV5d8qFyi20UlcDwsc+BTQH1x6L25KkAzuQGxnF?=
	=?us-ascii?Q?ihBGk2On1aMul3QuBdyV5pA0uPg01klDOKbOY2OSLKqC/O4QsXrdT8iEnt2b?=
	=?us-ascii?Q?Rih8dqKF/Et88Uu6fZicz9vOMNT934rLav9LmSeJrOSiOrHzquUUcLDV80ku?=
	=?us-ascii?Q?ofaNT3idQPYfix0kgu+vQ/bf73285lBX/GF6g+QWnUL4eCMOz/Jfr+YvNCo+?=
	=?us-ascii?Q?BjvV6XkITLi4H8Q5ixtUH24AZCcZ7XLU5+nVqKWd9+B7tzBo631BGW9wuWdr?=
	=?us-ascii?Q?s1EEfcgqYGBBbHlFYQQKyLj41aV44A1yvHc6F41o3r3EIZPlHqaZpdIX1LOf?=
	=?us-ascii?Q?x/UAWulV4I+E0q7dIRu84leu8pNp14KK2OYowY5OB9461MAuDTcxwBFuXvwG?=
	=?us-ascii?Q?2pdIRmxpNw4Bpt2uQKqZUu8Zuh5qjIrn/gZ/x6zcMJDgkVgN/CgCS4eWbmwp?=
	=?us-ascii?Q?6y/7+dekGJFn8LdjOB9NUw5LbE01RXX9Knd9QF3XUzd62Dr1EUhQEoZ9KH7m?=
	=?us-ascii?Q?Z73wXDVQGPbA7gCI9sHXjLwDnQ3aEMz0F9EtntDflPefxg0SLKUJEHmd8E9g?=
	=?us-ascii?Q?kjYia8+XttZlyB2WMo4Z1TqdLkwG9Ppn9aOXAGLAb/uqzF2qAugEvLrOJHpt?=
	=?us-ascii?Q?hvzDOyFmP9gOoyrOaBkHfKzn3oKIcg1LB90OwyP8MDhgIK4eawMmZ6VIxcUB?=
	=?us-ascii?Q?aas6qUZFp4RwXf1scR0U62a9s3sErXs2WeqTNEGKYPro2bFAibMvHm+ec8bD?=
	=?us-ascii?Q?B3A8sGimVdgjWOMddlUKnlwho30jFzeK/DIYv0IKx9D5gTZYT7Ygb7uTP1M/?=
	=?us-ascii?Q?RUHI8cV1FysfLuOg6qiffovuO9MjuslKHYr1Jo+MK2telLkYuVOhlkWS89As?=
	=?us-ascii?Q?d/5r/TeYe/u9f1mpfU8RKFmO1oDiTME355FuuEex82wb4cq8Mq/CpJmqrDpe?=
	=?us-ascii?Q?0hfoIbbRtrbHnrwDIZZrBtbtULJcBbzyrvkpVGC+y9DUqvOtHnk713NaXbmx?=
	=?us-ascii?Q?TksKc/gWmi50wPOFA7+guGn3VMm+oC4lEdb6K9K1MvoY9WPLKHCDBnWW1bGW?=
	=?us-ascii?Q?3n1YQfI4buCM+kXPTYurq/5msLGMnwL9odiu+fajSZJ+8R+aw1NHrtXtBopD?=
	=?us-ascii?Q?s84/tS/E/nfv5+wuW3Hi06z17jaDL7NqVjpUu4T5R3XD9z2oiw2rc+1jXlY5?=
	=?us-ascii?Q?wTuVo/3nFbvspvSVIBZReFc6EDAiREINuSivYx7Wcl80/wEI0d4WnK15YkZI?=
	=?us-ascii?Q?ss2QypU3E6I6bAay+86EbGLeuWsr9f76UmOvtm1rDPidqQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eeb3c67-0a20-4b34-8683-08d9155cfcac
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 15:45:36.8626 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FERJgYXCcTUDa539VBNJJESEu86oRmY91r9Ysaa3cR2eIeESrJ2I95stffes00L3sPUmU3sTUn6+m/hyD12yXO3r0QrqTX3137u1kEWA4Fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 suspectscore=0
	malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105120099
X-Proofpoint-GUID: 4tjWTxXamwRKozFW_HifdJWYuAXGU0ed
X-Proofpoint-ORIG-GUID: 4tjWTxXamwRKozFW_HifdJWYuAXGU0ed
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	priorityscore=1501
	suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
	spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105120100
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14CHQIhe024735
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 May 2021 03:51:00 -0400
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Petersen <martin.petersen@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>, Martin,
	"kbusch@kernel.org" <kbusch@kernel.org>, "osandov@fb.com" <osandov@fb.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <374027C562B81342B371D744112E46B5@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> On May 10, 2021, at 7:15 PM, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com> wrote:
> 
> * Background :-
> -----------------------------------------------------------------------
> 
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.

I would like to participate in this discussion as well. 

--
Himanshu Madhani	 Oracle Linux Engineering


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

