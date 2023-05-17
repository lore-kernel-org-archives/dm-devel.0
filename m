Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAECC7EE24
	for <dm-devel@archiver.kernel.org>; Thu, 18 May 2023 06:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684392021;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xi6Qw6PGEUV1/sGKzMGrMZGhkduep76n39X+NxCWAGw=;
	b=SbE1WPhX91sBgqymn7UoDVD7Qrg+PfuXbLi7/iXEcd7NavI6rS8mLx2u5GmnCuOf7R3Jyj
	2Jd2Q/lDqWTpWSyF+QNgJvWbp9V1dZMLonM27lMik7kXFa/b6PZF34LPawm/9jaqe191TA
	yFY31f+5jtllOw76V/hprSBCqXxmBOk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-vQZbi8mgP8yj-pR8SS3NTQ-1; Thu, 18 May 2023 02:40:19 -0400
X-MC-Unique: vQZbi8mgP8yj-pR8SS3NTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B46913828884;
	Thu, 18 May 2023 06:40:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B60BD2166B31;
	Thu, 18 May 2023 06:40:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 976A919465A8;
	Thu, 18 May 2023 06:40:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C8F119465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 17 May 2023 18:16:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BFFF492B01; Wed, 17 May 2023 18:16:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0353D492B00
 for <dm-devel@redhat.com>; Wed, 17 May 2023 18:16:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7E192A5955C
 for <dm-devel@redhat.com>; Wed, 17 May 2023 18:16:26 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-ePotoddpPAydqwvq3LRXPA-1; Wed, 17 May 2023 14:16:22 -0400
X-MC-Unique: ePotoddpPAydqwvq3LRXPA-1
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 34HE4CHA032044; Wed, 17 May 2023 17:02:28 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2kdpen6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 17 May 2023 17:02:27 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 34HFQi1Q033852; Wed, 17 May 2023 17:02:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3qj10669j3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 17 May 2023 17:02:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7486.namprd10.prod.outlook.com (2603:10b6:208:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 17:02:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%7]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 17:02:22 +0000
Message-ID: <4c338833-5fb7-5031-ceac-2d735b70c212@oracle.com>
Date: Wed, 17 May 2023 18:02:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Mike Snitzer <snitzer@kernel.org>
References: <20230503183821.1473305-1-john.g.garry@oracle.com>
 <20230503183821.1473305-2-john.g.garry@oracle.com>
 <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
X-ClientProxiedBy: AM3PR07CA0140.eurprd07.prod.outlook.com
 (2603:10a6:207:8::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e97a17-e201-479d-613d-08db56f87b20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kZACmKChk/4QEhaPZLmoYIz/Fqek0kYQxwHy8l6UiwYaKAXETX1Wg1ir/yfIhxLoAxNpY3XUyk5Dn48uLZOKOgaRIHqf1ZynVgpKOcYsKsclXLLzDwhw2Y9EUhxWe+HozU1smJ+g+CUyBtq88VPXsDc8/7Ig0d7MmAI+dwlEYJn5e3d0L5UWMbpwMQdKx92PXKdUwMU/XLH4yq2cHULP+IgYd9GzcLchzQeG/N5EgeZWtuLf97ozWTtDXniykD5rR5A1jSNJWrhijhWhNUnpF6sQBQwYr9O/3o1qbg3ohK2ENy2iiZIJD+HOf7lOupk5ULW174ERnyF0L6YIl99qXZnHnKLwY4P3kgM65Cx7rNJ9mzUQKiyeZ2ZC9MguxMFDns5bsYsGqJrFM54WGozPykm8reU28u4SOe4U4XrJ4yTC5TftTGGMZUrZoTfwXmbanXnsDZTP9sEhy8iUN7pYvBSrdG5ERfT9Xe0YGoQP2WauDKChAAr1i92PVJK8rzv9Cu2e7SkdJLvObN86VtaPNZc7HtE2jIlNZcZOMCsArMbDhXvtZkGwILr4x/YMY9JWKlaB/hWUxbBUjNbJczO0Pf1YuO4NtksV2ZpY8YhCt6cZbS4eMx1l+CLISRCpAD1Bw5XmI9RxvmBHn2VpGlUwWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR10MB4313.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199021)(31686004)(36916002)(6916009)(66556008)(66946007)(66476007)(6486002)(316002)(4326008)(36756003)(478600001)(6512007)(53546011)(6666004)(6506007)(2616005)(26005)(186003)(41300700001)(83380400001)(5660300002)(8676002)(86362001)(7416002)(2906002)(31696002)(8936002)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWhPZ1ZTbC9QcnY2YitYYmdpMndyd1hQSTRuTStTYngvMCtQeTVVakNhT01Z?=
 =?utf-8?B?aVpVWitobUVjUi83SWRLWkU4RmtXMTFpZWpzVmdwMGpDRVFLTVd2R3FSZTBV?=
 =?utf-8?B?VUVJZURZOGlwUDlJZ1M3L2tONVBIbTE5c3B1bnpEa2ZLZWtlUjkyVG12RUpF?=
 =?utf-8?B?WVluUFBWSU9DZFVoZGVGZkdBdFZ2aHpnTDlOeGhRaFc2a3RGYnc5bksyaVVy?=
 =?utf-8?B?NDE2aC9VdTJRN0lLL2x6ejUyaXBGVDI5Tm9QZEJWNEJhZTFhTndIQmhSWEZ6?=
 =?utf-8?B?MlN5UktrSEtMMVNtcWhkejk0WHN2NkZTSXZDOE9hRk5aN3pEVEt4dG9KSzZC?=
 =?utf-8?B?aHU5VzB5Wi8yMTlUU2p0bGIrekVZNktaT3lxNEpmOXdsZXFRS3N6eXFEcGFV?=
 =?utf-8?B?cHhpd0VsUDB6QlVLcm5BMFZOT0YydkwwRDVucnV2TThUTDhoWS9Dak1FQnhW?=
 =?utf-8?B?NSs0VTI4bzRXdmF5QjM2bFFFWWZsZ0Flc0p5Z2ZRaHFKckZ4NGpxKzZodHRN?=
 =?utf-8?B?eFI5czdFZlpHUThzaCtRWlF1dHIxV1R2RTk4aklvM3ZEL1NrNnZGS3FGOGZt?=
 =?utf-8?B?cEVuVzI4QnNCT0JQTjBpaDJ5aFlDRjd5WjlZMndBOHpOTms4eTR1cGU0bEhX?=
 =?utf-8?B?K0hnd3lXVzZTenlaU1kwVVhTeUNtZkU5M2cxY0tFbGhZdU9zcW1uZjdWT1RD?=
 =?utf-8?B?SVlsWVNWOEJqaEs1THd2TnFxU0FGbzMrdEszQTFLY2p6SnYrYXNZR3VWY0ho?=
 =?utf-8?B?R3dYekJRWHJjdURHcFRQWHUwR2g2RHczLzdyeFFrOCs0SHNNRWs5Y2FOZ2RV?=
 =?utf-8?B?WDJNVk93VkY0Nml0THR1R3Z2T1cvc2RJR0o1S2pkQzB4TzdQQ28rVyt5a1dO?=
 =?utf-8?B?MTA4YVVZRVdJejZtZnBtZ2VDc0dLdFBlRDk2WlpFUXEwelVVNkpnelByT2xi?=
 =?utf-8?B?Y0pRZWhDOS95YlltSzNQdXRpcHRlSzVLU2ZPMHBnOUMvUnI4UXZpOTZPK3hz?=
 =?utf-8?B?Qno0bEtXNUI5VmY4RE9hT21uZGhLeWRneVJIbXBSbTJKcjhQdUdJcUZ2K0pS?=
 =?utf-8?B?Z0xBNjY2aWI5S3FiTjlYc0hTVWY0NE83OGdwMzhGM0M1Q1kvblNKOGkvcUUx?=
 =?utf-8?B?S3VpVUZnODJnS09yMmdKR250b3JnV3VVclp1N3JUcXNnZHduSllidURKWkFR?=
 =?utf-8?B?M1BsSEVKRy9kenFPRFFDMTlxYW1ucEhVbnpmd2UzWFpGcVZ4b1pacWxxM0cv?=
 =?utf-8?B?SzVPRjd3UHE0OFN1UHZmMlVvN1lmcWNPd1J1V1M4R1c4SS9ybHhXZDlSRTU5?=
 =?utf-8?B?ODRBNWlhQUx6Sy84QVlmaG54YXU3TCt4RCs1OVQwTStRZWRQdFd4eCttZXNT?=
 =?utf-8?B?OTFIR083dVhXSzFkc1NWdlpya2pPTlE3dTVaK3d6aEp1MFFzTGc3VlhzNFJR?=
 =?utf-8?B?U3B3RnNST0Fxa0drTEwwK2xTcDRqYVdxbVI4QmdmQnBhQWVCMWJKcEVuZ3Bi?=
 =?utf-8?B?T0dLbGNZeUVQM3ZhYzNHY2ZFMjU2b05qWGRyVlM1TU8xT1lWbHZLcmc0VE1t?=
 =?utf-8?B?bklRNlN4Qkttb245TldzajdsbEtRcFJpdFlkVHF4Q0dLL0h0MDB2UlVnTmtE?=
 =?utf-8?B?d0JXMlJkTnB4R2h2TE50V1E1cmxjcE9XMXc4bUNaL3M2MGJlTTFQakFhTUZR?=
 =?utf-8?B?MU1nQ2o4QURkbVVSZ0EzK2FOSmFzcWRKSG1kQUN3NDBWVHdrdFRMWUF1NzVq?=
 =?utf-8?B?dWYyYlE4TC9PM0U5Z3NGV2xSNDBaUzFZYk90UG4zQllVazFRWVp2bml6dyt1?=
 =?utf-8?B?ZDk1aGxTVlhtYlBzdDlyaFhHYlR3L2puTXBVSDVka0dZdmZSTGk3bXNveGNI?=
 =?utf-8?B?Mm90RGM1eEMrRDRJaDk2aFFqOVlraVVMNTAzOTBPdDJnNG9LaVlGZzV6RW5z?=
 =?utf-8?B?WHJ4MmFSVkwwSEdXTEU2ZXQ0V0JqN21FMm51SnR4RkJwOFk5bWpnNGUvdEMv?=
 =?utf-8?B?aXJmSWlLRTF5b2pldTdGSGdJN1k2L1NOckxmYUpvOWRIcnViQWliR2Q3Y2Vm?=
 =?utf-8?B?NVg1ZThrejRrMjk4ZVVqaHRQYzkvYWhvTG83YldhazlOdytZVVBCb3gvOEJh?=
 =?utf-8?B?OW41VkgzamV1bng2cEVlK3lPYjlnRUlEVW9Ub0JyTVY5T041dWUyMGR4VnQx?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dGUwcTUyd3ZPeWFOUjYySzNJa2VzNU9VM09KdGFZVG5URFJvM3JBVjlBSVBE?=
 =?utf-8?B?SDR5MlpZeGVYaUF6SElvUk5KZWFubU5NcXVVUmZuSG5rZlBYaWpkS3dpRFR3?=
 =?utf-8?B?U0tyNXBWNnhkK0xxQy9XWm5PN0M4eTdsTkJMWldVNHFSY0MvU0pXRFJDMmZD?=
 =?utf-8?B?c2xXR3lYZEpzM09td1R4eGhEejlSYk5Lb2t6bmZZSlNxb1FJWGdvTGUxbzdk?=
 =?utf-8?B?VVBpK1YrUS9lTVJoZFhnR09US2hLeGpMQnk3Rm5uN0Zjck4zK0lJUmVGYi9k?=
 =?utf-8?B?RnNoNzJYcE44MVdxOVQ5d25MYzM1SmtreXhGdUszMkN5S1hyOHdQSmZscUdE?=
 =?utf-8?B?Q3dMV1BXOHJRSmVuVmMwYU9aNndhT09lVWZDY0htYlFlS3UvaE13MzNRbGR2?=
 =?utf-8?B?dmEvSnJhREJ1bzdicDM4eFJ4RVlwMjlYOU01L2Q5ZDg2UjdzaGU5eHppREY5?=
 =?utf-8?B?N3kvQmZ5Ky9HditEYmpQRG5sck0vYVhPZTRmRmwxcStyOW9OWGpkZGVrcURZ?=
 =?utf-8?B?cWZjVjE1RzltMVhzOHpXRzdZeEEvL3J4dWozS2FiS2cyNHhOWklGUG5HREpV?=
 =?utf-8?B?SlJJaGRlTmhyNFZUakoralBmZTFMOHUrTWNqMmduRlVKRVFkYWptNlBoZUp4?=
 =?utf-8?B?Rm5NelpCdEdOc0xFZUdUamRUUHpUZUpGWXZYcDFLZTE3c3hKeFVvcXBUYnZE?=
 =?utf-8?B?VXdkY3cwQnJySEN4ZnFMMDNYRWxlOS9xYWNlWGZRVENOU1NQNE5aWk5zS3Y1?=
 =?utf-8?B?WVBIU3A1Z1Y5Q2Q4eFM4Nytyc2FaeVRTOHRQM1QyTmdQeHdMZTBqdkk1OE9V?=
 =?utf-8?B?empvQTJGOCtSaE5Mb01TTzFJM1RaYXdKZmFOTFpZTWFueUlJaWVnbGxHTWw2?=
 =?utf-8?B?M3I4OCs5dWtiK0VNaVNuSTY4YVAwcXJJcWFEL1ZBa1UxUVJSR0YyYklHalJV?=
 =?utf-8?B?d3RpQUNLbFpBeGF0UFRFOXNwL1R3eUd2RzFZM3d1cW81WjB3TDRGMXh2bDYv?=
 =?utf-8?B?dEZ0d3dCZk13dU5FZmh6ZEdwODRhZjVsZk5RK1lPUy9EQlM0bGxjRTNUWDhu?=
 =?utf-8?B?bWN2Q2VjNUh0cjNyOHV2N0VWUWtKc3ZLcGpzQURqZzlQNElmQ2NGMXBkcStS?=
 =?utf-8?B?b2ZQVCtoVE94akpKYTdNNm96WUsyZUdwTEtsMDQvRGUzdVVMdG1WR2hZSWV3?=
 =?utf-8?B?MFVjbXI2empWV0lVcGZYcjh2UEJEck8yYWNIaTEyZjVKVWVyWXZYejJlZDUw?=
 =?utf-8?B?ZFZBUlIwRm9PL0gydUtnZ0x1TFBGZW50NEozZ2ppMUhIcmRieUxBSi9VVk1O?=
 =?utf-8?B?Y0lTYkk2SDIraEV4OGlZNkZPVkFFdkVwT2Z4V2x6cHdPS09Ocm1WWGc1akoz?=
 =?utf-8?B?REczZU43dEh1cytjczRsRFh5bGxuYlFhV2NUQy9odnVGaG1heDMxd2l2N0ZE?=
 =?utf-8?B?UTVHRFpuUE1UUjh5QzY4Um9nV0pnOFNEZGJJTjlSL1U3dG15TUtkYWtKclRs?=
 =?utf-8?Q?elDxYfJpLNsr7uRgz4szkmiaYIU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e97a17-e201-479d-613d-08db56f87b20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 17:02:22.3953 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPmtLtDMZ30ri+vJzWnCdba3MQTn55QuK2rS6YX0rptQ8OvTsXdZNi6TDWY+/U6aAPqt7/+dbJ6sg9pKZRzZWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170139
X-Proofpoint-GUID: yF1CEABBuUjnmwifmjd4Gpyk5cxBqfTZ
X-Proofpoint-ORIG-GUID: yF1CEABBuUjnmwifmjd4Gpyk5cxBqfTZ
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 34HE4CHA032044
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 18 May 2023 06:40:13 +0000
Subject: Re: [dm-devel] [PATCH RFC 01/16] block: Add atomic write operations
 to request_queue limits
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
Cc: djwong@kernel.org, Himanshu Madhani <himanshu.madhani@oracle.com>,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 sagi@grimberg.me, linux-scsi@vger.kernel.org, jmorris@namei.org,
 serge@hallyn.com, jejb@linux.ibm.com, linux-block@vger.kernel.org,
 viro@zeniv.linux.org.uk, dchinner@redhat.com, kbusch@kernel.org,
 paul@paul-moore.com, axboe@kernel.dk, brauner@kernel.org,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDkvMDUvMjAyMyAwMToxOSwgTWlrZSBTbml0emVyIHdyb3RlOgo+IE9uIFdlZCwgTWF5IDMs
IDIwMjMgYXQgMjo0MOKAr1BNIEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPiB3
cm90ZToKPj4KPj4gRnJvbTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFj
bGUuY29tPgo+Pgo+PiBBZGQgdGhlIGZvbGxvd2luZyBsaW1pdHM6Cj4+IC0gYXRvbWljX3dyaXRl
X2JvdW5kYXJ5Cj4+IC0gYXRvbWljX3dyaXRlX21heF9ieXRlcwo+PiAtIGF0b21pY193cml0ZV91
bml0X21heAo+PiAtIGF0b21pY193cml0ZV91bml0X21pbgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBI
aW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+Cj4+IFNpZ25lZC1v
ZmYtYnk6IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPgo+PiAtLS0KPj4gICBE
b2N1bWVudGF0aW9uL0FCSS9zdGFibGUvc3lzZnMtYmxvY2sgfCA0MiArKysrKysrKysrKysrKysr
KysrKysKPj4gICBibG9jay9ibGstc2V0dGluZ3MuYyAgICAgICAgICAgICAgICAgfCA1NiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrCj4+ICAgYmxvY2svYmxrLXN5c2ZzLmMgICAgICAgICAg
ICAgICAgICAgIHwgMzMgKysrKysrKysrKysrKysrKwo+PiAgIGluY2x1ZGUvbGludXgvYmxrZGV2
LmggICAgICAgICAgICAgICB8IDIzICsrKysrKysrKysrKwo+PiAgIDQgZmlsZXMgY2hhbmdlZCwg
MTU0IGluc2VydGlvbnMoKykKPj4KPiAKPiAuLi4KPiAKPj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Js
ay1zZXR0aW5ncy5jIGIvYmxvY2svYmxrLXNldHRpbmdzLmMKPj4gaW5kZXggODk2YjQ2NTRhYjAw
Li5lMjE3MzE3MTVhMTIgMTAwNjQ0Cj4+IC0tLSBhL2Jsb2NrL2Jsay1zZXR0aW5ncy5jCj4+ICsr
KyBiL2Jsb2NrL2Jsay1zZXR0aW5ncy5jCj4+IEBAIC01OSw2ICs1OSw5IEBAIHZvaWQgYmxrX3Nl
dF9kZWZhdWx0X2xpbWl0cyhzdHJ1Y3QgcXVldWVfbGltaXRzICpsaW0pCj4+ICAgICAgICAgIGxp
bS0+em9uZWQgPSBCTEtfWk9ORURfTk9ORTsKPj4gICAgICAgICAgbGltLT56b25lX3dyaXRlX2dy
YW51bGFyaXR5ID0gMDsKPj4gICAgICAgICAgbGltLT5kbWFfYWxpZ25tZW50ID0gNTExOwo+PiAr
ICAgICAgIGxpbS0+YXRvbWljX3dyaXRlX3VuaXRfbWluID0gbGltLT5hdG9taWNfd3JpdGVfdW5p
dF9tYXggPSAxOwo+PiArICAgICAgIGxpbS0+YXRvbWljX3dyaXRlX21heF9ieXRlcyA9IDUxMjsK
Pj4gKyAgICAgICBsaW0tPmF0b21pY193cml0ZV9ib3VuZGFyeSA9IDA7Cj4+ICAgfQo+IAo+IE5v
dCBzZWVpbmcgcmVxdWlyZWQgY2hhbmdlcyB0byBibGtfc2V0X3N0YWNraW5nX2xpbWl0cygpIG5v
ciBibGtfc3RhY2tfbGltaXRzKCkuCj4gCj4gU29ycnkgdG8gcmVtaW5kIHlvdSBvZiBETSBhbmQg
TUQgbGltaXRzIHN0YWNraW5nIHJlcXVpcmVtZW50cy4gOykKPiAKCkhpIE1pa2UsCgpTb3JyeSBm
b3IgdGhlIHNsb3cgcmVzcG9uc2UuCgpUaGUgaWRlYSBpcyB0aGF0IGluaXRpYWxseSB3ZSB3b3Vs
ZCBub3QgYmUgYWRkaW5nIHN0YWNrZWQgZGV2aWNlIApzdXBwb3J0LCBzbyB3ZSBjYW4gbGVhdmUg
YXRvbWljIGRlZmF1bHRzIGFzIG1pbiB1bml0IHdlIGFsd2F5cyBjb25zaWRlciAKYXRvbWljLCBp
LmUuIGxvZ2ljYWwgYmxvY2sgc2l6ZS9maXhlZCA1MTJCIHNlY3RvciBzaXplLgoKVGhhbmtzLApK
b2huCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

