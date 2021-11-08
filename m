Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEE8C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:03:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC0BB61502
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC0BB61502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-kiYkPkbrPSGmv7LsvQpJqA-1; Mon, 08 Nov 2021 16:03:00 -0500
X-MC-Unique: kiYkPkbrPSGmv7LsvQpJqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CB7F804141;
	Mon,  8 Nov 2021 21:02:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D5965DF5D;
	Mon,  8 Nov 2021 21:02:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2163A180BAD2;
	Mon,  8 Nov 2021 21:02:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8L2srS027253 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 16:02:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8FBD4047279; Mon,  8 Nov 2021 21:02:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D38CD4047272
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:02:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B47F3106655A
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:02:54 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-15-Ud0wsdQ0PRK5ahxrqDVhQg-1; Mon, 08 Nov 2021 16:02:51 -0500
X-MC-Unique: Ud0wsdQ0PRK5ahxrqDVhQg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A8KwSH1031546; Mon, 8 Nov 2021 21:02:34 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6usne8jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 21:02:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8L0dWC133780;
	Mon, 8 Nov 2021 21:02:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by userp3020.oracle.com with ESMTP id 3c63frw3hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 21:02:32 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3335.namprd10.prod.outlook.com (2603:10b6:a03:15d::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16;
	Mon, 8 Nov 2021 21:02:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 21:02:29 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v2 1/2] dax: Introduce normal and recovery dax operation
	modes
Thread-Index: AQHX0qwD5+Ie66qqNUGG2WP/amHP1av2tvUAgANrlIA=
Date: Mon, 8 Nov 2021 21:02:29 +0000
Message-ID: <63f89475-7a1f-e79e-7785-ba996211615b@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
	<CAPcyv4jcgFxgoXFhWL9+BReY8vFtgjb_=Lfai-adFpdzc4-35Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jcgFxgoXFhWL9+BReY8vFtgjb_=Lfai-adFpdzc4-35Q@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be211d7c-7795-446a-9989-08d9a2fb1387
x-ms-traffictypediagnostic: BYAPR10MB3335:
x-microsoft-antispam-prvs: <BYAPR10MB3335F92E042F027BAF0F8B34F3919@BYAPR10MB3335.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nHPOoHYgKNxd9S2wYOnW0zE/E3bRbriOhZxvihR7Rzj/8TKbArdBYcYb4/GIu6Qbp384oPX8UxPxgdjt0rD6Jo3h8NAVfG8VHIxWzYGFJo5BowWeY5oayer+c2qUcCAun0IuCUPboE4Agw78Rv3O85+TidkMOyY7XgpEKwayIlVepJ+HX1COkcPNujM/daDYOsKXIiImTfUB8GSL5kAhMyoiH5MoyuvGQCdyCx5yiGr0ZKaAGWcltu79Zo2hn37JJ5YxMJSIcOr+QLJyTIMX9Jaf4qr1lbQTUEI676lnhNQ2pbeX9fvH7EUJn9w4f1zEP6hEB4/WdzoU3wyeQJqmxgRZ47ddLPWAeJk6RJDDAR+/JEA9CO78NKcKHJNvK98TJofqD0GYwlF77SjVHdt2C0hQ3IPndFuJ3lYdggTdH3eiPuGRDrc2OomgMFFUUPO5dZrW831pbGOGxpQSu2WsltiF2LQtapIut0BEgLHWcM8gvojTe7rDBLzk9iB4EZf+msxywyZoNYt7xbNyJb90W/o1rVjHdXEtoNPQuivmpGNaK9D/QS+U1LuRLTWmLdb1akrHDEGJ6rYGAY25fhwGCfjj4ZIlAWbACOmkFPMVohBo5MGsPz4C9uDVrpNlWD3r0Pzi+Gw1zzW4gqVOMlQa/v9uCB1263E2RfjChZcgfzEXV2TmyLodem3IPuSedbd4m+YpEcwFEM8nWYn1h++sMhA+QFFyAsta1tmHU/Y2AJuVM8Iapzl41N8DutpXgh3I3a5H0RzaCmxRc2tunA71ig==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(31686004)(91956017)(83380400001)(316002)(66476007)(122000001)(66556008)(66446008)(53546011)(38070700005)(64756008)(36756003)(86362001)(76116006)(54906003)(5660300002)(38100700002)(66946007)(8936002)(508600001)(6512007)(6506007)(71200400001)(2906002)(186003)(6486002)(2616005)(31696002)(7416002)(44832011)(6916009)(8676002)(4326008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGMrOHZkVHBrazJpWjlrQnFKT1hieDFMZVdYZjlkdmQ1ckNrMkpxZmFJWkhv?=
	=?utf-8?B?YllYa0hFckVybUVrUUw0L05FTjhscEhRb3MrZGVobUJTZ3dkR0JDRmVxSlkz?=
	=?utf-8?B?WmhzUEkwbHo4WFhaWUdWU1dCcnFrUFpzTlZHcmlPa0ZlME9TTHdYMDh1V2Yx?=
	=?utf-8?B?SVk0dm1vUzcrVVd0bWZyVEVpbEI1TG5nNnZkT0RQK093ZXczNkZvcDFUT1Vq?=
	=?utf-8?B?Y0h2blYxcmpSblo5YXNjWXBwZGw3dzF0SUMrdlgwTktQNVZtcnRWUmRWQ2dr?=
	=?utf-8?B?TDVJMjVSb1pIc3NOVnVUbDN5TndmUmMvQkpEWmJkdCtGZDZ5UTcyTWV6QURW?=
	=?utf-8?B?cEtDS1NDbzA2SWNMd0MxQU9HeTBVaSt4ZFNPZldySFRuaHU2SXhKZTlVQUgv?=
	=?utf-8?B?QnlYNm5SUTZOczJscVEzd3AwVjNaNDFDT2h6dXNIK3NMU3p6ZkJreUQ3VHJ2?=
	=?utf-8?B?dVhoejZvSGcvL2Y1ODA2d0lZZ0V0MlVpQnlnTG5sOHoxeDErL09PM3NWVHNy?=
	=?utf-8?B?b2ZSMk9vL3BUNFhSRXRHUThJK2s2SDk1dzlTMmM2RVpwaFZHOVU4NXQzWmtX?=
	=?utf-8?B?UnhVbXJhWE5yTlZONi9ubkd6cXAwQSt3VkJnQ2NQNFAxZmdFREJjMjQ2NG5D?=
	=?utf-8?B?ZnRWWHc4VW5ybnpMRFdTTU9VSUQxL2J2d0NLZXJ6ZnYvRmlJa1BVNTJpeHUy?=
	=?utf-8?B?MDdmOFRQQjVCelp0bDliMkNNMmJMY250dWRrc1VVaUJXT3ZxZkphTHVWYXpo?=
	=?utf-8?B?NHgrRmh5YmQ1d0h0V2ladjFCbnRybnk2N3owdnpnbWdkSlRsWWhoVGpTbnFm?=
	=?utf-8?B?c0dhMlB6V2FBV1l0THRSRmx6MjdvVjdQVjZoYW1BMEtPd2p2eUtIdVdPL3Vk?=
	=?utf-8?B?Yld3Uk9RUFRvdk5LUk5RbnY3Smd2MUxia2Z1VVVQS2VyUExiVCtBdjhUdThr?=
	=?utf-8?B?RlNqVTVESVkzTEZmT094OVlSV2xCVVpmdUJYSWtYSzdvM1RNSG1LNGE4K0p0?=
	=?utf-8?B?TnkyeUx6ZWtGa0tzNE5hMmNnQjY4aHhEaUtJMjNzM3N3STZBaCtjK3RpZ0Zw?=
	=?utf-8?B?Tm4vSDFIU0pvZHQ5eVJMdzJWVldJbXdEajdTQjNVTSsvdUZsWXJwNlF0RFFS?=
	=?utf-8?B?YUcrMTYwUDgxWnpEc1EvSW9XRHl2N095bG5ONDg0Tm1tNkF6MUZYcnNYQ3lq?=
	=?utf-8?B?N1FXQnppSTZYVm85UlVYaTF2bDBiSHVLd25tU21oV0RLdlNGUEVSM1FKYlFC?=
	=?utf-8?B?R2MvTUpTUUlGS1Y4NVA2S1BsbzlCSFpDRnF2QU5jR3NzVExTZ2lUeStCOXJV?=
	=?utf-8?B?ZGpuWlRSQUxTZkl2OXR0dHN6RHdkbXppY1doWE5KL0laKzdYL0NUa3ZBVkZk?=
	=?utf-8?B?UCtEYmxWRGV0cENTRG9TMUN1ZlE2WlpKbjZQVENpWllRbGVYaW9hS3lEVnd1?=
	=?utf-8?B?Q0hXS2NienVsQVZabjBxbldUeEJWU1pyKzVZQTgvQnpPSEpvUXJuSk1EbEFz?=
	=?utf-8?B?bVFaNVFmcmZ1WXc4ZHF2Q1NHUG1QM0kyYlhwUkVyc0tzRzErdE9RNFVFcnRw?=
	=?utf-8?B?eWowUTdKUEZ0RkhEUko0ZnZ3RnUrbitvM3pBcDVhUk1JL0VRV0pXdStSUlU4?=
	=?utf-8?B?L3JBbTlEeUJMWmVaVXdINU5la1hJME8yRURtZ2ZXeHRrMDVsQUNTdUVpY0Jp?=
	=?utf-8?B?NVJnejkxVUkyTG5GMCtSYktVWVUwT290WWM3Q2xJMWVuUTVmcUpEMDFLbUlq?=
	=?utf-8?B?RGJNNE5qMytxWCs2bE5MTHNpYnRvV2hpT0dvU3RSZ05BSGdjd1hEczAvUnpW?=
	=?utf-8?B?SVFyV2RvZ1hYOTBSNzlhcUQ5TDNoTGtBejRUYUwrN0lMN21NRy9EejF5TVZE?=
	=?utf-8?B?NTl4QjI5Mng2UUJVMWloY2ROYTM3c0NjMlByYU1RckR5NHB6cXJvMkI5ZlhX?=
	=?utf-8?B?L2w4eVNzQXdZSGVRSlNqeG0vcnF6WS90b0xFVXdoajROMmFpb1h6d1NKSnJy?=
	=?utf-8?B?TjAxeldsMGE4d256TTdiYVpBVEprNDZqL0FVa0x2UGRkTkprNHI4bFMwd0NW?=
	=?utf-8?B?TDFvMTNJZjhmWmgwMGVhdWpqak9SenBJS1U3cVBHSk1LUkNQNEdGS1B3NGsr?=
	=?utf-8?B?ZFo3MVFGbERpc2lDS201dEUySmp6VlpTdFBuUHA1UStOeUFrRU11SUllRG1S?=
	=?utf-8?Q?6TSVcPKuTHruS2/No1VtSq1lz2XluELnUF0kqYrm93Pt?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be211d7c-7795-446a-9989-08d9a2fb1387
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 21:02:29.6725 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHqYZte8HsmAX212q12TExnemHUEoh2FnVILcgXFtSKdv0OnpKqhDCirkgJ6/fQ2ayP8yhG96VjptZo/gHK54Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3335
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111080124
X-Proofpoint-ORIG-GUID: 7AJ5FWTfkqp49jGYuzKUx2k233Fkdrzy
X-Proofpoint-GUID: 7AJ5FWTfkqp49jGYuzKUx2k233Fkdrzy
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8L2srS027253
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>, device-mapper,
	Matthew Wilcox <willy@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Alasdair,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dax: Introduce normal and recovery
 dax operation modes
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
Content-ID: <3AF8D5C40A3AF6408C3AC88A3D3ECC1E@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/6/2021 9:48 AM, Dan Williams wrote:
> On Fri, Nov 5, 2021 at 6:17 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Introduce DAX_OP_NORMAL and DAX_OP_RECOVERY operation modes to
>> {dax_direct_access, dax_copy_from_iter, dax_copy_to_iter}.
>> DAX_OP_NORMAL is the default or the existing mode, and
>> DAX_OP_RECOVERY is a new mode for data recovery purpose.
>>
>> When dax-FS suspects dax media error might be encountered
>> on a read or write, it can enact the recovery mode read or write
>> by setting DAX_OP_RECOVERY in the aforementioned APIs. A read
>> in recovery mode attempts to fetch as much data as possible
>> until the first poisoned page is encountered. A write in recovery
>> mode attempts to clear poison(s) in a page-aligned range and
>> then write the user provided data over.
>>
>> DAX_OP_NORMAL should be used for all non-recovery code path.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> [..]
>> diff --git a/include/linux/dax.h b/include/linux/dax.h
>> index 324363b798ec..931586df2905 100644
>> --- a/include/linux/dax.h
>> +++ b/include/linux/dax.h
>> @@ -9,6 +9,10 @@
>>   /* Flag for synchronous flush */
>>   #define DAXDEV_F_SYNC (1UL << 0)
>>
>> +/* dax operation mode dynamically set by caller */
>> +#define        DAX_OP_NORMAL           0
> 
> Perhaps this should be called DAX_OP_FAILFAST?

Sure.

> 
>> +#define        DAX_OP_RECOVERY         1
>> +
>>   typedef unsigned long dax_entry_t;
>>
>>   struct dax_device;
>> @@ -22,8 +26,8 @@ struct dax_operations {
>>           * logical-page-offset into an absolute physical pfn. Return the
>>           * number of pages available for DAX at that pfn.
>>           */
>> -       long (*direct_access)(struct dax_device *, pgoff_t, long,
>> -                       void **, pfn_t *);
>> +       long (*direct_access)(struct dax_device *, pgoff_t, long, int,
> 
> Would be nice if that 'int' was an enum, but I'm not sure a new
> parameter is needed at all, see below...

Let's do your suggestion below. :)

> 
>> +                               void **, pfn_t *);
>>          /*
>>           * Validate whether this device is usable as an fsdax backing
>>           * device.
>> @@ -32,10 +36,10 @@ struct dax_operations {
>>                          sector_t, sector_t);
>>          /* copy_from_iter: required operation for fs-dax direct-i/o */
>>          size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
>> -                       struct iov_iter *);
>> +                       struct iov_iter *, int);
> 
> I'm not sure the flag is needed here as the "void *" could carry a
> flag in the pointer to indicate that is a recovery kaddr.

Agreed.

> 
>>          /* copy_to_iter: required operation for fs-dax direct-i/o */
>>          size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
>> -                       struct iov_iter *);
>> +                       struct iov_iter *, int);
> 
> Same comment here.
> 
>>          /* zero_page_range: required operation. Zero page range   */
>>          int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>>   };
>> @@ -186,11 +190,11 @@ static inline void dax_read_unlock(int id)
>>   bool dax_alive(struct dax_device *dax_dev);
>>   void *dax_get_private(struct dax_device *dax_dev);
>>   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>> -               void **kaddr, pfn_t *pfn);
>> +               int mode, void **kaddr, pfn_t *pfn);
> 
> How about dax_direct_access() calling convention stays the same, but
> the kaddr is optionally updated to carry a flag in the lower unused
> bits. So:
> 
> void **kaddr = NULL; /* caller only cares about the pfn */
> 
> void *failfast = NULL;
> void **kaddr = &failfast; /* caller wants -EIO not recovery */
> 
> void *recovery = (void *) DAX_OP_RECOVERY;
> void **kaddr = &recovery; /* caller wants to carefully access page(s)
> containing poison */
> 

Got it.

thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

