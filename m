Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5639C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:32:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 425FD61186
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 425FD61186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300--mvvcP8RPeqANqs3X2YOCg-1; Thu, 04 Nov 2021 16:32:09 -0400
X-MC-Unique: -mvvcP8RPeqANqs3X2YOCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A0259126D;
	Thu,  4 Nov 2021 20:31:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82DD25C25D;
	Thu,  4 Nov 2021 20:31:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12B7A1806D03;
	Thu,  4 Nov 2021 20:31:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KRhCv021778 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:27:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DF14040CFD11; Thu,  4 Nov 2021 20:27:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D813340CFD0A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:27:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA329811E7A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:27:42 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-318-8xLaRAZFMx6ctBZm0bw6gQ-1; Thu, 04 Nov 2021 16:27:39 -0400
X-MC-Unique: 8xLaRAZFMx6ctBZm0bw6gQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A4KOSH2009207; Thu, 4 Nov 2021 20:27:26 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8pa9ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 20:27:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4KCIRS145552;
	Thu, 4 Nov 2021 20:27:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
	by aserp3020.oracle.com with ESMTP id 3c0wv8b90u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 20:27:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3512.namprd10.prod.outlook.com (2603:10b6:a03:11b::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Thu, 4 Nov 2021 20:27:21 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.011;
	Thu, 4 Nov 2021 20:27:21 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoCAAELPAIABAAaAgAbwJYCAASa6gIAIPpYAgADknQCAAWBnAIAAPDYAgADIRwCAAIRIgIAAJDSAgAAHXwCAABhYAA==
Date: Thu, 4 Nov 2021 20:27:21 +0000
Message-ID: <342eb71c-0aff-77e5-3c71-92224d7d48e0@oracle.com>
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
	<6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
	<CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
In-Reply-To: <CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5f7557e-19b7-4953-f50f-08d99fd18116
x-ms-traffictypediagnostic: BYAPR10MB3512:
x-microsoft-antispam-prvs: <BYAPR10MB3512ADE88FD15BFB98782B41F38D9@BYAPR10MB3512.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: a1qLVq5OJkFYKdC39HNSImIYwfGOZ49LdZw9dOjhjIoLF9Lxg2MPJq3xhBEJQ7YyN/9UO7rCT+Y2U+TUpneyYna3BO6ohsbTkAvu5SJYmNyxzftBKV29PD5FHHhLrVY+LrkoaxRM0TkMfSE6diXm1n7wL9HtwWRO0npmQamDMJw/32M+y4vuVLRfiaC5mqvURkxNL6qe1Lg21jwmAxHfyMUV6sn45Acs51ga4E6/kQ/UoM2qsW1QIopnwKC1krEd2EL8pX880YkVhxGF+w59a5/RC25KmdtJxH8YSLfujmzVNV8Nn6fnhRnIOZh3qr1PsPYcqKxV0tEjYoVcIKtuceSIvQ+4Qf5ETz0BHHwGGHlT70mor1X9g8ECOUBS7Exo6aXQyKYP602wOKEqwiv1tu0uuolyIT/+lvtREV2l+NGw+ODt1FD8NYpJ5mNZHw+ecgIOXsG3d326nNaINqkJYIZ/h6JPiF9he6UA1gGV7ehf0a9ajo/fKuUS3KfovSA0f6lSwIKzA75plR/G2XArUgJ0zrzjr9uBb8/ouAJ5afcwJVoRxRt7uHp8oNH5tshsk3Ncm8wfZKfObKXh846s64np87wDWb96ReposglMR9g6yq6lP/nuFe0I0N5MLkV9UNVRUTtYbeU+dWZxMGeuWfbw3KyM9scE2XADsAzQh2gInZ3kqlUgKfUgBXF+xQjeOPqhV9XeyHUPCQxirCsjhTZu/9hSOv/LcXQnToRXbkDjkB62w8VFmPE81b/EJUQo1HESM0P43u6HAXsHwQrbZOf8bmLCHfQO8jtk0uCUZH0MVS1bGA/44IEvmyPpvZKV4Lxq+rwlrx/xMkc+KWxMGv90Tc1r+EXTVRRmLR0R8co=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(53546011)(91956017)(76116006)(66556008)(66946007)(6506007)(66476007)(186003)(316002)(2616005)(83380400001)(5660300002)(2906002)(31686004)(64756008)(66446008)(31696002)(7416002)(8936002)(6512007)(54906003)(71200400001)(26005)(44832011)(86362001)(4326008)(966005)(38070700005)(6916009)(8676002)(36756003)(6486002)(122000001)(508600001)(38100700002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTNSUE16MjgvUUlHMHg4L0JLbjRYZFBTaEJ0cW11ck9pVDVtYnlhWGd5Y1Rx?=
	=?utf-8?B?THpzY2tRSDlnZUorS2VHeDJ4YWtGaFNwamJKMnB4aHJ0eTllc2NjcElNK1BJ?=
	=?utf-8?B?TlhsRFJNdWFEbm8yc2VKVHZEM2VHbkwvNmdSSlo2MGJkRm0vMGVPOWVZWGpn?=
	=?utf-8?B?MDVDRm04NUxXcmg4S1BZZmhlVkRJcWlJWStNWERtRkR5MlFxL2V3UDBHNUVB?=
	=?utf-8?B?UEtUS1ovUkxsVTNGQkhCUlc0aTZQNlFTUlFwK2Q5T0huSUtxNUxxYTJtdnd0?=
	=?utf-8?B?RzVCRmxzd1BGcE1tNVlIaFNEekFYaDBTcTRHaFN5L00xbTZkWUVsSzdtMUtG?=
	=?utf-8?B?RFRLbVZsMDhaMTlSMVQ2QXhJcUlqUmlreFd0Q0QzNEhVb0ZGL3FoNStvQ215?=
	=?utf-8?B?bTJDbjJoK1FYUHJWRHFWRTlJSVhaNGIvNDVqK2FnQWpiUkwxZnNPbFFkNHN0?=
	=?utf-8?B?MjhicVFZd0NlWTJhZFVQcHdEOGlCVFVST29uNThvb1NWQlE5aGNiczV1aVky?=
	=?utf-8?B?b2cwRUJHOGRpTzNyMHdVNUxYQ3dETHZCb2xJTGg2Y2FaK25WKzI0MWhpVFRj?=
	=?utf-8?B?eVRPdWR5RlpqcUhmOElWSnAycStaczA2Sk44bGxpUDhWN0Mwa3kvUEJsaGE4?=
	=?utf-8?B?MTJvckswdHZYYU4wRFBHbVZwNE0xQW5DSXFZeGp1WUVzVlB5SlNIUTNFeDVy?=
	=?utf-8?B?aWk5ZmVkUFNwc21qelNuR3ROeFBnYkpuOStvVGcrODM3M2VSVDFGZlFTSkRm?=
	=?utf-8?B?WWFqY0g5bTlma0xlZVZscUI2TERGMEZremJDenFsd0JmZjJJNmtYb3RvRkNN?=
	=?utf-8?B?bTNpQlh1VjNMc0Y4cE1ZM1dCYkZTcWZ0NUFoVFJ6YUhNMnQ5QnR5VjBxRnB6?=
	=?utf-8?B?cW9HcjVTMzVyTWJIdEZnY2I0ZS9mYUpScy93NzZKLy9ITkRLb0VlY1poN3ZT?=
	=?utf-8?B?VTZRSGRtOGMzeUFoeURnN1JFSWg3QkxaaHR0d2dWSlExOXpIQ1l0RXJUWGlW?=
	=?utf-8?B?N3V3V3Z6OVpDMDVOTWpqY0ZoWnpqRnh6MVlWMnV0NzczK0w1aU1IWnQzckov?=
	=?utf-8?B?WTF3bXpibVd6bFdnQWhaRGs1aldlM3FmRHdkK1ZaTFQ0ZmE3TGFXMExCQUFK?=
	=?utf-8?B?Smc4bU5wNmhnalphNGIzUmtiV09qRHZ3SmY1YmpvVExuZ1BXa05xS3pqTzNl?=
	=?utf-8?B?M2tLSDZsSXhJeG9MamNqM1JhSEpnanYyZjA4c1pMeTRnNkNlUVNuUWJERHBm?=
	=?utf-8?B?RWxaNEpvaVVqU2cvaVhDUElSVkl0KzkwS3lLdm1kU25ZOXpiOE0wakpjVCti?=
	=?utf-8?B?UVpJc01sSmJWMHVzZ0NYWXJoYnVXZFoxNXlzcUZwY21SblplTDBTWkN5OTVQ?=
	=?utf-8?B?RGZIYXdUbUVzUWlrdlFFY2t2NkkxQUJnNmxjSVU3N0JNZjhYdWFKT0xERWdi?=
	=?utf-8?B?RW1LREFtZkdyNC83T0d5aHFBTlNrTEZ6SzhBNU5Fb1hHMmo0MXF5eC81VVRY?=
	=?utf-8?B?RGF2UTVKK1ArSnZYMnFGZmgzTG1oa0dWbU1hSzBNc3I0RDRUTTZIeERDNzBr?=
	=?utf-8?B?d3pSNTV1eTBQak5uMnVCQlhYNDM0amhTWDU0OVZRVTdMR3hJaTMvejZSdUxY?=
	=?utf-8?B?aFhRUU1rS2Z4VXZ0aGwvN21uUTZ1dFI3RXZLdm9qb2dUcXc3RnFQRHg0dmNj?=
	=?utf-8?B?NnZIRDJVY1pCeU9aK3RFaXJzT0VXKys5VlNDMmhHRDQzb0NBYXM5clhIVU1D?=
	=?utf-8?B?TWlaS2w4ckdoUnlSM3NZeTZwc2RwTWp3ZGdxVFhHcmErek1oUVdKNDRkQmFa?=
	=?utf-8?B?VkhtbGY3WDQ5TEt5WTErV282ZFhTOXVTcUFYRGVOMnIwYzlYMXM1OFh0SzYv?=
	=?utf-8?B?cWg5L29tdkhYdlJReVRPN1o5VEszM2REVE5ib3dqS1FXamZwT29jR044OE5D?=
	=?utf-8?B?WDgwdmJqWVRYcUJrREtTVG1aSnNtLzFrVlM3bjZvRVVRN2pHTEdaRmFOTGtw?=
	=?utf-8?B?RkNpa3RCckhTdjhwanpKbzkxVjJLVGdObURJL252V0k0T0ZkTWFUK1J3eVZG?=
	=?utf-8?B?VDJVQm10OTdLNzU2K2k3ZFJkYkNMYkhMVUhlek1HajZHUDl5MzJDSUhrSzlw?=
	=?utf-8?B?cUxEVkVvMDRLOG5DUXY0YjdOTjVRT2pYcElxdXhDQ3Rud204WkNacmZ0eGw5?=
	=?utf-8?B?bmc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f7557e-19b7-4953-f50f-08d99fd18116
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:27:21.1307 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qwTZ8tAJo9JoIQXbJsnre4zoiwrl2GNkI63NifPwmqew6+15Gndyr3A/HhATlxfXqSHlDfGgX3F04LTr7IyIkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3512
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111040079
X-Proofpoint-ORIG-GUID: -RF93fyzrJTKJjpOAWzZi2b8YO7cagdY
X-Proofpoint-GUID: -RF93fyzrJTKJjpOAWzZi2b8YO7cagdY
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KRhCv021778
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
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
Content-ID: <01DCC2ACCEEBC54EBF7311E72E96B3BD@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 12:00 PM, Dan Williams wrote:

>>
>> If this understanding is in the right direction, then I'd like to
>> propose below changes to
>>     dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
>>     and the dm layer copy_to/from_iter, dax_iomap_iter().
>>
>> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
>>      is likely media error: if the API without DAX_F_RECOVERY returns
>>      -EIO, then switch to recovery-read/write code.  In recovery code,
>>      supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
>>      'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.
> 
> I like it. It allows for an atomic write+clear implementation on
> capable platforms and coordinates with potentially unmapped pages. The
> best of both worlds from the dax_clear_poison() proposal and my "take
> a fault and do a slow-path copy".
> 
>> 2. the _copy_to/from_iter implementation would be largely the same
>>      as in my recent patch, but some changes in Christoph's
>>      'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
>>      virtual devices don't have the ability to clear poison, so no need
>>      to complicate them.  And this also means that not every endpoint
>>      dax device has to provide dax_op.copy_to/from_iter, they may use the
>>      default.
> 
> Did I miss this series or are you talking about this one?
> https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/

I was referring to
 
http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
that has not come out yet, I said early on that I'll rebase on it,
but looks like we still need pmem_copy_to/from_iter(), so.

> 
>> I'm not sure about nova and others, if they use different 'write' other
>> than via iomap, does that mean there will be need for a new set of
>> dax_op for their read/write?
> 
> No, they're out-of-tree they'll adjust to the same interface that xfs
> and ext4 are using when/if they go upstream.
> 
>> the 3-in-1 binding would always be
>> required though. Maybe that'll be an ongoing discussion?
> 
> Yeah, let's cross that bridge when we come to it.
> 
>> Comments? Suggestions?
> 
> It sounds great to me!
> 

Thanks!  I'll send out an updated patchset when it's ready.

-jane



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

