Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77BB3C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 20:38:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-UcvwTmyiPaqdD3QaJ3rxew-1; Tue, 15 Feb 2022 15:38:38 -0500
X-MC-Unique: UcvwTmyiPaqdD3QaJ3rxew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F207C343CB;
	Tue, 15 Feb 2022 20:38:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CE79452FA;
	Tue, 15 Feb 2022 20:38:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93EC21809C88;
	Tue, 15 Feb 2022 20:38:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FKcTjJ006937 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 15:38:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6028D40FF406; Tue, 15 Feb 2022 20:38:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B40C40FF404
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:38:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EFCF10AF951
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:38:29 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-232-TupyZardMPSW-0NoxP4xIg-1; Tue, 15 Feb 2022 15:38:27 -0500
X-MC-Unique: TupyZardMPSW-0NoxP4xIg-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2058.outbound.protection.outlook.com [104.47.6.58]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-5-ZzLHYiqvNxGyy7SppOpj4w-1; Tue, 15 Feb 2022 21:38:25 +0100
X-MC-Unique: ZzLHYiqvNxGyy7SppOpj4w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM8PR04MB7266.eurprd04.prod.outlook.com (2603:10a6:20b:1d6::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19;
	Tue, 15 Feb 2022 20:38:23 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Tue, 15 Feb 2022 20:38:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "maier@linux.ibm.com" <maier@linux.ibm.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/2] libmultipath: support host adapter name lookup
	for s390x ccw bus
Thread-Index: AQHYIdSXlneEaAZ3oESYoO1IvMaoxKyU5d2igAAubYA=
Date: Tue, 15 Feb 2022 20:38:23 +0000
Message-ID: <b862a5941dcf0fbe6dbec1798c983e4d649393be.camel@suse.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
	<20220214185559.28363-2-maier@linux.ibm.com>
	<f122514cab837e0e613a105c90335a91f60a72d0.camel@suse.com>
	<33ffe0bf-7ffb-4ca4-91d0-fc55ea67c751@linux.ibm.com>
In-Reply-To: <33ffe0bf-7ffb-4ca4-91d0-fc55ea67c751@linux.ibm.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b634ca2e-ef9c-45f5-8b1e-08d9f0c31c7f
x-ms-traffictypediagnostic: AM8PR04MB7266:EE_
x-microsoft-antispam-prvs: <AM8PR04MB72665CE0F95608493BB6F32FFC349@AM8PR04MB7266.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0++s825CVRcI46JY3tgnn9Ku9gk5l2Wb57ru3BhU1hnZpjy/k9XIENDXCAn7N52rLIc0J+RKSWdBiqIeh7+ZVFBjvmcrIwMR3D4t+87QI7okAJU7+3yRr+IYgZxx1TPuTH0I/GUt+bR8Mbd8vN5uNyv6pK8rIkmYLkD6Q9PEtxRKlK+UkMZVynW7dvpziEKYmu2HbdCJiJ/UokJlnJDeFxqPSkMqtp3xhGQZV74i5jqEwVHdc0r2nPmMNGQ8GuHslR/owbEoEkrwCQ7pyohSyZSBfnPVN+U7o2cGo3HUTLMi2JuoRjMG/KDP1KBT0R6UgC/Of1a0V2LqeMJG/tjw0RVO4ePJcYRU1qcXRLlxkyqjw0qAS9jp4AfMQ9h8egKPvZD4K5fnelI+5HjITQzQgp7NmkQ/jk88fkTlH5l1vEikExX3iObVvhL8j6QCB8CarNwjuQY9YqEz/nN/y9EmJoViXrymkb1IIITz1eAOUIlUE3F1JYMF/zew44PYAdMCWjZTG8HTf0JNwhfBFcfUn2NYk0UKDha/L+UnKOuAH3Jq+qFLqMnFdP2ks3HXydbulOKQYVZwTPQ+NCxL3AThtyldXxEOmaCaR7hqDD5zP7JfZA07K5VY2B3NmDgzG8kQ52CIzpMv4QwW/IOyzNAcDmRT0wBj8YiPo+eWJs51D5gV4BXWAKwt417q25DPsPNjo2E0FtaIMxSp+o0FhT+X53T/Kdq896xLXtQH7+qkVkkETqrGBXPNKXIHvKdu680FUpQqwqDB4R+NMIICLcoil6yIiZoLzrDAssoi9PEHCeA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(38100700002)(2906002)(83380400001)(66446008)(66476007)(44832011)(5660300002)(76116006)(8936002)(64756008)(8676002)(66556008)(36756003)(91956017)(966005)(2616005)(4326008)(122000001)(66946007)(6486002)(110136005)(71200400001)(26005)(186003)(6506007)(508600001)(86362001)(38070700005)(53546011)(6512007)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?aMjCDfjUUGRiPXVtObN8eNgAMoy36soS9XrhmNDdkDtyA1zamDYCDdr1Z?=
	=?iso-8859-15?Q?n9RH0lq4KkO8C4DK+XkV07ciLFOEUF6BtXBVvhKl3qM4IVCMTEey4/gIJ?=
	=?iso-8859-15?Q?txS4hEBGvM25saJGRgtUF9FVjdhbuR0qkXL7rWF02+WRGZk3uoMeEmHXf?=
	=?iso-8859-15?Q?4qPG94g95TSKWZOl0UPyLmTRNj8drWWKrO7T9MBvgYLUbG5mwo1Maoc0p?=
	=?iso-8859-15?Q?nnjSWsaLmIzHJfa0vxOHlVc90ZK+jlmSZcVA7LHtGAk3RlpbaXBTbh0td?=
	=?iso-8859-15?Q?dPcKVw/TBKlMvrJTQ1U6N3Hp7hkQ3UQbaGzbCcH/IfL/5Tsn3lKKWOyFb?=
	=?iso-8859-15?Q?zmfkFteHF6BsHnVt0hRzg5EZpL0Ob4u1HrcT8KUAwI+XQ2930K1ye87gd?=
	=?iso-8859-15?Q?3JmG6wczIso4IFi21loxFXn1Eopoq/ojPlyhP+nP7wnjX5JuKeqHW+uUs?=
	=?iso-8859-15?Q?yO180Nbkrd9HSa3e9B/Ay/wslsCLng94AirKCO+BUrNfWESKvhYx53HkT?=
	=?iso-8859-15?Q?JWQsFUAK2qJZy9XZijs2tVVYskq10PLXg97cSR/WVa7w0+/223LppyJgf?=
	=?iso-8859-15?Q?4s40sc6wdowbJeXb99xA+3wgsgANR5eqS61VHHre4I4Jqj3n7pGugnw+x?=
	=?iso-8859-15?Q?kBJHmRXHCsEjnOyIXEe+cUrYka1RtYc/JXQicaMcWMBhoKGbzqKfpwRre?=
	=?iso-8859-15?Q?zpCNmMni1ex4RVoClEpi9c3ZWHopEURffMDT3uK/NXLA7P/LnxngEpcyy?=
	=?iso-8859-15?Q?FKn79Xjfp2rs5O9/6UGlOkfsKvIGzv4BIK075EqW0AbNFbbUbiWW5cEM8?=
	=?iso-8859-15?Q?7qR9k69HwM+8MXJPCPUk50RwYoxRuo2J0u/OATxpySOl10MVAGj9zGUzx?=
	=?iso-8859-15?Q?XI545Yo/XeYLD1EpFpv3LPOmeLncCqjsoxZCg6wElMp1QlcaCA2vSIpPB?=
	=?iso-8859-15?Q?lya9kGFRdHEShWLdFvvEaky6dTEAHnPGekfTLvURJtozfHOo6Nq067WPf?=
	=?iso-8859-15?Q?Mp3njaJi/m/T4c3JF+O4BHZt2BQZ4vBYi1fh+VEbz/GE6XSMGKT1zvcIc?=
	=?iso-8859-15?Q?o2XaYAlQ3WTJC/80iYsjJA+EOGfxgMzz/FjwzQUJkNVr2Qoh9OP2vJyfL?=
	=?iso-8859-15?Q?MPLKm6ipx5GzFclDoVukYj7Q29/2nDWXwQS2IOiAM0oWv2qG7psusGk0S?=
	=?iso-8859-15?Q?WXNz0GtrDMrRuTvUDmWruvIiNOeeVxFp3poTyxq8KztdvUiJASRc1EA4Y?=
	=?iso-8859-15?Q?vFheWEFQZVbZHbgjyNlrHEcPX0Ikme5uMFUmaVwrVlXHzk0Jx9yKMRewh?=
	=?iso-8859-15?Q?74f/n4yuirT9eLTalFcmpbvXW4cPPLofoibBUSTxx8ISJstBbamDiwFvp?=
	=?iso-8859-15?Q?StJXPKHfeM0o8bJ0RPWaezRvtXCqA82i8LIFKvQHxttf6s4F7SDBzDSZ2?=
	=?iso-8859-15?Q?OJnD4jqlpb9Kn0c65hAgvZoG7LVHoMGN+aUJyZ84PPug2UIFTiID4pQNY?=
	=?iso-8859-15?Q?hFWmYP1q0Gqfk8cMOa6Tkwb3GnHewAyiusQrSlhcmZBF7CeBqcOFfDah/?=
	=?iso-8859-15?Q?yOrJ71hnIyzOMwyCuI2XAXAvWxLWhE8/Scii9HGgQzNvJjbmmCfPLM+bq?=
	=?iso-8859-15?Q?Z7JaA53wdvZGHTyTLKE6IjoWIYVrf1tLP+5xfTeBPQG7b9sGFbewkHa7J?=
	=?iso-8859-15?Q?b8JPt7flpfN/TjXPqsm7YEXbAOLTDuqx4DPCslTOKe4xFsw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b634ca2e-ef9c-45f5-8b1e-08d9f0c31c7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 20:38:23.5951 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MNoCNZM/xofmOD6qJqX3AWM7tFlIF6ni/K+fG69K97PynFNbMDeIag3MSLQhrtRX8RvJY2917RAB4siOqgVO8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7266
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21FKcTjJ006937
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] libmultipath: support host adapter
 name lookup for s390x ccw bus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2F70D448A9DA64498A4994E8C6921DA5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-02-15 at 18:51 +0100, Steffen Maier wrote:
> On 2/14/22 20:19, Martin Wilck wrote:
> >=20
> > Is it certain that this condition can't cause a valid ccw device
> > (where
> > the driver attribute isn't required) to be skipped with the
> > "continue"
> > statement? Even if the answer is "yes", I'd prefer self-explanatory
>=20
> I had the same thought, but it does work. Apparently, the device node
> we're=20
> interested in for ccw-attached FCP devices has both driver and
> subsystem=20
> attributes that exist and both with a non-empty value. So we're good,
> even if=20
> the preceding "early continue" skipped an uninteresting parent.
> However,=20
> proving generality is beyond my capabilities, as I'm not even sure
> libudev=20
> works on the udev database or sysfs directly. For instance,
>=20
> # udevadm info -a /sys/class/scsi_host/host2
>=20
> shows SUBSYSTEM and DRIVER property for each part of the ancestor
> chain, though=20
> sometimes with empty string values which would not be a problem,
> whereas
>=20
> # dir=3D$(readlink -e /sys/class/scsi_host/host2/); while [ -n "$dir"
> ]; do echo=20
> $dir; ls -laF $dir/driver $dir/subsystem; dir=3D${dir%/*}; done
>=20
> shows some ancestors completely lacking "driver" and some also
> lacking "subsystem".
>=20
> > code here, because not all of us are s390 / ccw experts.
>=20
> I don't think there is anything specific to architecture or bus type.

I was thinking about something like this (untested):

for (parent =3D udev_device_get_parent(hostdev); parent;=A0
     parent =3D udev_device_get_parent(parent)) {
      driver_name =3D udev_device_get_driver(parent);
      if (driver_name && !strcmp(driver_name, "pcieport"))
               break;
      subsystem_name =3D udev_device_get_subsystem(parent);
      if (subsystem_name && !strcmp(subsystem_name, "ccw"))
               break;
}
if (!parent) {
       udev_device_unref(hostdev);
       return 1;
}
...
     =20

At least this would make it clear to the reader that we check for both
ccw and pcie on each level of the hierarchy. Functionally, it would be
equivalent.

>=20
> In fact, I was surprised to see this code here to match for driver
> "pcieport"=20
> [also "pci**e**port" sounds like PCI-Express, so what about HBAs
> attached to=20
> the old parallel PCI instead of PCIe?], because udev-builtin-
> path_id.c looks=20
> very consistent and similar between pci and ccw to me:
>=20
> static int builtin_path_id(sd_device *dev, sd_netlink **rtnl, int
> argc, char=20
> *argv[], bool test) {
>=20
> =A0=A0=A0=A0=A0=A0=A0 /* walk up the chain of devices and compose path */
> =A0=A0=A0=A0=A0=A0=A0=A0 parent =3D dev;
> =A0=A0=A0=A0=A0=A0=A0=A0 while (parent) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *subsys, *sys=
name;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sd_device_get_subsys=
tem(parent, &subsys) < 0 ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sd_device_ge=
t_sysname(parent, &sysname) < 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (streq(subsys,=
 "pci")) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
path_prepend(&path, "pci-%s", sysname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
if (compat_path)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 path_prepend(&compat_path, "pci-%s",
> sysname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
parent =3D skip_subsystem(parent, "pci");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
supported_parent =3D true;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (streq(subsys,=
 "ccw")) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
path_prepend(&path, "ccw-%s", sysname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
if (compat_path)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 path_prepend(&compat_path, "ccw-%s",
> sysname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
parent =3D skip_subsystem(parent, "ccw");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
supported_transport =3D true;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
supported_parent =3D true;
>=20
> However, the details inside sd_device_get_subsystem() and=20
> sd_device_get_sysname() are beyond my powers to understand, so there
> might be=20
> differences hidden in there.
>=20
> That said, I don't want to touch the PCI part here. I don't even have
> something=20
> to test that.

I didn't mean you should. I was also wondering about "pcieport", too.
It dates back to a28e61e ("Crafted ordering of child paths for round
robin path selector"), which was merged before I started working on
multipath-tools.=A0

Indeed for this FC adapter:=20

 /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.7/driver ->
      ../../../../bus/pci/drivers/qla2xxx

the "%a" wildcard returns '0000:00:01.0', which is the pcieport
upstream of the FC adapter, but arguably not the "host adapter" itself.
This feels wrong.=A0=20

@Ben, what's your take on this?

I suppose it may be related to the purpose of a28e61e which had nothing
to do with human-readable output. Rather, the patch attempted to
distribute IO evenly over paths, and apparently used the PCIe port to
identify the PCI-Express part of the "path". The %a wildcard was added
later.

See=20
https://listman.redhat.com/archives/dm-devel/2014-February/msg00104.html

You may want to double-check if your CCW implementation meets the
purpose of commit a28e61e wrt distributing load evenly over adapters.

Thanks,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

