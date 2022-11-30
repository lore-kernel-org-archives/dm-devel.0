Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2170C4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669838227;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HwfEAgKl8IRWbW0QsS8MnYIoid4FA8lqyoCbq2AUcsE=;
	b=YF7VO9mUTWILbPedFm0vLpMMDJ10ZupBXRVVt+YEkvwi+a86k0QFmJ0ch8DU3s0vkpL2F2
	o4KAWGTyEyj5Ky6/UmFGlEXAr3wPXc0YzXQW/E+dB5TMqtxDeu1yLFjhZbGcuBFKw9irGN
	cPIZzaWeHmUtfz82SpjpA98i4fr3pzc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-54vj7HDCMiOD-0opGRs9-A-1; Wed, 30 Nov 2022 14:57:04 -0500
X-MC-Unique: 54vj7HDCMiOD-0opGRs9-A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56D93858F13;
	Wed, 30 Nov 2022 19:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3ECC3492B04;
	Wed, 30 Nov 2022 19:57:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 207C119465A0;
	Wed, 30 Nov 2022 19:57:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 944151946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 19:37:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7255C40C6E14; Wed, 30 Nov 2022 19:37:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69B1140C6EC4
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 19:37:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E566806004
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 19:37:26 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2071.outbound.protection.outlook.com [40.107.8.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-bljEg3KOOveFfDtUYzJMDA-1; Wed, 30 Nov 2022 14:37:23 -0500
X-MC-Unique: bljEg3KOOveFfDtUYzJMDA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8980.eurprd04.prod.outlook.com (2603:10a6:20b:42f::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 30 Nov
 2022 19:37:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 19:37:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/2] multipath.conf(5): remove io-affinity information
Thread-Index: AQHZBPMpHSPoyYV/FU2XXkQVVZXFwg==
Date: Wed, 30 Nov 2022 19:37:20 +0000
Message-ID: <a08c15dbcf78c63ec0a55bd96c6580632bd5af7c.camel@suse.com>
References: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8980:EE_
x-ms-office365-filtering-correlation-id: 5ada4603-95a6-48c1-3256-08dad30a4bf9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CJmf+z35Y32MyI9I18lFBfE5t3psOVWublU1gOSycfTBBMhayuDWM1kzjF0yFejk1ijNhvHk80tfxLt4OwqFJN4+Zp1nCy06LmKLuLx8uczvKUqRr5elwaWBlfi4u4/7cdawomnNAjck2c8KO7GcydPql5O7sfUpaKWXXswp3FBGYQRwems6YHaDY8DNnEFgezHJ5t1CqeZSixwDpI4EkmESoTF0hWaMQOJLLvH49uiGxQCRNx22DQCbr2ysxcZWuIqyrSyEIYoTOJJg19GgX+mJTliFg9ZEbJL89yx0lee6inUrAsQ1Oddw9slw5FY0iUM+WoU46aE59eXLKrfsoMHS0/x5BekJDxceWAmv19tSlxQ2brQxKUgeDuXIeQSrwfEqMra8E7bCKf42wTpHUFHwQQUCIsB8DXW4lI1bDnXA4AwLLGFDT+oIfLp8AL3flnBdPLDB7grQwvJl+1JR8TCuXVeZR78tB/uKqM1OmNsGxHzzccP6TWIKorzf6qqt+DUOjH+SL5jpSX7wheQMbtSrJt9YdCzE8ff1SlSPrZWNsCqNPwrd+4wO2MIBMZgRajSL4EcHMYWF/WZa1Py/RTue2ZYf4NeXv1tzXO4Vmg8S+WzCIouLjtRjDYag6sHbiX0/2l9zGQN0s1SgdrduUSHMKiRHWSSla0KgGU6DvNrcVL+T6uOSAuCnVXWR+oq58r/QVahD0blYT9z0YhKDtQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199015)(8676002)(36756003)(186003)(316002)(91956017)(4326008)(66446008)(66476007)(66946007)(64756008)(66556008)(76116006)(44832011)(86362001)(2616005)(110136005)(38070700005)(5660300002)(8936002)(41300700001)(4001150100001)(4744005)(122000001)(2906002)(38100700002)(6486002)(478600001)(71200400001)(6512007)(26005)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?S7Ig+CdFqSzfCING4ZFdUdVckH4WUr4n9rJiB9XLY8mqGyunJbKKMR6Eu?=
 =?iso-8859-15?Q?gR8CwL+Kh90UXpAKF2Yk7S5RoGih4i4Eqe5rv65Mjkduv867NufZGsoM1?=
 =?iso-8859-15?Q?HBU+iGvMMME5tZNv8ffUbVEwI9fPCkLa7rn8S37Y472l01jLUAMKtMgFG?=
 =?iso-8859-15?Q?s9vsg/gN4utV5dplJ4yQJ4sKv9o9cqv4wljGyvTGmoFDGPxOCGoyNdu0h?=
 =?iso-8859-15?Q?6+wsU9NDVh8h3gmG5j0tdqjsGqxiAU7GI9c18BOVji7H9n2Q9jXZ1Q2ZW?=
 =?iso-8859-15?Q?CUWH24R827rOrZLd7w4eqBiC3iWJ4skyUqYIVKzOetFOyH8FobWv9kDTE?=
 =?iso-8859-15?Q?hppYBJepsMl6YGkoSeivh/SFg4GVqrZKzRoBeGqYDrr+Uzeyjb486pZv1?=
 =?iso-8859-15?Q?L49zm4DcPAk6A0K3jKSVWfGHW8cL6YzQxQFu3dLd8LuYugEaPFw1moGl2?=
 =?iso-8859-15?Q?pvETDL0+nfLnsUcpM1JCAecM8Wq3MLA6JULjDCKRMKkGIuTL5xxC1bnX2?=
 =?iso-8859-15?Q?pant2lukzq1pLX9dO/uB25ZkS1wTKMqSsjsiqsGgevuppEfyiOwOIV3VN?=
 =?iso-8859-15?Q?hx4oX7p61L82mUB+gqyKlu0e90d2Egh9Pt2NFf5OC2oGyUw24vQtooTjx?=
 =?iso-8859-15?Q?L/CsksAYHSp5t+reKDBrU2CwACVtHlgDkwj8ewLG/T+8fyFT5M4DTsDNV?=
 =?iso-8859-15?Q?bFZLuQXq80lbCa5seKGWNVLUjNDEKQ/1qhZ77CifoE2RT6eY/BngWQyWK?=
 =?iso-8859-15?Q?r1/UgHQIhdPaBXLNiCBq/aoYYyIm8YgS+Gbhe3Lh5fKktnw/G9eFLlPqI?=
 =?iso-8859-15?Q?wdeUg4AXyFl42h54PCeGms5SpBlHGZel3mG9GAa5iShogqTlvGuO5ZIZY?=
 =?iso-8859-15?Q?Q8i2LblZCCLoaeSxyuCpNsWnzDgob3g0W6N+dMqUn2fhXDKG3oR5ay9EX?=
 =?iso-8859-15?Q?WQSyL5baw4OzkExEsEW3cgMTnip6zePqZUlnI7VwYtUud3BZg/XG4ObKX?=
 =?iso-8859-15?Q?s8pkMW8jd/VL7dELDmXSIRfCFfzJkwRBDcQQ0JGz+D41inizrRuzIEgt/?=
 =?iso-8859-15?Q?FckoI1/ytPHyM1suKOIhOqwiBv9iRCvJY8l9BtFuavtJtIcP5OJIiuUVj?=
 =?iso-8859-15?Q?N5bytJFM2KWrCD4lcx3LQG76d5ou8zxvkVq3sXiPnotciBshzLDjBBv12?=
 =?iso-8859-15?Q?kzCyG74siy2lmXudH40EYoVrBh5o8oDZndx6TsbwVMbFjCP6dmp49Rpip?=
 =?iso-8859-15?Q?U/y+hYi26+lctM7XV0cNxKBOcRWuf+mBKsZYVDdgqURjmtQr3BodD8/CN?=
 =?iso-8859-15?Q?vGCuMHgaXsNUapHiyyyXKzAAFKp8GK/gWoUP4Yzu2XGhpW5wrNvDEmJVn?=
 =?iso-8859-15?Q?07XRvk3UMoWSdLg1Xbml9U9n9KwOI9nbrVFzVNGDasXUFI+dJVuRWq11p?=
 =?iso-8859-15?Q?pAXgnxLS3WEMNL7qF443mHy/SQuuII2Va/yCEDsA4swmNewc6um1ZYBQ2?=
 =?iso-8859-15?Q?73YeB5XfHXRKdDc90PThW5HaOqdXXr2mFC37a6vhpAxIoqvfwbo+TyR9J?=
 =?iso-8859-15?Q?JQvEhUk/8APdu9V/kWLWXt5QtAN/R+li8xkXIrttLbuK2i/ChYIStr/Ri?=
 =?iso-8859-15?Q?7EPtE8bLddwBnJqj8V9cSYqVuAtMraF32tQ7WZFp5UwC4sLlyhteKwnaU?=
 =?iso-8859-15?Q?2Sid?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ada4603-95a6-48c1-3256-08dad30a4bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 19:37:20.3946 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Y9rrg7qPOCEhWQLMqtg5bq8ExUpByZxTTXvso5svb8jRDtZSQvktjVD/g02H7DKznT7gRC28L3Tc4a8FwwZgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8980
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 1/2] multipath.conf(5): remove io-affinity
 information
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8EFDB19E356F1A4FA35B6E2ECE361AF8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-11-29 at 22:56 -0600, Benjamin Marzinski wrote:
> The multpath-tools do not support the io-affinity path selector.=A0 We
> always add a repeat count as the path argument. The io-affinity
> selector
> doesn't take one. Instead it takes a bitmap of CPUs that a path can
> run
> on. This isn't something that lends itself to the kind of
> auto-assembling that multipathd does. But even if we did want to try
> to
> support this path-selector, until we do, we shouldn't be listing it
> in
> the multipath.conf documentation.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

