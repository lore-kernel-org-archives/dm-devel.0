Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BDCC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:56:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B35D61502
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B35D61502
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-4l8eyj4CO6WgdcnEiFaAfQ-1; Mon, 08 Nov 2021 11:56:18 -0500
X-MC-Unique: 4l8eyj4CO6WgdcnEiFaAfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C7F9102CB2F;
	Mon,  8 Nov 2021 16:55:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2F08ADFA;
	Mon,  8 Nov 2021 16:55:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D86A01819AC1;
	Mon,  8 Nov 2021 16:55:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8GtmVH006139 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 11:55:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 003E41121315; Mon,  8 Nov 2021 16:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE631121314
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 16:55:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE265811E99
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 16:55:43 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-5-GyZPmjorOd2McL8_ZABZ6g-1;
	Mon, 08 Nov 2021 11:55:42 -0500
X-MC-Unique: GyZPmjorOd2McL8_ZABZ6g-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-R627NOeBMcygv7P-M9n3bw-1; Mon, 08 Nov 2021 17:55:40 +0100
X-MC-Unique: R627NOeBMcygv7P-M9n3bw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6476.eurprd04.prod.outlook.com (2603:10a6:10:104::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15;
	Mon, 8 Nov 2021 16:55:37 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 16:55:37 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
Thread-Index: AQHXxebeV4GFGv0wyUqQuLf4uivcTKv0BbIAgADVtYCAALbYAIAAGUOAgAREaYCAAAcvgA==
Date: Mon, 8 Nov 2021 16:55:37 +0000
Message-ID: <40e458b6a89435469238548fe41a08bad57acad1.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
	<33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
	<20211105214936.GO19591@octiron.msp.redhat.com>
	<c137193a6dbc7ea9ce25d06766874012de2f8ed0.camel@suse.com>
	<20211108162955.GR19591@octiron.msp.redhat.com>
In-Reply-To: <20211108162955.GR19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfd1cc86-3d8b-40d7-ca9f-08d9a2d896ef
x-ms-traffictypediagnostic: DB8PR04MB6476:
x-microsoft-antispam-prvs: <DB8PR04MB64763F1BAB9AB04F398E6A43FC919@DB8PR04MB6476.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 450Jv+g0+5iKM0Bs0bbJmxhTRhbNLjWdacXh+RaNHIoAWu53owfYZNEeYJh3Dh4LT6OxFuCiSGtdKU0SXuPQQwiyMpLJDrTqRaCuXXAV6Ul1/VBwkOgQa9RTpEcJnPUF985aFhDa8uoInzB9+sdXzDHaKhQX72X4XuSSt4olEw3jQUgizrN7CnHynTH0/GQJqcF1nZmbSLHFfjUAmyt8uWoei/x1a2bkDsxBYX6lJetjUgQixZeMM92ldseiguYEOY94G17vx+4XI0Ck5lRYs7W4nsHsUNRzOiBXQsVjUvaY/luZ6Fajj3IhsIKrXjmyayiOIcHQ6CdGnG9XQpeCLkHjPL/y3d7XEHAGtw9jA5baywxJ7HwLu+hN1dMltTAm0vnH2Jlf3hkf3+eCD3kffbiMRHhishL3jGSU2TRxcV0ari4DDx/ovcsMyFi9etLX+zvMsCngkSp/GzwnUcShjduy5RRmsctkuasSQwkhg0d1Y583EKURHqmwGN8tLrcHxhdYT6WeEEyePy2ZKeUv+76OBDV9Ya2UQ9ClAEI7s57rE9Gebn+N3Ikg5o5n98OnaHgwxJuqD4rPTcdJysRVowvkTvzYq6nJNqgn4W80VOYg+7fppXo59kM5jSzsMTfn/YUXFWtf+zgy/uqaBoqw6cGZy1z/jGUGfOHUFKMp53FiijX+lGTN5kvhspW+bMUypvws6kEAMQ5A6tWsH2qGDA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38070700005)(54906003)(186003)(508600001)(8936002)(316002)(8676002)(5660300002)(86362001)(2616005)(91956017)(76116006)(6506007)(6512007)(71200400001)(4326008)(6486002)(66476007)(64756008)(66446008)(44832011)(6916009)(66556008)(122000001)(66946007)(36756003)(2906002)(83380400001)(38100700002)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?rfhdesc0BzMHu+na/Z2docLiuc6ljSdY97lwKOSqpJiOQ9uMUDo9nqtTK?=
	=?iso-8859-15?Q?47g7oyE+/255LAU25uyXeDU6F096LUT/KSlC0Eugv95nIQhz4QH1GtuVn?=
	=?iso-8859-15?Q?IQRl3dyJ5WooZOIrzC0bFMYEq/AonISMcF/mqjLoevMp/sbmdEQ0/9I9f?=
	=?iso-8859-15?Q?Kg9HrZf9u6vxe+9isty85kWmtFbvw6GlScaCSi+Z5oMrSe8fRabLUD8uW?=
	=?iso-8859-15?Q?+wKkJmBhZoI8L7uhdDxdkLulySFBZvfmt9bwyc/w7hVsZ25gK0F6kTsv2?=
	=?iso-8859-15?Q?EYlRt/+wnqOuYaPJbTFplgu7OGECNYBvIOcadK7lwnuzOSbMGc9Lo4zzz?=
	=?iso-8859-15?Q?NPf5KjvkAWO7GuOpkoyZP4se2geZvpbyq+qM4BXT+FfMN7yVy6Bxqz1XD?=
	=?iso-8859-15?Q?B4AAHf4JauC8J6pLq31pGYAr1hAfhm/rcnVjTYgiyXyPPjYVja5UQJPmP?=
	=?iso-8859-15?Q?9DGDzJhUSVPsUrN+hlwvljrjbcMevsBQxQGtqjd8/gzFKJClURQ8iggX0?=
	=?iso-8859-15?Q?gtwi+eE8ez63Ddawt4xiwdAwnDMsqSg5Mx0S9YvvQRe80D0+Ywv+JLO6e?=
	=?iso-8859-15?Q?FEfUZU2qKPzTOfricXVoUY7jD5j2SIxMioek5tdf+OHrgA2RC61aLtgoW?=
	=?iso-8859-15?Q?ttvTnYzMkFKzSj94Yf+eVW2sX1xKhtkDdJy7JgZ4tjwh1QxYaGoA7M/Zp?=
	=?iso-8859-15?Q?uMEzb1ejXDR+gwYEVcoNVOmq/sjLL07/HhaVx/HzQtAmngGQqeWdO13zF?=
	=?iso-8859-15?Q?Rxgeg6x6dS8d8BA82OL3Tre1lceDmhhfMIYqPhp12uhT/pzDj5UsednSj?=
	=?iso-8859-15?Q?m3uBSENm2im2N88KjHDeHesTIhnydR9wVuSCCiFwe6oC7uPQ+LtZvVHcC?=
	=?iso-8859-15?Q?BU29pUUF9U2ZRTWqt6ZifitZ+K/7P3sRw37EJZFdqJoEWP/m5YRbyy/eb?=
	=?iso-8859-15?Q?/owefceWnF7uNxznBbOZArL9bQehYcYQ/3TYC+ph6NTMQWd0WnwUaUoK8?=
	=?iso-8859-15?Q?Ejawd7r/2NzshTghDedJt7vxocmiM2RUDmxkthTH160zPXr4eof2HKHpi?=
	=?iso-8859-15?Q?bpyrmhIh8m86UJpaYxTOyEY58yUOdxK2V+W9ZGoUrC7CN90wVYk3MNleA?=
	=?iso-8859-15?Q?iFPunSfxxLVOGlvmK5RWrCvvMz3TFVt2YE97m1GvoslqmCMl9jmv6Up7N?=
	=?iso-8859-15?Q?wZD4CTvvEhgiCJvY/1tZl7D2sTA2oDZ94ZlVAQZwpZ4tt6+TM02pU0a7E?=
	=?iso-8859-15?Q?Jow6Uw6Vsso7Zd4PJYVaaejLof1vJwSHDNNX+hdOlG12siN2wyY4a9yI8?=
	=?iso-8859-15?Q?Wf3aDSRHdizs8k7lkNw4q+kgX3qox3xjpmNlmz64arRdbAs9rgyJ3jT/F?=
	=?iso-8859-15?Q?85hsvlkmxWQxFozQ5pTfAaO27mHfq/CiJCML1cX9B+17ScJHJhYAhlqEz?=
	=?iso-8859-15?Q?rOMrlIbedwwMxADo2d8zDBDpLVN/Rb1kb+x2PTx/GnDjVXDECWGEewSr0?=
	=?iso-8859-15?Q?DkSQwDGEIBbigdQA07SWEeqZVamiexO+/rOHHYQdkR8RB1ve993j3YyZ+?=
	=?iso-8859-15?Q?lXpvLRqIY6t944fNAQjrz9+4imPs/8yuijHO0wYsCaMiHvhJA/ym090Ro?=
	=?iso-8859-15?Q?jjmQlxfq/Be4nrcRRihilq97mYtC2ZaH5atQVm9zncZ02ZvoPMFsuoOmT?=
	=?iso-8859-15?Q?fOLFm0yOfTVxHmHoRx8gcUFH8b1YCpv4MwwuCdlIpZ2YIhg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd1cc86-3d8b-40d7-ca9f-08d9a2d896ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 16:55:37.7849 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U//twXg3NoaJNIiM7nrVju+QVhx4HTzKMg12VeQczcEViRxpvM+RHszX8fvyPnkdKseBkeFR5xY/npRZdApIKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6476
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8GtmVH006139
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
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
Content-ID: <D459AAD80A422A468806D29214E1CC4F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-08 at 10:29 -0600, Benjamin Marzinski wrote:
> On Fri, Nov 05, 2021 at 11:20:01PM +0000, Martin Wilck wrote:
> >=20
> > If I run "udevadm trigger -c change /dev/sde" in this situation,
> > I'll
> > get the full info, as if I had run "add" before (some rules may
> > differ
> > between "add" and "change", but that's quite unusual).
> >=20
>=20
> udev rules may not change much, but, for instance, multipathd reacts
> differently to add and change events.=A0 So there may be other
> consumers
> of uevents that care about the difference between add and change
> events.

Let's send "add" then. It makes sense if the device didn't exist
before, after all. When we trigger, we don't know if an "add" event is
already under way, but that's just how it is.

> =A0
> > >=20
> > > > Also, we currently don't track the udev state of=A0devices
> > > > cleanly.
> > > > We
> > > > set INIT_MISSING_UDEV if we can't obtain uid_attribute, which
> > > > doesn't
> > > > necessarily mean that udev is unaware of the device. I believe
> > > > we
> > > > should e.g. check the USEC_INITIALIZED property - it is non-
> > > > NULL if
> > > > and
> > > > only if the device is present in the udev db. If uid_attribute
> > > > isn't
> > > > set regardless, we could conclude that the udev rules just
> > > > don't
> > > > set
> > > > it. It might make sense to retrigger *one* uevent in that case,
> > > > but
> > > > no
> > > > more.
> > >=20
> > > IIRC, the initial reason why INIT_MISSING_UDEV was added was
> > > because
> > > sometimes udev workers timed out, causing them to not run all the
> > > rules.
> > > Do you know offhand if USEC_INITIALIZED is set in this case? If
> > > we
> > > could
> > > differentiate between the following states:
> >=20
> > udevd sets this property very early, when it first receives an
> > uevent.
> > But libudev calls won't return it until the database file is
> > written,
> > which happens last, after all rules and RUN statements have been
> > processed, _in the worker_. Thus if the worker is killed, the file
> > won't be written.
> >=20
> >=20
> > 0. the device doesn't exist in sysfs=20
>=20
> We simply delete devices that don't exist in sysfs, right? If we get
> a
> non-remove uevent for a device, but it doesn't exist in sysfs, then I
> would assume that a remove uevent will be shortly incomming.

True, but still it's one possible "state" the device may be in. I just
wanted to mention that.

> =A0
> > > 1: udev hasn't gotten an event for a device
> >=20
> > I don't think we can detect this without listening for kernel
> > uevents.
> > And even if we listen to them, we could have missed some. udevd
> > doesn't
> > have an API for it, either, AFAIK.
>=20
> Isn't this the most common INIT_PARTIAL case, where we are waiting
> for
> the coldplug uevent? If there is no database file when we are
> processing
> the device, we are in this state. Correct?=20

Not necessarily. udev may have got an event, but not have finished
processing it, or failed to process it entirely (e.g. because of a
timeout, your case 2.). When udevd sees an "add" or "change" event for
a device for the first time, creating the db entry is the last action
it takes. During coldplug, udevd will receive a lot of events almost
simultaneously, but it may take considerable time until it has
processed them all.

> > > 2: udev got an event but timed out or failed while processing it
> >=20
> > This would be the USEC_INITIALIZED case, IMO
>=20
> If udev has, in the past, successfully processed an event for a
> device,
> but fails while processing a later uevent, it doesn't keep th data
> from
> the previous event. So it could lose the uid_attribute. But the
> database file should still exist. Correct?

That's true. But we can't do anything about it. libudev will return
what the database currently contains, which is the content from the
last successfuly processed "add" or "change" uevent, whether or not
other uevents are in the queue or being processed. I don't think this
scenario matters in the current discussion about partially initialized
paths. This is the "changed wwid" scenario which I think we handle
quite nicely today already. Or am I misunderstanding?

Cheers,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

