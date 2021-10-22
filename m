Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B14C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:39:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F168361038
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F168361038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-YH1jKUMIOJCKMF7M1Yz_gQ-1; Thu, 21 Oct 2021 21:39:06 -0400
X-MC-Unique: YH1jKUMIOJCKMF7M1Yz_gQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26DEE802B7E;
	Fri, 22 Oct 2021 01:39:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2979260C13;
	Fri, 22 Oct 2021 01:39:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83A90180BAD1;
	Fri, 22 Oct 2021 01:39:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M1bk7g022806 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 21:37:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B4D62166B25; Fri, 22 Oct 2021 01:37:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 821D22166B2D
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:37:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F495185A7A4
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:37:43 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-205-XxhXi5AwM2a_P2IqjBVVxA-1; Thu, 21 Oct 2021 21:37:40 -0400
X-MC-Unique: XxhXi5AwM2a_P2IqjBVVxA-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LNib1w019173; Fri, 22 Oct 2021 01:37:32 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2rgcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 01:37:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M1Vfea084363;
	Fri, 22 Oct 2021 01:37:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by userp3030.oracle.com with ESMTP id 3bqkv2wdx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 01:37:30 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3224.namprd10.prod.outlook.com (2603:10b6:a03:153::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18;
	Fri, 22 Oct 2021 01:37:28 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 01:37:28 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoA=
Date: Fri, 22 Oct 2021 01:37:28 +0000
Message-ID: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
In-Reply-To: <YXFPfEGjoUaajjL4@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea73eff8-2c62-4869-608a-08d994fc8226
x-ms-traffictypediagnostic: BYAPR10MB3224:
x-microsoft-antispam-prvs: <BYAPR10MB32241B676D280424BEBC4EC0F3809@BYAPR10MB3224.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: rgknTlS1HUD2+NGPDe8IHEp5G8MWclxk4C2hzaXFZACjen5uZUwlqyXc+ZQ+r3Gi+Y0rDFU1shVUDRHHR86Ih9eWqKIo81BceaQhD2vsuwlgzOqr0DwE5ZDXcLkUr8mU4a1O2gfUKaIhevYgANBX2ewlxaPrRG6LpUzuQfEm5wZBn9ajEgzcBMoNKK2SRkTNd0y6TrF93YWkrYR48JxlJL0D1ZJd97JA5uZXvBrM3oaD7kCCzifry82s6CkC9VF4Q218g7JNDLm3MOEyX+mVQqK47aQkCgPLkMLLHAEsxayCnRwKlQbdwY2ZDlHjPgCLUcux9yOlSkblciOCm6Hxal4/l33W71riABgAwFzQzKI0vgckQF684CSgTUqfs5giJfkKRrSKL76aU/IUjCYZSuS3uwcM6HZrCEHHiiLCwXNOMeqFsj8Z2qIPm1u8J1QeXCD9LprPGaj1AN3VxfuFy1gA4IPbvs5fiRN14nm/ULQ5sdw4/VTOerLzVs9p2Ajxo94ybusz4sYKeGvKAcYFh70bVqB0jFVzvyP7k2Odnz5aqJYYSMClyJ4w3l4VKPeNmJ18iAGcolADJGGw2zBZiNNFuHT2K5o35aPzN++QBahl2TN3sJTtcYhVueKp0yx9vOeqljlWGkbFQHgn8jSsG7sPhmF63sKkGphWqtMisn7eF5q01tz1kQarn7kN/+5YLaU6UdUHVfHeM+tm1olG67Fz1oOP3vfW16pPpEPY6mBavqJ/2Jz+hDCHmqht2cxeKIrHlRJ/5ceXdzct7FsvZQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6916009)(2616005)(122000001)(6512007)(38100700002)(66556008)(5660300002)(54906003)(76116006)(44832011)(66946007)(31686004)(6486002)(66476007)(83380400001)(2906002)(316002)(91956017)(31696002)(86362001)(6506007)(8676002)(71200400001)(64756008)(36756003)(7416002)(186003)(4326008)(38070700005)(508600001)(8936002)(66446008)(26005)(53546011)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHFnOG1CaWUwbjg3R1NIM2RpSVByRkZKT0FrZVJKUVU4QXVOOEJjQTdBT1Rz?=
	=?utf-8?B?TVltQWs5Q1p1ZlF0SGs3U01UVE1QUHYyZlh1OGxqSXNNaSt4VmxvRU9XaXlV?=
	=?utf-8?B?c1Z4bVVXNlZtRDVCTEFCWnVyV3hzclRmbkkvclladFBmeHZXaVlZTzBlN1d3?=
	=?utf-8?B?VGVob05venpJVWFPV2FNd3JPOHAvOUVCQk5La3FoMjg5RW9DREVqTlZNcXdP?=
	=?utf-8?B?RUhzeUZqYkZpaEsvOGs0WlBDRS95aUVHOHdkbkNBekRsYWtjOTBXRGNsdXF1?=
	=?utf-8?B?RmJCem9oSnFGTHRJOHhobDNQS1lyMVlPbUhvY3QwQ2ZqQnY1dy9vL1BlVWpG?=
	=?utf-8?B?WFVaQ0F1bWZ6cE1NVHcvT2g5bDlGUFNNR05lYVkrVVAyWXFwN0pXdSt6RFRl?=
	=?utf-8?B?YStmV2dKOXhjTm1kNGU5NUlybnRXL3lQVVVteHV3WEdVODRFVFVJbTc1U1Y4?=
	=?utf-8?B?U0lsOEMzOUNzZllFNEZ4d0g4OWJoa0RMR2lxYnBucGZuWmFSWFpjbVhMbVFi?=
	=?utf-8?B?WE1ZVEZGZElodTV6L1RlK3FueU5xWnhLclpHVXNNQ3FpaFEvdlN5UzRibjNZ?=
	=?utf-8?B?K3F0WnZUdjFqSVNwVHNnNDhvOHRTZzNmSkdtalltQ2tTZ21jVy9CL28yT2to?=
	=?utf-8?B?M1poRHZzblZuWFNmV3VQOXB3aWF3NlZrMGY2Q2w2THY2L1ZGaG5Ma1lPcnpR?=
	=?utf-8?B?Rkc5SWtGdndwbWh1SmN1VGU5L0l0ejR1U0ZmQ3hWNWQ5VXlDbGxDT1dGMnZz?=
	=?utf-8?B?ZHZmWGlKNnZyY3hZa0pXU2hvejJmcldjR2JrM2FrOWlLYUZOYmRJMURuSGdv?=
	=?utf-8?B?d1BDb1pzSVptTlJRNHJoWENnSUdyaHpxNnROR1IydWFaNzdma3BXQ3c3NU83?=
	=?utf-8?B?R3lXUDRLaFhBMGlQYnpWdUticTBGTGg0cmdRUzBhaExsWm8vR2Y5MDRiSjZ0?=
	=?utf-8?B?TDdlT0hDTk1ZS21RSGJsSlo0NVY4MGZBL1pkcEhsRlRxSEk1YUphSTJUMkQz?=
	=?utf-8?B?YXdScTJwSDlMcG5UN0orUWdlUUZ2MGx6cWdFL3RwK1VTcHcycDU1MERwQW5Q?=
	=?utf-8?B?NVdKc1dNL0w0WDVvTHJ5QU1wcGJyaHIvYk1teTdtRm9EamdodHRtSGF3bWRV?=
	=?utf-8?B?ZmtoNzZEbmpSbUtWQjQ0Nmh6c21WdkRMVjNyd2h6WlRFVnNIdmFMbEF0Y1I4?=
	=?utf-8?B?aFdvaC9EdUFnQmUvL1pjMHF5dmdpRWpySGY1WFJRS2EvQUs0Tnl6bkthcmY4?=
	=?utf-8?B?MzY4eWpIYTRPRWtGV1RTZUVGZnhZVG5KdDJSNWJwaFlHSUNNYXppOFUxZ1Ri?=
	=?utf-8?B?bEp3RHRXaTN6eGU0U1FFVEdRRWNsVDJGUGZzU282SmtKVkcrVzZrTmtXYmxu?=
	=?utf-8?B?TC9wNDFERy9BZjJrK2lSUk5nY2s3VGNyQ2NRdU5mVENXZHRKNjhTQkcyZmZQ?=
	=?utf-8?B?THJpdFlmZGdUWmVzMkJ2UWczSVpib3VxdG1rMS9oZVBaNG9pZDRJbzFZTzVO?=
	=?utf-8?B?d2dvTWFnbEZueEU4Vjk0THlnL2dOMENicHYvcmhtNVN3ZG5MaFRyVURVcExR?=
	=?utf-8?B?T3l5blN1Z2tmZkFYSEYwTjg4S2dpdWZrNS8vUlZZZFdEUXowSGtzcnBuV2NO?=
	=?utf-8?B?U0pqa21CNVlNR215YXFDekZmdk1iTUZMN2tPYWtGLzJQaDZGWi9iaXhhV2pR?=
	=?utf-8?B?ZTFLemFnd0FpZm9tbUx3ZmsxZ3k5bVl1NXFMOGRVeGIrWkthemI2QklKa3lR?=
	=?utf-8?Q?AKReQmK/zEPQsHPEhw=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea73eff8-2c62-4869-608a-08d994fc8226
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 01:37:28.5171 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3224
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220006
X-Proofpoint-ORIG-GUID: 4VggrbHW5vKK4dlcbEmtotYV-qv6imVk
X-Proofpoint-GUID: 4VggrbHW5vKK4dlcbEmtotYV-qv6imVk
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19M1bk7g022806
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9D0B4C40E28A1A4D8C2C44AC19319ACC@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
> Looking over the series I have serious doubts that overloading the
> slow path clear poison operation over the fast path read/write
> path is such a great idea.
> 

Understood, sounds like a concern on principle. But it seems to me
that the task of recovery overlaps with the normal write operation
on the write part. Without overloading some write operation for
'recovery', I guess we'll need to come up with a new userland
command coupled with a new dax API ->clear_poison and propagate the
new API support to each dm targets that support dax which, again,
is an idea that sounds too bulky if I recall Dan's earlier rejection
correctly.

It is in my plan though, to provide pwritev2(2) and preadv2(2) man pages
with description about the RWF_RECOVERY_DATA flag and specifically not
recommending the flag for normal read/write operation - due to potential
performance impact from searching badblocks in the range.

That said, the badblock searching is turned on only if the pmem device
contains badblocks(i.e. bb->count > 0), otherwise, the performance
impact is next to none. And once the badblock search starts,
it is a binary search over user provided range. The unwanted impact
happens to be the case when the pmem device contains badblocks
that do not fall in the user specified range, and in that case, the
search would end in O(1).

Thanks!
-jane



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

