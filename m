Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C945C432BE
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:41:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 483CE6103D
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 483CE6103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-lPx-UE9lOrSMgzk76f6rZQ-1; Mon, 23 Aug 2021 02:40:04 -0400
X-MC-Unique: lPx-UE9lOrSMgzk76f6rZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42A2A87D541;
	Mon, 23 Aug 2021 06:40:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DEF96788F;
	Mon, 23 Aug 2021 06:40:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E5B94A7C8;
	Mon, 23 Aug 2021 06:39:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17J7IrVi013977 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 03:18:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1CC410D16CA; Thu, 19 Aug 2021 07:18:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC7A21020452
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 07:18:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B22A800963
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 07:18:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-7FLxiCzeM2aTGmzHTVluvQ-1; Thu, 19 Aug 2021 03:18:47 -0400
X-MC-Unique: 7FLxiCzeM2aTGmzHTVluvQ-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17J77ltI013756; Thu, 19 Aug 2021 07:18:28 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agykmjfcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 07:18:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17J7ArtK068703; Thu, 19 Aug 2021 07:18:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by aserp3020.oracle.com with ESMTP id 3ae5nayu55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 07:18:27 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3560.namprd10.prod.outlook.com (2603:10b6:a03:124::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19;
	Thu, 19 Aug 2021 07:18:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%6]) with mapi id 15.20.4436.019;
	Thu, 19 Aug 2021 07:18:25 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
Organization: Oracle Corporation
Message-ID: <d908b630-dbaf-fac5-527b-682ced045643@oracle.com>
Date: Thu, 19 Aug 2021 00:18:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
X-ClientProxiedBy: SN4PR0201CA0057.namprd02.prod.outlook.com
	(2603:10b6:803:20::19) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.220.244] (138.3.201.52) by
	SN4PR0201CA0057.namprd02.prod.outlook.com
	(2603:10b6:803:20::19) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4436.18 via Frontend Transport;
	Thu, 19 Aug 2021 07:18:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6db8ae91-ddc0-4850-da77-08d962e188a4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3560:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3560F7D1EBD6E7D0931F56CBF3C09@BYAPR10MB3560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ec91aALRuuWmRQ/i77w39TEcJ3KiB6CPGOVnEzJTWUyuU4B2p1PDUKCl6oYWmfo96tevIBlLddzcUrg9ma6cvGidfTMPGZ5GZdclk8rYphraHG+DYGRS93hoGnVqQDaqqjTZ57tBBS0ahgAC7KqA7kt7aTA/y2fB49YwxwCrrs5THWN90PXPY8Pb21nk6zAjjaJsQPkQHx1E5ac4gJkPskfR27iJzzPcKGIkXkBTxjXWI1pfgdGnA5lRcN7LitNyvEo2frfCNp+Ym8RKddPFBJWHbnR1ts7ScYvtG1WC3N/WUJxUFZ9ozogmH2wjgFrjeGfyLLM2+ZPIOwa7vFEPxABaoCWbFLLvsz47RATETcGEdz/72tHN8rxPx33VvxnfJGP0UCsfK5ieYt410khM6rwW53RKvp+uLd+YHS5W+RQPy8nD4DCUK9ikEV1760NWZA/NeBvaA5mLuedRB5Mu0qwRp4UKIO2fsGpXqJFOpl0mDoPHofG1ffDcZarJnN/PVAOdNlf5yP9kQCUEB0/bUp4jRal3bWiBZbA80VlaDTKI9ep87LYsrc49dBquSaqi+qiCPIHsMLwXpuhkpvUyoB1GSdT06bNKij+6IIIUgOOTkydf12n8uVcVPVtTkMRyD6LPwB1N9RFKLh4dicl6wtZ5RA6Y2Ry122Q1uaSCnqAzKCzYcBLZV77zblqh1qQxYhlHK7RsV1fknX5QvC17qrIdffA0VWILekSP6fFaYRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(366004)(396003)(346002)(39860400002)(376002)(478600001)(6486002)(66476007)(66946007)(66556008)(4326008)(5660300002)(36756003)(2906002)(7416002)(26005)(6666004)(83380400001)(956004)(86362001)(186003)(2616005)(38100700002)(44832011)(107886003)(31696002)(316002)(36916002)(16576012)(31686004)(8936002)(8676002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blVndVRZNFF1THFBTUZuV2lJK2JBNE51ZFRiRldFL29pT3doUFFVc2wweEkv?=
	=?utf-8?B?dXAxQlVncXh1dnNscC96cG82WUF2by9OS01sTlpJT3llVy8xVEUwYkNuSDUx?=
	=?utf-8?B?RzByRW8rRnBSQU9HRDl6ci81dU4ydUl3amhwSndxUTk3c2lkVjUycDBOVk5C?=
	=?utf-8?B?ZzgzSW53TEkzK2VKTmg2aVhiaHA0cFVxMitpY3lIQUozL2cweSt5dEE2RFpx?=
	=?utf-8?B?NVdFSlVkNEdPZmxHNE5sQWZpbXhpTEVkdS90clNNL1k1b3FWc3BoU3IrZldk?=
	=?utf-8?B?WHAxamJYVTlCRUNyTWFIekhzS2Z1K1VOOW9TY2tPaitTUUc2Qm1QYVg2SnFv?=
	=?utf-8?B?ZEp6T2grUHRZOXg1YW9IWmFkQzZlN0FlOGVJcDVSVDFNZFo5YVhnN1VCdGFI?=
	=?utf-8?B?OS9wV3AwUWJ0bHQrUmh3cGtoQityQ1NiN3NBekhYazVGVVBnUnR1SUF2V2tV?=
	=?utf-8?B?NDJhMnR2WjkwUkRYTURqMmlzZDVDMHM4aVpaeS93VVU2ZFJTTVA3Wmp4ZVFR?=
	=?utf-8?B?SHJXRC95eUdkY08yZFhRU09GZERIdVU0OEZ2aVlraXBlN2hGQjZrQUxzeTkz?=
	=?utf-8?B?NFlBb3h1RWE5ZGdFaS9oUGVPWkhaREVhKzFhYUtPaGNnUmd6YW5PV2NZY0tV?=
	=?utf-8?B?Qjg5Nk5MZnhHSG5kbFJqalA3Q3plWWNBdm1QY1NTYUNIT2JPMkZQdzBaS3hL?=
	=?utf-8?B?VnJ4b2N1U3crbmpPRjlBTmJKY2YzYk5RMGpCalhOdjUvM1RGb0xQWkY0S3FH?=
	=?utf-8?B?L2xWdUY5YU15OHh6RnhSL3RKbGdLN09lem1XazhkY0J6NTM4cHJ2YjF0MWRl?=
	=?utf-8?B?R0FLa0lRY2Mzdlc3dmJDekw2Q01XS0wxaGlEbS9nT2Q3MXRud0oxTUIrYjE5?=
	=?utf-8?B?VEk2ZWxXaEFqdUtoeTRxZ1RCaUpoZ3FYQ1BkZ0dDYlNaeUo1V1hnZXdKdStM?=
	=?utf-8?B?cXpLL3JBS3N5VWRDUlBMYyt3ZEpYWHpXZ3pIMEZIb25VUXFWeG9UVTI0UE96?=
	=?utf-8?B?QVdQQ1dkMEp1ZkM4eUc1OGhwNm9QTnhxdWdFMHNwOGdzcks3cDZQcFdmUUxL?=
	=?utf-8?B?eldoREQ5KzFyUW05czlLamhYRlpLdFBGeHY4U2VkUEQ2OUJvaFNLOG93Qzdp?=
	=?utf-8?B?bmRINnNiM09MRWEyUGdSK0w5Yms0RXp5WnVwUEx4d1RYeTFpSUIybGE2cisx?=
	=?utf-8?B?K1lvVjgwTEEyTkpheG5wdFdwNDhXWGNMN2RGM2w0SHZKdVRDK0xEVE9pUHUx?=
	=?utf-8?B?eXlKaXl1bVA2azJFbzFWeVQ3eFRtbFNQRHVUekxDa3FVSHNiWFYwM3JzTlFv?=
	=?utf-8?B?TmdiM29wZk1kTzZaU2hBRWxIL2w2dW9hUTlDd0FqN1lKU0c2Y0JWNjlBbXUw?=
	=?utf-8?B?dml3YXJlUUUxRWdoQjVNb0YwWElTbm9LTU1DSUEyQS9HVWN0ZGRWMzRoWFFv?=
	=?utf-8?B?Q3JSdVlHb3pnTTFOb1pDYnREZWs1UE1VQUNHZFRoRDdRYlpQOElrWXhiOHZD?=
	=?utf-8?B?a0wyYllOMFZjSkRaWXBXWG9MZ21qN2dDNW5yem1NYWw1RWhjNWJxbnFtNlhV?=
	=?utf-8?B?NEc3M2VIa000WmdyUk1EeUZXWFZOV3ZnT3o5VzhyT0JoaWxXU21Lc0dtNlhP?=
	=?utf-8?B?bExoNENLTmRYQlZlQVdsYVZBbGdnbjdFZ3Y0Q0ZnejFOMlpEdlBibk5ISUlv?=
	=?utf-8?B?UzduODl2QnViRDJ3ODAzZElpcnZzL2Uyemd2YWMreXdQQ1B1NjlCaDE5Q0tH?=
	=?utf-8?Q?t+z3Dov4eS97g/UqCH3w6QS2u+8PdC4pJtwBbAH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db8ae91-ddc0-4850-da77-08d962e188a4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 07:18:25.0738 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSO8cwG3tEB+R1VJfQ+wKoKpG1zjuIOBCXMezDLOAZGHjTitIu6ehOjRtWkHfwRkpSKCFkCHVNEZEv7/2dSUQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3560
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190039
X-Proofpoint-ORIG-GUID: qA_glU1MWM4pwbIxP5JmInYAB6xn-xwi
X-Proofpoint-GUID: qA_glU1MWM4pwbIxP5JmInYAB6xn-xwi
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: Jane Chu <jane.chu@oracle.com>, snitzer@redhat.com, djwong@kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi, Shiyang,

 >  > > 1) What does it take and cost to make
 >  > >     xfs_sb_version_hasrmapbt(&mp->m_sb) to return true?
 >
 > Enable rmpabt feature when making xfs filesystem
 >     `mkfs.xfs -m rmapbt=1 /path/to/device`
 > BTW, reflink is enabled by default.

Thanks!  I tried
mkfs.xfs -d agcount=2,extszinherit=512,su=2m,sw=1 -m reflink=0 -m 
rmapbt=1 -f /dev/pmem0

Again, injected a HW poison to the first page in a dax-file, had
the poison consumed and received a SIGBUS. The result is better -

** SIGBUS(7): canjmp=1, whichstep=0, **
** si_addr(0x0x7ff2d8800000), si_lsb(0x15), si_code(0x4, BUS_MCEERR_AR) **

The SIGBUS payload looks correct.

However, "dmesg" has 2048 lines on sending SIGBUS, one per 512bytes -

[ 7003.482326] Memory failure: 0x1850600: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7003.507956] Memory failure: 0x1850800: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7003.531681] Memory failure: 0x1850a00: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7003.554190] Memory failure: 0x1850c00: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7003.575831] Memory failure: 0x1850e00: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7003.596796] Memory failure: 0x1851000: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
....
[ 7045.738270] Memory failure: 0x194fe00: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7045.758885] Memory failure: 0x1950000: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7045.779495] Memory failure: 0x1950200: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption
[ 7045.800106] Memory failure: 0x1950400: Sending SIGBUS to 
fsdax_poison_v1:4109 due to hardware memory corruption

That's too much for a single process dealing with a single
poison in a PMD page. If nothing else, given an .si_addr_lsb being 0x15,
it doesn't make sense to send a SIGBUS per 512B block.

Could you determine the user process' mapping size from the filesystem,
and take that as a hint to determine how many iterations to call
mf_dax_kill_procs() ?

thanks!
-jane



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

