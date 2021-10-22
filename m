Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A37C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:53:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5DB5861371
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5DB5861371
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-IrFPmo0EOIKF2ZCDVcZc1A-1; Thu, 21 Oct 2021 20:53:51 -0400
X-MC-Unique: IrFPmo0EOIKF2ZCDVcZc1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141BC8030D2;
	Fri, 22 Oct 2021 00:53:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6F7A19D9B;
	Fri, 22 Oct 2021 00:53:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D35C4A703;
	Fri, 22 Oct 2021 00:53:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M0nuRL020631 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 20:49:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 90CE9400F3F3; Fri, 22 Oct 2021 00:49:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B998401A993
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 00:49:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F4E3100B8DE
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 00:49:56 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-DfTm0dxXNtmMT31GPayovQ-1; Thu, 21 Oct 2021 20:49:52 -0400
X-MC-Unique: DfTm0dxXNtmMT31GPayovQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LNianW020528; Fri, 22 Oct 2021 00:49:18 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkw51bqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 00:49:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M0exN0071304;
	Fri, 22 Oct 2021 00:49:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by aserp3030.oracle.com with ESMTP id 3bqmsk3r22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 00:49:17 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5533.namprd10.prod.outlook.com (2603:10b6:a03:3f7::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18;
	Fri, 22 Oct 2021 00:49:15 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 00:49:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH 4/6] dm,dax,pmem: prepare dax_copy_to/from_iter() APIs
	with DAXDEV_F_RECOVERY
Thread-Index: AQHXxhA/migZDNV1a0+SBofbRrgPHKvdURMAgADgEIA=
Date: Fri, 22 Oct 2021 00:49:15 +0000
Message-ID: <325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-5-jane.chu@oracle.com>
	<YXFOlKWUuwFUJxUZ@infradead.org>
In-Reply-To: <YXFOlKWUuwFUJxUZ@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e3c56ff-f8e1-4445-5f5a-08d994f5c5a5
x-ms-traffictypediagnostic: SJ0PR10MB5533:
x-microsoft-antispam-prvs: <SJ0PR10MB5533B445904ED1BDA91A88BCF3809@SJ0PR10MB5533.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xQu4WxADlt8ZEsBF4C+BzSLiSpcRVOvMSfzfnzGDQXkICjijIFNS5vxpB0Esc6a8GwiT2M0ilBvsfVRoxyaU/FwN4BDUhqOPWoIN8FGUARkdbCfO2lcXjKpWvGtAGMmzXn+03+mHfbud7U+ObqCPMLY6nAdVJHw+GOdbBF7T2NN82/lnBglGa0tfmRqmpPXmx5iboRmNOl/WLfDUilV6nnf1Xp9QhrT3E56WPKSUOyK7tYGZeqeG0crOZPFXD1NW+K6HCiaExZPrIpQkxv/vkyIkYYEnjCIq0EEVG1ebjjMwgIvq7+hMnthn1tCCrMoocpJZF/IvORE0kYzcaBY0mNnSUOFzpRguDpNmPfXFZp8NMhAX4+CLz444rvOJQvD92vYU5XzFTrIKw6BCSKlTNmlnump5ImOrb9wimGHreyoOACiSrfbdIinXPfhjZ7hejuDU9yWKlJZDzacEtH5QASlppQTybuo05WwbLwaiMQn39xvtoMAvMpLUJMniptPc+0rmzhPqTFatq7t7+8UC6PbaQ9htvxgy69KRYkJq1jALEjKTz2XLkjnFBEXWhdciyAI5q1vOXCnOlnUa7WQPqNYcHZhpKaDpU2R2c1IaqtnTwVogiPylTBzzh285OXyTwTQ8vn6elQ1zTTzQXyAeOtH/x0Sak2AmDbGjOgutKpKZ9/dnnUGf/fmxxIzxy6JcvWjjpw93tLKTHTzZRcEej6JcQ5M0aG+1Wg/dcKu9+KW0ivH6Cfak1vgYbC8W+LaClG6sDknGUsyBk0oV1HPSKA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(64756008)(6506007)(4326008)(66446008)(66946007)(66476007)(53546011)(66556008)(71200400001)(186003)(6512007)(2616005)(26005)(122000001)(44832011)(508600001)(38100700002)(54906003)(6486002)(5660300002)(38070700005)(86362001)(83380400001)(316002)(2906002)(31696002)(8936002)(7416002)(31686004)(76116006)(6916009)(8676002)(36756003)(91956017)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHUvNDVOMDd2WTcvR2lhNlJYdlJhT3dtdDg0YVZlU2hBK29MNXFmY0RJNGho?=
	=?utf-8?B?ZzN0bE1KTWFwcDZsQ2dSVDJBM2NXeUZmeGFJaFJNekR0THVTU05JcS9OU3dE?=
	=?utf-8?B?L0xpZWFrVHo4YW5SYUpCbld2cDhMdlBhcUVxU3pSbHRISDJTMFUrRERBZ0pl?=
	=?utf-8?B?aU5vNUdMYytBM1lUMEl5ay9IeklyOGRDWGZRTlhrL0dnN09FNThVbEtybkdl?=
	=?utf-8?B?NU5laFk3K0xla205L1NtWUc1alR2U3BjWkhrMlU3b0lRdkFIQjdGS0lSV1R5?=
	=?utf-8?B?OXJZa1RLQjBwZ2gySytLanNIN0hJYU9yVTVwaERoOXFsdTJvZDZmdnNGemtu?=
	=?utf-8?B?MmRHVzRqNzdacG1kN3hwa25VRDhaOHRtNCtVR25Camdoc0s1Nk00QlhYS1Jm?=
	=?utf-8?B?akRSdDVRVmhTV3NlbFFRNVNjUk93M0tpSHovbHFOby81ZHhWK0tIQ0I3Wkta?=
	=?utf-8?B?UWJ4UTR2L3BpVEpzWFRHdEloRHpUdVBvTG9tMWRjN2lQUU9yb1duVlZjeElo?=
	=?utf-8?B?RUIwS0JkL3RuWkkrNWxERU9Qc0xSWUc3M1FnSWRxR2lldExVTjVYWU5aRUln?=
	=?utf-8?B?SmtGU1NJSFNXMkFSWC9vdERObTBwSXdXMzR6b2pLTWJVa0NPTThLTW04dHNn?=
	=?utf-8?B?bHk3Q0J6ZTRWOE5DZ0tWSHZGWmRBVTN0UGliZHNRMWlSdzYzRGs1WCszOGRn?=
	=?utf-8?B?OHRaanRVeEY2cG9lYnlhZU1RajJ4di9LeDFydFk3S1hQSjRsQVFRVm01b1FJ?=
	=?utf-8?B?SlNPbGdRQ2hMQWNNWWUrZHo0YXNzWHdrbzVnWmM4MFhwVldkb2tmaXl2YjUx?=
	=?utf-8?B?YjNyM1JRcEp2cnJOR3R2YUJVQlpmbzRmS0xjdDJCRjJSb2Z6K29oNHBtSFdX?=
	=?utf-8?B?em9qbTdLQzgwUXg2SUNTS0dJOUVqWWIvcGlyZ1lCb1ZRSVFIclNTNDNaSzVM?=
	=?utf-8?B?L2pMQmEreUlzbmdRbGk5RlEvdy9rQlVYdjdUcUhML2NjZjdIMmIrK2NWTDNl?=
	=?utf-8?B?YlF6cnR2SUUvVXJCSStzTVZXbS9NSUFnZzdiemRxNzNLMnVRUEs1RndmckVk?=
	=?utf-8?B?d2RYYlcrSkxoWkhFRmFjaWJ2Rjd3QkxOczVESHJLM1BuSkNINU11aVdOc0lq?=
	=?utf-8?B?RHZoVEhERkFHQmhEb25semVUZlk4Nm5FU21DVTRob1dNRmovOTJmUzNpSjJT?=
	=?utf-8?B?bTNLRXV2RHZOQk5YS2htOXl5aVBubkhlQml1ODBHb0ZpcVY2NWswT04weDV1?=
	=?utf-8?B?QTV0QjUySGlhWFVmVEE3VVRveVoreUVGUjFUanAxYWNJYUUrQlVrZGZUTEFz?=
	=?utf-8?B?RXpLRlNLZ1NvV1lCbTQ5d2taTTYzYllSTmZ3a2NmK2NkS0I2dElWZHNaVFUy?=
	=?utf-8?B?eTFtQnFLYlRuY1pHWGFGS2lWd2RjRjdVODNTK3oyV0UySzBTbEk0Q1pocThC?=
	=?utf-8?B?SGtteitJZm5NcTRHWnBrZ2ZzSm1hS2twOHBUMzBzQjMzV0Z6cE1VYlgvQkdM?=
	=?utf-8?B?ZXAzMmhTNTMvN3UwWDh5UlMyUnNnaEdkNi9EZGtCcmIwQnhpdTI0VGlWMEIz?=
	=?utf-8?B?K1FpMzlzQkRDaGV6REIzajFlNVBjazh4WUpxSitUNC90Y3BKcHBkVnpmcDR0?=
	=?utf-8?B?VE9HYzhUSVR3UU80VnB2YkIwcE11T3FVYWp4UTlVTko0R29aTFk1d0Mrdnha?=
	=?utf-8?B?TDh3NGUyYXZObElBU2pMZklRMUxsNWY4bGwweUFmWUhUUXYybElIVVdSUVBO?=
	=?utf-8?B?M3hyZXpYdzNQQWxoQ05HQ0FRMXpzTVJZTHZaWjlMbWJFVHBXWVlHU1hicUhQ?=
	=?utf-8?B?UHlVUEpjV0NxQkQ0ZllQT1Z2RitGM25XYWh0ZFQwQ3BmdVRFVVh0MTN1MThp?=
	=?utf-8?B?VjcrY2NoaStyYzRPQTYxZXZQZXIzZWVoUm91UnpaMFVjcFE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3c56ff-f8e1-4445-5f5a-08d994f5c5a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 00:49:15.2318 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	adultscore=0 malwarescore=0
	phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220001
X-Proofpoint-GUID: WNg8BHml_komDAw90HNBEtKfjrAL9SxU
X-Proofpoint-ORIG-GUID: WNg8BHml_komDAw90HNBEtKfjrAL9SxU
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19M0nuRL020631
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/6] dm, dax,
 pmem: prepare dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <BBB4DAE3B1312540A6CC5D9ED2B3A9D6@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 4:27 AM, Christoph Hellwig wrote:
> On Wed, Oct 20, 2021 at 06:10:57PM -0600, Jane Chu wrote:
>> Prepare dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY flag
>> such that when the flag is set, the underlying driver implementation
>> of the APIs may deal with potential poison in a given address
>> range and read partial data or write after clearing poison.
> 
> FYI, I've been wondering for a while if we could just kill off these
> methods entirely.  Basically the driver interaction consists of two
> parts:
> 
>   a) wether to use the flushcache/mcsafe variants of the generic helpers
>   b) actually doing remapping for device mapper
> 
> to me it seems like we should handle a) with flags in dax_operations,
> and only have a remap callback for device mapper.  That way we'd avoid
> the indirect calls for the native case, and also avoid tons of
> boilerplate code.  "futher decouple DAX from block devices" series
> already massages the device mapper into a form suitable for such
> callbacks.
> 

I've looked through your "futher decouple DAX from block devices" series 
and likes the use of xarray in place of the host hash list.
Which upstream version is the series based upon?
If it's based on your development repo, I'd be happy to take a clone
and rebase my patches on yours if you provide a link. Please let me
know the best way to cooperate.

That said, I'm unclear at what you're trying to suggest with respect
to the 'DAXDEV_F_RECOVERY' flag.  The flag came from upper dax-fs
call stack to the dm target layer, and the dm targets are equipped
with handling pmem driver specific task, so it appears that the flag 
would need to be passed down to the native pmem layer, right?
Am I totally missing your point?

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

