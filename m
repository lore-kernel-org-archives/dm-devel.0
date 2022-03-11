Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C723C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Mar 2022 10:21:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-ZMEgNjEuPru7JjQxX-TTCQ-1; Fri, 11 Mar 2022 05:21:43 -0500
X-MC-Unique: ZMEgNjEuPru7JjQxX-TTCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7107296A63B;
	Fri, 11 Mar 2022 10:21:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C01B81402408;
	Fri, 11 Mar 2022 10:21:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96B4B1949763;
	Fri, 11 Mar 2022 10:21:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE3721949762
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Mar 2022 10:21:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68C72566B11; Fri, 11 Mar 2022 10:21:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63CB942D3C7
 for <dm-devel@redhat.com>; Fri, 11 Mar 2022 10:21:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4495F3C14CCA
 for <dm-devel@redhat.com>; Fri, 11 Mar 2022 10:21:36 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-WoitlnZqOfuPjXVionnDXA-1; Fri, 11 Mar 2022 05:21:34 -0500
X-MC-Unique: WoitlnZqOfuPjXVionnDXA-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-j8g1GrgDOEWZmga0nDkuHQ-1; Fri, 11 Mar 2022 11:21:31 +0100
X-MC-Unique: j8g1GrgDOEWZmga0nDkuHQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 10:21:29 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::704d:a0a6:61ec:8f80]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::704d:a0a6:61ec:8f80%3]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 10:21:29 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/2] multipathd: don't keep looping when config is delayed
Thread-Index: AQHYNOwN/QkvzU+7Ek2xSxBexklKa6y5+bCA
Date: Fri, 11 Mar 2022 10:21:29 +0000
Message-ID: <d7f3a8ffe6fc59195beda878e59389c4a546dad9.camel@suse.com>
References: <1646964130-21800-1-git-send-email-bmarzins@redhat.com>
 <1646964130-21800-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1646964130-21800-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3faf877-8b60-423d-185c-08da0348e85d
x-ms-traffictypediagnostic: AM0PR04MB5443:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5443ABBD5882383715DD61AAFC0C9@AM0PR04MB5443.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4eC1/A1FjlsyVCZN/jguXixhWK8z1Ll0/BSfqsezzoHBArmbC2Im+2FCWOZtEq9Q38CmxzCNlp3W3mah5Y2Yiog/evdsBPHyH+G+cWuu7Tyxs4GM5immF8YogmW4iVbcOJZ5Mkczu5V5KL7DqhIsRD7fZmroTteL5JIkJISacddvsSkWO8HLg6KxRzjxaWTfjWnIXtpf1cgIXi6X3bu0tj/ab1fJxajCb9N6haIbvdDgvhbbxy2faJ2wiz76129Wi4SIFJVbJBc8LoZMmIQr7nB4FSf98lzw+saOMCJ2Vi7udLiD94+CkwgdBXBCjk0k6K/toV2er8nZ5Y8/WoQR8Bac+yll6zh1aLKx+C35q+AOAHvZaxo5b51Gm+5WLVUP/n3+BBM4Kr0BBITXcPojU+gx2ujvF1igwJ+xh6Edvmydd7yjqrnVFFSttkrlrj9qCLW1PrK2fECDjivbe9GbsoXkN/ysrGePCWw4TiSwc3LbCFETP3983OAjm7xcPRawmk4C4nHWfZCzZK9PahS5uNEE/uOO5rWKXytlm2V7dqygGKR4A9ghcNISwYTJaLE/589e2XpiNVy9kA2q1nz77MSmK/5ehPlMDGMaooAfpKxpMJSd/Kyvjn92N9XpkrHlKZY0qH92VXMGKPm6IHundDuC2DFhLRoD62osBxfMgqvf7BH/Bo+Y9nbZWZN+S51PWXvJ635i6zkOqS/9wIcFxQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(71200400001)(83380400001)(8676002)(6486002)(44832011)(8936002)(86362001)(5660300002)(2906002)(2616005)(186003)(26005)(38100700002)(64756008)(38070700005)(6506007)(6512007)(36756003)(54906003)(110136005)(66946007)(4326008)(66556008)(66476007)(66446008)(91956017)(76116006)(316002)(508600001)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?gLjumArkC8EDtcdCuRxF2ze1DbeoorLvr1mitDk34GUqbVam1QWxFAF+M?=
 =?iso-8859-15?Q?jWLyMSeyNnwkKSeNqLN9mLxBbOzG9CiOmyv3S/4hWBreK60AMS2GUetSw?=
 =?iso-8859-15?Q?ck4R2AUrRRBS7Ccallmx8EDvoQwAGEDYRJvLOjG+6nHXu5l5d/fU9g+tM?=
 =?iso-8859-15?Q?9VDmj0rv/XUehZXLsixJoY6RnDQlyRRFS3HqL6Ej26reyZ6+pnjd9Xx5G?=
 =?iso-8859-15?Q?FOUy9g5FTRLLXuhYu6MV5EUPqWI25oqYxhNIn6HVAhoitFlJFjP1tLSX+?=
 =?iso-8859-15?Q?6gkD0oegsQnCKbBCdC/jqo9ZGrjwhRdp6WfxJE42Z+Ps75lS0mgUhhwaa?=
 =?iso-8859-15?Q?wPKGXh/HrkEsSGqnlXA7XvawWiqk5sbAXruDaz46S/FRI21umFLncRlLu?=
 =?iso-8859-15?Q?Tfjwh3VgnQNwdM3GPpuF2MXJB52TwASnBTuTiLrwSVv9lEmPVAxrcxjua?=
 =?iso-8859-15?Q?W8NFWPcctbHAess7nYBaLnWnJjTGyJUmkI0Hnx10piSIb0Nh7taahRa90?=
 =?iso-8859-15?Q?RiE1vkuvYY6f7z6I6FSNBP3ap2UZGNFkTBszkqQSDijDjUdzGBbVWUqoM?=
 =?iso-8859-15?Q?t9fCn7gBMv1UiaCOlDbPfGZma2VYCzjsA/LKr4FqEQKxXgwy+tmn2q8EH?=
 =?iso-8859-15?Q?If521l9EZi55e4ZH+aLkf5oZ7PJdT4BEVB+GIDWlLnrOq3E5hbIN9/Ygy?=
 =?iso-8859-15?Q?Wb2cA4Hhz5TRz+2uxoyQ8gOD3k8obo7kM2esb0OfJ/MkpV2ZUJuX66Tj9?=
 =?iso-8859-15?Q?32EHRZKhx8F+w6WG9w7Hvvo/yxg1c+ld6BBddXS2ZlMKKauZ01I6q76Xm?=
 =?iso-8859-15?Q?hxA81YaRD8FwbrWLbJ0bkHGiA11McYtZt0/ICNjlukGEB35gGSZoumqqo?=
 =?iso-8859-15?Q?ge/Sk98ch0fjQkJxgU6sLYQWZHZyRS/PvHFdTsa5WL54FojDqIg7St+OE?=
 =?iso-8859-15?Q?T0I4YyhmO8tcOO/2iF7lBlTz73y4tlTG1uYTnk1WuUMLrOzWf5shF7g7G?=
 =?iso-8859-15?Q?7qu1dJ5xH1sh/IaXdd5jEB4k5XgWVDvS/aBJdJYCjxhPRPZmo7nCh7mmE?=
 =?iso-8859-15?Q?58JKNuF8QDFd6pi2i/3ABL/k34XIzui1ANg+NqPVZJtR00+Qx+Q0sKzhA?=
 =?iso-8859-15?Q?GxyRRyO+W6o05JW6Uzs3pRdo7CisBDVZ4bhQ1FfSKTkpP5fWr/HjBeLOV?=
 =?iso-8859-15?Q?ZTcGEH1ZFkurN7hx7GGWZkUKsGAe6AMoChgfNuZSL94RDRGSm6trIOuxS?=
 =?iso-8859-15?Q?RhGbdQLVLR4URaJD4vfWUydbAHB3UCuBRKPEGh48pIZMW7WFb3Mrl5YHO?=
 =?iso-8859-15?Q?bteQSorq8/Dzf3jvRDpRGyN2csK9jEddrcfqMkj53aewPsqXu5EAaGevr?=
 =?iso-8859-15?Q?DTpjAWS3FLgJO/L02hCXLN8yI5+JzFZyDWh1iEWMWnMBXxB+4LmfTgeMa?=
 =?iso-8859-15?Q?cqR1ckzIVpufQWm4u2eYT+knqu71ocWzdRnwaYHLN0iQa1a4ugKQKsdwD?=
 =?iso-8859-15?Q?IhpBvzJRld1PSm/t8tXWef0j4JPlf/wrDMK4pJKPLQJhCmZ+UNsi2vsdW?=
 =?iso-8859-15?Q?prXYHmSmLTAw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3faf877-8b60-423d-185c-08da0348e85d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 10:21:29.6509 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaTuaAa3OywuEdcXc9o7aqPnoSOe4EzckDJNSCyweN7kyFWjUG9EVyCngk6zBf7MNlbkSLxhNi+gfdcFSG0E5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5443
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: don't keep looping when
 config is delayed
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "guozh88@chinatelecom.cn" <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <890265D525495042BDA9CED3AC4F961D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-03-10 at 20:02 -0600, Benjamin Marzinski wrote:
> If a reconfigure is delayed because multipathd is waiting on a change
> uevent for a new multipath device, the main thread will not pause,
> but
> will keep looping and rechecking to see if it can reconfigure.
>=20
> To solve this, when __post_config_state(DAEMON_IDLE) is called, if
> __delayed_reconfig is set we really do want to switch to the
> DAEMON_IDLE state, even if there is a pending reconfigure, since it's
> being delayed. When the last change uevent for a new map arrives (or
> we time out waiting for it), a reconfigure will get triggered.

I had thought about something like this, too. I think there's one good
reason to switch to DAEMON_IDLE even if reconfigure is delayed: if we
don't, and forever reason the uevents we expect arrive with large delay
or not at all, we risk being killed by systemd, which will kill
processes that stay in "RELOADING=3D1" state for more than
TimeoutStartSec seconds. It's unlikely, but I think we should try to
avoid it if we can, because we have no control about systemd's timeout
configuration.

> However, we need to avoid a race where the main thread calls
> enable_delayed_reconfig() and sets __delayed_reconfig, and then the
> uevent thread processes a change uevent that sets the state to
> DAEMON_CONFIGURE, an then the main thread calls post_config_state().
> In this case, multipathd would move to DAEMON_IDLE, even though
> the reconfigure should no longer be delayed. To avoid this, when
> schedule_reconfigure() is called and the daemon is currently in
> DAEMON_CONFIGURE or DAEMON_RUNNING, __delayed_reconfig should be
> cleared, so switching to DAEMON_IDLE will instead become
> DAEMON_CONFIGURE.

I suppose this would work. The part I don't like so much is that the
DAEMON_CONFIGURE logic remains complex and distributed over different
functions (__post_config_state(), schedule_reconfigure(), child())
which interact in non-obvious ways. I noticed that while looking into
Guozhonghua's problem yesterday - the logic is hard to grok, even
though I wrote a significant part of it myself. In particular, I have
started to dislike the complexity we added in __post_config_state(),
which today doesn't do what a caller would expect it does (which is:
simply setting the state passed to it). I'm aware that this complexity
was created by my own commit 250708c :-)

By adding extra semantics to the DAEMON_RUNNING state (which used to
simply mean "checkers running"), the logic gets even harder to
understand, IMO.

Please have a look at my alternative approach (@dm-devel: only posted
off-list so far). If you think that'd be a viable solution too, I'd
prefer it, because it moves most of the logic into a single place
(child()).

Regards,
Martin


>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/main.c | 2 ++
> =A01 file changed, 2 insertions(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 86b1745a..9bd1f530 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -309,6 +309,7 @@ static void __post_config_state(enum
> daemon_status state)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * again and start anothe=
r reconfigure cycle.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending !=
=3D FORCE_RELOAD_NONE &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !__delayed_reconf=
ig &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state =3D=3D DA=
EMON_IDLE &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (old_state =3D=
=3D DAEMON_CONFIGURE ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 old_state =
=3D=3D DAEMON_RUNNING)) {
> @@ -353,6 +354,7 @@ void schedule_reconfigure(enum force_reload_types
> requested_type)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_CONFIGURE:
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_RUNNING:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D fals=
e;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D t=
ype;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0default:

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

