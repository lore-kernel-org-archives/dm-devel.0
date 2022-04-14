Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49C8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:57:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-gNDznqoSNeW0KIqKN1LqGQ-1; Wed, 13 Apr 2022 20:57:15 -0400
X-MC-Unique: gNDznqoSNeW0KIqKN1LqGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACC01101AA46;
	Thu, 14 Apr 2022 00:57:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9815B40D1B98;
	Thu, 14 Apr 2022 00:57:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BE1C1940347;
	Thu, 14 Apr 2022 00:57:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A89881940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:57:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 604091457F42; Thu, 14 Apr 2022 00:57:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE2F1457F23
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:57:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AA3D802803
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:57:12 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-y_ZnVTatO0WZwDGiB4BUDQ-1; Wed, 13 Apr 2022 20:57:09 -0400
X-MC-Unique: y_ZnVTatO0WZwDGiB4BUDQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DLZbwu012645; 
 Thu, 14 Apr 2022 00:56:57 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb2pu3pue-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:56:57 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0jkmO029572; Thu, 14 Apr 2022 00:56:56 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fb0k4jd5w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:56:55 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SA2PR10MB4745.namprd10.prod.outlook.com (2603:10b6:806:11b::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 00:56:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 00:56:54 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Thread-Index: AQHYSSYah9+z/rTaSUWMOtmXmhhWK6zrUlAAgANQc4A=
Date: Thu, 14 Apr 2022 00:56:53 +0000
Message-ID: <d248d95b-0b9a-cf33-9fd5-47e74870bc0f@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-3-jane.chu@oracle.com>
 <CAPcyv4iUWLsZRV4StCzHuVUhEsOB5WURD2r_w3L+LEjoQEheog@mail.gmail.com>
In-Reply-To: <CAPcyv4iUWLsZRV4StCzHuVUhEsOB5WURD2r_w3L+LEjoQEheog@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bf510d6-536f-4c6d-0b73-08da1db1aaeb
x-ms-traffictypediagnostic: SA2PR10MB4745:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4745FB2D4004C84BC9519E01F3EF9@SA2PR10MB4745.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: oYlkYZKIVgx+u5Pl7Bdqa2u301hKLBJQaCzw8TDhFOzc72yvx8pQFSbB44fOEtnvilbEVozdxvz4CN65RU/kBv2kAgdDDwE893tMZ1Hi7VHaTI2iq0y+dC3LXiS1wawtG+ioujeM8evC9CkeN/gkBdrP19SdxbOq1WYSMUd8TfcVxFR6QSkcBOp51GSV67pt/m6MgucuJ2bpxRpfcoKnM13krogFDw9ZvCYXSR53yZL7MERDYP6vy9z8Vme9cdNbbjPgg60yCqrvP0AnvN3vf8J9Pb1/0fN9nIzBwPVHaLSuOW7gzfRN5OGofuX51plPx6bdAkYwvvMInL8T+kaOX2EOAuEipUC+7yivBItZlYZKD1XucZ4fvoZ50o/vr4esRWrRd0eBs3X9A0dTrZZtlQbYvP4usjlNZgNs85Iil8Tgqo3m9EmYfmAVvlECdbYf21Ow5i1Mzqu3sVD6Tnk7jRio6g1pQYAvjCiY8EoOdxDa1rWoY2TEa6nHTir64y9gIYO+f7C1wQocJCy6N5gNmm4kGirJS5f4RactUqKFK8c9J8ixSQHssj4GNHRDyp+pLITeBKgXayWyXCIktvhI9Kk2exshppgsFsxN4OltIypJ8w0hwcqTipGBZU6Be2N3DuE8I21MwByuOG0WV8LxBN6yL8djmoS5/u9KcC2JpXXZSdGP1TjneSs5aSnBvG2SxMjyUkOonZgOGVR5jGFWuD6QKDj6wx+3oWRLABs6NFloFx3PY7NVf8jscdrjxKnzx4PrToURhqUcUNqq5clI1w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(71200400001)(6506007)(8676002)(66556008)(64756008)(66446008)(66476007)(4326008)(38100700002)(122000001)(6512007)(31686004)(83380400001)(186003)(26005)(2616005)(36756003)(54906003)(316002)(6916009)(2906002)(76116006)(66946007)(53546011)(31696002)(44832011)(6486002)(38070700005)(508600001)(7416002)(5660300002)(86362001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHN6Ym42dmVpa284cVJwOTRGMDYvbUI4ZU9mMGJaR0tCSCtMbDlNb0R2SCtI?=
 =?utf-8?B?clA0dHBxK05rYXoxenRhNTAxVG9lcy9nZWYxbDlvU3lMSExCd3dQR2V5dVE5?=
 =?utf-8?B?MjhmOE5id2lNVkZCRFd2VFhRRUs0Q0ZMdXM2ZStGTVdZNDlmbW53T3owYWdF?=
 =?utf-8?B?empSdVNVRnNpbElKQWl3Mjh3Tk1LZ2Nib1cwbWdKNmp3cTcra0dJY01ndkFM?=
 =?utf-8?B?bFBodVhHTklIc1RsT3hQb3l1YU9QY2llWTgyaDJTV1ZBTU9peDc1ZmxwV2Vy?=
 =?utf-8?B?RlhKTnQ0bWs4VVljbThyTkFwQjBZeGFFZGJmU0toN3ovaDJOeGFybHU0MU9o?=
 =?utf-8?B?djNHdnVxcGMxTEtackZsbXRIZ05mUFN5YzZuazRXR091bU1NckJ5NXpSNXgw?=
 =?utf-8?B?TlVlWk1xVGJpTVgweFhGYWhRMCsxSTJkc2lXdWMxUkV4MU5MTnpEa1lPVVdi?=
 =?utf-8?B?cmtwUlFtNVJxc3NvVnRiZG1xYTA2MzJndHljenBoNXhUYmZIM0laVy9LTnFw?=
 =?utf-8?B?ano1NXp2R0JtZmZNTEpnQ1puOGlxRVVvME8rblVkVEEvSFRQc2ppU2lNdVVl?=
 =?utf-8?B?aEFMVTZ1cjMvUERBZEg5TnpLbVc0cUZZQithK0owL0lqSWlPN1l4U1BsUjdY?=
 =?utf-8?B?T3ByeG50UnJFY0lhZ0J0QWw3elBRQ2V1NzVXQ1RENFJZMnNFYzV5VHQrRU5T?=
 =?utf-8?B?azhlc2FucmFURUhPUnVEQ3dVcnUwK3E3NDVvODBMUkd0NFdPVzZkT0NXczhs?=
 =?utf-8?B?dCsvMFROeEx1ZlBZakhqMGpVOU5rMjNPNVF2WnF4R3Y2UXU1eTNwNm5HRWN0?=
 =?utf-8?B?dy9DcktVOWNiUmhvVG9PQWcxcXdTSUJwcDVMSU9JS2FvQVN4RlA1aXQrcW42?=
 =?utf-8?B?WFZ0NFhLNkFBVVc2alBJclAzOE5FM09JUnVGYkxWcXJacHdQb21hVGVIVHNu?=
 =?utf-8?B?M1hOMWZZY0ZwL2hCZkRaNjJPS2pJQ1pkYlJ0Q2YrRndRd0lrZnpyMDlRMUpU?=
 =?utf-8?B?NDVEeDBZbkZyM3puMm03ZmtNOGYyVkc0WXNWTHpFTGZmS2d1cmF3MERJZ0k1?=
 =?utf-8?B?UTlmRGtWdFlsenhwTkVndUR5alREbDdIcDJXV1U0Qm9ybGkxd3NhekgzYTc3?=
 =?utf-8?B?bU9nTkFibENUaEFTeUFQVXdpdXFqS000aFkxYWNBU3RGWUFWQXBSc0pHMFh6?=
 =?utf-8?B?d1lJcHkwZEFPZjRsRDF6SVNHY203TjBMTnJUYVVTQ3Q1ZTVObVlWZFNrYytG?=
 =?utf-8?B?ZkpyS2VVR1lnWnA5dkhlWktURW5vY3NXRWdWa04vT0dWVzgwUi9vbVM5dUY1?=
 =?utf-8?B?Zk1vYlJWV1VFblhqKzJ5UTM2VXd4c2t3ZDdIcndpWU9PTjhEVGVjNjM3Qnc2?=
 =?utf-8?B?RHpqZTl4SXAwNEhYcUJWbTFUS2pTanJmbW1hdzJxUmxjY0FLWFhVZ0E1TktO?=
 =?utf-8?B?Um80eVZDakxJbUJ4Y2hXMTdwZWY2ZVVkK3d2QVU0WlgwYTltTU9KR0ZXSzB5?=
 =?utf-8?B?VWkzSW5CY0Z4NlA5UUpsdmpMQTZCcEdqaWU3UGt6ZmxISzgramhEOGhFUmpL?=
 =?utf-8?B?WTdrbmp4WXgwSFF2eEp0KzFsQVJISGFxRlR1L2RiRk5wRm9jSVN3ZkFYZHlR?=
 =?utf-8?B?QjRMVEJWRUQ5bDQ4bW42UFBpaTNNQUJWTXdscllyZmlhZ2VOQVFDSUpCbVMv?=
 =?utf-8?B?djlYK2w5Mm9hU0hIT2hLYys3RnNNSGVJbEloRk5WTXJzbWtaVnZPSmc0cElV?=
 =?utf-8?B?Z2FKRTJBd20wS0NnWTZYa1BoWkNTUzYzRXJaSTJUOTlXTEd1QkM3WGJYYk1H?=
 =?utf-8?B?YlJETkpMUTlXOXR5OHR5SHVCL0FXQzR5Z2Jpc1N3VVVHRUVZM1EwU2M4ZHBx?=
 =?utf-8?B?c3RKcEtyYjdHVkVkUUJhTHRaVVhoZEpmRW84cUV2dHN2dmR2aW5WZEd6ajFI?=
 =?utf-8?B?RVdqaDQyNndDMytUdDJEbFFnSzZZN1NkNUN2TTdvajZaMUw4WlYyM3dkaDZh?=
 =?utf-8?B?cEtwNFlyZFQ0dTlKNDdBUCt5eUxZMHUvUHFGMWhYT2hRMEdOb1JIZDNOK1Iv?=
 =?utf-8?B?U1ZFSTZpY3BUVGpmZWxYV3Z5UzZtbWlQazd2ZUlRR1hPRUhOaU43U3R0SFNr?=
 =?utf-8?B?OXNlOXFRUGp4ZXlFN1hGMlhiMHkwZEhyRlBkSjl2SzFRL25jWFFpczBMRktB?=
 =?utf-8?B?WlIrZTlRVm5hK2ZyZGp4dHhnNU1pTG5CMThTVE5MZ3RLMmxabUlkVWNVOTZt?=
 =?utf-8?B?ZCs2bCtUcW9LWVJzVVZZYXBwbW9vOHJBaGlDc1h6QkNyNEprdHhUSlNWdmFG?=
 =?utf-8?B?LzlXaTRWS3F4bHh0elJKcmlDZnJSMnhQd0FmaHBUc3RPQklFMy9kdz09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf510d6-536f-4c6d-0b73-08da1db1aaeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 00:56:53.9669 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /G/bXpT4AH+Wa5iM78Wgb9oYSKXltZPgViAzUJmoUnHFwqLojHjpQWGbmjMNgy00IMkVuTPK6BGtamHm470XKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4745
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140002
X-Proofpoint-ORIG-GUID: K8KM3rh-TzQuhALGsqDE69mO2WOYFktd
X-Proofpoint-GUID: K8KM3rh-TzQuhALGsqDE69mO2WOYFktd
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>,
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
Content-ID: <21622D29443C994EBD5A169B20013E1A@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/2022 3:20 PM, Dan Williams wrote:
> I notice that none of the folks from "X86 MM" are on the cc, added.
> 

Noted, thanks!

> On Tue, Apr 5, 2022 at 12:49 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
>> file where they belong.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   arch/x86/include/asm/set_memory.h | 52 -------------------------------
>>   arch/x86/mm/pat/set_memory.c      | 47 ++++++++++++++++++++++++++++
>>   include/linux/set_memory.h        |  9 +++---
>>   3 files changed, 52 insertions(+), 56 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
>> index 78ca53512486..b45c4d27fd46 100644
>> --- a/arch/x86/include/asm/set_memory.h
>> +++ b/arch/x86/include/asm/set_memory.h
>> @@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
>>
>>   extern int kernel_set_to_readonly;
>>
>> -#ifdef CONFIG_X86_64
>> -/*
>> - * Prevent speculative access to the page by either unmapping
>> - * it (if we do not require access to any part of the page) or
>> - * marking it uncacheable (if we want to try to retrieve data
>> - * from non-poisoned lines in the page).
>> - */
>> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>> -{
>> -       unsigned long decoy_addr;
>> -       int rc;
>> -
>> -       /* SGX pages are not in the 1:1 map */
>> -       if (arch_is_platform_page(pfn << PAGE_SHIFT))
>> -               return 0;
>> -       /*
>> -        * We would like to just call:
>> -        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
>> -        * but doing that would radically increase the odds of a
>> -        * speculative access to the poison page because we'd have
>> -        * the virtual address of the kernel 1:1 mapping sitting
>> -        * around in registers.
>> -        * Instead we get tricky.  We create a non-canonical address
>> -        * that looks just like the one we want, but has bit 63 flipped.
>> -        * This relies on set_memory_XX() properly sanitizing any __pa()
>> -        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
>> -        */
>> -       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>> -
>> -       if (unmap)
>> -               rc = set_memory_np(decoy_addr, 1);
>> -       else
>> -               rc = set_memory_uc(decoy_addr, 1);
>> -       if (rc)
>> -               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>> -       return rc;
>> -}
>> -#define set_mce_nospec set_mce_nospec
>> -
>> -/* Restore full speculative operation to the pfn. */
>> -static inline int clear_mce_nospec(unsigned long pfn)
>> -{
>> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
>> -}
>> -#define clear_mce_nospec clear_mce_nospec
>> -#else
>> -/*
>> - * Few people would run a 32-bit kernel on a machine that supports
>> - * recoverable errors because they have too much memory to boot 32-bit.
>> - */
>> -#endif
>> -
>>   #endif /* _ASM_X86_SET_MEMORY_H */
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 38af155aaba9..93dde949f224 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
>>   }
>>   EXPORT_SYMBOL(set_memory_wb);
>>
>> +#ifdef CONFIG_X86_64
> 
> It seems like the only X86_64 dependency in this routine is the
> address bit 63 usage, so how about:
> 
> if (!IS_ENABLED(CONFIG_64BIT))
>      return 0;
> 
> ...and drop the ifdef?

Sure.

> 
> Other than that you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

