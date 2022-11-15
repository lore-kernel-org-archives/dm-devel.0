Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C874DC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668528859;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S2ONCZ2sZ2WpLNitbH3emXABDOOffkdTWwEfIsqFrJQ=;
	b=HErS/E+5OrxrlMP7T5FR2kUDyjYcboNPjoi01pg1DfJFe4BPR2jOJ96wC2rBTxC0rFPt2P
	CDJzW3KMoZvz/rzTrDVwq2qJb+/m10Ji1wrtIgs+A/JcgtZhaIrHST3/yvmQoeT7CRd6gP
	PIERSO/z9ywmsBf8WVp8BTGIEk6+8oE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-5-32mbhdNcCDlKz54J9jcQ-1; Tue, 15 Nov 2022 11:14:18 -0500
X-MC-Unique: 5-32mbhdNcCDlKz54J9jcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04DE2185A7AC;
	Tue, 15 Nov 2022 16:14:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8AADD140EBF3;
	Tue, 15 Nov 2022 16:14:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 569A519465A0;
	Tue, 15 Nov 2022 16:14:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CAB4C1946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 16:14:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8E4E492B17; Tue, 15 Nov 2022 16:14:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1AB1492B05
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 16:14:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C049800B30
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 16:14:14 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2077.outbound.protection.outlook.com [40.107.22.77]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-SwdUAtinMFWKYy3zR14kLg-1; Tue, 15 Nov 2022 11:14:08 -0500
X-MC-Unique: SwdUAtinMFWKYy3zR14kLg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM9PR04MB7665.eurprd04.prod.outlook.com (2603:10a6:20b:283::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 16:14:05 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%5]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 16:14:05 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/3] misc cleanups
Thread-Index: AQHY9IUyAeSeKwMRmU2perE4iGtYIK5AMYQA
Date: Tue, 15 Nov 2022 16:14:05 +0000
Message-ID: <4a0cc303d4a3529711819117995ec7602e68fb7e.camel@suse.com>
References: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM9PR04MB7665:EE_
x-ms-office365-filtering-correlation-id: f56a3f21-13a5-46fc-5d3f-08dac7246b2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ALy6sjng5jgtXPoqH/n0vvhx/PXjX0Jzh7hzCdjRbbu44Vc+9DRykZf5xRFZPlxmaM24H0D3u/93q7zWDM82O+TsuQFDLgLyVqZKvJWdyM1B1htBvbrsiXCLojrzxLIHm2uqWsmtx8KENi5weXavSgK3566FdiU8AEUoDuOn7y5hq0kEpQXbK7j+bODXk9c3oIgPQcYagSLhi/k2VuLjI3rUC26iLNgalkfVdqVCufyUBMgEHkH5JdWJgHvSPvA+/jMjtMhguAwzzi10ruCXuN7AzUjcR+PSAaXN1MXb528XLXXeUY6s2t3CzPuXsRZFgfZyrGeRhWBeGGMMEkzMasT1QPKqP9tHNH3Q0A7m/GEXDFmOlFdL2Q0gCf1fKQH/mutPF4zu1UwVqkq6eoOHEoZ/QJi1xw7922wrA7NsSQrxr99neNt9R5sYvgzMbPTf3sZ5IANXpmWhC8IIU1GXTUDdFNAouwfihVHej2BMG7G64Yw2SGju9iWxLJpGkUuzFD0yiXmQ6NUrIdhA4VoNS4m5x3SrgLKPxjy9Yc1q14vAaQmBhg7MYAyUuKznqyr47XGySsU73a3wkUwQ8j+AVqt8gYbnebyVFS4oMkFRw5QQRs4seKUSdzyWpz6o7t0N6sUSJLldBa3Wt0G2y7Ie54hsEFhv71y39LfX5j9RLIlBX2xByG16HMKshEtn9csp6mRMb8CwKpjpvZ6Y/BJIcMcC7Z2OKWn3Rl9OkhgIqrMN9EHHdiE+vJsQpRvi49fgSNjl5lreff7/as1J4LuEWw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199015)(478600001)(6486002)(71200400001)(38070700005)(83380400001)(6506007)(110136005)(64756008)(66556008)(66446008)(5660300002)(66476007)(8676002)(66946007)(4744005)(76116006)(4326008)(2906002)(186003)(122000001)(316002)(44832011)(6512007)(38100700002)(86362001)(26005)(36756003)(2616005)(41300700001)(8936002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?X5to1V+9B9gClZUIitd7Ws8yWALFSViDIucpkajO7NPkkVcBCLMh54SWy?=
 =?iso-8859-15?Q?VK9Xa2OxHuz1tMxOuL4254mYDWmeeLHKAN/QQm9WXeDdJs7GE0fLKT/6E?=
 =?iso-8859-15?Q?YvHgMkEwUKtQsTK9YlLmrmlSl1xeyhScd2WxNAfwodEM7vn9Wys/FSxbH?=
 =?iso-8859-15?Q?L1euXfvGgoK4ZwCn3fBaX466fQM171YNsq1fBUbfi3Qi07jxgnetJ4OjV?=
 =?iso-8859-15?Q?JBtTFaADWP9wJsGAN2tla+zFrTKM5/8Cv50GnOSYHtZTj0D1qGjbsINft?=
 =?iso-8859-15?Q?+7Im7Zvisw+xuT069b7o1X03CN0qUmhS8hukQ5FEXt3e/7NeKQSzarpi3?=
 =?iso-8859-15?Q?uWNdWcUpsIRJCwXFCN4yZ+eK81r1Pdb0dcepHPzWZLm9pqvovgv5eToYv?=
 =?iso-8859-15?Q?kCQnxzEB9SIwIZ1Wy5mtclEhzymLCbz96ng5e9ONcK4FBLwDSC5/W5a1U?=
 =?iso-8859-15?Q?5jfxcs0thBlgklAPUaSJKsMrCP8cjIc772syeRbzbCQR4Pa4px5lg9Skx?=
 =?iso-8859-15?Q?NXqBrX08YxdLsQwQQWR4N2IwfE39NtjvIC/jIbkEbprtQwgRa1a8FJEII?=
 =?iso-8859-15?Q?wFbDE5a4+Aj3pJtQkRooksZ59AvOxAGk6tnKqNpTDMs7Z51lSq8GOGywd?=
 =?iso-8859-15?Q?5QeVv1bO2jhqTrSyIiIDfIIwdYKUk6ENsShs8pK7NlTTeNiLLhOAVo9Qw?=
 =?iso-8859-15?Q?S9MMscc2fqP27ZaNgkajtdcHh0kBcGPX1RUNVcPR3NpsoprmDoZ8GVRsb?=
 =?iso-8859-15?Q?ABfKL3GyYNPUY1P1ii45BaCgVEVGpSDOkZ4yAK1W+TSQ73Q3lqGqxDE29?=
 =?iso-8859-15?Q?CqKm4yXa8BsO/MHMLULX9K76dkHRAGBhtqXbebb0Lw1bjxNY2u/b1Wep4?=
 =?iso-8859-15?Q?ByJV2XIywZZT0fYuf/EEm2hXXjOjX+CkRjgrgu71LIfk5BMzgcUJQ4ytm?=
 =?iso-8859-15?Q?yHHRAUlZLRKIM6vTT7tFLMvMdhJvGLJ/mTXfWdgJAi/Ybd4VseRAExrbe?=
 =?iso-8859-15?Q?z2oA3nmzxyIJcEJErdcqYgTzslANjS+eQRCX/31SrxR12uEvVNVa868eu?=
 =?iso-8859-15?Q?dWkJyYQ6LvIFd4JaFba1dN+XgTHblVYOfudoDt4XelfUHw66XmBh8Ziga?=
 =?iso-8859-15?Q?/WMreK3YchQ2pqABiY1s8C7vooaA9LEeczUKp9Af1exZCepinvr3X6xuZ?=
 =?iso-8859-15?Q?0a5OxegwpU3JXuOUMD/Yfes81y5I+dkCnwBj8YXEx6KlijEcMRY+MR7l7?=
 =?iso-8859-15?Q?52VDo9HMFyD5stHddO9jOxWU4NM12nGozb0cdMt10deszMVVpiN+L8m0i?=
 =?iso-8859-15?Q?a2LaUsHlXsIBqh2Jvqew1wbuwpUYLu1SbArEoeTOyNpb5RHRb5N9CxtOo?=
 =?iso-8859-15?Q?eVdw14Z1C0xHezkuTIuub5FPL45DxHZpZ0gL4BfacJUmjUfF3LAg0Nodv?=
 =?iso-8859-15?Q?TQrlqlkzMQwPkJ/kFgTjDGgxyPUtU6fJTcHq5FAeJ9LysKm9RJyIOjU4o?=
 =?iso-8859-15?Q?yPfDKO3O57li5EJqs1hF7dakVmzPEEQLCRf41O6WVj3yIFo1xPwkWwAW2?=
 =?iso-8859-15?Q?j8A5wIdswgS6Dnt6i35LmYoJ3QSo04Yo4HdtmeH1UEhmtfYBnwAlhGDzh?=
 =?iso-8859-15?Q?CrcpVROPjSfPh0GWGsTftiuNVtYIB8NETQ6nk7rCZNZXf2GpFYNBN9Idh?=
 =?iso-8859-15?Q?Hz/svRH/15AWkZn2w9Ufnqk1pQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56a3f21-13a5-46fc-5d3f-08dac7246b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 16:14:05.6631 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Zy/XhGRayftk1lbQKrFBWg5uSR7HOnfj5WpqlGtjmxuqN1OVNyI+V+OFFOYcp1uo0CBS1lmzUE0DTZJfv/OSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7665
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/3] misc cleanups
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <446DFB1B1433204884A42EF2DF37328A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-11-09 at 15:49 -0600, Benjamin Marzinski wrote:
> Here are some cleanups (in response to comments from Martin Wilck)
> for
> patches I previously posted.
>=20
> Benjamin Marzinski (3):
> =A0 libmultipath: impove add_feature() variable names
> =A0 multipathd: don't initialize the field width in show_path()
> =A0 libmultipath: improve remove_feature() variable names
>=20
> =A0libmultipath/structs.c=A0=A0=A0 | 143 +++++++++++++++++++-------------=
----
> --
> =A0multipathd/cli_handlers.c |=A0=A0 7 +-
> =A02 files changed, 73 insertions(+), 77 deletions(-)
>=20

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks a lot!!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

