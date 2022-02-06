Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EF6C433F5
	for <dm-devel@archiver.kernel.org>; Sun,  6 Feb 2022 08:26:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-8E9QYSxGMiuktBB9SoDHQQ-1; Sun, 06 Feb 2022 03:26:03 -0500
X-MC-Unique: 8E9QYSxGMiuktBB9SoDHQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4DDB1091DA1;
	Sun,  6 Feb 2022 08:25:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6B1E4F870;
	Sun,  6 Feb 2022 08:25:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFAED4BB7C;
	Sun,  6 Feb 2022 08:25:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2168PgKf020174 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 03:25:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B78E7492CA9; Sun,  6 Feb 2022 08:25:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2333492CA8
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:25:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92769811E76
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:25:42 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-231-gkhrvGFLNmec1IZdQh9Meg-1; Sun, 06 Feb 2022 03:25:38 -0500
X-MC-Unique: gkhrvGFLNmec1IZdQh9Meg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2164impN009016; Sun, 6 Feb 2022 08:25:24 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e1fu2juc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:25:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2168BvYe131684;
	Sun, 6 Feb 2022 08:25:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by aserp3030.oracle.com with ESMTP id 3e1f9bs13w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:25:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SN6PR10MB3023.namprd10.prod.outlook.com (2603:10b6:805:d2::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18;
	Sun, 6 Feb 2022 08:25:20 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4951.018;
	Sun, 6 Feb 2022 08:25:20 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v5 4/7] dax: add dax_recovery_write to dax_op and dm
	target type
Thread-Index: AQHYFI6LEOTCAew0QE2MfSX8Pkzm9KyC8McAgANMQoA=
Date: Sun, 6 Feb 2022 08:25:20 +0000
Message-ID: <e14423a7-d2c6-06c3-fea2-bed1b1ad14e6@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-5-jane.chu@oracle.com>
	<CAPcyv4hFyoHgX9mo=NwOj_FPnfD8zkg_svM1sJZLn41vBm4Z8w@mail.gmail.com>
In-Reply-To: <CAPcyv4hFyoHgX9mo=NwOj_FPnfD8zkg_svM1sJZLn41vBm4Z8w@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c63dd04-4318-4fd4-01b4-08d9e94a36bd
x-ms-traffictypediagnostic: SN6PR10MB3023:EE_
x-microsoft-antispam-prvs: <SN6PR10MB30239499159150C6AE9B08FEF32B9@SN6PR10MB3023.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: m4kmuZaXP/WHUaWuFEiWgkPi5Un64u3+CwoppLzllBhLW0XikaBCBNP0OaEltqwbunURY2SprG5qQzq8t/PEWLWqfBdiYW9kpmwSExRZWBuZoTQOd1Qyohm0UP8+YDuHQXteMHBXGAhw3CbS5IiY7ovSEYSpcgpLXLE6Rgrp1vzwmWfd0TuctLaqN+96N8nnmKExnlibYRHl93cQ4IWY9CoVmEHxl1kMVUXXiQpYakmkTlT5qkZbfw5xmGRBbbpAYYeG5c9dPXRw+2bBWWtkQgV5R8kn9kQkh2Ab0bOsIHwOeLUBUKQs5D51E7nFwnkv6V0NV6sEY1421H17hdzqgENyXLfXsat2EdbZr+RkXvpZaF2lDPirXF+wHWuJUiDakMMRwQjOB7oGbgrjrnQ8Tkg/JfyupO9cnxRdg9FhimPT+zuTP9fyQCEcFSunoCaqmdf7cDDGZzVrIVIxM1uwbXC/O0eJtWbfGUv5Rs5xz7tx8wlRvLWD1VQHgUYH8uDZxss1Q//MoAnTjHww54os4UkrMDXqhGH3eQb5C1BzXAmjdhdHgdCVn5Jq5h8OXhCHrhfhUxJEh+A5+P6Gy/C40Nai78plYYCIjb1mgiWf1Fov1g9nS89WlFbkoI4WtciH0G5EXMrITirS7LUDMbTS5/6UVWJEBwz9YQidFkfqp2TzFylSGbWGOdDVmhozgYJdDeQVOYFcq5SOlJjkSonCUiUMSvuftTf9Otb7xV2Q4hz5j7gbdi/RKko2I82T3L9g0YmwfBr0uW5b6ua+ukXUzg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(71200400001)(86362001)(26005)(2906002)(508600001)(2616005)(54906003)(186003)(316002)(6916009)(38100700002)(5660300002)(38070700005)(122000001)(4326008)(6506007)(8676002)(66476007)(31696002)(64756008)(66446008)(66556008)(76116006)(44832011)(66946007)(8936002)(6512007)(53546011)(7416002)(31686004)(6486002)(36756003)(83380400001)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkdUdlpQakpHSWl4RkJBNUVMajZGSk5aeGc4WFNpTXlPUWdNSkdiVnA4Q01E?=
	=?utf-8?B?L3VkdW50a01FcithRUJpNnZncnk4QURrdmtMczZpZTB6SjlNZEd0bDRjejBM?=
	=?utf-8?B?amdUbjVnOWFUUkVQa3ZZc0N3ZE9TclFpaVo2djl4cm14bGVGalhhbFdDK2RN?=
	=?utf-8?B?LzZ0azhaejdrZWpUR0Z5bGJqZkJ1bW92UE12SWxKcjRNQVhSSWF2S21mL0lo?=
	=?utf-8?B?MUZXNHZwaTNYMVJJNWRQTThVek5Nb0dmZEIxOWxTYTFERjBSWmlYcUVsOWxL?=
	=?utf-8?B?UzVJbVF3K3Y5TFhZaEdPSGpDMUo1NU9aTDhTRTZtU210K3hkWFRnOGhodXdN?=
	=?utf-8?B?R3dveUdqdHMwWHNheFNxVllzTXphemVzZWd0RXc0b3B5STRDdmZoTGRWYnRC?=
	=?utf-8?B?dE4vazNDeG9uS3lzZGozN2V1eXY4UXZXNTBRaVBRQ0FCcXdNcXdkd1JqcWtN?=
	=?utf-8?B?QU9QYmhrSFRXMDM0dGFPZGxHK0dDeThPYkVKeUgrSmhueDF4aStlamFyb2dF?=
	=?utf-8?B?V0xPcDNqU1NVTFYwcysvWXJsVFpqNzR1c0VlYWxFZjdBUDNSTEFjTE9kOWFM?=
	=?utf-8?B?NHFvMUpYUmMzT00wS3hRZkp5YjIwR1RJQVMvRmVoaGpXa3FxeGR4MUtxYnpw?=
	=?utf-8?B?ekpPK05LT3lMRFJjdzk3WnZvYWdCMXc1MDg4aGd2WTZxWkZXWVB2NEIySGtv?=
	=?utf-8?B?cHF5VDkxTnhCWDVvVVRpVGsydGNEMWJ6cDdUejJIZHVOek96YUlhOTR0Mkdw?=
	=?utf-8?B?QnNSdk9BMkZuZEFObDdSQVp2RXpmblQyV3BpdTN4dUhqdFBDaFBvTWd5YnRO?=
	=?utf-8?B?NGFYU0twakF1Wno1SGRTc3ZvOERQZXJubzhSTjB6V1U3alBnK1R4Y09iNmFE?=
	=?utf-8?B?OU5FYTNnOFpEY2d2anN6NFIva3I2Z0RUK3NidW9LYXU4WjY5c3JsNVBYVXow?=
	=?utf-8?B?SVJ2YUc0L3d0QmltVjhsSzVOYW5MK2VpaVdqNDJMazRvdDdHZjVNTlJjQlQw?=
	=?utf-8?B?NForZUlKRWpVeWRWVGN5aXh4Q3oyVjRvWDRCS2h3dXg5ZTJmVSthZlhualN3?=
	=?utf-8?B?Vjk4cFVaaXpUeUFVaFBGenV5cTJuUDlwaStWbzJKUWZwby9DWTRadmpuVVRq?=
	=?utf-8?B?QS9NaGExUldRYU16bWpWd051ZktQa1lOYkREMlh3RHFENGhGUWJCeVRKTklL?=
	=?utf-8?B?ZTBsSmttTDMwcXZSNk4wbzFLdGRjRXp1MFl6K3dQakV2Uzc5SGJ0WGZjdXRC?=
	=?utf-8?B?QnRVMGJVUWtDY2RZUGVqNlJMUjhtV3lTaCs0M3FNdFZjOWhpaFg4T2NCTVlQ?=
	=?utf-8?B?b3RsVnVDQmpKMVlKa25HNmdaWDRuR01DNVI1MnhVVlppSjZQM3R1d2MzRUZh?=
	=?utf-8?B?dENjTE1ONFZVVldoY1FKNEwxNlh1N28rRitJOGROM0YyUkpPUVlYY3dXc3RH?=
	=?utf-8?B?blRMeFJuaHpRTm0wNm5JdlArRnA1cmR0Z2k3SEw1MURvQWdVam5RQVlOUFJJ?=
	=?utf-8?B?YzVaWjlWczROUENDWXpJOTdEa3QzZnpkcVY0bWxBTm9yNUUvSHJaRUM1dzNR?=
	=?utf-8?B?ZVY1NkFtWFRUN01ROUVKSC9HeTViMHZRN1N1a2MxR3Y5cDhpWVFJa0cyZEFF?=
	=?utf-8?B?V3JLdXd4WnZCajM5NTZYN203bzZsUk1oZk9aTzRUV01TKzJYOWRYUy9lVHFO?=
	=?utf-8?B?WDNBWU9xSm52YkIrSC9iLzlkYzBWMDBkU0ZySXhBUVdPdVNudDd5dUl2dFlB?=
	=?utf-8?B?Q0pSN1ByVk4zSm9vNWtxSm1INkQ2a01iTGhraFc2amphRjBrUEFLZ3Q1N0M2?=
	=?utf-8?B?VFpnc3RpaGxoVzhLcUJ5VzNmWTIvV1lKZ1Z1ZmNxNGFJckVmTjE0ZTV5QzJX?=
	=?utf-8?B?REU5bWRpUC9NWmJpRUhvQk1PMWpsM2lzT3Z3cUh5UWRDRVJVMXpUbWJjS1E5?=
	=?utf-8?B?QnNMSXhIM2p1cWI0YnVPR2xqUGVGQ04rbk8weTdidFNQWEl3aVZyWEVsb3l5?=
	=?utf-8?B?UmUzczFleWd3SVNlY2tiSUZiSmtpbC9Hd1pwaGtDRGpZRmVtM1lmbzA5b2xI?=
	=?utf-8?B?WHQxYmVydHQ2QzRVSDQ4Z1F1ZHZJYWpvTUcraUJiWlNiRFRaa25PbnRZdVNK?=
	=?utf-8?B?Q1RRN3dUMmFXUitqOVI3a0ZucWY1RmNtSzNoa08zNUFhb1dGaTYzcEh3U2w1?=
	=?utf-8?B?a3c9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c63dd04-4318-4fd4-01b4-08d9e94a36bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:25:20.3594 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nlt7apsf45bNsbHz7v0bYht/2LSiUXv6ymLd0b2dzQsNBmVCPlAfSMzJOUbStzKBh9O5RIfTH5yRgTssTTD0Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3023
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10249
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202060060
X-Proofpoint-ORIG-GUID: fhYGJugiiDgstLJsBtpgelt3g_j4zRPr
X-Proofpoint-GUID: fhYGJugiiDgstLJsBtpgelt3g_j4zRPr
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2168PgKf020174
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
Subject: Re: [dm-devel] [PATCH v5 4/7] dax: add dax_recovery_write to dax_op
 and dm target type
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <64B088008BA96342963236BED03D9A0E@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/2022 10:03 PM, Dan Williams wrote:
> On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> dax_recovery_write() dax op is only required for DAX device that
>> export DAXDEV_RECOVERY indicating its capability to recover from
>> poisons.
>>
>> DM may be nested, if part of the base dax devices forming a DM
>> device support dax recovery, the DM device is marked with such
>> capability.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> [..]
>> diff --git a/include/linux/dax.h b/include/linux/dax.h
>> index 2fc776653c6e..1b3d6ebf3e49 100644
>> --- a/include/linux/dax.h
>> +++ b/include/linux/dax.h
>> @@ -30,6 +30,9 @@ struct dax_operations {
>>                          sector_t, sector_t);
>>          /* zero_page_range: required operation. Zero page range   */
>>          int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>> +       /* recovery_write: optional operation. */
>> +       size_t (*recovery_write)(struct dax_device *, pgoff_t, void *, size_t,
>> +                               struct iov_iter *);
> 
> The removal of the ->copy_{to,from}_iter() operations set the
> precedent that dax ops should not be needed when the operation can be
> carried out generically. The only need to call back to the pmem driver
> is so that it can call nvdimm_clear_poison(). nvdimm_clear_poison() in
> turn only needs the 'struct device' hosting the pmem and the physical
> address to be cleared. The physical address is already returned by
> dax_direct_access(). The device is something that could be added to
> dax_device, and the pgmap could host the callback that pmem fills in.
> Something like:
> 
> 
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 58eda16f5c53..36486ba4753a 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -694,6 +694,7 @@ static int __nvdimm_setup_pfn(struct nd_pfn
> *nd_pfn, struct dev_pagemap *pgmap)
>                  .end = nsio->res.end - end_trunc,
>          };
>          pgmap->nr_range = 1;
> +       pgmap->owner = &nd_pfn->dev;
>          if (nd_pfn->mode == PFN_MODE_RAM) {
>                  if (offset < reserve)
>                          return -EINVAL;
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 58d95242a836..95e1b6326f88 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -481,6 +481,7 @@ static int pmem_attach_disk(struct device *dev,
>          }
>          set_dax_nocache(dax_dev);
>          set_dax_nomc(dax_dev);
> +       set_dax_pgmap(dax_dev, &pmem->pgmap);
>          if (is_nvdimm_sync(nd_region))
>                  set_dax_synchronous(dax_dev);
>          rc = dax_add_host(dax_dev, disk);
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 1fafcc38acba..8cb59b5df38b 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -81,6 +81,11 @@ struct dev_pagemap_ops {
> 
>   #define PGMAP_ALTMAP_VALID     (1 << 0)
> 
> +struct dev_pagemap_operations {
> +       size_t (*recovery_write)(struct dev_pagemap *pgmap, void *, size_t,
> +                                struct iov_iter *);
> +};
> +
>   /**
>    * struct dev_pagemap - metadata for ZONE_DEVICE mappings
>    * @altmap: pre-allocated/reserved memory for vmemmap allocations
> @@ -111,12 +116,15 @@ struct dev_pagemap {
>          const struct dev_pagemap_ops *ops;
>          void *owner;
>          int nr_range;
> +       struct dev_pagemap_operations ops;
>          union {
>                  struct range range;
>                  struct range ranges[0];
>          };
>   };
> 
> ...then DM does not need to be involved in the recovery path, fs/dax.c
> just does dax_direct_access(..., DAX_RECOVERY, ...) and then looks up
> the pgmap to generically coordinate the recovery_write(). The pmem
> driver would be responsible for setting pgmap->recovery_write() to a
> function that calls nvdimm_clear_poison().
> 
> This arch works for anything that can be described by a pgmap, and
> supports error clearing, it need not be limited to the pmem block
> driver.

This is an interesting idea, let me give it a try and get back to you.

Thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

