Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4D5C54EBC
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 07:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673509356;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8wfH9iA5xLev42dnDTW8Zby5RUd9I70OlOlnNsQE5B4=;
	b=VQd4D4V/1N3rPtuFeGMecZLGlLaGJPc8qSuRHU2DDyCsQkqvwrsRfhiwEj6wZQuFK4O8XK
	BHbsFzTfwab4Ts++ktbNPbQBPZvKv+kNojPojwyFCN/froY7COUQR0zZCFcJB6x8x2+Enm
	KvGj0ur6AcFFgBVyw0FXae26HQoigBk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-usqbOdnBNWuX5FnRJjPdXQ-1; Thu, 12 Jan 2023 02:42:33 -0500
X-MC-Unique: usqbOdnBNWuX5FnRJjPdXQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A810C1C07830;
	Thu, 12 Jan 2023 07:42:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A07AB492C14;
	Thu, 12 Jan 2023 07:42:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D0CB1946A7B;
	Thu, 12 Jan 2023 07:42:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 54BC31946A76
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 01:07:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFFBB40C2004; Thu, 12 Jan 2023 01:07:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E76F440C2064
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 01:07:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5CE685C069
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 01:07:06 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-loV9aWZBMOe0282nPOT9sA-1; Wed, 11 Jan 2023 20:07:04 -0500
X-MC-Unique: loV9aWZBMOe0282nPOT9sA-1
X-IronPort-AV: E=Sophos;i="5.96,318,1665417600"; d="scan'208";a="332581652"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
 by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 09:05:58 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CY4PR04MB0825.namprd04.prod.outlook.com (2603:10b6:903:e4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 01:05:55 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%9]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 01:05:55 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Thread-Topic: [PATCH blktests] dm: add a regression test
Thread-Index: AQHZHBi8DS86lMnHgkmGVPNvsNuEj66aC9gA
Date: Thu, 12 Jan 2023 01:05:55 +0000
Message-ID: <20230112010554.qmjuqtjoai3qqaj7@shindev>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
In-Reply-To: <20221230065424.19998-1-yukuai1@huaweicloud.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CY4PR04MB0825:EE_
x-ms-office365-filtering-correlation-id: 76cf9a20-acfa-42cb-7266-08daf439285f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WNKhF1IiDf/lyg8zgYF12dMJuJHLauYMzghhe+j+efOpdBAUMO3XYExKM7V7NbQ69ncX9n93hCoHTpIaKGdAn0bF8aLJU96ViR1ZHGMTf2jg8F/N0IOeR61NpOAHIRkX2pzT+3w3FUNrF2azBiloirYZ7zc28U1ypPNR1gSgP9Qo8EZNPFq2zyOdxtTUR+ZPWKNfwHOhN1EJlgC8kvwq0Izkg+MmXpDelmoB1lndGPukkh07d19/vR+g4eYxYQ0NLUXZAZq3/mE7NPvolK3u3om2WkqmQYkveP3rT6tf/sPLr+OqaY9VzBhnELFrIz5JNr7Cw9uMwPV/tan05/sfujvvewh5SwZBTlAz8cIvDx+3qlA6ER9v/+KjxV26N/AdRLZBNocewVJFE+cizUyv2KeBXcSsOkECm12LxXwIeZzud8JhhneirLgjYJQq9ziYQdOR1rNJu6NfEgVBTj6FcY3NZ5uYp+0Z/TkospxzelVdDv2tnp/n5dvWqPUoh8e4JZQIGGHfmsZ0acBdsZHd4VGOD5eA4hIHiGBnSF1GdyJqTVxcEZE81WFPtHz9Bg2G7tq87evwLNKWpcrAxfKH00w3ThI1pRYT2dYUzn/3NXZlcUCn3Wu3aFIXsse2WxwLpPprnFdZTMc04c5a/yKn9JjQPQufKQmQjWCVA3nqZ49kJ4WCmmT7ubkQdRVlYuBdTm+tGETsGJ9lpHWw3oj0sg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(7916004)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(6506007)(38100700002)(122000001)(82960400001)(2906002)(478600001)(6486002)(1076003)(33716001)(316002)(26005)(6512007)(44832011)(186003)(5660300002)(71200400001)(9686003)(86362001)(8936002)(83380400001)(38070700005)(64756008)(91956017)(41300700001)(6916009)(76116006)(8676002)(66946007)(66556008)(66476007)(66446008)(54906003)(4326008);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pWirSEeL3fcAQJCiXENdn75PFXmynIQLuh2cK28fFapBfJp7OvXtTVsBGfiP?=
 =?us-ascii?Q?cLy0UBc5kXyPotU1XVDiheqTd9DwMGNc23rQO48kUZ+smiC/WAbblhsykhxm?=
 =?us-ascii?Q?L6Qb8D6jPDoN9vRuW6a7RGhvFJNwh7Z/7SuqROsejlIJKRPwjiPYVLL80RDQ?=
 =?us-ascii?Q?ydxkEOyVnutybXRoU8EOB0P4c35H4Sm1dm9w30s9zngfs1sA6YzkZH3ZFIt7?=
 =?us-ascii?Q?QEk2NABbR0xHBg5HoBYgfiLM/FeOZmrvj2WQyb/MAdbZAQJl/beH1CZ1/L5W?=
 =?us-ascii?Q?BndkAHnHYTjRGyEQVR8Ph9FPgSjAANyGQEl99PDo+y0lKUgtW49oLQGmm6Rx?=
 =?us-ascii?Q?sI+PyMYfpvvXiPT7L1nb7QZzdIFG91rBy25MNFCi9cAu1b3kSiluywhxz830?=
 =?us-ascii?Q?6dIY+/OKKjpp90WDYzG6F+97yAch0HGdeVo0UyFm9F7JsUAf17SCqIDNT6GD?=
 =?us-ascii?Q?NYVCMc44GU/fwHlaMWSi6pqdVXhbDmTRWvsehPGnAJX5EuhGbKJl8bgUGlTm?=
 =?us-ascii?Q?RXspY8xVNKVcQx0OEcbb73yIwP+3YgrZ3lbzvk/jwU+HBJNcnQEQQSExG2pL?=
 =?us-ascii?Q?V8uZiVOs/tF70EFx7vqh9edqfV+tnECs+zBg1yHuAS+lEPfVqKTPtnqEUwAs?=
 =?us-ascii?Q?6YlpWZNL51XItmE2rxLdpsZZzXD6K1CSnnhrbq3KLOVYb1X/fR3zs3yh4sJN?=
 =?us-ascii?Q?WZ2td83jQ2oY7kssS1gtFG9Ccls9JDHIA8ogjSk+MfDL/2r/3N7oaWOTY/8e?=
 =?us-ascii?Q?9ZJo93nXCDGPEkbPTnDo9sG1cUbEFiS3Jl5bmRG4zwZmSpuvjUQMepi7PFaH?=
 =?us-ascii?Q?zO+fwj+9ZYT3J6Y0Jl5PBk0mOXeEb5DK8ZHgEf2XxoFqUrTNNRwuRPqtwyQT?=
 =?us-ascii?Q?qAcuw6mCIVc7ctIPUyZLfFod0AekJpl8mFmYHxXb3Jh2hhDOYXHBm7emnrS6?=
 =?us-ascii?Q?ELsXtLM+fNsjnj+KrELDucThja4L/Y3km8I10yDXEOosgC2nOAB6/XII47Y2?=
 =?us-ascii?Q?PHN+yggKGtJ29Exbpzk9CLdXsvClYP3nSRtLlo7iPGRz04EjeKv6kFoCVs2M?=
 =?us-ascii?Q?X925/+2hQiJ12XkecGTVgxTZ/ao2pOGbkbYHPf/kNf83UngC+L9drbT4ugRJ?=
 =?us-ascii?Q?RZBLbsm35vHJaSeSnS3/yxuY5xDbZS8+HE5nuOGryrnMAD5DwlDKJVqVxR7S?=
 =?us-ascii?Q?4ygZUPUibUU7jNVohPgOseKjbIZDDPA0zojrqA2F4+ljyoK61UDbqXFBO3ql?=
 =?us-ascii?Q?HkNYe8igSTH5NAtt4m7qrXrtJx0IOJ05zfuMXvH1EK4f05wEcA5XOXRPC/D7?=
 =?us-ascii?Q?FBHaLF1TOczPY6YVOcSH3zyDLfToio4F5tjIYj8agLFWdmaevPcZlljPZYoA?=
 =?us-ascii?Q?qh9OKicyinpUqnbRWFYx4YY8OuwDheTyFjkIhI4l0DXRhS2byknTOdUWBJSW?=
 =?us-ascii?Q?XTFF8uVuDAD72Vrs7Qhxmnfw8uWNlCrGw7BGUXr8RZporfDPFtztFoZNQb8p?=
 =?us-ascii?Q?+riZRUTpFr+r9ItPHiFc9j1bPUWT9R/9XWwFmm7TymSi9c/jDKa1NC5JY43k?=
 =?us-ascii?Q?SCdcyPxysU6GjAC4HMmK5OxXQN1jYHNwv/mPXyuhioGowtCIgNJCOhvlYpYs?=
 =?us-ascii?Q?C2UMmbfYp2A4APR0n8rwHkQ=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?G8IpbquZf83QCK4ztANg3yAma6xpSZildQpcR3zP707SmAMvqaGM+iP7ETOy?=
 =?us-ascii?Q?9IUAxOAxvf5bD4BLDLtNAcCf/BkyYLYlHy0kSRE2iwxqFJKiNGPQLP0t4Ny8?=
 =?us-ascii?Q?p0Uc7SVyXm9oSj29qiue8+UrcBioaGI4Wg/y1pH5AqtwEjhWS6dfVzfxC0xj?=
 =?us-ascii?Q?nNC3SgPuob6G5TAGm5u3JNJ5jKQ7xv7qIX+2ZknfZeY8kCZH/o2jqmpq17O5?=
 =?us-ascii?Q?zDArGdfmLIPqNuU4V4ERG9ALJK9pyJ8tipDcY9SzjFaYS3ooLmu6K5IFTA1Q?=
 =?us-ascii?Q?q8xkXJrAKWUVxjeriyYrKo9ao257oN/jknX20DO1K2zO5BU/L/J7O1TBioiR?=
 =?us-ascii?Q?FnNWYlDgsDD/wunU2agyvliynnMQiwcU3A5kix7Qg+6ydspVvfAuQX3nG8BR?=
 =?us-ascii?Q?oswPLAgAvZObzoon7VFyQ3B0AdQ5AfZW++naUk0WMhrYPRUq1royEGkx/Aaz?=
 =?us-ascii?Q?QnpJ/qSoLwDspz+i5rfvO7d5/wAnB/HgYU5a6SPHC8/jWgn0vy0KPKJvMEik?=
 =?us-ascii?Q?6f7S5CLBfkkQsecLGMSt/XG03sH5c6Z+khmt66+f2Q0Lwg4sRKOlARVEoCE8?=
 =?us-ascii?Q?6gCHMZPwv+9yAXvIh0ZEmwmrBf0uOZ5o4B3qsvoPHDrPhzlwGbUaYqhKtmWM?=
 =?us-ascii?Q?SPLI/TM7dne2Im0ZukHimmK7i6sj4Y0KjYjoJtzZY6f74jo7IGd9J4mydOna?=
 =?us-ascii?Q?ZZMOHD9fngfSrtAfscrtds5O1nCT9VXZBg+uCv6Pwj/JRlELLErJYZzaWhmR?=
 =?us-ascii?Q?Cz1YdC6BiSQuO9B5aXmIHNg5x/AdB5WIQPnd7cBKfX13aFTSVIn+H0DdijnX?=
 =?us-ascii?Q?YtI9C4pCczfFzbCuYTb/V7xQvPLGQsaVWzZbTr+5gV+dnAO3pm80u8qLjftE?=
 =?us-ascii?Q?UpTidyx8myMiDP7er7MERD2JALpIvmAvDGDBtxXn1psYYUN+1usojHS8g4eQ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cf9a20-acfa-42cb-7266-08daf439285f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 01:05:55.3690 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UcdTRjWFMDP8S9f47U5frOocKE7n0tfPN7ah821uhc2XYjw0Vz3a3Wya0eKQ3BpNKTcCWNAJ5bdYgfiKxdVSsZrZ3VfpYfck6nzL/FQOvYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0825
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Thu, 12 Jan 2023 07:42:27 +0000
Subject: Re: [dm-devel] [PATCH blktests] dm: add a regression test
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "yukuai3@huawei.com" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6E519046A3C24743A6EB442F08934A02@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Yu, thanks for the patch. I think it is good to have this test case to
avoid repeating the same regression. Please find my comments in line.

CC+: Mike, dm-devel,

Mike, could you take a look in this new test case? It adds "dm" test group to
blktests. If you have thoughts on how to add device-mapper related test cases
to blktests, please share (Or we may be able to discuss later at LSF 2023).

On Dec 30, 2022 / 14:54, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Verify that reload a dm with itself won't crash the kernel.

With this test case, I observed the system crash on Fedora default kernel
6.0.18-300.fc37. Will the kernel fix be delivered to stable kernels? If not,
it would be the better to require kernel version 6.2 for this test case not
to surprise the blktests users.

Regarding the wording, "reload a dm with itself" is a bit confusing for me.
How about "reload a dm with maps to itself"?

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  tests/dm/001     | 27 +++++++++++++++++++++++++++
>  tests/dm/001.out |  4 ++++
>  tests/dm/rc      | 11 +++++++++++
>  3 files changed, 42 insertions(+)
>  create mode 100755 tests/dm/001
>  create mode 100644 tests/dm/001.out
>  create mode 100644 tests/dm/rc
> 
> diff --git a/tests/dm/001 b/tests/dm/001
> new file mode 100755
> index 0000000..55e07f3
> --- /dev/null
> +++ b/tests/dm/001
> @@ -0,0 +1,27 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2022 Yu Kuai
> +#
> +# Regression test for commit 077a4033541f ("block: don't allow a disk link
> +# holder to itself")
> +
> +. tests/dm/rc
> +
> +DESCRIPTION="reload a dm with itself"

Same comment on wording as the commit message.

> +QUICK=1
> +
> +requires() {
> +	_have_program dmsetup && _have_driver dm-mod

I suggest to move these checks to group_requires in dm/rc, since future new test
cases in dm group will require them also.

Nit: '&&' is no longer required to check multiple requirements. Just,

	_have_program dmsetup
	_have_driver dm-mod

is fine and a bit better.

> +}
> +
> +test_device() {
> +	echo "Running ${TEST_NAME}"
> +
> +	dmsetup create test --table "0 8192 linear ${TEST_DEV} 0"
> +	dmsetup suspend test
> +	dmsetup reload test --table "0 8192 linear /dev/mapper/test 0"
> +	dmsetup resume test
> +	dmsetup remove test
> +
> +	echo "Test complete"
> +}
> diff --git a/tests/dm/001.out b/tests/dm/001.out
> new file mode 100644
> index 0000000..23cf1f0
> --- /dev/null
> +++ b/tests/dm/001.out
> @@ -0,0 +1,4 @@
> +Running dm/001
> +device-mapper: reload ioctl on test failed: Invalid argument
> +Command failed
> +Test complete

With my test system and kernel v6.2-rc3, the messages above were slightly
diffrent. To make the test case pass, I needed changes below:

diff --git a/tests/dm/001.out b/tests/dm/001.out
index 23cf1f0..543b1db 100644
--- a/tests/dm/001.out
+++ b/tests/dm/001.out
@@ -1,4 +1,4 @@
 Running dm/001
-device-mapper: reload ioctl on test failed: Invalid argument
-Command failed
+device-mapper: reload ioctl on test  failed: Invalid argument
+Command failed.
 Test complete


> diff --git a/tests/dm/rc b/tests/dm/rc
> new file mode 100644
> index 0000000..e1ad6c6
> --- /dev/null
> +++ b/tests/dm/rc
> @@ -0,0 +1,11 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2022 Yu Kuai
> +#
> +# TODO: provide a brief description of the group here.

Let's not leave this TODO. How about "# Tests for device-mapper."?

> +
> +. common/rc
> +
> +group_requires() {
> +	_have_root
> +}
> -- 
> 2.31.1
> 

-- 
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

