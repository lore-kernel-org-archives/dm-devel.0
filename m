Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF137C0018C
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:45:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FC5222EBE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FC5222EBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-0GlbfG-MMWWEOI4D_RgHBA-1; Thu, 10 Dec 2020 09:44:55 -0500
X-MC-Unique: 0GlbfG-MMWWEOI4D_RgHBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70469809DD2;
	Thu, 10 Dec 2020 14:44:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 492D710016F4;
	Thu, 10 Dec 2020 14:44:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 134AD180954D;
	Thu, 10 Dec 2020 14:44:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B9NEH08014959 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 18:14:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D1DF62026D48; Wed,  9 Dec 2020 23:14:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAF1E2026D47
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 23:14:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4368858EEC
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 23:14:15 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-18-Qg_XFNL0O0C5PH9n5YMOjw-1; Wed, 09 Dec 2020 18:14:11 -0500
X-MC-Unique: Qg_XFNL0O0C5PH9n5YMOjw-1
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	0B9N4iqD026593; Wed, 9 Dec 2020 15:14:09 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com with ESMTP id 35ak7a89mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT); Wed, 09 Dec 2020 15:14:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
	by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.1979.3; Wed, 9 Dec 2020 15:14:08 -0800
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
	by BYAPR15MB3303.namprd15.prod.outlook.com (2603:10b6:a03:10e::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18;
	Wed, 9 Dec 2020 23:14:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b]) by
	BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.012;
	Wed, 9 Dec 2020 23:14:07 +0000
From: Song Liu <songliubraving@fb.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: Revert "dm raid: remove unnecessary discard limits for raid10"
Thread-Index: AQHWznvGWYeJlNK5kEy9X37Df/JOxKnvZQSA
Date: Wed, 9 Dec 2020 23:14:07 +0000
Message-ID: <03EC7F7D-DF6E-4962-BBA7-FA554509C2E5@fb.com>
References: <20201209215814.2623617-1-songliubraving@fb.com>
	<20201209223615.GA2752@redhat.com>
In-Reply-To: <20201209223615.GA2752@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:400::5:d023]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aebea487-bebb-4e59-3709-08d89c982142
x-ms-traffictypediagnostic: BYAPR15MB3303:
x-microsoft-antispam-prvs: <BYAPR15MB3303A59E93EAA3A05A5005F3B3CC0@BYAPR15MB3303.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OPlUyXQKAU8h5+9XHSSZbNjldsv980yP1m6bVd/sm8SqEBoO3JaVMl80IzUZ4/q4aVJ9DuCYCJcugerMJxnI9q1Sal2WTy3T/1TKiuC8Jgg+lwMNzRIL2qOfcYPmqDvM8lSkeJ7NCtJffbKBT8Z9KD9T8bqAS4cs9DHAEHgqbH0QvSEw3gSX3CubwrpVLmUBgvnYH6N41LNRiT/JiDzoqLzSltmGUXY9LDhWe2UmhBXZ7fHSTwH8n0CjzU07n9JQkUY829z/7x3AoAZiqfoGnuJoeHsaIRTeLcVdk90hrE8jouP45+9+KmMEENA55O0QmNlbJ0HQgQHoBO1p6aSzgLS8Tfg0kFfWhKX7nfOYdbeSwGwi5ArYJ6H0WGn0OwiLeqcT7p97YCOgBbL13ZukXUK2RNg33miJmlEY3V1ordXv+eIYC6VHgvqtqEuKrgG2/g0nmvflmTo17IZORkWlFA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR15MB2999.namprd15.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(366004)(376002)(346002)(6916009)(2616005)(2906002)(6512007)(5660300002)(508600001)(66446008)(8676002)(86362001)(64756008)(66556008)(53546011)(54906003)(71200400001)(6486002)(8936002)(76116006)(66946007)(966005)(4744005)(36756003)(4326008)(6506007)(186003)(66476007)(33656002)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lf6F/SsHBi9ex73b0zNBRiNQODY5yFyURMZFGofbohTi5UB/K39twqvlIv4C?=
	=?us-ascii?Q?uAtORMI1Bvmd9NERGZ6YWhzzhbIwU/1Qw8i5LgGEJ7zeKAPlS53TgxM2dMSG?=
	=?us-ascii?Q?YU8Sknb5U2eEvve6PqEptGgDzHgdnttjoYjd4XXAzbM7WE9K9o0PDBjnkWeR?=
	=?us-ascii?Q?3HiqScj/oV/hmTsIU55HjTJKvcUBm9zq3Yu35VwaEjFNJucg8/wafGKyM/v0?=
	=?us-ascii?Q?yKB4jfugqveL4Ap3t6iQ1fnVk8HWuJ/YdDCyrLK4jcUzI/wtYLgmMTJbQloV?=
	=?us-ascii?Q?uQN0FssO1M4rfaGCFqfJarCPGzQtDMopAYFA/vyAhEjeVX0TITbuToMMMfTi?=
	=?us-ascii?Q?kJcHwMJa5QUPBLZzw6TzUAsBjM+zm8J/4cnPYFCHG8autGYPajuKbZAjG9w9?=
	=?us-ascii?Q?l88v0BkFbCL/JZIN5R2sl6EaZ2j5gMJ2YKn+H6M/E5O2otSOP5YGm9LeySfg?=
	=?us-ascii?Q?HTwbbcRl7edupTRsO1cVc7CNj9ttNHYPt1RkC1fspwuH4Y4CskIwD6qIANnq?=
	=?us-ascii?Q?7PP/kBeT3fpiuB1q5sOQ7ln2XrFHa5gCB6A5W6WCgHn1nkswaMHPswMtHOpH?=
	=?us-ascii?Q?WoNZmH3ZuiM3B91PkQ7kObV9Q/Gh48xqLI5K/Ksbwd3YnamPuXWkT4UEztPD?=
	=?us-ascii?Q?OZHfXIzz4gfa7K4ARCIhE6Vv8YgA7VZ4L7eb9/UWGi7v8fvH4dqfiRLCU4w2?=
	=?us-ascii?Q?YMylKh35+Fkkzyg+Y9AIIIsqqyHLx1y9NbxIys31+11GsSOb6kztB4BQc27n?=
	=?us-ascii?Q?MhUJwCS2KTNb6/RhjD2VMUSKazqJp4cT+yru+aXPcNtvyRYY8Hi53rN6y6Oa?=
	=?us-ascii?Q?d6ZTa02AiUsrsd2iZZYgntGUsps6Ib9wGhSyWkX9gQIrBG+nGRSu6jgIW8+/?=
	=?us-ascii?Q?254CpKLqR80xLYc1wvrW4yv5S+9JUIK5OhGzrYeojDwx0B4NbRvxGms73CPp?=
	=?us-ascii?Q?cosnVsXcQpfQHb8eJxpDuvYx07rY7m3WSFcdphg3NY9e7cL45taEKx31HUM8?=
	=?us-ascii?Q?coHigf3IVeDfLLiR4NPF0D4rusj7RasE89ngBtC+7ZMCFRM=3D?=
x-ms-exchange-transport-forked: True
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebea487-bebb-4e59-3709-08d89c982142
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 23:14:07.7995 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCRtnlq/vmdBfoeZnxSiAVpOoPj9CiU3meOYL6wTaPIcZ64oZyzF7rwros4Wt2uFQH1JNV98aIejQ+hhfyWQsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3303
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-09_18:2020-12-09,
	2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
	impostorscore=0
	malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
	lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=951
	priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
	scancount=1 engine=8.12.0-2009150000 definitions=main-2012090159
X-FB-Internal: deliver
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B9NEH08014959
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Dec 2020 09:44:21 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Xiao
	Ni <xni@redhat.com>, Matthew Ruffell <matthew.ruffell@canonical.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] Revert "dm raid: remove unnecessary discard limits
	for raid10"
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <69A71CAB8890E444B48DA3D937DD6248@namprd15.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> On Dec 9, 2020, at 2:36 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> 
> On Wed, Dec 09 2020 at  4:58pm -0500,
> Song Liu <songliubraving@fb.com> wrote:
> 
>> This reverts commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28.
>> 
>> Matthew Ruffell reported data corruption in raid10 due to the changes
>> in discard handling [1]. Revert these changes before we find a proper fix.
>> 
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/ 
>> Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
>> Cc: Xiao Ni <xni@redhat.com>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> If you're reverting all the MD code that enabled this DM change, then
> obviously the DM change must be reverted too.  But please do _not_
> separate the DM revert from the MD reverts.

Good point! I should have thought about it through. 

Thanks,
Song

[...]



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

