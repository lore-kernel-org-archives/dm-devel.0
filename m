Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5446C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 510A1611AD
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 510A1611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-jXdPwAgKNvy3D42p3yaizQ-1; Thu, 11 Nov 2021 03:16:35 -0500
X-MC-Unique: jXdPwAgKNvy3D42p3yaizQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D46A919253C0;
	Thu, 11 Nov 2021 08:16:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A507460C05;
	Thu, 11 Nov 2021 08:16:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0A4F218199EE;
	Thu, 11 Nov 2021 08:16:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB89DR6021034 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:09:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 592C34010FE5; Thu, 11 Nov 2021 08:09:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52F6B40CFD04
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:09:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32124185A7B4
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:09:13 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-11-xp47cAxcNkC486g3nHZ3Aw-1; Thu, 11 Nov 2021 03:09:10 -0500
X-MC-Unique: xp47cAxcNkC486g3nHZ3Aw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR1201MB0224.namprd12.prod.outlook.com (2603:10b6:301:55::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15;
	Thu, 11 Nov 2021 08:09:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:09:08 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Keith Busch <kbusch@kernel.org>
Thread-Topic: [RFC PATCH 3/8] nvme: add support for the Verify command
Thread-Index: AQHX0Ufns/7MhUkEakq3YhkbprD95avz+KGAgAoLnYA=
Date: Thu, 11 Nov 2021 08:09:07 +0000
Message-ID: <c8283a02-32df-5268-7526-7f1dbf2a15b2@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-4-chaitanyak@nvidia.com>
	<20211104224459.GB2655721@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20211104224459.GB2655721@dhcp-10-100-145-180.wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78863056-8c90-49c5-1a03-08d9a4ea8934
x-ms-traffictypediagnostic: MWHPR1201MB0224:
x-microsoft-antispam-prvs: <MWHPR1201MB02245F4E76FFD4E1F357F8B5A3949@MWHPR1201MB0224.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jcrfrqDjZZnPq4nHoz6kcCCktHn3Pi/yeRZmxReJunjQmBn1WPtgan/v5OMFogTtIu2e23uihSjWJ0dZi+eiIXI49OVhrPGU6VCH2piq9mW9fKL9811OdpUxsnkhUzelkgOmg/GnKXvuvjHAHFVSFp42dUiB9NV6yaBOyyKT8IjB5m0u0F0EPXbohMCs2ZC+2c2kI//oX+2S887pqltniVMn5jM1UOyP8ISrKROaxZq0g0wAThpUIwkTrd9mXurA7D6Vxbl75gOJL5f3uLWjBEaom/zDW3fd89tE6RwQo00RkM+7sCDbnYdgj71pEfKQIMBA5GCBrAcrT1l1XhCr3aUFzhnyJHnB3nzmw/+e/Rb5BITIRzVJFe5xK/oMDzAdkonM+4xcNQ00rSzhVURzLSBoqOKxPQzMMhUDYJw7YHlS5Ez7lPg4ZYVaiadw9zK9bGlk8hVtyQFmUnnMXY7vnFdvCZrRmAQlzaOQ+6CCEiBAIHsC6GcGRtzsiwbK93VDqdWrJZGp+0VrlIHqI4vL7jhzkaV5DQq5ycKOq9c9IuuYmBZJQ7LsHDjyxadvgVmyJm2FWL3W5LbstoKWx2GEqOe/LIGCw5+vBklI6LW4tyiaLBCPsbhOEkW1IH4YWqwBwroXDtdE3u1teC4Q2j+lkjeKqRTC1pBStQjOnMUiCQrJOnL+aFe2VBF+WR3F3iNY2tSSb7N7MgztkrsITmMXJXQ93AKpacSNwv2BQ1GCFIJD60xLipAe8VHB0fp74gPAzpCue+E7bQAF8FM6MgCj9Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(2906002)(66446008)(8676002)(64756008)(8936002)(38070700005)(66476007)(54906003)(38100700002)(36756003)(122000001)(316002)(5660300002)(6512007)(6486002)(2616005)(4326008)(15650500001)(31696002)(508600001)(71200400001)(6506007)(53546011)(31686004)(66556008)(86362001)(76116006)(66946007)(6916009)(83380400001)(186003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2x6elkrems1U2VRUEhZancrQy9HKzByNGRVQUViU3poY2c0ZGtoZ3N1OFpF?=
	=?utf-8?B?Z1BOZG1vQkorK20rSlo3Y0ZqdnVBQXpjOW5lb1VFVC84MWxlQmVyRXpzbnRi?=
	=?utf-8?B?a3RLM0NPUWcrMm5kVlIrVzFOdnZkTittNFd1K0NYaUlqL3FKNXBmM1pMRWV2?=
	=?utf-8?B?dXBuUWZyVHhYTlZJaVEvZUduaWxrUk4yNmJ1L0V4d1ZqN1dDY0crUXBoZzNr?=
	=?utf-8?B?dmp2d0dQRjdXdVUrdDlDaXQ0dksrNllheDFCY0VtTWdyYnQ0bWFyQXI4TmlO?=
	=?utf-8?B?SllveDc0c0M0ZUk5Um14QktnN1J5VXoxeFdla2xVdEhndkVBR1BHOElVTkpL?=
	=?utf-8?B?S2Z3WExEdUhMd004V2dHSHJaZWxod1BvMG52bkI5aHp4TTVSOXdkbTVWUERI?=
	=?utf-8?B?OUZNcVVZQ09iVktZOUtQK0ZjOG9NNDJ6a0Foc2cxMUN3cVRmbk5qcG9UMWQw?=
	=?utf-8?B?YU1iTEZZY1kwSHYyTDlkQ3IrMU81QTJ2TklNS3U5Z1hjWTAvQ0VvK2lPTWtz?=
	=?utf-8?B?VVRza2Z5dmlpa1V3dFAva292bWJ3em1sZit1TGlyWStVQjdFdU1zTmFxU0xL?=
	=?utf-8?B?ZzBUZ2NwTXhYT2xLYW1ubDZxN1ViMThrNW5ySE5ZOC9kR0xlTHhKSnV2a2dJ?=
	=?utf-8?B?MmJoZldHUjV3eTFIZDlFOHR4UzhwRE04cURlcFh6ekMzeEoxUjNxN3pDTXZu?=
	=?utf-8?B?TEJnbENqM3cwd1hoNDBiSnV3TjRrS1YvSEh6Sm5jalA1THJsZzhnTU9CdlBW?=
	=?utf-8?B?MEpvVHFhY3hjbFc5cVNPVGc0VjJZS3NKekNLekJQQVh4L0p5MTJ5b2JkNXc5?=
	=?utf-8?B?TTh3TDkzTkJSNTJtS01Dd0xRNjlERXRUZUk3dUF2V2pXYlVmNk1QSEVSMHJi?=
	=?utf-8?B?b2tqV2xHR3lnNFY3Rk9wOS9HKzdMQXhPTjVZRXMvNnZCdGk0dzZhaVd6SHp3?=
	=?utf-8?B?Qlp3enliUzV6Wk5lYm9PN0lIcktIenR2S3BpSDFJM1hkYWRyU3Fkd3N2MXQr?=
	=?utf-8?B?VUkxaWk3bmsrS0Nvc2tKTHhnTlF5ekh0SEhYZnlmSWl6eWc5SnYzZ1ErR1ov?=
	=?utf-8?B?T2M3UTRBWUhwVGpGdmQ3UTNTL05wOUFIbVNJRXVIWEtpUU92SElhL0NWNnRI?=
	=?utf-8?B?VFFMNUdYNnQyWG5jWG1Fam4vQlFIekt4UHVaMExPS0M5T3M5cFNQdXYrdllH?=
	=?utf-8?B?M3liQXBwQjRsOTYzQjFGVXZGVGtuNmVTYzdYQ1I2dW1xaHJGc0tBZ0kvbG15?=
	=?utf-8?B?aUs2Z2U5WkRQVjYvU1BBQU0yY1BtcGRGdFhDa0Q3Q3ZtRzlXMWRDbzcrWTBX?=
	=?utf-8?B?aWZmTkZ1Y2s1UFp3UFovWEVlaWxETE4zanpFUDIxSE8xRXZJVGxUc1dSZnll?=
	=?utf-8?B?aEJ2WXArRmV1R3dlYlVDNmdCZGlVTDJtNXIrRGllNGhDQ29aMHltWUl3Wm5a?=
	=?utf-8?B?UnRLbHVoMWp0ckJDN0k4SVI2WVk5d21IZitqdy9qZUR3UTIxWVowdVFUbzNF?=
	=?utf-8?B?YUZYUWNJOHF4alR0blloSTE0cGNML24vTkhKM25BME14ZXozZ3k0R1Y5ekVI?=
	=?utf-8?B?KzUvTUZNOWZXR2k5cWlqeHRGYW1pRHJrdk5qTHNGZklWak0xaEc3Ty9wN2pO?=
	=?utf-8?B?ZFEyNzE2dm8vcGxqdkZWSE1QRlhBb3hvamdTMlVGb0hCd2lJMm1ZOVYzaXZT?=
	=?utf-8?B?UHRhQ053RTlRbHcrbGdqZVlMV0lDZm00dG5iNGdBMEVZRjMxNGV4NUR2Q3Js?=
	=?utf-8?B?TXZ4a0x0YU4rMTh6UmM3ZWJlQkhQZENwSGIrRWN0UFRFbjBLaHFyR3lhUzRV?=
	=?utf-8?B?L09NUEVaYU10YTZNUTFpaldJRExlbk1WV0R2dGVUcGg2YlR6YUxVdW1BSzFQ?=
	=?utf-8?B?ZUNoZ0w0cGp3VXFJT2wzeDFUVVdIb3FsVjA2YkJsUE1GY1o5M3YzSytmQ3dL?=
	=?utf-8?B?UjNxTjZVdytOWndmcXN3NXFlVnpEcjBKaHNpcGRpWFR3ZEtWajd3RzE5TWZv?=
	=?utf-8?B?RFBKVDltVmhuZWJEbTVJWjY2cWRVcURITDRCQVpLc3cyekszeXV0MUFRcllo?=
	=?utf-8?B?cGhZQkRaK0poZ2pmM0NRckNMdFRNMEt6YVZNdlVPdXV4b2E1aDl2UWRsN2Nk?=
	=?utf-8?B?eDZMdVdzSnI2bW40UXVLOURhTVNtVDhuckwvSFBlcTJxZ04wQkhmSDRqQkFp?=
	=?utf-8?B?aWp2YUw0QkNOK0daMzRPWUNUYXo1TGpDOTVuWThpMjAzNlIzZGRyMksyb1dK?=
	=?utf-8?Q?mqIJibtJ0+5Rhi8kvvQFJTWRvqsrznoyZN2JlotfEc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78863056-8c90-49c5-1a03-08d9a4ea8934
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:09:07.9981 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gL5YzanYH0zT71oAtz6ugw0kjjU9SUbTgA+fZkQgtDg2BwIJLTBsRUuw/Uy7nvy1yj2KirChdCqsfsqPtq+qGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0224
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB89DR6021034
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
Subject: Re: [dm-devel] [RFC PATCH 3/8] nvme: add support for the Verify
	command
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C19B3030F9D2544D889652BDB7F35519@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 3:44 PM, Keith Busch wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, Nov 03, 2021 at 11:46:29PM -0700, Chaitanya Kulkarni wrote:
>> +static inline blk_status_t nvme_setup_verify(struct nvme_ns *ns,
>> +             struct request *req, struct nvme_command *cmnd)
>> +{
> 
> Due to recent driver changes, you need a "memset(cmnd, 0, sizeof(*cmnd))"
> prior to setting up the rest of the command, or you need to set each
> command dword individually.

Agree, will fix that in V1.

> 
>> +     cmnd->verify.opcode = nvme_cmd_verify;
>> +     cmnd->verify.nsid = cpu_to_le32(ns->head->ns_id);
>> +     cmnd->verify.slba =
>> +             cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
>> +     cmnd->verify.length =
>> +             cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
>> +     cmnd->verify.control = 0;
>> +     return BLK_STS_OK;
>> +}
> 
>> +static void nvme_config_verify(struct gendisk *disk, struct nvme_ns *ns)
>> +{
>> +     u64 max_blocks;
>> +
>> +     if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_VERIFY))
>> +             return;
>> +
>> +     if (ns->ctrl->max_hw_sectors == UINT_MAX)
>> +             max_blocks = (u64)USHRT_MAX + 1;
>> +     else
>> +             max_blocks = ns->ctrl->max_hw_sectors + 1;
> 
> If supported by the controller, this maximum is defined in the non-mdts
> command limits in NVM command set specific Identify Controller VSL field.
> 

I need take a closer look at this. I'll fix that in V1.

>> +
>> +     /* keep same as discard */
>> +     if (blk_queue_flag_test_and_set(QUEUE_FLAG_VERIFY, disk->queue))
>> +             return;
>> +
>> +     blk_queue_max_verify_sectors(disk->queue,
>> +                                  nvme_lba_to_sect(ns, max_blocks));
>> +
>> +}

Thanks for the comment Keith.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

