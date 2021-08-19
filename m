Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DC0C4320E
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DD8761357
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6DD8761357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-7g-1Fma-PhSQbl6sBp_SQA-1; Mon, 23 Aug 2021 02:40:26 -0400
X-MC-Unique: 7g-1Fma-PhSQbl6sBp_SQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BFFD1008065;
	Mon, 23 Aug 2021 06:40:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBCBC10372C0;
	Mon, 23 Aug 2021 06:40:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B9C4A4A700;
	Mon, 23 Aug 2021 06:40:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17JKpBYX019617 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 16:51:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CC2712028692; Thu, 19 Aug 2021 20:51:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C259621D0DB1
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 20:51:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44910100B8D2
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 20:51:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-405-j-3cl3i9PHandWb44rHzfA-1; Thu, 19 Aug 2021 16:51:06 -0400
X-MC-Unique: j-3cl3i9PHandWb44rHzfA-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JKej4c024089; Thu, 19 Aug 2021 20:50:55 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahsxd0qy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 20:50:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JKfBAM106160; Thu, 19 Aug 2021 20:50:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
	(mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
	by userp3030.oracle.com with ESMTP id 3ae2y55p1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 20:50:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19;
	Thu, 19 Aug 2021 20:50:52 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%6]) with mapi id 15.20.4436.019;
	Thu, 19 Aug 2021 20:50:52 +0000
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
	<d908b630-dbaf-fac5-527b-682ced045643@oracle.com>
	<ab9b42d8-2b81-9977-c60a-3f419e53f7bc@oracle.com>
	<OSBPR01MB29203E90FCF9711D8736C8D4F4C09@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <0c11714b-06f8-8eba-e0b3-8bb1caa8ebf2@oracle.com>
Date: Thu, 19 Aug 2021 13:50:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <OSBPR01MB29203E90FCF9711D8736C8D4F4C09@OSBPR01MB2920.jpnprd01.prod.outlook.com>
X-ClientProxiedBy: SJ0PR13CA0175.namprd13.prod.outlook.com
	(2603:10b6:a03:2c7::30) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.65.154.182] (138.3.200.54) by
	SJ0PR13CA0175.namprd13.prod.outlook.com (2603:10b6:a03:2c7::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.8
	via Frontend Transport; Thu, 19 Aug 2021 20:50:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12d90e6d-bc2e-4e07-d92d-08d963530853
X-MS-TrafficTypeDiagnostic: BY5PR10MB4177:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4177479B26542D242F9DD102F3C09@BY5PR10MB4177.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: xxx7LLHnsVwWj4hu28D+Pc2dH7uGszYH9JdMXES/bPoa4no2PxnGQfVwrSparQlWSBgyljlGalrSIKQHpHb1mz9ctwYkBkJ2e9xKE1UNUJCE1AWkBtwtvW+q8Z4Qkz4ZgEAIgySulVaGZ+GPRKN9qa907F96XOs0BRYY01YkI6yCMtI9TTfj+BRcj08+kSMNuHDzbj28SJcWcmilWQwSw3tusHADOuOaq5skm6SQdKnjYSw8mIQkC/KjfGL80GcP2LxpjRiWm6YDQP1R8GXTKfN4Eltq4iWBCFwCKKDvULMS0CvZtm8+6BWznqtfCKyoruJboFhVD00N5POhOmP9/dr7kn/ohN5pnz/MJYF6i+FfCpo9g6Udiaqfka5ShUrDOC/TU5Jx+zHHKrjC40Qgzz1JifBk3REw9lBddbjk9NTgO3E37E2pGu/4Jyfy16CeLcc9Kj6PSlViLt4bKLFFDOh+C9tnNf9BYpuqKrkAUVZQaluul94aUrFJWrB8zoZ1z0Zfy7GB2xp4KbWQ/vQHdw+75cMUsFUhl4H1Ms3GgwNsJeUe/xKTeooLXT9OIgvkpss+9P1tz9bIRuuAIxxzRUeXq8qjmuw9MngcPSdiEWMJi6Eoxzjuv+AvhzMbvLEBG9iqObkhniu6S4YicGPZSlWwBEoh2SirsqR3VCjTnpsNa39bjGMIsyZFyv/H3FxxG3ZhAGwzr/nHbb+KPeMq30lh6yAhK+qIcohesNhhfBU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(39860400002)(366004)(396003)(376002)(346002)(86362001)(8936002)(31696002)(478600001)(44832011)(38100700002)(110136005)(316002)(956004)(36756003)(8676002)(4326008)(31686004)(54906003)(66556008)(2906002)(66946007)(5660300002)(7416002)(26005)(66476007)(53546011)(2616005)(36916002)(83380400001)(186003)(16576012)(6486002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDAvQ25OYlJvNW1Pc01tSEk2TUp1QWkrUFZnZXczSWxReDlKcGFqYVNuaXcx?=
	=?utf-8?B?U203aDJZNENrK1JCSHhFWTl2a2lPN2dFd3dWUjhGMUNMMVJ0WWFkOXE4ZTNT?=
	=?utf-8?B?bmt0VTRtRnJ4YXNweG5qZmR1Q2pKN0VaK21DbytiYmRBdVAzUDJmeWcyOWVM?=
	=?utf-8?B?dW9PQjBSRGQwTXI2RHJqWGFwUzA4SEtib3lqYXZPcStySGw3SXhjdEZUQmIy?=
	=?utf-8?B?d2hDcm9XcFBLbFdlZDJFSkR5NUdZOWVjMkZsRGtBVlh0WUpRT3V3Um1ka0Z3?=
	=?utf-8?B?RmVrR2dqTVNiVC9vbEhXb2ZvVGlJcE5tTXgzKzNrNDZONUQrQnAvYnd3d0lQ?=
	=?utf-8?B?OUUrU2lqU2syajFkZlhIVWIyWHZ3dGxzdUhobktBMkk2ZzBqN3BuS3Y1VGor?=
	=?utf-8?B?L0VvSG9MN2lSRExjbkwyYXVYcWFZcVluRFNrNmZhekZ6N09uN1pFY1VyQ0Y5?=
	=?utf-8?B?eXZRQVF1Y0VRcXk3Q0l4NkFpTTg2YllZV2xxWGZnd2JGM1pLbkZNaTFUcVgr?=
	=?utf-8?B?Tm02eng3ZXdZd2RUcVZKSmQwenJJczFLcXlRUkVZU1Q2NEVIQ1ZBWnczTUFN?=
	=?utf-8?B?dVMxV3IxM05ydmpvTENPK0FlK3FXVTZIcys2MFlCYUdMSmZKSEV2ZzFuSXpo?=
	=?utf-8?B?N2RhV1RWRmNNV2g4ek1ieGt3eUszUUdvb2xIek1iMEVHeEsraHhSOGZYTlBt?=
	=?utf-8?B?UHE3Qk9Xdi92dTJnSDhNMEdmMXZGRWNwKzBnem9DRHNhbmlqRnFhRklnVW5u?=
	=?utf-8?B?Vzh6MzV2OHdmVm02Nlc4ZnV6RGZWYzI2RUFldGJyTnZvM3pSejFLNVhMdUZD?=
	=?utf-8?B?bmMrcHJLVFM5Q2lIeTg4MFJBYzRYUko4MDJDaHQ2NXRVQzBtTVBKRSsrNktR?=
	=?utf-8?B?QWFaWTZ3SmkrcjVUUXJvelpid3hUdzEwUlVTSFRZYU5IVDU4dzBMSzhnMlNs?=
	=?utf-8?B?Tjl6Z0xFZkFCcHJsNGhINHJzVkU2ckZtOHJXLzd0citoekNGb0x5YmJKVnFq?=
	=?utf-8?B?RG8rZGkwOGNicHFiakpzRzNaQlZYaVBYcGxGTW13QWpOWFdJOFBkc25ZMWpN?=
	=?utf-8?B?aDFmTXZuaElrTUI1SXlFbVoxODBCZFNCaW92YnZGakZiQ1VSb0Y4b3pTbEZS?=
	=?utf-8?B?Ymp0OEdUK2dURndqVlRaL2tzQlNMVFlqOUdsMW0vN3puU3dWVDlQSUc2ZmZu?=
	=?utf-8?B?bjdKMzJBNkk0akhnTndwNjM2Z1hkdkZyOXZIenVZL2xHY0lHcktRLzNYNXFB?=
	=?utf-8?B?Z051ZEZEbkVxVE5PajZmTC9HNWRyb3ovYVRkajNmZjJuQ3B0QWFXUTMrRXky?=
	=?utf-8?B?MHlNdmFiQWsyVHMycHJlUUJkTDdXMzZLTVJDbkJiYlNvV05SZmtQMUwyN005?=
	=?utf-8?B?Uzh6NDhXWTRwM3I0NkRoamNxOURNdW9kMXBtK3RzV0VGd0NtLzhjbHRncExC?=
	=?utf-8?B?dWVsbUxXUEdXTlVZUU9xYXU5SmpNeXVzbjdDcCt6dUZzN0hCYUNrRFlZVlMx?=
	=?utf-8?B?OGNIWlNuNkZCUHZDcXNUMU1tN0xZbHRhYS9Zb0J1dU9tUm5lZ2tEZHYyUnhl?=
	=?utf-8?B?QytyVU9GZXA3bUhpanJmaWxpaFBKOFduOXJ6anNpR084Z3BWK1hGajNWSzc4?=
	=?utf-8?B?dHdsb3ZiTW5wb1FkczVGR013ejJhU2Q0d1hsNkNXZ3dMc21LMWVyalBEbDYz?=
	=?utf-8?B?bk91cmF0ekV1dmE1YUZkQUR4azV0RnBaUXRTQTFkUzdpcUEraGVnZUcxSXhD?=
	=?utf-8?Q?5MCkNw86/Qip7GsTVJE6yl47f+OPCsrBOyux5bS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d90e6d-bc2e-4e07-d92d-08d963530853
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 20:50:52.3779 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiM3d/qvo3cOd+osQfbYqX922sjeUPBu/jRmG/1w1O+y8I9tifZ2nfRiz5uWsuyilM6z/5Zj+julEd143qt0Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190119
X-Proofpoint-GUID: cC4sCOoyPRBmC-pQ5viGQ_h4xk0Ffhf-
X-Proofpoint-ORIG-GUID: cC4sCOoyPRBmC-pQ5viGQ_h4xk0Ffhf-
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-00069f02.pphosted.com id 17JKej4c024089
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17JKpBYX019617
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDgvMTkvMjAyMSAyOjEwIEFNLCBydWFuc3kuZm5zdEBmdWppdHN1LmNvbSB3cm90ZToKPj4g
RnJvbTogSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNsZS5jb20+Cj4+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggUkVTRU5EIHY2IDEvOV0gcGFnZW1hcDogSW50cm9kdWNlIC0+bWVtb3J5X2ZhaWx1cmUoKQo+
Pgo+PiBTb3JyeSwgY29ycmVjdGlvbiBpbiBsaW5lLgo+Pgo+PiBPbiA4LzE5LzIwMjEgMTI6MTgg
QU0sIEphbmUgQ2h1IHdyb3RlOgo+Pj4gSGksIFNoaXlhbmcsCj4+Pgo+Pj4gICA+wqAgPiA+IDEp
IFdoYXQgZG9lcyBpdCB0YWtlIGFuZCBjb3N0IHRvIG1ha2UgID7CoCA+ID4KPj4+IHhmc19zYl92
ZXJzaW9uX2hhc3JtYXBidCgmbXAtPm1fc2IpIHRvIHJldHVybiB0cnVlPwo+Pj4gICA+Cj4+PiAg
ID4gRW5hYmxlIHJtcGFidCBmZWF0dXJlIHdoZW4gbWFraW5nIHhmcyBmaWxlc3lzdGVtICA+wqDC
oMKgwqAgYG1rZnMueGZzCj4+PiAtbSBybWFwYnQ9MSAvcGF0aC90by9kZXZpY2VgICA+IEJUVywg
cmVmbGluayBpcyBlbmFibGVkIGJ5IGRlZmF1bHQuCj4+Pgo+Pj4gVGhhbmtzIcKgIEkgdHJpZWQK
Pj4+IG1rZnMueGZzIC1kIGFnY291bnQ9MixleHRzemluaGVyaXQ9NTEyLHN1PTJtLHN3PTEgLW0g
cmVmbGluaz0wIC1tCj4+PiBybWFwYnQ9MSAtZiAvZGV2L3BtZW0wCj4+Pgo+Pj4gQWdhaW4sIGlu
amVjdGVkIGEgSFcgcG9pc29uIHRvIHRoZSBmaXJzdCBwYWdlIGluIGEgZGF4LWZpbGUsIGhhZCB0
aGUKPj4+IHBvaXNvbiBjb25zdW1lZCBhbmQgcmVjZWl2ZWQgYSBTSUdCVVMuIFRoZSByZXN1bHQg
aXMgYmV0dGVyIC0KPj4+Cj4+PiAqKiBTSUdCVVMoNyk6IGNhbmptcD0xLCB3aGljaHN0ZXA9MCwg
KioKPj4+ICoqIHNpX2FkZHIoMHgweDdmZjJkODgwMDAwMCksIHNpX2xzYigweDE1KSwgc2lfY29k
ZSgweDQsCj4+PiBCVVNfTUNFRVJSX0FSKSAqKgo+Pj4KPj4+IFRoZSBTSUdCVVMgcGF5bG9hZCBs
b29rcyBjb3JyZWN0Lgo+Pj4KPj4+IEhvd2V2ZXIsICJkbWVzZyIgaGFzIDIwNDggbGluZXMgb24g
c2VuZGluZyBTSUdCVVMsIG9uZSBwZXIgNTEyYnl0ZXMgLQo+Pgo+PiBBY3R1YWxseSB0aGF0J3Mg
b25lIHBlciAyTUIsIGV2ZW4gdGhvdWdoIHRoZSBwb2lzb24gaXMgbG9jYXRlZCBpbiBwZm4gMHgx
ODUwNjAwCj4+IG9ubHkuCj4+Cj4+Pgo+Pj4gWyA3MDAzLjQ4MjMyNl0gTWVtb3J5IGZhaWx1cmU6
IDB4MTg1MDYwMDogU2VuZGluZyBTSUdCVVMgdG8KPj4+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1
ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMuNTA3OTU2XQo+Pj4gTWVtb3J5
IGZhaWx1cmU6IDB4MTg1MDgwMDogU2VuZGluZyBTSUdCVVMgdG8KPj4+IGZzZGF4X3BvaXNvbl92
MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMuNTMxNjgxXQo+
Pj4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MGEwMDogU2VuZGluZyBTSUdCVVMgdG8KPj4+IGZzZGF4
X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMu
NTU0MTkwXQo+Pj4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MGMwMDogU2VuZGluZyBTSUdCVVMgdG8K
Pj4+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlv
biBbIDcwMDMuNTc1ODMxXQo+Pj4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MGUwMDogU2VuZGluZyBT
SUdCVVMgdG8KPj4+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkg
Y29ycnVwdGlvbiBbIDcwMDMuNTk2Nzk2XQo+Pj4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MTAwMDog
U2VuZGluZyBTSUdCVVMgdG8KPj4+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2Fy
ZSBtZW1vcnkgY29ycnVwdGlvbiAuLi4uCj4+PiBbIDcwNDUuNzM4MjcwXSBNZW1vcnkgZmFpbHVy
ZTogMHgxOTRmZTAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+Pj4gZnNkYXhfcG9pc29uX3YxOjQxMDkg
ZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0NS43NTg4ODVdCj4+PiBNZW1v
cnkgZmFpbHVyZTogMHgxOTUwMDAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+Pj4gZnNkYXhfcG9pc29u
X3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0NS43Nzk0OTVd
Cj4+PiBNZW1vcnkgZmFpbHVyZTogMHgxOTUwMjAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+Pj4gZnNk
YXhfcG9pc29uX3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0
NS44MDAxMDZdCj4+PiBNZW1vcnkgZmFpbHVyZTogMHgxOTUwNDAwOiBTZW5kaW5nIFNJR0JVUyB0
bwo+Pj4gZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0
aW9uCj4+Pgo+Pj4gVGhhdCdzIHRvbyBtdWNoIGZvciBhIHNpbmdsZSBwcm9jZXNzIGRlYWxpbmcg
d2l0aCBhIHNpbmdsZSBwb2lzb24gaW4gYQo+Pj4gUE1EIHBhZ2UuIElmIG5vdGhpbmcgZWxzZSwg
Z2l2ZW4gYW4gLnNpX2FkZHJfbHNiIGJlaW5nIDB4MTUsIGl0Cj4+PiBkb2Vzbid0IG1ha2Ugc2Vu
c2UgdG8gc2VuZCBhIFNJR0JVUyBwZXIgNTEyQiBibG9jay4KPj4+Cj4+PiBDb3VsZCB5b3UgZGV0
ZXJtaW5lIHRoZSB1c2VyIHByb2Nlc3MnIG1hcHBpbmcgc2l6ZSBmcm9tIHRoZQo+Pj4gZmlsZXN5
c3RlbSwgYW5kIHRha2UgdGhhdCBhcyBhIGhpbnQgdG8gZGV0ZXJtaW5lIGhvdyBtYW55IGl0ZXJh
dGlvbnMKPj4+IHRvIGNhbGwKPj4+IG1mX2RheF9raWxsX3Byb2NzKCkgPwo+Pgo+PiBTb3JyeSwg
c2NyYXRjaCB0aGUgNTEyYnl0ZSBzdHVmZi4uLiB0aGUgZmlsZXN5c3RlbSBoYXMgYmVlbiBub3Rp
ZmllZCB0aGUgbGVuZ3RoIG9mCj4+IHRoZSBwb2lzb24gYmxhc3QgcmFkaXVzLCBjb3VsZCBpdCB0
YWtlIGNsdWUgZnJvbSB0aGF0Pwo+IAo+IEkgdGhpbmsgdGhpcyBpcyBjYXVzZWQgYnkgYSBtaXN0
YWtlIEkgbWFkZSBpbiB0aGUgNnRoIHBhdGNoOiB4ZnMgaGFuZGxlciBpdGVyYXRlcyB0aGUgZmls
ZSByYW5nZSBpbiBibG9jayBzaXplKDRrIGhlcmUpIGV2ZW4gdGhvdWdoIGl0IGlzIGEgUE1EIHBh
Z2UuIFRoYXQncyB3aHkgc28gbWFueSBtZXNzYWdlIHNob3dzIHdoZW4gcG9pc29uIG9uIGEgUE1E
IHBhZ2UuICBJJ2xsIGZpeCBpdCBpbiBuZXh0IHZlcnNpb24uCj4gCgpTb3JyeSwganVzdCB0byBj
bGFyaWZ5LCBpdCBsb29rcyBsaWtlIFhGUyBoYXMgaXRlcmF0ZWQgdGhyb3VnaCBvdXQgdGhlCmVu
dGlyZSBmaWxlIGluIDJNaUIgc3RyaWRlLiAgVGhlIHRlc3QgZmlsZSBzaXplIGlzIDRHaUIsIHRo
YXQgZXhwbGFpbnMKJ2RtZXNnJyBzaG93aW5nIDIwNDggbGluZSBhYm91dCBzZW5kaW5nIFNJR0JV
Uy4KCnRoYW5rcywKLWphbmUKCgo+IAo+IC0tCj4gVGhhbmtzLAo+IFJ1YW4uCj4gCj4+Cj4+IHRo
YW5rcywKPj4gLWphbmUKPj4KPj4+Cj4+PiB0aGFua3MhCj4+PiAtamFuZQo+Pj4KPj4+Cj4+PgoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

