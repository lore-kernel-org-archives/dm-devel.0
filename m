Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539D6C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 16:19:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-F2R2S1LDN52JC3ZhJHg5AQ-1; Fri, 15 Apr 2022 12:19:50 -0400
X-MC-Unique: F2R2S1LDN52JC3ZhJHg5AQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49A4E296A633;
	Fri, 15 Apr 2022 16:19:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00269416143;
	Fri, 15 Apr 2022 16:19:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F9FB19451F0;
	Fri, 15 Apr 2022 16:19:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADBF519451EF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 16:19:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B8DF403151; Fri, 15 Apr 2022 16:19:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76215416165
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 16:19:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58B003C14CCB
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 16:19:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-nZjr9cyaObuwt-Gr86bY1A-1; Fri, 15 Apr 2022 12:19:37 -0400
X-MC-Unique: nZjr9cyaObuwt-Gr86bY1A-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23FFepTm012649; 
 Fri, 15 Apr 2022 16:19:02 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb2pu7r3y-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Apr 2022 16:19:02 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23FGFqPU003939; Fri, 15 Apr 2022 16:19:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fb0k62uk3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 15 Apr 2022 16:19:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB3978.namprd10.prod.outlook.com (2603:10b6:5:1fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:18:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:18:57 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v7 3/6] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Index: AQHYSSYcmxaMmXFgxUqypAmHkAJB9qzrZR4AgAMnHoCAADFSgIACeSgA
Date: Fri, 15 Apr 2022 16:18:57 +0000
Message-ID: <b3f0bfcd-9e7c-cc71-e91d-d0f28053dea9@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
 <CAPcyv4jx=h+1QiB0NRRQrh1mHcD2TFQx4AH6JxnQDKukZ3KVZA@mail.gmail.com>
 <b511a483-4260-656a-ab04-2ba319e65ca7@oracle.com>
 <CAPcyv4jpwzMPKtzzc=DEbC340+zmzXkj+QtPVxfYbraskLKv8g@mail.gmail.com>
In-Reply-To: <CAPcyv4jpwzMPKtzzc=DEbC340+zmzXkj+QtPVxfYbraskLKv8g@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37b33543-6d89-4516-675a-08da1efba4a0
x-ms-traffictypediagnostic: DM6PR10MB3978:EE_
x-microsoft-antispam-prvs: <DM6PR10MB39787C42692967FE149DAA0AF3EE9@DM6PR10MB3978.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: F1+0xrki9fEjsd4NtzS2bnD4PWNgZ+vyztShShChTON9DKREm4T2snnjb0GY4CukzMfgGYvyrzl9TTWAmieCIaBo5cvz58TRELJZ4f+pQKybzgYLvj0z380rN4mvUcIeYcB2s5opx6bLSERml/SZeiIQPvce/xLRMiLb1rrQrb+aRnh3cHvGnGysLiLJwOb3bFnx5hSaYGMZbatXsXMWLobCvnIsXdLZS096zwk7fOtaFW4aTfA1zfIXyYLyDA8/58fOoJ7Csov3PxJg20kUmXDjEC3SbwgUhD8E4ZGNPDZgw8a5mMl9e0hysEkPOLPzAaOACNi4McGjf/21ZAA7VEST/0DaXK5r88T9vkUGn/tH88YNrS4pMd0iFR5Uh05WD3Ie4PI0+SyJ8knxVGhKWYNsk+lXvKiVO7/mCG/N5mhuuS8jhuy/u7aiCln8Js2PtXEBq1TLiduunmUCwsDTfircZI5POxNYWuZpp+GBj+VOZ1Vi4ieKHF6sysNwXFMUVJCYa4G5vtqiiL8JOuDI8Bxe2bW+uwg7fNLwrmalGWsuUlOlpyIUL4xMoVfJeVYqls3AMv17d5HSWCUm8Fg27j/CugaBhAyRiyw1lOAKOSf86k80fLQSljljfLnkUho9FgpVBc8hublhIrEyYgD0Br2F/SYtJVaiaSHL/Vxw6BJe+2cSDpy8iFI2ophfBzQ0c9mqqkVqJm4EvtddtCVzQHxHWBXxSis3t/YicMab7VwmwAsg/ONDEIdtmf14dFnKB8uTh/eAOUvTQSdQzG3Y/qdK9Y9CoQz1C19k9SqshxY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(8676002)(64756008)(66946007)(6486002)(66556008)(4326008)(66446008)(83380400001)(76116006)(2906002)(8936002)(7416002)(44832011)(5660300002)(36756003)(54906003)(86362001)(6916009)(316002)(2616005)(6506007)(508600001)(53546011)(6512007)(26005)(186003)(31696002)(122000001)(38100700002)(71200400001)(31686004)(38070700005)(21314003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RU1MZkx5alVCN1NMdkFJNk9iTGdUT1pGZnlvYXhPSi9QMk4vc1B5bW5jRUFk?=
 =?utf-8?B?TTRWNXBGWFNOajNQRjFqQVVqZTl1bHdVd2NScWRtendJNU1ORmwvTDR1S29h?=
 =?utf-8?B?TDExbU9mTHJ2NDJBelhqUHZSMHJEaVFBbkVnbjhxazNNNldnQlFJZVRFZTRi?=
 =?utf-8?B?Y1p0aGNDRUJDQkNYelNHcXdkekE2R3NOVmRJWDlJQVdKZ3cwT1dmNlVsLzlU?=
 =?utf-8?B?c2xjbit5NUNYQ05tbWRLa2o5aXB3Ry96alBmVHQydlF4bTN0Yk9Hd0ZobUhq?=
 =?utf-8?B?Rk9JR1dtd3o2djlqTENzdkUzdWc0dTN0cXhHSHd6Q3RESkp1OVJ1ZFQybnZm?=
 =?utf-8?B?a3JWcHFFYkJhSEFxMWhTcWFsd2tHQkZTaWMzUGFXVTVRTTdKYnhKbGdqYkh3?=
 =?utf-8?B?bFJsTGQ2M1pwL0NtelFVYy8rSlBZSm85a3ArNkJrNFgwZWFiSHI3cFRRNHUz?=
 =?utf-8?B?NEhYNTRUR2NadWFQVFhkWHdwOUpHSEdvYkt5WTZFRUZITzdJKzZINEI4dEUx?=
 =?utf-8?B?T3c4THE5V283K045ZnBHRk5jSTFUbFNuTEpmd0JNV0FyMFJ4bHBJSm5YTGl1?=
 =?utf-8?B?MGJJMWFuVjhZTk9GZUU2S0tqd1h0OEJvYVhvOUpGL2pkZ044MjBRNTBwdVY4?=
 =?utf-8?B?U2t4NjRyeTNqTmJFYWFEc0JDUU56Z0VOcjZReitwREZNeWhRYm0zSGJZVC9s?=
 =?utf-8?B?ZEl2R01ZbmEwdDcvekRPZ0kxbVE1WDM5SXhUeU5wQ3QrT1pVbTVjSTBsUmI5?=
 =?utf-8?B?M05uSVNjY3FCcnBKbTQ0ZTNlMVNITDdMa0V4SytUVVYwdk5QaDBYUFFodDUv?=
 =?utf-8?B?N2V5TkxYQmFmUytLS2ZBKzFRblpqWG92SGl6UXoxOTBiU2FrNmYyQzJCckto?=
 =?utf-8?B?S0J5WVJQOVV1a0duZnlvSEdrTkdsUEVUUnd1NG55WjlHem0zQ044emlYZlVL?=
 =?utf-8?B?MG5ZQXhqaHhZYzU3TXJ2cUhLVmxZaE5KaVRrMG1IcXEyZVExcXlGclRvRElY?=
 =?utf-8?B?TFJpOUduRkNJNEFJbldYbVNickx4bVNaRStpRHBSSm4wYnI2STZrdjVaZW9T?=
 =?utf-8?B?YlBZNDEyNWZJVG9QTklPb3ZmbW82clpQektQdTFDZnM2M0lhQy9tL1ZMVlZG?=
 =?utf-8?B?OElhUG1nTWNqOTc1b25aeHorcHBXNFp6djRRYzVLcTdzV2xMS2JuQ0RZQ3Vr?=
 =?utf-8?B?bXRhZkhaZmpmQWQ0TVB2WXJYeFZXTEFuQXpoMk5BYjdmT0dqNFdJRUc4VUNS?=
 =?utf-8?B?NUVjenhzRU1jTGlzQ09kMituUHB2MEVkY3FyTVo4ZEIzT3UweHJMeG1sRG5G?=
 =?utf-8?B?SmQ0WDJuNnRIK3dpajY2S1lHNWJQbnlvM2hMNnYzNjdlU1dEN1Z6NUpxZk56?=
 =?utf-8?B?Lzh0QmVUdkhIZytDVlByTGJmQzRmTjJYbEwvTDVvSGFibUFyMXBoZFdVT3pa?=
 =?utf-8?B?dUcxcTROYWdSRTgxbW1jSk4zWXFrNVZtdm52TXlOd3dHNVY4K25hTHdsSHY2?=
 =?utf-8?B?ZFF1VWphODJuUDczUDhCYnBRUzRIdXBIYk5wSVYxWHNWMjdTdUZEN1ROOW1t?=
 =?utf-8?B?aXZSNXRreUVHajhOM2YxVE9tdW1FdVlnVmJKZTBaVVYzRkJNUTl5bXZBQ25y?=
 =?utf-8?B?WkpUalVGUzdJWHJLWEdZamc4eks1OFZlNGYzVGkwMnI3TmwyR3d5am15TGRS?=
 =?utf-8?B?dlJ1cTFKeG5ySW1IaXBob3FKZzRlalIwSjg1eU9uRHJ4bFVGeGVQOWhNajQr?=
 =?utf-8?B?NHpjbTk3UEdMb2h6M3R0aFhqeTB6OGszNGthRTh3NzFqVmlnanoydlI0b2wr?=
 =?utf-8?B?T3lZVWM0SFg5OXV1YzU1dWtqN1BTWCttUm9JcytGQTdjb1IxWlJ0eXdlREtq?=
 =?utf-8?B?bGxoOXpyMHYyblFzbGNHZEJRQjhzRVBaVGFYSTdPalA4dElQNFZqN3hmOE1h?=
 =?utf-8?B?clpXbXBZV2pUeVlTRDY2S09FZVpjTy9sUUQ3cllFTGxwVUpCU2daeDBKN0xE?=
 =?utf-8?B?VUp4UkhoZ1BiRFBjbUN0aC96bnN4UmUxeEtkUzRmbmVpNXhUUXFUR2dJU3NO?=
 =?utf-8?B?QmNSN0pQSkEvaUhMbzk3dTd4Y3p3c0RNbXdpODZMeEIzNGxpbkhLOXFOeUhB?=
 =?utf-8?B?bEFMeHh1aDZNd3FOY3Q5TUtQeHhzUk1teUR1YXB5dWpEdU5idDB0UWxYOFMr?=
 =?utf-8?B?WEY2MVNwZWNsUFVSRVMzVmRhOWR2NXQxMzI0WEtqREhhOC9iRmxlUllOamRo?=
 =?utf-8?B?UkZ6MVBBdHZ3a0NLR3ZpSlpDWDVRUUVFNjRxRy83Q1JZUWZxRlF1T05oK0tS?=
 =?utf-8?Q?ajpTM3Tw7SR13rhQfP?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b33543-6d89-4516-675a-08da1efba4a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 16:18:57.3165 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4eYH7GuBPoWJuR7dSdPGD1hQeABO6tL4RBGOyBdxHPAwU5o2yIWoSpSFj3nNEfBcOl0yPJUsZcXcS3hMgtjUaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3978
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-15_01:2022-04-14,
 2022-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150093
X-Proofpoint-ORIG-GUID: fM0BYJool8UnlPbd1opG_axTbXY17yTk
X-Proofpoint-GUID: fM0BYJool8UnlPbd1opG_axTbXY17yTk
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <271F86A4BEF6A145A1503974C9B11412@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/13/2022 7:32 PM, Dan Williams wrote:
> On Wed, Apr 13, 2022 at 4:36 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> On 4/11/2022 4:27 PM, Dan Williams wrote:
>>> On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>>>>
>>>> The set_memory_uc() approach doesn't work well in all cases.
>>>> For example, when "The VMM unmapped the bad page from guest
>>>> physical space and passed the machine check to the guest."
>>>> "The guest gets virtual #MC on an access to that page.
>>>>    When the guest tries to do set_memory_uc() and instructs
>>>>    cpa_flush() to do clean caches that results in taking another
>>>>    fault / exception perhaps because the VMM unmapped the page
>>>>    from the guest."
>>>>
>>>> Since the driver has special knowledge to handle NP or UC,
>>>
>>> I think a patch is needed before this one to make this statement true? I.e.:
>>>
>>> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
>>> index ee8d9973f60b..11641f55025a 100644
>>> --- a/drivers/acpi/nfit/mce.c
>>> +++ b/drivers/acpi/nfit/mce.c
>>> @@ -32,6 +32,7 @@ static int nfit_handle_mce(struct notifier_block
>>> *nb, unsigned long val,
>>>            */
>>>           mutex_lock(&acpi_desc_lock);
>>>           list_for_each_entry(acpi_desc, &acpi_descs, list) {
>>> +               unsigned int align = 1UL << MCI_MISC_ADDR_LSB(mce->misc);
>>>                   struct device *dev = acpi_desc->dev;
>>>                   int found_match = 0;
>>>
>>> @@ -63,8 +64,7 @@ static int nfit_handle_mce(struct notifier_block
>>> *nb, unsigned long val,
>>>
>>>                   /* If this fails due to an -ENOMEM, there is little we can do */
>>>                   nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
>>> -                               ALIGN(mce->addr, L1_CACHE_BYTES),
>>> -                               L1_CACHE_BYTES);
>>> +                                       ALIGN(mce->addr, align), align);
>>>                   nvdimm_region_notify(nfit_spa->nd_region,
>>>                                   NVDIMM_REVALIDATE_POISON);
>>>
>>
>> Dan, I tried the above change, and this is what I got after injecting 8
>> back-to-back poisons, then read them and received  SIGBUS/BUS_MCEERR_AR,
>> then repair via the v7 patch which works until this change is added.
>>
>> [ 6240.955331] nfit ACPI0012:00: XXX, align = 100
>> [ 6240.960300] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
>> L1_CACHE_BYTES)=1851600400, L1_CACHE_BYTES=40, ALIGN(mce->addr,
>> align)=1851600400
>> [..]
>> [ 6242.052277] nfit ACPI0012:00: XXX, align = 100
>> [ 6242.057243] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
>> L1_CACHE_BYTES)=1851601000, L1_CACHE_BYTES=40, ALIGN(mce->addr,
>> align)=1851601000
>> [..]
>> [ 6244.917198] nfit ACPI0012:00: XXX, align = 1000
>> [ 6244.922258] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
>> L1_CACHE_BYTES)=1851601200, L1_CACHE_BYTES=40, ALIGN(mce->addr,
>> align)=1851602000
>> [..]
>>
>> All 8 poisons remain uncleared.
>>
>> Without further investigation, I don't know why the failure.
>> Could we mark this change to a follow-on task?
> 
> Perhaps a bit more debug before kicking this can down the road...
> 
> I'm worried that this means that the driver is not accurately tracking
> poison data For example, that last case the hardware is indicating a
> full page clobber, but the old code would only track poison from
> 1851601200 to 1851601400 (i.e. the first 512 bytes from the base error
> address).

I would appear so, but the old code tracking seems to be working 
correctly. For example, injecting 8 back-to-back poison, the
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/badblocks
cpatures all 8 of them, that spans 2K range, right?  I never had issue 
about missing poison in my tests.

> 
> Oh... wait, I think there is a second bug here, that ALIGN should be
> ALIGN_DOWN(). Does this restore the result you expect?

That's it, ALIGN_DOWN fixed the issue, thanks!!
I'll add a patch, suggested-by you.

> 
> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
> index ee8d9973f60b..d7a52238a741 100644
> --- a/drivers/acpi/nfit/mce.c
> +++ b/drivers/acpi/nfit/mce.c
> @@ -63,8 +63,7 @@ static int nfit_handle_mce(struct notifier_block
> *nb, unsigned long val,
> 
>                  /* If this fails due to an -ENOMEM, there is little we can do */
>                  nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
> -                               ALIGN(mce->addr, L1_CACHE_BYTES),
> -                               L1_CACHE_BYTES);
> +                                       ALIGN_DOWN(mce->addr, align), align);
>                  nvdimm_region_notify(nfit_spa->nd_region,
>                                  NVDIMM_REVALIDATE_POISON);
> 
> 
>> The driver knows a lot about how to clear poisons besides hardcoding
>> poison alignment to 0x40 bytes.
> 
> It does, but the badblocks tracking should still be reliable, and if
> it's not reliable I expect there are cases where recovery_write() will
> not be triggered because the driver will not fail the
> dax_direct_access() attempt.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

