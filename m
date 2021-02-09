Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866B5C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 20:58:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB3E864E6B
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 20:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB3E864E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-B8VhLoUAOkKhsiMDlgHurA-1; Tue, 09 Feb 2021 15:57:58 -0500
X-MC-Unique: B8VhLoUAOkKhsiMDlgHurA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB45C801965;
	Tue,  9 Feb 2021 20:57:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 313F560C04;
	Tue,  9 Feb 2021 20:57:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D70A04EEF6;
	Tue,  9 Feb 2021 20:57:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119Kvl3u015225 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 15:57:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0F1E2026D49; Tue,  9 Feb 2021 20:57:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A8C2026D11
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 20:57:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BAC6802A69
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 20:57:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-453-5pMAFVj-NnOe1z0mwt8JUQ-1;
	Tue, 09 Feb 2021 15:57:43 -0500
X-MC-Unique: 5pMAFVj-NnOe1z0mwt8JUQ-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-24-0MXJLsC_PPG4wZNAlxUSMw-1; Tue, 09 Feb 2021 21:57:40 +0100
X-MC-Unique: 0MXJLsC_PPG4wZNAlxUSMw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30;
	Tue, 9 Feb 2021 20:57:38 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3825.030;
	Tue, 9 Feb 2021 20:57:38 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [dm-devel] [PATCH 1/2] libmultipath: fix use-after-free in
	uev_add_path
Thread-Index: AQHW/qMtr6+fCcETkEuwS2dbmIY706pQTx6A
Date: Tue, 9 Feb 2021 20:57:38 +0000
Message-ID: <32e12b10f99011fc982e38bf95da9a99ef00a02b.camel@suse.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1612847967-8813-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0611655a-1fd6-497e-2e33-08d8cd3d55b9
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB52274CF1C787894872E29D86FC8E9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0Y6Mo84jdRk3E8DJ+IVJ1uIqm5g5pU117WiS6NqSM3xGuz3LAMZTM/ywiOUwVJXX/SXUOlJgHdTIDPAtIJwV0JhcEUe8i5PJrrjhPUubKQeXkrH0Qclt6F8swYdR4ijkHwmzItDJzbL3dfdgqb3EoUbWI5LJm6n6dP+ru/4N2tK6SSYn7Fn6Dz2bg104+uHCwNojBiReFEBl8APYQA84n8dOXe6v4X1/waL07yJzQcNvUgQH98BZCPVk8n2z5NyS6qK+mH1T6HEZq65bCNJ6RnfHDJDGLQz1p6731MlYNMyqVwZpflU+OgXC6wiZGD1Hlv3ZAVYfxg5imtkb42Yw9+tCavkvn3fbbIiU0L0HZHU/w9syJqV/exKyMKZSsiuJrjURxJ8ir4yKqf8jfGwYZFQkAQbGwnFh76C8d35K9HtypRZpCm3ceA4gqXihTZDur/OrbkxkNwgKu35w0lkDosn7ZdhGNMlH8yG23w1RNffFo156ABs+gGnwx6D6X8DbTM0KvbZD3h5CQzrPSA7YdA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39850400004)(346002)(366004)(396003)(136003)(376002)(44832011)(2616005)(26005)(64756008)(66556008)(66446008)(66946007)(76116006)(4326008)(66476007)(2906002)(66574015)(8676002)(5660300002)(8936002)(36756003)(110136005)(91956017)(71200400001)(186003)(6506007)(6486002)(4744005)(6512007)(54906003)(86362001)(83380400001)(478600001)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?ZY/hOERs0B4aluibx0tYwIukoE9AtQYBndCakcmsQb+/m1o5ZX3ftcQ26?=
	=?iso-8859-15?Q?IJ8iCiEqF7JSVoNoAU1KWmCz/fE7ip16kdp0mOagfN/4JJd1ah94mh4te?=
	=?iso-8859-15?Q?iRShtsSmLsaLKO4bWbvdIF0eNA9Ja91ZaQuP/T7pN+DGA8Y0OKTc/gb+y?=
	=?iso-8859-15?Q?1cA/6QGHefb7PMsKYfoPpcFEgh7CpI8b6tgN7mCbCLUo08NT0TWIyiyMz?=
	=?iso-8859-15?Q?UCa9XC9Qu+dRG6dJcFJ7atV4e0QmbiZ80sQ6tcmB51vvQIBCjDPFnt8Kz?=
	=?iso-8859-15?Q?c+/5mxHMkKl7WQOx2bRn0TdiOCMbh9LUm5i2uCogGddP8UXLsFKdJogJm?=
	=?iso-8859-15?Q?mGo25CSN/CsupufOKb+S9GRb88iFmuPkWzGqJVNcNbTrDdVBxdp1jBJEh?=
	=?iso-8859-15?Q?ymI8gm2StV54hSWkVlXNkh6Xu3MzH0zWJ4YR7SA06eB4l+hxmcjv1MGtP?=
	=?iso-8859-15?Q?VqKD2WTfkfu9fAk0anH1KrEx1ue9eqNc7vBP1uCngr46Z1ZbH5eJnTluo?=
	=?iso-8859-15?Q?2GVtXsuNeu+yVI39a95xpEzLwVko9vaA55bK69b2+ynrwb6fW99qWgFpm?=
	=?iso-8859-15?Q?cgO85N6jNkC5LbzeK6xVO6cG1xAE2zWzJslFHYJ+p9mnLi04yGAr6GE33?=
	=?iso-8859-15?Q?pLxbKFvcAOSu+1rqZa/ee31rLqe6aZNDlTxiMpJYjiyRvXAOiApNesFFa?=
	=?iso-8859-15?Q?P1HswuWIZvvTnNINqiaomHPsrCIQR9zUKOwbIXmUMDlH8Ks5vfFJqrok5?=
	=?iso-8859-15?Q?RR85al3/cGJWio4zDKiwi5czTiujxl+9lct/n5lB9ppU6AFMef7FYWlvf?=
	=?iso-8859-15?Q?h9dvyMmfDzPAGqtbETGANa6+KEqwQyDgsE70unqNRrHOp90kYgk9iLWek?=
	=?iso-8859-15?Q?v7mykFDxiL+NAc2jALO/qOqWA1VKzlF9W+zD9kNnI/8VimcAbEuDHPfak?=
	=?iso-8859-15?Q?aA1AUb1Oh5O5pChvIjuvXlk5sckpuqP6UH+5rbwAPsEzRgjW27GTpeYEw?=
	=?iso-8859-15?Q?e0PJmHSu0X+5INbvLkkATU5q+6ny9YTFZxCDJ9KUpISCf2cwICRju9ECG?=
	=?iso-8859-15?Q?PUEU6mQ9ugoegh2rv8mig5zC4K8nslqc4LFFtsbSRg9IzF7E9iIqyQ5sV?=
	=?iso-8859-15?Q?M/K2wlxU7BLjY7Qk0YJFgqSGbqj6BAqumUkZJHEhvLYs7zaQ6GgDGkkQ9?=
	=?iso-8859-15?Q?fqPLHvfp//8k948upkvHwcrRTjyHc1qLNM+gnMGtUMiZLNj3oDFFW+RO5?=
	=?iso-8859-15?Q?7r59p/ku38Y2rlYqdOQy2KzFZfrCLkOr9w038jI4/S4H+Q3E2Uay5e1hf?=
	=?iso-8859-15?Q?xziLDeZZ7lXDHoeoUxA83qz1Apc2+DBlKmNTRiLvoUL/GFqiBnppiUypP?=
	=?iso-8859-15?Q?czf1GMBBa24BeQH1V6WbTby0tb8YXxNNe?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0611655a-1fd6-497e-2e33-08d8cd3d55b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 20:57:38.6494 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sAFqtiYaFvIRt4WDLdup+l7CKtVGwMSI5xiOLlWmz4caLO/FpfSJ9CAC0qw/v8ZTRTfzpXGMKfJOStPgfOxFQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 119Kvl3u015225
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 1/2] libmultipath: fix use-after-free in
 uev_add_path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <308A487B7789D741B5B2D6BF9791A8E1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> if ev_remove_path() returns success the path has very likely been
> deleted. However, if pathinfo() returned something besides
> PATHINFO_OK,
> but ev_remove_path() succeeded, uev_add_path() was still accessing
> the
> the path afterwards, which would likely cause a use-after-free error.
> Insted, uev_add_path() should only continue to access the path if
> ev_remove_path() didn't succeed.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

