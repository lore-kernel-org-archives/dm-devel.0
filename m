Return-Path: <SRS0=F9kp=KW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E8C47089
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:21:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39B8F613AC
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39B8F613AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-V3I7p3DPMUqFcD3gkArMRA-1; Thu, 27 May 2021 01:21:42 -0400
X-MC-Unique: V3I7p3DPMUqFcD3gkArMRA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AD5C180FD67;
	Thu, 27 May 2021 05:21:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D34485D764;
	Thu, 27 May 2021 05:21:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8AC731800BBE;
	Thu, 27 May 2021 05:21:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14R5LZQt017994 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 May 2021 01:21:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AC2731054F80; Thu, 27 May 2021 05:21:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A71481054EB8
	for <dm-devel@redhat.com>; Thu, 27 May 2021 05:21:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABCCB101A531
	for <dm-devel@redhat.com>; Thu, 27 May 2021 05:21:29 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-562-UsB-2y_KNMGwxvVmeWv9cw-1; Thu, 27 May 2021 01:21:27 -0400
X-MC-Unique: UsB-2y_KNMGwxvVmeWv9cw-1
IronPort-SDR: nXzluAwSe5wZnFeWrd1JRg+O98nTgozX72NF7ZLk3xT5xpXhKbFZzTftt6H6bbUSSY1khVX15A
	ITj8iXBduutcDFV5tK7DhFkzFVp52HkkAvpJb0PzUtwle6fGhZgrfB8txZqFEPiWLxYPCwp1bM
	+OYWnynKL/Ok0RXeVIESbrVz6i8MsSVDgRURlvAXEKjmVd6yuR6WqUhL8XIbyBDnG8+DW/qJpt
	X7gaWB0hkxLSVH6i1y0JDVTkyJ1I0q3jssHBm5yGbJw5peuyA5dTD6o1/zghS5KnLlnWIXATht
	N2o=
X-IronPort-AV: E=Sophos;i="5.82,333,1613404800"; d="scan'208";a="174286395"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
	by ob1.hgst.iphmx.com with ESMTP; 27 May 2021 13:21:24 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB6777.namprd04.prod.outlook.com (2603:10b6:5:24b::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Thu, 27 May 2021 05:21:24 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.020;
	Thu, 27 May 2021 05:21:24 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [PATCH v2] dm-kcopyd: avoid useless atomic operations
Thread-Index: AQHXUjmx7iH8NlEnmkSIn41as1ZK0w==
Date: Thu, 27 May 2021 05:21:24 +0000
Message-ID: <DM6PR04MB70817B208C96D2F568927EA3E7239@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <alpine.LRH.2.02.2105251548340.29706@file01.intranet.prod.int.rdu2.redhat.com>
	<CH2PR04MB70783B1B24BD10E2BE380D1FE7259@CH2PR04MB7078.namprd04.prod.outlook.com>
	<alpine.LRH.2.02.2105261013460.25928@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c8f130e-c35a-428e-91f4-08d920cf4577
x-ms-traffictypediagnostic: DM6PR04MB6777:
x-microsoft-antispam-prvs: <DM6PR04MB6777DA547D06170C3A0483A8E7239@DM6PR04MB6777.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 12xEXs8XTLtm5D7mYIZehXePY8Uz/gjyv0bcHqVozdMfE/rn6HURbyjL7Jxc+Jg2/283fcUjjGp5tpCKVlKpfjs6RlASNgpYeWOlRyUkbyIOc00afpk8INfnnLvrBNlfI+C1jaDLoNIJkswWMKgIX13sB4/xZdb0e9oPBKa6UC70ejAI99AtJ22dYul7mHau6+92NyzS+tDD/tbPTUU3Yb6gN5g/rIpZDLfkE+9I0DAxaS40rBh6q2qiLetmV5KvEzkxkGqvU8dDztco3NLI2Lal3dPhbrOhLwELOTPqI16AElVMd+3xjfBv153LgO3RYLvAePmRz2xNLH+RHgXhmj43xp2OOD/iLqQImxA/kZxGSEiReH0d9wY22CPQitLYJTtu2bXO2M+Pz3PhX6+M6m/2XfSmXp/STjP1ZjnkUqPbsX9thIGN3COKyL1SIXKZbbY72N+qGXoi15Ttb6G5zy9dxthq79Lo4KC40q9q9Yl0dgujrEqaL66CisfzrhZtDtp+/FQro38dullq4vguI6TzjRNc+l1Iwo5ez4xpq1Y3jOWnhrXMg+y1daWrjEUsjfpjUtEnYUq5VTwWrttIeK0SLMmCEe2jHbMlYSreVbw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(66446008)(8936002)(8676002)(86362001)(2906002)(450100002)(53546011)(76116006)(52536014)(5660300002)(91956017)(54906003)(316002)(66946007)(66476007)(6916009)(83380400001)(186003)(64756008)(66556008)(38100700002)(122000001)(478600001)(55016002)(26005)(9686003)(33656002)(4326008)(7696005)(71200400001)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7Ccz/LBbnvyC7kwgyUlHSma2EW+BCkpGzwZyYALntu26vOaclWzCsVIPslCq?=
	=?us-ascii?Q?I6gKao3gg4ihAK76pVugQ1ihe/dm9tW3TuKt8QufX28FlMqM12CNyernxH4n?=
	=?us-ascii?Q?mCs+t8a3uy8USwUoxKJ2MAt6saGv5KV6JwB6Uax7BpI4fSH5CPIqPEpbZtgK?=
	=?us-ascii?Q?Ay+/dWL1ydBk+2Xg/8EEfDT5zNKqDYeXha6CsTnuosY2lp3lTmk1ir1iq3zP?=
	=?us-ascii?Q?yIOHzsfOYVBID/st5/zV9f2rqI5/fPj9QzB5gS8k8l5x6YyZwN/ZcTz3efLT?=
	=?us-ascii?Q?yrPEdqeX0J6spQ0LGcFxgzWu709R9j/T57FhV5aXkg/0vMQRMc/SWUwTGRDQ?=
	=?us-ascii?Q?+kf+c97d181Z6CNE4kTJ0sGNRvhLxZOCg9s2pXfyY9+HPEj6tRvaq//K7hoX?=
	=?us-ascii?Q?VvgDtL1Q000J2SR+Xg0nLd8ogFjxsigaPNvJMWmEo8R40Qm7jzT/kyzX5vgc?=
	=?us-ascii?Q?567ovqJnXRSiAdFjsVpIRepn+MigSUc3Pfvql6ROoI3TzSuSiWOi0ljukAC1?=
	=?us-ascii?Q?BEdOcZV/5jwvQ4H32J1wsGuU2cDN9EuWb2naB+cTr1jCkr83SF89sKn6AGRe?=
	=?us-ascii?Q?udyTZpeMX1Pe1aV8cXD0BcvKfo/r4/1svCffEmHiYWFmP6ogMLLQlxTpInwb?=
	=?us-ascii?Q?9DHVtc4Jttt2YtdJBcY/Oovh3CifzEIEYfFTEKHWPVXi76cLIUeIO4CHbGZd?=
	=?us-ascii?Q?MrGMcbrnY8ANTx4cEup3+V138f94P6BssXld7TJKghskHocESS2F1Jjl+vio?=
	=?us-ascii?Q?tZnfZ9Tin4Qvbnkms2nL9RjThaEwcQHqmzVZLkCPlfkmGGhgGpHvoAcAJbZN?=
	=?us-ascii?Q?FMIj4NiIpzz3SY/gLCzSCkt+h0xn+Gj5zLpKwEORC10ciTBXD5kx1w1ARU8A?=
	=?us-ascii?Q?igdoeZi5HhkBQDqPMmJ0W83d/6foWr82URFcOFoP/2Bw5M1mtnRQo+ncumWu?=
	=?us-ascii?Q?J7J9ozlqcRHM+A9AVbp7GCJa9HSlu8a8W3rgDYxc2Xi5tnR5VyUj+lZCTXeQ?=
	=?us-ascii?Q?ru1m2ykoL15zC5VzlFY7Ot6vppV5T2CYc0UgkfrkpAvva8TPq9LEw1S+J/HZ?=
	=?us-ascii?Q?rAjvoYiG9nRWQLaVUS0rZqaWYiZQ3987aFHqRr1qAiTe840gVU2tOlfk7Pt+?=
	=?us-ascii?Q?CVRVFJ5RPy5mV+8dJrv2XlhRc5QRcYD/qBn+Tc2U4X/EhgeHzC4bIZTSCLEK?=
	=?us-ascii?Q?SBaIecr2rEKZhtSYcFoEercFQQos33d+Ej3OYHz+ou2st0GysAFKEh+Ra2rQ?=
	=?us-ascii?Q?nid9ckKBPcroD8V+hfvNkU+6MpnAmlKwbaCn5qYRjtmjXKHf0nfcP6VSNPz2?=
	=?us-ascii?Q?/ko9v/y3waE5afLQ+l9dNvQFpsPok6v3ec1hQM9kUQ4AyA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8f130e-c35a-428e-91f4-08d920cf4577
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 05:21:24.4771 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lJQ3J0N0orUJguU1aq8XQE3UAKim/vGcPwKk9vn4OeLe4IJOS0BwnxerJf041MKd7VJVChlh/Z70JC6ojc0SXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6777
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14R5LZQt017994
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-kcopyd: avoid useless atomic operations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/26 23:16, Mikulas Patocka wrote:
> 
> 
> On Tue, 25 May 2021, Damien Le Moal wrote:
> 
>> On 2021/05/26 4:50, Mikulas Patocka wrote:
>>> The functions set_bit and clear_bit are atomic. We don't need atomicity
>>> when making flags for dm-kcopyd. So, change them to direct manipulation of
>>> the flags.
>>>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> Index: linux-2.6/drivers/md/dm-kcopyd.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/md/dm-kcopyd.c
>>> +++ linux-2.6/drivers/md/dm-kcopyd.c
>>> @@ -812,7 +812,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
>>>  	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
>>>  		for (i = 0; i < job->num_dests; i++) {
>>>  			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
>>> -				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
>>> +				job->flags |= 1UL << DM_KCOPYD_WRITE_SEQ;
>>
>> How about using the BIT() macro ?
>>
>> job->flags |= BIT(DM_KCOPYD_WRITE_SEQ);
>>
>> But I know some do not like that macro :)
> 
> Yes - it is better to use it.
> I also changed flags from unsigned long to unsigned, to make the structure 
> smaller.
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> dm-kcopyd: avoid useless atomic operations
> 
> The functions set_bit and clear_bit are atomic. We don't need atomicity
> when making flags for dm-kcopyd. So, change them to direct manipulation of
> the flags.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Index: linux-2.6/drivers/md/dm-kcopyd.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-kcopyd.c
> +++ linux-2.6/drivers/md/dm-kcopyd.c
> @@ -341,7 +341,7 @@ static void client_free_pages(struct dm_
>  struct kcopyd_job {
>  	struct dm_kcopyd_client *kc;
>  	struct list_head list;
> -	unsigned long flags;
> +	unsigned flags;

This triggers a checkpatch warning. "unsigned int" would be better.

>  
>  	/*
>  	 * Error state of the job.
> @@ -418,7 +418,7 @@ static struct kcopyd_job *pop_io_job(str
>  	 * constraint and sequential writes that are at the right position.
>  	 */
>  	list_for_each_entry(job, jobs, list) {
> -		if (job->rw == READ || !test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
> +		if (job->rw == READ || !(job->flags & BIT(DM_KCOPYD_WRITE_SEQ))) {
>  			list_del(&job->list);
>  			return job;
>  		}
> @@ -529,7 +529,7 @@ static void complete_io(unsigned long er
>  		else
>  			job->read_err = 1;
>  
> -		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
> +		if (!(job->flags & BIT(DM_KCOPYD_IGNORE_ERROR))) {
>  			push(&kc->complete_jobs, job);
>  			wake(kc);
>  			return;
> @@ -572,7 +572,7 @@ static int run_io_job(struct kcopyd_job
>  	 * If we need to write sequentially and some reads or writes failed,
>  	 * no point in continuing.
>  	 */
> -	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
> +	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ) &&
>  	    job->master_job->write_err) {
>  		job->write_err = job->master_job->write_err;
>  		return -EIO;
> @@ -716,7 +716,7 @@ static void segment_complete(int read_er
>  	 * Only dispatch more work if there hasn't been an error.
>  	 */
>  	if ((!job->read_err && !job->write_err) ||
> -	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
> +	    job->flags & BIT(DM_KCOPYD_IGNORE_ERROR)) {
>  		/* get the next chunk of work */
>  		progress = job->progress;
>  		count = job->source.count - progress;
> @@ -809,10 +809,10 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
>  	 * we need to write sequentially. If one of the destination is a
>  	 * host-aware device, then leave it to the caller to choose what to do.
>  	 */
> -	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
> +	if (!(job->flags & BIT(DM_KCOPYD_WRITE_SEQ))) {
>  		for (i = 0; i < job->num_dests; i++) {
>  			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
> -				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
> +				job->flags |= BIT(DM_KCOPYD_WRITE_SEQ);
>  				break;
>  			}
>  		}
> @@ -821,9 +821,9 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
>  	/*
>  	 * If we need to write sequentially, errors cannot be ignored.
>  	 */
> -	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
> -	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags))
> -		clear_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags);
> +	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ) &&
> +	    job->flags & BIT(DM_KCOPYD_IGNORE_ERROR))
> +		job->flags &= ~BIT(DM_KCOPYD_IGNORE_ERROR);
>  
>  	if (from) {
>  		job->source = *from;
> Index: linux-2.6/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid1.c
> +++ linux-2.6/drivers/md/dm-raid1.c
> @@ -364,7 +364,7 @@ static void recover(struct mirror_set *m
>  
>  	/* hand to kcopyd */
>  	if (!errors_handled(ms))
> -		set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
> +		flags |= BIT(DM_KCOPYD_IGNORE_ERROR);
>  
>  	dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
>  		       flags, recovery_complete, reg);
> Index: linux-2.6/drivers/md/dm-zoned-reclaim.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zoned-reclaim.c
> +++ linux-2.6/drivers/md/dm-zoned-reclaim.c
> @@ -134,7 +134,7 @@ static int dmz_reclaim_copy(struct dmz_r
>  	dst_zone_block = dmz_start_block(zmd, dst_zone);
>  
>  	if (dmz_is_seq(dst_zone))
> -		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
> +		flags |= BIT(DM_KCOPYD_WRITE_SEQ);
>  
>  	while (block < end_block) {
>  		if (src_zone->dev->flags & DMZ_BDEV_DYING)

With the above nit corrected,

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

