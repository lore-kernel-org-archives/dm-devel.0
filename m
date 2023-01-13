Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C0CC54EBE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 08:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673599976;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H9MaaNyeHth7fXgoHfr+w1tYP+nim5MPpdILclTppkM=;
	b=CV/7IEXdk6YwYzU0mV4KSwWUL5qenO0o9geVwLfhZDG4p8A6SohpHBACLF7i28nZ8jjtFz
	Ua5NG4BbYvYIbLPy47s9DjzAHddCjJKKIOr1TPwEfZvi75FwU440WUsgHmxIg4hPsL+Vhp
	F9eQho2y2/DmejdwqNKhHzHHwHbFJ2c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-PeFKgP4AMJahZFeRXliJYA-1; Fri, 13 Jan 2023 03:52:53 -0500
X-MC-Unique: PeFKgP4AMJahZFeRXliJYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83DAC3C0254D;
	Fri, 13 Jan 2023 08:52:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 199521415308;
	Fri, 13 Jan 2023 08:52:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF3491947050;
	Fri, 13 Jan 2023 08:52:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE79B1946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 08:52:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3DEC1121315; Fri, 13 Jan 2023 08:52:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB7641121314
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 08:52:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89D7D101A521
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 08:52:47 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2049.outbound.protection.outlook.com [40.107.15.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-hplQrI_KM5W9jAr0arxBjw-1; Fri, 13 Jan 2023 03:52:43 -0500
X-MC-Unique: hplQrI_KM5W9jAr0arxBjw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 08:52:40 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%4]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 08:52:40 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/2] multipathd: Add format options to multipathd man page
Thread-Index: AQHZJsSAMzoztRQRkUKYwQ/ztz0A566cCz6A
Date: Fri, 13 Jan 2023 08:52:40 +0000
Message-ID: <0ce9d087cc48ed97f2cee1a5c48c0149d5728332.camel@suse.com>
References: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
 <1673555329-9850-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1673555329-9850-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8204:EE_
x-ms-office365-filtering-correlation-id: d418a13e-60a8-4fb7-702d-08daf543872a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KrimO4kPXhWPOcyy8nNQRGkAMiAN3Nglaf5uFqpcnURDscg1f1lfXbKHZ5+DeGp81WC43NjAbFnxlx7IMRN+gUmL/2fL46W2lAUmJltuagu0ENH9fHeilftsnSWvKJFHRj6jqmIWp8BynAuW4gawvxfCflfoUQr4ub67YvRntyAKMBun/a2rhi5kXDwRPRsLEgZOOTs0VUB1PvITuP7nXIhVoMbHJhpuP91A+P+uk/yXrtFxtDo5Bs7EUY4LXuaig04ZDB870kKDBKDs/aFT73LV31VNiLo6LZQ2p5Zn8K30kmJ6c8c3K77UZyHZtqDWFjcQGjEc1fLj9wRAAxbK0KxwKkcm7QPf/FTNzUWfzvbQ6hRtge+OkOtALUSL8hXt+15Jdi2igU+/YWzsP1AlkzMhziMei3SZZmdTaiMN9g4X50iSo+s9Y8zEDo/XBSrD6f895u3ZdPx9cBSDbVRAytqGsbM8Kw1THAEuaIt4TJHQ4wdRdmiikgBNehU2x7M8POhwj1BpvMjQr9i+RGqkFWy2Oj/Ghg5dshtyTOublu4LE4ltk7OMtvOJOsiNjmnvuBoXCgUB8qFrA2tN4kkdorv8q8JU+xAs6qSypfhSUzt2ulOS00SSwtyklgBTvoyCq/hSc10wzP0Ra1XQ2AWBGq0TSCXWZ+8WEJtspPjFmzti3IeOYLvhIB9iR+qSWxzHrBIO827WiO6YL0SHv0DBng==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(38070700005)(6486002)(478600001)(41300700001)(6512007)(38100700002)(71200400001)(86362001)(316002)(110136005)(54906003)(2616005)(91956017)(66556008)(66946007)(26005)(186003)(76116006)(66476007)(36756003)(5660300002)(6506007)(2906002)(44832011)(8676002)(66446008)(64756008)(4326008)(83380400001)(8936002)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?4VNv1jRaEJTa5GWxR2zYBKT07sz0gjbDVV4ie2jptYOVzccZzJyI3cuT4?=
 =?iso-8859-15?Q?eSaUYVy8XaTkSY1GesaadwuctKw3nAJ6wddk19/R4MsQLzcUAxv/Fd3iw?=
 =?iso-8859-15?Q?ITAdPllPa9CIa3I2ZStcZfOtQUbWfxX91H5mZKsEsCNE7QxU+68hozD6t?=
 =?iso-8859-15?Q?+dEvuMAobFAXDai8/C6lht71qxGf52S8+/A4kQoDE50tLEiDvHIur10kY?=
 =?iso-8859-15?Q?Uu+xUrp+fWVHZRrek+dYksGaknKRhcRLeXlsVC6PqqletZf/W2nkHBxIb?=
 =?iso-8859-15?Q?jI17AhDFT2z0LiR0rijxF56FZD19mUYloZP4iRsjl3iIPYeSCxGn1n0TJ?=
 =?iso-8859-15?Q?Ug8Npd3uEPF2DLd2pwuXheahaRGQbVEM12RR08xqXW3BdcXj97NmslEQA?=
 =?iso-8859-15?Q?HQcnsSmOs9ZILpN2kRD1IF3Nm16PetzR1h28lZYuxv893cOLIEGPnWw9d?=
 =?iso-8859-15?Q?hg4PqfXJKXDW0LJGULM3aea53PIDwGDkhmkTO2fegvSQgD1BoPxH8gUJ7?=
 =?iso-8859-15?Q?0jYnGxax6w9ZyoD0RMSULqKLu868HdbTqSPuJf5a+8B+COe9uQynUtPWk?=
 =?iso-8859-15?Q?RMW9Id2qRYDZgZOxSFMxtzNrAd2juE9ZOOSpy2kJCbiYjjnLEEMlwS2Fk?=
 =?iso-8859-15?Q?mV1WG8tt50pJtIKuuYTDtZzamYepVN2arEbDB/SjQCb4bIzqHTdfL58Sq?=
 =?iso-8859-15?Q?0a/XK9EQZz6uNgH32flb+YwDqDyLgmyqyTT71zM6VhKSypnz+Git4MraN?=
 =?iso-8859-15?Q?Q5HjxSeB7W1FB245hXdhNAR+Wz2QtVXSHCA8ksuN+xweMk4SJ1BN66Go+?=
 =?iso-8859-15?Q?Fg7IIVLjsZVDpNkfBCesdkf3jilAQn9Ovb/Q67fuB3Zd4+HC0AF3130x9?=
 =?iso-8859-15?Q?XlnahwC+Zjy7BxF8/SdFyS95Tw9N/t6BcoXydXJ272ygDtNJtpe8mMJ8i?=
 =?iso-8859-15?Q?DHXWCymQemN70g0GQUnvzW3OCGTrOZb2KxuB0tJHFThRzmc6YOHZkZwfu?=
 =?iso-8859-15?Q?pJAoVl2b2PcLUO3T7JM2JXiK4DrnYkQ82aKXxIQXI7UJ2otDLZxfMaR4R?=
 =?iso-8859-15?Q?D/oNmpALSRJfZrJdcG/3FFRzefEdwgexAHYDDlZIIqPtZVJjr0LcGZu9z?=
 =?iso-8859-15?Q?Ygh5AZtTkcemlOno0IiJTKEmtoA6F5Vu2zAuOFBOwXLQBrv2W6HPTk+K1?=
 =?iso-8859-15?Q?VDL+ZrIRVEdYSu/pnQxHvp/2b0fnWsEFuF8zyK7dSzgLnsdOLDlP5I7I0?=
 =?iso-8859-15?Q?HW4RFDjjo+Wf9mL0JJmqyIgE92HxrOBxkvUx1qpCwKDBwpYz+Eo5lMF1V?=
 =?iso-8859-15?Q?Hufq4FTy9GYWijzk2FCqF6GIsqzUL9UscsOlwThPNRpWZ7/qZG8xr19fi?=
 =?iso-8859-15?Q?6ggpj9UB0gVoEZGcMeSheFXsxAEfuJoToeCi7OInDEj+XCqF7mfMEjT1t?=
 =?iso-8859-15?Q?RmgmrMfU5BAJPBveLPdksewj+onQiAhJgyRPp0hGkAK6ez33+hUGl7d/0?=
 =?iso-8859-15?Q?Hbn1e+4tjAaa80rz4mqwcN0lGhjOa3r9G+zi/GB3PEFlENyb+URtuQlEK?=
 =?iso-8859-15?Q?FCgv4aaAgencSXUrj8NR4xRqIMXNDG98ihAbWaYf98QZLDKqJYSQd8YUD?=
 =?iso-8859-15?Q?iXotoprkj3ZDDKxMPdrSXWrVI6lw687vImSlScMrgwgAY66rpBpKi50p5?=
 =?iso-8859-15?Q?H/8P/X8eJJqAZLLia36lPnz1AA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d418a13e-60a8-4fb7-702d-08daf543872a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 08:52:40.5353 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vv9hRnMYruZ66HRd3yfxhbBTpZXEgn6ZBoOmgHwSXI0HuzbvTr2d81eXufauMQjrjv8uKL32GcsbRkmmfuuxbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 1/2] multipathd: Add format options to
 multipathd man page
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nyewale@redhat.com" <nyewale@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E1692ACEAC4BB645868FC7590C4FE8A0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-01-12 at 14:28 -0600, Benjamin Marzinski wrote:
> From: Nitin Yewale <nyewale@redhat.com>
>=20
> Move "multipathd show wildcards" command above the $format commands
> and
> also add $format options for "map" and "path" commands to the
> multipathd
> man page.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/multipathd.8 | 16 ++++++++++++----
> =A01 file changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> index bdf102eb..95d475da 100644
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -113,9 +113,17 @@ The following commands can be used in
> interactive mode:
> =A0Show the paths that multipathd is monitoring, and their state.
> =A0.
> =A0.TP
> +.B list|show wildcards
> +Show the format wildcards used in interactive commands taking
> $format.
> +.
> +.TP
> =A0.B list|show paths format $format
> =A0Show the paths that multipathd is monitoring, using a format string
> with path
> =A0format wildcards.
> +
> +path format wildcards:
> +
> +%w (uuid), %i (hcil), %d (dev), %D (dev_t), %t (dm_st), %o (dev_st),
> %T (chk_st), %s (vend/prod/rev), %c (checker), %C (next_check), %p
> (pri), %S (size), %z (serial), %M (marginal_st), %m (multipath), %N
> (host WWNN), %n (target WWNN), %R (host WWPN), %r (target WWPN), %a
> (host adapter), %G (foreign), %g (vpd page data), %0 (failures), %P
> (protocol)
> =A0.

If we do this in the first place, we should explain it better. Terms
like "dm_st" need explanation. The explanation would grow into a longer
paragraph, which should be moved to the bottom of the man page with a
cross reference here.

> =A0.TP
> =A0.B list|show maps|multipaths
> @@ -125,6 +133,10 @@ Show the multipath devices that the multipathd
> is monitoring.
> =A0.B list|show maps|multipaths format $format
> =A0Show the status of all multipath devices that the multipathd is
> monitoring,
> =A0using a format string with multipath format wildcards.
> +
> +multipath format wildcards:
> +
> +%n (name), %w (uuid), %d (sysfs), %F (failback), %Q (queueing), %N
> (no. of paths), %r (write_prot), %t (dm-st), %S (size), %f
> (features), %x (failures), %h (hwhandler), %A (action), %0
> (path_faults), %1 (switch_grp), %2 (map_loads), %3 (total_q_time), %4
> (q_timeouts), %s (vend/prod/rev), %v (vend), %p (prod), %e (rev), %G
> (foreign), %g (vpd page data)

Same comment as above.

Martin

> =A0.
> =A0.TP
> =A0.B list|show maps|multipaths status
> @@ -148,10 +160,6 @@ Show topology of a single multipath device
> specified by $map, for example
> =A036005076303ffc56200000000000010aa. This map could be obtained from
> '\fIlist maps\fR'.
> =A0.
> =A0.TP
> -.B list|show wildcards
> -Show the format wildcards used in interactive commands taking
> $format.
> -.
> -.TP
> =A0.B list|show config
> =A0Show the currently used configuration, derived from default values
> and values
> =A0specified within the configuration file \fI/etc/multipath.conf\fR.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

