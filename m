Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B43C71153
	for <dm-devel@archiver.kernel.org>; Tue, 29 Aug 2023 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693341295;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dByYs/+tRnwpUpzwR8eSaQb82G3olF6yzsL29bkzUi0=;
	b=L4TD+ceVetTpZSkAQoDW+ia4Ms4jQALuEBJ6tMJeqYfXa77s12SjDq7J+xdGZvqjUV0gcY
	a3y7Va9Thqq302mQlA1JTq/by5sqIgbYql8QaD8yHAg+EmC0A0BdFAp5j0WWSWJxdN5EDK
	kBQiRQn5NOV9lX9dQt6LfwiUOE1GiTI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-fWQLXUUtNUWHSK-HfVY1bw-1; Tue, 29 Aug 2023 16:34:52 -0400
X-MC-Unique: fWQLXUUtNUWHSK-HfVY1bw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 792E2185A78F;
	Tue, 29 Aug 2023 20:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4831492C13;
	Tue, 29 Aug 2023 20:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99FFA19465B6;
	Tue, 29 Aug 2023 20:34:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 143AD1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Aug 2023 20:34:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D591940C6F4E; Tue, 29 Aug 2023 20:34:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCCF340C6F4C
 for <dm-devel@redhat.com>; Tue, 29 Aug 2023 20:34:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A98123844E00
 for <dm-devel@redhat.com>; Tue, 29 Aug 2023 20:34:45 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-l68GLjORN3WTWgT_QBTj6A-1; Tue, 29 Aug 2023 16:34:42 -0400
X-MC-Unique: l68GLjORN3WTWgT_QBTj6A-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8944.eurprd04.prod.outlook.com (2603:10a6:102:20f::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20; Tue, 29 Aug
 2023 20:34:39 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e%5]) with mapi id 15.20.6699.035; Tue, 29 Aug 2023
 20:34:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [RFC PATCH 0/4] Make prio timeouts work like checkers
Thread-Index: AQHZwYaSzPmtWTkelUqZESI4T+ZOq7AB7WgA
Date: Tue, 29 Aug 2023 20:34:39 +0000
Message-ID: <5d4d7dea45c20d758a35756f2d3cc1e4f7a0db26.camel@suse.com>
References: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8944:EE_
x-ms-office365-filtering-correlation-id: 85443808-9f34-4f81-5227-08dba8cf5e1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: D82MHMrweH+B4Di+C9ANwWAFcjmle1X1WzUmLQKchOH7lkMraiywpH2cg8he4fQMl9jjRexShmrZcAM6x4uZGJHW99OqjWKkQJcui3HaSEZ2skZxgPKEMM7lq6azCLoZfDCuBbbgdqTmo/fF6PHInaWnox7HSu0oZ3vVvvHHdl4HEbG6l7D66syJsIwqFkFibpXPk7tre6CAT34neh/CfO5ONjbaD4sb84quGEM7dpH6BNvfo6Vwsc5X3RVVsbumWFRgI2CDY4G1Y4K7iK1PeTLTxX0jevncFKU7Qg4KDIUCZSasrkhCeDIAMI54FlNXhfKWDM327njq6Y92GACUnOuexiaerKv9mvnNTT1NbROhGcw8TVrW4YQTKvlD+fEn5wZUMEe4wtXrXAb8SzrRirxt+/tyxFm47Rn28ky59ly2sbJFfVflC4WWohEczdcKvaMRyobrKVs62MdEV+hQfSORZmViAAuaNFS9pufu/z2teabGUGZWTNbY1cR7HKEi6IlxozDygjHZfqDoTvel+WclkueNYv/na4QHHza2TLvQ8nzPEz7pOjw5C8QAq8BhTwX/BGxMvyW2tvSJu8gAOm7OaW9jhR2TTEAp46Amdz4wefXl9gmNAia7bqDDpzNz
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199024)(186009)(1800799009)(26005)(44832011)(6512007)(6486002)(6506007)(5660300002)(71200400001)(38070700005)(38100700002)(4326008)(122000001)(8936002)(8676002)(478600001)(86362001)(2616005)(83380400001)(91956017)(66946007)(76116006)(110136005)(64756008)(66446008)(66476007)(2906002)(316002)(66556008)(36756003)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?+Qi/CxIZlPkxn3Lu4fSOMyxc0EkPGZnAkTKdmaRXgBLAswrUTZykVkV3t?=
 =?iso-8859-15?Q?NBU//YS4586dwVxAaIi2/xEDHtGEYrz659OpGfPXvDDKfslG977g9NHsQ?=
 =?iso-8859-15?Q?EmNvRVc+xS+jPdRHA7i2oFsMcHP2wgEvLQhM9kUajIET7B0cEeCHRrsWk?=
 =?iso-8859-15?Q?XXKMCpsOg8o6TUg4hEdrS8aABnueslTQkLIyL6Rxb6SrMx0o8dvEignlV?=
 =?iso-8859-15?Q?UCV0+hSGJqFNiZuUANlCCx9Pttvu26dcefGSV+Cy6CwV4BpCrdaKF80fQ?=
 =?iso-8859-15?Q?2G+wmMcRlcYUTgvuWeY7DjHViFNqForI5Kf05d7qt4fRAYHcVXRrE9lEp?=
 =?iso-8859-15?Q?bb7H4E9Yleho1XRcg+R8WFg/Ypy+7T876nyp+BmFbMJrD6+9uHFqsi1eN?=
 =?iso-8859-15?Q?sUdhigJ/VNHiPyxKLtMK0lOu7oQ4KACgBsc77QLHK4AuE+170+jLM6RYt?=
 =?iso-8859-15?Q?PKVdjvYUDQTx/d6EfP4ig3/5LyxnYMcJj5xDXracv2xmWo5yrKFdoIN6u?=
 =?iso-8859-15?Q?G7cMYpc0CquY/5RSFM/Cfrxl7Q8a97vAOio0B5MKLm8HrPJ5943zRr1Fk?=
 =?iso-8859-15?Q?+Scr9qqFNqrx+lf8WeHB1LbzEsWAgQaeSj+RzsQoNTgtRiagpuTyLL3LA?=
 =?iso-8859-15?Q?CgP6elVc2IbGOV+r2YAIMj8HgQOpb/5qtzstu0kdpqWF5rThidTWiDibi?=
 =?iso-8859-15?Q?gNkxKMgwtjnfIXWNXQcHifO+AakyUbDqyBrDtqv1gkysGB5OK+aDTVcUY?=
 =?iso-8859-15?Q?uIqojdOnnvU3xCDB7RlgQvOg3bKGa/MKXhfAkMq/Td5SFxgwigLLWA7ss?=
 =?iso-8859-15?Q?AfifapP6/sj5IiMUoJMsHLps6ApD3bDeieY/EBmod+xGWdIma9FGIHM4E?=
 =?iso-8859-15?Q?QFGfq5ZM2zydQKPYd99iAhek6FlNZssouG0UN4yu5VAHNTm68C6X4Hyf0?=
 =?iso-8859-15?Q?RXVtu9D/RhTf3cvTgWpMasA4/+YEzdvRDFsWvPNZFp/LuzfJtpwhErdn7?=
 =?iso-8859-15?Q?AxpLutRZqMFt7vQVntfsCZ5Iejq1Lud1k1F5Um/CQEx/jwzNcZ8U+8wc/?=
 =?iso-8859-15?Q?SDDyqsgTYM/a1//pzv4KfGqVWDle/8klZVZ1y7AfI1EWqqO4IGZrDVqn+?=
 =?iso-8859-15?Q?ay7sZxlj0iZZHNmgKBamlBeVFW8upriuXqEPfarKmHnZJzzeF34KNse/c?=
 =?iso-8859-15?Q?WBJf8kHGIw/OeDH3UQ+ywmfBkOb5UyDJ7uek1AOPVlKuP4F2dlFtvhnaT?=
 =?iso-8859-15?Q?g8XXyTLRJ4mlqgIQyvVhnFY+JuIe3xP8oo/SCQAJ1AzHG/SeaolEFUtWN?=
 =?iso-8859-15?Q?UE4gtF+hBNlUUfWY8U+TM1NP9scIiujpzRqSvaLC+90FocPdTWKEM94hF?=
 =?iso-8859-15?Q?6PZDsCy8k2913Y1L3JfSbCTQWM8FY4rlmnsIlyoHZVhM1mdasbFBuyWGf?=
 =?iso-8859-15?Q?/Uya7y/fQ6brGc7U2BCVr8uPz/QRFETHxZmYClEGgBrh6Whl6zmlsudcn?=
 =?iso-8859-15?Q?Pm/t7MMaKZYIuMhq8RL0vuVZVlxbF3CbtHR63trssb+M4bMt9vnYiC8iV?=
 =?iso-8859-15?Q?TiTFMGNAAstDY22spqLbJf3nRJGXPVL4NAtfJRo+x0WwhB5jAvGO0ohUg?=
 =?iso-8859-15?Q?TLMtDWD4QYiALxs9ivji974UHTUWnN5D7R5oB+HxLYxVFXyNL/7A7GETx?=
 =?iso-8859-15?Q?2ZL03vNxkIMaMjfuOVZANmcgug=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85443808-9f34-4f81-5227-08dba8cf5e1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2023 20:34:39.3343 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vJqXGlDfXpQs1Dq6dBwKmiH52k0p052WN9ycMMzPUiVllT9zYXYqupA5diS++DaylGoucox0FX+PgTlmLsyB3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8944
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [RFC PATCH 0/4] Make prio timeouts work like checkers
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
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <E6B4127287AD844593BAE2036BD1A52C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-07-28 at 14:05 -0500, Benjamin Marzinski wrote:
> This patchset changes how prioritizers set their timeouts, to make
> them
> match how the checker functions work, and also cleans up some minor
> timeout issues. I did this to make out timeouts consistent, but if
> someone has a good reason to object to that, I don't feel
> strongly that it's necessary, and I can resend just the bugfixes.
>=20

I don't object the idea, quite the contrary. But I would prefer a
different solution.

IMO we should treat the "io_timeout" as a path property, and add a
field  in "struct path" for it. It would be initialized from=A0
conf->checker_timeout, or if that's unset, from sysfs, and finally,
DEF_TIMEOUT. By reading the sysfs value, we'd be able to accomodate
different properties for different devices, but we'd not re-read this
value repeatedly like we're doing now. IMO that would be more
consistent with what we do for other device properties.

We currently pass the timeout value down the call stack all the way
from pathinfo() like this (for alua):

pathinfo()
  get_prio()
     prio_getprio()
       p->getprio()
         get_alua_info()
            get_target_port_group()
               do_inquiry() (*)
                 do_inquiry_sg()
            get_asymmetric_access_state()
               do_rtpg() (*)
              =20
With the exception of the functions marked by (*), all these functions
obtain a "struct path" argument, too. IIUC, the main reason we're doing
this is to avoid stalled getprio() calls for paths that are down
(bb935d4 ("libmultipath: change failed path prio timeout")).

IMO it would make more sense to remove the "timeout" arguments from
these functions, and just determine the timeout where it's needed. I
don't think that's a layering violation; functions that receive a
"struct path" can also handle PATH_DOWN. Thus we could write

int get_prio_timeout_ms(const struct path *pp)=20
{
      if (pp->state =3D=3D PATH_DOWN)
            return 10;
      else
            return pp->io_timeout * 1000;
}

and use this function as far down the stack as we can.

Furthermore, to improve code readability and avoid issues like in 3/4
and 4, I think we should call all variables and fields that take
millisecond values "timeout_ms".

Thoughts?

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

