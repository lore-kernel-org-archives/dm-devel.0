Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C698DFA3746
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198343;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1gFG5H79BI+8b33ywmvz1RNjZktTM1EOE/HGjytrRlU=;
	b=gRp2es/zMghUXm5LbAgo3q84DZKKEQ6hsJJ4wfZImUz3j32dnchbimT6WzXhNwO0OjGlVd
	g4Cj0bBS71BrhQMaKrAGpG63rsGdMjlK2NB2EamCtDCCyYsKg3UZ4bl+h6tSeTXNfd3Xi4
	U2IhKdj68RnHCLVFQdEvQw3jiio4w0Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-kqpl-iV3Odu42XZuagyO6Q-1; Mon, 31 Oct 2022 02:39:02 -0400
X-MC-Unique: kqpl-iV3Odu42XZuagyO6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3684C1881424;
	Mon, 31 Oct 2022 06:38:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2957207B34B;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D951E1946595;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00A521946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 20:55:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF9304EA5B; Sun, 30 Oct 2022 20:55:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B7D18EB4
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 20:55:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2B3E833A06
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 20:55:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-n3vdgP3zMoqg1d8mgcXXWg-1; Sun, 30 Oct 2022 16:55:06 -0400
X-MC-Unique: n3vdgP3zMoqg1d8mgcXXWg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29UKk1l3028231;
 Sun, 30 Oct 2022 20:54:53 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgusshycr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 20:54:52 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29UDNUPt029388; Sun, 30 Oct 2022 20:54:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm2jqu4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 20:54:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5240.namprd10.prod.outlook.com (2603:10b6:408:12f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Sun, 30 Oct 2022 20:54:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 20:54:49 +0000
Message-ID: <fb1fb550-14fa-d2cc-cf03-e0b129fd1ba0@oracle.com>
Date: Sun, 30 Oct 2022 15:54:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Christoph Hellwig <hch@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-12-michael.christie@oracle.com>
 <20221030081851.GB4774@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221030081851.GB4774@lst.de>
X-ClientProxiedBy: CH2PR05CA0018.namprd05.prod.outlook.com (2603:10b6:610::31)
 To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 769593cb-9fc2-47a2-6220-08dabab8fc5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: NOx1OLF8wyQacWok9mlzvC49Z1fVgiq+CjM/Aq+FBzuzgrGCapaJeINBnfZ5IYcoaL3UMQQlN0qkDh4qHyaZbzVdyU0rsvb9xqMxaI0vh4NIZBEWu/eklRNn8OAh5RJ+1taNASzZ4hPXwLOPkYpjvRJt/4TDls1pSdch0o83LgVqHzkWBclRoKIuGb2iDu/sp2dpJYApL80rnplIGWIkAE7Y0y6iPRQIKsJ7AH9jiTNWPZXafXlV6Ew8rd46hwXS+1zKOcHNp27GA0j/xuIVKNbLKcNMTOIbN8pOHi3vtqWMQkvqlJZmJpE35CyndWzILpvjsDis5gQovpiPNB5iHFwG9hq4HNICb/6pTNZXib77ilx8qarjH6RDhzOyLKi4ZJdKrGPb7TS9m1d8H8rEEjYSuhNVdNKyoV/ZbS2H1NPBNgh9gm2Ky7mMtVD1ZWL2MvXnkNeeH4orTFbbb+4Y2cJwhQmp6cebLms8upDp11BkDO9tLVvLHejWgTiiNJ2NGumIM6K6BMuZUER02EtonRtD9zQVDdzxxy5TOeo9G8dMbm0E23XpkiBrcMJ5zZYkc5QfX8eqveiewpxDOncTpX1wycZkK0kHEu2+eq00IynsL3rPQa2qyR/1F9Mh42BmXJ1HRe/bWTZu4HPc1J0XsVdK23kflthvgTmGxnV0W1l/7gY4g8ksKVVfODfpXW6KJs+ByAMiwXu1vvo61Oo2zS1VRvyqE/88sYS8MK8Qa6+EzmGCqyZyGKsrD76WDhOaqw8q8c+Jlmd7zUAtHO6bXcUhuDcYJPcVT0rL8at160U=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(36756003)(558084003)(31696002)(86362001)(31686004)(38100700002)(2906002)(26005)(6506007)(186003)(478600001)(53546011)(2616005)(6512007)(316002)(6486002)(6916009)(66946007)(66556008)(66476007)(41300700001)(4326008)(5660300002)(8676002)(7416002)(8936002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDdYOS9qTEFNb3dncDhzZ3NCbENyTlVWclVmSXBYa0tId2pKVERFTXNER2JW?=
 =?utf-8?B?alJQMDR2eFZUV1plSHV2QjJYT0pHRVlORU5Ibkp1WUNySTZSODErU0dmUnkv?=
 =?utf-8?B?cTdQWTNBTjN1TmFPZTRhbGlzQ3FzUWxuck9pSnlmWUFCcThxaEp0WGVqR2Nz?=
 =?utf-8?B?d2kwTC9ETXpVSFkzMmdmWU9sUmc4cGVWZFJjWjgvaHNtQ1N2dFZvV0IyOVpI?=
 =?utf-8?B?SXo2b1lqOFdJa0hzRFFhOEZZMUtvOE1mWXgvTFd6RldjUzluU2lOdk5DQUlG?=
 =?utf-8?B?ZXMxdzZMdC92RTVVelk3VGVuaERHc0c1QzA2YlJjVkNNb0NpRVRON01nSGJU?=
 =?utf-8?B?cDViVFV0RzZyQVVNVVNiaXdsMlhGY2JVUWVxMDZGYk10dm1LNFAzWjRRREh0?=
 =?utf-8?B?UDlwZFpML2NoczFZNExYcXpRT3R4N3R0dmhTa29qd1J2ZE5SNFBaTHBWRjlL?=
 =?utf-8?B?UGVQZm05VXU5ZXRoSk0vbzQ2SlVTOVU0OFM5RUpPVEQ2amtsbjlLa25OMUp1?=
 =?utf-8?B?Y1lDbzRpcU1rYmN0VXE1UWRXQ0VjRkdmVDh0K0dKdndjU0hUNmZld0hCV2ty?=
 =?utf-8?B?dWRlQ1c0ZW4rQjVHMVNjMloxRStXRWFmZXptSjZwUzJKZ0F0eXh5dG5zQkht?=
 =?utf-8?B?SnJadk9Id0dyeXpEc1FIRnhJNGx0MWhWTjZQZUl2QlN3R0lNdWt4RFRCMFRs?=
 =?utf-8?B?V2tnbHF2Tm1WZjRqWTRGc1pZMW5UVUNkRlZrWm95TnM3TDBNKzNLUGhTaUVF?=
 =?utf-8?B?UU52MDloVENWN0dWSTVXbEJsSFpTU3FjOEhnUE5kNlBudU5YZTV5aHJUeWMw?=
 =?utf-8?B?OW9JcFk0cGR0RWd2QnZRd3lMV0FWUXk2Q0tONFM0dFRUWC9kamduRWdGOTJw?=
 =?utf-8?B?bU1ZWU9qMHc3dFhFalFRb2hkZEEvWVpRVFhnc2hzdWF1cDU4TnlnZkZxWTJa?=
 =?utf-8?B?UTlaaEpOdjdHRHoxcHo0eWpZRm82eTkraXpKVlNxeDFjMjN5Zi9UZ2Rocldi?=
 =?utf-8?B?WXlrY3E5dTNxaGFNL2VBemNjbWlRVmdYdVhBaXA4dTlxYkF3cGFTTE43d2lF?=
 =?utf-8?B?cE8wb2g4OU5aQjNIOGZVMzA4ZUtsNEtudkEzaG9KdGZKeTBBWnV4aFhkV0ND?=
 =?utf-8?B?a3JYVmxjeEZ0aTdxcjdzdTdSeEZaeWc1V1BmaTBmMXVZaEVJeTFpUmdldkhi?=
 =?utf-8?B?aUpLNDBHZTMra3doWE1YWlpqZXpDbmh4Nk4wN3VsalBBWHIwTGpXVUNGOGpT?=
 =?utf-8?B?MlF6UWRkdk55NHU2cHZ2K1FnLyt4QzBJb1V0S3E5M0ZrNnB2YzF4S2NrbEJV?=
 =?utf-8?B?RUFCVG0zTTQxTE9lSHNVYjVIelY5R0ZEOU0zMlFxanlpMXEvWWF0dm9NSklJ?=
 =?utf-8?B?dnBpR3RBWlFBMlpwYlB5RWs4WGZGUkJkK09qaU9pNWc5cUJJMUI2ZlV3aGwv?=
 =?utf-8?B?aG93NUNPZnNLM0taditIdWJjS21TVGFtdzk5cWpJeGtSZDMweVhrWnJ6SFo5?=
 =?utf-8?B?SzltZVJad1FZaVVGNEo1aXAvUWE3aFlmejB2aHhkMXhYQ1VoMjRTRkowWlJ0?=
 =?utf-8?B?MTREUm9EQ29rWEpNeUFicWNxVnVreERFUTkzZ2dJOUJhR1lYZU1JVU5NSFpT?=
 =?utf-8?B?Tm1nd2FLTlVtSStWMXNUbDl4aG9nYVplM043dHhCUllId0szZHBnYXk5M0dY?=
 =?utf-8?B?eEFiY1BPNEhpQW5NOTJUcjZYTUdiemt6S0lNUC9aRUhhY1hlOVo4UVZLOXcv?=
 =?utf-8?B?Q2ZBNnFxeEdxZDc3WG5FOEwvOGlJSlFvN2NFSGhiQ3NZSFd5YkNJN1ZSMkhR?=
 =?utf-8?B?di9lN0VrNzBoMC9mTHVlY0NMeG5tYmFQWVlodnA2Sm9aeU1zSHNQeXFUS0pK?=
 =?utf-8?B?NDQ1UGMvU1RVYkNqRVlQZGRHR0FKT2ZoM3ltV0U4QlhMbmozbHcrU0xEM3ZC?=
 =?utf-8?B?QzBtSEN5S1ROY1NnekxKRjBrT2FKTG00ZjdVc3NEVjZNVDMyV2xVdjJtTWZt?=
 =?utf-8?B?NVEzTkJLYnhSOWMxTjliSHBiVldrRWZPY2RFaXQxNlNvNlMrZXV1WTc2aHRr?=
 =?utf-8?B?QVFRY2t3WGJtTSswcnFVU1lKdEZKbk03bGFVRnptaGpHdXkySTE1cE1iRXNo?=
 =?utf-8?B?RFRRQWhHdHNzdmw0NWFNSnd0Q0xSZFJBTHpnUHJsWG55OTdHbG4yZytMWHJS?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769593cb-9fc2-47a2-6220-08dabab8fc5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 20:54:49.8610 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYkCD5emTAE1U7JL2Nt1Wo6WnQOthxuLk/3g8E2DPFPEnOdEnQ/rKarHmGzf0vzrZorCW0xoVXgHs6/swQtd8P9LIwIaJAQu4lEweN6FkFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-30_14,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210300142
X-Proofpoint-ORIG-GUID: XUE5_YiefUfS4tIyHvsEWWwk3WCfUqV8
X-Proofpoint-GUID: XUE5_YiefUfS4tIyHvsEWWwk3WCfUqV8
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 11/19] nvme: Add pr_ops read_reservation
 support
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 bvanassche@acm.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 kbusch@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/30/22 3:18 AM, Christoph Hellwig wrote:
>> +	memset(resv, 0, sizeof(*resv));
> 
> Is there any good reason this isn't done by the caller?

I will change it.

I think it was leftover from when I was experimenting with
some mulitpath support. It's not needed anymore.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

