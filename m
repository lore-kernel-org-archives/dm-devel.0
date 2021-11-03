Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417F8C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:11:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9A1B6112E
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C9A1B6112E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-WcMt9eIkMk2Wp-_a30FpVQ-1; Wed, 03 Nov 2021 14:11:51 -0400
X-MC-Unique: WcMt9eIkMk2Wp-_a30FpVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FE2187D544;
	Wed,  3 Nov 2021 18:11:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C0681B5B7;
	Wed,  3 Nov 2021 18:11:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE3DA1800B9E;
	Wed,  3 Nov 2021 18:11:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3IAorf027332 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 14:10:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 56E6151E1; Wed,  3 Nov 2021 18:10:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45DB351E4
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 18:10:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23D1D8011A5
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 18:10:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-495-zTp2AttiOSymLhFleUGPjg-1; Wed, 03 Nov 2021 14:10:45 -0400
X-MC-Unique: zTp2AttiOSymLhFleUGPjg-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A3HgItm008338; Wed, 3 Nov 2021 18:10:02 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c3q1nb6hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Nov 2021 18:10:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A3Htga5018954;
	Wed, 3 Nov 2021 18:10:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by aserp3030.oracle.com with ESMTP id 3c3pfy26sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Nov 2021 18:10:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2967.namprd10.prod.outlook.com (2603:10b6:a03:87::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18;
	Wed, 3 Nov 2021 18:09:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.011;
	Wed, 3 Nov 2021 18:09:57 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoCAAELPAIABAAaAgAbwJYCAASa6gIAIPpYAgAJY/YA=
Date: Wed, 3 Nov 2021 18:09:57 +0000
Message-ID: <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
In-Reply-To: <YYDYUCCiEPXhZEw0@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68f6b887-5d2c-4ef4-0e81-08d99ef52525
x-ms-traffictypediagnostic: BYAPR10MB2967:
x-microsoft-antispam-prvs: <BYAPR10MB2967D4507EE6E02BADE2819CF38C9@BYAPR10MB2967.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: F9ngDCMj9/BGiwlH5070rFXWjvJwOu/AqLAwWuRxZdWmRS61IxmhKEv/ohOSybO0UK+cZPFcXKkt0ICRm+NDxj/PErQzD0IXxrLp8dYS7fIoWA4LFdXmYt4XEoTeL0Z8TN9iBYRK09s6Rji3SL2SHnvdUBP8d5vEMkh3kefMQTxWxMUfIMmlTXrKCtT7w24jJpwmUozk1Ie6qwxxCxjTiiIw4LXGgrobk/nprqdSH2FJfIbMUf7EKIhN/YGPmNfVrivp79q/cyW/6uvQ7MqE5LrmKQdrFx6eCquj1MZQyrNRNBfkWPDHqyWAxPgv2asJGHPolf/FGaHj00ZmF11hIh8ZZVTSRHPGuGpYRKZMBEVjTklN7T6FMGFYukm4uHriitNDbUka6cQoG0brnGJht2XU6ZsKY0n9x7b6deMXSoQaAfp9YtFIVNIVURFJB2jIaWstifqAyH6+rUSCoSyh7FMwERAyDTNKqnc8Vz7RnpFQ1dzG3fhRmpmcGPpl0v4VRIglMxNZrZNU3sdhJIHqQGNn/nC8W/3m1nzu+u4jeYFxGhRr+jSVt4QgyVzAhQyFqcg49v1DByOcILBLhPd3826E9y6wY4P8lBJCIho/t9Xb8FoHo/ARXOqKI9CteMqnY4lFyBpEjkeJgjVrBJsZ8Ej3STERmH7Jo0NNOCLI9guL7j0DISTBRdHo5Ku8FOWgsj41z+Hox95lQ884Bnehw52nSe3i3TLc5AHN/Sfxc9D0EGe8k6hurWj+Uym1o14at0670N1RbNl8L96uzrN/ofzMZouwa4UURHpo2Oki261qqmV2HLwPRCagskOBmKCsi1RpRQEJsBxxkoDxlAYURRKiB/AojaK+NFeMcIRO5PC98YDR4nJE4FUiuqkeuN+TQAJYCxTNGxEZGUjAf+6rlA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(110136005)(54906003)(8936002)(6486002)(86362001)(36756003)(31696002)(186003)(2906002)(2616005)(316002)(71200400001)(26005)(83380400001)(5660300002)(64756008)(66476007)(66946007)(508600001)(4326008)(6506007)(7416002)(966005)(38070700005)(6512007)(31686004)(8676002)(53546011)(66446008)(44832011)(91956017)(66556008)(38100700002)(76116006)(122000001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUg1cWFYSzVBSFJFTUp6WFpybWFiVy9VRjZ2TCsvWkozQTFiTUd1WjVhNmRJ?=
	=?utf-8?B?UTFldmFsdzRrZk01TWdhUU8vNkRkWkhPbkF6aW9qQmhXTExJN0Y0cmJxejFG?=
	=?utf-8?B?RUdvNjUwWmd5U1hLbGIyZU1zY1hwRUw0d01pb1VWREd0U0lsdDVuenZXSzlj?=
	=?utf-8?B?YUkwbWxOb0h6anZGTFNNUktnd09mRkJuOS9rK2d3UjFRMGxlTXd1YzhKNFh6?=
	=?utf-8?B?L056eGNUd0ljUjEvSmJjdFp0ZFFleTNOMFcwcjZ3N3dha1NCRHhYOGYzaTV0?=
	=?utf-8?B?N2ZOclZOSVlaWlQ0TjFpb3dlUVZ2K2I1cW9vSVNTSGpHQzhuTnFBazI3MERF?=
	=?utf-8?B?alNMdHh3TzFMdVV5SE8wbi9ISkIyRDMzRTdXQ3BmMHV4bVprWVNjMEVSYXBq?=
	=?utf-8?B?TjBaeTAvaXJOeWFUUGpIM3VBalBLS2RnOU5yblBpeHJvTTVlUDI1TE9jREtH?=
	=?utf-8?B?Tzl1aWs4L2RUckFocU8xS0QxWWdyL1FST01iRVdPUTduV0MrUElGVnUwSksv?=
	=?utf-8?B?MzBocU0zUVg1L3VwaU4yOGl5M2pUQ0tENVBWMDZNUHVIZ250RWNzeDhxWlUy?=
	=?utf-8?B?N2ppMmZvREVuWmRFSUNIZVdRdTFZdXpySnFxSURNcTltQjM3VmpzT0ZwbVVY?=
	=?utf-8?B?UytNbVdpdDA3Wm8xaVEwVXRwZUNRWGpsSi9aditkblZCcEh6dFJJTGM3Q1dn?=
	=?utf-8?B?QUl2dGZFc01yVWpXKzNYL3FqLzhobXFqaW5rVHYrQXpibW0rUkpsd2cyc2tX?=
	=?utf-8?B?VklBSXVBYzdNMjRqQy9jcVlibStwZ1BuVjF2TmZXdmZrSWJuM1U3N3l3djRI?=
	=?utf-8?B?WUVFM3BIUVl2Qyt3UkxhSytsTWFOY0h6bkZHK0RRNVVhdTF5ZUttU3IxTGtD?=
	=?utf-8?B?WXdKZkg3djNpNElSTXRoNDZ3cHpxN3RKRGJzcG0wSWhYZGxuTmFpNVMrakFo?=
	=?utf-8?B?c3hiQXhIZ25UZEc3QzRvSSswQjFtM0U0QkVLSFFidjNQQjdaemZhRG5UYW5u?=
	=?utf-8?B?YnZxc2J4YzlHY2F2d1FzUnROQmJqNzJXZFU3MzF5MG42WStDR1FPcE11NUcz?=
	=?utf-8?B?SzVYOHVFOUZqSHpubGYrMTJxUXQzOGxFQ2ZTMWJMVXA2UU1uSUZOMmI0V0w3?=
	=?utf-8?B?Z3FCZ0hGa3ltN0FpOW42dWsxNXZRc3MvR2o5dDVudzV4YjN4QWQybTN1YUJX?=
	=?utf-8?B?SUcvOXJJMVlCOEY5MENsb2RzazcyNGRxRjRQSjNxNlNVK1Jmb3lqdWl3ZEJD?=
	=?utf-8?B?OUJBdnVZUUJYRVVZazNoY1IrNWN2emdkZ0hOeUxmZ1owS0RyRFdxN0FzN3Zs?=
	=?utf-8?B?eTRyZVB3UVdORU5tTlBnR1dyUlBJYmxYbCtmaUFFeStSd0h5S0g5QUNtVDR1?=
	=?utf-8?B?dlZ3bWxGbm5qdTJwOXFzVHNHNklWem9KUFU1Z3RrUnBDNXBNNTIxL1hRMEc5?=
	=?utf-8?B?NnZ0ekFJTnVkTzFzT2p2ODQyUU0xRjZ4ZEpzcjQwejFnSEQ4c1p4K0V3YzVX?=
	=?utf-8?B?QUhSWXZNa3JyenQ0N1REaXZxWDVDa25qYTMybzE2eG9PRjFjQlFReUllRHpT?=
	=?utf-8?B?QlBYc0tzeHRSd2FYOW95NmdaZUR4djR2cmNFZkg2ZWJiUVRmV1kwMU1OOUp1?=
	=?utf-8?B?bFN1QXlzRm5aV3BIbFRIVTl5VHo1NnNtRFhhSEdyNU5LRVFuNkVIb1d3SkFE?=
	=?utf-8?B?Mzl6Lzl0UGsvVzBWLy9ERFJlb3dEODNhbGs5SHMxM2RyL2ltQ1ZvQThud2hV?=
	=?utf-8?B?dm5lQ3BBMys5MWVKcEZmVCtzbit4MEJVYm5OSC9HK25nM2plZmIxaEdjUWtB?=
	=?utf-8?B?Y05BMys4Ymt1eDlFRlFRalRjSElxdmxMZm03aFpFTW1XSkt5WHhpc2dSUGFG?=
	=?utf-8?B?SnNHME9UQVE0c29wK3dBNTRwTSszVlZSZjYydUJLUTVBZXI5dyszZDNBclEy?=
	=?utf-8?B?bG5vNGF6T0FvMVZFejJlUlpYTnJsbDh6RkNKS1cxdkVhSDdobk1jZHhsSnhJ?=
	=?utf-8?B?aklQWXVNM1ZHdW9VT3FEWk84S2kyRVFyN2NRRmpkbnI0bUY0ZDBTWCs3U0tm?=
	=?utf-8?B?bE5pZWc2M2ZwTHZEQjFyTGJBdFkzRDVOTUdUUHdONmNSSk5NOW80L0xGZDBJ?=
	=?utf-8?B?VmFveDZzeFpSb2sxaWhxRjA4SUJHYXcyaHFNS0YyNjUvRDhicXNHdnJFTy8y?=
	=?utf-8?B?MVE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f6b887-5d2c-4ef4-0e81-08d99ef52525
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 18:09:57.5972 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nbc/iXgUQK/KbZln7fo+T4eTvz3vKgVOdjAD6REI4q5rRyj4H2xg+UcIwzFfqJnt5G4Jdn7YydN7jeTDUC0U1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2967
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	suspectscore=0
	malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111030096
X-Proofpoint-ORIG-GUID: XhpW4DRbLRb9jAE0d1IfqUrFu4lPa2Ad
X-Proofpoint-GUID: XhpW4DRbLRb9jAE0d1IfqUrFu4lPa2Ad
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A3IAorf027332
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <82AAA3E6AE7CCC4AAFCDAAE954D866E1@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/1/2021 11:18 PM, Christoph Hellwig wrote:
> On Wed, Oct 27, 2021 at 05:24:51PM -0700, Darrick J. Wong wrote:
>> ...so would you happen to know if anyone's working on solving this
>> problem for us by putting the memory controller in charge of dealing
>> with media errors?
> 
> The only one who could know is Intel..
> 
>> The trouble is, we really /do/ want to be able to (re)write the failed
>> area, and we probably want to try to read whatever we can.  Those are
>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>> and I arrived at a month ago.
>>
>> Unless you'd be ok with a second IO path for recovery where we're
>> allowed to be slow?  That would probably have the same user interface
>> flag, just a different path into the pmem driver.
> 
> Which is fine with me.  If you look at the API here we do have the
> RWF_ API, which them maps to the IOMAP API, which maps to the DAX_
> API which then gets special casing over three methods.
> 
> And while Pavel pointed out that he and Jens are now optimizing for
> single branches like this.  I think this actually is silly and it is
> not my point.
> 
> The point is that the DAX in-kernel API is a mess, and before we make
> it even worse we need to sort it first.  What is directly relevant
> here is that the copy_from_iter and copy_to_iter APIs do not make
> sense.  Most of the DAX API is based around getting a memory mapping
> using ->direct_access, it is just the read/write path which is a slow
> path that actually uses this.  I have a very WIP patch series to try
> to sort this out here:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> 
> But back to this series.  The basic DAX model is that the callers gets a
> memory mapping an just works on that, maybe calling a sync after a write
> in a few cases.  So any kind of recovery really needs to be able to
> work with that model as going forward the copy_to/from_iter path will
> be used less and less.  i.e. file systems can and should use
> direct_access directly instead of using the block layer implementation
> in the pmem driver.  As an example the dm-writecache driver, the pending
> bcache nvdimm support and the (horribly and out of tree) nova file systems
> won't even use this path.  We need to find a way to support recovery
> for them.  And overloading it over the read/write path which is not
> the main path for DAX, but the absolutely fast path for 99% of the
> kernel users is a horrible idea.
> 
> So how can we work around the horrible nvdimm design for data recovery
> in a way that:
> 
>     a) actually works with the intended direct memory map use case
>     b) doesn't really affect the normal kernel too much
> 
> ?
> 

This is clearer, I've looked at your 'dax-devirtualize' patch which 
removes pmem_copy_to/from_iter, and as you mentioned before,
a separate API for poison-clearing is needed. So how about I go ahead
rebase my earlier patch
 
https://lore.kernel.org/lkml/20210914233132.3680546-2-jane.chu@oracle.com/
on 'dax-devirtualize', provide dm support for clear-poison?
That way, the non-dax 99% of the pwrite use-cases aren't impacted at all
and we resolve the urgent pmem poison-clearing issue?

Dan, are you okay with this?  I am getting pressure from our customers
who are basically stuck at the moment.

thanks!
-jane







--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

