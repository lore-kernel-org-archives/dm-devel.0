Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A96C25B4E
	for <dm-devel@archiver.kernel.org>; Mon, 23 Jan 2023 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674435609;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+FyHBZiJ3PLdhWL4o2gGtZQJY5fBFI5nl5WY9yJtuxM=;
	b=EYwbmy99jBKetL35WkiW5O7MGfalDv1lqyr7W7o+pE60ei+PkHQgSVnWs9cKaqmSjCVrJS
	xo8CGFdznRuiOF1sGvzxMwQ0SVxVj1dQeglWhEq5fI2f+NE9DscLKXQEJyj+UzBjtWlMX4
	BJc3lmnTRJKIxIQ+kd1plJIPPS8t5co=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-QaztaoaPOwCCjYHSBj06oQ-1; Sun, 22 Jan 2023 20:00:08 -0500
X-MC-Unique: QaztaoaPOwCCjYHSBj06oQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2971D811E6E;
	Mon, 23 Jan 2023 01:00:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42B5B40C2004;
	Mon, 23 Jan 2023 01:00:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C5C31946587;
	Mon, 23 Jan 2023 01:00:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D3E091946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 Jan 2023 01:00:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4ACBD492B00; Mon, 23 Jan 2023 01:00:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41293492C3C
 for <dm-devel@redhat.com>; Mon, 23 Jan 2023 01:00:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 207E5858F0E
 for <dm-devel@redhat.com>; Mon, 23 Jan 2023 01:00:02 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-Yj0FmCTJNzCFawLyPSbCxg-1; Sun, 22 Jan 2023 20:00:00 -0500
X-MC-Unique: Yj0FmCTJNzCFawLyPSbCxg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 00:59:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 00:59:47 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Thread-Topic: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status, an
 expansion plan for the storage stack test framework
Thread-Index: AQHZK5fy4D60HvoJAkGWFwtQ6nnwK66lAiUAgAYyowA=
Date: Mon, 23 Jan 2023 00:59:46 +0000
Message-ID: <9a8c1645-c4bc-728e-6002-ae6986286c56@nvidia.com>
References: <e24383ca-8ba8-3eb3-776c-047aba58173d@nvidia.com>
 <20230119022056.plpe5wejji6gl3fp@shindev>
In-Reply-To: <20230119022056.plpe5wejji6gl3fp@shindev>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA1PR12MB8517:EE_
x-ms-office365-filtering-correlation-id: 8b1056ca-b516-4f69-aa10-08dafcdd1f45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ceh3TeHXQLnkHPtdtlBJeA6YB0aKpHo5VCYBAGZQdMSExyFEtNvbl7IR9vcPFYHWWkRT98slm0BZT0lilwZnaEt6z+jXKsd/SybXJyLe+jlxsx0S1c1i+ccD4L5bOLDPaPHPfbS3xlXAaa6OV3+bvq7SS3MXwLrVz8eLV8nq5H4S6ZQsIu10NUU3Bcrl/EYq3zavs1F7U3+JAJtUKBtNULHYfwRwWI4/hNTYWyXbWnppBodobPl5w7wwffi43had5hMfI9oeZmVzz3qErR4INWgM9nSHNuNorbaaDycqzCS7P/c76IWNOIIeh4hAcZf3rNJi59BbXHdATsvMdY3VyXoBg6PoxKdDNk9IM0cPF1FLyTrWh5IWBJ1C/3nycpldXruTyGYq/qqSXNmIzcZBy4kyRrdW1A1SMXd+CVZVo+wFa7KfkmEZ41k92E05WummJTOilbQa942qo8OvneT7S6HfqJVGAV2FX11h8UUTVluiDDPYayFkARwfI88WKZHevfsbB8cOra24nVdc5D17KUsoyQTxK2+CeB+ccpxocE6Eu36ygkT8B7U9CeEoWMPW4r9GXgB0fV98c8OiWtlj2uD70kwZDg23bsvV5R0fmLJ0Gm088hAVt2O6zUgNJpbZwQlCQ+rImm/kcb4SXQgO3C1puPS9+3Fdp/lyU85eeQy0pZ4IviDubGwtzIu4eJC0pX+TncttcLe08+tyIx5keV2wIUCzlerrQtQJ946W+8kzTxy5goLsK9++0XV5HpNHX1XFct4dCA5CC6F2Tl83/X6elqEBgO13gDbLZ4fvduHGF96JMlDbpDzb03iECF9bjeqTXMmu5Ye5WcUOfmSelhcMbPHjwiphTUm1YkIUicw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199015)(8936002)(31686004)(4326008)(7416002)(66476007)(66446008)(8676002)(64756008)(66556008)(66946007)(91956017)(5660300002)(6916009)(76116006)(53546011)(71200400001)(38100700002)(31696002)(478600001)(2906002)(6506007)(186003)(6486002)(36756003)(966005)(2616005)(316002)(122000001)(54906003)(6512007)(83380400001)(41300700001)(86362001)(38070700005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEhYSFlMMWk2eHdGSklhVVFHbENHQW1ZdTljbERiOUFZMFR1R2o2N3lCYnJp?=
 =?utf-8?B?ejNGUzZaTW1mTVlBZUpMUVFmNWdoemVWT1RZMGQrQVZMVi9CTmNMcmpCM0lv?=
 =?utf-8?B?RVVFVk5jeTZmVmlnTDRmaUpQSE1yT3NiR3RSOE9wMnRrVGdrN3A2WW9VbldD?=
 =?utf-8?B?V2dvR0YzSThSWk1tZmtLRmx4S2RyQ2tnL0praXdDRE5zRUZLQ25GZWtMMUFz?=
 =?utf-8?B?a2pYbDJYU1BERC9oNGdmT3l4MTVDdXNlTkxuckpWUlhuVUJFdDc4TzhCT3gx?=
 =?utf-8?B?YVBUSjkrOFhGR3FMMVVmRUZ3M3JVMkFsYTFFNmRZaFZOZlNZTzkyaHpqaFB4?=
 =?utf-8?B?ekI2aUFrcTVsbnVjazJNRVVKZjd3U3VWNmxVQVd6RUg0WUNZSnhlT0x5Z0pk?=
 =?utf-8?B?aTVCWWRWbkFRTWFrdFhUMWNJa0FVRFYxcVYzWWZNMmhXaW1aVDl1NGtrTjNp?=
 =?utf-8?B?aFIwTldnUkFFU0FYQkZpT1RockMvUk5OWWR6djRtamFUM1dOZjM3Mkh5eWds?=
 =?utf-8?B?aXhKQlhMcFp6a2d6dlRKR0trcmFlZjhKQVd3YkVHVTFOcjVUdklEVUYxUk5P?=
 =?utf-8?B?dysrRm5DTWxUelJWcWllTE94eFV5Q3U0REcwYU03OW1IN1VPbk5JWTFGbWZj?=
 =?utf-8?B?eFEwbVpYZG9Gb0RkMGNXYnBtd0xHTmRoZ3pTVklhbXNTZWYxa3p4OXZ1Q1pT?=
 =?utf-8?B?dE15NDBTTUhkUVlmV1ZzWEVtTlIydTFCeWhYaXFRK1hvbTJpQ3M2UnlzMlNk?=
 =?utf-8?B?SHk2Z1hjMm50TjJ2clJNYTljKzhMUVp0OWFZNzhDckRMR0h2VEZaVVZDMkVv?=
 =?utf-8?B?WUk4VGpTRWI0UVNOUC9xaXFZTXBYb2lGMGQ3N2llOEdqRmlZdzdaVm0vVzlN?=
 =?utf-8?B?azIrZm5VdERqeU9SSzNKUHRyVjlsa2JjQ2tNcEw3RjgzZURTaWFnRzlkYmF4?=
 =?utf-8?B?ZUlabHZQamNaR09TR3l0b0YwOVMyZFgzVkYyY2VyelBSTWRRUjI3ZEVHbDhi?=
 =?utf-8?B?U2FpTWlHTE5LNFV5MEdvU0dmM2JwYnhZcGdjMWlzQzVCN0thK01EdFVHMmdx?=
 =?utf-8?B?R1pCSWRsSFBzSUNJZ3AwT1JXZmR4WXdvYU9jTmlIL1lXTzZpUy9KdDUxQ1Rp?=
 =?utf-8?B?TmdUeEpBQ0hkcGx0OWNLNDJiMldLdVdHOWtDOTluUkFUN1lvR09IcGhFemIr?=
 =?utf-8?B?dTN1b2dPdmRxK3A5cUJvRnAxSkJmUUxlbkc0N21qb0c4SDhmeStyeXhMNWVY?=
 =?utf-8?B?Sm5ONS9jcmNIWXJjbGU5NEtKem1SM1lpN01xYTVyd1BoaUdLSHV6YnlCTGFI?=
 =?utf-8?B?OUc3S2dzTjRxWktvV0k3bXVQRkN6Mmp1Y2pDMmI0OExKN3A4dEoxQXIyWU54?=
 =?utf-8?B?T1VLV1g0Nm0vNTU1cnJWQ1duclFsVFM2aTlvbjN1Y09GTXFRMlRPc3Q0K2Zu?=
 =?utf-8?B?OVIwakFpYlJKR1AySFhFdCtRODZiZ0U2SXFpOWVaUElLNUQ4QW9Bc2t2OFRm?=
 =?utf-8?B?Mk9UVjVQSzRNS3dKYm5UL3kyZW1YQlZlWnNMcFc4NkVXeElhTXJHaUFVYnY3?=
 =?utf-8?B?T2pYYXhHNC9GaUJSOUlPV1Y5MmE3bWttZHdDVUFhV1I5OEM4TU95cFRBQmxL?=
 =?utf-8?B?RWRRYjZNSkl4OXBMVFBPTUpqYnpqSWJBdWYxT2lncUFNZjlWR2Q1ZjJHR2ta?=
 =?utf-8?B?SkRLYmtqRWZURVlMZFlOb1dWbnFGSHpyQ3Y2Q1YrZ3FqWG9pSmR3eXltb3dJ?=
 =?utf-8?B?UVJHN3E5cFlUV2VhbGxaMzNCcVBjY2h4OE10bU1GQWdQQlZULyt2bCtyRjBP?=
 =?utf-8?B?bzQ5V05yRnpKYXAzbXNLSjMyTFN3c1BQa2VyZGNUWklZcTNZTm9zOU5Xcnhw?=
 =?utf-8?B?S1dLNVI3ZUhDUi9RQWZ6QzMrQnoxUUlBNURHbFAxV3ZkQStKNFRNc25Ka1B0?=
 =?utf-8?B?MUhQVVF6b0ZMcE52SzUxRmpBSlFQYWY3bmc4Z3l2ZS8yUVdDbHc4V3ZHOEdq?=
 =?utf-8?B?a1hPbjcxYjg3bEZVL2ZMSWxXbFpNVThJRzlRWWI1VWNXeEZuVDhwZjE5Q3pT?=
 =?utf-8?B?VnpYc1FvYVZqNFVRdGdaVkNncmp3SUVUZGlrVTZwRk1qRVZkVWk4KzR3UUsr?=
 =?utf-8?B?ZmRhVlF3ZDd0aWlnalFoNzd1NW0vanNneGswS3hrR1N3aEltQzc4eU0xdXZl?=
 =?utf-8?Q?GLJR351scyqBp4Z7gFC14zGFYgy89s+j6bcnihMRWhCU?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1056ca-b516-4f69-aa10-08dafcdd1f45
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 00:59:46.8665 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WrvqsW1zl1FQyfnjAbRNKCsyJLDBltvrgHlIe2qRTKGEgDcrA6VS4VFjihk7vTb8dkefXbktbJ80lsN3hrdvLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests:
 status, an expansion plan for the storage stack test framework
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
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Keith Busch <kbusch@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
 Theodore Ts'o <tytso@mit.edu>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jack@suse.com" <jack@suse.com>,
 "linux-fsdevel@vger.kernel.org>> linux-fsdevel"
 <linux-fsdevel@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FD02A1E988E6D34EA2DBF52D34455603@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/18/23 18:20, Shinichiro Kawasaki wrote:
> CC+: Mike, dm-devel,
> 
> Hi Chaitanya, thanks for bringing this up! I definitely want to join and learn
> from the discussions. Here I note my comments about them.
> 
> On Jan 18, 2023 / 23:52, Chaitanya Kulkarni wrote:
> [...]
>> For storage track, I would like to propose a session dedicated to
>> blktests. It is a great opportunity for the storage developers to gather
>> and have a discussion about:-
>>
>> 1. Current status of the blktests framework.
> 
> In the session, I can talk shortly about recent blktests improvements and
> failure cases.
> 
>> 2. Any new/missing features that we want to add in the blktests.
> 
> A feature I wish is to mark dangerous test cases which cause system crash, in
> similar way as fstests does. I think they should be skipped by default not to
> confuse new blktests users.
> 
> I remember that dmesg logging was discussed at the last LSFMMBPF, but it is not
> yet implemented. It may worth revisit.
> 
>> 3. Any new kernel features that could be used to make testing easier?
>> 4. DM/MD Testcases.
> 
> I took a liberty to add Mike and dm-devel to CC. Recently, a patch was posted to
> add 'dm' test category [1]. I hope it will help DM/MD developers to add more
> tests in the category. I would like to discuss if it is a good start, or if
> anything is missing in blktests to support DM/MD testing.
> 
> [1] https://lore.kernel.org/linux-block/20221230065424.19998-1-yukuai1@huaweicloud.com/#t

we really need to sort out the dm testcases, without dm testcases it
not allowing us to create baseline correctness for block layer,
I've already discussed that in the last LSF.

> 
>>
>> E.g. Implementing new features in the null_blk.c in order to have device
>> independent complete test coverage. (e.g. adding discard command for
>> null_blk or any other specific REQ_OP). Discussion about having any new
>> tracepoint events in the block layer.
>>
>> 4. Any new test cases/categories which are lacking in the blktests
>> framework.
> 
> One thing in my mind is character device. From recent discussions [2][3], it
> looks worth adding some basic test cases for NVME character devices and SG
> devices.
> 

Agree

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

