Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC750C43334
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jul 2022 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658336629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mTNdk1UweFwzcLCnCbZHCWAo0DqBAtlwCsbAc5EXnAQ=;
	b=Gsm2UhDSfxmoEcNX7mq184kPzzKJMOdzGbRfkWmGVKNNCGXLPD6NazpsdiqiJjMGTL0Gwo
	LpROY2j4+8k7bcmqvRFmCA5YfqvNch+mRBNuCbf8I0DoNFbqqBk31s4RlsWGsySNtguTX3
	4HZpgc3V+vuZF8TRIcRCX+RZWzpM4JM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-kSREOevLOh-V9mmS1BHG1g-1; Wed, 20 Jul 2022 13:03:46 -0400
X-MC-Unique: kSREOevLOh-V9mmS1BHG1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F06A53C11E65;
	Wed, 20 Jul 2022 17:03:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7BDC2811A;
	Wed, 20 Jul 2022 17:03:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 546A8194706C;
	Wed, 20 Jul 2022 17:03:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4CC21947066
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Jul 2022 17:02:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E2FF1121314; Wed, 20 Jul 2022 17:02:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 892381121315
 for <dm-devel@redhat.com>; Wed, 20 Jul 2022 17:02:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17BEA89C96B
 for <dm-devel@redhat.com>; Wed, 20 Jul 2022 17:02:22 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-QOWH4HzuPM6f6vyYBlqg2g-1; Wed, 20 Jul 2022 13:02:18 -0400
X-MC-Unique: QOWH4HzuPM6f6vyYBlqg2g-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KGd4JI003953;
 Wed, 20 Jul 2022 17:02:06 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx128u8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Jul 2022 17:02:05 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26KEr9kY016466; Wed, 20 Jul 2022 17:02:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1ennbwb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Jul 2022 17:02:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 17:02:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.025; Wed, 20 Jul 2022
 17:02:02 +0000
Message-ID: <29afdf97-a0a3-4299-e542-9baf7598cb87@oracle.com>
Date: Wed, 20 Jul 2022 12:02:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
To: Christoph Hellwig <hch@infradead.org>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
 <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
 <YtT1uTW04BC38NSK@infradead.org>
 <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
 <YtedpBxV3Y/b33Sx@infradead.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YtedpBxV3Y/b33Sx@infradead.org>
X-ClientProxiedBy: CH0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:610:b3::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d5aaa2f-3226-4bb1-d673-08da6a719126
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Fho0mYrfIL1fhPQrw8FWJJ6BUC/o40lw5/6LRsrDMzNRMzbuXCLhuhmNJLiwMvUi+baXH+LnymjPBm/9UyAxcTs1HPj9ZlkjhukuIOeC+VLLyHw3JkUIBFKiZIkfJF6zaYqLF7LH/zbjioqn3/CpNV5NBMjd4MIjfa3ChbpjD2D5sNTv8t6yBVWKbf686cEeMu1N7nMOYt+VklkvRGRxlsduYVuaXGvvyi2IdQHWhXkQhfef+RnhYPkayblRfuZeqTHNtJBXb7VzbHVVNkEQQu1T1NhapO+cxSthtQ6tdUuONeAOXDjx1gIdcoVWY9lhB/aEfwZMPf4S7+DaakbWszOT6maPtboHZ3OOe0HRoqnoZRa3wDeRX5q3mPbYrhKbOSJoeNf+95t6uHrnmEP2a9PyxcdxlFT5iQ2MUT4nosxfwf6VBGJDAlkOb9BBxH4F/EyjT/iEyyrDXHA0DwBwKPRdz3co18okkVxZdlmHbcIN047OgScbOPmmVQH4hbcyo3tIRXfn7DODrlJb8Jj1kIQkcEdwwCCUJodHripqyGPu3jkPDutyQ1infKJu381ge2TINo1tssgo1zrzYN/lQvtOwj8F3Wi0ekcmeno6Br65askAYyAKJ2SWBkpMTkUkP+Cwb91IXQjG/wQ2zd5dkHDKlLTPh1gIR44fJgZC60giFCgfkQEVtnvTkCWaWr1JrVfYbA5vkYHetkp70M6NFXVRo6hXeR7+CbKSS0KpR/QWTKNorNaRm2Ve93YSKyswVwOjRJxNlkqHQQkkRKFdyntaia/Guii6Km7bI4PMJJGY3ssZAbrwc1y+RMe5Tz4luKKLw5SW2ZH7HJFtYMBnBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(376002)(136003)(39860400002)(366004)(396003)(8936002)(38100700002)(66476007)(66946007)(8676002)(4326008)(66556008)(36756003)(53546011)(31696002)(6916009)(2906002)(41300700001)(26005)(316002)(31686004)(6506007)(2616005)(478600001)(186003)(5660300002)(83380400001)(86362001)(6512007)(6486002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1BxWlN5ZThRQXhaZTMrTVlDY3hFN2h1VjFGNUEyQTFNOFRzS045aVNydXYy?=
 =?utf-8?B?Zmc2dTdSUmdjYmIrVU9mM2JBb0ErL0pOTFg4RG44WnhBelNrVVBubmNmRGY5?=
 =?utf-8?B?bElpcjlLcmpUWmxaaWJ3SXlsU0NsSGd5alk1UnNRNStNWEdxcnROWXVpU0xU?=
 =?utf-8?B?Z0g4azFMWDl5NE9TcHNxc3YyVnF6dG9HTXZFNlNaWHl1RnBDMDlKWWdMNWEx?=
 =?utf-8?B?M1JCUyt3UVdnRDgwallZRlNyR1Yvb2dDRENrRDQvZzh3aU43eXRpUkZXNzVz?=
 =?utf-8?B?SVNQTGRuMnVMbVF4aVIyaEtnNXJRQVF4UW42Mmw1dytUdDdIWGNxRGR0MjlD?=
 =?utf-8?B?bzZieG1nWHdoK0RGWjJmWlhZM2FRM3pmU3F0aTUzcFg0MzVGSGhZc0tmdVdo?=
 =?utf-8?B?NEVod09rL1c3R2pZSGdESld5bm5OcE54SlBvOXRyYVFBVlAyNU9Kd2wrUG1K?=
 =?utf-8?B?dnAwWEtSREtwNUdMZ00xMVhueXVURVNwVXlrL2VGTlgveGNXbS9MaDJoM0dX?=
 =?utf-8?B?YkZvV0F2WkZ6Wk5CVFM5ODQ1SXBHSThwejNlOXU5am5JNGJIaW4yMTlXMGw3?=
 =?utf-8?B?UTV1eTNuenVOS0xtR0FoL0NVRmRpbGR4TUJzOTdybWx0YXZ6em5DRFpvekhq?=
 =?utf-8?B?UGlWVjQ3dlMwZ2FVVGJiMERVUnB3eUhBdzhOTC9ac1NUYnIvb0xJSkJRQWEr?=
 =?utf-8?B?emRqOTNZWXlWSFd5ODhSWUVmNG16Z3ZQZ1hKc01TQ1RqQUhZbGNrQXdpbU1a?=
 =?utf-8?B?a1hDVmVwN1NoNUVtaWlpM2pWNG9BY3dYZUNtRGhRUmRBQWsxQk85bXo0dS9R?=
 =?utf-8?B?ejdSYjgwY3RpOXkra0RpSElvTzBZR1Q5aWh2Qkg5b2tjeVVqWCs1QWxMaHp4?=
 =?utf-8?B?S3hmcXRtZXRvRGFaaDdoMU9kNUJ2ZU5kK2JGQWVDVVdDU2lkT2pHVDkvN1R5?=
 =?utf-8?B?WjJCRnIydnBjc3hpMTE5dWdwR0ZPZ090S2ZubmpmU3plN05XdWwxc0VHZjF0?=
 =?utf-8?B?bFZZQldiYU1FbU1EWTVtNVlnekprb1JJZVdTWHpIZ0hMTFY2eit4b0NxeU15?=
 =?utf-8?B?cmlSU1U0OHIrY3FxbFFsRWJyTyt1MGZIRis2OFhjOG5keTNySU1Qd3BJNUIr?=
 =?utf-8?B?WEZuV0FRREdpaSs3U0RVR3NWUmFSQm43Rmp1Wk5VU2wxRitIQnBlVnppcHQ2?=
 =?utf-8?B?YnpFd25xbS94MnhYZzFzYVc0bXFVek9TdmRYOHoyRjZ4OVFEWjNIbnIvd0N1?=
 =?utf-8?B?c2YrVXh6RE1TZm9EczZlVGxmNUZIM3U3aUhiRlAxV2pKWEVBd29RVzRDdllt?=
 =?utf-8?B?V2NiSWVuRzFCSkd3b1UwYmZyazhNeDd1V1V5N2IwbCs5OGo3bXlpeEwvNE40?=
 =?utf-8?B?YldKSG5BTFlDQU1BR0lhc2MrbFM5WVJCc2pmbmthMitwNDFUcWsrYTZ3Vlds?=
 =?utf-8?B?ZW03NGFoeTVLSFllNVNCeTN6R1pZWXJ3MGswL1hhcCtKQ0VSL3EvclloMlBT?=
 =?utf-8?B?Wlk3U3lPMjNzQWxjcnFlWXBxSENVemg3YmU3cFlWM3h6VE9ncHp5QUVmZXND?=
 =?utf-8?B?MngyaEhXWkJIQ0hCUnJ0cWRDamZvbk81T1JQL2s0bXMrWnh1LzIyb1dwTWI3?=
 =?utf-8?B?d0FCRm1lTEsrSEM5dDZWZ1FiQ3lGeWVtV0ZxYUdEUStlNW9uRHNCSnR6MkZO?=
 =?utf-8?B?VVBmS21YWUpRbEJuRDZ5L1E5U1FPZVlkR0xWVHUwU28xcnpqcFBOTWVkK2U3?=
 =?utf-8?B?am5pN0t3RVpPdGJPYU0weTVhTDZHc1VpeWF4ZXNjWVNKUmVQV2xSTCtSR2ll?=
 =?utf-8?B?OTJqV3o5WHVGZng2SEN1VmFTQTRKVXFCNDhUeHF3WFhqMUZrejRCMlpkcHBN?=
 =?utf-8?B?WDdoQitvOU4wKzVLYmt6WmhFTmdnWHhyVUxHcUttejJkWm4zTGJJUFhLeEdz?=
 =?utf-8?B?WlRQcTJZRlRncFB3Z1dzL0NZZm1xR2JualpWUUN1cisyY052VlRvTlRpUGFo?=
 =?utf-8?B?U3J1eHgxSU1CVWlacEZxb3JlY0xJTjJQUUpnSG1BVUZmQjQ2K3djYmlOMEZa?=
 =?utf-8?B?U3BHc2EwaXNLN1pCRzFlQ2M3SEIwb1VMSTFNZUdFOE85WDdubEc4cDQ5d2dL?=
 =?utf-8?B?c1VCZmJyZ2RmbHZnVDRiTTBmRlZmdlQ2VHI4dFdMK0FEZGRZS2hvYjV5N3Nw?=
 =?utf-8?B?QUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5aaa2f-3226-4bb1-d673-08da6a719126
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 17:02:02.7311 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tVdGL+lVi46rtCz+RJfjT2aPzPByDj+gLd3P9L1s7D1oRlsMfStuAOZm1dp3Ou776Iq2A0oRDV8iTGWr67SYejJX+/M44nN2IhLIBIoI7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_10,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 mlxlogscore=981
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200069
X-Proofpoint-GUID: FQrsFrEllL6Pijq4g8XqJSW6tyzds6_y
X-Proofpoint-ORIG-GUID: FQrsFrEllL6Pijq4g8XqJSW6tyzds6_y
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

On 7/20/22 1:16 AM, Christoph Hellwig wrote:
> On Mon, Jul 18, 2022 at 12:39:12PM -0500, Mike Christie wrote:
>> 1. Let's say you do an active-active setup with 2 paths in one priority group,
>> and the Write Exclusive or Exclusive Access reservation went down pathA so it's
>> the holder. When the app does IO to /dev/dm-0 the path selectors aren't PGR aware
>> so IO can go down any path. For Write Exclusive, when WRITEs go down pathB they
>> get failed with reservation conflicts (sbc4r22 table 13). So this type of
>> reservation and active-active would only be useful for read-only work loads.
>>
>> For Exclusive Access READ/WRITEs can only go down pathA ok. If they go down
>> PathB we will get reservation conflicts. So it's really useless in an active-
>> active setup.
> 
> It's not useless.  It just needs all paths to be registered.

I don't think that's correct. I think you misunderstood me or I misunderstood
table 13 in sbc4r22.

For just "Exclusive Access", even if the path is registered the table says
to fail commands with a reservation conflict if the path is not the reservation
holder. So there is no way to use active-active with more than 1 path, or every
time the path selector switches paths to the non holding path you get IO errors.

For "Exclusive Access All Registrants" or "Exclusive Access Registrants Only"
I agree you are correct, and all registered paths can execute IO ok.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

