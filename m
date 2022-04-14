Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DCEC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 21:54:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-EF5APxEkOnCt0SFCPC3zxg-1; Thu, 14 Apr 2022 17:54:53 -0400
X-MC-Unique: EF5APxEkOnCt0SFCPC3zxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23C30296A619;
	Thu, 14 Apr 2022 21:54:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0E8740D0179;
	Thu, 14 Apr 2022 21:54:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 830B1194034A;
	Thu, 14 Apr 2022 21:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2686619452D2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 21:54:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A85A82024CB6; Thu, 14 Apr 2022 21:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A26E62024CDA
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 21:54:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60D753802ACE
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 21:54:43 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-KYNy4s4MOOyrEiHrJjc4yQ-1; Thu, 14 Apr 2022 17:54:39 -0400
X-MC-Unique: KYNy4s4MOOyrEiHrJjc4yQ-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJmfn7029058; 
 Thu, 14 Apr 2022 21:54:19 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse58m-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 21:54:18 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23ELqUui000830; Thu, 14 Apr 2022 21:54:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fck15ch1m-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 21:54:17 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB2586.namprd10.prod.outlook.com (2603:10b6:5:b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 21:54:16 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 21:54:16 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Thread-Topic: [PATCH v7 1/6] x86/mm: fix comment
Thread-Index: AQHYSSYYGFAW2NTmbUWesvhenggRg6zsFCQAgAKPhICAAIHKgIAA3J+A
Date: Thu, 14 Apr 2022 21:54:15 +0000
Message-ID: <8361114d-f543-9785-8359-66b3d8fbdc9d@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-2-jane.chu@oracle.com> <YlVMMmTbaTqipwM9@zn.tnic>
 <e0f40cd6-29fd-412d-061d-d52b489e282f@oracle.com> <Ylfe9eqCYvl0nSRC@zn.tnic>
In-Reply-To: <Ylfe9eqCYvl0nSRC@zn.tnic>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c8ff1eb-4614-42f4-8583-08da1e6151df
x-ms-traffictypediagnostic: DM6PR10MB2586:EE_
x-microsoft-antispam-prvs: <DM6PR10MB2586A8C29429EBD2DADF3D83F3EF9@DM6PR10MB2586.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uOJBd9RNYj57BJpDPHKffx2AS7UmVabQAPKYpWS1ueKQwllWHdb8JnLKgMRAgzCxalyJsNQJ8Xb+xlGDquNJ2zX7KeeeUS9meSbLy+AlQpgNpNATIGbvuKfuUynjKB2l00J+cDCzOimAhMH9AYbKQjDGsD/hO787U4DPX4w07qpLC17WI0NGN7MFM/OBcgoCf4nJQMky14b7hjzHmeS4Qo3LpYdKtOLRnoYhoaMSym50C+cTJGceedV4I2ZcVp11K0lD9WcjckZIhxkwLF27D9W0hS/edrdb/jigZ3eHHAA2NMOcJCKHxDywO5DSGRiVdpE5G5AYLHScdQSlEKSLGWgGI53SczlgXVJeZyvuJ9vDQPwOhHevcnxHL/G68yJ8abyqCqMicniCRK5+nKzHZMhnhCVgIdAiudrDg63jSwE/JyDWuoIcx4O1NZesGtT4CkfOU72W3LlAvXYBv5KEwezAuCBpbd9ghyGe3iH2bOvMhiX6gDuoi6Qc1JDdea+A4vuKTLyGMkO82F8rzrdJsjySfBeDeKndSYkyDth6v+koiyqfR0gIrB0FfED2u9zJj+iHxon4qJcTjPeVugCTVAAYJtnXGaqSI0IT0hJU5cLohnmjFQ+swduYXLYOS8gz4RGuZUX4jJDOvttcs+Ay/Ap5evM3Yhtf9i8ChQ9ujKWlouumayOsb4vHWMNQ3twxC1B3Emszr7XR4hdN5IPF7PFaWguUCrr2N02BkfxgWVY7lcir5HDqTXksMrThEfmLL0tETvS5lMVyC+rnAUukXg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6512007)(508600001)(64756008)(2906002)(76116006)(6486002)(66556008)(66946007)(186003)(8676002)(4744005)(31696002)(5660300002)(83380400001)(4326008)(44832011)(7416002)(8936002)(66476007)(2616005)(6506007)(53546011)(316002)(86362001)(31686004)(54906003)(66446008)(6916009)(71200400001)(36756003)(122000001)(38100700002)(38070700005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkowczJKQkNMVlhzSUN3Z2VMcGtGWDAzbk9WT1RkU2hPWjhXczQrMzUwUjJ2?=
 =?utf-8?B?TlBuM0ZzTnFkcGtvTzJjSmppWDUzaWc2RGM3NklTWXlZM2VHb25OQUxiZVF6?=
 =?utf-8?B?UnlGRTAxREM1TVdQWThpaEVwRy9KMGdKUEhRVnlrR21nUHhhd1RyRWVxZ0FX?=
 =?utf-8?B?YWtpVnRmWVFDeGtqRzVLSmJnK2FlRzRNam1NWnJraytjNndST1djbGZCMzRT?=
 =?utf-8?B?Vlg0R0FycWplSFAydkx4RFVqYlp3UWlKdW15Qm0vTlhkdVpNSlU4eDQ3bzBh?=
 =?utf-8?B?b09JY0tIcnBmR1kxd0tBTzE1ektBZHMzZXV6V1VTalhRSWZySXpac1E0U2wr?=
 =?utf-8?B?dVZuQzJyQWg1blNueXE2d0tvcXlsaXJMUXpIaUpUaHR5TzROUkJHYnRzS0po?=
 =?utf-8?B?L1pwREhpL0dod0N0TU9qaUlmSnR1a0Y1b1NSUENoTFZwQzY5TitPK29nKzls?=
 =?utf-8?B?OXFFaGF1bXZUUkJ0b0pka0pPNlcwcUpMVXpwOVlCQURwSnExVHBaVmtJUUtu?=
 =?utf-8?B?QmN1V2RPUTV3aDJmM1hxbHdWOFlVMXBjeGNabkhJcWNDVjg2T3IxLytLVm50?=
 =?utf-8?B?dHN6UjN6cDlsemVHdjdiRjViQjRzaE1ERXIwK0FmcEZ2SW9HVGFlODArb0o5?=
 =?utf-8?B?SnNWZWZ3K2tnVGRMbkRwWkVRdC9jd0JvSWZEb2VCeEdCakswbnNXMDNBOEJZ?=
 =?utf-8?B?MDk1T2R1dDJ2OHo5SUt1R1krbjNPVTd2d050ZVByL3lKcVRmeE90WTJDT0xJ?=
 =?utf-8?B?bXM5MmNqVGlnMVZSQ3RMazBHQ1lwYmFIdHgvNG12eDA5TmFsLzBwR29rdTlO?=
 =?utf-8?B?QW9KOGFyNXU0TzF2NFRJM1VaVy9hSVlXeWpWamIyREZSS2F0MUxpZytsRUFt?=
 =?utf-8?B?aVl0dE03d0tEcE9ZaUdpcFZLeDIxUWN1SjJxQ2tzWFNFU3dEK0RlZXcwekxI?=
 =?utf-8?B?T3BNcEFaODdaVmZ5MEk3eG1acVFxbnFCWE96SVNyemhFa05KSTZKdzZTUUNt?=
 =?utf-8?B?TmtnZ091UjlvdTExT3lIYXkrQ0tSN2k0bkVYTC9ROW9HMUxIMUR3ZzQ2Q0R5?=
 =?utf-8?B?SklmNUFsWDlYUEYyL0xINkRIYUZJeTdJeW5PRFpGUTVHUS9wdm9JTmFoU2s4?=
 =?utf-8?B?b2hVVWtvaG9maitUUGFYTm9xeloyOUszWXI4cjRNd2poNXdKbkkvSFVFNGRn?=
 =?utf-8?B?U2hJNjc5OGlpaGxkT05RdzY0SW5XbDgwYm5kak9OOEtBSGtkT0w4S0w4Smkv?=
 =?utf-8?B?WkFtRnlSU0ZYRzFmM0J4S1AvdHI3UTZWTlgzeTJxUnhscytlbjZLc243WDZ3?=
 =?utf-8?B?Y0xhanJOcmVSaDNuN0lyRGFocnN2OXcxRUxmem85Y1IyeHluVmVubFRtN1F6?=
 =?utf-8?B?MWVrZkVabk9DdUNyWlpKVWpIUGQzN3dWeXRSeW9rdW8wTGRvaUtxZVhXZUNz?=
 =?utf-8?B?RlA3ODZQdXNmeHdTMmJkckZiZENmdlZDVnQ3RXh3RFYyVDZVVTNWQ1FteDdM?=
 =?utf-8?B?WXJselhDK25uMWlTSm0yK29CZjBRK3plYkZvSFdPQWgyV3NFQWpINHRxNlht?=
 =?utf-8?B?emN6eXBzbC9VTWxMU3dDR3dUVUlOQkNqOGVrdnl1ZDJwRTJ1NUZka1NTYUd1?=
 =?utf-8?B?Nkt5dy90VUNDMnJPMFhtNlNSUDU0NVlpKzUrK3J6Smo1Z2xJYkxEeU1hQm4z?=
 =?utf-8?B?N2FkcWhZekNKVWI0alVkSFdDZUd2Q3NIckhJOUp4d2F4ODA2bWxkY1JLWE1y?=
 =?utf-8?B?VzVEa2U2Vmd2L3V0UVZUcmhtNkw5eUhDVlk3amtaeHNoRVhMMDZhVzlHUXJV?=
 =?utf-8?B?R0NsQmk4K2x6R3NSUG1UTmtSSWoyYjV6TEFxaHAwM0pkcStCejFxNmU2MlNY?=
 =?utf-8?B?MmdiWGpTZkxrN1Jqd0IycmR1dGNWdEl5dUMrbDlFRjB1MEdrWTRhMUF5M2JL?=
 =?utf-8?B?bUh4ZUsxUWZGeFVjdVR0eUM0RGxFeDNnLzRLY2M2V0QwbEdKMTAxT05Wcytk?=
 =?utf-8?B?MXNUVjcrdlE5eFhIVXBFNW1mQUhYZDUyRWljREw5RlFiMUNDT2hjaUUranhY?=
 =?utf-8?B?cG9RRUFkc2NxVHVUYWtLL2hBNzdCL3FGOEVUcUlPNEFUZnBXUTJUMFZtWWh5?=
 =?utf-8?B?N2duOVZzazJQV0l5NC9hOTI5aktvaTN5a3FPZXFCY1FERHNVRlNGME5YOFRs?=
 =?utf-8?B?c0dibHNsbDJpVDZwWk00MjNST3ptM0NtNS90NTNRL1NVa2FFWlNnWmNjR2M4?=
 =?utf-8?B?amZoL2dRV0cra05MUDBvT1ZHVy9iOFF3T0VoKzZROEhFRmkzTmppbDVvZjh3?=
 =?utf-8?B?OStma1lkVm9DSURhdE1VVnk1WVRtOEZzcDF1d252L1dNNjdlbXFHd2hMbEI1?=
 =?utf-8?Q?qtKiITA1noAowVHo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8ff1eb-4614-42f4-8583-08da1e6151df
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 21:54:15.9673 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yfvLuxTNi87EgMvH8w4bdEOEqDgIp9QYnvTs/6gQ/9tnAA2wY9PFQQzoSgoyzYJjNIEy0oj3SDbFCyVorcbGqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2586
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-14_07:2022-04-14,
 2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=869
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140113
X-Proofpoint-ORIG-GUID: uZTvyBFe-r2ENqZ374oGHSTjnfxi09iI
X-Proofpoint-GUID: uZTvyBFe-r2ENqZ374oGHSTjnfxi09iI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 1/6] x86/mm: fix comment
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
 "hch@infradead.org" <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <37CC72E7A8B2404BAD7C8A7D00814543@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/2022 1:44 AM, Borislav Petkov wrote:
> On Thu, Apr 14, 2022 at 01:00:05AM +0000, Jane Chu wrote:
>> This change used to be folded in the mce patch, but for that I received
>> a review comment pointing out that the change is unrelated to the said
>> patch and doesn't belong, hence I pulled it out to stand by itself.  :)
> 
> Aha, someone is being very pedantic.
> 
> For trivial unrelated changes like that I usually add them to a patch
> which already touches that file and put in the commit message:
> 
> "While at it, fixup a function name in a comment."
> 
> Less patches to handle.
> 

Sounds good, I'll fold it to one of the mce patches and make a note that
it is a BTW-kind of fix, not something related.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

