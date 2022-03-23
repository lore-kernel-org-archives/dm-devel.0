Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B55C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 18:43:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-Myt4J1wLM4K6MzOyRGR2eQ-1; Wed, 23 Mar 2022 14:43:52 -0400
X-MC-Unique: Myt4J1wLM4K6MzOyRGR2eQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A65F185A7BA;
	Wed, 23 Mar 2022 18:43:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEA84140262B;
	Wed, 23 Mar 2022 18:43:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BFF71940347;
	Wed, 23 Mar 2022 18:43:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 75AD11949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 18:43:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 343FB2166B4C; Wed, 23 Mar 2022 18:43:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E0A2166B4F
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 18:43:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82A7F85A5A8
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 18:43:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-_H6bNwEgNi6W16NLV5mvTw-1; Wed, 23 Mar 2022 14:43:33 -0400
X-MC-Unique: _H6bNwEgNi6W16NLV5mvTw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NHr6uR004114; 
 Wed, 23 Mar 2022 18:43:10 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y22f98-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 23 Mar 2022 18:43:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
 by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NIf7R5183175;
 Wed, 23 Mar 2022 18:43:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by aserp3020.oracle.com with ESMTP id 3ew701pw79-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 23 Mar 2022 18:43:09 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM5PR10MB1481.namprd10.prod.outlook.com (2603:10b6:3:9::19) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.18; Wed, 23 Mar 2022 18:43:07 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 18:43:06 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYO1qr0XYuk2dPyEaDqgStF1AJhKzLIC0AgADrq4CAAG/9AIAA2SAA
Date: Wed, 23 Mar 2022 18:43:06 +0000
Message-ID: <2897ca93-690b-72ed-751d-d0b457d3fbec@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
 <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
 <Yjq0FspfsLrN/mrx@infradead.org>
In-Reply-To: <Yjq0FspfsLrN/mrx@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36aa46f6-0b6a-4e2a-7fca-08da0cfcf8a8
x-ms-traffictypediagnostic: DM5PR10MB1481:EE_
x-microsoft-antispam-prvs: <DM5PR10MB148194C88B87C00180A081F0F3189@DM5PR10MB1481.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: umPTFNbuJbnAF6x6VwU92Glutd9+hBRfwsapvHjCilYkk8cBrD8EV82YTyxsLmx9gZXV69UAUQWPicuB9mDB2NP3vvDouk2kr6kC5OMnfsgvdQ5KSZw8+aAaKIBCiKMVdwtyk4EU04dXlhb/+owELjA54W9i1ckcZ73WES7RkS995aYSTrMF0OPEXnx03+1ZzSpPWCUT5TP/ZGoD+AWifd9ZRVGvgTJKJkc4G9JMFJGjzJWEisar+oUvUx1PY3pDaSuucIthrqsdPs+9v3VP8e+RbasJ8/TY6ahfjI0A383H8Do30M9K3ERt8Od4eJnMwvc/vEga2oP4LBaCKxg8QZXMCIFaQ6to2Sx6YURB6njTZsTgn51LEuqrIzvJPMovDhrrZwd44kTnHHLJZA1SBKRfjyGWS98oWWNB9FuJq1GFOHySPITAQfTMzME1IWgT1WSDt95vxCuWpCds0eSdT52+lGqhKwlC5164p+6i+QkEXTHpDWtdFQVXmWFD4DqvNkJUVdtKuybD+LSC1CIUJ2hVpWIcJoRd/0ubFlJSuOMEb/+/yT/AVL2JNzav/EZlT4uCgMlDGD+Zn43cipjUXa6iha1l3QU4FZfVjsFfHMMgZtf1Body23Qp188wx0ML0PaP8VlLH3JOSmv9frBMBopd7T3rtMNEznwsltj+MYKAEBE/deAfkKxuOiOisgaymQyIhoBG57YE6izVXwi26bG5k69nhgXi0KRtBR+jS8olmYY9/OuFybU4blXiQMRzTUyXd/bd8WRNAOiY03R3dveKsSO+hul+qLJTBxdl2tYvJ2O9820D3iJ5PglQgKHNk5nxgsPqq9jei7yMW+nKm3DJWZmjWVj5hPdS26/qtaRYEg+RHOAwJuKPrQ2pOm1H
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(4326008)(8676002)(66476007)(66556008)(66946007)(86362001)(76116006)(66446008)(64756008)(36756003)(2616005)(508600001)(71200400001)(5660300002)(966005)(6486002)(6916009)(53546011)(316002)(31686004)(6512007)(6506007)(54906003)(186003)(26005)(83380400001)(8936002)(31696002)(7416002)(44832011)(2906002)(38070700005)(122000001)(38100700002)(142923001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0wveG1PS3A0MnBESFJUTEpkWUwvWlZqU1ZPZ0RraHUwdmloc3FESjlMQkZW?=
 =?utf-8?B?NXpUTEt1MWxFVy9icTFmb1A4OXBUb2c0UEZSbjJPdmlBZHZDUUhuaVJsRHpN?=
 =?utf-8?B?TWtvVUFaMldLS3VrTGQrZE5lMG1OQ0NYaVZFRkNHOEF3NENoRlZiaEltVm5a?=
 =?utf-8?B?djU5RUMyd1RhZUpmaGVEQjFDVkJXNnlxY0UxSVAwWmJyc2wyOEZDMHAwQ0h0?=
 =?utf-8?B?SnlCMkNkQnRCaHY0L1Z4em8yZWQvNXpUYmlsOTdsNERlNVFyeVkveDF6enJz?=
 =?utf-8?B?UUIrS1FhV2pBQmY2b09lWmlpdzdJVzV3OXJuTEVrdHRUZUZla3FwODVGOXgv?=
 =?utf-8?B?aHgrdXU1M0hNamNKd2loYmxibkU2dVlvM0Uyb1RuQTB6VzFWMnpyVHpZUGlW?=
 =?utf-8?B?cnIvekNNbkNIZUMxNk8yWEd0RitLZXI0aGFUMjFUVGoxcHNucm5kZWVCVE1k?=
 =?utf-8?B?ODlnMnFuaDlJeGNaa0swaWJMRkVUNFlZczVLZEpCUjF1cmI1d0xTb2NtSUpy?=
 =?utf-8?B?RXhsbjhDOUViZmFJejJXT1NTcExFbWgzdDBKYzFHTFltMTNOekg2YkxoL1dT?=
 =?utf-8?B?eFdJWjN1ZnZYcWVnOE9CamNoWkNENzBEWmR5L2N4YkFuWnpRaXQ4M0ZRUG1X?=
 =?utf-8?B?Y05xQ3k1UmdLa3A1R3hqRTB0di9kSlN0c3dEMmM4aWh2SUpaZUhIMWkvbFNt?=
 =?utf-8?B?MFRFN1VWYWJIblpxODVEODJ4Vk1ucTBNclZLNWUxWDRnTjVHQ1A1cFdXV3NG?=
 =?utf-8?B?em9lNERwK0dvN0hjM0FlSXRsM2lSODE5TFFubjhWZ2NYMis0NWVCYi8vRXZK?=
 =?utf-8?B?bU9qV21JM0xISGhQWENJSi92ZGRZUERrNGpPY2NoeU1OdGhjVERPakVTUDJL?=
 =?utf-8?B?TElxN0RmV2RmbmZqcHVxa045U3F1ZFdqa2FYTndKTmJ5aHpaTThrb2hlVVdy?=
 =?utf-8?B?WTU3N1psbEVFWTRaeTJrUm03bmlOZDJaL01YTU13cWpOVU0yNVg2bVRhRUsz?=
 =?utf-8?B?THVZVWRoVndsMmhSdUdwVEpWRHB6SzJNN2FnbS8wTllGelQxODZFTnBqQkJL?=
 =?utf-8?B?LzVQRDlXSW9FeStFeWtjSmFpUjJuWmdERytqcVZEeWNVVXZTcFNEWDRtTUdi?=
 =?utf-8?B?SU1LZ3dlbnFkdDJINFVIUzlaZlRCZnFHRzN6QVU3TFV2Yjh5cDg3eGgyck44?=
 =?utf-8?B?SFBvTkJ3RFAvUUNtMlpTU3k0OWQ3KzNQemRQU3NvejFsSFhEbWJnMDczeEpv?=
 =?utf-8?B?RTFOWmJ2VVM4QTZWU1d4QVRxTzRFVElkM0twdFpHbmVSejlHNm5FTllQd1Nw?=
 =?utf-8?B?eFNBUmhtN1NLNnEvSW9kaElkZURlWWxRZjhBU0d4VFV1cUo3blA0Nmt1WUdR?=
 =?utf-8?B?Q0VLMEEzcTkreDg5eXV5UFZDa1FsUjlERmRsUXNJMWJYYlg0bEwwMzkxcHZJ?=
 =?utf-8?B?RnY4QXl1d1JjVXJaYXc4SHI3NWNmU0VnblcvQ0c0WlE3aDVkOVMvWFZxb0tk?=
 =?utf-8?B?T21WY0crY1hqMEFNUWRSNGdBczNCdnhMSG9MNm5uVjVWMkFwQ1VvRkVLQ2F1?=
 =?utf-8?B?VytBb3JQNXlGblRiaGphTkYwczZ0dWNxSUIyWkcrb0Rtb1lQZUM3bEljczlr?=
 =?utf-8?B?VEMyUlF5eFhoTmFaaXU3ZysrWEI3WUhPZWdaV1AxWE15ZFZtMC96YXJBUUJK?=
 =?utf-8?B?UGRrNWRVSFVaREJYWTRtTnpiYklQcStKQWU1cGZyNlV2dzhIajQwc2EraGI3?=
 =?utf-8?B?WFEwMC9FRzZlRkpSSmJvNDdWTnpMQ3g4elQza1Foa3hmaVI2M1lkTXVneitL?=
 =?utf-8?B?TmZzcGVUSHlQOFdEWFVJYmQvYkd3ZG9VclVRY0I5a29hTTZydFllbTlJZFpO?=
 =?utf-8?B?aGdRQmM1UkpXa1lUSUhqTFU4OGI4ODlEYk1yYVJwSXhwTHBvYVVvRDB0Q1ZF?=
 =?utf-8?Q?SL5iwCOhvt8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36aa46f6-0b6a-4e2a-7fca-08da0cfcf8a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 18:43:06.8337 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbV7RVNpjvzgtfeN5wjBsAcKsVRRWgtvT90qu9gVIW+/E3+LCU/MXCo3FJxw+xgiury301q7KLlRplEWYgfFDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1481
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295
 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=878 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230098
X-Proofpoint-GUID: hjjHGXr6HSA6N0p88bNGHy3fW6sykkEX
X-Proofpoint-ORIG-GUID: hjjHGXr6HSA6N0p88bNGHy3fW6sykkEX
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <73969C9FD7DAC94F8ED6B7FBD409F573@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 10:45 PM, Christoph Hellwig wrote:
> On Tue, Mar 22, 2022 at 11:05:09PM +0000, Jane Chu wrote:
>>> This DAX_RECOVERY doesn't actually seem to be used anywhere here or
>>> in the subsequent patches.  Did I miss something?
>>
>> dax_iomap_iter() uses the flag in the same patch,
>> +               if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
>> +                       flags |= DAX_RECOVERY;
>> +                       map_len = dax_direct_access(dax_dev, pgoff, nrpg,
>> +                                               flags, &kaddr, NULL);
> 
> Yes, it passes it on to dax_direct_access, and dax_direct_access passes
> it onto ->direct_access.  But nothing in this series actually checks
> for it as far as I can tell.

The flag is checked here, again, I'll spell out the flag rather than 
using it as a boolean.

  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, int flags, void **kaddr, pfn_t *pfn)
  {
  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;

-	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
+	if (!flags && unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
  					PFN_PHYS(nr_pages))))
  		return -EIO;

> 
>>>> Also introduce a new dev_pagemap_ops .recovery_write function.
>>>> The function is applicable to FSDAX device only. The device
>>>> page backend driver provides .recovery_write function if the
>>>> device has underlying mechanism to clear the uncorrectable
>>>> errors on the fly.
>>>
>>> Why is this not in struct dax_operations?
>>
>> Per Dan's comments to the v5 series, adding .recovery_write to
>> dax_operations causes a number of trivial dm targets changes.
>> Dan suggested that adding .recovery_write to pagemap_ops could
>> cut short the logistics of figuring out whether the driver backing
>> up a page is indeed capable of clearing poison. Please see
>> https://lkml.org/lkml/2022/2/4/31
> 
> But at least in this series there is  1:1 association between the
> pgmap and the dax_device so that scheme won't work.   It would
> have to lookup the pgmap based on the return physical address from
> dax_direct_access.  Which sounds more complicated than just adding
> the (annoying) boilerplate code to DM.
> 

Yes, good point!  Let me look into this.

>> include/linux/memremap.h doesn't know struct iov_iter which is defined
>> in include/linux/uio.h,  would you prefer to adding include/linux/uio.h
>> to include/linux/memremap.h ?
> 
> As it is not derefences just adding a
> 
> struct iov_iter;
> 
> line to memremap.h below the includes should be all that is needed.

Sure, will do.

Thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

