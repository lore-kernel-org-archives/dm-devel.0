Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D705C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 20:31:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 784A061059
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 20:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 784A061059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-EhT_vDH8NV6lkWCCB7ntig-1; Fri, 22 Oct 2021 16:30:58 -0400
X-MC-Unique: EhT_vDH8NV6lkWCCB7ntig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1239E801FCE;
	Fri, 22 Oct 2021 20:30:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D0E1196F8;
	Fri, 22 Oct 2021 20:30:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D08861800B9E;
	Fri, 22 Oct 2021 20:30:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19MKUlal019332 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 16:30:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 594371007246; Fri, 22 Oct 2021 20:30:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52CFA11558B4
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 20:30:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AEEF811E78
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 20:30:44 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-459-cPQVlPZ2PvS4cQalok0IQg-1; Fri, 22 Oct 2021 16:30:41 -0400
X-MC-Unique: cPQVlPZ2PvS4cQalok0IQg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19MJ9Wwh026091; Fri, 22 Oct 2021 20:30:33 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bundfmffv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 20:30:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MKLJ0L161436;
	Fri, 22 Oct 2021 20:30:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by aserp3020.oracle.com with ESMTP id 3bqpjb59t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 20:30:31 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2919.namprd10.prod.outlook.com (2603:10b6:a03:89::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18;
	Fri, 22 Oct 2021 20:30:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 20:30:29 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH 4/6] dm,dax,pmem: prepare dax_copy_to/from_iter() APIs
	with DAXDEV_F_RECOVERY
Thread-Index: AQHXxhA/migZDNV1a0+SBofbRrgPHKvdURMAgADgEICAAE9xgIAA+peA
Date: Fri, 22 Oct 2021 20:30:28 +0000
Message-ID: <600a0bb0-06a8-ea7d-47ad-c0e26b1c6668@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-5-jane.chu@oracle.com>
	<YXFOlKWUuwFUJxUZ@infradead.org>
	<325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
	<YXJNLTmcPaShrLoT@infradead.org>
In-Reply-To: <YXJNLTmcPaShrLoT@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f43cb01e-36dd-4be1-6a76-08d9959ac9a6
x-ms-traffictypediagnostic: BYAPR10MB2919:
x-microsoft-antispam-prvs: <BYAPR10MB2919F68B9A1C363E818FCF52F3809@BYAPR10MB2919.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 673TY0/KY78NKVEskN9jdnBeZYZ3yINOUhU6jy7qhy9g1exHcZQEV0Kx9PYKojXM6q+9TYsrK5IQdeLGhTIItla805FOSl7QWeqIk2rwNBWKojsY3XM2gzsNi6A4BoJdhcHVYpw99fKdEpZ5jM5QYlL2IT+gFATQVPU2nCzRlKU9fXANGzrbBnc4X2Ymi4WEOBtjdsgcTYB/qCoTpsZTrpSyS42BV5rlp4oBsJQiOfBEWFRAkmKGgSXqZH54JoM8etjB3FOSQqf3Gpi6AYSnXudK4DC9ceA4ofzQ9NoEHsOsjoprKMIxiLKYthntobaHY2vi4pTtoRLSAvpfo7VvL9MQegOPMWp81vcXeclQYdVj1U3R/fDvm/es/FmjTfQhMrZvFyxR47iDRsbrbD8HxAjSH2jxtZV5Y7qLCT1CV6/PuAvyQkc+kLMedEDoC45YuXm/MVI0pXhbcBW7C/pjmytbgj4I11LosobV8rVvgV6MHpod997X6u7FGh5uL5YHWtg4CIgeJ46+tAJW50CiG5cwn52WywJo1CODddkpJzOxhrME5KpClQ1CPmrRX/68i/jkrJ2qqzEl2IPQ3XIfnEihcvry97jldwm642BfuoHP+q/KGzqMQr4KM3w0BuigN8SnMZet9M6ZnTJSlZFAY2MS6PwbxqJRZuy80Ub+H0QxLZDk+MoxchcpbWoTFqYa3/dW2DhQdgWDv59pizqpIa3PwaErimkdA8pD8Q1BJ2Jl3jc6gNVL+fW9RK78lHddjziFaw7Ap9QlveA+Y/ey7BH/2F4oSi0HbU9RzuN3/left9DUfGzRJTzssDVKo+c8zP379CBk4/jPVcIIyPnh0iG875FThC6liJRpO9SHE10=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(26005)(71200400001)(186003)(966005)(36756003)(66556008)(2616005)(31696002)(316002)(8676002)(5660300002)(6486002)(38070700005)(6512007)(83380400001)(4326008)(38100700002)(8936002)(76116006)(44832011)(2906002)(31686004)(6506007)(53546011)(508600001)(7416002)(66446008)(64756008)(66476007)(6916009)(86362001)(122000001)(54906003)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnNPYmFsOFdMUHhSSmtLZTl6bmhNVCthR3BlSEZ1TGZtdVN2c2xPUnZKcE1Q?=
	=?utf-8?B?QjFTTUdjTTJic3BGN09vSTlBR3R6KzhjYTBoMkxqRkJ4Vko1aGREOVlXaVM1?=
	=?utf-8?B?VnFuMGg2VGdpREZLUEJVMjJDLy9HMENuK29aYWZ1THlHV3pzUnJCRE0zY1hr?=
	=?utf-8?B?TjVFczlBUW5lcDVWaFRuMW9ldTlvYVI4b2xLNnpUZ0swNThJMWkyMEg1MEtp?=
	=?utf-8?B?ay80R0dhelFUbkVrMmtwVnIvVVdEWUsvZnBkQThUZEZlVUxwWXY5U3ZLOFlO?=
	=?utf-8?B?L1hCTGpJWFMrWE5GclFab1g5Y2ZaSnNUOHpQSFVQU3BxUTRvRGZ4bFhxZXps?=
	=?utf-8?B?YWZ6N2grSkk4Y2NJb2d0ZVAxS3JNQk5yc0JHd204UWhzZHJXRVAzVE9xUUNU?=
	=?utf-8?B?RG9TU1RiRHluRXZqOUc3OFRFeXhybTN6NWVFaGZhcXI5dVBnUEpQcC82R2lF?=
	=?utf-8?B?Y001VDBReE9qMC9RVzZQMnhldWFHSEJCT0M1NjNSWVhzWVo1SXhYTzhOclNB?=
	=?utf-8?B?dUpzUnB5SWtHaE56LzVSOUJXTXNrLzFRaUVZZXBybWJMdURZMHdUeTQwS3JI?=
	=?utf-8?B?NjROeHI0TC9SaENaNnpDMGFmV0ZiMkJhYktFUzFVOWRiTi9XZWI0WnBqK0Zj?=
	=?utf-8?B?RnRlMlVmRVJhclFodFlzbERxQ3AwZ3dQcmszVG9kRnpEaTJLUXEwdExWM0x5?=
	=?utf-8?B?MGc5SUNMcVFVaFJCYm5wMTBFdlJIWFpORHl0M21rZUd3SkVaTm5xc1huNHZy?=
	=?utf-8?B?VllSSmV2TVF5MThkcFpQZzNhVTFNR3hOUUFreE9mWGNsbGNKMmNTbUYzSUta?=
	=?utf-8?B?TjNxOVJxTFYzSHRTQmN5RFRrU2xKQlVBa1Z4TnY1ZlRNYzBkVGNMNlpvdGZj?=
	=?utf-8?B?WVBZV2ptSDZNdlNmUDl2Sk1zMVVXQXh5bE1NRFpkeTNCQ01vQVFsYlZIakpZ?=
	=?utf-8?B?L09iR2pySDhCNUlWc3BoWnFnNEh4bzRFQk9LU2dXY0RkVHhiNThiVDMwNGlM?=
	=?utf-8?B?MFAvbEZRV1Q4cytybEVNTi9NS2dSZ1dybjBTb3MrRlVBdkxucFdCcml3WXFU?=
	=?utf-8?B?eHhoY0w3Wm5tR0docjRCNWYzcDdaakxFaURldzV6Q3M2a3gyK0c1bnhWNkJO?=
	=?utf-8?B?amtiQ0dPRkJxRUduMkxwemN6dDFpRS94OVJGQ2ZZVmxaWWhUZ1MxQXp5Szdm?=
	=?utf-8?B?S2IwVG5DZ0hFOE16blBnQzNYL3pRN3NwSDgyVlZ3eUxLdVIwVjFveVAzNTZi?=
	=?utf-8?B?OHFhKzR5WDgxTzlQWlNobjZPL1EvMVpQL2FlYlMrMUtheHdnV1V4MTgyZENG?=
	=?utf-8?B?WFZuaElKZFRJeVgyNldzNGJkUGt5ck1NYjRCTTVBQm5HblEwMmZQNnBVL0VD?=
	=?utf-8?B?TFJObThVbFB1OHdNblAzOXlGSTFuV3BqNVJLT3RBeWViUkliNnEzbEYvTmha?=
	=?utf-8?B?elNOWGhUeTJKSTI4NG5pM1ZWK1FRVXFsTEFFdklyc2lQb0tVMnp2ZFFWUUty?=
	=?utf-8?B?SEFmdGdzV0hldzU4SXZkWnlCRDhQTU0zTW1kN1J6TkFOVFlPcHZtcFpmN3du?=
	=?utf-8?B?WktNbXI5aUw4bFhGRGlpWlVYK1V2bnZHRFNybVNWSnVRcFpCaW04Y3NoYkpt?=
	=?utf-8?B?TmduNVYzSUp0QXdUZWRFT3piU0hyV0VDZk8rK2F5dEdiT0FaaDBFM2V4MDBz?=
	=?utf-8?B?T2NBSEVlVGt3WDFtNXFpNUJBZ0tKRDArV3ZiWWdTZEpvUVNtS1poQXo4VnE3?=
	=?utf-8?Q?CZ2AKJR4vkSRmrjDWw=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43cb01e-36dd-4be1-6a76-08d9959ac9a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 20:30:28.9627 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2919
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220114
X-Proofpoint-ORIG-GUID: 2oiQaB9DpzfbKOXJCJM56BWOaK6LxeLT
X-Proofpoint-GUID: 2oiQaB9DpzfbKOXJCJM56BWOaK6LxeLT
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19MKUlal019332
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
Content-ID: <4FE03E6769CEC14DA622BC8B5CFF31F0@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 10:33 PM, Christoph Hellwig wrote:
> On Fri, Oct 22, 2021 at 12:49:15AM +0000, Jane Chu wrote:
>> I've looked through your "futher decouple DAX from block devices" series
>> and likes the use of xarray in place of the host hash list.
>> Which upstream version is the series based upon?
>> If it's based on your development repo, I'd be happy to take a clone
>> and rebase my patches on yours if you provide a link. Please let me
>> know the best way to cooperate.
> 
> It is based on linux-next from when it was posted.  A git tree is here:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-block-cleanup
> 
>> That said, I'm unclear at what you're trying to suggest with respect
>> to the 'DAXDEV_F_RECOVERY' flag.  The flag came from upper dax-fs
>> call stack to the dm target layer, and the dm targets are equipped
>> with handling pmem driver specific task, so it appears that the flag
>> would need to be passed down to the native pmem layer, right?
>> Am I totally missing your point?
> 
> We'll need to pass it through (assuming we want to keep supporting
> dm, see the recent discussion with Dan).
> 
> FYI, here is a sketch where I'd like to move to, but this isn't properly
> tested yet:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> 
> To support something like DAXDEV_F_RECOVERYwe'd need a separate
> dax_operations methods.  Which to me suggest it probably should be
> a different operation (fallocate / ioctl / etc) as Darrick did earlier.
> 

Thanks for the info!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

