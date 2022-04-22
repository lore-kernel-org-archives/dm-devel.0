Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9FAC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 04:16:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-HAHeRpdlNI6RaC6bWTa2MQ-1; Fri, 22 Apr 2022 00:16:10 -0400
X-MC-Unique: HAHeRpdlNI6RaC6bWTa2MQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC80386B8A0;
	Fri, 22 Apr 2022 04:16:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D79CE2024CAE;
	Fri, 22 Apr 2022 04:16:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5A411940350;
	Fri, 22 Apr 2022 04:16:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 810BA1940350
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 04:16:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51A08C27EB0; Fri, 22 Apr 2022 04:16:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C383C28131
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 04:16:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2953C1E17FE3
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 04:16:07 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-T7BHn11RMx2z8PXAoEeTGw-1; Fri, 22 Apr 2022 00:16:03 -0400
X-MC-Unique: T7BHn11RMx2z8PXAoEeTGw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M3wfrH019412; 
 Fri, 22 Apr 2022 04:15:44 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cwbuv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 04:15:43 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23M46mc4028448; Fri, 22 Apr 2022 04:15:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fk3av5umy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 04:15:42 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3349.namprd10.prod.outlook.com (2603:10b6:a03:155::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 04:15:39 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 04:15:39 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
Thread-Index: AQHYVFsQsaUDJAWZ/UKYy6bMSO9seaz6xSCAgACRaYA=
Date: Fri, 22 Apr 2022 04:15:39 +0000
Message-ID: <d56480c4-9ede-7340-6e66-c8dca114754d@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-5-jane.chu@oracle.com>
 <CAPcyv4jBUE9BTOrqVsFcBUZxzMx6ygax5FihrrccG2sET56Gjg@mail.gmail.com>
In-Reply-To: <CAPcyv4jBUE9BTOrqVsFcBUZxzMx6ygax5FihrrccG2sET56Gjg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dca5088-667f-4c84-bf43-08da2416c282
x-ms-traffictypediagnostic: BYAPR10MB3349:EE_
x-microsoft-antispam-prvs: <BYAPR10MB3349E8044BDB75C764FD8C9BF3F79@BYAPR10MB3349.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VVF1y0qSRBVsNUks91DLstKSmUBg0DtQDH1hCV/oe6hDouWowBShOQTsS/cn8X+jt1uuIeisWoPfTQDGc1gPP1IwRDxvdQPCHMNFKbkd0vWBcHfcMXVVqrPVykvsimqWYN1+zddpmoIUdy0VKNANmhd2UQ5zHwcNPl4i0xIwvBK/E0eVbPduzBg55cScjwNEpLVfSvHSsA1OgBOliE/ehRpjf4FwHwG+tOZdGTz0kRLJyq9dqWPRraHrIcWTI8EBUSJ/g9in/hlAMif8QLpzG9w1u5r2ozoCHrjq8kWYQmmUZrHv37dhdR+P5U+evgnbjHxYvPT+i/T8TvYi5m4rFd3ch0Hm/LUF/yNoESpIwCrY+jMc/Jg2qQDsMZlTztSW899Pmem8IgeDCSZ+Oz28tqa+ivMsecwwIPUCBtmbmL7IYCzWSLbkWIII6s+n5SEFHF+8ZOLV0+kXrxlIeSXMRuDbxemcLqaCFS8+8ccwW+XnJdMlFniGfpJUbV7jbSMkrBq4XOXIPcZuMiU7N2tL4YiJffHNoQ5R/iYr0RZOEur7QSM9jRqQy0twFJDs3qQUZ82M2W9KgjU34eSZLOzW1s/1hyPJhHX2XmmerNpIRzyjFv7JN4jo1sRnHlfboXXTYGeiHwiVVngDkw8pd31pq34ZfSSPVqdsE+xVHLA0FzcNLF5zCTZ0x60lGbpivNsV8aVFl+8OGhc/ay4fBA5e1mLIZ6iIiPAyjZjE/wDYpW2w16ornxw67d/UByAkaV80qkOl7YnhxYSZFC/uT4LxdA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(76116006)(83380400001)(64756008)(66446008)(8936002)(186003)(66476007)(8676002)(66946007)(4326008)(31686004)(6512007)(122000001)(7416002)(53546011)(86362001)(26005)(2616005)(31696002)(5660300002)(54906003)(6486002)(44832011)(66556008)(38070700005)(6916009)(71200400001)(316002)(508600001)(2906002)(6506007)(38100700002)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVRSZVJVTEc4emFGd3R4NnFYWWRWbldwdmtHYkR0N2p4VW1Ocit2NkJHRFM5?=
 =?utf-8?B?alEyY3pkOHJJTy9XNHZyay9wWTZxRGlMM2krcDk2UzhDdkN2MzhoMXh2eERX?=
 =?utf-8?B?Y0VqdkdxV1NHQ08xS1FWdmRTSmx2WGIrc2pkQWtBYzNaTVg5Z1JuSHpHRzdW?=
 =?utf-8?B?bmREZmxneVhpVlp0a1pUYjNCemtRdGZRNXJDN3dQc21CcGhXWWVScmltTlMv?=
 =?utf-8?B?WTNteC9adElFUHY0TnJwT2FzUm1wck4yVE5zYWhTN1B5Q2dvTVF6VXh5ODNt?=
 =?utf-8?B?TmQwUm14U0MxeVlpcThCcnFpRGMrdTVLeXd6TFRSaVJEcGZqdG9lU05OQ3V2?=
 =?utf-8?B?ejB5dU5MUTJTQ0s1YVc0YUZRQWxBZzRpVWk5ck95Rk9qVkNTUDFxL0RiSTNI?=
 =?utf-8?B?ZGE2OXFoNGFJNFM0eWxVUFBWTzFNaHdLVEZaM09HeFhkbDJhei8wZFhhVjVt?=
 =?utf-8?B?aVN0ZitYQ3FXU0E4VWJWaHJhN1ZtN2pLU2xZaXNvMG5CZ3daTlFSeXhlUm54?=
 =?utf-8?B?QTBYSDZRZmcwa2FJTDdNWDVsc3VzU3BKdThDdVU0bFhpUTFTK0xaaXZqVU1Y?=
 =?utf-8?B?b3A1VnVCRXdkcFRUZmNmQXZyTzZXSjZmQVFzT3haZzM5THNwY0hNeG1WV1ND?=
 =?utf-8?B?S1ZOZWluU2RtL0w4d1k3OTgxamRkYW10OHk1aEhRQmYxdGpwMktFWUZybHAv?=
 =?utf-8?B?K0NmMGhlRFdNQmFhVUtQQXRsZVl2bXMvVmF2N3NrcEZNOVlHY2Z5SE1pUzNa?=
 =?utf-8?B?N3FlRkYzaHhqOUxTU1dtU3FSUUNld25neVVRUHNrSjkxZjB3Z3BOSTJ3blhh?=
 =?utf-8?B?YnRLR2ZkMU5nTElpeXA5aC9uaWJrc2cyV3g0eXpSdU9KdGwwdXdPTWE1NU95?=
 =?utf-8?B?MWtkaGg4dGJ5a3NXVkRkYldYT05PY0NSOVNiZHRnOUgxVzN1WUd0R3VadHRV?=
 =?utf-8?B?eURvblV5UjRJNC9IbThUQ3dhRzk3TENjZGFTKzdLNlVPdkpGdG81NlI0TmJN?=
 =?utf-8?B?cWh6V0pQTmo3Wk9QazBzNzZXU2dnb0JXVkNNVFJ4SVNBREJVanFFd3pvajIy?=
 =?utf-8?B?RWZ2c1Y1YnJWZGJ6U2hCQjVScEtLVUJlV0xJQ1FidFIrMDkzQ1FQMTVUWDA3?=
 =?utf-8?B?TjArVUZYVnNteXZReXRtd2wxeVEvaG1PdVlVYXVxbnJTbWNyd0UxRHlhTzNq?=
 =?utf-8?B?YWZJRElqY2EvVWk1Q0JCS3EyUXQybFUzUjhKWWJuamhGZUM4Q29FN2NScnk1?=
 =?utf-8?B?MnE4Ui9XcGNPdXdSc0RCMU56eTJQRVA4eXhlRFB4MFdobENSc0taYTdLczha?=
 =?utf-8?B?OXU2K3RaeUdScFBHOTBxZ2h1aW9YcC9xUk9CTnZmOHNSdVVFNVdKeG92aXUx?=
 =?utf-8?B?eTBhZlE2dHNoUVhuTkpUYlhCZEl6aXZIekcyZjZRa1VkTFF2ZEJZVGJhZTBQ?=
 =?utf-8?B?WHdVL1BpZnNLMzhjL2xqUFUxNklyM242TlhpRktKdXRRMjNXZC9Bd3dHWUV4?=
 =?utf-8?B?ZzhkWFJwNkpJcUcxR1YyZnVybkwwUWF3WjFQUVJDMXJvQjI5aFRCZTRiaDFv?=
 =?utf-8?B?YWFpS3F6RHVyUkxGUUlQWUh3R0NpUzE3ak9hY1VTaG9PT1NKejZJOGdEYlVD?=
 =?utf-8?B?SC9VMVlKM3o2UGZnQ0trRXBiTUFYK3FNUEJqVEQvNGdnVCtNamhnR2pVSzhM?=
 =?utf-8?B?UTl2TDB4ckVobzBoTDFzVkpweXQrVlpuMmlNeExBV2REWmJ4Z1B6NGNuV3N1?=
 =?utf-8?B?aGdzbGdxZ0xwdFhIbld0Y25Wbnh3ZzNZbHU3UE5GdjVQUTVoeGlpK0NsVktj?=
 =?utf-8?B?WXZ5bXZ2L2JPNEdPcllCcC9sUGt0RFZDSkllYjNxWDNOc1N2OE9FMjdlUzdD?=
 =?utf-8?B?bHdSN2J6OVNiZ1A0ZEtJYnpGNXh5d0VIbjQ0K25rd1J0ZkZHV2tmMDBETUp1?=
 =?utf-8?B?K0xGdURZZkxRVVRtYTZiclBkNmY5czBQM21GM2ZkcWFaQVA5Wlo2c0c3T3Ix?=
 =?utf-8?B?Vk9OdGhOYUNIUkNXN0VXb2NpVDZSVldVenJQTE5UaTFYOUc5Y0VheksvWm0w?=
 =?utf-8?B?eDFUbTI3U2dnN2YxaHY3QnBoV3BrWjRka3g4c3lsSm9rbnRyVnoxN0VGL2Y3?=
 =?utf-8?B?eEFSYWdQdWRBRnhQRTJTUGt6VTl1WVJ4MklqVW5Db3lzM1ZpaksvMXhIWUFs?=
 =?utf-8?B?L2dOMVRUTjFxbG1VOUt3Y09Jbk40SXBTUkhlQ2Y2UXptSTNhZ29oZEtnUW9U?=
 =?utf-8?B?UG8reDgwWktXakRqRFpmbG9EMTAzYzJwbjZFeFF5bXU0bk9JN2hiUDlxeElR?=
 =?utf-8?Q?wqYj6GXk2x9jzTNaF0?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dca5088-667f-4c84-bf43-08da2416c282
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 04:15:39.6481 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYf0igP++zW13QRz/+IPhowgRgIe0bHTdoudCEMU8tfP2EADN48TeNGjQzRId0mZKnQ8zPGE3LtFLvowOVBjwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3349
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-22_01:2022-04-21,
 2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220015
X-Proofpoint-GUID: aqP9wGl6gv4U-B4l_yFX2WUyE8Yo8b0U
X-Proofpoint-ORIG-GUID: aqP9wGl6gv4U-B4l_yFX2WUyE8Yo8b0U
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax
 access mode
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
 Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 "Darrick J.
 Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CD8B9897F7532648B8DA52F81DF787CC@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/21/2022 12:35 PM, Dan Williams wrote:
> On Tue, Apr 19, 2022 at 7:05 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Up till now, dax_direct_access() is used implicitly for normal
>> access, but for the purpose of recovery write, dax range with
>> poison is requested.  To make the interface clear, introduce
>>          enum dax_access_mode {
>>                  DAX_ACCESS,
>>                  DAX_RECOVERY_WRITE,
>>          }
>> where DAX_ACCESS is used for normal dax access, and
>> DAX_RECOVERY_WRITE is used for dax recovery write.
>>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/dax/super.c             |  5 ++--
>>   drivers/md/dm-linear.c          |  5 ++--
>>   drivers/md/dm-log-writes.c      |  5 ++--
>>   drivers/md/dm-stripe.c          |  5 ++--
>>   drivers/md/dm-target.c          |  4 ++-
>>   drivers/md/dm-writecache.c      |  7 +++---
>>   drivers/md/dm.c                 |  5 ++--
>>   drivers/nvdimm/pmem.c           | 44 +++++++++++++++++++++++++--------
>>   drivers/nvdimm/pmem.h           |  5 +++-
>>   drivers/s390/block/dcssblk.c    |  9 ++++---
>>   fs/dax.c                        |  9 ++++---
>>   fs/fuse/dax.c                   |  4 +--
>>   include/linux/dax.h             |  9 +++++--
>>   include/linux/device-mapper.h   |  4 ++-
>>   tools/testing/nvdimm/pmem-dax.c |  3 ++-
>>   15 files changed, 85 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
>> index 0211e6f7b47a..5405eb553430 100644
>> --- a/drivers/dax/super.c
>> +++ b/drivers/dax/super.c
>> @@ -117,6 +117,7 @@ enum dax_device_flags {
>>    * @dax_dev: a dax_device instance representing the logical memory range
>>    * @pgoff: offset in pages from the start of the device to translate
>>    * @nr_pages: number of consecutive pages caller can handle relative to @pfn
>> + * @mode: indicator on normal access or recovery write
>>    * @kaddr: output parameter that returns a virtual address mapping of pfn
>>    * @pfn: output parameter that returns an absolute pfn translation of @pgoff
>>    *
>> @@ -124,7 +125,7 @@ enum dax_device_flags {
>>    * pages accessible at the device relative @pgoff.
>>    */
>>   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>> -               void **kaddr, pfn_t *pfn)
>> +               enum dax_access_mode mode, void **kaddr, pfn_t *pfn)
>>   {
>>          long avail;
>>
>> @@ -138,7 +139,7 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>>                  return -EINVAL;
>>
>>          avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
>> -                       kaddr, pfn);
>> +                       mode, kaddr, pfn);
>>          if (!avail)
>>                  return -ERANGE;
>>          return min(avail, nr_pages);
>> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
>> index 76b486e4d2be..13e263299c9c 100644
>> --- a/drivers/md/dm-linear.c
>> +++ b/drivers/md/dm-linear.c
>> @@ -172,11 +172,12 @@ static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>>   }
>>
>>   static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>>   }
>>
>>   static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
>> index c9d036d6bb2e..06bdbed65eb1 100644
>> --- a/drivers/md/dm-log-writes.c
>> +++ b/drivers/md/dm-log-writes.c
>> @@ -889,11 +889,12 @@ static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
>>   }
>>
>>   static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -                                        long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>>   }
>>
>>   static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
>> index c81d331d1afe..77d72900e997 100644
>> --- a/drivers/md/dm-stripe.c
>> +++ b/drivers/md/dm-stripe.c
>> @@ -315,11 +315,12 @@ static struct dax_device *stripe_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>>   }
>>
>>   static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>>   }
>>
>>   static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>> index 64dd0b34fcf4..8cd5184e62f0 100644
>> --- a/drivers/md/dm-target.c
>> +++ b/drivers/md/dm-target.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/init.h>
>>   #include <linux/kmod.h>
>>   #include <linux/bio.h>
>> +#include <linux/dax.h>
>>
>>   #define DM_MSG_PREFIX "target"
>>
>> @@ -142,7 +143,8 @@ static void io_err_release_clone_rq(struct request *clone,
>>   }
>>
>>   static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          return -EIO;
>>   }
>> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
>> index 5630b470ba42..d74c5a7a0ab4 100644
>> --- a/drivers/md/dm-writecache.c
>> +++ b/drivers/md/dm-writecache.c
>> @@ -286,7 +286,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>>
>>          id = dax_read_lock();
>>
>> -       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
>> +       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, DAX_ACCESS,
>> +                       &wc->memory_map, &pfn);
>>          if (da < 0) {
>>                  wc->memory_map = NULL;
>>                  r = da;
>> @@ -308,8 +309,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>>                  i = 0;
>>                  do {
>>                          long daa;
>> -                       daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
>> -                                               NULL, &pfn);
>> +                       daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i,
>> +                                       p - i, DAX_ACCESS, NULL, &pfn);
>>                          if (daa <= 0) {
>>                                  r = daa ? daa : -EINVAL;
>>                                  goto err3;
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 3c5fad7c4ee6..8258676a352f 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1093,7 +1093,8 @@ static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
>>   }
>>
>>   static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>> -                                long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          struct mapped_device *md = dax_get_private(dax_dev);
>>          sector_t sector = pgoff * PAGE_SECTORS;
>> @@ -1111,7 +1112,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>>          if (len < 1)
>>                  goto out;
>>          nr_pages = min(len, nr_pages);
>> -       ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
>> +       ret = ti->type->direct_access(ti, pgoff, nr_pages, mode, kaddr, pfn);
>>
>>    out:
>>          dm_put_live_table(md, srcu_idx);
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 4aa17132a557..c77b7cf19639 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -239,24 +239,47 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>
>>   /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
>>   __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
>> +               pfn_t *pfn)
>>   {
>>          resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>> -
>> -       if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -                                       PFN_PHYS(nr_pages))))
>> -               return -EIO;
>> +       sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
>> +       unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
>> +       struct badblocks *bb = &pmem->bb;
>> +       sector_t first_bad;
>> +       int num_bad;
>>
>>          if (kaddr)
>>                  *kaddr = pmem->virt_addr + offset;
>>          if (pfn)
>>                  *pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
>>
>> +       if (bb->count &&
>> +               badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
>> +               long actual_nr;
>> +
>> +               if (mode != DAX_RECOVERY_WRITE)
>> +                       return -EIO;
>> +
>> +               /*
>> +                * Set the recovery stride is set to kernel page size because
>> +                * the underlying driver and firmware clear poison functions
>> +                * don't appear to handle large chunk(such as 2MiB) reliably.
>> +                */
>> +               actual_nr = PHYS_PFN(
>> +                       PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
>> +               dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
>> +                               sector, nr_pages, first_bad, actual_nr);
>> +               if (actual_nr)
>> +                       return actual_nr;
>> +               return 1;
>> +       }
>> +
> 
> Similar feedback as Christoph, lets keep this patch just to the simple
> task of plumbing the @mode argument to dax_direct_access() and save
> the logic changes for DAX_RECOVERY_WRITE to a later patch. The idea
> being that in general you want to limit the blast radius of
> regressions so that it simplifies reverts if necessary. If these logic
> changes have a regression then reverting this patch also undoes all
> the other innocent boilerplate plumbing.

Got it, will do.

thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

