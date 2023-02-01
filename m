Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3971C636D4
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675282405;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VsIen/cP4n6Em5VYRamhjyS2sjWqaY2SO0kTkjoljRw=;
	b=eeYcW+iDvk7XpmZX4khVQwBWqNuRN4ERsNp3G9t7SJDb/G5LODg3HjjC0iuhx7yID+7+Rk
	cIjkKNJUOzipxrvL3TXbHu8gGDGsMKaK9ea5qreQ6GrPnpZ5nI7258fc3+i7873h4iL86q
	JbXdUyWFMpQ2eYqbuHkGVkeSl+hoWMQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-YhEhEcE_NmGkz35zzPcAjg-1; Wed, 01 Feb 2023 15:13:22 -0500
X-MC-Unique: YhEhEcE_NmGkz35zzPcAjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5477C101A55E;
	Wed,  1 Feb 2023 20:13:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFDBD140EBF4;
	Wed,  1 Feb 2023 20:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B139119465A3;
	Wed,  1 Feb 2023 20:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FB9419465A3
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 20:13:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 007C62166B35; Wed,  1 Feb 2023 20:13:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED92C2166B34
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 20:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD3E385CBE0
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 20:13:15 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2074.outbound.protection.outlook.com [40.107.15.74]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-7PQxttJQM9GhGZpXDzU8Ag-1; Wed, 01 Feb 2023 15:13:14 -0500
X-MC-Unique: 7PQxttJQM9GhGZpXDzU8Ag-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8188.eurprd04.prod.outlook.com (2603:10a6:10:25e::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 20:13:09 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Wed, 1 Feb 2023
 20:13:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 4/4] libmultipath: keep renames from stopping other
 multipath actions
Thread-Index: AQHZNasNdibzGBrjF0a5rX6LpFB6fK66KsAbgABdHQA=
Date: Wed, 1 Feb 2023 20:13:09 +0000
Message-ID: <2681f5627802a3a940646c55d13ec40890fe3a93.camel@suse.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-5-git-send-email-bmarzins@redhat.com>
 <75e8e7c39785a85b068f65c49f9c334f95fcaf24.camel@suse.com>
 <20230201143944.GV17327@octiron.msp.redhat.com>
In-Reply-To: <20230201143944.GV17327@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8188:EE_
x-ms-office365-filtering-correlation-id: f52ae91e-1153-4fcf-de71-08db0490bce2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9p5at3tlaWJO9ev/4HhbMMmYFy5V01SQNcLauYETjGeMFdjMicK3PmwX/xnvFjw4xP6viM/A2YuwGnqdRB47Ix5caTLBWM9y1kf+SGiV7a2h6ug9p2BUhq/bkNMnjTXU6lP2bX0j1BS3oNH9wpF9kKseU1L6fR1DsNE7fe2iP6B3vJd3xpfsu1d60Clkl+hM3eaEqAo+AZrzOFZuL4qzRoSJUys/t4akG2qN9bJ41Ezf90/aAAl0r64g2mRHnmMWabfPK/zxse9B1TERgwhBuh7Bf+4+AWVMksSPIcILgbSHvDS//WhtwQs+Tz3zq7e2sdP8cF8ZtQHvVUWsCfbuY6j+4ZOjH7jTvHAoV9y9LLZ19Y7+EBmlHHchrgNu23N1PvosL6lHr7p+LYxWPK8oM4aDWUG0OauoWMkkZA2cPkFjkLH3OtiutlvvMbRmMQK4tdv4S9sOJCvDuN7ULRzTdzALl0iBruNmGCYJHy5MadfeF/DpyPEcII2WsJZeSpCaBFR76MTAT2ruLPOLvZml6WwZK9tOxLpWLMVIveJiiKY311osQwPSeEkprn6Slpz06OOMlaEoagwrf2nHguD6cwSPY2Ei4By9gbMOqEdYOt5SuTO2Ls906nReXjrIXEuSUbdK5S1rSQ+48wp3KX6iFNCtBOLECW84axHbVV/9IV5Pxu4VbdXksuPeRDr8bfhpUYNhF/1+ZrmI9ScYFQFAww==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199018)(26005)(6512007)(186003)(6506007)(478600001)(6486002)(2906002)(71200400001)(44832011)(4744005)(86362001)(36756003)(316002)(5660300002)(8676002)(54906003)(41300700001)(8936002)(38070700005)(2616005)(4326008)(6916009)(66446008)(122000001)(38100700002)(64756008)(66556008)(66946007)(91956017)(76116006)(66476007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?wouZ6QA1IL2vF13DNsaGzLBhbHijecZdDww+M1O8Jtii647Yh+vlLutBu?=
 =?iso-8859-15?Q?nPD3e43UgEytYNqF+a521wrK5lmfkx2ruiQt4klEycQvR2m8zPXT47H1p?=
 =?iso-8859-15?Q?Brb6vRXF8zuFhHsEXHZM97OQNf/533p/sZFeLb6N37QokA+lx4QirFuOM?=
 =?iso-8859-15?Q?/fXW6HhOWjd0kgaVpWGgnw03aNU13ztouwUPfsM7hjpAfToRC6zugYeCD?=
 =?iso-8859-15?Q?32o9zzKnXQ/eLbspgzAYYdrCsEKJOel//jSBcTn+CUGGVVcdMKy0zSmxe?=
 =?iso-8859-15?Q?OaDf6BCUX6eLdhT7PrfdEp1cy6VjLGdXP8E8vVEEZzvdiYKce5WvRaaRE?=
 =?iso-8859-15?Q?fNygXj50MBmYGRG1HRan/cTc9RImiYPX6XPRxhtumfwU3IZk//dic2MYf?=
 =?iso-8859-15?Q?yv4v1HPg+cqZCQm+o3Ta7a+RrWhVPHmsfIojFxKE8zQJmBXCbNPesmnFa?=
 =?iso-8859-15?Q?6La0bBP3DPZ3NRjzerRaURutu9eNrMNHaCU20TgVc10ks2sTtlEZHpmHb?=
 =?iso-8859-15?Q?43EgL6onKtG0JcPeyxkNF25G8jXiXOKLlgRkOWUjytqExPXBT6OTkqdGV?=
 =?iso-8859-15?Q?8jp18Z0ep/w/8gD56F01B1n5doub96f2MbwHBTgbohr1ZoMOfG/kbszgT?=
 =?iso-8859-15?Q?Y2uFDMRk036Zt+IQU7HSTpU6QTWrEghWLQuuOY9OIMtJzTYGq63sKb1Ul?=
 =?iso-8859-15?Q?HQLND7sji7ktTEBW7nnHmjXS4cl76twRWgoAMeBmQOHCu97HMrXE5Pfug?=
 =?iso-8859-15?Q?QP2BE80RJel89qGPK+1vGEXb0Qz5FcwmFOyUrOhEXFKZGeDYGfioTaD+G?=
 =?iso-8859-15?Q?0INZ3eES8rO4lR6diUKeK7jMFxARBE6OQt3JPPK4Az7+g6Goq/+a3/CT7?=
 =?iso-8859-15?Q?StWXKckJuLURglmSj4fgqkjEfX16hEfgdMlHuYWqKKXcpLsMYrtvwX+SD?=
 =?iso-8859-15?Q?TNcMSHvbMP86oYb4byBFf5vF9C04cIDhZtx1fDqMtdF4xTglPvthlITeP?=
 =?iso-8859-15?Q?iMPm3Swq7JGaJFDl/eNBQF8ehFK3+DOUPvgVwCRWKInuMmHFeMtkRlRiO?=
 =?iso-8859-15?Q?xgw2xlCty0XLfVaHxheG4jB+87q/NaIJAfYI8HGalrEvntcuamlrUpcnx?=
 =?iso-8859-15?Q?i6zUv6+WHKVDwPSZjOo4h0fw+LqqrV1TR9kAud1TiZfMUj7ofueIqklHX?=
 =?iso-8859-15?Q?GN4BwvEja4I2iHEUpdi+4xkSFfQwrt5JlwXZUAXX0cDAhftdfzkC9drxz?=
 =?iso-8859-15?Q?OUEbqHbT6iGI/jnczYr3AVnm3bAuTe60roUPHVayLezpuepbpznzmRptB?=
 =?iso-8859-15?Q?3qDY7voRTyIqJ34IQnCdIrcWKEGAfq2UN7OP2qlkoW9BBPiiOt7BecG9c?=
 =?iso-8859-15?Q?HeUjhmzSPUY8B7zGlC/xW9ayzP6vbaQ5g1xUDIvVWgV+9Es8obnaIbp3L?=
 =?iso-8859-15?Q?VfipN6ifsBor0b47r5lnwvw6dIV4Ha7R9TdfLYSZEYx/7HzoYClCKucoD?=
 =?iso-8859-15?Q?T+g2YWyJN5n/fbzjEFppjpa1aOj2ovLdvuDYsO6Rx2oDruJwF4HtjkaaL?=
 =?iso-8859-15?Q?7eHg72Zp1coG2GFWkkcc+IXbbJzjuYvex/TFRshwSfsZWuTKP767r+iSC?=
 =?iso-8859-15?Q?0QY+HaDeDXPuPOd4T5ToUtjPENybrdbl040tRDKVp+l1t4wz7+vbY/kwL?=
 =?iso-8859-15?Q?voHmKfo1w5zIwTterRdoQiFGKQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52ae91e-1153-4fcf-de71-08db0490bce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 20:13:09.3530 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OVPBd56paeaYLcavtEIkxOFmvVGTKC2obkhKRZrgujCuvgNuETSn+t3bQeUmjnDyCFFou50sqyFCyJ0XAWhEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8188
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 4/4] libmultipath: keep renames from stopping
 other multipath actions
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
Content-ID: <18286E1A88F45E40B9B49B37BF4F43EE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-02-01 at 08:39 -0600, Benjamin Marzinski wrote:
> On Wed, Feb 01, 2023 at 08:00:25AM +0000, Martin Wilck wrote:
>=20
> >=20
> > This code makes we wonder if we should transform the ACT_... enum
> > into
> > a bitmap of required actions that would be ORed together.
> > At least ACT_RENAME is now orthogonal to the rest of the actions.
>=20
> I thought about that too, as well as breaking rename out from the
> other
> actions, so it could be checked separately.=A0 But since, AFAICS, there
> are only these three special cases, it didn't seem like there'd be
> much
> benefit, and it could give the false impression that something like
> ACT_RELOAD | ACT_SWITCHPG makes sense. If you feel strongly about
> this,
> I can do it, but I did consider it and I didn't see a reason to
> change
> it.

Ok, leave it as you had it. Fine with me.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

