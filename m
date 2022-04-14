Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC67FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:51:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-OxoxKXWbMdWfEj0mg3DKug-1; Wed, 13 Apr 2022 20:51:14 -0400
X-MC-Unique: OxoxKXWbMdWfEj0mg3DKug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 900773811A28;
	Thu, 14 Apr 2022 00:51:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7692D7774;
	Thu, 14 Apr 2022 00:51:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3898D1940347;
	Thu, 14 Apr 2022 00:51:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 760541940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:51:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F73041373D; Thu, 14 Apr 2022 00:51:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49FDB416162
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:51:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 291AD80005D
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:51:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-xiDKw6PfMhybumAUXqrgnw-1; Wed, 13 Apr 2022 20:51:07 -0400
X-MC-Unique: xiDKw6PfMhybumAUXqrgnw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DLLWRO006846; 
 Thu, 14 Apr 2022 00:50:56 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rsbhwp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:50:55 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0looD012732; Thu, 14 Apr 2022 00:50:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fb0k4xsj9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:50:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3462.namprd10.prod.outlook.com (2603:10b6:a03:121::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 00:50:52 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 00:50:52 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYSSYdGKTdETDbkEmdZR/SZY7Ic6zrcIqAgAMwiYA=
Date: Thu, 14 Apr 2022 00:50:51 +0000
Message-ID: <51d90176-4b5c-c5db-bab9-e05b88c049f7@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <CAPcyv4ij8VxaeosTsRFgUTnSpRRaxWnxWK6xvUJrhmT-7ae+-Q@mail.gmail.com>
In-Reply-To: <CAPcyv4ij8VxaeosTsRFgUTnSpRRaxWnxWK6xvUJrhmT-7ae+-Q@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75f16486-e502-4516-88f8-08da1db0d322
x-ms-traffictypediagnostic: BYAPR10MB3462:EE_
x-microsoft-antispam-prvs: <BYAPR10MB346251CD5C9ADB80ED963CFCF3EF9@BYAPR10MB3462.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MmS+0tvlch6zzXQuXvdrjJ/TrB+AB863I8NuK+TAcxEM9NdIinGYkczBJhKMUC1QEzl8alIPIWzG94oR3wibXQVVRrQ5KnTtasqG8/zuRF0GAh03XNTxq9C7JiLTL+PbmM8T2paWGKYZPWsTukV1Fc1D3ukJ2lUZgZN1cELMM8i90a+fh/tarwPRdw2Ml2OVRDUEPK/g87GyHQ7XYoD90CcH/aZe79GxLJ1fq5/xStUezhagocb3LbNTPZVSVddLw4Tsacoa3wmp1XK2cVGH8cBsYtpzYoCHnZWHBmAGU39ATPJaCzRNhWBAz3CW7zWgKgh6uH/31pUgzR6INQyW9Qs6OB/D121vievPTBJu4oaVpLxLUoLXWDrdsz1zLbP6u4YxeUgvo//QSc0Wk70TAuvP/xxO19BqI33eTDtDtvDP38tRfWvMbc0gxQWvZnkno4c+UqG5xRacT3u5cyOdh1TlEAooPFFBSKXdCK+cngOszc5LN0fVIt229fTl0SVtS2qGA6VusaqxxP3A+HyX0XHoipy3nmq8nMWzoqm+4YkqnHrBmfHh24yLOiWXzan8XThg2PivcgSsislHbIZSUP9Mrw6H0obn+W96f8FUNmFflod0yAO22XnA7rS3XeNB9LcbvRh7bwelhFRjBl/YsWXatheQkgGy/CCMr29LrzliwrKGpGM9q9HJqImFS/funb/IMz1T/jh/8tMZMfG9Q3+KWRBS2NNVibm/UDiOA8tBqgEms1cQEF8q3rQ5NYevgGX7DxBNzovT7IwrNmy3/qPcAmW4B+CYeVs3UmH6zoPVw/yCXGfR2nskVRdCGsGaX6iqUYsgD8eUXnosWmBUsg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6512007)(316002)(91956017)(86362001)(2906002)(30864003)(53546011)(31696002)(8676002)(64756008)(66446008)(66476007)(66556008)(71200400001)(36756003)(4326008)(66946007)(76116006)(31686004)(6916009)(54906003)(7416002)(6506007)(38100700002)(6486002)(5660300002)(8936002)(508600001)(44832011)(2616005)(38070700005)(83380400001)(186003)(26005)(122000001)(142923001)(43740500002)(45980500001)(309714004);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnV4UGRXa1NBNU5zTC9NL0tFclB3bzF5WnIyandLelVCdWRhaFlJdGl3UTdL?=
 =?utf-8?B?MWs2NFlLaXFmd3ZOT0NrRFFDVVJjUjRFTFVkeUY3cXY3QjR0aGw5V0IwQ0NB?=
 =?utf-8?B?bExQRFRLVHByRWtKWmlsOE5ienJwRHkrVWo1TWFORWJBU0Jrd0lCUUErcTNu?=
 =?utf-8?B?VGk4RzRaL1dUUGhqeUZiSnNhWFlkalFuOGlmQ3Z1YkdZM0NDL0R6R1huM2Z2?=
 =?utf-8?B?SmxGbWo4bUxkVGVoRHZRam5ZazE2NWg4MVR4UFoxNzcwNmxZaVBUeUEwaHRl?=
 =?utf-8?B?MXFvY3NzK2JPWE82ZVQ2WHliT29XM3Q4amxCUFJ6TmUvM1FWRTVZdTdRSFFE?=
 =?utf-8?B?T1dLT0p4SXV1YzlsL1lyaW4yT1dsYys1MjNnbU5XRS9CcDlzZlFqcVI1WW9y?=
 =?utf-8?B?Rmp1bU54Vit1YWVxTTA3MDZmS21wNkMzc25na3hFSGViTHNIZDZ4ZFNtRTgr?=
 =?utf-8?B?RVpKTTkwbGhaTU5sMTBoVC80eld4cmFockFqUEhxbTcyNkFVbzBPNXV0WHpO?=
 =?utf-8?B?RFlNRGVPTWtxS215c3pIOHV4c2owSWR0L3FORzBUSERTbVB6aFJZRlpqR2M3?=
 =?utf-8?B?eHFROTNkbU9oZkpmWmRZbHZaQkFBdGJ0QUhNQXJxZGVDcTBReVJoVzZrQ3pm?=
 =?utf-8?B?LzlNMlNuaTJVRFp5bFpTSG1BeXA1alBCS0ZXd3RrS1dQb0Y2RStvMXdhT2ZH?=
 =?utf-8?B?UHNUOE5GSnhabHhFNDZMSlZrMmRvNmN0SlYwalREZ0ZnWTdIWE9EakZESWh2?=
 =?utf-8?B?b3RPMlpSNjZNMEpUdkFzOEM3NmpkcFl5bnFDU3h1SHZZQXNvR0ZnTnNDVFdq?=
 =?utf-8?B?YnFuaDYyUFpjQUtEKzN6ZUVRY3QwYTk5ZGxUQkdjb0tOck4xWVJLNkppenN4?=
 =?utf-8?B?eFNFcG5FS0xUMldaeVprSm1vT2gxaFNOa3pCN3BOZko3Q1ppVGRRWFlJWjBW?=
 =?utf-8?B?d2hYMUVyTWdFZjJFK09xYk1SV3BGQWZENWVlOTdoVXV1dDdxQ0dveFBMRHFu?=
 =?utf-8?B?QmJYd0VsTU9tSmJZeDZyUXhPS1p6eVBpWUt0N0tTYkdjREVFN29Memx6ak52?=
 =?utf-8?B?TUdDUW1SZThrblRwWW4zcXVSR0NxRlRzYXREQW5VbzVTVXJNbGkxR2hUbW9v?=
 =?utf-8?B?ZW5GdE5JU1ZnZEpUNGU2YnRVTHM4ZUxQaXBvY1FIN3o1VE8zaEFFR2p2ZVBr?=
 =?utf-8?B?ZjlRY0xMbzMrSEsydXc3Qis5b0xVUWNBTmZJRE5UQks0aTZRRzlFbE5vYUg2?=
 =?utf-8?B?Wk1oOXR2bndWZU83M1o5WlJqMGdoR3VrRXJxUEppQmNqYUs5UmtWWXR5bTZQ?=
 =?utf-8?B?RjNYMUlMVHdlOS84SytzelRybzFPdnp0SDdQSU1LVUE0SkUvQXIyTE1jRXho?=
 =?utf-8?B?cnVjajBpd3lSQ1dWTzN2YldhM05hMHErcjNvU1R1Ti9TU0pDQWdZcUFXSUNs?=
 =?utf-8?B?ZHIzV3FhNWJnK2NaL2lta0lFRVlYV3FXMnYzRmJpUmJNS0p1QTB1di9aaEZl?=
 =?utf-8?B?YWVGZGE1cUhrMmdkQnFWMWE1ZUNjN2tNZ245R1JvMlpnRys5bHRnY3E2M1hn?=
 =?utf-8?B?WVBhT3lnYnQrZ3IremdsTDF3WEhWMzZ5dS9hM3JVUHNvVm9JdUJYT29xeDB5?=
 =?utf-8?B?NmMvazJuNWk0T1FOaTVLNE14WTZrU1loS2xoekJQVDVpN0ltY2hXanNHQjlv?=
 =?utf-8?B?RU9qb1QxbkhPN1IzQnBMdFRmWWwwU2lUVVcvbGdLUUF2OW9rTlo3Yk4wbUd5?=
 =?utf-8?B?L2ZYMlJ0cXVFS2FiQUhIRHA5NEZCZ3MxVkwzdXNOVkRheWdDRC80V2MrOVNh?=
 =?utf-8?B?VDUxeWE0SWVvcmRNOW0wbFdNMVdEZnhwMm5yS0Rtelh5QW5sNGUzNHZ2dlhp?=
 =?utf-8?B?dDIyMExKWEVJbTVVNUlrdm5pckFJcXVHT0lnUzRXMmdiaWdFQW1zcDR1b2wv?=
 =?utf-8?B?MjgycW1EenB1OTVXdHVQYWxZZTNMb3JtRzNDZTRYK3ZaTEc1QTFrRG9yZjk1?=
 =?utf-8?B?OFNZSzFMTzlvNlYxYS9nVHBqR2hVYnN4YVFqa3hqVGRVWCtYZEJKZFVpaE9y?=
 =?utf-8?B?eU1kcmdvNVVoZGh5T3pQQ040bm5LWHdQYnpHNzNIaTFVa3N1WDc5b1ZNWlJJ?=
 =?utf-8?B?WEFBbGFhaHA4Um1zV0RDNFZ3dXd0Si9CcFRpU1B4bVJoWXBLWHRYdFNuUkhH?=
 =?utf-8?B?L2FmZ2JxT0d0TFVvNGNqdjFkNzROSUFKRFhRbThDQzNjVUZRdFNxZGJqY3pj?=
 =?utf-8?B?QWpVSWdQVVgzMnl1WXFiWUQ2WWxJV21RL2dIZVBMR2Q1ejVlalJ5YVprTzdR?=
 =?utf-8?B?bFYra0VWaVplTzM4LzJPSDk5TUoyQnV1dEI3WTl5K2R2N09jZFp0UT09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f16486-e502-4516-88f8-08da1db0d322
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 00:50:51.9271 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fk2ZxlKSdtcnO6+UD7G/2NR+zdxG7uo4bQr1Y2VbJdfZYAKEZX6GZOHOirDlKq6UCN8SYuEdL+uVDZK+OTlh6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3462
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140002
X-Proofpoint-ORIG-GUID: m2ArhstpqARsTpe2Abyo0ZEB91-MuH6q
X-Proofpoint-GUID: m2ArhstpqARsTpe2Abyo0ZEB91-MuH6q
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <85CBC7C848E772439354969E43314673@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/2022 5:08 PM, Dan Williams wrote:
> On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
>> not set by default in dax_direct_access() such that the helper
>> does not translate a pmem range to kernel virtual address if the
>> range contains uncorrectable errors.  When the flag is set,
>> the helper ignores the UEs and return kernel virtual adderss so
>> that the caller may get on with data recovery via write.
>>
>> Also introduce a new dev_pagemap_ops .recovery_write function.
>> The function is applicable to FSDAX device only. The device
>> page backend driver provides .recovery_write function if the
>> device has underlying mechanism to clear the uncorrectable
>> errors on the fly.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/dax/super.c             | 17 ++++++++--
>>   drivers/md/dm-linear.c          |  4 +--
>>   drivers/md/dm-log-writes.c      |  5 +--
>>   drivers/md/dm-stripe.c          |  4 +--
>>   drivers/md/dm-target.c          |  2 +-
>>   drivers/md/dm-writecache.c      |  5 +--
>>   drivers/md/dm.c                 |  5 +--
>>   drivers/nvdimm/pmem.c           | 57 +++++++++++++++++++++++++++------
>>   drivers/nvdimm/pmem.h           |  2 +-
>>   drivers/s390/block/dcssblk.c    |  4 +--
>>   fs/dax.c                        | 24 ++++++++++----
>>   fs/fuse/dax.c                   |  4 +--
>>   include/linux/dax.h             | 11 +++++--
>>   include/linux/device-mapper.h   |  2 +-
>>   include/linux/memremap.h        |  7 ++++
>>   tools/testing/nvdimm/pmem-dax.c |  2 +-
>>   16 files changed, 116 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
>> index 0211e6f7b47a..8252858cd25a 100644
>> --- a/drivers/dax/super.c
>> +++ b/drivers/dax/super.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/uio.h>
>>   #include <linux/dax.h>
>>   #include <linux/fs.h>
>> +#include <linux/memremap.h>
>>   #include "dax-private.h"
>>
>>   /**
>> @@ -117,6 +118,7 @@ enum dax_device_flags {
>>    * @dax_dev: a dax_device instance representing the logical memory range
>>    * @pgoff: offset in pages from the start of the device to translate
>>    * @nr_pages: number of consecutive pages caller can handle relative to @pfn
>> + * @flags: by default 0, set to DAX_RECOVERY to kick start dax recovery
>>    * @kaddr: output parameter that returns a virtual address mapping of pfn
>>    * @pfn: output parameter that returns an absolute pfn translation of @pgoff
>>    *
>> @@ -124,7 +126,7 @@ enum dax_device_flags {
>>    * pages accessible at the device relative @pgoff.
>>    */
>>   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>> -               void **kaddr, pfn_t *pfn)
>> +               int flags, void **kaddr, pfn_t *pfn)
>>   {
>>          long avail;
>>
>> @@ -137,7 +139,7 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>>          if (nr_pages < 0)
>>                  return -EINVAL;
>>
>> -       avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
>> +       avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages, flags,
>>                          kaddr, pfn);
>>          if (!avail)
>>                  return -ERANGE;
>> @@ -194,6 +196,17 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>>   }
>>   EXPORT_SYMBOL_GPL(dax_zero_page_range);
>>
>> +size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>> +               pfn_t pfn, void *addr, size_t bytes, struct iov_iter *iter)
>> +{
>> +       struct dev_pagemap *pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
>> +
>> +       if (!pgmap || !pgmap->ops || !pgmap->ops->recovery_write)
>> +               return 0;
>> +       return pgmap->ops->recovery_write(pgmap, pgoff, addr, bytes, iter);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_recovery_write);
>> +
>>   #ifdef CONFIG_ARCH_HAS_PMEM_API
>>   void arch_wb_cache_pmem(void *addr, size_t size);
>>   void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
>> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
>> index 76b486e4d2be..9e6d8bdf3b2a 100644
>> --- a/drivers/md/dm-linear.c
>> +++ b/drivers/md/dm-linear.c
>> @@ -172,11 +172,11 @@ static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>>   }
>>
>>   static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, flags, kaddr, pfn);
>>   }
>>
>>   static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
>> index c9d036d6bb2e..e23f062ade5f 100644
>> --- a/drivers/md/dm-log-writes.c
>> +++ b/drivers/md/dm-log-writes.c
>> @@ -889,11 +889,12 @@ static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
>>   }
>>
>>   static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -                                        long nr_pages, void **kaddr, pfn_t *pfn)
>> +                                        long nr_pages, int flags,
>> +                                        void **kaddr, pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, flags, kaddr, pfn);
>>   }
>>
>>   static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
>> index c81d331d1afe..b89339c78702 100644
>> --- a/drivers/md/dm-stripe.c
>> +++ b/drivers/md/dm-stripe.c
>> @@ -315,11 +315,11 @@ static struct dax_device *stripe_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>>   }
>>
>>   static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>>   {
>>          struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>>
>> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>> +       return dax_direct_access(dax_dev, pgoff, nr_pages, flags, kaddr, pfn);
>>   }
>>
>>   static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>> index 64dd0b34fcf4..24b1e5628f3a 100644
>> --- a/drivers/md/dm-target.c
>> +++ b/drivers/md/dm-target.c
>> @@ -142,7 +142,7 @@ static void io_err_release_clone_rq(struct request *clone,
>>   }
>>
>>   static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>>   {
>>          return -EIO;
>>   }
>> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
>> index 5630b470ba42..180ca8fa383e 100644
>> --- a/drivers/md/dm-writecache.c
>> +++ b/drivers/md/dm-writecache.c
>> @@ -286,7 +286,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>>
>>          id = dax_read_lock();
>>
>> -       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
>> +       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, 0,
>> +                       &wc->memory_map, &pfn);
>>          if (da < 0) {
>>                  wc->memory_map = NULL;
>>                  r = da;
>> @@ -309,7 +310,7 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>>                  do {
>>                          long daa;
>>                          daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
>> -                                               NULL, &pfn);
>> +                                               0, NULL, &pfn);
>>                          if (daa <= 0) {
>>                                  r = daa ? daa : -EINVAL;
>>                                  goto err3;
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index ad2e0bbeb559..a8c697bb6603 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1087,7 +1087,8 @@ static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
>>   }
>>
>>   static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>> -                                long nr_pages, void **kaddr, pfn_t *pfn)
>> +                                long nr_pages, int flags, void **kaddr,
>> +                                pfn_t *pfn)
>>   {
>>          struct mapped_device *md = dax_get_private(dax_dev);
>>          sector_t sector = pgoff * PAGE_SECTORS;
>> @@ -1105,7 +1106,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>>          if (len < 1)
>>                  goto out;
>>          nr_pages = min(len, nr_pages);
>> -       ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
>> +       ret = ti->type->direct_access(ti, pgoff, nr_pages, flags, kaddr, pfn);
>>
>>    out:
>>          dm_put_live_table(md, srcu_idx);
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 30c71a68175b..0400c5a7ba39 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -238,12 +238,23 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>
>>   /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
>>   __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> -               long nr_pages, void **kaddr, pfn_t *pfn)
>> +               long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>>   {
>>          resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>> +       sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
>> +       unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
>> +       struct badblocks *bb = &pmem->bb;
>> +       sector_t first_bad;
>> +       int num_bad;
>> +       bool bad_in_range;
>> +       long actual_nr;
>> +
>> +       if (!bb->count)
>> +               bad_in_range = false;
>> +       else
>> +               bad_in_range = !!badblocks_check(bb, sector, num, &first_bad, &num_bad);
> 
> Why all this change. >
>>
>> -       if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -                                       PFN_PHYS(nr_pages))))
> 
> ...instead of adding "&& !(flags & DAX_RECOVERY)" to this statement?
> 
>> +       if (bad_in_range && !(flags & DAX_RECOVERY))
>>                  return -EIO;
>>
>>          if (kaddr)
>> @@ -251,13 +262,26 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>>          if (pfn)
>>                  *pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
>>
>> +       if (!bad_in_range) {
>> +               /*
>> +                * If badblock is present but not in the range, limit known good range
>> +                * to the requested range.
>> +                */
>> +               if (bb->count)
>> +                       return nr_pages;
>> +               return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
>> +       }
>> +
>>          /*
>> -        * If badblocks are present, limit known good range to the
>> -        * requested range.
>> +        * In case poison is found in the given range and DAX_RECOVERY flag is set,
>> +        * recovery stride is set to kernel page size because the underlying driver and
>> +        * firmware clear poison functions don't appear to handle large chunk (such as
>> +        * 2MiB) reliably.
>>           */
>> -       if (unlikely(pmem->bb.count))
>> -               return nr_pages;
>> -       return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
>> +       actual_nr = PHYS_PFN(PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
>> +       dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
>> +                       sector, nr_pages, first_bad, actual_nr);
>> +       return (actual_nr == 0) ? 1 : actual_nr;
> 
> Similar feedback as above that this is more change than I would expect.
> 
> I think just adding...
> 
> if (flags & DAX_RECOVERY)
>     return 1;
> 
> ...before the typical return path is enough.

I plan to use the re-organized code by Christoph - looks cleaner to me.

thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

