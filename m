Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCEDC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 00:26:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-WfPc4UYcNl6yMuKa3U_A_g-1; Wed, 26 Jan 2022 19:26:35 -0500
X-MC-Unique: WfPc4UYcNl6yMuKa3U_A_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4C7839A44;
	Thu, 27 Jan 2022 00:26:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA5AF5ED5B;
	Thu, 27 Jan 2022 00:26:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA9051809CB8;
	Thu, 27 Jan 2022 00:26:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R0QNlX007240 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 19:26:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D1A072026604; Thu, 27 Jan 2022 00:26:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC1B62026609
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 00:26:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A15E1C03382
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 00:26:19 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-299-c7CjQTb6NuaFMOKZi0-BYg-1; Wed, 26 Jan 2022 19:26:15 -0500
X-MC-Unique: c7CjQTb6NuaFMOKZi0-BYg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20QKZ7qj017314; Thu, 27 Jan 2022 00:26:00 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dsy9s7k2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jan 2022 00:25:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R0H317046880;
	Thu, 27 Jan 2022 00:25:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by userp3030.oracle.com with ESMTP id 3dr7227whc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jan 2022 00:25:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SN4PR10MB5605.namprd10.prod.outlook.com (2603:10b6:806:208::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8;
	Thu, 27 Jan 2022 00:25:56 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.019;
	Thu, 27 Jan 2022 00:25:56 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v3 0/7] DAX poison recovery
Thread-Index: AQHYBx1mMl0+u9/A1ECT4doipsHhkaxruVyAgAEGPwCABTQgAIAEJu+A
Date: Thu, 27 Jan 2022 00:25:55 +0000
Message-ID: <eb09688d-2fa1-80c2-61e5-972ff58eadbf@oracle.com>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
	<Yekxd1/MboidZo4C@infradead.org>
	<4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
	<Ye5q7MSypmwdV4iT@infradead.org>
In-Reply-To: <Ye5q7MSypmwdV4iT@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcfde5b1-7718-4436-44d5-08d9e12b95b5
x-ms-traffictypediagnostic: SN4PR10MB5605:EE_
x-microsoft-antispam-prvs: <SN4PR10MB5605A165BB45CB68BB202B4BF3219@SN4PR10MB5605.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pvngJnniqeHTZRQu6d/8PEqHRwhbLeHeoCcDxdALouv9qjGvMXh8EaOsKsRQLQwjKDdazPMvN/ivFpmpLRgFrTE70VsgohceJ492il8ez5jnxpi8Vf7ROpIn5BVPHwibPX9lAjVhxcGBED1FPWIGpeAxtb0+FozHgCjVvKc3cQ7yUmi5TNeVlCIcp4wdgDWptQZWKY3TII9ObggJpXtO/1t4WtCoQNJKigEv3uYtZfi4Wq6qM7qRPxH4ZUu8T++S5eegyiKD18XoRhrbo1PY8JdICLLRikqvU3EsRYxivPnklT/HzNlt8ttxTJSN2jvr/5enEnHi22MSuy4/3z0YdCo8Z9+bp0bj3OYC2M2hD3fnBrQQ1ngB92qwjWDuNTPsadoIhyzxct/WsNqy2hIoKpjzMNbwmQ1tUVOYUBcvUBPq+0zAqApUw6O3T5iP4oz5y7H/dbss5SjQ9hj3EhYvGjYcInJ71ZR8my16Tx3jr3zynUAIO7XMuNaNc069qPbbyKy9C0h64yEP3+7SSatOdxs2rlVkoyreQ0QbBt1gfCMWCNVPhPAgkkK33fCCY/49Uga+dhgdEgtOMecYcCagv9Ine3QI8tv2RFCaqbSr4l8PU4eWa5Dyr9xkfJnKzM7FYFoWniN0fDaGyGkkP6/n/2e0xJ7nUO2yZSBMv0FnLXywKmSD/UvESyfWFIbKbCChWLW2KCzP7MyRHRRJjWxAE9xFv2PRHqWk0SL4CS7BKdnXFRfCw+oGBnaQJU32uDj0z6BgFkPEQstCg6XQCI+1Nw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6486002)(71200400001)(66946007)(66446008)(122000001)(316002)(31686004)(64756008)(44832011)(6512007)(76116006)(91956017)(26005)(38100700002)(7416002)(54906003)(2906002)(4326008)(83380400001)(38070700005)(8936002)(4744005)(36756003)(31696002)(8676002)(6916009)(186003)(86362001)(508600001)(2616005)(66476007)(66556008)(5660300002)(53546011)(6506007)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXEveW0vejhNVjZiOS9yR2orbnVITmRtTVV3bkpYSVcxYnlRYUE0REJjZnlY?=
	=?utf-8?B?WkdUMEtUd1JSVDFURGNsM2F1K2NLRHpMRWw1Q0pUcnBrWnM4VFQ3aTFwdW16?=
	=?utf-8?B?d0RGUTZNam13bnV5ZkNwMTBNb3dXcDFiaDlEUk9nUWlOUnRaazZnam5rMWkz?=
	=?utf-8?B?MGw1Mm1YZ1pyQ0tzUHh5Zm53N04rT0EvbUhGdEtJOU82K2owOVF6RjR1Ym5r?=
	=?utf-8?B?aS9qNHQyMnB6UjlybzZiVW5aNVlzL2pkSm9Benlja2VHWW5pYmQxWEJ5QVpm?=
	=?utf-8?B?Rk9LMGRmenFuWWc5ay9QTEhZSWsvc3lMelRFQ3hhWVhNaUhRT0JUUTZqZ2tI?=
	=?utf-8?B?TEI1MG5QOW1ua0JDMno3R2RNcE5ycGM1NXBNL284dHY4UlZ3cEc3bGQ2YlJr?=
	=?utf-8?B?M2EycFlJY011RHRlTmFNc1pwbS9icEVoOVEwOFdoTy9aK1ZwNnNUM1JUU2cw?=
	=?utf-8?B?NUMvSWVQTjBtZmlBQUovSk1Mb3VBaWFYcHo1MVlDNmNYaEZSeHJLRDREWUhL?=
	=?utf-8?B?VnMvek1DUE9KVWFIRnZHbWQ0eWFGd2Z2dEdLM3VmemhYM3FCYzFnd29iZHBq?=
	=?utf-8?B?ZHJRU3VzNlBNaXRZS1ZCNTRPcENCWUQwQUVTdXdOT1NHVFdJdXgwS3ZPcTda?=
	=?utf-8?B?RldvQ0pSTWtaNGVBVXZQVDZWc3lsVXNpdm1PSGFNWHlxNnd4b1lTU0d2b0RQ?=
	=?utf-8?B?SXVWTmZUQVFONDdWUVpSeUZIVjlHeHVIbGFJWTlCemVkSWFsdjQ0QlpJWWU1?=
	=?utf-8?B?NXdvZTZ1ejlwcTB4WE83bWlTNm5NV1U2SUpEMGJ5dkpWZ3VCeTBoaDByOWtH?=
	=?utf-8?B?ZDVBcmFIN2RmRFJqaWxFNitTZ1ZIMHVrY3d6NVp0Q0xyZVRPc3FpbW9VeVVx?=
	=?utf-8?B?bHR3b0VyR3phb1F5S1VDS1pDYklPZkZSWi8yOEk5UWlBbUR5UnlCeFhmeWZ2?=
	=?utf-8?B?SjJ0bStuVFdlWCtqZ3FLRXlkc2k0b0pMV0FzWHhDL1NLTWJKVUkvaHZWVUcy?=
	=?utf-8?B?cUlNaDhadVl4bVZsb0RvcEdrNWk2SzdBT1h1QkN4ODd1b0t5QzFpVWhacm9Z?=
	=?utf-8?B?VStUN1gzNXQ1L2xxa2JxdXI4ZDNQb0JBMG56QmlYcjFVbVljRU1DblVZQ3Az?=
	=?utf-8?B?K2xxL3FxN3FFK3hnOTZqVm4wYk16WVpPbWVqdlZDVEExZ2N0TndBMUJHWEJS?=
	=?utf-8?B?VHdGQkZGZnZ2c3hmbVNGdjROWWZtMmYyV0FUWUV0bTAyVERtcTMzNmdPcHVh?=
	=?utf-8?B?ZzNLaEV4STRuR0dPS2swSGU4WGlDeHNydGt2MjViYnp1MkV5ZWpGcXNGbkRo?=
	=?utf-8?B?cG15UGxkN1VIeEp4allTY1EzRDdJSWljcFhDTzVsK2p5aXg3VHFydXVTc1JN?=
	=?utf-8?B?OVhyakJpMS9SUERZZVpzRWxNVTRabEVHMk1OcUZsUEczWStOcmh6ZWZqRkU4?=
	=?utf-8?B?ODlER09JYWFVQVl6WUZ5MnRQZjhjc0dmanhuSksrNlQ1WVBSMFphV0tTdE5v?=
	=?utf-8?B?RnhuWklHcWpkL0t5dG5pLzIrckcxQ010aDhnbCszVkRybmpzTnNPdmVkbzhu?=
	=?utf-8?B?U0pHcXFMODU2L2d2azlOdHRTS0REcjdUa3ZmdUZxZ09lVFh0T3dEL2hZUDJG?=
	=?utf-8?B?MnZwSWJhVC9ZTC92T3lkUCs2Z3dKZE9aUDRBY3FTeGh1NE0vK01meU8yZXc0?=
	=?utf-8?B?anBuSW5yK3N6Q1c0U2FSVWx6Z25ldU1hMlJqVlU2NmY5dlIyR2NkVjFobkFM?=
	=?utf-8?B?RnZ0Ymg2dXViWWo5ejY3bzhhT2RhUFBKQXpZS2paWmo0SExxb2F0QkRUOVFx?=
	=?utf-8?B?TW80dW1IdlorSzRtenczTjNvQytVYUMvUTZYRXVzSDVIUC9NVnNQZ3I1b1h5?=
	=?utf-8?B?aWRpbFZTOGJzZDRBVlE2OUpuY09qTzNBR05YNGRHU2twV1BLek1ISk4zeXpK?=
	=?utf-8?B?TkI2OXYzQ2RUZFNBbmJJT3lDZWFMOE9OelVwWFJFL2RPV1psL3ZuKzFjM0ta?=
	=?utf-8?B?NzhRWCt0T1V1d2tqMnB6ZGZJS29ScXNBZmsyNVU4c2lmK2U2cEZSNkhDL0V2?=
	=?utf-8?B?VE03bTV5Ly9KRFptVDAyQVAvYlpYb0lHQURlWlpKQlpXaGl2UU93NkszeWdw?=
	=?utf-8?B?Vy9wQXA0c3BLSWhDbkJMM0hTVkpFQ2crSERrOUJYdjJUR3FaT3BSNFRiOU4v?=
	=?utf-8?B?ZHc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfde5b1-7718-4436-44d5-08d9e12b95b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 00:25:56.0382 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LcuAIdlHeNX3L6ylCu2tb0TjZe0WTp6v3VtPa0haavtutMFwnhOZbpiHfEiFw/tylFf1/72SXr1/laCbu5EZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5605
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	mlxlogscore=946
	adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201270000
X-Proofpoint-GUID: _9Kn0o8E__aAen6zdxizj9bXtfKVpt6o
X-Proofpoint-ORIG-GUID: _9Kn0o8E__aAen6zdxizj9bXtfKVpt6o
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20R0QNlX007240
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
Subject: Re: [dm-devel] [PATCH v3 0/7] DAX poison recovery
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D7ADC38D4B7FFF418AF7B8B42C5651E4@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/24/2022 1:01 AM, Christoph Hellwig wrote:
> On Fri, Jan 21, 2022 at 01:33:40AM +0000, Jane Chu wrote:
>>> What tree is this against? I can't apply it to either 5.16 or Linus'
>>> current tree.
>>
>> It was based on your 'dax-block-cleanup' branch a while back.
> 
> Do you have a git tree with your patches included available somewhere?

Sorry I don't have a git tree, so I rebased the series to 
v5.17-rc1-81-g0280e3c58f9, hope that helps.

-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

