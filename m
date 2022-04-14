Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B83EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:55:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-qRYLfpjqPKGuXN7Qd7stTA-1; Wed, 13 Apr 2022 20:55:28 -0400
X-MC-Unique: qRYLfpjqPKGuXN7Qd7stTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D73C43C1852A;
	Thu, 14 Apr 2022 00:55:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83F741457F42;
	Thu, 14 Apr 2022 00:55:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 21BFA1940347;
	Thu, 14 Apr 2022 00:55:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 392771940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:55:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29D55416162; Thu, 14 Apr 2022 00:55:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24BA741373D
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:55:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 079F51C05ECF
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:55:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-HVhUseYjO6KRZMxYLClMTw-1; Wed, 13 Apr 2022 20:55:18 -0400
X-MC-Unique: HVhUseYjO6KRZMxYLClMTw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DNXx0A018439; 
 Thu, 14 Apr 2022 00:55:06 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1khrr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:55:05 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0lhNN034687; Thu, 14 Apr 2022 00:55:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fb0k4a4kr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:55:04 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SA2PR10MB4745.namprd10.prod.outlook.com (2603:10b6:806:11b::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 00:55:02 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 00:55:02 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
Thread-Index: AQHYSSYgcxRlD0CAw0GRmRS3uRkg1KzruLCAgALpjYA=
Date: Thu, 14 Apr 2022 00:55:02 +0000
Message-ID: <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-6-jane.chu@oracle.com>
 <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com>
In-Reply-To: <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c3c1eea-5fa4-49fc-54fe-08da1db16876
x-ms-traffictypediagnostic: SA2PR10MB4745:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4745077EA78267C406D54F52F3EF9@SA2PR10MB4745.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iNYCy0u1U8A7KIWKllVN0y8x+jNqQS/8aytQra3oGbBo22IysANz7uBUj4GO4hEuZoIH+yY6eH3rNvm8SIEjJ+pfS4SDRAPsRXl/uFNFhIxquu85F3OjjftHH0q2gkxRV5mtss+Do/OUnb77DA/LutyPY3bECNVmJTbi2wfLDM3Veiww2SKeLfD5l1cVbHOSRZ4B8I7hl65OoCM91hDR+ntU4n5HnjD2O/yJnKHF1KFiQMOubr6pub/RXNs6bcFdD47u6yhfaUzTNoi62f1pSXPynJnOhaEAiPxiYjBvYCGYMUwo3FPewyDsfERWmzlRwoP+FuCK8W1bFSP7+kma1D2DXJqVZWJdsgvTtc0MYlT92n/CCsWIR3/UjsAL6UGZEINv1EmS8AOj2DKS4nq4k6nS5a1sAHwW7EwFDCSelFGIITyk8y2MUWxOyqd42dueXgpR6LCjyjGqmUwn5e0vD5us7kiGTrlgXqb9xe29gp8qdnz5uidgVdQdl2KKgXjupPuXF3k2drMPl2l1y7Wej/6Vo3QA4GJl4p3wEDSAWPddhD8cPAz0Q/HdEI/UvLY0H8rqfAxXz9QRy/g9RGR0+bhMHNgarUf5QhbMXRGVFbAuJqQwaQ6V+hotFR9/akzS2XCVMX8QP3hojM1PUEMyza8YwJOksImeVVrF0+KesvLS6SR7OypFxp+rUyGInKg9v3XimeIN+ujApo2zb/m2OLy1BmAZZCIwZWc0Tgk/ThbMQFKLHf/NJUVxs9kFalqdavDx28TBmIHjTSkhJqXepg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(71200400001)(6506007)(8676002)(66556008)(64756008)(66446008)(66476007)(4326008)(38100700002)(122000001)(6512007)(31686004)(83380400001)(186003)(26005)(2616005)(36756003)(54906003)(316002)(6916009)(2906002)(76116006)(66946007)(53546011)(31696002)(44832011)(6486002)(38070700005)(508600001)(7416002)(5660300002)(86362001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVlZeU03eXZDOG5IU3dCTExQeFplcGxieWtacXZLUnFVREJJRWlMZUdTVnM1?=
 =?utf-8?B?cXVHNks4ZmhHWXQwc3FTVDgySk11NG81eDExc3lMK3FnTzI2SWk5TGJpS01S?=
 =?utf-8?B?V2pDSXVSVitRbU5LR3g0SVY2OTV5QVdTWTFnMFVLTmhHTm5xbkp3Y1pkamVH?=
 =?utf-8?B?V0NxMWc3bkRmSkNadnQvUjRjbDZGNm1od0lUd0ZvYVVnKzFXeWRXb2Z1ZTAw?=
 =?utf-8?B?WGZZQ1RqM3lxSG5BQUtLSUFNQUFFUUpsMVoyRVFCY2R0L0c3dTdZRkg3ekhU?=
 =?utf-8?B?NXJ6RHN4TExabHFjd2RHdEZPaTl4Vm9ucFNRZDI0VDA2VUwxNmNQSHZZcmdu?=
 =?utf-8?B?eGVTNHFNcW85WTJwZ0I0OGZYL0QxVTRhZEplOUVidW1qNDlyWk5LL2MyOGdU?=
 =?utf-8?B?Q01CNWxCbVN0TTZ0b3A4Wk03VHJCbXVoc2YyS0VTRVoxU2FFVUxyUFRGOXVv?=
 =?utf-8?B?MkJDcHBjNU1uZnpxTkU3emQwVGlBYnMzZzNDTmZzQXhoaW1XVWpmZm9HUndS?=
 =?utf-8?B?S1hlNXVYczlvUXBUNDRzWitybFhZdVQvMzhRWHpPYzdSaVR5cEVlUS85OC93?=
 =?utf-8?B?S2xGUjVYZmJYeE5ieEVzYnZPZmRHQlNiN210Qk5vUi9EZkN6ZzBSck1iSHNr?=
 =?utf-8?B?Wjl6RmJxQ2czemhoeTVyWTJpcmJjTEp3dDZoNzAvSDZiMEVqQndLaW1IRmo3?=
 =?utf-8?B?RE5udE9YSDdZelBwNi9lTU5nSW1OcjhKRWRLQmVXVmx2dUc1dnkzL0JVdGNs?=
 =?utf-8?B?cHhuN3lVSmVxL3BObTlOQjV5d3lwOHNLaGZJOCtaV3Q1M3RJcVQ2anJUYndj?=
 =?utf-8?B?R3pXbWJCWFFib1F1Mm50c0NYUnFoVUVqTW1iSWZaVjFiNnIrTnhmd3l3ZnYz?=
 =?utf-8?B?cWdBY0F0RUVmU0lvOEhseTFmY1BpSkxWUlJnaCtHVFVVbUdBUlFRZURjQUR3?=
 =?utf-8?B?eXc1eDA5MGZhRlFodC9WdzdGSGZ3M25hTU94L0wxVlBpVHhWTzNzaWxodHFy?=
 =?utf-8?B?aWEvMHFreFduMko4NjNNZExsRFpZMzdzbFlkalk3YmdiclhMcGVvVGxydVN2?=
 =?utf-8?B?Yy9EUlRQRzdpdUJiK2NwMFkyRW1OMjZ4cHFOTTB4bmpNYUFZb1dLb205OC9s?=
 =?utf-8?B?RnB4U1VseHVRTStFS1V5NVlDMXNkM0FLemp4TWRPQWd0dFY3cFVDZWdYOU9i?=
 =?utf-8?B?bUlmOFhJUklheCsvMnRodXU4dmg1VWxxTjRzRG1yVUZwTThYRGhDQ08yNUc0?=
 =?utf-8?B?d3dycmEzbE5pMks0U091Y3d2RC85NUZwSUV5ZnQwcXZ1UkVBVGp5QUh5RHdB?=
 =?utf-8?B?SnhHYVpCNVA3UGlta0QrWHhPclQ4WHVvd1FmUXEwRmJmS0J0c1FKL042eFp2?=
 =?utf-8?B?dkhmV3dkUGhsUjd1emx2dHpXUkpDbzVzOVpqeHluM1cxMUVkenUwWGw5VVFY?=
 =?utf-8?B?Z3ZtY28yY3hYNHQxRHJzMzIwTHBDT2tiZk9ZTHFWZTF1eEMweEc3YTlsWU9t?=
 =?utf-8?B?d2NoNnU1Q0cxMGVUdE1RNjlybUNRaG9iSDh6Y1NRWVlQZUl1L3oxc0JMQk5H?=
 =?utf-8?B?ZFRYYlNDa1o5UmpiZmpVU1o5QmRUd1lldUJDclRGV0JDVDZmcTZ5K2ZNd2NK?=
 =?utf-8?B?WCtkeWRkSi83dXdBTXVVRkYyMlk5Y281cGE0K1VDOFR2ZWloL3VtdkxuT0lu?=
 =?utf-8?B?S0k4Y2tScGUzcEVUMG9SV2xhSmhreHV6Wis4SGlhUVAwbm1rUXdLaTcvNHpL?=
 =?utf-8?B?TWtsNGkySXYveW16QXVrQVJCb1hKT2ZsMUNSZkRIWUh4NlFZNDM2V00xRlBt?=
 =?utf-8?B?R2E3Vzk2WGRoWld5SWNTVkU0SnRCWWZnamkyOWRiNHFvNURCUGZRNnlLcFhM?=
 =?utf-8?B?UnBKRWFRY1lRY1NWOGEyL1R0djExNHA4dWR4dlZ2S0xibzQzSC9yRU1IcnBC?=
 =?utf-8?B?eW9ieloyMVlYdHA3U25aamtQeDgrcSs3NVo2aXdlVVMzTWwrMml2a01jTGhu?=
 =?utf-8?B?N29QM2dkWktrcHRKendJN09WS3NJSGdTelNKY1JqUnY5R2xRNTllTFd5MUFi?=
 =?utf-8?B?Mkg4UnlnR1NjdndiRVhEbTJkL0QrM3NhZ0N0akFLTm56OUx5M3JaZCs3NjdM?=
 =?utf-8?B?dlVlTGttN2xiZkxkcGRFVGZiT1BZSENSQWFyRTBJQ0FVOE43cDlpZnlkNkp3?=
 =?utf-8?B?OExNY2l3UU1BL1ZkRUlHUGFvL3lSWURGbncrN0lUU01IeG0zYk51T1RtUTh5?=
 =?utf-8?B?RmNCSmdHbG1jQ2ovbERmVHVIZ3haNVhSQ2s3anNEYm1tcnNVajgxZlluQTFp?=
 =?utf-8?B?aktVUnE4WS9rK3lQbjU1TEd2MDltdWlnUEZEOWxLclFhd3dVd3dyUT09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3c1eea-5fa4-49fc-54fe-08da1db16876
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 00:55:02.4255 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hycrgXFm8Uo9EO2sCEm2vE79TzCfn5rOloqCnoc0CXjLSHfEarpd8aRxBhVAoyjPBPoqdyf4d/C3v1hl9ZKz0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4745
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140002
X-Proofpoint-GUID: Ksf6kpwWm0jUPN3K0MkQUaufLE0gCHbb
X-Proofpoint-ORIG-GUID: Ksf6kpwWm0jUPN3K0MkQUaufLE0gCHbb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <48DD840341EF774CB66666613ABDCCBD@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/2022 9:26 PM, Dan Williams wrote:
> On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Refactor the pmem_clear_poison() in order to share common code
>> later.
>>
> 
> I would just add a note here about why, i.e. to factor out the common
> shared code between the typical write path and the recovery write
> path.

Okay.

> 
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
>>   1 file changed, 52 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 0400c5a7ba39..56596be70400 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
>>          return to_nd_region(to_dev(pmem)->parent);
>>   }
>>
>> -static void hwpoison_clear(struct pmem_device *pmem,
>> -               phys_addr_t phys, unsigned int len)
>> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>>   {
>> +       return (pmem->phys_addr + offset);
> 
> Christoph already mentioned dropping the unnecessary parenthesis.
> 
>> +}
>> +
>> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
>> +{
>> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
>> +}
>> +
>> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
>> +{
>> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
>> +}
>> +
>> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
>> +               unsigned int len)
> 
> Perhaps now is a good time to rename this to something else like
> pmem_clear_mce_nospec()? Just to make it more distinct from
> pmem_clear_poison(). While "hwpoison" is the page flag name
> pmem_clear_poison() is the function that's actually clearing the
> poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
> toggling the page back into service.

I get your point. How about calling the function explicitly
pmem_mkpage_present()? or pmem_page_present_on()? or 
pmem_set_page_present()?  because setting a poisoned present requires 
both clearing the HWpoison bit & clear mce_nospec.

> 
>> +{
>> +       phys_addr_t phys = to_phys(pmem, offset);
>>          unsigned long pfn_start, pfn_end, pfn;
>> +       unsigned int blks = len >> SECTOR_SHIFT;
>>
>>          /* only pmem in the linear map supports HWPoison */
>>          if (is_vmalloc_addr(pmem->virt_addr))
>> @@ -67,35 +84,44 @@ static void hwpoison_clear(struct pmem_device *pmem,
>>                  if (test_and_clear_pmem_poison(page))
>>                          clear_mce_nospec(pfn);
>>          }
>> +
>> +       dev_dbg(to_dev(pmem), "%#llx clear %u sector%s\n",
>> +               (unsigned long long) to_sect(pmem, offset), blks,
>> +               blks > 1 ? "s" : "");
> 
> In anticipation of better tracing support and the fact that this is no
> longer called from pmem_clear_poison() let's drop it for now.

OKay.

> 
>>   }
>>
>> -static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>> +static void pmem_clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
>> +{
>> +       if (blks == 0)
>> +               return;
>> +       badblocks_clear(&pmem->bb, sector, blks);
>> +       if (pmem->bb_state)
>> +               sysfs_notify_dirent(pmem->bb_state);
>> +}
>> +
>> +static long __pmem_clear_poison(struct pmem_device *pmem,
>>                  phys_addr_t offset, unsigned int len)
>>   {
>> -       struct device *dev = to_dev(pmem);
>> -       sector_t sector;
>> -       long cleared;
>> -       blk_status_t rc = BLK_STS_OK;
>> -
>> -       sector = (offset - pmem->data_offset) / 512;
>> -
>> -       cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
>> -       if (cleared < len)
>> -               rc = BLK_STS_IOERR;
>> -       if (cleared > 0 && cleared / 512) {
>> -               hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
>> -               cleared /= 512;
>> -               dev_dbg(dev, "%#llx clear %ld sector%s\n",
>> -                               (unsigned long long) sector, cleared,
>> -                               cleared > 1 ? "s" : "");
>> -               badblocks_clear(&pmem->bb, sector, cleared);
>> -               if (pmem->bb_state)
>> -                       sysfs_notify_dirent(pmem->bb_state);
>> +       phys_addr_t phys = to_phys(pmem, offset);
>> +       long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
>> +
>> +       if (cleared > 0) {
>> +               pmem_clear_hwpoison(pmem, offset, cleared);
>> +               arch_invalidate_pmem(pmem->virt_addr + offset, len);
>>          }
>> +       return cleared;
>> +}
>>
>> -       arch_invalidate_pmem(pmem->virt_addr + offset, len);
>> +static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>> +               phys_addr_t offset, unsigned int len)
>> +{
>> +       long cleared = __pmem_clear_poison(pmem, offset, len);
>>
>> -       return rc;
>> +       if (cleared < 0)
>> +               return BLK_STS_IOERR;
>> +
>> +       pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
>> +       return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
> 
> I prefer "if / else" syntax instead of a ternary conditional.
> 

Got it.

>>   }
>>
>>   static void write_pmem(void *pmem_addr, struct page *page,
>> @@ -143,7 +169,7 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>>                          sector_t sector, unsigned int len)
>>   {
>>          blk_status_t rc;
>> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
>> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>>          void *pmem_addr = pmem->virt_addr + pmem_off;
>>
>>          if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
>> @@ -158,7 +184,7 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>>                          struct page *page, unsigned int page_off,
>>                          sector_t sector, unsigned int len)
>>   {
>> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
>> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>>          void *pmem_addr = pmem->virt_addr + pmem_off;
>>
>>          if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
> 
> With those small fixups you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

