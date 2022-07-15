Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06577C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657917547;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mLJvld6yTupkX50jxWbJJjx6UbuMkMQjvbDreJSdX1A=;
	b=Lf4yz/2ZxbAojZh3Hw0guQCITGLJyOdY0NVxdoagksVWy2Rb0BEQ4fwMu2RIK3dQ2KT9f0
	4I3LBGZunszGeYt12LCLoOND1U7BISNGJn+oIe+KgbuaNe5gOoVzhmbXqZUijFry+JWyf0
	Js5eN0r4H3J3yvQXo6D94cUbhMM1iJM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-oWl8589dPyCcPFEs2wt1TA-1; Fri, 15 Jul 2022 16:39:04 -0400
X-MC-Unique: oWl8589dPyCcPFEs2wt1TA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CF8E3C0D871;
	Fri, 15 Jul 2022 20:39:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C69C40E8B04;
	Fri, 15 Jul 2022 20:39:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D68A1947041;
	Fri, 15 Jul 2022 20:39:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC09B19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 20:38:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B900318EAA; Fri, 15 Jul 2022 20:38:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B40F918EB5
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 20:38:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F7BE2802284
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 20:38:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-6mf330ZlPCaTZFl6ZfUfkg-1; Fri, 15 Jul 2022 16:38:57 -0400
X-MC-Unique: 6mf330ZlPCaTZFl6ZfUfkg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKYiIT018705;
 Fri, 15 Jul 2022 20:38:54 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727ssgtp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Jul 2022 20:38:54 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 26FKGdWD007079; Fri, 15 Jul 2022 20:38:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h70480bbf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Jul 2022 20:38:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Fri, 15 Jul 2022 20:38:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Fri, 15 Jul 2022
 20:38:51 +0000
Message-ID: <7d7c171e-8ccd-9ffd-6e0d-e5d6a6622f73@oracle.com>
Date: Fri, 15 Jul 2022 15:38:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
From: michael.christie@oracle.com
To: Mike Snitzer <snitzer@redhat.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
 <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
In-Reply-To: <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
X-ClientProxiedBy: BYAPR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:a03:80::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e6e8f9d-469e-4658-8fd5-08da66a206c4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4808:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: JI+iwQbtQZzDjFXTwS17F4fUWq0M45bBWngs+2j8bzZQALbnjlFsPat6lXfSwQl4bPlYKTPifGuSjCo7w0Xy2MHwsmF9u1B/tm+lv+rJ4V/X9jbsI1Z+VNdy2Kz98tzIF80P8YfD+5vFWTaYRJK+FAupcXOx7Yq3305qhIZO4zQF+ySO8dcfH2Sy0TSJJRUSeqjCxe2iicJg2rbShdNTlBwNABwkPH7Gp90EfA5IrK+uD0COoQLJ0Ltv9sPLDUONJvNfnvTr7Mp7XkS1r3tQeKGgwWINjx2yWPEAbiHwrrUdK0MqyDUAXKpWmPmdcP5Y7dk7HTGORN4/Gxv6asXF0C6kKF6OJVzgkdJtRosBcyuey5vKu9evCwcZZzwu71j5O/rEsg/iRhxtW7x31MOaB9sUWVBt73gElnUrV39YewnqVQ2B1ey8Q4MWTOej29xU91M0P+KTqtlnD5zdLiiX2W4rNoQuG9T18JIJnNKNsWgW0D5hCezl7v3QWow0Vwm3ejiFvSAIHgyOGK9hxS5h7IK7NbvHng9XrUDVOy70GP5Zd9cP+AvSPh9ESLaTSto4hcQjgJU8VLIRSV4aBukmKNBPDNlOM3sKqSiq1/h3Mj8xDDLitRTVbH3iYvks+yeemkIV6z/RK9UR7Ex6RLB39Yc8baufAdRSuqWzYMQntpHw3l3nIer1UptKN3hq1L4QRa5ZIybZiaeuGTwmHANNmttYS6gQnIkjz9ymgsHClYc3S/3ALKiQJAU/mfEVt5hM3ZfmqsvAiaDv2JDqqWdQoosaFP0vRjF5GdkygETO5ci3HrPejNiArTCi+2fB/D8P
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(66476007)(66556008)(66946007)(4326008)(8676002)(86362001)(2906002)(41300700001)(6666004)(6506007)(31696002)(478600001)(8936002)(6486002)(4744005)(5660300002)(6512007)(26005)(9686003)(83380400001)(316002)(6916009)(2616005)(38100700002)(186003)(36756003)(31686004)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1hLaktINGluWVJYVXVMNUdXclhFUTY0cllCUm9vS0UwQ3kzeGcvOWtTbUVw?=
 =?utf-8?B?aDZ1UEd5dE1GR2taYU1rdFZlZU5NM0tvWE94Ynl5RzRnM21XdVErbEVMSkdE?=
 =?utf-8?B?Y0ZMRW9qRE04Rk40TUpSZnJXR0JKb29rWWdSQWkvMTg4aEJOMERPelhlaWRV?=
 =?utf-8?B?L0Zna2FXNm91bUpveTNiSGM3VTlLRnNOVm5tZXl1Mms5SC9sTVIvbDFXVCs3?=
 =?utf-8?B?U2trWHRwdWM4dDBoRWs5YU16Mk1qUFVjSmFxOUN5b2FGUktEenJxd0pwS2xX?=
 =?utf-8?B?a2RKTUtCRmozRnBibkloeHRoOXhseHM1T2tiRnBKdFZzanByUUVUMGl3OUk5?=
 =?utf-8?B?bGMyQVN3WXZLV284MVhxMXpyZ2xwWE9weXFsQVBNT0pCUDhaTlRMYXZvK0Vh?=
 =?utf-8?B?MkdLNmRha3dteUxscStYd3ZuaThrR0tBeGxKU0tDVUZFank5Z3VYN3U2VXR1?=
 =?utf-8?B?MjMwclNsem05VmRIRXR4ckVQM2l0d21MSFpYUERHektsS0h6ZVQ4dVM3NzNs?=
 =?utf-8?B?OCtIeThHRzFITHplOXI3QUViMVc1QXdWbnlqMHpNNWh1WW9VdGpscEY2REhO?=
 =?utf-8?B?L1hDdC9vNDBTc1RPU1Nmc012U0d1U2QycHpiS3hnaXpDdW1paENJSzRJRTJJ?=
 =?utf-8?B?YWUyM0xheXQ1TTJzQmh5VXpIdVRFdDhsZ2R0SDRMS2NRb2N5WkFzbHFFMlN1?=
 =?utf-8?B?b0w3MGlKVmFUOXZxbGFWdCtadnMvSnJ5NWtmSFRmSnBlN244S2tyc3ZJcEpG?=
 =?utf-8?B?Z3g2UzFoMkltLzVkbGF4V29McE1PZnpCOEhONm9ibHRJU2ZZREJSSFV2ckJQ?=
 =?utf-8?B?cXl4Y0tMQ2dBK284aG12b3lvV2RzdFZwQ1JBQ0h0dURCa0xKdzA3QU9pNDNh?=
 =?utf-8?B?NVduSWwrUnNpRUdKVEJSYVQvc1lDa3RvalEvZzlmamUzdzZJM25oeTBoRm1L?=
 =?utf-8?B?enA5NHoyR0phMkRkNEZER0dmMkxnM2ZWb2NRRHo0OGMzYmMvSThNem95VGxi?=
 =?utf-8?B?a0F3SHVTejZLOTR4eDB4TlZSa3hldHNBbW9mMjhaN2pvVEJra2FNemxpc2Iy?=
 =?utf-8?B?SThaVjZrSHFYSTZ0ZnV5dU93b3RhM0ZxMEpQR1VQZm1zT21CQjk3SXI2YnZo?=
 =?utf-8?B?d3RMVUdabSsvYkVCUGxNbW9vcXVISmVKRVI0U2VTb2h3Qit6ZVE5MHlmZU1Z?=
 =?utf-8?B?cEdWbFZScUVWTk9HdXNNVXUwUlJzcUtPT2pqK2RxeHRyU0xSU205dTFjdFdJ?=
 =?utf-8?B?dVhYMXduYUJZdjdxSDJGamtVZ1VsZ0Zpek45eWg1a0ZiMjlrZ095akYxK0dQ?=
 =?utf-8?B?emlMODZQQzREMVNHRXI3eGdYVEttTEkyVVVtNEFZajA0d1dMa05xbGlWVDJN?=
 =?utf-8?B?RUJxa3pOOWt1YWp3M2dnb1JOTHJ6aHJZWFcxSEppcmFZMHdpcFlxYU4xU2Jj?=
 =?utf-8?B?ZmhPdHI4d09RRnY3TFViNDB5NWNrWVlDdlAyQW1wcDNsbm9sZ056K29WeEx1?=
 =?utf-8?B?bG9MK0N6c3o3eGltcnRUM3ZSOG5hdGRLM3dnV0Vmdi9LWDd5VW9SendJVHRn?=
 =?utf-8?B?NEJ5b040dUMzc2FUMjhDZkRXY1NWR0FEQVhUVzBQc1p4OGE1cFcwRXAvbFJ1?=
 =?utf-8?B?b3FKUlBWejBNN0FtWnl3UHFnZU1xVFo2UU13V1p0MzN2NTZpMUN4aFJzNWJR?=
 =?utf-8?B?bkJabHJqZjN4TU1GK00zZEh4RmxIcVBZTWNWQ3kvUTlIdXlTaHRyckx3Ti96?=
 =?utf-8?B?S1d6ci9hR05kYUJHdGh0dG8xWS9TZ2hOc1BGVlNzcHpIVWREeWtmVmp2Wml4?=
 =?utf-8?B?NkdUdFcrZ0xMdEI0TE1sRlMwcG4raGdaUWU5TjBaVmRDdVFMdmJ0OWh4UDdW?=
 =?utf-8?B?eVg5OEJOU1NiWmRlU0tYNWhoQk85YkdYSE1CUXVlcnhDNW1EMVU1M20vWGtS?=
 =?utf-8?B?OHNKRHRCWHN1b3FEV05vZys0QzNscVRwYW1Tam5yS1V5VGVkWFhnSlJwbVRp?=
 =?utf-8?B?OUtWL1Z2czhpRUMwMWhrdHJDL240K29OL2ZIM0MxMlNkSU5ZRmZXa1VYdlNB?=
 =?utf-8?B?T0ppU3BCVCtHWmhNQVRWTkhlUHV2TTdMMGdyWklrN3BSVDJvb0llYkFMQjdT?=
 =?utf-8?B?QnpKRmJPNDZKVWptdVFLZlQxT1Y1VE9pRlBCb0s1U1JhOHlCeHE3bWZ3Wkl3?=
 =?utf-8?B?aGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6e8f9d-469e-4658-8fd5-08da66a206c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 20:38:51.5938 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IoOn0bmlcSydMRJ4aK8UKeIGSlIG/Mzlju1CEj8pma6eJVg3J27PGZ02QqIaOXgLl7AUgKpE7sak9ajLVXqG9Rm7epKQfgXFMSfpycR+Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-15_13:2022-07-14,
 2022-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150090
X-Proofpoint-ORIG-GUID: BYbCto1QvIxey1CaoVB_syAhV9APgZis
X-Proofpoint-GUID: BYbCto1QvIxey1CaoVB_syAhV9APgZis
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/3] dm: Start pr_reserve from the same
 starting path
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
Cc: hch@infradead.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/14/22 7:34 PM, Mike Christie wrote:> I also ran the libiscsi PGR tests. We pass all of those tests except the
> Write Exclusive and Exclusive Access tests. I don't think those reservation
> types make sense for multipath devices though. And as I write this I'm
> thinking we should add a check for these types and just return failure).

Let me tack that last part back.

I forgot people use dm-multipath with a single path so they can use the
queue_if_no_path/no_path_retry feature and then do path management using
some other non-multipathd daemon that does stuff like IP takover uses iscsi's
redirect feature.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

