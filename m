Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417DFC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 00:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657845324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=211NjRIf3sywidX2Pr64s8VacK1Rmp8bd8TUA1LgMjc=;
	b=I8OJnIjUvRmay2+KFb1GlypaZ79ci2LuN0z4nsk9y5iBh33ytqhLxvYSbm9TTs6ZVkYHjz
	kmisl+19Ard8OWLK4uDueVfD9dG5j+eptxMCPr5IUr9RMMYaAPKyVFqlVefB++HB4lcdvz
	UFxFkjCxma8CxPQk0xBhKZuEEX4fUy0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-J5BIjUzrN5mDgjIcW1mFgQ-1; Thu, 14 Jul 2022 20:35:20 -0400
X-MC-Unique: J5BIjUzrN5mDgjIcW1mFgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC67F3C025B1;
	Fri, 15 Jul 2022 00:35:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD3F22026D64;
	Fri, 15 Jul 2022 00:35:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96AEA1947072;
	Fri, 15 Jul 2022 00:35:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CEB32194706D
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 00:35:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7B0C401473; Fri, 15 Jul 2022 00:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2B56492C3B
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 00:35:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875F4101A54E
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 00:35:15 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-5u2ygqBgMe-uHoRFtG8Tpw-1; Thu, 14 Jul 2022 20:35:13 -0400
X-MC-Unique: 5u2ygqBgMe-uHoRFtG8Tpw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EL463Q024282;
 Fri, 15 Jul 2022 00:35:05 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sces10-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Jul 2022 00:35:04 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 26F0FgVH028567; Fri, 15 Jul 2022 00:35:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h7046pgb6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Jul 2022 00:35:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3970.namprd10.prod.outlook.com (2603:10b6:a03:1ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 15 Jul
 2022 00:35:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Fri, 15 Jul 2022
 00:35:01 +0000
Message-ID: <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
Date: Thu, 14 Jul 2022 19:34:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
To: Mike Snitzer <snitzer@redhat.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YtBlLDShzLdW8xDx@redhat.com>
X-ClientProxiedBy: CH0P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eefa7ace-7084-4ad5-4a59-08da65f9da83
X-MS-TrafficTypeDiagnostic: BY5PR10MB3970:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 0nDsY6jIX+bz570d9d9ADc8AoFas10zhLKbqJfvBkPZqhs6CCnuKafuK/HXn61V+YBfS/QRjd3M+pMDrDh01b8NXs91Vkwh9cF+7GA9VkZLHMgTYLVaALY7Dof81T2bNJgxfbPg5BXRPKcFVlwwPzktlQQMTg7Aa3PIdIF+ineH6Qk8Xgluv9YWIBSKE0rGOjXSgSP9drm+6z8aiDtVdXcPkWEoRPZsckXH7MLwqnGLQOO8/VPlafffSqekL13mSBUy/Yg/lsFgiIyGPIRcq463iYRwObWh27eAaD0v5VeaGMnfBXAurvcxs05UcPNvytsc5zRevMNdaeTVXLaMe68iHyeq8CAs0f6OBHhBBux9s2ZFKbn5lTHfdcH2JPSpxEAgg8fr8UaMnjxlKb+UEYMaYM28LHYf7h6wJcGM6ZCGF5kOY/GH8VfpOGLfoSZOoUnltOXaoyK6MlfbG2UyaDd9+G52ZGObghNImEpul90xecSTfyKLgNBhFEY6AjQg+b21Oiarkl85tEMo9PMciiuCoNSqRIR3QMCbJ3tQzb6K2mVBQh5/Kgbidye/tO6zOt6kZDsHvcKknllmD3kqrmEJKUYTed/5OxlwpQuFctnCngKpeqKYXjf5PhB/usak612NLuwNy06jyUm+oMDNYd2WFwHAqv8ZMGfoXND/94eErV8ZTXopy44qkhcNWZnQB5pfLawKZh/y+feV/8NfvERzS9QpWGXF3wCRIkIqRffpIW89U7bEy/2pKIXOzciPGhZhkx91yN3FpUiV1a7c18y7I+k3um7iqW0rZH7g12IHLJ8TFQ3A9fexvMnIa5TKHBnM8+rJA0d8rFXs6zsWC5I/G0pNU3hPvfV3xWD5eEWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(366004)(346002)(39860400002)(136003)(478600001)(6486002)(36756003)(53546011)(41300700001)(6666004)(6506007)(31686004)(6512007)(26005)(66946007)(316002)(6916009)(2616005)(186003)(66476007)(2906002)(5660300002)(8936002)(8676002)(4326008)(38100700002)(86362001)(83380400001)(31696002)(66556008)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTF6WmFVWW5sUVMxRlFaUE1kUTUweWxDdU16djJBRjQ2a0MybTVVbmQzczZy?=
 =?utf-8?B?TzZFWW9FMGlKRFdTNCt0ODFDNG5PYk9ObG1lMDZPRWVYS3Y4d1N1ampTdUdN?=
 =?utf-8?B?aE5nZUhSTlFkbG00VTBZUmpLVlJtbnA2MnQ3VS9Feld1djJ2aTM4ZXAzamp0?=
 =?utf-8?B?Zk9JWWdQSDNudENkdDhac21DZUxHTndTUGJPdEdpRjVwck5weTFRQU9iR2FF?=
 =?utf-8?B?YS8xVXpWd2pKUys3L3p5YUFxdTgzYjRRMTU3SkFXVHNxb0VWL3lTcUJZcWRT?=
 =?utf-8?B?MU5qdDYrTEZyVE9QcUx2NjRLOVovYmdPMkVhN3MxR1NBbFNYYTAvanpYWGV3?=
 =?utf-8?B?MFozNXZwS2o5ZzJEY2Vlc2RhakkxV2psSFJ3a3hmSXduQW9vN1FyeDNFUjFT?=
 =?utf-8?B?bVRvQjBhN0VTbHl2aTlEcjBDb29mdVJ0WmQrd2FYNmM2VE95SUZCd2lHcDlN?=
 =?utf-8?B?a1gxV3NEZ3dVaFE1b0t1cXZjYStFSUdxTmZoNjBNREQ5QmVMSUFUeC9MdVZR?=
 =?utf-8?B?bnNwSW96RS91REcwcjhUTFRUN2EvZlI2SFBtVEFBMm4rbnpac0RmZUltaDUz?=
 =?utf-8?B?MG1ScjFLOXk4MVFmVzBUMmFxaUIyUlJDaVlWRmZUdTB1YmdDNW80akwxYWRQ?=
 =?utf-8?B?QkNxM1haTnNBbHpZN1FPNFU2dFFwT0tGMUEzdGdzMDZFVHhubTRUNm5IbGxI?=
 =?utf-8?B?VzUzYzNZcExSa0g4Y0FyNXdGa1lLQTF4OVZsMkZZVUtoWGd1ckJUd2QySE1S?=
 =?utf-8?B?a01yR2EvcmZtY3BsTi9ZUm91Wi9wQ0lIUk5HQmVxbUFVN2RMZGYzOUwyUExv?=
 =?utf-8?B?MXRhY0VaTEFYZFpWRjRtT2dRVStyNzlnaExBSzRoYjdHWENwM1ZzYWxHV2Na?=
 =?utf-8?B?dXh0YWR0OTVzWlVYRE5LWkJ2UVhtUG5tOXptR0ZSbFRUTDZJa25qM015ajI5?=
 =?utf-8?B?WDAxUVZpQ21mN3VJOHFUcG1MMEx6NXFydjFDVEQ3T25SdEhOdnJzWHA5blVK?=
 =?utf-8?B?UXFjTWdPcXpQUnk3dVdFS1dZVStUZEo0RDMyYUg4RVgvMVZ1SDJRZWpERjBr?=
 =?utf-8?B?QjBaTHlZdTEwNGtHYml4MnoraS9ENXJsZjRQTTBIc2FJbUxySWtVai9IdU1N?=
 =?utf-8?B?b0VKZytwWHVHYzczSkxnZU9OZGlHNTFEUE1wRlBWT05jOENXd0N1eXNkbjNj?=
 =?utf-8?B?c2MrQ2d6cHRYZFJmMWxlUDNpRXhtdDNJTlVIeGtpR08zOVF1aXY5RHdBSStz?=
 =?utf-8?B?czVvU0lVQ0d2NVh1eUpXbGtTVThsV2RvSFBQakRaZElyYlJHWWFUUmduVncr?=
 =?utf-8?B?eWNuK0o1WUdTakorOGxrSHA1bHJKTyt6TVVzaUx2S0x3TEVWRmwyYnN3L2No?=
 =?utf-8?B?T1k4cmo5S3liNHJNQkpTS2RzSFBxaThpbEQvVzZNT3VWUkllZHBGRkcrRlhG?=
 =?utf-8?B?WWRRR1hBbW1BTThwOHhndUxUdlhIVDJaM0NSTTJsRW9YUDQ4MzFvRnprcXBO?=
 =?utf-8?B?SmFoK0dHSUo5MFJxOVFQdnlLN2RRUExUWStwakg1aHppbHVadEpoUW1LSllj?=
 =?utf-8?B?a1RySEIxRkR4UUZpdXRiQnRLQTNyTXpNWHErMWRkbHF4ZUZPZXcwTWhlRjFQ?=
 =?utf-8?B?d04vSFR0SEVldGREVGpDV0RReG1od1I0Ni9xcCt0SFdsSnQxSVRjaWhXYmtt?=
 =?utf-8?B?ZHM3TERNdWdMV1FOL3BrVkFPY3JKYmtaVXAwN1ZPeUpmZ0FHSFZEcm5BYVFj?=
 =?utf-8?B?cVo3OEdWbng4MHN1U2FPdTRUd3VVU1h5Q1Z0VzVUMGpDejg5eUREWkxob0ZY?=
 =?utf-8?B?SlhMN1dFUjVGQXhvRUtTdWZiVHd0YnhuRmJ0T2h1ZWJZMTZQa0JodjBENjYx?=
 =?utf-8?B?N05IcUFLeUNXVTJpUHlIZUNoaThUSUR3ajZQS2JwZDhGZjBMRFdkRk9Dc2pS?=
 =?utf-8?B?cWxUV0dIaGVRYWZUd2N3ZDN2dnZSWExVYy8xSXNhQlczcDliaGxkUEdXTHdU?=
 =?utf-8?B?dGVyaENndVJRMUgyaVFoMXlQeUVoL2hSUENpVWwveTE5MDBmbm5WZEg2cStD?=
 =?utf-8?B?ekFWUmNOeHFMZkRMc3VUWDJJRVN1bTY5WVhYTTVObU1KQms2b0JXMzRSUDhK?=
 =?utf-8?B?bjBnTm5KYlZzL2NyMWkzb0h3VmNscW5uOUYrK2l0MUlnTXBNLzB2bGsxTWhu?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefa7ace-7084-4ad5-4a59-08da65f9da83
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 00:35:01.5364 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5SPmsYXOlLRzLmiy/Eu11d4PO1efuq6CM8nGuEdD+ssF0NzR+lqJlZnvBgA5F5TPcFQVdYBJfsfVjhYJ5/pStm1r/76GfILGTI+nS5pn6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3970
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-14_19:2022-07-14,
 2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150000
X-Proofpoint-GUID: UJ4wTKCIZ6FL-yJ2WuYWUaIVXwoqDAf-
X-Proofpoint-ORIG-GUID: UJ4wTKCIZ6FL-yJ2WuYWUaIVXwoqDAf-
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
Cc: hch@infradead.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/14/22 1:49 PM, Mike Snitzer wrote:
> On Sat, Jul 09 2022 at 11:06P -0400,
> Mike Christie <michael.christie@oracle.com> wrote:
> 
>> On 7/7/22 3:27 PM, Mike Christie wrote:
>>> When an app does a pr_reserve it will go to whatever path we happen to
>>> be using at the time. This can result in errors where the app does a
>>> second pr_reserve call and expects success but gets a failure becuase
>>> the reserve is not done on the holder's path. This patch has us always
>>> start trying to do reserves from the first path in the first group.
>>>
>>
>> Hi,
>>
>> Giving myself a review comment. pr_preempt can also establish a reservation.
>> I meant to send a patch for that as well. If the approach in this patchset is
>> ok, I'll send a patch for that as well.
>>
> 
> It'd be nice to have Christoph weigh-in on these changes but I'm OK
> with them in general.
> 
> But please give details on what you've tested them against.  I assume
> the Windows cluster? How about pacemaker? And all looks good on other

Yeah, I tested with windows clustering. With the patches we pass its
validation test suite.

I did not run pacemaker. I was reviewing their scsi/multipath fence
agents and noticed they use a Registrants Only reservation like windows.
I just ran the commands they run manually. It works ok with the preempt
change I mentioned I forgot above.

I also ran the libiscsi PGR tests. We pass all of those tests except the
Write Exclusive and Exclusive Access tests. I don't think those reservation
types make sense for multipath devices though. And as I write this I'm
thinking we should add a check for these types and just return failure).


> systems that don't have the requirement to pin the PR to a device?

I didn't find any real applications that use the All Registrants type of
reservation where every registered path is a reservation holder. However,
libiscsi has PGR tests for that type of reservation and the code works ok.

> 
> Once I have this context on testing I can then work through the
> changes more closely and get them staged.  Please do feel free to send
> a v2 that conveys what testing was done and you're welcome to sned the
> patch for pr_preempt too.
> 

Ok. I'll send an updated patchset and add more details about what I tested
in the commits so we have it in there.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

