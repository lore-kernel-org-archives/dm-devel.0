Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7FAC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671010958;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X9n5f+EECdGyhk/UjocQViwkFdaO1pWR1skPfnuFHE0=;
	b=K8AohW1r+sbD9DtOsfqt5O5mVT4XLQzwX4AQztked4AlyO7x14cdW4BdJ0czx+1MZzjTWo
	oFe7vXyVTtHQcfb++3QirydwusPByfV3HevqEtCPeh3q5cp/vGhL7gmlp5nGcLddG2E7bm
	f3a4g2CVVaLqop3pXpmNrN7mUThtS2o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-FiAg6MolMx6xZLG-FE5YhQ-1; Wed, 14 Dec 2022 04:42:34 -0500
X-MC-Unique: FiAg6MolMx6xZLG-FE5YhQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB7EE1C08970;
	Wed, 14 Dec 2022 09:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 675BCC15BA0;
	Wed, 14 Dec 2022 09:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F53B19465BA;
	Wed, 14 Dec 2022 09:42:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1C7B19465B8
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 09:42:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A951A1C4C3; Wed, 14 Dec 2022 09:42:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A63E79A1
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:42:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6680E3C0027D
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:42:05 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04on2071.outbound.protection.outlook.com [40.107.7.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-JcnFNNw2P9W1hhBnCt4nRg-1; Wed, 14 Dec 2022 04:41:54 -0500
X-MC-Unique: JcnFNNw2P9W1hhBnCt4nRg-1
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com (2603:10a6:102:cf::21)
 by VI1PR04MB7005.eurprd04.prod.outlook.com (2603:10a6:803:136::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Wed, 14 Dec
 2022 09:41:51 +0000
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462]) by PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462%4]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 09:41:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/3] libmutipath: validate the argument count of config
 strings
Thread-Index: AQHZD0uzFRqcD4qHUEmFm538JhqxSa5tIfyA
Date: Wed, 14 Dec 2022 09:41:50 +0000
Message-ID: <e4bd27a114e65fc0fcc5b9038d0d216ab9540dd2.camel@suse.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
 <1670974567-8005-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1670974567-8005-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB8047:EE_|VI1PR04MB7005:EE_
x-ms-office365-filtering-correlation-id: 173a1466-b93e-4500-b927-08daddb76d39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1+pOeQZdOuU9M3kXMOho/watMlZRTChLL8wZse9ouGUMGU6JD0aJIn21O6mGtxnZ7fG8hvJyrcxaXxXHcUGq84zK/k2362HjrkqIJk8K1KUtfGcgtp3cmlm0jKqgmjYh8CuJGkxrsNA0sdZFbHBkeCdfFfoE+Ie6aLKc6GTSSPXxi1tHdbhH2Rz+Wnq/kRDrF1aJ6yQ9320m4ziMVZt1i6AAqtm8QkTgOKMUapSnH32TSuXgX5S0c9w5tGmqoKYjnq4hdU4dDdL6u4w2ylpH8e3fgN+f0XB6nTUuOA5LWDeIzhaViIcRDaze+jYTKc9B1mhDkU3DS1kgqQq4GeHmgBchS/l0aqS+fxq9U3zy2Q84xU84gNAKGa6UcGbixHdEyJVgiotqvP7jMStvhlqdZzWoIRDhruFAnW/2RhH7Ix8w4e09Q9u5R3HiN+9gIKOydVn4BgGq/ZU5tz5uyvHYGEXvDOnGKAodD1FPnXgwMHK0fkw1yrZZgW20kFjZJBC4l5Q26vG8/7mC3oHxkwU7sqFpFa0SDrP3/RXbgD3Y0Z4kP8cWux32e7e8EVWpyPn+iazZvNf9k14QBQQnuNJsU3Eh2ZakesZLeXzbvOmU25rEnIrOZVYj1HEQcq4t3kvxHUhHKn3Xy3mgW0hyJyXxNjhTT16PrDTzFufSHMEWbO9EI87Ju6I1MaXYOrwF+BcfOYDSWEEO8MAEbS5ZM/0fdQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB8047.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(8936002)(76116006)(91956017)(36756003)(86362001)(5660300002)(41300700001)(44832011)(66946007)(64756008)(66446008)(66556008)(66476007)(186003)(8676002)(2616005)(110136005)(26005)(83380400001)(6512007)(6506007)(122000001)(38070700005)(4326008)(71200400001)(316002)(38100700002)(6486002)(478600001)(2906002)(4001150100001)(15650500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?1+4KWZFCZtcVylDZcYjS90EAUNzyDmBQxhb2dPliCWa3+g7ODSzrk8DY/?=
 =?iso-8859-15?Q?qO255mVBFRrssn0AnVLY8o3rSiw4OJtwVTQRiJZL3SR5ZENnfz8wgrS6q?=
 =?iso-8859-15?Q?fQsn3GTuIoQ+NeEgsMjSOrDch6oFniSbE3oZy1hDEPxHSUkqNkGpVtVBG?=
 =?iso-8859-15?Q?8M3p2rL/0eD7gEp2jNwVQE7ud7bS/2+5nnECpm9fAGfho723cWHt2ew8+?=
 =?iso-8859-15?Q?bDDuwKPf5VgyMBQqp9cFba91hjQh1ASUu2/Fbd+SL9kGojZdZwqsHNksG?=
 =?iso-8859-15?Q?Sy0BO6pTeJfPbL0dBgxBUqQNMwyOSMz8uIregJVCktpkNTyA0p0feqGiX?=
 =?iso-8859-15?Q?XAP9uz0iDeh5RCwzDvmrblnjgq6IluwLebikyPaeZECYsKBMwxX5qIjXm?=
 =?iso-8859-15?Q?sK0aKc9XZpoNJFGtyvPnIjgh05dlIII6ihCqShYpIpLTUk8P0EZsjKwB+?=
 =?iso-8859-15?Q?k02hLzJ5+hF9CFYImALNfP6FibI0Ki+2EArRJId9nwLtcZn1l0be4Uo3w?=
 =?iso-8859-15?Q?D4VmqQDX3MHHSYPA5rmMk+Irbvnb2SZaZIKToYtA/vGJ9m/KHhqPw1Oj1?=
 =?iso-8859-15?Q?qWqO1T1T3Tm2PhLPBmIobHH/z8lAwC7BrGHcbx3r7QsQ4se4yGD21YATe?=
 =?iso-8859-15?Q?DDBp5CWLsl7dJPEd64CocalCTE4CSFBWTcIvGugH0f9Z5q+2KSnkFlFZw?=
 =?iso-8859-15?Q?fWFyj1p3AMqQHF97QESmVRNOemj6OF6+JOyUj/thfiKV+2GOxAuloWAwA?=
 =?iso-8859-15?Q?9umdW9r2wqcyJisSo1fLPedcTKb4aJuZp3njJrjD57cEwMYXmvqcHKHCk?=
 =?iso-8859-15?Q?PnFOdcumLrgvtLrR1zk4LQf4TE1NzTaX8mJHvVS1eGkvDvGkA6OPt0nRo?=
 =?iso-8859-15?Q?/G5fMv4DhLkMGpNdsY8f1qJgPpmnolcEa9/0ohErKMCXAr4GZC1PHT6zs?=
 =?iso-8859-15?Q?Rc0pycwW55ftcyUDmJFVC+eszno8vmjI3dATQPtFB7U7Srxvm7cExobog?=
 =?iso-8859-15?Q?UXAJEStllaoC2LAkeNd3OC1ryz6/nIk5xWakwZTZq46k0anCgPd5M/qlw?=
 =?iso-8859-15?Q?bGTvo2O3X1x7/CXDcb1U5MpNl4J2IsEALedbFuYthJkS68fF6S2Mxxq8X?=
 =?iso-8859-15?Q?D5H37t+gNOxgOItun7x4xllG2ogYlOhKkbTGHGtyCgA8Cj0tCGRkueFAU?=
 =?iso-8859-15?Q?svRc8ERU3X8fnFL5ai5XyV+coAUS4AOkZIL63IxY11pfigHcUKPWJZ8hg?=
 =?iso-8859-15?Q?kbSuP2olY3YYm9L8zHF+14wK6E1zZuMPa4rf5Jl4PBwafUT+aCxjFTXL4?=
 =?iso-8859-15?Q?w29jucc79xfG7GbbyHlgt3U8tcnkwXhYJVh/21tpKyl57RZ2q82CfV+iF?=
 =?iso-8859-15?Q?3ioVxSrjUwne8gVHSR+9Ts98TZYmt0IBoGHIktIQvnEZw+IeblUJKsiKV?=
 =?iso-8859-15?Q?owgvSIj5+SSd2wRcjkWKZ4eqjQQJidOxwEIOLSKVCZdYqIzWp3JN/4u0L?=
 =?iso-8859-15?Q?WBkvd0fqIvu/pIfDdDtKpfDfsNnWYChtQzQSyfe90Nzt94BV/kjnMGvqa?=
 =?iso-8859-15?Q?gNrGW4Q1+fRmzSWzrfjk2k2v4hw/4RMVdMLJrDQsL4qKbi8uzb+nce2BI?=
 =?iso-8859-15?Q?C70/Q5Fw2ysMuOkptS0i9p659xVC9PG6kZXbRjh2+urhJ/e5JWE8ObMwy?=
 =?iso-8859-15?Q?sqQUxRiFJlzB3MCngXYub+o4tg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB8047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173a1466-b93e-4500-b927-08daddb76d39
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 09:41:50.7443 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/DZoovf16aJY+6NfTTb15vK4v+q3JlJyzNcl4IKfmf8L3vBd5F8uKHqlAdpTymyjaAjJWbHJjZ70Ty7hia4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7005
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 3/3] libmutipath: validate the argument count
 of config strings
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1E723044AFCDC445AEA0B0D600C8498D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-12-13 at 17:36 -0600, Benjamin Marzinski wrote:
> The features, path_selector, and hardware_handler config options pass
> their strings directly into the kernel.=A0 If users omit the argument
> counts from these strings, or use the wrong value, the kernel's table
> parsing gets completely messed up, and the error messages it prints
> don't reflect what actully went wrong. To avoid messing up the
> kernel table parsing, verify that these strings correctly set the
> argument count to the number of arguments they have.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/dict.c | 110 ++++++++++++++++++++++++++++++++++++++++--
> --
> =A01 file changed, 101 insertions(+), 9 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index f4233882..6645de49 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -116,6 +116,58 @@ set_str(vector strvec, void *ptr, const char
> *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +static int
> +set_arg_str(vector strvec, void *ptr, int count_idx, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> +=A0=A0=A0=A0=A0=A0=A0const char *spaces =3D " \f\n\r\t\v";

Nit: I believe '\n' can't occur in values passed from multipath.conf,
as we don't support multi-line values. Also, should this be "static
const=A0char * const spaces", maybe?

Other than that, this looks good to me.

Regards,
Martin



> +=A0=A0=A0=A0=A0=A0=A0char *p, *end;
> +=A0=A0=A0=A0=A0=A0=A0int idx =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0long int count =3D -1;
> +
> +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0p =3D *str_ptr;
> +=A0=A0=A0=A0=A0=A0=A0while (*p !=3D '\0') {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D strspn(p, spaces);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (*p =3D=3D '\0')
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0idx +=3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (idx =3D=3D count_idx) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err=
no =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cou=
nt =3D strtol(p, &end, 10);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(errno =3D=3D ERANGE || end =3D=3D p ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 !(isspace(*end) || *end =3D=3D '\0')) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0count =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D strcspn(p, spaces);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (count < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, mis=
sing argument count for
> %s",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, (char*)VECTOR_SLOT(strvec,
> 0));
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (count !=3D idx - count_idx) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid argument count for
> %s:, got '%ld' expected '%d'",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> count,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0idx=
 - count_idx);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +fail:
> +=A0=A0=A0=A0=A0=A0=A0free(*str_ptr);
> +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> =A0static int
> =A0set_path(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> @@ -288,6 +340,14 @@ def_ ## option ## _handler (struct config *conf,
> vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0 \
> =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &conf->option, minval, max=
val, file,
> line_nr); \
> =A0}
> =A0
> +#define declare_def_arg_str_handler(option,
> count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +def_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &conf->option, count_idx=
, file,
> line_nr); \
> +}
> +
> =A0#define declare_def_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0snprint_def_ ## option (struct config *conf, struct strbuf
> *buff,=A0=A0=A0=A0=A0=A0\
> @@ -340,6 +400,17 @@ hw_ ## option ## _handler (struct config *conf,
> vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &hwe->option, minval, maxv=
al, file,
> line_nr); \
> =A0}
> =A0
> +#define declare_hw_arg_str_handler(option,
> count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +hw_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf-
> >hwtable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if
> (!hwe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &hwe->option, count_idx,=
 file,
> line_nr); \
> +}
> +
> =A0
> =A0#define declare_hw_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -371,6 +442,16 @@ ovr_ ## option ## _handler (struct config *conf,
> vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 file, =
line_nr); \
> =A0}
> =A0
> +#define declare_ovr_arg_str_handler(option,
> count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +ovr_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if (!conf-
> >overrides)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &conf->overrides->option=
,
> count_idx, file, line_nr); \
> +}
> +
> =A0#define declare_ovr_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0snprint_ovr_ ## option (struct config *conf, struct strbuf
> *buff,=A0=A0=A0=A0=A0=A0\
> @@ -401,6 +482,17 @@ mp_ ## option ## _handler (struct config *conf,
> vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &mpe->option, minval, maxv=
al, file,
> line_nr); \
> =A0}
> =A0
> +#define declare_mp_arg_str_handler(option,
> count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +mp_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if
> (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &mpe->option, count_idx,=
 file,
> line_nr); \
> +}
> +
> =A0#define declare_mp_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0snprint_mp_ ## option (struct config *conf, struct strbuf
> *buff,=A0=A0=A0=A0=A0=A0=A0\
> @@ -584,13 +676,13 @@ snprint_def_marginal_pathgroups(struct config
> *conf, struct strbuf *buff,
> =A0}
> =A0
> =A0
> -declare_def_handler(selector, set_str)
> +declare_def_arg_str_handler(selector, 1)
> =A0declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
> -declare_hw_handler(selector, set_str)
> +declare_hw_arg_str_handler(selector, 1)
> =A0declare_hw_snprint(selector, print_str)
> -declare_ovr_handler(selector, set_str)
> +declare_ovr_arg_str_handler(selector, 1)
> =A0declare_ovr_snprint(selector, print_str)
> -declare_mp_handler(selector, set_str)
> +declare_mp_arg_str_handler(selector, 1)
> =A0declare_mp_snprint(selector, print_str)
> =A0
> =A0static int snprint_uid_attrs(struct config *conf, struct strbuf
> *buff,
> @@ -663,13 +755,13 @@ declare_hw_snprint(prio_args, print_str)
> =A0declare_mp_handler(prio_args, set_str)
> =A0declare_mp_snprint(prio_args, print_str)
> =A0
> -declare_def_handler(features, set_str)
> +declare_def_arg_str_handler(features, 0)
> =A0declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
> -declare_ovr_handler(features, set_str)
> +declare_ovr_arg_str_handler(features, 0)
> =A0declare_ovr_snprint(features, print_str)
> -declare_hw_handler(features, set_str)
> +declare_hw_arg_str_handler(features, 0)
> =A0declare_hw_snprint(features, print_str)
> -declare_mp_handler(features, set_str)
> +declare_mp_arg_str_handler(features, 0)
> =A0declare_mp_snprint(features, print_str)
> =A0
> =A0declare_def_handler(checker_name, set_str)
> @@ -1821,7 +1913,7 @@ declare_hw_snprint(revision, print_str)
> =A0declare_hw_handler(bl_product, set_str)
> =A0declare_hw_snprint(bl_product, print_str)
> =A0
> -declare_hw_handler(hwhandler, set_str)
> +declare_hw_arg_str_handler(hwhandler, 0)
> =A0declare_hw_snprint(hwhandler, print_str)
> =A0
> =A0/*



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

