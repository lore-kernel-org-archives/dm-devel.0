Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F3AC48BE5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:48:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FE0C61375
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FE0C61375
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-t18oo8GUPGWYY_qyAi43Bw-1; Wed, 16 Jun 2021 12:48:17 -0400
X-MC-Unique: t18oo8GUPGWYY_qyAi43Bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C856B2E93;
	Wed, 16 Jun 2021 16:48:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44BCB5D6AD;
	Wed, 16 Jun 2021 16:48:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDE34180103C;
	Wed, 16 Jun 2021 16:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15GGmAb7025639 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 12:48:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B0DD72044721; Wed, 16 Jun 2021 16:48:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB5072044722
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:48:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17F9918E0926
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:48:07 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-394-bhNhyLeVN26zE82eEMO9ug-1; Wed, 16 Jun 2021 12:47:57 -0400
X-MC-Unique: bhNhyLeVN26zE82eEMO9ug-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	15GFvW5i016469; Wed, 16 Jun 2021 16:03:35 GMT
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 396tjdtn5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jun 2021 16:03:35 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15GG3YT3019839;
	Wed, 16 Jun 2021 16:03:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
	by aserp3030.oracle.com with ESMTP id 396waukedy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jun 2021 16:03:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18;
	Wed, 16 Jun 2021 16:03:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::4c61:9532:4af0:8796]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016;
	Wed, 16 Jun 2021 16:03:32 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnqt4x1q.fsf@ca-mkp.ca.oracle.com>
References: <20210615132456.753241-1-hch@lst.de>
Date: Wed, 16 Jun 2021 12:03:27 -0400
In-Reply-To: <20210615132456.753241-1-hch@lst.de> (Christoph Hellwig's message
	of "Tue, 15 Jun 2021 15:24:38 +0200")
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0051.namprd05.prod.outlook.com
	(2603:10b6:a03:39b::26) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	BY3PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:39b::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9
	via Frontend Transport; Wed, 16 Jun 2021 16:03:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21c9dfe5-5cbf-4b3f-6912-08d930e049db
X-MS-TrafficTypeDiagnostic: PH0PR10MB4792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4792E6746C4F34A54D13330C8E0F9@PH0PR10MB4792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: KmUD+JEPTsSnCCiZ2ZdhwlfPbiDpM/oYyA9XIn1pnIled7TOnu0tXcktl8cSP2v44KKAlm92+tbYoL7d4o6i1spd8sgzWWAuTYJqG2MXZ+Ib2eLdZe71bk6fbJRGxZx3OHuTEFIm/zgZDsLlrNk9fsEvG1M/gUhP8I/YDA4LyS65bi5rj7wC10fpa7v2/r8IBIXMeYW5ezx/1L7QZlVmJ4hzZw6WYZH5Ne8iq8ilwrbpI3lwSpjgzNKXDRfcy3SAMx8StM0aWo0thKZErsycKbISBHtBeOeUnT26E3tNFM2Twie+E7VVuRj9szvxe9FxH4KXyfXk/TCqKvKTZYr0Put3K6wt4l6pIWKsTB15SAi4jPqZhHS9Qh17XZxK0kYIax8/+/QSCx11rnY8XdiG9RHQn0OpuCP3EnK8Iko0zD2RP5lioUIFZzSjW7CqvaeANaR2MFeLqRtke4UdGSCMZIv9nC+d1E2iW/tr8D6nrdd91tsUmNq/KCdTDnr9tP0sT/Yx5O+yAUK1JUzlYxTA5Vxn65T6usLQVEHi56DHOqdEwUghJc3dFa1TzRdfp4rUBsa00FmKjuU4Z14RNqcfupq60YNCpxe3L56qvKG5FnhO+e5X7zG7i50M0431hlXKHJrkoCgFt5LLEgouvvunqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6666004)(6916009)(66556008)(36916002)(52116002)(55016002)(4326008)(66476007)(4744005)(7696005)(5660300002)(7416002)(66946007)(956004)(498600001)(2906002)(8936002)(8676002)(186003)(26005)(38100700002)(83380400001)(86362001)(54906003)(38350700002)(16526019);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zHmGVe+ALXTJCFUdUHTNkxVmzHeCbrPdieRoU/7tnu8IePI2dRLXAWWWYCnH?=
	=?us-ascii?Q?WmHPxt89EkrbYoYDKZkQ1hLVF+QzyOiTqZ9NqeLKg32AnReYyOwgSO/h0WAn?=
	=?us-ascii?Q?bgltbTFldtlUcDoTl3bmoXhMRyg2MsjLDPaX3LuCJEJ0OA4iHdqbx0+sk1bN?=
	=?us-ascii?Q?bDf2WQNV2eiPaiEwMkmk3mptXrO496x4jufZY+d5UP1DAFOBK7qbL79poPXI?=
	=?us-ascii?Q?CCK6NHCI4d5xxXeSvHuAy9cPAagT1afOjQ9RuV5u+z1MOVbLo9Hjoi5oHpu3?=
	=?us-ascii?Q?KQVfVOlA6xomXG6xvN8QsisyWnheVb8WC9wzBI8DGNB82xe8nLU/0SdwGNdz?=
	=?us-ascii?Q?o8d9P5SIyWHoy5STAPVtG1iBQwHDetSPKlHpuVVIRdoCLqIjSAldWq6BYJ15?=
	=?us-ascii?Q?0IWwDvF3e5ZhLe6Ss85ivT1sECZ+pJUiM3xPBD/copE/EnG2zKIkMaI6k7yP?=
	=?us-ascii?Q?I2je3QoHY7L7aj0REPIu0bpSvVcCzR7UpwtuAziBlpzZWGTaXfdrJIp5O+kT?=
	=?us-ascii?Q?poQT0KTjYPegCeDVACmSYNiC1pttl9gtKS5cxYZmVcTFt9z1MVC0/CsaE+Is?=
	=?us-ascii?Q?yDDwyueYC63NxymdXMbubi/arKuSXXUa+7eBxDLhVM7q0Uscc2f8mAWYG4Yn?=
	=?us-ascii?Q?ZUUi2fZ1kTqx3Ji08rERThOhk59iXPRs5+M1ejz2yC+HxpppZEE3/8xXI+fY?=
	=?us-ascii?Q?Cfr+ZxWZVUi1AHyMfGjiWowurinj3FWYvl/j486bOjKiZccmcUBpxQND9E/6?=
	=?us-ascii?Q?R7pOYuHye2vGQEZOk+6TQrVTdgBhMvfQUK/x0TDpF3+4K8NDzZRzHJSoc5fy?=
	=?us-ascii?Q?xpsGKNe9b6lSnhHKkgek+IAUu7u3xTCWdpFuplqrredg/AF1zGaUCimI0kp7?=
	=?us-ascii?Q?Su8OIAM4UCgyfUfgO5qWct517wkAmbkgCcaKCCV6SxHrHBvQkkyL8fcCjW4c?=
	=?us-ascii?Q?aa8a3CLoaWd8z4uXlhEJ00sCYhokwepJF+uO7c0J+/xhVAj8DebJoXrRlSxJ?=
	=?us-ascii?Q?c4WGo0gkMP2MxVEpWU1+TMYb8xBNdGmtEtMZI9o1rAUELNYtBu/Ibhr0Dx89?=
	=?us-ascii?Q?GAaJ6rDjcTzdyqdPNyo/Qmo+3naKV1JbkEU5RLSSj0joIv4kHlhNNkz9y8df?=
	=?us-ascii?Q?wb5v+Ui4Xat477qCsd9m3LC5MOU7Say/Vwkujt8kv3o+yfzrMmQfi9Xpf624?=
	=?us-ascii?Q?JQbQLyc65+9bDgAKNUzaolmoDGpyDBCMHIcwDaO1LYPRRh+CWb6YaQAv9V6p?=
	=?us-ascii?Q?NKXTJpkXYHhLpAUWP5e7Z41W9tX71NQx9PFxaxyphxnFrSIM+M1VIpmg6ZYm?=
	=?us-ascii?Q?5bwEFau3mTsQhrv9Zk3RGjAL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c9dfe5-5cbf-4b3f-6912-08d930e049db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:03:32.0614 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/7FCid3FO6EEMrDlCLiNW8dwVO0QoyaXBqibk+OAZwll9U4QbE2j7w8UitSVaadOAuqLIWRaSIYs4t+tWqCY4OZAmGxYUmWuRe3e+cb6wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	suspectscore=0
	mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2106160092
X-Proofpoint-ORIG-GUID: 287C8opapJSjkChRqFXQvASCFz49YKWV
X-Proofpoint-GUID: 287C8opapJSjkChRqFXQvASCFz49YKWV
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, "James
	E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, linux-arch@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, Ira Weiny <ira.weiny@intel.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [dm-devel] switch the block layer to use kmap_local_page v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> this series switches the core block layer code and all users of the
> existing bvec kmap helpers to use kmap_local_page.  Drivers that
> currently use open coded kmap_atomic calls will converted in a follow
> on series.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

