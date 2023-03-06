Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64941C678D4
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678174904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8h4nMtbRMmTuppyaQ1k5Fy+/vqcqYy6ToWmXYNygggM=;
	b=XeIXnKxyAbgFc2CdbxFRSRDpZDdG+UfcwpW3o9ozICdXWjCKjuPBc8+TnWIM1rcigdJyfp
	PY589J4uNWdP2YQWPnKyzDsHPFDmU5VeLU8JUmjJ9zmlH9TS/+sY29maZtWQeabbSZtKXp
	Z0XqeCm/7OVMTNsi9eXGv36XSkev+bc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-7C4pwN3sPAahSxi8xsspjw-1; Tue, 07 Mar 2023 02:41:41 -0500
X-MC-Unique: 7C4pwN3sPAahSxi8xsspjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A19F9101A521;
	Tue,  7 Mar 2023 07:41:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 182252166B26;
	Tue,  7 Mar 2023 07:41:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9EFAE19465A8;
	Tue,  7 Mar 2023 07:41:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12E17194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 17:25:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ECC9A14171C4; Mon,  6 Mar 2023 17:25:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3E4614171C3
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 17:25:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C33B43C6986E
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 17:25:58 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-roq2Xk4YN1WLALiM13ySvw-1; Mon, 06 Mar 2023 12:25:56 -0500
X-MC-Unique: roq2Xk4YN1WLALiM13ySvw-1
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 326GwrWU003384; Mon, 6 Mar 2023 17:25:26 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xugr1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Mar 2023 17:25:25 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 326HMpgm023367; Mon, 6 Mar 2023 17:25:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3p4u051fcc-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Mar 2023 17:25:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB7546.namprd10.prod.outlook.com (2603:10b6:208:483::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Mon, 6 Mar 2023 17:25:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:25:23 +0000
Message-ID: <55874bd7-5c05-4d55-c780-c4206156b708@oracle.com>
Date: Mon, 6 Mar 2023 11:25:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "axboe@kernel.dk"
 <axboe@kernel.dk>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-11-michael.christie@oracle.com>
 <b4b5feb7-521b-fc5e-8c68-a05bea292ebf@nvidia.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b4b5feb7-521b-fc5e-8c68-a05bea292ebf@nvidia.com>
X-ClientProxiedBy: DS7PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfc83e3-e903-4a3f-1263-08db1e67c4ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: UfbC7mtZikQ8vqa/fuTD3Ao7M2LS+/HanmfZQiLtDu8ydp2IhjYfqWxgEDcFK3FDYEGtBAzLBULFyHkcyrxFhqOzwARLUUNQtzB1osmKmEATYLZJBXTbC3LMBPIO9JS2bzlbokiDB6JMEK2ttRvZobiyuUMdOspkJnjqHoJzcrgrwWaQLGx2u5CrZPy33r5NSGXmyXuUV1swJxaSBIRbtpYftho1uYc9QoqUQrk+U8+ZkQ2YQs5n6VuRr+ptS1Ix3aGrqVcst18lQ6s4SOzEnIgXy92DAl/aE8bEoSX9I3DI8t1po8krNfEzFvMpAoG5gh2FfELYUvCUxa8qXLUJHmsN6V350vS2ZeL/aEhF0kLmfEjRFR0USdMCDfLz7qg169mxFyLCNR331QacJp2Endvba5LU1g74nc8Tl/bFld11oWwrS/IcJvRpZ80N94hsxJY3WEwOwClFn5HkDRabYg9fiGY6AYqjet0CjAOpPkIcvvGggIJd6K7qoXvw+h2+hhJ3m/uSck6YIb4q7r1saEGzcE5pzo81UpFaVxjtZtxTBFPtPBIYQJ52zIYylH7Bk4cjYWlTQqy2f0RJFbE6Jt6flLsfiZlEHEvXwLzTbznlBZuMsMhqcK8u5vtvjveNC4iENjsAH5tmJL62nAjAGdDypwD/eWVfsBMMy4OMjyelO4v+LYLaEXbYdaNj21AhtHX7mTPMF04bzT2sMaawwfweM2mh3yS6U1Rh5HR4zTXt5ugj/qzeQUV8aFnmXsvq
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(921005)(86362001)(31696002)(38100700002)(36756003)(4744005)(2906002)(41300700001)(8676002)(7416002)(5660300002)(8936002)(66556008)(66476007)(53546011)(6512007)(186003)(26005)(2616005)(6506007)(83380400001)(110136005)(478600001)(316002)(6486002)(66946007)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUtiMm9XMzhGd2lDTTg2ekdOWExzVlFXejZqak80VEUzR0hlQm9PUVVWMXNq?=
 =?utf-8?B?S3N4M2k4MEhIS2ZPYUxvNFV1UjVDNllCM1hlY1ZmR010UkI2MnlTYWFQdDc1?=
 =?utf-8?B?eFd5QlI4NGIvYnlFbnZjNnZwNUNKQ3laa0ErWTJmWUJ6MDN6U0pPWFNzdmpx?=
 =?utf-8?B?S2FERFdiaHpUSjBZOE9MTUxZTUp6NmdSZFJ2eUI4L0FHMVlGWDBrZmVGTFZu?=
 =?utf-8?B?bXBMNDJiSlV5eG1UcllwT1UzdThqYWczVU5mM2V3ZmZWaHp5T3drY0pycElG?=
 =?utf-8?B?dDFzMFhiNWtpRi9nUWNIK0pRMnNyVlJwWUxSdzNzSTBqaUNQdys4RnMzdTJz?=
 =?utf-8?B?eHg5REVCcE91VjNNVnc0clFxY0NOYzV0V3hJSnZEdkNoQkhhalc4OHpWL0Nq?=
 =?utf-8?B?cmFkNWJBSzJZRFZxdmZCWDRmZXc5dWNnSU1NZ1laeFZSZ2IrWGQzM3ZEZGl5?=
 =?utf-8?B?RHNpZGJOYkxNTUxMUmNtVzFDa21UMW15LzhEQmRxZG9JSFlFNzhsajAvQWpO?=
 =?utf-8?B?b2NDR3JFa21zWHFWdlRpR1p2Yi8zQkFMYTdjTEFYVWJDK21RTXhXcUVEZlRt?=
 =?utf-8?B?OHRhamdJVjJHcG1XMnJZSUNzWktMTGdxeDl2aHE2WUp5cGNvRG4zR3BnNWxj?=
 =?utf-8?B?eUhHdHFvUzFIeUs2YlpsdU1pMXJWM291SGZQbGVFWXpGV2lxdDZGalZ2eHY4?=
 =?utf-8?B?c2ZIRkdEUWY4RVE2UnFuaStkRWd2NDd2MUhtL3JBY3lUMTZZaTFPWU16ZVpG?=
 =?utf-8?B?em16dUlSUFgxWGJrekliYWRZTFpKYVpTdTROTFIyYzdFdllPN0R1bDB1TTlN?=
 =?utf-8?B?Mit5UVR4TmlscGJtR1JtZ3lpMXpVa2dNZHFNRTFlNXNjU2R3ZG5iRFhJVGJ2?=
 =?utf-8?B?UHE5NVRzblB3NTFNMDc2VlYvNDZHdmFrYXRSMEVFZEVkRTNvSDFSdlJZbHV6?=
 =?utf-8?B?SFRqQXQybERlTFlOUWJYbEZnem9nYVNGc0FlazdPMVJ6K2JaZytYNDZSdlZG?=
 =?utf-8?B?MG9YZHFHUjRObk14K1VtY2NRNm5OSGtnazV4czd0WHU4ZHdEdnk0RkdPZldi?=
 =?utf-8?B?THcrSzBzMWFoZFB4KzFIMUEvWTlnNkZoaE1UREY1UDdRUzI2NmJkb1pKaFRD?=
 =?utf-8?B?T0tIdnFTdW9UNlNWMGNnTkVZVmxKVXNKdjU2WFNUSXVzMGNWQTIyTEZCQkcy?=
 =?utf-8?B?R2xXS3pueVBnN2d3ZDA2MU9XUnNiL3JrdU9CZzJIaDB0QUtORzltNVByc2tq?=
 =?utf-8?B?K082QzIrTGc1V1Jla3VyLzlMakJZcGpGazlacFNPMmxYTy95VGJ5RDR0Z3dL?=
 =?utf-8?B?cTAyNnA3TWUxKzNMaEVQc0p5Wm1CZGN5WHJjRTRrZzRkTjVXM1g2cTNuUTlp?=
 =?utf-8?B?Q29aUncyWHQzMzIzajc5V0RxSGJBTFdBdTNDcnlLSmR2bngrL2c5Z1VSSUN6?=
 =?utf-8?B?UjJhV3ZZZHFVOWpZSVlYME9ERjBHQ012Um5iS0l2bXUyb24weFJoQ2Y3WEpV?=
 =?utf-8?B?MVhMV0FXeHBWdGRLQkF1YmRMbHhCSHovL0k3RjNDaHhEUGJ4QjJTWEJMUXNr?=
 =?utf-8?B?QWN0SUdFR0NGTThpd0hsUjFtaS9meVlOaUxIeUtpZFYyWmdYYThiSmlYZ1Z4?=
 =?utf-8?B?cDZpMWp4L09aQ0xYcTF5eDFLSnRieXR5SFpFNDl5TGxzMlEwczZxclpDMHBy?=
 =?utf-8?B?TktjZWhzRjM1OEZmQW5WMjdYVkVrWUpyZit2OGwwNjh6eEFQVkwrYWRTR01I?=
 =?utf-8?B?ZG9jVjRta1UyVmpLcFMyL3VVeSszZUhaZ0lGaFZIMnpOT051a0ZtWTFDZjEz?=
 =?utf-8?B?TlBtZkdEUndyQVV3STJOYXM4V2ZNZEROMTc1RWFFbDNONngxR2hHUlhnTGpz?=
 =?utf-8?B?WWo1WGY2SW5HdGpLemowOHhLNjRRV3Zjd0FJdlovSDJKcXlkVGg5YkJhMEpv?=
 =?utf-8?B?bHhCZVc1cFRRTGxGZkhmaHF5VXZnMFU0QysvZXFoMTNPSlBmQUQ0N3JtUS9Q?=
 =?utf-8?B?VEcwUHY5T2FJMW1VcklEemZTZm5SWVJpUmhqcWxTM3R5N1pQOWhLMDBzT1BN?=
 =?utf-8?B?cjlSUjd0VkRQVnBBZjdLTzRES0lZem9jcVVqQ0FOSG1iWjhQVldJbkwvL3lS?=
 =?utf-8?B?YnQ0cUdpVVRkU0Q1Nm5BbUtzUUhFNmxGSFpkYm1FVk1XU2xMZFZyNFlZTFJ3?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K2xKa3VrT3lheE5IN2FmTTB0N0tibXk2WFdxSjU3Mis1WkV5cFNNbnR5VzJq?=
 =?utf-8?B?cm5iR0tnRGFGcjRMRmZXdWY2T3FMVjdqZklaQ1dCNW1Xdjc4ZGw1RjNORU5O?=
 =?utf-8?B?R0lSRXhDUExnYmpXNlk3RG1rZFlZYkF3bVNEaTNzS3BWREVuZGVwbjdOdytK?=
 =?utf-8?B?WkpXKzZjcTJQeWQyRWVNOGRQVXduTDVVRlZsMG13b2lncEU5aTBjQ2tIdDdU?=
 =?utf-8?B?UlZwNTVDWFZtOG1GRG52YVM5L0pBbjBoekN1eWE4bm14SXN2VkVGczlxTjdu?=
 =?utf-8?B?NmpEbks1WDRTb3lDNEIwZUN2YVRReU10Q1FFQ1RwU3hWVUh0WjU1MXJKODE3?=
 =?utf-8?B?VVMvenNWSHdFakxMOFNPMlVvMTR5OE5Xc3M2VFJLL21mR0FwQm51bVcvZkpk?=
 =?utf-8?B?OVVIdEpBcmZTWlU4ZzRkSU5QS2E1ZmhoMkI2QmpKbWcrSjhCMHZQYytwRjI2?=
 =?utf-8?B?YTUwMWlyYU1EOWFPUEIwaFdFS2RacXhBTTRoSHdUYmgwL2o4eFlXdWR3S3g1?=
 =?utf-8?B?Nmdjd0M2ZWxZZ0NYLzdzdWpkMWlXUGdzWkVvaVA3dFEwTENOR3ZENHV0WWsr?=
 =?utf-8?B?dldodktzZStsd2ZTZUJOQmMybEQreGRUTGROaDhkaVN3SjJLVHhwajR4OEQ5?=
 =?utf-8?B?d0xxWjBaaXRwR0gvSkQ0R3RqYnFaUFM5SXZUME9INzhWZ0VHN1pOM0s0c2Nu?=
 =?utf-8?B?dFZwMzBZT2x1VTlOYW4vMHFoQWdDSGtqbURSM0w2TU5XazBBelFMTVZkNTYw?=
 =?utf-8?B?UnRxUWxvSXNKQU9KMkp3Q29nMGVKYy9tY3dHQUkzeUI1cGpsZ29leDhiNnJJ?=
 =?utf-8?B?SzBqWU8zaXlqQklsb3cwUmxFUmt1TkMwVVkvcGxDSktKODNCeXNTM3diUXZX?=
 =?utf-8?B?enhXZStFOGVmdmIzdm16N3JiMWR2QWo3TEZyMkxxRi92NHQwdVEzL3d6S2hP?=
 =?utf-8?B?YVNsZkZvbHJabEE0N2x2dmJERHNiZ252aGVkeWJ4WmM2K3E1Y1pzcVQ4eXdw?=
 =?utf-8?B?dHVTejB4ek9LTFZCRGJsR214TUQzem1HVTBzZjFqL0VCa2pjZnZ4TERKa1d3?=
 =?utf-8?B?QzE2REk1ZFhDVjJrVk4zQzVYM0NCRkwxMytPenlEUnFzenZUZlZRRjQ1OXNj?=
 =?utf-8?B?L05PSSt3eUorWVAvK0MwYm9kRHZzM1BMWnZCZVFEd0s0TVhzb0Z5TDhCbTcw?=
 =?utf-8?B?TnVKcllaSFZzeVJaVU1KWUVVQXJuTHlBRi94UlJMbFI5TlVERS82c0xZbVg0?=
 =?utf-8?B?OFBTN0tjUjUzelhEUGVaUUFOL21rT3pjWmZSazZ4M0c2SG9YcEFJdklQSVVT?=
 =?utf-8?B?dTJUN2VzQ2RNdklrbzd2aVVaWkR6OGt2RWFaVjFNNitDNHN5UHRUaUlHemc0?=
 =?utf-8?B?SkhVazIvMmtZa3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfc83e3-e903-4a3f-1263-08db1e67c4ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:25:23.4670 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l67PSWdjoyeB9KiqyRhgqgGx8nnv2W9G7LbqzBFcuqHEXa7OJxdvDyFDp5uuqKzjxZcbjgpZGgHhGRWAauH5dLa3PS++vLpQviaCVGFPATc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_10,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060154
X-Proofpoint-GUID: wYAbemW-Ov5Nj85Bu7DLT_KEsjeJ8zPe
X-Proofpoint-ORIG-GUID: wYAbemW-Ov5Nj85Bu7DLT_KEsjeJ8zPe
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 07 Mar 2023 07:41:32 +0000
Subject: Re: [dm-devel] [PATCH v4 10/18] nvme: Add helper to send pr command
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/5/23 3:28 PM, Chaitanya Kulkarni wrote:
>>   
>> +static int nvme_send_pr_command(struct block_device *bdev,
>> +		struct nvme_command *c, void *data, unsigned int data_len)
>> +{
>> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
>> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
>> +		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
> below else is not needed after above return..


Will fix. Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

