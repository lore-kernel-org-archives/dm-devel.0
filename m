Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFF1C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 06:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680069948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xLZoUOCfj89WttRPHD6PBjsjhl+05mHlSajfvZQv1ms=;
	b=DZd3Zwar6vizKUktBDjfQt1KOgi/GLr1eGkBdgmcIvZfXye8Ih0Vf5FtjEuru8oHECFFSn
	pWGbBzA8wYepA9ORYuMbv5apdGmEVl5kQGVFwsW7ak/3yzKwyiRIXkQWaXobtpMWY6tABZ
	dGNp5BBDTBzD3q4JWlptZfmwLzf0XI4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-MctE8Au9OjG3nwIyLTJVQA-1; Wed, 29 Mar 2023 02:05:44 -0400
X-MC-Unique: MctE8Au9OjG3nwIyLTJVQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCFC029DD98F;
	Wed, 29 Mar 2023 06:05:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 148924042AC0;
	Wed, 29 Mar 2023 06:05:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D19CB194658D;
	Wed, 29 Mar 2023 06:05:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1769D194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 15:51:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF072C15BB8; Tue, 28 Mar 2023 15:51:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5D41C15BA0
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 15:51:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C45B83C0C883
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 15:51:04 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-J-D02MukN6GiwZICs-_Q8g-1; Tue, 28 Mar 2023 11:50:59 -0400
X-MC-Unique: J-D02MukN6GiwZICs-_Q8g-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32SFnxZi023139; Tue, 28 Mar 2023 15:50:30 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pm37g002k-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 28 Mar 2023 15:50:30 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32SFaSWO020349; Tue, 28 Mar 2023 15:50:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3phqd6u4j0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 28 Mar 2023 15:50:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB5899.namprd10.prod.outlook.com (2603:10b6:208:3d5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Tue, 28 Mar 2023 15:50:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425%6]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 15:50:26 +0000
Message-ID: <06c0cc8a-cf98-9687-93f1-a1da07578912@oracle.com>
Date: Tue, 28 Mar 2023 10:50:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: kernel test robot <lkp@intel.com>, bvanassche@acm.org, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230324181741.13908-12-michael.christie@oracle.com>
 <202303281502.U47uzous-lkp@intel.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <202303281502.U47uzous-lkp@intel.com>
X-ClientProxiedBy: CH0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:610:b1::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: ecd0c1bc-9597-4623-e872-08db2fa42644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: IikP/SPCYjRFwGE7D2pR2sG1/AErY2v3WgYe4BjiYoBpZw6sIoYtPZLd/SYxhwHpqIHJBQwAyDlxTnS36EOZ197RfVn2pbsORGv+ItX9IkZdcyJ4GxX1eoiZEpU3xqtyCJ3XwOUs3HcdyyWBC9KmFX3zt7U5qFOTMzoMsOAES/mUqGArl8sBNWJoE6QS2ksXBpCFKGVhf0ENUGMZHMeTfmlTdc0APBXol4Vbj0zP6X+qqPGzgTwjHt010iwoUqEVTYDj9zYg5IdawGxMP9IJJV8J8e1LQz3ZiQU+K8ZOEpwS2/KLjIqxe0C2ehnV/TbeQK9vHMELCIiXonmgvOq1O3oNfCCAF1AZERZIRZ5IcCbNISvDge05IPBjfT8tU6NTqbGmskPLNeFJUHqifpW2so8BK57+mkNG7ryKTnzd2OchztODZTORbrHnqaxeqouxJiO4fS2oLEObx2kw0Cpwcwjq5eXUia6m6I9ji1KGZ8NwVCkQL+nxgaUBssQT2ou3VhntLaCyzy4BFHEjaE2ZEmWmeTk0FlKk7RAkXvRWCwLbmvqavcem1M/Buce1UEZ6aOcaXtBWafluZMXafYO4NQNjsVtbS89oHkbN6qgj7orssZy5qEmKLg4E6C4I7dmH06DmSE/Nto511KxFJyUaUGDSNKqzoyakiOGWsYMC7bUNvem4I2hAPgsqwCC65S/p
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(38100700002)(31696002)(2906002)(86362001)(36756003)(921005)(186003)(4326008)(6512007)(26005)(478600001)(7416002)(5660300002)(53546011)(8936002)(31686004)(6486002)(41300700001)(966005)(6506007)(316002)(66946007)(66476007)(2616005)(66556008)(83380400001)(8676002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2ZMNWxpWHoxMnAzNnI1R2FEc2lJc21nOGc3VjROOVFqU1AzRFpBMy9EaWlE?=
 =?utf-8?B?eFhRTGZzV25YOEhxRkVqTTlzTlMvNWdnL0JxNzNVOGI3KzgwMnFWeUhQYUlD?=
 =?utf-8?B?Z21XRkxsNUJlMERuclVURXN3Z0ZNcU82ZFRJakhpR2tHS3NmWllNYUhEV2hX?=
 =?utf-8?B?bW9KQ0IzcVd2WENUWVZsQVZjdXZrd2JXU0tKWTJobEVDaUxUSWgzZzJJZjlz?=
 =?utf-8?B?eDUwSHl5c21MdVNKZXZpMXdxeDgwQllBQ3paZDJEcTQ0VGlOaldzcEg4V0xV?=
 =?utf-8?B?Sm5WSzdCbmJKdlNiQ0tVUjNqcHBFTGNYZDMvZ2N0SVYwZFpablhmb00xQnB5?=
 =?utf-8?B?TjkydFRjU2tma2R4SEdCajB5OExheEE1a2JEbU5UUHhhVGo2eU8zd0N2czk4?=
 =?utf-8?B?VnJTSis5RWIzTStiSEE5N01NN1JKN2tSV0lKRmdybFdLdmFQNmxIVC9GSFc4?=
 =?utf-8?B?aUxzMU5xMXkybFEybW1mS1NjdWYwZ2szZEFSa0tvZGhzZmUrOUkxWHdJRUhp?=
 =?utf-8?B?Ni9oWW01bHc4SFk5VHhZZE9JK0Exck43cm5ReVp2TUMzWm0vazh3OXYyL202?=
 =?utf-8?B?WWlXSVBmRGhHdVVRRUYvVGY0UE5KdGM0Z1luWnZRN1dlS0d5SnVzYXhBZmdJ?=
 =?utf-8?B?UndMMmNGMCtZNndQUGJ1V1RWN3g0SVFtdEg0SFZ6cEVvNm9LNWMzS0crVXVR?=
 =?utf-8?B?bEFMOWliUUpIOVFtMSsrNUNXUmk2Q0tBTTl0dWJnUjBQeDRUTVF5dVEzTjJa?=
 =?utf-8?B?Z3BqNGRPL0l2VEtxNmt6eC96SUplTkJMNm5GMHRmN2FrMXY5OWVRTmR6Qmlv?=
 =?utf-8?B?bDFiTmNuM2dEb2Nma2R0REx4R1VDVm9ZUTJEQy9vUkRwSlFQb1kwbjMvdVEv?=
 =?utf-8?B?NE52L0Nsd2Ivek52OHJZTjl1L1FxeDFrS3BsZWpzY0tuQUNBNm55bFZKVkFM?=
 =?utf-8?B?ZEhidU82WjR4SENJNHlqMXR5Smtpakp3WGdKeStaNFpvZ2l1cEZpeksvcnlp?=
 =?utf-8?B?Z1pLeFNNSnB2dG50NlEwbTE5cGVBb0p5cFB2NnM1U0JpeFFMMnFKOVlGQnpM?=
 =?utf-8?B?bGhmN3Y0NHdhSy83Y3MrS0hYZXN2R2RTVjlKdzBZWVdGYW5sUG44VHNER1lr?=
 =?utf-8?B?TTczczQyM0tVTHc4bGg5UnQ1L1FzTUJaQzB3YTM3YnZuSS9ybTBPalQ3Ylp4?=
 =?utf-8?B?TVczQnRzSmxvT2UxSG43NHkzcUJqNlUvNXhtdjkzajZiL2VYRkF4RzV4ZmhV?=
 =?utf-8?B?c0RadWJWVElJMEh4ZGxVdkVqV3poaUhQYjJ6Zjdzb1NPYVplTk1IZ2dPMmxH?=
 =?utf-8?B?WkFxNkpwNHBhQzR6ZUxkcmxZenFYWGFnNS9ma08reHBwNXJQeTZHV1pvaFp2?=
 =?utf-8?B?MWs0RVJwSVdMaHFrVGgySHhNZUk5M29ONlIyQ2JQRFh5SGhYOFFyTnJQQVo3?=
 =?utf-8?B?LysyaXhiMnNza3NhOG8vdHRHWVdpMEtLZnV2emdrd2V6SnVqQUF1MksvOHFI?=
 =?utf-8?B?T0FjMTloRkFwcjBkdnoxZStmMkYycGFLMmF5UHNKVDVVZ2hVM3ZHako3SUlq?=
 =?utf-8?B?WGh3eXVtVHB3SVNmSnMrQWQyaDhydkVPdTZpODdjVWtwMkt0Ty93Ly9lUWhF?=
 =?utf-8?B?Z0VWM2ZCTjVJcUo1VE5WTHVMbTlHc2ZMYXlkOFN1VCs5MnhCdWdrZTFLNWpk?=
 =?utf-8?B?R1o4WDEvR2NPb0g5K1dNek84eDVNSDRBQ0lCZ25VdVNtUVRVWUNDSGQ5YXFZ?=
 =?utf-8?B?ckFrczY2RTNWVzRUK2N3dksrSTc1R1JaYS9ESnRiMWhsVVg0YU5XZjhrbXc3?=
 =?utf-8?B?SDFoTzVJckRtME1sZ3BYNWtrbDlXRUJ1b0FDa25oSVBGS1dXcGZnNzlLampG?=
 =?utf-8?B?ZDB1YjZjN3JqRC9iNWRtL2VMMEhMOE1ZMENaRzVWdG1KOUNSdFNuZUs5S3Bo?=
 =?utf-8?B?cGhkeWJEcDBOTE9HUnpWQ0kyK2ZDMng1SVhvOUFydHppTlFrWXRKbU9UREZz?=
 =?utf-8?B?SVJiTnVrcy9KZExSSTkyU3RJWVJmeWhXNUU4bzd2Y2RIV1I1MWZ0a1ZTMjRl?=
 =?utf-8?B?UGVJL05UZHczSlR6Q043NGdRek1VeFRtQ3ByM1pmV2JnbjdJOVZBdmZZV2p6?=
 =?utf-8?B?RE5GUVFxUExjWnJISjBhQmg3bFF6NUoybnB5LzlCaitiajRORm5QTTZEa0Y3?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MzZpaWtOVnRsZHlaY251UmlZZllFUjNDeEhpU2hreWQ3STNlODNBN2dCZVFq?=
 =?utf-8?B?WkRJOUJ5dzRsc1Q5TmoxdjE0b2ZoMXE5SjZqQytmS0M4SmUwajdvOEVVV2VS?=
 =?utf-8?B?MDQ3YktrL0kveGhneUp4SkR6c3FLdmJjbzFYQkc2UEtzODhUY2E1ODNlVklt?=
 =?utf-8?B?RURsV3Vpa2RVRGJNMFlJZXcxeVIvUk9UL3RUL09tc0ZWaDg4NHIxRUlYV1dp?=
 =?utf-8?B?WXBVMDNYenlOd2RDMGVaV2R0R1drMlNGUWNFSVJLakdGeVlCWVBKdzJ6bkZ5?=
 =?utf-8?B?R0VybzdreHVGMmdJQktXSjdFcXRkayt6bGU0MjRtOW5qMGxpTmp5S2NrRVN6?=
 =?utf-8?B?QmpkOUJMUU1uaHNlME8rcU1HWktjd1p5dTNiN3hTOXN6SVFqbUFWSlZENDlI?=
 =?utf-8?B?d2FvT3BacUt1MnQxbno2R0djNzQvV2NtYmdQbEtBYksrZHpUekJHUEk1VzNv?=
 =?utf-8?B?VjJkb0Q1Ri9HOHR1aUNLU043b3BaeG52M095eWdFRzF1QmJxZlY2THNpcVZP?=
 =?utf-8?B?WGpsT0ZLMVlkRjlmV2FWK2dreU45OGhKVGJJV1NPenhiM2tJVWdBQncxVUNa?=
 =?utf-8?B?MERidWRHL05DdmZLUllHbVRXTTBPeDIwejRjaG8yNjc0SmErakpYRUZCUjBi?=
 =?utf-8?B?UElyV2hzaGhublg2QzYrdDQ5N3BQdC9iRmVCeEE2WFVkaHkyaUpqUDZBSG4r?=
 =?utf-8?B?MTFaVFBrVGh0Y3V1QkQrKzBJTVpLZndKZjNvZDMvdmZtL3hENDY1cWJMWkNT?=
 =?utf-8?B?NUZ3TCtpUldwM2pTUXcxQXFpZTBlNWhoZmZINmlnZG5Yd2VyendTYm9HTGFX?=
 =?utf-8?B?TXJianJYa25OaTBUejJUaS9SK3VUdVdTeEV4RWtVU3JveDdJckV4ZHBUbXRs?=
 =?utf-8?B?SHJFWVJRc2o2RmIyTkY3R3MxQTVxRkxDQXRHUTdyYk1hdGoyd0RIcWJnWnM2?=
 =?utf-8?B?SGFKNWR0dGFUNWZncjdlUkZpNnVWK3E1UFlCckJtU292SVhJcHV5NjBZakIx?=
 =?utf-8?B?Tys0U2oyUk5BOXkzbFNQc1FyVzhCM0p0T1IwMkI0SkIrVXdSdEdaa1VaT1Nn?=
 =?utf-8?B?djZ4cnlUUEZTZVBkUGRKRlJ6WjYydkNKcWdhRTBkd2Z3SklvU3ZkRnBkd285?=
 =?utf-8?B?T0pQV2hBRnc1YysyZng3cm1lOUFSVkVuWi9lOFVyNTJVSytaNWVoR0NyZnU2?=
 =?utf-8?B?bDJ2L0Fxbm1MY0UrcWZXRlI4QXVYdkZ0dG5veERoUElIREdOcVlSSTBmeVJz?=
 =?utf-8?B?Q3loaVpJVjFCeVRnOGU1N3RLZ2xjbjNOcjZaRlNKY3gvQ3UvUWNPbUsxWXJi?=
 =?utf-8?B?WGdLd0RwQm9JY1FFMGpxMk5hL3l4NnRnVllxWk83cWRQeGFMQUhhY01lQ1RE?=
 =?utf-8?B?VXNOL1Y1dk56REVTVW9IajlCdzNUZlN1ZEF4K3BWdGZKajlPbzJIcUdFVjBE?=
 =?utf-8?B?S01PSWpzbEo0MTErZ0tQNmRsU2R4RFEzczdncUZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd0c1bc-9597-4623-e872-08db2fa42644
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 15:50:26.8234 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZWn+824+EEpWYZq7WpdXYypd4BnkmAjR4W6KSO6OtZ9LjSOwqYbtOA08kK3OrmNFuB2w75Bxmm7xcBwmjswRBbmp0N6X6uFvWNfnUwT4Is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280123
X-Proofpoint-GUID: PmyGD-3HxLD0-5h2QLCWMVWeiO32z980
X-Proofpoint-ORIG-GUID: PmyGD-3HxLD0-5h2QLCWMVWeiO32z980
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 29 Mar 2023 06:05:27 +0000
Subject: Re: [dm-devel] [PATCH v5 11/18] nvme: Add pr_ops read_keys support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/28/23 2:11 AM, kernel test robot wrote:
> Hi Mike,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on jejb-scsi/for-next axboe-block/for-next linus/master v6.3-rc4 next-20230328]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> patch link:    https://lore.kernel.org/r/20230324181741.13908-12-michael.christie%40oracle.com
> patch subject: [PATCH v5 11/18] nvme: Add pr_ops read_keys support
> config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20230328/202303281502.U47uzous-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/fcd2233cf643c550ab3cea2b6102077b1d05b389
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
>         git checkout fcd2233cf643c550ab3cea2b6102077b1d05b389
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 olddefconfig
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/nvme/host/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202303281502.U47uzous-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>>> drivers/nvme/host/pr.c:165:24: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [assigned] [usertype] cdw11 @@     got int @@
>    drivers/nvme/host/pr.c:165:24: sparse:     expected restricted __le32 [assigned] [usertype] cdw11
>    drivers/nvme/host/pr.c:165:24: sparse:     got int
>>> drivers/nvme/host/pr.c:171:21: sparse: sparse: restricted __le32 degrades to integer
> 
> vim +165 drivers/nvme/host/pr.c
> 
>    156	
>    157	static int nvme_pr_resv_report(struct block_device *bdev, void *data,
>    158			u32 data_len, bool *eds)
>    159	{
>    160		struct nvme_command c = { };
>    161		int ret;
>    162	
>    163		c.common.opcode = nvme_cmd_resv_report;
>    164		c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
>  > 165		c.common.cdw11 = NVME_EXTENDED_DATA_STRUCT;
>    166		*eds = true;
>    167	
>    168	retry:
>    169		ret = nvme_send_pr_command(bdev, &c, data, data_len);
>    170		if (ret == NVME_SC_HOST_ID_INCONSIST &&
>  > 171		    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {

Kernel test bot is correct. Will fix.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

