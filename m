Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3DBC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 03D9560F57
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03D9560F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-0Bucxw-ZPQy-5FtAKFcrAw-1; Thu, 12 Aug 2021 06:23:35 -0400
X-MC-Unique: 0Bucxw-ZPQy-5FtAKFcrAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77BAB18C8C03;
	Thu, 12 Aug 2021 10:23:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2722D1BCF0;
	Thu, 12 Aug 2021 10:23:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A68D74A7C9;
	Thu, 12 Aug 2021 10:23:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CANHHu012235 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 06:23:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AA25320285BE; Thu, 12 Aug 2021 10:23:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A41D420BDB30
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 868E18058E6
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:14 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-537-pEDJ3HcPM_u5HP0nVraISQ-1;
	Thu, 12 Aug 2021 06:23:12 -0400
X-MC-Unique: pEDJ3HcPM_u5HP0nVraISQ-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-9-p_whgUQTPsGpFzrLF2-ICQ-1; Thu, 12 Aug 2021 12:23:10 +0200
X-MC-Unique: p_whgUQTPsGpFzrLF2-ICQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Thu, 12 Aug 2021 10:23:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4415.015;
	Thu, 12 Aug 2021 10:23:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/5] multipath: print warning if multipathd is not
	running.
Thread-Index: AQHXhMMsLsOnjSdJikCBBs4czMJrG6tvvpGA
Date: Thu, 12 Aug 2021 10:23:09 +0000
Message-ID: <a6c0dff1b97512eb4150969894de22c3d2d0efc8.camel@suse.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15d1b50b-360f-4aea-ae22-08d95d7b2ee0
x-ms-traffictypediagnostic: DB7PR04MB5385:
x-microsoft-antispam-prvs: <DB7PR04MB5385D83D12D6839CD25DB44EFCF99@DB7PR04MB5385.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iQWCCj43EA27KmYepUBX4zfSXDfsM/HyZSpgi3qnBDn2eCznsvdTWv/8HRgfmLxhaWM6hHE7wKgWAUhplf6swEBzyk3BV2xQYzskUbAnKqDwyy0UW1Fcy9ifZEIRjlGQ6CKX26zX33M4q0JoTgqzuyzI0jf3T56vLDXDv6W0GSprnBpSeR1Lkyqp7nqafErOcvTG2E9mrjH8Ww1P1ccZroa/3FGn34ElvPxi03i34urORkxjBi2X0PhnKSGvS8xMnM4YVdZJkoVx1RstvrRiJPnRUt2VvxD9IlXYoVxKfp1ERrufROq9/xvD1vK/V0BSlcNgMpef5QXv6jCNAVD8rkT7y/XChx+eGH8zEehcLbQalQAfB/+QiyzyrGt7WNHMSL9LQ7TrprEqmD2r89GUNO7CCK/byglq+Wt67NcaALnNGJWQDV40hiRVLsXssElR2uP1t5bQ+uDE/wOx555WjNqofr/6CDRswk/QBkLSX3BbEUwURu8cPRJPQKfRrNIiqdatwu7a1BH8e/ZpwM7nhpTYJ4Mru2RhRp7s88rBzaEjynKwH95SGLxcDALdMiA6fRSF5NwgSpOcP/KzMyYRE+jEg5ixLn3pS6BIoGhPaeHvzcSpgNzmpd1bXMxb/lc18cvITHXahBVhIIHEx7N18eXOcu2h7K5NbpsYi6Y0EE5HDGv03VFwA2EaYGuEdqPmnF+k5jBJeZFvH4zh8DCmxA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(83380400001)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(86362001)(4744005)(44832011)(2906002)(38070700005)(5660300002)(36756003)(8936002)(76116006)(2616005)(8676002)(6506007)(508600001)(26005)(38100700002)(122000001)(4326008)(6512007)(316002)(186003)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?mPHv5o0By5xZykaef1dFwWBvtIR24M7HgW54640XDqabm07BVtCEX12GT?=
	=?iso-8859-15?Q?AnCjV5BG8rWg/CxRWsLH5OKGILrVXI7mU7hcpxlrs7prxLLu/1/IWjTfx?=
	=?iso-8859-15?Q?Fzgcav+sqiOhacHueTXuhsLKqMEsRCxOnG7+MBvadUU02siMftIk/STWa?=
	=?iso-8859-15?Q?1A/kygP5/x6ZWf5De8RoaE8z/fj4fqlFf5G83oaRKC3wiv+ISWvmC3dcr?=
	=?iso-8859-15?Q?oZhMEhzy2DNmiBe8mEv25/1LxsL3wtonOFpQ+bahM+6U1XFborxu346HD?=
	=?iso-8859-15?Q?N3n+vcswewh+TuCdaNmnE2WaIJiqHWGaVEckfsGyWXg4xlgbqM/GVP5i2?=
	=?iso-8859-15?Q?ZRUd1zbi+Bdqm40+gYO0h7m46bBRETBRoPGyv2grgnI6mfQzXEw8vuoeA?=
	=?iso-8859-15?Q?uhovVZmMYppdN6Bark+gO23i1Ejeqj4yoryBEwE+yLldS3RMp28QsoNyE?=
	=?iso-8859-15?Q?desEHVJrujPb6bDnHs58N6cFmPAmxNnuXd/A+Iqhu2LLYkzXpCk2fZlE0?=
	=?iso-8859-15?Q?n6fkf+3e2f2Uj9NPMclSXeZmoNAnaenGrccC93lgEmcX3HiTnkEkmiRKK?=
	=?iso-8859-15?Q?rGeApAVtOZUF+uk3b4GQKuvhejmV5+2Y2Wtj78H27MupNLWgXL4JStAkD?=
	=?iso-8859-15?Q?KSKJ2ycyHkTyUrzop5pZCVwnj/V58oUXTubRnRc2v57nNk80lNxCf0GnE?=
	=?iso-8859-15?Q?4FZZ9yDa1Ugr9hsSvOJgRlg4yDzquc1WZH0GocPcaUESf8ccoL2YpXZvg?=
	=?iso-8859-15?Q?XIaWaUvh7oM0SWbSxg61xax7wwR49dexrti3ciDDvte0I+pcM6zHcT850?=
	=?iso-8859-15?Q?OEL01SskccIiE0jrlCqxUNKu2X+lxD6I/BWc2wdusFHtEuHmTQwhDS6Fh?=
	=?iso-8859-15?Q?2Bb3t972NUgKNS+ikVKL2zmzgV4eA127/cw6eVIesEUtCQeFMkApTLhDz?=
	=?iso-8859-15?Q?TnX7ZKZ80WLEzvngvXE3cMpsDwUAOcpx2S1jF+m2w7qeqYwEWhzy3xE2B?=
	=?iso-8859-15?Q?Ir1MxabQNsoLy7OSfDBUe+f1MI5dBZpbQFSk73md0WWZyWVgAawxf3SJb?=
	=?iso-8859-15?Q?PI9wxuXm8pofdZuwwdNuv4PZ79PrxrYRkLc8svLO3Oj4YdQNI7dWNBL7D?=
	=?iso-8859-15?Q?S9tlYoAIeYyUcKHqtDBknNvfNAMVFZFUzBi5SToydy07P9MQQ5yhEAaPR?=
	=?iso-8859-15?Q?Km7Eicx5f4yjw+Bz96P+4bEkDdNKBAmVpH/l9FBJq4LWx8FiXO4hwlqu2?=
	=?iso-8859-15?Q?l+rxZIMdyu7pPSGpeNAoaRU01tn7ih7q9Rzf87zthkGUwP3qe2HYtbr51?=
	=?iso-8859-15?Q?uqSyX1kGm4zdDzLF9S1qkRTv2vyMxCIeVcEp4IsvQlihV375r8ukVlZdz?=
	=?iso-8859-15?Q?pU653gNGdZI+aEaEi4i4lAo/99xxnKLHE?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d1b50b-360f-4aea-ae22-08d95d7b2ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 10:23:09.7633 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eVgnQ9amcwSRV+Hvnq9WIGlRg2ZvvIUUouaf1ad+UIDI+p8Siq7dpCiqlJFb7P2hpc1r0dn8WI3HVfdecoRQLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5385
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CANHHu012235
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipath: print warning if multipathd
 is not running.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8219CA5B5DBB094A9BB1AFDEF3706E15@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> If multipath notices that multipath devices exist or were created,
> and
> multipathd is not running, it now prints a warning message, so users
> are
> notified of the issue.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I'm not sure about this. Are there zero valid use cases for using
multipath without multipathd? On production systems, I agree,
multipathd should always be running. Personally wouldn't want to see
this warning every time I run "multipath" while multipathd is
(temporarily) disabled. Have you got user requests for this feature?

In particular, I dislike the idea of putting this code into
libmultipath. I would love to get rid of the "is_daemon" logic some
day. If at all, the detection of the situation and the warning should
be implemented in multipath, IMO.

The message should be prefixed with the word "Warning: " to make sure
the admin understands that he's supposed to take action.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

