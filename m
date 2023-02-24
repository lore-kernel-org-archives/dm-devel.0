Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0507C7EE33
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481421;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PnUGbhxq6W1or0KMruo6Fg4JxQ+jJOx6Ph0wu258cRI=;
	b=NZV2TpvnDIOqumrInnwOROAgVZXpT/SkDSOPZEf/5vlFdmHJ0Jv3VXOK/XsrrKBaTUEFC4
	Uw3smNrdjA+MbejU0+4IzW+N1dU+B8RZYmlmN6yTNWte613dWxN6if8X82kVBTaVFjav++
	jT0qRobdbHa/oNO1M+wgeArPeERdOKo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-yTTeBxGRMwyJpSaBlgkAUA-1; Mon, 27 Feb 2023 02:03:37 -0500
X-MC-Unique: yTTeBxGRMwyJpSaBlgkAUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F1A23C16E9B;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A9CF2026D76;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78F8B1946A4D;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1498819465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 19:23:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EDC62492B13; Fri, 24 Feb 2023 19:23:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3FC8492B12
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 19:23:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE73829AA3AD
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 19:23:17 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488--jI4m_W5PSyKEpq-Kv46Ig-1; Fri, 24 Feb 2023 14:23:15 -0500
X-MC-Unique: -jI4m_W5PSyKEpq-Kv46Ig-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHiJtR020501; Fri, 24 Feb 2023 17:45:10 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpjadkp7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:09 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OG0il1030220; Fri, 24 Feb 2023 17:45:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49ssch-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:06 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:45 -0600
Message-Id: <20230224174502.321490-2-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:4:ad::41) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 2294f043-102e-47ac-191d-08db168eddb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: V41gLsgffiW3kT/I+UWnWbzAm/9jclG9GpS/M1nPqYi5QcuSwkphZvgdtXHj+ZMl6jowgced5i4WoFapEBBTR6mKSiLShSCVoa1/gyO9kl+oD37nyg6J8ikDWcFHMDRLsJoO75Xt6k3kv8qauhq7Rr7fp07fHQ9t+23qHdTcqX4bkzN84u7gCuzMUVuGkxtoItuXXuPveYZ0s4NCZfTC8HMfX2MmOhNL1iKOgxO0OdoZnhCjFDJoiBhNk7YjOZjP/1nKs7KNDJCi6r8JMh2NRSGOtCMAingrKrq/yKFndSyc6BrjlDoG9K3m3nWFS9PjjXFWwDI2JflQ0d63RXUhr5+yzu48+4S/k5Ak6snNo3cYJ126+qsJtyIejqSRYOK+XIOfx1WwKuLFE6zBsFtvxGJ/P6aGvQ7nUnsefDTBSFasA8EmIGsGiwkB4rfQwCy0hTXeP9upaBkHZgjQJb6Px+qm2ByxZhqtSu5TxDKz6kiwvKX4YCxBGx4KvQMGEr8ctMnhpyrr1TXy493T6XQSpADtihHNIw3NGfZDfRvJsof5/IHQRMkv2654DfdCaMSN2eARx4CRAaYnC2+bEe4gK4Uy4OHH7TvdG/fEPuQqYhvJMRdPajzoK6ojrQaCp47dpWWvTd4b/k+nPjp++uJE7e/vq+7eNpuVKLJz8WNWvB1WR7/Eql18FeapBiRcs9K4
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TpOCdgjaPwrMIa6yRzX1b72+qb+zWj3ZXrdTRMI4U+vocUGRtszCOb2cp0Sh?=
 =?us-ascii?Q?fOgsfgIT361eVdN67Wm+fhsd58D0jyg3fDN4OMJeD5aIeaoSrrbi7mELwVsI?=
 =?us-ascii?Q?4YAYp9JFCGfGmjSOQZeAYCDQaWqNRt/Abpbewg0A/87TdgQzo4ROjiWAz3Sx?=
 =?us-ascii?Q?58EJAseRE5BgBDKq6/Dqz91763fdVpTlZBO+6VJL+6QTCZXQoMnmqSKETbfd?=
 =?us-ascii?Q?7FGVwcZgnuAhWk58Ryuvtfub/Of10SBXXZn/WWbp3ExwCrKLSYZpAgfaiGmr?=
 =?us-ascii?Q?vDKUOO9SBvi6X294A0JPcc9K+/PvFh1J+baQUkDuEypRJm08FeEU87wjk+ln?=
 =?us-ascii?Q?gZBKprMNBudOr61biNrtM2oK8z5iErkaMdYT7iKDHVgHixHJxUTgyL9Kr4hB?=
 =?us-ascii?Q?HitlrCrP0q8gHgRZsBi9nR3oUHEd7Xb9nl3T/CIYOAEApmeGPFTHhPMemJ18?=
 =?us-ascii?Q?pinzoipvcl3ms3MmeDw3ktFEOqyxp58+hio16SO6tHEAKVO4boLmkeIyzj5k?=
 =?us-ascii?Q?ySk6IDJWZ30zKlAsAT84BQ7digOkOzqW19OIgAOsSyVRPEPn5lX39vAUVxNy?=
 =?us-ascii?Q?CO1y3m4SNamISoMqX3muJsE4LIQzFRSWjQg1uWQg+B4eyKtkskqS9TK4Hmus?=
 =?us-ascii?Q?dXbYi6B2uFGx/ih+2Z6LlwV9KPAOVBLzBKYQtBR3rcT2W9PKN+1jLUPSLEA7?=
 =?us-ascii?Q?tQdBwVIYev25HRYk6HERkQsru+djFIoMbUfza2xmAc6hmDh5HO9nRUql/r+u?=
 =?us-ascii?Q?ZnzWK4MBuw8RJUIbxCMUmpvf8J9YGM+v/XxHLoczlsbONh5aGPe32b+bgD+2?=
 =?us-ascii?Q?SpRAEt3p206JpuRIjkR8V9uJbMVcQD1epeHp5rYOnCWxFYWswGGRqcz8naKU?=
 =?us-ascii?Q?rP9aJLGbHHYcqdx9aDVwlQmH/oOiq0RgFWvyZyH6mkKWKmEpG3nl/gJt1jUP?=
 =?us-ascii?Q?QqDcd/oVrfkH7y1NootDIrLlAM3h6HhmCJKdQ+6lSK04oY5FPBM67pJ2io+t?=
 =?us-ascii?Q?jo5H/oHVWkNmP8tW6qE62gJ4u/Qq86OlqQcRGEF+EucO1RLT2k5EIMXcJ1cu?=
 =?us-ascii?Q?fX7hj28tYvIm2AqAO0R8woNiYm5kyS6gkO1SMm+QPrDL8XKSljK8XIzXDFip?=
 =?us-ascii?Q?9ppBqFGWjmY/3S1gZcDz2P5Ap1InOM2lA3sG9R1rbb0bqB/ODOJp0DI0+5qK?=
 =?us-ascii?Q?RoZFPMlhhFlM8i62OtEVhYdg3lA6K0MA/+1S6V1qnHNpXvsgJkCYNl74/53C?=
 =?us-ascii?Q?I3PwUN1pAg7aJbsrakx6Ac+hVC9fbPNpyb3sspBrAuI8wwqSg3DQ638glfrF?=
 =?us-ascii?Q?OgOnz3WG6U2uJpJaqjcc1MC4I+CfTVljHjZoW8qyZKyBTh8ccadouA2B3J7o?=
 =?us-ascii?Q?xZvPlzQwXMlJ4hkGGV5wl9KK4D/JU5x3zHxZaXvEpAB91xWddh20YiBoxbzZ?=
 =?us-ascii?Q?JrVXaJLinQKqYWUqDbkNVG045TN1pCjEaww4JYGWc1U+jILgIxpO7hHVH6xm?=
 =?us-ascii?Q?sitURpROJOhQ1RRyhgLL2Bwk4VA+Y1dgxEGI70H+EsFTIelYo+yzaZHOi8Y9?=
 =?us-ascii?Q?v2zg5C3vZvUrdoRgBMa3Z/SpnAdBuk0/ncLkQpal4JX8ReuwyMn5OKXGma0d?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MRJVFA1lVDwJwLetoXvhE8s7Qgt9JqoXo3wTT7Io/EIcQBtsCkLSIWoA9rKS?=
 =?us-ascii?Q?WKoFu4fYyLV3eGAB6cBK5wlWfImQ/RKzsEqCR14RdC2t71QUis4eQEyFn2qI?=
 =?us-ascii?Q?z9EYo6dFji49VP7/eEl2FCJic7BnRGjxWscY7JDGxhW3tTer4jU5ikTUWTwV?=
 =?us-ascii?Q?hQMP5X/60QurUAx7dyP7rL1HMhvHlK2/GLdcs52njut/EqA7KrwpCAEH9K1c?=
 =?us-ascii?Q?Vfm08mk3HH3Wx6M6qp/VUW0HJnZ2Qj4M7QW1rqkgV/P1Jzo9QPfXpUPfyGUu?=
 =?us-ascii?Q?6mPW3jp50TFjBgjjlVWoOs1SEVkdJK3cN0cyljaLNEh2bE9JJa9eVquuUT2y?=
 =?us-ascii?Q?2oABe9wE77hinRrpLi9xWbCFh9ep9O4t8d2MTpiZ6I1bpwAm2HaYtPFJqzky?=
 =?us-ascii?Q?sE9O4Q129FEX9fd2lulwayFpnX4vcIkuU9J+N5UhTak/i5h8mlSEYVeGmOZf?=
 =?us-ascii?Q?fi1BQ1KAVk/vVJ1UlCv4/PHZL9Qh+2OUTVhe4e1kLN8deXDyaGL8fTbXCIDL?=
 =?us-ascii?Q?6mNXTYzbpczmN+ZyK+RhvwzSP/11WT23qS6y6gVka5aPcQ+PZNvphPEtyTnn?=
 =?us-ascii?Q?LTAOLoOQA1dWZ1ml325I13Hb8sysFlSYQr2n24aTgznJSdJP+9/YZjwFfCdB?=
 =?us-ascii?Q?gcMmNAufgPc+YmN5dVuowUzSw4N3DKeBvjFTVdLaqph5OhcxOxf5mIGLS5Cx?=
 =?us-ascii?Q?lgYTGUm/4JVThAdpl7RWp3SWpV5rwPEsG3JRUowNm+NLp/pQsL1kOphO7Ti7?=
 =?us-ascii?Q?aEEreJ481mFis93FEFVHaMWlNvNAbWUZGSXmNW55zmlmzktfATI81UAJNDYB?=
 =?us-ascii?Q?WOM6F5CYB/kohIJQOTmCtJZL5UrP2E1DPk7F9rWYt6CKYkB4ZASWvFFKQ0jB?=
 =?us-ascii?Q?Oen7dPO6aoEzdvHboKg1UIVQQHwAXR6jAYdgtDFp5mhzXU8mEPquQV+C6nS7?=
 =?us-ascii?Q?qlxRJ/LATMz/cnbgAL64jpl8GGP0gIk7Yz9+3FdRpyeW6xs6KSVgC85AissT?=
 =?us-ascii?Q?fe7kNtVs5F5218I5Fx56vDcawQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2294f043-102e-47ac-191d-08db168eddb6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:06.5797 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bv2Nf2yz5lcDFmCSePjKuDA6Qkf3srojf7QWYt2sWLlwzNDsqSALjZC99wwhk7lzhpybLyIikjXS86bUi8IqexImmO+g0sgDhP6cke8wK98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: BPEMvpnrqkgIzwGqAV7UtARAm42GsJRv
X-Proofpoint-GUID: BPEMvpnrqkgIzwGqAV7UtARAm42GsJRv
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 01/18] block: Add PR callouts for read keys
 and reservation
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
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add callouts for reading keys and reservations. This allows LIO to support
the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
to optimize it's error handling so it can check if it's getting an error
because there's an existing reservation or if we need to retry different
paths.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. read_keys
and read_reservation are exactly what dm-multipath and LIO need, but for a
userspace interface we may want something like SCSI's READ_FULL_STATUS and
NVMe's report reservation commands. Those are overkill for dm/LIO and
READ_FULL_STATUS is sometimes broken for SCSI devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..3003daec28a5 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64		key;
+	u32		generation;
+	enum pr_type	type;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,19 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	/*
+	 * pr_read_keys - Read the registered keys and return them in the
+	 * pr_keys->keys array. The keys array will have been allocated at the
+	 * end of the pr_keys struct, and pr_keys->num_keys must be set to the
+	 * number of keys the array can hold. If there are more than can fit
+	 * in the array, success will still be returned and pr_keys->num_keys
+	 * will reflect the total number of keys the device contains, so the
+	 * caller can retry with a larger array.
+	 */
+	int (*pr_read_keys)(struct block_device *bdev,
+			struct pr_keys *keys_info);
+	int (*pr_read_reservation)(struct block_device *bdev,
+			struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

