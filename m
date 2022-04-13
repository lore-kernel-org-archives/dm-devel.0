Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC9EC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 23:42:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-eEsMNa8FN02q2VHALCI4NA-1; Wed, 13 Apr 2022 19:41:59 -0400
X-MC-Unique: eEsMNa8FN02q2VHALCI4NA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4F3C811E76;
	Wed, 13 Apr 2022 23:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9C832166B4F;
	Wed, 13 Apr 2022 23:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 58B2B1940347;
	Wed, 13 Apr 2022 23:41:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B85BB1940345
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 23:41:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A0B2657B35F; Wed, 13 Apr 2022 23:41:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BD7754FBB3
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 23:41:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D90D29DD9A9
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 23:41:56 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-iS_z3KCsOsGkn_riRV2iUg-1; Wed, 13 Apr 2022 19:41:52 -0400
X-MC-Unique: iS_z3KCsOsGkn_riRV2iUg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DL9MQ1014133; 
 Wed, 13 Apr 2022 23:41:25 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb2pu3mfx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 13 Apr 2022 23:41:24 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23DNfMbP031007; Wed, 13 Apr 2022 23:41:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fb0k48x2k-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 13 Apr 2022 23:41:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM8PR10MB5414.namprd10.prod.outlook.com (2603:10b6:8:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 23:41:18 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 23:41:18 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Thread-Topic: [PATCH v7 3/6] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Index: AQHYSSYcmxaMmXFgxUqypAmHkAJB9qzsGAQAgAJ1oIA=
Date: Wed, 13 Apr 2022 23:41:18 +0000
Message-ID: <7ef7960a-d505-db5b-06da-96f60c24113a@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com> <YlVPcrK4SSXyPx+Y@zn.tnic>
In-Reply-To: <YlVPcrK4SSXyPx+Y@zn.tnic>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3de0b4b5-8f69-4334-d982-08da1da71b9f
x-ms-traffictypediagnostic: DM8PR10MB5414:EE_
x-microsoft-antispam-prvs: <DM8PR10MB54143FFBCF7A1087909978E0F3EC9@DM8PR10MB5414.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5XAF7UPikyGZ7mNwSHEK+DkXuHXLAO8edGeCHBr/CF0i08xRDHUzQT925X4BcBxqeWnXo2i3aQgpO4uHB6uCCyFFiduv/m1IB3wrOkeC3XWKxjI+mWxHd2BxW7gpGwydgEM72BJGsTB5PhfXBkBhpYO+GU5PMB/DZByuTN884AGlSlC05bSOyP1xJeiYw0YEgrgTWLYm+fibr9478LA7ZCyV6ph1Yj/ObHIuvpGTeJEN31WODnE3OiS+RRT9OJDzghEUH4SiyAoEeyAhwk/1h/vtdTC2xq50GE5Xz6clKvSxKz4jBlh5RgbWMxtv4vf+u2W4WhABivpNymu8/g8sc1ZITcKTwMlNlPGfjEyoYHd8Q66rrsJPEzamXVjCCzepODhWF++0jxCkAsfIMK+sFZIcwtRqlxXEO4LUMdoxIivoYppkEGzo7Qc/ZhswIVPXHMQ9u8YgJtzxM6+KUHhED3ily/wbcI4m2eFXpehNDn/KZRzA9MQEG+q4gDKoeN3IpOOg/iduIOCcS1JDY27Sj/SZS+iYgS1CJNsZOvNRG4VfmKqcIxYC3z0hZ7sfz8Od68QuVaDx5BS1aQ0MCiGVb4Xh+g3JqGhkaCxZdu3E//vWuHrQdSztCjCAFEekZvbqQbwPimeenZJnm4EL7c7UvPg6Crwzdg84BqmLVKJT8x3akkHF8cPFoaAoBbZD7PlvO/PBMoF9cijT7sNVJH43o6bcmzQh6hazS8vqV3hP7wO0bWpbGseQB8rxx9BtG8QQmdQ9/2W8LeBANqjt5/DIAGuEuU/n9/sKSZFxTKhLS0Jqk7jg+Ceuwme+BH+PQ3Zgl/MnrnKvWyUjYF0N4d7FsQUcDMcwjMVhbG3ap4IJSgU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(31696002)(66946007)(91956017)(26005)(186003)(2616005)(6916009)(122000001)(54906003)(86362001)(8936002)(7416002)(38100700002)(83380400001)(38070700005)(76116006)(31686004)(44832011)(36756003)(508600001)(6512007)(6506007)(71200400001)(8676002)(66476007)(66556008)(66446008)(64756008)(4326008)(966005)(53546011)(5660300002)(2906002)(6486002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THBhTStoVjBoVVg2WlJIM1hDQzRwekNRc24yS3pQeUQ0bzRQNDFnNzM3WmlV?=
 =?utf-8?B?ZG95OXExVDE5aXM2K2hvWVNDckVMcmRZN1B3V3E4WkcraUpCWUlrdnYzMnlP?=
 =?utf-8?B?cWR0S3BwZ2xhaTM5SGx2SHFqQ0JGMUJjb1JuRGhPZndHY0RJMUE0VFVvYkR4?=
 =?utf-8?B?a2I3Wk95WHBCeWtydGp0K3RLRGtSeDJSb2wzZkxvSVJ2Vm5tRlR0NzJjazVt?=
 =?utf-8?B?bkdSODdsazAyNjVWTVVZZndQODlUZVcrTXZucG54bE1MWDJ4cEdZdS9rQ1Jv?=
 =?utf-8?B?ZFVBWXk1S0hPY1FQT3NpLzh0WG5RZmZuRWg5MjFkZXY1V3F6OG1LdU5aMVpn?=
 =?utf-8?B?L2REWnBKdkFMUE1lWlZsRzJuellWN0FlT2FpOXUxNXZZQXZkZ3V6NlBIMEl5?=
 =?utf-8?B?RzlTM003VU40NDdHbXYrcDdXbDd4WkNYSWw2TktmM0hJbHN5UzRFWmNBNlJx?=
 =?utf-8?B?SWxQSENoWjJrbWxIM3BHRzlQazdrZjhnYURqRm1YZFkzcWtwaWNUazI4clVt?=
 =?utf-8?B?WVpKRVBsNHY4MGIxZFJZU0FVemNZWmdibytGL0sxT3YvTFRYdk9UbE55OWRN?=
 =?utf-8?B?ZzVPMjBZRlRiL3NRSE5QcDE4VGR3ejBJVnZiTkFDZUd2bTYyTUd6MGt0UWlI?=
 =?utf-8?B?SEwwc0pvUDNtN3hxclRnbFl6S21SMXVpdkYvYmRNQXBSUzF0Q0xiYlFhSnNz?=
 =?utf-8?B?SU9wd3BzUjZRaWRhb09wV2dEMkFjZlJaalA2YXhOWWNDd010VkpRanN2UjJ1?=
 =?utf-8?B?Ynp6dm5WdnZwSjBMWkhQbGRwRDUyTklFcXYzM0Y3cEFTMzc1TGk0MGJUMkpE?=
 =?utf-8?B?WEd0eGwraXZnNzk2dnZLUmZodzlWSXZ2WTVpOWk4SksxSkdtdlN0WGR0NDBr?=
 =?utf-8?B?ZlVGdTFqRTZyYXFiYnBpMGdLOVFUT2dadFQvSGt1djNsVXU0MHBNNmlmUW9r?=
 =?utf-8?B?czl6VkR5K0ZWUWpMS24raHlyVS90LzhucGRuTXM2Y2x1bENoRlRRQmRvRjBW?=
 =?utf-8?B?c2JCc2gyaFp1Ykl2TlFtQlc0RkJJamJ1aHFXZUUvVWxwQVc4ZXBLSmdvWENB?=
 =?utf-8?B?WUdTRGU0R1RIU1pwVXoyYmhObkc3b1ZtRWxQRjk2NFE0Qzk4NGlqOEZaWEtH?=
 =?utf-8?B?UUxTakVIK29DNnpjaVlLbHZNSFhPOFRVVlo5MGJOcW1CZm9nUUxLSW0xTE1a?=
 =?utf-8?B?MW9zdXpTSmM0WmptNEtBWVVqOStVS0hHdUdSanA1ankrcFFoYVlHSDBXNTc3?=
 =?utf-8?B?dGZOQ3ovYXNFSkVRRWNmRGgySG1YeVhXWk1TcDdXSUd3dFg5aFd5ckEwMTJ0?=
 =?utf-8?B?dUdjUDFTS2ZtRTVweFBGT3BTeTUxKzFLYlBtVUdqdlc5U0JaNjM2WXlpa2xD?=
 =?utf-8?B?TjNPK0xnVVFaVDQxYUJIZkFJeWxXM2o0WXlwd2hsQ3BJckRRbFBKTzBSdTlE?=
 =?utf-8?B?eVIwQkp2NG81TXFmN2taU3pzNHM1Sk1CWkV4UzBpU1gyU0VqU0FoN09PQlpH?=
 =?utf-8?B?YXJITHh1QWlZYWpJYXZueDRENExiTVZoemFJYS85bmtFSU5YcG5CZUFKVlJo?=
 =?utf-8?B?b1d1dUNndWZSbjViT1orZU9SVGZ3UGFSYWR0L0QvYUgvd3VYUlVTdjNScElt?=
 =?utf-8?B?eFkxU3JzK0JLQ09ZbEp0WE9JKzF6b2t0V0loT1M3eGJDeGt6WXpOdXZKcitQ?=
 =?utf-8?B?NXNTRitFazVOdHlLSDlaRS93NlNYdzBudG5GcWlOK1pNTGsyUXYwYWxEeVNz?=
 =?utf-8?B?ZEUzNG40bFRiOVhDVTc0MDRnVU15NEtFTjNkSHl6SnZqZkNKWUVMNkdicW0z?=
 =?utf-8?B?S3pLVmEyODlZTW15RGRWaDVYbTl2UVdCRWhlWjBhSWtyYVRoKzZHR2xIa3E2?=
 =?utf-8?B?b3hOTHljdUNRNW0zbWsvRjdMMDRnR3BPTzcxT3ZnR0t4dkVFQ051dGZZNldL?=
 =?utf-8?B?TGRUQldTSXQ2YmhweUFzRzU0RzBuVnJ3KzNsbGpZaElrYkh6MEJoUVVvcVBn?=
 =?utf-8?B?eHZSenhYNyt3TlR6d0ZFdWJNSHRQd044V3FXK3JWSFBCd0MzODlPMHhiNDh0?=
 =?utf-8?B?clhrSDBmM2lYa0J4QU1PaUwzUHJ2MGd2a3pYeG1wY3VYdGMrNy9pemFsbThD?=
 =?utf-8?B?YW1DOEhEdDhORmphSitKR25rQkhlbE92T082MXQwT1plOWFCa0MzeXdhVkI1?=
 =?utf-8?B?VkcvTDVJUFJQL0l1NzFrYTNlU1BkZXhiYWN2d0RKblFQRW1JeWNPUHgxMVo3?=
 =?utf-8?B?QW9RS3EzaGt5cG8zOU9OK0JiWWd2bm9rcHhua1ozOUVYalBpbTJNWStqcW9E?=
 =?utf-8?B?ZTRDbXRsTVQrV1Y2MmhLa0RoNXhEYXBRODM2eXNoN2RiK0NtL1ZYZz09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de0b4b5-8f69-4334-d982-08da1da71b9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 23:41:18.4988 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDSW1h6WHDLyRtmI5fviECIbGGZvZXtS1QkFCtV0upouMyBcBo6KK+Wdsr/sVUINfKqG5Zsb/GwYdFFRYd4i7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5414
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130112
X-Proofpoint-ORIG-GUID: MFpFY46T1w738wfpAPyoDMX3gak5X7cx
X-Proofpoint-GUID: MFpFY46T1w738wfpAPyoDMX3gak5X7cx
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 3/6] mce: fix set_mce_nospec to always
 unmap the whole page
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
 "peterz@infradead.org" <peterz@infradead.org>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "hch@infradead.org" <hch@infradead.org>,
 "dave.hansen@intel.com" <dave.hansen@intel.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F2871F7C12A925438730E545B80E9E41@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/12/2022 3:07 AM, Borislav Petkov wrote:
> On Tue, Apr 05, 2022 at 01:47:44PM -0600, Jane Chu wrote:
>> The set_memory_uc() approach doesn't work well in all cases.
>> For example, when "The VMM unmapped the bad page from guest
>> physical space and passed the machine check to the guest."
>> "The guest gets virtual #MC on an access to that page.
>>   When the guest tries to do set_memory_uc() and instructs
>>   cpa_flush() to do clean caches that results in taking another
>>   fault / exception perhaps because the VMM unmapped the page
>>   from the guest."
> 
> I presume this is quoting someone...

Yes, will mention Dan's name next time.

> 
>> Since the driver has special knowledge to handle NP or UC,
>> let's mark the poisoned page with NP and let driver handle it
> 
> s/let's mark/mark/
> 

Okay.

>> when it comes down to repair.
>>
>> Please refer to discussions here for more details.
>> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
>>
>> Now since poisoned page is marked as not-present, in order to
>> avoid writing to a 'np' page and trigger kernel Oops, also fix
> 
> You can write it out: "non-present page..."

Okay.

> 
>> pmem_do_write().
>>
>> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   arch/x86/kernel/cpu/mce/core.c |  6 +++---
>>   arch/x86/mm/pat/set_memory.c   | 18 ++++++------------
>>   drivers/nvdimm/pmem.c          | 31 +++++++------------------------
>>   include/linux/set_memory.h     |  4 ++--
>>   4 files changed, 18 insertions(+), 41 deletions(-)
> 
> For such mixed subsystem patches we probably should talk about who picks
> them up, eventually...

Hmm, maintainers' action item?

> 
>> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
>> index 981496e6bc0e..fa67bb9d1afe 100644
>> --- a/arch/x86/kernel/cpu/mce/core.c
>> +++ b/arch/x86/kernel/cpu/mce/core.c
>> @@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
>>   
>>   	pfn = mce->addr >> PAGE_SHIFT;
>>   	if (!memory_failure(pfn, 0)) {
>> -		set_mce_nospec(pfn, whole_page(mce));
>> +		set_mce_nospec(pfn);
>>   		mce->kflags |= MCE_HANDLED_UC;
>>   	}
>>   
>> @@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
>>   
>>   	ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
>>   	if (!ret) {
>> -		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
>> +		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>>   		sync_core();
>>   		return;
>>   	}
>> @@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
>>   	p->mce_count = 0;
>>   	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
>>   	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
>> -		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
>> +		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>>   }
> 
> Both that ->mce_whole_page and whole_page() look unused after this.
> 

Yes, indeed, Dan also noticed, will remove while_page() in a follow-on 
patch.

thanks,
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

