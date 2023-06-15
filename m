Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 254F0EB64DB
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686846502;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=icl1pkNwLxZwFQirfm8QkZaxJYi0m2fazWXGlVVph58=;
	b=jF+IBeHuQQEtKKCTPdhECycTA2joK8P7Y2do8QF7bEaHitGI9dL7LPlo4Hilb+z6lJQm0F
	mkH8U5sIC3V9S38RoxItnlTBTdSE2bZDvq9wpVmzjmWxrffi2lHWz12rNAS8Q1NAG4UrP7
	SKl010DzOHPUO5l2/jmw6L0QRLQxNNY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-VpMS70unPAKz_hnlGpPxEw-1; Thu, 15 Jun 2023 12:28:18 -0400
X-MC-Unique: VpMS70unPAKz_hnlGpPxEw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B64428237D9;
	Thu, 15 Jun 2023 16:28:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 282672026D49;
	Thu, 15 Jun 2023 16:28:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D9BE81946594;
	Thu, 15 Jun 2023 16:27:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F0A11946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 16:27:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E2B448FB03; Thu, 15 Jun 2023 16:27:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0531348FB01
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:27:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDDE9858EED
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:27:53 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-iF1fFBbnOYitJsT7qAhwkA-1; Thu, 15 Jun 2023 12:27:50 -0400
X-MC-Unique: iF1fFBbnOYitJsT7qAhwkA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8692.eurprd04.prod.outlook.com (2603:10a6:20b:42b::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 16:27:47 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 16:27:47 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V3 01/11] libmultipath: add group_by_tpg
 path_grouping_policy
Thread-Index: AQHZmYFbptK60nC7dEqBEfqG5DUSb6+MGZ8A
Date: Thu, 15 Jun 2023 16:27:47 +0000
Message-ID: <91beb503704d4dbe770f973359e3ab8117a6fe64.camel@suse.com>
References: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
 <1686170873-5754-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686170873-5754-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8692:EE_
x-ms-office365-filtering-correlation-id: 27af64bf-0017-4b43-8626-08db6dbd7468
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HejuZj0LdNEub8ljQv+7tOtHj0Q441nuMxfAM4NUu3NPigfNlHGLUf931wgTlm0uIAIWCr1q/9CFvGeD1beFpuMkOeNGAuxCvgx4FrNHxNbOlMYDZMYclPRATWIlNCMFS9DSe20C2KWw0AF5Cot+Mo73upb3WGgjHQdxfhfW6dJHBYx9lY7gmt7oVQVMFFOT34gD9/BJW41VTbrfKENZNvm41ud8pS+hLWb0205Qu3vkAH//BKoQC/arWN3DqT5JppwCoVtaZiFEKiq4fEBqUtu8aIxp7x6Kom/eQTnpbugVuKcw1IKvFvr0RMRtukOO1KacNFYZixOjzbSDPsOBFMNAoozqlFaZQBEyplC62lLsn6JMPfuxoRR+OZ5NrkueWXpUlaFvp5v6TDgP22P2qImZyvw4qqbsc5zGUSa5oPtCQ1WsmfWDqo8rmVS59Gee16yX5MzeV6URqLnJtdd47A6tZh/7w3a1TSDdbzHCDgkIhKVWhizP3VKcvBvj5L210ZbEJB3d02UOKjUUNarho5OYvN7JUptU+oCuPMAIL+D+voW9B3n0/g0LNZ2R6CvoGCaQ2o/hYxRVtgEGrMWXtchDePCcCYDlUN8jkeyn1hMS2ztt5hUefao90O/Xig2c
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(4744005)(44832011)(5660300002)(2616005)(186003)(83380400001)(6512007)(26005)(6506007)(2906002)(71200400001)(6486002)(8936002)(8676002)(41300700001)(66446008)(66946007)(36756003)(38070700005)(38100700002)(64756008)(316002)(122000001)(478600001)(66476007)(110136005)(66556008)(86362001)(4326008)(91956017)(76116006);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?kf8tslGF/MNpHJAcDJzkMCRga94kG3RKrw8tZ/pX3ifk1XpIjPVFetOId?=
 =?iso-8859-15?Q?KTSYeH3CWQFzjqg/+dAoa5TrJ4g1E8L2KuT4TsrsEOL+Zu1HmCyQKrOHz?=
 =?iso-8859-15?Q?2XOySPwc3IuQF70FBiGraW5CiphFUIjC9L1h4/lH+6jVy13OBPyhgV7gG?=
 =?iso-8859-15?Q?we1zP8IEQ/XeGImjEvpO1otAh/cSzXFHNbf3w1PCCDqVzL+N5/keCeguV?=
 =?iso-8859-15?Q?vYKye2Imeww9p8kuvyS6UviONh6zNCAsk+uV62NgyHKlNhYKtitdjstQN?=
 =?iso-8859-15?Q?2wBA2lkUPM7k6CGK1gr1jSz+Qq6jHKtuNq0fHucKWnTqQYGBsKReLoJ5r?=
 =?iso-8859-15?Q?g4oGK+B/AgixxVEvI6imUUHJjIt9df8QdxJq/t3IFR1lDiC7lE6J4lH2V?=
 =?iso-8859-15?Q?cIzjxou4m9tf6UM/y5H75LPu7NUKvwUQMXCnLzGYawnzcA2qk7Kt78UUE?=
 =?iso-8859-15?Q?adYtpYNFoWF9P9byHlrn4nGRgQmxi7/Oquwwr0Cf1vM+8+YTPly/jHrXx?=
 =?iso-8859-15?Q?Y1ouugkZWh5Bw5gt1fO+Cwz9HnSwbZQv2yAVyl2HcNUHRHZ67if9oqfAx?=
 =?iso-8859-15?Q?w6mzqIdOCPBwj6wzo8uNgJBczeIN1c1nIfZJwOcBr2C1blSe+3RIShNJA?=
 =?iso-8859-15?Q?5qH3JHgde3bxIPb/lLGxtxxYEafhI6P5qcwCmUGZ6tNdq5gamyxUyatVa?=
 =?iso-8859-15?Q?w+irRU0HhcxQhhaoSc97ARihJm0ZSpFGXh2FC9xGvthw61OkQ5yPsomMn?=
 =?iso-8859-15?Q?VgGcBHt/8TpYKRXXy710wIRapQLyfG+vFHfCmUnsa8JwwZYk0L0opiZtk?=
 =?iso-8859-15?Q?7PIaHfHWc3oE6YEUNxyV+pgii0kWhLRRhKC8N6VqYByYOuui7ZAlNNG30?=
 =?iso-8859-15?Q?fKgdN/r1TCbZDktnStya00Sw8fyC7JjvFl+clN4mSRxtOQ3B7vvefWOHw?=
 =?iso-8859-15?Q?HWOuDG4uqVmVAICfws0mlxCo6b6KH8j5KVvWcriNfyj04KYF6LgzU0knx?=
 =?iso-8859-15?Q?/uNNVn/V+pc6BAKy6BcA/4sUBwR/6IcjqNKSrNC88THYLFJ0thadWHg7r?=
 =?iso-8859-15?Q?qL5G8WsJKlPwIrJPxl6dc/chXYwepbtj0mTp61WsNSLO7Lrxy3g1EDR50?=
 =?iso-8859-15?Q?oNilbw2QOw7EQB6RSKEJw7ZItpC4Z6H+1nCWpJgJb9FwsvmfHz2ClMWQ7?=
 =?iso-8859-15?Q?e0xJ3TSXZ0y0ePlTp/4qJArDSFei54FwjF6KSpta/RRZh1I+3XqCpGy01?=
 =?iso-8859-15?Q?ov67KA5IIzPmvlhsgavo10dCOm7GcH0HwPkMAZQkgQhqWNPxVP0Dg2NmA?=
 =?iso-8859-15?Q?PdoO14HpSiQ7pgg0CMTNy3/KiMxHeM6iMEm9zEGRVdUE3eJmG4aoqD0Yv?=
 =?iso-8859-15?Q?Ww+06Af6huXOQSEt3um9MvNer4d7a/GqlmRsod/S90ZV7RUSCQ/C+ttHv?=
 =?iso-8859-15?Q?AiCQVK4Grqxvdruq4FWSDC/kkLzbfGIUbZ1/n+7GfiOamT0lM6pRBb+iD?=
 =?iso-8859-15?Q?EMNnP35CJZi9rR95WgE6kDpXD3VdT4DC5SPGHTLSCpQEaIen5atTmB9yf?=
 =?iso-8859-15?Q?GiEfJtFY279mXKrnzxrvHUK+xhW6+Ct8L2wyN7ppWS7+R2ROqpaufZfWF?=
 =?iso-8859-15?Q?H9nBcqW54iYjtjVFGuFBfIE4Hk8cR7B6q26MRh+IvfrSbgGdKiJqhMNUM?=
 =?iso-8859-15?Q?VjCC?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27af64bf-0017-4b43-8626-08db6dbd7468
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 16:27:47.2200 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6bAfLMsEHI+tGHAxeoPnQtOYqofEWUkrB+sloyvCMGp2OylCg42+yAJFaYWMq9bk+bYSn3S16/iqjz7gFI7uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8692
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH V3 01/11] libmultipath: add group_by_tpg
 path_grouping_policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <638BEAB96228204AA07DC9BCF8A3C8BE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-06-07 at 15:47 -0500, Benjamin Marzinski wrote:
> When we group paths by prio and the priority changes, paths can end
> up
> temporarily in the wrong path groups.=A0 This usually happens when some
> paths are down, so their priority can't be updated. To avoid this for
> ALUA paths, group them by their target port group instead. The path
> groups chosen by this policy won't always match with those chosen by
> group_by_prio, since it is possible for multiple ALUA target port
> groups to have the same priority.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

