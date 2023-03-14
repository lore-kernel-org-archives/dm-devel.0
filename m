Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF12C6FD1D
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678869787;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ec+XlhoKe8bZryKrpXlMYKiFLNO8ummT1bzgpb1lNns=;
	b=Ff1d8ROZc5ZjoMEvAGGXH+fDi4NI1mA6ELM0uZjFmt5Nh6S6Ck2z758G93bxUENDmhTkx/
	7dhBo2BL/pKBb09BesP/OyV3vbCDLHsaEANq4n462cgAFSPLaYaOqtGL/Jd+JnufOD8vD4
	XNwq7+OfkupZssQydBFJNsxhZt5/wwA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-Pw0skNv6O_254yhnYGWYug-1; Wed, 15 Mar 2023 04:43:03 -0400
X-MC-Unique: Pw0skNv6O_254yhnYGWYug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B222B8828C5;
	Wed, 15 Mar 2023 08:43:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B892406AA66;
	Wed, 15 Mar 2023 08:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7B9219465A3;
	Wed, 15 Mar 2023 08:42:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 822CE19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Mar 2023 22:23:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60FCD400F4F; Tue, 14 Mar 2023 22:23:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58A64400F52
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 22:23:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 375CE1C02D33
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 22:23:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-JMwYuge7NpWhpjQnwd9_Yw-1; Tue, 14 Mar 2023 18:23:38 -0400
X-MC-Unique: JMwYuge7NpWhpjQnwd9_Yw-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32EJJScJ017278; Tue, 14 Mar 2023 22:23:21 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8j6u7u5f-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 14 Mar 2023 22:23:21 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32EL3mP5033479; Tue, 14 Mar 2023 22:23:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3p8g36rqyr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 14 Mar 2023 22:23:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB7407.namprd10.prod.outlook.com (2603:10b6:8:15c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 22:23:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 22:23:18 +0000
Message-ID: <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
Date: Tue, 14 Mar 2023 17:23:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Christoph Hellwig <hch@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
 <20230314171538.GG6780@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230314171538.GG6780@lst.de>
X-ClientProxiedBy: DM5PR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:4:60::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB7407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df83549-e6dc-4188-41cb-08db24dab64a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: dtFHGAZD1GhQxeBS+diuj5hpDgo0DyT5h7doV5igLUtyBUChn4Fp94rwqFuWJE437NjRHQy7yMKOs5ShPs6QqNOF/ITAZi54FYKovFAAP4IzqZEvN+7/PpbWY+RZx/rQUlWiNCGC3RHPw8fV04hYEweq4brVcCY0dq7ElXYJN5yPLjj5ew3ddgeJtGRujob+sQdfU93agCKBdtJGN5fV2pR11tnj1wLCd2MuGL4Tev+uwQ/oqFFKF7n7B1YZQ25NkgMGsxZXqsdxuSPAyLLmaaVQtdy3JcrOvrpAsrVpsvADq30VjcDFX1p7tnDrAXtm2nN/21VkH3ILw7YkeXUIY3/XxAYvaFzhT2Pk7TM1vU5L9cgyDrrie+mNq0CgxhRx4a6hGUdvJYLKdHGqh693D7r3V1skHLogryHmORCOcd9xWZqX/Czx8EkTCyVqPmmkN/rTu6S8rqmcvImDH0BfEmsyj+GLcdxS/sBgeBPhKf8Q+Wc116Gp+aZeo535vM6zyJFR8l9qfekmRtiyfIdhqab6qhP3zNwzwny9IQ+QZgrLp0e9noJ4T9gl32FHtPePvNXjpOsrP/XsjmhxWgFKmayr/zgeC4/D2gEWj5jYy3Qvm2TwGUeOqRcA1V3Ku62QssSFIt7oZDBDl9ioqOIgHhakyBVPf5AvkoYIWzg10G/n8evFAoFssoRNlz+uSxcmVhV8TlKhNASSVGRGpdNXs16qoOgvPZe41VrY0hQ9nlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199018)(316002)(5660300002)(36756003)(38100700002)(8676002)(478600001)(66946007)(6916009)(41300700001)(66476007)(66556008)(86362001)(4326008)(31696002)(8936002)(2616005)(186003)(53546011)(26005)(6506007)(6512007)(31686004)(7416002)(2906002)(6486002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUpLeDVjTldTZ0VBUjlXSnB5dFg4WU5Qd3B1U2svdmdhUkNhOXlNa3B6SWdn?=
 =?utf-8?B?aGdkbmVNcEx5ZDhsRXpnZzV0MFVZQUFjSDFhNVlqZFY3b2FEbEZhOW9nZWlS?=
 =?utf-8?B?MFJBRmdjOVlyVzZlTy9GaDZqQkxNTTlxSDVBNmhtZXlIYW1yRy9FWU1kSlFi?=
 =?utf-8?B?VkhvTXVWNkhoMGJGeENFNUtnc0hZOVpXL2ZIN0xtaUVOeEZxMXlJU3hiUWps?=
 =?utf-8?B?aUcvWVVVOEZ2UW9OcHgrUUhwbEV5NkZ6eEVIMnZFR3p1QzRmSzlQeGJGL0k3?=
 =?utf-8?B?YzdESFQ1SDBkSjZWYmJKeHNvRUNQTkw3MFhkZ2JxUCtQZVNsUkl6MElnY1Z0?=
 =?utf-8?B?N1p4Rk5RYXVjK1hzZEhBZjFHQUd3anp3YzAvNzZSeExPOW5pM2U4Z0NWcWpr?=
 =?utf-8?B?K0JFZ0tPbGZwMVBWU0RvWkwvallmYlZwZmlQSyttSHk0NldPcklkejhTbzA3?=
 =?utf-8?B?a0E3R1lXTG1NRENhcVhBU3hmQlMrSkZFc1dmTWNabkRJNlAwQVUwQmxUWlJ6?=
 =?utf-8?B?QUZxcGkzMk9XUzJPUkFwOHlNeEw1TVhHakJzQnQ1Tm1pNFlEVGc1VlAwSUFB?=
 =?utf-8?B?TzdpNERPYUUwUWtFY2NldXRUWDJkVDBmbzFVQkkrMVI1SnF4L2dsQ1Q4N1FK?=
 =?utf-8?B?Q2FTZnFHY2VESnJ0QzZxL1d2SGRZb2lCOXc4ckdtNG84TjRwd3puTU8yZ1RF?=
 =?utf-8?B?clBQRTdVNVVHMWVPYTBvbEp1bUJYWUkzSnNSN1VRS0Z4THcyNFhXUExWREhh?=
 =?utf-8?B?NU9hQU9Ec2s1dDBlUHFFMlFzTHgxUVJhWloxa3hlUklOYk9zNFZWbGNHM0tW?=
 =?utf-8?B?dUdOVlhGQzh2djIvVHRKSmZwSHkrZEFyY3doN1VPRTNHUG9FTS84UnNQbzVB?=
 =?utf-8?B?dkZQOXhUYm9KUVM1VlppNzV4czlEUlZHaVNLQ1hWY1kyQUdYNlllUHdrV2xr?=
 =?utf-8?B?aUdVaURLTkNUZ2hxOTJ2bWNOV3RUV2Z4ZUh2QUd4MXBJRXZKKzRQdHFBSjJj?=
 =?utf-8?B?ODAwU1pNY2g1Q0M3SG9CNVh6akdWOFhHb2dtTjZoVi9hUXNURFpGOUx5V3cy?=
 =?utf-8?B?WFRwQnFTcDZTNzliL1FjMnVvLy9adWRROWZvUnhLazd1TWVaczBLcmdDbHdn?=
 =?utf-8?B?SUpURDFaRDVQdFpRK21NY2tOYTFRYkc1WEh1R1J6ZW1EYjlpTjl4ejVmNkUz?=
 =?utf-8?B?TytTK3B2SDh3VTNxanJyRW1WMTJDY2R0Y1ByUHlML01FYWgxVlQ5QzdEY0hV?=
 =?utf-8?B?anh1Ym9SQmZGYUdGRCsrdXpWVEc3VG1ERjQ5VERpUHBRU1ZKdWQzMkZMTXps?=
 =?utf-8?B?aUo2bGh3TCtQRjQxeTFFNDVFeGNvQUloWmwzbnVyMFBtRENYNVZ6RWxGTnBt?=
 =?utf-8?B?N2dBUTBsTHowNURyVVVDOG94czBuK1VUR1NPc3BONFg0L3RqOFNsSmJGckph?=
 =?utf-8?B?OU5GOXpJeVMvaUVMMFhFaTR2OE1JWHRZQjVEQVNwdVk0ZjluQzYxM1NWUGlX?=
 =?utf-8?B?QUZYckRXb1c2VW1aT2lSb3hqaTVueEhZSzRvSTlLTUZBTktKa0hiRUc0Z1FX?=
 =?utf-8?B?WWtrd1BPSDI4dTliaFZXSmNuekRwNzVLTjZZWDZzZmtBRlVZeDlZTXo2Rm5U?=
 =?utf-8?B?djUzM0duQnFFQTdxV0Yyb01FNkk4MHZwdmlLdmUwS0RlSVQ3bXhzV3RoR0s1?=
 =?utf-8?B?akpTeVJCZzM4TkdKcUZJREF4ZUtteHlMZWVvV1NqcDZ3SnI0cFpjOUNZeE5m?=
 =?utf-8?B?eXl4Ulp2VHdSMVNSR0ZsbnR1WmYwTkM4MlRiSEhIOUZ3QVZ5T3ZjTEdUc2lo?=
 =?utf-8?B?Q3gzb1B3OHVZY1ZmSFNmUDEyL1ZpME9QQjRqc2lraFZ0TzlWaHk4R0pmTWV6?=
 =?utf-8?B?Sm1sR3d4SUtCTXk1TDlrR1BOc3pJMzFGNkFXN05NUXorR2c3dnZQaXJEZU44?=
 =?utf-8?B?bnA5UGZIa2VQREl5cHdLOHNuRldjbThZWms2WEplVm1aYjd2TGdsWkV4YUp3?=
 =?utf-8?B?NXJSNWJzNkErcStqdGVFRGhKY29kZnk5ZlJWbzFNSkx3djVOY1Y3Ym04R0tF?=
 =?utf-8?B?SitURER0MWNqNVlhOTNTaXpnOElmRkdTN0lwcEozdkdiYkJpL3dtWEl3dHpw?=
 =?utf-8?B?WEtOVlE1UWZtNng5NFZ2d2dvTnJVcXY0SGpqLzFnc2pqRVhzUkUrMFhRbEIv?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SGlYcERtb3RJSVZiSUhUUHhTSWE3QlBXUDBPZjU0bHFaWmhZZWh5N3JBUVg0?=
 =?utf-8?B?MnhMa3B3ODFoOHRvdnZWNG1FRlZ2M0NYWE4xK2xuYTdpQW9NYjhLVkl5UzJo?=
 =?utf-8?B?WUFiYS8vZm5RQ1o3Ym9ZekdZV05nbkdmR1Y5ajVTOXZoa3BSc1E0YU1qZjVF?=
 =?utf-8?B?a2l3blRmN1FzVU9NUU9WOVBBcnh3TGk5SFFkcUlXQU9wekFpdGxkOUVvUEQw?=
 =?utf-8?B?Q0QrRGdPZS9NMGJ2UFdvZmNsOFpWVGxiRHJ3aWgwM2xtOGhHY0w2ay85aEhC?=
 =?utf-8?B?SFJ2c0J0OVkyeGh0bmVzTkVjQnE0QWZNdG1QZXNTRWtKeEUzRkg5a1dZcmxq?=
 =?utf-8?B?N3ZtcTVLWTF1TzltSjg2V1dhV3BUVjZiejRuZ1NqOCtFdTFzQWdnZWhReEV5?=
 =?utf-8?B?M0Jib1EvWFRPVTA2cUNDSFFiNnBaZzJkUG9wZWlDRFcva3lzSDFidDFyY3BZ?=
 =?utf-8?B?bnlLQm9GT1NrajZ2TFZtR0Zoc3hWMis2L2QrVVc4TGplUVB5S3RkQWxoblNq?=
 =?utf-8?B?OWc0RUVQWis1SjBFaDVhdHcrMVJtUWhoamhMSkEzendNYkFIRXQyZ3l5M1Na?=
 =?utf-8?B?bjk0dzVZeUgzams2R1Y5R0VCbThYU0d0NGhXQS8zSzI0OEFHUGtmWDEzWEh1?=
 =?utf-8?B?VjF0VnZ2TTg4QTgycVZDcFNOeUlpYjUrOGRNY0xqb29ic1d5aU1lRkZodXlq?=
 =?utf-8?B?dTB5Z1VnbXRpeERSUXZFdERuTllVTUVjbmV2NFNmZU1JV0RBSDBFVlpkTkRV?=
 =?utf-8?B?VTU4SFFIOEFxVGQzM2d6VFc4YzlzdlMySGZmSitZNm05VUN0S0J1TVVqZVFz?=
 =?utf-8?B?ZERDZndKNGhUdEIvcDViSmhHQlJsdjM0dnk2QTlWTVVrdEllN2tHNks4dnBw?=
 =?utf-8?B?Vi9taytDVGpYSVhNb2xoWVNMMXdtYWR4a05Ua09nUUlGY2ZOUnJINzlHc3M4?=
 =?utf-8?B?b2FCMVcrRnpZME1RUjQybGZHTzJOYXBoS09XajA1dUhHSTlUM3hjVHRuVm9H?=
 =?utf-8?B?eTYvQk83YWVHQ2FvdlNsWEgwRi9vSmVtMXJvSjFBMnk5MzdhTEZ2SnI5Tm5u?=
 =?utf-8?B?TW9aSndUOWVOSFExTkNyN0Vma3VZb2JkTmJRWnJIUHNHNG1Ga1JoNWF3RGZT?=
 =?utf-8?B?Zit3a3I4WUZuV3Q3ZTlCMStVd1pqNnBVK1BvakNPVk43T3NkYy9wRzRORFdM?=
 =?utf-8?B?Q2c4NG5QK2xHOXkvWExjZEV4VmZITC93ZkRORTN1R20xRWpQblp4cTZ6UTM2?=
 =?utf-8?B?S0F5TFRTTU9WczlIMmxpenV6cUh3UEFnNGk2MnZGUzc1Y05iLys2T045aVNP?=
 =?utf-8?B?clgxbVo3QStDZDhXb3o5dVA2K3FRaEdVdm9lbDZUUW9BVnQ5M1NnT0R2dndi?=
 =?utf-8?B?dDdUUnVtTSt2N2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df83549-e6dc-4188-41cb-08db24dab64a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 22:23:18.4878 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtMzbknd1Zvqlr38oX3qZltgADrdt+phe5PZdj1Bs9lRAJ8w5tr59K8v9S4MFeS8Uqt7ihcgZkMhWrXe62kRxAjRBX3R1TNaPNBhIolTB6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7407
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_14,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140178
X-Proofpoint-GUID: gqnGOfWimCYZz7-3gyjy8awA2Wvecjkd
X-Proofpoint-ORIG-GUID: gqnGOfWimCYZz7-3gyjy8awA2Wvecjkd
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 15 Mar 2023 08:42:55 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/14/23 12:15 PM, Christoph Hellwig wrote:
> On Fri, Feb 24, 2023 at 11:44:51AM -0600, Mike Christie wrote:
>> +	__u8	resv10[14];
>> +	union {
>> +		struct {
>> +			__u8	rsvd24[40];
>> +			struct nvme_registered_ctrl_ext regctl_eds[0];
>> +		};
>> +		struct nvme_registered_ctrl regctl_ds[0];
>> +	};
> 
> ... actually - I think both these zero sized arrays should
> be the modern [] notation.

gcc at least doesn't let you use [] on a member in a union. You get:

./include/linux/nvme.h:804:31: error: flexible array member in union
  804 |   struct nvme_registered_ctrl regctl_ds[];


We could do separate structs though:


struct nvme_registered_ctrl {
	__le16	cntlid;
	__u8	rcsts;
	__u8	rsvd3[5];
	__le64	hostid;
	__le64	rkey;
};

struct nvme_reservation_status {
	__le32	gen;
	__u8	rtype;
	__u8	regctl[2];
	__u8	resv5[2];
	__u8	ptpls;
	__u8	resv10[14];
	struct nvme_registered_ctrl regctl_ds[];
};

struct nvme_registered_ctrl_ext {
	__le16	cntlid;
	__u8	rcsts;
	__u8	rsvd3[5];
	__le64	rkey;
	__u8	hostid[16];
	__u8	rsvd32[32];
};

struct nvme_reservation_status_ext {
	__le32	gen;
	__u8	rtype;
	__u8	regctl[2];
	__u8	resv5[2];
	__u8	ptpls;
	__u8	resv10[14];
	__u8	rsvd24[40];
	struct nvme_registered_ctrl_ext regctl_eds[];
};

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

