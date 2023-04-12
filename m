Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49B2C77B6C
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 06:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681368916;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9I4j7fuUY6XwQis3GjQHURJwm4g9cwo6Tom0KMPQy9s=;
	b=R0rtybLMe5jRBi7djYucTcWghmGCre7xNLl12n0acHDXkZpdHBOU0J7UArUirQH8lRVitk
	4PTD8NOVCv0yI2qGaR2aza3L1WLGF8gLJLWaYtp1Ni95Kn4hDqZoaQZbu1mwmjvfV5vFds
	V0QoZlHSFawbdOt+M53GqEXeONfzLl0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-cKpAu4E7NDCVacClIjiGXA-1; Thu, 13 Apr 2023 02:55:13 -0400
X-MC-Unique: cKpAu4E7NDCVacClIjiGXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE8CD1C068E3;
	Thu, 13 Apr 2023 06:55:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9A2F4042ACF;
	Thu, 13 Apr 2023 06:55:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE76719465A2;
	Thu, 13 Apr 2023 06:55:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7CB21946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Apr 2023 18:29:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9997F2166B29; Wed, 12 Apr 2023 18:29:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 915522166B26
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 18:29:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E575185A78B
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 18:29:16 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-uNzRdfP2Nu65omb_ZZjnQg-1; Wed, 12 Apr 2023 14:29:14 -0400
X-MC-Unique: uNzRdfP2Nu65omb_ZZjnQg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 33CHDrQX012022; Wed, 12 Apr 2023 18:28:43 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc91ky-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 12 Apr 2023 18:28:42 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 33CHBSdL017471; Wed, 12 Apr 2023 18:28:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3puw897kvh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 12 Apr 2023 18:28:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7513.namprd10.prod.outlook.com (2603:10b6:208:451::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 18:28:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3%10]) with mapi id 15.20.6298.030; Wed, 12 Apr
 2023 18:28:39 +0000
Message-ID: <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
Date: Wed, 12 Apr 2023 13:28:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Naresh Kamboju <naresh.kamboju@linaro.org>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230412093617.285177-1-naresh.kamboju@linaro.org>
 <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
X-ClientProxiedBy: DS7PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: f118d117-1ea1-4028-9440-08db3b83bc66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 4Q4P+PPvhAPRe3fGn+8B5irB2ovxt4aIfkm2n4qUuHdh9ZBM7UQygl2v7ehun2DdHXhiCnSz6sSVMptqf20BJ1jugUo0DJmzza/arhDGNlm6PVi+NMz1drAQ3Vl7LVHPEV4mzVU7jL84+p9ZaHP6qtpQxt/7jI5NAyA9SBkaNF/vM+oXrqlB73JV3KDdtJdo0r//Tp2/jvnPVMQNGqLCRlhfg5UWPX26Xa7sOlEMwZTLWLvR4H72Q7em5kyft2VIjerIP2eWDfflsqJJ9EEBU+Xt/PIJSMRIZJXJWSCgSi5kkBA/HNvUfhI43F+N9plyvEhSAucBsN69QScwld7AMbZahsf0kNTlY46kFh5zSifpqaPaTEL71oZabb6ziWtfjhgCD2gvUMKhmhmUaAbXZ/xSkSMlK2JYTh8B4TdY5Gzq/8J1PlJu+w4p6D1rM0m9aFxKZkjeilh3wePUe9NaBnuMIyrkyqrR4vWTiapNx5M8bFj/YEPbguzRixR+HZjLBymBs1ftYj6vYHRP/lQNqdTiyO0wzsRu69QpEo28U8Ssg1hHuZ/dllHIMGvBxIcP707gmZeQgQo2v+M1T9FEMjtx/BYBmRqY8yoObE7Btxd9w1xfD9wbjlzHHo1U9stl
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(31696002)(478600001)(53546011)(26005)(6512007)(6506007)(5660300002)(186003)(316002)(6486002)(966005)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008)(7416002)(8936002)(41300700001)(6916009)(86362001)(38100700002)(83380400001)(36756003)(2616005)(31686004)(84970400001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1dsUTlxWURMRmN3eXllUVZieUorQWxlZ2gxYWl2aXJiNll5d2FGTmdoNkx6?=
 =?utf-8?B?RURoN1I1YU9mNFhOWU54QnF5M3cxcmJaRmthTjh5bmRpT2ZIVStpNzUrem5j?=
 =?utf-8?B?TmUxRWxDRU5GVW9VMm5pU0lkaUpDR1BPNHZiNHJXWGI5eXQ2a3orVzVFL3FV?=
 =?utf-8?B?bVJ1SmxneExYV3o0YzZtZ1BjQmtUUlBmVmI1T09TQUFkRys1di9GR29KdFFo?=
 =?utf-8?B?aklBZnBxcFV1ckpaUS8zVUs0WWhhanhYL2drVWxKM1ByeXBaaWlUS0ZZOEY3?=
 =?utf-8?B?ZmtIc3pPcXJNZ001UXRRT0p1dTJ4cG9Pa2xCTnFldWtzYUpKQlJTMElmRlFx?=
 =?utf-8?B?eFhKVTFIRGsxT2RTMS8xUDFQSUJvdHdPUGt3dXNBcUtEU05yOUd2SFRERTEy?=
 =?utf-8?B?aWlUK1ZjMFVSdUVuL01MaVQzemZDc0JJRXptalpDTExNUWE2TmdEOXA1S1Nm?=
 =?utf-8?B?aHRpelZNV2FJTVpvZVV2cDJUOVl4djJjSFZNbmwweldSUkRCblVXdVRtZnFh?=
 =?utf-8?B?czVMaFdXWHlrRHFONmRoaTZudDlSd0I1cDFxSFZHODMreExSMmRYOVRzS042?=
 =?utf-8?B?aHBFc0tpTWNTZnZRcmxwemo0NE95YmNhVTVLNG1KaUZ5d1V0eS9rdXFjVEJW?=
 =?utf-8?B?MDI0U0piSUtwTlVlNDRhdVIwZGlLZnVzKytnWDhjQk9SelNGcUIyU0pRdW5t?=
 =?utf-8?B?QjcwQUVOZ3ByRDNHSGhhY1ZSRE1kQ3FpTjBTd0VOR2NEb3d2T2xGR25tazZ6?=
 =?utf-8?B?LzBXSFA4SWRjbC8wd0pLdlJ5WHNQVGJDUjhUTk9JSXA4MUY3czcwWnJLanVL?=
 =?utf-8?B?L1ZFS2VlaU1zWTJvYUowM1RXQkdoS2lheEJac05wZ21iRGcxSUlCZHdPWGtG?=
 =?utf-8?B?UXVTZUgxNTUrVFdYdUxXS3lsSE1JSjNJY3R2aHYxRWV0WGFGQ1VkS2hQOGt4?=
 =?utf-8?B?aEowSzlhUm8yL1B1MmtXSCtMWjNxTWlFbUhVKzBpaGJlUC8yOVZmaitBbXpS?=
 =?utf-8?B?aXRpZDFQdHFZbHd3aFhIeW95OXliYWM5aE1WRWlHYkJMendkZFBkNkVMaHQ0?=
 =?utf-8?B?QUw2ZnQzMUM5UnVaSEw2VlFjSE1mSjhkdzc0bXhOcEY0cnlzWnhEbUxXNHF3?=
 =?utf-8?B?MHZLMG1NdUZ4aENoWTBPZzRKZTVjZDBYaTQrMitrSDRiUVRlelN1L2pZR1Vu?=
 =?utf-8?B?SXF2WHpXWG1MQXQ0QkxjSzBlTkdoMVFBcGN3WEc2Yy92R1dyblBoN0N4dFA0?=
 =?utf-8?B?aHhUMElOYnMzQ05PVEV5Sk5lUWZ1OTBQUDVSYjAweHg0TEhUbXVYdmlDTUg4?=
 =?utf-8?B?cDM1UG9zMDVXVk5xRWdwRkFKRUhrNmVDMjFiN0VsWWpLT2NCNUhFS0g4SWRY?=
 =?utf-8?B?bGVzQWtOazlGSEFSUWxJSnBKUHR6UzMvUnVPUWd0Ui9OU1NXZmNpMU9iNTVs?=
 =?utf-8?B?bng5ZHZQd2NZRFhDQ3ZaUnNKTjBPZ1padzJrei9jRjJKbzAzL21yUnZlRFN3?=
 =?utf-8?B?RFZwcTZRbDkraC8vQU15emhxZzd6S3ZmWC9iRG45aWJ6QTdGdlFUMTRYMHJp?=
 =?utf-8?B?M3d2R29PNkVhUHAyVk9EaDlnM2pYVEZKM3hMa204aFRBODM2QUNpbk9tcjVj?=
 =?utf-8?B?RUFsZGtxa1YveU9LNVBnaEt3RkY4S3NzVitaZWZYanZJYWJFYVdwVW1xcmlq?=
 =?utf-8?B?YjRyZURkKyt5NTlyNFM4QlpURDVTb3JzSDk2OFpRUkcvVGpEYTN1blFlRG1C?=
 =?utf-8?B?aSt0V0UwZ0x3WUd3ZHluR3lwSjBDRWFudFd2Q0d3WkVVV3dWQ2dvNWFXLzQ5?=
 =?utf-8?B?Q3VRaWx4QWxQenROUkJOVEYrdGFONWROYzAyUHNJT1NsSElxMGlSOUsvWjZ1?=
 =?utf-8?B?S3dWeXNEMHpVeHdLeTBURU1Eb2xleHowVUhXcVRLZWY1TXFDN1NuNXZyWFlq?=
 =?utf-8?B?STJtOFlBQ1Y5VHgvUGJ0NU53YTlzZXJRbmNoZ2tkNUUwUUsrTGRWUDhVNHda?=
 =?utf-8?B?K3FJTnBTaHlBYklaVHdjSmJhTjZibnFqUXJYbE5Oem96ZXc1U2JIQ1lYOFEy?=
 =?utf-8?B?QVBTeGtINllhekhlM1FOeHhzQnFvQTNxNVBEUXdlcnp2bVFtMkNROXJ6czFi?=
 =?utf-8?B?V2FvTFJIckpSQktaV0w4aXhFWEZDYVViRks1R0x4L0dWcHROWmFFS2F2c0Uv?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dzc1b1JzV3dEK21oSXlHYVpuQlB2R09ZM2FLRDhibWFTMWRQYnprT211WG80?=
 =?utf-8?B?ZForTG41cmVyQ3lqUDE3ZnBleDJ1WFhpOXZwaHBGbDJ6K2NQQXFhakw1WWNw?=
 =?utf-8?B?U2RlRUVYZStjbFM5ZklmL1lKVSt4Yy90Ky9haUdvdTV2cTNYM0JnZWVQdlow?=
 =?utf-8?B?MlB6STl6MlJiUDJqRzk5UXQyOGlwVVNSV0dsL0laTVVNY3VzT0ZTWjdKKzAy?=
 =?utf-8?B?dS9FTjBEZGlHQTA3Um0reWFXNW0wNHVmU3o1MlFlSVBYZWhXcDRGa3ZDRUtI?=
 =?utf-8?B?eVh2NDZVRG4vaDREQzRPVlFiOXd5ZlR6dG94Z0hGQ044c0hQTWdRaVVQRTBm?=
 =?utf-8?B?dlplSElIeWFTMmtKS0FtWitOQk5GVnpCeFJMNnZLQWJrUjZaczVKTXhoclUr?=
 =?utf-8?B?N3BsWFYzRTIzY0pMbzdpMVlOTmQzU1hsbzhCM21Lb1BVZXZUamZYbSt5REFj?=
 =?utf-8?B?Skd4eWhWOHpuTnp1MmNva29Ed2tEV1FxdG5DL29CVmdRYzNoVXhxN0U2RHYx?=
 =?utf-8?B?blpvR3FKV1dzc2FxNkh4TXZvRXVpdGMwQXJVT3RXTUJRM3FNclRlT25TLy92?=
 =?utf-8?B?Ti9GR0FwN05GKytJbm9TT0ZFc2VrRlo3c1d3c2x1WUh1Wmo4KzlkRmRIVTAr?=
 =?utf-8?B?djIrWHVnOVZ2ZGVnMVh5Ym1xYkRKdDR2Tk0zRnhsRERtOWhFb21LQUQrbnVw?=
 =?utf-8?B?SFJZYTRIWWluYnZVbTFuOXJYK09mUUZmWjJvWHBhWE93Ui9ucFZDaTRPZzk5?=
 =?utf-8?B?YUFudzJDYlZIbzlveCtpOFc2cmtCSWJkcVlTTzNWU2M5WkUzRnorK1pvcXVt?=
 =?utf-8?B?T0E5Q2hzZzdlaE1mRkEzRjQxL3JhREtUUzlzM2hPc1NBbHFPaEF0Y201RGIv?=
 =?utf-8?B?RXVZL0hsTlNqRVhuQmZVb1Y4WXdCTnhoNS81SzdEQ2pWMXE3Z2owTWxOSXhZ?=
 =?utf-8?B?Rm9oSGNWMlNTV25Zb3ppT1dPSFdtYmlZaWJMWTJsSE9Fa2dtNE5CdkppT1Fj?=
 =?utf-8?B?Q0ZwcEF4Q3dnNTVscklVWEpyVjFseGs2czM2ZXZUc285VnhROEhoWTRSd0NX?=
 =?utf-8?B?YUhkSWVkbEprbGxkOU9mY0pyRXZkblR3M1BNY2dYRU5hbVI5YWw4SG40RHZ2?=
 =?utf-8?B?Rm5BeVBOQjQvWTAyL2VqbmlCcmIwU1Q5Q0N0VkVETkdsUmpKcGh2LzdPdXBO?=
 =?utf-8?B?S3gwa0FLR3lIRHByemFPQ3ZnaHkwTGttdEYzcTZETGY2T0dQVHlyYXB1Q3BS?=
 =?utf-8?B?bkNESXM2YzJabkdFdGluY21RWWN3a3dkWTk5NXo4dzh3Z0ZNWnJBTzd4Y0tT?=
 =?utf-8?B?bG1Vb3pPbElEWlJxWUZjNWpoRm15ZnNOUnErOU1RUW1weHlMa3V3bk56TXZC?=
 =?utf-8?B?ckl6YTZmci9KcG1jbDJlTXVPS1g4czVDWlJueHdqbVBFc0lqZlBlUTBQVFhB?=
 =?utf-8?B?L2FaMS9OQmtOdlVYMEN4bUJUYk1XVThob3BjTVdtZmdXNWpNeTZ0bUVReEQ3?=
 =?utf-8?B?SDNnVm1KSktvWWJZcWFUZmZrVUdRdWZhZGpsSDMyVjBLbDNERzhGaXZXSUZ5?=
 =?utf-8?B?elJFQytyaUl1NUF5ZmZYa2NxZjE0eDluak5jUVNWV0x2S2VWakhDQ3RXcWV1?=
 =?utf-8?B?S0lSbS93U3VhcHUzYkVvWTcyenJZWTNGelNQdXFmbjRCcGRyR3RmaUhjaWNW?=
 =?utf-8?B?ZzI1aURod2ZqQm9JOHBVWmxYenF3MEdJaTgrZWhHL0o1SUcyMkJWaGk5VThh?=
 =?utf-8?B?WGdRejMyMU1iOG9xUlRVdFZ4M1oxc01vRkIxNU1XNis3WTREVVpjeDhxOUVE?=
 =?utf-8?B?bVFVUTNqQWtQUURHNDM1Z3hDYmh0SGlrQ0xUL1JwSktkZnlXUzlPYWpUYktX?=
 =?utf-8?B?aGJpbVBReStmM1dRVXdTTWNCMWZDblVhQTl1T2lTMis3QzJpM1BVR1o0MTJC?=
 =?utf-8?B?RHlpNGl1cjZEbnd5NExjWkF4aXZTWjlvRlFJZk0vcytjOXZYWlhLV3ZIYmdB?=
 =?utf-8?Q?X2KEcJaeZyqj9Y74FmRLFp65KTMho0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f118d117-1ea1-4028-9440-08db3b83bc66
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 18:28:39.3084 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WpTzkd+cxY4yXMXC/WH/InJsuMC+gdOVtBJd8gO33YKtXM2AqX6mWPD8Jjo+HW5U/4dk7GVCSwry1uvAPx3+GIPnzfACzdpMEiR3zxq30U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_10,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120159
X-Proofpoint-GUID: 5Dl-6VgABmBOq0Wq6CGqfzDriG7RAiET
X-Proofpoint-ORIG-GUID: 5Dl-6VgABmBOq0Wq6CGqfzDriG7RAiET
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Thu, 13 Apr 2023 06:55:08 +0000
Subject: Re: [dm-devel] [PATCH v6 00/18] Use block pr_ops in LIO
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
Cc: shy828301@gmail.com, roman.gushchin@linux.dev,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, hch@lst.de,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, willy@infradead.org,
 chaitanyak@nvidia.com, ryan.roberts@arm.com, keescook@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 vbabka@suse.cz, yuzhao@google.com, axboe@kernel.dk, martin.petersen@oracle.com,
 halbuer@sra.uni-hannover.de, mkoutny@suse.com, akpm@linux-foundation.org,
 mgorman@techsingularity.net, zokeefe@google.com,
 kirill.shutemov@linux.intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/12/23 5:25 AM, Naresh Kamboju wrote:
> On Wed, 12 Apr 2023 at 15:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>
>> [sorry for the adding you in CC]
>>
>> While running LTP controllers test suite on this patch set applied on top of
>> the next-20230406 and the following kernel panic noticed on qemu-i386.
> 
> Also noticed on qemu-x86_64.
> 
> Crash log link,
> ------------------
> - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/test/check-kernel-panic/log
> - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/tests/

Can you point me to the original report? I don't think my patches are the cause of
the failure, or if they are there is a crazy bug.

Above, I think you pointed me to the wrong link above because it looks like that's
for a different patchset. Or did I misunderstand the testing and that link has my
patches included?

I did see my patches tested:

https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/

but they seem to fail in similar places as other failures that day, and the
failures don't seem related to my patches. It doesn't look like you are doing
anything nvme or block pr ioctl related and just failing on forks and OOM.
It looks like you are booting from a scsi device but I only touched the scsi
layer's code for persistent reservations and the tests don't seem to be
using that code.



> 
> lore link,
> https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

