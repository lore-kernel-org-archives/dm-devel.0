Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3664C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 18:24:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 72DE8613C8
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 18:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72DE8613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-outRrSFvPbCq-Zbt01QgUA-1; Thu, 21 Oct 2021 14:24:35 -0400
X-MC-Unique: outRrSFvPbCq-Zbt01QgUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8750D806689;
	Thu, 21 Oct 2021 18:24:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97E285D6CF;
	Thu, 21 Oct 2021 18:24:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01A164A703;
	Thu, 21 Oct 2021 18:24:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LIOSo1017144 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 14:24:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0C42C40D1B9E; Thu, 21 Oct 2021 18:24:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0765040C1257
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 18:24:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFA28106655B
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 18:24:27 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-g-eoG7naMN2UM5bnWsyOWg-1; Thu, 21 Oct 2021 14:24:24 -0400
X-MC-Unique: g-eoG7naMN2UM5bnWsyOWg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LHxKV6030748; Thu, 21 Oct 2021 18:24:16 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkxa0kfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 18:24:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LIFfVd191933;
	Thu, 21 Oct 2021 18:24:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
	by userp3020.oracle.com with ESMTP id 3br8gwgxsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 18:24:05 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:9c::17)
	by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18;
	Thu, 21 Oct 2021 18:24:03 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com
	([fe80::f12e:1d7a:66a3:3b1b]) by
	CO1PR10MB4418.namprd10.prod.outlook.com
	([fe80::f12e:1d7a:66a3:3b1b%5]) with mapi id 15.20.4628.018;
	Thu, 21 Oct 2021 18:24:03 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH 3/6] pmem: pmem_dax_direct_access() to honor the
	DAXDEV_F_RECOVERY flag
Thread-Index: AQHXxhA9jtGrb5nkUU6g/kyAPNS1eqvdT/kAgAB1ioA=
Date: Thu, 21 Oct 2021 18:24:03 +0000
Message-ID: <d5419b70-97fd-b760-5343-066e9b5cb9f9@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-4-jane.chu@oracle.com>
	<YXFNqI/+nbdVEoif@infradead.org>
In-Reply-To: <YXFNqI/+nbdVEoif@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c9e0640-0866-4d39-b490-08d994bff5dd
x-ms-traffictypediagnostic: MW4PR10MB5702:
x-microsoft-antispam-prvs: <MW4PR10MB57025A684F140A9B4FDAE5E8F3BF9@MW4PR10MB5702.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BRY/pfvmx8A5wQ1TSm3HrHGQWm+K+hFYKwEX8OXSpRad7WrL+bLPY97CkySk22mu/ZRCbZShV2vcsFUaxM+GcLkp5y3B0PX34r2IicozZEVOdalsa+qexMHaX1RKmXFz5+4BZ/ByYQP3ZjZAr5Dy/Neuau2J9uN97IfGoPrbTHQpzQaqACZ2N6p7STHQYNUAB+RdI4TKv7HKt1uqrinwxQIcHXHSPLXtXqGzUGfTUaFA2DW/RwQGoheUpGkrvmqzYn+Zu9DKVldsr3oXWRfpDYaxq8uWo0PfP+/S5/a7ToQJ3tXHDY6IZ4Thb06UdCrLNDOsHeh1XJZGXk4hPcuWuNshtBqyjHBCBgqWtByCtW/s4MoW7XJORal0kBHXUNMggqSvycGuOQqUPA4qAxbm5Kt6Ye/6mR2xE/mrES2OjZOSzidpisfYc/pZ3+WrFy3MBVqj3lHoDKxyanYqaARQsLAQt6ugzicS9NfTXBUV2fqo5G9lxGJpH2ccSYBqalCyucopM3XjGH7Pv5N0vqbFbK8pnfjwOBQ4kTVPCAKzuKcWcyKv/41oUWxDPYhVIHDYBNBg8mYHur81XvpzC/xbXlLm5PVx8V3C3v4QwvD1r0XnU1Z6kulPVWCrjkeKOyKwlvdkcLkKNjbKs0wDOzfzngTCkOW3ZS1MR7DyeLhbhf8fFvDPCxwJd9nOcTAjOHlY9/DNC2OMbNhOTZsp7kj6hdhYNrETZvzw6a56M7ChY0WXPinPmk4XCcvqbVqfbgt2fflnsS2/sVpKlnPL5B9LUw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CO1PR10MB4418.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(31686004)(8936002)(5660300002)(38100700002)(4744005)(71200400001)(86362001)(66946007)(6916009)(66476007)(2616005)(4326008)(2906002)(8676002)(64756008)(66556008)(53546011)(36756003)(6512007)(122000001)(44832011)(508600001)(7416002)(38070700005)(31696002)(6486002)(54906003)(26005)(66446008)(76116006)(186003)(6506007)(91956017)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnY2Uk5uTzJzQmpyMDJYWnFvTzYwVlE1bDFEcjhHRzVvM1V6RVYrS2JRNXVS?=
	=?utf-8?B?VEwvcWd6MHBPekxmWjVtWk9RcW1BeEJiSDNqVCtYdWlMQWNCQ1p2Z2lSblUy?=
	=?utf-8?B?S0VKTGxZSGU5VlltdkZKa2dtRGlJSmROTWtmNHhhRGhQNE55eXUraVVNYVdh?=
	=?utf-8?B?QkNWSlZGbXVYZGxLbWE1WXdiVmVtVTVSbFBsWVZZT0c5ZlVXQVNGejZ3dWNs?=
	=?utf-8?B?ZkpFMUhVWDhaM0FjSGZyb1ptbkU0enpuaTg2a2VLNVAybHRTYi8wajlyOUxp?=
	=?utf-8?B?NUN3c3pmQTdtdzNyR1haekJDa2s3d3JDZG51V0RKVSt5bis4UFJTOE1aQVYy?=
	=?utf-8?B?OXF0NWVhOFRMbXRWdHMvRkNmemkzSVJySEhqdll3bWdXRTE5U0F2Mk55NGRU?=
	=?utf-8?B?dHhocUNKeGllYVpGVzZZdW50MGxXbWl2S3ZzSnAwVGNnZlNrcmNjVVh3V1Z0?=
	=?utf-8?B?TS9GWHU1VU9rQ2gydnRyMHFuWUVBS1Q4VHplY1RkWmJHOUtKQnAzaHVvWm9k?=
	=?utf-8?B?V2Z4d3lheEFUclVkRHljUjZ3cnBzOUlkajJCbDRrb1p6bVhHQ3gyZDJhZHQv?=
	=?utf-8?B?RVdUV3ZaSGd2dlJTaTd4RGRSdHRzZTY3cElTQkw0NGdBazlFTmJSOXR5anlS?=
	=?utf-8?B?dzJvUmVNVCtuYUdFOHlhUUx2RnpzT1JaaFFjeloxN1llZXVNNkRMVXlLd3Ni?=
	=?utf-8?B?aTFDY0lYNTZTVEtLbCtWay9DTnp6R1gxMUh2bkNrUzJUZHJSb0k0WXk1eWgx?=
	=?utf-8?B?d1NrL0dxWVB2YzR4dDFHd1BIcG5pSVdGS3hIcDVmOE1odC81K25lSWVISmFh?=
	=?utf-8?B?aE1rY2d4YmpzeloyaW9HOW1RMzI3YkxjODY1cWl3VkJLaEM5WXJlU2lhaEVP?=
	=?utf-8?B?QytCTHJkQi9OS1NGNW9jZ3k3M2ZqWEd4UlVKWm5qUUF5U0pYYmJPeEF4Umpx?=
	=?utf-8?B?MDVwbEZjOVdSMUwzTXpJOXgwSlFjYm9BdnRlQ29mTU5xK05kaU9LWHlqK2Fq?=
	=?utf-8?B?V3MzbmJvanF4d3plb1V5d20wV3JJZTRUUGx2VklrTXVmZUREaE9valFHckJK?=
	=?utf-8?B?V1dRM3JVT2xDYmtaeGhRb1BqVjhZSjZXeEVXMHdmRmYvSUNPYmFpMUQxSlh4?=
	=?utf-8?B?NEJyZ25xYlg4NmcrN0pIWUlWSzluTEw2NDdFYXlCakt0Vy9QcXdXTVVOVkRY?=
	=?utf-8?B?QlpjVGZJMEk5cFJpMFp4Z1EzVlNncTdPRTBacEpUR0dwUStqc2NjYVNGRzV3?=
	=?utf-8?B?clhTa1ZBNHNrbnU0YUU4ZVFRZWtJZ0szalJ6K1Y3aHdGK2syUEE4bkF0SFVs?=
	=?utf-8?B?aGhhT0kwRjRGb2JwSFZrL3A2RVVqS0taR1JQYnpTZXhUeUtHWmFlTExHdE52?=
	=?utf-8?B?SzV3YU9SRzNHQVhieFlqeEtYWEIySkJPSGpwbUpDdDFBTlprMkg2ZzNVQTBj?=
	=?utf-8?B?Yk5rUEdsZ1F4SFp1QWFwWUpwQ3hsMkFDeTNra0RJODFkQVpBV3VQUXppUnl0?=
	=?utf-8?B?WXloa3ZpWTR1dHpOaVNOZ2hqMUNLcHpyTkFNRU1teDlzRm9RM0ZFY3pXWVFH?=
	=?utf-8?B?d0NNUlJwZU1nYU04azEzV1I4NHo4RTh4UXl5aDJCMlRtcVB0bU8wN2VHbnFL?=
	=?utf-8?B?WkV3MGc3SzVIREIxNFAwbEoyNmt2WnlwVDJ1VktRSlU2ZzZ0MEZXZTB5WS9Q?=
	=?utf-8?B?b0R1U0NWTDhTdWFINy9EQzZuT1Jva00xUVpoRW9uWE9GWWl0M2RoUzEvb0Nu?=
	=?utf-8?Q?OLIcVbMokdl8CcuAmk=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4418.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9e0640-0866-4d39-b490-08d994bff5dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 18:24:03.3102 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110210092
X-Proofpoint-ORIG-GUID: m-TZsuuz-qwO8FeJQbsDnSvC5OSiLnw-
X-Proofpoint-GUID: m-TZsuuz-qwO8FeJQbsDnSvC5OSiLnw-
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19LIOSo1017144
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
Subject: Re: [dm-devel] [PATCH 3/6] pmem: pmem_dax_direct_access() to honor
 the DAXDEV_F_RECOVERY flag
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
Content-ID: <3AC7C9ED1EA8C443B466CAD299DA151B@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 4:23 AM, Christoph Hellwig wrote:
> On Wed, Oct 20, 2021 at 06:10:56PM -0600, Jane Chu wrote:
>> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -					PFN_PHYS(nr_pages))))
>> +	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
>> +		is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> +				PFN_PHYS(nr_pages))))
> 
> The indentation here is pretty messed up. Something like this would
> be move normal:
> 
> 	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
> 			is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> 				    PFN_PHYS(nr_pages)))) {
> 

Will do.

> but if we don't really need the unlikely we could do an actually
> readable variant:
> 
> 	if (!(flags & DAXDEV_F_RECOVERY) &&
> 	    is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)))
> 

'unlikely' is needed because 'RWF_RECOVERY_DATA' flag is not
recommended for normal preadv2/pwritev2 usage, it's recommended
only if user is aware of or suspect poison in the range.

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

