Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F001C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 12:58:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-lMW7-qRCP9KU5dR_t7_aHA-1; Wed, 30 Mar 2022 08:58:38 -0400
X-MC-Unique: lMW7-qRCP9KU5dR_t7_aHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F1A73C0013B;
	Wed, 30 Mar 2022 12:58:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD2CDC27E80;
	Wed, 30 Mar 2022 12:58:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F6B81947BBD;
	Wed, 30 Mar 2022 12:58:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63D3B19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 12:50:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7147400E420; Wed, 30 Mar 2022 12:50:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1EDB4010A37
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 12:50:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3B071C01507
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 12:50:09 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-ZK2LE_wZO22azf_A0ikxnw-1; Wed, 30 Mar 2022 08:50:07 -0400
X-MC-Unique: ZK2LE_wZO22azf_A0ikxnw-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2056.outbound.protection.outlook.com [104.47.4.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-33-fTvqpYRdNNycDyUWqtLngg-1; Wed, 30 Mar 2022 14:50:05 +0200
X-MC-Unique: fTvqpYRdNNycDyUWqtLngg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM0PR0402MB3841.eurprd04.prod.outlook.com (2603:10a6:208:e::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 12:50:00 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 12:50:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipath: return failure on an invalid remove command
Thread-Index: AQHYQ+VJIAbDSvXWgEeLacKNrI+s1qzX4YmA
Date: Wed, 30 Mar 2022 12:50:00 +0000
Message-ID: <6c69d3e943217da7027e65279d6f84830d9a881d.camel@suse.com>
References: <1648610498-28440-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1648610498-28440-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b26e435-a520-434d-0df0-08da124bcd5b
x-ms-traffictypediagnostic: AM0PR0402MB3841:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB3841245E708559D7949BB73DFC1F9@AM0PR0402MB3841.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LnFaDcfo72y9o5+p070fsmkrPIeNwGlcbMaeRmJ3vSUy6Zjkb+DFYf3LNdQVDcWdUrXut1p7QdVcrR9rtyFcA3wysv9HoL/V86ze4e4YZKyCk2JlYtVciErzhjZYU9cJTCd+ezl+Sxa92n1XbryeduY+QYUpZ/QbnfhsYTVEcRWAmUYcJvlZWEJtigxsEm2fTALRALkO9SqEDar/knScloP0J023V6pUcuIcdqIAPn26a10oL9RsncoKdgaCgxF3XW57fWP31eelpiQvYchJY08ne+7iIkf1AQhNhr0GI4gfJeM9BpXKn/tlglHhv6GzbP9g5c2BpDVL5paRt7G7H5ehfet1ZaLcuf0zdWLqV8f24wYQwbnwRjN+p7qx3HXUtVFe3OoAf6rm6fSuP1t4ki4cjNMSg9qtB62Ec+1FVt21VXNY0jWZZYozF9HCvkcsS8mtM0lzFYYxgUvRupM4qfLi5Zxem5pAQfRoUHhwY7jjKbj15ADJZEvb42Z+ghSUim1xSrek6ij4r+JE1DVQrSES/y6VLOlczokXeeTRAy4bQXyJcbihgQk7H+YjoMwgnl3guNQI7FzJauSxiLKNc8A+bQC0ykNxglahgDvc7EI9mHQi4XK6sGbqPIPjPM4ohMDTtvxC5/rxunB41IObGqywV494GbG2c71u2EpNp+1Hmb33c3aqlIvNnX7NUawWSFPEP6jMY9M4bddoLW3ycw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(83380400001)(6512007)(71200400001)(2616005)(2906002)(316002)(86362001)(6506007)(508600001)(38070700005)(186003)(26005)(6486002)(110136005)(36756003)(8676002)(66476007)(66946007)(64756008)(66556008)(91956017)(122000001)(8936002)(5660300002)(38100700002)(66446008)(76116006)(44832011)(4326008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?FdUDOnRkrJKPOWdJ7qEZNUdJf24DZgDSUBXTtDYNg39R9A2TPAfhfHh+l?=
 =?iso-8859-15?Q?YFPax+uDf4K1jrMjRxIVVoMYHo8RWRn0FXzgYja7Nz2s7fKO27IQEnwQh?=
 =?iso-8859-15?Q?1meaucQr28qhkg5LA1+v6929YXYfe+HC4jR2ybQqdQzUvd7uKrYnXnJY1?=
 =?iso-8859-15?Q?/8N8ebNCwTeaScTwHNm/4uJCin2ErOZq3imBz6GDR0B802mhv11YfPXpu?=
 =?iso-8859-15?Q?oXzsY9nEZRkpedHh7q3MC5RpyeHV1rKPyZqTgJyq944+OPCEuRNTPO52s?=
 =?iso-8859-15?Q?SjQR+dNM9PC6L0RDynxncFTHW6NwezoI/pEj3bcDONmvucZST2OeIu7h+?=
 =?iso-8859-15?Q?79WHnbengFAADmIIXxZdz3QUJoTrgdT8Y2bWjkJFvZoZpqcWlskGsK2Cs?=
 =?iso-8859-15?Q?UEBkoO9QR/HMWfukTzOoyG2/ubJZJJ9nbEIecVxIIDWiDw7yOG/undAN3?=
 =?iso-8859-15?Q?YgDmD9xMPr3+Iv6jMVCgcOI/CxVoGVIsoX+KSo8k3sC+N9yPMo/TvHhEW?=
 =?iso-8859-15?Q?RTAHzIdbFjxgkMDJvwtdWO4OMeci9WepY1RQQDZvXeE2Xd6nd+SE28wUq?=
 =?iso-8859-15?Q?qmDSGSn/QIv+xg4Ehb8lFUf1oAORjxbAPiLIcLBV3XBxlP/dfH5qhDCja?=
 =?iso-8859-15?Q?0G2C9hRBgTyKkBVBW9rmP0kYMU4O5su7OyML4gMQyk5jMKYbIjG69aix0?=
 =?iso-8859-15?Q?+6I8fRWa3+0nA4+nfqAkM1eodrpZWVw8MRW3hlQ7KWwnlNkOBLYQeebUf?=
 =?iso-8859-15?Q?+5b+m6qa/irDT3Dbsx5ArTvqgiV8d/griYkq7durUC55c+5wPvslBSPwR?=
 =?iso-8859-15?Q?QJZKrN0Y4LRPEaQzeziLgUZI5JI0r1wTMdodVuStNzZeVBFuGi+ja+3an?=
 =?iso-8859-15?Q?rxVdnbFl0d5gw1QToC9KxOQVVW+mux9oExCSi7E0x4RxJdVvmbWyiokb9?=
 =?iso-8859-15?Q?TyeNEY3B4A1D0NM8Fg9FoNtGK4YuiZISA0rqkB948K/qkquC0ihFH8jd/?=
 =?iso-8859-15?Q?riHkuSLt2ZjugJ1M3Qhy7BvYBwwQNhxVIBlVtrt4lfC78S663vtOIAQOl?=
 =?iso-8859-15?Q?lBGpdEmlSDrGm2BPNxhaLyWnob0upOahNPr7L2lbnjWDhiRMpJFL+ANvq?=
 =?iso-8859-15?Q?1kjEQ2WSSfnpx7YxVCNsG7wcDrfmXXMQRgrUjsO2vWa56TJNFy7ynqs3N?=
 =?iso-8859-15?Q?ip9KEgg2DfkGeYxPt9r5Cq6OaK5C9NqghCXR1doEjr1BjQa5/Sp8hpEl9?=
 =?iso-8859-15?Q?AMQ4b+d7ORFvss1hN8ZyHi4vvdZIzG5P+2YCQIg5WV9rScH6Gs0q4QH39?=
 =?iso-8859-15?Q?e8vkEm1yNmCTjkcSvaQ2P5SXOq+Sh8hFuz2zbq4U/6ntOX5qbaGWMipB+?=
 =?iso-8859-15?Q?AH36H33EI1IVsYRLs4t9QIytJuTuDPWa5VX7fMaBKAw0r+/XcQkEcM7dz?=
 =?iso-8859-15?Q?N9RIqzgeT0CAXeZJw3SDfWQ8TyJC/Vk2u3prYG5VLVTCwFHohudEMolrp?=
 =?iso-8859-15?Q?pcLVdm1h/MR8q+9tDGtklXXdOBoeLF8gIn6W54ETBQO085Lu3y/nxMICq?=
 =?iso-8859-15?Q?wQlGHw2Jg1KOy75/3xvgM5CAZ+mHvnguwjIq04fNmFzOq0i6nYfBcUQAc?=
 =?iso-8859-15?Q?KdbtXnB+cULJa2hticCxH2YOlzCZNg8SENLvf601xfzt1BptmpmKUaH0t?=
 =?iso-8859-15?Q?db1xM175pa/YIs9smMMVDipVnmVb4gMVFkMMu2HE7MTnYy1Uzrc/YloBe?=
 =?iso-8859-15?Q?97/kUQABNnV9F7mFLR0z0WI5gu0+hRWW3FVqrmwa6GfoVG/+52hM7pqnX?=
 =?iso-8859-15?Q?xiZri6w34s6z4FFVCHtpY3DSiMiTaB/IamGA+8ZLaeRObnLsLZBu4olC0?=
 =?iso-8859-15?Q?51zo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b26e435-a520-434d-0df0-08da124bcd5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 12:50:00.2865 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XYewe6upQJWO+W346FwNuCojnt44j6d+EK63vxklvgBMZtBMeRCgWZmohB9I0RJAcJNCEF5PcbgFhnhjNbeZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3841
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath: return failure on an invalid
 remove command
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <EC7AC4FD22BB6D42976CCF1725D3E0B5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-03-29 at 22:21 -0500, Benjamin Marzinski wrote:
> When "multipath -f" is run on a device that doesn't exist or isn't a
> multipath device, the command will not remove any device, but it will
> still return success.=A0 Multiple functions rely on _dm_flush_map()
> returning success when called with name that doesn't match any
> multipath device. So before calling _dm_flush_map(), call
> dm_is_mpath(),
> to check if the device exists and is a multipath device, and return
> failure if it's not.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipath/main.c | 5 +++++
> =A01 file changed, 5 insertions(+)
>=20
> diff --git a/multipath/main.c b/multipath/main.c
> index d09f62db..e865309d 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -1060,6 +1060,11 @@ main (int argc, char *argv[])
> =A0=A0=A0=A0=A0=A0=A0=A0if (retries < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retries =3D conf->remove_=
retries;
> =A0=A0=A0=A0=A0=A0=A0=A0if (cmd =3D=3D CMD_FLUSH_ONE) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(dev) !=3D 1=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed removing \"%s\"", dev);

Could we provide a more meaningful error message here?
(As you're the native speaker - shouldn't it rather be "failed to
remove"?)

Otherwise, ack.

Martin


> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =
=3D RTVL_FAIL;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o out;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_suspend_and_flus=
h_map(dev, retries) ?
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RTVL_FAIL : RTV=
L_OK;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

