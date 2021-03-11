Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4CCC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:31:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AAC8A64F8B
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:31:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAC8A64F8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-fc_mPla-PfKIc74_vngu1g-1; Thu, 11 Mar 2021 15:31:12 -0500
X-MC-Unique: fc_mPla-PfKIc74_vngu1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFEA48030A0;
	Thu, 11 Mar 2021 20:31:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDE61138EA;
	Thu, 11 Mar 2021 20:31:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5351B18155DE;
	Thu, 11 Mar 2021 20:31:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BKV2OK008403 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 15:31:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F0242026D60; Thu, 11 Mar 2021 20:31:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08F322026D7F
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:30:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A24F185A7B6
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:30:58 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-347-uWJCo6CmN6y3SY5S5EfljQ-1;
	Thu, 11 Mar 2021 15:30:55 -0500
X-MC-Unique: uWJCo6CmN6y3SY5S5EfljQ-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-39-01pKNUS0NAale_XhNrohLw-1; Thu, 11 Mar 2021 21:30:52 +0100
X-MC-Unique: 01pKNUS0NAale_XhNrohLw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7097.eurprd04.prod.outlook.com (2603:10a6:10:12a::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17;
	Thu, 11 Mar 2021 20:30:51 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Thu, 11 Mar 2021 20:30:51 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/3] multipathd: add recheck_wwid option to verify the
	path wwid
Thread-Index: AQHXCnb/povonI3prku1VaMnRVGuJap/VesA
Date: Thu, 11 Mar 2021 20:30:51 +0000
Message-ID: <8f500bcd5d5a683edcfa4d59567a50cc794cb085.camel@suse.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
	<1614148402-19847-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614148402-19847-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f59fbfb5-a081-4eb4-132f-08d8e4cc9008
x-ms-traffictypediagnostic: DB8PR04MB7097:
x-microsoft-antispam-prvs: <DB8PR04MB7097B7B97E1E74872C3E505FFC909@DB8PR04MB7097.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:246
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: L4vHT8QgHx+epWObGyB1W+lK2erm+FqF7k0OxlrSV5vM5RbMltHQ9Ep+NXHHUxr9Jp95jm/O7KDTloL2byumYVn2TxcVkX9Hzcc1u5MYkbpivfgQtg63Nr0jBmIyJNSPF8BgSmFjvpvDlysX+J46rdaD3CcNgW0AX+eazBLkO5AKADdDBHt0aAIrcVLFI6jGvZTGvi5y9hEnFiAhXsuPANmrDwBu946OKGw8FS3WZdM2N1amV6+1tzNkYGhhj1lLS236LbLzF7GWn36SHeelbIG/lVRfaa5HKXyMG4vPcy/hu13mrX2WQ0Eas+Kx+yCn2d3HiC/QBoWV4c98aTTNUm3e9gk27fhKG/NDauy+SNB4E3X/sq8KDXmht0ybJWKaAyh7HWHuxBkkkFGPBXVMlLRGYYIFPfUKOdbeqI3mgreCWbmkOtI/bR6FjuiG+BURF90TpbUAvyfhvlrwvjj/rslTRg0Vk3nL1qVoeU1lwJilRMNQ9KoZSRyT8WHgo444V8vPtnsnDBnMJZ0gV5qFLA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39850400004)(346002)(136003)(396003)(366004)(376002)(66574015)(2616005)(66556008)(26005)(66476007)(64756008)(4326008)(86362001)(66946007)(6486002)(83380400001)(76116006)(66446008)(8936002)(186003)(6512007)(316002)(71200400001)(8676002)(478600001)(15650500001)(36756003)(5660300002)(54906003)(2906002)(44832011)(110136005)(91956017)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?JBS54GPb9A71vCqeXWvQ1uFfOOHRVqPG/vnueUcd6tbT/OcZyhYOjcTyP?=
	=?iso-8859-15?Q?wbw8SR12N3mvy2XWyrDwtuf2QhX0RUr/we7DpmW1YttcmVl+Lr5RL2oZW?=
	=?iso-8859-15?Q?ttNMbVWr4LBRQP5GwNl8WT0m6e+ooyaA3x2TwD9Cv/PRfyDeX5bjLE5wm?=
	=?iso-8859-15?Q?UCkCHfBq0Ps3Nn+IX9wZMh8ixK6d/juqDqzH1YgBtUho5SqxLYXR6zqfa?=
	=?iso-8859-15?Q?UPH0AUCD4iGPiiE+An9VxIRy0XFXOm70EKwCNEtKhdoH2/qW+yoyDPXEo?=
	=?iso-8859-15?Q?qsHm6E3nKEThS6sfUcEegUUEPfXoyMcfYgcHijZdx1nkkrsWdgmDdX7nc?=
	=?iso-8859-15?Q?WCORXQU3JvYtdZsAu6YvQx7PyFnulJqHUYhSqCFuxLTBsBCqHXWcxaFfs?=
	=?iso-8859-15?Q?8nEv9dHSDPTqqLGgm6Inbk6Rqca/PC8ldQOjesG+mfSfMm5DqvJk8yerL?=
	=?iso-8859-15?Q?lYXqA0GYPvYyMZCTiBn3VAOy0s2lSIe6NC/rlE4DoMbEhITKwFTGjBeeI?=
	=?iso-8859-15?Q?Qgh1LMRaAH+dQ9QsjCGQcrzh351XGYbmz//gsbjLuyD4Ck3qvfwasERF+?=
	=?iso-8859-15?Q?x6ipT7sJ+5dXza/ZVxkYTCmO7tR690k1/wmIBReBP8duenMWuJ1OUKjY9?=
	=?iso-8859-15?Q?q4EAHqTt/TXSBJYp5weQkbbbg91sJ+gzKWkaPHc1NRSYbCXzSTOJcJFvA?=
	=?iso-8859-15?Q?vHreJ84ABvhFS9lRQgQ2PniVWRvsC8NgyU9OXuBHW7vjzs3R/KGXRKZUV?=
	=?iso-8859-15?Q?AaC3qwiVHTVIXAbSlu7MkURkmbvQqnOsQ1xSUzc3z9lsNG3H7NMG3DxRe?=
	=?iso-8859-15?Q?aGFloOmZi6rke0E9LVCJO1nyA93MoO1CN6RQ9AhSa6bfRfAjshcIBM3ey?=
	=?iso-8859-15?Q?lAt4t49ywWJF0G20oGTTtoVGRQtvXNveNccEi5knqi3eNT77mG8FVfHqA?=
	=?iso-8859-15?Q?BlY1i0NYisM5PAFvWh0zNU1qj5npokeEoaT1ycRPrafxxIFWbAnA0P2Jy?=
	=?iso-8859-15?Q?7B3ZHsa4UmuB3YLNBV0eNv+q9lm3mvEJ8EAQ+TN7EZW52QIWDzlS/eCaW?=
	=?iso-8859-15?Q?PQO8fLEyfjmOmrUey5RAxPhdTz86a9A7XwgNPTjavSfpODRUD47Ao3XGO?=
	=?iso-8859-15?Q?qmm2Vb3HIoZOAqO+SiWRxCXhkZB1iSXwWDVCtw23t/4k/V9G92QnZ82F9?=
	=?iso-8859-15?Q?DsmdnZRFYDAXN3DfArlNxQQNI1Gb7xXtelKltxB6Ty2fzU83GL57y65og?=
	=?iso-8859-15?Q?oZdV39fECRrvCNkZHn3IrYxz/7pmfbVpCPr+is1ZrW2jR1A6rHUXS2+2z?=
	=?iso-8859-15?Q?f3JznoSg6QjzdTv7hCMycWrolAqsvzCtiXQ6+/IcHCgZo/VHhboGoG9+w?=
	=?iso-8859-15?Q?bWs083qy0K7RDbdkwOv0bzyXxm6FpdfUp?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59fbfb5-a081-4eb4-132f-08d8e4cc9008
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 20:30:51.2535 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vJ6qubUIyAg6B3sUjh2DQWfsApDgb1WTsVXhMQ2uDboCvUQ34ehY9R7MWDzE9hgNuUqkRpgNAAh6iTFtJaF+UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7097
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BKV2OK008403
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH v2 3/3] multipathd: add recheck_wwid option
 to verify the path wwid
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <92E7DBDADAF7C546AE209D672886D492@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-24 at 00:33 -0600, Benjamin Marzinski wrote:
> There are cases where the wwid of a path changes due to LUN remapping
> without triggering uevent for the changed path. Multipathd has no
> method
> for trying to catch these cases, and corruption has resulted because
> of
> it.
>=20
> In order to have a better chance at catching these cases, multipath
> now
> has a recheck_wwid option. If this is set to "yes", when a failed
> path
> has become active again, multipathd will recheck its wwid. If
> multipathd
> notices that a path's wwid has changed, it will remove and re-add the
> path, just like the existing wwid checking code for change events
> does.
> In cases where the no uevent occurs, both the udev database entry and
> sysfs will have the old wwid, so the only way to get a current wwid
> is
> to ask the device directly. Currently multipath only has code to
> directly get the wwid for scsi devices, so this option only effects
> scsi
> devices, and they must be configured to be able to use the
> uid_fallback
> methods. To make sure both the sysfs and udev database values are
> updated, multipathd triggers a both a rescan of the device and a udev
> add event.
>=20
> Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Two minor remarks below, but:

Reviewed-by: Martin Wilck <mwilck@suse.com>

> =A0
> +static void
> +rescan_path(struct udev_device *parent)
> +{
> +=A0=A0=A0=A0=A0=A0=A0while(parent) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *subsys =3D
> udev_device_get_subsystem(parent);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (subsys && !strncmp(subs=
ys, "scsi", 4))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0parent =3D udev_device_get_=
parent(parent);
> +=A0=A0=A0=A0=A0=A0=A0}

You could have used udev_device_get_parent_with_subsystem_devtype()
here.=20

> +=A0=A0=A0=A0=A0=A0=A0if (parent)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(parent=
, "rescan", "1",
> strlen("1"));
> +}
> +
> +void
> +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct udev_device *udd;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0udd =3D udev_device_ref(pp->udev);
> +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp) =
{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FAIL=
ED;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias=
, pp->dev_t);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0rescan_path(udd);
> +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(udd, "uevent", "add", strlen("=
add"));
> +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(udd, "add", strlen("=
add"));

Why do you need to do this for the partitions?

> +=A0=A0=A0=A0=A0=A0=A0udev_device_unref(udd);
> +}
> +
> +bool
> +check_path_wwid_change(struct path *pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> +=A0=A0=A0=A0=A0=A0=A0int len =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0size_t i;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Get the real fresh device wwid by sgio. sysfs st=
ill has
> old
> +=A0=A0=A0=A0=A0=A0=A0 * data, so only get_vpd_sgio will work to get the =
new wwid
> */
> +=A0=A0=A0=A0=A0=A0=A0len =3D get_vpd_sgio(pp->fd, 0x83, 0, wwid, WWID_SI=
ZE);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (len <=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: failed to c=
heck wwid by sgio: len =3D
> %d",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>dev, len);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0/*Strip any trailing blanks */
> +=A0=A0=A0=A0=A0=A0=A0for (i =3D strlen(pp->wwid); i > 0 && pp->wwid[i-1]=
 =3D=3D ' '; i--
> );
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* no-op */
> +=A0=A0=A0=A0=A0=A0=A0pp->wwid[i] =3D '\0';
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid=
);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: wwid '%s' d=
oesn't match wwid '%s'
> from device",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>dev, pp->wwid, wwid);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0return false;
> +}
> +
> =A0static int
> =A0uev_add_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> =A0{
> @@ -1296,6 +1363,7 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "%s: path wwid changed from '%s'
> to '%s'",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel, wwid, pp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
v_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0res=
can_path(uev->udev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n=
eeds_reinit =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> @@ -2197,6 +2265,16 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0set_no_path_retry(pp->mpp);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (newstate =3D=3D PATH_UP || newstate =3D=
=3D PATH_GHOST) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((pp->state !=3D PATH_UP && pp->state !=
=3D PATH_GHOST) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->dmstate =3D=3D PSTATE_FAILED) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 check_path_wwid_change(pp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: path wwid c=
hange detected. Removing",
> pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0handle_path_wwid_change(pp,=
 vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if ((newstate =3D=3D PATH_UP || newstate =3D=3D P=
ATH_GHOST) &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (san_path_check_enabled(pp->mpp) ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 marginal_path_check_enabled(pp->mpp)=
)) {
> diff --git a/multipathd/main.h b/multipathd/main.h
> index 5abbe97b..ddd953f9 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -50,4 +50,6 @@ int update_multipath (struct vectors *vecs, char
> *mapname, int reset);
> =A0int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
nt refresh);
> =A0
> +void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
> +bool check_path_wwid_change(struct path *pp);
> =A0#endif /* MAIN_H */

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

