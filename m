Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096C4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-loKQ-5IzM-2E5LAc05Yy5w-1; Wed, 13 Apr 2022 20:51:58 -0400
X-MC-Unique: loKQ-5IzM-2E5LAc05Yy5w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD383802803;
	Thu, 14 Apr 2022 00:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8F5541373D;
	Thu, 14 Apr 2022 00:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C8E01940347;
	Thu, 14 Apr 2022 00:51:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C7FE1940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:51:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A556111D3CB; Thu, 14 Apr 2022 00:51:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 248BC111D3C8
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:51:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E1D780005D
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:51:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-Z-Gbi2g7NSKeQjrdN-VZEA-1; Wed, 13 Apr 2022 20:51:44 -0400
X-MC-Unique: Z-Gbi2g7NSKeQjrdN-VZEA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E0Z1AP028126; 
 Thu, 14 Apr 2022 00:51:33 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb21a32db-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:51:31 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0kT0L000829; Thu, 14 Apr 2022 00:51:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fck14g4nn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:51:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3462.namprd10.prod.outlook.com (2603:10b6:a03:121::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 00:51:28 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 00:51:28 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYSSYdGKTdETDbkEmdZR/SZY7Ic6zrwVsAgAABT4CAAt6UgA==
Date: Thu, 14 Apr 2022 00:51:28 +0000
Message-ID: <90b46d82-f4ed-db07-b3a4-31cf806f1d96@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
 <YlUH2f66hMyXOP1r@infradead.org>
In-Reply-To: <YlUH2f66hMyXOP1r@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ea18c10-046b-45ea-166f-08da1db0e8a5
x-ms-traffictypediagnostic: BYAPR10MB3462:EE_
x-microsoft-antispam-prvs: <BYAPR10MB3462344FAF9B745523FEE64DF3EF9@BYAPR10MB3462.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lWiKhh5hfQaEodtLhxcIlgPPwz6UWgWWYG1VN5wHOaoaIiqrNkp0R8FS+SXS0xK2PoacdeQz/I3V8r+8+W17rF4KaGPopiCn9H32K6Z0Eyjikbav+qIiYrkpnJ9SZ+5vdtAME4k4vF7iWMji9JREC7zb1rLBPBIBuO7ZY7b5TfIAvD6vsA+Cz0yBOGiTvPVU4g7KzfFf2295dwOxkMt6bYwHaz69tVCDfX1fqzkgJaNVZgTVMTT4AG4vlugBgw2KZXCQx1c5RgCi3cqqETR/mB+36OggzonXNUK1DtuOLSVOIJm2phm3xayS1l2XvzOwwI6927DXoaHkDVbx4mhZo7hDDqN3EbLHvWVVO5vr5NBTz958nFiH0eX2/iVHzDBROnO1C9lWWMa+42J7TC75aKAWkDB2Ix6jdFlEog4rU3sgAYAitj358ZuLB/D87Knh174+5fhixJCTAiSIsVa4mPrm3AcfpU2LrWtniphk4S3xNwurmETz+yIGRkR5/P2RAUAwKnm4dWxRuTqkGykr6Gh9bUGKLZCdIuEEWSNsKs7rVl6/RXspAUWOy5BLSQPpgc5+pXLqz+UvCZyMIqnzjyuArWd9nDA+QdsYhr1xd8ALVPmn1A/z6sOMihwE65soBiU3cbcGi0X61RUNRXJlBMxEeGJpgoacCpCLLo3yZTcZrfh0aqZf0ZbUwFUdov3C3xOCr+FU5s2+2XF9il8MJff3n6n/+xcvLY5oEztQx5yFXzWMofZKpNaTL2k4nVgXF/ezQG6afoVQQtaXYxD3XJFwmpjgbphtzBbvPL5YxW4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6512007)(316002)(91956017)(86362001)(2906002)(53546011)(31696002)(8676002)(64756008)(66446008)(66476007)(66556008)(71200400001)(36756003)(4326008)(66946007)(76116006)(31686004)(110136005)(54906003)(4744005)(7416002)(6506007)(38100700002)(6486002)(5660300002)(8936002)(508600001)(44832011)(2616005)(38070700005)(83380400001)(186003)(26005)(122000001)(142923001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXVuRG1tREN4SEhYazdCTXRrZGtrTk94OFpPT3RwUEFOQUZCQ0xZUDkzV3NT?=
 =?utf-8?B?WDdLTFQxU3g5c1ZURW0ya1N4WWNURHhhNExpZmZheXZpc0VmVWxNMkNOUFJO?=
 =?utf-8?B?YzlYcnFKT3hOTWpnck82Y1VRdGZvSzd3ZmpnVnhUTy9iKzJCS0lQdVZYSWJw?=
 =?utf-8?B?M0pDSm9QT01USExvUHhYZkszbXdIVXYvOXNneUNQUXVFSDdQQ3ZMMlhuNGpQ?=
 =?utf-8?B?VlQ0aG5uOGZBdXVsRzFqS3hQWWQ2RDg3eXBKZC91Q2JEVUh4UUlCMkhVdU8y?=
 =?utf-8?B?NUFKMUF6L2xvcjllSFJpM3Nyc2d6NVNCayszTFRVYjRUNW8zSlF2M0x2R05p?=
 =?utf-8?B?aEs1Z21uWUZJVjErWFE0dC91UTkxazFvZks2VzFPYjVaak0weVJTV0NnZ2RE?=
 =?utf-8?B?cEg5Tm5kUngzRHZIeFdZRkI0ZFNoRkEwWXUxTy9Cc2VBT3ZIZ25TcDhpTzZ4?=
 =?utf-8?B?Wno0c0RxejFVbDVFOXNBYStoWkpPVm1OeWxSNy9FYlh3bmw1NjdpMXUrS1dD?=
 =?utf-8?B?OTZqZ0p3dGozd1ZlS1R3enJIWkpZc0xEMkdSK0hvd096a3ljNUV4OXkvVlha?=
 =?utf-8?B?cmZ1NS9iSVdPVlNzVlluVmc4Ykg1NVVDZ3hXVVJBUFExaHdDVnBGQ0lHQzQy?=
 =?utf-8?B?enpKcmUxa3phY281NUJtNzVqb1hLOW9mVDdTUDZoN0xjSjl0UXN2YjI4c1ha?=
 =?utf-8?B?ays2UEsyRFMvamx3UG1acEQ2dlN6SFFxY2VVYmJ2ZWRVWU1Cb3I0NjZtSEsr?=
 =?utf-8?B?V0kyTEt4NFZSYWFrWVE3MFBRdVRVSTZZU1JLNXpjc21OTlozeTRWUHRtckJH?=
 =?utf-8?B?Y1dqMWVSdEZUeloyMmhqU0xwNm5tZTJtR0FSVnl6ZElKWTRYcmwvZWZPV2ZW?=
 =?utf-8?B?S3ZVYk93Z29uNnVYd2czbFJQUW42UTVvOHdjcmdlQm5TZmxrSlg2dFlxcG9y?=
 =?utf-8?B?Mnl5WjNGRllmbnRJSGFmMkhzREtqSWFNNE1VbUFPTm0wRloxVlQ2WERSSW9I?=
 =?utf-8?B?R0tjanh4d3FoazFzSW1QeEU2alQweHZOZVNJdE5uYU5rTEh3eWZPRCtzSnI0?=
 =?utf-8?B?Z1ZHbzNGYmc1WnVVNS9lTG1WMFZLVWV0anFzZkZndFhYVS9WbGdsK2I5SXdP?=
 =?utf-8?B?bE1TdExJRndKMU04N2dxQlVCOWNNYVFKRWdoSHF5d2pybzVmb212c1lUSnV5?=
 =?utf-8?B?MUJQZGZsYk9VcXFVb2NJa0hUVThRSWJUVHZWUWVMRVpmaDgrU2lNRFlvcG9J?=
 =?utf-8?B?M3creWJEeWd3cVVIWi9HUisvYk9ZU2lZSmZuZUZlNEJLSDlDaFdEYVE4TGFG?=
 =?utf-8?B?Ni9aVS9qMVlSQXZrOUs5RFJJd2RUaDhmM3FKRkZlMzJkaytNK2dQcWlnRnVZ?=
 =?utf-8?B?WlVrY1N1b0VadENRY01CTXFvU3M3WkNvT3kyTVdMQWlrbHArMEZUamo5WlRG?=
 =?utf-8?B?LzlHQlRqNEpnMzNWblFPRG9oak5La1p5bFppanV3U05lWEllQ1NDS0p5ZHFt?=
 =?utf-8?B?OGxmMzNEUlVKK3l6cGFzUTNISEFRVFlBeU5JdVNYNkF3d2dBeDBkYU84d2tK?=
 =?utf-8?B?ZW5STXh4QzEzaiszNFBsNlRCaFBGYnRaaFFQeGQxS21BSW96VTNRdldWblRX?=
 =?utf-8?B?aC81WmJRbW1YdWVpODlQTkpQWEVFeUlaaWFVTkxtODM1bWhZSWRRSjFDZkk2?=
 =?utf-8?B?dXVvN2Zzb1JsTVEzdmh2dGdybnRtRzByb2xQMXliZ05oYnltdGYveXhLNlZw?=
 =?utf-8?B?ZithTkdiMlg1dnFQZUhHOHRNMnF3YktxeG9ac01Qd3Rza1M3NXFEcG0vcHhu?=
 =?utf-8?B?Ylg0b1RQT1lvby8zSkJQQmZnWmJlbUZ1ajhxRS9SQ0ZucUc2Nmdlc2JwQVRs?=
 =?utf-8?B?U2JjUUt4Um5lWVJtV2hoeGhtSU9GcDdQWWFGSnZMY2R5M3hBaG9XUllxL0xO?=
 =?utf-8?B?TkxTamcreVF0eUhxZThUdGNsbkhqZ3dtR3lreE1qaW5ta0Y3TlV1K3dsYkc4?=
 =?utf-8?B?eDFoTHRmbWJjWnNWWXJhbnNSSms5T2hGQllTbUFXRlArdGVNOUgzNjhxR2Rq?=
 =?utf-8?B?M0U5UkZQNjZ3c2IrSlkrV0Q2Sys3d2JzSkFBaEZtRjZUbVNDU0h3aklOczYz?=
 =?utf-8?B?Y0wxRm00Q3JmOElYMmFYSEl2Skt1TzY5NHppY0llUG8rY1NQdnFIdTdtTHA2?=
 =?utf-8?B?andldVFnc1FCZUVYbmY5cWpLSVRvYmJJOE1ZUmFaQ3ptdlhKODV0MDZ6Tmhu?=
 =?utf-8?B?bC9FSENNMXhOUmJEN1p4R1p6MGY5bWtadlNxNGdxR2xrSm9EMlFoZWlyOUdv?=
 =?utf-8?B?elhYa2ZTTEVBZFJpVGxyWGc3ZXNxNE43cm02T3BTZi9yejZzN3JEZz09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea18c10-046b-45ea-166f-08da1db0e8a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 00:51:28.0304 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GrzvxFL3qdJuYVY1Tbzawb4ns+aneAq5+k+g3d7NdmVwVoWnHLVbPyzGzuhXVZe2p1td+LoeC2CNzxi9l47ZNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3462
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=925
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140002
X-Proofpoint-GUID: 03dIehigQ3jHLPR5LBQe5bqLni8_DHGm
X-Proofpoint-ORIG-GUID: 03dIehigQ3jHLPR5LBQe5bqLni8_DHGm
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v7 4/6] dax: add DAX_RECOVERY flag and
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3293CCBB6E862142901E5645F816756E@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/2022 10:02 PM, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 09:57:36PM -0700, Dan Williams wrote:
>> So how about change 'int flags' to 'enum dax_access_mode mode' where
>> dax_access_mode is:
>>
>> /**
>>   * enum dax_access_mode - operational mode for dax_direct_access()
>>   * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
>>   * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
>> for use with dax_recovery_write()
>>   */
>> enum dax_access_mode {
>>      DAX_ACCESS,
>>      DAX_RECOVERY_WRITE,
>> };
>>
>> Then the conversions look like this:
>>
>>   -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>>   +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
>> DAX_ACCESS, &kaddr, NULL);
>>
>> ...and there's less chance of confusion with the @nr_pages argument.
> 
> Yes, this might be a little nicer.

Will do.

Thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

