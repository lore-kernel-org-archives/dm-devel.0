Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987C6C6FD1B
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678174904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xp8BIAAgfkxQCsgi+HvhlkhtEku10k47komqj8ES2og=;
	b=CAQXgaENg/Pv0RaHw2VNHhagaI8vzWbVFD51LC3DGSMwYGgQyDm8wxjgme9AocjaTX44dX
	IsvukscaZ2IYpjUiWj1tsqBiMxTnJZ23CisHh9CJWMgz09hw6N1AosyN4nz1F0yEhwkksv
	aj+qpf+7rJ8siMp8vZUiZIJ8nbNSeV0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-f7F-XMXFMUyDylZ1skVCDg-1; Tue, 07 Mar 2023 02:41:41 -0500
X-MC-Unique: f7F-XMXFMUyDylZ1skVCDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2826857F40;
	Tue,  7 Mar 2023 07:41:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6A6AC1602B;
	Tue,  7 Mar 2023 07:41:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6B5319465BA;
	Tue,  7 Mar 2023 07:41:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB521194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 17:25:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D732EC16900; Mon,  6 Mar 2023 17:25:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF3D5C16903
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 17:25:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF8CD1C29D41
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 17:25:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-gowXMaWPNHKk1pSDQj8_ug-1; Mon, 06 Mar 2023 12:25:50 -0500
X-MC-Unique: gowXMaWPNHKk1pSDQj8_ug-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 326Gwldr021464; Mon, 6 Mar 2023 17:25:25 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161ufns-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Mar 2023 17:25:25 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 326HMpgl023367; Mon, 6 Mar 2023 17:25:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3p4u051fcc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Mar 2023 17:25:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB7546.namprd10.prod.outlook.com (2603:10b6:208:483::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Mon, 6 Mar 2023 17:25:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:25:22 +0000
Message-ID: <9fc842c2-d842-5803-3f79-2c593d61743b@oracle.com>
Date: Mon, 6 Mar 2023 11:25:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: kernel test robot <lkp@intel.com>, bvanassche@acm.org, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230224174502.321490-14-michael.christie@oracle.com>
 <202302250448.cEVYdC1I-lkp@intel.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <202302250448.cEVYdC1I-lkp@intel.com>
X-ClientProxiedBy: DS7PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 439c992f-f01c-48f9-2121-08db1e67c3d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ZAeHx3Hm8QUhxpYv1Qa5HXwwVZIs/8/Icr6e5hRKirP7OQgZAMXAXg127JxlU2FylwH7ginlXl4vku6kcSZ4GWuuFkd1mXmYqrx60nb0xzd8LG1hI9jN2yDztrv+eXMEcFCVpBVH9bVOgZ17Kg8YzRLBSsYUvX5HJpYv8Uk8kAX27pRULP8vB/RVBULbB6ky8zfcwqGkv52DGF141scifkKd0CVWx3gHb0jaWMC6l5c9ays/GM30tTdDO0YrwsLqslgSKBRqcVHw4sWYN0BnAVklpfRuL9Z6mmi6zqLuA8VUt3L543B/d2q9hUgQT3bfJGYht564b8iGDqDGP0v9ffOCcAUK00tkXHb82B5sJfi4XEdlOlG/qZB4ealMZiSYcW4CLg3j1xBP8c9+6gNlNqyiE2cHQ8eowLcyon4TtCoDRtelJUOOmyWICvcq5+6TQGczrm60bTXJcgXkKle0qYwA26rQqrZ84ZYdkdFjouZLo903s8PRCY0uB2g0bH1C2pl0dFEI+n6H/SIxcCFTrZIDfE+wBezgZxgYWZTOymdVegGfEU/YEVMTiq619QfOPf/wYUBSXbWuUE+KJ57gAMZkPC/NByfUpr4+yZ7nptCc2nl+qk8pzB/BlCfKlq5XFUTq84fVF9UW9db3AstEvQpzn7JCV8wztrgaE5mY3eZBgb+mwWjVleP3PQ9PLHTD6B/8bshrBQN744UBQlXsFX2e0Mu8YPzqHq958pKjjdXYPVbfDnEZiAgM0hAXmFxF
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(921005)(86362001)(31696002)(38100700002)(36756003)(4744005)(2906002)(41300700001)(8676002)(7416002)(5660300002)(8936002)(4326008)(66556008)(66476007)(53546011)(6512007)(186003)(26005)(2616005)(6506007)(83380400001)(478600001)(316002)(6486002)(66946007)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUZCaTlaTW0yT0FiYnNzb1hSMEU2aCs2c0pRL0ZHMnFvZzFiVEZWMlRGM1VJ?=
 =?utf-8?B?R2F4YmpQT1lOTWoySkhpdFdSb295dk1aVHhYbnhENFpneWF6R2VJaTFxbWlq?=
 =?utf-8?B?Vlo5bVdSUzVURkpoVzgrSDRDUUxxWEhFcjI2YnhYTmpQaTM0VjNmNUx1U2VH?=
 =?utf-8?B?ZTF0QVdNQjdGWXpPS051NmJEWE9acmI2a0ZMSzZycGt3MTg0bkV5SDZEUm9C?=
 =?utf-8?B?UVZEN3VDcGFTWjdIS254M2s2R1N0SVBxZHROSFFSOWpmMWxGR0NsRE1NMEsw?=
 =?utf-8?B?OWlwYWwvSUZLdE1VeHh3R29Wb3RhUFBoMnFwWUhKNFYrbEpqUUZRWE5tVFFY?=
 =?utf-8?B?WmV0dVovZWFjU1oxU3UvN0hGNEU2Zm96bUZBLytTVXVHZUQxUUMxRFdwUDI3?=
 =?utf-8?B?ak9DdlkwVldDQ1NVWnhsdkRvdkVTSjRaeEtiWm40YlpqZHRuc1Y5d0RVMjhF?=
 =?utf-8?B?Rzdrbjd2MTJ0blFWT3pHTkpnQW9hMko4cHVtMEVXVWdWU0EzRFVFUjdzVmha?=
 =?utf-8?B?NytmUk54MWUrSkNNU3RWWDFzWTd5SUo0ZGZXZFJBVWt2U3M4M0MrUmRLalo5?=
 =?utf-8?B?ZzZJY01BVVJsUFBYMitUcytzZXNCMW4yY0RUYmduV3RtUitXdExKLzZoeVI3?=
 =?utf-8?B?NFA2N1p4YVp2UEVYSEZmUWExbFRSaW9TZXBxR0RIMDUwdHlFancycWdaYndq?=
 =?utf-8?B?UTdpN2tjZU5WQWhieS8zcEhhMnkzVE00dTErSjI3MVBhak1tYWpsb1dJZWUw?=
 =?utf-8?B?ZjZQclB2cm1iSWtVRUFFZWYra0xCUXRsUVM5Z0JVbWlRY0ZHS09HdVJWZFg0?=
 =?utf-8?B?NE91aHB4amsxaUV6SWdMS0VxRUdEbXJnaTV4eVZKSHM0QlNOQkIwb1ltcFpV?=
 =?utf-8?B?YTZER0FiVFR4OU9nM2k5ZitDY0ZHTmNvN3NTblRjeXYya2QraHk2bFl2anlX?=
 =?utf-8?B?UXM5USsxaUlGa3JWRHdraUJFd2pPNW9WN25aVmZUeGgrZUlPeTlqbDJaeDEz?=
 =?utf-8?B?bkVYcExKZnk4WXpVUGZiRGk1OGlzakFXSUhHWEYrODdkRE1SZGNFRC9FZm5B?=
 =?utf-8?B?K0xEc2tRa2REYm5JdG10emovaTdObWg3YVI5bFllZTNXcHlaeUdyQ1hlblJB?=
 =?utf-8?B?bG5oODF6SHEyTTJVVEwrVHNMZEhyTTF3Rkt3UmwwWXRNb09VR0FwTUpFQS9y?=
 =?utf-8?B?Q0F3c1hpUk5jTVFGTDhxZkEzeiszU1hnUlIyV2JFc1ZWdVhmQm5uMlhJanYw?=
 =?utf-8?B?YXBXenpJUTJsTDVGVUpCUXdPSDFIa1l0bkwrQXZ0ZXlONDQxYk9Rc1NndGNl?=
 =?utf-8?B?VFpuSVdhUmNrVWR0eWVIRlIyaXA1cTkzajBpM3U4Um81bnhLOFhhTStwNzRp?=
 =?utf-8?B?VDI4cVdaYTdGOStOR2xnKzljQkErRlB1VDFhWFlMUjlXc1RIOGxyT1FDMWFW?=
 =?utf-8?B?MlJoWkY0S000Rzl6cCsvdnJiMXphUVpkQ0xGcXhadm9iT2hDc1Z1Ri9DN3kx?=
 =?utf-8?B?QzFqZ3JMRFphWDhnYU9oNTU4RFJOS2xyV2plSmIvUUFNbk1BT2lzNld6ZzV5?=
 =?utf-8?B?dEdZRlg4cXZmVWZyZXNPdTY0MGhvMktMMEZxcVBoSWUwSE1HdFlBUTlQWWlp?=
 =?utf-8?B?SGJDRm82N1FrL3N6Ti81dUR1THVpVzNibEJhVE15V3d5aHNRcU1BYlB2MU9p?=
 =?utf-8?B?dmNvK2dmVG01VEJPYzk1Zit4WWU4elozVVVJTkNZVi9JUTRzRkJFVGQ5Slpw?=
 =?utf-8?B?K3hqSzBpRDRzeU90MzFuUExwUFQxVUpmUjZqTnA1WDVzcHJ3aXZZc0hNTDRv?=
 =?utf-8?B?NWpwbDZDRDlYQWJsNWF6N3VNMFEwK015Q1ZFajhzQkJaaTZ2SFpGVUZoTklh?=
 =?utf-8?B?L3Y0eFFiWTROc2RkYlNiazBLTzRmVE5FZDZ4cU5Icys3UkRhYXMzdmFPVGNw?=
 =?utf-8?B?aHpyUXRyMyt2TVh0aHBrYmJQdGpDYThUdExwTW1NZ0doZDZ2ZzN4aGdZSTdI?=
 =?utf-8?B?V1BqMVVRcURuUHhEQ2FyRmZRZklQTmtnWFp4R2p1T2gyOXhtS0t0RG5HS2M1?=
 =?utf-8?B?VitSaEZkcmFQNFZNYVAvYjB6NVJtLzRFNExHazBaZEtXSE5VNVRJRVNxVGxu?=
 =?utf-8?B?VytSYlNJa3U5QTcwTC9wTHdETWt3c2U2cGNlSHJ1cUg4NlNBUkZ1ZDFHOE8x?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ejF2ZlljSzNVTmtXYlNzR2EyUmRVWTBJU2FWMUg2NWsvNVd5eDFxZnorQVZL?=
 =?utf-8?B?M3VSbkZQSzE4OG5BT05lRVVBa3FKSlRLQUR3OU8zU1ZCNElqeWFRa3B5WktB?=
 =?utf-8?B?bG9kbjhzNE5MQ2FmaU1xek14Y3ZFQU5lVmZ6bFZlZ3pzeHQxb2lVcDJNUExS?=
 =?utf-8?B?cVFOMnFHV2lRVzdjandXN051TEFjZDBYeDFZa2ttcHZKRjZCcElNZTB4WUhC?=
 =?utf-8?B?UmNjbWtoVy90VFhmUjV3eEdmWk9JZTFuWkZwd3N0UER6dXV4dUpzc0pUVno0?=
 =?utf-8?B?aWVZOC93TDlvMTJyNUlwd244WlhIamh3T3dYSUpWVTdHSC9lVlg2b0tDZWVT?=
 =?utf-8?B?b29Ia0pyR2hDY0hJNy9YVnZ1L1FmU3RXN1k3VTFVMmlwQ0FXR0dmUEhVSGY2?=
 =?utf-8?B?NDZPZndTbjlUeHNmVkUvSWNTSHZiUTJqVkRIQmJVcytoUHg4N0s1WWN3SU56?=
 =?utf-8?B?MjQ0QVRiMUovQ3o1NkxpRHF0L2p3TXV6SUhDM054anc2WHEzR08zWEZHQ0Zo?=
 =?utf-8?B?RllPY2pNQXIyZUd5SHdabGhtdmp3K0FUcHg5SDVpTlZwbFk2ZndRd0lFU3hx?=
 =?utf-8?B?OEV4Y1dpTm1NWlpTRW5wRUlDN2IxenFBVkJ6cGtOWmZOM0dBK0p1Z3JHL1B6?=
 =?utf-8?B?YlNDelU0QmxVQVFpMGV6ZGxvVXBET1JBZ21kTGRIdzJhV3IzRmVKWkxCeWJx?=
 =?utf-8?B?eG5EWFhZZkVrd29tSnRvNnAybXV5VUFWRkZwM1pSemJMdndyR0h1VU02MjQ1?=
 =?utf-8?B?QzJIL3M5WGVrNEpELzhOOVd0YXNnQllpYU14OUxQMFlYQ05Td2NIUzdIdzdU?=
 =?utf-8?B?bkNGTGFESHFuemh2MGMvd3NzNERqVHBLZTFtWW1uWm8wby85MndnSTN4MEtQ?=
 =?utf-8?B?K0IzcDBsUENWNWJ5VzFyalZLdEJrZWNXQmg3WkhvZE1qd3U1Uk53d3JSaDlD?=
 =?utf-8?B?aElnNzJleVVDdnJxTm1LeHdvNVFEa0xYajV2QS91azB4c01SWld1Z2lsNyt3?=
 =?utf-8?B?K1dtME5vVjFRL2NmTW9VNTh6MkQwOGZzVDY5WnczZUR1RmxhTjQxQUZCZ3ND?=
 =?utf-8?B?QWE2ZFFRVzJrSDc0cGNJMzJuV3VhcmxMTU9GWkoxaDBzT0pWWC9heXRLVXc1?=
 =?utf-8?B?SS9FZ0xxUU9lTzFYNm1pMjZiclFsMFdQN2VnWVppNjBKd3ZXa2R6Qi9Ed3do?=
 =?utf-8?B?WWxJMFRTNzM0akJ2MzZJdVNzRkE3Zmh4eVBCNVRkeWNkVVNFRzByQjJraWEw?=
 =?utf-8?B?SXUyM2FKM2s1WWxJRDdZWDdmV3ZjMENocnJnczhOd3VLU2dDK3NZZGpnSGp0?=
 =?utf-8?B?MUZFRWRScXc5WVBEeW5ZazNraExwNndoVW41V3plNkRTS2hGT00wcDhQUkVm?=
 =?utf-8?B?dmRGQUxlUTRrQTdMYzhCc2FPTzJObitxbWNyU0FTQzkxV0hRTUxDTU1PUlBz?=
 =?utf-8?B?NExZc0pIaWdwQTlCRXBaQ09XUTZucTZLT3h3ZElRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439c992f-f01c-48f9-2121-08db1e67c3d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:25:22.0609 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /X4AyNiHpjINZ5sFnFfLrYokR3u+g0TBcHYsYkmq5sTsOFbprAskFp3gKTWCVFjfwbYxnnqTh2FQTCuXBfpLUEbSdI8pKR2HnjDzlMlB7ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_10,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060154
X-Proofpoint-GUID: aBsc09qXi4EqZ6bBycaoCEF28idtbs0r
X-Proofpoint-ORIG-GUID: aBsc09qXi4EqZ6bBycaoCEF28idtbs0r
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 07 Mar 2023 07:41:32 +0000
Subject: Re: [dm-devel] [PATCH v4 13/18] nvme: Add pr_ops read_reservation
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
Cc: oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/23 3:04 PM, kernel test robot wrote:
> 
>    drivers/nvme/host/pr.c: In function 'block_pr_type_from_nvme':
>>> drivers/nvme/host/pr.c:43:24: warning: implicit conversion from 'enum nvme_pr_type' to 'enum pr_type' [-Wenum-conversion]
>       43 |                 return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Should have been PR_EXCLUSIVE_ACCESS_ALL_REGS. Will fix.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

