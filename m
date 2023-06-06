Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBE4C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686063345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DwL5UmEi/AUgZin0zCbd7GlO18XNCDSwp4EANYKRNFk=;
	b=USIATpIhmlpNbvTr3tGEv/k/MLrKh6wb2n6sAQomfPoLuRWRVw+FzGPk4MTIo6nMhew8Kx
	BSSrbtfxtzhp6cH7IzTpo7AnPm9mJayyDskhxaxjRsWhXxBdGMbNn6+fXZVIDDbXBTDYWu
	lTCbkq5KX8MAcBMGbJCU5OIUFbRg0Jw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-WcspuN3YMxChhsOaE7rZNA-1; Tue, 06 Jun 2023 10:55:43 -0400
X-MC-Unique: WcspuN3YMxChhsOaE7rZNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B7ED811E7F;
	Tue,  6 Jun 2023 14:55:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82E7A492B00;
	Tue,  6 Jun 2023 14:55:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3020A19465BC;
	Tue,  6 Jun 2023 14:55:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 14C0819465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 14:55:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03C7CC16044; Tue,  6 Jun 2023 14:55:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EED4DC1603B
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 14:55:38 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAF1085A5AA
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 14:55:38 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur02on2059.outbound.protection.outlook.com [40.107.249.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-PPiW3V8UN36H7d0QsYUVQw-1; Tue, 06 Jun 2023 10:55:32 -0400
X-MC-Unique: PPiW3V8UN36H7d0QsYUVQw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by GV1PR04MB9215.eurprd04.prod.outlook.com (2603:10a6:150:2a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 14:55:27 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 14:55:27 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 4/5] multipathd: reload map if the path groups
 are out of order
Thread-Index: AQHZjpZ2q6vNqLfPoUixhg0FPwfDKa98pQ7/gACgTYCAAKtSAA==
Date: Tue, 6 Jun 2023 14:55:27 +0000
Message-ID: <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
 <20230605190807.GT24096@octiron.msp.redhat.com>
 <20230606044215.GV24096@octiron.msp.redhat.com>
In-Reply-To: <20230606044215.GV24096@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|GV1PR04MB9215:EE_
x-ms-office365-filtering-correlation-id: 5f8dcb26-2313-4b96-f6f2-08db669e10d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +9mzowWFvIjHc4McnwRC07Dahp5QlD/psy7nme8OgBujnOQ0x3pMEJQ1T+RDVXpbndZ4S0nZoP8NDrsWi8/oIaXlgdyxxMBCX3ZKq+51McpebkoMXwZpdx7KV0fKXrh9jvbK7Q6PAK5/j5oQuWiN8kKA3ZzdU3155rg/l9MG/0POS+luzdjvhZOMVukW9RiZyi4Wg+iw0bQq5KO4Dk/iOCirEFk55WWxVrjTk6zbqo8lIQ1L64xZ5fD+inFsPiI8Po5zfVUMXY5OkVfgU1rqL9nzZpGp2DwFbkZViMg+NNn2PoVzm3RfXuCKhEoiKqj9SQ4n/S5b0aWQY39Fc/kdA+MgfHQQrFO41JbYWpnHgyyEskRIr7d7Ox89cw+IgPygOW+NuF/fiS9biHfFCJT2bwXp+A9nld2ds1L2bt+mMbj7BH2gPLF6AZSXHVnmupkMNjKqjnjMMPrhGvtgf/StEf/0ksJAM8e5wmF+nUEk3j20b57bkHLNraDuPr56N3izOc3duKI+/312tpBwQB57phvS301stV/8KjVsFYdBAygeQExrtySlfQOUx/kHMFPt07X9GJaDYljsnHo9L5Mp++gpPtAoxiKSRbwOtFVQKK467O7iyfHto3mWXHB2xoHJ
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(8676002)(8936002)(478600001)(41300700001)(6506007)(5660300002)(316002)(6486002)(66446008)(26005)(44832011)(4326008)(91956017)(64756008)(66556008)(66476007)(6916009)(71200400001)(76116006)(66946007)(450100002)(6512007)(2616005)(186003)(83380400001)(2906002)(122000001)(38100700002)(86362001)(36756003)(38070700005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XlCIHZs9S69Kt8KIlOwkC5fgYtkH2f8VsavL1He1G33ajtIbFgLFd6e+9?=
 =?iso-8859-15?Q?VCj/Hrb5bbHY99u7FL89LdH9v927NAN8ba1nTouIZ0f//i8Ls+bKnCi/w?=
 =?iso-8859-15?Q?ecAcH6Fv9gKEOhaXLND6dI73jQUOfR47T9w1E63s0hVAuphfm57sXuuF0?=
 =?iso-8859-15?Q?1ut0Af/AVGDTn5DPY70D/QBuk4kdeV1OonaT5j7mxOKB7UOzX5j8n3Ur6?=
 =?iso-8859-15?Q?H1Bo1LXIk7xBtTTfgOS4bbi9JA6oZW89PB9/L7bRPt8J451ea5KM1zof3?=
 =?iso-8859-15?Q?t+5Ai2iImtm1NeF3rZgN0I/jNwCQvxMZxE0hRIRkNgoEYbUi3eRzpB3XW?=
 =?iso-8859-15?Q?qUfGZE5kn0tJtO5YtpQo0De3Fr7C2+82XUvZcpE8VgtsXhaYfCenyMNqQ?=
 =?iso-8859-15?Q?Dkk+wqUt4IinQHPEazl1lSTO0XwlmgzoPPyAzrYj4ov/bdD7C3N79I4rP?=
 =?iso-8859-15?Q?FiodJ6Rqga+esQHQrF+K0UadrTQvMPYTL9/wko+EZbxeTAWPROppIjlTu?=
 =?iso-8859-15?Q?4nOC8Jj5RmZe28X/Zgp8Vgzmi+rj0wlhBSXhS7hkOPg471dzqYqUKw8W9?=
 =?iso-8859-15?Q?lnHE+nGTEvHOB8vQ5eeDDTzL88o3HUNb/5Dqpld5MHNmPoNahgF5hU7h1?=
 =?iso-8859-15?Q?lFe41lCSXeGMLroNjLIjBE6MLMxS23qY6Ru6JysUXTHHpmbDVeqPFRC1N?=
 =?iso-8859-15?Q?YJ01m+O8Gu1FZdFslvHA9JNvW3FgCgZRmzuLzTM6y4gLUi+zkgpBC0vM3?=
 =?iso-8859-15?Q?nNfugPgH5zlWKc6BL2p7tFfhID+NZWwnILb30DpEAAaMux75KDrolEV3X?=
 =?iso-8859-15?Q?02xF2jEhzRSERgVCd8jYQRorZsn329MkBiEk8ZkWzhFd8zoGLwGPQ1dDh?=
 =?iso-8859-15?Q?m0m0LcA6F54WIqFlcd6wJytL0YcDlPhJKKmXTZYrk9goNZpS4SWj1OPuR?=
 =?iso-8859-15?Q?shR816LtDJ/smYOxb1ZdALXS4wvQR3lDWHxDbl0JO4+6PkNR8o+9uJR5+?=
 =?iso-8859-15?Q?oBqWftO5vLGON47CIXbdSxPntjzeGj/HRMNmYGfET5PAyr8iTtRLzPHCo?=
 =?iso-8859-15?Q?Dpt/u9VnA6odPQJ0qYCossRyeftR9uCJOKyhXkXVMQVGLICxql1LUcnJn?=
 =?iso-8859-15?Q?V/bB2dEgfqF6xzNXdZiRnotVx553r6uwOycz4A+Hm4F1lXYQ29CDYzMd9?=
 =?iso-8859-15?Q?sM3mnUOGSnVahvxelrWAGbBrMw6i1FETC2HRI5Z0erAWglgMlJHdmjIjz?=
 =?iso-8859-15?Q?VCER1LuhQL61EaD1o4vt4SqMcsokwdKPFtRPr+2DyI4Ju11GkD0bUkjJw?=
 =?iso-8859-15?Q?R3h4kT2NakpaEhnIlyIctWqvtAxRmU75Z/hLg70+ZU+tMLMP095pTWiWQ?=
 =?iso-8859-15?Q?6KZ3TT4f2oxSoq+y2Tbxyo61rL482vhvZeRnx5VL381V1ueGHZZ7+K5Nm?=
 =?iso-8859-15?Q?D28V+m0Fxa05mGUz1eOT0HP0MAk9aKX7XqImFUoOsRxJZOZuqKj/2PLeA?=
 =?iso-8859-15?Q?sZk3AM8bcnpwfCHXMM6wjfOUXjyMoLOaNdjI+CxWuYn5kZnBxWvK0SFqY?=
 =?iso-8859-15?Q?5Y868s8rd6NG4Mr4SaFhuYGmAnbSVqGCa63KDJarmP0X4cpvfl6HEMFlV?=
 =?iso-8859-15?Q?LlIrEwzC4woEAsM9vpi3Vo0iysMRcX0Qc0rmLWM0xNNF2kw3F04O2+NhJ?=
 =?iso-8859-15?Q?GJ60?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8dcb26-2313-4b96-f6f2-08db669e10d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 14:55:27.6244 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5+77KNvRWViRDsRN8Oaz01J4FBKzNzUk4h/csKUoJmaIXqHkkJu+JzREZOQeNtv1eNKDOcPuXrD0sYlCXE57w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9215
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reload map if the path
 groups are out of order
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
Content-ID: <74E6E4A985E58A48B094C612045301BE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-06-05 at 23:42 -0500, Benjamin Marzinski wrote:
> On Mon, Jun 05, 2023 at 02:08:07PM -0500, Benjamin Marzinski wrote:
> > On Wed, May 31, 2023 at 04:27:30PM +0000, Martin Wilck wrote:
> > > On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > > > need_switch_pathgroup() only checks if the currently used
> > > > pathgroup
> > > > is
> > > > not the highest priority pathgroup. If it isn't, all multipathd
> > > > does
> > > > is
> > > > instruct the kernel to switch to the correct pathgroup.=A0
> > > > However, the
> > > > kernel treats the pathgroups as if they were ordered by
> > > > priority.
> > > > When
> > > > the kernel runs out of paths to use in the currently selected
> > > > pathgroup,
> > > > it will start checking the pathgroups in order until it finds
> > > > one
> > > > with
> > > > usable paths.
> > > >=20
> > > > need_switch_pathgroup() should also check if the pathgroups are
> > > > out
> > > > of
> > > > order, and if so, multipathd should reload the map to reorder
> > > > them
> > > > correctly.
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > > =A0libmultipath/libmultipath.version |=A0 5 ++++
> > > > =A0libmultipath/switchgroup.c=A0=A0=A0=A0=A0=A0=A0 | 27 +++++++++++=
+++++++++++
> > > > =A0libmultipath/switchgroup.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > > > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 38 +++++++++++++++++++++--
> > > > ------
> > > > --
> > > > =A04 files changed, 59 insertions(+), 12 deletions(-)
> > > >=20
> > > > diff --git a/libmultipath/libmultipath.version
> > > > b/libmultipath/libmultipath.version
> > > > index 8f72c452..38074699 100644
> > > > --- a/libmultipath/libmultipath.version
> > > > +++ b/libmultipath/libmultipath.version
> > > > @@ -237,3 +237,8 @@ global:
> > > > =A0local:
> > > > =A0=A0=A0=A0=A0=A0=A0=A0*;
> > > > =A0};
> > > > +
> > > > +LIBMULTIPATH_19.1.0 {
> > > > +global:
> > > > +=A0=A0=A0=A0=A0=A0=A0path_groups_in_order;
> > > > +} LIBMULTIPATH_19.0.0;
> > > > diff --git a/libmultipath/switchgroup.c
> > > > b/libmultipath/switchgroup.c
> > > > index b1e1f39b..b1180839 100644
> > > > --- a/libmultipath/switchgroup.c
> > > > +++ b/libmultipath/switchgroup.c
> > > > @@ -7,6 +7,33 @@
> > > > =A0#include "structs.h"
> > > > =A0#include "switchgroup.h"
> > > > =A0
> > > > +bool path_groups_in_order(struct multipath *mpp)
> > > > +{
> > > > +=A0=A0=A0=A0=A0=A0=A0int i;
> > > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup *pgp;
> > > > +=A0=A0=A0=A0=A0=A0=A0bool seen_marginal_pg =3D false;
> > > > +=A0=A0=A0=A0=A0=A0=A0int last_prio =3D INT_MAX;
> > > > +
> > > > +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(mpp->pg) < 2)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > > > +
> > > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pg, pgp, i) {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* skip pgs with PRIO=
_UNDEF, since this is
> > > > likely
> > > > temporary */
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pgp->paths || pg=
p->priority =3D=3D PRIO_UNDEF)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal && =
!seen_marginal_pg) {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0last_prio =3D INT_MAX;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (seen_marginal_pg =
&& !pgp->marginal)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return false;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->priority > l=
ast_prio)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return false;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_prio =3D pgp->pr=
iority;
> > > > +=A0=A0=A0=A0=A0=A0=A0}
> > > > +=A0=A0=A0=A0=A0=A0=A0return true;
> > > > +}
> > > > +
> > > > =A0void path_group_prio_update(struct pathgroup *pgp)
> > > > =A0{
> > > > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > > > diff --git a/libmultipath/switchgroup.h
> > > > b/libmultipath/switchgroup.h
> > > > index 9365e2e2..43dbb6c9 100644
> > > > --- a/libmultipath/switchgroup.h
> > > > +++ b/libmultipath/switchgroup.h
> > > > @@ -1,2 +1,3 @@
> > > > =A0void path_group_prio_update (struct pathgroup * pgp);
> > > > =A0int select_path_group (struct multipath * mpp);
> > > > +bool path_groups_in_order(struct multipath *mpp);
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index e7c272ad..2ea7c76b 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -396,7 +396,7 @@ void
> > > > put_multipath_config(__attribute__((unused))
> > > > void *arg)
> > > > =A0}
> > > > =A0
> > > > =A0static int
> > > > -need_switch_pathgroup (struct multipath * mpp, int refresh)
> > > > +need_switch_pathgroup (struct multipath * mpp, int refresh,
> > > > bool
> > > > *need_reload)
> > > > =A0{
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > > @@ -404,6 +404,7 @@ need_switch_pathgroup (struct multipath *
> > > > mpp,
> > > > int refresh)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> > > > =A0
> > > > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > =A0
> > > > @@ -430,10 +431,9 @@ need_switch_pathgroup (struct multipath *
> > > > mpp,
> > > > int refresh)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > =A0
> > > > =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> > > > -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > > > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp);
> > >=20
> > > This will start another loop over the path groups. Can we just
> > > integrate the path_groups_in_order() logic into the loop right
> > > here?
> > >=20
> >=20
> > Sure
>=20
> Actually, after looking into this more, pushing those two functions
> together makes the logic more confusing. Plus select_path_group() is
> used by multiple other functions that don't need to check if the path
> groups are out of order.

Hm. Can it happen at all that select_path_group() returns something
other than=A01 but path_groups_in_order() returns true?=A0

If we follow the mindset you layed out in your patch ("the kernel
treats the pathgroups as if they were ordered by priority")
consequently, just determining bestpg is not enough; we'd need to sort
the PGs every time (except for a user-triggered switchgroup command).
IMO whenever we reload the map anyway (e.g. in setup_map()) we should
make sure that the PGs are properly sorted. Using "switch_group"
instead of a full reload is just an optimization because the kernel
operation is more light-weight than a full reload. But as soon as we
have e.g. a marginal path group, reordering is probably a better idea
most of the time.

I agree that that would be another patch set, but I think that
determining the best path group and checking whether the groups are
correctly ordered are very closely related tasks.

But it's not a religious matter to me, so proceed with what you
consider best at this time.

> There's no reason for path_groups_in_order to be in libmultipath,
> since
> it's only needed by multipathd. I'll fix that. But I would rather not
> join it with select_path_group(). Since we just loop over the
> pathgroups
> and not the paths within them, we will likely go through the loop a
> couple of times, and we don't actually perform any costly actions
> during
> the loops that would make combining them look more attractive. The
> performance gains for need_switch_pathgroup() aren't worth making the
> logic harder to follow (and the minor performance hits when we don't
> need to check the order), IMHO.=20
>=20

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

