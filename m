Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9424EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686846609;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KknyM8I7YG0LX6iJNrRQifvtm/v8G9+2ERHrgi45kQ0=;
	b=IXKufWzh7VXvLGjO349FKSonmtdZ+o5AZemyt5bkfMk2emZdk77ei3L9vdjqQEVOHykICE
	SVAO8CjBzwQwu+V9RYAM40GDN3bSPdcPIFHZdwFIDStm124b8sLvJMQxooYWgi4c626s66
	EawjKS7UcQBn0lwKr0o39GZoXXdZ6bk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-5ZzjasqYOzOdk3wM1c7lvw-1; Thu, 15 Jun 2023 12:30:06 -0400
X-MC-Unique: 5ZzjasqYOzOdk3wM1c7lvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D4E18030AE;
	Thu, 15 Jun 2023 16:30:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED3C51C558;
	Thu, 15 Jun 2023 16:30:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9AAC1946594;
	Thu, 15 Jun 2023 16:29:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8890F1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 16:29:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF10C1C558; Thu, 15 Jun 2023 16:29:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A734217586
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:29:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87C7838117F1
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:29:39 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2080.outbound.protection.outlook.com [40.107.8.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-u9HhnttdPzeGTB0MwvZglg-1; Thu, 15 Jun 2023 12:29:30 -0400
X-MC-Unique: u9HhnttdPzeGTB0MwvZglg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8692.eurprd04.prod.outlook.com (2603:10a6:20b:42b::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 16:29:28 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 16:29:28 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V3 06/11] libmultipath: add "detect_pgpolicy_use_tpg"
 config option
Thread-Index: AQHZmYFfArlvWP4+m0mp/Sn6lkgAka+MGhiA
Date: Thu, 15 Jun 2023 16:29:28 +0000
Message-ID: <b8f02b7e9e2bb444ec09658d8c3f89f3926a33da.camel@suse.com>
References: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
 <1686170873-5754-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686170873-5754-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8692:EE_
x-ms-office365-filtering-correlation-id: dc998474-f6ba-45cc-a908-08db6dbdb08a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nq8OZcTvwxOZOLnATmRraxfBRH/MwhW/eapP3FIhafKvmQ7sxgzLyXoh4khYNnrhFOFpbH4Qitjltbh72/STFuFf5ReCJP28fGvsGaMczM22IvQhu1djeUyTgQ0MIyPZdoewVFPIXgpZEvQbLFhlpiT2VCHo2nVpHEWEiX2YbEq/5y5a/p0NgHb0zW/69tW5bWeo4GG35engzxTnB7FF14Beq3KfGTCG6HO/4qxk258k3X5JjjUxbZ3gi5aqR57NpGNsacDYOsMQbRuP2+01kZl9a7s48SEJkPrw6BT0bbLt4MySV1iHeakeE9CBCDe2X9bHm8iWlFBO7CHUwPTX8pji87UNkF9d5fpOD6I7I39Nk4DZRgDO0YdbeiJb0deCJSC4L88mjjp2vuUpXfuM/zx5ze7fwXOncHvvc8EI4E6XUg2VLh/Fg2tcdfiVP5x7UQKqlW4Gvy969Kih9Vkh7Bn3Qyh3zKb+4BnFlOjgfhMnHTqARHMehrLbzGlerTWihcXUtONeKRBVJclplW4gLNMh26nHZEuF3mEhIBboLoVfGTKwygyrRL07ACRkM3NZ26v1qwenBsRBEoIKcfQSIk3h2W0rMpzUFlBuphkDSCEPxel0Sga48CplIgViogey
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(44832011)(5660300002)(2616005)(186003)(83380400001)(6512007)(26005)(6506007)(2906002)(71200400001)(6486002)(8936002)(8676002)(41300700001)(66446008)(66946007)(36756003)(38070700005)(38100700002)(64756008)(316002)(122000001)(478600001)(558084003)(66476007)(110136005)(66556008)(86362001)(4326008)(91956017)(76116006);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KW9sjub+RStcsHam86EZBBzdJzRnJ04QknEYfI2kGfkcuZ7rIKs1f4MYb?=
 =?iso-8859-15?Q?xyGklKiPglyJWGeUIpsSyPdIildV8Vgt+mJZ9h4q3t8hpGdk5o7jLNarD?=
 =?iso-8859-15?Q?xZAg62tkcrYzCsLWYsbxydeikUzXK74A59LO81eMbTWHv4fcn32jZlzX1?=
 =?iso-8859-15?Q?nZzuWg1byzrDGvSkTNstSVxDNmtbItXuAMwCVJ0Mh+S25pOfhWiWdXYU6?=
 =?iso-8859-15?Q?0+hcL+5QjmItFfkNpWY4bWx6uxbcrP7PspNZSn6L6PSo4gEi9qZ4kZCvl?=
 =?iso-8859-15?Q?Wm+Y567PWO+Da1tl7SVCO2SWjoHyZllnNXgU5MBBHHyQwU0G8uCtgzJMo?=
 =?iso-8859-15?Q?4qterc++2Qo/2PPzbC0u7VUBdf1nZLfabLRhwRX1UG6iubOymbUoboXfm?=
 =?iso-8859-15?Q?m4ok2b1+h/l0YLWqvziw/NpwYkyiy2xr4VsdM1kCHOxnJDpXlo/ohVdGX?=
 =?iso-8859-15?Q?8sGdXuIFXkdkPdy0havlv+7/TRBgFH+v+fO4dCBQTYZmMBp5eXpIysXNU?=
 =?iso-8859-15?Q?D4dbYAdLYsxy9P9d9RBKVm32aBTsr9/xLYOMgjQmoKOXKP5nG8PKJ1eq8?=
 =?iso-8859-15?Q?ExQ80UiQUzg739rTOyUwyX7IBwdPfRBI+mOjlklf5WMAi91ZHwCakvjAh?=
 =?iso-8859-15?Q?ktjPHMLstr/Qmg88NsJOsUMvFoFKYX4wnLF9Uj61Nps5+y3gzs0xgclBe?=
 =?iso-8859-15?Q?cXhPM3Mlo3YPqyqQKVzJGsO15MFUlup/HS95nuedrT8eEjMqwpEauo79T?=
 =?iso-8859-15?Q?TO5SNtO2wqgsVmbGAIL0T6+7f/qYIqzIG9EY8R2WcmjSkkXcG44XO+VXb?=
 =?iso-8859-15?Q?Eh7fi2+/+bv7GZu+Ka4z8pmGTHOd9IgM3AWuhLvF4EYcLoOrW3zxNcJDT?=
 =?iso-8859-15?Q?DGUcBIljnXrAvjPCICIGuuexgaa821YdIYIzCFUJgP4vFMzUF8UeOVh7L?=
 =?iso-8859-15?Q?TFtwS5UI+BdgbikhqsRswgmjTb8AbPw2rpJS2fJRrur0J7ytC6MMMiF4f?=
 =?iso-8859-15?Q?cnEy4l2+JtJZzkZ6tBrAmKz878yacrn/jcJNiCJBMUNQiKZl8pYSoZqCq?=
 =?iso-8859-15?Q?j8Lq9hWmohgAcedx5kuQnBDtgewlzfL52zIaft0KlM2Kynj5fdUyz3Z7e?=
 =?iso-8859-15?Q?yGrwsA6+/+JfcPOHNSGsGjRFsuGzvkZc2plULNT735SeSvj0kLB+e31dE?=
 =?iso-8859-15?Q?AHMD2z7s3Zf/H2K3xVfpvTr8hNIuaBO2cUVMOFPpZJhvfF9YWYuzthzjv?=
 =?iso-8859-15?Q?EwuwSGi9o0B77Wt4mC0neF9j/GIw+0cuWYJfMdpHsOsDKR0lkCmHvb6Wk?=
 =?iso-8859-15?Q?KneYcLne2DSL1rGaBXh857DUZv9v9NtQpqrmUKMCD3/Q+DRkTxk3Iw7SK?=
 =?iso-8859-15?Q?QeFEIC19y2PtcT0Fn+ki9GurMxZK697kw4ZYih1sNedkqC5qucQiRA5hZ?=
 =?iso-8859-15?Q?VZCc/xoaI3o7gar5nWn/iyQvtYbj27vOkyd22xSe3s5P9JEw5FRHz45Y0?=
 =?iso-8859-15?Q?Q6PtNah9ae2SYOW4ymdRHRgU7XIdeb9bN3/wrJbWSwZgLVTFquNudNJBD?=
 =?iso-8859-15?Q?NlIvfjPVykltnplKYGOBPSWZWGE14vSu9xa4NGWH9sbtCHFnl3H5cCUFZ?=
 =?iso-8859-15?Q?Xj82WKcSpBopebiofVM7P1gLJtlm14/z2V0j2JlysGEaB64UiGIxsMb4C?=
 =?iso-8859-15?Q?Wcfi?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc998474-f6ba-45cc-a908-08db6dbdb08a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 16:29:28.1012 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QhvxoSF7/gNiXtmrbtp3LmATPvF9DcH3gOFUVevFSd5UKH8fvIip80Z6mseaAMK4+TmYM3C6e3e+/xufVOA2QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8692
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH V3 06/11] libmultipath: add
 "detect_pgpolicy_use_tpg" config option
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
Content-ID: <07304CE6FF401C4689F231F860DC3F41@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2023-06-07 at 15:47 -0500, Benjamin Marzinski wrote:
> If this and "detect_pgpolicy" are both selected and ALUA is
> autodetected, the multipath device will use the "group_by_tpg" policy
> instead of the "group_by_prio" policy.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

