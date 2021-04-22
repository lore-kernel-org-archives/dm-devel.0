Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B09C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 09:07:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFEB5613F0
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 09:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFEB5613F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-UUnI5OM5M22VhhXNAjXJlQ-1; Thu, 22 Apr 2021 05:07:39 -0400
X-MC-Unique: UUnI5OM5M22VhhXNAjXJlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7552107ACF6;
	Thu, 22 Apr 2021 09:07:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A0F75944F;
	Thu, 22 Apr 2021 09:07:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 013D78C06;
	Thu, 22 Apr 2021 09:07:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13M97RFg000780 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 05:07:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 54B3020BDB22; Thu, 22 Apr 2021 09:07:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E9E520BDB20
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 09:07:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FAC285A5BF
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 09:07:24 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-98-tN3DuWu5O_q6ZoANx73gqQ-1;
	Thu, 22 Apr 2021 05:07:22 -0400
X-MC-Unique: tN3DuWu5O_q6ZoANx73gqQ-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-BsZYUbIvPCWRy6AnzARlkQ-1; Thu, 22 Apr 2021 11:07:20 +0200
X-MC-Unique: BsZYUbIvPCWRy6AnzARlkQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6153.eurprd04.prod.outlook.com (2603:10a6:10:d2::21) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21;
	Thu, 22 Apr 2021 09:07:16 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4042.024;
	Thu, 22 Apr 2021 09:07:15 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXJIIevKqEvjcbJUy9Ai14uQzKmaqm92EcgBDwGwCACBMFD4AAakAA
Date: Thu, 22 Apr 2021 09:07:15 +0000
Message-ID: <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9da11e97-b9ac-4bf5-3843-08d9056e064b
x-ms-traffictypediagnostic: DBBPR04MB6153:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB6153FDBBFC0F29868AA55548FC469@DBBPR04MB6153.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qHfcgIIxtxzkZheR0puwFjfzXWJbgeiJ+nqBexHvce/Vo1rORzXq0y5eXnZQcSsp+9JtbPEFi2y4L965cmAEU/1f44q1ZmzsEkM2oFDmRUCACA9kvbm2/iuNvuHdobBXFEh80mnBuIaClVm4RYV0j0zHWoOHO/g6mUIYtmKbnxHbZYpvxQ2oB4nuUgu9Gw7W/gozwelc46AGXm+eDlfXxMWs9FUl9zSm1rV7dHbDaC5YMgxtoAqqNZgwxrwCxDgaE56uuqT4CFqh0Q5xN+nHy7x+2jl9J08QmI6YhXJPMyf/U/mYhlj2KyLhlFz3Mn/P75/cXH2cnXTfM5+RS+oRhXEwG0E9TH0SQu4gr0wAAu+qq7DaC6KrKxfLmGNACi7YBSiErzXZnWgtdSrTRidD6o9DA8OIJEscnmm1AV2oYjNdBnOIMZ18hZ/Hok56b72+Z6lyyDhcoJ4jIjgiHmxb9MkQzfnySCjgb0jQ5uLWENuiiobtSTg9aA5Qo4VDbefobR92P8z7kwi8HJqsksGFJUhB5H1MTBj9obbeUW8GFZPRr14WgSBO4AlSpRRJYWp1Xrb8o9yeOdQuLqUCe/FqK3ymORaabBW4skv7j8+869NRP+0DfsxTrl1dPOab/vwY3j87Adz0xeSvnoJ2NSWMNNBC6iTpbOvx01CvRDpy3kv13DR+yP8DexN12wvuwca4
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(4326008)(8936002)(186003)(5660300002)(6916009)(66446008)(66556008)(66946007)(64756008)(66476007)(122000001)(71200400001)(38100700002)(2906002)(6512007)(316002)(2616005)(54906003)(6506007)(66574015)(26005)(478600001)(36756003)(6486002)(86362001)(44832011)(76116006)(8676002)(83380400001)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?KS15n3OpZf90lpdta7qsy0biVVIYFuL+nraZd90GEQpRfqKNd/pAdk7GL?=
	=?iso-8859-15?Q?BRcns6S9R4xAp1Efj9iPOJhwqQcYgT3yCFR5R/Sm5IQlmUhrx2ZZV2mS/?=
	=?iso-8859-15?Q?Xy4wvXkBP0CBBbQ4eF3ddNkaIixbCLaSHiqBgFEDpRC9+3W1sNKuNq9Y8?=
	=?iso-8859-15?Q?chfB7E5nJDsD0qKyv4pr8tKrrLYgATYNOjdtrXl6ewQe1AczPtMyKup3c?=
	=?iso-8859-15?Q?zpW0UxaQY7jUeuGsj2vbiK3ovawMTK3qq2nmAlu25SOki4Q19rXgeZwBh?=
	=?iso-8859-15?Q?rFqjOC6HY3p5+A+1GMSVYd+yAceYWyEe+/AZzpTM5ciqZpevpAzItXtnx?=
	=?iso-8859-15?Q?rJXFsiV8bldcXhbMVS9Zzq10/PMSHAl/1zJUDUSIWKDwig7nmYJ87IBx3?=
	=?iso-8859-15?Q?fOXYP3Ufk3AIfS5ab/jwGMBqYFJ+cwMeGim08sU+0vLvkZwpYffnpxiAC?=
	=?iso-8859-15?Q?D/OWJ56bibJBaw/atvdK4NAJDbXfNmGFLxsclAw9B7Oj9ivm9y3mkYw29?=
	=?iso-8859-15?Q?vRBaXu3KE98wpxiXv47olcvIJAWJKIZawUf//Q+RUoUj1c+HxqRghmjZK?=
	=?iso-8859-15?Q?oei/flBW6S8O7yAoDAb4k8I5UcT8FYYliRRhuff7VKYCNp9RO2VHVv9Ul?=
	=?iso-8859-15?Q?qm5ElbLnyALPNHga9oi9WOZVZBtg23S56bG/sdpSobMEy7pHeVT0UN4LS?=
	=?iso-8859-15?Q?YqKicjBN3lnU4FXrssezEiP7S4ElMTqFc5U9e0141JFbOFlUD9gU0ptt8?=
	=?iso-8859-15?Q?A9kFjAY/jJWnDghkQnI2UyGwRX5jIRtvjFniGW60laVTwjTNchr7gp+G8?=
	=?iso-8859-15?Q?KhWsMu56ePiHtbDCDnzhOAZ7WQeutvtWTYXUx/JLdI7e8cRvA09+fnUSt?=
	=?iso-8859-15?Q?vsHUOZdSad9QV8yzNi2qZ25C5Tl6p4PQBdybCQR/4ZucjE6kYTgPBXmzE?=
	=?iso-8859-15?Q?YzB9Rein0KBbv2LkHrGFuFTDz2kPUcE9DWW16rtelDegUogKl5vrsK8u4?=
	=?iso-8859-15?Q?iCbvS5qQN0XiaqeVBgcAr3enrmUYa1ZfLJnlBIckGlgr26WJR0Gceiawc?=
	=?iso-8859-15?Q?akmduxjLFT8l/RFPJyCJoZqlkFmALLIMma3M+wwp0DKRcrylBNDus1Uhr?=
	=?iso-8859-15?Q?WbsVRj5s8iFxdnuN3081jR/38eGiof5sGHedBJ9WXlvSW6nrAhWUdNgNx?=
	=?iso-8859-15?Q?KwKlo/Z3AV+pRXx7P512QKpRgCu+jPJ6dKBv9dDzu2K5Y8F8oraLY6B7R?=
	=?iso-8859-15?Q?ed+0OcbLhkh1Fz0z7vLVgqrBLKS6meACWO0R2ptovCEYaz4ksZbSZ+yCz?=
	=?iso-8859-15?Q?NNnKRFLAQrxvwrCQB8IkMGg/HIcxSrzQQvc7e1hxDDkqWEKpqFK0luqT6?=
	=?iso-8859-15?Q?mEn0rWgVXlP4OsZnxDt3ivGUFnKxYevNm?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da11e97-b9ac-4bf5-3843-08d9056e064b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 09:07:15.8680 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5bB/yiIkWddIne4G4cWQNG5KExSgIzmnnSdNksgDO98vNS7wPLxk7tjSSh8GEwaPDkDpUJpP2ufEw2DKYA4u9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6153
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13M97RFg000780
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AACB99A3887C604A845A8FA4329A4B20@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-21 at 22:46 -0400, Martin K. Petersen wrote:
>=20
> Martin,
>=20
> > Hm, it sounds intriguing, but it has issues in its own right. For
> > years to come, user space will have to probe whether these attribute
> > exist, and fall back to the current ones ("wwid", "vpd_pg83")
> > otherwise. So user space can't be simplified any time soon. Speaking
> > for an important user space consumer of WWIDs (multipathd), I doubt
> > that this would improve matters for us. We'd be happy if the kernel
> > could just pick the "best" designator for us. But I understand that
> > the kernel can't guarantee a good choice (user space can't either).
>=20
> But user space can be adapted at runtime to pick one designator over
> the
> other (ha!).

And that's exactly the problem. Effectively, all user space relies on
udev today, because that's where this "adaptation" is taking place. It
happens

 1) either in systemd's scsi_id built-in=A0
   (https://github.com/systemd/systemd/blob/7feb1dd6544d1bf373dbe13dd33cf56=
3ed16f891/src/udev/scsi_id/scsi_serial.c#L37)
 2) or in the udev rules coming with sg3_utils=A0
   (https://github.com/hreinecke/sg3_utils/blob/master/scripts/55-scsi-sg3_=
id.rules)

1) is just as opaque and un-"adaptable" as the kernel, and the logic is
suboptimal. 2) is of course "adaptable", but that's a problem in
practice, if udev fails to provide a WWID. multipath-tools go through
various twists for this case to figure out "fallback" WWIDs, guessing
whether that "fallback" matches what udev would have returned if it had
worked.

That's the gist of it - the general frustration about udev among some
of its heaviest users (talk to the LVM2 maintainers).

I suppose 99.9% of users never bother with customizing the udev rules.
IOW, these users might as well just use a kernel-provided value. But
the remaining 0.1% causes headaches for user-space applications, which
can't make solid assumptions about the rules. Thus, in a way, the
flexibility of the rules does more harm than it helps.

> We could do that in the kernel too, of course, but I'm afraid what
> the
> resulting BLIST changes would end up looking like over time.

That's something we want to avoid, sure.

But we can actually combine both approaches. If "wwid" yields a good
value most of the time (which is true IMO), we could make user space
rely on it by default, and make it possible to set an udev property
(e.g. ENV{ID_LEGACY}=3D"1") to tell udev rules to determine WWID
differently. User-space apps like multipath could check the ID_LEGACY
property to determine whether or not reading the "wwid" attribute would
be consistent with udev. That would simplify matters a lot for us (Ben,
do you agree?), without the need of adding endless BLIST entries.


> I am also very concerned about changing what the kernel currently
> exports in a given variable like "wwid". A seemingly innocuous change
> to
> the reported value could lead to a system no longer booting after
> updating the kernel.

AFAICT, no major distribution uses "wwid" for this purpose (yet). I
just recently realized that the kernel's ALUA code refers to it. (*)

In a recent discussion with Hannes, the idea came up that the priority
of "SCSI name string" designators should actually depend on their
subtype. "naa." name strings should map to the respective NAA
descriptors, and "eui.", likewise (only "iqn." descriptors have no
binary counterpart; we thought they should rather be put below NAA,
prio-wise).

I wonder if you'd agree with a change made that way for "wwid". I
suppose you don't. I'd then propose to add a new attribute following
this logic. It could simply be an additional attribute with a different
name. Or this new attribute could be a property of the block device
rather than the SCSI device, like NVMe does it
(/sys/block/nvme0n2/wwid).

I don't like the idea of having separate sysfs attributes for
designators of different types, that's impractical for user space.

> But taking a step back: Other than "it's not what userland currently
> does", what specifically is the problem with designator_prio()? We've
> picked the priority list once and for all. If we promise never to
> change
> it, what is the issue?

If the prioritization in kernel and user space was the same, we could
migrate away from udev more easily without risking boot failure.

Thanks,
Martin

(*) which is an argument for using "wwid" in user space too - just to
be consitent with the kernel's internal logic.

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

