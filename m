Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41315C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:12:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7DA022AAC
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:12:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7DA022AAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-mxET2zOGMTG4S4oZto4S7Q-1; Sat, 12 Dec 2020 12:12:45 -0500
X-MC-Unique: mxET2zOGMTG4S4oZto4S7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD32D1937FC0;
	Sat, 12 Dec 2020 17:12:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53CEE6F81E;
	Sat, 12 Dec 2020 17:12:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C132E4E58E;
	Sat, 12 Dec 2020 17:12:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCHCY2q023412 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 12:12:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 218F02026D12; Sat, 12 Dec 2020 17:12:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 189BD2026D47
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:12:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33C92800183
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:12:29 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-549-MFI-D48XNkSxyECSxQhhsQ-1; Sat, 12 Dec 2020 12:12:27 -0500
X-MC-Unique: MFI-D48XNkSxyECSxQhhsQ-1
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	0BCHAlYI013269; Sat, 12 Dec 2020 09:12:24 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com with ESMTP id 35ctsjsch9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT); Sat, 12 Dec 2020 09:12:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
	o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.1979.3; Sat, 12 Dec 2020 09:12:23 -0800
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
	by BY5PR15MB3618.namprd15.prod.outlook.com (2603:10b6:a03:1b0::28)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22;
	Sat, 12 Dec 2020 17:12:20 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b]) by
	BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.018;
	Sat, 12 Dec 2020 17:12:20 +0000
From: Song Liu <songliubraving@fb.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: need help with dm & md raid10 issue
Thread-Index: AQHW0JMnDPTWcyNGHU6la5ijBHt2eanzsr6A
Date: Sat, 12 Dec 2020 17:12:20 +0000
Message-ID: <7A0B2EBC-1033-4442-9053-F982F43DD9A4@fb.com>
References: <C8607BD3-5701-40A1-AA17-62B2A807A751@fb.com>
	<20201212142856.GA21863@redhat.com>
In-Reply-To: <20201212142856.GA21863@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92e7307e-222b-4952-7da2-08d89ec11602
x-ms-traffictypediagnostic: BY5PR15MB3618:
x-microsoft-antispam-prvs: <BY5PR15MB36189D87AA18DA4E435FD314B3C90@BY5PR15MB3618.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YzlDKcyUI/pxnGevpcdPWen+Z5ackmz9DBXbzuyiCEdj1WhND1dcT5ooX6zxd7mHyvCp/MNCNkeRyrYLbf67tsOwy9hn8PVv7rZ2hQ0CtZKGdy8bjU5nHBVV5PurqP1w5XdREmnzyHHziahBjQ6iI+eBS1bYiECeSR6MZpnyVG/NG877kYs1Yv15hK7FtF8qpyV+8VQmsCl2Aau85slKprjuoH35dL1eXzvZrJQ5TlTMfoxAHG9jz3yFLujj8UJYWf3nR+tAoAqMF0hfv/OXilJ7uGeg6dH6CZ0Yu0G63D86wtgNA57Ny8V6euzBUHj0UYM9F7lGDLJJ5Iqr/EangC95quRM3nKp+ymo0x67ng5as2jxzOudRm32+UJPxpcaTM+jYMPrecAhbzzuFRjPViAHPG4XGC152mQxOSem1+xulMqYbPe3WQpTECDuKxi63k1RPXrM45Mp+kzRIJqYPg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR15MB2999.namprd15.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(376002)(366004)(346002)(54906003)(64756008)(66446008)(86362001)(2616005)(66946007)(53546011)(4326008)(66556008)(966005)(71200400001)(66476007)(6512007)(91956017)(83380400001)(2906002)(6506007)(76116006)(8676002)(6486002)(6916009)(36756003)(508600001)(33656002)(186003)(8936002)(5660300002)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BL2YiEqHMQdwJTV+fHlgJStaHB+pqN820gbuuQ5madiiPf0rLmLqUUCc0awI?=
	=?us-ascii?Q?2ERuVisxqBUxGwQkMYFkJkotAeAAGDDiH+yMYrWr0pVZoDxaExfNM9m2H9km?=
	=?us-ascii?Q?twYeBzFsF7+MsAK1cyiQpNpBit+Bc9L/Ff6Xo93j3ihwpPbkbE5h97mpso6X?=
	=?us-ascii?Q?l0N2LMy7ao8y0bC8LlQM7N2bFYO6CKRprMLwwQle3D35/2zDQdsjtHWLi5vh?=
	=?us-ascii?Q?u82M6Z5mNk2W+oXxjYuJ5lFfAQYjDsI0gXWnHSkkj2VImNeOIqxKoeAzzWPU?=
	=?us-ascii?Q?naeoZ5FL5ZQueK8IRlFfOkg1DxqMX+u8BY1Fyw8DsOnYIr+VAexzwrB2BSCW?=
	=?us-ascii?Q?spt383UZ86YuNpFM7vg6GULyC6vc7Srg41fEHncapE59YapS571EgbLTBbq8?=
	=?us-ascii?Q?xIHkuQ+xH6YR2i3ifMg+P+Mw5dw0wS49rQz4c7kg8ALSwZcpO5oOt0fIoq0u?=
	=?us-ascii?Q?WcnHQmOtY2inXFptJFxyLrpWgju4PozB9i6sluYnXFXVfN7kvc3AZMC/eLLO?=
	=?us-ascii?Q?EwrpNjH+kn9AS6qhUkdRzHnRqDL3fN+RhtH3/DfqLQriED4ulcSYMmy1W7ZU?=
	=?us-ascii?Q?qzkJ8+YvnUC0eGnC0iz3ytyleUq//UA5Jk+RU7ytoY1hM6M+sZ4uc7PLfN0f?=
	=?us-ascii?Q?O1UM0om9k3P/qrQvvDkBFxzFvbuvgKYxBtbAyyD9V6E1vxzkKXArJr1d6Kd5?=
	=?us-ascii?Q?aPVkPDzkwhnhssWynPCRFBmioOldXjKDCoFkkyGowgBTfpEiM6yVGEqpye6l?=
	=?us-ascii?Q?Gucox1Ti6BKhQBw3c1/A+rBg1nFBeZ3C/xbRcUTnPTgFMZ8L2GuTz7VgS/Hz?=
	=?us-ascii?Q?jHsMZryzfEOrGgssuvUToVN+tgPLBo32KGTGFAivLxpzG/PCzGJ1tnSqsL02?=
	=?us-ascii?Q?plFD97TIa8K4lVl9XmHwIBbE8CNOTE4crhYkiSvyI9CZsKF6+4XnP+EaBaDt?=
	=?us-ascii?Q?J7+nV2g2KpRdCN6QAGnzeL0d27TMl9zgMkwr3rC+JzMOMExLMnwFYdXaRrhw?=
	=?us-ascii?Q?XsOUm7588GebcWnrVFGP9FtG0r/oEZkFIRCL+mO17643L+c=3D?=
x-ms-exchange-transport-forked: True
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e7307e-222b-4952-7da2-08d89ec11602
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 17:12:20.6914 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LeKhPVXGFuQMjv/yTMc7slRGuvSWJrOCRHRk8QCwX2233hgY0FCVreSQtbckb8HFIh6vlZd33I1BbI0UZcVaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3618
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-12_05:2020-12-11,
	2020-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
	spamscore=0 clxscore=1015
	phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
	mlxscore=0
	suspectscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012120134
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BCHCY2q023412
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Heinz Mauelshagen <heinzm@redhat.com>,
	Xiao Ni <xni@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] need help with dm & md raid10 issue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A05C4B4EFEE09F4F9ACBD14246868EC1@namprd15.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

Thanks for your timely reply over the weekend. 

> On Dec 12, 2020, at 6:28 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> 
> On Sat, Dec 12 2020 at  3:42am -0500,
> Song Liu <songliubraving@fb.com> wrote:
> 
>> Hi Mike,
>> 
>> I am looking at the a new warning while reverting the raid10 changes:

SNIP

>> We are looking at 7 patches, in the original committed order:
>> 
>> [md1 - md5]
>> md: add md_submit_discard_bio() for submitting discard bio
>> md/raid10: extend r10bio devs to raid disks
>> md/raid10: pull codes that wait for blocked dev into one function
>> md/raid10: improve raid10 discard request
>> md/raid10: improve discard request for far layout
>> 
>> [dm1 - dm2]
>> dm raid: fix discard limits for raid1 and raid10
>> dm raid: remove unnecessary discard limits for raid10
>> 
>> dm2 depends on the md1-5 changes, while dm1 doesn't. 
>> 
>> I reverted md patches and dm2, which caused the new warning above. I 
>> didn't pay much attention to it, because I thought I was reverting a 
>> patch, so I just brought back an old warning. However, this was wrong. 
>> The warning was introduced in dm1, and fixed in dm2. Therefore, there 
>> wasn't warning before dm1 or after dm2. It happens with dm1 only. 
> 
> OK, I see it when I revert f0e90b6c663a7e3b4736cb318c6c7c589f152c28
> 
> But a simple cast silences it:
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index dc8568ab96f2..8e04a4cb16a4 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3736,7 +3736,7 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
>        if (rs_is_raid10(rs)) {
>                limits->discard_granularity = max(chunk_size_bytes,
>                                                  limits->discard_granularity);
> -               limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
> +               limits->max_discard_sectors = min_not_zero((unsigned)rs->md.chunk_sectors,
>                                                           limits->max_discard_sectors);
>        }
> }

Yes, this is the first thing I tried yesterday. 

> 
> But I think a proper fix is needed in MD (see below).

And I agree that fixing it in MD is the proper fix. This will be included
in 5.11. 

The reason I proposed to revert patch dm1 instead is that we are about one
day before 5.10 release, and these two versions haven't got much tests. 

On the other hand, as we both checked all the uses of chunk_sectors in MD
code, it should be safe. 

> 
>> At this point, I think our best option is to revert all of these patches. 
>> As dm1 alone hasn't been tested much (and it triggers new warning).
>> 
>> However, as I plan to test dm raid10, I found there might be some issue 
>> with it. I am following https://wiki.gentoo.org/wiki/Device-mapper#RAID10  
>> and using commands:
>> 
>> for S in {0..3} ; do dmsetup create test-raid-metadata$S \
>>    --table "0 8192 linear /dev/loop$S 0"; \
>>    dmsetup create test-raid-data$S --table "0 1953125 linear /dev/loop$S 8192"; done
>> 
>> dmsetup create test-raid10 --table '0 1953024 raid raid10 5 512 raid10_format near raid10_copies 2 4 - /dev/mapper/test-raid-data0 - /dev/mapper/test-raid-data1 - /dev/mapper/test-raid-data2 - /dev/mapper/test-raid-data3'
>> 
>> The second command give some error. After debugging I found raid_ctr() 
>> calls md_run() with rs->md.new_layout == 0, which doesn't work. The 
>> new_layout was initially set to 258 in parse_raid_params(), but got 
>> overwritten to zero in rs_set_cur(). With the following hack, I was 
>> finally able to run tests with dm-raid10. 
>> 
>> =================== 8< =========================
>> 
>> diff --git i/drivers/md/dm-raid.c w/drivers/md/dm-raid.c
>> index 9c1f7c4de65b3..13b624490e24c 100644
>> --- i/drivers/md/dm-raid.c
>> +++ w/drivers/md/dm-raid.c
>> @@ -3178,7 +3178,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>                        /* Reshaping ain't recovery, so disable recovery */
>>                        rs_setup_recovery(rs, MaxSector);
>>                }
>> -               rs_set_cur(rs);
>>        } else {
>> size_check:
>>                /* May not set recovery when a device rebuild is requested */
>> 
>> =================== 8< =========================
>> 
>> Could you please help me with the following:
>> 
>> 1. Confirm it is OK to revert both dm patches, which is available at 
>> 
>>  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>> 
>> This is urgent, as we need it in 5.10 final this weekend. 
> 
> I'm not understanding how the compiler warning relates to your gentoo
> recipe's failure (seems it doesn't).

It doesn't relate to the warning. I brought it up because I found I 
didn't know how to test DM-RAID properly. 

> 
> But given MD raid1 doesn't require bio splitting, reverting
> e0910c8e4f87b is excessive.
> 
> Why not do the unsigned cast like I showed above?  But secondarily: why
> is chunk_sectorsin 'struct mddev' _not_ 'unsigned int' like it is in
> 'struct queue_limits'?
> 
> Isn't the proper fix just changing MD's chunk_sectors to 'unsigned int'?
> E.g. this seems to silence the compiler warning too:
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ccfb69868c2e..b0814d8f3523 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -311,7 +311,7 @@ struct mddev {
>        int                             external;       /* metadata is
>                                                         * managed externally */
>        char                            metadata_type[17]; /* externally set*/
> -       int                             chunk_sectors;
> +       unsigned int                    chunk_sectors;
>        time64_t                        ctime, utime;
>        int                             level, layout;
>        char                            clevel[16];
> @@ -339,7 +339,7 @@ struct mddev {
>         */
>        sector_t                        reshape_position;
>        int                             delta_disks, new_level, new_layout;
> -       int                             new_chunk_sectors;
> +       unsigned int                    new_chunk_sectors;
>        int                             reshape_backwards;
> 
>        struct md_thread                *thread;        /* management thread */
> 
>> 2. Help me with dm-raid testing. Is it a bug? Or did I use wrong options? 
>> 
>> This is probably not urgent, as the same command gives same error on 5.9.0. 
> 
> I don't know, likely best for Xiao or Heinz to have a look.
> 
> These private mails are completely unnecessary.
> 
> You really should be communicating with Xiao and Heinz and cc'ing
> dm-devel (I've done that now).  I never even saw any exchange where you
> even ask Xaio about the corruption, caused by his raid10 discard
> changes, that kicked off your cascade of reverts.
> 
> That may have happened and I just missed it.  But if it didn't happen:
> why not?

Xiao and I had brief communications about this issue in the linux-raid 
list. Xiao was on vacation this week, and he planned to look into it 
next week. Unfortunately, that has to wait until 5.11. 

Thanks again,
Song


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

