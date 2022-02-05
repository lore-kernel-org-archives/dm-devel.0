Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633DBC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:34:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-5rI_pkQuOIKAA6Huegjo6A-1; Mon, 07 Feb 2022 04:34:31 -0500
X-MC-Unique: 5rI_pkQuOIKAA6Huegjo6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BFD21006AA9;
	Mon,  7 Feb 2022 09:34:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BB4B2A17C;
	Mon,  7 Feb 2022 09:34:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 226A44A7C8;
	Mon,  7 Feb 2022 09:34:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21533aFi004063 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 22:03:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 20D25417EC6; Sat,  5 Feb 2022 03:03:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AE9E401E6B
	for <dm-devel@redhat.com>; Sat,  5 Feb 2022 03:03:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFFED811E7A
	for <dm-devel@redhat.com>; Sat,  5 Feb 2022 03:03:35 +0000 (UTC)
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
	[148.163.143.35]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-175-InvdjTHwOEqXQEFPPUrgcw-1; Fri, 04 Feb 2022 22:03:32 -0500
X-MC-Unique: InvdjTHwOEqXQEFPPUrgcw-1
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id
	2150U3fG007626; Sat, 5 Feb 2022 03:03:29 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
	[15.241.140.73])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3e1erdrstq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sat, 05 Feb 2022 03:03:28 +0000
Received: from G4W9121.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
	[16.210.21.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 07C4C57;
	Sat,  5 Feb 2022 03:03:28 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
	G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) with Microsoft
	SMTP Server (TLS) id 15.0.1497.23; Sat, 5 Feb 2022 03:03:27 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.241.52.10) by
	G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP
	Server (TLS)
	id 15.0.1497.23 via Frontend Transport; Sat, 5 Feb 2022 03:03:27 +0000
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:434::21)
	by DM4PR84MB1901.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4c::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16;
	Sat, 5 Feb 2022 03:03:26 +0000
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
	([fe80::f8ec:1dee:fed5:f051]) by
	SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
	([fe80::f8ec:1dee:fed5:f051%5]) with mapi id 15.20.4951.012;
	Sat, 5 Feb 2022 03:03:26 +0000
From: "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
To: Milan Broz <gmazyland@gmail.com>
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHYGXmiT1kBxk65DkuP81XVV9oHsKyDAvwAgAEozvA=
Date: Sat, 5 Feb 2022 03:03:26 +0000
Message-ID: <SJ0PR84MB182225795091C5A502E6B6E7C22A9@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
	<yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
	<e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
In-Reply-To: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 354df647-d057-44e2-cc4a-08d9e854141f
x-ms-traffictypediagnostic: DM4PR84MB1901:EE_
x-microsoft-antispam-prvs: <DM4PR84MB19012BF4AB240A170AAA4CFDC22A9@DM4PR84MB1901.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XS0JsOI2BWADM+hf0rJfbRGh4q3lKvoZo9MCQxIeGhv7gh3Ro+mEw6jigpzZWBUKHtNBsut0ykZLkJupGkEpxjk9nRT/bvtLlm4xdhAww9pXtNnLSOfHxnvJBLMnpoxBeRulziKIVo5r94cace8PLV3EJToar/U46enuAir1rn/4RjgpbeOcCSoVCYEY1GevdqJ4A6gPe9N3YeZXt2fWrIQYZML7KEcF/o4KA1nVWix6hPuTSGIaLzd/+ccFfIWbm4PwRNkJGkGi4VvJHayj44N+sAInaglOVrtl+Qbgfw6PQobCzuHrKVCQvljbaztInNAA7miZU83LYJ2IUJ4kO0+iF7MPDpQMGcMOpVFN/WFl3mOLmEYCkuUql8Jx9a+BsjtiKcUZwlYITCFP2eqz2ULi67jiWv0s2LKL3beUL/riIWzYtAThinpX2FHI/bcxsMw+ehT1r+5UilagPiFlpIkwrx/g1gD4yMc6RTfW4PTLfSgSDv4RUY5+S5xy4JkYTfNJkwxfwsHyXXcPHPz4E/TM5BEB8PY1TwhLJEpftRSQiqW0OikvSXJ48QSEpV+WX1TbbKhu36oOTLjVYNGUsmb+75zbXPAiI+WT2l+4Pualj3s8sw/5H7MOJTmQMoftKyIF4mLPu/ZCyTaLRi/9VH1BB9EBR8rRzi1slGvM/Z+iWpvUv0heO/SmBt8JcF7E9yLmLisfL2MN80JpODFUnw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(64756008)(8936002)(8676002)(4326008)(52536014)(66476007)(66446008)(316002)(83380400001)(38100700002)(7416002)(6916009)(54906003)(82960400001)(5660300002)(122000001)(9686003)(38070700005)(86362001)(186003)(26005)(2906002)(33656002)(508600001)(66556008)(76116006)(66946007)(6506007)(7696005)(71200400001)(53546011)(55016003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlZNdjcxQ3pMMlU2T013VUJyb29iOC9aYm5oWSt5cjE0YUJrNDYzM1pPZXQ3?=
	=?utf-8?B?cmlSeGpzbXFQVFBScmVVb1lQTTV1a3dMUE1vSXAvV2drMzVSYzh2ZHk1b1h2?=
	=?utf-8?B?VWVOZnJJWUNiOEVwQ1hqKzdUR1Vub1ZMU0tHblB2SVFBRHVlTUozL1g0L3dI?=
	=?utf-8?B?MUJlMW1GQnN2VHcyY000RWhRNkRMZHVTaC9hN2I1WUxiVmIxWTZTTDV5OXMz?=
	=?utf-8?B?MWdNMENMVjBTYmFpUWUzbEYwVHFUOEFWZkhMWS9BcVNRMWIxRGJzWEFRVHVa?=
	=?utf-8?B?Z3FIS1lYWkJRR3dabWZtTkhEa2NqbkRQL3lUbTZZTTNZeXNDSlB0U3BMRGF3?=
	=?utf-8?B?bzBWMnpwL21OSUY0L0tKM2JRdnpFK25aYjJGVnpCNS9kaEE1MXB5SXViN2R4?=
	=?utf-8?B?eWNjdW43OElZOERyU3NGaDgzcHVZQTAvc3l3bXg0VTNyTjRZRTNKdXFXVW1U?=
	=?utf-8?B?U1RCS1pFRC91NFpsZHkyU0MrcDdPamh1QlFHZlBEeVpHVnJpY095NnFvU1JG?=
	=?utf-8?B?aGtRZ2lNQ0d2V3lKVlhhLzY1OFAzU0RtQkQrR3lOWStiRlNCL1hib0dlNWVT?=
	=?utf-8?B?NzhwVE1FcWNkQlpURVI3dFluQVVPTHQvbWtsMEprZndNWTQyTExvMzVRSDdW?=
	=?utf-8?B?bFFCSDlacVp4QzBqWmcxaEQ4cldFcXNIdi95MEVydUVJTWZ5ME9YRkRvZlZQ?=
	=?utf-8?B?VllGUDEyemdWTW9RNzRRQzFqaFAvUFpEbndvMVlaRlpCL3BOUXZGbm5IazVu?=
	=?utf-8?B?Y3NCWjJ1VjlLcERQeDZMbEtGZEJDVDI4TmV6S2hsTTl4eER3NVdQdFhCTVdM?=
	=?utf-8?B?VXUxd2dFUUlZdXpvb2hEbDl6N0tEcExvYnp5Sm03ZWIza0gvcWU1N2g3bEdj?=
	=?utf-8?B?VHY3R2N0Z0JlUlh0cGZ5eTJPRjNSRHBFcFloSzBmNDArb1UxeXg2dk9ZUnkv?=
	=?utf-8?B?bTMvcWwxbmsrektEYlhxbXl3ZFdaaTROaXRLNmhRMVZlbEZiSnpmdjdrYW1J?=
	=?utf-8?B?d0tCOVBzRmNSZGlweWxrelZWRjNxQ3MrcmhpQWtJa0FjaFZRc0VMdVlqNUVo?=
	=?utf-8?B?MERCWG5qVE14b2VRWms3UW9XM2I4Z1h5UDBrVlk1YWZKSDQyN2h1dWY3a0pW?=
	=?utf-8?B?bC9FSWFydXJ1NkNHOTIrUklNWlltbzRMQWE0OEl0SllBZXo1UUovakNaVE04?=
	=?utf-8?B?KzVpZXlYakpGZTdhVnROT0I2TDA2RzFWNFNsamhidXpQRlpFMG42MlkzWEdw?=
	=?utf-8?B?Z3VROUFRQkFLbjZoMWJSZWo2dzZ1QjFSa1VRd1BoVzgxNWxTWEU4Y0VHNmZH?=
	=?utf-8?B?WHdDVWFaT0NRenoxQmt5L3kycGlkTTJuYTV0MVpqMVM2bG9CUHg0aGJTNUM2?=
	=?utf-8?B?VENROGFzeGpmNHFBY2UwVUNlN1c0RnF1OTFrLzNGT3BnZ3hTTlBVQXE0R29O?=
	=?utf-8?B?bEFCS2U2ajJtaU1XRFp1VEJjR0UzamRhNjVXV0lJbm5wbzlackUzVVI1NU5V?=
	=?utf-8?B?UFVoVEZjMWFWekRBTnJyS2dCb0U5dkF5Nng5OVEwNlEydFNUVndYbStuMWJx?=
	=?utf-8?B?dzdlN2NLYS9lTEdDS1ZkdFphdEFDRDJXZ0pSUi9YbkRWeEVDUGdEd3JCOW1j?=
	=?utf-8?B?bFlkK1VKUWs0MVpralp2NXBiTGtHSDJ2Mk9RTFJvMUMxZ1YzTUtzdlJMZ3Va?=
	=?utf-8?B?YTR3cmwwc00vQm0xY1VsNlgwNzVMZkZjYTJwTExVSTFTSXN4WHJBZ1piczhU?=
	=?utf-8?B?ME9BNnN6aHNqTkhZTTdoR0wrdktQTDQxM3d6TVB6MzBvMG55UmFaNlBkenZk?=
	=?utf-8?B?bzEvdXJ6UDl3TnNhYkRVaHR5VStMWXBvOUNpQ0c5QWxFUnk5Y1VNV01Gbmcy?=
	=?utf-8?B?QXNNNUsrTzlNd0lybzdtRVZSVGtLNFhxek1FVXdKRVQ1Mm9YcGt0a3hIcCtz?=
	=?utf-8?B?YUdUZkwyaTZ6Q3VvWkUrUmt3MXpHNFZCdHF3YVhsbmF1NWlEY0pGMU9oRnBQ?=
	=?utf-8?B?TEJ0aHlhZkxhdWhqNnRVTVAxYXBxZW9HaEhTc28rcDZlbi9lK0Z5bzJ4aDhH?=
	=?utf-8?B?S01DVzZhdkVzcDR2Y1YyTGYwK2lRNmlJQ3d0TjBraFcyRCtxQnI5a1IwZ2xF?=
	=?utf-8?B?ck9KYU40OHZaUmpUcktRbkJQQ1N2NE5WaklxR3hFQnZDeldBQnZ6VDJJVzFJ?=
	=?utf-8?B?S2c9PQ==?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 354df647-d057-44e2-cc4a-08d9e854141f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2022 03:03:26.1223 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8K9a/xo9rcnygBRek/F6uES71BK1SGBxGkCGOca4FpHWN8Kmj8qwJ+0RHG/QAf8lP0ZOiD0N6aj3R90AJ6M4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1901
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: g9Vhed7E_CH_EKh3hukwc813oi6xoHVs
X-Proofpoint-ORIG-GUID: g9Vhed7E_CH_EKh3hukwc813oi6xoHVs
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0 suspectscore=0
	mlxlogscore=971 spamscore=0 mlxscore=0 priorityscore=1501
	lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1011
	adultscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202050015
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21533aFi004063
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Dmitry
	Fomichev <dmitry.fomichev@wdc.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>, Mikulas
	Patocka <mpatocka@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
Subject: Re: [dm-devel] [PATCH 0/1] t10-pi bio split fix
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 04/02/2022 08:43 +0100, Milan Broz wrote:

> What's the problem here you are trying to fix?
> Even if I read linux-block posts, I do not understand the context..

1. Let me demonstrate this issue with the following example.

Given a driver which maps a bio to underlying devices with 4096 logical block size and the mapping:
bio: sector:0, size:32, dir:WRITE
Virtual LBA     Physical LBA
0               0
1               1
2               0
3               1

The Type 1 or 2 integrity is generated in bio_integrity_prep() by generate_fn as:
Virtual LBA     Virtual ref_tags
0               0
1               1
2               2
3               3

According to the mapping bio_split() would split it at 16. That would advance bip_iter.bi_sector (aka seed, see bip_get_seed()) by 16.
Virtual LBA     Physical LBA    seed
Split bio
0               0               0
1               1
Updated bio: sector:16, size:16
2               0               16
3               1               +1

Remapped updated bio: sector:0
Submitting it we expect to have ref_tags remapped to the actual physical start sector at the integrity prepare_fn and incremented by one per block of data:
Virtual LBA     Physical LBA    seed    virtual tags    ref_tags
2               0               2       2               16
3               1                +1      3               17

But we get with the current code a wrong seed (0+16) and there is no ref_tages remapping in the block integrity prepare_fn:
Virtual LBA     Physical LBA    seed    virtual tags    ref_tags
2               0               16      2               2
3               1                +1      3               3
This IO would fail by the NVME controller with Reference Tag Check Error (84h) because the first reference tag (2) is not equal to start LBA (16).

Martin's patch resolves this issue advancing the seed (bip_iter.bi_sector) properly by the number of integrity intervals (2) so the tag's remapping takes place in prepare_fn:
                                if (be32_to_cpu(pi->ref_tag) == virt)
                                        pi->ref_tag = cpu_to_be32(ref_tag);

2. Browsing the code I found a snippet of advancing the integrity seed directly, without calling bio_advance->bio_integrity_advance
I hope it does not introduce the abovementioned issue, please advise.

Dmitry

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

