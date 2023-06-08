Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A395C77B7A
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686189863;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pn/XTKeKfoDpRtKfvYqequs/J47T31MYc2oIJkTXOvI=;
	b=AVuBWsfcGZ3Q0EohJqQNij8xxGpsQaG77MeAhYsJOWTG6an6akzNMeF106C/4iIjTw0SSJ
	0YiWFzvZCcaW1uyQ8ceyd8cXzT/XKbzStQ3jQr9RFSXVnTeFCqrNEJJ3XispD+b9HRpsQg
	BlFl1vIwVZIDwAea1Cza06Tp+olYOKM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-VvaseWpMNlepZn9AvvUbXA-1; Wed, 07 Jun 2023 22:04:20 -0400
X-MC-Unique: VvaseWpMNlepZn9AvvUbXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82E0185A5A8;
	Thu,  8 Jun 2023 02:04:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A04A2166B26;
	Thu,  8 Jun 2023 02:04:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 263ED19452C4;
	Thu,  8 Jun 2023 02:04:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74B0419465BA
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 02:04:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 509192026D6A; Thu,  8 Jun 2023 02:04:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 472B72026D49
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:04:17 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2571E3C025D1
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:04:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-wu4_4jPTM3G8ysr1-5TXpg-1; Wed, 07 Jun 2023 22:04:10 -0400
X-MC-Unique: wu4_4jPTM3G8ysr1-5TXpg-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 357Ndk2m017995; Thu, 8 Jun 2023 02:04:00 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6ub46t-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 08 Jun 2023 02:04:00 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 357Ni37n015818; Thu, 8 Jun 2023 02:03:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3r2a6mgp0j-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 08 Jun 2023 02:03:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 8 Jun
 2023 02:03:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 02:03:43 +0000
To: Dave Chinner <david@fromorbit.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfb21zsa.fsf@ca-mkp.ca.oracle.com>
References: <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
Date: Wed, 07 Jun 2023 22:03:40 -0400
In-Reply-To: <ZHqOvq3ORETQB31m@dread.disaster.area> (Dave Chinner's message of
 "Sat, 3 Jun 2023 10:52:14 +1000")
X-ClientProxiedBy: DM6PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:5:333::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e4959a4-414e-4f70-6701-08db67c4964d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 0u9PtSuEdA5DTQf+Uog0aC92BF2nw1I9yPelJUi4tNa0C4b4h60whrxjbvZ8fwIcpgZxJwbKcMEHhcmktLh1ALm543E5jb9/wDq1WCkCsaV1H6Q+CYwmjYDl75Gwi2pisSdumGbUKd1kE6+FWf4lBEfc+v35kEK0ZihRTfYkyow9G76MwTaZyOiu1ihkjNvNH16WF9tz1sn+voweNtRFok5ojpNP1t3nbA+xUkW1rJb0AAqzk0isA8JTyOKq9eCpzy0Vmfgh8Aihvbxw0b/WUUD/TKbDeuY6ZgX9M4+MINgjRnJ4E4SgUC0DUb5fs5jDTfLZOV+AqdLW7IXM11u4mcgzifcsr2FK5q69Y6Z3be95EUJFULJ7ekiGH5dG0x5eRauIIky+UOOOCfWzYO5MTjLDJ5Hs4f3cvHwhJuEu9Qo4/vdTdQ0n/Ty+XMcI1Zsu1vCrnwlda86dze0UdkKNCYF26loOU3bid6gOXvm7FC9tB3bq3PDaoAUM74n/z6T0nMEVcvoodXGCfhpPZN9gqkeOV+YtRSpRv3tVFGVq9oYuh5likXNYXyCUOar4UyX/
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(5660300002)(83380400001)(7416002)(8936002)(86362001)(66946007)(41300700001)(6486002)(26005)(38100700002)(316002)(4326008)(6512007)(66476007)(36916002)(6916009)(54906003)(66556008)(478600001)(8676002)(186003)(6506007)(2906002)(4744005);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2P2wXqnA1AIc+D1BMU8uGjZFtmjmVBgm+uzTNY2UXFI4k3//fzxa32DulGK6?=
 =?us-ascii?Q?RyeIb5dgob2K1xb3q14j25kfG4KB68ZqRFkVUo6PHbY95z0ExbI/jHkTCwu5?=
 =?us-ascii?Q?TENUBrfsn0uuDXpqtUhdgOT+b2rxHNO+p11ppgvjBM+e+Lvo9Kktg50zcMee?=
 =?us-ascii?Q?T8L6ccUA9vMAGwLB6krsBq/VvtCA65bgebEXKLmS4UBgv4+TW1AobsYbeZAT?=
 =?us-ascii?Q?jA3W85woTaeUXWaHKqBP8fXU/VaDcFCqiPhpaYWLOaKT5a/qBPWHGzBUl/F0?=
 =?us-ascii?Q?JwzZoYaOAdQNayt4j4JqJprhZtBiyHAFdwHebpxhWqlbJaMfbqFwXr1LxG2u?=
 =?us-ascii?Q?972IMbI8jUi5I8EzTBWjBSI1w+bl6rdgLJm1kTHRhA5CPtUN1oANM8jaHuup?=
 =?us-ascii?Q?LIVjD+D2GEzjSVhFqp/cFkaBvpTO4IPSnLhvbTm6oRwT0fHzaGvPHIbyryDN?=
 =?us-ascii?Q?xLF88MY353cJ1jUC6AFz6MA/b02bAefwtyp6a5P9OoBTqZrob+7p63rlFLR3?=
 =?us-ascii?Q?nGs9y8w/GoOBVHSb6jFUhDa5UI5Jdpk1A7F6HobGXzdYnzo+vXR94wHmGNF+?=
 =?us-ascii?Q?9Dr+wmYpjw57ngOsBjmszLhNeyrdAe9mMDfS6jx/W6rT9RG6MvXCg3R/VUgj?=
 =?us-ascii?Q?TxLNeeObsmcArKG4nFz8I2/mon6cOtisPykA7/9ZdzSoBjJ/Sj6+Ycvyo/ly?=
 =?us-ascii?Q?/gdul+DpfXRAEVdn8VntVxUI1YK9Eqx7ViWNuHDFoQHaA04GXT8GzImPDCpz?=
 =?us-ascii?Q?37dD4a03rWm7P0bv7eNvbRtLM5qBtUtpsm8m7uBscQcH88QXov+JGLBKtEeb?=
 =?us-ascii?Q?upbEnsbkXwbNVudDWSQY7rnT1kxjHOySD2SdZrYDw0Pw4ABYptCXrj3zKk+S?=
 =?us-ascii?Q?gU4wEH8z2vb5kCIR5EIgkr6+AcqioopctUDSyyvV6rlcTdIzd0r4d6pJCS0Z?=
 =?us-ascii?Q?l6avi6CbycP3etAhUNokb0GyZvyfkMq3EVYB7S8J/1Fj4m80ZZmfVXy5N2IZ?=
 =?us-ascii?Q?8xIYM/jeIzYmdB36rQmmBihlGL24ckJaViK4m8+/FGOIam5sT+0RiCUrzuHm?=
 =?us-ascii?Q?hi1y304olneOZJbrKw3ahXsZq2b/2yCFpsmq+reoncOa6Yz6iBdahF82XkB2?=
 =?us-ascii?Q?n1mbZ8JDVSrR7jnf5wukWsj2fGJpUIMhY3jfD0yz40uf0WKi9OFYjOuSnoxf?=
 =?us-ascii?Q?/kPSzqKR8wCNNp2hYoyVOEGmyo35mo1Y/XaIORTFH8n73v6dS66h7YeJ6X5W?=
 =?us-ascii?Q?yPEXduOaoXSFuk+kMH4XGaycVJ/Shh3xgu8gmDN8LvtNC5EnnYnm9QEcq4Lm?=
 =?us-ascii?Q?ywDr88GPSP1iJmQkqf7vd2TvBtqwqgMacbumM7+TEDfAGJAglrexNF8sy/QM?=
 =?us-ascii?Q?eUHK6OQIlbz5N6Rd51/8C5sRNkqYuGRhQqWu/EgvkmBkX3HOTIWpfXFkCS0z?=
 =?us-ascii?Q?LUwpXFX0Gqi1KGN6Pm3W3Q8irIHVnJ6mYGwkq0Pti9xt+HmDVj1fZ39JXK07?=
 =?us-ascii?Q?3HzhtXew2/tvtZZfb00zuCogh7cSXhFvDD8FqfEmB/EHQVY1v1MgKhfMHSuP?=
 =?us-ascii?Q?c1BKfCLKr8EoNqpgQNAVNUlwakZ70Sn1OZskYbt9zjrjqWWfnQcpilwUAuyc?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?IJlyDKGi1CSg5yvJc155/f0vdpShExEqnLUfXV4dkiJuVDs3FsBKZcGQI5p8?=
 =?us-ascii?Q?o8jlErEap2Bnaq7OWKmmm7BIwBcoU6QIfJ1+7AMYVjEnD91J9PbV100SiQs9?=
 =?us-ascii?Q?B9aneBbNIpfvzWenotLOTUkx9PJjC4lola3M8Bz9xfHWMZ04o3cJPb7Ic2C0?=
 =?us-ascii?Q?6hj9vHQR73FkMbvV/ygTkz32ZJehz2kkxd8/LumCo45vGr5m6bfLMEBa7Qyg?=
 =?us-ascii?Q?KNKZvOt7bxA0+1pOczzAUVJ1Q8caCSiegV8mK7Zm7S4ATHMrwEbVwzks9u68?=
 =?us-ascii?Q?gDcZK1m/7z1BenK00FloxuSjmZpDm16/vbb7IJOyas5ZCNB0ECkhtkdq6Rpj?=
 =?us-ascii?Q?O4E23Rkm5EwvF/NW2bwBKqNypgxnwEJaCqeRl3megMtKZD+Zy4PeaomKA4Q2?=
 =?us-ascii?Q?xyVY4i2jn5zKLuozLRcCzLRoj+yTanWHuU13GNkV6xASH+dcF1VJATWe6LPo?=
 =?us-ascii?Q?W+lhug4x852qajI4tWWAyQcgoE+PB5hN7ak7/yYjoYVJpQzWiMA4XZrhbo8w?=
 =?us-ascii?Q?iqSXCqtmq1EzOFoOhUVHarT+eDuHi+DMQTEj3WeRAm/0LUBXgD8p2H1+4G2L?=
 =?us-ascii?Q?V0l6DEw3iECDP23mGsWW5TYyy1Plmf1reIfEoDHdtIq9H4ZMmvtPohNE++Wc?=
 =?us-ascii?Q?m9pIyiW2T0VYd5w6Db7YsPvRy3QH/MQ0/ENI7+zq90OzT0GO9C8Rz6K+NY7U?=
 =?us-ascii?Q?EnVxWxkFugJpBpYlvWtHlorfnXUpHTwtvZ1DBHtnGLb5YQp1GxC3JE4vrvV9?=
 =?us-ascii?Q?fhYJRPycIWQo8vlLziTx3niJD6LlP1MbJZ9znaObLWA1HrhDSw4BIyCFLIbv?=
 =?us-ascii?Q?hmhPmjrQNnrUIQW85sKxLM5IscQ9WNC2dn61j88CNRmrjic5IqJQBqs7oUzw?=
 =?us-ascii?Q?6dYvd9bzgPH/Tres8XCr7iyqF8oMJTLeBPbwniXTPXY2qs95SB5CXh71rkuN?=
 =?us-ascii?Q?RKiM0hB8JH0tgnhtOutqFEtm+3ZipAE+2NG+c07l7Imv6ldYBcYkrijYPB8d?=
 =?us-ascii?Q?wjdw+C45ITg53lfMLm+WOFKWYg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4959a4-414e-4f70-6701-08db67c4964d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 02:03:43.7095 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDdyRby7cgI6L/SS63kqFxXOoQtDCgWdBK6byT6iAJ2hlgOuF/5wu3Bvu0JnAOxyGsymUOhcL6l6tMMq63vBR4/s3LHXUfJxxx/oRKoMdH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=880 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080015
X-Proofpoint-GUID: qvEDSeu3ZiYVHl31NCVuM1rmGCKDqo6X
X-Proofpoint-ORIG-GUID: qvEDSeu3ZiYVHl31NCVuM1rmGCKDqo6X
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Dave,

> Possibly unintentionally, I didn't call it REQ_OP_PROVISION but that's
> what I intended - the operation does not contain data at all. It's an
> operation like REQ_OP_DISCARD or REQ_OP_WRITE_ZEROS - it contains a
> range of sectors that need to be provisioned (or discarded), and
> nothing else.

Yep. That's also how SCSI defines it. The act of provisioning a block
range is done through an UNMAP command using a special flag. All it does
is pin down those LBAs so future writes to them won't result in ENOSPC.

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

