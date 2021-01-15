Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3A0C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 13:56:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D401208E4
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 13:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D401208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-BlIbg1JOPfyCngjLuXGAVA-1; Fri, 15 Jan 2021 08:56:21 -0500
X-MC-Unique: BlIbg1JOPfyCngjLuXGAVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48649107ACF8;
	Fri, 15 Jan 2021 13:56:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 258886F44C;
	Fri, 15 Jan 2021 13:56:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E314118095C9;
	Fri, 15 Jan 2021 13:56:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10FDuFk0024889 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Jan 2021 08:56:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11BE2DA679; Fri, 15 Jan 2021 13:56:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AB0FF1033
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 13:56:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92C6080D744
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 13:56:12 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-190-vjBDQZNbMDqxlwy-2WTgug-1;
	Fri, 15 Jan 2021 08:56:10 -0500
X-MC-Unique: vjBDQZNbMDqxlwy-2WTgug-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2057.outbound.protection.outlook.com [104.47.4.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-KVELE8JTMx6QAMNedd5bfA-1; Fri, 15 Jan 2021 14:56:06 +0100
X-MC-Unique: KVELE8JTMx6QAMNedd5bfA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB2999.eurprd04.prod.outlook.com (2603:10a6:6:5::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3763.10; Fri, 15 Jan 2021 13:56:05 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3763.011;
	Fri, 15 Jan 2021 13:56:05 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/6] Multipath io_err_stat fixes
Thread-Index: AQHW6uUHTLI3CrtvNkisIEuS0cHeXqootooA
Date: Fri, 15 Jan 2021 13:56:05 +0000
Message-ID: <da8de4866215a92714d39fdc6bac1fdca910b139.camel@suse.com>
References: <1610677227-23550-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610677227-23550-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 949748c3-73e9-4ab6-3720-08d8b95d4d76
x-ms-traffictypediagnostic: DB6PR04MB2999:
x-microsoft-antispam-prvs: <DB6PR04MB2999992B426003A752BFFEFDFCA70@DB6PR04MB2999.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Azz/R8sJ0UOFAmMnkPH6G24p/UdC3o0rls2KR1Fbrxpc+G5PyXOYVH1Iuk9ecpbFV5ktl+fQGwpUknaQn6mZQYBxgQR6efkcUC1XP81ZcQxdMsjUNB/YYTCfmV+Sp7eb8BI3vD/JvJkLBaBz7AXWnX/YDlK619cHQmlUDuYXh4x0fHh8LWFq5YQ3itA9CB2cb5cW2x+uIhmr6z9GopndTo9IRVEF1IBZHzi5qclMo5vkEauRLU0fIJV3iNYvV/pXPH9lBMl99JiPS4Tr2CUmZMFSjZ4wI8BlX9jbSR8sV/NvXNNLU5EkYVbZefArADfO35F6CjvkmUJ3S9gncov1d2nDMFN22RGyI2G3JHRTVLhMNUUp4kamn+acBjEEpnwN
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(2616005)(36756003)(86362001)(5660300002)(4326008)(110136005)(83380400001)(44832011)(6506007)(64756008)(26005)(66476007)(66446008)(8936002)(66946007)(91956017)(71200400001)(2906002)(6512007)(66556008)(76116006)(186003)(316002)(478600001)(8676002)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?2I/CbnO7Gx5ry+HCgexV8W7/Yz98ImWbCUlaebY1gdCTauoTMTWOcMa2w?=
	=?iso-8859-15?Q?nk9zL4CxXOuCzraR0blXzhsGYqJ+weHl1x9x1x6mEoxaM3NW3zTbHoYH3?=
	=?iso-8859-15?Q?KVicl8FwxiC+dAwzlQDqCyYPUYP6xCv3epnDRi8mDNEJ8OhEdCPyELmUQ?=
	=?iso-8859-15?Q?UJdoy7lXtSVaYELFp80UoYKQtLu/lwlZC87CxMNYR3iKFgwYDAyXcw2Sk?=
	=?iso-8859-15?Q?/7dQ2by7AvJCzCDQtNwhJQg6Y5iDR7W8ek38nFXyETLTvksUZ47mMXBP5?=
	=?iso-8859-15?Q?Hlp7U2lrgswnytm8+9QZkwzityLgxt0FRcEULbG6aBMloUPNhCKKvGyr/?=
	=?iso-8859-15?Q?D+79lBPYSzhX25gza+4h/IQrMPsnQYQ7A2HqLfF7dmKH29b/vMAJeJyWa?=
	=?iso-8859-15?Q?vIkJAFtUKSdl+KUNOWMBEcnXI28gnC4idUvW63v+5lfsWqWct2d+g3qe3?=
	=?iso-8859-15?Q?ncuCK/JfSPSAAW4xTzAvC8HzFUZjA8Kv4z3oOUOOX+lUzlR9CBajAjfjJ?=
	=?iso-8859-15?Q?vi92fsm1XLoThUoepNgVaHyd4SId0j5aUp4nWg8fDVqphxO8vC3hjfk5J?=
	=?iso-8859-15?Q?NRlVmCHeE36Z9ILgkOYNVcJ/YhVHka3SQGThgotDBAS9e8HnnZxzetCVZ?=
	=?iso-8859-15?Q?MUhZ99ezWMCQo1xdPEkE5jXvmggp27UFE13QFNHX3jU5OL27WOUgULn3+?=
	=?iso-8859-15?Q?pFcb8LuObXtrfIV0JspKEX3vZC6GQ9+lYxdwxNUnlTRr7KFLuKYRfKVJS?=
	=?iso-8859-15?Q?toxgnZVLA6DBr+lVqMIqKrEGanWLtGJ1/YuBrdPNiAy7vzmN5so3XEYzD?=
	=?iso-8859-15?Q?dsCjA+Yx4s6Z6LwcwbKKMIHIO1zNM4u5XN4VGIDWNoq2jnvXsLszmkSdX?=
	=?iso-8859-15?Q?YWF913RddSWSO8KQBZCZf7n8gZR/pe0BGMSU0m8c95VeXfQTzBeEtH048?=
	=?iso-8859-15?Q?6itD9DxyQG8JjkKTwVIv/4QECxwZ4z6mFVrCctxqT1hW+qKkNXZzslCXP?=
	=?iso-8859-15?Q?VSwMLTNzcaocQW9swgt81JfEClkBNC6rKsBLt16vKwuf6o6jovqZ1wD?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949748c3-73e9-4ab6-3720-08d8b95d4d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 13:56:05.5095 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sXdUGPksWNup9ILJ5cEPpQc3/DO599DdWkcR9MeMUmR7AeAYRWmcI+SbrsA0OxO4O1xGGO72qOjd70QLL0ea0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2999
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10FDuFk0024889
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/6] Multipath io_err_stat fixes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <74C7DBF8C7939242974CE106CDFA3076@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-14 at 20:20 -0600, Benjamin Marzinski wrote:
> I found an ABBA deadlock in the io_err_stat marginal path code, and
> in
> the process of fixing it, noticed a potential crash on shutdown. This
> patchset addresses both of the issues.
>=20
> Changes from v1:
>=20
> 0002: use cleanup_mutex instead of cleanup_unlock as suggested by
> Martin
>=20
> 0003: add pthread_testcancel and use cleanup_mutex instead of
> cleanup_unlock as suggested by Martin. Also, make tmp_pathvec a
> constant
> pointer, since it should always equal _pathvec.
>=20
> 0004-0006 are new patches to deal with io_err_stat issues from
> Martin's
> review
>=20
> Benjamin Marzinski (6):
> =A0 libmultipath: make find_err_path_by_dev() static
> =A0 multipathd: avoid io_err_stat crash during shutdown
> =A0 multipathd: avoid io_err_stat ABBA deadlock
> =A0 multipathd: use get_monotonic_time() in io_err_stat code
> =A0 multipathd: combine free_io_err_stat_path and destroy_directio_ctx
> =A0 multipathd: cleanup logging for marginal paths
>=20
> =A0libmultipath/io_err_stat.c | 216 ++++++++++++++++-------------------
> --
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 25 +++--
> =A02 files changed, 105 insertions(+), 136 deletions(-)

For the series, except 6/6 where I had a nitpick:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

