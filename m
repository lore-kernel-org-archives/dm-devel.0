Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F035C432BE
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF34560EE4
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF34560EE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-jzcuIey2MQu9Sj0GGJws7A-1; Mon, 09 Aug 2021 02:53:45 -0400
X-MC-Unique: jzcuIey2MQu9Sj0GGJws7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09EC287507B;
	Mon,  9 Aug 2021 06:53:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2289779D0;
	Mon,  9 Aug 2021 06:53:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B73954A7CA;
	Mon,  9 Aug 2021 06:53:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17611J5i020231 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 21:01:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AF3E3115D93; Fri,  6 Aug 2021 01:01:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7953115D92
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:01:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3242A800182
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:01:16 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-122-JHyZA7EINZaeovbQTjRhEg-1; Thu, 05 Aug 2021 21:01:11 -0400
X-MC-Unique: JHyZA7EINZaeovbQTjRhEg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	176112Et028188; Fri, 6 Aug 2021 01:01:02 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubpu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:01:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17610Ars184188; Fri, 6 Aug 2021 01:00:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
	by aserp3020.oracle.com with ESMTP id 3a7r4apyc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:00:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25;
	Fri, 6 Aug 2021 01:00:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 01:00:57 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-4-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
Date: Thu, 5 Aug 2021 18:00:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-4-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: SN6PR05CA0013.namprd05.prod.outlook.com
	(2603:10b6:805:de::26) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	SN6PR05CA0013.namprd05.prod.outlook.com (2603:10b6:805:de::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4
	via Frontend Transport; Fri, 6 Aug 2021 01:00:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e106df5-e72a-4800-c5f2-08d95875a5ee
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2712496B605482D42FBFE44BF3F39@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ilsREwpHh6vvSvMX+dqa21Kiln2AX1PXBJTSDp2RY2vDVLFJCQIKd8R3eKbzDDmm5cixZ0ilI4gN6rFN8dpDNITllWgrHhKuL8/wdA9mNNJefE7jMcep7EPutwxPNrNM2s+rdE/JxwGwre26wusQVTX2+j6b0AUI638vy8sPNrAwCqixRJBzPdJlEK4l1d7s62pV++12c5bSL3maRzDXHlqli197Cd/usNJKSIiPW906knmBavOd8fke7Rse3VP8WrLVPe7Cj0AgQRRemYkj34o3Cz/5F+s4aYA+q7UEkmAVuWz4g+XPwdmAnAD31GtWglxk+8JAJiN8hIagTA0m+kBpL23Z5KTUxjFSBkWKgDftttftXLt/jxIt7Z1PWoON6DQ0d/zVQ2vtrNc5KWgu7xWFZPrMIJ2bpO6Xa0QaOzS9IBXBiFLK1P+7FmirLP7uFjoA7fzlSCityfS3v0+2R0YCIbAku59WsyZ8BWjZ9pTtxPkmCERL7oJviUW1PnsMUtGOFOvoc0oW1qKnvzyQEFR16WErn7116aHFFUb8EwvyRJvKT5ZXo6Bte0Lb53y1txi273XXij42Ef8LHO728m8yqx/vz98NetM/i/1e1uAF7yh4eoGrbmAJVd1HcduCguU/ntvWfFtdzHvD12ciK5rrK/j6SQr2wYpbVUhGUbYI4D/9bkTNWbcGgDMXkaGCDezBD0cSP3Z3hBGYekG0jZCO92NTjs41ymH+B4BjUF0wBErNKoiDjDLYdYDjtaEj
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(396003)(346002)(136003)(366004)(39860400002)(83380400001)(8936002)(7416002)(44832011)(956004)(2906002)(38100700002)(53546011)(16576012)(6486002)(186003)(316002)(36916002)(2616005)(26005)(66946007)(31696002)(478600001)(36756003)(8676002)(66556008)(66476007)(86362001)(4744005)(31686004)(5660300002)(6666004)(4326008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTB4NnlJUCtYKzhBbGptU0prd3o3MDNhYzBwUDI5ZG40UU9tTkI3UmFJZVla?=
	=?utf-8?B?ZzBYZEpYaW5iNXhCME9IOC9YNTh4WUNFZGs3T01mcVhleFNNSjZZKzl6VmRi?=
	=?utf-8?B?RitzSDBMNEM0S1lYdDJFTUQ1MG42T3lWYmgzM2RSNGZKcmZLYWNURS83cERE?=
	=?utf-8?B?MDhrT2dPcitibTNHTkpNRzRWcE9CdW1DSGpHTy91cHZ0UEFmbGNnMWFJV3Vk?=
	=?utf-8?B?eFNWQVNja2k0enBlaDFYanFDYmhJUlNncGdhY1ZOMzJlTTY4TnhhNGJyNkJ5?=
	=?utf-8?B?OXhkK2lOa2dycFdRY2x5M1BkNnF3T0U1d2FnK0ppTHdFQ0JRUHJZalltbCt5?=
	=?utf-8?B?TDQ3YjNwOWoweHdLVnl0UUNFQ3QwcDh3L2hncWZJQVZ1R3RFZytsRjA1YVdV?=
	=?utf-8?B?MjdaUTlxTGkrK1hOOWJKbUltNmRRbzY3UnBpcjhGOWRnRTA0WVhnc0tadkMx?=
	=?utf-8?B?Nk5LYkxubG1yZ3Btb2F4eUFnNXNwSy9pQkRENEZvVnZnTlFwV0lGRFdHRUVz?=
	=?utf-8?B?Z2Q5THRwTndsNTFHNitMd0NmSTBRUkdPNjlTcUNiK2hSZ0QxVEU1SVNlSGV5?=
	=?utf-8?B?anRFc1FMVnFJSnJUNGt6WHRydWZwbWVXaDBPWFhldVZ5aStzNmlrbXVmK3hh?=
	=?utf-8?B?QUYvbHhrRzVCK3A5ZG96OVVpeUY4WUpZZTFVeTNJYjR0Nkh3bEE3MW5JWGZX?=
	=?utf-8?B?V0ZBcjFoY1JqSkpmK1VRTXFwZE1MdUZsdm1iTXlOYjVreXlwOGNRMFIzZ29w?=
	=?utf-8?B?Z3hpTWlYUGtlVWRlN0s3NFNsWHpGUHdkdU40V1dRSFNRbVlVNXpLem9SN29i?=
	=?utf-8?B?QWUvQ0l4aXMwdE1jUTVkSnM5c1dSWHJCN2lYM2NqZGF3NmtXUC9GWXBYYWhp?=
	=?utf-8?B?NmZpWVh1ckw3VFI3cjlWNmhmVXA4RThUdGVOdk9xTEh3UWttMUZ3Q0pKdXBj?=
	=?utf-8?B?Wm1oMmJhOW1PaG84T2sxK2taaGVjd3lTQXJKQmdlUyswOGJPditRODhrZGxT?=
	=?utf-8?B?NDVzVGhDaDRnSEVPK2ZxVGtEZ2I5WTBKS2FQMEtTbW1RdEd2UXBqcTdGRk1y?=
	=?utf-8?B?K01JMGl0bkx2VFExU2hnRkJyT05SeGZJUDJENXdXTUY5SndMRTY2VjU4dWk3?=
	=?utf-8?B?cng3aXNtanEvbWJYQ3VNSitmODNsTGs1SWN1cmh5ZmFCVUhqYU9MeGo0MzJv?=
	=?utf-8?B?OUFOSmxZc3FjQWl5UmRBclUrRVdJTkdmTjdtWjZOZ2NSaVN0N0RCWUVCZDFU?=
	=?utf-8?B?d3VvKzQxeTVJTWdpTTducks4TmVteGJ0ZkRVcnkyMitKTnljRlhpOWYxWjlw?=
	=?utf-8?B?Q0FSZFliTHZKb08ydVB6LzBNMEVwOFpIQ3l2SFRKemVHNTZNRkI4bGM3WlNr?=
	=?utf-8?B?Zkd1NXQvVXZxazJpOWx3TFVmbXlldHZxTFhWSnRhK2pjN25mZGRSUk1oZ1dK?=
	=?utf-8?B?Ky9lYUdWekYyUS93NlFwQTBxYWljU3ZwbHpKNUpZWnU5RllwNEhqTGhFYkFQ?=
	=?utf-8?B?ZUt2cXhhdkEyQ2RCVURFb0RpQ3A1Z2o5MG4rcXNrYWVQV1JBcFVxcER5RWJ6?=
	=?utf-8?B?dEtvbVZPSDhOUkpjNXJhRlM1ZTdNbVhmTUkwT1cwaGFtUHh0ZXE4T01mbU5q?=
	=?utf-8?B?TDMwY3VlZlhBNDlKcU9OdFQva2Y2WTQrYU8rTjdscHdrTFRieHpuRlFzT3Fm?=
	=?utf-8?B?NmN1Ym9iL2NQbXFRTVJFSVBSRjYrT1RDMFlrV2tHdnA0RlN2Qk5rWFIzZi9F?=
	=?utf-8?Q?z9qp+hgovL9xN26gaAlc6+2l5YY/AIhNDcivbBD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e106df5-e72a-4800-c5f2-08d95875a5ee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 01:00:56.9734 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKQyeNAO23LPrvSyLmwK2VD9ln/bOAznFEYG12crnDORxEVVvwDL5/4twxubKyAh9h2Em9BYPHZgvPYccGiLxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	malwarescore=0 adultscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060004
X-Proofpoint-GUID: qX5BLRTE6Ck7nVaTfXshSA-VOMU45SDF
X-Proofpoint-ORIG-GUID: qX5BLRTE6Ck7nVaTfXshSA-VOMU45SDF
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 3/9] mm: factor helpers for
 memory_failure_dev_pagemap
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> -	/*
> -	 * Prevent the inode from being freed while we are interrogating
> -	 * the address_space, typically this would be handled by
> -	 * lock_page(), but dax pages do not use the page lock. This
> -	 * also prevents changes to the mapping of this pfn until
> -	 * poison signaling is complete.
> -	 */
> -	cookie = dax_lock_page(page);
> -	if (!cookie)
> -		goto out;
> -
>   	if (hwpoison_filter(page)) {
>   		rc = 0;
> -		goto unlock;
> +		goto out;
>   	}

why isn't dax_lock_page() needed for hwpoison_filter() check?

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

