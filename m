Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B293DC6FD18
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 05:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680240173;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=868xYDvH04dXQihGbqwA4YKSCW2kByoq2t8V0BZ7zoU=;
	b=bQ4A5TfTTlMGYKEKDVlUnd11yjXVEgn2lnOjIkRIHL92Kw1MKxUSriA3zdEBbJMLFOBSQV
	P924iyG35qNQZVeJ/lQAgPAoEcatNyyqXawTiZyjddkaOMuLnCbUOJa380JiD/5qECyi70
	9iHGYUNz1cI6yg1jQrqFpODSMPqgEgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-a0uC4JIVPdiGX5omLFo9GA-1; Fri, 31 Mar 2023 01:22:49 -0400
X-MC-Unique: a0uC4JIVPdiGX5omLFo9GA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00E428030DE;
	Fri, 31 Mar 2023 05:22:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A64A818EC7;
	Fri, 31 Mar 2023 05:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9281F1946A71;
	Fri, 31 Mar 2023 05:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CE9F19465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 19:00:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79D67440D9; Thu, 30 Mar 2023 19:00:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7179F18EC7
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 19:00:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D7A21C05EA9
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 19:00:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-BmQoDeM6Mx62lGyF4Zx65g-1; Thu, 30 Mar 2023 15:00:30 -0400
X-MC-Unique: BmQoDeM6Mx62lGyF4Zx65g-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32UEELoJ028972; Thu, 30 Mar 2023 16:50:20 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpmpbav4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 30 Mar 2023 16:50:20 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32UGY6Rd016542; Thu, 30 Mar 2023 16:50:19 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3pmyvvms18-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 30 Mar 2023 16:50:19 +0000
Received: from MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14)
 by SJ2PR10MB7082.namprd10.prod.outlook.com (2603:10b6:a03:4ca::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 16:50:17 +0000
Received: from MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::9bf3:e61e:d41e:c531]) by MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::9bf3:e61e:d41e:c531%3]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 16:50:17 +0000
Message-ID: <8f08c42d-268a-b608-1ee2-dad74e26cb28@oracle.com>
Date: Thu, 30 Mar 2023 11:50:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <820f11140138c2deb4a649014556aef27474c13b.1680172791.git.johannes.thumshirn@wdc.com>
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <820f11140138c2deb4a649014556aef27474c13b.1680172791.git.johannes.thumshirn@wdc.com>
X-ClientProxiedBy: CH2PR18CA0051.namprd18.prod.outlook.com
 (2603:10b6:610:55::31) To MW5PR10MB5738.namprd10.prod.outlook.com
 (2603:10b6:303:19b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5738:EE_|SJ2PR10MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 45542abf-9782-4d22-ed88-08db313ed6fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: KLuZAEzoGmxhiaciYl/n62ypvSUqwjIkRmOL9TkWGNpnLMwk8e5iAQd6CogtgOC+RYe9wD4mEGpxktZRqs59WjU0CBUf1oJ8ppPPWQ/3UQxQstIY8h2U3NcEM0wpdIKyysoy0r441kNtbVAf5nHnRwEbKxVFIK934VoOtxWnbubSOs9qyfuNn9bXP7YBC/bTKB2bwZ2H/a+TWOAMWCBfW7ppb1DX0IVxunLnmzWh7dH4kqrHAC4jHha769oUB4mMh9vWbtrMBZaD0xLqQxQ56CZxga5aFk5Am45qojboWtTwT3CksAiDdeDHf6qT3iG5nOBb84HiSmvqLcK98V2162lyyDfHvOvHSVb737RHRIp79cRlojyc/xGjBZlh7gqx0mU0QFfueADgjoARAAcqC5gEBqDpWCduf505hhLfFUpQ0Br4GdR8xbxlaTzor2257LP9ay7NtDcSFhIYnhlU2EwA2MYNvwuDYDewtULbILXNanrcS3VTuQ3ivOW1TqCdvNc9dZbsJ4fYRPaQ77xS0lBZYNKaOebz5y0WOFtExd1CwpDpujV5rnhfTCiWGr9bcLuMFfjC5Tj4K4+eHLdfoJ8zGrg5tGN0zkhek3xk0Pi/oXL0icQCSx1pOwIUK64xMsjf+HXj0SDTZM4Yg7f2Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW5PR10MB5738.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(44832011)(2906002)(8936002)(38100700002)(41300700001)(7416002)(5660300002)(86362001)(36756003)(31696002)(54906003)(6486002)(316002)(110136005)(478600001)(26005)(66946007)(66476007)(66556008)(6666004)(8676002)(4326008)(2616005)(31686004)(83380400001)(6512007)(6506007)(186003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmRqZ2ZQajJZRU5lM3hSdVlEWGt1MnhENko1Vms4WHNOWGN4UnRoZ3FnQ04x?=
 =?utf-8?B?ZVU0TFFFSHRKOTBIeFVJc2xheDVXa1B4N21zN3UxOE4wd2tCOTBweVgwMGs1?=
 =?utf-8?B?SnVUUTBRZ09GeXc0cmEwa3dlUUkraElsNDJGK043dVFIQ1pvRXJuckJ6Z2Zr?=
 =?utf-8?B?dmxhbHBQNUdLemVLeE5ETEd5cXd3WjBCTVFUWG5EaU9SMGczMkFLN25iUmg4?=
 =?utf-8?B?QmV6NmFXU1RWOVJwMWYzODQvYzRDTndKZmxjaFBvbTd2ZUFPNktabVlheEVa?=
 =?utf-8?B?VnpldGpManJwd3ZlQVhTZnI0ZVlndjJ1ZkdwSmRxRVRjVDdVMUphckE0aFpO?=
 =?utf-8?B?ODR6MVQ5TXJFQXN0MkpRdTMwOUkwVjk2NkMrK0NHRUl5RlpEMmQ1UmxZTGNN?=
 =?utf-8?B?RFNmTzJZcUpLem1sUy9FN0tpNGtxRUZDdy8zZkZyeFl0d0VnL3BmNHRtb3F1?=
 =?utf-8?B?ZTBtTFJiM2R6eW9nbTkyNUFZaUQyRU93T01waHRsUkNyd2RHTmxoZmsxSElz?=
 =?utf-8?B?Z2hFeVp1em1lUGc1RUFURXNuUFlwMXhZc1hhdnhvRTJCNXpTU29pLzFIci9K?=
 =?utf-8?B?VDhDdVp3RUxEOGFGOFQwcDRsYnU4K0dKRFdLekUxOWU0ZWFJTFdycUpRNFdL?=
 =?utf-8?B?MzY4U3JBajY1aEdJL1BvMS8rSHozV0hTZnFWZTdsU1FoczJBNkVwSk9iQlFr?=
 =?utf-8?B?TEw0cEViWVBIc0w1YWMvUmdxeWxUZ1BoRndBN2svNnNLcDh6OC9CMWE1T1hP?=
 =?utf-8?B?WVdJMXlsY1c5Q1FFZzE0OTdUbFVVWi81TWFnYm0yRm43UVFvcnB6VlFPRWsv?=
 =?utf-8?B?Y3NqdGFuTW1vL1FCWmNNaDZZdlFhOEtocTFYcFdVSnZtUnlmTzZrQWRzdDdH?=
 =?utf-8?B?aGw0TWNkQmV4dTFwQVRPS1czTzlzYzMxdG5YU2FHL1cxcWlIaStVVlVuNlRk?=
 =?utf-8?B?UkxnTFBRelRyblg2eUdLdVVRUXFkMW9UdVpVQ01YVkFRdGlnV3d0dTJvLys2?=
 =?utf-8?B?TE9DYkhtZ252T0EyTmxHdFVOblVtOHh4cWoyeG1xblRaZ2hOdjNSL3cvUTlo?=
 =?utf-8?B?cXdFYmtZUzA0RVRjSkJRaUpPbUpURTEra2Z3VVBlVWMwbXBnTzFXZFBOenBP?=
 =?utf-8?B?MXVWUCtjMmtpcEh1RnJYeU5vZFZNRTMyNUczQS9ndEZCek5vbDFhNTlCdlFN?=
 =?utf-8?B?aDk0emhCTFU4QkxFcWpWNjdrREE1QVI2SUh1eHp1VUFSVS91QmJqcEt2Vyta?=
 =?utf-8?B?MTY0bk9NSTNMTmdWeXNYQXl4dW9CQ1JENUFWV2pRV3JGZnVMTHV3WkhDUE5M?=
 =?utf-8?B?Njl0NVhGRkt2R2dOQVRyZUJhNkdoK1NQWHJIZWo1NDBWdHVHdUJETFQ0dlU0?=
 =?utf-8?B?Und1ZFE5WFF5UXFCQWRQQTEzMzhlNmltVTRyazF5alAyODZRd0QzNlovZ3c2?=
 =?utf-8?B?bDJzaUhQQ1U0ZHM3WjBmUStCdkZkMTNCV2Z6Nk03c1doUGFZTnd0RXFHeExM?=
 =?utf-8?B?VnN0WHMzMExEb0tHakwzZGFMMVkvbUtkL3lPazN0aEpXL0VLekZpbTVtRFB4?=
 =?utf-8?B?ZmlUdHJaY1RKR3VFa04wdVpwRk0rclMyVnpWZWpmZitkaTZHMlJCZ1hCWVhW?=
 =?utf-8?B?N05WbmFnNk9UNkhuS0NPUUk3T1dtVCtkR0pUWHQvQXFrQUtnTlYybjI4Z2Mr?=
 =?utf-8?B?djVJVkRpNGs0cDN3Zmh0N0NGL2hHcDZDZDR3S0N6RjVPdmptdkZzRnZ1ZnQ4?=
 =?utf-8?B?ZHVSaFhqKzB4N2dtL2hVWlhFWHcrck5tYVFaWnFHQlNndTYyeXV0RjZLT05C?=
 =?utf-8?B?Vm02RnZLMEpueTJOS2ttYnJXZTFlcVgxMTBVV2V3WjkrQkpIMy8yeGtndERF?=
 =?utf-8?B?NG9Xd1V1UTNycVduSk5wcXlCMUxyckhzalpjYVA4WTBrRVFUYWJRek1FdDNu?=
 =?utf-8?B?a0FaeEltSUVGSU9xSXNQZDQ4SjZXUDQ3endOTDFDK21BWmhjeEdaazh1ZjdB?=
 =?utf-8?B?aTU2ZzlkM0JCaXFsMTZ5Q1FsZGoybU5SQUp1b1dHakVqRnlzQmxpYUZtL0kr?=
 =?utf-8?B?U0JHUG00NWpOTkhySnZDWE5Id2c1SmpiL09ZeDRZT1pvQldOK1dvbVlnY1p2?=
 =?utf-8?B?TjRONWlTVFZGRXBvWXYybXRLNXpsdVIvL3ZZcU5ocGtDWmw1WjIxNnZTYXdl?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cXdUR2lVMjI1OFR3UHJTMjdyTFdKQVlTL0hjdHh2bllDSGk4TFNZVVYvRlNN?=
 =?utf-8?B?eGNlL0ZhQVJTNGtiemNEYjZsWEg2KzF3MTBoREFhN3VjYVdYNFc1Z2tGTUZ0?=
 =?utf-8?B?MlI5b3BPbndHQ2dweWpsbng5OERMbzRJdFM0eWZNdmRaT2x1OWMvR1pFblBJ?=
 =?utf-8?B?OXE4Q3d0RUNnVms5TGV0Y2R6ckhlbXVrSVJIV3dvdmxMQjQwTnNwbWl3QnQx?=
 =?utf-8?B?VXNTVWRhODNqRUZsZzhZMWdBYndYUXNTckhhMkx3d0hhUU56bUZ1RDlYZjhk?=
 =?utf-8?B?b21sTzBNdWdPZmNWYjd4dWpQcHRTQnNPeGNrOTQrbHMwTGQ3c2dpRGVZd3kr?=
 =?utf-8?B?OU1Yc3ozNVZ4SFdqZnFOVDNaRVlSWkJlbE5YeFB0WTVOZGlWWW11MUhwVjVl?=
 =?utf-8?B?eHpYWkRSbk9ScHRETzhrR21OaWJDd1JubjNtRmNnTU1LNVhQb2ZsMDdzYkpn?=
 =?utf-8?B?MWcrRlVtOXlIOHl0S3I1ZWxBNlFGWjNuQnpZZlF1TFRxcnRRL0JxaU5QRzNO?=
 =?utf-8?B?WjRUakxBamdKZ1Izc005a1pRTnNnT3FCcExVOTFJOU4vSEU1UGZhUU9POXZJ?=
 =?utf-8?B?TERaZVdEZmszeUwvQzdaejBQTE9WL00vM3dmN29BMGlqYyt5eTBTMHIrc21h?=
 =?utf-8?B?NkdaYWYrZHNvS2hSeG01MzNzeUJLS21ZTlJmR2hHczFUTG5RSkFDYUo1SUhp?=
 =?utf-8?B?TG1rdDRHdWhRL0dPZEFWZzY0WFg2QUZMNWhvbFQ2dE1qWUJZK09YSFBXWnZS?=
 =?utf-8?B?S1NwVG1jYjE0a3h0TXIwZTJsakQvYjVBNkIyZzR2UXg5d0grcnFWMGJjQmFI?=
 =?utf-8?B?SmUzV2pXMFd2bWlvZkVQRGoxSWRkRkFNT0pGZUNWc2ZEUHUyTmI5Vk5keFp0?=
 =?utf-8?B?Z2d0OCsyTS9xNDVweU9xWUFmeU1ZRHdHQTZNbS9mZzNtVmZkOXRlQUszbGxT?=
 =?utf-8?B?NjVKU3dKR3NTL2xmaGduUERxQVJoNkpIbzd2WnBrMzdPamNHeEh6R0ZFdUZo?=
 =?utf-8?B?RDVNM3IrR3FnUGRmMVhMNFg0ZkJMU2kzR0Z2Q2U2WC9JWklubUJocGRYUlRj?=
 =?utf-8?B?OFJUcS9nQXBFQzhoV2d5LzlxMldPTlFPcjhNNUZKOXJXaEhTbGdIaDZNRk5s?=
 =?utf-8?B?V0pnWFZQL2Y1OXQ2T3RWN2xteVUrNFNUblBHMHR6dEZSWStWNHlqVnRWOU9j?=
 =?utf-8?B?U0g0YjVHczNJRTFIck9zR3owcXZBYWl5RCtKeXJ4dHUvU3RMUlpXSmhtZ2FT?=
 =?utf-8?B?MVBvLzJvNkF0dVNzM2NOK2JSYXIwY0l6ZkpLbThRck82TXV5Q3l2YmVTaEs3?=
 =?utf-8?B?U0V3dEZPdHVJVkg1VDBROC81amNWdVlPWHhvMmpnY1RCYnRybnBlMHBTcEZK?=
 =?utf-8?B?NFkzSkozRFptbWs4WlZXWE5ib2xHUGJzaXdTdjZjZGtFWWZzbk5rZFhjTnhW?=
 =?utf-8?B?NTRvcTlMblRzWUV0cWwyWFByNGhMUjRuWTZVdjRmaWxSbUcyRHQzb2dHenZk?=
 =?utf-8?Q?0Yed2KYhkzFZVfMW6dIptBrSXQi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45542abf-9782-4d22-ed88-08db313ed6fa
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5738.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 16:50:17.0229 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mA+BGDOjvIb3Y9V6unZIyg8nzJWQvLd45EfuBCfW4162phUfNQxz+Y4TOgDd3fPp5fsAOzCiTV0cHol8sdMRfnU5rcyHLrZE8cQDUVl8fDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_10,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300133
X-Proofpoint-GUID: 0ZUYaGANpVlW8g4lDHks9yPCbowaWVnO
X-Proofpoint-ORIG-GUID: 0ZUYaGANpVlW8g4lDHks9yPCbowaWVnO
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 31 Mar 2023 05:22:41 +0000
Subject: Re: [dm-devel] [PATCH v2 10/19] jfs: logmgr: use __bio_add_page to
 add single page to bio
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/30/23 5:43AM, Johannes Thumshirn wrote:
> The JFS IO code uses bio_add_page() to add a page to a newly created bio.
> bio_add_page() can fail, but the return value is never checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>   fs/jfs/jfs_logmgr.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 695415cbfe98..15c645827dec 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1974,7 +1974,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
>   
>   	bio = bio_alloc(log->bdev, 1, REQ_OP_READ, GFP_NOFS);
>   	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
> -	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
> +	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
>   	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
>   
>   	bio->bi_end_io = lbmIODone;
> @@ -2115,7 +2115,7 @@ static void lbmStartIO(struct lbuf * bp)
>   
>   	bio = bio_alloc(log->bdev, 1, REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
>   	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
> -	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
> +	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
>   	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
>   
>   	bio->bi_end_io = lbmIODone;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

