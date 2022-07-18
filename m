Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC31C43334
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658168946;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/NATJ1foSFSH7axwQPcPpA7PUh+z8H3FquC8CbxMuDM=;
	b=MQ6KDrtFy440th4nhZP4+LSk/cMsnUOHtFBL6ctYRyr7FwZQXUOl8HVjFQN5y1OVSTJrpR
	Gbwbc2s/p6vgv6rad4z36WPI7ClkszNRjPUyqs0q8DFsAaHvzFJ2g1dO/5tS3qiFI+H79u
	sJJ82yfq3kSJ9llesBC07ArWXscJzTk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-S9TVPCFxN8CDVXXvsedQmA-1; Mon, 18 Jul 2022 14:29:04 -0400
X-MC-Unique: S9TVPCFxN8CDVXXvsedQmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 467D48032F6;
	Mon, 18 Jul 2022 18:29:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD001C28100;
	Mon, 18 Jul 2022 18:29:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B92031947067;
	Mon, 18 Jul 2022 18:29:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CCFD1945DA7
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Jul 2022 18:29:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47F84400DFD7; Mon, 18 Jul 2022 18:29:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4236A40CF8E7
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 18:29:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26B4C85A581
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 18:29:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244--CrqAeFWMZS1qs7CbHgzOQ-1; Mon, 18 Jul 2022 14:28:43 -0400
X-MC-Unique: -CrqAeFWMZS1qs7CbHgzOQ-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHUTaL013970;
 Mon, 18 Jul 2022 18:28:40 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs455y-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 18 Jul 2022 18:28:39 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26IGuQ21004030; Mon, 18 Jul 2022 18:28:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k42jm5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 18 Jul 2022 18:28:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5928.namprd10.prod.outlook.com (2603:10b6:8:84::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 18:28:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 18:28:37 +0000
Message-ID: <660c9cbd-3090-1591-f02c-c6c6ff13cb43@oracle.com>
Date: Mon, 18 Jul 2022 13:28:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
From: michael.christie@oracle.com
To: Christoph Hellwig <hch@infradead.org>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
 <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
 <YtT1uTW04BC38NSK@infradead.org>
 <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
In-Reply-To: <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
X-ClientProxiedBy: CH0PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:610:e6::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0794be8-aa34-4d7a-8ff5-08da68eb5460
X-MS-TrafficTypeDiagnostic: DS7PR10MB5928:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: UTn6/DRvbZXeJ1/ZduZo1DQ7zdNUjezxnaSqH4SKF/zwc6bR0jxDdA28JG/cMWMFIS+DLpj3Jfwdj5n3rDyaZVkCsMiOKfSHjT0jEzzO8NlFBbHcnN6UoEFkPERW4hIChWNwDCi3FIwMNCC+/cL9d0QSsg/M2irdtmqZIoQ5KLbNTv9VW0Q/9Jksbih5CinWaBpMWJhWG28qFSvVL/Uos/bTDHmwzP+rn2rYH2Ws6Xb48mYtoMZPlzE8E2U7jZ/lDsCNUalIqOHvQsKmEtjdLFEp8jQheayx0Uq+XpOtu4M9IVG9+KG9emuoWtisf8IAcIzxmiHY5cFLitrsFl6s3wyML1KcSW3Z3zAIJCDu8BpbaJ4MQeirPihzCEVByLBOSRv9/iXbEecup1JtZoII907jnZB6KKDmGq0HH9SW7ZXK/JJqHshuv0Lzcr7gTP0P0R0PLstFzLo0fQMfGvo9zngOBKLEZJy1HgxDSaykihjCtW39zNQCJBpyR7z9LO9tB8ZVOLYsr2TfQnnXdraz/vbw3352XsAUp9XE79desoJW1fEnSrGtyf/A5skTtwI5SVkmNfzJUyzKE9xIZ94YGsK9ZUfR+megTvoAeRAIY3Yj6CIVDvHdH24Y1AEreAO1NXypOCVBmra5SfkWQY4pAYhS+x5HOeLYHx6oYmcIeRChx3QcGMzcdC5EhJEjnKoNb55SzySUAiy4+R/J672H/jhcu6LcGKtPQLQ3w7/mJyWwhfqr6lItsb4HSAM9lDimWi2Z1AHZ2f81Bd0yS3u76hCb0jRtlg8vBB1TuB61Urg=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(346002)(366004)(136003)(376002)(39860400002)(86362001)(2616005)(83380400001)(6486002)(53546011)(478600001)(38100700002)(6506007)(6512007)(41300700001)(9686003)(26005)(186003)(66946007)(2906002)(31686004)(5660300002)(36756003)(8936002)(316002)(8676002)(66476007)(4326008)(66556008)(6916009)(31696002)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnJOdURTMCtqKzFuZmNwVENyY240NWcrSmNSeGg1NHZHMHQvSVlEdGk0VExR?=
 =?utf-8?B?bEZJZ1hQSnA1QUtQVXhZMnJvY3J1bld2bXlDbjRiN0FHNXUvOGtBMEttTnQ1?=
 =?utf-8?B?V0g0aFRyY1poVTk2aS9zSllYSDNtNzhFVDdtSWJtVGFhZTFESlNzV2Z2TG1W?=
 =?utf-8?B?ZXg3a2RIN3U0RE1MWGt1T1RacGpwb3NGTHcrNjNVODhCUFp4ditmaTJxMmN5?=
 =?utf-8?B?VTQvQ0w4UWpWSjkzYjF0ZTNpeTBkMGErWTE0Uy9WNzBLQlFKN1lsa1pRRXda?=
 =?utf-8?B?SXo1Z3dBNnVOUFgvWDZDeHRyVDh0Z3dUMERDUFQyNGs1eHNGa3RraE1XNnV2?=
 =?utf-8?B?TkU4RTZscHhadVppdlkwV1JpNjQxRjcyUWRUcWpZVER2NG1OZlY4MmtPcmFU?=
 =?utf-8?B?TjJtM25MdFVmV1ZWWWFWYS9pZTdlVnNsdTVGUHpsd2x6MWF2M3FPSFVNS2pu?=
 =?utf-8?B?R29hOU1mLzc5Zjg4UVdLaFJraFJURWRWZHl0dmJnQlhLM0hWdjBtWDhGVWtZ?=
 =?utf-8?B?ZHNXd0hYNUp5WWZVM3pKSVAxZ09hVWR1K3JJWlBYQ0ZuR0p5K01NRC94bEN4?=
 =?utf-8?B?OUJJTGRMNVljSUVueFp3RmxBcG9Hd1doVVNPdzU3bVNVNG4rT3JIWUdmTTZB?=
 =?utf-8?B?YXRwTU9pc1lBTjRRRXJESno5VnNmZXl5ejJCakFBcUE0ZVRycTliYjN6RnhW?=
 =?utf-8?B?ME5aQWNSQnN3Y2FpNVRmWEdnM083UWhxY0pWejVKalU2SlNlaXBhYjVMTlB6?=
 =?utf-8?B?d0ZwbWVvSmE5THNNRHQxZStVa0kzMXRHaDdsUDNnVkxqbWh4QjNERUxnMUVV?=
 =?utf-8?B?ekJzZ0FwQTFkUzBBOENjTVVSV0tVSFJydkJSSklwN2twejdTVm1INWY0WWUr?=
 =?utf-8?B?dDBweWlMQkhmZmVwbWRkb0FLWXhZTC95aUZYZDJmbHBjREtlbTFJME1RNGlQ?=
 =?utf-8?B?Ri9JYUNyOUhlWE1wUkpwK2JOb0NPOUplbC9qbXArUjMrYVF6UG1uS3Q0VUVM?=
 =?utf-8?B?bzZ6c2h2TGtMdnFlMlRNc0ZPUWsvbmVDSzFITTJ4USs4d0tIenhEQnBBQW5s?=
 =?utf-8?B?eWFYY2s4NW5nMTVabXQ0aVdOVXBMTWRqSi96VUYrVG1FSUdOMERyYTlYNlVN?=
 =?utf-8?B?cm1sS0V0MnlWNmRWa1JDSlBSZUdnOEF5OWdTZ011N0twUjVCY0xsRDJYZlVY?=
 =?utf-8?B?Z2x2QmlBQzJlMHlreUk0NnJDaGpKRnYzbEp6VWg0YUNWamZ1MXlDeUN5S2pY?=
 =?utf-8?B?NWNYc1NSdG1FL2E3MGRJQ2QzeFZ2OEVhNXdCeFlGeHA2amttRmRxb0hZVUow?=
 =?utf-8?B?Vlc3NkFsNy9xOXJmRjlRODh3NVFUZnFSOGI4SS9aNUV0UkprMFcwQzZSaWVS?=
 =?utf-8?B?QVVXeWEwRkxIV29ON3lOZ0Z1U0h2SytlQzVnSVdROWJ2UlV3YVptWTczUnA0?=
 =?utf-8?B?dHZoeVVhY00xNmw1NHpybzVOK1Uvd0hBaUlKUlV0VG1GVEJOYjlBR0RZTUFt?=
 =?utf-8?B?YjNKV1Z4QmlTaThWVllOT0lWdGs2ckNnQ3ZYaWtsRzdFZHZuUVcrU0dsUzBV?=
 =?utf-8?B?aFhsdERDeXhZL0t4MGtDMjFkYnVUQXdvSjBYckY1RmtuWWhaN25LN3ZoUTZw?=
 =?utf-8?B?a1RMalR1WEk4Qm5BekdJUkpCdlZ5d2ZDVzlVZmZhcTkwQ1VmNXpOTFVOQzVo?=
 =?utf-8?B?VmpnRkVUVGhmN3RzUnhvY0krMDVaYXduc3doeXh4bmk5T2N6cDNiREdWOE9P?=
 =?utf-8?B?bGNrSDdLYXlsclNiVlhwUEs3MHY1Q2hxcnhieEI4RENtWmNIZDFUS0lrUkx5?=
 =?utf-8?B?VmdESHdSWHVUSDdubEVPeDZKSTdLWFJMQ0lMdUd5cE0rd2d2Zlh6eTgvbGtt?=
 =?utf-8?B?V3BPclBGcmczbjl3S1cvcnEyTG5xVjZoQ3JBOWttQ2ZXWVh5emNRMEZPamRn?=
 =?utf-8?B?b1kwK2k0TjVLMEJrdkRxWWlQUVBNbjkvSlpJaUljbW55ZnhZdGJWZGJ3a3RY?=
 =?utf-8?B?SVhxbU9NU0V1bDN4bitlM3BuYk8raXhIZm9JQnVVK1J1cnFpbTgvajNoZ1VP?=
 =?utf-8?B?NTlGMTFOL20xS3Jqb0ZlRis2RDhkbEVRbHZKblkxWUpJR2VTY1JSRkREZEpq?=
 =?utf-8?B?MnB3bUs4ZFFWL3Z5eFMvL2dHZk1Mdml4SXlmekJwVHo5MzBPaG16cUpwNStF?=
 =?utf-8?B?L2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0794be8-aa34-4d7a-8ff5-08da68eb5460
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 18:28:36.9970 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcteXkkm6VPQYPBepIVqi5IHxSHbwi0hqOtfG9DoYEuom9nz2XQNRBLRauuGpCPV5v+tMBdshpNJ/WcXk/hmOfzy5CvFfQNJBEK+WraHQJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5928
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_18,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=770 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180079
X-Proofpoint-GUID: zCVgTAdQBnwO4vQE2-pirkqIBuFlVPy4
X-Proofpoint-ORIG-GUID: zCVgTAdQBnwO4vQE2-pirkqIBuFlVPy4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/18/22 12:39 PM, Mike Christie wrote:
> On 7/18/22 12:55 AM, Christoph Hellwig wrote:
>> On Thu, Jul 14, 2022 at 07:34:57PM -0500, Mike Christie wrote:
>>> I also ran the libiscsi PGR tests. We pass all of those tests except the
>>> Write Exclusive and Exclusive Access tests. I don't think those reservation
>>> types make sense for multipath devices though. And as I write this I'm
>>> thinking we should add a check for these types and just return failure).
>>
>> Why would any reservation type make less sense for multipath vs
>> non-multipath setups/
> 
> I think those 2 types only work for really specific use cases in multipath
> setups.
> 

...

>>  2) the target actually has a useful concept of the Linux system being
>>     a single initiator, which outside of a few setups like software
>>     only iSCSI are rarely true
>>
Oh yeah, if we are talking about the same type of thing then I've seen a
target that has some smarts and treats Write Exclusive and Exclusive Access like
a All Reg or Reg Only variants when it detects or is setup for linux and it sees
all an initiator's paths registered.

So yeah I guess we should not fail those reservations types.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

