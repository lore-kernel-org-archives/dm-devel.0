Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16AA8C74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 06:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680069948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7xRgCI32jOtrPFbhaNrHusRSRNlqP9KvLhPcqnbjles=;
	b=JGGJcXi/1ztlniW0/PQ5gg3ERno3DWlrwAcAe0MB/AIRK3cQSFWD4jWjPyL2IA+wlQnW+S
	gfkcYtxZMDkTd4Qgk/2aiHW2L1D+9TJtMFhGohtk8JpotRjCKBhoYmsw0gX10REMSzCo72
	wq5vtVTHcxh43L65sjjEstvAvwiHuoM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-UWIg0yNnMSGdTkVI2XlSbw-1; Wed, 29 Mar 2023 02:05:44 -0400
X-MC-Unique: UWIg0yNnMSGdTkVI2XlSbw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF3EA8030A0;
	Wed, 29 Mar 2023 06:05:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3214E492B00;
	Wed, 29 Mar 2023 06:05:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07C1519465B8;
	Wed, 29 Mar 2023 06:05:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C2B7B194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 17:19:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1313202701F; Tue, 28 Mar 2023 17:19:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A78202701E
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 17:19:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6592087B2A8
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 17:19:27 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-BZAhMe1JPQCXfcfcIU9v9g-1; Tue, 28 Mar 2023 13:19:22 -0400
X-MC-Unique: BZAhMe1JPQCXfcfcIU9v9g-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32SH4lgd021895; Tue, 28 Mar 2023 17:19:04 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pm4ad81je-30
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 28 Mar 2023 17:19:04 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32SGneED009437; Tue, 28 Mar 2023 17:11:29 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
 (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3phqdd7fca-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 28 Mar 2023 17:11:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6374.namprd10.prod.outlook.com (2603:10b6:a03:47f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 17:11:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425%6]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 17:11:27 +0000
Message-ID: <204ac74e-3d49-5fe4-c819-cbbbecfdcb29@oracle.com>
Date: Tue, 28 Mar 2023 12:11:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Mike Snitzer <snitzer@kernel.org>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-2-michael.christie@oracle.com>
 <ZCMXecSrJ97oCD+s@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ZCMXecSrJ97oCD+s@redhat.com>
X-ClientProxiedBy: DS7PR03CA0257.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: 103e9e42-02ba-4443-581e-08db2faf7745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: aQMLRCkUR82c7cDlOYr0yJnjmjCLuo7ABEtttXHZQqsJDPQulnN28T/ORZ+UIGDKYexO55r6GG53Rh/GEEjghdqyulbAhm+09LwN1BrfwQuTX7+BibrznRJDj3MQ0Sxp00EbtbJ686ljximK42CWZ4iA2/6/9+a8r9EUNRKT+KZqJoR64OzO6zbkEc6O9VZrkgPq8O5AQ6wgL5/EPfziNr1R42KQieHpW6N4a6LgvPHew7ACDVr/94tI1pwwfUeZNLje3gX1mW4jqv7uZMv0vfn99Ymkwj8cnRfVjIlMYVG0seObi0t06llz/h4NMyG6XJ9CtX3HcBcUcJO9e6xT1ECNLB9DdsvsHdnY1zRolqKskKXUGfUjchjDJ52Qfx9K81EKy7K4w34BWpR1mMuk3AIpr7VCBLkd1YClaMbMsxuar8Dckc7+CbqdxvkK+zPcDMT4/7JzLTWWIDTzDKu2oh0ghxD2+bMJEfPS/M0QOWgSGwNLkaxxEJnFSRQiOg666aNelFj/FZVBsQN7RbnB2ZQtVanUrfdS4yDZtJKohvE4D1s8pXbkEbgn+EyXhsPvseLI1c9ZTufm3Co0gvwO4bQkkZ5+PYd73ATEO/Sm4Z1PycZWnFxFfpnW9ijpQ3O3/LlaL+5ctzn1n5bIi0Bfrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(2906002)(83380400001)(8936002)(7416002)(5660300002)(36756003)(38100700002)(86362001)(31696002)(6512007)(53546011)(6506007)(316002)(6916009)(66556008)(8676002)(4326008)(66946007)(66476007)(186003)(26005)(6486002)(31686004)(2616005)(478600001)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2lZZGMwZ2NReFllVDFYK3BkRm1mL1d5RnBxRlhtTkFRMTREaHFVSmZPUDJS?=
 =?utf-8?B?NWNScDFvNkpzRUwrUEU4QVVpazZBcWVSdGhNVW0rRkljYkxsaDZMblB1ZFdl?=
 =?utf-8?B?ZE5nWmFEMVcvWjNDT2NPcUtRblFYS09YYXBZVGRqVW9NTHF3SmdPbHlIMitt?=
 =?utf-8?B?UEVRamljdkhCcXgxRjhtT1IxNnJ0YWFkcU81Um55bGVqNDFLODNQN0dRaE16?=
 =?utf-8?B?MThPWHNtMGxCS0hvdDNxKzY1Tlg1NXI1dTlUUHFCNnVmY0EvRXZtbXJMYm5q?=
 =?utf-8?B?eWxodWIzWG93Smk0ZWVkOFpjTC9XWTMyMmVLdkRJWjJJNVhvYzd5SFgrMVBU?=
 =?utf-8?B?THAvWTZwWU9CSHZldm43WG45a2FLb20renc3OFE0eDFKYkRIcTc3eUE1N2Rt?=
 =?utf-8?B?UUQyeDcxK0VSaFExeWlTMzI1bFJFc04zcUIwcDJhbmpBemtCSmxrakZ1ckVv?=
 =?utf-8?B?ZDI3N0tTUEZndlVOOTlFN1didlNmb1NrM1U4RzRLZ1p3UlRtaFZvZmZMYlBk?=
 =?utf-8?B?TnAyUHFOSDdVSFVRL1ZBYVd5T05LbWNEUU9zNFNoL1JaOEI2TGh4cE52ODA3?=
 =?utf-8?B?am11QjRZSWlhNDIweVhPclZIRHpEbHV5V3dQbVVCclU5RW5sRWFndUthekJG?=
 =?utf-8?B?Z3lLTDJTdCtvNTBtS09uLytvZmpCWHdPc29tcVY2SlFkQ3lUUDQxelBsdkMw?=
 =?utf-8?B?ZXd5ZDROWlBscTJDRmhLL2loTXhkL0N5UWNHTFJ3S2dyVXlKbXUyNnJQaXdY?=
 =?utf-8?B?a0RSZFZmUkR6ZTUrUWc1NGhSRVNubnlEbmRKMDQycTg0eHRIWHQ5NlVOV1pM?=
 =?utf-8?B?a3ZYVSswR29FVktHSDRNcHhsYzJCb1M4RDhETkFEellUaU00VWhNUmFlQXk3?=
 =?utf-8?B?a1B4UjhmZE40NU5uMUNVem8rdGxmY2NmVllzcmNRUGlHS3A5NkRuc0tOZjVU?=
 =?utf-8?B?MTlqcGFJSko0U0txalFRTWZBbndnZzhaTzJyZ2dhaFdNRjFrajNQV0tIQmI3?=
 =?utf-8?B?VUwxRWRRNFdkZTBZYlNQUmJyTzh6OGx5ZGlHTjZSSEtqendZZGZ6dEFNdE45?=
 =?utf-8?B?aDlPVDVtRy84MVpLbzY3bWxnODNud2pUTnpRbDYrWEdKdXB3TlZBanFkWFdl?=
 =?utf-8?B?WmpqUDdibVhPNWJoelJoUWRRcUhKbXVWNDRPMmhiUUUvK1lsVHcvaVZnSG5V?=
 =?utf-8?B?VUgrWXlQUCsveWhaMEovRnM5ZnozT2UwbnRPK1VGWEdpVXJqZS93ZHpDc2ZZ?=
 =?utf-8?B?emszc0FpNWFSbEhvUStONVNyOUMySTZWN2RadFZOczAzejFGcjEzdUhSdzJN?=
 =?utf-8?B?OW8xMERobXVVS2NKS3JZZTR3S3EwcmJkaFFoclBRUUp0OFUxYTF1ei8ydzgx?=
 =?utf-8?B?dTQvOVdoZWF3M1o1NEM5Yk9VaEk4eTVteC90ZUN3MDh3T2lZRXZKZG9sRlNp?=
 =?utf-8?B?Sm1DcHJrWXl5L09QMXp2Y1h6RTROeHBvWnZJUnBSYlYrR2tWSEFmNHlSWFN2?=
 =?utf-8?B?YXFyTmpLRFBEUm96dWdyNDZpSmdCdzVlUm9ha1JrakxaVXNBVFh4Z0xWdnFY?=
 =?utf-8?B?ZE1xUXRtcUZ5QVZLQ3k0czlPU2UxZ3prUjVtWm41RlViRGkreUwyUjJzdUxC?=
 =?utf-8?B?VmdpWE5CYmc0T2htbjNkeTZ3SzgwR0VQOEQvaWw2K01lMTFYYVRwWUF4YTNG?=
 =?utf-8?B?eEpkU0lJcHR0anV4aVJCaVFoVU9vZ1hiY1J0YUZEdE1aWkdFRmJUWG9PMjBN?=
 =?utf-8?B?aURubmRCQjRIcVVMU3FJaHdUR092VDZ3Z2pESHk3WitlZjNHemZHRHNBMDlY?=
 =?utf-8?B?UVVMWXJzYTE3VWtMS2tnS2FNdGtueTgrNXBIcTRjODE3M1RFU1Z4cElldndS?=
 =?utf-8?B?cEhHZDlJUkNUMTdhYXQ4MHRhSzUxS1o0bEVYMUp6TXdyQnlXckxtbXdpV2dC?=
 =?utf-8?B?M2E3dHZtVHVscjI0YzNFVDRNeUJUN3VJaDJjSVhQR3lRZ25kaTIyV0FJT1Az?=
 =?utf-8?B?ZmtOV29MNjlxUWtoSW5aM1ZlR1ZvbzdlRFdLbFdxOEZvRGwrSG9xNzE0em9u?=
 =?utf-8?B?NE9MRGtQRjNzOUxOOVJCZTZPdmk0aDlUNkdoQTdFKzNKRnJRM1I5STRQbFZE?=
 =?utf-8?B?RFdOaTUveTNDTFB4d0tEZldGNktRdGJVRHZCY3FUaWxxeDZrWnJ0aXdGRnZl?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZlBLNWxqUkpUY2VzZ0NtL2pxV2tOOW9jekkzNmpxamhVVFozSFFmcTVoc0Fl?=
 =?utf-8?B?eFlFSVNHMnpnbFhtVVJvZlMrVDUyWHZpdklKcENnQ0pHb2ZtMWNWdWEreXVO?=
 =?utf-8?B?Y2Z6MEo1S2ZQKzBCNUFLZHlua3UzQVlpWG1iYVZQTFYxU3ZaTHNxaVZ0VHNO?=
 =?utf-8?B?SFN5VVpSYVBERHBxdDVJa3ViVGVsRGJ0RGtzMFlFVlBOa1VDd2VNQjduWHpm?=
 =?utf-8?B?VXF4TE0vVHVJQlA5anNZdlh6Zmx1enc1bmVtbjRSaDNrZzFrN2dRdHl4YzF0?=
 =?utf-8?B?RSswbjJQWFhrYURmZTc1ZDZZemZlMmNDOGUrbC9icHlvSmNKR0Z0Rkp2UnAv?=
 =?utf-8?B?TjFtakJIL3AzaGVwNFp0RzNFa1pkcmNjK1ZGWjVvbEdPZTQwMmpBMS92VFBw?=
 =?utf-8?B?SzVEK0pibnhEYnF1R245a1VMZUNzRG5jc3RmUHQ1K0tVNlM1MGdyb2MrTWRa?=
 =?utf-8?B?eTdJU0xVSkMwNTBmTVZqR1VHamFsZ21zMnJoMnhqaDgzbXVUbC8yWHVQY3Zw?=
 =?utf-8?B?TWdPcytrdmNXd0ZKaGFhNlNYanRmRTlDcVU4eG16M3RhdkIrUDJWaFoyV0hm?=
 =?utf-8?B?UWZVdzQ4eE5POVVFS3ZGT1lPMkNIRmNWeWN6c3lKS0VaeENoOEhPKzJ0aVpl?=
 =?utf-8?B?NHZOK2xjaEs2Q1JxejJqYkNvTjVWcXdQWXowL1RubTRsUlhtZmRna2E4ODhh?=
 =?utf-8?B?bmpHRGhFWDh4TG1QNzVoLzB5WUxCdkRKVG0zcGhVVnJQZ2JwdEtwZXFuMENr?=
 =?utf-8?B?cFUzKzJ1L0VYeUx2K2hOK0ZJYUNhTmo2cDBEVWozbFBIeGtJVGoyN1R3TEZL?=
 =?utf-8?B?SG5BUmV2UXU1czV0dEhCeEJucnRObU13bGV4WmZLYXFjbEZlOWcva1h4bVVN?=
 =?utf-8?B?ajk0NkhNZ2podUVtMkloYUt4d3VYUHNaU2srM0FLVkxiM0NKMGJVQkZXV1Yv?=
 =?utf-8?B?M0NnUzg4WFlTcU9VQm5qbTFtN1ZtZ3VhUzhUdXd3USthOFl1SzkvQnBrK1Fj?=
 =?utf-8?B?bW15RXZUSSsxbUowckJjSnJEb3Vna0szN0JaSndiTUR6WVJvb25hUnp6WWMz?=
 =?utf-8?B?bEdvRlRuTENhSjF4OWZGeHk5ZjJud2ZzQ2Q3a3Q0b0F2UUtTZDhFNGhKYjBO?=
 =?utf-8?B?OWxRdjU1REw3VjFtTDByRHI2UUs2RXRxRm5zRWtLMVhKeGl4R0cvMFllRkZj?=
 =?utf-8?B?bklHOHBhcnZ3WENFejRzMHJ2Vmo5L1BlT0V3dStHanFacTZZc1JqekR0UEpu?=
 =?utf-8?B?eEdjNEdsNjRjVkYzZlV1cm1TMUt4R0p5Z3I2ZnJyR01jemxoV2pEdGljOGFI?=
 =?utf-8?B?OElWOU1uS3EvYVBqaGdKMkcyZjE2aWNPeThFU2RZRm5oYUxDVFRaQjFkWGs0?=
 =?utf-8?B?a1NhNWJEU0Y3dWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103e9e42-02ba-4443-581e-08db2faf7745
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 17:11:27.1570 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXaqQjjw6/meGnr+7RGdFZLBV7rF+82QVf0usBhFGWdlYu8uFWEbSbJ4pgPJJglvxlhxZX2pjbCTiBlNhcD4b5ObUFLK87ncrOTQ5rtiYgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280134
X-Proofpoint-ORIG-GUID: uYTDee_dHYpaiV4g25dN4xqp2ZTTqBBp
X-Proofpoint-GUID: uYTDee_dHYpaiV4g25dN4xqp2ZTTqBBp
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 29 Mar 2023 06:05:27 +0000
Subject: Re: [dm-devel] [PATCH v5 01/18] block: Add PR callouts for read
 keys and reservation
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, martin.petersen@oracle.com, kbusch@kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/28/23 11:36 AM, Mike Snitzer wrote:
> On Fri, Mar 24 2023 at  2:17P -0400,
> Mike Christie <michael.christie@oracle.com> wrote:
> 
>> Add callouts for reading keys and reservations. This allows LIO to support
>> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
>> to optimize it's error handling so it can check if it's getting an error
>> because there's an existing reservation or if we need to retry different
>> paths.
> 
> Not seeing anything in DM's path selectors that adds these
> optimizations. Is there accompanying multipath-tools callouts to get
> at this data to optimize path selection (via DM table reloads)?
> 

You can ignore that comment. The comment was meant for the dm pr callouts
and not for normal IO/path handling, and now I think I can fix in a different
way.

I originally added the comment about better dm error handling for something
like __dm_pr_register getting a failure when it did:

        ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);

Right now, we fail the entire operation if just one call on one path fails. With the
pr_read_keys/reservation callouts we could check if we got a failure because there
was an existing reservation vs a retryable/ignorable error.

I forgot I wrote that comment about dm in the mail and we actually don't need the
pr_read_* callouts for that type of thing now, because I ended up changing
the existing callouts to return common error codes last kernel. So I have another
patchset that I'm working on, but am still debating about some issues like:

ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
switch (ret) {
case PR_STS_RESERVATION_CONFLICT:
	pr->ret = ret;
	return -1;
case PR_STS_RETRY_PATH_FAILURE:
	/*
	 * We probably want to retry like how we do for the pg_init.
	 */
	....
case PR_STS_PATH_FAILED:
case PR_STS_PATH_FAST_FAILED:
	/*
	 * I'm still not sure what to do here, because if this is the last
	 * host then we might want to try and register the rest of the paths
	 * and limp on. It probably needs a user config option.
	 */
	....


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

