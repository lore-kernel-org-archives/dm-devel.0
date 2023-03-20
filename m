Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE968C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679324013;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cSw9YaVuFCaAL4pw0Jgcxd7Z07PQYk3VBAuQ1mPmY70=;
	b=Srseo5Py82IbWrMlVj30myifY3EgtqZx5xLx5mC9D9imKjx8k5UCxahLoz4XdnpbpONDKr
	lpxcMplckbXBHYvwQNidCUPa+l2Bg77affPlnW40l2sJuprKLDuqCZH5742Hcopl1W0Ih9
	ws7wMkSLB+nFFJp5i7ipa2Hm0sVI5Kw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-9PghzgStOMC5YJIJT374jg-1; Mon, 20 Mar 2023 10:53:29 -0400
X-MC-Unique: 9PghzgStOMC5YJIJT374jg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F23DF185A790;
	Mon, 20 Mar 2023 14:53:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88B4B492C13;
	Mon, 20 Mar 2023 14:53:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4842E19465A2;
	Mon, 20 Mar 2023 14:53:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 037AC1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 14:53:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9613E40C6E68; Mon, 20 Mar 2023 14:53:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5AA40C6E67
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 14:53:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ECA9185A78F
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 14:53:26 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04on2044.outbound.protection.outlook.com [40.107.6.44]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-O9A86gIyPaOYkCHhwRQ43w-1; Mon, 20 Mar 2023 10:53:24 -0400
X-MC-Unique: O9A86gIyPaOYkCHhwRQ43w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by VI1PR04MB7037.eurprd04.prod.outlook.com (2603:10a6:800:125::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:53:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:53:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: limit paths that can get wwid from
 environment
Thread-Index: AQHZPKvyANbsh8kW3UyR3Hllsj4wYq8D/hOA
Date: Mon, 20 Mar 2023 14:53:20 +0000
Message-ID: <5be1cfaef0f67e4992169b92a9c44cdcb623affc.camel@suse.com>
References: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|VI1PR04MB7037:EE_
x-ms-office365-filtering-correlation-id: 454cf376-f618-4c2f-ebbe-08db2952d8c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: j4pXMYruKx8n39FHL4EYZdJgW31/ZMI5d4o4TBqh3mGz3f41Uh5tXJrelsWbTtudbgwjEp6qIVDDb2T4jXof/nUhrOWL7/lpuvyaWFy6vfC40VGTn8k4alvGuowEckh1SNDph1aHsmn/yQhAKft/ZluGNk9qLlKu3DO2jvl0olttUaxlKzvCNsiFmg7zwxYlUW7lJFLdKvjBXT00OnOrcwgi8d+FW6mdOw2PoRsSMIGlGoG1ff8kKVvVsxmLg+9kWpjRWAiZTn9KD4TsZniLwlwwhy9dqEjVEH/XpEj+izinnbnEr8K9H4Mo1mOF/pKmOOkycm5pKWiqH1YtjCa71tBjoq1wrHTu0tUAL+luZGr71+Wx/9hwuBct0+JmT4PaM2/+FEj3xC/aLaxk4ZlBeg869L/o/h42Zz6veqGk47p0CGHrVujF7JwTzKBCZ+AGxTuKwQ09wZAs93CE1pmV5Z9iQP4p00B53pA/WfNdc9P5eF56SeF8p978YQVMUaFvIKNkfD86y8okq3oVhGaXCCnHTKUrO6dVUXicHCtumlARsoIqfOYxE78TcBGvZ5wOQKQHURbPV6JvtFxejy0wOqA9oLxzSE3d9/ghuUqhoZhThTyU6xk2H7IBsOd/lchGkrBgIjnMGAAHr7FOnzptouIE/BaJNU+RukjOdaYtTEp1ne8xT8Ivcuwj+aUCfKuTIgg14DIjN9kssQge+yDKsw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(396003)(376002)(39850400004)(366004)(136003)(346002)(451199018)(2616005)(83380400001)(110136005)(6512007)(478600001)(71200400001)(6486002)(6506007)(316002)(5660300002)(186003)(26005)(122000001)(38070700005)(38100700002)(86362001)(91956017)(8936002)(2906002)(66946007)(41300700001)(76116006)(44832011)(8676002)(64756008)(4326008)(66446008)(66476007)(36756003)(66556008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?E4wH7D3qiH80jFLWKlfvkNIiNmSIRRQcKNq7xB4MuLml/Avpb/kV2TkEK?=
 =?iso-8859-15?Q?pIph/3uJBOdwkAmgh8hkevrIq55G4xguXK0u3EmuTnWEtGokPN9/7u5Jc?=
 =?iso-8859-15?Q?vCXE+H6gydkte02wtxA6n0+9/Colg6IaRewO6EaXLk0ZEKqiQSwRui94R?=
 =?iso-8859-15?Q?LQ7ciyGIPZQ73IS2efzlNNfGVXPin8f0FPs5XO6v5xDYOKuqreyPzEMeX?=
 =?iso-8859-15?Q?mRZsICSP2sr/YvDIT17g9Mub55mY3eX3eOsZZNb8+exBgQPrZcYlY+GUe?=
 =?iso-8859-15?Q?qPm9Pwcxm2Og4Kp57eZf3VwbVQNnJDESKbLn/5AHbTfETplKrzJVm9duS?=
 =?iso-8859-15?Q?QnQKlw+tNYVDxfCdsKll7QGOfCBaaR0zC5Z/Nxk7/ocDed3sxN/huhWfE?=
 =?iso-8859-15?Q?Grc4MKeSvFmigPM7rTrFh68pkF9WL+6ha6U2F4jwzqFXdvWyTQcXaD1ec?=
 =?iso-8859-15?Q?ZXw3IAPUbLq50gdjrsR8tDNju9ZwX6kJ665R4e5hkDAM4ONsWEc9kAV9t?=
 =?iso-8859-15?Q?gCVcY2cVyP79h1P8G54jbpyfvvMnis2kftx7x3y8qr/NM5o5JBYL5Ba/c?=
 =?iso-8859-15?Q?YzcbEx/2fivDpee7c828cR1JKNSsyHJQCtzAqmR78htWnb0V9qIfJyKTB?=
 =?iso-8859-15?Q?5iA6TqbaepHuJ0OeUQxYDKAVr6ofgylVELQc/Qh1kBHJ9YhI8ur3FXHbt?=
 =?iso-8859-15?Q?bJc3r1Q/F6rjRW+irzJDoD2rAcY4DOpIU994GO3t9HUC6bWAlU5SCYKh5?=
 =?iso-8859-15?Q?sqnxcOXpgMptsWwjqwl5pUE58bmDpZaafSJk/7d85oWmWdDrgMDpIvKmx?=
 =?iso-8859-15?Q?ImPaNV64KkoDcoSRoJZUcuSJAT2lUDEMHAUtvJBul3m3098r277u0nhgt?=
 =?iso-8859-15?Q?lnu5sdTP1rQWo2ujSrJfDCvEUl37tz0Hsgg/h3ZkW6fbCsFx3GONAgUDL?=
 =?iso-8859-15?Q?YWm+DHItT2WCteDtrtcjtoumjof3cLWZELB+x4iNP92ctAATITYaKDANW?=
 =?iso-8859-15?Q?dINW2aymYZpJqUvrYzudmu5K1tq0jWLKcVSWK/jzaIpWux+KoGz2ZwCEp?=
 =?iso-8859-15?Q?0vPLVNwBa9uLhPfgnqOd7T/dxr6hMziRYQ6AT5ZpNxTcfofZ4aR6s66GL?=
 =?iso-8859-15?Q?Wq8kdAiJTQeWJFIks7TC2BT07Hdbh/QJoKIi3HtgB+f/rO2IHuZ9YduEk?=
 =?iso-8859-15?Q?srIusyxmhAtVPyy0+/4UvpXQ0y5a+93AIF234LNVwZ7eJaWTsFRcM8J/S?=
 =?iso-8859-15?Q?YSNZt5lAveaEvTjrkvr8Klr96mYxywXq/sD5oN76kw7u2cNpStBeSN3od?=
 =?iso-8859-15?Q?t59SieMD+OYDEVQKp+kBUVRk8okXOmY9RhNpGaDOtkxu8rPQMjrkI5Low?=
 =?iso-8859-15?Q?1jLEu5xtTDZ4jYEUF5zmqxV/IDKtAdbnRXxB1ribdzozt1mZIuxU8cya5?=
 =?iso-8859-15?Q?WV+FygE8CNZGeqCPkJuJ7bNQuU+tv6PtsBNIchnCc2ac3vVFl0Fs7Cdvr?=
 =?iso-8859-15?Q?P8YHPNU1NuIeIYZ3JHS7y5k6iiy7lb2EOIDnlxmMr4mKq/QkmRP8itsiT?=
 =?iso-8859-15?Q?liyhCbJ/h7bhI7aodALw8f1tj+DuFSaKIHWjfc2dBx+Tf7CgLfUmd2HQk?=
 =?iso-8859-15?Q?l7abiZv9MA9pOUypm/75CEbEK0MluNQPPdVPXN1bWsd46EIrrp5GAteh1?=
 =?iso-8859-15?Q?1k0YJW4qMyfJymiFu74B5MSJjg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454cf376-f618-4c2f-ebbe-08db2952d8c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 14:53:20.3142 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmZ0jZR9rB2KW91rJ23GwRQaV0LuBiUHdfPQwCyBrIX06TPDJk/5anPX9WgdZNT5cje+VeZh5HSyExAAnr0ksg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7037
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipath: limit paths that can get wwid
 from environment
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1AA54564674956468E69B4A2BDC8B7CD@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-02-09 at 11:28 -0600, Benjamin Marzinski wrote:
> Currently, whenever getting the uid_attribute from the udev database
> fails, multipath will try to get it from the environment variables.
> This
> normally isn't a problem, since either multipath -u is getting called
> from a uevent and the environment will have the correct value in that
> variable, or something else is being run and that variable won't be
> set.
> However, when find_multipaths is configured to "smart", this causes
> problems. For maybe devices, multipath needs to get the WWIDs of all
> the
> other block devices, to see if they match the maybe device wwid.=A0 If
> one
> of those devices doesn't have uid_attribute set in its udev database,
> multipath will fall back to checking the environment for it, and it
> will
> find that variable set to the WWID of the maybe device that this
> uevent
> is for.=A0 This means that all devices with no WWID will end up
> appearing
> to have the same WWID as the maybe device, causing multipath to
> incorrectly claim it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I have to say I don't quite understand why we read from the environment
at all if the libudev call fails. This was coded before I joined the
project, so perhaps you can clarify it. Why do we expect the
environment to provide the correct value if libudev cannot?

If we need to keep this fallback, I wonder if we need another field in
"struct path" for it. For example, we could read MAJOR and MINOR from
the environment and use uid_attribute only if the result matches the
path's devt.

Regards
Martin






> ---
> =A0libmultipath/discovery.c | 2 +-
> =A0libmultipath/structs.h=A0=A0 | 1 +
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 2 ++
> =A03 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 67ac0e6d..3a5ba173 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -2093,7 +2093,7 @@ get_udev_uid(struct path * pp, const char
> *uid_attribute, struct udev_device *ud
> =A0=A0=A0=A0=A0=A0=A0=A0const char *value;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get_property_value(udev, ui=
d_attribute);
> -=A0=A0=A0=A0=A0=A0=A0if (!value || strlen(value) =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0if ((!value || strlen(value) =3D=3D 0) && pp->can_u=
se_env_uid)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D getenv(uid_attr=
ibute);
> =A0=A0=A0=A0=A0=A0=A0=A0if (value && strlen(value)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0len =3D strlcpy(pp->wwid,=
 value, WWID_SIZE);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index e2294323..a1208751 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -368,6 +368,7 @@ struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int dev_loss;
> =A0=A0=A0=A0=A0=A0=A0=A0int eh_deadline;
> =A0=A0=A0=A0=A0=A0=A0=A0bool is_checked;
> +=A0=A0=A0=A0=A0=A0=A0bool can_use_env_uid;
> =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> diff --git a/multipath/main.c b/multipath/main.c
> index b9f360b4..90f940f1 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -607,6 +607,8 @@ check_path_valid(const char *name, struct config
> *conf, bool is_uevent)
> =A0=A0=A0=A0=A0=A0=A0=A0pp =3D alloc_path();
> =A0=A0=A0=A0=A0=A0=A0=A0if (!pp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return RTVL_FAIL;
> +=A0=A0=A0=A0=A0=A0=A0if (is_uevent)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->can_use_env_uid =3D tru=
e;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0r =3D is_path_valid(name, conf, pp, is_uevent);
> =A0=A0=A0=A0=A0=A0=A0=A0if (r <=3D PATH_IS_ERROR || r >=3D PATH_MAX_VALID=
_RESULT)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

