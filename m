Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5BCC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:34:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5881E61212
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5881E61212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-bGgYCUeDNoGP9RpRJubMvA-1; Thu, 04 Nov 2021 14:34:26 -0400
X-MC-Unique: bGgYCUeDNoGP9RpRJubMvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39731100B701;
	Thu,  4 Nov 2021 18:34:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91B665C1D5;
	Thu,  4 Nov 2021 18:34:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91EF91806D04;
	Thu,  4 Nov 2021 18:34:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4IYGTl011198 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 14:34:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DDC5D4010FE5; Thu,  4 Nov 2021 18:34:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3B6A40CFD0A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 18:34:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B68E6800159
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 18:34:16 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-212-No6nnv8iORC6r4ZCitP6CQ-1; Thu, 04 Nov 2021 14:34:12 -0400
X-MC-Unique: No6nnv8iORC6r4ZCitP6CQ-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A4IUwwJ027083; Thu, 4 Nov 2021 18:33:53 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxhac41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 18:33:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IUO2Y161052;
	Thu, 4 Nov 2021 18:33:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by userp3020.oracle.com with ESMTP id 3c1khxmru8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 18:33:51 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB4387.namprd10.prod.outlook.com (2603:10b6:a03:211::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Thu, 4 Nov 2021 18:33:49 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.011;
	Thu, 4 Nov 2021 18:33:49 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoCAAELPAIABAAaAgAbwJYCAASa6gIAIPpYAgADknQCAAWBnAIAAPDYAgADIRwCAAIRIgIAAJDSA
Date: Thu, 4 Nov 2021 18:33:49 +0000
Message-ID: <6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
References: <YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
	<CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
	<YYOaOBKgFQYzT/s/@infradead.org>
	<CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feb87378-dea7-4c73-7e2b-08d99fc1a517
x-ms-traffictypediagnostic: BY5PR10MB4387:
x-microsoft-antispam-prvs: <BY5PR10MB43879581499D40C6B2128D29F38D9@BY5PR10MB4387.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: w4NLcLaU+imd5VEHx+ZkEpFlnlK1uQ+bUJba246VyezqxdMRlK5bvODUPYUBPdEd5IrowPjDySb2sS0lQIlapGXHLL5K5dEXvg09Sj2PHky4mSpOblrQnSlW0QVVaoELyJoFJxm+KKnknezCNyCJhQ7pAZCMgtB9NVpf7+Guctl+UFAQjUK+ten8l2SkzFKAWWXOdXW9t/Bu4WZhv8KWfYbMaAyNruf1EuhC5X8Vyt91DlLNcM/72uEmRe/uWmMP8o5y6Wip6pRoVs2h4SKEeMlhFOr2Mwp8DxTQeg+iTTG7xmBnz4/q7oerH9jt3D07f6XaZ2qgAZUobB9jrWYcK5YFGtMrXJrClOKl7+RxewdqH4YGVnFoqAOdvzV4er7F9cbQei+LajDITpIYclCdg6aj3NjR19rvkdrT8AQ8feNgse+VxJ2vHDT3Jt1asEDZOQXra1bUNGd1wCXiKDI5cFwgZZIXbHK/HaNA+9NVja0htlCWMm8njUztQWnxde2zWgpMtD21/X10CF52gHUpaiFpr+UYcFPdtsmqyHXgsQO3zKJJa+Zot8aGrZxjK+H9fLV7NE+5hiwi/uWm/yjYt9l3fEofzz0o9Tkde0uwN5UnqxN86GvwBD/hcbkmUHcYX6/IPavD9842Il5pActxsJSvDaFbGRbLIEXgrFRum8VSLsZ2UIAzwxjNF5UftMFfdVIBUGNVJ8xyw0coJvU+myfotpfelGuFFdxVtlkGHFLV1+2hsCMqxD6EYC4slbVn2DgIfJS84DDhxSIXKakRbg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8676002)(71200400001)(4326008)(2616005)(86362001)(6486002)(31686004)(110136005)(316002)(44832011)(54906003)(26005)(6512007)(66446008)(64756008)(38100700002)(122000001)(5660300002)(7416002)(66946007)(66476007)(66556008)(186003)(76116006)(2906002)(31696002)(6506007)(36756003)(8936002)(83380400001)(38070700005)(508600001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MG9KUlN5UXl6cnJ1U0gyRW1zR3N6bmdDRGpqOE9JaDZhNGlLdmp5RERiN0lT?=
	=?utf-8?B?ek9WSzZTaDgzTFltVkFnN0hBMDBYLzF4eG1rRnZGS0N2cXk2VmdxYUxZZ2Ez?=
	=?utf-8?B?YzVEWEJONTl6ZTh5K2E2dFZ6NW80Tkk4Nm8yWE1ibFRheDkvazl0bmRiSlNy?=
	=?utf-8?B?c2plSm9jcFlNNUJqN29ENDJrNWdDaXdkcWFrOXVLL0t3SFRZMnI2UkFvejh6?=
	=?utf-8?B?aElQVnN4Z0oydGxOQzMxTzBpdHVGdXhFNjZFR0RLcXc2WHVudDVWbW5CdjRv?=
	=?utf-8?B?TzZSQVBzbk9VbjFVUEs0cm5mMEc3QW9IS2Z0OG1sV2dMTkpHVmFBYUdCSWJ1?=
	=?utf-8?B?MkhOc2VvTUdzVW5ZREZqVWNJenlVWkhoNkZVellQVzRJNE1UdllDMDZLSkJn?=
	=?utf-8?B?dEtmQkVza1JuMHowQ3dTSkR1SEZoTWVrMldkVDRsMzJ3TFlFNm1Ma3czditD?=
	=?utf-8?B?a1ZNdzkwV2RGQkNvK0M5blpJY1p0N0dadlNYWWFJbHYxYkIzYXpUbUtCbE5o?=
	=?utf-8?B?Q0VwS3F4NzBBZytOcGVDdUlzS2Nqa016RUFIMzlUQzdxMWpSUVF6ZmJQejdU?=
	=?utf-8?B?ZkNnZmU5RHNaVDd5SHZvbXBHbEhlbmFrTzJwYnFUVzliZGkzdkJYK0hYMWNM?=
	=?utf-8?B?SVZBYXJucndncE1yU0Y1REE0aGpLZDhya25aNjJUNDAzZXI2UGtWZDFUTmNn?=
	=?utf-8?B?TU9VcnBQb2xPNWdNWlIrZUtaM0F5SjN3blFSbFdvNlZBSEt3UmlqdWdDdHAx?=
	=?utf-8?B?VHkvakJ4ZVV3SGdhZ01yc0ZZZHlKQ3RwME95WU1GSUtQSW1mdzNpKzZSTjQy?=
	=?utf-8?B?VmpSWkhsVFZ2RUttdWdNdjI3MktlY2oxWHpidnhsanl5NmFkeWZQdXo5ckNU?=
	=?utf-8?B?R3BEQkVndHdHVytJS1hjRTgzZFFqNS90Y3NWeWY4NUFuamZjOU96cWorUTNJ?=
	=?utf-8?B?SUo0U1BlNmtsTFhCN0NyTUZrdXFtTW5IaDVhdU1BcytiN1FyNk1uYmFuMHVq?=
	=?utf-8?B?dDMxNEozblVlMGdHQVU1OWNCME5GcE9GQ24zdklNYjVuR3pWRkRueEZVTzNi?=
	=?utf-8?B?OFhadGNSSkM4ZW1ZRWhsNG4zY0tMWHBQY1FxWXUyOWJrZTRLOG9kU0o1U1dZ?=
	=?utf-8?B?c2xPVkJBelorV2JXTk1QOURUdlRLN2JPeS9tZzdPY1E0ZTRlMmFNYlBqd0hv?=
	=?utf-8?B?VEsvSXpQWmIwRWl1ZFE3YmJYOG5kdVNXKytNWkptVHpGVE10V3hmdGtjSEQw?=
	=?utf-8?B?L1JGOUdiQ1RNWmVCYlJlSFZkakdHZGhwY2ZGRlVRRFNTem5JUldPOUY4N2Iv?=
	=?utf-8?B?VkVmTWdhUS84TFR0SEg3UkRYbU5FQnJsK1U5RmE3cjJtc1pnVzZvSDNPL2dn?=
	=?utf-8?B?bW9lUUxybUNOdTRrZ0dBKzBIWnlXYlhadVNpVFZQWkc2NExKNy9UTjJvclNa?=
	=?utf-8?B?YlI2VXQ3bWxxcjRmU0lEbHJUYUQyeWEvL2VLc3FuUjBveU1yclJaY29mbFU3?=
	=?utf-8?B?djV3UFdQcHlzWXlhdmw5YjdPVHI0WHMzdFduUkVYajZYYi9jSklUMkpldThF?=
	=?utf-8?B?SUhZcTd2U2Q4Qlh1UEYzclFsRytKdU1VM3E2UTdRVzJoeHJLM0Fram8rNDgr?=
	=?utf-8?B?QzgwTWZySnhmbGhJb2dnZkNYV0ZDdHkyMG40WUNoajZMTkhMbFdpQ1h2MmMy?=
	=?utf-8?B?RXBLZFJaMW1MMElQdXZvT2c2Q05HbUkyaGlVZ1E3ZThjV0JEQWl2NHRMOEpk?=
	=?utf-8?B?NEVqdTZtcXEzZGE4ZGdtNTlpMzRkS0YyaEZINzVrVDNBc3JxcDhnLzNacDBu?=
	=?utf-8?B?NnRwMjRwSjliYkY3dTNKRExRQmx0ZklsVzkvTTZzR2l5azlNWEhzeTkwd0Qy?=
	=?utf-8?B?UjFjYXRPYkJic3Jpam4zeFl4dlNIM3dOMFJqN3dpZjVpWWI5dmdIWFVzWStT?=
	=?utf-8?B?Zk95bDNNLzFBSFVtK3RLa2Irb1FMTWI3M095a29JVDFINE1rZDBPSExYeENU?=
	=?utf-8?B?bzJHc0FkOU5zK1NFbnQrd0FNMTlGVFhvaS9nbFRzZVI2bVpFeUhZNi9jOUFj?=
	=?utf-8?B?Z1VQbUQwS2VRUnVtdkhPRitmeHZoY0JtejdMNGg4MEVLNmF0SVdkSzF6cVlr?=
	=?utf-8?B?NUpNRFlMdERwalJLQ1RvZ2FpZlROMi94ZnJlaVZ5SUdOcG1ZbFl0bFl4N0Nt?=
	=?utf-8?B?U3c9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb87378-dea7-4c73-7e2b-08d99fc1a517
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 18:33:49.5447 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jWljXOsnVf/cvuBCXbw5sIzPnyOPcww1t1lj3AV5sJgJt2kl6myveJHSQdnDmKBRR5Nx+xi/CPhdRevxv0iBIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	phishscore=0 bulkscore=0
	spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111040072
X-Proofpoint-ORIG-GUID: BV7LzkUpA8-2rXvY1wA3pdHIT9kH81Vo
X-Proofpoint-GUID: BV7LzkUpA8-2rXvY1wA3pdHIT9kH81Vo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4IYGTl011198
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3C1C778101671E4EA5D1B9F80B0B9A44@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for the enlightening discussion here, it's so helpful!

Please allow me to recap what I've caught up so far -

1. recovery write at page boundary due to NP setting in poisoned
    page to prevent undesirable prefetching
2. single interface to perform 3 tasks:
      { clear-poison, update error-list, write }
    such as an API in pmem driver.
    For CPUs that support MOVEDIR64B, the 'clear-poison' and 'write'
    task can be combined (would need something different from the
    existing _copy_mcsafe though) and 'update error-list' follows
    closely behind;
    For CPUs that rely on firmware call to clear posion, the existing
    pmem_clear_poison() can be used, followed by the 'write' task.
3. if user isn't given RWF_RECOVERY_FLAG flag, then dax recovery
    would be automatic for a write if range is page aligned;
    otherwise, the write fails with EIO as usual.
    Also, user mustn't have punched out the poisoned page in which
    case poison repairing will be a lot more complicated.
4. desirable to fetch as much data as possible from a poisoned range.

If this understanding is in the right direction, then I'd like to
propose below changes to
   dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
   and the dm layer copy_to/from_iter, dax_iomap_iter().

1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
    is likely media error: if the API without DAX_F_RECOVERY returns
    -EIO, then switch to recovery-read/write code.  In recovery code,
    supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
    'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.
2. the _copy_to/from_iter implementation would be largely the same
    as in my recent patch, but some changes in Christoph's
    'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
    virtual devices don't have the ability to clear poison, so no need
    to complicate them.  And this also means that not every endpoint
    dax device has to provide dax_op.copy_to/from_iter, they may use the
    default.

I'm not sure about nova and others, if they use different 'write' other
than via iomap, does that mean there will be need for a new set of
dax_op for their read/write?  the 3-in-1 binding would always be
required though. Maybe that'll be an ongoing discussion?

Comments? Suggestions?

Thanks!
-jane





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

