Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858B4C4167B
	for <dm-devel@archiver.kernel.org>; Thu, 15 Dec 2022 11:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671104073;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AMiUhdHXzmn0/d8ozDf/e0FY3cERJsB1cvMHurk08WA=;
	b=DyW1BoNod9xP0ESdDBEf8Q8UOns7h3pRtswbILaBsgaDBhwDL/1AemmlY8YOSZ2opBgd0C
	s2T3t8MOUOmfsZsb32Jpk3q0ME/mGqul+oVXzFbGOomQ9lBTuIEkuKv3P7Zk1YgqrEgVM8
	2yOkfRlpQzvy5ha0faABH0Z2/s8Hg/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-w63gea_vPjORjtZWjqfysw-1; Thu, 15 Dec 2022 06:34:30 -0500
X-MC-Unique: w63gea_vPjORjtZWjqfysw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05090884341;
	Thu, 15 Dec 2022 11:34:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27CDE492C14;
	Thu, 15 Dec 2022 11:34:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C692C19466DF;
	Thu, 15 Dec 2022 11:34:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2160E19465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Dec 2022 11:34:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CE3B14171C0; Thu, 15 Dec 2022 11:34:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0486714171BE
 for <dm-devel@redhat.com>; Thu, 15 Dec 2022 11:34:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD0D1185A794
 for <dm-devel@redhat.com>; Thu, 15 Dec 2022 11:34:24 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2071.outbound.protection.outlook.com [40.107.20.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-QccFNaRTPC2v4UdW9B-DeQ-1; Thu, 15 Dec 2022 06:34:23 -0500
X-MC-Unique: QccFNaRTPC2v4UdW9B-DeQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB8PR04MB6858.eurprd04.prod.outlook.com (2603:10a6:10:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 15 Dec
 2022 11:34:21 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%7]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 11:34:21 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 0/3] multipath config fixes
Thread-Index: AQHZEARoZ53ijs8w4U+snxXBOUCswq5u0k6A
Date: Thu, 15 Dec 2022 11:34:20 +0000
Message-ID: <204a11c0a4cabffea117638b597ba0f99b0dacad.camel@suse.com>
References: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB8PR04MB6858:EE_
x-ms-office365-filtering-correlation-id: 77860fe9-f523-429a-b87d-08dade904f15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GolPcsjZgK/4auXkX64qPyLGWyoMg2PWVkIw3mFB+PEcXP/Knq0TgqpYU5D+dOPZFISeLyl+G4SlHZt3AYItQX+ORSX0MTSbPq/Oeo20Y7qB81UxTgJASqaUC4Q6jqCB6vqh2nF5r7/jopwa7PlGFhGEYSaM9MKU5KcQriNdFZaO9uY4wWdoexZrkjHgx8J20T5dMhewIkrM4jCxwu7pi3/JGLW1uKZ9H+6xnAVa9fRSWJoTMsDiingG0zuQfSq0mGvbYJKohqr22zG9nUJZ5DAKQTbTKm86MzyJFLFCKltFNLaKz0E7r7J1ATBbdxBtSAdV2RreixDQ+dXYV9q5yQez7AOS/xgLoVCpHZXX29xq85qMpDHkjcUH3+qDOkzztVuaJGlhO/RQMfR/zLSQm3UO1uPWEwuzBuOljtj9woqWaG8FQYzEClJF338yShSODstovogDndBerP2EhZcmSLH7rD7F7b1HKG+xD+Yzy3n6M3gRIrePNFM+seXLOW7VIkCHVLy4LQISY3K7fWuwm9hJgbLNIeX8p02PMy3lUaE0hpqbL/kqmX/z6zUGhTW4i981FVnHDgIjJy9DfmREzjVSmyJjhzid2+O0/K8Fzv4D6b91+JPeOt6w+LVMEszxM45IxNV+qZsTeqZcSox1NPbMiXOtciFxx8RnDn++fjzgmGhhTlyH/IaAjn/vx+zJ29Z0Y6gh9ywO8VoBGyGDbw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(36756003)(4326008)(91956017)(110136005)(316002)(38070700005)(66556008)(66476007)(8676002)(64756008)(66946007)(66446008)(76116006)(41300700001)(38100700002)(122000001)(86362001)(83380400001)(4001150100001)(6506007)(71200400001)(8936002)(5660300002)(2906002)(44832011)(186003)(26005)(6512007)(2616005)(478600001)(6486002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?8cdoHWmv2+obJED2XbCYo+nYYT377PQ4Cz+hdpqKlnYUqOsK0pnaa4Mh6?=
 =?iso-8859-15?Q?kjqqegRIKJVHMdrzxNJClR+YXVta0+jEJW8fVBXb2rCLJRfcwtPTONq3Q?=
 =?iso-8859-15?Q?BVMINqap24jlHtskAfNMubXZRJtU/p/dOxJzBqrmIZ4CDUiurRo9xqRXk?=
 =?iso-8859-15?Q?QVhrf73x8Ly0VTJywkDs6mjhcPdgSp2JYIX8J1XF0eaYDbBCDSmq3ZzQD?=
 =?iso-8859-15?Q?JnSADIfQdrk0ZKnmMs1ognjajx8Oey4GLEMhh0o0aFmQjugGs+hbE3ky2?=
 =?iso-8859-15?Q?OQP8FXe4cCXVLIYc39vcEuf0eZS7Jb2RANYgdwwc2Eb55KD1Jsf63itHL?=
 =?iso-8859-15?Q?+WSxwEhy/JJxIUYyVUyjuxYfJBEcl+2lOB/urPOyj6+3EfQm9+csmnUus?=
 =?iso-8859-15?Q?LfSRv4Y9R93guDl5jVXVBIvuwAWnrGso8HLc3vnkaCxEg9qJ/aRzuQkvK?=
 =?iso-8859-15?Q?TMISlNv0zRZZK9l/EJfhZxP4qvS3ER3CVwywRnkn/trgtJFFvSy/ohDsC?=
 =?iso-8859-15?Q?ovqPhWD6PVDr7cn6rxouU559V2HU81UNPcxpUFVwFGRktWIwLDycGyhA2?=
 =?iso-8859-15?Q?ux/a7jVQrYX2pztuzVPYtkBR2zJyWskuRDH5RlHTJHK8iJNDcxd70s1C9?=
 =?iso-8859-15?Q?7Uj19uQa0lN2iobd4Zz05oNdBI4//Wqklz2bwwjMfCoU/4o7ua6ayq7e2?=
 =?iso-8859-15?Q?vBneGj4B6M484cnT7uUrkNtV6DyhAbllHZZCrK0mv+LJvcIUaRVD/CavK?=
 =?iso-8859-15?Q?rxKMD2xy8xce8awcFbbiSWlfdPjkrH03Puz6hcKyyNYQKEC+XAy+AVD09?=
 =?iso-8859-15?Q?8ug7PlblZ9x03/2BFd8szlx1wBF+BTomMuJbHtRNOB0r3zdcdagwT1ohl?=
 =?iso-8859-15?Q?5tTnKqGHtoVNnBqlvakOREN8SReb+OxMP7XnQHP3LwUUUEgCsPD0CFb8t?=
 =?iso-8859-15?Q?0ZKwoei/f29iYCmbkMsrO3o3Q8Zwd7YURb+Q7/PhuAmisumfBmkTTBMCp?=
 =?iso-8859-15?Q?vAF+kehAnKlog2HrFuXV4ZNjV9JZedPqUbTl+ZwiNsyZzlvqxQZ+2HUO9?=
 =?iso-8859-15?Q?+NnOanx462jiZY2xwQkEYBRUjsk0s7ELyS93wQqxZ/WlPfeNOcfBamG8+?=
 =?iso-8859-15?Q?G86BOyVh9VPj9CY6B9Q+LUkXpqEfeZXbBBeIcdTICK1fSx2wHFz4I3n3g?=
 =?iso-8859-15?Q?mOcLO2VXacwdi43nY8eUwxdpkPNvvRuF45duyFhDlx6rJirOiiECHgyb5?=
 =?iso-8859-15?Q?dRzWEwBRoxHwzofrFV7zOUWAZqDq5N13PRk3TzMWEoe1bvhRFC2iJr44y?=
 =?iso-8859-15?Q?AUjNB0JjsTCk8hVE/kX8EnZ/n4ZmAiyUp4ZFWiRVuyY2k135rjrlB7r5N?=
 =?iso-8859-15?Q?xWOkvjDEcqp/g6FnaICTQePauCxfxMWtE+PWM/yvrmUEwH/w51fjGx3GH?=
 =?iso-8859-15?Q?UV77XiGVNAl9gcruR4husY+ih/WzXURURjlCyYYg6L0UwFyVTSmeWet62?=
 =?iso-8859-15?Q?Lwct1bkbzMgUduafob7PfhNptSm/W51CZ7fJO7GmFCNMZ+u098oSWW4nq?=
 =?iso-8859-15?Q?wjj+Id+jqsGh16lfW9nGp/r8ilXIzIwc5+lrXuKd2Ygarm0bpvejrg9N/?=
 =?iso-8859-15?Q?izlTjHmDc5mm9t/LXN6urlnNBx7PHURTdgNb1NfJTXfEqPFsshGOAyyzz?=
 =?iso-8859-15?Q?ukkhsnFXv2YmD/qXuBDhqEESfQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77860fe9-f523-429a-b87d-08dade904f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 11:34:20.9358 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m16/EyaVXgVz946RC8+E3x+zdIBMMJbgGcDWZ/GjGALPVhq4wZh6Yg27AKF4awccZH6uiJlpH5akFS1cze371w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6858
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH V2 0/3] multipath config fixes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D3BAA2E1B8E9224B8821FBBFCD90820E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-12-14 at 15:38 -0600, Benjamin Marzinski wrote:
> The first two patches are a cleanup and a fix for a memory leak in
> the
> config code. The third patch improves multipath's validation of the
> strings it passes directly into the table, features, path_selector,
> and
> hardware_handler.=A0 These three strings all have argument counts, and
> getting them wrong causes the kernel to parse the table incorrectly.
> When this happens the table load fails, but the error messages from
> the
> kernel are often completely unhelpful.=A0 A bad argument count will
> cause
> the rest of the table to be parsed incorrectly, and the kernel might
> not
> hit an unworkable token till later in the parsing.=A0 Multipath now
> makes
> sure that the count matches the actual number of arguments that it is
> passing.
>=20
> V2 Changes (based on suggestions from Martin Wilck):
> 1/3: unrolled loop in validate_config_strvec() to explicitly check
> the
> =A0=A0=A0=A0=A0 possible quote strings
> 3/3: spaces is now a "const char * const" and doesn't include '\n'

Hm, my suggestion was wrong. It shouldn't be a pointer at all but an
array:

=09static const char spaces[] =3D " \f\r\t\v";

"static" makes sure it's only initialized once, and ends
up in the .rodata section.=20

In practice, there's no significant difference between either version.=A0
So, for the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

