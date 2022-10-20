Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522B7C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p2A8XuFYZXLXd5wV9moureWEm05CIA0l488ZIC3NaAY=;
	b=cXY8/Lk+lC77ewz7lr7yDSG82IKiIjoFl0cF594OHt6YXfxbPE18lZ+1PQUjASm/PrD8RU
	YoRNRR4Gyz2csuuR2pIUg/AjL6ord5IIzMgeyABL1obHQxgEpQZKHI9LSUeuSXA/prPPIu
	RrnkwQHoBoUrfOVkalljGnDqnftHUE4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-uhBmJ_hAPVS6wVrLvFKINQ-1; Thu, 20 Oct 2022 10:59:04 -0400
X-MC-Unique: uhBmJ_hAPVS6wVrLvFKINQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E31A29ABA07;
	Thu, 20 Oct 2022 14:59:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4291B40CA423;
	Thu, 20 Oct 2022 14:59:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 244A519465A0;
	Thu, 20 Oct 2022 14:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7EFBC1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:58:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 643F2202323C; Thu, 20 Oct 2022 14:58:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C273202322E
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EAE01C08975
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:59 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-EIRkUnJOMZqfHRkvTddBvg-1; Thu, 20 Oct 2022 10:58:56 -0400
X-MC-Unique: EIRkUnJOMZqfHRkvTddBvg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 14:58:53 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 7/8] libmultipath: get nvme path transport protocol
Thread-Index: AQHY2nND3iqIxfWN1k+c3HgyyItNS64XdAgA
Date: Thu, 20 Oct 2022 14:58:53 +0000
Message-ID: <0cf08d684ffeaccf1b15f91c738a510531d2c443.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM7PR04MB6981:EE_
x-ms-office365-filtering-correlation-id: 500042b1-2178-4bc2-1a03-08dab2ab9ace
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fo12zcTX/YzH1elbclXeafI6vpx9S3UKkhN6UM6M0JPHHt45eTThqLMSMeRrvQSgpYnqG2tu4OsKIURb0e0Y8dQ1dCblgwf59S5L7Jgfi6QZMo0iTsq5vmHiesyr269j8C1ov2Kz44y8yLe2414AbgG1YwZvj4eTprBsDXXW7tdPzdb7V7sdcGXh6/rSC675nsvX8fzHtnuWoEDdqtTUXOreiBAlpWQeOA6B7OC/xT3Y/UPWxyabRFG5Y9f5iAcK+UIjgJ9k9n39vExPx6M2yxoWWriIHf4dZABGDCbLLk8oR1VyLCKxfhwY4uh9WaT8TeRe8iAPT7BXFTCLUc/nI3ytpJL99+0jOzEf+w9rD1zAe4J3gMmUA2u2vfDzeoVSw3mDGDRnxb+KM+5GCD4j0LISduXJoUIgpW9JeUgkT8pbDpSxYm6ntutn70/YYTYSml6xzvNFNN9VI0hBKh7P/YuOi5nvUxC9K1yDAxi0LYMlorVhCEo/uo7efkqBmKRV9XHp9H73q7eupDo7We0e/9TzdD/GpYyPKMwdLWyIC/6SUgf+rTG9CVwr/EKPqDafCewxYEbu1XLGSdAU51u4FsSTd0kArIsVEHt5HNMlHDhs2gQQFr31MYEtYRJ7LSkzv7Y3i9iUO74/Rc47MIRwMvMVa1KJgscBhc2jcMYQynHdnR8RxsX2h4w3GSdcEuCPqaipF2aMW5Y4v35HOFPxb7tyyMZPAUcNoRgSlEYBQdPVAPUeGqWq00cz3XyPFREjohoeNgQhICD0AdRmfB8yAw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6512007)(71200400001)(478600001)(83380400001)(86362001)(6486002)(66946007)(66476007)(66556008)(36756003)(66446008)(316002)(110136005)(41300700001)(26005)(76116006)(44832011)(8936002)(4326008)(5660300002)(8676002)(6506007)(2616005)(2906002)(186003)(64756008)(38070700005)(122000001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?HV9Jh1lB+HMPWJFCYeeRrFwRszgZqADShT3SpoiUi/6p/ldImAC9ZKbYl?=
 =?iso-8859-15?Q?Ckh5AN2MK0/qEFEsP+Z4MplN7qYGfU15SAzoTfV0hdIO6husKYKHYRZmu?=
 =?iso-8859-15?Q?tMUMT/ELfen6AHEgGEepbNtQmitBHNOCi5eZOAeRQWoW0k9zUprN+6LbM?=
 =?iso-8859-15?Q?xH0GfOuI0U1UcZgETbSsY6irMr52ccbj5qejGBTxGFc3oeDtKPtWUc1Th?=
 =?iso-8859-15?Q?DzexQU5W54MdygWnppRA1PupSM8ZdxEtrzJEiPGziuS2Dcu8IE1u0grZd?=
 =?iso-8859-15?Q?9XrI/dL5OXkvPsBiUAYj6Xchb8idza31NKJwbLpY7Tq6XNcF0zsMUD6sj?=
 =?iso-8859-15?Q?gxk2Jvp0pTTLZjh9iHuf9Bx40+id8HYqKaSh2DV6Wwy47C5Aul4NePWO+?=
 =?iso-8859-15?Q?wGUvdBVh3Rlnft4YV8t9hQEmUVNyOjxp3OVy544/b21jqW5NvkhPiCHMf?=
 =?iso-8859-15?Q?PzYbYFC9wCmN8NX4lHlodXz0cbJxT4NTFGaydzxa4o2SGmulpu4ulfp4i?=
 =?iso-8859-15?Q?aYSnU7hhcxUHL/Zktjs3nW/NTZxXfi5QX5dX7cxBEIAgjtvL49Lpyt9j6?=
 =?iso-8859-15?Q?+ZTpo07aJFYT6cnzV2uXRl3raAGNvHf0yQEOhLMhzPmKosD+4YqaxmaeN?=
 =?iso-8859-15?Q?nZk9QVUEvzknTgPLLm+ToHIjLeaa4RsmcdtOUWTFtn8aTH88kLOBdkDNK?=
 =?iso-8859-15?Q?HTFhlOEiiirpMAt5m10ab00w0+mqV7zwEgHyeB7P31viKtS6pULdeJQQT?=
 =?iso-8859-15?Q?lmmA+m/5l5VuP/SHDw3rXpjN4WfdIPkBV1DM8uRc4I5NhoNl23y4/Jjwy?=
 =?iso-8859-15?Q?q45vaArJZSNGu7P/BR6r0281q7KLom7/mva7wmqpzRwiFv37k7nkKuEDJ?=
 =?iso-8859-15?Q?X6lCWm6NNz8kMDjcYS+6+uc6aDvsLDxuXE3qppG2jL0I/OW+2gFSMtqAC?=
 =?iso-8859-15?Q?lm4bU9s4ajUFbWUKxmp7Oycd/LmlS8dTnSmCXwgd5PmMomIj6N/Ehs84X?=
 =?iso-8859-15?Q?r5X9EPVK6QWpFmx8IFVq9S9JhDtU42Zi+0kaCaIL8QPvg4OZf2jP5ZWqf?=
 =?iso-8859-15?Q?Tz4AjWLIgkWGCNG/H+ECWj6W+uCePbn63cxT2bxPRjZUYj9NIpnS9tgg3?=
 =?iso-8859-15?Q?akqVQ3UcxKlibNQJGxMe5ELq12DNPCLhVqvFVmevw50VMsWkmoRkZjXvX?=
 =?iso-8859-15?Q?Zmh8YY1jG1oDcVCaamuEMeUUwvaeeMg9CHiZ501KcGF26aVf+gRPLH4o/?=
 =?iso-8859-15?Q?hdK38eDw52IUXvbIzF8GeYjPplHVOnObnl8FYZcs0NDZkA/FGlM0fZkv9?=
 =?iso-8859-15?Q?/Pv7ui/+OlaMXccx6aRwM5G5h4M+ECwzkLE3lU3UN3OqGMMGCDeyUbyLY?=
 =?iso-8859-15?Q?tf8r15mwXuXrDoPzP/powu6a/eNJRMPPr3xj2sGGZsyg7yjF2T7cyFH/W?=
 =?iso-8859-15?Q?arBmxnFm8jGsk2EojVQFm+HMC/ytUh0/fYg/e0naF/4xAnVYdIDRlU3Wk?=
 =?iso-8859-15?Q?hZS4UXoRS/7sunZUXQ+tpwZFbuN2K5pnPse7QfSW52Ba/CAJQeWjSShKh?=
 =?iso-8859-15?Q?EK8VEcByRmdLpF/Cm96YsQviTy1IW+8mE/9tOoHbQs2R8KtSsmd9G1QTP?=
 =?iso-8859-15?Q?+TC+IGBCXxkHuWDEhG3NhWA8UR4DC6p8pK/MnKDHA9QMOn1tnU0bBtwdH?=
 =?iso-8859-15?Q?GPjdFXC94dLfoMa9BUw/e8Ao4Q=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500042b1-2178-4bc2-1a03-08dab2ab9ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:53.2071 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8cFewu2fVi1AjtjgUXYsRWhNHAJCcTaF229oOWekOV7jJuWBB9wQuGucxJUGSz62gtayBEp0a0KQVjVt7HkBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 7/8] libmultipath: get nvme path transport
 protocol
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F9E9FBA6E5FFF0489C7748F5D81C321C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> Read the transport protocol from /sys/block/nvmeXnY/device/transport.
> Update protocol_name[] and bus_protocol_id() to store the nvme
> protocol
> names after the scsi protocol names.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

One remark below.

Regards
Martin


> ---
> =A0libmultipath/discovery.c=A0=A0 | 18 ++++++++++++++++--
> =A0libmultipath/structs.c=A0=A0=A0=A0 | 22 +++++++++++++++++-----
> =A0libmultipath/structs.h=A0=A0=A0=A0 | 33 +++++++++++++++++++++---------=
---
> =A0multipath/multipath.conf.5 |=A0 8 ++++++--
> =A04 files changed, 60 insertions(+), 21 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index e937f090..f3fccedd 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1539,6 +1539,7 @@ nvme_sysfs_pathinfo (struct path *pp, const
> struct _vector *hwtable)
> =A0=A0=A0=A0=A0=A0=A0=A0struct udev_device *parent;
> =A0=A0=A0=A0=A0=A0=A0=A0const char *attr_path =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0const char *attr;
> +=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp->udev)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0attr_path =3D udev_device=
_get_sysname(pp->udev);
> @@ -1561,6 +1562,18 @@ nvme_sysfs_pathinfo (struct path *pp, const
> struct _vector *hwtable)
> =A0=A0=A0=A0=A0=A0=A0=A0attr =3D udev_device_get_sysattr_value(parent, "c=
ntlid");
> =A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.channel =3D attr ? atoi(attr) : 0;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0attr =3D udev_device_get_sysattr_value(parent, "tra=
nsport");
> +=A0=A0=A0=A0=A0=A0=A0if (attr) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0for (i =3D 0; i < NVME_PROT=
OCOL_UNSPEC; i++){
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(protocol_name[SYSFS_BUS_NVME + i] &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 !strcmp(attr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 protocol_name[SYSFS_BUS_NVME + i]
> + 5)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D i;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME")=
;
> =A0=A0=A0=A0=A0=A0=A0=A0snprintf(pp->product_id, PATH_PRODUCT_SIZE, "%s",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 udev_device_get_sysattr_=
value(parent, "model"));
> @@ -1815,9 +1828,10 @@ sysfs_pathinfo(struct path *pp, const struct
> _vector *hwtable)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->bus =3D SYSFS_BUS_SCS=
I;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D SC=
SI_PROTOCOL_UNSPEC;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0if (!strncmp(pp->dev,"nvme", 4))
> +=A0=A0=A0=A0=A0=A0=A0if (!strncmp(pp->dev,"nvme", 4)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->bus =3D SYSFS_BUS_NVM=
E;
> -
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D NVME=
_PROTOCOL_UNSPEC;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0switch (pp->bus) {
> =A0=A0=A0=A0=A0=A0=A0=A0case SYSFS_BUS_SCSI:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return scsi_sysfs_pathinf=
o(pp, hwtable);
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index fb44cd64..7a2ff589 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -25,7 +25,6 @@ const char * const
> protocol_name[LAST_BUS_PROTOCOL_ID + 1] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_UNDEF] =3D "undef",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_CCW] =3D "ccw",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_CCISS] =3D "cciss",
> -=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME] =3D "nvme",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_FCP] =3D "scsi:fc=
p",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SPI] =3D "scsi:sp=
i",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SSA] =3D "scsi:ss=
a",
> @@ -37,6 +36,13 @@ const char * const
> protocol_name[LAST_BUS_PROTOCOL_ID + 1] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ATA] =3D "scsi:at=
a",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_USB] =3D "scsi:us=
b",
> =A0=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC] =3D "scsi=
:unspec",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_PCIE] =3D "nvme:pci=
e",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_RDMA] =3D "nvme:rdm=
a",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_FC] =3D "nvme:fc",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_TCP] =3D "nvme:tcp"=
,
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_LOOP] =3D "nvme:loo=
p",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_APPLE_NVME] =3D "nv=
me:apple-
> nvme",
> +=A0=A0=A0=A0=A0=A0=A0[SYSFS_BUS_NVME + NVME_PROTOCOL_UNSPEC] =3D "nvme:u=
nspec",
> =A0};
>=20

With NVMe subprotocols being added, I wish we could separate
bus and protocol more cleanly. The addition (SYSFS_BUS_SCSI +
SCSI_PROTOCOL_FCP) was ok as long as only SCSI had transport protocols,
but with NVMe transports being added, I'd prefer something cleaner.

I guess it's ok for the time being, but we should look into improving
it.

Martin=20



> =A0
> =A0struct adapter_group *
> @@ -746,11 +752,17 @@ out:
> =A0}
> =A0
> =A0unsigned int bus_protocol_id(const struct path *pp) {
> -=A0=A0=A0=A0=A0=A0=A0if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_SCSI)
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_NVME)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_UNDEF;
> -=A0=A0=A0=A0=A0=A0=A0if (pp->bus !=3D SYSFS_BUS_SCSI)
> +=A0=A0=A0=A0=A0=A0=A0if (pp->bus !=3D SYSFS_BUS_SCSI && pp->bus !=3D SYS=
FS_BUS_NVME)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return pp->bus;
> -=A0=A0=A0=A0=A0=A0=A0if ((int)pp->sg_id.proto_id < 0 || pp->sg_id.proto_=
id >
> SCSI_PROTOCOL_UNSPEC)
> +=A0=A0=A0=A0=A0=A0=A0if (pp->sg_id.proto_id < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_UNDEF;
> -=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_SCSI + pp->sg_id.proto_id;
> +=A0=A0=A0=A0=A0=A0=A0if (pp->bus =3D=3D SYSFS_BUS_SCSI &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->sg_id.proto_id > SCSI_PROTOCOL_UNSPEC=
)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0if (pp->bus =3D=3D SYSFS_BUS_NVME &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->sg_id.proto_id > NVME_PROTOCOL_UNSPEC=
)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0return pp->bus + pp->sg_id.proto_id;
> =A0}
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d3054662..9e2c1ab0 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -56,15 +56,6 @@ enum failback_mode {
> =A0=A0=A0=A0=A0=A0=A0=A0FAILBACK_FOLLOWOVER
> =A0};
> =A0
> -/* SYSFS_BUS_SCSI should be last, see bus_protocol_id() */
> -enum sysfs_buses {
> -=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_UNDEF,
> -=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_CCW,
> -=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_CCISS,
> -=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_NVME,
> -=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_SCSI,
> -};
> -
> =A0enum pathstates {
> =A0=A0=A0=A0=A0=A0=A0=A0PSTATE_UNDEF,
> =A0=A0=A0=A0=A0=A0=A0=A0PSTATE_FAILED,
> @@ -190,14 +181,32 @@ enum scsi_protocol {
> =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_ATA =3D 8,
> =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_USB =3D 9,=A0 /* USB Attached SCSI =
(UAS), and
> others */
> =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_UNSPEC =3D 0xa, /* No specific prot=
ocol */
> +=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_END =3D 0xb, /* offset of the next sy=
sfs_buses
> entry */
> +};
> +
> +/* values from /sys/class/nvme/nvmeX */
> +enum nvme_protocol {
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_PCIE =3D 0,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_RDMA =3D 1,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_FC =3D 2,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_TCP =3D 3,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_LOOP =3D 4,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_APPLE_NVME =3D 5,
> +=A0=A0=A0=A0=A0=A0=A0NVME_PROTOCOL_UNSPEC =3D 6, /* unknown protocol */
> +};
> +
> +enum sysfs_buses {
> +=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_UNDEF,
> +=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_CCW,
> +=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_CCISS,
> +=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_SCSI,
> +=A0=A0=A0=A0=A0=A0=A0SYSFS_BUS_NVME =3D SYSFS_BUS_SCSI + SCSI_PROTOCOL_E=
ND,
> =A0};
> =A0
> =A0/*
> =A0 * Linear ordering of bus/protocol
> - * This assumes that SYSFS_BUS_SCSI is last in enum sysfs_buses
> - * SCSI is the only bus type for which we distinguish protocols.
> =A0 */
> -#define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC)
> +#define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_NVME + NVME_PROTOCOL_UNSPEC)
> =A0unsigned int bus_protocol_id(const struct path *pp);
> =A0extern const char * const protocol_name[];
> =A0
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 46a4126c..07476497 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -1377,7 +1377,9 @@ Regular expression for the protocol of a device
> to be excluded/included.
> =A0The protocol strings that multipath recognizes are \fIscsi:fcp\fR,
> =A0\fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
> =A0\fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
> -\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and
> \fIundef\fR.
> +\fIscsi:unspec\fR, \fInvme:pcie\fR, \fInvme:rdma\fR, \fInvme:fc\fR,
> +\fInvme:tcp\fR, \fInvme:loop\fR, \fInvme:apple-nvme\fR,
> \fInvme:unspec\fR,
> +\fIccw\fR, \fIcciss\fR, and \fIundef\fR.
> =A0The protocol that a path is using can be viewed by running
> =A0\fBmultipathd show paths format "%d %P"\fR
> =A0.RE
> @@ -1773,7 +1775,9 @@ The protocol subsection recognizes the
> following mandatory attribute:
> =A0The protocol string of the path device. The possible values are
> \fIscsi:fcp\fR,
> =A0\fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
> =A0\fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
> -\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and
> \fIundef\fR. This is
> +\fIscsi:unspec\fR, \fInvme:pcie\fR, \fInvme:rdma\fR, \fInvme:fc\fR,
> +\fInvme:tcp\fR, \fInvme:loop\fR, \fInvme:apple-nvme\fR,
> \fInvme:unspec\fR,
> +\fIccw\fR, \fIcciss\fR, and \fIundef\fR. This is
> =A0\fBnot\fR a regular expression. the path device protocol string must
> match
> =A0exactly. The protocol that a path is using can be viewed by running
> =A0\fBmultipathd show paths format "%d %P"\fR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

