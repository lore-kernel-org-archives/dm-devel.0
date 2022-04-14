Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDAEC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 07:52:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-Gy3d6Q-YM4mQFL-_oormdg-1; Thu, 14 Apr 2022 03:52:28 -0400
X-MC-Unique: Gy3d6Q-YM4mQFL-_oormdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86EAF3802AD4;
	Thu, 14 Apr 2022 07:52:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DC7B40E80E0;
	Thu, 14 Apr 2022 07:52:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 446501940345;
	Thu, 14 Apr 2022 07:52:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BEF9D1940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 07:52:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC63E7C43; Thu, 14 Apr 2022 07:52:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5C769D7F
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:52:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96525804193
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:52:13 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-xJvkg5BcPC6T45pYrIg1Kw-1; Thu, 14 Apr 2022 03:52:12 -0400
X-MC-Unique: xJvkg5BcPC6T45pYrIg1Kw-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-YHzKCbGNON-QbK2mA8Q-Pg-2; Thu, 14 Apr 2022 09:52:09 +0200
X-MC-Unique: YHzKCbGNON-QbK2mA8Q-Pg-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM7PR04MB7079.eurprd04.prod.outlook.com (2603:10a6:20b:11d::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:52:07 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 07:52:07 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 5/7] libmultipath: check the overrides pctable for
 path variables
Thread-Index: AQHYT7gEuzSOsm+sYUip611kTfPLIKzvCaIA
Date: Thu, 14 Apr 2022 07:52:07 +0000
Message-ID: <0fbacb97a7af0bfc89bb9a34024c0e6da2b1747d.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6acba92-4a54-4a50-2faa-08da1debac77
x-ms-traffictypediagnostic: AM7PR04MB7079:EE_
x-microsoft-antispam-prvs: <AM7PR04MB707964D07D4C3FD2D6CCB87EFCEF9@AM7PR04MB7079.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YCUtD6dRYBF0p6o2AECLdMY3IpImEKLdD+QXl7TpxHgA4mxzmIXU1O8uRdxPc4YLXbb+7kLzQ2lBrTa2LCsVDq+UjFgw+C2B015+8nTTyIKRJlHApTHvyBZMxpAAZVTKMjC0D9nIbFfG/v+LhR7w3LhEzrCtVxnMRpll+lenUoeCgNJExWmh3XAZLhulGQtp2a/Risguapl1NRYvRGAIzScjIt8QYUrjLRGG43PUGqizjtM3QNT25FZTdo+vZ1js81Aw3FeUbtz/nZIIfG0TjIz7uj9r08arILyO2liUnC2caU87lDEq6vi1niWueA5YzTXZt8B99YIWRcb9wzVHxKAObD2udbe9mCALsg9DMTvqfvZFyBPJTkD2pFpEVwhAqMRz6UXDvap6f6NOYLQFgAtsgfyi99s03UzHIRZIJHIRNoX6eEQMrxsO8tVQxr2JGrotVmJqN+QQumHbM637DRa7NjDaGqXG0YHS864oC1WbQA35rK+HevJK1HaGa2VGc5bQUGEZSCH7VZiCfGwNenx198ttTohuvt+A7YNX/BhCeHTy6gc98YpO2N02aDkapH8rIMTAufy9BAoHooLXeHnk7C1rRDaFUk6JIQ1LLsUWGLz57uESWD90e7RoxppYYlospFxxxv9DxcF7DjyV0K2sPoNt88NDgU/g0syB4NFkTokjojALK4uJ/hL8X39coZzhrGKwfqFyY5BAqbnscw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6486002)(2906002)(5660300002)(8936002)(71200400001)(508600001)(4744005)(66946007)(64756008)(36756003)(66556008)(66476007)(8676002)(316002)(4326008)(86362001)(91956017)(76116006)(66446008)(38070700005)(38100700002)(44832011)(110136005)(122000001)(186003)(2616005)(6512007)(26005)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?e4OcUHj+BkaX1n7ruwuirO7/SaYgEqhn0fuPsNKILjwuUEvyFlQn8ZKr7?=
 =?iso-8859-15?Q?9fJS123gDNZrUcIIcoE1dF9IWmVzAMQoGRZ+N+3IQ63mtjoXuMiofPycl?=
 =?iso-8859-15?Q?k/VMCLejFg6cpS+rwjrk67BVKrsZRZtlhd/oZrfObivWXHSxbRexTsfsi?=
 =?iso-8859-15?Q?iYxIbWth3BusdFOiJGQvh3Z6jf2PGW5fOa01Dp5UdBkW4b51xw/uaYbD3?=
 =?iso-8859-15?Q?dtPUDkK2JVcMCkm2sdndqJrWmy3SZdGDSJ2liY08e8qNAW3g+Mcp67m7H?=
 =?iso-8859-15?Q?XdsMjHsjpI09OeiJUquPAW0740KEDpHr48PitD1LRtQ7fROyqOJmrFArW?=
 =?iso-8859-15?Q?2D/OGB0Wouty1q8nWrVUiJaGI/EGRMERKjoDo1yM/ew5BIy94/SJZc8FC?=
 =?iso-8859-15?Q?oZVzSrrLFpBh0/7XD1APna6b68h3wrgoyYlRme9aWcai4v7SRxc+ek2qh?=
 =?iso-8859-15?Q?6LiIPOSZF7amBux7lCoqhm54FTeZrJyFdU8Uu4ey/Uk7DSIXFz23/itI4?=
 =?iso-8859-15?Q?XCZF6D7e8tniczf6NQdnBontrYGVuyvNPThsUrZyzfamP3GcMc1iJREv0?=
 =?iso-8859-15?Q?ZmGiZ/RGbG6iC+DO/z+ikP5NNDmbl2RI8PcTcSl8bOKbu9h9RqKyi0F74?=
 =?iso-8859-15?Q?sqZMCoq1LIj3AUASq19yn1E4JSoCqmjcH6sTQX5r5oODv7ik2xeJA6js3?=
 =?iso-8859-15?Q?EqciG+KRpwFxVAU1LoJ2wbuve8ovRZ+4E4GvNONRQlmk0C/9ql/vr54Bw?=
 =?iso-8859-15?Q?bX6CNgg62oDbnp5zQ71V1UPH13Hcl2J5Y8hGbrg400Q432Cp64MfJjyR6?=
 =?iso-8859-15?Q?fxfcNfGKhcyrEqHoU5ALPGumtIjiYAcLez0crw4P7r/MZ9/y7vw20wG2N?=
 =?iso-8859-15?Q?vcwT8pjQR21+Y9NDBoLXuQ2UOxwTB9v96Eje31QwpwEfliAfIlGDWTiD6?=
 =?iso-8859-15?Q?HOQ/lZNjDkLhPRu3zul4TUuSTYzB9ynkqK3CDOmU0/GQhJ+njXgrtym2D?=
 =?iso-8859-15?Q?vlu/e2UShPtmBrAnjh2yFpY7NaMNTml9/cGs/AaKSPiPWucTbZYH/7oR8?=
 =?iso-8859-15?Q?9ytl/ZXjlh63z/qWjdXcF+ZNAqDL8nvqcvX78wQ6XGH5DaUQHBbLhCNjt?=
 =?iso-8859-15?Q?hFOU5/vaihBmslZ6XkUxmRN69T4DWChSU5AmZQ6Hi6HsM1tWrhGWm95Ag?=
 =?iso-8859-15?Q?L2LsXGf75W+7x7GzsDHIUx/wqj2bPNfTpgkBd6k0tuOEt4nddECg61t6m?=
 =?iso-8859-15?Q?LMPLlO5lIIqBswCl9T9QzjhuCYXlzbuflnZb5ORUEde8/EgptIzHPpvEk?=
 =?iso-8859-15?Q?4bGuwJyULGq8UtmU62fOVyg+TnoWCbGNCVp2r6kQlVryQOQCHfqo9KQ2K?=
 =?iso-8859-15?Q?FiHY7otZD3gghWJEY88SjsQMnIyD7Fcu2WuSEeNkg4XJe9yfPiascY2er?=
 =?iso-8859-15?Q?Gs+SOq1uTvV3QzSSxM4x8AtsfAme0jZmpTsoUkqcjapPgDFerwOgcLNlw?=
 =?iso-8859-15?Q?mfQusityGsFJNFeBbXq3Zka1O4Eq6xYZ5u2d+oZknFwadvtOoTbVB6w1V?=
 =?iso-8859-15?Q?YIA+9G6xCnEDy7dOJ9yU2eDw4oDNEufOolt8UmBB0BWf9ikKj5WgaFRo4?=
 =?iso-8859-15?Q?Xqm5cDknWKXlNjxEjhtL4fnuigk6FVlFblx1tZ6RWvvg6L2w2iKE/Kiwz?=
 =?iso-8859-15?Q?AeJuuVXmMYkF2x3THKPXEvY+9Mr1/bmaYjSHOcl/pAr83Bz+H3C0jyUuQ?=
 =?iso-8859-15?Q?B8Uk/vy4Uqm2DmvHVPMOU1vTQnj+5TXHm1zaDtIKLf7VFvnjQBWaB4CHc?=
 =?iso-8859-15?Q?bT+XyJOd4CS1aQ6eJKze6Tqw46AxsY+n3+FhFsMG/aEloOntY7sxNwr7c?=
 =?iso-8859-15?Q?aKpE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6acba92-4a54-4a50-2faa-08da1debac77
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 07:52:07.3577 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNxOudeg4YM4Ra4JBOmYJbpq7XgKluq2rqF9CeLagNjk+O7FCN+5UkO3hIGIAVis7GKPfF6MAVyesM55WRYbAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7079
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 5/7] libmultipath: check the overrides
 pctable for path variables
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C27D5C0E3A99E646A3986A2B3A1E01A8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> Paths will now also check the pctable when checking for attribtes
> that
> exists in both the overrides section and the protocol subsection.
> Values
> in a matching pcentry will be used in preference to values in the
> overrides hwentry.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

