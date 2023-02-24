Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CC8C7EE32
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481427;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G7oBmT54BRgE84EM/aznpLLIq/n2Z7FIRwlOTuHXdHU=;
	b=cpF/IZ+ivtDzj8H0lT2N51n+5HI07J9ctdce8ZKrMlUh7cBGSc8N3WqxjkAJt9NB5xyZPZ
	T6cRoJzPm+l1LmKd6DX6xtFmSmyiMFGL5ixXYbXkd1Xakp3LaeybvRtgNYnsy7TDuaRJof
	x4KFUsAE9nZrULyviP7e2g7yBVWv7zI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-J0OxfqGfNmKr9JZ0nq-O3g-1; Mon, 27 Feb 2023 02:03:43 -0500
X-MC-Unique: J0OxfqGfNmKr9JZ0nq-O3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67CFD38149C0;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 559962166B2D;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3AB57194658D;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC13719465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CF047404BEC1; Fri, 24 Feb 2023 17:47:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6843404BEC0
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F4698588E3
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:49 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-zyJQrTA2Mu2HIzYKPlE0Ig-1; Fri, 24 Feb 2023 12:47:47 -0500
X-MC-Unique: zyJQrTA2Mu2HIzYKPlE0Ig-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHhpes013466; Fri, 24 Feb 2023 17:45:21 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3nqxq-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:21 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OHJGXU031548; Fri, 24 Feb 2023 17:45:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49wjuh-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:17 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:52 -0600
Message-Id: <20230224174502.321490-9-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:8:2b::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 74a50198-3000-4993-cf82-08db168ee446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: o3yrTG2V6V8sTfrkH0O+3dWEQiJ9Zi80KZSuv8nW9ANClcob/isD8gvX9uwd8FpS6l2yVYPOZySMe98yMVRAa2ONuyIK1nUYe+KEaWZvBAlBCOYTqp0C4NG2wbQTXt15nb+v1kTZZfwYXFpGa+Q6w6rzrjZDrbHstxzr/h5BfHo7amz7nAslanolLeqRxEwe408tueBBzhl99JGchDSNUG9Lp6ZHhsNlIlBlZNge5Cbm1XtlQIpUz25I0zIsOMjSqvj8oROvLjbSIDGnxBsZ/K23aaMMB/qb19Z7ZiNSYt+wguI1NYtH6t1wnuH8D89x0wZ0dK3ueCzx7ue14dwnkDpVhZvZ7BHmZFhZ7UMsuYSP1JmiQPgqHy3Eg88SHrbmLzI6/oYkJKR22JFIcHqQfXnvt+5aXaN70DQKtF8N7dYhRgI1bv5itbB8gFY/P7rIZOVQxZeH6GDWORJDXmKs7T1fiGMT7EuhGZ/+KzAwzs/RIYD2jyC3lGjTW3zQBrIfmt32DbFA48LF1DxC8UVjwRJ1+xz4iJ3wjvGXz1LyMo7jiM89oFNHC1enKcMl6xSVAOaUc90GR/I1dTnbwHhmqzdODetQ71jDc2v0c99fl9o3SJfD6ieAywyVaqEqDfGeIqQjUYkXJ/gbe0c5RWAvuhrQx3eSaV94MWFP3hLnRndJTIT6Fmo8qel7Fyu+I8/O
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(54906003)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OphU5baYiq+owFN32hjUCI2ezFpBUbA3WdkknYxSy5JAnjW+OqqqrvEKHpu3?=
 =?us-ascii?Q?Pn08DoLcakUqDsSs/GvzBM9REixuhZen3OumnzivH8uQ3rWkyYE8OczqJAO/?=
 =?us-ascii?Q?nonZdmZpMy6pfF//BxGI0RiVTBlmUV7PQUWoa/htw226Sip3hswmR5WriHH4?=
 =?us-ascii?Q?28pRGq4uAMc5AvvLNnBYCmXOhEBh7emaaoOQwt2DmvzcY9Qyiqods/bZDN+X?=
 =?us-ascii?Q?xsF519zl7dL0U7VQ7XMhyJevh4ACxp3SFpu0J22QahQsEVBG/MYZXIHx0Wuv?=
 =?us-ascii?Q?PDryJKhUjygzBeKhIQeTgMcEApnNUwgyguEziS7uF6fNFUgHPa8JR2HK7hzg?=
 =?us-ascii?Q?NtshLrRfSaS6EpHpeFijprqDCGfYjoLzNEWVkTj/5r5pbDRzdN7JR8sMMcOg?=
 =?us-ascii?Q?PkNDABb8gCrgFI10fl66GgNZ2k7obmIvQV/g6gL655wTti7Kk+QA3dOgdivj?=
 =?us-ascii?Q?qYFVrJjRmF2/TdIYrWeklTaQlBGxFNdvXn8oeHcNaJRhmESswJUSc8FK+bdE?=
 =?us-ascii?Q?qeAfzlpXlzmDl0AhaTUxsK/bdB9CSV+gZJS4KmDt4zTbehox/0f9NNBS+s6X?=
 =?us-ascii?Q?INI+ZFCePK38IfZ0rpVwRh2FAerLcGTkDkJLOiljHPbJsUiinMu0z8p+ha/G?=
 =?us-ascii?Q?RQuMvLBSsH1d21ZwIbqwJwz3vSMDJRnmoMonEccvvJJmAfymgL/PPgK4gjLo?=
 =?us-ascii?Q?o2cdRirM/9YMP1pxcFaP1lbzWBCngI9tw0a6W8RzL1ZJynhDm1nR39X484pp?=
 =?us-ascii?Q?mvZ4ofl4Dn9J7X6TdPnXd1WYwhKQsosXPWWoD3IZuiLd5Lp0Dg7jkN79hqDI?=
 =?us-ascii?Q?aAYBxcicd0CDiFNGbkA+N+266uoPsQyuvcKt3eo4tcdDkXm2pdbgoCdv1/Ql?=
 =?us-ascii?Q?NMNndICmwZPwwnNX7I4d6LnoOgubfUXWvoE0yE5kM9NMhZ4P+al0Z330gui4?=
 =?us-ascii?Q?lGNiE+AT8r92YcroEmoTbDmpkWjIS1hNn3Tqd31mcxkAHSxnygRxQLoOZnM1?=
 =?us-ascii?Q?5t5795YzCizNx/7VhW3BiX+XDwAM7SqKUSZkibK2FjdXTynLCum2tFTC8w+t?=
 =?us-ascii?Q?/vLgbLZQnKV+CmQqmtE5C1lukfZbga/mbRPimrQJSbkmWnqsy5ltb+Y55t2f?=
 =?us-ascii?Q?ntcRkSX4teKCXbJbEyw56b4rR+JGqK+L4Gmot+Rax92g5oIjhWzKnXvwN9wj?=
 =?us-ascii?Q?DT86zWnZG821i+Rter30RdbIz4aJrwJq2QB2v1UAFN4vfz6her/R02/npkF3?=
 =?us-ascii?Q?Ncm7wR2qgHYs/nGpWnyMDNROtto0U+mzeupBhJTb3PVT4NTeTNg7Mh6CR2uc?=
 =?us-ascii?Q?6ylazKEKlzYDOKJrvWFdbkxYutkc2BppAcgjOXEgrffEqOx5fWqPC0fqnhF3?=
 =?us-ascii?Q?av+WALRMSMcfPvh/E2k3LrfO5HUz33TDlfZsvL6OE/j3rUlP5fOwr94bCQ5y?=
 =?us-ascii?Q?ZLAA5VW4GOTDRLljKKS6NPqltIRcxweqngWyopytw3nrNQmMf3YDcZnqPSQW?=
 =?us-ascii?Q?CJqIaXuFxU/ECh8BLGPkjNjmkGBSF0Fk2Eio/RJeWwhalyBf/HrUNiw09pLM?=
 =?us-ascii?Q?Vr+unLpnId2Onsgs596yJGY8wOCRlkfCB7N0rOQWEVdQPVTcqgjxFzAyRzeL?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?PJc3JfXk6g0JogdSuh4cP7pKzzE0kKKg2JhkbO8fX95eoAXA/iaOPYizEydL?=
 =?us-ascii?Q?zty8HO5kXVjiiphDfxNa2oz8DXPXpBbWLLbkDm82yHJJjy1z+OgGEhN5j2rK?=
 =?us-ascii?Q?xLRgFiwW+2zBJ1mMZhSuScv8BdlJIHnyy08En94Mj9MU8ljS/CxkMeglpeEy?=
 =?us-ascii?Q?BHycBqtlG6E96SXMUvlL3MmeVFsH6qtlBvEvRnFOqs9oXKv9S4QdA6XCRBEL?=
 =?us-ascii?Q?z3gjrp6ouYGrjiqjoj7eQsVWXUmfN2cfM4GFrJ5xB/oJVO4QpGn9FOmYGlsA?=
 =?us-ascii?Q?TiddIrqKd7bBFnYNLLB/z7GvzSAVp/jRSCyeH5J73R1NEkeMzx6qfGaXHWbi?=
 =?us-ascii?Q?oxUi+13CxP65sqj571u2tPexlu/6XJpSyQ6II2EA3LaRnFVHQNu0WQqsVKn9?=
 =?us-ascii?Q?rlSycXrusDcxTwpMUQKUUocqS0dDv0MJtf0NtWftq5K/NpYTtPDFRMl9meUq?=
 =?us-ascii?Q?LIh8mrPaAYZyHkBhFIXOHulS8SWy0J9zcbmvKSElfzI/4o53MhjBSiTN/qXa?=
 =?us-ascii?Q?AEKRjYv588xlM2JezrwQGzKfB6cM7qqnHz72XVqFFgF2Is+BRQZ+YRrewyjZ?=
 =?us-ascii?Q?O8N34TGNWM38ef5/3Pw9qTo4bvBq3WTP6o1BzLBBlyqXCBPgR3G9CwdgyCvE?=
 =?us-ascii?Q?c3R0tBgnSAdscCcpM/2aLewlAWMXx/6PLIJ7TggWoH97CoZM7gU8jl8XwQmB?=
 =?us-ascii?Q?yM8WMluHMTqUpi3SbrjuGnA2FaKXUj/X6k5oDIQIkcVfhhxhsAosCW7vnz6G?=
 =?us-ascii?Q?OVuBBxrXtPSPQqd14kjs0wdBWwOm6Y5IzMi1CyXDs1yGJ/F9NErq4HoYYZOz?=
 =?us-ascii?Q?EH5wWA5VtAfjL2010sBOuyY4aVHLu6RUqp3PyuIffFrtG6iexO8hHgbjCBYi?=
 =?us-ascii?Q?2FZYo5pgcWdnhGBIh26xDylBgX5JCdL5uD757lmtp6WlG0FxK1qeICcjsC90?=
 =?us-ascii?Q?YMyXrSVpo9+ihrRxR03CGe9OYyi1t2hjbpQUYWzfGyjxkMqGJ9DmOfjVoECi?=
 =?us-ascii?Q?fZyNtPxGSLubnmrdqLv6ZVi7zQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a50198-3000-4993-cf82-08db168ee446
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:17.5632 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDi/IvQ6py8TbjNjMlfsttyuVN2r/1tkNz1fFIQNe7xDmJ8wlM8qD8OBPBeYL4/ag68bh/9PmFe/1WS5Bk8UOWi8yjGoTdb2oKsQON2RwE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: okasKYKA-brnZu_b21o7fK6hZd8BwFvz
X-Proofpoint-ORIG-GUID: okasKYKA-brnZu_b21o7fK6hZd8BwFvz
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 08/18] nvme: Don't hardcode the data len for
 pr commands
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reservation Report support needs to pass in a variable sized buffer, so
this patch has the pr command helpers take a data length argument.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ba6f1911f7ea..6323ff79386a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2072,7 +2072,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 data[16])
+		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -2081,17 +2081,17 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 
 	if (ns) {
 		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, 16);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 	
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 data[16])
+		u8 *data, unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 }
 
 static int nvme_sc_to_pr_err(int nvme_sc)
@@ -2131,10 +2131,11 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
+						   sizeof(data));
 	else
 		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data);
+					      data, sizeof(data));
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

