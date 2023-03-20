Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09869C6FD1D
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 07:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679385266;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aqNXLp8qMfRS/+W1zqXTJshrkv3Mxs7CADaxNSXmsCM=;
	b=dFFplGtbq+gH0if/BZAednkHxEiNdci6HfUyvtFT1Lc9aApRrtBLesR3F0iVzT7eGMwoAU
	/2LeWUkUTbqF+G5cHuFpflKy1sbLfekCI6flRtK6GHaiphC6rTngiWCDUCcWgJeybBCD4R
	EXjAeUmAcFW9T8roRnGrh0h4t1e1wQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-HuHlajUUOMy6XCJsHYLTnA-1; Tue, 21 Mar 2023 03:54:22 -0400
X-MC-Unique: HuHlajUUOMy6XCJsHYLTnA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68F2A85C06B;
	Tue, 21 Mar 2023 07:54:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 579AD463DF8;
	Tue, 21 Mar 2023 07:54:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 660071946A52;
	Tue, 21 Mar 2023 07:54:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4ECC1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 20:08:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2AFF1121318; Mon, 20 Mar 2023 20:08:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B84301121315
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 20:08:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 943B23801F69
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 20:08:28 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-fZZQ8nzqNtqrcZRBGWTEcA-1; Mon, 20 Mar 2023 16:08:26 -0400
X-MC-Unique: fZZQ8nzqNtqrcZRBGWTEcA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32KFwqv5010251; Mon, 20 Mar 2023 17:08:21 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433m2ck-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 20 Mar 2023 17:08:21 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32KGpRMb036988; Mon, 20 Mar 2023 17:08:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
 (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3peg5nkhbh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 20 Mar 2023 17:08:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB7012.namprd10.prod.outlook.com (2603:10b6:510:272::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:08:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:08:11 +0000
Message-ID: <3660c287-331a-6824-ef3d-2ea02830f033@oracle.com>
Date: Mon, 20 Mar 2023 12:08:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Christoph Hellwig <hch@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
 <20230314171538.GG6780@lst.de>
 <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
 <20230315054042.GA29433@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230315054042.GA29433@lst.de>
X-ClientProxiedBy: DM6PR06CA0094.namprd06.prod.outlook.com
 (2603:10b6:5:336::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: ece04eef-ac14-434e-a64d-08db2965af11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: R+TlSlUdLLSNqKaVN1tGF1/5nSBz4Z1cuvUXpiuldDPg8NZzpGgIURElSu1WZ+l5E4JLBVP4a/mLsi0Kb6zHbF2Bkx06B5tNyfDxZONxUbtElgW33LhNHDFrG3ihlrcho4c240xlK/LKlGG5+vC6prOX6XybI7kUKp4BogHCDQjTl3PMhJXbF32KCKBTpjGIaoKLKxhhvv+KNa4Qdx9l7/1IjW0H0wPCvDIgAWgLl9DDKUzc9pDRGoWYRnH+x/PIVgu1qW605oWjY2oM+alzztyi75h4vc6tP+IlwzhyhZNSe0wOb8TISr+NOJMOnrptrz8oaaSV2XmsTSKzBMGZdNPlgk6DXvz++PRUqPGL+Ok9d/+9fyoI4WVUEyAFcHGBdn3fgvYbRMQ00Njn4+tQJuxi97U4hJpoyDMyOZ5K2Ke+eaggpOdGdZzVC6fSPnCmLTbUBx8UXJJm9/TiadgGylxJcMRaUI4cox+tmKaazf9ldB5HMyBEdy29/pODfbRQndCovprodETVxoGfHYrqGwjZQ0tXTdkmLlf3FOVxNdHw6aGnGfCmRNx3IfTHaWEVKXTFpHq5+2iYxOw8D3D9TXwNKv5tAxAgGXa+araJ6LyuAv2alwH/vgeMzTVx+aINUcTh0msFgl0w+hiH1mkGwPyVRjazifIVtIL8MN/tgWeWVMgZLGq5zNBUL5eBf9isomPGZdqxQkresURaMLZJyASTqHagdjqUqipKHaP9lNU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199018)(6512007)(41300700001)(6506007)(186003)(53546011)(316002)(26005)(36756003)(8676002)(66556008)(66476007)(66946007)(6916009)(4326008)(2906002)(86362001)(2616005)(8936002)(5660300002)(38100700002)(6486002)(478600001)(4744005)(31696002)(7416002)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGJWTDNaenc2a09wMWIrUnNjSjRIbTJneTFiUnRtdU5YalFmUFBFWDJ5K2ZC?=
 =?utf-8?B?WTVseW54MzBEQXdJZDlJK3pEWXJaNnNZQ3l5VGRDRWRTVXk1YmFYQUI4WW5O?=
 =?utf-8?B?WmFYZWtIblZnTnhmWS9oK2JJVXVQNnZMRlVQa1k5TjFTS1B0cTRkenNHSkR5?=
 =?utf-8?B?WStHZmllRWtnVW03VmNCaldGVEZLK2RGUXhsYitnR2x6OTdIMU1WV0JJN0pZ?=
 =?utf-8?B?eVBHYldDeFVNc1N3aFNOOWZ2eGlTQmtOY0M5Nnh2NCtjdE9CTmNJVzUwVnJD?=
 =?utf-8?B?cWZCRG80NG5wa2FpbjZWM2QzcUtYZ3AyY0hFb280WlVVVVV0M1JDN1hVZW1X?=
 =?utf-8?B?MEhYbTJQZUpKMEJvRFFqTWNSSVJ5SVZvV3pPUW1KNW1aRFNPVzVheVRRY21h?=
 =?utf-8?B?b29LVVBSaVV6TDJqUnJGZ3pnd0ZRZ0Uxd3Rwc0p5cndVTWFycDFtTk9GaTl4?=
 =?utf-8?B?L3JsS3MxWlZzZEM2amFTSWZGMGZHa3c3cXBYdjNnTmMrb25VY2Jzbmk1MGtz?=
 =?utf-8?B?dlFqZmVjYUp4RzdvanZpbE1aTHNSTnYrSVB5UDhicnFxVHdoUE44UzB4SXlT?=
 =?utf-8?B?Y3lQUy9KejdvMnl2ekl2dmdVem94Z3lQNUgvTGMxWTZtcFFVNHhybk5sMWY1?=
 =?utf-8?B?a1BxRmJyOWYwZlcveDZwcmN1dTRtZjE5SGNIUkNtZjRDZlBjbWhuZ2oyWHda?=
 =?utf-8?B?M25NNUQ5SXA4Q0htQ2ROOWxZWUtMY0pYZk9MeFFjYllnaDRCOVRXdVdmNnMr?=
 =?utf-8?B?S1dFQXpCejhVM0tWRVFvcENueHdFUUhFZ01jU00xZE53ck1YcHhtMVBoaW9C?=
 =?utf-8?B?TjZDNzAxRFhzSjd5SHBEeE5CRG4vb2RZMlVwSnB4QjlHNjhnaFRIY0FDTnBy?=
 =?utf-8?B?OUdCa3VHMjVySHpRMVVIanZnbHBNRnRzRXNsY0JwaHFoU2plQlFrdHVXVURj?=
 =?utf-8?B?RTFUbEtYVjNCL0VxSTJWajY0VWZzZDgzYXBqT0RpaWlJUGx0SkZRVjlOY1J6?=
 =?utf-8?B?bXZkdTM1dUdmUjNnYXhSWlFUbWNFRGxzdE10UjJKbTE2K0kxUjJtZ1RnVjEr?=
 =?utf-8?B?d0JNSWlNY09GWHN2M3kzNUJHUndRTnAvR0hPb1N1QkxaUkRVSEhXVDhKY3hH?=
 =?utf-8?B?WmFidHVyT3NoM3pqMlhzMkE3a3R1MGdCdDU4bVJYKzNtcGF1eHhVSkM2eGFW?=
 =?utf-8?B?cVY4VW5hdFVCMzNTWlJWWUMxTE1yNFNURm1zSWZlc1RMZUFhMTNZelpUREtJ?=
 =?utf-8?B?RXRXTUZhYUlzMzVkbUtVZEdNUG00UVA4eWZVcSsxTXI5UDBqSk5MMkVKbFRE?=
 =?utf-8?B?Qi9sOGxGbnN3L0IzWS8wdjNHR1hXbUQrQnV0blAySUZ1QnUzZW8rdUkreTFU?=
 =?utf-8?B?bGZSY1JzQngxWWpCVFZsNkc2UjU4QzZMazFjK1AxV0lReEcvSExHcUlEYXNp?=
 =?utf-8?B?SVFsRUtFNTc2RUlFNzRBQ3hlSHNJSUdYa3NHcXZxZFVNdk5FVitucGVyMmdF?=
 =?utf-8?B?Sy9mdDVOajdIOU1jV2JEZ3JmYmRkck42Tld6UnNZd3NwZFRhMGFIYkpjd3Rr?=
 =?utf-8?B?NDR1bEw4dXkrcThVeXpaTWZyVVl2OGNEbmduNWZ6YnJWSmY3Q1VjM01RQVZv?=
 =?utf-8?B?cjRBZkpZTHBSU0YrN0w1cklibTdodFpKUTQzN1Ixbm1xQXR0WTZCNlFzVWEx?=
 =?utf-8?B?L3h1dVg5K3ZobHZSdXFYdUR0VFNZMGVHT3dMT3pOMzZ6bW15cldHeGE2MTVu?=
 =?utf-8?B?UFc2elBsUXN1QW83YmFhSEI1MWF1eXNDcEkwWStQUThQTzd0aGd4QTRRNW92?=
 =?utf-8?B?QzRmNjZmOXJOVUVQNFV2K2JmVkx3czRWZEZZOWM0Y2ZCNTU5RUtmbEQxSlFv?=
 =?utf-8?B?Y0dRZUIwc25GeWZibit1MXVIZU4yZTJ4c1Z4L2xha3NHcndkWGxwb0VuWnhL?=
 =?utf-8?B?bjVELzNURmg5Ukhud2hOQ0w1ZVJ4UTUvRTFGLzBqQjFFdG1iWk1hVmlkN1ZX?=
 =?utf-8?B?aHRuT25nSCs3RFR5OUZ0ajRhZHQ4aE54ampkQ1JMUGR5MHREQm9YMUlvS3Fk?=
 =?utf-8?B?TEhIWVVxWGZpZFRSaVpYSWsvb1F3anZmU1YzRmhjS3FETHp0RzF1KzNDaUVP?=
 =?utf-8?B?QUV5MzByY3U3amh4cGZ3TWE0L0lLVkxKNlVvMEY1VFBUclJJZkRDTmx6YTJk?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SGFURTNBY01CMDY1R2pWR2gxQXYvWWhXZFZ4QlFNYjVVZFdhUlhmM2luUUF4?=
 =?utf-8?B?ZncxODR3QU9BUFg4ZkxFNkFXOVcvZG5KeHkrbjlQNnV1VjZqTEw5VUZsTDU1?=
 =?utf-8?B?SmlDQlFZWEJmOGtKRW4xcnV6ZXhYcG1ITEI0elFTUDEyeFFUOGQyNHMrYkww?=
 =?utf-8?B?VFlPOFZ3RytEMU1pbTVRLzlVSlNSdVhHMXdUTGVGWVl3R2NJS3hxWmp5VktU?=
 =?utf-8?B?R2lPRHFucUJIZnJHTGFpem54NjJ2ZU8yc1FvU2xYUlF6c3lIUkZES2pEcGhT?=
 =?utf-8?B?UUw0Q2VMQmRYWU1reThKRk15NHFCK2thUy9mREdYWGtOaDQ0NFFOckZvNWxF?=
 =?utf-8?B?REs2a1lnMktORWpwTnZZaVlOSENIbVd3aXR3Qktyb2JzOTQvRUw3OW9HQjR5?=
 =?utf-8?B?RUNtdnd6ekYydVJSNVJYdHdsclM1NEE5VSt0MFV0cUNGRFpqcEF1KzFoaHgy?=
 =?utf-8?B?Y1RRWEVQY2ZTNVcwWVp1UTNjek5VN2lpZlJaVDI4T0ZwdUVzNkhZem5md3Jr?=
 =?utf-8?B?TjJ5WVZMYWNjbnFMM01hYkhqYXp2Q2dYU1gyRnNkRUpudU0yWVVHTmd5a3I2?=
 =?utf-8?B?N2lpUGJqQkVVTFFaMERQNXpxVjc4QUhXRFJGSTBFc1FDUTBLb1RiMTZmYmty?=
 =?utf-8?B?cVZjV3c1dklzS1YwT2hZYy95c3FWOE5tbGVaMGFNNmpRajdQeUk4VEx5YlBC?=
 =?utf-8?B?MjJFMmdHZG8zSFN0OC8yVy9lU0R1VVVpTWFyOC9TVEZTYjBJM2N5U3BQZ1Rt?=
 =?utf-8?B?bWh2WW9sQk93Wk5xcEJYUko2MVgzbDZoejk3NlB5RWZyc2drenErdUhuSkdZ?=
 =?utf-8?B?SVBtcnBtQm9BYnB4bGlSaGdNeHV6TEVET0cxMEJsdk9OMTJYajBhR1ExZFFy?=
 =?utf-8?B?ZGQzTnRqMXhvSVNFZDQrTnFoVDNqWjhvK1dzUUZOWkxVeVprY3h3NDVmdSto?=
 =?utf-8?B?Wm5ub1pZS29DMVRrY3NnTER2bEtESmxENjBBSGMvZUVaZXN5Y3drdmZGdDlB?=
 =?utf-8?B?N3dITVFnOS8rQ0pJbnZOUms5MlRvR1Y4RHdqSUtIcnJyeHhZaUZuK1A5L3Nn?=
 =?utf-8?B?ZjRZdXhBZXFndlVMamVvT1pWZC9yalhTdGpEbHBJSDR4MmhKZDlYbSthbm11?=
 =?utf-8?B?eS9ack5KckR2RXJ5cmRJdFFydStpb2tVWkdCZ0UzNnc3ZkFTeEpDZmd5M0cv?=
 =?utf-8?B?YXNKMTdVQUhYajVYWkdIVEtUNE5NRWFnUjYxVjVLWFUrOUpWS3JBYyt5dGFu?=
 =?utf-8?B?VGc5YkNjTENsVHBMSGpxWTdXeEZlNXpzdVZjTHl0VEhmZ2c4bFdSaEhoUTZt?=
 =?utf-8?B?RUxwNExtQWRXVlBpcTFYVjg1YThHbnZjRnBaWE5DbW1Lb3dNUlpxbGppNStZ?=
 =?utf-8?B?a1hRcUlUYWFmK1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece04eef-ac14-434e-a64d-08db2965af11
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:08:11.1005 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1neE5D+4QI3SLFudblHW/NuQYUT8EPpnf4G+dGVkt7pMeNUFmVxLZ5biE4vlZFvpfUheKrMoH34idCFyh/KHD3zWIj4KQ+Oq+ALyrJ0CPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_14,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200146
X-Proofpoint-ORIG-GUID: PUs8LeBzqv8Y4iX-D-yKj8IzZm6G7qR1
X-Proofpoint-GUID: PUs8LeBzqv8Y4iX-D-yKj8IzZm6G7qR1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 21 Mar 2023 07:54:06 +0000
Subject: Re: [dm-devel] [PATCH v4 07/18] nvme: Fix reservation status
 related structs
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
 bvanassche@acm.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 kbusch@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/15/23 12:40 AM, Christoph Hellwig wrote:
> On Tue, Mar 14, 2023 at 05:23:16PM -0500, Mike Christie wrote:
>> We could do separate structs though:
> 
> I suspect that's probably better in the long run, as the [0] notation
> is on its way out.

Ok. I was able to use the separate structs and then use [] and struct_size.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

