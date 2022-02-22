Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AD7C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:17:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-wx6TzA3KMeWGyx8JkUYQFA-1; Tue, 22 Feb 2022 13:17:12 -0500
X-MC-Unique: wx6TzA3KMeWGyx8JkUYQFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11C04100C611;
	Tue, 22 Feb 2022 18:17:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65D8F196F2;
	Tue, 22 Feb 2022 18:17:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCBF14EE45;
	Tue, 22 Feb 2022 18:17:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MIGx5o024255 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 13:16:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 47A2F40D1B9F; Tue, 22 Feb 2022 18:16:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BA7400C849
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25FF3185A7BA
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-ygsYpkxHPiSnrsOm8po3ww-1; Tue, 22 Feb 2022 13:16:57 -0500
X-MC-Unique: ygsYpkxHPiSnrsOm8po3ww-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21MHxLC1009296
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:56 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ect3chxyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MIGeaM034940
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
	by userp3020.oracle.com with ESMTP id 3eat0nb4f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:16:54 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16)
	by DM5PR10MB1787.namprd10.prod.outlook.com (2603:10b6:4:9::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4995.24; Tue, 22 Feb 2022 18:16:52 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd]) by
	SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd%7]) with mapi id 15.20.4995.027;
	Tue, 22 Feb 2022 18:16:51 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYKBhdkcPf1IYiGkKQmhbhdfjHXw==
Date: Tue, 22 Feb 2022 18:16:51 +0000
Message-ID: <BDC6F60D-FED6-49EA-B9A6-B1AE1D9C2166@oracle.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
In-Reply-To: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d136976-2700-468d-b73d-08d9f62f7fd5
x-ms-traffictypediagnostic: DM5PR10MB1787:EE_
x-microsoft-antispam-prvs: <DM5PR10MB17876C98699EF27DB6CAE08F8F3B9@DM5PR10MB1787.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JP1mP+MvPpYKgCd7yOhimZ52aGCFuke9WIg9K0Asi24TddrUMVrqqfBztjpxYxHf7wd5RMZ9GqG8IxxpP0+3SDg70AkKy39cQojNb5O//w2/oCMo4LaqVaiAgirYn1rlS0okLrnqJR7BGmYRZzGwRH1voCRt1psbDdvNHxleCSygqOrvugJ6zg4o/LxRsW6Pn31gMizC7EHXMw9b6OoxVCHsdBx18yMqu3s1lACyfs+5g/SFlxRM/LmesX2H4cGVkA5/pI08g8A0x8uFLkVvg5Fuhz8U1i9X/YRNkljhwDjmfETlAo12RtSIG4UItlDbIuP9+7S8BNF4g/F4MUaLIImh6K9Y5E5YQbCIUO2f4Xiqf5sBLHiweMY2EoUynef63By02FHpZ2Xx7o4dZyyW87/xOK82GhnSBqegPHE/0ifh6mPwsoE9zYl4+MLiekQrj+HaaUT8GWQLrfoEDxlRaSHkc/e+bOSPcLFJPCbb6RByUZmj5vVQWqzEct9F0mx7DmqqJ5THrrDh3xwpULGb2BLDrCa/GFoNve95F5LU1Gtg9+dRjv+uycgM7Pp+7L4x803JjbgK8Df8wC5tuuH6y6yipgs+dVY2TCRbdBzggZtv3hfuZSps+UuN5HZc+nIxREu7ejb7DBhFwCAYoVG5m2+ejvoAsTVO3Bq9t0RVQFRY0AAWm88mkNHfmxnvWX7zeXSGtwuvNzdRAb5a+xENSBLT68jW/Wktq3KtnXQz8ZBuEeu7xswZ4C6UWs/6cN70N/L25X8FcaYILsE2A1WihobU/4r/TluiTwC1cAsTd3hLnVwtuRBHX50hfaH5OGdN
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4654.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(2906002)(316002)(508600001)(83380400001)(6916009)(5660300002)(86362001)(76116006)(122000001)(186003)(44832011)(2616005)(71200400001)(38070700005)(8676002)(8936002)(66946007)(33656002)(38100700002)(36756003)(6512007)(6506007)(966005)(66476007)(66556008)(66446008)(6486002)(64756008)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3k4MUZtQStQOWpReFZBWmljMm40US81VnNqVnlLdi83TmhUVXlRYWJELyty?=
	=?utf-8?B?ZEhUR1FuMm1JaHR5R1pwc3YzL1JoTkxYY0dBZThyR3lQVnJOek5wK0thQ2Fu?=
	=?utf-8?B?WDBDQ0NNYWR4c2o1S1d5dmY5ei9JMStHY3RiT3ZqeUVvcFczOEFNYXNSRG1W?=
	=?utf-8?B?b2dselpVUGFCeWtRTHpPYTh0ZWQ3WE1DLzRwb3lSOElWZy93RkVZNEtBcUgv?=
	=?utf-8?B?RnB3Q284TDVlVTdyZzRTdTVzekFMazRMZmtXQit4MDZTU2RvZG9nVXJ1Y01W?=
	=?utf-8?B?NWpvY3B3VVlpVGFhbDFpdytZRTJrQzA2dEZxMm53YVZFRXdGWE9yWWRORFZZ?=
	=?utf-8?B?YzRwSGN1WFdXYmZQVWVWZ0RqYVVwdW11cmpuNk1OVmFmRjNnelpqRVNjd3lI?=
	=?utf-8?B?NUFMUmVDY09IdUl1amZIV1VZN0dKcFFyZkxnaXJaNGpLOHdPaG00L2haaUU3?=
	=?utf-8?B?eXFaS0RMTTdvdzZWanpBYUFocTBZSyswZUtqYytsZldNOHpHNmczOC8xUTJE?=
	=?utf-8?B?bk1icnJETHBCTUN2THh5em9mL2NqbHVnVlhaUld4dXFaQkRlTlBvQzN3cWdp?=
	=?utf-8?B?MG83TVBrSzlDOHVrSlNqMWFpdDM1N0Z1b3VPcGprdUk5U3I5bHd1bjZjOS9G?=
	=?utf-8?B?MHYxYVlQVzJRWHdRY2JvNXhaVTR1ZjlUc1RjVU44ZThEZWV3b2FlSDNNNVE4?=
	=?utf-8?B?Z21ycytJbGhxSWVOa0dZbWM3RUdmM2luSlNXSDJIMGhpUnJSYjhmR2Y0cDli?=
	=?utf-8?B?OXhUOE9uN2o3M01iTmpBa04rM1RVMFdQb25qZnJ1NnlBdXdLVDEwM29qWlFo?=
	=?utf-8?B?bEJrRitDWTNjeGt2TThlelorWTdocDRHaGgwZGhxRzhFVFpvU0dYYUR4NGl2?=
	=?utf-8?B?Vm5TV1hhZVE5VW1Ec285aWtNbVlSUHJ5TWZDKzZUaXpKRENSUk95VGtIYnZ1?=
	=?utf-8?B?SThmb0xwbGVjOC9xcjhhQkswSU11Rkk1aUt1Y0RaamtVbXp6dkRuQTZ5M3lM?=
	=?utf-8?B?a2Q1eUJ0QlVURmRBU0U3UkI4Yy9CenV3K3JXbXB4d2Q5WlZGMHg2eUNVU2lR?=
	=?utf-8?B?aS95eXdlMWJQSXkrcE5RdlVxR25IK0RWWDBYV3NTNDBSUWt0MXFoZHZ0T09t?=
	=?utf-8?B?RDJNY1g5Y3MyMFBMMnF0cU45Ymp6c25tZnVNbkwyeXpQVjI3SU5aMnkzUGNW?=
	=?utf-8?B?UFJsR3p5UURLKytMUWlUcGpRMnRXRzJxNlp0Q0FqUE9iRCtveERCNTZEVUQ1?=
	=?utf-8?B?ZWVXanhGK2l3b2VwaWtWU3F2MmhreXU0bTBPajQ4UWZOUWtKTGxFMHM5TUxh?=
	=?utf-8?B?ZjdndlFNOUtTTXFUSlZZSk1abG9qZmZLMURHRzNsT2VtTmswbWN4bDJqYW5x?=
	=?utf-8?B?YWNxOGtWcUx6QkF0VDluYzVJckU0V1F4MHNaL0NWVHg1UVJ0QVJKZnR4VzVJ?=
	=?utf-8?B?YVJsRDZrQnBFRE5zeEtYN0ZLbUlMalBsbm0zZDBsOGVqMHppcTBKOTZLZURR?=
	=?utf-8?B?dWd1VnVaWllOR1Q5VEVsQWp4eVhIREFqVkFpMzhvMnZCd2tGSGc0bTJuRzBz?=
	=?utf-8?B?Wkx3VFh3alcveXB2eDVZaHFBUG43WVpBUmw4M0g0Nk83TXlaamY5N0RSZGFI?=
	=?utf-8?B?bmVGTnBTVHZtYW5SNklmSHBvSVJYencvSWhzY2sva2V2TTM1U3lWV1Zva2ZE?=
	=?utf-8?B?WC9qT1RGZnF2MTU5cXBVQlQ5Rk1KWC9GaTR0R09sWUxBWVYxcHZHbzVrMWVm?=
	=?utf-8?B?UEo2MmM0ZW5ocSsxM3lNUERRbmtKU1JYUmxVTzZDeEQxOHJIYlBFOXBqUEh6?=
	=?utf-8?B?bm55ek5CVlhBMWpQRlJCamR6WHFhQ2p5dzB1UWVXZ2tKbTUrQXJxc210THNT?=
	=?utf-8?B?QnZPcXFGOWdUaU1yMEVIc2J3RjIwZkh0VWdMM1FWNncvcDJRMFcvamRiQlZK?=
	=?utf-8?B?Qms0bnBlWFo5Z3ZPMUFtTDBXc0UxRnhWUWxuVC9lZXhTbENKV1ZVN1FxOUpK?=
	=?utf-8?B?SkhXcDdpbklkaDVwSlZHY0x0NzRoWnBVVWE0Ly9LM1FCQUQ1VFpjOHhzTHBa?=
	=?utf-8?B?NGxyWkpNenlIR3pVVkJGcjExSVJYZ3d1L09ZT095cFQxT2VnN2ZZRDBabmJV?=
	=?utf-8?B?ZFhtd1k0eEdjWFhzbEhrWGRzRmR5Mnd6emswMmxJTnVyWkMvQjhPTHh2eGlB?=
	=?utf-8?B?a3MzR0JEaWIzcHR6L216SlIvYS8zbzF0WTJIQmY1dHVUMk1nVWNIUnNLc3dY?=
	=?utf-8?B?MXlrWlhyY1BPMmJQK2dDTlRSQi9VemZ0SUhMOTdOOEdTSnBlSitKVy9ML0FH?=
	=?utf-8?Q?rsyNn8GDd2FWb13bJk?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4654.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d136976-2700-468d-b73d-08d9f62f7fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 18:16:51.7150 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHmTowbByRPMQSg8DxtasAMjg14Jk+zPHgVuYNB+vXdS3tGEkQ86jX5VSDZpAqC0OgdFt3FkzhpjscDgLoU1ipA6k6EwpQzgYkhCcOLJ0rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1787
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266
	signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 spamscore=0
	mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202220113
X-Proofpoint-ORIG-GUID: xgXe7sm8SP7AqxUPa1Iab8XnX9LsivoR
X-Proofpoint-GUID: xgXe7sm8SP7AqxUPa1Iab8XnX9LsivoR
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21MIGx5o024255
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
Content-ID: <4279D44C0E305848B44123CF2D25ABBA@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpHZW50bGUgcGluZwpQbGVhc2UgaGVscCByZXZpZXcgdGhpcy4KCi0tICAgICAgICAgICAg
ICAgIApUaGFua3MsClJpdGlrYQoKCu+7v09uIDIvMTEvMjIsIDM6NTEgUE0sIFJpdGlrYSBTcml2
YXN0YXZhIHdyb3RlOgoKICAgIEFkZCAtUCwgcGFydGl0aW9uIHNjYW5uaW5nIG9wdGlvbiB0byBr
cGFydHggd2hpY2ggd291bGQgc2V0CiAgICBMT19GTEFHU19QQVJUU0NBTiBmbGFnIGR1cmluZyBs
b29wIGRldmljZSBjcmVhdGlvbi4KICAgIFRoaXMgb3B0aW9uIGlzIHNhbWUgYXMgbG9zZXR1cCAt
UCBvcHRpb24uCgogICAgU2lnbmVkLW9mZi1ieTogUml0aWthIFNyaXZhc3RhdmEgPHJpdGlrYS5z
cml2YXN0YXZhQG9yYWNsZS5jb20+CiAgICAtLS0KICAgICBrcGFydHgva3BhcnR4LmMgfCAxNyAr
KysrKysrKysrKysrLS0tLQogICAgIGtwYXJ0eC9sb3BhcnQuYyB8ICA1ICsrKystCiAgICAga3Bh
cnR4L2xvcGFydC5oIHwgIDIgKy0KICAgICAzIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pCgogICAgZGlmZiAtLWdpdCBhL2twYXJ0eC9rcGFydHguYyBiL2tw
YXJ0eC9rcGFydHguYwogICAgaW5kZXggM2M0OTk5OS4uYTI2ZDBhMiAxMDA2NDQKICAgIC0tLSBh
L2twYXJ0eC9rcGFydHguYwogICAgKysrIGIva3BhcnR4L2twYXJ0eC5jCiAgICBAQCAtODcsNyAr
ODcsNyBAQCBpbml0cHRzKHZvaWQpCiAgICAgCWFkZHB0cygicHMzIiwgcmVhZF9wczNfcHQpOwog
ICAgIH0KCiAgICAtc3RhdGljIGNoYXIgc2hvcnRfb3B0c1tdID0gInJsYWRmZ3ZwOnQ6c251IjsK
ICAgICtzdGF0aWMgY2hhciBzaG9ydF9vcHRzW10gPSAicmxhZGZQZ3ZwOnQ6c251IjsKCiAgICAg
LyogVXNlZCBpbiBncHQuYyAqLwogICAgIGludCBmb3JjZV9ncHQ9MDsKICAgIEBAIC05OCw3ICs5
OCw3IEBAIHN0YXRpYyBpbnQKICAgICB1c2FnZSh2b2lkKSB7CiAgICAgCXByaW50ZihWRVJTSU9O
X1NUUklORyk7CiAgICAgCXByaW50ZigiVXNhZ2U6XG4iKTsKICAgIC0JcHJpbnRmKCIgIGtwYXJ0
eCBbLWF8LWR8LXV8LWxdIFstcl0gWy1wXSBbLWZdIFstZ10gWy1zfC1uXSBbLXZdIHdob2xlZGlz
a1xuIik7CiAgICArCXByaW50ZigiICBrcGFydHggWy1hfC1kfC11fC1sXSBbLXJdIFstcF0gWy1m
XSBbLWddIFstc3wtbl0gWy12XSBbLVBdIHdob2xlZGlza1xuIik7CiAgICAgCXByaW50ZigiXHQt
YSBhZGQgcGFydGl0aW9uIGRldm1hcHBpbmdzXG4iKTsKICAgICAJcHJpbnRmKCJcdC1yIGRldm1h
cHBpbmdzIHdpbGwgYmUgcmVhZG9ubHlcbiIpOwogICAgIAlwcmludGYoIlx0LWQgZGVsIHBhcnRp
dGlvbiBkZXZtYXBwaW5nc1xuIik7CiAgICBAQCAtMTEwLDYgKzExMCw3IEBAIHVzYWdlKHZvaWQp
IHsKICAgICAJcHJpbnRmKCJcdC12IHZlcmJvc2VcbiIpOwogICAgIAlwcmludGYoIlx0LW4gbm9z
eW5jIG1vZGUuIFJldHVybiBiZWZvcmUgdGhlIHBhcnRpdGlvbnMgYXJlIGNyZWF0ZWRcbiIpOwog
ICAgIAlwcmludGYoIlx0LXMgc3luYyBtb2RlIChEZWZhdWx0KS4gRG9uJ3QgcmV0dXJuIHVudGls
IHRoZSBwYXJ0aXRpb25zIGFyZSBjcmVhdGVkXG4iKTsKICAgICsJcHJpbnRmKCJcdC1QIGNyZWF0
ZSBwYXJ0aXRpb25lZCBsb29wIGRldmljZVxuIik7CiAgICAgCXJldHVybiAxOwogICAgIH0KCiAg
ICBAQCAtMjI4LDcgKzIyOSw3IEBAIHhtYWxsb2MgKHNpemVfdCBzaXplKSB7CgogICAgIGludAog
ICAgIG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KXsKICAgIC0JaW50IGksIGosIG0sIG4sIG9w
LCBvZmYsIGFyZywgYywgZCwgcm89MDsKICAgICsJaW50IGksIGosIG0sIG4sIG9wLCBvZmYsIGFy
ZywgYywgZCwgcm89MCwgcGFydHNjYW4gPSAwOwogICAgIAlpbnQgZmQgPSAtMTsKICAgICAJc3Ry
dWN0IHNsaWNlIGFsbDsKICAgICAJc3RydWN0IHB0ICpwdHA7CiAgICBAQCAtMzExLDYgKzMxMiw5
IEBAIG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KXsKICAgICAJCWNhc2UgJ3UnOgogICAgIAkJ
CXdoYXQgPSBVUERBVEU7CiAgICAgCQkJYnJlYWs7CiAgICArCQljYXNlICdQJzoKICAgICsJCQlw
YXJ0c2NhbiA9IDE7CiAgICArCQkJYnJlYWs7CiAgICAgCQlkZWZhdWx0OgogICAgIAkJCXVzYWdl
KCk7CiAgICAgCQkJZXhpdCgxKTsKICAgIEBAIC0zMjgsNiArMzMyLDExIEBAIG1haW4oaW50IGFy
Z2MsIGNoYXIgKiphcmd2KXsKICAgICAJCWV4aXQoMSk7CiAgICAgCX0KCiAgICArCWlmICh3aGF0
ICE9IEFERCAmJiBwYXJ0c2NhbiA9PSAxKSAgICAgICB7CiAgICArCQlwcmludGYoIi1QIG9wdGlv
biBpcyBhbGxvd2VkIG9ubHkgZHVyaW5nIGxvb3AgZGV2aWNlIHNldHVwXG4iKTsKICAgICsJCWV4
aXQoMSk7CiAgICArCX0KICAgICsKICAgICAJaWYgKGhvdHBsdWcpIHsKICAgICAJCS8qIGFscmVh
ZHkgZ290IFtkaXNrXWRldmljZSAqLwogICAgIAl9IGVsc2UgaWYgKG9wdGluZCA9PSBhcmdjLTIp
IHsKICAgIEBAIC0zNTksNyArMzY4LDcgQEAgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3Ypewog
ICAgIAkJCWV4aXQgKDApOwoKICAgICAJCWlmICghbG9vcGRldikgewogICAgLQkJCWlmIChzZXRf
bG9vcCgmbG9vcGRldiwgcnBhdGgsIDAsICZybykpIHsKICAgICsJCQlpZiAoc2V0X2xvb3AoJmxv
b3BkZXYsIHJwYXRoLCAwLCAmcm8sIHBhcnRzY2FuKSkgewogICAgIAkJCQlmcHJpbnRmKHN0ZGVy
ciwgImNhbid0IHNldCB1cCBsb29wXG4iKTsKICAgICAJCQkJZXhpdCAoMSk7CiAgICAgCQkJfQog
ICAgZGlmZiAtLWdpdCBhL2twYXJ0eC9sb3BhcnQuYyBiL2twYXJ0eC9sb3BhcnQuYwogICAgaW5k
ZXggNTEyYTU5Zi4uOWExY2U0OCAxMDA2NDQKICAgIC0tLSBhL2twYXJ0eC9sb3BhcnQuYwogICAg
KysrIGIva3BhcnR4L2xvcGFydC5jCiAgICBAQCAtMjMzLDcgKzIzMyw4IEBAIG5vX2xvb3BfZmQ6
CiAgICAgCXJldHVybiBOVUxMOwogICAgIH0KCiAgICAtaW50IHNldF9sb29wKGNoYXIgKipkZXZp
Y2UsIGNvbnN0IGNoYXIgKmZpbGUsIGludCBvZmZzZXQsIGludCAqbG9vcHJvKQogICAgK2ludCBz
ZXRfbG9vcChjaGFyICoqZGV2aWNlLCBjb25zdCBjaGFyICpmaWxlLCBpbnQgb2Zmc2V0LCBpbnQg
Kmxvb3BybywKICAgICsJICAgICBpbnQgcGFydHNjYW4pCiAgICAgewogICAgIAlzdHJ1Y3QgbG9v
cF9pbmZvIGxvb3BpbmZvOwogICAgIAlpbnQgZmQgPSAtMSwgcmV0ID0gMSwgZmZkLCBtb2RlOwog
ICAgQEAgLTI2NCw2ICsyNjUsOCBAQCBpbnQgc2V0X2xvb3AoY2hhciAqKmRldmljZSwgY29uc3Qg
Y2hhciAqZmlsZSwgaW50IG9mZnNldCwgaW50ICpsb29wcm8pCiAgICAgCWxvb3BpbmZvLmxvX29m
ZnNldCA9IG9mZnNldDsKICAgICAJbG9vcGluZm8ubG9fZW5jcnlwdF90eXBlID0gTE9fQ1JZUFRf
Tk9ORTsKICAgICAJbG9vcGluZm8ubG9fZW5jcnlwdF9rZXlfc2l6ZSA9IDA7CiAgICArCWlmIChw
YXJ0c2NhbiA9PSAxKQogICAgKwkJbG9vcGluZm8ubG9fZmxhZ3MgfD0gTE9fRkxBR1NfUEFSVFND
QU47CgogICAgIAlpZiAoaW9jdGwoZmQsIExPT1BfU0VUX0ZELCAodm9pZCopKHVpbnRwdHJfdCko
ZmZkKSkgPCAwKSB7CiAgICAgCQlwZXJyb3IgKCJpb2N0bDogTE9PUF9TRVRfRkQiKTsKICAgIGRp
ZmYgLS1naXQgYS9rcGFydHgvbG9wYXJ0LmggYi9rcGFydHgvbG9wYXJ0LmgKICAgIGluZGV4IGM3
M2FiMjMuLjgxNTM0ZTIgMTAwNjQ0CiAgICAtLS0gYS9rcGFydHgvbG9wYXJ0LmgKICAgICsrKyBi
L2twYXJ0eC9sb3BhcnQuaAogICAgQEAgLTEsNCArMSw0IEBACiAgICAgZXh0ZXJuIGludCB2ZXJi
b3NlOwogICAgLWV4dGVybiBpbnQgc2V0X2xvb3AgKGNoYXIgKiosIGNvbnN0IGNoYXIgKiwgaW50
LCBpbnQgKik7CiAgICArZXh0ZXJuIGludCBzZXRfbG9vcCAoY2hhciAqKiwgY29uc3QgY2hhciAq
LCBpbnQsIGludCAqLCBpbnQpOwogICAgIGV4dGVybiBpbnQgZGVsX2xvb3AgKGNvbnN0IGNoYXIg
Kik7CiAgICAgZXh0ZXJuIGNoYXIgKiBmaW5kX2xvb3BfYnlfZmlsZSAoY29uc3QgY2hhciAqKTsK
ICAgIC0tIAogICAgMi4yNy4wCgogICAgLS0KICAgIGRtLWRldmVsIG1haWxpbmcgbGlzdAogICAg
ZG0tZGV2ZWxAcmVkaGF0LmNvbQogICAgaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs

