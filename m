Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2351C7EE25
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686162972;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wh3MXI61XVfdzNIEQJT9glJd0Un82asYazv/WxAmPxM=;
	b=dhbjY8/wUmpeSqLaF3Vj++G5mDizgj3EY1qFpThA5HbvOiT2mHfGVDCiwb/bBwaY8GqJPQ
	Kp8/WVwbBAI+qOAlCM9Otsy6x6sZpDQcrsVaiJusckx82IUQgl9H+aAC9AntzOYcBat6wH
	WGoP9Jy5+3kgflo0bDGtJ8JLpT0HiIY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-4RHvzp4lP7-4qv7FBEWbbA-1; Wed, 07 Jun 2023 14:36:09 -0400
X-MC-Unique: 4RHvzp4lP7-4qv7FBEWbbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F0C61C02DCE;
	Wed,  7 Jun 2023 18:36:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CF759E8B;
	Wed,  7 Jun 2023 18:36:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20A5719452C3;
	Wed,  7 Jun 2023 18:36:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E16119465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:36:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BFFD40218C; Wed,  7 Jun 2023 18:36:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 429A748205E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:36:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 252638002BF
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:36:05 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
 (mail-am7eur03on2077.outbound.protection.outlook.com [40.107.105.77]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-kA9bkTDgNBSRF-74roG7jA-1; Wed, 07 Jun 2023 14:36:01 -0400
X-MC-Unique: kA9bkTDgNBSRF-74roG7jA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:35:59 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:35:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 04/11] multipath-tools tests: add tests for
 group_by_tpg policy
Thread-Index: AQHZmLNaFA3/CbPPCkikBcwfG/sFB69/rGYA
Date: Wed, 7 Jun 2023 18:35:59 +0000
Message-ID: <d8515666714373bda315106b35b2d0946fcb18c4.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8204:EE_
x-ms-office365-filtering-correlation-id: 6f54136f-545d-4de3-ab0b-08db67860a27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M1b2sypu3L0fNaA1552b7DwZsaHC3yXr/1E9s4qUWbaFVdT2C99y1FDk3LXGt4RuqwkwXlnv0Bb4nsg860hNoOBsDQIZshb7Qw74kjP5EptzuHcRRO0veaSXDtTgzST8MXStxQC/u4ygHYIA0d5fShXr6DLpYKJuF+T9NYAlEBV7d2UgOO9ZzKeoYVWNvZf0HHM2TF2xrLRt707NDyF7PrJGAv75l0N4XOlrQ3mGMy8OL2iO75sUOFGh+/kMvKGMFGCuywH+AFmZFjuptcH5kf2Yz0A0GpRRnwB1vBUsKmCYIequ8FPxH2t8lblGjszmsxz4YVwbn4yEnL5EY1OA8llTuU7FgQiEGWTpVyIh6PbDRAAOGHCFVbU9Ik9CzIk6usoXgaC1gXNSGZcKB97BYLtHGaQWFYthIkjc1kTZjkHEK5bcEiDrX6n6nZyP0sEKkd943npniU7O7YW877xWaCdZHM2K5jBUbu8FD4SiaUaO2tLfFxbziOBTYOUQl+cf6hLkbObIC/bryU9d24w7hFGcymqG7dFmVrdNuWGYFd9EaXhEREXJXqzCOGwk7pNB8ilx8yETD6JPoCkYj8Xlsf7u7iXgAEL56EAWw8GbFLKrUF9cNXCmLPw9XD/hwvjh
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(478600001)(2906002)(6486002)(36756003)(71200400001)(558084003)(38070700005)(2616005)(86362001)(26005)(122000001)(6512007)(38100700002)(186003)(6506007)(316002)(5660300002)(8936002)(8676002)(66946007)(91956017)(66556008)(4326008)(76116006)(66476007)(66446008)(64756008)(44832011)(110136005)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KvBnLhua/Uz95L3xxcQYG1T3nkO9zL5WcCAaHrdv+t9LrLf9pGnqlAxUl?=
 =?iso-8859-15?Q?csXly1zBO3dd94Z9eIpuE7k8DApc7/yXt1KCdoObwEbUprphv7w9GHm2n?=
 =?iso-8859-15?Q?KpUHlNoaQDc9hGnAYr1rXu+iyHvkOsFSMFWhps3uTJRhDXKt0fy2+38el?=
 =?iso-8859-15?Q?1b64TiowJduvlY/mobJvVWalYq9xvQOdePnN+Kup8kRvYquXiFNWvoEt7?=
 =?iso-8859-15?Q?voc2wq+ymLLi1ddQjbHCliEMARF46mxCTkAchPfsIZzjczo4yG4SFK0UY?=
 =?iso-8859-15?Q?+yDBPR54US6w61K4ORjnfAIRGW6iN79xpoC86TN3E6SBdpN7CLV+jkm0d?=
 =?iso-8859-15?Q?4b5bXHwTDP1Lxvzc/mMUehE14jbZep1+prVbhG94vQlXWzGBTFAOrPUe6?=
 =?iso-8859-15?Q?N0mV4e/L1NZ0IrErrrV3AzaeiWc5ls7o9HWsCnz39Z7ewMQWiONOnIH8X?=
 =?iso-8859-15?Q?do3raM67/BwgGD6o5du941b+5MvlPL3nYPIm1+/cK3plMGy57ZUHHnxqD?=
 =?iso-8859-15?Q?GjRkreXa83VAZiM+fUjfaAUUqMDzg5zMaSon0z2DnUFa+ExhoBctgR+YW?=
 =?iso-8859-15?Q?JsGPmkKh7BqGKP5eDYVEGo/hJs2s4t5/9H/L0lIQ51ZAhxZa+auYrZkdT?=
 =?iso-8859-15?Q?SvX3k2H3kEoLDgmxJ2L1yXlvX6QlIGGwdvZPELrNEEhKicQZKjjZF1ZwF?=
 =?iso-8859-15?Q?0MyoaI61PdsW2zt9Xzw1a5raySoFO8awR6/OjWYJcacZS8WPTCaXuZS8H?=
 =?iso-8859-15?Q?gygbp38h0adM3g+Y7ctmUK2LfgQWEMqsd32yQiadr8Nz47DGlAn5KigzS?=
 =?iso-8859-15?Q?jxOS4vvp9NnI9stBnaYFOg53kpPNFhfEuVH/K+nlma3uYDRjhHE3lQHlI?=
 =?iso-8859-15?Q?Ly1HlFXvf7TUwgxnINP1ZlB8z2+VrNGSP+gb6TaplPDq5o5OlgJ0o41nq?=
 =?iso-8859-15?Q?qxJPzX86uojGC8/AWrU6c1iMjBWsj42WfmlOz3w5SV1GA/eMOtHiiQbSi?=
 =?iso-8859-15?Q?JR0aIkrD3I9Ty5EwSlFzB3qbQBZ1CVjmJNFe9sSPaoHocP7Lrz8zMXcTo?=
 =?iso-8859-15?Q?2bZJ93yjojeBKkDt2HdpgOmAGmmADJhGxlyNXsfLZ6rKbQ+2w4SyaovNR?=
 =?iso-8859-15?Q?deuLqe/KGxtCbqZV/stHI84xvLlIe5M1wPP9zZqFly2/WhU1fgRwTzrDA?=
 =?iso-8859-15?Q?fu699lIUehsPLGPSODKMqwa02uN/V6+MRU7AlzxxXgTQruft4qn8I9y0t?=
 =?iso-8859-15?Q?py5rITjKZDs5Fe1VPXVOxzsoYMjr+KvYgHMLclQwS8KLvlW6Dxxp6rPVN?=
 =?iso-8859-15?Q?XuCCP9nXn4YSTiTLA0Z9FvXkRhS1izKNSvovjsnuyw9akQDOlIiSLg59b?=
 =?iso-8859-15?Q?NDd1UEaxz04COisLsDU1znuiZKAGqv5KI5OxiO8zhys22mHGu5kc1Mk36?=
 =?iso-8859-15?Q?u3oWkyv2R+7nJ4lMyLsI+NS6TBuwBob7LqwUuwOiTiPdNu6XZvLJbHZXq?=
 =?iso-8859-15?Q?nrdShJdFZ098oHZsDBIZF6ArXKhFWGlBtsQIoJejOArConePvdvfhbIWl?=
 =?iso-8859-15?Q?G6lb4URt0Ebx0tjJY/qxp+USqDNy9n/LiXG0pS6qca8v4BuQ39yIllxfa?=
 =?iso-8859-15?Q?g0q6uYPWVo2AFTyfWENtN4nFr6DFnbAPtGNplFp3KwDRapJ3MSl427Mqc?=
 =?iso-8859-15?Q?E+Ks?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f54136f-545d-4de3-ab0b-08db67860a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:35:59.6542 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSbWSYSuyCm7QG5t5BMBAjBcaeKgVVV3wsrQohrpw7gg+JgxCOtsDTkBfWJmngyqahc7tv06yKGBooe0N1EAog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH V2 04/11] multipath-tools tests: add tests
 for group_by_tpg policy
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <F19557E06AC0A849BAA268F7ED53E1F3@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

