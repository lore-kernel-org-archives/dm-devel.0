Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C1BC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:48:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-ocVm2nmlNPeMhmWiS_K0GQ-1; Wed, 13 Apr 2022 20:48:03 -0400
X-MC-Unique: ocVm2nmlNPeMhmWiS_K0GQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95148101AA45;
	Thu, 14 Apr 2022 00:48:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42317111D3CB;
	Thu, 14 Apr 2022 00:48:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCEEB1940347;
	Thu, 14 Apr 2022 00:48:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C4561940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:47:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CA4A400E870; Thu, 14 Apr 2022 00:47:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76D23407F77F
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:47:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A4C6185A79C
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 00:47:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-vITAIV1VOZm0entzk_V-3w-1; Wed, 13 Apr 2022 20:47:55 -0400
X-MC-Unique: vITAIV1VOZm0entzk_V-3w-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DMRAPN032238; 
 Thu, 14 Apr 2022 00:47:38 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jdb56d-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:47:38 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0jpmI040354; Thu, 14 Apr 2022 00:47:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fb0k4s3cd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 00:47:37 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by PH0PR10MB4405.namprd10.prod.outlook.com (2603:10b6:510:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 00:47:35 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 00:47:34 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYSSYdGKTdETDbkEmdZR/SZY7Ic6ziWZ4AgADMqgCAAMiFgIAKsVwA
Date: Thu, 14 Apr 2022 00:47:34 +0000
Message-ID: <65a3e761-d88e-a8dc-d174-29fdc6953b2b@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <Yk0i/pODntZ7lbDo@infradead.org>
 <196d51a3-b3cc-02ae-0d7d-ee6fbb4d50e4@oracle.com>
 <Yk52415cnFa39qil@infradead.org>
In-Reply-To: <Yk52415cnFa39qil@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 429b8166-649c-4642-d25b-08da1db05da7
x-ms-traffictypediagnostic: PH0PR10MB4405:EE_
x-microsoft-antispam-prvs: <PH0PR10MB4405110B0F044B88C2D6AED9F3EF9@PH0PR10MB4405.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: N5q9gte9hNzA4BtCi7UAlI8B+3+XcW147V6zoJKThtIHFWULR8GtFpGa0X+Jo7V+YFGHrs/BpGBIMvAuQgeKvepWFYbmPizW7eewen3nvgGWLJH7aRfaxnjVjkJ1Bpfx8uCryN9o64UhwpclVLOAmZKZNwMUK75mFQ14YADPP5Bwa/YpUajGaRDTQNqAQ7VDf5SjkuXPo5rLRroMPvQH/CSVRwCqOs0xNZOsfvpdbCP9NO1l5tC7Y7RqJZLSm+XrGI59YKmlwh/HvZTPLVsgre8cAte3G3zMtnQ4C2vXCjOybdb7PXDPCW8Lt7z2IzEJcMCGXH6V/AyQWoMSdJ18/XgeBbty/c2DNO6dOKWtJFX/D0TsjeZlGALaJ7GsgxMYIPH354ZrewEfxLpYMVnvj9jFPwpveH9QelLj/oF90efJmXrFjBSGr2+kfHY7aygX6QFQ9ANeFGJ6yfHDetkY5OtnGkqfMammzhsuRuzdKYVAAvtgn7WkDahjZSHgkQ/LgJkJbg4Asdc9U5Vw2puY4nuSezTpWI8XrFAt9dg4eZob4O4rV6YjL2AjAHqXVIqKJo05fWTx4RwUug9SCMD4jN030t4c+N9b2QuZkiZu6C4hWRdjat1xASUmB5R7MXn4ZKhVxs8nECwq1FeQkxFnfFTXAF+nflJaD6P1QoTg4vAcipKz1WGoIMdnnQEjZpz6tfX55DIe3w5n4WEjvN25Tubn5xwaqORCJyz5+iT6jEFBUi/zoTw1axn+FhSPUogkBtw+ZQ3SQid4h8X+wMPGCqh+G7XvIliHuHAXuuJAkO0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(66476007)(6916009)(316002)(54906003)(508600001)(53546011)(8676002)(4326008)(44832011)(38070700005)(66946007)(122000001)(91956017)(76116006)(36756003)(31686004)(7416002)(38100700002)(64756008)(66556008)(6486002)(66446008)(71200400001)(5660300002)(26005)(6512007)(2616005)(186003)(4744005)(86362001)(6506007)(31696002)(8936002)(142923001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bU04enhCVkRyanprd056cXQ4TjArTFlxZ294NUVhUHl5dWFTL1FkOExmVklB?=
 =?utf-8?B?b1VlbjBOc3JKZm5jVkd5VGUrZlAwakRKR2k2MFp1cHc2TmQzaW0yOGVqVm5E?=
 =?utf-8?B?bDJ2c0Y1Z0lOVEhhQ0VrS3BhU1Q3ZjhSYjQvTWZlTTVCQjFZTzE2SmhwUWJC?=
 =?utf-8?B?RE5FWllBK1c4ekwxM0ltU0FMb0lzeStIclVleTRGc28yZkk1QmpSUEd3bFBW?=
 =?utf-8?B?RVdHcUpsOVB3dUR2RnlOWXovVEJLREpOL2xtNW9nbHVXek1GMFdkK3BSMXFL?=
 =?utf-8?B?cFN4L0lpditFSFVtVE5YdXVrSWZxeWlCdWxQNkFwbnZjVVZsd3VObkdTVVh1?=
 =?utf-8?B?UjFaY3dETXVpZWwwUnZjS1dsWDVGN21hOEdZakszUmlDU2tXR2ZtQ0p2TXRD?=
 =?utf-8?B?NTdYa2YzM2huYVZWWmJlNUZvMkJSdzI4ejdEeitWUEVBWEQycE4xWWcxL2c1?=
 =?utf-8?B?OGM0cU1QaHZLYzY0U0QyL3hId1BQcm54dmVITFpEMGJPOEN0K3Z2Ylc1dGQ2?=
 =?utf-8?B?RmN3NnUwaW9vWDl2eDhMWUtSbm5jK2s3SVMwaUlqRkprU1RlRXpnTGE4U29r?=
 =?utf-8?B?V1hOZVFXYzJhb0lyOUVDdW94dUNDYnBtWXd0NlYzbDNBR3VJMkk5MXBKZjFE?=
 =?utf-8?B?Nkk5OFRQTmkwVmRiVVhHOFJ5MnhWR2xRa3ZvQnl2ak0xVEhzUzZWbWNQSWxR?=
 =?utf-8?B?QmEybzU2TmtWU0RJQXI1QkVzVGRvbUdWc0dQQWNGcEw5bmFXaDZvaWI5SUJ4?=
 =?utf-8?B?alpOdXhPS2llUTVOMmRzWFJFZzgwQTdldkdvczN2VnphRjVKVjNpaGtFNnZS?=
 =?utf-8?B?M1h2aXFJNklDc0daSjdFdkx3QXhPbnN1QWVNc3dlMjJTVFQ3MkE1Zm5OWjBD?=
 =?utf-8?B?N1BPYUFRcHhVUjBTVjdEeXBCcDZLb0lzSmcvaWY5WTRTdDdiUjlaNU5CL0Nv?=
 =?utf-8?B?MU1ibHZVcU9oenVsSkJNbk9yQnBMTVRWc21rQXBoRDB2Z1Bwa3M1OW1TWSth?=
 =?utf-8?B?VEJQdG1pWHFpWjZHeDRkK2oyVXZYRTg3UElrc1d2WFF6dndHcWE0RGkyS0pu?=
 =?utf-8?B?b2xWNjU1UTJ1d29ZMEZJSk9vWjhYWEg5clZIV2lFbXVXMEFxTnhVb016M0xJ?=
 =?utf-8?B?cmpVNmlCWkVXaGJRWGJRTEtTeXA4V1d5cDVTZklJYUpQWHVma3BTRXJ6QTlm?=
 =?utf-8?B?YWZDNGlPc2wxVXkxNkVPRnZRYmxzdXU4dzJQZ3NKanM0VUZvb29TVDNEamNq?=
 =?utf-8?B?NXp4V0taWlY0cUlEL25MNzdPbTdyYm5KMjZ2L3ozY1lZcUs1NXIxM05YWWkr?=
 =?utf-8?B?TmR3dGJwU2dRL1MvdFJhT3Z1MEJBV2V4MldZczhQeEYvMTIraENqNWJQcE05?=
 =?utf-8?B?NFlxUmozZ2hVaUFPZjZjNC80U1NSZUNMVlQzb2Z4WnB5N1l5VU5IT0lubGxw?=
 =?utf-8?B?djk3SHdrWE5zT1orU1pKOXRPSDJqZFQ1YThmN2NKUHBJQ04zZ0JkZHRzRlpE?=
 =?utf-8?B?eDdVR0ZyRXNlM1A2U3pQOUozWVJWNlVTQ2NkRnFsODNjdUtHL3VnZzRndWZk?=
 =?utf-8?B?TVRkNE8vb1hpZ0p0SmNYV1Q0OUsxUlZSeXBWTElvbmUxU2Fhd3NpajhXalpl?=
 =?utf-8?B?dWpYejRZZmxRVU5JR0NTRDE1ZVR2ZlpDbHV2VFNUZnp4V2dONmo0c2RKYmFo?=
 =?utf-8?B?bmk1UDZobGdFUWhvcEZBRzBMWks3Wk9ya2hTaTBDU256WkpHOHdoUDYrZXRr?=
 =?utf-8?B?Q1FzdWUrZlhtYStkSDFZbVNweW1nMlVMcEh1SGl6SW5FdkJqN25IdlZjMm0x?=
 =?utf-8?B?QVkxdENkamJQK053eW4yR3VrNDhISDFHU3BPNTNXUmEyVWZHN0VRZUhxM3Ba?=
 =?utf-8?B?Ujl3dnNrMHhtdk9vQ01uQm1MbU1vbVVUcHpWNnFrV3hNRkJMOUpBNytuU0Jl?=
 =?utf-8?B?TFZ4R1ZVc2h1QVRFVWlwK3BnZzE0dnpyaWxVbDRCaFA1NjlDT2dwWmlHaGJi?=
 =?utf-8?B?RzlEa0FaZVhKMzdGd1d5Y1Z0THpyTGp1eitOWmF5anJUK09nUHlEVGE2Wk1L?=
 =?utf-8?B?UUxHZlR5djZJNmxZQ1UvV2wrbkI4ek11MEVBSm9rZTBRaXMyQVZSakQzZ05s?=
 =?utf-8?B?ZTF5Uy90TkJiZEVvNERtOC9KWmkwdFFEY1NHcDgrS25VTWtLaHRoY2J0UzB1?=
 =?utf-8?B?a3dNU1lWMEZxeDJZcHhNa1NJd2pJaGhYOGF0VUhEVUdGVURBVGVRUkVtaWNE?=
 =?utf-8?B?ZW96OTVBQ3RlUjRpSTBpZkdvQjhXZytQV3B4b2x1Zi9Nc0U1Y1QySXAxUlVY?=
 =?utf-8?B?b3ZHVXFkaTV6VmFadTFRSXhkeCs0TjBMVVU4Wmh5dTh1dFdGTGpBUT09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429b8166-649c-4642-d25b-08da1db05da7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 00:47:34.8138 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0z93I8528PCvGVfadwJsoAShj4bg+f1P9REFjCmeR7bz/iMWKpLrdKG6F8NarpEIS6jTwv7XDI8f0y07MdUkzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4405
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=732
 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140002
X-Proofpoint-ORIG-GUID: Lf5wp0bvrKjugppJhYuX8JYu3wjWoXF3
X-Proofpoint-GUID: Lf5wp0bvrKjugppJhYuX8JYu3wjWoXF3
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C43690E473AE154A97B9FC637874B7FB@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/6/2022 10:30 PM, Christoph Hellwig wrote:
> On Wed, Apr 06, 2022 at 05:32:31PM +0000, Jane Chu wrote:
>> Yes, I believe Dan was motivated by avoiding the dm dance as a result of
>> adding .recovery_write to dax_operations.
>>
>> I understand your point about .recovery_write is device specific and
>> thus not something appropriate for device agnostic ops.
>>
>> I can see 2 options so far -
>>
>> 1)  add .recovery_write to dax_operations and do the dm dance to hunt
>> down to the base device that actually provides the recovery action
> 
> That would be my preference.  But I'll wait for Dan to chime in.

Okay.

> 
>> Okay, will run the checkpatch.pl test again.
> 
> Unfortuntely checkpatch.pl is broken in that regard.  It treats the
> exception to occasionally go longer or readability as the default.

I see.

thanks,
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

