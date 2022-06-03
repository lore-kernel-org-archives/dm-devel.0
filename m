Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEDCCCA483
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:46:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-wr7TYsW3ODyIcXjVv3TGsQ-1; Mon, 06 Jun 2022 02:46:22 -0400
X-MC-Unique: wr7TYsW3ODyIcXjVv3TGsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E4971C13941;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38DCB1415102;
	Mon,  6 Jun 2022 06:46:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F7A61947B90;
	Mon,  6 Jun 2022 06:46:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6499E194704D
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 17:56:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 11F881410F37; Fri,  3 Jun 2022 17:56:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D1601410F36
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 17:56:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E54D4811E75
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 17:56:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-t203n9UDOEuwIdM1YDRhPw-1; Fri, 03 Jun 2022 13:56:01 -0400
X-MC-Unique: t203n9UDOEuwIdM1YDRhPw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253FK45T017182;
 Fri, 3 Jun 2022 17:55:40 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfgmsgwd9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 17:55:39 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 253Hiubf018458; Fri, 3 Jun 2022 17:55:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3gc8knu86u-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 17:55:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BL3PR10MB5490.namprd10.prod.outlook.com (2603:10b6:208:33d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Fri, 3 Jun 2022 17:55:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 17:55:35 +0000
Message-ID: <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
Date: Fri, 3 Jun 2022 12:55:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Christoph Hellwig <hch@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603114645.GA14309@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220603114645.GA14309@lst.de>
X-ClientProxiedBy: DM5PR12CA0001.namprd12.prod.outlook.com (2603:10b6:4:1::11)
 To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d14f32c5-61cc-427b-f303-08da458a42d8
X-MS-TrafficTypeDiagnostic: BL3PR10MB5490:EE_
X-Microsoft-Antispam-PRVS: <BL3PR10MB5490F0924F0FF8CE7353B730F1A19@BL3PR10MB5490.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QcEa1ejL2OB3/itfohEt1AaRiFwTF9rDvJRbZVX/pt6eK+42xjvRZkOf0Rw/jpyYshfbrP/r9BKQY9AeqPeMtmDJVVPkgVfYxHnjm+Sgnpika67uD5lPMMiJlR4tpOH4bFxD3dXT+bp3YYP3BXFFJjqSHnWqtzKhztNTpT4uc8W7/Koc+JhnN91Jqf3KCcQssv8A0uquYbNgTz9hnk4koAwobtOJQHIWjXL/LQTzSBNpeGkVD3YPZDuP6zPsRnrJVeadk3xgbSX2aoydRX2lLiHGMO8H6OAtoWOKxUj8GE7UJmmwjQgkT1o2kHxI3W1ok3Z2M1J3TavW1+19VCYt9mJHHX+xcoF2H4CwJf+DpQfRWulmap29cTiP0hrXk8Ugee4zyJSmGW6FdSAopMZiQyXYSIEsCbZKBlC91NWCtgqMiF2EITdsrYv3covpwJxAkgENUywGIoOkcouoqtRnYtfNzi366HDs7WIvww3JsC4qqZvKko6YVbTSa19dtKVUuXnmhs3Ci2Rh4NrgCdSZ2cg9J/jTwmwqOcoKNoHziILyKOdZVs/V0NAeWEbwOG3jTimdzJgx1sPX6XLF+r8ndgCXW+bfZZvkydh7D4O0kxiMc8YMZ+J9K2CH8P5U3FvQgagHjjHBmL63+2BQoR1fOH7CiWsiAXJvVlttLHd2R6+ndWaiOhogsMWYiPgMlhBHI+aG+/Ff1/khKoJTbJk79dEBUgr+O/kVYAxRLMlDCO/il56MMA1/dWvfSi8qCqGYKfS2wJ+xqdCj7gNxu4kUlqTRSjYkEoPW5R8pRcnEdkuTsB3/+I6wGvtzHUYV3k+ZgXU+sCmhzqJPBaj/JkIm4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(186003)(36756003)(31696002)(53546011)(2616005)(31686004)(26005)(316002)(6512007)(6916009)(6506007)(86362001)(508600001)(2906002)(5660300002)(66476007)(83380400001)(38100700002)(8936002)(6486002)(66946007)(66556008)(4326008)(8676002)(966005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDlScERqTkt4UWFHZFZZMDFGMkZlQ0lVYUxpWnVGNm9ZejlrZTRBa1hhNjFr?=
 =?utf-8?B?RmdiS1N0U3IyMHZ6WHBYaDRSNXNxUzVaWkNpRnR4eFBQYXVwMmV4NllwRmUz?=
 =?utf-8?B?WWMwczJNcmhQeVl1M3JsWHNMazl4YTFNWHlnbnlWZS9YY0s0Rm9ucU5FbzVH?=
 =?utf-8?B?V1NIRnlZR3B1ck14anpuS1B4V0Nucmp6ejNCL0N0cWU2N2NJNUNIRmFZL3hR?=
 =?utf-8?B?YS9Sek40d1c5RDgwekJPZzJHaXFUMnhHMXV6UXNTZHI2b3pZVmxiM1dZcWFY?=
 =?utf-8?B?ZUw2d1R5QjZxRzNqSS92Zm1FSGxzY1RXcFlncDdhR3U4dzU4V0oycHBKb0NG?=
 =?utf-8?B?dEJLM29HWGZVL2lpVHlKL2txeUNsRWtaTldkN2l2emxhL3M0OC9MTEg1cS96?=
 =?utf-8?B?dWtqWlZMYmg3U3pzRlRsdHBHeHNSd05nekZ2MWlLVEM4dk9iSXJoNEtkOGhN?=
 =?utf-8?B?aDJlTEFmdmxlZUorVXFpOWZnMVI0dXhkQ1poekw0UFZxTXhGaHF5V0V6WUwz?=
 =?utf-8?B?TlZqTmZFQUlCUzlpNStiM0lTV3B2akJiazFaOUFkeXArSkRHL0VyL0RsSndi?=
 =?utf-8?B?cVpicm1OZi9PZ3V5TERuV2Y5RXN6RGZpSENBNEpYRnVucmFMSzNpRFkxalJF?=
 =?utf-8?B?WmJNZ3hxWHBvS3pkN25xQ1JYRUlWd1ArR2ZoNjFEUTBQUFZEMWpYMS84RXh3?=
 =?utf-8?B?ZVhrVTlqRC9ZdUxuL2YwcWZlbEQwZklmdFVSWUt2alVjZWlxSUgvSEttSjd2?=
 =?utf-8?B?eE95TC9scG5CYkpqT0c0eVdVZVJocGtXb2VqSTBRRzlTdjBKNitVNGxMSWhw?=
 =?utf-8?B?VXgrVCt0WGJMUW9wZnJ0OUJ3TFYrM3A5KzdNeGhhZ2srdlRuUWV2RGRPbzJj?=
 =?utf-8?B?M09QT3RXVDdpNUZnZm5maG91ZlZVNFdnRnBYdTFnQXNBbjA5RXRyR2lwbGNq?=
 =?utf-8?B?SkQ2czdqRDZsNEJTbjkxa3MvUVR4Wjg4em04NWtxMGdsZ0k4VjBBS0pBa1VH?=
 =?utf-8?B?Vjd4RVp6VFhkMlZ4bXoyUHlYWkNsVG16Q3Ztb2N4dHNaQjlyOXRxd1FUYXRO?=
 =?utf-8?B?ajFhbm80N3BkaVlGcDB6REliajlybDBLUnNsU0ZWV2kzZ2JzQWR6NTNLZ3RP?=
 =?utf-8?B?Um01YVJLczRBeW42a2JFb3JRNTc2UjgyUHJYaXNHcWlmcWdjZTg3Tm00ZktV?=
 =?utf-8?B?b29PaEd4VEJueFYxTGE4R0JLMGIrSFZGaGw5OWtoZys3WlFWNFdyNlBQNjZa?=
 =?utf-8?B?Z3EvVDV2N2tibzl5aFZmL1kxQW1NNGt4Qi9pVm5rNXEwbVFMTjgxQVFWWFFa?=
 =?utf-8?B?OVM5OGZJaWRjeTQxMDl1MUVzbmVyQVJBWUNtakhIZFRkRXNVdjJXWTZZWGZ2?=
 =?utf-8?B?S3R4SlAxWTBjS3MycnBkaVNVeDhNL1dsQ1J0T3lwSXRRREZNNXZIK1ZSYnBP?=
 =?utf-8?B?WnVVWUp1VUlMelNGZldDaE0rRHV2a3NDcXVLQVR2d0lxY1g4MWgrNmNvMkgy?=
 =?utf-8?B?OFdhTE14QWQ5SnQ2ZHpkZkUxN2pVMTBTTXhDQkx4eHIzcktKVy9CQ1RRMGYx?=
 =?utf-8?B?RGIvOThRS2Y0cnQvRnlPeUtqTUNUazlyODdSUFhBeXBuUzZaV3FoL0JhM1hz?=
 =?utf-8?B?VHVIK3NkczlDYUpMQXdibHdzMERJQk9sNitmRHRGWm9VZEpZRzRuTENBY1lE?=
 =?utf-8?B?cGF3OW0ydldONG93WEdDTlRHZVlrYnkyNDYzV0RVYmJVWmF1UUlFK2NTSDUr?=
 =?utf-8?B?VlcvWnRlcXV6dnlxWjI2SkRsbTFOUDlMTmcyL0hYSnlNc0pTNlVJeUlnMndw?=
 =?utf-8?B?cFArY0lTT1BZdDFHdzlEZ0R3d2cvbmRnbFpOY1FsT1d0cXNJK2hwb1hJei9L?=
 =?utf-8?B?T09oWjQydlhnQXl2dXlsOVk2ZWo3RnBmbmF0ekZMMTZGZ2NzN0t1aDc5ZWt1?=
 =?utf-8?B?eHpsdEhhWkdPV0Joa25NYTVJa0R3MUt3WFJzcDh6OUh3eTlOWndBUUl1a2c2?=
 =?utf-8?B?UWJTaEFOZUlYUlBFa09RekNJZkMwdytQRW5mbFRmdUJPNk5MQ2poSi9qVklv?=
 =?utf-8?B?QTZUdTNZRWhXZE1pVnV2RTQxT2dIaUd2ZUJhazkrRVh2cW9MeWVVK29obDMv?=
 =?utf-8?B?RWdXK1JvdzNzVnBaSWg1TFVCR1o4RUdQeS9vVmtMRFZhb1R1V2NyNEk2WGV5?=
 =?utf-8?B?U2Z4VFdVU3RXUkR0VGFyeGI0T1Y3OWoxKzdtUVFMSGxuSDVNSDBSMmN5RThX?=
 =?utf-8?B?VzNDZDdvYzcyRzJZOXQveWlQNGhvZGwwZ2RsK1F6N3NQM25jSWNacEhlckRk?=
 =?utf-8?B?QXh1bzY0ZXFoQXZLWjB3c204UTNXbGZ4MGVPd3ZKN0IxVnZpS3pLN3YzR0VB?=
 =?utf-8?Q?oeIVt27bwrGWMoik=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14f32c5-61cc-427b-f303-08da458a42d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 17:55:35.7538 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFCex/nFlwtOpqpCg1NsMK+MevmhGYKk6h9KNIbvP6FZmIeBt6yviPSzkp8yAPP0cUF0CwGhiwqcNlTjAL8h5NSFii88J5iV9Wndz+bcA+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB5490
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_06:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=859 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030073
X-Proofpoint-GUID: U_Xu2kgsliFV8H7fMoU_iFeTrXnzGJ1e
X-Proofpoint-ORIG-GUID: U_Xu2kgsliFV8H7fMoU_iFeTrXnzGJ1e
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Mon, 06 Jun 2022 06:46:17 +0000
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/3/22 6:46 AM, Christoph Hellwig wrote:
> From a highlevel POV this looks good.  I'll do a more detail review in
> the next days once I find a little time.  Any chance you could also
> wire up the new ops for nvme so that we know the abtractions work right
> even for exporting nvme as SCSI?  No need to wire up nvmet for now, but
> that would be the logical next step.

I forgot to cc nvme. Doing that now. For the nvme list developers here
the patchset discussed in this thread:

https://lore.kernel.org/linux-scsi/20220603114645.GA14309@lst.de/T/#t

For the patchset in this thread I only did the simple SCSI commands
READ_KEYS and READ_RESERVATION. For nvme-only people, those commands just
return the registered keys and the reservation info like the key and
type. There is no controller/host ID type of info like in nvme's
report reservation command.

I did the basic commands because the apps I need to support don't use the
more advanced SCSI command READ_FULL_STATUS which returns the equivalent of
nvme's controller and host ID. I also hit issues with SCSI targets not
implementing the command correctly. For example, the linux scsi target just
got fixed last year and it only works by accident in some cases where we have
2 bugs that cancel each other out :)

However, for nvme and for the interface we want to provide to userspace,
do we want to implement an interface like READ_FULL_STATUS and report
reservations where we report the host/controller/port info? If so, below
is a patch I started.

Notes:
1. I hit some issues with SCSI targets not reporting the IDs sometimes or
sometimes they report it incorrectly. For nvme, it seems easier. SCSI has 
to handle a hand full of ways to report the ID where nvme has 2 ways to
do the host ID.

2. I couldn't find a nvme device to test. Qemu and nvmet don't seem to
support reservations.

3. The patch is only compile tested. It's based on a different patch I
did. I'm just posting because you can see the pr_reservations_info data
struct we could use for nvme and scsi if we want to report the ID info
and keys/registrations in one command.


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca544dfc3210..161a715ab70a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3156,6 +3156,28 @@ static int dm_pr_read_reservation(struct block_device *bdev,
 	return r;
 }
 
+static int dm_pr_report_reservation(struct block_device *bdev,
+				    struct pr_reservation_info *rsv_info,
+				    int rsv_regs_len)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_report_reservation)
+		r = ops->pr_report_reservation(bdev, rsv_info, rsv_regs_len);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
@@ -3163,7 +3185,8 @@ static const struct pr_ops dm_pr_ops = {
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
 	.pr_read_keys	= dm_pr_read_keys,
-	.pr_read_reservation = dm_pr_read_reservation,
+	.pr_read_reservation	= dm_pr_read_reservation,
+	.pr_report_reservation	= dm_pr_report_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 71283aaf3e82..1f251b8f381d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1770,6 +1770,101 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	return 0;
 }
 
+static int sd_pr_read_full_status(struct block_device *bdev,
+				  struct pr_reservation_info *rsv_info,
+				  int rsv_regs_len)
+{
+	int len, full_data_off, i, result, num_regs;
+	struct pr_registration_info *reg_info;
+	struct pr_keys keys_info;
+	u8 *full_data;
+
+retry:
+	result = sd_pr_read_keys(bdev, &keys_info, 0);
+	if (result)
+		return result;
+
+	if (!keys_info.num_keys)
+		return 0;
+
+	len = keys_info.num_keys * sizeof(*reg_info);
+	if (len >= rsv_regs_len)
+		return -EOVERFLOW;
+	len += 8;
+
+	full_data = kzalloc(len, GFP_KERNEL);
+	if (!full_data)
+		return -ENOMEM;
+
+	result = sd_pr_in_command(bdev, READ_FULL_STATUS, full_data, len);
+	if (result) {
+		/*
+		 * TODO? - If it's not supported do we want to drop down
+		 * to READ_KEYS/RESERVATION and just not fill out the port
+		 * and transport ID info.
+		 */
+		return result;
+	}
+
+	num_regs = get_unaligned_be32(&full_data[4]) / 8;
+	/*
+	 * We can have fewer registrations if the target did the ALL_TG_PT
+	 * format where it does not report every I_T nexus. If we now have
+	 * more registrations then someone is doing PR out commands so try
+	 * to get a bigger buffer.
+	 */
+	if (keys_info.num_keys < num_regs) {
+		kfree(full_data);
+		goto retry;
+	}
+
+	rsv_info->generation = get_unaligned_be32(&full_data[0]);
+	rsv_info->num_registrations = num_regs;
+
+	full_data_off = 8;
+
+	for (i = 0; i < num_regs; i++) {
+		/* every reg should have the same type? */
+		rsv_info->type = scsi_pr_type_to_block(full_data[13] & 0x0f);
+
+		reg_info = &rsv_info->registrations[i];
+		reg_info->key = get_unaligned_be64(&full_data[0]);
+
+		if (full_data[12] & 0x01)
+			reg_info->flags |= PR_REG_INFO_FL_HOLDER;
+		if (full_data[12] & 0x02)
+			reg_info->flags |= PR_REG_INFO_FL_ALL_TG_PT;
+
+		/* We use SCSI rel target port id for remote_id */
+		reg_info->remote_id = get_unaligned_be16(&full_data[18]);
+
+		/* We use SCSI transport ID as the local_id */
+		reg_info->local_id_len = get_unaligned_be32(&full_data[20]);
+		if (!reg_info->local_id_len)
+			continue;
+
+		/*
+		 * TODO. Do we fail or operate like the SCSI spec and return
+		 * what we have and user should know that they messed up
+		 * and need to send a bigger buffer to get the rest of the
+		 * data;
+		 */
+		full_data_off += 24;
+		if (full_data_off + reg_info->local_id_len >= rsv_regs_len)
+			return -EOVERFLOW;
+		/*
+		 * TODO - we should put this in a easier to use format for
+		 * users.
+		 */
+		memcpy(reg_info->local_id, &full_data[full_data_off],
+		       reg_info->local_id_len);
+		full_data_off += reg_info->local_id_len;
+	}
+
+	kfree(full_data);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1845,7 +1940,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
 	.pr_read_keys	= sd_pr_read_keys,
-	.pr_read_reservation = sd_pr_read_reservation,
+	.pr_read_reservation	= sd_pr_read_reservation,
+	.pr_report_reservation	= sd_pr_read_full_status,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 21a8eb8b34b5..ec325a0ed33c 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -30,6 +30,9 @@ struct pr_ops {
 			    struct pr_keys *keys_info, int keys_info_len);
 	int (*pr_read_reservation)(struct block_device *bdev,
 				   struct pr_held_reservation *rsv);
+	int (*pr_report_reservation)(struct block_device *bdev,
+				     struct pr_reservation_info *rsv_info,
+				     int rsv_regs_len);
 };
 
 #endif /* LINUX_PR_H */
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..66028d37ac5d 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -39,6 +39,35 @@ struct pr_clear {
 	__u32	__pad;
 };
 
+/* Is reservation holder */
+#define PR_REG_INFO_FL_HOLDER		(1 << 0)
+/*
+ * Registration applies to all SCSI target ports accesed through initiator port
+ * at local_id. remote_id is not set in this case.
+ */
+#define PR_REG_INFO_FL_ALL_TG_PT	(1 << 1)
+
+struct pr_registration_info {
+	__u64	key;
+	__u8	flags;
+	__u8	__pad;
+	/* NVMe Controler ID or SCSI relative target port id */
+	__u16	remote_id;
+	__u32	__pad2;
+	/* local_id size in bytes. */
+	__u32	local_id_len;
+	/* NVMe Host ID or SCSI Transport ID */
+	char	local_id[];
+};
+
+struct pr_reservation_info {
+	__u32	generation;
+	__u16	num_registrations;
+	__u8	type;
+	__u8	__pad;
+	struct pr_registration_info registrations[];
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

