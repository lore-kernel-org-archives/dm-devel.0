Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09E9C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:17:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 75D2A611AD
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 75D2A611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-BzJiNbgQMjWqvV_uUre_6Q-1; Thu, 11 Nov 2021 03:16:59 -0500
X-MC-Unique: BzJiNbgQMjWqvV_uUre_6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FBB5100B793;
	Thu, 11 Nov 2021 08:16:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77EA71017CF3;
	Thu, 11 Nov 2021 08:16:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 53E9E1832DD6;
	Thu, 11 Nov 2021 08:16:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB87jfM020882 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:07:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DF251404727C; Thu, 11 Nov 2021 08:07:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9B644047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:07:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB823811E78
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:07:44 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
	(mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-519-0Iw1jVTKOxa4i2k1akBCKA-1; Thu, 11 Nov 2021 03:07:42 -0500
X-MC-Unique: 0Iw1jVTKOxa4i2k1akBCKA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR1201MB0224.namprd12.prod.outlook.com (2603:10b6:301:55::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15;
	Thu, 11 Nov 2021 08:07:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:07:39 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [RFC PATCH 2/8] scsi: add REQ_OP_VERIFY support
Thread-Index: AQHX0Ufej19RADS0h02RwBAEv1bAa6vzTaUAgAq2LwA=
Date: Thu, 11 Nov 2021 08:07:39 +0000
Message-ID: <cb9cac6d-1206-0bd3-0883-dc7f1a9fcc78@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-3-chaitanyak@nvidia.com>
	<bd36ee58-8273-cd0a-295e-0c66b0142bcd@opensource.wdc.com>
In-Reply-To: <bd36ee58-8273-cd0a-295e-0c66b0142bcd@opensource.wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 875ee3a1-5194-4313-ee72-08d9a4ea546f
x-ms-traffictypediagnostic: MWHPR1201MB0224:
x-microsoft-antispam-prvs: <MWHPR1201MB022445A026BAB1407513C558A3949@MWHPR1201MB0224.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iW1Vh6lwnohG0eBulzeUMESsh7ziq+HS6K7zqIOJAOHWOd7H9PtL78sCm5ZWNj5vz132ghZUOVFOOyP4UL+FsaDxBoWnGZ+/ozQyq7kfx6TLP1uspybMsCTnzxpNUnDB6GIIGHovjze7qQ3gBVQmpJ9oRnqv/YxpC4py2eImCYdIagEEWKZZoeTNgpxKGJdnwhuiQSeeH+7uUrcTBrc7jGfAy+Ptlp5fMjLDsAdCJ3qUQuuqoxmgJ+cI0yUudjrtA7zCqFvaexIIp0wJ8ZzvNOtgcSFGQPTSAlqU4qBcebRN3dQM+2wMnAKga+HBySX/QYBckNkHJ2U8E/EEivatiL5c0ky8rizXKe8x94kCwGwJgqgBJejwyTQ9eXX1GOXRTuGrW0c+r8UWpAnchobcT6VQkTRvUo7AUR2wt1gT9gRT2WyyZsnGpkgdpaNDha4CkWvh9BvkfGkAeb2GR6xNdyaM55q4TxYQAbga4vjvRf1198I76HBtxwRUge7bbXTy75yCbiR0E3xarqucA2g9Laf6O/jNyQ/EBA341uzDA9btuZJMT7dmdm48AlL0qYezcbmKElGiIWn+hqSvIdSQiWJFwC44cciPp7rCRP7IC9OHII9LSSWicp5mmw6Objq8aASz7d39ScXOUrQo1VwvqREwWZdSc4DZ04fARPlrXLzsxqXAz8iJeS8En+GGVlNY5VnYitZGlcPVv8Jw3jA41qoYo2nKrpdmZ4Hj90+kBbDhYfiTagyBijcQtT1713H3yY3TKsPaFT7KYHZ7NRtGIqgY+KXtj5V2evDUcA+y+4s=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(2906002)(66446008)(8676002)(64756008)(8936002)(38070700005)(66476007)(54906003)(38100700002)(36756003)(122000001)(316002)(5660300002)(6512007)(6486002)(2616005)(4326008)(31696002)(508600001)(71200400001)(6506007)(53546011)(31686004)(66556008)(86362001)(76116006)(66946007)(6916009)(83380400001)(186003)(21314003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1lpRkVyRlJhYThsTlVVOHZIQTZyMktwT3drRW5kendERjI2NlF0TWxlNVFM?=
	=?utf-8?B?K1EvUGk0Z0VwS3R0dTkxeFRGSiticFhmUWdiN3dMUTFMRlVWem5rTHJjT29i?=
	=?utf-8?B?ZXlSQmYxM2d2YnRvS3hOUVRJTldJK3dBRW1hcDNLb1V3UGdoVTdNRjRrTUdp?=
	=?utf-8?B?bkZGOWpXRnh3dytWV1U1U3VVeGlWazFIN255NWZXOWpvSUlhREdpeXI3NUIv?=
	=?utf-8?B?OFFjZldVYTdRMlZTb2JBYUM0WnlHUHhzcFFDdWhBNGIveXNSZk4zRUdacFEw?=
	=?utf-8?B?RGp5R3pTVXE1UVVPWkJDN0YxTEhOZ0hpRTRjSUFBRWtQaVhJUEp1dFpCMThK?=
	=?utf-8?B?RE41bTJNcTVoVnZOU2laZkQ0SDR4SGVrMm02OTVHN2NFSWkrTDk3YVpQWjAr?=
	=?utf-8?B?NUFIY09NOVlXdTduM1N4RXUxQ3NGSkpJQ0xwYm1vc2phaWhuT0Zmd24yY0wv?=
	=?utf-8?B?Sk1HbjR5amp2eGw4SmhSYjIvMk83QnFsQWtZYURkcW9MenFVVmoxRlRPeXJW?=
	=?utf-8?B?ZGw2RUIzNzI5UXFESFRDdDQ5S1lMTitxdU0rMUk3NTUrU2JOVWJtOGMzalZ6?=
	=?utf-8?B?UlFlN3pJM05YNVFxWHg3bWUweW90bldUaFBEU0RpZEVZVjd2anoyczFXYVNX?=
	=?utf-8?B?eUpRcTBaaERHcVIrVUt5OFNFVHlNY21lK3FtejZnWkRybWczV2VubGk2MVJu?=
	=?utf-8?B?UGgyVmpGUVo3ckUrb3RWcyttZHNyc3dENWV0a3dXcHdJNkYwdGxNUmZ3YWpW?=
	=?utf-8?B?V1h0dG83K3RnVDY1aG5xQTVFbU9aTjdQaTRWSEJqMFgxRHoxVjdWYSsxekdY?=
	=?utf-8?B?MHJyaHoybXJ4ejVIU29DWk8yaldMOW9aMER3OUtRQU1KSWVMQm5keHNFclQ5?=
	=?utf-8?B?bm9xQlIwREtFaU5YbzZveVA4MXlDa0FZRVBJcVNLSk0xOXp4ZjlZU0Q3WUN6?=
	=?utf-8?B?ZTFlNW04TitFVG1KUXRDb0tLRUFLYm5JR0xVNWJ4T0cxd2U3K3duVjVmRVBN?=
	=?utf-8?B?QjhtZjR1aGE1YU81TUlLVGZGdk8xNFlyY1pkZm5FMzV6Nkp4Qi9xampxdVZh?=
	=?utf-8?B?NUNXRjRDU0ljcE0xVTdWdEhvWVJNNld5UDcybUtVTUY1WGNuRFBwdlpmYitZ?=
	=?utf-8?B?eVJMZVlsSEZ4MklEZExSb0RkVkk4alF3eDQ4elpaeCtyejhzQTJQcFE5UGNu?=
	=?utf-8?B?bDJoUjdDcTZZV3dYbnlYNmxRdWFiL0ZLcEZuZDQxcGhoYSsvRk1xUzJ6dU9C?=
	=?utf-8?B?VUtNRGZxYVZIM1JTS05LTC8ySnNEREUvdWxNaGhVWko0cFhJSk9JdjV2NHlE?=
	=?utf-8?B?MytwU1JkTS8vZTZOZEFXbEpQZU1mWG1wdm9RRUJUaDc1TVRpTnhXYXNieWFL?=
	=?utf-8?B?SjFweERwZ0dRYkJ3aDI4dHRkWjRFVUx2NDlRb09GWDRMakdxaDU5SDNXMWNo?=
	=?utf-8?B?WU4xV0FCaGZCNnhvSzYyemQwRVZoUEpwNVBQMzhXcC9QWEZYaE15L0lCYm5q?=
	=?utf-8?B?T3VjNW1oODhwT2FsR3B0cTdWcnBQU3dhaWNmRDVKdkxOSHd0RVg5ajU5MW5m?=
	=?utf-8?B?M2xDdE1tOTg3UXl5TVVZVWh1MDlROHJYbE5ieUt5bWI0K1lyM2t3aDhKV1hh?=
	=?utf-8?B?SE9XTnVSTEliVlJ4Q0d0d3Z3ek5zUCtnL3JNUXBGMkdUaTdpT3BJRnZPazVu?=
	=?utf-8?B?T082UUs1N24rUWlETVF4anFkTmo3aWwweDlkVjRvNVpaaS9hMWhsOVRrSDY3?=
	=?utf-8?B?d0FvRW9NcGN3UXpRVTZScC9OdkJOQ0xzYTgydU5ZV0RXaGw1Ylg5aFRXdnNJ?=
	=?utf-8?B?a3JuSkZyODBwTHZyT0lGMWhRYUFoODhIUCtpL3hkRmlVaWxGUlpuemlvZ3N0?=
	=?utf-8?B?WndtellKU3NkRjlXRWw0QUJCeFVZQldtMExYT2lSWmpiMURBcUF1c0pjc0ZS?=
	=?utf-8?B?cHh3N3h4T1VPL0dJODJ2UTZocHpvL0xxVDEybExKODJjc0JmTU9PbzIzdUtQ?=
	=?utf-8?B?QklseFVzblY2SWdjekZwWEI2ZTlma2FHdzVOWGxEUUgvdFB6b1o1YnJ1SE8w?=
	=?utf-8?B?WG1rOE5nMWt1dG01aXFYd0ZNalVNYVllQXhYYTVoUyt4Z1oxTWoyZjM4UEw5?=
	=?utf-8?B?Y3UvdzhVZGRGYWJmVU1kcnM0MVdESWVMOHo2UEc0ck5GRU42OC9pUmQyQ2NE?=
	=?utf-8?B?dTlhS3l6SWlLdnRweDV4MG1Jdk0yTG9TclRlNEt0V013UDlqMjRqTHhNQXpB?=
	=?utf-8?Q?Vu6HVmxlb5NzIvsK/bIWYftV1BjN6nsx6abKmrimA4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875ee3a1-5194-4313-ee72-08d9a4ea546f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:07:39.4060 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cd8oGViME+/b/yG6aw70ERvQ255QurjMa+ayzSTs9idAOt4tmMiw1wbA//+uxdULY8NGYRdbHxvaCjHuP1tpww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0224
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB87jfM020882
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
Subject: Re: [dm-devel] [RFC PATCH 2/8] scsi: add REQ_OP_VERIFY support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F1DE8655E680234FB7174EB54CE8527D@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 5:33 AM, Damien Le Moal wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2021/11/04 15:46, Chaitanya Kulkarni wrote:
>> From: Chaitanya Kulkarni <kch@nvidia.com>
>>
>> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>> ---
>>   drivers/scsi/sd.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/sd.h |  1 +
>>   2 files changed, 53 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index a3d2d4bc4a3d..7f2c4eb98cf8 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -106,6 +106,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
>>
>>   static void sd_config_discard(struct scsi_disk *, unsigned int);
>>   static void sd_config_write_same(struct scsi_disk *);
>> +static void sd_config_verify(struct scsi_disk *sdkp);
>>   static int  sd_revalidate_disk(struct gendisk *);
>>   static void sd_unlock_native_capacity(struct gendisk *disk);
>>   static int  sd_probe(struct device *);
>> @@ -995,6 +996,41 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
>>        return sd_setup_write_same10_cmnd(cmd, false);
>>   }
>>
>> +static void sd_config_verify(struct scsi_disk *sdkp)
>> +{
>> +     struct request_queue *q = sdkp->disk->queue;
>> +
>> +     /* XXX: use same pattern as sd_config_write_same(). */
>> +     blk_queue_max_verify_sectors(q, UINT_MAX >> 9);
> 
> VERIFY 10, 12, 16 and 32 commands are optional and may not be implemented by a
> device. So setting this unconditionally is wrong.
> At the very least you must have an "if (sdkp->verify_16)" here, and call
> "blk_queue_max_verify_sectors(q, 0);" if the device does not support verify.
> 

Yes, I put it together for the RFC, this needs to consider the device
unsupported case just like what we do for write zeroes and emulate the
same.

>> +}
>> +
>> +static blk_status_t sd_setup_verify_cmnd(struct scsi_cmnd *cmd)
>> +{
>> +       struct request *rq = cmd->request;
>> +       struct scsi_device *sdp = cmd->device;
>> +       struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
>> +       u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
>> +       u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
>> +
>> +       if (!sdkp->verify_16)
>> +            return BLK_STS_NOTSUPP;
> 
> I think this should be "return BLK_STS_TARGET;"
> 
>> +
>> +       cmd->cmd_len = 16;
>> +       cmd->cmnd[0] = VERIFY_16;
> 
> And what if the device supports VERIFY 10 or 12 but not VERIFY 16 ?

For first implementation we can only VERIFY 16, later we can add cases 
for VERIFY 10-12 versions.

> 
>> +       /* skip veprotect / dpo / bytchk */
>> +       cmd->cmnd[1] = 0;
>> +       put_unaligned_be64(lba, &cmd->cmnd[2]);
>> +       put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
>> +       cmd->cmnd[14] = 0;
>> +       cmd->cmnd[15] = 0;
>> +
>> +       cmd->allowed = SD_MAX_RETRIES;
>> +       cmd->sc_data_direction = DMA_NONE;
>> +       cmd->transfersize = 0;
>> +
>> +       return BLK_STS_OK;
>> +}
>> +
>>   static void sd_config_write_same(struct scsi_disk *sdkp)
>>   {
>>        struct request_queue *q = sdkp->disk->queue;
>> @@ -1345,6 +1381,8 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
>>                }
>>        case REQ_OP_WRITE_ZEROES:
>>                return sd_setup_write_zeroes_cmnd(cmd);
>> +     case REQ_OP_VERIFY:
>> +             return sd_setup_verify_cmnd(cmd);
>>        case REQ_OP_WRITE_SAME:
>>                return sd_setup_write_same_cmnd(cmd);
>>        case REQ_OP_FLUSH:
>> @@ -2029,6 +2067,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>>        switch (req_op(req)) {
>>        case REQ_OP_DISCARD:
>>        case REQ_OP_WRITE_ZEROES:
>> +     case REQ_OP_VERIFY:
>>        case REQ_OP_WRITE_SAME:
>>        case REQ_OP_ZONE_RESET:
>>        case REQ_OP_ZONE_RESET_ALL:
>> @@ -3096,6 +3135,17 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>>                sdkp->ws10 = 1;
>>   }
>>
>> +static void sd_read_verify(struct scsi_disk *sdkp, unsigned char *buffer)
>> +{
>> +       struct scsi_device *sdev = sdkp->device;
>> +
>> +       sd_printk(KERN_INFO, sdkp, "VERIFY16 check.\n");
> 
> Remove this message please.
> 
>> +       if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, VERIFY_16) == 1) {
>> +            sd_printk(KERN_INFO, sdkp, " VERIFY16 in ON .\n");
> 
> And this one too.
> 
>> +               sdkp->verify_16 = 1;
> 
> Why not checking for VERIFY 10 and 12 if VERIFY 16 is not supported ?
> Also, why don't you call "blk_queue_max_verify_sectors(q, UINT_MAX >> 9);" here
> instead of adding the not so useful sd_config_verify() helper ?
> 

Okay, let me see if I can add that in V1.

>> +       }
>> +}
>> +
>>   static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
>>   {
>>        struct scsi_device *sdev = sdkp->device;
>> @@ -3224,6 +3274,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>>                sd_read_cache_type(sdkp, buffer);
>>                sd_read_app_tag_own(sdkp, buffer);
>>                sd_read_write_same(sdkp, buffer);
>> +             sd_read_verify(sdkp, buffer);
>>                sd_read_security(sdkp, buffer);
>>        }
>>
>> @@ -3265,6 +3316,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>>
>>        set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
>>        sd_config_write_same(sdkp);
>> +     sd_config_verify(sdkp);
>>        kfree(buffer);
>>
>>        /*
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index b59136c4125b..94a86bf6dac4 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -120,6 +120,7 @@ struct scsi_disk {
>>        unsigned        lbpvpd : 1;
>>        unsigned        ws10 : 1;
>>        unsigned        ws16 : 1;
>> +     unsigned        verify_16 : 1;
> 
> See right above this line how write same supports the 10 and 16 variants. I
> think you need the same here. And very likely, you also need the 32 version in
> case the device has DIF/DIX (type 2 protection).
> 

Agree with write same 10/16 versions, let me see if I can add that for V1.

>>        unsigned        rc_basis: 2;
>>        unsigned        zoned: 2;
>>        unsigned        urswrz : 1;
>>
> 
> 
> --
> Damien Le Moal
> Western Digital Research
> 

Thanks for the comments Damien.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

