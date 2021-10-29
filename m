Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CE1C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 18:54:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 542CB60F9B
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 18:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 542CB60F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-vf_ULzRjPkyhKWd9lzZRKA-1; Fri, 29 Oct 2021 14:54:48 -0400
X-MC-Unique: vf_ULzRjPkyhKWd9lzZRKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927BD101B4A1;
	Fri, 29 Oct 2021 18:54:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3490A19D9B;
	Fri, 29 Oct 2021 18:54:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2445E1806D03;
	Fri, 29 Oct 2021 18:54:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TIscb1006157 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 14:54:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6B58B2166B3F; Fri, 29 Oct 2021 18:54:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6494F2166B2D
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 18:54:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F8A8811E7A
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 18:54:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-296-8sNXdEF-O92w1Nrf6xOjPw-1; Fri, 29 Oct 2021 14:54:32 -0400
X-MC-Unique: 8sNXdEF-O92w1Nrf6xOjPw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19THe7O3028575; Fri, 29 Oct 2021 18:53:59 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byhqrh52s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Oct 2021 18:53:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TIpfPc078424;
	Fri, 29 Oct 2021 18:53:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
	by aserp3020.oracle.com with ESMTP id 3bx4ggb13r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Oct 2021 18:53:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2790.namprd10.prod.outlook.com (2603:10b6:a03:89::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Fri, 29 Oct 2021 18:53:55 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.020;
	Fri, 29 Oct 2021 18:53:55 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Dave Chinner
	<david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoCAAELPAIABAAaAgAbwJYCAASa6gIABepqAgADWGwCAAHd9AA==
Date: Fri, 29 Oct 2021 18:53:55 +0000
Message-ID: <35d4da2e-ae2f-2998-f6d2-3598afdeaf05@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
	<22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
In-Reply-To: <22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5b47680-dfb7-4f04-e079-08d99b0d754d
x-ms-traffictypediagnostic: BYAPR10MB2790:
x-microsoft-antispam-prvs: <BYAPR10MB2790DED0742C03A220A708CAF3879@BYAPR10MB2790.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: dVEfVtHazmgoJNm3JelkmmOcN7/wJ7Z9ZPufB5NLoXUc7Gn2a/cj+TiSdIL4kdIcL+rkWADHhSoow5RQ3q6vH2OLOU4MNh8RtPjnpc4gvpX/X+XYtIZnoVOY0uoBP5zt/9UVhn78G7Btql/VmLsd43HT8yIvQW63AejWnTzyeOc/0549YP5UrkSWWEQ2XqySgU/ZmjPUhqgIXUoouC39U+sjPPIm6huONUi4oMJcwzZwZrdmqNIBglTaQBdkmFckL8eo5pLRgnYQVeLLtX8n5ZofX/W8Ff3mMKLvrjhpPrdrMY4aF92Hpic7/7Ys41xDvNa1dCXclThs2YSmmbKXUErbjwqIonLHTJZwaypWM0Hj9L+v/FRRkCib1bysyPHwuiX2ZsxAmMd9gIDb6vHkk3HYctllCyyv3w27XZND8/HyEj5ic5SqKXB6KLusIdVT8Hrhkgh/e++4DYD1DAhYjhfDsE+BCmLMbXBfc2OGMvPlua5M1+xntTEFamznOHaaQ2kUdJQ5n+W+dgOZEwYmj8Fq/IwkMR0UzVMywuCEnv9I9k5SmwufoEtdb41g9ul8XHiZwHYaHQd0NDKiQZMAellVPgKJJfjb66asg6EKFye5mHexryFfZSfUfN54GQX6u1cORx8r3COT+lGzm1niLIbBjwb+wkEH4ppmrPdyUQ0gE0/PTjC3t7EurFRn11XGy0IMdRIlb3sOlDHcEH1U2h+cF6i1uidM2zo6QgtXgdmNxlT6vhB0gw7KR14+YnhtMxv6kUDtNrKIE4vwcwMsog==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(508600001)(53546011)(6506007)(6486002)(26005)(71200400001)(44832011)(316002)(186003)(2906002)(5660300002)(6512007)(54906003)(110136005)(4326008)(86362001)(31696002)(122000001)(66446008)(64756008)(76116006)(66476007)(31686004)(66556008)(2616005)(38070700005)(38100700002)(7416002)(36756003)(8676002)(83380400001)(66946007)(8936002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVVEOUlCdmpvd1RZbTNaKzNvaDdoell4aVY2UHRaa3BKM0s5UHRPM0VlNzZi?=
	=?utf-8?B?UEdqTmxuajZ3eDNYY0NFVCt0T0xsVU9YTlM3QmxveHhveEdPYzBBNGJlZE1K?=
	=?utf-8?B?QU1mVGRuU2E3b0hadFBDbS9HQUVGQmxRWnV6eXdIQnk5bzZadVhQeFJmVzA4?=
	=?utf-8?B?d1p4MFBtUnNwaFNmb2ZicDI1UGRxbHpHMkg4ZmtOS0Q3ckZISGdFZFlWV3R1?=
	=?utf-8?B?c1pHNGVBQ2VmSnVtRFB1bENRdHB2RUpmNFVkN3YwcnB0RVNHdEtDckx1czZi?=
	=?utf-8?B?dUozOE1oVlpudFhaL1BkaytkOTg0MnBLM0QvaGZYdDMwREgwNmdocFk1MzFU?=
	=?utf-8?B?RndZYm91WExMZmUxQjFLRjRoNEhRajBDVWxkaTc0cGtTV0JtczlxMUt6Qjdv?=
	=?utf-8?B?M0gzQmFxRTJLV3pGQ2tvNVpGZ213WHNtWU9OZW9BVkNVS2dyNzdtenZZQ0lw?=
	=?utf-8?B?Nzg1aTFwbm9YaStBdUdjRkRDSm5DcytSbHkyV0s3RWwzdTNKK1VDanM0N25R?=
	=?utf-8?B?NVk2TWljK2dBaTI5VVByRStJUUIxdDIzR01kb0wvcFdLMjdITzVkZlJWVTl4?=
	=?utf-8?B?NElVRS9mY0lWaFI3NjVWbWJUQTdIQ1pPNDJTM0V1QTF5Z3pIbWdESGdabFJl?=
	=?utf-8?B?d1RDTTBtUXdlaHl1bTNDU1hySUk0eTBKdHJFQlFsQ1dpUm45c0d6bTYzamsz?=
	=?utf-8?B?bTFXS2JUWUtvNTlXVVY3aXdQOEZGM05RWHVMR0d1YmdsN01PZG1IcUsvNGcw?=
	=?utf-8?B?VDB2SlZZS2h6UlRFVGE0elJMSjdtbS9lTDJhcFBkMG5Ua1dYTm9yeFhSMnFi?=
	=?utf-8?B?a2JJV0tPemZhdjJRam9wQUN6U0U2dTBZS0pUZUdzTHpxZ3NCRFh3K1QxcWo5?=
	=?utf-8?B?eUM0K01yY0pOd2tCVVVUTjRNODNLMnZBREcxM05wVndRM3NrYkxqQTUxbVlP?=
	=?utf-8?B?bkhqTExrZW9RSzVQU0FJRzhOUC9YaS96U3cyekY5RzhUbm91ZGV2NExvOFBE?=
	=?utf-8?B?cTRKa3d5UHFvWUNnZHFoNlJ5NURWWkZLQWYxV2l5ZERJVER0UU5WWkc3SCsw?=
	=?utf-8?B?aUJBbjhxakhFaHlVYnNrUzJhcXBsanFnT0k2NXY5Q3ZFNnJvK2VOTmROOW5X?=
	=?utf-8?B?VDVmOFJlQlZBTmpONEttNVpYSi94U2tIRnNiMmRqZ2JnRHM1WjlsaGVocFg1?=
	=?utf-8?B?RnVNd0pINnNXL2pDK2VMNHo2ZjZWYkxOSExMRUQ1MzdFNktjaXl1RmxETWg4?=
	=?utf-8?B?b1hkRnZTQ0FRKzZPby8wdVloQlRyMW5Iekg5dFVCOWxTS2lRMTlNczFPTDFV?=
	=?utf-8?B?bGhuQzN5cFhoVjF2MjA4dmRoeGlkMWo2akMrMUhVWVU4bjczeVZOQ0dudStO?=
	=?utf-8?B?bWNwdDlNNktSeWVGQ3dLK0NPWWNOOUUwblFNRmtaaWx2Z1NTYVo0Z0tqK1Zs?=
	=?utf-8?B?dXRaWkM5aHN0QVBSWlByTE1YeWF1aXFYdDZMQU9JVjcxdmZ3dnJlV08yVnhW?=
	=?utf-8?B?RXRoMkN4RFVaT2szRm1xT2VBSXI2Umw5MVVIZm1vWFlwTUFkbmpZcytVM20v?=
	=?utf-8?B?K09CZ3ZwT1dkU0VoZTR6eVNLSkRuN2lhZWM4VkpJTVVyenJtdnJYRnNPM3ZK?=
	=?utf-8?B?TnpRbnMzblgycDJadnJBWUE4dHlLZU1VT2RPeHBkTG52empvM1dkS1V5SzVj?=
	=?utf-8?B?SCt6UGE5TjlveDh1dVpudERZSUp4aTE3NjM4Wk9EbllmRU1LaWRsMC9KYmc3?=
	=?utf-8?B?cnMvUjV4djhyMXgwc21Pci9rS0E5NFBvT3BBMU1MOG1zQ1dpNWo4bDNaZXN6?=
	=?utf-8?B?bFVacU44R0pDcTBuZU5RVzlwaSttNDZ6bHRrK1JqQzVlNWJoWnp4dm5aY1Yv?=
	=?utf-8?B?OHpMcWh5YW8zTlFFa2FCdWpkYWwvUk9lZFpTemJjZDNqZjN5dFBBRVE1WEZR?=
	=?utf-8?B?WExYMitDeTdSN3JmcXU4SFdHa2tBVkRrOGVFYUFza1llVy9sV3JUUHpqS3Ro?=
	=?utf-8?B?TGVZaUpNZTJhZWRteTVnNmU5Z2VBUGJjZlc5VnhCK2F0K2hWQjBNTW9uTk5a?=
	=?utf-8?B?OXpjazBveU03c3hPZ012K3BBRFBndWZwZmVmaktHeTYzZW1aY2hLcGVmZ3pQ?=
	=?utf-8?B?eUQrME9KWDVrcFpMK0tua2l1d1VpclJ4Qkd1OUNmNjJVOXNOL3VEZ056RnV2?=
	=?utf-8?B?b0E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b47680-dfb7-4f04-e079-08d99b0d754d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 18:53:55.3209 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: egtwPy2A/UMVMBDyTzdU3/kIBL8C3pWJ8H7TxNr7Q68CHrq81eAtjdlMoeghyV/AWKUnJRj796Ob1Z+bfzteMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2790
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxlogscore=999
	bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2110290103
X-Proofpoint-GUID: wOv3UPp8L5sa-BVu7hWNPapJ7BV-C8O7
X-Proofpoint-ORIG-GUID: wOv3UPp8L5sa-BVu7hWNPapJ7BV-C8O7
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19TIscb1006157
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <90F861C1586DD049BFBACFC30B33572C@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTAvMjkvMjAyMSA0OjQ2IEFNLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToKPiBPbiAxMC8yOC8y
MSAyMzo1OSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IFsuLi5dCj4+Pj4gV2VsbCwgbXkgcG9pbnQg
aXMgZG9pbmcgcmVjb3ZlcnkgZnJvbSBiaXQgZXJyb3JzIGlzIGJ5IGRlZmluaXRpb24gbm90Cj4+
Pj4gdGhlIGZhc3QgcGF0aC7CoCBXaGljaCBpcyB3aHkgSSdkIHJhdGhlciBrZWVwIGl0IGF3YXkg
ZnJvbSB0aGUgcG1lbQo+Pj4+IHJlYWQvd3JpdGUgZmFzdCBwYXRoLCB3aGljaCBhbHNvIGhhcHBl
bnMgdG8gYmUgdGhlIChtdWNoIG1vcmUgCj4+Pj4gaW1wb3J0YW50KQo+Pj4+IG5vbi1wbWVtIHJl
YWQvd3JpdGUgcGF0aC4KPj4+Cj4+PiBUaGUgdHJvdWJsZSBpcywgd2UgcmVhbGx5IC9kby8gd2Fu
dCB0byBiZSBhYmxlIHRvIChyZSl3cml0ZSB0aGUgZmFpbGVkCj4+PiBhcmVhLCBhbmQgd2UgcHJv
YmFibHkgd2FudCB0byB0cnkgdG8gcmVhZCB3aGF0ZXZlciB3ZSBjYW4uwqAgVGhvc2UgYXJlCj4+
PiByZWFkcyBhbmQgd3JpdGVzLCBub3Qge3ByZSxmfWFsbG9jYXRpb24gYWN0aXZpdGllcy7CoCBU
aGlzIGlzIHdoZXJlIERhdmUKPj4+IGFuZCBJIGFycml2ZWQgYXQgYSBtb250aCBhZ28uCj4+Pgo+
Pj4gVW5sZXNzIHlvdSdkIGJlIG9rIHdpdGggYSBzZWNvbmQgSU8gcGF0aCBmb3IgcmVjb3Zlcnkg
d2hlcmUgd2UncmUKPj4+IGFsbG93ZWQgdG8gYmUgc2xvdz/CoCBUaGF0IHdvdWxkIHByb2JhYmx5
IGhhdmUgdGhlIHNhbWUgdXNlciBpbnRlcmZhY2UKPj4+IGZsYWcsIGp1c3QgYSBkaWZmZXJlbnQg
cGF0aCBpbnRvIHRoZSBwbWVtIGRyaXZlci4KPj4KPj4gSSBqdXN0IGRvbid0IHNlZSBob3cgNCBz
aW5nbGUgbGluZSBicmFuY2hlcyB0byBwcm9wYWdlIFJXRl9SRUNPVkVSWQo+PiBkb3duIHRvIHRo
ZSBoYXJkd2FyZSBpcyBpbiBhbnkgd2F5IGFuIGltcG9zaXRpb24gb24gdGhlIGZhc3QgcGF0aC4K
Pj4gSXQncyBubyBkaWZmZXJlbnQgZm9yIHBhc3NpbmcgUldGX0hJUFJJIGRvd24gdG8gdGhlIGhh
cmR3YXJlICppbiB0aGUKPj4gZmFzdCBwYXRoKiBzbyB0aGF0IHRoZSBJTyBydW5zIHRoZSBoYXJk
d2FyZSBpbiBwb2xsaW5nIG1vZGUgYmVjYXVzZQo+PiBpdCdzIGZhc3RlciBmb3Igc29tZSBoYXJk
d2FyZS4KPiAKPiBOb3QgcGFydGljdWxhcmx5IGFib3V0IHRoaXMgZmxhZywgYnV0IGl0IGlzIGV4
cGVuc2l2ZS4gU3VyZWx5IGxvb2tzCj4gY2hlYXAgd2hlbiBpdCdzIGp1c3Qgb25lIGZlYXR1cmUs
IGJ1dCB0aGVyZSBhcmUgZG96ZW5zIG9mIHRoZW0gd2l0aAo+IGxpbWl0ZWQgYXBwbGljYWJpbGl0
eSwgZGVmYXVsdCBjb25maWcga2VybmVscyBhcmUgYWxyZWFkeSBzbHVnZ2lzaAo+IHdoZW4gaXQg
Y29tZXMgdG8gcmVhbGx5IGZhc3QgZGV2aWNlcyBhbmQgaXQncyBub3QgZ2V0dGluZyBiZXR0ZXIu
Cj4gQWxzbywgcHJldHR5IG9mdGVuIGV2ZXJ5IG9mIHRoZW0gd2lsbCBhZGQgYSBidW5jaCBvZiBl
eHRyYSBjaGVja3MKPiB0byBmaXggc29tZXRoaW5nIG9mIHdoYXRldmVyIGl0IHdvdWxkIGJlLgo+
IAo+IFNvIGxldCdzIGFkZCBhIGJpdCBvZiBwcmFnbWF0aXNtIHRvIHRoZSBwaWN0dXJlLCBpZiB0
aGVyZSBpcyBqdXN0IG9uZQo+IHVzZXIgb2YgYSBmZWF0dXJlIGJ1dCBpdCBhZGRzIG92ZXJoZWFk
IGZvciBtaWxsaW9ucyBvZiBtYWNoaW5lcyB0aGF0Cj4gd29uJ3QgZXZlciB1c2UgaXQsIGl0J3Mg
ZXhwZW5zaXZlLgo+IAo+IFRoaXMgb25lIGRvZXNuJ3Qgc3BpbGwgeWV0IGludG8gcGF0aHMgSSBj
YXJlIGFib3V0LCBidXQgaW4gZ2VuZXJhbAo+IGl0J2QgYmUgZ3JlYXQgaWYgd2Ugc3RhcnQgdGhp
bmtpbmcgbW9yZSBhYm91dCBzdWNoIHN0dWZmIGluc3RlYWQgb2YKPiB0aHJvd2luZyB5ZXQgYW5v
dGhlciBpZiBpbnRvIHRoZSBwYXRoLCBlLmcuIGJ5IHNoaWZ0aW5nIHRoZSBvdmVyaGVhZAo+IGZy
b20gbGluZWFyIHRvIGEgY29uc3RhbnQgZm9yIGNhc2VzIHRoYXQgZG9uJ3QgdXNlIGl0LCBmb3Ig
aW5zdGFuY2UKPiB3aXRoIGNhbGxiYWNrcyBvciBiaXQgbWFza3MuCgpNYXkgSSBhc2sgd2hhdCBz
b2x1dGlvbiB3b3VsZCB5b3UgcHJvcG9zZSBmb3IgcG1lbSByZWNvdmVyeSB0aGF0IHNhdGlzZnkK
dGhlIHJlcXVpcmVtZW50IG9mIGJpbmRpbmcgcG9pc29uLWNsZWFyaW5nIGFuZCB3cml0ZSBpbiBv
bmUgb3BlcmF0aW9uPwoKdGhhbmtzIQotamFuZQoKCj4gCj4+IElPV3MsIHNheWluZyB0aGF0IHdl
IHNob3VsZG4ndCBpbXBsZW1lbnQgUldGX1JFQ09WRVJZIGJlY2F1c2UgaXQKPj4gYWRkcyBhIGhh
bmRmdWwgb2YgYnJhbmNoZXPCoMKgwqDCoMKgIHRoZSBmYXN0IHBhdGggaXMgbGlrZSBzYXlpbmcg
dGhhdCB3ZQo+PiBzaG91bGRuJ3QgaW1wbGVtZW50IFJXRl9ISVBSSSBiZWNhdXNlIGl0IHNsb3dz
IGRvd24gdGhlIGZhc3QgcGF0aAo+PiBmb3Igbm9uLXBvbGxlZCBJTy4uLi4KPj4KPj4gSnVzdCBm
YWN0b3IgdGhlIGFjdHVhbCByZWNvdmVyeSBvcGVyYXRpb25zIG91dCBpbnRvIGEgc2VwYXJhdGUK
Pj4gZnVuY3Rpb24gbGlrZToKPiAKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs

