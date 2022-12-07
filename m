Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57227C63703
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 23:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670455055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cEhYJoWnGA2rshTQ+0BR1c4htAoMd0PlkFC22q5ZzQc=;
	b=FQR3le9QSKe+NGIYmjOvSq1B/rd/8wc0lxPhqjmX2koY6Mrjt+oaTj8Dgz0FnnEdfLuhpT
	2TMvR1U0scDsSMfP9mNuAVtTNQDMcqOJ40gpajvFGFRmkTq3o113fkFmDwQNR/4fP0KBq/
	xxQFW24QPFmmB7XgTyucsc/WQjRbLnw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-BswyGh1kN0CiLqSmX9LBJQ-1; Wed, 07 Dec 2022 18:17:28 -0500
X-MC-Unique: BswyGh1kN0CiLqSmX9LBJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 820E03C0D856;
	Wed,  7 Dec 2022 23:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2849540C6EC2;
	Wed,  7 Dec 2022 23:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E972B19465B9;
	Wed,  7 Dec 2022 23:17:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D523019465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 23:17:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8CF3042220; Wed,  7 Dec 2022 23:17:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84DD339D7C
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:17:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60A403C0D860
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:17:22 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-vZuH-9wTOMmvc-kswF2rFg-1; Wed, 07 Dec 2022 18:17:20 -0500
X-MC-Unique: vZuH-9wTOMmvc-kswF2rFg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS7PR12MB6335.namprd12.prod.outlook.com (2603:10b6:8:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 7 Dec
 2022 23:17:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:17:12 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, Gulam Mohamed <gulam.mohamed@oracle.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Thread-Topic: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Thread-Index: AQHZCovJdMlm6wlSxk2x2f41eVikla5jDJCAgAACagA=
Date: Wed, 7 Dec 2022 23:17:12 +0000
Message-ID: <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
In-Reply-To: <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS7PR12MB6335:EE_
x-ms-office365-filtering-correlation-id: d9a18e21-17fb-489e-9f1e-08dad8a92bf9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ww6BsunjukQCDW1+TBpL+UtANg1SBeM2hoYfRywKSkRYD8vQQ9Vb1CyNQrsrDFGzL7JtW3lNIeojZ60nd9ViU4DjuC6Y4DVkdFJV8lDvzIzlYa5iFvFeNHVHSdwCaHRgRV7nkKTVEDcFbrczIeburUrr30HQr6eJcSVGv332TeLWt0GTx7ZG8+7lVJAUsjEeNNaP6g7Mp68Taw9OFgmVxoBAyQKhH05sB45nozZapV1+5bL2N2hxnvnOK+u01TH9YVJr9jVpLrLqOEz8HdL6c32Y8y8gE3sxZXaQ191RMW/tZrix13WGo7joosjssiVmM7uWiKQW6WcUIXrQWObx0OXmRO80xKgL7zfXLhA8/1DtJaU8bfRKlGHYRr5nMeVHcQcjdQsnaN4jikw9pEgBv5/WIkPaV12uxYtN1evZx9jOyGcW9WXYwSG7ur54N3sseZm9akt/djkQMv974rDkOK9hDCdxXmyZJCQAzcB4O9ocl+WOxgshv0+m/fujpli5ewH52kV/0oPWTaZIRks05QE92IkGyaU2TIZyFDdQfclMJWY3WBtpcjq7BlZTzJ+WZvvwz1KD5nMyJpnAYsRpU4K6OFnimwv+2seY0bT0XVS97LKGtZlynGEhLfSVE63pNbGazgunNfU3QvvNggqEVSsJ94yqIZMFZ/dm9gTeKLrmJY4SN7RwvFcef0NhBIiUoz/BOu/up3QFVJWjFffIIeEB99bUa0zw2BNe5O0LoZzZFtwjQvJmEvT1OYzOatfsK9XcES6r+qfQELkXRtiJ7Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(31686004)(2906002)(4326008)(8676002)(66476007)(478600001)(7416002)(66446008)(91956017)(41300700001)(36756003)(66556008)(8936002)(76116006)(66946007)(64756008)(110136005)(316002)(6486002)(54906003)(186003)(6512007)(53546011)(6506007)(2616005)(38100700002)(83380400001)(71200400001)(5660300002)(38070700005)(86362001)(122000001)(31696002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3Q1NmZITGpmR3RGbWlnbDhHWTFadk1Pdkc4Q29hQ3ZMVFB3bWx1cEc2TWdW?=
 =?utf-8?B?NTR3RFFIZnVmZi9TdkpGM01BN1k5V09hRkZ1T1BxY0MvNnA1d0VXMHFmUUNa?=
 =?utf-8?B?b3N3M1pUK0NJcHZsNEgzV0llZElSckNXUUx4eGdPa1V1dEtIMlFablhoWXEr?=
 =?utf-8?B?RXdCdC9jZWFaUXRlNDh5S2JwZlJ0a05HclVGT2k4SmQ1Q2xubU5EQUVOT3Y3?=
 =?utf-8?B?elpNemNuVVdSbzdGRDU3KzIrMlRQNnFpRVF2QnJEMDk0WEtwUk9zVDNuWGxm?=
 =?utf-8?B?d05SNEdCZHdNVyt6eW1wOUE2Z1VReEdmRmZrbC80bWpoaERBTmVMcDlhOFdG?=
 =?utf-8?B?eG0yVEVuU280VXhjZU9vekRKbS8vaVNJbVJ6dVFCQkpVV3BnMVVBMEpHUnRn?=
 =?utf-8?B?VDhWUCt6Zk5tU05JNWhvbTNNYkZJaXZQaWhCa1dTemRzZld1RXpMRnNhSjFV?=
 =?utf-8?B?Zk9yRjBhUHZEazkzUHh2NXVkWVd4R2tJWFRBRnBvUi9CZXE2Y2toaDREelNH?=
 =?utf-8?B?UlByb1pOYzBGS2QyMGp3V052eTNjZ1M2QXZrY1lheG1id0pzYkJQaWQrR2dX?=
 =?utf-8?B?aVR2dUtXNzdQM0Q0Y1hWeS9xQlJOdVlDbzJHS2F2VmlyNERXU1E3M0tlRU9T?=
 =?utf-8?B?cFIrTHZlUExxdDl3Z3J3b0c0dzJkeENXeHMyY2VKSk1qNUN4eGFKTEJBVFpq?=
 =?utf-8?B?RmxOTDRCUVRBakkwWnNrK2NvN1ZEajE3d1ZnVHA5NUNwd012TCtwVzR0SWl0?=
 =?utf-8?B?ajJIVkl2TGROL0xUNVdaVGp3QjJRV1F5OGFTbVZEd2JHUzd6RnhVKzl4bndT?=
 =?utf-8?B?TXJyTThhaUhIaUVKUmpBeDVoQm9QKzlyYnFYREVURTRXb2pnMTUyZFFmUnF6?=
 =?utf-8?B?Zkd6TnMxMC95UC9KL3BHYlRVMm41T05VNUJRM3dpVWVZMlZpcHFyb2F3MmRa?=
 =?utf-8?B?eEQ2VXNpZjBodjY3b3FaR0tMT1BBTi9laFpoVlcyZDc1TnR2SlpTMXlYNG1z?=
 =?utf-8?B?UUF5a0FxcTRIYzhyVkNxTnptZjh4MXJiQzN2dS9KaHRlWTI5REVVdUo3QUdx?=
 =?utf-8?B?U2tYSmVpZTVDeHVCTFNJRHhYdlFjY010TEVqandvOGcrOXArZXBoNTk5bmJ4?=
 =?utf-8?B?K0NjZHJLaGhvTmZkZGFzODFxYXRTODlaei9qa2g3K0ZwNnRDSXVlT1lYbGl1?=
 =?utf-8?B?QWk3S2lpd0Z1eVNZY0RVWktNeGcwR3RlWkdZdmsxblBMOWtjV01RQ3VhU2ZX?=
 =?utf-8?B?Nm1FaURJTGJsb0JtRm1rVTdDMVc3Yi9YQzZ2ZThBRHZnMTZ3WTVsOWJmc0pW?=
 =?utf-8?B?NXN3RjdQUU0vNnRZQ1BwM3I3TGdlSjVLWWZQZHE2a2h4TytOWVIvVkxzMTht?=
 =?utf-8?B?alhnMFNoeURKREppcmxVMXBHSTUxZG1XNFhSNXRZVWlnOEQ0d2NZdUdKdVBu?=
 =?utf-8?B?OS9PM0E5NU8wb2FabEMrNUFpNjhTMld0enZMSGpYc041MW11OG45VGxib25l?=
 =?utf-8?B?WTlqN0hBUjQ4RGhXM0lTK011bWt1dzRKZXp6R1VKdk1BUHZzaWFUdXhXNHps?=
 =?utf-8?B?Z2xEZk1JYjh1dTlhYXBBaFdKOTNFRjlRR1loYTRpZ1FGSkJTbVNYNjE2S3Nt?=
 =?utf-8?B?VGRselh4Mm9WSmhVUEtRbDRZSnZkNG9ubHRXNlJ4aFIyckFpUyt0dmtCWWRG?=
 =?utf-8?B?a0NUZWZPZ0N2dTVpMUwxaHVBU09OcG5YZEZuM21NaS9SQlUzdkVWSTRzaS9B?=
 =?utf-8?B?QzFJNnBISEtPRDNmWWxEYkZuYUZjMi8vV3ZGN3oyWkpDRyt3NEhzTHh3NFJL?=
 =?utf-8?B?ZGNZMzRkVWQreEtzcExRekdqWWZGU1k5MHArQ1gyT09zTHNQaVZqVmVBK1pl?=
 =?utf-8?B?cCtwakxkblFOdWVyekUveGVjRWNGZGllUTdLL2NHOVo0aW1iL2xTNHVFdFFC?=
 =?utf-8?B?djRXbFVsbUhrOURCS1YvOW5RcmhYbGM1MEg3NTZEemFGczgrR3BzYjV3WHA0?=
 =?utf-8?B?Z2d1dEdSVWtXVmJwM0tpNG9ZeFV0N3NSWWdTK2NJSytTUEJKU3Jaank4d0pO?=
 =?utf-8?B?YnlqT0lBSXVXZVhtbnJ4SjV2UXhxUUdmSW5rRStjckxvWTlyaHFvMDJqaXAw?=
 =?utf-8?B?cng5VlRaRFJROUJLb2lST01GUVhGSEs1OFVtTkVzc0cvZEZJM2dFTEdFdzJ5?=
 =?utf-8?B?QXc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a18e21-17fb-489e-9f1e-08dad8a92bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 23:17:12.5042 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHW7SWltXzhuPtJ6C+jJNKXOPFKDqIqyOvAynZqmyyZOkTzsSCV6nW0fSu8teNgq1FWktdDGmhmkaTtcq4WGEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6335
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "song@kernel.org" <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "joe.jin@oracle.com" <joe.jin@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "ngupta@vflare.org" <ngupta@vflare.org>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "colyli@suse.de" <colyli@suse.de>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <49B6173FD1ADDA4BAB931DDA7410A344@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/7/22 15:08, Jens Axboe wrote:
> On 12/7/22 3:32?PM, Gulam Mohamed wrote:
>> As per the review comment from Jens Axboe, I am re-sending this patch
>> against "for-6.2/block".
>>
>>
>> Use ktime to change the granularity of IO accounting in block layer from
>> milli-seconds to nano-seconds to get the proper latency values for the
>> devices whose latency is in micro-seconds. After changing the granularity
>> to nano-seconds the iostat command, which was showing incorrect values for
>> %util, is now showing correct values.
>>
>> We did not work on the patch to drop the logic for
>> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
>>
>> The iostat command was run after starting the fio with following command
>> on an NVME disk. For the same fio command, the iostat %util was showing
>> ~100% for the disks whose latencies are in the range of microseconds.
>> With the kernel changes (granularity to nano-seconds), the %util was
>> showing correct values. Following are the details of the test and their
>> output:
> 
> My default peak testing runs at 122M IOPS. That's also the peak IOPS of
> the devices combined, and with iostats disabled. If I enabled iostats,
> then the performance drops to 112M IOPS. It's no longer device limited,
> that's a drop of about 8.2%.
> 

Wow, clearly not acceptable that's exactly I asked for perf
numbers :).

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

