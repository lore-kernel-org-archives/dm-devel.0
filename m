Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0071AC433EF
	for <dm-devel@archiver.kernel.org>; Sun,  6 Feb 2022 08:29:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-iau8wEkjNEKZ43VvGSZufw-1; Sun, 06 Feb 2022 03:29:44 -0500
X-MC-Unique: iau8wEkjNEKZ43VvGSZufw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B4A61800D50;
	Sun,  6 Feb 2022 08:29:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E92F97AB69;
	Sun,  6 Feb 2022 08:29:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC4A11809CB8;
	Sun,  6 Feb 2022 08:29:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2168TbHj020388 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 03:29:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D5FE9C08097; Sun,  6 Feb 2022 08:29:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0B90C08099
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:29:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFDFA1066692
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:29:37 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-303-EWX9yxryMQqMW2JvNCS5fg-1; Sun, 06 Feb 2022 03:29:35 -0500
X-MC-Unique: EWX9yxryMQqMW2JvNCS5fg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21664ixo007379; Sun, 6 Feb 2022 08:29:19 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e1gustrr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:29:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2168BeOe147452;
	Sun, 6 Feb 2022 08:29:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by userp3030.oracle.com with ESMTP id 3e1ebv4j7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:29:18 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3174.namprd10.prod.outlook.com (2603:10b6:a03:159::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Sun, 6 Feb 2022 08:29:16 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4951.018;
	Sun, 6 Feb 2022 08:29:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Thread-Topic: [PATCH v5 2/7] dax: introduce dax device flag DAXDEV_RECOVERY
Thread-Index: AQHYFI6IEi37NS8sIkiGyAObMdfpFKyARuiAgACHZgCAARCGAIABBPgAgAAER4CAA1YQgA==
Date: Sun, 6 Feb 2022 08:29:15 +0000
Message-ID: <7a5d4def-a054-a445-2438-2333df713e48@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-3-jane.chu@oracle.com>
	<YfqFuUsvuUUUWKfu@infradead.org>
	<45b4a944-1fb1-73e2-b1f8-213e60e27a72@oracle.com>
	<Yfvb6l/8AJJhRXKs@infradead.org>
	<CAPcyv4i99BhF+JndtanBuOWRc3eh1C=-CyswhvLDeDSeTHSUZw@mail.gmail.com>
	<CAPcyv4hCf0WpRyNx4vo0_+-w1ABX0cJTyLozPYEqiqR0i_H1_Q@mail.gmail.com>
In-Reply-To: <CAPcyv4hCf0WpRyNx4vo0_+-w1ABX0cJTyLozPYEqiqR0i_H1_Q@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 700bcb9c-dc41-4a85-6390-08d9e94ac31d
x-ms-traffictypediagnostic: BYAPR10MB3174:EE_
x-microsoft-antispam-prvs: <BYAPR10MB31741E12E04093CA556EE490F32B9@BYAPR10MB3174.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eYO3dqNF/y+kjUASndn59QIPtlczk+1BwOfd0g6O8Sl0rE9Jf0+verZO1gHiCoysqtfN/hqi62DyC0HLur2rBbJR9NNU1Bt3QXhiX6fZy8s/Hjg7Sbzkqg61Tl/ZrwW91N5iIlfAoGQ2PNM71MrsL1u8NLIU3Sz6rHFEp5Gs0ejvwyE9N/MkZZl0xtn4Zv9Uu+gld/kwewRMnSDI0jaTrTHNaM+x/MOt6QTBFH7x6wkrYyBtvDh+jm8Y9LS8IaBPEydl6J54mPauEEFadl9Z4BP2i/gpA/9vUWuujxBPvQII7Cc0iVFahd/sUTCvkmh/rSdTiXeUciJVN9+5ISNIIWr65ssTWzSl4e3I34SqYujL0eTLyLzCrjXzgvSpusotHDCt77wKef6bh2ORjCYKh9ZCPHDzjByoCVnBQZGR3R5pvo5QwayUgVD8mRzZawai2XTRw4rqjwoVTXB4s+FWhgJSxAhTGhYgJzsCB+SCc8FWS0i5f9qnDBpArDYtOo5KGRouZQn2NuSKutXuwSZkUxi8b6VVX+lo3F+ELANnwwKJ5RpyFyU/DowCjiGNWOVWQgs6EkGD5jbJTJymTSbH7eoYT0Yxug7oNmBr/gNHwuriCR32X85ikhqqtcKdP6/xDnR7etxr476eLiT2dAqLghY9QFqHCj075iJdmQVW1rCRurG1VVLIIL1TH28NDbAn7+QVH03GApofvdRnQ9xsj6PGaEHegkJ0Fuk++HgvWGlybuNY3QV41FRb7+JbOhwTUGWD1FbNkkQl5RdM5cgLzw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(36756003)(26005)(186003)(316002)(6512007)(6506007)(54906003)(71200400001)(122000001)(38100700002)(2906002)(2616005)(31686004)(53546011)(110136005)(31696002)(83380400001)(38070700005)(86362001)(44832011)(66946007)(5660300002)(508600001)(7416002)(8676002)(8936002)(4326008)(66446008)(66476007)(66556008)(76116006)(6486002)(64756008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXhsVHMyU1JUR3FEWFp3RTRJa2ErMFUxNzMvYmUzaUhudmkxZU9CdW1Nb3JO?=
	=?utf-8?B?ZXE4RUFsNUovbTVSNlpOTG5pSG1YWG5PSXNCeUdQMkU5NmFCV0M1WWRiYWk4?=
	=?utf-8?B?SEg1MVhxVG1Bdm54a0wvSlQyMDBSN3BqY2FuaFFKR1gxdVRSSHk3V09OYnlM?=
	=?utf-8?B?R1l6KzBXUmxxcFQ3QkMxdk00WE1UTCtieFdpekJablVhNzFpN0xiUlc3Rk03?=
	=?utf-8?B?SmVSRHR5RnVmZmJKQ05uNWZqSjRHTW1MeGh4SVd3a3g5c2l0M0RkZjJDVUpD?=
	=?utf-8?B?eU13a2h0cFFVRFk2UWs3YmxzcW5RN3BQbEp6dWpSejF4V2ZzaUNhblFYMlFE?=
	=?utf-8?B?bWc0empGS0IyY1ZsT2J0R2IrSUtJeitQU3kyM3AybnF1Tit4OUpSUzlCaWMy?=
	=?utf-8?B?amwwNW9ici9IL0Vqd1J3amNacmJ4KzZHbElHNVBnZHp2RW1TWGladjJtaHdQ?=
	=?utf-8?B?STBLd1lMTFo0VjNTWUIzdkhKamlRMldBOU5nR24yOFhMR1NNa3ZsWjBUQ3k0?=
	=?utf-8?B?ZmhEMnJrRW1ZVjFlU2svMVl6MjhjQnQ1MkM4VDZNT25NV0JxN2pSWXRDem4x?=
	=?utf-8?B?TWI5RktaeWs0UkNDZkNGVk1ydEVWSTZ0NkJvTTd4bnRFQ0pXUDRjQWhWdEFM?=
	=?utf-8?B?QmhEZmQvYUxCd2tPeE9aWjB2eE1pb1NmWUtTZkZaVDllVzVZbERraXBRY1cy?=
	=?utf-8?B?WTJoK3NEMFhYV3hNNDdkbm5PL2JaSlgyK2I0Z1QxNjhMNjN6N0RzRVU4Yzht?=
	=?utf-8?B?VXVNSy9wSUVMMFRvNi9PWHhYdVVzUTZQK3RmbGs0YzRHdXBIcjhkQzZ5Smp6?=
	=?utf-8?B?UjE1K3FpSkhITk90S0s0b2hBTVBRZWhPODhjZmliL3V4bmNFTElBUHRRTWRR?=
	=?utf-8?B?TFNWZTZkMlhXVGVTMGVhTWJZcWtsM2NSOFJNbUx2UEx6L05MUExsQTFDMGhL?=
	=?utf-8?B?Y2tlbGtCeWpCWWEvQ0E5RGhTM0dHQWY5S3JzSEpkZUF5cC8yMHN0RDl6OGJI?=
	=?utf-8?B?dXVNUXRJWnppSDNZSXM0aUk4SlJyRXhDL240eURpQnF1UlNPTzFuRUNhcDVj?=
	=?utf-8?B?V0V1Z2h5eTkyN1UvcXpqdHpSZllLNkFqcHhIZ09aVWNCQmRsQXhRaXM2YVNN?=
	=?utf-8?B?RnVYbFo5Sm5mcWtYVDVpREpDTmlRejc3OGo2eDVHSnc4MElVN1didG9zZmtv?=
	=?utf-8?B?TVlmUkUva1JUdGVyb05ITTVZMlI0aGVGVkNLR2pJUmdpYisvMFU0YkJWM2JP?=
	=?utf-8?B?WkdrZTdhNFdDTGp2cENFNzFaUXlFSDdQK3FRdkVSOVlIYmJBdkthbEFzYURS?=
	=?utf-8?B?T3JDRUJTdUtkTzNzY1ROWXBGeHB5N1VKRXkvVExOSGxBdjlTQ3RtZExkYkRM?=
	=?utf-8?B?Sm9QcEx1Y3VnYndseFVHWHJrS3FBc3R6VGY0N3JuV3U5Q0VOWkdvNVRzaEs2?=
	=?utf-8?B?TFlzaWVJMjdodFZDYko4NUFNMTJtbFlpamZiNG5oMGg3MlZOazl3bXRYMkFh?=
	=?utf-8?B?TUNnWHEyRWpwb1R3SFluanN6OUZnelE1OHBnekFpbkVsUUVmQkxXMlI1bzQv?=
	=?utf-8?B?YkZzWjFDbmVTV3pwWU1kbHlOS2RYOSswa3V1K3JLclNKWWszbVNGUi84Tks4?=
	=?utf-8?B?MVhMWlNKWllYbHd6UW00ZlpNNTBvRE9NTUIrS0JvSjkvWi9FZmtQdkRxSU85?=
	=?utf-8?B?ZDhtM09UUUdNdTlycEkzUFBZcS84VXVHNS9yUmlTWHhka3ZWaHduNExsZ3J0?=
	=?utf-8?B?bFcycWl5cDQ2a2k3MlF6TFFzbk5LMW9aV3l1K1hiVkVCZnNmV3JnVFRmdGJS?=
	=?utf-8?B?NmJpVkxCbzV0OHRRL3lZOXNDcGhadGFXVTk5YWgvMmFzUFFKSjlGa2MxVEh4?=
	=?utf-8?B?aXcwSlR6aXNTc2lkdGYwVGJGOUFDU2Y5dkNpUG43QmhTRGRoOWNWcTNSYU5N?=
	=?utf-8?B?RE56MkJJYUpDOTNhUGhMTG9TSW5aZWlEVE5PNi9WUlowSU1IdWpPYUtsL0x3?=
	=?utf-8?B?YlM4WG5aRDF2aUFqNTRnckVzWkMvMmVEbkVqaXp5V2VERmZGdU90RmVMZjRt?=
	=?utf-8?B?TmJIeURjR1IxR29iZnZkM2VzMW5mVW53V1VnTWV3eFg3RU9HV2ZuZFF2d01h?=
	=?utf-8?B?amFQVDlKcDZmaTNkakZ1aTFSZThMMkpqQmdwZmtIQUVYYzMxSjNDVnV5QXdj?=
	=?utf-8?B?ZFE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700bcb9c-dc41-4a85-6390-08d9e94ac31d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:29:15.7470 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b11312b5djKxxTg/zo/uUDlJvrLZOVGmzHGV5Qq3eoQtI27d+xyF5jUqbDXYP0j+7dnV7CLH0KhfaeEoNW2ZKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3174
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10249
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 suspectscore=0
	mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202060060
X-Proofpoint-ORIG-GUID: GlKaU_tQhDs7EQpX2d8lt-3BgJxQyQjr
X-Proofpoint-GUID: GlKaU_tQhDs7EQpX2d8lt-3BgJxQyQjr
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2168TbHj020388
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
Subject: Re: [dm-devel] [PATCH v5 2/7] dax: introduce dax device flag
	DAXDEV_RECOVERY
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
Content-ID: <023C2240804C624FAEA4D47B24097260@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/2022 9:32 PM, Dan Williams wrote:
> On Thu, Feb 3, 2022 at 9:17 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> On Thu, Feb 3, 2022 at 5:43 AM Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>> On Wed, Feb 02, 2022 at 09:27:42PM +0000, Jane Chu wrote:
>>>> Yeah, I see.  Would you suggest a way to pass the indication from
>>>> dax_iomap_iter to dax_direct_access that the caller intends the
>>>> callee to ignore poison in the range because the caller intends
>>>> to do recovery_write? We tried adding a flag to dax_direct_access, and
>>>> that wasn't liked if I recall.
>>>
>>> To me a flag seems cleaner than this magic, but let's wait for Dan to
>>> chime in.
>>
>> So back in November I suggested modifying the kaddr, mainly to avoid
>> touching all the dax_direct_access() call sites [1]. However, now
>> seeing the code and Chrisoph's comment I think this either wants type
>> safety (e.g. 'dax_addr_t *'), or just add a new flag. Given both of
>> those options involve touching all dax_direct_access() call sites and
>> a @flags operation is more extensible if any other scenarios arrive
>> lets go ahead and plumb a flag and skip the magic.
> 
> Just to be clear we are talking about a flow like:
> 
>          flags = 0;
>          rc = dax_direct_access(..., &kaddr, flags, ...);
>          if (unlikely(rc)) {
>                  flags |= DAX_RECOVERY;
>                  dax_direct_access(..., &kaddr, flags, ...);
>                  return dax_recovery_{read,write}(..., kaddr, ...);
>          }
>          return copy_{mc_to_iter,from_iter_flushcache}(...);

Okay, will go with a flag.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

