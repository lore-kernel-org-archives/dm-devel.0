Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8D9C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:23:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8A9B60FE3
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B8A9B60FE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-lIcUVTSHMACb-HdRk2iHUA-1; Fri, 12 Nov 2021 00:23:48 -0500
X-MC-Unique: lIcUVTSHMACb-HdRk2iHUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B91C15721;
	Fri, 12 Nov 2021 05:23:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22CE71017CF3;
	Fri, 12 Nov 2021 05:23:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E48B91819AC1;
	Fri, 12 Nov 2021 05:23:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB8S54G022714 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:28:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1A04404727C; Thu, 11 Nov 2021 08:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECD994047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:28:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5A94811E86
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:28:04 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-557-DMuJb_p4NPGf3u64fDkqiA-1; Thu, 11 Nov 2021 03:28:03 -0500
X-MC-Unique: DMuJb_p4NPGf3u64fDkqiA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1135.namprd12.prod.outlook.com (2603:10b6:300:e::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Thu, 11 Nov 2021 08:27:59 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:27:59 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Thread-Topic: [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
Thread-Index: AQHX0UfJUBDssfv+ckmT1a3v6/33Gavze2CAgAqOIwA=
Date: Thu, 11 Nov 2021 08:27:59 +0000
Message-ID: <d862ddb6-4c58-e046-ab6f-98cf314fec5d@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<7f734d14-c107-daa3-aaa8-0eda3c592add@interlog.com>
In-Reply-To: <7f734d14-c107-daa3-aaa8-0eda3c592add@interlog.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43bb50ac-96b3-4f98-7713-08d9a4ed2bd0
x-ms-traffictypediagnostic: MWHPR12MB1135:
x-microsoft-antispam-prvs: <MWHPR12MB1135C7FF3F9A310ADF4C2959A3949@MWHPR12MB1135.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ueS25Etfg8pP0Qixb3mXJKjNBoQaRVoouNzEmhSuITAD6pZbL9T/93UG9ZnXgfrQnTVmiYjYvriS1HgtoNtjwkqVFFguznRi3AYc7TLuC9DyQ2SSrX2MmnW7wcMOPjJxeUfUriOCAI/E1ldug6aMMD2U0Dtu54RInq0XbIr+xyQLXrMqLvT+/lRs7oly5+Svs/qRXTWHialmZ51rWtG/WTH//JbGm7jyx0sIeeY6s8X/sn2rLQ4YS/0M/RDUChJ1uuPdMnuV18raL/hoRPJKXhd3PtC9rQjCz424Igewc3/oa+yVNJF1z2lqJwUufMunICWJfYt6Gs/QrKCAzmY2XjAhBOqkrBqFKpAOMCbSywGjRg+7hE1lJhG3gQ/0KVs2fac+2WRu/9Ol4lkEGiDFh8qcA2psz9VuVtpaX+bl2gWVnNfuYVEuV4656NEmR6dNsWyaxTqRSv4la3SyfV5p2dY/vkRSe9j+lwWUcy6+19SvCqoF9/L0jIvFQi8NLMLxe5FPv2G99+CVl9sgoGBHUWKiKXiecNiL1ZTrfv2YAde+cRx8CZjtsYupJJHwiNxvJu1gXd6aMuxasYi4aqpWbsbEKZOMi/rZ7Bnzl+CpeeV3ndFct/BEi+TBFV6gDfYDM9BPdegOAezVSeir/S4lTfXd51C1ER8UGFRx1RPz3pE48uuPbHpqKkxuSS3EhNXMIf5Y+q87XzWN/udJ2MjycTpoqcNRnKmBYVvfl82B9j16e/FVPLEvqrZXMN1dhyDg+l4osYNQgGe4lBul/vT0uw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(4326008)(2906002)(86362001)(66476007)(38070700005)(54906003)(8936002)(316002)(5660300002)(83380400001)(71200400001)(31686004)(8676002)(36756003)(6512007)(66446008)(66556008)(64756008)(186003)(31696002)(66946007)(2616005)(122000001)(38100700002)(76116006)(6506007)(6486002)(508600001)(6916009)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVZZVVRpVUZnRWIrOCtabTFVeUE3SjBxaWs3MEd6YzBLVVhlRUlTc2Vta3N2?=
	=?utf-8?B?amNqMzBvZWRkRGQ5czhHSG5nVCt0UFJJbVYyUkJqN0hpbXhNaThzVkZpTWIx?=
	=?utf-8?B?WVJoYTFBVDU1ekdKNjNzdjQ4ZVQ1ZTdUcjYySW4wc2hxb3ZzYXhjSEVBc2hj?=
	=?utf-8?B?dklycE1tWjNpWU1QK2JBcE55K3AxT09OUG9EUXNsVVRDY2U2M3JwMU0vK2hq?=
	=?utf-8?B?bk9nazN0MjRHcUpwZDJyK01VWk4rWUZGSkpBOUgwQldiTGtQNlNidzM5TUNN?=
	=?utf-8?B?Zzd2NDhGanRhUjJNTGl0Y2s5cGtYdlFUeDBJYk03RW9WcVFUSktvN1c3bmR1?=
	=?utf-8?B?OUZyMWpVbUZCT0U1aTRXQnBYbGhsdFpYenpCbjVwb2tKYXRJSjFqU05nNDZa?=
	=?utf-8?B?Z1pueVFReHFQNk5HaHdvbnc2QjhFWUp3UzNHZmE2N3U5dVBuU3QvVDBESEJz?=
	=?utf-8?B?aVoySXBqVkNBRnZ3MmNPa0ZDVCs4L09ySVlxNDZHeXFZMHZwWDc4TnFDdXRi?=
	=?utf-8?B?bFFXaGxFQkRXdkZZSXNOcUd0T0NIYUxreDJnRGRLTFM1VkpZeFdJY3JsUGRp?=
	=?utf-8?B?SSt0dFBKR1ErUTA2WGwxY2NxUUROZHpSOHcvaDNpK292ZVdsVmh4ZlhkaEk4?=
	=?utf-8?B?ejJHUnhndEpqd3oyTTh1UmZwVkNXL0ZLODdSbG1lbnl2K1JwL2JvVEErRElj?=
	=?utf-8?B?SkZIY1AzeUhvam05UW1TVzVYRncwWWsyR05DOUlVRVB5ZXZjSW1xN0RUZDh3?=
	=?utf-8?B?L1lhRTQva2dJSzIwY3FPWkxmS2NXeElhc05Fd2xhVHFUTGhXRjB2elk2VWls?=
	=?utf-8?B?Rlc4TUl3VGp4bTVwUXNYMDRoWHpuTEtKV291REFaT3R4d24wbFozU0llRjdK?=
	=?utf-8?B?bWlkQjZYakF1amVIZmtvR2lqaWl1YmNjTlVDcDdjMGNaMVFNTjBkRVVVdkFv?=
	=?utf-8?B?QnBMWlFCMy9CU1Q5QVcrWW5sRW0wdlBvV2ZtWFFTNlE2M2RoZ3hKUlFraXhr?=
	=?utf-8?B?TVorLzB0TWJxUmlrdjFLTVdYMG9uUTY1OFBmM0kyNGZubjlNT2w3QlZqS3lk?=
	=?utf-8?B?OGlUb0JWQjFsSGtXOFpZenZGSGFJeUhSNDJMY2tKdUk5b3J2Y1Y2MjFFNTRv?=
	=?utf-8?B?azduVlU3bzZlQzBnZklPOWo3dlkrWjBCN09aK1RjaU1KVmtUZkY5KzVuOERl?=
	=?utf-8?B?dTNvYjIwUVVVdG5OZDFBTTRvdDFtOFRkTFZmTVpMWTA2VFJZOE5wOWZDVklF?=
	=?utf-8?B?NUp0bmYybHJ3dElQSFZoSUZVcFBmTmNUaUN1SWtRMWk3ZEhiSGRaUzZBL0Zr?=
	=?utf-8?B?dUtjSUZVaG5Hd3BnaXlwMUFCM0lsUFBmQlZVR0xQZ0NSTnEweVEvd1ROWDRs?=
	=?utf-8?B?VVByZmltdFRiT0lQSzNLOHZpV1pqd1JZSDRPVEp5b1pZU2ZoVjZmV3NyQk1u?=
	=?utf-8?B?K2FUL1hzMXdZc1NJUXdmUVZ2OEFRdGZLeW9GbjBEdWVjWXlBRHNwOXZZSmpX?=
	=?utf-8?B?WE1iUUtjRFhTMEprS1k3QWpxWjhOcjE4VS85YzhBN1ZFY2E5em9adnE1NkM2?=
	=?utf-8?B?YXlZelFlYWptc3BzUUh5a2NmV2xERUdBNnFKYkhLMGpEaXNnK3BuV3VIdnNz?=
	=?utf-8?B?MHRWNWtBaDhlOGx5QTRDbG8xM0RnY1RzM3p6bTZwY3FLWjU4cjIvTDQxdENi?=
	=?utf-8?B?MHdqemxjK1NiWVUyejZyT1R2L0hUTUsvOGR6eEpaSEljTXhGbUR4VHJVQTQ2?=
	=?utf-8?B?b0ZVRlk1aW5qU0pFK29Hdy9EalhmcExaQlA5ZGdCcHpVUEZvTzVOZ2tKdVk5?=
	=?utf-8?B?QllZQ1l2dG4zWVk3SWh2YnNNVzdJamQ5VVV2M0ZGeloxQVdyQ2RqK1hzQ1FG?=
	=?utf-8?B?cjRPemlRbTdxUFdmV1FoaEErTXVVQ3RoRWdvQS95ZGZWeEYwZWtJMzErVGJI?=
	=?utf-8?B?YjB0dzQvUTdjbE05cmNEK05yandUbERBTFRacUxpUVR2cnFONC9SeDNXTXM5?=
	=?utf-8?B?TTRQRk9ZbHZ2WVdCVTl4QlpKM0hJL3NZSDQrbGpieWVSVVNTdmIxam9DM2Zm?=
	=?utf-8?B?cDN6alBxTVVEU1ZzTlRkdE1vMmFqeHF4UG9kelpjOWJBbDg4b1hLYVVwMTRl?=
	=?utf-8?B?OUkraVQ2QXFjTU55YUxZZk16dzBsK2w4bjFLb1hURGppL2lScUFtNGVKdVFC?=
	=?utf-8?B?bUNkcENhWUFNQWprcVZybDcxMXVSOHl0OFBBTmpYc3FvRjVibm1xamttS05s?=
	=?utf-8?Q?f1vyhshmVEa+2fJUwhdW6rYcU+8pVg4T75VA2eXA8Q=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bb50ac-96b3-4f98-7713-08d9a4ed2bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:27:59.7423 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i3wisA3kb0bvfVXuRglllJcjAoS8i2x/hc2MuJN/biLyMDUAyuuuh2AkmY24zjR4GVBRywUdCznz4Gateocg1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1135
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB8S54G022714
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 12 Nov 2021 00:23:13 -0500
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
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
Content-ID: <09979AA6EE8E05439EA550617CBDAD8B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


>> Please note that the interfaces for blk-lib.c REQ_OP_VERIFY emulation
>> will change in future I put together for the scope of RFC.
>>
>> Any comments are welcome.
> 
> Hi,
> You may also want to consider higher level support for the NVME COMPARE
> and SCSI VERIFY(BYTCHK=1) commands. Since PCIe and SAS transports are
> full duplex, replacing two READs (plus a memcmp in host memory) with
> one READ and one COMPARE may be a win on a bandwidth constrained
> system. It is a safe to assume the data-in transfers on a storage transport
> exceed (probably by a significant margin) the data-out transfers. An
> offloaded COMPARE switches one of those data-in transfers to a data-out
> transfer, so it should improve the bandwidth utilizatio >

I've thought about adding a support for the compare and friends. But 
those commands are optional (correct me if I'm wrong) and I couldn't 
find right usecase(s) to justify the kernel plubming.

Do you happened to have usecases or application which are using compare
command extensively or perhaps we point to an application your dd
modified version ?

> I did some brief benchmarking on a NVME SSD's COMPARE command (its 
> optional)
> and the results were underwhelming. OTOH using my own dd variants (which
> can do compare instead of copy) and a scsi_debug target (i.e. RAM) I have
> seen compare times of > 15 GBps while a copy rarely exceeds 9 GBps.
> 

This is what I'd expect when it comes to performance, but we need
a strong usecase with in-kernel user to support that, I'd be happy to
add that support.

> 
> BTW The SCSI VERIFY(BYTCHK=3) command compares one block sent from
> the host with a sequence of logical blocks on the media. So, for example,
> it would be a quick way of checking that a sequence of blocks contained
> zero-ed data.
> 

I see thanks for the comments and sharing compare related experience,
I've thought about that when I worked on REQ_OP_WRITE_ZEROES support :).

> Doug Gilbert

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

