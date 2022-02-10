Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6D8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 21:05:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-g6_ZkvzFPCGlwz4uBg87qQ-1; Thu, 10 Feb 2022 16:05:49 -0500
X-MC-Unique: g6_ZkvzFPCGlwz4uBg87qQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 810161F2DA;
	Thu, 10 Feb 2022 21:05:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4EA0E2D3;
	Thu, 10 Feb 2022 21:05:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1FCA94BB7C;
	Thu, 10 Feb 2022 21:05:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AL5fWo008014 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 16:05:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A43BE1120AB2; Thu, 10 Feb 2022 21:05:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE9C1120AA9
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 21:05:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 858A9811E78
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 21:05:38 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-172-_t8rlZYiPD63ZZZWxqg70w-1; Thu, 10 Feb 2022 16:05:34 -0500
X-MC-Unique: _t8rlZYiPD63ZZZWxqg70w-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-17-kSVs0Ar_P7-rGYkVaHIefg-1; Thu, 10 Feb 2022 22:05:32 +0100
X-MC-Unique: kSVs0Ar_P7-rGYkVaHIefg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB5395.eurprd04.prod.outlook.com (2603:10a6:208:115::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12;
	Thu, 10 Feb 2022 21:05:31 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 21:05:31 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxKyNRkDmgAAAzwA=
Date: Thu, 10 Feb 2022 21:05:30 +0000
Message-ID: <cdec4d4ec101ae68e83fec96517a0a11dfeeff70.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
	<bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
	<20220210210215.GG24684@octiron.msp.redhat.com>
In-Reply-To: <20220210210215.GG24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79a9e91e-395e-40fb-1e1a-08d9ecd91267
x-ms-traffictypediagnostic: AM0PR04MB5395:EE_
x-microsoft-antispam-prvs: <AM0PR04MB53955414DD86E6409196611BFC2F9@AM0PR04MB5395.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ZyWdj7epUQqSm7HPJCOpYWMRP7F771Wao7Pb/DZXDuTf2TtFvGGq4iJKSytqkuN7oGem6t++zCTXaKseT+ytqUWQ/VFU+P8BjsExY1sSLsNS5zg5aIu4goZk5Kymioz1JJHKPp5XaiqJ4OS28LnPh5ZUvihBfx6QTanwpJGTnU58j4z5y7IwUVqBETv1IYq9rO1jAxT1WCoWI+tYmSGBUEmrMfPpCO9VWCQ+g2ZuodOz9LSXzTX82Agx7C8Slr17Pz4qGz+Z6RG99tl8cBXsBLicfB2evm6RwiH8jtkSVEj3bqYgvqQmCwy88jtM+bVPEvl0ZqqK+m6kp03mVdXARwyhOSKuCdunbmFlQRaHl42BbibnoTGNYBCsDnwAwrzYCvrPC6bxrQa5+mDPQZ6ROCvN4PzYnL9I7hLOqyWNc18PMWKvXW/kF791WlelJVuB7jpYSA4sRtQm7oePNssLTXfEDmkyw57vpW3NLcHEvf6UOxJuTBwZwFCMg93KjEpATTE1NIhiOC17iDzBeOXNZWiBMs6hnewy8Lfot0hQlJ6MRJCKTiVcj3nlcz7w2PloYNoZemZhdiRmAsrEJ0WCZYIMhAsRoAFE+SNh0V1OdwXGX47VjlW/45DCeFSWZ4TlgN0QTFW24QFx2m+Vc7rZLkynNdOfpGJd0Xgp4HZDGclMeAgpZxcXlnXXwEge4E+ibQCAQqrJBKRuaLfCg8TAiwocd+CSYhALfwHnKbqLMm4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(36756003)(2616005)(8676002)(316002)(122000001)(4326008)(71200400001)(83380400001)(8936002)(6486002)(6512007)(26005)(91956017)(186003)(64756008)(66946007)(66556008)(53546011)(66476007)(44832011)(6916009)(38070700005)(5660300002)(6506007)(86362001)(66446008)(54906003)(508600001)(76116006)(38100700002)(2906002)(60764002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?0MzbORX6ejSfZHDeCUP8HFP64dDG6qdo2Ymqrgst8D/t+L/7osfzgwXlc?=
	=?iso-8859-15?Q?PCEXheNvzrkG9fho3UuwTP2iN4CRb9SKM72RzCPWd0M0MovUZ0tpBpCB3?=
	=?iso-8859-15?Q?F3lmyDv9pOhrVBZapiwsoOVgDT0Uoa8FOXYw+FLPwwpTTjQQa/1WDDcSw?=
	=?iso-8859-15?Q?XTlnP9w15Hj71jFyArhS6GZ4vNaiLicRE3BRaGR43HfUdXpQWZtKYyWbx?=
	=?iso-8859-15?Q?yji9IKdcNvTGNPpb9mehkGiZiJAmdZ9jPKvw5eIgC/BgrKZGQh4HrlSHZ?=
	=?iso-8859-15?Q?LoVaYazEyKk4WHTqSyEjrJejgj3tKhJUcoQq1dFO8p/RsaKIFdYV73K4H?=
	=?iso-8859-15?Q?DZQxXbz1IQVt1nrJ5r/whOEz98eNuQPyhBwuKK9558OYyAtFdP+bWuRvU?=
	=?iso-8859-15?Q?WxrTexnHRGBM3N51E3mEKNgUasu6AJAgU1V+92YGnoLV9ZU08o7h235vS?=
	=?iso-8859-15?Q?mBd+A8qr4jgi9K6pXrGd/06nB3tFARMvluuE2VzW10pHAocxAo3N7dT79?=
	=?iso-8859-15?Q?8H7CSdPAYAPGmBE9u/q5qhA/oWfdtHwP9NeBiLImbo5riJ84E1ROy5kun?=
	=?iso-8859-15?Q?Tud7wW24Mkdtey38usyCfXwrvtFaCVo3YTR2thtXEJH5O/mCi1LQ9ALTp?=
	=?iso-8859-15?Q?IvdIhnx0jJPNhXnCOyWgm4ErX93+1g11IuVV8XptOCbI0UyvoMg/qdD5S?=
	=?iso-8859-15?Q?fmu9qvTGM+663/Eow13aJSc+6eP4z4QFRTo8Lz1vKldbeAp31YVieDH6K?=
	=?iso-8859-15?Q?n1sNIW2WUj2XU3JmD6jDUYAXpbswV4AsjlB1M+YrEn6Ed6RBxoEyMSIsa?=
	=?iso-8859-15?Q?ZFg4t/DoPou0/WfqR0tHy3lq8dIwp+eDmL4aLqpTifs8PMoj9jMh1G89H?=
	=?iso-8859-15?Q?vnUOxzd/9faI2cOsenQHvk/7plAaI9dxU/fYF40lCmb8GtGBHM3B3KpUo?=
	=?iso-8859-15?Q?XJQDFe5KVRMaUT4EJcog7scKs86xSWANpJElqBKTGnwgHLbGmZXvZf9+G?=
	=?iso-8859-15?Q?QMBUGlKC9/GbwXRC3Ei9b9Oplrvw8YNq+/DHp3caFWtaNCCPXpE+pZrlT?=
	=?iso-8859-15?Q?X/Ywpuj3FYoU+FRwoR8+Ubo3wDrJHTlfDbGN0E1mnPp3rKJbLuYDgGwly?=
	=?iso-8859-15?Q?gQh4n5n9gJm5yQdtUnNV9wETLdtcw8yQKxK2oKd58VbPqWEApLSUQgxbn?=
	=?iso-8859-15?Q?mRpAFJeASjfuRme1NI0/Hqm/w+apopiaHqL9eu1ny6cyu1xxups9xUzDa?=
	=?iso-8859-15?Q?s1RpXNaw1/3vn95kkZ8lsZwCWdkAUAQrOpP+Nie2UM8frqNB1dGJSx/4E?=
	=?iso-8859-15?Q?TOQjw+9qdAPOREFoUoyx4jhP1u/VmQvx6wigN1q6rHaLC3UfjevWDPMBY?=
	=?iso-8859-15?Q?ucwWYmBzCzZUdn0rLrcHHO3J1hU1qZehhswbOqsTRtK5J8jE9QWXangX6?=
	=?iso-8859-15?Q?PlYTpvvuoVmTZa2I8wyrWemvdPNY2KJIdRsXc81hE3qnHQoKqV8on68Ui?=
	=?iso-8859-15?Q?voyf7t6xSUpHSPLGuVJSLwaX3Ci3Al7e0Vt8nAdbK4IaZVPTcrZliNXIx?=
	=?iso-8859-15?Q?03MbZuKXiioADHFAV9ZEzXKziNOC4BuXxfHuJTBdimp3YGjufN0aPebkT?=
	=?iso-8859-15?Q?ZdBk7fK4bnM56lFa6nd024egXXMpSH0ZU30TEBgwzhcjLlETETkrYpXUC?=
	=?iso-8859-15?Q?S/GSfbdJEugEYAw+5RDxOh2h2mFzkvbyrBQLhjfMRm1aAyA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a9e91e-395e-40fb-1e1a-08d9ecd91267
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 21:05:30.9504 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQdlXbJ379PjwPMZug+GE7IPGWaaSGtpBmBaGxYAa6Y5ICNtHqJpLsCaaSSUSg0caXHGIuqrg9TTm/oUH6wlDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5395
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AL5fWo008014
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <303C1088C2F8954A88640C91E931AA4D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Thu, 2022-02-10 at 15:02 -0600, Benjamin Marzinski wrote:
> On Thu, Feb 10, 2022 at 05:00:09PM +0000, Martin Wilck wrote:
> > Hi Muneendra,=20
> >=20
> > coverity found some defects in your patch. Please help me review
> > them,
> > see attachment. It's well possible that they're false positives,
> > but
> > please double-check.
> >=20
> > Thanks
> > Martin
> >=20
>=20

Thank you. Meanwhile I figured this out myself, and marked the defects=20
as false positives. I've pushed the patch to my "queue" branch. The
compilation errors have been resolved, too.

> > Date: Thu, 10 Feb 2022 16:50:12 +0000 (UTC)
> > From: scan-admin@coverity.com
> > To: mwilck@suse.com
> > Subject: New Defects reported by Coverity Scan for
> > mwilck/multipath-tools
> >=20
> > Hi,
> >=20
> > Please find the latest report on new defect(s) introduced to
> > mwilck/multipath-tools found with Coverity Scan.
> >=20
> > 3 new defect(s) introduced to mwilck/multipath-tools found with
> > Coverity Scan.
> >=20
> >=20
> > New defect(s) Reported-by: Coverity Scan
> > Showing 3 of 3 defect(s)
> >=20
> >=20
> > ** CID 375096:=A0 Memory - corruptions=A0 (OVERRUN)
> > /multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()
> >=20
> >=20
> > ___________________________________________________________________
> > _____________________________________
> > *** CID 375096:=A0 Memory - corruptions=A0 (OVERRUN)
> > /multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()
> > 155=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > 156=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg =3D calloc(1, sizeof(=
struct
> > els_marginal_list));
> > 157=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (els_mrg !=3D NULL) {
> > 158=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_m=
rg->host_num =3D fc_event->host_no;
> > 159=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_m=
rg->event_code =3D fc_event->event_code;
> > 160=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_m=
rg->length =3D fc_event->event_datalen;
> > > > > =A0=A0=A0 CID 375096:=A0 Memory - corruptions=A0 (OVERRUN)
> > > > > =A0=A0=A0 Overrunning buffer pointed to by "&fc_event->event_data=
"
> > > > > of 4 bytes by passing it to a function which accesses it at
> > > > > byte offset 2047 using argument "fc_event->event_datalen"
> > > > > (which evaluates to 2048). [Note: The source code
> > > > > implementation of the function has been overridden by a
> > > > > builtin model.]
>=20
> fc_event->event_data is a u32, but that's just because the first 32
> bits
> of the event data is the els_cmd, right? The header makes it clear
> that
> event_data actually does hold event_datalen worth of space
>=20
> From /usr/include/scsi/scsi_netlink_fc.h
> -------------------------------------------
> =A0* Note: if Vendor Unique message, &event_data will be=A0 start of
> =A0*=A0=A0=A0=A0=A0=A0 vendor unique payload, and the length of the paylo=
ad is
> =A0*=A0=A0=A0=A0=A0=A0 per event_datalen
>=20
> The only thing that looks possibly suspect here to me is in
> fpin_fabric_notification_receiver() which calls
> fpin_els_add_li_frame()
>=20
> In fpin_fabric_notification_receiver() we guarantee that we read
> enough
> for plen to be correct by calling NLMSG_OK(), and we check that plen
> is
> big enough to hold fc_event before we start using that. After that,
> we
> just assume fc_event is well formed. However we could check that
>=20
> offsetof(struct fc_nl_event, event_data) + fc_event->event_data_len
> <=3D plen
>=20
> just to make sure that we really read enough space for all the event
> data.
>=20
> > 161=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcp=
y(els_mrg->payload, &(fc_event-
> > >event_data), fc_event->event_datalen);
> > 162=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_=
add_tail(&els_mrg->node,
> > &els_marginal_list_head);
> > 163=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthre=
ad_cond_signal(&fpin_li_cond);
> > 164=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > 165=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =
=3D -ENOMEM;
> > 166=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> >=20
> > ** CID 375095:=A0 Program hangs=A0 (LOCK)
> > /multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()
> >=20
> >=20
> > ___________________________________________________________________
> > _____________________________________
> > *** CID 375095:=A0 Program hangs=A0 (LOCK)
> > /multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()
> > 423=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rcu_register_thread();
> > 424=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_cle=
an_marginal_dev_list,
> > NULL);
> > 425=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0INIT_LIST_HEAD(&marginal_list=
_head);
> > 426=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_cle=
an_els_marginal_list,
> > 427=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(void
> > *)&marginal_list_head);
> > 428=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> > > > > =A0=A0=A0 CID 375095:=A0 Program hangs=A0 (LOCK)
> > > > > =A0=A0=A0 "pthread_mutex_lock" locks "fpin_li_mutex" while it is
> > > > > locked.
> > 429=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthre=
ad_mutex_lock(&fpin_li_mutex);
> > 430=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthre=
ad_cleanup_push(cleanup_mutex,
> > &fpin_li_mutex);
> > 431=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthre=
ad_testcancel();
> > 432=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while=
 (list_empty(&els_marginal_list_head))
> > 433=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pthread_cond_wait(&fpin_li_cond,
> > &fpin_li_mutex);
> > 434=A0=A0=A0=A0=20
> >=20
> > ** CID 375094:=A0 Memory - corruptions=A0 (OVERRUN)
> > /multipathd/fpin_handlers.c: 339 in fpin_handle_els_frame()
>=20
> I can't see how we could double lock fpin_li_mutex here.=A0 This looks
> to me
> like coverity isn't understanding that the pthread_mutex_pop(1) that
> we
> must do before we loop is unlocking the mutex.

Exactly.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

