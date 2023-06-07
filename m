Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC09C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686163005;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AZWan8wtaPZW1JHP3VszmKRMDEdV6Hlrwm+dxOPihzc=;
	b=LKWroEeHjsAnlelnfj09fkwlTxyp9x5YDhBB6rmKtdg9TKmI0hq8GyqawibtoY2a9PkA7/
	op2qpqrBBFOmqqfScb9y1Os8oXImAEu5blHjLYEPTWPJq8uaRHiV6fU0+RQGJfci1YaxKU
	6AfzAy213eU3u0/CMrBC5x5o0X+XweE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-swDg2rBCMICUWqnd1XYvKg-1; Wed, 07 Jun 2023 14:36:44 -0400
X-MC-Unique: swDg2rBCMICUWqnd1XYvKg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD5EC185A79B;
	Wed,  7 Jun 2023 18:36:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 827F540218C;
	Wed,  7 Jun 2023 18:36:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43D3C19452C3;
	Wed,  7 Jun 2023 18:36:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8037419465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:36:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60213C16044; Wed,  7 Jun 2023 18:36:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5744BC1603B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:36:40 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B9042801583
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:36:40 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-3Ovqwku0N5a4TeEaEN-_rg-1; Wed, 07 Jun 2023 14:36:37 -0400
X-MC-Unique: 3Ovqwku0N5a4TeEaEN-_rg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DUZPR04MB9967.eurprd04.prod.outlook.com (2603:10a6:10:4dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:36:33 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:36:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 05/11] libmultipath: add "detect_pgpolicy" config
 option
Thread-Index: AQHZmLNbJ6rt8GE/gUWwQnnX579z969/rI8A
Date: Wed, 7 Jun 2023 18:36:33 +0000
Message-ID: <013f866d962bd5f9a30369f0a4574a7ec034f914.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DUZPR04MB9967:EE_
x-ms-office365-filtering-correlation-id: 93c47425-b47c-47ee-d1e3-08db67861e52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pLjjxMa3i8IReoB9/YVMz93U+bkBwFutMrSBTYjgk4rpb3hlunRKB9NbP39F//95efrXkL+0dUU9zhcHLP0tU2iUQIcMtIq+2A2azVVWlDQgOXi87t78Y8bWlPl9x4BE46ZWb78aTUxrfz85G7LPBEL9yFwZIqVHcwGIftilw75/wmOuVTqS55PN0x8CnLm5dKng/TKe134f58vq9Qt7UiBgrBpbQbu73X2nO9uZBQHOP6ryNIwXcvlXVXbGf/p93hXtV1r7S+PJ20onTKjJs3cQPSEObsxpeLF4KdzLjIuE6qBwJZ0uc5F3AukU1Uml0+UqApi5svNr6zT+ZHwYT6+fcpvYbo+b6Yu0Et7BAl8BnGGnCnE08O3pG6f/sgJb9+dW6LtO/lDY8GQZD0I+J87QU++YEq310dhUS8TV6PuOnBdqbN/AtOfY1cUfex2aipCPYnk/cTiZq0+5h46/iDXACBml3GwJdy6WQ/wZOZizbo35XLkqB+lp3HXbHkXEwGssUgrbFuzeGTNCqr7dq0IFp54ma3uLXF+qtQvRRAd0avimUhDYk6j/ChPdzAS7tADnp8SqCvSRI0MaGZ8NZacEP7q5lqiKOzY6dwl6JHy0nm3IAdCrfpA/2XxknFK4
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199021)(36756003)(86362001)(2906002)(38070700005)(44832011)(558084003)(5660300002)(66476007)(6486002)(6506007)(6512007)(26005)(186003)(478600001)(91956017)(83380400001)(71200400001)(110136005)(66556008)(76116006)(66446008)(38100700002)(66946007)(2616005)(4326008)(122000001)(316002)(64756008)(41300700001)(8676002)(8936002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?mRdtAdyC1g3WIdhzL7/sMZG6pIm/AJbiwSJugcznH0JMKzOp0sDIicLs9?=
 =?iso-8859-15?Q?WOf9ZtAFiHfZVUSKLN/unRgi58KvDgsOyeyvseYpYxbwvv98N5MR/YKIu?=
 =?iso-8859-15?Q?cEVylSC0cXBwRy2KzBbdOFKay1UoyFSNfGyViWeCJSp6PrxvvsVW6RB2M?=
 =?iso-8859-15?Q?dylhXl5DyRjczkLXl5WFzNRDh2PcZfJ4zzLUSGPK6maGXQQ/fcRNThdiG?=
 =?iso-8859-15?Q?7sB8uZejLBuQRyBDoQfIab4Y8edyZBDHRf8c8/CJZYXpBvpQbydt7ljXA?=
 =?iso-8859-15?Q?b790au+YDzBunE8hzFHqd4nns8jirEeqcW8UeVUAe4blOJdFiqNqdUEf/?=
 =?iso-8859-15?Q?wZJw8mN4C5w8ZCsNSd/UkO9H4X8xLr0YayaXb2x7oN2chNMZj3h9K5GIB?=
 =?iso-8859-15?Q?ZUjbKN8FBhMmP7Ezi9w4gU+OsQgdO2Mushmi2nzV9mXu673nYTcd5sme/?=
 =?iso-8859-15?Q?zhXzv7IJBlNfAWNoXjqex81eVHR8DSeMy1lVzaHjCOkEjUQ2Wf7ifdCCb?=
 =?iso-8859-15?Q?x9DmURBM7wR+BE1mW1gmxM0LwOf+ISGCv7a8SREqN7r6CdLCv/1YYMDdn?=
 =?iso-8859-15?Q?omjs/0tvyfvxUcJmk7NARapVwCGp0rQFU18ElygWx28JzuVui4LFZ7ujX?=
 =?iso-8859-15?Q?ccAujW7Dz3YjIo8AYn40vq5vTpZINRSKzpF7etj2ejuExnnht75NDaHq1?=
 =?iso-8859-15?Q?zJvw5FPeUll2X9CVQdg48vdNX4fCdKCrwlktV6GvLY4a0bktNfSVtIwQo?=
 =?iso-8859-15?Q?/gTN6mvQr90xn4peOhJ5NzqLrvhXisvqQzglBhlXmRTenC4ultldMbFzh?=
 =?iso-8859-15?Q?/1OsP8wArHz9tuvMNO/RIsQqWxfatQ7FKw6bOnpaMLbmfBTSWpXqd1WtD?=
 =?iso-8859-15?Q?yfa1JIERLLd/eox5f2k4SApvVyiL8DgjbWFEGtrQtXj30JlijblVsuSC6?=
 =?iso-8859-15?Q?ght8m+N9U5UyFsl4OWQGk077U+G2lKwu4/ZFn33UxAZ3xOdjalcOkcyW+?=
 =?iso-8859-15?Q?aA6q1NIXFksaZG8MbTMHPyuL4vslXhvIh2IQJI43ni+19CdMxrinYpQyF?=
 =?iso-8859-15?Q?PGTn5bAPsjVmxlSsXv2mZyXSeTAJ+QNwsjDrLeq6eah7dzzNmWn3gJbp3?=
 =?iso-8859-15?Q?mshok042l0ojvSWNDyj//u93kjWJu3IsD5HohzwdhfNBIdzTQSP3Q29Sw?=
 =?iso-8859-15?Q?WiyEoitRY7gErhVcQ07sgXTV95rKHV2/nZ3PeYfoDWG8cSTVyv7k6l8tF?=
 =?iso-8859-15?Q?sGOBd6SL0L00W/JDHuLP3dQ1kTwuJS3ESvyVF7WN/5ycU2O3gLdIqeyX/?=
 =?iso-8859-15?Q?pJG2LwH180X5Of73bU8/F/fpXtXlQV9VhL2NWiGm7LLmtf5UKavU2vtAY?=
 =?iso-8859-15?Q?pD9S2p4GcMJeAfzkao9d1Zxq+v5t5xmqjZ/P7dJFkgpgsKdy9lwlo+k/0?=
 =?iso-8859-15?Q?u4+CNx8wC6q6aVOZdgFTbV11rehqzX2Yy4ppqUw/T8c6UOoxK/UPhfhY1?=
 =?iso-8859-15?Q?1TJxOZMwXX17reoVa83Bl8ALKkaSV4UNgKS7Ul34LzhutVuKEBWTAFdPF?=
 =?iso-8859-15?Q?FjPP+6Qt3Z+6K9W0ZR9VBFBBHC0FmHFZKl0wmS0TqmyrFMWgp/Dk7VB84?=
 =?iso-8859-15?Q?juzke19Iq1gq68qRJQ2R6j61FriPFgAFQvWdluEiAfu/4UXkAMGiS4O3/?=
 =?iso-8859-15?Q?SUrQ?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c47425-b47c-47ee-d1e3-08db67861e52
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:36:33.5064 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uBNNnD19Gr98eEGqvZEPFziPgkv8dDi0QtqukzZ28SYFVjgjGtseJ56qS7h8e0YU0ge+NHvXCvte4WjvmOcCGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9967
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH V2 05/11] libmultipath: add "detect_pgpolicy"
 config option
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
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <609009EB6C57BB48949D29FE448028FD@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> This allows configuations to use "group_by_prio" if alua is
> autodetected
> and another policy if it isn't, so they can work with detect_prio.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

