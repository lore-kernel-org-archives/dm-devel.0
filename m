Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E58EC6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663176011;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XX17P/rAUk+Diem7b/LzAqkDdGp9NCOiyVuUuiu3MJk=;
	b=BqcQbPjE1JM3eDWVonN7oGY8/2sYkfbhhJmRPoIM+j44Ew1/Q3rIkXM8nR9Y892TgJQCSL
	L/Nq56pqsqzchbMIwJeyONRNPi7Xqe2ND4SEMtT53UJhsGvqOk0uny34KaMei2pIhqHWRh
	D6SwS8zUmJTUKG6GRZfSZEk8EVEWltQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-Tyf1Tdn2PgSWmVyTHLETBw-1; Wed, 14 Sep 2022 13:20:08 -0400
X-MC-Unique: Tyf1Tdn2PgSWmVyTHLETBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ABD8185A7AA;
	Wed, 14 Sep 2022 17:20:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 563D040C6EC2;
	Wed, 14 Sep 2022 17:20:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 381101946A55;
	Wed, 14 Sep 2022 17:20:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A1D481946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:20:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 868071121315; Wed, 14 Sep 2022 17:20:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 820C51121314
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:20:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60D293C025B2
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:20:03 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-YRqs42FbNWWZqihiXOnuYw-1; Wed, 14 Sep 2022 13:19:58 -0400
X-MC-Unique: YRqs42FbNWWZqihiXOnuYw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 17:19:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:19:54 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 01/13] block: make bdev_nr_zones and disk_zone_no
 generic for npo2 zone size
Thread-Index: AQHYxoDltGm3Bk/AC0G7Pq3p/7Aq5a3fL2cA
Date: Wed, 14 Sep 2022 17:19:54 +0000
Message-ID: <0daefc87-86d5-e893-19d7-7c018b5e4c51@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082206eucas1p25336d07279850f7009be6b5d1fccf558@eucas1p2.samsung.com>
 <20220912082204.51189-2-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-2-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|LV2PR12MB5728:EE_
x-ms-office365-filtering-correlation-id: 66245184-e193-42d5-34bf-08da96755750
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0ombUhyGnsgPIhLJtiQq+/9OIOXqHMiSr1BRF2+ba8qyazwLtbT5Khod4ZeEPadzSm5Q1Wt1w/I93ZtmFCCGpMYjApi3321YZN4qtONq/dXth8stJsyBQuNXORd+K36UHlP7T0Mw7K5MlrZwrxy67yuRO/PW9fyVu49lSIeIx96GOOTKZ5nz66pdLJzzzM2+wz/DZUP8nzfMtZzINIJkTkvCsTdi/NXhZdYla7OC7kDT10QnGO6SHsK83Dhuo209vGo0ntXM+RZIDmJEkN797FXAUCi6Hbh/aiHqgKuFicSaAJcnEH4uEvfysA0htI1NN5U9uviVzflG6nJAv7VMV/UXdpBkcUwkaerasldCMnCK53Oy+ixkDb7GzuMjJPWyxSWH3sOYu1SreiQs3sETB/f7LJ3jsvDOyDxj3ll60lfmyYMZ3SC7Nxz1jNUbof13MQw9JHgKqzXelosr00NI1slb/Wguu3HYYbjy98+zGCKabeQ+1cgbpUc/yUOhWtDTdcC/LQnhUl0fgMwtZru5vhCGxvkFEteNc6Ojab6wOkBB1WNMAdkvFifMlnd4AVqBsIuAzCGIPDbAbl3tt7CiQangcJ9AXhnfIimCyaXP6w9tNO6pcKAYyerAIImb1DdZSU1NgcgO3CMNJSCoXCmE7YYQ0vHGyO1B0dyCtUhA954llw1xlNUBYdOWT8Z/957QMztLGznYc7+14jU1rT1xlu8456rNLM0vJxXiOlFzVfVogeb41OQY+wvb0WCjooWW3+46CIkaNnim4dvV/ApUj5bxaNlugBTEfoVfWtvMbcjXRszLMvt1OqT7Nw6f9YfH56zCK4Sx0AKsJoFyV+vx4lr08g23Uckar6c4CIpG74I=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199015)(66556008)(66476007)(2906002)(64756008)(66446008)(122000001)(66946007)(7416002)(26005)(31686004)(36756003)(6512007)(38100700002)(2616005)(6486002)(4326008)(91956017)(316002)(76116006)(186003)(41300700001)(6506007)(4744005)(53546011)(31696002)(86362001)(54906003)(8936002)(8676002)(110136005)(71200400001)(38070700005)(478600001)(5660300002)(41533002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmtjUlFySTl0N1NKZkl0VFQ5Z3EvYWxJQTlaWnBPU2xQbzVIZkhwQjl5a2lk?=
 =?utf-8?B?Q05waUY0Z3oyNUZvMXN1UHpnZk1Rbm96R2RZbTl4a3hSbSt3b3JmVm9vNVhr?=
 =?utf-8?B?YWpTMWl4M1hvYnJDK0RzZURxRHVwdzhQWTcwYTdPYk16Y3h5ZG41eWRzMm5m?=
 =?utf-8?B?RTBrZzFMb0RCSGM0Z1lWN2dPT05oNVZ6aEdPY09BejRicGNhbnhOL2lkQUlE?=
 =?utf-8?B?cWZZQVcwUGtRa2h4QTNUWEhGYmg1QVdCVDVDejluVm9BVTIzS2FteElTM0kx?=
 =?utf-8?B?RWpXb2ZKcVdWcVA5RSsrbDZKYjBOMERvd3N3OW9LK2xvdjlyOHphWkF3ZU9v?=
 =?utf-8?B?anBaMXdXeisyWFhXaXRUUEVzdXhiQ0szTTg0U2JvZzhHOCthRHZaQ1MwV2ZK?=
 =?utf-8?B?OFpJc2k5dEJ0dzVJTS8vL2ZoN2dHNVdsTmFFTHZqQzJxUlB1MGlPTmZkd2NV?=
 =?utf-8?B?bVBTYk8zcFZuL2RwdTFOcHZtS1dnMGNMclZKNFJlYU82V0FWaExUVnBEcGZ6?=
 =?utf-8?B?TlF1TStqK2piQXg5SHNUempPdFJFMVlGSXB0dlZFZFZWN2tGN1ZwVElsM1VG?=
 =?utf-8?B?U3I3RS9pQnBmWEdzT0wwZVFMcG5kTmladmZ3SkljVW9KZFlRU3lQUDcyL0Uv?=
 =?utf-8?B?ZmxiVVA1RDBaRzdscUFyQkQvbmNFNzNtY0dPVzI0Ny9nN3dWbFdwSXI4VVRh?=
 =?utf-8?B?eFVhcUJCQjdpcmtveTBVSlhhM3Rad24yR0tJcDFUMlVVZVdKTDVoSTM3UlpG?=
 =?utf-8?B?MjM3bjliZmN1c3A4bk5xVHp3Ny9vNmlPQ01SbU43cFlSbmpDdyszT05XSTlp?=
 =?utf-8?B?d1VpL1ZPTWhSbWl0STBNcER2MkZxeTdEelE5TC8yVmx2RWZKSC80TU11Y09n?=
 =?utf-8?B?WXNyK1kyWkZ6cUZEWGJKTHF1VDF5WWFBWVhpb1BBVjhVbXBCWnJyMUxBL3RT?=
 =?utf-8?B?bEprWTRaaXB3WXNVRUFJSzJ2NDdRUlZxaUUxNUFOWU5BSnRTb2tXcjg1bGZ5?=
 =?utf-8?B?cndEQWwxNE9kd21WN2xiZUo0QmxwZnNOdE9yaSs3UnlNN2tlWlExcXgxMGFq?=
 =?utf-8?B?TW0rb2lBeEVlWmpXWGZaY25EaFF4cU9TUG9MLzNlQTAyN1BpNEhUZDRXY2h0?=
 =?utf-8?B?S25Fa3o2eDJsbkUyL0toSFFhR1UzZnJXeHZBSlVCUE1uQVdOdUkwTytldTZa?=
 =?utf-8?B?dUF0Y3VXVDZQcEpjanU5MTZ4T092ZUluWEkzbnFhMGdKeGk4b0NKM2VleEFW?=
 =?utf-8?B?U3FNYU5qU3F3WWxUdXRlYkxxckgyUDFmd3hjdS9ZOFpLNjc1dHFSclJDc1Vx?=
 =?utf-8?B?TkswUkhCNlV4L0d4a0pGdEpYcUdZN09jMUx5cnE0UUs5M2VDQWIzQTM5akNO?=
 =?utf-8?B?Y2xxdHM0Z0JPRnAwV1doMXUrd3psNXdzUW9LV0RISHlHTGtVRXIyR1g5QWwy?=
 =?utf-8?B?cS83SDBndXJzM0hockkzWWdhcG9vWmx4Nzg0SGU1azkyeGNPWFdlQ2F6UDNp?=
 =?utf-8?B?cVJMYk8rSzRkeHhqSmpON1FsR1l0SmpOSis2OVgzRFZrRGpHQUNCTmRhZUtP?=
 =?utf-8?B?U0R4RlRuSWdja0Nvd2d2UisvTUtzTmJxbW1Qbzg2c1FVc29NbHdXZDlUOHM5?=
 =?utf-8?B?Y1RZU3YrS1haSXptbkM3eFFyYnZLQnRKV1FGNHBzSFZ2Z3RMWHZzQm1yTDAy?=
 =?utf-8?B?R0srZS9wV1BPczI3Q1hJU0ozWDlSS0o4TXpKNG9oT2FwaWZyOFQveWtsa216?=
 =?utf-8?B?aC9BSzhiRGJEcXJ1bUJhNTJoVmhQK21nUjJxVjJzSW5DYmI3MFoxSGV3bnBK?=
 =?utf-8?B?bm1BNmhBZTFYVENBRnFjWFJSUnRTRVN0VWRyNkZORVZaTGNUQTlHUTVzc05U?=
 =?utf-8?B?TnpzT1NRTTlGWTFGa0JNdE80WnVXV29CVFJTRGVIbFphL1paMTA4dE03Tk5V?=
 =?utf-8?B?U0JrM2VzdUFSUEdydDNnc1FvbVMvbDV0cWJUM0N3NTRVb0RZWjFEejYrRjJo?=
 =?utf-8?B?SHNqQ0JzbkpWOGxVLzkyTHhjWitKUm9qSSs5UnFEZytZR21sNXpicCtVRmRw?=
 =?utf-8?B?VUhnY1JuWi91V25mSEdDL1EwV3ZYM0RkTU51Q2tPbzR3UTFNZ0NaVVpLaTAr?=
 =?utf-8?Q?FoMLkVzZJiYgwotmDrUoQkIrR?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66245184-e193-42d5-34bf-08da96755750
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:19:54.6404 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnkFkWb4odVcQISsF6g9eXkDGvCma2mG275A8g4ypNlBktP1NB2kHT5fOVyd2PGk1hcTiQhatPtqmscgE2QYeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v13 01/13] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zone size
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Adam Manzanares <a.manzanares@samsung.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <852EA681CB50A14DAE7CA5E7B122AFA5@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> Adapt bdev_nr_zones and disk_zone_no functions so that they can
> also work for non-power-of-2 zone sizes.
> 
> As the existing deployments assume that a device zone size is a power of
> 2 number of sectors, power-of-2 optimized calculation is used for those
> devices.
> 
> There are no direct hot paths modified and the changes just
> introduce one new branch per call.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

