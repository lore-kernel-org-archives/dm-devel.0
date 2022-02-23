Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A15C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 02:00:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-dHiXmIp_PmaHh6BjuI1V3A-1; Tue, 22 Feb 2022 21:00:26 -0500
X-MC-Unique: dHiXmIp_PmaHh6BjuI1V3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFC941800D50;
	Wed, 23 Feb 2022 02:00:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2B7661008;
	Wed, 23 Feb 2022 02:00:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 142834A701;
	Wed, 23 Feb 2022 02:00:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N20FU6001965 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 21:00:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD8C31402408; Wed, 23 Feb 2022 02:00:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8C081402407
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 02:00:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C826185A794
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 02:00:15 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-654-XNEr8aKUNr-fVUA3ovG69A-1; Tue, 22 Feb 2022 21:00:13 -0500
X-MC-Unique: XNEr8aKUNr-fVUA3ovG69A-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21MN3nd9021790; Wed, 23 Feb 2022 01:59:05 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar2gnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 01:59:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N1oga8169951;
	Wed, 23 Feb 2022 01:59:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
	by userp3020.oracle.com with ESMTP id 3eat0nsw8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 01:59:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by CH2PR10MB4293.namprd10.prod.outlook.com (2603:10b6:610:7f::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16;
	Wed, 23 Feb 2022 01:58:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.027;
	Wed, 23 Feb 2022 01:58:58 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0dmcpih.fsf@ca-mkp.ca.oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-8-hch@lst.de>
	<yq135kefh5j.fsf@ca-mkp.ca.oracle.com> <20220222073833.GA4979@lst.de>
Date: Tue, 22 Feb 2022 20:58:56 -0500
In-Reply-To: <20220222073833.GA4979@lst.de> (Christoph Hellwig's message of
	"Tue, 22 Feb 2022 08:38:33 +0100")
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
	(2603:10b6:a03:39a::28) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6beb76ff-17dc-4243-fbfa-08d9f6700e09
X-MS-TrafficTypeDiagnostic: CH2PR10MB4293:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB429368F3A1F30E4D0EA34AC58E3C9@CH2PR10MB4293.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TppeV1sN9wjmXJ7qvPfnTsRqSmZjjwupYjef+tA420Y4oyflZSsYfCCfjJ1Cj5zZiZMM8W2wkSljU8TtxiyDhhTn42iAPNXzW6GkjUSm8uCGTrQhcloF15r4nUpcRZ4W08CJG3gIS9UyBXNToXZRAsHt3IO5aSfM11JH0hCAqnK14HHGXK97Tnb/aeLjBaduSK7P3/Do4CeSWmFSPYV/GcvIyFBDwIT2oYe9zDuOUcX4Paq0RWv+pBmLJNhLzhBPZERyMSV2HBAwV8K10uudr9acu2YfsLo+2yK2ZnvEkmLLFh8tS/9xmVXX/B8apzL1Ja4J6BTLg6neSkITBZKpDSlcK4VVSntoCr72XLVgWf9mdSos0jkE6K1vBeR2w9W76gXpUZ6Ze7b2TXlePcDOKfjSPHrtXYH4xZuu/TZ5h2ZziXBKcyDJ3+bM8oFwFYjRUSeEqSyK0hvcs2XAtPVoHG3RtqH0vgs/7jYMqhPpzHM1C1AxkVbj1rk17zQj+fkOIdg5p+MjwGmQAQKf7ovZQoGQ0DqQpv0HvFv9cG5eGfJfYEhBO04DGJqy6y9iPDtuuVlLDlmi+Ef2FWzG3JpP0umJLlzl+Jl0Aq4jM+iJmiyfGLhVc1ezRyktyjDS+tSoeP+IwyXyepBMcAmqT+8eFlq353Se7Ua1hcyweEZfSsPn6gINf+vC96+FJscySMrfI9Z/EvGoyjHo+qXMswJ2iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(38350700002)(38100700002)(8936002)(316002)(5660300002)(7416002)(86362001)(6486002)(508600001)(6916009)(6512007)(8676002)(6506007)(36916002)(52116002)(4326008)(2906002)(26005)(66476007)(558084003)(186003)(66556008)(66946007);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xzcXutVrChIU8JlfONbQAlXn3ZRa2CBvckDLsW1vQv91wLjtSSotHf2ew+6z?=
	=?us-ascii?Q?kIDoYkTihjunRoFO5X3xwpkEVh2y4qAaaLuVIXyuJwEQCm92oIF/OaOCcK2w?=
	=?us-ascii?Q?rPXqi5Qb1YlzouWP9dz3y9pwcQaySPf/eBX4RHPtqdL4x+y+NE0aVdft62tk?=
	=?us-ascii?Q?LM5fJHSq2fqwHZ4S4JzIWXLVZfsvYEwYspNXgMVcZ88d9YhaAxTVEoE/jCWR?=
	=?us-ascii?Q?x4zajtmdecGeA4WqekeKiV9TqHhSkndjNCq0NREBK5cnLpoRwPD1k68RcRck?=
	=?us-ascii?Q?P3WYwtHVTZMHdMT0LjW00gGnT1ZqP1juVMU3RPW2WIi2qzP6ZPzPwIiVL1WT?=
	=?us-ascii?Q?987nEQ2fiUFAoUAPjzG0KE01FXZ5CBXa3OLJ+eywj+1hCVyzM2xBYF55HUUt?=
	=?us-ascii?Q?j+fkS1/UmNFBatf4dS/Q2CZkFdjfZeqQpdlFmUuED4oYHqysNSclAV11h+V6?=
	=?us-ascii?Q?LBaKYjGoPLJ3udGkryDz58DvOifzM9LdRuZVoSlQK1WnAgsTii9l6N+XTxU3?=
	=?us-ascii?Q?8PiXfcZqXRqqug4oBlrZGM/51GaYikPXiWAoXx5iApKXdxjLDE0wg24lNL9Y?=
	=?us-ascii?Q?SS7eKPggrsfPYpFZwz3BM4yp8hnXQgqa66xq419UOVnwMSkjZ75aZYERjCkQ?=
	=?us-ascii?Q?AB3WlVFCRzzZVC3muvYkVmb9UM0CTzZNtKUlK12gA7Pl/bzzXXV5HrK6dfYo?=
	=?us-ascii?Q?3coBvGKOVNFC8h/UFRhfTQSFbU1ktHIdPZl/UP4IRh1TR+ZqadVhtE7nmfG6?=
	=?us-ascii?Q?KqV6jFvzgWu73+7P91thmNZjFdHrqO4cTHV6Zik7egsRHggmwpodBUx7RkcU?=
	=?us-ascii?Q?icBk+VWUP7mfgXtzQ20IXZf+aKlOCqLCmUUPbF2MBbp7oiCBQX7GXJLOwFGf?=
	=?us-ascii?Q?01kv2lAg1j21L2pDabbX9mmmQuhkMWBKXHAT2JKN2NtxnFChNJMiQFA1W03b?=
	=?us-ascii?Q?p3Lx1gn9Q9aa4/f1/rAWLwws5eCN53UpecUUmK5I0XJPc+VpMeoH4V27HeEl?=
	=?us-ascii?Q?9dleqMI8yMa2ZJ8rOum4f3MupgK0KUmKMhsuIwu1GMyAgkoBrwCRdBX7VhMC?=
	=?us-ascii?Q?hbmvuTUotJx61ufTAvmNKE6zenpoTJCQ1dJ7QcsaH9a+t/ehLL4byD+Ms8Xq?=
	=?us-ascii?Q?G87CkdI15zrlLN3lWdfpQ2puyaoQa/No1dzCm2kCKD5saXVIfILWWx4iQk5L?=
	=?us-ascii?Q?7s188pKTcUjsvli/OC3eICrNnXX9gqNs9XkWru8XOMlvf8VyUBqRxQ5nA64Y?=
	=?us-ascii?Q?9tReopAvgmcynbfWQAxXDRfnQxWokX2JmeO2R1tRzLfEa69YQyHPNIPfn5R8?=
	=?us-ascii?Q?gKUBgKzPltRKqkyOtlJRXX73IN5N6fdbi+cel1iK1zC1iIAGaH8bXf1lz5kO?=
	=?us-ascii?Q?ttxczdFDg+bFXB5umYE21jMEV/93iH0xM8TgWXyyNIrqQjy04c1wCz2rOU9F?=
	=?us-ascii?Q?sdhj4j7Gbrf11kY16/zRJ6JveOUUbtNL3imCQDkKJuJ57r3mnT3fXGa33LOl?=
	=?us-ascii?Q?2Bz4LpqNOrQC42u5U2gL1UGGkI2Y6PD5N59a4Ib5m6hrYWql7CWzX8MO7CTM?=
	=?us-ascii?Q?tPmULmX3Pxy4ntNlb1XK9MyPN/c+Bq105Hb758JBFP8I2mp1iswzThJKbpzH?=
	=?us-ascii?Q?Q34tIj61AQ5h09OmEmYhL0UiqLWYAxnLDuJTl4lujR6RNqGMLRtVffgPQ+f6?=
	=?us-ascii?Q?XyL49g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6beb76ff-17dc-4243-fbfa-08d9f6700e09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 01:58:58.3347 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzG6L0tLUpJhdpPkLufrsNljkeyzbNASMk4xSt4NOP5UJrp3q29SnoKXEjxPn2H6m+MvNUi7HCpuSXpKAKeNvcANSkpWHnZ1v2FV1xq3cJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266
	signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 spamscore=0
	mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202230007
X-Proofpoint-GUID: erlMEIfg0EtElSGE8Fyd_nVZoy7bJHYe
X-Proofpoint-ORIG-GUID: erlMEIfg0EtElSGE8Fyd_nVZoy7bJHYe
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	philipp.reisner@linbit.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, ukrishn@linux.ibm.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 7/7] block: remove REQ_OP_WRITE_SAME support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> The maybe fold this in?

Done, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

