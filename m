Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B69C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 20:47:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-Y9eLaiABPL68tzsc9tRVHg-1; Tue, 12 Apr 2022 16:47:52 -0400
X-MC-Unique: Y9eLaiABPL68tzsc9tRVHg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10B151C04B7E;
	Tue, 12 Apr 2022 20:47:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AEC2B401DFF;
	Tue, 12 Apr 2022 20:47:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 661CA1949763;
	Tue, 12 Apr 2022 20:47:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 400F01947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 20:47:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B1FB40CFD21; Tue, 12 Apr 2022 20:47:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 15C7140CFD1E
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:47:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA42D85A5BE
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:47:46 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-K-vnzQyQNUOooijqSh-eAA-1; Tue, 12 Apr 2022 16:47:45 -0400
X-MC-Unique: K-vnzQyQNUOooijqSh-eAA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2109.outbound.protection.outlook.com [104.47.18.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-qPJe0EMoPFaltFW9pjkiMg-1; Tue, 12 Apr 2022 22:47:39 +0200
X-MC-Unique: qPJe0EMoPFaltFW9pjkiMg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB8PR04MB6650.eurprd04.prod.outlook.com (2603:10a6:10:10d::30)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 20:47:38 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 20:47:38 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 0/9] Add protocol specific config subsection
Thread-Index: AQHYThEKdbrAhr5xHE2kaVKyN3MnN6zsn24CgAAhhwA=
Date: Tue, 12 Apr 2022 20:47:38 +0000
Message-ID: <92f53b4d9679a2d958643fe3cc72a09bda4c73fb.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
 <20220412184728.GF24684@octiron.msp.redhat.com>
In-Reply-To: <20220412184728.GF24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96e9211c-ddc9-4aab-704b-08da1cc5ae6e
x-ms-traffictypediagnostic: DB8PR04MB6650:EE_
x-microsoft-antispam-prvs: <DB8PR04MB6650348F390B36CCC7FCBEB3FCED9@DB8PR04MB6650.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: u+hoQgvqUo6oTfcCjSK+G9kUo6mdi2iZXN3VsSu5oLmm+3qcUEHjgLBZynF6ULP3bNNdYVsthrfpdOcLeJW6HdTtLP7OTuDDBTlNAc2OH8cofc0wdfdJjBQgqgCgxrxHVxiZN+p8SnqUJZgMcxT63veARvGhWf3cmE7OOQKOw0mdW/pnw+w9qnSwaLzLuggszhZmJVlNaOnofBZIIvmoNdB3yCokSUO1dvQ7rTfD+W0s0ZWJgGuZlofbz2quyKa4G3/4s6yBjxWwEJXcwPi7FCqENrAZQ1beQevLokgNdiy+T9jle3yUAXKvtCk8zr0jr3bhpcwWj/IyHiuJVudD1ByN5HApBEATANKh7RYq5NzoBsBLXBeWJgRRDtZK+m31AcuQEAuTeXXX4s7JNBJafGQDZLozFoPHY5/7fBT0Nr/kL6fzVOA1uE31thuo9ttfzNnpDc6c3klUA3l+W7qJYg4cHCdotQPn4XNMEniSEVxQlVqM16PotNzO6TLJArfWqxVV4Zgo53YFD6exSyBLK8e++pIQmzYe+QihjK1Z2X3M9CKsN95bOcu4XSAi42XovnfnHJgigrP5AODzixhQ/XiTqrcX+aBqMABl7tUOrHYS3M5CW2hmZRCzOI/dHCQeQ/v1VUuZrctsPZJNmHP8vizaxqS4+6aD5IbPYG3tIABs2niWsFa4cOHQExj3HUSQUba1zXsRh68W0tU69G5pjw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(36756003)(6916009)(2906002)(8936002)(6512007)(54906003)(86362001)(508600001)(316002)(38070700005)(38100700002)(6506007)(44832011)(91956017)(186003)(76116006)(66556008)(66446008)(64756008)(66476007)(8676002)(2616005)(66946007)(6486002)(71200400001)(5660300002)(26005)(4326008)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?6AmsURw174V7TD+RBPtIRTj2rY6hvP5V8fykpg6ocaqMaOvOn+K6c569c?=
 =?iso-8859-15?Q?kMVPCGciSxXvOsz7m42Uuv8rX2EZsatd0oJ+LKAGQryVUJtxBA5G4a7NI?=
 =?iso-8859-15?Q?H2Q5xHRBKO1LIHSkoplf0BPofvMIezciwdbOoEFHQHe5RudXeuOHmUv+Z?=
 =?iso-8859-15?Q?WDgkU/ZtCX1uVxAAmPbAljKQcjFnN/QhQwwQI0+mcfBQSMI4Z9KwwgSuZ?=
 =?iso-8859-15?Q?aIT4hAZKf3ASZr5DWcwXpNTi7SvKo6RjA18Y8uR1uGqyVksMYb9I87p2Q?=
 =?iso-8859-15?Q?BJ6YafEnq8AurP+/fATt1Yk4iqV4BsN7ysqHiTv6/G0QIqAwCTQKU0pNG?=
 =?iso-8859-15?Q?7B3gTujSLDXvyHp3PyEMW0YLCC5zVDT4N6a0xmmh/P88ElF1iIuh8jq1J?=
 =?iso-8859-15?Q?D5wCZDTywS5uLnZ65my4SHWTxCil3rmDy8wslrlGE9+Vfdure+mkObuqS?=
 =?iso-8859-15?Q?RWguwJANXEMZ6cq+KV5+AmJfqk9FVp3ms1EAoJlXqCccFioL8RneKexLP?=
 =?iso-8859-15?Q?lN+RDyjnmWU4YMYV4CDmHGLbo3a7HDSmi0h/Ro8ckffWk6nnDh4xmmyTy?=
 =?iso-8859-15?Q?+dVVb1E5/De6wFDYRKay0t4mbvN5sFAdfSvRaYc5x9FFVGJyAoMK6c6AV?=
 =?iso-8859-15?Q?OMUwWhVj1GBZ3CskcZPygRXi84Vl6pyj9dW9rZ7TWIIVMOsPIPvDPk3v9?=
 =?iso-8859-15?Q?JWtdZOk/KpbnSVuetlSsmBk6ekAcMwcLX87/Ak8wtet58DHUiT4/Vj3n7?=
 =?iso-8859-15?Q?95xHvpsdHeLzGgH2295Y3kOf3YXKaeoZrE2HtOs/BmrpBOoA9mBYTkoJb?=
 =?iso-8859-15?Q?zLJalCJHY46S+uwrnbJv/2/WSw4jX/PZUyKsRGD8a7lHaTjsotVxC0E08?=
 =?iso-8859-15?Q?aEIx9H6svS9XASAZ8aDB2qf9jtssKYO9bhku2rR+sRv72xRLDqaWaxF79?=
 =?iso-8859-15?Q?zKETkWTAr8uyJlSFSOZMkrd7Kt2X+TxSm0lb68fyscu088diZuuFJF4qB?=
 =?iso-8859-15?Q?mYpv4Z0bPXue2JnJOXV13gr8BKVIubDdsbCg57XSzht+PPViIz8mLrS5u?=
 =?iso-8859-15?Q?/lRryzSp53YM6W1ADLevKpFhQzUTVBQN+ezZGuVxB190QxE1amhBY3f1b?=
 =?iso-8859-15?Q?E2kMYha1+Qf02FiO0n4qMHP9YCF2Ahtwk3Vb5qAsGpNXgLh/E7CgcTK0u?=
 =?iso-8859-15?Q?1St/2m4hNzAQi9+ZCNB5nXJlg+yxj6vKPo5Vd7Quas+TSl5ZuYikESCQv?=
 =?iso-8859-15?Q?JVmbM73XGnHNRF6DhK5as317UTC6QEPk8IKWfCM47nefIC6QDW3BZCTN4?=
 =?iso-8859-15?Q?FssI003G+bBbUEW1nhndVTQlA3ZlFN7QRT0nLdYhOZqOjPm8+hNQl5I6P?=
 =?iso-8859-15?Q?8GyiU951gkCKrRyaMKuWaf+8rqv2Rn0GBN+Ko2I8fdj8R1nMtHBuQt38T?=
 =?iso-8859-15?Q?pF/oet5hnS00I4n0kiWJzNGSjNd385sFOEINwms+CjRdWik+q/5TTg7cs?=
 =?iso-8859-15?Q?CmFM3tYAa0q3jK9nFYd0da7XiZR+kZnHeImRfmVyJpzVx/3xO6ce09+EJ?=
 =?iso-8859-15?Q?uMXOsMdFW3D674Ct1MpyCayDJq+DmAJzPG9q7Iyd/Hu/ugq7OqvLySmkw?=
 =?iso-8859-15?Q?qssqSejmiHpe4wDFTLZejGBULV5NqB7XPq/2hmOorJI+VStQdnMHYSDwI?=
 =?iso-8859-15?Q?P8haMZFoLg6ZRR0OmjfO8Or0qM1qsO9i94hGNMMJgxuDmq1BEUCm+1wjT?=
 =?iso-8859-15?Q?M3nkIHkzqw5SxHuoCcspwifh9boSAxeNLzsl6dvhjp6HMoSX+ZUqF+x33?=
 =?iso-8859-15?Q?PMS6xysGhObDGCVFP6CPwqO0V1Z3D6yDrYYjxsj5Ko6wZQkb4sHDu6keM?=
 =?iso-8859-15?Q?D7Mw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e9211c-ddc9-4aab-704b-08da1cc5ae6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 20:47:38.5861 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NGNVvF1PWzDOX5gB9IRwEVOvdOXFsb5t3nuHJmcyGeUfgRk8KIFHdSanuv2HcaTc8++Vq4ZSNpEC+ZLtywUYiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6650
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 0/9] Add protocol specific config subsection
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <81139F85886CB142976EAEAA3BA253AC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-04-12 at 13:47 -0500, Benjamin Marzinski wrote:
> On Tue, Apr 12, 2022 at 10:31:50AM +0000, Martin Wilck wrote:
> >=20
> I agree that setting fast_io_fail_tmo to different values based on
> both
> array and protocol is usually overkill.

If we doubt that there is a serious use case for this level of
differentiation, I think we shouldn't implement it. Doing that would
violate the KISS principle.

> >=20
> > What about adding simply adding "protocols" as a new top section in
> > the
> > conf file, and have the per-protocol settings override built-in
> > hwtable
> > settings for any array, but not explicit storage-device settings in
> > the
> > conf file?
>=20
> I'm not really enamored with the idea of only working on the built-in
> hwtable.
> I feel like the people that want to tune things based on the
> protocol are the same sort of people that want tune things per array.

Hm, maybe we are misunderstanding each other. Let me give an example
what I meant. We've got dev_loss =3D inifinity for ONTAP in the builtin
hwtable. My idea would be that users could override this in the
protocols section for all devices using a certain protocol:

protocols {
    protocol {
    =09type scsi:fcp
=09dev_loss_tmo 120
    }
}

This would take precedence over the built-in hwtable, but not over an
explicit config file entry:

devices {
    device {
        vendor NETAPP
        product LUN
        # With the dev_loss_tmo line below, RDAC would use 300 for
        # every protocol. Without it, it would use 120 for FC and
        # "infinity"=A0for other protocols.
        dev_loss_tmo 300
    }
}     =20

Admittedly, the problem on the implementation side is that we don't
distinguish between built-in hwentries and those from explicit
configuration. Changing this would be considerable effort; perhaps more
effort than what you did in your patch set. I haven't thought it
through.

> More importantly, we don't have anything else in multipath that only
> applies to some of the device config entries. That change seems more
> confusing to me than adding a new subsection.

The main change would be to differentiate between built-in and user-
configured hardware properties. I hope most users would be able to
understand the concept.

>  The protocol subsection is
> visually part of the device config it is modifying. A separate
> protocol
> section that only modified some of the device configs
>  seems less
> obvious. Plus we don't have a good way to code that.=A0 Also, what
> happens
> to merged configs, where some of the timeouts came from a builtin
> config, and some came from the user config.

To clarify once more: this is what I meant, built-in configs would be
overridden, user configs wouldn't be. This is different from
"defaults", as "defaults" don't override hardware-specific built-ins.

> =A0 If you are really agains the subsection idea,
>  I would rather have the protocol section override
> all the device configs. Users would need to be o.k. with picking a
> protocol for which all their arrays have the same timeout values. But
> again, that should be the common case.

The question is whether a "protocol" entry should override device
settings, or vice versa (as in my hypothetical ONTAP example above). We
seem to agree that that device subsection would implement a level of
complexity that hardly any user needs. If this is the case, we'd just
need to determine the precedence between "devices" and "protocols"
sections. If we determine that "protocols" should always take
precedence, we might as well allow it under "overrides" only. We'd need
no "protocols" section in that case, and no differentiation between
built-in and user-configured hwentries.

> > [1]: wrt dev_loss_tmo, I tend to think that the best value must be
> > found based on neither protocol nor array, but data center staff.
>=20
> I do agree that fast_io_fail_tmo and eh_deadline make more sense than
> dev_loss_tmo (especially since FC/iSCSI setups seem the most common,
> and
> iSCSI doesn't support dev_loss_tmo), but since the section is there,
> and
> dev_loss_tmo is a per-path timeout setting, I put it in.
> ...

I'm fine with treating dev_loss_tmo as a protocol/path property.

> > [2]: I strongly dislike "overrides", in general. I wonder what we
> > need
> > it for, except for quick experiments where people are too lazy to
> > add
> > explicit settings for devices and/or multipaths.
>=20
> The biggest reason is that some of the builtin device configs do
> things
> like set no_path_retry to "queue".=A0

You don't need to use "overrides" for that:

devices {
        device {
                vendor .*
                product .*
                no_path_retry 75
        }
}
You can follow up with more device entries that define exceptions for
the general rule above. Am I missing something?

AFAICT the only thing you can do with "overrides" but not with the
trick above is override actual hardware-specific user configs, and I
have a hard time figuring out why someone would work out detailed
device-specific configs just to override them again with a big hammer.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

