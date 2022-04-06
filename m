Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A75C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 17:34:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-Sn5VMlcxNjaM_uuvd6ezZw-1; Wed, 06 Apr 2022 13:34:54 -0400
X-MC-Unique: Sn5VMlcxNjaM_uuvd6ezZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12D28899EC2;
	Wed,  6 Apr 2022 17:34:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE16253AC;
	Wed,  6 Apr 2022 17:34:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7521194034B;
	Wed,  6 Apr 2022 17:34:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26A851949763
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 17:34:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 146D71121320; Wed,  6 Apr 2022 17:34:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D5A21121333
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:34:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A53F1185A7B2
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:34:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-GWySnFiCO5OkiQcv0pKZTA-1; Wed, 06 Apr 2022 13:34:44 -0400
X-MC-Unique: GWySnFiCO5OkiQcv0pKZTA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236GSL1i014716; 
 Wed, 6 Apr 2022 17:34:33 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9sf5h-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:34:33 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 236HGt36000767; Wed, 6 Apr 2022 17:34:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f974d4jbs-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:34:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BY5PR10MB4194.namprd10.prod.outlook.com (2603:10b6:a03:20f::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:34:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:34:23 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
Thread-Index: AQHYSSYgcxRlD0CAw0GRmRS3uRkg1KziVV2AgADRcoA=
Date: Wed, 6 Apr 2022 17:34:23 +0000
Message-ID: <839591ec-1754-e5a2-4676-57772bbaf3d0@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-6-jane.chu@oracle.com>
 <Yk0fbUs584vRprMg@infradead.org>
In-Reply-To: <Yk0fbUs584vRprMg@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc03a692-c666-4bad-5536-08da17f3b0d3
x-ms-traffictypediagnostic: BY5PR10MB4194:EE_
x-microsoft-antispam-prvs: <BY5PR10MB41941BCBBC6FF490ABBF4079F3E79@BY5PR10MB4194.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: y0TfKmQJpDDpFBnR3ABwSra707lRQziqvGxqh65l+Sjo0Mez/8Mxe2oh1We3j7VaNkzG8W2EILcc4P75FwMIkaiOiMMjozlRt/LRNPrHkzCqJ65zMoaXDrPw8iNRb9I9ujMZsf8JwhMBgP5upj37dxxXACfRd9k47F0YlGehTT99UQRJeU3q+Si/TiFDSOEKxYqlBFTSyU1NmaT0sUuwMxnUI9KA21je2+yCwsjxgrAFVrnxKqZ29euBtabokPItnqs8pgxTK0E8WgOKSJBszqaRGQD209Ig3IlR/mKDOpYtbRNcvw2P+RVmkU/eXKp/QzQA67JDCDBbYOiwsut9MO5lioPtTVYbuvh3YXZiwffKD9rgdrui6Bao2/EhPPZc0vP1oo9XkqiMCCxl8cRweGc2eSoryKj4m2JD59dwnvsxmE6ga7M42YpPRVPvJMoYyucktDKlTmPTyewglwpvUo85Qzly0gip414P3s6tHLC7iggj71T/q3GPP2lCabcKOKtusSgMELsZbBUxl43DFSPxrHLCPfpLZYsDVTFAxWGDezxGUVtNLJZNvubdMniCCbg79uihmrpe6rEtpG1hClU0XUsvr5K3cl5CAgzncghXXC72oCi6Lf1tQcNONWw8ZzOgR1eGysY0VE1Yph2NV1FqhbKtW8lM6shSmGpeLe8+/j1e1eKxCUWI5bbfYu8BcPyBt/HBXiGacl6F5y15nrZn6u6fDlkeVUq1ZGbFEtzxAZDfPul7REvQeTKfaH4ToGuCocs6Efh1Fs0oUY3hSg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(31686004)(54906003)(7416002)(44832011)(38100700002)(8936002)(31696002)(38070700005)(86362001)(4744005)(5660300002)(508600001)(76116006)(53546011)(66476007)(64756008)(8676002)(66556008)(186003)(122000001)(4326008)(26005)(91956017)(2616005)(66446008)(6916009)(66946007)(36756003)(316002)(6512007)(6486002)(6506007)(71200400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vk5ScFlDVFBEZmhKRE5lRkMxc1N4VGduWFpwWnFpU3JMUjkvT3dmckx2ekJr?=
 =?utf-8?B?OW9GM1VaQlB0L1poTXFudGlRNWlzaUU3eXExSGtxQm5UUEI4OUZCSWtuYWpI?=
 =?utf-8?B?UWUvdEdWbjhJbm9HV2xhSVVEWHl2V3J3dU5TMU5Ob0ovZFFSZk5XUG8wejFX?=
 =?utf-8?B?aktmQlRKZW9tY1BsdFYwV0wxem9adTBTa2g4bWFHQTNIZHljYWVYSko0TGlY?=
 =?utf-8?B?QXBNN2ZCSHVraE9kb2UyRjZQck5lN1YzcVdLV09xWFc3cVV5enMwTng0Q1JS?=
 =?utf-8?B?UEFnc1h2akM2aEk4YzlNbDJGV2FGSmpzSjkwb2Nma3hmYlZjT0xDZkNWMGRw?=
 =?utf-8?B?eGtINnlmamFNY3V5ZHRHZTE4VHI1bVorV3B5aXBPQnhLbU9JUi9Vb2Z2T2FO?=
 =?utf-8?B?OWY4cjd1WjBTV3JTZHBGOEtDQlJXQ0VVeE4rUHQwaWFXbllwdVVuZm44YmtN?=
 =?utf-8?B?Zm8rYWRESHdsSll6K3pZN2ZsWHMrVVY4SmMvQnpjcTZ0aHBtZjB4VjdBcDFo?=
 =?utf-8?B?Sm1vR01XSTJWMG9qK2VGS2hxZFVnQkVMZWFNL0hsZzQvUS9SSUxNM3MzUzZs?=
 =?utf-8?B?SDdkR0FSSThSRTU3UHB1WGZYYUNCVzVBcGtMK2Ewb1NtaVdBRWVTYUVsVnFi?=
 =?utf-8?B?NDdaU1JQTnBpZFQvTll1Ym9RczF4OWhKRXhIa0J1b29DV3JCYVpYcXQxMkJx?=
 =?utf-8?B?OGRieldwVEQwNTBsQnZEanByRS8yeStnSXhUOXliTjc3d2hJcXgxTE9kalhm?=
 =?utf-8?B?c2pnL1pSOUozNDQ4Qy9jbGpuZW1SVEJmY3dRZldUcHhwVTFzWG92YUo0UjZt?=
 =?utf-8?B?dCtiWGhIbzg5STVPVWtEaHkydDg1eHNKMW1ycmZNSU9ISWRUUGZKMG8rOHZi?=
 =?utf-8?B?V0ZCczdRaUR5eWpBZkRvR2JlWVFFRnpoYkM1aytpKzU3RGZ3bHBkYXFtVHhu?=
 =?utf-8?B?SHcwdzF4cVRZYzRwY1c4RHdiZGRYWHRuVExoQ2tnWkFMRlpMV0J0Y21iclZX?=
 =?utf-8?B?VUVvMTNtNERXWEdRV2dHczNEZElQdzZOaVNtdjJTd1NySGhRODlFeUhrWjBn?=
 =?utf-8?B?Q1hjSDFzSGxGTmhKUi81R2Q1WEUrSkJFdis1Nk9id1h2U2dFanFCclpoQUZn?=
 =?utf-8?B?OUFtM2hjM3dYL3BjSWVLNDhaaE90TTFxMFprTk1yeXpGNkpXckNySldjdTVM?=
 =?utf-8?B?MEEyMHVML1BVWVpTSWp0eURiVXZCN0FpQlI2aWJjaURsWXpHYW5tVUxxMHp1?=
 =?utf-8?B?SlNXTGFmak5uQnNTcndtQXhKeGMvRkxFbXdJNkk2TExxL2NveUZza0FsTDBl?=
 =?utf-8?B?Q0xuSEZiQTdqVFFhTlpWSUt1UTA0OGxQYjRwOC9udmlyTENBZ1lRTFg1bXdC?=
 =?utf-8?B?YXlpY1hjVUJTbUM0Tmw1dlo4Y3lnQ2xEUjRWSkl5Umc4ZlFiK1loSHJNbXVK?=
 =?utf-8?B?bm5FQVZkb0p2TEhxM2l6OTN6TVlEWGthTFlOUjNoRWgrY0xWSzlnUDFZZ0tn?=
 =?utf-8?B?aUtGTnhkUFhZV2FnanRNZ0dVdlB3MU5QZ01YZEd4dytYajFoa2w2eG83MkNm?=
 =?utf-8?B?cm9vcVVoUnhMY3JoeitCVGUxVlVET3ZIUHovQ1pxdUZ0OXV1alM0eWh3NVpS?=
 =?utf-8?B?TGxaVDR3M01FZ0NWcFlsOVZ3dWJhang4czhWNitpdm82Vys2NVRFY1BaWmZY?=
 =?utf-8?B?Wkg3dXdpTnFNbjdlL254U0MwQmt2MmUvTll5ZlA2aytYUmZtTFdORVl6NzRD?=
 =?utf-8?B?UFRFY3VIKzBqSlk3NEt3eXVLK3dQWWExZnhaaDdEYndkQVRzOEs2VFhHdi84?=
 =?utf-8?B?bGg3VjlOVnVtYXRkdnVFUVoyWkpLUHFFZnh0YTBJaDRRRzNYNVR0YkRtcmUz?=
 =?utf-8?B?ZForeWI1YjNVYnRGTk44Rys5UEtoT2dYWmsyNTJ5TkpYR0hzd1dlTlVxU3dL?=
 =?utf-8?B?U2JtVTh2QUVheDNrUllHcnpIUFlOSDN6YVVLaWNjbVVvczZGVzM3R3NCZFdW?=
 =?utf-8?B?UXI1VVJoU3M4YS83THRBeFVhbEZCSlMxVlh2MHViMFJFOGZ1bWlseDRJeGZ1?=
 =?utf-8?B?V0c0MVBTMVBqN3g4eEtoR1M5T1RRR3Q4eE5tZUNEbmpkQWVIaFQzdXpzeFRT?=
 =?utf-8?B?bU9zNWlhZy9jMXdOTXZJbC85MHlwY1dwRlhqUU5WOU83WHhJWE85MEdKWXp5?=
 =?utf-8?B?WS9weHFxVE96b3U5Unh3MysxeUV2MllNTUdBZzVGcGRGUGF4WEwzZm9uVVZ4?=
 =?utf-8?B?QktaSlR6K2h3WmFkcWNKbWVaeG9MV0lDYmwyMTRzOFZab2RKMWlNUGlneHVF?=
 =?utf-8?Q?+3YTQjUI6/BPKIEpPz?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc03a692-c666-4bad-5536-08da17f3b0d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 17:34:23.6541 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdNJ8oxZrr605i30IwkjQVG1c8ct6SyPR1A3hYch4MvCWGKx+ykK2rqhvGhmYlyRXe2P+maFrnMGuCEHkLGYcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_09:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 malwarescore=0
 mlxlogscore=815 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060086
X-Proofpoint-GUID: siMRKrM5B0-3kC1HPYxEiFS5mrDf3jge
X-Proofpoint-ORIG-GUID: siMRKrM5B0-3kC1HPYxEiFS5mrDf3jge
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B6D5D09266131449BA1A90B18CF64970@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/2022 10:04 PM, Christoph Hellwig wrote:
> On Tue, Apr 05, 2022 at 01:47:46PM -0600, Jane Chu wrote:
>> +	pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
>> +	return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
> 
> No need for the braces.  That being said perosnally I find a simple:
> 
> 	if (cleared < len)
> 		return BLK_STS_IOERR;
> 	return BLK_STS_OK;
> 
> much easier to read anyway.

will do.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

