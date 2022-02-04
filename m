Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F2FC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-Kr9s87MVN0OzqIWWrluRkQ-1; Fri, 04 Feb 2022 04:42:13 -0500
X-MC-Unique: Kr9s87MVN0OzqIWWrluRkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A09E21091DAF;
	Fri,  4 Feb 2022 09:42:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EBB37B6ED;
	Fri,  4 Feb 2022 09:42:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 588CE4A7CD;
	Fri,  4 Feb 2022 09:42:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2147x0k1001944 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 02:59:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 96370C080B8; Fri,  4 Feb 2022 07:59:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90BE5C080AD
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:59:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 718BD2A59543
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:59:00 +0000 (UTC)
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
	[148.163.143.35]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-235-wO7u8QinPte-ui24S69hgw-1; Fri, 04 Feb 2022 02:58:56 -0500
X-MC-Unique: wO7u8QinPte-ui24S69hgw-1
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id
	2145c0RT025527; Fri, 4 Feb 2022 07:58:52 GMT
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3e0x5grtyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 04 Feb 2022 07:58:52 +0000
Received: from G2W6310.americas.hpqcorp.net (g2w6310.austin.hp.com
	[16.197.64.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t5008.houston.hpe.com (Postfix) with ESMTPS id C17284F;
	Fri,  4 Feb 2022 07:58:51 +0000 (UTC)
Received: from G1W8108.americas.hpqcorp.net (2002:10c1:483c::10c1:483c) by
	G2W6310.americas.hpqcorp.net (2002:10c5:4034::10c5:4034) with Microsoft
	SMTP Server (TLS) id 15.0.1497.23; Fri, 4 Feb 2022 07:58:51 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (15.241.52.12) by
	G1W8108.americas.hpqcorp.net (16.193.72.60) with Microsoft SMTP
	Server (TLS)
	id 15.0.1497.23 via Frontend Transport; Fri, 4 Feb 2022 07:58:51 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
	by DM4PR84MB1709.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:48::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14;
	Fri, 4 Feb 2022 07:58:50 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
	([fe80::1115:5407:b4fb:9e10]) by
	PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
	([fe80::1115:5407:b4fb:9e10%5]) with mapi id 15.20.4951.012;
	Fri, 4 Feb 2022 07:58:49 +0000
From: "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
To: Milan Broz <gmazyland@gmail.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>,
	"Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHYGXmu8xbekrL+u0uyE4tyb91/SKyDAvwAgAA2bwA=
Date: Fri, 4 Feb 2022 07:58:49 +0000
Message-ID: <C86CF721-6C22-4382-842C-0098BD9D42DE@hpe.com>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
	<yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
	<e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
In-Reply-To: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03ff2633-5461-4bd4-ccde-08d9e7b42de8
x-ms-traffictypediagnostic: DM4PR84MB1709:EE_
x-microsoft-antispam-prvs: <DM4PR84MB1709393B574AC82F62EAEFB9F7299@DM4PR84MB1709.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2331
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lKk+CL4ytkxuym5pJntRWV1ayhxI+U9appW7yMWa1tNPnSAVrHH+jb80qcnbqfg9m8I098+bl144MW+A/jPt8VdLIxfR25+FZ18ojMRl/NEwiB1NC7HbSPSzZcuJ2z5hiXmpzsXuBpjo7uffHQUe0NRJk4yXWkIwbR3xBy8QjiWqwN6ieAnFg3wRwmQI3gdyzQr1twff4ps8bv1SuTqWX9IVuALzhWUkcgYTcV4YERhboyjnH2KWNgj8ztoI7oqF9J6rjtsXosBRENUIn36QWpZRQuoiR6wT2W2bjWrqRVGkib1X0Na4k2+a5B1JjJ1Zv0SKnWR5RRUu+Ps8nvhnqlOkpQNNFXoFvyk+6ltRm9uFft9kiJowSu8olI8wJPCLxyiRR928Vy3u4tpWqlET0O6NBStsqwgQNQMy3ZR2wWP5mFuUw7DLsydxOigUGr+k5aH3HE5KzoqJp1abQqdnON3isZ5pW61yHKtLs9oTIWau8eO8+jFgUX3rQhEWr7btkxrwtA57DKnFszZGlnY9tqxoOOEWKZrVnNYeyOXFnEGMYJqY6kWrTZ/icsdmbU8H/loWlUniwMF8Ogr1s4DsSwSqmX2fzoSchtW1Kr21IJRZQbl4+eodPqZ/DLzLpH0DsSGKMJfF38/CrYuWmS/7fSykXOoZqL68/2yfH/LttU74l45PmVcOC0DH8lhu54GiAuEfuACSUANLePLC9X91FS1R9locnupt+ovTB3ReIcM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(91956017)(66476007)(66446008)(6486002)(186003)(76116006)(8936002)(4326008)(26005)(66946007)(2906002)(2616005)(82960400001)(6506007)(6512007)(64756008)(8676002)(53546011)(71200400001)(38070700005)(7416002)(316002)(6636002)(110136005)(54906003)(33656002)(508600001)(38100700002)(36756003)(5660300002)(122000001)(86362001)(83380400001)(66556008)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm00UGhBcm9XQ0xtdGIvRk9PcmUrZnVaY0ZGVjNPYkFLVU5PaVBINVNXb2RM?=
	=?utf-8?B?Z3pZRmIzc3A2d1cvcjdONXcvZThQbTJQb1VVTmszZ0kxdzJvbk5SN0JaRC9P?=
	=?utf-8?B?QTYwaGZZaXJSaDFKVHhqZEhwSHZ2d2JOVmxiRmZFUWVtMmJEd2IvYnp3OVBF?=
	=?utf-8?B?bmxxL2dXOG11OUtpRzYyK0xub2FESzg2Zm1XcFhtTFB1YTB4RDNJVTJGYkJT?=
	=?utf-8?B?VTk0aWJ4OFJja2FwVnZpcXZFZXVxTVFhanZXOFpUUm9Mcjd4elYwT0pmWGp5?=
	=?utf-8?B?cDRGMFE4RTFsdU5qZml4VGdrUzJGbU1YaHBJSk54aWdOM0UxazJ4R1ZZRFhh?=
	=?utf-8?B?clROd2d5cUtaekF3cmwwTUJaZ091OGQ5TGtaSzZIQVk5cjRUd3k3VXFVM0xi?=
	=?utf-8?B?dFoyNzlSeWhyWGVmTURhR2gyaHdzb0FDY0FXQ2hwbUI0TG9TaGY0RTJPRCtK?=
	=?utf-8?B?KzlXZEFmajJvMWJiK1RIczd3Rk96Ymh6K05uL2hUL2JPLzk4RTZiN0RXamUv?=
	=?utf-8?B?TVdUUEt0OHIyL0FRZWIvNEg3YUtITHdkZlYxVGVweUljdVpINHdNc3Qxdmha?=
	=?utf-8?B?SDg4Uk1YdC9kUzYvUHRUU0RKS1hqZFlKTHZhZTFsRkVNaUV3YXNJMnRlUUww?=
	=?utf-8?B?RmZqeUlmODYxdStlY1FmcnJSNjdjRWUrbTlrSmhPY2I1S0xTbnJYK1c1Q0F3?=
	=?utf-8?B?aDhCalBqbU9lQXBNQ0dlN3pRUkU4NmtEbVJxaVRCVHNHTWlaZWp0bnFpTlR5?=
	=?utf-8?B?Y1k0LzIwRFpMTjQxYkV2em1OOHdFZk80WVZtbm8yT2F4Y0J1Nm1sbzVFbGEv?=
	=?utf-8?B?L0cwRTRQZk1TNFFzZnZYVUVGK0RGeGJaQVQyK0NjbFNzYUsweGltbUpIVTN0?=
	=?utf-8?B?WWdudTFKbDFOZDV4OUcvZWRJaDlIbXBiQnlyNnY2b0lDMVg1WkVGSkpDU2dr?=
	=?utf-8?B?Q0tRcmI5enhEVnhlcUt3RjROck5rZDhldVJQVVJqZWg5ODkzeDZPeWFnTHR2?=
	=?utf-8?B?RW1XMTJTMFJHMkhFNDhzYnV3V1dVajRVRHNUT1R5VWcwU0hDcXhiZDczNWJL?=
	=?utf-8?B?UWZFdXdrbzNTbDM0dUtpRisxMzM2MktIZ29ZTElROTFMRXYyaW03T3dLa2Jv?=
	=?utf-8?B?T1pXS25wcU1RWS81TDFxSTY5TU1HVUdEaXpmaUd3aldPZDl1MGFCcisrb2Mv?=
	=?utf-8?B?RXl1Nk1uZVdGQ2loa09LSys2YWpPSldsdFd5a0Z1VnVsMnhNZEErQXBIbW5D?=
	=?utf-8?B?L01OQWlyNlhJR3o2RGE3dGEyWVc4U2k1b2w0ZUZBYnVlM0VSZVMrZWdudkE5?=
	=?utf-8?B?c25yL1pmRWhmenA0M09sYU83K2ZkdnBqbmNydTR6ZTh6SnV3RUkzL3NqYUVn?=
	=?utf-8?B?WWJGVlhPSGZMMTNHUXEraTNqUTQwY3RQNW9qeCtMMTlrdUh0S3BQUGx0eDAv?=
	=?utf-8?B?Y3ZoL2lXdmdKV2F2dmdIUHZzTmJoR1A5UHNVS1dockJJS2I0UktrOFhLeG5G?=
	=?utf-8?B?UFUyQXQ2WW1kOTNLdjAxbG5pSUZLejhWWnV3OHh2MVVYVENuNXE2M2hzcER6?=
	=?utf-8?B?ODlXVGVleU1RaWNCNGtxdGE0a29pMnR1NkNnMDZRLzB1MkdTdUJtNGhseXh5?=
	=?utf-8?B?bXpMOWxrSm1PS1ZHeUZRWUsxZlA3cG0zOFg1NjBQaFlyMy85R2k1YS9IZG1M?=
	=?utf-8?B?YmpNcmVtWjl3c2lvendCZTZLQnlQaW5NbENRaXQ4cjYzcjhwRytrOG1Zamc2?=
	=?utf-8?B?WkZHeUtkQVVyazBld2ZzeGVWRGVuK3RrOXY4dVlaSUJkL0VqWXZpelZjTS91?=
	=?utf-8?B?QkgvWVJlMzNiMkhFTVN3K0Y5MWNUTDMrNGI5aW9LRG4vQmxJL0dJV0drVFl4?=
	=?utf-8?B?emxXTG9uRFZOelBJdW1TRFF3VGh0R3V2NWZxQ2JNckpJTE1VRnE1REhoNVRi?=
	=?utf-8?B?Rkt3c1VnRFl1dnh5ZHNkZDI5VGExeUZidVhDbEcrU01xeDVzRWhyYldZNnJH?=
	=?utf-8?B?RnRoeWRNT2R6QitRUW41cUYxdVhtQ3d2ZzNpU0lXTGJ5WS9TRE1TMWZvMkpY?=
	=?utf-8?B?ZXdQdGViN01WZGJjUXFkUGlGUmQrSXhCUDNBSXh0YlJQZEM2T29MU2tIaG1F?=
	=?utf-8?B?bnVKUjRJV1hodEx5bjBCTDFMRkh3bVJ1ZUM4VmlrSjZvMW1teW1VTkd4WHh1?=
	=?utf-8?Q?B2JOklQwMq3fluvN4cPcHc4=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ff2633-5461-4bd4-ccde-08d9e7b42de8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 07:58:49.8435 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fIqGV/HLWoQKsbXR78ja1SNt2Hf4PtLBRcsfCL5MmKeJ/7XqD8Z8oXNHpd8RUtN88EeZlIyK+hv/gkgkZjjmHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1709
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: HWV6F0Ud2LHcOq0anVEr06CS0SezdVsb
X-Proofpoint-ORIG-GUID: HWV6F0Ud2LHcOq0anVEr06CS0SezdVsb
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-04_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	bulkscore=0 mlxlogscore=999
	malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
	priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
	clxscore=1011
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202040040
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2147x0k1001944
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Patocka <mpatocka@redhat.com>, Mikulas
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-ID: <8E9C55B7EB491B47A5CF7BBFC6335EF5@NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

TWlsYW4sCgpJIGFuZCBEbWl0cml5IHRyaWVzIHRvIGZpeCBhIHByb2JsZW0gd2l0aCBCSU8gc3Bs
aXQgd2l0aCBpbnRlZ3JpdHkgZGF0YSBhdHRhY2hlZC4KVGhpcyBpcyBjYXNlLCBpbnRlZ3JpdHkg
Z2VuZXJhdGVkL2F0dGFjaGVkIGJlZm9yZSBiaW9fc3VibWl0IG92ZXIgcmFpZCBkZXZpY2UgKG1k
IHN0YWNrIGluIG15IGNhc2UpIGFuZCBiaW8gaXMgc3ViamVjdCBvZiBiaW9faW50ZWdyaXR5X2Fk
dmFuY2UuCkJ1dCBiaW9faW50ZWdyaXR5X2FkdmFuY2UgaW5jb3JyZWN0bHkgc3BsaXQgYW4gaW50
ZWdyaXR5IGRhdGEsIGFzIGl0J3MgYXNzdW1lIGludGVncml0eSBpdGVyYXRvciBpbiB0aGUgNTEy
YiBibG9ja3MuCiggYmlwLT5iaXBfaXRlci5iaV9zZWN0b3IgKz0gYnl0ZXNfZG9uZSA+PiA5ICkK
QnV0IHQxMCBnZW5lcmF0ZSBmdW5jdGlvbiAodDEwX3BpX2dlbmVyYXRlKSBpbmNyZWFzZSBhIGl0
ZXJhdG9yIGJ5IDEgZm9yIGVhY2ggaW50ZWdyaXR5IGludGVydmFsIGluIHRoZSB0MTBfcGlfZ2Vu
ZXJhdGUgZnVuY3Rpb24uCiggICAgICAgIGZvciAoaSA9IDAgOyBpIDwgaXRlci0+ZGF0YV9zaXpl
IDsgaSArPSBpdGVyLT5pbnRlcnZhbCkgewogICAgICAgICAgICAgICAgaXRlci0+c2VlZCsrOwog
ICAgICAgIH0KKQpJdCdzIGdvb2QgZm9yIHRoZSBzY3NpIHdpdGggNTEyYiBibG9ja3MsIGJ1dCBi
YWQgZm9yIHRoZSBudm1lIHdpdGggNGsgYmxvY2sgc2l6ZS4KClNvIHR3byBzb2x1dGlvbnMgZXhp
c3QgCjEpIG15IHNvbHV0aW9uIC0gbGV0cyBmaXggYW4gdDEwX3BpX2dlbmVyYXRlIC8gdDEwX3Bp
X3ZlcmlmeSAvICB0MTBfcGlfdHlwZTFfcHJlcGFyZSB0byBpbmNyZWFzZSBpdGVyYXRvciBieSB2
YWx1ZSByZWxhdGVkIHRvIHJlYWwgaW50ZWdyaXR5IGJsb2NrIGluIHRoZSA1MTJiIGJsb2Nrcy4K
MikgTWFydGluIHNvbHV0aW9uLCBqdXN0IGNoYW5nZSBhbiBiaW9faW50ZWdyaXR5X2FkdmFuY2Ug
ZnVuY3Rpb24gdG8gbWFrZSBpdGVyYXRvciBzaGl0IGluIHRoaXMgaW50ZWdyaXR5IGRhdGEgYmxv
Y2tzIHVuaXRzIGluc3RlYWQgb2YgNTEyYiBibG9ja3MuCgpBbGV4Cgrvu79PbiAwNC8wMi8yMDIy
LCAxMDo0NCwgIk1pbGFuIEJyb3oiIDxnbWF6eWxhbmRAZ21haWwuY29tPiB3cm90ZToKCiAgICBP
biAwNC8wMi8yMDIyIDA0OjQ0LCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6CiAgICA+IAogICAg
PiBEbWl0cnksCiAgICA+IAogICAgPj4gTXkgb25seSBjb25jZXJuIGlzIGRtX2NyeXB0IHRhcmdl
dCB3aGljaCBvcGVyYXRlcyBvbiBiaXBfaXRlciBkaXJlY3RseQogICAgPj4gd2l0aCB0aGUgY29k
ZSBjb3B5LXBhc3RlZCBmcm9tIGJpb19pbnRlZ3JpdHlfYWR2YW5jZToKICAgID4+CiAgICA+PiBz
dGF0aWMgaW50IGRtX2NyeXB0X2ludGVncml0eV9pb19hbGxvYyhzdHJ1Y3QgZG1fY3J5cHRfaW8g
KmlvLCBzdHJ1Y3QgYmlvICpiaW8pCiAgICA+PiB7CiAgICA+PiAJc3RydWN0IGJpb19pbnRlZ3Jp
dHlfcGF5bG9hZCAqYmlwOwogICAgPj4gCXVuc2lnbmVkIGludCB0YWdfbGVuOwogICAgPj4gCWlu
dCByZXQ7CiAgICA+PgogICAgPj4gCWlmICghYmlvX3NlY3RvcnMoYmlvKSB8fCAhaW8tPmNjLT5v
bl9kaXNrX3RhZ19zaXplKQogICAgPj4gCQlyZXR1cm4gMDsKICAgID4+CiAgICA+PiAJYmlwID0g
YmlvX2ludGVncml0eV9hbGxvYyhiaW8sIEdGUF9OT0lPLCAxKTsKICAgID4+IAlpZiAoSVNfRVJS
KGJpcCkpCiAgICA+PiAJCXJldHVybiBQVFJfRVJSKGJpcCk7CiAgICA+PgogICAgPj4gCXRhZ19s
ZW4gPSBpby0+Y2MtPm9uX2Rpc2tfdGFnX3NpemUgKiAoYmlvX3NlY3RvcnMoYmlvKSA+PiBpby0+
Y2MtPnNlY3Rvcl9zaGlmdCk7CiAgICA+PgogICAgPj4gCWJpcC0+YmlwX2l0ZXIuYmlfc2l6ZSA9
IHRhZ19sZW47CiAgICA+PiAJYmlwLT5iaXBfaXRlci5iaV9zZWN0b3IgPSBpby0+Y2MtPnN0YXJ0
ICsgaW8tPnNlY3RvcjsKICAgID4+ICAgICAgICAgICAgICAgICBeXl4KICAgID4+CiAgICA+PiAJ
cmV0ID0gYmlvX2ludGVncml0eV9hZGRfcGFnZShiaW8sIHZpcnRfdG9fcGFnZShpby0+aW50ZWdy
aXR5X21ldGFkYXRhKSwKICAgID4+IAkJCQkgICAgIHRhZ19sZW4sIG9mZnNldF9pbl9wYWdlKGlv
LT5pbnRlZ3JpdHlfbWV0YWRhdGEpKTsKICAgID4+IC4uLgogICAgPj4gfQogICAgPiAKICAgID4g
SSBjb3BpZWQgTWlsYW4gYW5kIE1pa2Ugd2hvIGFyZSBtb3JlIGZhbWlsaWFyIHdpdGggdGhlIGRt
LWRyeXB0IGludGVybmFscy4KCiAgICBIaSwKCiAgICBXaGF0J3MgdGhlIHByb2JsZW0gaGVyZSB5
b3UgYXJlIHRyeWluZyB0byBmaXg/CiAgICBFdmVuIGlmIEkgcmVhZCBsaW51eC1ibG9jayBwb3N0
cywgSSBkbyBub3QgdW5kZXJzdGFuZCB0aGUgY29udGV4dC4uLgoKICAgIEFueXdheSwgY2MgdG8g
TWlrdWxhcyBhbmQgZG0tZGV2ZWwsIGFzIGRtLWludGVncml0eS9kbS1jcnlwdCBpcwogICAgdGhl
IG1ham9yIHVzZXIgb2YgYmlvX2ludGVncml0eSBoZXJlLgoKICAgIElmIHlvdSB0b3VjaCB0aGUg
Y29kZSwgcGxlYXNlIGJlIHN1cmUgeW91IHJ1biBjcnlwdHNldHVwIHRlc3RzdWl0ZQogICAgd2l0
aCB0aGUgaW50ZWdyaXR5IHRlc3RzLgogICAgKElPVyBpbnRlZ3JpdHlzZXR1cCB0ZXN0cyBhbmQg
TFVLUzIgd2l0aCBhdXRoZW50aWNhdGVkIGVuY3J5cHRpb24KICAgIHRoYXQgdXNlcyBkbS1jcnlw
dCBvdmVyIGRtLWludGVncml0eS4pCgogICAgQWxsIHdlIG5lZWQgaXMgdGhhdCBkbS1pbnRlZ3Jp
dHkgY2FuIHByb2Nlc3MgYmlvIGludGVncml0eSBkYXRhCiAgICBkaXJlY3RseS4gKEkga25vdyBz
b21lIHBlb3BsZSBkbyBub3QgbGlrZSBpdCwgYnV0IHRoaXMgd2FzCiAgICB0aGUgbW9zdCAiZWxl
Z2FudCIgc29sdXRpb24gaGVyZS4pCgogICAgSGVyZSBkbS1jcnlwdCB1c2VzIHRoZSBkYXRhIGZv
ciBhdXRoZW50aWNhdGVkIGVuY3J5cHRpb24gKGFkZGl0aW9uYWwKICAgIGF1dGggdGFnIGluIGJp
byBmaWVsZCksIHNvIGJlY2F1c2UgZG0tY3J5cHQgb3ducyBiaW8sIGludGVncml0eSBkYXRhCiAg
ICBtdXN0IGJlIGFsbG9jYXRlZCBpbiBkbS1jcnlwdCAoc3RhY2tlZCBvdmVyIGRtLWludGVncml0
eSkuCgogICAgTWlsYW4KCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

