Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D2FC433EF
	for <dm-devel@archiver.kernel.org>; Sun,  6 Feb 2022 08:30:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-bDkRiFoIN2i-Bfn3E8fgqg-1; Sun, 06 Feb 2022 03:30:48 -0500
X-MC-Unique: bDkRiFoIN2i-Bfn3E8fgqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A19DC180FCAB;
	Sun,  6 Feb 2022 08:30:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 721056A023;
	Sun,  6 Feb 2022 08:30:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C5A01809CB8;
	Sun,  6 Feb 2022 08:30:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2168Uge8020491 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 03:30:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 95CBA2026D69; Sun,  6 Feb 2022 08:30:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F9ED2026D65
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F560185A79C
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:30:39 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-435-6TyFBj53NQChyjSPvscPgg-1; Sun, 06 Feb 2022 03:30:37 -0500
X-MC-Unique: 6TyFBj53NQChyjSPvscPgg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2164scSF009011; Sun, 6 Feb 2022 08:30:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e1fu2jurr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:30:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2168FI5o164454;
	Sun, 6 Feb 2022 08:30:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by userp3020.oracle.com with ESMTP id 3e1jpkfhqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:30:26 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3174.namprd10.prod.outlook.com (2603:10b6:a03:159::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Sun, 6 Feb 2022 08:30:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4951.018;
	Sun, 6 Feb 2022 08:30:24 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Thread-Topic: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole
	page
Thread-Index: AQHYFI6GHFAsB7tXYk+ZNKUkZMvm/qyARncAgACF2oCAAB3ogIAA9HMAgAEGwwCAA1kGAA==
Date: Sun, 6 Feb 2022 08:30:24 +0000
Message-ID: <3fc16569-7730-2101-b494-94ef5291cf11@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-2-jane.chu@oracle.com>
	<YfqFWjFcdJSwjRaU@infradead.org>
	<d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
	<950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com>
	<YfvbyKdu812To3KY@infradead.org>
	<CAPcyv4g7Vqp6Z2+EXHdv95oqQxfdvPDAnzBiRG2KqobaHzOAsg@mail.gmail.com>
In-Reply-To: <CAPcyv4g7Vqp6Z2+EXHdv95oqQxfdvPDAnzBiRG2KqobaHzOAsg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d363a2c-fb6f-4cb5-6c45-08d9e94aec1d
x-ms-traffictypediagnostic: BYAPR10MB3174:EE_
x-microsoft-antispam-prvs: <BYAPR10MB317414710CBF36B95105CBF8F32B9@BYAPR10MB3174.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cUCe7FMcW1DVS6t8PqhaUNu48VFYLTIxHPvNhTjRmu4zrRH71gZZoWYoVVq27QiMVJ+KNlIkjlB7VsGVED91881wX61xbAT5Kk0X2CF/LzBQw6caYBahXtOwjjWybhhoHflt+dqLJm+LKFTPoKu8YbHcmN2WULJmv6gRnBLT9PYmpgh6F4VgcFFNP4Xu4Fw/VNuINTL2fZNtmf7kr0ctVT6+JQ69fFQuP1DU8s/6dRp0WkyWh2wkgW3URivvy9fofWQpiz29itBaAr4PPfq8nI1upbcU0fuWhDC96nHWtfbvwyGH6dDzyJXzjyLpIBLyixpfVGM6C3T1y9hEPCJSTeVlZntJYXTVcyejB5UoGjGzyO9BLoY92vCBkxTM34pqiMbhsjaOUQhUJVp5ijo1B68a34NmzUaMqW+Yo7MWchVpMRfz3s84h7Zb2JQoGCDFL/CEYxomDVtib8cgkW6lkwLjSYr2Kub5aBCEkUpuo8rxazBdwZT5jSusysYDZT4ZbwRsjJxlTJGVfGQqhJ36a7ORlHRTCnOspcEBT13s2gyuQ9zvH7v6Kyv8/JToZBl1g0n2CmoRQ6iWoeuv2D1DJ5j3iurN9vX4sINHUIr07s5BS8Vh2lrIkXAQSpwF4Ty2uDe7FWhPUPbmyHase26gDyu5rvuW3AGf+zUWL9xrf5Euwn0uWBtkC/aXH0Jggc6OZAvmPrEmpTRhzcoKGSkKk/m43/117aLZnx9z/RvLHbSZpBZZKzZQOtZfASCSnJY50bPhlBI+9QsCzHlfglFpJQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(36756003)(26005)(186003)(316002)(6512007)(6506007)(54906003)(71200400001)(122000001)(38100700002)(2906002)(2616005)(31686004)(53546011)(110136005)(31696002)(38070700005)(86362001)(44832011)(66946007)(5660300002)(508600001)(7416002)(8676002)(8936002)(4326008)(66446008)(66476007)(66556008)(76116006)(6486002)(64756008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDJkYXowZ3ZhS216bjFxTTQxYVBMaFN1bWF2OHU3WGttSHJCVlF2M3duaTgx?=
	=?utf-8?B?OStrMG1UVENJWG5SUUVEeTc2ajVSbUpERXZTb3c5QTRmTWYzVVJNemlUVWIx?=
	=?utf-8?B?bGo1VUpzaXhSOTFwMU1GaDhhazNFL3VlTjQ2RTIyWGtSSzJ3WXZIeVVldDB3?=
	=?utf-8?B?aU5RenZ5Y0lhNlZFSHpBbnpYRVRqL0M3TUVWa25yTEtqd3dQMkdnaEZwbG43?=
	=?utf-8?B?MFpJTEI0ZlBraDRxYkFKNnNuVGRrVTgrOW9hK2pELzZZN1NZcHM3Nm5VU3Fk?=
	=?utf-8?B?L3FuS0JodjVQdkUzMDdDRlJEVXdLU25rRjJVRWo4amJvenRIOCs3U2k0ZHVB?=
	=?utf-8?B?THQ2VnZtR0NlaTlXOU1IcFM3S1ZlQW05NFp0d2xUdTIrTitEL3pRM0RwY2ls?=
	=?utf-8?B?NkpHdXBJbnNobFkzdXBwY0RUVkRUTktkMFRuWFU5c0xDVXB2Q0xrS2VwQ0Ro?=
	=?utf-8?B?YmFNemJ0V2dvUURQbVJWMnE5MDZ3OXZPWGdZUlFvc0doU2lDK0FmOWhYaStn?=
	=?utf-8?B?Y2ZqYnlKQkxISVFGRHFjYW5EYUZkaEtNcmh3NDdOUFVvcDEzeUlPVzNLcTdq?=
	=?utf-8?B?TE4xYXhOTVdXY2pKVjlqQ2tZLzEyaWJGNHdWVUhmbGNvaS9ZY09VcGxIQ0Jk?=
	=?utf-8?B?TFFqQzFiVlRESmNMRm5HVmhSWTI3emhoNEZJS0F6QTAwL1JybWlsREx3ay90?=
	=?utf-8?B?RlBxZjNGZGdiRXlxRFE1VUd3cFdvYWRPOUVPTzdnNnUxYlYrYmR2cGNJVFhn?=
	=?utf-8?B?NjF3U1BNMHd1NXJvbTF1cmxwNGlvZHVQTnlsbEtIamMybW1yUEdFWGlZSys2?=
	=?utf-8?B?ODRiZUdvTGJqN1ZvT2dTT3g2ckVSMkY1cGozckN2bzJLOHFwZ0Z2elRacWhH?=
	=?utf-8?B?R1VQQ2RMNnRlWE9wZlhxaEtLdzNzclgyd2lTUFJTOGNmWkhvRXpxTjY4U2lp?=
	=?utf-8?B?cTdTOERRcjBGam9vb0JzU215cnpqR205Rkl4VjFDTkd1QXdyMENMenovZWlU?=
	=?utf-8?B?YUM4eE5LSGVQeXAwTHQ5NUxkZ3dvU0FuY3hEdEdLdWxzcG8zRldDRjFZdlRX?=
	=?utf-8?B?RHJCTmpFUmNUWXFpR3RKV25OVEF2Y2cyNDVwYk10ZHdMUUpJdWV2a2FNbVp2?=
	=?utf-8?B?TVRlc2VGT20zTVkvdENyQVRWMnlzNFI0dk93ZUVvZ1M5QXlVakd5SVJ2a2U3?=
	=?utf-8?B?RklFZlg2cHMyUzN1bllhZTIycGhMcnhOVThEakg2TlZyWTdqV0FRNEZsWFJV?=
	=?utf-8?B?NWlmc0tPNWdHTHRQelFCd2V2clM5TEFNaVZyblR2N0JvTU9MUk9RSEdFUDVr?=
	=?utf-8?B?YjhURTJQYzA0Vi9PNitmTlNoRk9QajBEMVVBMGxmMFN5Wk01WVJ3N1o0TlRF?=
	=?utf-8?B?a1c2b2Fuc3dEajdReks2ejNubEowblM5bDhwUzRwZUMxQ3RadkVaRmNGcWRr?=
	=?utf-8?B?cHdsbG1OOVUwRUxocWdjVzZaNUpJMGRqOVFnSXR2TEUxVTkrajBYd1lrcFBr?=
	=?utf-8?B?S1cvUWVqajdxU0tKb3RZMi9JbEJreGNHSFBqbTJTRVVNZS9KVkpSQ1Y1VmlM?=
	=?utf-8?B?bVdMalhBMVdYc0pqT3lnd1VwNndZVHFCcXlJKzhCK295VmNwMkdyaW53OGxu?=
	=?utf-8?B?L0NLZnhXcG9xZ3kydS9jSE9KY2RJRWY4aktnSEdGTXpWNC9zVGw5TlRObWQz?=
	=?utf-8?B?MDdHK1JXM1RmcDQ0UnlOYWo4TExQZzdXOEVZMEtjYmJ3S2h3emlNVzhyNFBS?=
	=?utf-8?B?Y1h4djhobzFqUWdXU1FUc2JkL0M5NUpXcjJLWVZzVTgrT3dCc3pYNndIcnJx?=
	=?utf-8?B?NFJrV1FLZkd5RDJWbVcxOEpYZE1uZ3paSHlnaEl6LzluYWdnVHdwUFNlWkhW?=
	=?utf-8?B?Q2M3SzFsSjdJYXE1OTJ2TitXdFE0SG5uZkZPV2hlem8ra1hUa1prSjgwRkVD?=
	=?utf-8?B?TFZ1ZmRXTDNhdTNsdEtmcnlGS2Q4SnNaTWcrVHZGZmxNdC9BUm1uWEtLd0oz?=
	=?utf-8?B?b3drODhOcEVaTEdnMVRCa2Y4YlVkVE1uMnU1ZjY5M0l2YkhOdzdGb2tEOUgr?=
	=?utf-8?B?c3JZUk5INlFhdlcxYUJ3WkpUTDFSZzFOZ0RwOUVSR1JvMTZLeU80Snk4bXph?=
	=?utf-8?B?aE9rb1lHU1FPM0k3eTNodXo1VE5vRlpxYnN3N29JSmJEVFN6bGNsblBiRkU4?=
	=?utf-8?B?Znc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d363a2c-fb6f-4cb5-6c45-08d9e94aec1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:30:24.7057 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: teazSoAPKNd9J1HEJOBfrVHtC+GmZ8B720qKbs8uqx0xlUS8V7H4rK2wPav8eVOb9FpaA/OEb0ZVavm97r8I6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3174
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10249
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 bulkscore=0
	malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202060060
X-Proofpoint-ORIG-GUID: Acn1tSbgj6OZOZqAtYa5r7vf1QpPWIjX
X-Proofpoint-GUID: Acn1tSbgj6OZOZqAtYa5r7vf1QpPWIjX
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2168Uge8020491
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
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 1/7] mce: fix set_mce_nospec to always
 unmap the whole page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7FD8B29ED170CD41B820970C78775FB7@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/2022 9:23 PM, Dan Williams wrote:
> On Thu, Feb 3, 2022 at 5:42 AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Wed, Feb 02, 2022 at 11:07:37PM +0000, Jane Chu wrote:
>>> On 2/2/2022 1:20 PM, Jane Chu wrote:
>>>>> Wouldn't it make more sense to move these helpers out of line rather
>>>>> than exporting _set_memory_present?
>>>>
>>>> Do you mean to move
>>>>      return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
>>>> into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
>>>> If so, sure I'll do that.
>>>
>>> Looks like I can't do that.  It's either exporting
>>> _set_memory_present(), or exporting change_page_attr_set().  Perhaps the
>>> former is more conventional?
>>
>> These helpers above means set_mce_nospec and clear_mce_nospec.  If they
>> are moved to normal functions instead of inlines, there is no need to
>> export the internals at all.
> 
> Agree, {set,clear}_mce_nospec() can just move to arch/x86/mm/pat/set_memory.c.

Got it, will do.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

