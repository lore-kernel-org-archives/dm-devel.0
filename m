Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E095C38A2D
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666383209;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QnI6XDtowX8gFY8K1yHGQa+LCCM3a/lxaDRLIF5rThI=;
	b=fbrwlC6ryslbInjwNKIObJ32asn4DVlG+kBu4+HMnCKEsk6lP+dAxfhsjviVVMbfmdhDxd
	Aw2H5PuCQ2KLZILWcMm0qk/Exopy3k2ZLmyT/Kjx9UjAbhWmXCKUduvNGLLZ5jLUBTTqqs
	mTla5X/Lw+G5+VSM71K4251NRtxRm+E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-RgMa1Q4ZPYe33bqlDSu03Q-1; Fri, 21 Oct 2022 16:13:27 -0400
X-MC-Unique: RgMa1Q4ZPYe33bqlDSu03Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3324A1C0BC71;
	Fri, 21 Oct 2022 20:13:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF90A2166B2C;
	Fri, 21 Oct 2022 20:13:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 386651946587;
	Fri, 21 Oct 2022 20:13:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF0251946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 20:13:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ADDD112131E; Fri, 21 Oct 2022 20:13:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 922F4112131B
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 20:13:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3992D882820
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 20:13:01 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur02on2071.outbound.protection.outlook.com [40.107.249.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-mp7b4w0eMneONF6SmtzjxA-1; Fri, 21 Oct 2022 16:12:57 -0400
X-MC-Unique: mp7b4w0eMneONF6SmtzjxA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8688.eurprd04.prod.outlook.com (2603:10a6:102:21f::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 21 Oct
 2022 20:12:51 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 20:12:51 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 3/4] libmultipath: use regular array for field widths
Thread-Index: AQHY3bvdNudt1Ixlw0ahWnEoffd7oq4ZMEzhgAAnOAA=
Date: Fri, 21 Oct 2022 20:12:51 +0000
Message-ID: <7922795ac7e0f7686296d518d215b0a077bbdf46.camel@suse.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
 <1665525183-27377-4-git-send-email-bmarzins@redhat.com>
 <306b876895770fc11229ea43418e3766282ee4e5.camel@suse.com>
 <20221021175150.GD19568@octiron.msp.redhat.com>
In-Reply-To: <20221021175150.GD19568@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8688:EE_
x-ms-office365-filtering-correlation-id: 0fee508c-7979-4d8a-137e-08dab3a0a1ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bcQzROvNdTCv5nEUCwRxVAy5cUSaay0SQt1Nvf+i7TvPU4ReN283rt7pkkbQO2Xf8ZA6MccEN4GC/VMCoaXCzuAjHIxS05EwaZgCksQPek7P+cxdBjXScr9F3YBeMamPw4cXXp/HjjbrlrEMYQ09n+gDzvqpZtAPh6mAUdwVSLnRCnh+Ei1Egooj8UtsP3SQ5DDdG8QHgvTonalm3N8UPJNM6z7xBsZeWn8uC/MacKlNyTfFWSG4rRf9kYyFgws92G3cro2+AcH6d0PQj5+QqyB2VI+RMGWQQ/45w8bTXvXe6r64QQjWe1uCFM8j5T/KxYnooYtxIGNiXUCWEWpNej0RnoqBH7Ur5eBq8bZxxo+l8dkSte/IFlL39MsXw24n4dib8EoSS50rNUWQoVEyRZbmAfSWcaHO44gROxGrNxHshmtME2Igi8OSXoGSJ5Dq6NbacnR45WRFxJdDxuaF5AMZMjMa7nPTvm44AdENvUTs/jL6kqNTPc6wGrmfMjMckXLRKVb2fw1viMvuVHBZmHwSanNCOkrbLpLSX8PC0XwhrnOeZsd0doiJmTLYsPP5Ns/lXkjXLdxZq/NTSeCjsxnen6pqGCYHLWA2qEdtLe42E/R/J/Cv/YSgKaj2E0VIvZPpQX0sZrGQXJLT5Df34OBvHGV7TrVZg3lH2cQMyyrx0cyAwv61VJSlyDumc1kHgqcK5HFzh/iuQIdplSuilyoVxVZkHJTWYLTzRkh9V4EAdoPj0CsN4fcUoGiPyQJlWQl6WPvS+QxOw7XT4Qimqg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(36756003)(71200400001)(6486002)(122000001)(478600001)(2906002)(38100700002)(44832011)(6916009)(86362001)(54906003)(4001150100001)(2616005)(186003)(316002)(38070700005)(8936002)(66476007)(41300700001)(26005)(5660300002)(4326008)(64756008)(6512007)(6506007)(66446008)(8676002)(91956017)(66556008)(66946007)(76116006);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?bU/nWJq2G41rU2I2fSUBUSxyXY5KEG9ojEU4jHbMGbxwPEvVpmJL/WCvT?=
 =?iso-8859-15?Q?/NH3SvJaQI6HuBXoO4kevDnfZ1RnpfzxUfEmB8/7NL44c5UB/nmsRIzMY?=
 =?iso-8859-15?Q?wz3/yS4KyRpmG2AM85tuJF4ylivtv3P5iaty17Hv0TcTk3yh37Tx2BIHf?=
 =?iso-8859-15?Q?URsJ+7G0k6XWR+YHLvCdDij8HY9lBeNBgF45rpKswLjaT89yLe5eLhVh2?=
 =?iso-8859-15?Q?f36R22iZ2V1Wy/1QMlPLbo/X2l2qEJRHPoYUfeord+OX06ZEQT0H91pWd?=
 =?iso-8859-15?Q?MO5LYycD6Q1qRCO/E5FJOW+mwbPYTWDByln6R4tMLukqH91Ktb2XX3hG1?=
 =?iso-8859-15?Q?Di+dvr3rd0crGdo1mj2WLRcqp9yeWTbNDd4Rrdb473V/vnfhVchDZksI2?=
 =?iso-8859-15?Q?SokRZaTwZD0pVzFCacG6myqQb4vTObp0vcPntY7zqDbsK0iHXEBZfhyKq?=
 =?iso-8859-15?Q?G9jM6YyrHujMW8dQtYxDnWu0PKbEjy4N7T267gDFwr6MISeRgMg/Tl8B4?=
 =?iso-8859-15?Q?YRCIqCzERH8Skl5LkWCwSSodEvOSSZ6Tx2QvB4CNGfJbBxFl0luAExJgY?=
 =?iso-8859-15?Q?j/J8uCTKroyvNomszWUlq/7+KaK3UF1vLQlPbEshl+wP+2TpVIU8B9Rps?=
 =?iso-8859-15?Q?f6TPWOhuynmdXXuazUZ8LWa+emPNafV/DBWnmL1PHQl7LVBNDVNnVgpPs?=
 =?iso-8859-15?Q?a9TJAzbPMS/PJCq8M7LU26a1/3hyOlgYfqdYrTVYLXBHnlxiFL3zCxPf2?=
 =?iso-8859-15?Q?aKrSaPpoNzMe8wG41x2Lyp/HaqqxnTCZ5B9HZiyrdSDlIZPqgaFxk0ZEC?=
 =?iso-8859-15?Q?XNuIpDkIWvOJUzS4JhY5n1yfkKY7jnsdbJPIiSdcWIcPpHQi6hMTFD6Ho?=
 =?iso-8859-15?Q?VIEWb3hYxloJ1Sd/nJLIT+f5r5iJanGv+WuBtnIHz45Q0nAC4HzY0YhMk?=
 =?iso-8859-15?Q?feNRfaQZDwjxtn1oX7Z6tas5esJ3bTcV5lrQautbfDIWDrpUpkCMcLSsf?=
 =?iso-8859-15?Q?PcxSKW1i3xINC3PVFWQcOxs3HcgBXXCZjS4NPcOP7EUozjpFFVAX76FVr?=
 =?iso-8859-15?Q?ufr2BOD88LUKwJRkopGaCq/7btExgkb/JE26JMQm9dv9fmuBZtobjkvXx?=
 =?iso-8859-15?Q?EvcPTt1uX0jleDDxNzgGa3exQB5uKdynuvVMnBNDXnwRiwK69mjkpHNzw?=
 =?iso-8859-15?Q?Eu+lHgvRx40HHa0rryWmy81FPfHBXV59BtMpggAOQGICeRKnD8xKwOxmx?=
 =?iso-8859-15?Q?+zUC/O74fx2g0wxVBJHpP98pokm8UV4LDrXC3Fv+FG2V32be3jdvdCL1D?=
 =?iso-8859-15?Q?ifiF+Fr50DdIb9aJV4wY8juOZetJMy2NjKINV5w9ZxJ7PerU03xGptxzD?=
 =?iso-8859-15?Q?io4so/wKPSVfvRGuyDNHt8h2wURQ1xyq1G0pr85yVCUypgUZpJAbSG64W?=
 =?iso-8859-15?Q?S8vWvou0ilhH0xgq9snojjLI6OOSYgcd8eCbtx9JD2/ldmymlCmZvuIhw?=
 =?iso-8859-15?Q?eaP3mp5VUfrpiiRxEXfql8udQ/D8O7WdFjZyIJ2yhnq6w7eSUZo544RSp?=
 =?iso-8859-15?Q?pYIbMdWGnbFoyIl7Uxv/GBINrdEXLMRbRtecO093i2eihjRbc8ut6o0Mn?=
 =?iso-8859-15?Q?7na0XuHnY24xUrhrJjp30umNmQyd9NDJ/T9redk5yBfD5Efm8/drhD5wf?=
 =?iso-8859-15?Q?eX62vcq+SvYmBtalKcoDl/B1eA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fee508c-7979-4d8a-137e-08dab3a0a1ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 20:12:51.8464 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6WMMHjFR52lU/IL6uTxrc8fZUGy6Frz+xhoT4af6Inq/c5C4AsFxh0BvAHJfH63heiFZ0Ve/2PWnZWceDaa/cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8688
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/4] libmultipath: use regular array for
 field widths
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5CF02B40EF5B9343B3972EE499FDBFD1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-21 at 12:51 -0500, Benjamin Marzinski wrote:
> On Fri, Oct 21, 2022 at 07:04:55AM +0000, Martin Wilck wrote:
> > On Tue, 2022-10-11 at 16:53 -0500, Benjamin Marzinski wrote:
> > > We know the size of these arrays, so we can just allocate them on
> > > the
> > > stack. Also, show_path() doesn't use the width, so don't
> > > initialize
> > > it
> > > in the first place.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > This isn't wrong, but I'm not sure what it actually achieves except
> > a
> > few less NULL checks (I'm sure you're aware that this doesn't mean
> > better protection against out-of-memory situations). It comes at
> > the
> > cost of an ABI change.=A0I understand that the intention is to
> > eliminate
> > __attribute__((cleanup())). But if we agree we don't want to do
> > that
> > everywhere, I see no particular reason to do it in this code path.
> >=20
> > I'm not totally against it, but I'm not enthusiastic, either.
>=20
> That's fine. How about I send a patch to just fix show_path().

Yes, please.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

