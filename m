Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2079.outbound.protection.outlook.com [40.107.105.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E73208A8
	for <dm-devel@lists.linux.dev>; Mon, 13 Nov 2023 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="wdSPULD9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMKGx5uFYQijNMHlOXsjZWbHk+bFyUtEHv/xRRz14znT6gRH089phJkjtl6p8hRkqJDThzLaOlJwK5dJOX1MWg0aIbmybtiwyDIEPROl9uCtsghzRsD8eo/movAXUYOycQH1aZIxtq9S4v+585BsIglNORy3nHfhM9J+byyMCjrlctbNlXkmeeHxc3VJz5reEajLrnTZjxZRkCiJsC6M0+ASrGBUqxsyane3m6YOtWDY1H9b0fZ72SsmTl2oHnqyphPNQGqaRXvQxN1cPxokVInPRmgcssiTaTJO0bOvSDdyqyAXqy49dAg0EpXZ/ATNzrAUhsDBHVWJEXXfOuTXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vgxt/Vy2CumXF9vox/5cD8SNd+YNG0DjoTRwedYBlHM=;
 b=eyL9jYiWsUy1UDpgk5bINQYCsXx5qXrsZu0gc+iqKtatSHNbFbE33QcNSnOJWNA3RnZz+hsUttEYQRmTDlSB+5s28CdFnXba2g5iijKd+Ad95m5imcQOVbDqdZC2jAq9LPLrnmqBVCr8aUEGnkEGbjPcrKtaCA3dh8xNs/Y2BHIu1JOkXcY9rJzjJGAot17qm8XJ0+Eb2WI0eRgt6tDtEWhGjVT2VbxGky+JVPzs391KcodOw+IakPzjeLrbYZ/vdmKlrQijxUC0IHctHcoXPYjBjB+DiL8PsWdbSTTUilYJ9S6J9kGmiGs2BgXPq6wCoSeDZkVtxj/Od0SciLGB1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vgxt/Vy2CumXF9vox/5cD8SNd+YNG0DjoTRwedYBlHM=;
 b=wdSPULD9tMyLU4d9tmPwdSfACIwa7XCAtUbn02LSvK5AFjq2RS7QrphMKZCbeAY/jANCBLgR6XqlTIlMwm4tugtszC61QjH0g9HPnmvHarvrnYOVHy4bPUv+I8OLA4K6vG6mkdMvKUehOHv8J+ELpHSg/1Qo/xUNIiK1Ym5F1x3Pkrpfw8mOffGKZu677KmxkmHD41FiJ171pNBdL2QZaWZxWzF4ErqjhCL66SCg718wBZlsX0R0E8xxLA9e9QA2Als+ssCco9SUx8aWKHxPc8LhcIWFA92I0uhb1I/2mcfrbp4jKYKkE9u+5gjUEkax79xOE9iB+n79QSriOhoRJw==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by GVXPR04MB9901.eurprd04.prod.outlook.com (2603:10a6:150:113::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.14; Mon, 13 Nov
 2023 13:52:28 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::5c82:3111:897d:74ab]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::5c82:3111:897d:74ab%6]) with mapi id 15.20.7002.015; Mon, 13 Nov 2023
 13:52:28 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/2] Makefile.inc: always use /usr/share/man for mandir
Thread-Topic: [PATCH 1/2] Makefile.inc: always use /usr/share/man for mandir
Thread-Index: AQHaFA+JG0y9YoReY0CHS8CqhvmL8rB4SSaA
Date: Mon, 13 Nov 2023 13:52:28 +0000
Message-ID: <f25352d1c00ca1b104bfd91338433451ab919bee.camel@suse.com>
References: <20231110195304.107907-1-bmarzins@redhat.com>
	 <20231110195304.107907-2-bmarzins@redhat.com>
In-Reply-To: <20231110195304.107907-2-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|GVXPR04MB9901:EE_
x-ms-office365-filtering-correlation-id: 013d1f2b-3311-4120-29bc-08dbe44fc67e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 fXqU2iSv6pkAGcPuFQV2inxmhVjlgdmBuqJz9/44Lv1zk0wWqwIaMPqac5YXTQJhYjvYvAiAl+wm2Y733KQsU/hNpqckSLXkvlb05y68R/sCLJFepFmL8NBI11pFFXTyRJoA8TY5S0B2kORECeljlh9jwYAQ+i3BPd0iVDpvNTi3x0iMYEkRwVnDyGlc2PiK1AtzK8FiCGnrcvpcvgoN5HM/5jvDu8nPuQ9Sc3DS6bzdPHF7drfRbofzigUMNp9uqKwYfRZvgxKQszMjMA1Oe+lYEMbtsuWQJw07Qj3RoUPSvUPz753/APjjxO30MmC10Dfwxnd1p1/3UDItw47dkz+eFW31h3aOqfvzLb1Hw7vmnlcdMLGgCeM7y4/xGcydpjtp1POCGKM/wMsQXBKORWPtg5wBbqaWtAN88qGfIxOTBJWljCD0EoDIRSiIpR+IuaNZFOeuq+ycMW3t8nghmmSlBOzPQMX5zBpB8+EfJV0kAOj86kT9BW41Jd77sMP+w6Qr0FfmaaDzd9t64ZzRkKqPWUVGoIMlcxQ/TY/CcYN1q0xEboMV3uAFQRGu/gfZjCK4WF4oK4c8uSi3cO4u1OtoymsIi7HJ2POd2G2h3NOUz8tVJZXFqLIU6Mgqy+NH
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(376002)(396003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(110136005)(66446008)(64756008)(76116006)(66946007)(66476007)(316002)(66556008)(478600001)(6486002)(71200400001)(86362001)(5660300002)(4001150100001)(38070700009)(41300700001)(36756003)(2906002)(4326008)(8676002)(8936002)(44832011)(2616005)(38100700002)(122000001)(83380400001)(26005)(6506007)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?JJ/X1RqRy/Dfj1CFAq9p7YzfXAuArhSkJ5va5pKic8tiUWNUdqyLqWNWm?=
 =?iso-8859-15?Q?CbCWI93RBYoQl01cWpd5bnJAXXHP7RieVonxJK9BnjufPRqsggD/GpgJT?=
 =?iso-8859-15?Q?Up/QRjJ6JFtUzI5rPwUMVKxRxYgjuLORo5gS1uczdYaGGUA0UCQjVqeYt?=
 =?iso-8859-15?Q?ky2K6ulj2w4bj6XVp8AiscfvfbtGBJv2R2BBRsD3AerZ+GxWb4kvccUsy?=
 =?iso-8859-15?Q?bj7kRO2Rv//HC6OmBvpHXOQ6LVm4AHjaVI/uIHl8X9dhOaAXXaez4gGbE?=
 =?iso-8859-15?Q?Yarg//LuRkJTxP3noJHPrB2UG9UUq0aEzue1fFdZtlWzJcQ931Qxqnlwr?=
 =?iso-8859-15?Q?Q5hsbDE3B7GRn2FqUIVs53bv7Z2D5/E443V9njF/DRryKyx3M/x2DZKSP?=
 =?iso-8859-15?Q?+H0FPOowpRQZaAyRbTQGYXDmvBO33JHqJdFwWX48K0Nykai7ect+yY4bj?=
 =?iso-8859-15?Q?UcwFnq2ugwHD2wsKGBcILiiRWvDg5MJm8/D3Qzab2uObQC833igXJnSJy?=
 =?iso-8859-15?Q?Ohp9NQjQST4DgzTL5ddYw3hZAx7OfKXST4LXc6beS59nn8IFFQ1olfB1u?=
 =?iso-8859-15?Q?NaZSVoDC/RSuIPzFc7agFel6ugDo0zepqLPjaj2s5timSVzDnc8LZa0eH?=
 =?iso-8859-15?Q?Z9Pc9lYwv6ntBPdCPvWg/cB8ZnAmOtKZ26O18SRbOvWx9PmJaqPRIrxBD?=
 =?iso-8859-15?Q?xtsVG5TKTr2cg79aAT1sMvoPh3ilfBCO7TIwsO0BCHYkRn1DufTHMFvJ4?=
 =?iso-8859-15?Q?Arwu8KwPbk5jtEkvabP0U3WnVoCbGuPOBkrVcwfvY9dgNOZ8xVTzLIPEV?=
 =?iso-8859-15?Q?VKqbtMKFz30HoWgUQHVU1gewMrXl2LRt7uHxmcr2LTmm+SYDqIjvK/vQ+?=
 =?iso-8859-15?Q?2KedCcO2ktUROKUCcLhmDmlQQhMg76/ZwdJtMnpy7NMmiU0IGr0ECm6JH?=
 =?iso-8859-15?Q?DTgkVRvaHfe2ysAm+0yyFjyqHyzpRgnHdRmcxmxqQ1dKzJnxeWcqoyKwE?=
 =?iso-8859-15?Q?5FGHD/6LZFNN6Z7l+uMkvIITTNnXxOC67L7yyg7/7T5LCE5ckE1YZokJ+?=
 =?iso-8859-15?Q?xmM/NnI/YmZlWRUimG7iU5g64zTio9Dm+7eJ/+weyZ2mCJEyLu87PeA4e?=
 =?iso-8859-15?Q?iZs4h/eixOrgAjG9lVraltkg/J9ifPpAnS0kscnJRs0GtBMWzq3ZcuSLW?=
 =?iso-8859-15?Q?FslymmY7z9vCcvSYOlQ400KwwIM51YgImZvPT5KaIY0/iMtxl7CRiU8r3?=
 =?iso-8859-15?Q?k0/v7tkTQPbbvxeAvscXpynG8gQ9TNEmnJFuDeu7l4yqSxPYOR0PzQR1L?=
 =?iso-8859-15?Q?vVS2YZGlCOXTpyRwSWMBcBu/HfotAkbTZxp6Il6yh4qEBudHI7QDVHq1R?=
 =?iso-8859-15?Q?EXjrl7WKWOxTWhd0xVEt5Nxj0qV/NkyQJ2wTOg8Y4wza1487psfbnDVn8?=
 =?iso-8859-15?Q?umAELvd4r/IebHh9q5ZUXGFz7wZNc2w7HHUjg4MMk2lS3GidQoq+2ZImJ?=
 =?iso-8859-15?Q?oZXdcurw3o1MfdqewXj/fqVoPWt+kAJHpJxmYQcpyJAHdSzKIGRlGMF9j?=
 =?iso-8859-15?Q?aCHOkNMC4NCIVNmK5yaXSd2DO187RwUZBZKHiR9tnaAW4hMu9S2lAk728?=
 =?iso-8859-15?Q?NKEZz17I6+kk4HHDsFjflZn+LpX8LSB9tbquiZGYXHoYOZkFl6Itlc8pj?=
 =?iso-8859-15?Q?f74Z03i+Sg5dbdhcWEtdxvxrtQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <5912EAB26B141C499281EA996648B72B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6324.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 013d1f2b-3311-4120-29bc-08dbe44fc67e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2023 13:52:28.6006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thT4vFhrntof/FZKT0F+CLwsJaGJvwD6kj/jVPUAhsTLBcUw40Tsl7Gst2W/Nx97CJCmPPqAdUGVIfXdb8PB1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9901

On Fri, 2023-11-10 at 14:53 -0500, Benjamin Marzinski wrote:
> The current build system, with nothing overridden, will install the
> man
> pages in /share/man, which AFAIK isn't correct for any distribution.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0Makefile.inc | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Makefile.inc b/Makefile.inc
> index a20e2cec..ed40b449 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -60,7 +60,7 @@ modulesloaddir	:=3D
> $(systemd_prefix)lib/modules-load.d
> =A0libudevdir	:=3D $(systemd_prefix)lib/udev
> =A0udevrulesdir	:=3D $(libudevdir)/rules.d
> =A0bindir		:=3D $(exec_prefix)sbin
> -mandir		:=3D $(usr_prefix)share/man
> +mandir		:=3D /usr/share/man
> =A0LIB		:=3D $(if $(shell test -d /lib64 && echo 1),lib64,lib)
> =A0syslibdir	:=3D $(prefix)$(LIB)
> =A0usrlibdir	:=3D $(usr_prefix)$(LIB)

Hm. You are right for the default case, but the current code works
correctly for prefix=3D/usr/local, for example. Also, I don't like using
no hard-coded values for the secondary paths like "mandir" and
"bindir".

What about this instead?

diff --git a/Makefile.inc b/Makefile.inc
index a20e2ce..6b45430 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -36,7 +36,7 @@ prefix                :=3D
 # Prefix for binaries
 exec_prefix    :=3D $(prefix)
 # Prefix for non-essential libraries (libdmmp)
-usr_prefix     :=3D $(prefix)
+usr_prefix     :=3D $(if $(prefix),$(prefix),/usr)
 # Prefix for configfuration files (multipath.conf)
 etc_prefix     :=3D $(prefix)
 # Where to install systemd-related files. systemd is usually installed
under /usr

This will put the man pages under /usr/man is prefix is empty (the
default case) and under $(prefix)/man otherwise (i.e. /usr/man if
prefix=3D/usr).

Thanks,
Martin

