Return-Path: <SRS0=QKrD=P5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF06C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 18:38:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A59961055
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 18:38:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A59961055
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-ZcA8p6hTPqG0H-IqBv2jCg-1; Wed, 10 Nov 2021 13:38:14 -0500
X-MC-Unique: ZcA8p6hTPqG0H-IqBv2jCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 838B0871807;
	Wed, 10 Nov 2021 18:38:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D5F967848;
	Wed, 10 Nov 2021 18:38:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FE7A4EA2A;
	Wed, 10 Nov 2021 18:38:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AAIQdWp003746 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Nov 2021 13:26:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CBA21121318; Wed, 10 Nov 2021 18:26:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16FA71121314
	for <dm-devel@redhat.com>; Wed, 10 Nov 2021 18:26:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40AF480015A
	for <dm-devel@redhat.com>; Wed, 10 Nov 2021 18:26:36 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-319-GzjP12WINeqwvGX8GSg6Cw-1; Wed, 10 Nov 2021 13:26:31 -0500
X-MC-Unique: GzjP12WINeqwvGX8GSg6Cw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1AAI0Fgb002009; Wed, 10 Nov 2021 18:26:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c880rvgbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Nov 2021 18:26:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AAIAirc075984;
	Wed, 10 Nov 2021 18:26:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by userp3020.oracle.com with ESMTP id 3c63fv1v56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Nov 2021 18:26:03 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5534.namprd10.prod.outlook.com (2603:10b6:a03:3fa::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Wed, 10 Nov 2021 18:26:01 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Wed, 10 Nov 2021 18:26:01 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v60R0AgAC+aoCAABOLAIAAEcSAgAFmpAA=
Date: Wed, 10 Nov 2021 18:26:01 +0000
Message-ID: <795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
	<CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
	<15f01d51-2611-3566-0d08-bdfbec53f88c@oracle.com>
	<CAPcyv4gwbZ=Z6xCjDCASpkPnw1EC8NMAJDh9_sa3n2PAG5+zAA@mail.gmail.com>
In-Reply-To: <CAPcyv4gwbZ=Z6xCjDCASpkPnw1EC8NMAJDh9_sa3n2PAG5+zAA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45e02c91-580b-432c-0857-08d9a4778c4f
x-ms-traffictypediagnostic: SJ0PR10MB5534:
x-microsoft-antispam-prvs: <SJ0PR10MB55343FB00253A9AC4B1DD3E6F3939@SJ0PR10MB5534.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: llhCXkMSOXMCRaw9g0lSdQ9mFEvd6bJ/htzUYEul8Ds8GWzHGLCJeF8LK6IIZ6Rh4X/LCHkjLwTZyQQTC4cK0TSwjRMnQQ4l1QWi/G6IJuMYWkCfdXpGFdJ5kyTJRVY7FPlv6x5vQpKvWtlBl27MSDq8NMDsNz0RjviPKih1EG5AtuI5xhkbWRgB3vFSUYI6/rS0+PaWp0aOdSNfgrYIdxLDCbu3koJBwbm9x7PEltREopa+OUwCUFuNenVzgnhGJKb7RE+XvxadjIORgChf+fB9f4fafz/xOIOhcybhWuTwKL7qysowbEHRG3LosKtpYeQyFripJyyQLAntG7FQb2ftVz1IT0SkoFxgp3Sz4xNNxrGU8rm3bKJ848LTBwk9u7f1z9iwCggYqAVkNwwfNTqxg9krjV9tiKuu+ACtx9EOXF89tzzRQFLE8ceh14xW6eeyWj5ftR8WX9z1ZnZNE3liabqNU/udIn1+9AMkbKeUrPQs7m7zrFQqQeXT0kYBwmbVGz8Lyo/iIiuTWXrvGlQULxXztcd/3kV6J5DlmIb+v8ZAQbKWsaXUtZ2BGWRpkSgu6ryLanyekWEslINyXXLULupgrleIuwEyeTfGv6vx5uby9WQSysAYOeXJosmk3Wes1MeEq/DOG4YsmK/RT/ayFshlZVtPCeOvkt5eUzDAIgaH7FlvAqzKZmjhgFvBes9Q4zyGWywP25KQ40wv1fRS+XuAHhKyf/ecF+pqMupR4iD010eNlfeHIyOT8oinMiY3fTmQAU6ZPsRvhGBVhw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(122000001)(83380400001)(8936002)(38070700005)(38100700002)(66476007)(316002)(64756008)(186003)(54906003)(66946007)(31686004)(2616005)(36756003)(508600001)(7416002)(71200400001)(31696002)(2906002)(5660300002)(6506007)(53546011)(8676002)(6486002)(26005)(6512007)(44832011)(86362001)(6916009)(66446008)(4326008)(66556008)(76116006)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTR0VDY2WFpZN2VKS2FoaFNoZFdjbGlDYm9uSDlWdXh1Ry9tK1B0UElTd3lL?=
	=?utf-8?B?TFlQWWNWQUsvcHlUTk4rREozekRLNUcxaFUvS296TElhbkYxeHdNTllQWHdi?=
	=?utf-8?B?YWsrYmhaMElBRzNnS1hoODQyZHlPYXNHamM3UXR4QWVONDFmK1QzMHA4UGVD?=
	=?utf-8?B?ZUJ6elpzQm5JSXhCTS8rczdHYlN0MnRSVEJDSERVYUlwcDFSU3ZkTm5Dd3RK?=
	=?utf-8?B?VFNJWU9nbFl5cG5ZT3Y3TkVEK09VeHg3dHpHUlI0RkFKdk0wSldqaE5aKzF6?=
	=?utf-8?B?emY4SnkwYWRKcnhhSWZ5ZDVCNjF6bWdrbE5TMDFPdUU1Y3k1TkczWGdvWkJG?=
	=?utf-8?B?RWRDaVRwejJTc0FNWSs2SG54V1hzR1JrMm5YcGVzTWhUd25jdlVYaDE0UERn?=
	=?utf-8?B?TEZ5YXhqTkVqUS9IYlRURnJOZnR1bXpVU0JCOENrenNPZFd0ZmVMZHZ4d2ho?=
	=?utf-8?B?bWZKVXIrSGorcTlvUGxSZkZzQ2syT1FRWTlIdW1EYlAwNVVJYWdVYldGbXlU?=
	=?utf-8?B?R3JvcWM4U1B5VjVjb1dPb3ppZW9uL2U4SGQydUJ5TUNNMUN5V2ZpQmJJT3hC?=
	=?utf-8?B?dE1iVld2NGpTamFXU0dNVC9mTW5XMkRKdFNqVmQzZm5jLzRBeVdISVlyak14?=
	=?utf-8?B?UUxqNW9ESkVrSys0LzU5QkFrWXYxd1VON2l1WlkrV0JjK2dCbFJJdmY2SmIz?=
	=?utf-8?B?WnU2Tyt0djVqK1VXWllSRlhzQ1krODVVQys0aUV2dEl0UFpvbGlMRExrM21G?=
	=?utf-8?B?elFQU0NWcWNwUUY3ZFEwRlJORStYMHU1Mk5lRHZRV0U2MjFkWjAyZlozdklV?=
	=?utf-8?B?S05YdStsTi9lUkNQc3NoY2VLMzdQN0lGRjlHNzhyQ2VIUVd0QmJIUE5PRTFP?=
	=?utf-8?B?ZWQ0NW5XWjBIVVAxNkhjZ3MwejFNZ3VpMVEra3R6N2t4aFhiOGNDZkN5aFpa?=
	=?utf-8?B?c1lIYVNKcU82bSs5Z3dBUWxaT3VDcHY4SXdSR1I2MERxMHdSN0xoTFdsLzdE?=
	=?utf-8?B?UHJZRkl6TmVyQzJUZndybVpxV0M1bUloYkxnYy9sYUtFRWo4WXE4cGl2azVF?=
	=?utf-8?B?b0ZTQlRqZjVDNGlxcmFYbWZnWTJBWWRtQVlIdy9teFJJdjh5N3FLd0w0VDhp?=
	=?utf-8?B?N0ZiNkZQTURwUGdobm5iSDFxdHdyMTNpZHAycnV4b2cvQkl3WEhEbUtBNW4v?=
	=?utf-8?B?ajFqeE5FMGRQK2g2MUdSNzBXbmRKUkppZWJmS0VtMnIxRG5TL043WVVlRGJ5?=
	=?utf-8?B?M25ucHorZU1EeEx2Wkd1UllrU1NGaXB2RHBVcWgxdW1XWlBZYUJkL213dzVS?=
	=?utf-8?B?S3UyQTFZMFpueHFaMGpjUHcvSTd1ekdOaW1yT3BqeFFwVkhKZ1FZRmZrU1NC?=
	=?utf-8?B?akNCd0FQaW5ENXF3V0Z4ZlM2UVFsSElkakNGc1U2L1U4RFpDTnRtSC8wTTE0?=
	=?utf-8?B?Rzl3cURCTGJxbUJYQmFlVmtqOVI4Znk2NUJib1hzNmZ2NE9UajBsYjVhTk5C?=
	=?utf-8?B?ZE1ubEc4YUh6QjEwcHhLak1jZlBKb1FPTGl0ZVNuYWdmeHRDT0k3RzlLOVds?=
	=?utf-8?B?aS83dDduMjJQQlZTektGZlp6MngrdE43Snc2bGgwazVYcVVDb0hJdnpNRDlk?=
	=?utf-8?B?QUpqMTEvNUVsaloxbjdFbHoyeXFSTEl4VGxnWE9lTXE2YkFYMGdzTTFyOE5z?=
	=?utf-8?B?VGIrbzhjcDN4c0hxd3BlSEV0eW9ZMFkvVkdjQ2hUMmlFL2J1VG1MK3NXSGcr?=
	=?utf-8?B?UUZLM0JaNXZqUmtnbncwcU40QVJEcEF6T0pKNFRmYVpyVk9uQ3FMQTFtaEcw?=
	=?utf-8?B?TU9salo0WjFTTWNXMHZqZ3UyYk82dnpMYzE3ZUUwOGRkQ3BaT1BJbW11R0Fj?=
	=?utf-8?B?eHhrc1dPWHQrNzZDdit4SStuc2lMSTI1eWxxcDUrQjZiSnJocThtZHltVVJ3?=
	=?utf-8?B?c3didG9RaEFWNTF5Ullwcml6bFZDQU9nZ0t1cnNxQkY2V0cxV0ZrWFBqUFQ2?=
	=?utf-8?B?MVRuS0tFQllRMWd3VXc5cTVGZUVXQXFDMlF4NVJwaEZUdUFNUHVjSm5LblBu?=
	=?utf-8?B?VWFUa2JzaEJSZGMvQjFqSy9wYjFvSjJ3OTBsV3NNWllWaVZSS2xSYjdya296?=
	=?utf-8?B?bTBxSkhiZFZCL3Jxa3hvS0pWRlgyeUdYYUxMeU9kUTRyNnQ2NkFxZGN1Ujdh?=
	=?utf-8?B?YUE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e02c91-580b-432c-0857-08d9a4778c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 18:26:01.0454 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s650s6cUZibOl5zv8fdLoz4F4AUE78HL4aLnOYtGaG2ZK8Tnw4NicCthJ0E9Adh0sS6Zx8RrMeSiu91nDJ2EaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5534
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111100091
X-Proofpoint-GUID: t8AFUFFuH-1HZaCuCF5T5DRVP34guocL
X-Proofpoint-ORIG-GUID: t8AFUFFuH-1HZaCuCF5T5DRVP34guocL
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AAIQdWp003746
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>, device-mapper,
	Matthew Wilcox <willy@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Alasdair,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <02425C3062B0BB4D8EB70258B3CA0A2D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/9/2021 1:02 PM, Dan Williams wrote:
> On Tue, Nov 9, 2021 at 11:59 AM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> On 11/9/2021 10:48 AM, Dan Williams wrote:
>>> On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>>>>
>>>> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>>>>>    static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>>>>                 void *addr, size_t bytes, struct iov_iter *i, int mode)
>>>>>    {
>>>>> +     phys_addr_t pmem_off;
>>>>> +     size_t len, lead_off;
>>>>> +     struct pmem_device *pmem = dax_get_private(dax_dev);
>>>>> +     struct device *dev = pmem->bb.dev;
>>>>> +
>>>>> +     if (unlikely(mode == DAX_OP_RECOVERY)) {
>>>>> +             lead_off = (unsigned long)addr & ~PAGE_MASK;
>>>>> +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
>>>>> +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>>>>> +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
>>>>> +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>>>>> +                                     addr, bytes);
>>>>> +                             return (size_t) -EIO;
>>>>> +                     }
>>>>> +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>>>>> +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>>>>> +                                             BLK_STS_OK)
>>>>> +                             return (size_t) -EIO;
>>>>> +             }
>>>>> +     }
>>>>
>>>> This is in the wrong spot.  As seen in my WIP series individual drivers
>>>> really should not hook into copying to and from the iter, because it
>>>> really is just one way to write to a nvdimm.  How would dm-writecache
>>>> clear the errors with this scheme?
>>>>
>>>> So IMHO going back to the separate recovery method as in your previous
>>>> patch really is the way to go.  If/when the 64-bit store happens we
>>>> need to figure out a good way to clear the bad block list for that.
>>>
>>> I think we just make error management a first class citizen of a
>>> dax-device and stop abstracting it behind a driver callback. That way
>>> the driver that registers the dax-device can optionally register error
>>> management as well. Then fsdax path can do:
>>>
>>>           rc = dax_direct_access(..., &kaddr, ...);
>>>           if (unlikely(rc)) {
>>>                   kaddr = dax_mk_recovery(kaddr);
>>
>> Sorry, what does dax_mk_recovery(kaddr) do?
> 
> I was thinking this just does the hackery to set a flag bit in the
> pointer, something like:
> 
> return (void *) ((unsigned long) kaddr | DAX_RECOVERY)

Okay, how about call it dax_prep_recovery()?

> 
>>
>>>                   dax_direct_access(..., &kaddr, ...);
>>>                   return dax_recovery_{read,write}(..., kaddr, ...);
>>>           }
>>>           return copy_{mc_to_iter,from_iter_flushcache}(...);
>>>
>>> Where, the recovery version of dax_direct_access() has the opportunity
>>> to change the page permissions / use an alias mapping for the access,
>>
>> again, sorry, what 'page permissions'?  memory_failure_dev_pagemap()
>> changes the poisoned page mem_type from 'rw' to 'uc-' (should be NP?),
>> do you mean to reverse the change?
> 
> Right, the result of the conversation with Boris is that
> memory_failure() should mark the page as NP in call cases, so
> dax_direct_access() needs to create a UC mapping and
> dax_recover_{read,write}() would sink that operation and either return
> the page to NP after the access completes, or convert it to WB if the
> operation cleared the error.

Okay,  will add a patch to fix set_mce_nospec().

How about moving set_memory_uc() and set_memory_np() down to
dax_recovery_read(), so that we don't split the set_memory_X calls
over different APIs, because we can't enforce what follows
dax_direct_access()?

> 
>>> dax_recovery_read() allows reading the good cachelines out of a
>>> poisoned page, and dax_recovery_write() coordinates error list
>>> management and returning a poison page to full write-back caching
>>> operation when no more poisoned cacheline are detected in the page.
>>>
>>
>> How about to introduce 3 dax_recover_ APIs:
>>     dax_recover_direct_access(): similar to dax_direct_access except
>>        it ignores error list and return the kaddr, and hence is also
>>        optional, exported by device driver that has the ability to
>>        detect error;
>>     dax_recovery_read(): optional, supported by pmem driver only,
>>        reads as much data as possible up to the poisoned page;
> 
> It wouldn't be a property of the pmem driver, I expect it would be a
> flag on the dax device whether to attempt recovery or not. I.e. get
> away from this being a pmem callback and make this a native capability
> of a dax device.
> 
>>     dax_recovery_write(): optional, supported by pmem driver only,
>>        first clear-poison, then write.
>>
>> Should we worry about the dm targets?
> 
> The dm targets after Christoph's conversion should be able to do all
> the translation at direct access time and then dax_recovery_X can be
> done on the resulting already translated kaddr.

I'm thinking about the mixed device dm where some provides
dax_recovery_X, others don't, in which case we don't allow
dax recovery because that causes confusion? or should we still
allow recovery for part of the mixed devices?

> 
>> Both dax_recovery_read/write() are hooked up to dax_iomap_iter().
> 
> Yes.
> 

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

