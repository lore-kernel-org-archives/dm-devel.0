Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE63C54E94
	for <dm-devel@archiver.kernel.org>; Wed, 25 Jan 2023 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674643252;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0y/S64TZ26Ic+Lc9gYBJpbjQybZR+HrAYMnq3DC8Z/s=;
	b=DerlpfoGS5RCYZ00ljCTP8/V7CjzGKOODDiaQDam+KRpde59hfGtdaBz6PX3LhdHCvmqr+
	4NCS7RCVOSuD9gbbI1G0STbEQmX6IfvfbAMjfediSQJx4uSWHjJtjpJ/myMN6LPpodsR7j
	h2mOpLoQvKFQj0y8stvhbuLc1swckjM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65--_j5KayjNa2TCG7gR2y3Hw-1; Wed, 25 Jan 2023 05:40:48 -0500
X-MC-Unique: -_j5KayjNa2TCG7gR2y3Hw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3227101A55E;
	Wed, 25 Jan 2023 10:40:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E2162166B26;
	Wed, 25 Jan 2023 10:40:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CCD2194658D;
	Wed, 25 Jan 2023 10:40:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9D0C194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 Jan 2023 10:40:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE0822166B29; Wed, 25 Jan 2023 10:40:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6BA92166B26
 for <dm-devel@redhat.com>; Wed, 25 Jan 2023 10:40:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3B52101A52E
 for <dm-devel@redhat.com>; Wed, 25 Jan 2023 10:40:40 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
 (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-xvmuqYXZP8CeFB_oAiiUkg-1; Wed, 25 Jan 2023 05:40:36 -0500
X-MC-Unique: xvmuqYXZP8CeFB_oAiiUkg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DU2PR04MB8950.eurprd04.prod.outlook.com (2603:10a6:10:2e1::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 10:40:33 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 10:40:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/6] libmultipath: make prflag an enum
Thread-Index: AQHZFMyS6bhrbWemp0+Ei98aIVt0h66vKUwA
Date: Wed, 25 Jan 2023 10:40:33 +0000
Message-ID: <786f375415ee12a0f12c93cbd817a19a1501881e.camel@suse.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
 <1671579675-23658-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DU2PR04MB8950:EE_
x-ms-office365-filtering-correlation-id: ab52b175-e49a-492b-42d7-08dafec0965a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fvMNE1hL5OwfSF41o2Ffw0QETBip96yASL9DYupMmlEEz0I+I+l+2tgQ6frvVjPDcjs3qB/v1Zjwwj865Tr8EEaAVQJCR+ymf4aAquNKPZJkvTfUjRXi40worOX5NMmvSuhF+vGzXxqQl8Gk40WYrAy2hhEVvoU6oohhSwrDsh0UzUur/cDwmqpCX+wVAHEZaOeus91aGebylAd8p9jvEPeITGG1U4x/fSNAcZ0fBI6BQ0WKxYMyAAtWFdnjSEzGcrLa67E7HctjrUp6M5nTrMFjFzRxYGZFRCLRZ+fahAqFRM0/qEa2Da6AJaksLAZhaaw7x/IE22cbinK6lXy4uOVIAnZjap15K4NFpKCkc3Apnf9VzpQu4G5lsylYxE+2omYhsYr7DsxvW4ejMfLD7E3ddEOKHE+jSoLRNKbpA203+lQ8ZFmzFTAVQ2AQhJnQuodWFnQ2JcAsmRlf/N7UY1wLa2Kf+IfEyJ/kY83L8oBo6IWaabeHDekX+q2OF80jD3MVr0gDUL9a1RkjhK2Kij1rUdiVtyAnyuRka/2xoVJDdI92cvc4F77U/MolkAueqGhBMgCcYWGBiY/bCUMJWC05SivtmAyfaYFP3HnO0/vq6D+wZGN/4TvFfRYgGAsHz28unpy2brRFkS/pgwAgmqGsaKIrJxKdUIuHedW8BTYWKFFgBwFcfV7pzvSkrNuUWsDc3pt440rdwMUCGOIXa/K2oCC1vevOEyuRCv9lczutZ1A46K1A92ZVX+Mwg8Jx6xYasJIAdBXKY58ai7pbQg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199018)(122000001)(38100700002)(41300700001)(2616005)(66946007)(64756008)(66556008)(86362001)(76116006)(110136005)(91956017)(71200400001)(966005)(478600001)(66476007)(6486002)(36756003)(6506007)(66446008)(44832011)(4001150100001)(5660300002)(38070700005)(2906002)(316002)(6512007)(26005)(186003)(8676002)(4326008)(4744005)(8936002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?5On1uqZnTgUsZASS/TIYD69azvRWcBexBC3SiG8pV2YmKthra1uepcmoV?=
 =?iso-8859-15?Q?HdwC0dT4qR9NBmMn69wJdd7OueByoEfGy4byo+SdKaH46vY2nEQQBdNfX?=
 =?iso-8859-15?Q?QUNcRkv0XVLXBGNgkPNI15H8lPPpVAJDgrKDQy3mxDZOTYmDNB/i9vCHS?=
 =?iso-8859-15?Q?DYRwNI/l4PsUCTWvkedaihyGKDIv3xaAd6msASrSLAZZF5y1IoCSCXd5p?=
 =?iso-8859-15?Q?PD4L4uXV+rDRPzGDGt0+H0Lqp4qNNPLZZoCG9RQLybOeZzvNUWft6eZPq?=
 =?iso-8859-15?Q?ZfSiJLq2R4W3rdy1RJlRXN9mhM1O6w2sOqV6wN96hhPqMQ1zknx5OQfHP?=
 =?iso-8859-15?Q?REYFh3rm8Ahhvuh5f2gwOc8/XiYqzm1x9OsneIOOvb+Ftdy3Dj+e5d6AI?=
 =?iso-8859-15?Q?5Jp/YtBk3/x1s4lciHjGkbPW78eQPYAN1RKCAXbKIq2JlpdkiT6NBvQ1T?=
 =?iso-8859-15?Q?2rZyOcgpc/vhKuLsjWEPqp8c40MIZ7JmkVXBpBvAZfclF3zrf+Ph8e15b?=
 =?iso-8859-15?Q?GrqilJaV3natDzZKCPAE0L5Ek1uxutReJN+PRbXFqwhbzfMBRsVkfNKp6?=
 =?iso-8859-15?Q?RpPuRYHBe9xq98wdOdjj1vWl3EJFkI7svH5TljdDXc3uKEX8o4Jzeq8xT?=
 =?iso-8859-15?Q?3PW7GH3Q+lnZpIhAT7VOfGDz1uPKn3fOqL8sED9C0zj65ln1wQlxlEpIP?=
 =?iso-8859-15?Q?KNv+c5Jel597Njhv9101cJdrBDG7skoC+k8fwCJa/K5hMw0NlwjxosvPu?=
 =?iso-8859-15?Q?KjaURwxxahr/x8tuS7800KTFEgznVp3tItmv1+sLzx4fl0a6v2HBQXKpt?=
 =?iso-8859-15?Q?/xwc1/rNAcEWfiAZPDMYga5QPhPg3CUx8FglZXICr4r/Oks7uwCyJ/eel?=
 =?iso-8859-15?Q?A5eCYSpx2++1WWsYewOhj74hpt+vd+QIYU1Ea4bjs7v6yJvSqKr3lDdHk?=
 =?iso-8859-15?Q?e4/fx/IcDtK0Yj5XRsiKSdaajVj8mJF6XtoCOYvncJoazomNoXjziN7Qm?=
 =?iso-8859-15?Q?9rXXGO9D0iALeukO90TEoRxm30qWdp0Z4Fc2ho/IKCnS5SJSRYcN9hQvy?=
 =?iso-8859-15?Q?dgwgnwUBSOIIheG3RWln6yyY70RlsguZcu+1gjeE3WPwUY7Dgo7gd3czL?=
 =?iso-8859-15?Q?m/Txl/3q7UQYyX/R014/90Lwg3RhF3lpSRt40xoHJOctWiybadZBxtXdE?=
 =?iso-8859-15?Q?BQ1TH8pLgJ5HL5XAJ6ZZJdDJyTth8P/RYc7Q3iTK1OsoWClthnS4sVPx4?=
 =?iso-8859-15?Q?ndo1XPk7hpxWX8WQ3IDtJ74nsd4zAbZscoyqnaPN1yVxCedne6MrSV+R9?=
 =?iso-8859-15?Q?svFr050mcPjFmsyUOxxelnHo3F7LTV3Ou7RzKPGmphPjE+JrlY/XLUSdq?=
 =?iso-8859-15?Q?IJLjeql5WpyAdz+KXSbRCt+Z4+1jeAQOA44toM4jhsQYqVJK4F0u1Kuft?=
 =?iso-8859-15?Q?TjhcmjOsiZ5oHu4nleFk+vp+QnEbMblXGFvSinYm8dJQEqmrXKBhPmx34?=
 =?iso-8859-15?Q?GjKajE9DfXnLQruKaz8+ra6Jfjau0MfGepdRX+62xXq5an05vjYChcfYk?=
 =?iso-8859-15?Q?ZWstWr3Jv82bBejNMMFFDlmQ0eet43H6hseOp0UJ2Ofy7I0gPjAfXlg13?=
 =?iso-8859-15?Q?UTjRtkSi4LpHNibquGkCi23IVyZ1kzcp8zn7zfB3lyaeFb4gWQSIZ7yDs?=
 =?iso-8859-15?Q?sTBnBreGkGJV1LVjrJ7eAs3x3w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab52b175-e49a-492b-42d7-08dafec0965a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 10:40:33.5551 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnptbqNld6Xz5aql/lh/LJ1uB9noRuqNN+9UWdndOVQb+Sua/ESIezytDRF6OuuvYRM61g0DFmfcSwUwVYvltg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8950
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 2/6] libmultipath: make prflag an enum
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
Content-ID: <42AC77AB1542154E85F597422FE132B5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Ben,

On Tue, 2022-12-20 at 17:41 -0600, Benjamin Marzinski wrote:
> In preparation for a future patch, make prflag an enum, and change
> the
> reply of cli_getprstatus() to a string.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

this patch changes ABI. Thus I pushed 730629d [1] to the "queue" branch
[2].

Martin

[1] https://github.com/openSUSE/multipath-tools/commit/730629d604e4ea30f7902fa347d815cd05a60002
[2] https://github.com/openSUSE/multipath-tools/tree/queue


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

