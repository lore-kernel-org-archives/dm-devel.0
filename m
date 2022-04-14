Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAB2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 08:03:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-pxPoPulbPaK0gtMhcdk-Vw-1; Thu, 14 Apr 2022 04:03:13 -0400
X-MC-Unique: pxPoPulbPaK0gtMhcdk-Vw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC48101AA46;
	Thu, 14 Apr 2022 08:03:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9BABA416156;
	Thu, 14 Apr 2022 08:03:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 681D51940345;
	Thu, 14 Apr 2022 08:03:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9BE701940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 08:03:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 575BB426321; Thu, 14 Apr 2022 08:03:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 527AD426325
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 08:03:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B05180B71C
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 08:03:09 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-bBHjAoe9OQCbuybSo0TGsA-1; Thu, 14 Apr 2022 04:03:07 -0400
X-MC-Unique: bBHjAoe9OQCbuybSo0TGsA-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-lEHGh0c0PQ6Uh3ZZrQHwRg-1; Thu, 14 Apr 2022 10:03:05 +0200
X-MC-Unique: lEHGh0c0PQ6Uh3ZZrQHwRg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR0402MB3477.eurprd04.prod.outlook.com (2603:10a6:209:12::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 14 Apr
 2022 08:03:03 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 08:03:03 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/7] libmultipath: add a protocol subsection to
 multipath.conf
Thread-Index: AQHYT9YRWoUL7MrLikeEDoNwjSHlsw==
Date: Thu, 14 Apr 2022 08:03:03 +0000
Message-ID: <0f782e4c31ed880829d90264bb0ae01c8e5ddefc.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-4-git-send-email-bmarzins@redhat.com>
 <e75e2e48f9d8ac2985f5995ede8d7d0d609929f5.camel@suse.com>
In-Reply-To: <e75e2e48f9d8ac2985f5995ede8d7d0d609929f5.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 636e2948-6e78-4b78-c6bc-08da1ded339f
x-ms-traffictypediagnostic: AM6PR0402MB3477:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB34779144D0CFB43E85B349B6FCEF9@AM6PR0402MB3477.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: DXJ+jeydRhWOMbGSxPJV0QKP1r37rhmlWYoQuT/iSFCI67s82zVwuImN1VqUPdc+ASSEvjAq8GUtu7NDdSNwHcPc4ngXV/3ZzvbuOtuCgyRlEra1X0nSITT2Aln/BE2S17utY2yegsqIwaCud4pcrvGsm5irx2f+y34CxfhfOcbuzM306aitaddsuDXpFr0ZQYOjWJ3m+HvAdcmgmtbx2PmaG/TA2Rvj4baSGs8C3XEZOkgK72amWwavLARAhhDp/52Sb4oBBTgCzRtdb7uLSkME+WoAbE9Tniajg0rm5soLAWDu7BwVOS7VGineQUvslUL3uvL6r5d6OzXYOEMgBW0Qc+saByIV8NxPnrlvIy4AEurC8EhTbmujD6tqScgllxzPDiUpLuGA4EL3Pb/3T8GQIdt2N7Cf2tNq21mXanyVFfOFTy/SWY4llizc3Cy9kmVUR2UBXz4EpLZsZqn58ehh0P44H4Oh//QTKa4Sf5k7tceFqzwnWhgArSbWuAUL+e8ZRkxJVIrFg4qNEsNd7hZskx7/yEJPoD8Ior6Ep6XqhMAIJE2Hbag5ynDTkJpJyr8hrAptTgL2F8apH5RCXRou9xdn6bU4g+cowcp5vwSfTlobmIKWhvf0rAI0931P5IRyJwjUr08uguT0XnzoSIQ2Y9alPvXI02k/5zPS/B8Xc2VoWAwyO/jjOMoE9gg+AL/zxXDH69GgOcTk91wi6g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(186003)(316002)(2906002)(122000001)(6506007)(6512007)(4744005)(44832011)(6486002)(508600001)(36756003)(86362001)(110136005)(38070700005)(26005)(5660300002)(8936002)(2616005)(83380400001)(38100700002)(66556008)(8676002)(64756008)(4326008)(66476007)(66446008)(76116006)(91956017)(66946007)(71200400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?nw9C9JumpGkxpLOOFV4yB53QpXyV79XNoK9v0BqLpmQs8scT/D4OEUFD4?=
 =?iso-8859-15?Q?wCEcsSgmSZaWZPkFV5xGpJrfR2jv8+3jjUIyvcvvRleM7nvNY0n7d+iNB?=
 =?iso-8859-15?Q?l8TOmpTrKfnLjeTukyX37g4G+D0+v3hG7fnwAw7cBCYaDe+N3xxSTApxw?=
 =?iso-8859-15?Q?vsQvZrFj2a56f0weBX8tRXU0bWgn+YmrX0Xa8toXlf2dcOj4GtdZ+rDEk?=
 =?iso-8859-15?Q?MvtD/AW0iR+zKRpRrU14UJBYNgb/LVfXO9jmFPQYersk8JiAm2GtNaBpn?=
 =?iso-8859-15?Q?eQgIX0BlbnNQ3E2Oot38F53D1beMI3/q9Kt23ZbUBTgm0vgpSdgwhztXH?=
 =?iso-8859-15?Q?YhfP+qSkPpw4sQsy3K4XpZ/pLxJxkQa4382aq6tAISM6IDWlsbhQrPU39?=
 =?iso-8859-15?Q?0fNo0YweymM5iKeel1m5Qf2hp25xabhzqUNaS2iNwrRs4Hmvpme2ow0Lo?=
 =?iso-8859-15?Q?tpCe3LBcpi+eB+N7CgXeQ5RQHrjFHgYipPEg772lUFp+yACRz9cyRpiFh?=
 =?iso-8859-15?Q?jtN2gO+VEe5ZdFuQPH69Oq2jRSxM28taCPAoiyiPzUpGal4lpZAYKDIr+?=
 =?iso-8859-15?Q?gSDjgZa8O8hxYEO+gXQ93QwwJsHbIUVjAetynF2jMjntDUxhjcIUUM7WN?=
 =?iso-8859-15?Q?VrD/xe7m7MvG5LoU5LtRSjW/50FX0+OsfeKPvyTp1YC04HXRETbaybWLW?=
 =?iso-8859-15?Q?yWJ8INN3k36nNYoB3DMfApA6kwPGwBwoLpEHO40zg60iaIDhNnC+FSLBL?=
 =?iso-8859-15?Q?R/d2TRKPoyhsHEEUTJ2oL3pb8QZRD6M5eY11takcaCAOKsF8EoLDy9Frf?=
 =?iso-8859-15?Q?W7Nvt7UeMt4W/mbJp96LKlfnw+u2vVqiFeSNOui+sNnDxTJmR89H6ZCAX?=
 =?iso-8859-15?Q?maSe/GQiLgH7xfPtMKVBZjTQxUeLamUy5o1HaqFzPM8II6xLa4+jiv92D?=
 =?iso-8859-15?Q?L77W+Pc4RPh11GbcaK2YMazjvpFE1KMzbA9SUFgQd5J8MLPpi75x1qaOI?=
 =?iso-8859-15?Q?aEUJfhao3AprfUpXBjRIHxD+AivuKeFtepqF/3U4eMkNO/VWdv9PWCRSJ?=
 =?iso-8859-15?Q?VmJr/iRItsjY0uckTlIUtPHg7x2ltAf1yGJ73csjcd/nbukYDSW7DrM+D?=
 =?iso-8859-15?Q?EEEKkj7ZhyjMTtL57DkpH6atHROCITqvZ2C8DMXkQIYJuqKuQJnsPOTMY?=
 =?iso-8859-15?Q?3iIuL6eyhtPXzOiOiLlE63oX1y2HXxeE0gzVj9OtSbl6JlLeHCc8i2hKY?=
 =?iso-8859-15?Q?X30uf/0awBM23BO5k3km06GS4ywOXTjT2AvpQqdelqcPlbzrQqqxO+9od?=
 =?iso-8859-15?Q?AbRC7z3DncdpbD4o92V2WQT/rSTpUO7Z7gNlmkyWBsenvWfJV+DTP12NB?=
 =?iso-8859-15?Q?mQkfgA8cZtYWxpbniDh1jDSHDiaU9LXK4rYiQ61DoJIV8XJOWDzuEoXZy?=
 =?iso-8859-15?Q?Iv0+i5fYRmKwYV3rSs/Ow0XIbj0+Y4IT1gWqmnO0fXBRXY2aA7UKqU5iY?=
 =?iso-8859-15?Q?xwgMffSkBk4Ttagp4DjSLfcl+Z3Dv328sKjTHn/SaXhili4/RnPKgVmj8?=
 =?iso-8859-15?Q?0mob5k29vfarKV6GiewYb/YgET0zg4Se8LY6tleMuHAawuTCdSrpkCJor?=
 =?iso-8859-15?Q?0MaP64xBIWn4i7htUkL+LXJDWuA+R070r9LyO7cWSa6epKwGo65cVJmyz?=
 =?iso-8859-15?Q?my3hiC66zRVQhi48tnU/GVQMbrd4eeAWBaxVPfnkXSYpFSsb7Pa6zcqeb?=
 =?iso-8859-15?Q?rNORjGtCgmg6CqEIbJ9LR7gwbv5YX8tox4fFcaibNZJZLJyVd6BU5HdLn?=
 =?iso-8859-15?Q?pmQ8QUDE+nJ4G2BcdpXvkNosQDl3WQKJ11Z2dNpv3hTFqf0B40C2DjihM?=
 =?iso-8859-15?Q?5eAU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636e2948-6e78-4b78-c6bc-08da1ded339f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 08:03:03.6285 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKPkbtiL1Sn3TSR8o8UHxIJ09rbbOqzzjkIBAh9CQs2JcXfwbIJ/9k2RlxRHD4AH2PhnpOxwKb5aoDTlYXqheg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3477
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 3/7] libmultipath: add a protocol
 subsection to multipath.conf
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <97B1DA975E7CA545B39080F95CAB33C6@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-04-14 at 09:27 +0200, Martin Wilck wrote:
> On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> > Some storage arrays can be accessed using multiple protocols at the
> > same
> > time.=A0 In these cases, users may want to set path attributes
> > differently, depending on the protocol that the path is using. To
> > allow
> > this, add a protocol subsection to the overrides section in
> > multipath.conf, which allows select path-specific options to be
> > set.
> > This commit simply adds the subsection, and handles merging
> > matching
> > entries. Future patches will make use of the section.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Looks good, just a minor nit below.

As this is really minor and I'm going to be out of office next week:

Reviewed-by: Martin Wilck <mwilck@suse.com>

... and I'm going to push this series to my "queue" branch.

Perhaps you want to send an add-on patch with a symbolic value later.

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

