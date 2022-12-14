Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA005C4167B
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 09:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671009689;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VR+x622taO2sogQkau3lxai80DMSbPWbYJPhwBgE4SU=;
	b=f/hR9IgfSscP3IRVM6QSx6PO5WcjRP6kvVcF4satHv7pc0vwEmsnIm+qFsjhu/O8UWjwli
	l/Rxye8D37N3XqYFzZCf1Sk8yhEpFaAtm+FMU3lSH2HjohCD2TlcMO5dxVqsCMGZqv+Uqg
	iwpa3LfD7kNR9FwAt2wRtpTLB18v2tc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-CQI6FwVmMzOqtEiqE7VIfA-1; Wed, 14 Dec 2022 04:21:26 -0500
X-MC-Unique: CQI6FwVmMzOqtEiqE7VIfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B16132A59560;
	Wed, 14 Dec 2022 09:21:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0326400D79E;
	Wed, 14 Dec 2022 09:21:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5683319465B9;
	Wed, 14 Dec 2022 09:21:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03A7F19465B8
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 09:21:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8828400F5A; Wed, 14 Dec 2022 09:21:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A0A0849BB6A
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:21:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 869578588E1
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:21:21 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-0zlPM3mlPWy2NZQlJm424A-1; Wed, 14 Dec 2022 04:21:18 -0500
X-MC-Unique: 0zlPM3mlPWy2NZQlJm424A-1
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com (2603:10a6:102:cf::21)
 by AM9PR04MB7635.eurprd04.prod.outlook.com (2603:10a6:20b:285::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 09:21:15 +0000
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462]) by PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462%4]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 09:21:15 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/3] libmultipath: don't leak memory on invalid strings
Thread-Index: AQHZD0u0j8pWq076sU6zOEX1/UHZ665tHDsA
Date: Wed, 14 Dec 2022 09:21:15 +0000
Message-ID: <b957a5c815b2d4fab7d8ac51aa61642cb877a8b7.camel@suse.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
 <1670974567-8005-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1670974567-8005-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB8047:EE_|AM9PR04MB7635:EE_
x-ms-office365-filtering-correlation-id: cd899cdc-4d9b-4ddd-32c6-08daddb48d16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VrBqT/VJfovtuli1V6Ai9rNYvjiC39/epVk8/I+ZryDJT63fnvNICkh7ITsZdq2EAm8mr592sdUNkIEG39mTZ0hVnx8lw3j7pLGYXP5RS3MfyryDbDpnsoOcZ/BTasMOOJkdSiF+w0c6vU2jhiOhcT0rieMuEVXhieYHCovIztew2JEeyF3YWUYUt6RQm1qjv/fSJRzK+xEgNDchZma/A01AS+vKxOgsJnf+pjxY0+WMyAwt2022sl7URJ2PLYig4B5KP9m9whWUxte+slyxmUvENq/cW4UDPCJ/R+d9fDYQHl1Tu4sBlkrNf1oSwaJ7fkkBGECf9tWNndMhROj2sFG+akLOR1PnxgZXHUtMBExvgvsEZWjDXAX/0bE2ounZJxkmC+VDURm8rRd05h6r++n2t/nt9aZzcfHNNnpTyYIMw3aLsLMTtllIwid/xNFh89x8dVm+FlwSAHM1ZyOAQNEc7Z6KircLJ754VesbJALDn6r7SzuBxMBQxvZw+iqdGr3HfYSYpf2czSe2GUkE11GxnnRYeRMwqLihAaHzd07cYONw697EbJAEiOEhFgjXOiIbmQGenSEU6QM0aIVMWWUYQXgd6nSsfokTTa8YuIbsEssx0hnHEWKuUZUW0ugi72Z//CEFrN8ZUiIsSwbuJ2tGgf9YpqxSir6c++cAGjOOnX7ZoBBbRUCVPxPrlE4DflJCOyoRTdC4za2wkjSG0w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB8047.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(8936002)(38070700005)(41300700001)(36756003)(38100700002)(316002)(91956017)(4326008)(2616005)(76116006)(66946007)(66556008)(8676002)(66446008)(66476007)(64756008)(110136005)(4744005)(44832011)(86362001)(5660300002)(2906002)(4001150100001)(122000001)(186003)(26005)(478600001)(6512007)(6506007)(71200400001)(6486002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?wHKkzZiME1WjXKtyIEIf42T6nTcLchebnd17MI/UT2xvHLmzXy/Uq2dg6?=
 =?iso-8859-15?Q?wVtw/O/KL2YYtOEPZykYEFgaOM6Wvqj36vx1GN67nRQbApR9cKAIx853i?=
 =?iso-8859-15?Q?+8eRywKw8yzZIxpQYs6kvna4fPnR1BYSdAnQK0/m9S9L5g23jmQiqhDh4?=
 =?iso-8859-15?Q?72hTZPggfrfjHWfMqvKwwv99jn+AIX1H0y14a8bfEsstWDJ0jFUeJtg3k?=
 =?iso-8859-15?Q?sxmdcLt4ffdHw2oFCJ5K0c3saSBIR0Hcrs6K/yGsihkfTlbk1bdBOLT8U?=
 =?iso-8859-15?Q?IA4nB6mXKZpKzhXB39uCoNhVJErGir/XXJhl5fw8TwThCOjrhliCCmgnC?=
 =?iso-8859-15?Q?bmUWSvNT0JscLntNnYu0N4kNXcD/s40KK/cnEA7kLXasMubJxdhMaafkQ?=
 =?iso-8859-15?Q?ffr2LojFteZt1t4W+womkB9tMuMkfxcdCx0vwBRrxdQBhz8kj/8f7+fBt?=
 =?iso-8859-15?Q?RHg+yKlWREb8tD39nuxpc3nUWaS9C/rvgTxngD6T7LriEFZNCubY1FUHG?=
 =?iso-8859-15?Q?JH5wZlDawjWDHj4eLCIKiz3tdP4xfAmNeKOR0FwXtIiJ2/Xm3uuwBlbl+?=
 =?iso-8859-15?Q?RV/PvQbaacWiV5yYjX5ztcHYBiDGDZrybCIUXNr7mfHam18l/H6U9XttE?=
 =?iso-8859-15?Q?S41Xt0YAJvxVq3Z/08CGmOkRe7gbljrCImF9mU/IpY6dZRtQj9XhkIcQY?=
 =?iso-8859-15?Q?GRKx3pQLBYe5T/lb+vhPuyqDKSH765NwA80T3bDChPHYyWFNyJH0y9yX3?=
 =?iso-8859-15?Q?BcGPMbCrLSwa6DpY+p+a/rfxMaNdRqG361LYBM/023mkITVRqT6uw+qDf?=
 =?iso-8859-15?Q?Dzz2qLERKLD3N9cdrX8Zbz8bYM3xfUR5c7gI9DMItD5BzaUAbWakPr4w7?=
 =?iso-8859-15?Q?JnX9zQNBQKJkxZLdWrBBSu+gdwMe2rdxGnmFUXE7Kq/KtiIvy00rIJPmT?=
 =?iso-8859-15?Q?VbPHzcY7fTqS8YA65rbpkb5uWkWLkKovmcpCeLaF4CvVJCBITEqDyB3ms?=
 =?iso-8859-15?Q?O0a9lTRrfV61KhaeD2oAE3iEBd39/Cw15uJ0zBKg25g0z4QfTaOoatE63?=
 =?iso-8859-15?Q?V8+58Sbp+rU79vgwDuuQzj+0V2laxTO9Hz922wH0riKCMu/zl86qgLU8R?=
 =?iso-8859-15?Q?HRhu6Sd4jRBpkYix3EQ0ajaGWAXD+oPoeelb4UcBBcX+GNK+lqpZLv79S?=
 =?iso-8859-15?Q?ru6SP9wSvBMwrXuyZoXrOXRODs/zO4dYVtQWFLSErqXfmHLjlmek3kZrh?=
 =?iso-8859-15?Q?uXHTCXhAEAkIPwYds9hqluyAaajAqr4QVN2ilnG7oQvjNYecxSutDKkQQ?=
 =?iso-8859-15?Q?SjNV6VcW9ESD6jQGOSN1ljRxj9oZ0oaXt27MaF9kjok7fd4tl0tfunxQS?=
 =?iso-8859-15?Q?NtlULR9bqNigy4jkwEFOEEyofRll8GrMw50uE1JZucZlCSc6XB4xncUpZ?=
 =?iso-8859-15?Q?uuqlBKbIizU4xKW3MI7mYlClhYRf1ArFLfDXkJ+5g37MOL68buB/7N0/2?=
 =?iso-8859-15?Q?+kXfNnhf4eL+pWZXIRrHaBfTuVLe8LGfHfavhBMyls9kh+UWwE9zpblBr?=
 =?iso-8859-15?Q?VrJNtzgtWgS404+MWCvNQ59tctCUbILz6UX4lMZHN81HfWhG4L6ksW41m?=
 =?iso-8859-15?Q?Xo8WJUxepVy6JSYXT8S9B4xrzdaSPIUoTsNXLDkS1V2yPP0shi3iU9LPo?=
 =?iso-8859-15?Q?MeXFlR1bJpRuTe6hkKnfzXeaKA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB8047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd899cdc-4d9b-4ddd-32c6-08daddb48d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 09:21:15.6771 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hiwn1pdkuZAoWyWtzj5+2/MHDFRBczvJ4C+v5KRoUsYy3M9BhPVqlRf2UhaghgJeEn2Eqk+/6TWr99wLEtRCuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7635
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/3] libmultipath: don't leak memory on
 invalid strings
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F5A96DFF27B2EF4F89CE504CFC96911B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2022-12-13 at 17:36 -0600, Benjamin Marzinski wrote:
> If set_path() or set_str_noslash() are called with a bad value, they
> ignore it and continue to use the old value. But they weren't freeing
> the bad value, causing a memory leak.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

