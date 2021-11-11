Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CF1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2CED26109D
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CED26109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-g2wz8iqPMX6gA3CsWwu0hg-1; Thu, 11 Nov 2021 03:16:56 -0500
X-MC-Unique: g2wz8iqPMX6gA3CsWwu0hg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA1C781C865;
	Thu, 11 Nov 2021 08:16:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF53C4180;
	Thu, 11 Nov 2021 08:16:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AB441832DD6;
	Thu, 11 Nov 2021 08:16:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB81DlE018986 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:01:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 21EDB404727C; Thu, 11 Nov 2021 08:01:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C8434047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:01:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F262380231D
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:01:12 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam08on2046.outbound.protection.outlook.com [40.107.101.46])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-449-RA2i5aJqPQu8Jl2-WShBFA-1; Thu, 11 Nov 2021 03:01:11 -0500
X-MC-Unique: RA2i5aJqPQu8Jl2-WShBFA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1472.namprd12.prod.outlook.com (2603:10b6:301:11::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Thu, 11 Nov 2021 08:01:07 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:01:07 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [RFC PATCH 1/8] block: add support for REQ_OP_VERIFY
Thread-Index: AQHX0UfScAsEJ1qSlk22dasx+1xeTqvzn38AgApiggA=
Date: Thu, 11 Nov 2021 08:01:07 +0000
Message-ID: <3875c1ba-e70e-baf4-bc3e-d0a7e22a7fc4@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-2-chaitanyak@nvidia.com>
	<20211104172558.GH2237511@magnolia>
In-Reply-To: <20211104172558.GH2237511@magnolia>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8487657-f9d1-4c7a-f094-08d9a4e96ab3
x-ms-traffictypediagnostic: MWHPR12MB1472:
x-microsoft-antispam-prvs: <MWHPR12MB1472D59426598AF8DFA2B686A3949@MWHPR12MB1472.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IwEnRA7+ZNX3jXoMpZF6urOroJjGQEcgv5jK6Eqg1f5w2AJNQ+NJCq4GL9j7gn7B3oRbnBJPqsq1cBF9ucowUqgYLF42nGjhpDRNdhpnlnRDFmOaAId+R8eeLPr++dF8h1Qt7Qsjm52UrseUiEmzvoJlEG/thnGiF05MHIIzeeoS1XH7kJKHO7UT9R9iAWjXYH7VcYNAQbhfT3lBs+/WBDqtNlURoAQOquRQEzVMMejkARbU0PcYQeWkiwFZtx/wODmMUzenLBH8oPEzHyzAHqY1RlAxD01Cm2jm1AF3k5K31ROKnHJvLHw+OaGURGUtsz+xnxwRtkqiT4TlbvZ3injA2B1GV98kM1vUuHTUfM+aGw6d2hVtA9TH1anH6LeV/SP397J6y2ho3cOCT9gexAmiyq7sOliJ4Z1+Q5sABEehZrqSv0kykX4PijJT73byvrZ73pQASyPrMUiK7GTB3yGTdhIyrInXEkCnHR8ND/fCyGqBbpDGq5+j9HtIGTfaoIR0j4rUEc5EI8dW/NPr8FfsmhA0Hr4ejbFKWJB2Hu5jyrHhQctMuexbPZnnDibfAC865mYwMskjo4lSbVCZL5ZaDGVc2O/MadJgHrEFv4T75e1Nr4IEr0NBZzmF14e74/CxFpqPUxT52LwkQjmogyDfzq3gk3hQ2bhibw+7gpDR5b0O/Zm2DSG/U+W4ZuYnfbaWPtTD7tn+60kWqBc0QGUnqAgacL0HWdvU5GeyNULCCGJAAyRFvY7rkTYrDOtElqpuxeqe9jxuJDcRiNOmRA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(86362001)(316002)(31686004)(5660300002)(66476007)(36756003)(8676002)(6512007)(8936002)(54906003)(2906002)(66556008)(31696002)(64756008)(4326008)(66446008)(76116006)(38070700005)(66946007)(38100700002)(122000001)(6916009)(71200400001)(2616005)(6486002)(6506007)(83380400001)(508600001)(53546011)(186003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXFpeHhYYXByeXIzY2JHbVJJSmRqMTlueTkwWlVOSE5PQkRIakFlVVNPaHhw?=
	=?utf-8?B?dUVSbm9RRTBwYXhhdVZ3aFBnSnBFQlNFS0NtWjRQUklwbnd2K1Y0a3JsVDZN?=
	=?utf-8?B?OEZkZVZVcXlpemhsdlgwVGJ1L2llQzVGK1BvWGZMbDJuUDF0OThIdWxUem5E?=
	=?utf-8?B?eDVNeGlmU0hZbjRQOGp5enN0OU4xSWRFNHd3ZlMrUjB5eWJ3YkMrNFBuSmZ2?=
	=?utf-8?B?aldyYWg5T2locWNpdVk0TDFicldEZUhnOEZORVB5WVZacGZvTVgwdys5Mndl?=
	=?utf-8?B?SG9XSzJXb25yTE1qZGRLYU0zdkkzTjVjcHIvakxvdG5hN2Z1Ymo1c2hjOUFT?=
	=?utf-8?B?OHNLVmFBWVErL3Zoemk5MUZpVkFwN0IrM29uNklVZWtJdmExT0x6amtQUzhP?=
	=?utf-8?B?SW9Lc0YwbDlTKzE0MXIvNS9ubkVsVEdYWE10N3NBN002TXRDWThQWXROK1Ir?=
	=?utf-8?B?T1Jlc1FHQU45TGpyNmwvejc4NURJN2RGTjFBODB3Z1dkSlVSeUI5WE1RZ3pK?=
	=?utf-8?B?MnhkRFJLbVNrRS9pVHZCQ2sySGw3OHFqOHNRdkFDT2ZlbGFkMGlIOW42c1JP?=
	=?utf-8?B?RGQzM0xJVXhnc0JDWjFYeDBPd3lQaE1xa3VvYWpmTkVLZ1JIcnZkeGpHdFhY?=
	=?utf-8?B?bWpoVGVRbEdRcWNmdFdMK21xdVNYQ0ZXRmR1VGh1UkNYdWh1U25ZaEJCRnZW?=
	=?utf-8?B?RU9QcGNnQ1J2ZXRCT0JCc00xbU9OVEpvYm5QcHBqYW53RnhVOWRybW8yZGZs?=
	=?utf-8?B?MmxkWmRORUcyVTN2WXF6SWhUNXdDUkZVaFpVVUJia3drTno0YVRYQjFQbENp?=
	=?utf-8?B?U0ZSMDB6ZTYyaGVKWHNOTVZoMUVWL0d6cStDMGMzVmt1L3Ewa1BDUHZScnZq?=
	=?utf-8?B?QThDbDBOSHlyQXY3d1dOZjUvSDVEcXYwZE9uSzZUeWdhclc3Tk5hMnQwRk1I?=
	=?utf-8?B?dC9kNEY0MWNNVW16VG5YZHV6VGY2dWdXc1ZUODBjcHdrVVpqOVljRll1WWdl?=
	=?utf-8?B?cmp0a0dxK2pqR0wzT2oySm04bEN2NThndU9vUDNvWTQ1bFRNRHg4WDg1Y0Ns?=
	=?utf-8?B?dTN1ZVlhM2RYZnJoMExEZUJwbkc4RjQxNjVsSHVBb0wvUVFlWHNRRVBtT0Y3?=
	=?utf-8?B?NFVhMkF4eXQ4cUhWcmdwZVQzbGJvRVBHbFFQK3FZeCtVcVN1cWxxSFJjY0Qw?=
	=?utf-8?B?NTJ0aW1zZ1Rlb0NBb3dWbkdUMnUvWlN3UE5uR1ZDQlRYdmhta3RqOVFaeFhp?=
	=?utf-8?B?SDRLWDZZU2VjNUlydDdxd1NTT1ZrTXIveWN4S290clNxQjg4TVdHZFVuNm54?=
	=?utf-8?B?R1EzU2VydnhwN1dNY3JCQVdwR3lRVVVzdVROUis5aFdUUUFOdWlQYTg3bklM?=
	=?utf-8?B?WnROMTAvUnBudHcwVnpBWnoyUnJkS1VCU0l1b2JvNS84cjF2ZFFmZ1ZmNVhJ?=
	=?utf-8?B?ZXV3ZlNnK21sZHZpcTZGY256cGM4SVo4VVNPbFE0TGF6RFVhVEwrUEplQytF?=
	=?utf-8?B?WDhOWjk1TU40S3lNanROcVBDWlpRU1IvQjIySkZUTmZYWXVWZWFMaFR2YTNJ?=
	=?utf-8?B?L1JiaU5RRWlXU1ZidTVJT0t1Uzk0cm5iL0hNa3BFU0JieXhENTczVVA2Yk4r?=
	=?utf-8?B?VnBUWit0RlNSSmdtVnVsNFlBOGRpbUQ5ZHg1d0dha2ljRDJHS1d6NXJab3Ur?=
	=?utf-8?B?aW5yM29MeFB5WXJwOEt2QlFkbjdiMDJqblgrbUdhK3pJSXQyMXNZdEtxaHpD?=
	=?utf-8?B?a1JKa1d4MEMzWDVkTmNiaXA1ZWZ0WmVZSXhHNkJ6UElhQmdJcVV1SUlQUkdE?=
	=?utf-8?B?R2RCR2hRQ0czNXRsc2VqbnBnRW9ZdzhENHQ3bXJZbVpBaTJENGIzU1ovODRV?=
	=?utf-8?B?WFE3YmxsSHE5WkhvZDRJME9FT0JPM0ZZMVhXaFE4ZnAvVXdPazg1T0x2UGYv?=
	=?utf-8?B?OGpNb2tjNXFiNFdrTTNnbjgvUGp6MUVQNVhHc0RCMGZUeDA5cUE5aVJkZUFq?=
	=?utf-8?B?S1cxWlUxTGJUbGhVNFR3dWdtdWJ6RGxsUFAvMHRYMlBrMjFEamRFSVZnbGQw?=
	=?utf-8?B?QW4xMkY5c0Jkd3kxblFMdjJjaWk2amFnZmVaUlp3NEhSNzBhUFAxSWJNWHg0?=
	=?utf-8?B?ZXJtSFdpUTlxdCtieHRnOXRRNmJkOEZZS1NiV3Bicy9HYnpsRkxVdS95RjlZ?=
	=?utf-8?B?WmkxbHpoVWMxblJJdERNUlAyWjFoTGNIMG8vd3VGMlZ1NzBIWHkzektQK3V4?=
	=?utf-8?Q?/pbE97HVhQyB2xVV7OfGtyg6M2imvFGmDE8jrlUqII=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8487657-f9d1-4c7a-f094-08d9a4e96ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:01:07.2799 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kpcaHjr7f2KnubCgqcs7Y28sqPN/EQ4AHrWpXdHzakdHCz9rkSD0zfynxpjiREwVpUPRVwzCu7vYQjo0D18NWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1472
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB81DlE018986
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 11 Nov 2021 03:16:24 -0500
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 1/8] block: add support for REQ_OP_VERIFY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <38916031B5D5694FB0A19625758BC852@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 10:25 AM, Darrick J. Wong wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, Nov 03, 2021 at 11:46:27PM -0700, Chaitanya Kulkarni wrote:
>> From: Chaitanya Kulkarni <kch@nvidia.com>
>>
>> This adds a new block layer operation to offload verifying a range of
>> LBAs. This support is needed in order to provide file systems and
>> fabrics, kernel components to offload LBA verification when it is
>> supported by the hardware controller. In case hardware offloading is
>> not supported then we provide APIs to emulate the same. The prominent
>> example of that is NVMe Verify command. We also provide an emulation of
>> the same operation which can be used in case H/W does not support
>> verify. This is still useful when block device is remotely attached e.g.
>> using NVMeOF.
>>
>> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>> ---
>>   Documentation/ABI/testing/sysfs-block |  14 ++
>>   block/blk-core.c                      |   5 +
>>   block/blk-lib.c                       | 192 ++++++++++++++++++++++++++
>>   block/blk-merge.c                     |  19 +++
>>   block/blk-settings.c                  |  17 +++
>>   block/blk-sysfs.c                     |   8 ++
>>   block/blk-zoned.c                     |   1 +
>>   block/bounce.c                        |   1 +
>>   block/ioctl.c                         |  35 +++++
>>   include/linux/bio.h                   |  10 +-
>>   include/linux/blk_types.h             |   2 +
>>   include/linux/blkdev.h                |  31 +++++
>>   include/uapi/linux/fs.h               |   1 +
>>   13 files changed, 332 insertions(+), 4 deletions(-)
>>
> 
> (skipping to the ioctl part; I didn't see anything obviously weird in
> the block/ changes)
> 

Yes it is pretty straight forward.

>> diff --git a/block/ioctl.c b/block/ioctl.c
>> index d61d652078f4..5e1b3c4660bf 100644
>> --- a/block/ioctl.c
>> +++ b/block/ioctl.c
>> @@ -168,6 +168,39 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>>                        BLKDEV_ZERO_NOUNMAP);
>>   }
>>
>> +static int blk_ioctl_verify(struct block_device *bdev, fmode_t mode,
>> +             unsigned long arg)
>> +{
>> +     uint64_t range[2];
>> +     struct address_space *mapping;
>> +     uint64_t start, end, len;
>> +
>> +     if (!(mode & FMODE_WRITE))
>> +             return -EBADF;
> 
> Why does the fd have to be opened writable?  Isn't this a read test?
> 

Yes this needs to be removed, will fix it in the V1.

>> +
>> +     if (copy_from_user(range, (void __user *)arg, sizeof(range)))
>> +             return -EFAULT;
>> +
>> +     start = range[0];
>> +     len = range[1];
>> +     end = start + len - 1;
>> +
>> +     if (start & 511)
>> +             return -EINVAL;
>> +     if (len & 511)
>> +             return -EINVAL;
>> +     if (end >= (uint64_t)i_size_read(bdev->bd_inode))
>> +             return -EINVAL;
>> +     if (end < start)
>> +             return -EINVAL;
>> +
>> +     /* Invalidate the page cache, including dirty pages */
>> +     mapping = bdev->bd_inode->i_mapping;
>> +     truncate_inode_pages_range(mapping, start, end);
> 
> Why do we need to invalidate the page cache to verify media?  Won't that
> cause data loss if those pages were dirty and about to be flushed?
> 
> --D
> 

Yes, will fix it in the v1.

>> +
>> +     return blkdev_issue_verify(bdev, start >> 9, len >> 9, GFP_KERNEL);
>> +}
>> +

Thanks a lot Derrik for your comments, I'll add fixes to V1.





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

