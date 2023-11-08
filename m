Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2056.outbound.protection.outlook.com [40.107.6.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4774C6A
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cXfeO/QP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDu4UfPDKgEwoe16DLQg3SWADbQa8+aDFWVzzAY2QtgRYbbK9TiXVIPVmhxvm3ub2DU6+3MRoWqkiAdOyOD6H8kh22nf6IEQ9CCw+SqGCelb59HU5ZrV/HSpI7WvyR5N/+GhHpmlwqwD8aWI47bVCEVl6IlQh6PS7n4OmBgS76VoqtRI4OAbzawGSi+JtAUcNPlD3ZfJwYoTipzpoWU8jjK/OFap2/x/pqcKy+n7NTpHkQvDIp/vL9jDqLmz+QOs7NUTKETBfcryhZbefTg7/Dry6gsHrfYTt0d0U5k5gi3ZRpV0kMkA9ruP26ZkIWgq++8K+gwB/Q5M4E409HJyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9JwfSohlrcO8a/0Uc08tzC3+miNoWxPctjJBVC9Uz0=;
 b=UJXSap/fk5E9JeNF6+a9GL0YdrQkHdS9/SzJ/hQyZCwprZLilzd9CDTrftjs81IY64w7xJlSNV7/sGapJqVmjN8IKjmkMPCBN19pUAF67CKPS8XbydL8HV0xuSYJbzBAU6r3BSZA9E0NlzisiB/RrGfCE8+XoX8gL8tgRrQKJDg8u4NhZkYpazIDVurCiZMJwn4DZmS6zVhFqo7toi+KnU85DOb8himdcoch34SlGWMPSbJxdDdU2QNeaUdcywkBb8bVghWyFIpOTMHXXMyOIgEcZ78CIH9/Ss3LuaUbmUTrMOrQnASU5s5XtGhcIgEyVdQ4jPEYmWOSl9aNVKjGhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9JwfSohlrcO8a/0Uc08tzC3+miNoWxPctjJBVC9Uz0=;
 b=cXfeO/QPiRNyP3AM/d/KJtCv6QMEnncPgIL1UQyPJLyy6YrMHUsML15uVg6yTH7wV78lX8ji57BmionZyxGOvWsIad+NTGcOIaJG5bRMsqFhFV8dBOEY3PEoyPW3057UTFbDFSnhiZSe6pbsyrY7q/7R7wg5yxX+mMtbTMNCDpyDx0rXlFzDDSzcyBWRnTbsn7Cki8ONppLV/HaiPzcyZrqoIAlrUIyBTug+7UxmLDVunzkL/pgu1W/v6rV+5nzV8m6YP048CNvnRyrM3MKDIsTS5No7/vQLkjzA0pswEPM1Yz3Zl8mCaJytXcZhXUuQv+4pIAv+Y59lNxkcmnO1Mw==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by DU2PR04MB8918.eurprd04.prod.outlook.com (2603:10a6:10:2e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 15:36:14 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 15:36:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Topic: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Index: AQHaDdoOZRSHWsemRkaW+Xn4xoVS/7BwlueA
Date: Wed, 8 Nov 2023 15:36:14 +0000
Message-ID: <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-2-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-2-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|DU2PR04MB8918:EE_
x-ms-office365-filtering-correlation-id: 6eef835e-751a-4d27-5af8-08dbe0707124
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 tOOrN+DHNdPRzEUeAo4kYAsTFqSFYhzPP2NJDBRxq/OGLFyeumYKqnmGsmzutYufp2EByFsq6RAHZr/dhzvffZr5W366e2DP+5r5q1P+spOYJK4yH7B3woqmOjYOSdFvz2hsdwPc3XIDbIjdJ/TIjVblcZ4NuHDRIj80EtADGUZPUaB689/qGGEPPKqILWZVYv3lYFcXjf41v2vNChDTuwk6i1jCL9xt+VvsPwXCETXA6PPmrM3JNSILPlTl4/o223POGUwWucTGKlEtWsm+tsJDxu0ibYcnldnFgGe5UBAFP2WNuJk5TJlgH18l7vDtQYQx3pms+g0yP+5RxqK47YdOyuCiqTYJeWEafEzOdOyFPgI1m8t7Y8/xhYIwDT8puqY6UatXyIXtHQPlwrTJRrXQRRmfpT13hfoyKzOIiSRUkPHWG8FrgpidJhwNZug5JypssaAS5tvW3cal95thcWd9xF6g+PRSTJFgDjJHMcYvmnBWIkCQidMicFeaPhRksc+KW/4mTZuQ3vC7ixbTHUsyooDeqfGBYsyQwhVRsyj6JL/RMBoooeXp6catfkp9WI88UNr1CdWYoFxGmAD4DPIsxsN0uMX8K9eWFUKIJ0sU1APnfGiF3+WeGc/1WNJ3
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(5660300002)(86362001)(38100700002)(44832011)(41300700001)(6512007)(6486002)(36756003)(66446008)(66476007)(64756008)(316002)(4326008)(8676002)(8936002)(2906002)(66946007)(122000001)(76116006)(110136005)(66556008)(83380400001)(26005)(2616005)(38070700009)(71200400001)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?9FE0V9/uIeIIWGm0B/4VxNrfbUiPrPtve8fMwPs01+xXr9HeqBMyAwukf?=
 =?iso-8859-15?Q?tYwDLJbstpoHDAB80Pys4whYsmOVKUik04KysY6s+r2ViLIV+O1bE4RtU?=
 =?iso-8859-15?Q?VqK4vXwWi/VRmRM7jfbWn99PRS0dahRaNdKQW0Cfd7gsP/lhN/FM1e6kd?=
 =?iso-8859-15?Q?iDdb1/BsIF/+/5MVM4BKBwuSvQtDGacTjkPYOwUaKfPjBozIWKsY0K84w?=
 =?iso-8859-15?Q?bBerDjwV6fPoJ+v1yjkSXLs0AostYYxo66ABLq17C/sNRKaydfyC73Qyb?=
 =?iso-8859-15?Q?c3WnhO7BVUNQyRI9EdT5fF9nPlJilF2lMGQeo5W3EKBXxFOK1LvAxiKn5?=
 =?iso-8859-15?Q?ADF7wB2QKA85dd3N6uBx/9kogHeqAEi194ewtxMWJ/f37s19OVRZunPx4?=
 =?iso-8859-15?Q?wptdOw46T45HcaN/b6ZgHMyNPk+mvlVlGYDmFEyRyRlJph2hr/br3Ie3w?=
 =?iso-8859-15?Q?GCubUiGCv2VtTlqj2/l8T1D/S4AvtH8Y965bGZ6xvew75nFWj6jWtJQsO?=
 =?iso-8859-15?Q?/D1R/K6UMVy0PEBrb/oKq6uHC4oxxb16B0VreO7/q8f8+VnPt7u0/IhXX?=
 =?iso-8859-15?Q?PVhjN/ks5u5FptguvXBdBo2wIlhl5t9c9mnKMpWpwjYnRSt/iyA4LhoKo?=
 =?iso-8859-15?Q?5YRX9cU6qHjKJCRQlMiDPgXXjSr6ahSr415s3ZHMzKNxCirvGvEkHrKKd?=
 =?iso-8859-15?Q?jiBgudyLF+IKj0IG80yyYckIaxFMlodCZ34vUQO3S14TE+Ro9y/fgQUWx?=
 =?iso-8859-15?Q?xsixqdUhPpheCA+gffdYLK0JR89/9RQlE/Bz0oX6d9+mTHv2x+kVEMe+T?=
 =?iso-8859-15?Q?r/KgzAzzRWz2itXG0uWdRDocw+0x3tqA8Wn/lkTCNAdwQRPtJ+guShEFP?=
 =?iso-8859-15?Q?v//ORC1ecfkJSfUbJWtQmNKFW46MshJbuNNNyk0oND/2MUHM8jPb97pIE?=
 =?iso-8859-15?Q?xxlVR8sHGU4vPPqguMlB4kzUgy4M8CIEerG5gu4MItZ48cjQhRPTUrdcX?=
 =?iso-8859-15?Q?GMP1jNobeb0wLD47tLKEpM1mJoCB2EoEkuUbZVt3P8mCOXUgWSxZiYGMp?=
 =?iso-8859-15?Q?bwzZA5Nx0qBlth1Oi3dPfOjGubNa9RBHeMTt98UNZvwPaS9LOkzIgUFMC?=
 =?iso-8859-15?Q?08B2P2CVtA0FEW+8iWNsi8n0ayopJzQsRfDsd1MzUPnKhBUEQQlPo4jhE?=
 =?iso-8859-15?Q?CDOpLtOAo1lSrTVZrILesxa892IvlwPnSCorEZx387cWDKcndvlFqopEa?=
 =?iso-8859-15?Q?8N3HaP9mLjdrfgemVF/8DM5A8/4BeHLUH7Nid/7eH8ScblCe57J2OrQM2?=
 =?iso-8859-15?Q?lE4f8eguED1gqboDBnS7mevYebOuwvP7wXzKwTcDl4A2e49wYeGwmqBXe?=
 =?iso-8859-15?Q?OoWW5AfYCSmZ5EB4iPNrjIALdX7inyojeRtAzp3HEEME/mPGGeM1CI+8i?=
 =?iso-8859-15?Q?Oc39VAv5UtLe/d05I088uAfZf6jML11MmHKS3COiIqzI06Fq1SjTBudAV?=
 =?iso-8859-15?Q?zXpqs8Y/aq72BnkXJmRxYvKGVh0KLH4k9ysyPjx4d72vzlybB6120WMEQ?=
 =?iso-8859-15?Q?oeTWG8goPNpHXoZIieswWFzn6HkFfVAb2yndfr+NiTJ45lQeLE0L0AzuR?=
 =?iso-8859-15?Q?t7D5miE+dxyncRTGyk2YFaH5CfTVTmShBLkdVuMYGkD4OWFXz2rOvFbN8?=
 =?iso-8859-15?Q?BfkbL902PrYw4RKD1zeJQG13dw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <CAA819ABE31B4D45A292FBA0C52DC04A@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eef835e-751a-4d27-5af8-08dbe0707124
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 15:36:14.2096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qug1W6IvCsXnn1GEmZLJbptkpP11vqd548fJdjaAt0GOOYxulVgShguMc7ANOmnINLmdnMG7lwd2xrMDGrIaxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8918

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> This option lets multipath set a scsi disk's max_retries sysfs value.
> Setting this can be helpful for cases where the path checker
> succeeds,
> but IO commands hang and timeout. By default, the SCSI layer will
> retry
> IOs 5 times. Reducing this value will allow multipath to retry the IO
> down another path sooner.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

2 nitpicks below. Please explain to me again why we recommend to
activate shaky paths detection with this. What will go wrong if the
user uses max_retries without shaky path detection?

> ---
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 34 +++++++++++++++=
+++++++++++++
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0 | 42
> ++++++++++++++++++++++++++++++++++-
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0 | 18 +++++++++++++++
> =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0 |=A0 7 ++++++
> =A0multipath/multipath.conf.5.in | 22 ++++++++++++++++++
> =A08 files changed, 129 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 044067af..fc438947 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1152,6 +1152,36 @@ declare_hw_snprint(eh_deadline,
> print_undef_off_zero)
> =A0declare_pc_handler(eh_deadline, set_undef_off_zero)
> =A0declare_pc_snprint(eh_deadline, print_undef_off_zero)
> =A0
> +static int
> +set_max_retries(vector strvec, void *ptr, const char *file, int
> line_nr)
> +{
> +	char * buff;
> +	int *int_ptr =3D (int *)ptr;
> +
> +	buff =3D set_value(strvec);
> +	if (!buff)
> +		return 1;
> +
> +	if (strcmp(buff, "off") =3D=3D 0)
> +		*int_ptr =3D UOZ_OFF;
> +	else if (strcmp(buff, "0") =3D=3D 0)
> +		*int_ptr =3D UOZ_ZERO;

Why not use MAX_RETRIES_OFF and MAX_RETRIES_ZERO here?

> +	else
> +		do_set_int(strvec, int_ptr, 1, 5, file, line_nr,
> buff);
> +
> +	free(buff);
> +	return 0;
> +}
> +

> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 226d0019..41f3927e 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -793,6 +793,22 @@ The default is: \fB<unset>\fR
> =A0.
> =A0.
> =A0.TP
> +.B max_retries
> +Specify the maximum number of times the SCSI layer will retry IO
> commands
> +before returning failure. Setting this can be helpful for cases
> where the path
> +checker succeeds, but IO commands hang and timeout. By default, the
> SCSI layer
> +will retry IOs 5 times. Reducing this value will allow multipath to
> retry the IO
> +down another path sooner. \fBNote:\fR If it is necessary to set this

Maybe you should add "[retry IO commands] for some types of SCSI
errors". Otherwise users might get their hopes too high. IIRC the main
cases that matter here are DID_TRANSPORT_DISRUPTED and perhaps
DID_BUS_BUSY (don't put that in the man page) ;-)



> value, it
> +is also recommended to set up shaky paths detection. See "Shaky
> paths detection"
> +below. Valid values are
> +\fB0\fR through \fB5\fR.
> +.RS
> +.TP
> +The default is: \fB<unset>\fR
> +.RE



