Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25431C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 23:37:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-fShUdC4xMimedfse8uX6aw-1; Wed, 13 Apr 2022 19:37:01 -0400
X-MC-Unique: fShUdC4xMimedfse8uX6aw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4377E29DD9AF;
	Wed, 13 Apr 2022 23:37:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75FB84047780;
	Wed, 13 Apr 2022 23:36:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABBBB1940347;
	Wed, 13 Apr 2022 23:36:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 481E91940345
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 23:36:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1993E4047780; Wed, 13 Apr 2022 23:36:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1450940D282B
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 23:36:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E3980005D
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 23:36:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-4PAlJArnMI6F4vzzmi3gCA-1; Wed, 13 Apr 2022 19:36:49 -0400
X-MC-Unique: 4PAlJArnMI6F4vzzmi3gCA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DNXxnv018439; 
 Wed, 13 Apr 2022 23:36:19 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1kf9r-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 13 Apr 2022 23:36:19 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23DNZvOb022672; Wed, 13 Apr 2022 23:36:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fb0k4h3yw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 13 Apr 2022 23:36:17 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CY4PR10MB1592.namprd10.prod.outlook.com (2603:10b6:903:27::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 23:36:15 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 23:36:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 3/6] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Index: AQHYSSYcmxaMmXFgxUqypAmHkAJB9qzrZR4AgAMnHoA=
Date: Wed, 13 Apr 2022 23:36:15 +0000
Message-ID: <b511a483-4260-656a-ab04-2ba319e65ca7@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
 <CAPcyv4jx=h+1QiB0NRRQrh1mHcD2TFQx4AH6JxnQDKukZ3KVZA@mail.gmail.com>
In-Reply-To: <CAPcyv4jx=h+1QiB0NRRQrh1mHcD2TFQx4AH6JxnQDKukZ3KVZA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de2c6eb-0df0-4504-9a5b-08da1da66714
x-ms-traffictypediagnostic: CY4PR10MB1592:EE_
x-microsoft-antispam-prvs: <CY4PR10MB1592A42E0B194847E1CC6710F3EC9@CY4PR10MB1592.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3zgJmHfMitlPdjAlWpp0CFN7cQPLVrFeOWUSV5vgllHQsgMd21zkPILVZa76A0iaapZljZDT3fkicRsS4zh1ciNPsLxV2t+AmmQwiNfSdOGJqYvvtbYtrgXSb0N3851jJh/9KJA8mg2o64lTefXlxKp+5ixE/hV0Ru2TqUSA89DT0cCrolCRqft5SDfpEznB8iliRfdDX8WiPY7RcePx2JO48Qfi6gz23Dd0/JHgsQgQhxnzG1ltgp3gGhyBz9YM3MND9GMPx37gqCnDZNmzJYKKYpak6baenOgERxuvKM/914smwkdIKABUR/5OWiKLnti07wqbOir4/Or2oiOCR2P0WkacMItwjZv1x01QhfLUpifPIYdR94QisLZl1HIYSed7tWd6RK8PS/uyNRK4CTdQPRUBL4s1ismtjUzG+ZaoqXrxUrWUE/e8lIRZo6VxvVQG/ir/Z9zErgmGMdfOvv0AJvWa2ZxqlevvrMo3RaQ0AIolA4UFzrNIouAZLIHBzGufptciHZY7jNvJTExKcybZ4Wt60WTs6snqRUT6gGQOLwy0o302ctHewYTGBXIRxr33OMI1HcJDhCbnvPDZ+Mp1OENuIy+1BP6Wxb2wdKprt12zzvMx/VAiAOagfypR6B5wyeMNVTM/Gxr1tbGh7s/8mCJGdvHKVSrd2hw41JjFnqkgx5WQI154gnBt2voF/5hB+S7EOjn7O9nBbGux1yNiZFw7Vjgu8xiXnXHUz+hc5YW+MI+uF2S++BhPTqPstrNnwdjWl10vZA5cIjQTAv7P4gQHUnABDG2aLDF8Vr1t+vF+T7dr3f/v98uakgum1IBSWah9yO4i208U6iiDiJijEbzhxDwI9murf2V49J4JUINFPsjsRrba+pQKYeku
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(122000001)(83380400001)(38100700002)(5660300002)(7416002)(76116006)(31696002)(4326008)(8676002)(316002)(66946007)(186003)(64756008)(66556008)(66446008)(66476007)(86362001)(91956017)(26005)(2616005)(36756003)(6916009)(54906003)(6486002)(966005)(38070700005)(31686004)(508600001)(8936002)(2906002)(6506007)(53546011)(6512007)(71200400001)(44832011)(21314003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDA0Z2tqYnlOenNTaGw4bE5CaVlTV3Q5N3ZXQUw5aERVMVB6S01YTS8xYm0z?=
 =?utf-8?B?K293OXcyUUhZODFjaWxvTmQxRUxqMFk2RXZxcE1tZ3JRbFZnN2dCSUx4Tjkx?=
 =?utf-8?B?UitISUl5MnFTSklqdXZvU05zQmhTSkwyR1VTZkFUVGFsa1ljQmx4NENiMi9C?=
 =?utf-8?B?eURQODJQTUg2YW91TE43UlJXL3RBc2VwYlB5WEdWeG5mK0pQM2xtb2hOM0U1?=
 =?utf-8?B?NitmM0FaVjRsV0U2MElJbFBSNzFGQi91VmFMRVBYK3ZBK0lheTEzaWk3cXNT?=
 =?utf-8?B?dmJvQytkZlk4aXJyNGZpamxHY1JXdkliYm1nSUJNSzUvMUNkaEsyVFNJV1Ns?=
 =?utf-8?B?T2hrQkRCWStEZ0hxS1FzY1NBMEhXL0haenk2eTlYbkI2ckltNm1sVlFHaDFT?=
 =?utf-8?B?bkJkV29DZ002b0QxYVZMR1lJV2hCUTlvLzRBQ3ZFdG1mYnA1dGFQRTM5MHlY?=
 =?utf-8?B?MUVEZkd1cFZPbkp1b1BxRitRZnBONlIzeDNuQWQzNTlZU3laekxaNHY5TS9F?=
 =?utf-8?B?eTFWcDNvR2RwdytpdkF6YW0xMFpsMlp5bE8wUjFXaGYrdUFVcTB4cFJqZzVX?=
 =?utf-8?B?SW5RcS9iUGNpOU45K3NkZVZvekZjMml6Vk1acHlPc0JBZmhqUGJaNkJ4eHR5?=
 =?utf-8?B?UkZxMGhpSWNPVUlBNTJoQkJnRVpJeXlWaFNVWm9BOWs0V2tXVWlCYkl3bVVk?=
 =?utf-8?B?aEpnRFRRRzZLU0pYVTFwY1pQWi9qMU9ZR0x2bksxUjF3MjJCYzFZbGVBaU1C?=
 =?utf-8?B?NFZVeWdHTUJzeDJVeTROUEl6NEtRYnQvN0lBRlB2cU9MbkRmSUtxWnpHMVFk?=
 =?utf-8?B?b1l5TjlDNjNoMzcyemt3OU1BcStoeENCU3ZhOTBpd0J2ajY0cHVVbUdWc3lj?=
 =?utf-8?B?ZnBqR1MvODZpeGJSL0lTYThEdWdYSUFRdXdjVVZuZnZMNGFTdFphNERJYXpH?=
 =?utf-8?B?ckE5bSs1dldEWFBxNWwySnB4L0c2cVFCZit4Y3labzRacFZER3pySnBuWDZp?=
 =?utf-8?B?OUh3UzBmc3VSRTNYYUxTNnp0eHJpNDJWTmZDN1dzYXZHN2ovckUwRnY0Z1J4?=
 =?utf-8?B?Y1ZETnRGZ2grQzUvT2JxYXgzZEhrdFhzT1RrUzVReUpvMTFaV29qWGlsUEp6?=
 =?utf-8?B?emViYVUwQUJOL1RFNTRZK0dXYVhnQUlkMHdlMkdVNW5VNnhZcGFsU3BqNlc3?=
 =?utf-8?B?aW8rbnlFWm9FcEh6bHFGdEtUc0o0dnNnN05vaW5sb0ZCVXNJMVQ5YmJzZmJF?=
 =?utf-8?B?dE51V3R1cVZMUURQZlpxYVpqV3Z6bkc0S2xrYm1FY0RQaVM5Njk3d1hrZzJH?=
 =?utf-8?B?RldERVptQ3l6d0ttMVIvaHpSN0RPanhSdlMvNEhIT3kvb3pORVFSU1VmazVi?=
 =?utf-8?B?VEVEZFZHR3RHZ0I2KzFhUU82YnNFSDB6ekkySU0vcm52aUZsZVIyY1BRamhE?=
 =?utf-8?B?Y0R0ODdFSVIvNldyZTl2Q2NvR1ZzOW5HV3lXRFlYajNQeCtqcEdiT3FZZHJu?=
 =?utf-8?B?dGRVSnFiN1g1bG4raWI1U291MmdIUDE3dEF2T1ZTQ3RtbkxORFVJY2MrY24r?=
 =?utf-8?B?OFNSSTJYV0VmcDNCU3dNQm14aUNMVmlBZFV1KytOSVdhenBFVnR0dnpvbWpY?=
 =?utf-8?B?RzM3dDNVc3E5S0dTWEJmZHRqWUZ4ZGdRZUxsSkpkQkF0dVdYM3Q5VkNycVB0?=
 =?utf-8?B?NlRVUGtiYk5SZXlRamE0dGJUa1hEWXRyMkRzanB0Qi80QWFIQVhHRUlERDFJ?=
 =?utf-8?B?bWwrOWVkK1JwL0RPa0tTT21Sd3JFUCtpcXlDOHl3NlF3Tm8xdEJiOG91anR4?=
 =?utf-8?B?QWJHckJJNW4zZ25uVUk3enYrQVMzOFlkRjBIYmdpdVdOcndSQklWOGhnR0dl?=
 =?utf-8?B?UXFJZmF4M3R4ME5iaHMzczVwL2huK2V3QytCcVJMbk55YlZ1MytzSE1jcU5X?=
 =?utf-8?B?eHdMK1B5LzUrWU5vVlFIR1NtYVdZSnFOTVVyeHZyN0E1cTZJeUVIMWtSeTFx?=
 =?utf-8?B?c3J0UzRydWRTd1VDdzBpK3kyVUJ0V0RHUTNtcG9tK3hzVVl6RVo1R2tMVzhB?=
 =?utf-8?B?R1Z1SWllZ0JLT2N3MWY1dzFJOEhQOGJGbXhWVTRpdjE4YXB4UGJQMk1Rdk4x?=
 =?utf-8?B?MDBNYmtlZjRRcTUvV1B2Ri9Ga0sxWHBUWXUwdjZIUkcvM3lxdlFLM3h5L05V?=
 =?utf-8?B?YzdiM2pucnlTeG5ZNGhoWFlBSSs2bGR5bXd1Vzc5N05YMm5uaWxBL2FLNEhH?=
 =?utf-8?B?T3hoYnpnTEFhdXBxV1JxblI5M2plVTdwbklPa2w5bC9sL0pjNWdjSkIzWUhT?=
 =?utf-8?B?N0JxRmc5VkFSb2RSM3E4VVNXUEppWENUSTZScU15bEtaTi9aWURndz09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de2c6eb-0df0-4504-9a5b-08da1da66714
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 23:36:15.6745 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IqOuBzI4+d4+Kb8QjTxqVOL0PpPXXV0FeVJeqkUPCYdgnODYa81wMQL0mopV2ENmaCdFM03LALZfAfs130+eyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1592
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130111
X-Proofpoint-GUID: RBI3M7l52sEwW7et-VtyoInQEKqL8Xct
X-Proofpoint-ORIG-GUID: RBI3M7l52sEwW7et-VtyoInQEKqL8Xct
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 "dave.hansen@intel.com" <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FB540957D122794AAA29E755CC968372@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/2022 4:27 PM, Dan Williams wrote:
> On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> The set_memory_uc() approach doesn't work well in all cases.
>> For example, when "The VMM unmapped the bad page from guest
>> physical space and passed the machine check to the guest."
>> "The guest gets virtual #MC on an access to that page.
>>   When the guest tries to do set_memory_uc() and instructs
>>   cpa_flush() to do clean caches that results in taking another
>>   fault / exception perhaps because the VMM unmapped the page
>>   from the guest."
>>
>> Since the driver has special knowledge to handle NP or UC,
> 
> I think a patch is needed before this one to make this statement true? I.e.:
> 
> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
> index ee8d9973f60b..11641f55025a 100644
> --- a/drivers/acpi/nfit/mce.c
> +++ b/drivers/acpi/nfit/mce.c
> @@ -32,6 +32,7 @@ static int nfit_handle_mce(struct notifier_block
> *nb, unsigned long val,
>           */
>          mutex_lock(&acpi_desc_lock);
>          list_for_each_entry(acpi_desc, &acpi_descs, list) {
> +               unsigned int align = 1UL << MCI_MISC_ADDR_LSB(mce->misc);
>                  struct device *dev = acpi_desc->dev;
>                  int found_match = 0;
> 
> @@ -63,8 +64,7 @@ static int nfit_handle_mce(struct notifier_block
> *nb, unsigned long val,
> 
>                  /* If this fails due to an -ENOMEM, there is little we can do */
>                  nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
> -                               ALIGN(mce->addr, L1_CACHE_BYTES),
> -                               L1_CACHE_BYTES);
> +                                       ALIGN(mce->addr, align), align);
>                  nvdimm_region_notify(nfit_spa->nd_region,
>                                  NVDIMM_REVALIDATE_POISON);
> 

Dan, I tried the above change, and this is what I got after injecting 8 
back-to-back poisons, then read them and received  SIGBUS/BUS_MCEERR_AR, 
then repair via the v7 patch which works until this change is added.

[ 6240.955331] nfit ACPI0012:00: XXX, align = 100
[ 6240.960300] nfit ACPI0012:00: XXX, ALIGN(mce->addr, 
L1_CACHE_BYTES)=1851600400, L1_CACHE_BYTES=40, ALIGN(mce->addr, 
align)=1851600400
[..]
[ 6242.052277] nfit ACPI0012:00: XXX, align = 100
[ 6242.057243] nfit ACPI0012:00: XXX, ALIGN(mce->addr, 
L1_CACHE_BYTES)=1851601000, L1_CACHE_BYTES=40, ALIGN(mce->addr, 
align)=1851601000
[..]
[ 6244.917198] nfit ACPI0012:00: XXX, align = 1000
[ 6244.922258] nfit ACPI0012:00: XXX, ALIGN(mce->addr, 
L1_CACHE_BYTES)=1851601200, L1_CACHE_BYTES=40, ALIGN(mce->addr, 
align)=1851602000
[..]

All 8 poisons remain uncleared.

Without further investigation, I don't know why the failure.
Could we mark this change to a follow-on task?
The driver knows a lot about how to clear poisons besides hardcoding 
poison alignment to 0x40 bytes.

> 
>> let's mark the poisoned page with NP and let driver handle it
>> when it comes down to repair.
>>
>> Please refer to discussions here for more details.
>> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
>>
>> Now since poisoned page is marked as not-present, in order to
>> avoid writing to a 'np' page and trigger kernel Oops, also fix
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
>>
>> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
>> index 981496e6bc0e..fa67bb9d1afe 100644
>> --- a/arch/x86/kernel/cpu/mce/core.c
>> +++ b/arch/x86/kernel/cpu/mce/core.c
>> @@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
>>
>>          pfn = mce->addr >> PAGE_SHIFT;
>>          if (!memory_failure(pfn, 0)) {
>> -               set_mce_nospec(pfn, whole_page(mce));
>> +               set_mce_nospec(pfn);
>>                  mce->kflags |= MCE_HANDLED_UC;
>>          }
>>
>> @@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
>>
>>          ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
>>          if (!ret) {
>> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
>> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>>                  sync_core();
>>                  return;
>>          }
>> @@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
>>          p->mce_count = 0;
>>          pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
>>          if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
>> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
>> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>>   }
>>
>>   static void queue_task_work(struct mce *m, char *msg, void (*func)(struct callback_head *))
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 93dde949f224..404ffcb3f2cb 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -1926,13 +1926,8 @@ int set_memory_wb(unsigned long addr, int numpages)
>>   EXPORT_SYMBOL(set_memory_wb);
>>
>>   #ifdef CONFIG_X86_64
>> -/*
>> - * Prevent speculative access to the page by either unmapping
>> - * it (if we do not require access to any part of the page) or
>> - * marking it uncacheable (if we want to try to retrieve data
>> - * from non-poisoned lines in the page).
>> - */
>> -int set_mce_nospec(unsigned long pfn, bool unmap)
>> +/* Prevent speculative access to a page by marking it not-present */
>> +int set_mce_nospec(unsigned long pfn)
>>   {
>>          unsigned long decoy_addr;
>>          int rc;
>> @@ -1954,10 +1949,7 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
>>           */
>>          decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>>
>> -       if (unmap)
>> -               rc = set_memory_np(decoy_addr, 1);
>> -       else
>> -               rc = set_memory_uc(decoy_addr, 1);
>> +       rc = set_memory_np(decoy_addr, 1);
>>          if (rc)
>>                  pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>>          return rc;
>> @@ -1966,7 +1958,9 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
>>   /* Restore full speculative operation to the pfn. */
>>   int clear_mce_nospec(unsigned long pfn)
>>   {
>> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
>> +       unsigned long addr = (unsigned long) pfn_to_kaddr(pfn);
>> +
>> +       return change_page_attr_set(&addr, 1, __pgprot(_PAGE_PRESENT), 0);
> 
> This probably warrants a set_memory_present() helper.

I had a set_memory_present() helper in an earlier version, but as there 
is no other caller, also if I'm not mis-remembering, thought Christoph 
had suggested to simplify the code and I agreed.  If you feel strong 
about adding the helper back, I can do that to improve readibility.

> 
>>   }
>>   EXPORT_SYMBOL_GPL(clear_mce_nospec);
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 58d95242a836..30c71a68175b 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -158,36 +158,19 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>>                          struct page *page, unsigned int page_off,
>>                          sector_t sector, unsigned int len)
>>   {
>> -       blk_status_t rc = BLK_STS_OK;
>> -       bool bad_pmem = false;
>>          phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
>>          void *pmem_addr = pmem->virt_addr + pmem_off;
>>
>> -       if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
>> -               bad_pmem = true;
>> +       if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
>> +               blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);
>>
>> -       /*
>> -        * Note that we write the data both before and after
>> -        * clearing poison.  The write before clear poison
>> -        * handles situations where the latest written data is
>> -        * preserved and the clear poison operation simply marks
>> -        * the address range as valid without changing the data.
>> -        * In this case application software can assume that an
>> -        * interrupted write will either return the new good
>> -        * data or an error.
>> -        *
>> -        * However, if pmem_clear_poison() leaves the data in an
>> -        * indeterminate state we need to perform the write
>> -        * after clear poison.
>> -        */
>> +               if (rc != BLK_STS_OK)
>> +                       pr_warn_ratelimited("%s: failed to clear poison\n", __func__);
> 
> This should be either "dev_warn_ratelimited(to_dev(pmem), ...", or a
> trace point similar to trace_block_rq_complete() that tells userspace
> about adverse I/O completion results.
> 
> However, that's probably a discussion for another patch, so I would
> just drop this new addition for now and we can discuss the logging in
> a follow-on patch.

Okay, drop the warning message.  If the unexpected pathological scenario 
happens, user will see I/O failure.

> 
> 
>> +                       return rc;
>> +       }
>>          flush_dcache_page(page);
>>          write_pmem(pmem_addr, page, page_off, len);
>> -       if (unlikely(bad_pmem)) {
>> -               rc = pmem_clear_poison(pmem, pmem_off, len);
>> -               write_pmem(pmem_addr, page, page_off, len);
>> -       }
>> -
>> -       return rc;
>> +       return BLK_STS_OK;
>>   }
>>
>>   static void pmem_submit_bio(struct bio *bio)
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index d6263d7afb55..cde2d8687a7b 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -43,10 +43,10 @@ static inline bool can_set_direct_map(void)
>>   #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>>
>>   #ifdef CONFIG_X86_64
>> -int set_mce_nospec(unsigned long pfn, bool unmap);
>> +int set_mce_nospec(unsigned long pfn);
>>   int clear_mce_nospec(unsigned long pfn);
>>   #else
>> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>> +static inline int set_mce_nospec(unsigned long pfn)
> 
> Looks like after this change the "whole_page()" helper can be deleted
> and the ->mce_whole_page flag in the task_struct can also go, right?
> In a follow-on of course.

Okay, will do in a follow-on patch.

> 
> Other than those small issues, this looks good!

thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

