Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2403DC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 18:05:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADE2A61054
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 18:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ADE2A61054
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-rOl2nRpUPim75gUlQ6lWBQ-1; Fri, 12 Nov 2021 13:05:31 -0500
X-MC-Unique: rOl2nRpUPim75gUlQ6lWBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB35F15720;
	Fri, 12 Nov 2021 18:05:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECA98100EBAD;
	Fri, 12 Nov 2021 18:05:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABE734A703;
	Fri, 12 Nov 2021 18:05:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACI0k4U030326 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 13:00:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57AEC1121319; Fri, 12 Nov 2021 18:00:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FEF8112131B
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 18:00:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65DEA85A5BA
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 18:00:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-61-HUJbvUyFMLK4VKxotsk5QA-1; Fri, 12 Nov 2021 13:00:38 -0500
X-MC-Unique: HUJbvUyFMLK4VKxotsk5QA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1ACH8XI3004095; Fri, 12 Nov 2021 18:00:20 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9t709mb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 18:00:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACHoEer135322;
	Fri, 12 Nov 2021 18:00:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by aserp3030.oracle.com with ESMTP id 3c5frjt3e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 18:00:06 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB3922.namprd10.prod.outlook.com (2603:10b6:a03:1fd::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Fri, 12 Nov 2021 18:00:02 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.019;
	Fri, 12 Nov 2021 18:00:02 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v60R0AgAC+aoCAABOLAIAAEcSAgAFmpACAAvVOAIAAKBmA
Date: Fri, 12 Nov 2021 18:00:02 +0000
Message-ID: <5ca628b6-d5b6-f16a-480d-ea34dfc53aef@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
	<CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
	<15f01d51-2611-3566-0d08-bdfbec53f88c@oracle.com>
	<CAPcyv4gwbZ=Z6xCjDCASpkPnw1EC8NMAJDh9_sa3n2PAG5+zAA@mail.gmail.com>
	<795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
	<YY6J/mdSmrfK8moV@redhat.com>
In-Reply-To: <YY6J/mdSmrfK8moV@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c9a576f-6521-4e49-a36b-08d9a606400f
x-ms-traffictypediagnostic: BY5PR10MB3922:
x-microsoft-antispam-prvs: <BY5PR10MB392212FB8D9F7006DB950554F3959@BY5PR10MB3922.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: yq7tAWue4MvS4AAh85jWyPz1pMN20FzpRMZROrt+Jc5QNRVyz6LRN80CqwRP5ekubVgg2P3krlludMcZhnfoQNmvaPRezBk0+Q/1PUSlKiQFPRDkmw/q8SbUCMyIBrfGjlGRUC2dGJLGh8OUUKnM0Uixd3vc+7BKVE3b37F/t+FXBOza1FIWaAqYdbfryvk/hDAzRc2LlqxlWZGo6xq38/kWWk5heU9xM1OmGvAkdrileJFF5mg7mEzpvKcUz18/6nqNFEM6bieuRk6Hiu5wBWYAzCx2ehfUSyn/Fj+2vsZCBd7LqjDs/YPJFTZMzRZXwXBe0jrL3VV8EKI20BcWGtrslpDsgV/k3oAanyRkzsyGAV2IiiFoZKR7nFMGrXoCBKJIysb87q4nRGa24P5+pVTSf9jeeAz5vxAas9ELedu0CoYMVri1vWwz00s8J1WN4K+Bc4AWcsfqAtiXjnrI+2APhvfyYt0A7r9BauocoWc/Ogu0Lj7gXgjtlvHAZocaPHCIkylatdUMEosJIGd31j9MgaQwle8Dymyrb324ga2tlmoj1YzIVNzQO2T0o+4pHgjjF9ddKFAjSSXMQVIyu1op/irkL6xH0QV5q5TIWi7ZAlLKlUWMPZHVn5zQTCD7NF+2wzv96zw6btUPmWNuANKjNEFw2EEruO5r06DNzw/XIaKJINQcjBUvX7isBU74h+JxpT0thRk0RRkkpghLlmiVt7KpcA/1Jnsvzazpzum5otuwVb0jx5uv6VHF6XOmABXh+Iqd44C+BhRcHn/Jfw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(83380400001)(54906003)(36756003)(76116006)(66556008)(66446008)(66946007)(7416002)(508600001)(6486002)(44832011)(122000001)(66476007)(5660300002)(2906002)(64756008)(2616005)(6916009)(186003)(53546011)(31686004)(6506007)(8676002)(86362001)(38100700002)(6512007)(8936002)(316002)(38070700005)(4326008)(71200400001)(26005)(31696002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RU5zS2hmM2s1TWs3bnI1b29ySDZyUys1TFNzWHAyWFhrKzBPQUtLYUE1UE95?=
	=?utf-8?B?UG9sanhQNVpzTjhySVF0VXRVaW1aSS9zQmtselJCb3ZIbHV1OUREcEJqdWdQ?=
	=?utf-8?B?YVRtT1FLUUlSNjJrMXhnbE1XVjZQeHpkNEhjRHJnYy9ndXFxODRwTDErSzFh?=
	=?utf-8?B?ZEVVbDhBRSs0NmxtcHhsbFVQa1JvL01kdHJZenZ2Y2lkRFl6TmZiZExHSkhM?=
	=?utf-8?B?TS9ydGltdS9TZmFCM2xENVJ1TFV0bVFlelBHVldadGFxNWpoWWlnTitLOHUr?=
	=?utf-8?B?ODI5amxKWUx6NTcxLzh0aHpPLzJ2NWtySWY1aHl1eUsyY01JZEZiZXNCekZj?=
	=?utf-8?B?b2Vkcis5TTlTNzJrK2VHVml0aURmUG14K1BZRjc4aXhpOEFPbHNOZ2tKZlU4?=
	=?utf-8?B?MWJWakZrWXdYZndtck1mR0RjUWtrUDlBN2ZTYm54ZUpTMkorUWkydDlDZTJ1?=
	=?utf-8?B?a1dqSFgxbTQxY3dZTjJSUk1wMlFLSmFoczE2Z0tHVkxQaE83WEI5RW9mZ1Av?=
	=?utf-8?B?OWpZd1lUcSs4S3gwOVFsaWlQV1prWDViUm9tc0k1d2UySTVqSXQ0SkpYQlIr?=
	=?utf-8?B?aWJjb0xBRS9pWUxXT1F3eGNVb21zSmJ2bmh0VGo1OUFuVzZIR1RUVWxteXVQ?=
	=?utf-8?B?T0J1REhrL04wRmxRcUdoOXZ4RXV1LzZUMGVQcEV4aXlVZ21LQnBnRE1WMENG?=
	=?utf-8?B?WnIzVlQvLzFCZWJNSkVvMjg4RXFsdGRPcjgzWnYrMXpkSk9RQmVyMkhHc3Rj?=
	=?utf-8?B?N3BXQVJiZnRVYmpOR05mTFpYRGVaSVpNeVRTNU10REdRa2tBZ3lSNStUOEJN?=
	=?utf-8?B?bllOYVdidWRIZE9Ed3ovN2VFWFpXQml2Q2VseTNTMXh3ajFFNkNkWENyMGQy?=
	=?utf-8?B?L3o5RFI3dWt5SGZuNXFaRURILzNCZkphb2U3aDNIZkFmejVXM004M0FKaVk3?=
	=?utf-8?B?Wm1hRXY1ZHAxZnNBRGtCayt3RktwUkgza1p4dXNuRjlSTkQ3Rk9IeE41anZO?=
	=?utf-8?B?K2RKWDR6bnVNWlNqaGZyRXlRaC9uNW1RWEt2WUVsUDBRbHhEUVZvV3o0QlRy?=
	=?utf-8?B?enFINHdQZkk5QlVQK0xPL1VsNnhDZkNUZ2NmMGJ1U3RNUGtBRnhlaHloQ1du?=
	=?utf-8?B?aW14UGQzMlhuRlJLVEU1Ty85OG8wUmdVTTVGeFlXWVhpL1NKbU9mRkpJWTlR?=
	=?utf-8?B?VzVlWWhVZVV6MmhKUXdlNzB2UWU2WjZmbWRVei9oQm1IanlnUkVrc1FIZk9a?=
	=?utf-8?B?S0Y2U05MUW96RlJSSmdrL0VmT3grVzRCMUpFSWpYWFgwblhVSm1RZFNyMWhF?=
	=?utf-8?B?Zk1yQ3BZV3AySnNVZXRFR2JSVGtUUEUzZitrVnRpN1ZONENJRU9jdFRuek5z?=
	=?utf-8?B?dEY3Q2xpWWZJZjN6ZnVJOUI4SEkrR255UlUwb0xFYTNPR3htSU9Nc3EvSTQr?=
	=?utf-8?B?OVp2YkFDM2VLaFJrRnFrZnFxd1pDalVDNHJOT21OZUxGVmZ6Y3dOWEdVMXp4?=
	=?utf-8?B?NWxFbUxSdWMweDM3NFprYmJMNWl5S2tiQktkM0QzbDg0QWg0V2JJWDlvWUhY?=
	=?utf-8?B?QnFmSkZvUTFPSEJXcUhuM25yakpmTGxCT0ZubXBwbG1xRjZpa2RSMVlYcmtL?=
	=?utf-8?B?ZUZuWll3SnRLbXpuOUk5OGladXZSV0QrYU5EclpKVzA2RXpSQnptMTkzTmtV?=
	=?utf-8?B?Y2NmYXltb1NUYkNoUGFtOWR5V2xNbFBSVmtFMGUxS3AwdGVjNjVYMm9KY3RZ?=
	=?utf-8?B?Zk5oZDRMQ2FySU0vUlIxRXdvbDZDSWMrUWdad0tMSEF2ZHR5U09iTU10dTFs?=
	=?utf-8?B?ZlgwNzNxd2E4bXVqZGdjMlNsdmRpdTdJMHBPV3E2QTcxNTNvMit6bUkzczRY?=
	=?utf-8?B?dTlTdEpEaktha3U2SGFpdUoyNjVnRXFNbDJndWY2SUl2ZGYxd0IwNTFVdlBt?=
	=?utf-8?B?MG1NV0ppeUx6UkhuVVkrckVkUjZjVDhZOEFhU3RTY09sZlNLbmszVWpkR0Nz?=
	=?utf-8?B?Q2VLSzZqckVZQWpieXE4SGRDUFhIK3Flc0lOSWtmd291TitpTmJzd2hrVVUw?=
	=?utf-8?B?UTE5YkZVTzdxeThxNGZBUDZxcWFyN1YzdG92bklQbHI0TWlXUTVabDNvaTFl?=
	=?utf-8?B?VnhZN20xcE1ic3VubklwenRtcHErOERrTnJvTk0vaDVNbE1EOWtuU1QzbE11?=
	=?utf-8?B?S0E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9a576f-6521-4e49-a36b-08d9a606400f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 18:00:02.3769 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IH7zaZ+FlNh7xt1xJHt/3OrNeFWRAX3NOsW2+SEOIAqcXDUU/LDDetflXBK5bAvPX8d+vosxo5RY0KSqO8CyGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3922
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111120098
X-Proofpoint-GUID: 1nwcnBZaWSWA2t3kEaJP9fnp5s3Z9qYZ
X-Proofpoint-ORIG-GUID: 1nwcnBZaWSWA2t3kEaJP9fnp5s3Z9qYZ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACI0k4U030326
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>, device-mapper,
	Matthew Wilcox <willy@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>, development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, "Weiny,
	Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
Content-ID: <DBEC190E00E35044B00AC2CCD7CB1C3D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/12/2021 7:36 AM, Mike Snitzer wrote:
> On Wed, Nov 10 2021 at  1:26P -0500,
> Jane Chu <jane.chu@oracle.com> wrote:
> 
>> On 11/9/2021 1:02 PM, Dan Williams wrote:
>>> On Tue, Nov 9, 2021 at 11:59 AM Jane Chu <jane.chu@oracle.com> wrote:
>>>>
>>>> On 11/9/2021 10:48 AM, Dan Williams wrote:
>>>>> On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>>>>>>
>>>>>> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>>>>>>>     static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>>>>>>                  void *addr, size_t bytes, struct iov_iter *i, int mode)
>>>>>>>     {
>>>>>>> +     phys_addr_t pmem_off;
>>>>>>> +     size_t len, lead_off;
>>>>>>> +     struct pmem_device *pmem = dax_get_private(dax_dev);
>>>>>>> +     struct device *dev = pmem->bb.dev;
>>>>>>> +
>>>>>>> +     if (unlikely(mode == DAX_OP_RECOVERY)) {
>>>>>>> +             lead_off = (unsigned long)addr & ~PAGE_MASK;
>>>>>>> +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
>>>>>>> +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>>>>>>> +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
>>>>>>> +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>>>>>>> +                                     addr, bytes);
>>>>>>> +                             return (size_t) -EIO;
>>>>>>> +                     }
>>>>>>> +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>>>>>>> +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>>>>>>> +                                             BLK_STS_OK)
>>>>>>> +                             return (size_t) -EIO;
>>>>>>> +             }
>>>>>>> +     }
>>>>>>
>>>>>> This is in the wrong spot.  As seen in my WIP series individual drivers
>>>>>> really should not hook into copying to and from the iter, because it
>>>>>> really is just one way to write to a nvdimm.  How would dm-writecache
>>>>>> clear the errors with this scheme?
>>>>>>
>>>>>> So IMHO going back to the separate recovery method as in your previous
>>>>>> patch really is the way to go.  If/when the 64-bit store happens we
>>>>>> need to figure out a good way to clear the bad block list for that.
>>>>>
>>>>> I think we just make error management a first class citizen of a
>>>>> dax-device and stop abstracting it behind a driver callback. That way
>>>>> the driver that registers the dax-device can optionally register error
>>>>> management as well. Then fsdax path can do:
>>>>>
>>>>>            rc = dax_direct_access(..., &kaddr, ...);
>>>>>            if (unlikely(rc)) {
>>>>>                    kaddr = dax_mk_recovery(kaddr);
>>>>
>>>> Sorry, what does dax_mk_recovery(kaddr) do?
>>>
>>> I was thinking this just does the hackery to set a flag bit in the
>>> pointer, something like:
>>>
>>> return (void *) ((unsigned long) kaddr | DAX_RECOVERY)
>>
>> Okay, how about call it dax_prep_recovery()?
>>
>>>
>>>>
>>>>>                    dax_direct_access(..., &kaddr, ...);
>>>>>                    return dax_recovery_{read,write}(..., kaddr, ...);
>>>>>            }
>>>>>            return copy_{mc_to_iter,from_iter_flushcache}(...);
>>>>>
>>>>> Where, the recovery version of dax_direct_access() has the opportunity
>>>>> to change the page permissions / use an alias mapping for the access,
>>>>
>>>> again, sorry, what 'page permissions'?  memory_failure_dev_pagemap()
>>>> changes the poisoned page mem_type from 'rw' to 'uc-' (should be NP?),
>>>> do you mean to reverse the change?
>>>
>>> Right, the result of the conversation with Boris is that
>>> memory_failure() should mark the page as NP in call cases, so
>>> dax_direct_access() needs to create a UC mapping and
>>> dax_recover_{read,write}() would sink that operation and either return
>>> the page to NP after the access completes, or convert it to WB if the
>>> operation cleared the error.
>>
>> Okay,  will add a patch to fix set_mce_nospec().
>>
>> How about moving set_memory_uc() and set_memory_np() down to
>> dax_recovery_read(), so that we don't split the set_memory_X calls
>> over different APIs, because we can't enforce what follows
>> dax_direct_access()?
>>
>>>
>>>>> dax_recovery_read() allows reading the good cachelines out of a
>>>>> poisoned page, and dax_recovery_write() coordinates error list
>>>>> management and returning a poison page to full write-back caching
>>>>> operation when no more poisoned cacheline are detected in the page.
>>>>>
>>>>
>>>> How about to introduce 3 dax_recover_ APIs:
>>>>      dax_recover_direct_access(): similar to dax_direct_access except
>>>>         it ignores error list and return the kaddr, and hence is also
>>>>         optional, exported by device driver that has the ability to
>>>>         detect error;
>>>>      dax_recovery_read(): optional, supported by pmem driver only,
>>>>         reads as much data as possible up to the poisoned page;
>>>
>>> It wouldn't be a property of the pmem driver, I expect it would be a
>>> flag on the dax device whether to attempt recovery or not. I.e. get
>>> away from this being a pmem callback and make this a native capability
>>> of a dax device.
>>>
>>>>      dax_recovery_write(): optional, supported by pmem driver only,
>>>>         first clear-poison, then write.
>>>>
>>>> Should we worry about the dm targets?
>>>
>>> The dm targets after Christoph's conversion should be able to do all
>>> the translation at direct access time and then dax_recovery_X can be
>>> done on the resulting already translated kaddr.
>>
>> I'm thinking about the mixed device dm where some provides
>> dax_recovery_X, others don't, in which case we don't allow
>> dax recovery because that causes confusion? or should we still
>> allow recovery for part of the mixed devices?
> 
> I really don't like the all or nothing approach if it can be avoided.
> I would imagine that if recovery possible it best to support it even
> if the DM device happens to span a mix of devices with varying support
> for recovery.

Got it!

thanks!
-jane

> 
> Thanks,
> Mike
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

