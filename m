Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE79C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jul 2022 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657379215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d2Z5XRVhS8QBMvtX7yzs20oTLaWzE9YPkysyAGmR2r4=;
	b=Q5K4rVX0ppPeo13YETZrrAx8fjGv0SfEcHMZ7JuNkwNUWElwsQ/MVMWi4gONVjE1ovJGPg
	kwBHwHodk5LNcMSFqYyRPNN4lFtBNXbMgLFk2E5RMQSQli3jNzo9xUvb4HyE++THfs5nJr
	ZMjXIA1w23LABHNkTRJlZIafPnnkIws=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-9CCSB10PMrSY3CvrWGqukA-1; Sat, 09 Jul 2022 11:06:52 -0400
X-MC-Unique: 9CCSB10PMrSY3CvrWGqukA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 528B1380673B;
	Sat,  9 Jul 2022 15:06:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0FD1492C3B;
	Sat,  9 Jul 2022 15:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 83F711947072;
	Sat,  9 Jul 2022 15:06:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3D111947040
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Jul 2022 15:06:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 927ADC2811A; Sat,  9 Jul 2022 15:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CC90C28118
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 15:06:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7095885A583
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 15:06:44 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-TKxakC7IOiKb1v2NKFHbDQ-1; Sat, 09 Jul 2022 11:06:40 -0400
X-MC-Unique: TKxakC7IOiKb1v2NKFHbDQ-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 269D4oGi010865;
 Sat, 9 Jul 2022 15:06:33 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sc0hd8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 09 Jul 2022 15:06:33 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 269F0R44020813; Sat, 9 Jul 2022 15:06:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3h70404p08-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 09 Jul 2022 15:06:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4812.namprd10.prod.outlook.com (2603:10b6:806:115::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.21; Sat, 9 Jul 2022 15:06:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.023; Sat, 9 Jul 2022
 15:06:30 +0000
Message-ID: <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
Date: Sat, 9 Jul 2022 10:06:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220707202711.10836-3-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:5:334::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa44a8b2-dba5-4de2-011b-08da61bc9ab8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4812:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: T786PNFpkkpWHX899/t6+x9kWtIgS7tcxO22985PI/+S9H0dkp5yH7DxcXwYAEgY25NilF0HgCKodtyZQj6XqO+cCU6cf9+zRwsqlIQwX7usucocY2u0k1fYRND+sxO5S8KCDjWADVSAZLVAnqy6RF4gkw6dlBEIVTQT5leAHTvLYtIzxKqwjrI1wLlyvOVWRk/78S6z8Syo678M8NuZe2l7quRscZ5U5DYzSBcBkwLeRnjaL9hBxnfGol9ymEnj57Cljv7FLXmxFL1nzmxlBMTBDOlod5N3GEJMrof8X9xL8MX45Q8IY6t1HoAsPU2cflg7f6XnbMhkK7gQCOI8D0OLcINmR8NBZv+I2+YJc0JyYembTOYaAwph0o5elhEu4oBBzajnD357SMvZYcUu2BHQbG3WlIAhI+/Moxq/VCiPlJedmRVZTmRJu2Ei+iAedUd1q2r+Q18zzzmCnbORtJ7xu0sQVNU6urxyauubpDNny64Pz/GAsobsU2cLl0bT4KS28e3dub9YQa7MrMakHunT5Z4lWN4e2dIEmswy4OnBjdhfk1MVmY1fvOV4oWo7XqQykYyGPWSPCjcXDUJHwHPMKNiuRxmcFoFAhrLddW14ccLLr9SPG3Nho6jv6gMkJVtdBFGjBEayFKe1KBISreS04FyhM+r1Fq6Jq30MqdeLU4wnb+2sMZ9RxEq+jbiv79oD/Uwzcf5NWq3qxnsjiIZ9sEHthrlVKNJ9w2DlC0ZvmajEtDTXSFMgopmfOQdwoG3ZAfOhB/fFIYX9K59LfjmDh6cuL3T+eFwDZgntomdQbcxzvrGHDR0pFYVjjz4mSImnahDpPmv3v+xYzuZeDmSln9Dw3WaD0pQJz6ZQ348=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(366004)(39860400002)(376002)(396003)(346002)(186003)(38100700002)(36756003)(31686004)(66946007)(83380400001)(66476007)(316002)(66556008)(8676002)(41300700001)(2906002)(31696002)(4744005)(6512007)(6486002)(478600001)(26005)(6506007)(86362001)(8936002)(53546011)(5660300002)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXN2ZmYyV0JtdmNtSnBvckFPRnlDdGFOSStKZGx0bTJJQWNYanpYQThBb0l2?=
 =?utf-8?B?UmNydmk4K09jdGZ3N0w3ZG9jWDkxc050NTR2RkxnelVVd0FRMXZFU2hpZUlV?=
 =?utf-8?B?ZWFMRTdvNThpYm9pYk5ZT3NJOE1yTzJiTW53UHZ4N2xVZG1aMGkyZlNpY0hI?=
 =?utf-8?B?dWlzNXZPZFNHN3d0aE9VR2V6ZW5BQkdBYkp5UHBhWm9pcEM2NzQ4aDk0MmtQ?=
 =?utf-8?B?R1VkZ0VJRnV2SVdWYWhkNjJOY0xjYzcvNzJsc1lRYkN2R1BueU5wYTBCcGNv?=
 =?utf-8?B?K2syMVZvZnQ3dHVsMHlBV0toSWhxbDdwZ1luaFVXM3lJYlRYSEFpZXN1WDBa?=
 =?utf-8?B?RXBQaWQ0REUwSzdyYTJUelJqNGxZL3FUbldpSkRia1VSSzg5NkNjVkwzYXdX?=
 =?utf-8?B?VXFScytQRllzME1VVkY2OHBkSmpOQ1JZdjBZN3c3bWl4THp2Q1l6ZWMwSXRx?=
 =?utf-8?B?T0FrRExqb2xsUHlJdGZJeWpJZmtoeTNkZXRVeVVuZDRzM25rWVFjM21yWjgy?=
 =?utf-8?B?Sm1YeGljWVRoM0FSOWdoNHdHcE1LZzRGYyt4L2hPK01wUDU3MW1LMWowUmQy?=
 =?utf-8?B?b2poN0EralgvSU9PNlE3QWkvSVdqQ1Via2RWUTJJbVVvSmxtbHR5R2R0NTla?=
 =?utf-8?B?UXpxL0RqNEhRa2dZeFdqVktrS0svOVdFbjlNbXJ2UEZQMVEzbjlYdkZkMFNF?=
 =?utf-8?B?TDUrSTQvWlBkK2QzTTUrT0Izb21jQms1K3g0NnA4QmxoQUoweXNXWUV4ckg5?=
 =?utf-8?B?ZW9ZZlF4bFovSEFWUndLVGhod1ljdDBscnN1d1BocWt6b3Y3UDYya1hpL293?=
 =?utf-8?B?YjZLSTBYaEc1aW8xTUJLa1ZzeHRoWXVUZ3d2Mlg3RWppUFBmdnpkQkI3U01W?=
 =?utf-8?B?TnFidHBiWHgzSXA1ZU9MVllGalUvTlZaazhibnlPTDJuZ1RJSGsrajBCT0o5?=
 =?utf-8?B?ei9XOW1PYi9HeTQrekM2bHhuaGthSGR5M1Z5c3VFcEtXaHFwTTNJekF6NDhz?=
 =?utf-8?B?cGIwRGNuSVpoOE00RTlLOWRIZGlLdlAwb3hZTVorNzRZOW1yYlNEbm1EZ2pB?=
 =?utf-8?B?eTBuUktva1ZHWktoblB3MkFpVmEvTjBkWEgwcUI2WTBiTUpXYy9YQWhWYzZG?=
 =?utf-8?B?cHBOelZqV0EvZGpXMGJIbXhBS0hUZGhCbHJoemtQcStBYXBBWDMvSHV0cTR1?=
 =?utf-8?B?Q2FoT0pEWWxoWlBwV0c3dEE4SDVTMXg0YUpUcGg3V08vYndodUxqcktwR081?=
 =?utf-8?B?cTY5SWFSemJBeUNTZjRneWl5Y3ZRcHoxMlR1cHZBTFZNNlpGN0NtMzhtUnVJ?=
 =?utf-8?B?SE5sUmlSMkFwN2F6OHpQVkZ1RFFmTFZjUHVtYXFmZVZjcDF4YTFjdlRMbzY0?=
 =?utf-8?B?Ny9lM200ZWFnOUFLcUlWNHpOcVFQb01rYkZJUVFOSHAzV2t1TkNhM3JrNVU5?=
 =?utf-8?B?ZkI2cUlOQzRaV1Z2ZlFMTjJvVlhSQ0ptQzNYak5mN2VETDNxZFA1WDdCQUlr?=
 =?utf-8?B?OFpRUkl0YjJsbFdWbGlZS2lMS0l6blVDRXhrUktuRCtIZlNVa1R2YklPa2Yv?=
 =?utf-8?B?eEZ4enE4VnNranFSNVZTcEhuYjU0NGN0RlQvK0NleExnakRqY3cwa3V6Ulo5?=
 =?utf-8?B?bU9oRUw4cWZiV0dTTmZ5TldiOEpoRWFQck01bHJKWGIwa2UzV2FOSFYvd3JX?=
 =?utf-8?B?QlEwR2FSa2wrNzRLVEtLcTlFSU44VWhHM0hlQUZhNzNHeHcrdFQwNzQxT3R4?=
 =?utf-8?B?R0lkZG1hVWVWVU1yQTVYZmtsUkpnTHpDTjVqTGxJVi9OdG9CRDcxZ2FtVmVX?=
 =?utf-8?B?REM2K1NpNnQwVmR0dFZsb0lHd2hrSFZyK2VUMVpXTWRKUGd3eTZXSWI0Rlpj?=
 =?utf-8?B?a0g2eldWQTNiMGVmSVVtRm9RSGRRMVNhbXJ0Mm5UWTYyZjBEdjgvU1RMdkxh?=
 =?utf-8?B?djRiNFFKTXNVcm9CcjNncDRtczZnTDEyZlVvdG1tQWlvQkIySTV1OVV2TzNI?=
 =?utf-8?B?RTYzV2lMTHZTTkxUSTdycnhHMGtUdHN4cnhSQnRSd0N4T3RSZEhhK2tnZTJz?=
 =?utf-8?B?cHNTZld2YzZubWI0QW5DNmtVNjlBME43ZDJzM0J4L2ZSUFBiYzc5dEZLMFFU?=
 =?utf-8?B?Tld0WUw3STZWTGF2UjhMeFluMlltbEtlSHVhazhOcDFvajdqelB6OWQ3aUNs?=
 =?utf-8?B?dnc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa44a8b2-dba5-4de2-011b-08da61bc9ab8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 15:06:30.6654 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egcpHaZUa2CibjjCRqtVxXiuceamMV6LRd68GJjIBBpSKoZkxWSJP9bE4s9dAjGYGppUvMDBWY1ioovurWcawnVSpmWULewWGlE01zLxgqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4812
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-09_13:2022-07-08,
 2022-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0
 mlxlogscore=650 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207090067
X-Proofpoint-GUID: KZMdE99D97hXdhuLU-3dCvsiHmyqyE6f
X-Proofpoint-ORIG-GUID: KZMdE99D97hXdhuLU-3dCvsiHmyqyE6f
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/7/22 3:27 PM, Mike Christie wrote:
> When an app does a pr_reserve it will go to whatever path we happen to
> be using at the time. This can result in errors where the app does a
> second pr_reserve call and expects success but gets a failure becuase
> the reserve is not done on the holder's path. This patch has us always
> start trying to do reserves from the first path in the first group.
> 

Hi,

Giving myself a review comment. pr_preempt can also establish a reservation.
I meant to send a patch for that as well. If the approach in this patchset is
ok, I'll send a patch for that as well.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

