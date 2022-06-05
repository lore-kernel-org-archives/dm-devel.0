Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037C4CCA487
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:46:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-CMhy4bwCPIq5zA13YzN0Wg-1; Mon, 06 Jun 2022 02:46:24 -0400
X-MC-Unique: CMhy4bwCPIq5zA13YzN0Wg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0054857CEA;
	Mon,  6 Jun 2022 06:46:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDADF492CA2;
	Mon,  6 Jun 2022 06:46:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CAF491947BA4;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF80C194706E
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 16:55:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88DF52026D07; Sun,  5 Jun 2022 16:55:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83DFB2026D64
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 16:55:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65128185A794
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 16:55:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-Z3uvhhOfMwO-gDsHSgGJwA-1; Sun, 05 Jun 2022 12:55:55 -0400
X-MC-Unique: Z3uvhhOfMwO-gDsHSgGJwA-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 255CwMO5010787;
 Sun, 5 Jun 2022 16:55:43 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmr4nf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 05 Jun 2022 16:55:42 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 255Gtgb1012689; Sun, 5 Jun 2022 16:55:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3gfwu6sc2k-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 05 Jun 2022 16:55:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3343.namprd10.prod.outlook.com (2603:10b6:208:129::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sun, 5 Jun
 2022 16:55:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.017; Sun, 5 Jun 2022
 16:55:38 +0000
Message-ID: <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
Date: Sun, 5 Jun 2022 11:55:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
X-ClientProxiedBy: DM5PR12CA0010.namprd12.prod.outlook.com (2603:10b6:4:1::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb26cef1-4f60-4b2d-3632-08da47143741
X-MS-TrafficTypeDiagnostic: MN2PR10MB3343:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB334363A0FC5245224E13F1EBF1A39@MN2PR10MB3343.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: n74rLXK3FEunftKQmaGliz+JJSAjTlEEd8FKEZgomTNCiNxdiINT50OXuUfV5DZ9mRXkMnS3AAEDNii7E7QaaCba3aVZDz2fRwDugogoluralDh2MRKUyCbXK48viE7DKNK0weP/lqYJJo4ecbZeTjGQQ9ycQzopinOwscOmbu1Br87hawbvox/qSQhNnj6C9ZevF5dssZ+qfsmps0SADzH3lrNk+2DSG0PDsf2Qw7GZNi3KP04dwTtxkLL1dw7oplr5kgT28jrTn/Qzmm8P6oMgUS6VrzlCgG/IAxtFTP9EWPFQ8Zr8EGNEpCIqWk72YwduGUoAB9Gg4T6BRYCmHsQXA+cbI7w3FSoBk/zhMp5ioKwu6/mpryWEjRfuW7Uzqz1y0obDZr+pWdo7ABwZkwyxFzQuG1d5vROvWoB+UfDU8uz38zkh/ve79FAeDv8wyglVh6g3beH1d8LTSQyC8tUv8aZf8kah9Ik3DdN7S/YM+rxHEut9ymg76PGlTh2vcu+R/2qQQ/akXY0PQYcIlfYEvxbVhwKhfRssZ/Gm/3sXeis3ghIgWMDj/c4li5FWk29xkRbB2SU5qv9QuBolol9N5nwQlJ4SVRKA+N4a1D29v2y2GiBTsdaldoT2+frEyyXrie0692iAlkQS9rYvEknEWijh3/l+auAo978IBrO5s9rja+YsyeDeLGJ+IglQxlLGuTOXtbW2LbESDQYUp3UWxrWmY7mCRd6O08iTfI9l/Y5tPa1TbIoiy/6Pdz53ps5O7LSohDk1Cf4xB/R8ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(31696002)(38100700002)(6666004)(53546011)(2906002)(921005)(6506007)(316002)(26005)(6512007)(186003)(8936002)(508600001)(31686004)(6486002)(83380400001)(8676002)(5660300002)(2616005)(66946007)(66476007)(36756003)(66556008)(86362001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UktRK2c5alFneDh3UFFjN1JVRnNkRjNRSzNXamVqWE0zWVZTL2k1dHI0MVRq?=
 =?utf-8?B?SXZyajZDTFNzYTJkdjJLd0dVcGV3VHVuYjU4WFZydk9WT1NRQ0RxRjI4Y3o2?=
 =?utf-8?B?bnUvZlgyVytPdFNWejJFeTNNS2d0WGV4aHdCV2NuUVd3akQ0bnVyWUhaN0NS?=
 =?utf-8?B?U3ZTaUpqQkdrMCt2VGZMbHdhWDZEWk9hZmVBcHZOMWZFYXlqNkdRb3kyVkhS?=
 =?utf-8?B?QWR3djI5VUJaYXNKK3Evd1VqbDJpYVpnQlpKSCtnYVQveWVHUWZoU3A0Q2Jx?=
 =?utf-8?B?M0ZYU2E0bkg1aVI3QWo4c3duUTJYSk9Yc3hndHB6c1I0TEVQQmYvYVhjckZK?=
 =?utf-8?B?K2xsTitaRklZK2dBUUt6OE9xTy9kbWlkTklwdDVPU2tFMVBkTjhnMno0OXBq?=
 =?utf-8?B?bSsxeGo4QlFGOUFROEh0aHpPbDJWbDRhQ2lzenRyTGlFQnh3UFhCbEFCYkxz?=
 =?utf-8?B?eE1HRk00V2V0M1FHdkpFTnhlZFJHdUNpdHJ4QVBQTnorZ2V5di9LbHJYeWRS?=
 =?utf-8?B?NUcwanIwYXNEUVBIRUU4cWtROTFIWWVGeUFkVjBURzd5TlZZeGVsaFRhRC8r?=
 =?utf-8?B?RzZvcEh4d3YzVlJhYTdnZ2tuMWswRkpPT3N6b0dCK05NZkpyTjFhay9Eb3A2?=
 =?utf-8?B?UCt5dUIrY1A1OFhSaldPVUNPN0JXVEc4QXlBdG9PdVlpSlBKOGZSYWhDNU9V?=
 =?utf-8?B?MFhqejRWN0hackoxVXZjb1d6Z3lGTGI3c1c2TTFmb09oZ2lWM2VDNWh0NG0y?=
 =?utf-8?B?MXdZVHpUNWkrYjNxR3NlSFhvRXhHOXhSMW94aTgvR29WdzQ3bjU0dURUTm9v?=
 =?utf-8?B?WlE0aml4YUc3ZGNScFo0bGFQQ2FJMEJRRXFtWkx0Y0E1MTgzQmJjSHByM0xh?=
 =?utf-8?B?clY4V3RCMFVQQllmM0Z1YmN6alZweFE0NUMwdlhPbnFOOFdMREtXTFlQYWFi?=
 =?utf-8?B?ZHRYQUNuYWhwS1JKRzFocU9mYkVISlZqL0FRUGJnVjlhSEFiWUViSzlyWk1p?=
 =?utf-8?B?cW12Ukh4eHVkTThyVFA0Wnl1L3VjL3FKaXd0ZFJmUW44aDJSZ29WOS9nYVA2?=
 =?utf-8?B?TytQa0dDTTBSZXd3Tm5BR28rUzhWeE9KYTlUTGVDcU5pcHpmZDFqQ0JZejZX?=
 =?utf-8?B?MXkvVjZBcitKRUNkQWYzbWtuZm9tMEpLZmdnSjd3Q3pQRDhxcGpVS3pzaWZK?=
 =?utf-8?B?ZFBHeDlkcGovaFp3K0w2RHBhcWJlTDhRZG8wNnlYOFU1bmI5b3pzR3NaME0v?=
 =?utf-8?B?RzBWU0ZBTW02LzFSblI5LzRBaWtXNUNSendDcnhsVGNXUFBsZHFlc3VLVWtp?=
 =?utf-8?B?UVVwNmxkYjFyZC9BeDhBaDBrYVZPVldiaGV5dEVnTTQwNTlub1IxRmJ2Q2xX?=
 =?utf-8?B?cFRSVTV3ZlV3aHU4ODVhYmh4UVdlWFYyWG9GQlFBMG9mOEhwM0YvalVBMXo5?=
 =?utf-8?B?RHVMK1cyVEJLbWI3bVlKcnBkQkk5eTNmdTNzbzZMSENxYlcwQVpiTktuUjZX?=
 =?utf-8?B?VlNpRy9YTnl6S3NLbTdIR3p0OXVNTzh2RklUU044UUIzd1BwVTh1YzRlWkFK?=
 =?utf-8?B?aHJVbE5FZ2FsQi9qZXF6SUdRY0gxaHllRDVJaG1EMTBHZ1NCc1RrTC80dU5L?=
 =?utf-8?B?eW5tK1EzUS81Zm9pUC8yZ2gvWEtqUU5ZWFRrVm52NnJZRkROTXNVVGR0Nmxj?=
 =?utf-8?B?bllFN1NseWJWWDI0aitVQkRicUEvUTUzYTFrcGU5NVZ5S2JQZ2JPTnBRUUJR?=
 =?utf-8?B?d0tGUGM3dUFTaEN6b0NXNlhROUllZFZCbkN5dTlXQUo4Y3ZNTmlnSFBOUHVL?=
 =?utf-8?B?S2ZMMmJNU3kyYTBFTTVEWXo4MlJTY2VBanVya1VITEhMdjhkMktOUGtZa3JG?=
 =?utf-8?B?NFM3NnRQZG0wZGp2OXp5NXFCTldMSU5ENTg2Z0ZDcVJzeVhaSHNuNC8wa0sy?=
 =?utf-8?B?TlhUQzlXbFc4UUZvZ2xZdml1Q1IybWJGL0FaUjdJRW5ITC8wMzhNOGlUTXJD?=
 =?utf-8?B?V1IyTDlSbHhBQ0RQQWRhMjBPSWhYSkhFR0NIZlJqL3BPcHRwT3pmeGtpOEt3?=
 =?utf-8?B?N2Z6WC9QM0orMEkyaFJPVHQvbnB1bW0vMlY2V2RjbnVPazVQWklNK0hlUzRN?=
 =?utf-8?B?aVVWOHVFOTFyQUFER0dvUEo2bitKRlNCQ1NzRWVEMGprQ2lTOGZ6R2hnZlhl?=
 =?utf-8?B?OWRZVUFYOUlDREVyaGoxY0NIMkFueHFhUUR4U201RnNMMmhObE54VmxCVDgy?=
 =?utf-8?B?RU9kU0xjMUNxWnA4bS82OW5pQUJDS1VSbTUrOXR6TTZWNWRwUFBVWXFDU1B1?=
 =?utf-8?B?dFBGcDExZ2pNVWkxSnZ6ZUliOThwSWc2WkNKNngvZ0xLQ0Y5T1NDcmJSd3Ny?=
 =?utf-8?Q?l8ncVPMsiBqWjihg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb26cef1-4f60-4b2d-3632-08da47143741
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2022 16:55:37.9847 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XZcP/wSPPgUcpmyt+LQj56TN6CPGsrpnTvZ26JMZ1m4sWikzHegHRTn/F1Qw7Lwi6dQN0f6kwgz/dDBCxobqyvobLGg5DucwKkPgPJYeUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3343
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-05_09:2022-06-02,
 2022-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050082
X-Proofpoint-GUID: i-gfswmU86Z61O9NVZZZFGB_UUAlxb3j
X-Proofpoint-ORIG-GUID: i-gfswmU86Z61O9NVZZZFGB_UUAlxb3j
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On 6/4/22 11:01 PM, Bart Van Assche wrote:
> On 6/2/22 23:55, Mike Christie wrote:
>> The following patches were built over Linus's tree. They allow us to use
>> the block pr_ops with LIO's target_core_iblock module to support cluster
>> applications in VMs.
>>
>> Currently, to use something like windows clustering in VMs with LIO and
>> vhost-scsi, you have to use tcmu or pscsi or use a cluster aware
>> FS/framework for the LIO pr file. Setting up a cluster FS/framework is
>> pain and waste when your real backend device is already a distributed
>> device, and pscsi and tcmu are nice for specific use cases, but iblock
>> gives you the best performance and allows you to use stacked devices
>> like dm-multipath. So these patches allow iblock to work like pscsi/tcmu
>> where they can pass a PR command to the backend module. And then iblock
>> will use the pr_ops to pass the PR command to the real devices similar
>> to what we do for unmap today.
>>
>> Note that this is patchset does not attempt to support every PR SCSI
>> feature in iblock. It has the same limitations as tcmu and pscsi where
>> you can have a single I_T nexus per device and only supports what is
>> needed for windows clustering right now.
> 
> How has this patch series been tested? Does LIO pass the libiscsi persistent reservation tests with this patch series applied?
> 

libiscsi is not suitable for this type of setup. If libiscsi works correctly,
then this patchset should fail. It's probably opposite of what you are
thinking about. We are not supporting a a single instance of LIO/qemu that
handles multiple I_T nexues like what libiscsi can test well. It's more
like multiple LIO/qemu instances each on different systems that each have a
single I_T nexus between the VM's initiator and LIO/qemu. So it's more of
a passthrough between the VM and real device.

For example, right now to use a cluster app in VMs with a backend device that
is itself cluster aware/shared you commonly do:

1. Qemu's userspace block layer which can send SG_IO to your real backend
device to do the PR request. Checks for conflicts are then done by the
backend device as well.

So here you have 2 systems. On system0, Qemu0 exports /dev/sdb to VM0. VM0
only has the one I_T nexus. System1 exports /dev/sdb to  VM1. VM1 only has
the one I_T nexus as well.

2. Qemu vhost-scsi with pscsi or tcmu. In these cases it's similar as 1 where
you have 2 different systems. How you pass the PRs to the real device may
differ for tcmu. pscsi just injects them into the scsi queue. We do not use
the LIO pr code at all (pgr_support=0).

3. This patchset allows you to use Qemu vhost-scsi with iblock. The setup will
be similar as 1 and 2 but we use a different backend driver.

To test this type of thing you would want a cluster aware libiscsi where
you do a pr register and reserve in VM0, then in VM1 you would do the WRITE
to check that your pr_type is honored from that I_T nexus.

And so we are going to run our internal QA type of tests, but we are hoping to
also implement some qemu clustered SCSI type of tests like this. We are still
trying to figure out the framework (looking into Luis's ansible based stuff,
etc) because for general iscsi testing we want to be able to kick off multiple
VMs and bare metal systems and run both open-iscsi + lio tests.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

