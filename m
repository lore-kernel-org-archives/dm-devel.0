Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E505BC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 06:25:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-Xq1-UCM-NQe4ottZg5vRnQ-1; Mon, 28 Feb 2022 01:25:40 -0500
X-MC-Unique: Xq1-UCM-NQe4ottZg5vRnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9233F1854E2C;
	Mon, 28 Feb 2022 06:25:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7344F62D4F;
	Mon, 28 Feb 2022 06:25:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DFE51808800;
	Mon, 28 Feb 2022 06:25:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21QN0Drs020222 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 26 Feb 2022 18:00:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C5176141DC57; Sat, 26 Feb 2022 23:00:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C02E8141DC2D
	for <dm-devel@redhat.com>; Sat, 26 Feb 2022 23:00:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A336780159B
	for <dm-devel@redhat.com>; Sat, 26 Feb 2022 23:00:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-578-UlKOaeM1Odqi0iVGk0N7dQ-1; Sat, 26 Feb 2022 18:00:11 -0500
X-MC-Unique: UlKOaeM1Odqi0iVGk0N7dQ-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21QIHOf4008190; Sat, 26 Feb 2022 23:00:08 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3efb02hbaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Feb 2022 23:00:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMueW4129187;
	Sat, 26 Feb 2022 23:00:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
	by aserp3020.oracle.com with ESMTP id 3efc11pd8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Feb 2022 23:00:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
	MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22;
	Sat, 26 Feb 2022 23:00:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
	([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
	([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026;
	Sat, 26 Feb 2022 23:00:04 +0000
Message-ID: <ec8d0b97-e94a-21e1-acdb-e90a7df39b72@oracle.com>
Date: Sat, 26 Feb 2022 17:00:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.6.1
From: Mike Christie <michael.christie@oracle.com>
To: Zhengyuan Liu <liuzhengyuang521@gmail.com>
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
	<828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
	<CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
	<be26ef80-c3cf-713d-2a9f-4fb73cec7e17@oracle.com>
In-Reply-To: <be26ef80-c3cf-713d-2a9f-4fb73cec7e17@oracle.com>
X-ClientProxiedBy: DM5PR07CA0029.namprd07.prod.outlook.com
	(2603:10b6:3:16::15) To DM5PR10MB1466.namprd10.prod.outlook.com
	(2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfda1d5d-68a3-43b1-6380-08d9f97bb981
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB57506F2541BB6333ACCC6553F13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: HOnWY6IjpmJrqKzseKJp2uud+YW1Soj8t/amdgkFi0BhhNy8LLHLq7WXIvVfxhzG+w0/hGTgGZxUeBTbOZo7HomMjS6gTyp0rxyXWAMn/wcL5XBtKVPfN5C83atUonaibAeregpa+VvVCh7AzhWwquBNTi1APT+dB7m8Q2Icye3xAheTiyLct9+G4E4eujhQhb2Jpm4g1oEK6uFC0Dj7/HtXM6h3Z7dEtumuBMkxKYFzdEVyVRbiNueOZk6ho62wkeM4Szg0wcyiZ/iJ78L7PwICfJGreiyCyYK278PnFXuzwqfBVD2lPD0jU/gvElYKUmuW/7FyCOLauClhbezDFLAsbzpK3oX6GdadsGRRsk4OP5xLcwfE9DFlUImcsL20svWaCdgRTQMaBa7w+YYvrkOz6/nrSLyUDYuuBx8oyyfswQDi7Vz2yDY72XFXS+ts1LbgKmHQppgUJHfjY0BN3awkA2fo1Sa4bkCUBqh4eKEs8rPxvkP5A8jAARzxf/gIeixQZ+TLX2E2d6gN+tPUkUD6Ry/3O1d5nq+aOyDo9sutJg9JlUOK3JdU8UTW3qQD76Smt1ietKVFb0EHlwiKhElaP89W/TK/QSPzvBSxDq/JBZEz9cxKIGQuCBhrqTDgGBV1+XgJMkxRblkNYLsek3ynfKGHj53tnjRGaLTS48lSTkuD8PW1y4zUzB4OEhaPssTY9l4v2FehqinF83xDJAIfzx0vakbFeoKVRpHJ2Xw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(2906002)(5660300002)(31686004)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38100700002)(2616005)(66556008)(66476007)(53546011)(31696002)(8936002)(6512007)(6486002)(6506007)(83380400001)(86362001)(508600001)(316002)(6916009)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2VUU0ZyRTFIOHJXeUhvQnNyTVBuSHNPWloxYjVwVW5LMlA2cXRranZZckxn?=
	=?utf-8?B?UDlFenFybzNhclhIaWY4R3o3VzFYNHRzcEVlNi9ISjhPN3U5SGdRY2hNQm1l?=
	=?utf-8?B?a1hWdSs4dmpsa3hmVGpUQ3BTMStFOW4rUW1QcDRhL29tL1VENFF3RXN5TnRo?=
	=?utf-8?B?N2tnY3ZRUzNuRHUzN1ZSNG5jOFJUeEZhbVEwS0EwN29Wdzk5UkxWWW5PYWFo?=
	=?utf-8?B?WFE3SGhzTE00Y0o0K0VjUUdhempPNzJuTUNZN21GblZKNEVaV0lRcE54clN0?=
	=?utf-8?B?dU1FMmpUdElpblBFUXBiNHBKRU5tTlBodHRGdUZDOTZtMDhHM0hWaWZBZmk3?=
	=?utf-8?B?N1VPT0tYSTB4YjZtb1pialNGZlg3UDVJT3pINTZXODJRQkliN3owM3ZWK3dt?=
	=?utf-8?B?Z0dCd2hGVmIzQmN1aEoyVzA0VEhvdCtsMDdzK3F5cXdLWVRISjUxVVNTYXhT?=
	=?utf-8?B?bkoyMjMvOWpwOFBjZWlJSGNkSDZKbHBkNzNvVDdUMFNUZjFFZjVYeERIaWlG?=
	=?utf-8?B?RE04YTlMdStYSU1RR3EwK3NyTGlLZzRNWDB5VmFZMUsyQzdhb1hsVTdkUE5w?=
	=?utf-8?B?MWNENmZmMy9QVzZ0QWpZditQd05CL3pLMmIwNkg1alZFdWNmMGNNMC9NQ2VO?=
	=?utf-8?B?UEhxNXdkejRaTmxzMXNSYTBCQ0pHTFFSU3JpZjVGWlpLV0wrZDhCQjBwczA3?=
	=?utf-8?B?V1M1VnZXcC9vSlVyWUV2SXQzS0s5TlY3cVpha0NXT2YxNjA5bVg0cU1mY0Uz?=
	=?utf-8?B?eVFMbmhyTTB3WTRNSVdQc2pzMi8rR09ucjNodGlMQlFCd1dRb0lIVHp1N0lw?=
	=?utf-8?B?TVhHUW9wcURoZ29tcTZJR2hnbjNCcGxadTJJbHUvZGN0eFZWd1NYRjVQQ3JD?=
	=?utf-8?B?STVYVFYyWWhTNXMvUkFrNW92U2tkUFBaQTV1RWYrV3ZhVFRvbDFGQWNlZjFN?=
	=?utf-8?B?K015YkR3a1ZZNCtjcjI3Z3hoclV2aVFFK2FpOTdSeVJ2Q2VBMWJ2SXprMFp2?=
	=?utf-8?B?QjBST1oycjJSVnNaS1ltald1OEkyNGVGS3VvZHF5eExuYzNYUktaMDErSkE4?=
	=?utf-8?B?cmdWUG9tVUszb1Q5RjdhVlJDbFJ0MUgrVmpHZzJ4dm5kQW0xWUM5YklSaDNT?=
	=?utf-8?B?eXpFbWxjY1V6c1ExTUJyalkzcXR3SUxpTHNoUXpGbng4VEVIUlJzTWQxYkN1?=
	=?utf-8?B?L0E1VWp4Ui92TnlaUCtacUFhZXlrK3BCR1AvbXp1TW0rdVhjMFo0ZG44ZVlm?=
	=?utf-8?B?ZXowdk1walgyV3MybHROT2tYOGFkMmNWU1U5WWlhY3ZZbVMzeUtNZ3V4RUM5?=
	=?utf-8?B?TTVVUVV5QnNaNlRVTGxMRGRLYU5Bd25HMDJwbllFMFVpNWd5WXY3VVNRVndu?=
	=?utf-8?B?dUZxMncvamRwcjRhVitveUpjbGMyOXRYMDlmUHl1b2hYcXpkblJCaVAvTGdX?=
	=?utf-8?B?ZkhaWFpDbVdOZHdKMGUyWERqdmFNdHRNK1p6R3gwakVybUdVdUkxS1NBeEMy?=
	=?utf-8?B?cXZqSm8reTlZbmVISW01Tk93WWJxc2cyZkxydVNPRW9peHltMVV1ZnQ1ekox?=
	=?utf-8?B?MENoQ05OWkpYbld6c3JEVXR2YURRZGRreFBQRFJUVDhnUTdDNU01VDFqS2kw?=
	=?utf-8?B?d0lyMjRoR2puWU84eDlDdHpvSmkrRjhXMmdtaUtvMmFHd3hpbHNVMnZQdHFB?=
	=?utf-8?B?SGpTczdaTlZYb2xjdXRBSXlpWEZ6anNOT0xZcDZIc05KQjNiTUNCN01HbzJB?=
	=?utf-8?B?VU5KVmY1S0s2TnZJaHZ3cEtFZUhPc25VZGd2bk1hNmQ1aFhYY292eTMzYUQ1?=
	=?utf-8?B?d1dhU29qM1hENEJlLytzdWU4UWxQWjZHazJocDZjODRwMlNxbit5bHdmdUNp?=
	=?utf-8?B?bElhR0pqZC9sUjZhK3pQOHd2MnNxcS9yWHlsUWhWWTh6b1FBZHBVSjVLT1Jp?=
	=?utf-8?B?a2RHKzhFVHlwSFMvb1I4ODN5S0pYbExpcFQxRXM3UklSQ1pZTGRvbTFBUStS?=
	=?utf-8?B?cHFQeEgxSWlWUG9rNVZEVUd2dTJJMkg5ZW5qbjZtQ0M1cldONWxHOHBmSmtt?=
	=?utf-8?B?TTNWaEY1eCtWVzd0Njlic0VCay9RcWxtaFJWUTZqREdqWWFRRnFqRXU0cVJR?=
	=?utf-8?B?NHBGTXRyZVJvWUR1OFZ2WjdDUjJDVytCVHBMN2NKYTlUSjNxU2RuWjA4Yng3?=
	=?utf-8?B?QmhPSDk0Q0R6MnNvMnQra21GK3BTcEVuenRMYVgreklBaFIyVXlSRkxIRmVZ?=
	=?utf-8?B?ZmpGYmc5TGkwRjVTS04zL1ptTjhBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfda1d5d-68a3-43b1-6380-08d9f97bb981
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:00:04.0694 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcczFeDn/5caNcbo5g96YrTQgiXybFqSfoV9F7Kimqb8UybT1GBOoiW9Xp/DyTfR9IPnVgJJqoVOw8zXcr/PDcSDFKI5qoElpnDSXlSyNic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270
	signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	mlxscore=0 phishscore=0
	bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202260163
X-Proofpoint-GUID: UIMzvDhPgAf6XmvM-jFjmk50IszIShCL
X-Proofpoint-ORIG-GUID: UIMzvDhPgAf6XmvM-jFjmk50IszIShCL
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Feb 2022 01:25:13 -0500
Cc: dm-devel@redhat.com, open-iscsi <open-iscsi@googlegroups.com>,
	leech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] Question about iscsi session block
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/15/22 8:19 PM, michael.christie@oracle.com wrote:
> On 2/15/22 7:28 PM, Zhengyuan Liu wrote:
>> On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
>> <michael.christie@oracle.com> wrote:
>>>
>>> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
>>>> Hi, all
>>>>
>>>> We have an online server which uses multipath + iscsi to attach storage
>>>> from Storage Server. There are two NICs on the server and for each it
>>>> carries about 20 iscsi sessions and for each session it includes about 50
>>>>  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
>>>>  on the server). The problem is: once a NIC gets faulted, it will take too long
>>>> (nearly 80s) for multipath to switch to another good NIC link, because it
>>>> needs to block all iscsi devices over that faulted NIC firstly. The callstack is
>>>>  shown below:
>>>>
>>>>     void iscsi_block_session(struct iscsi_cls_session *session)
>>>>     {
>>>>         queue_work(iscsi_eh_timer_workq, &session->block_work);
>>>>     }
>>>>
>>>>  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
>>>>   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
>>>>  blk_mq_quiesce_queue()>synchronize_rcu()
>>>>
>>>> For all sessions and all devices, it was processed sequentially, and we have
>>>> traced that for each synchronize_rcu() call it takes about 80ms, so
>>>> the total cost
>>>> is about 80s (80ms * 20 * 50). It's so long that the application can't
>>>> tolerate and
>>>> may interrupt service.
>>>>
>>>> So my question is that can we optimize the procedure to reduce the time cost on
>>>> blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
>>>> workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
>>>
>>> We need a patch, so the unblock call waits/cancels/flushes the block call or
>>> they could be running in parallel.
>>>
>>> I'll send a patchset later today so you can test it.
>>
>> I'm glad to test once you push the patchset.
>>
>> Thank you, Mike.
> 
> I forgot I did this recently :)
> 
> commit 7ce9fc5ecde0d8bd64c29baee6c5e3ce7074ec9a
> Author: Mike Christie <michael.christie@oracle.com>
> Date:   Tue May 25 13:18:09 2021 -0500
> 
>     scsi: iscsi: Flush block work before unblock
>     
>     We set the max_active iSCSI EH works to 1, so all work is going to execute
>     in order by default. However, userspace can now override this in sysfs. If
>     max_active > 1, we can end up with the block_work on CPU1 and
>     iscsi_unblock_session running the unblock_work on CPU2 and the session and
>     target/device state will end up out of sync with each other.
>     
>     This adds a flush of the block_work in iscsi_unblock_session.
> 
> 
> It was merged in 5.14.

Hey, I found one more bug when max_active > 1. While fixing it I decided to just
fix this so we can do the sessions recoveries in parallel and the user doesn't have
to worry about setting max_active.

I'll send a patchset and cc you.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

