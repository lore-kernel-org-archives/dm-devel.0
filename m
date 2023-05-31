Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA3CBC7EE2D
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685547848;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2gUMzaqb63Ov+7a7K22fAcHwDRFFwxIlomeBWo5AU6g=;
	b=FvEXF6DBcl6dV+liXyuH8IBF8fFsSsE1q1XKlglZRAn4AVL4Ixrynh0UxemPnCvMpk9r3E
	fXEhZ0vS+uZZfoAGqLsJQrvbtKgG7r4ogyaDTv/MQZS2ngQzufOkzOTKASWFa9iQos9dU1
	mB2r9biG37b7r7/kTzps5G+8zmeoar4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-yjCt7TfwOESqLgDOIjDD1Q-1; Wed, 31 May 2023 11:44:05 -0400
X-MC-Unique: yjCt7TfwOESqLgDOIjDD1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 324E7280BC8B;
	Wed, 31 May 2023 15:44:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04C80140E962;
	Wed, 31 May 2023 15:44:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9347819465B7;
	Wed, 31 May 2023 15:43:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 418CC19465B9
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:30:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D75C492B0B; Wed, 31 May 2023 15:30:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 242F3492B0A
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:30:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05486811E97
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:30:28 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2071.outbound.protection.outlook.com [40.107.15.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-K12woYxhMP2IbVLjkYKYnA-1; Wed, 31 May 2023 11:30:13 -0400
X-MC-Unique: K12woYxhMP2IbVLjkYKYnA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by GV1PR04MB9085.eurprd04.prod.outlook.com (2603:10a6:150:20::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 15:30:03 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:30:02 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] multipath-tools tests: add tests for group_by_tpg
 policy
Thread-Index: AQHZiqX5kbej4m74xEu6OQG2zGRhWq90lDuA
Date: Wed, 31 May 2023 15:30:02 +0000
Message-ID: <8ae8ff6b0d7d02d33da5b894c3ff1b0e4cdd8a9e.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|GV1PR04MB9085:EE_
x-ms-office365-filtering-correlation-id: 01893e86-4fd8-48ac-756b-08db61ebe754
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Zh+dy1HkEDZv1W9Hr1wiqeMp7txb5KNNlA58X/AkYWx4fZTiJ4eq02saZiBUJld99B3f2t1BFnTPd6ZFdKoxAKh72LSuU9+vMWlXPYhkQ4OLoTZ5pu6MxHWEHRs/oHIbF/f3adrZjHCFG5MN53qvH0Kijza+mJpE4S1aZRPW2yEPlYz2WUHOm7L+M3LGrINryW5Srs0QphH20WGxBF+jObtZ1Rsi8kX86vpoem+YmmZuO9NhjBgXFYk0w7+oC6NDRMASXzsq1TD3DJB3G56lP8XN82sTJBFlgS2Tskzna7ks/UcuG+wklqT7U+K+WIVX4plvqfFdI/a30kTUKOpgyC030pRfA9VX+9y+370YMO1I21lCqqR0ouu71GINHpSkk2BMCxn9aAMDTBN+VfWcbEeAI4h7C6Infjor6tkg8GHVNDnE5GewbeuqeWHLRcCUhaXdfSAuOzn31I/jf0A1qc6HysCyLI4wppOOSgHl4RjcLm/RULxhbEV7k8LeMgHWWfmIAj57B4VYtFCLoISrkUg6OLB19STMjyEoGCfLy4fLG2zDu+LVvzxH70xV1rBa29UkWOpIboVdRCD4EO2ma3j4V4ikL45Xul1/lKeHpmm/2U4zROVA5dRjkqlUNDDx
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(83380400001)(66946007)(66446008)(66476007)(66556008)(64756008)(76116006)(91956017)(26005)(71200400001)(6506007)(6512007)(478600001)(110136005)(2616005)(186003)(8936002)(2906002)(86362001)(8676002)(5660300002)(44832011)(6486002)(36756003)(122000001)(4326008)(38070700005)(38100700002)(41300700001)(316002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?m8CSB6MIXbacAGM96XZZqfqBBz5rw9lvbJ7mGzC7IB5in55gf8oORLI4u?=
 =?iso-8859-15?Q?O+HvCmxKkzxw+W4xulMy+KrNM3kGCcjmTNci146We+6JdmaUIwVxNjiL9?=
 =?iso-8859-15?Q?CMQcYsbnGDLT/JofpEHDSsjgt8N/XyXCc7Ooxu+nlZJ9igEnMx4Kust84?=
 =?iso-8859-15?Q?R3z5JqJhjETr8fJRIVTCZvneFEbpRAe7GwqIapslUZRuDoUM3hc7V1Z1z?=
 =?iso-8859-15?Q?WuYUrnVnXmZT5BpwZcA4duuFjLu3vDaeXsJFDM1zVEvuxOuzEFw/NYMTX?=
 =?iso-8859-15?Q?JLHVV9DoW4Fp3uwsdXn0DEe3k+v0B9OXm/qPvG6CC/CW5VOJEEOzTUgoi?=
 =?iso-8859-15?Q?P2PJzp0ZVCNg9TMlF0DJBEqm3rf0u94dFphHL8u3Lx3kegkpWGnsPQdLy?=
 =?iso-8859-15?Q?nARW07c3I4Nz3xOedORShKt97WcR5+RAjBOQVTpCl5yzyjZO5H8L5b+3J?=
 =?iso-8859-15?Q?/hPpp/8URnJ1yHxSkC5KvdhiUeImH65Uz5GAjV/4WxGZuSgQd6BpcVWHw?=
 =?iso-8859-15?Q?OrIltB8ujauUzYTleqW2DFrrrH6zAAnieZNhiYyPhE0ZCLhlJpEd7Ro/A?=
 =?iso-8859-15?Q?RK/YcowtF7RtbHSWeEnR2y21ZulSDgHHWMgOlqw1GxFjfzUn00niGGbDq?=
 =?iso-8859-15?Q?LBUI/5feemPPlksE7SMCxdJ0lQgIRYgwmZSTVMouoT8chRvkV8ydqIwLg?=
 =?iso-8859-15?Q?p+Ze3kJIfm7238NfLCSinr6C8Ap6YltLhryNRHSs+KusXYHXzhbIaEaOU?=
 =?iso-8859-15?Q?mFxPCEcBdXxLOOLUy40O1Jnn3ICM30JfZZsnqxrZt6rAcEtZQgGiS7chb?=
 =?iso-8859-15?Q?I/+1uQsbqewCejjZRBJK8c+9g7/GT9bx3NOcqHPmk9KPWUstOqxc5KVj4?=
 =?iso-8859-15?Q?EPWTIadUugC8idbV8rWVX3TeZL1van6oSqUnDYs6iShwDFZqt3fNUSZxw?=
 =?iso-8859-15?Q?tT5XAMjF00Z3MOL/A6rBzDBJ/85ZFGcMg3NK0eMYBeVuzm1xuHmHP3TbB?=
 =?iso-8859-15?Q?VgdLKh7fRoVD1drDYRHGK8rz/jLp3cdXANIYBfISMja8YKvl+vpfCj7pS?=
 =?iso-8859-15?Q?bwHNMUno8heMVcuUttKP3r7zQcLyO5k3voNZaScw31QyG3MaE9LKX4+AK?=
 =?iso-8859-15?Q?AcJx9OiiuaN/Bv+ItDA93b9JQ6g7eXXdCCYTP01qRaqDKdg2MLjkJkdNP?=
 =?iso-8859-15?Q?HDMCnNZ7JAIZzWJoll98weNKTzpu5MJ/6SOwM+7Twp7GLBdvXtpocSBiX?=
 =?iso-8859-15?Q?pIVvBXjigtil4NEy5fjz+wsPmId/3YkbD+SyFL8UuRLskwDR2h/NJasJu?=
 =?iso-8859-15?Q?vmMFbI0iG1vsG+tqb6PvwD1StTNjjScM5dTKStzrio9CeomoPBOjKb6LZ?=
 =?iso-8859-15?Q?pQ4vbuEX4l14PJPptEzfWWI3JdsVvjaiAEibJ2+fnz4VtAzOWfH3lpCmB?=
 =?iso-8859-15?Q?0VYf3okx0Cq9H7IeoHTDe1x0Y1sW/afv/MDsk5YH0Oj3dJTXq/C/ebXr4?=
 =?iso-8859-15?Q?AHvi4PsEMqxc+CxeYsozhwOXqTF6oDqp+VY7EqemdcRVYQ1oRUrgcF1Pg?=
 =?iso-8859-15?Q?4gtw4zWUcvBKVK5jG+kuRt8JViQzPn041YeRzOmK2CblxL6xGFseVAiac?=
 =?iso-8859-15?Q?sMaskPv7sHXYV+YL24e9KYjRAgIJZQ15ktS1E+6nhh6HtFRJ3bFf3K+op?=
 =?iso-8859-15?Q?TK2W?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01893e86-4fd8-48ac-756b-08db61ebe754
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:30:02.9311 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PY35POIrOY18UpMU6l21BPkAI2uoAwcOW7JE3+bCa0Gnl4AtOI1Uu1UgiulfFYQmIwitJq12rJ6IGGvSkfQ1zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9085
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 4/5] multipath-tools tests: add tests for
 group_by_tpg policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <64473865AF898F428AF0908CE8DA37B9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I wonder if it might make sense for group_by_tpg to mock calls to
getprio (assigning the prio from the path's TPG ID) rather than calling
set_priority() directly.


> ---
> =A0tests/pgpolicy.c | 201
> +++++++++++++++++++++++++++++++++++++++++++++++
> =A01 file changed, 201 insertions(+)
>=20
> diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
> index 43be831f..85fa30ce 100644
> --- a/tests/pgpolicy.c
> +++ b/tests/pgpolicy.c
> @@ -32,6 +32,15 @@ struct multipath mp8, mp4, mp1, mp0, mp_null;
> =A0struct path p8[8], p4[4], p1[1];
> =A0
> =A0
> +static void set_tpg(struct path *pp, int *tpg, int size)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +
> +=A0=A0=A0=A0=A0=A0=A0for (i =3D 0; i < size; i++) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp[i].tpg_id =3D tpg[i];
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> =A0static void set_priority(struct path *pp, int *prio, int size)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> @@ -639,6 +648,187 @@ static void
> test_group_by_prio_mixed_one_marginal8(void **state)
> =A0=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 7);
> =A0}
> =A0
> +static void test_group_by_tpg_same8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int paths[] =3D {0,1,2,3,4,5,6,7};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {paths};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {8};
> +
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 1);
> +}
> +
> +static void test_group_by_tpg_different8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {1,2,3,4,5,6,7,8};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {3,5,4,1,8,6,7,2};
> +=A0=A0=A0=A0=A0=A0=A0int paths[] =3D {7,6,5,4,3,2,1,0};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {&paths[0], &paths[1], &paths[2],=
 &paths[3],
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 &paths[4], &paths[5], &paths[6],
> &paths[7]};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,1,1,1,1,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 8);
> +}
> +
> +static void test_group_by_tpg_mixed8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {7,2,3,3,5,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,3,3,4,2,5,6};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {2,3};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {1,5};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {7};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,2,2,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 6);
> +}
> +
> +static void test_group_by_tpg_3_groups8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {1,2,2,1,2,1,1,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,2,1,3,1,1,3};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {1,2};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {4,7};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {0,3,5,6};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {2,2,4};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 3);
> +}
> +
> +static void test_group_by_tpg_2_groups4(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {2,1,1,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,2,1};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {0,3};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {1,2};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {2,2};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p4, prio, 4);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p4, tpg, 4);
> +=A0=A0=A0=A0=A0=A0=A0mp4.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp4, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp4, p4, groups, group_size, NUL=
L, 2);
> +}
> +
> +static void test_group_by_tpg1(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int paths[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {paths};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1};
> +
> +=A0=A0=A0=A0=A0=A0=A0mp1.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp1, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp1, p1, groups, group_size, NUL=
L, 1);
> +}
> +
> +static void test_group_by_tpg0(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0mp0.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp0, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp0, NULL, NULL, NULL, NULL, 0);
> +}
> +
> +static void test_group_by_tpg_null(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0mp_null.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp_null, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp_null, NULL, NULL, NULL, NULL,=
 0);
> +}
> +
> +static void test_group_by_tpg_mixed_all_marginal8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {7,2,3,3,5,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,3,3,4,2,5,6};
> +=A0=A0=A0=A0=A0=A0=A0int marginal[] =3D {1,1,1,1,1,1,1,1};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {2,3};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {1,5};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {7};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,2,2,1};
> +=A0=A0=A0=A0=A0=A0=A0int group_marginal[] =3D {1,1,1,1,1,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_marginal(p8, marginal, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 1), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 6);
> +}
> +
> +static void test_group_by_tpg_mixed_half_marginal8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {7,1,3,3,3,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,3,4,5,6,7,6};
> +=A0=A0=A0=A0=A0=A0=A0int marginal[] =3D {0,0,0,1,0,1,1,1};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {2};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {1};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {3};
> +=A0=A0=A0=A0=A0=A0=A0int group6[] =3D {5,7};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5, group6};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,1,1,1,2};
> +=A0=A0=A0=A0=A0=A0=A0int group_marginal[] =3D {0,0,0,0,1,1,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_marginal(p8, marginal, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 1), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 7);
> +}
> +
> +static void test_group_by_tpg_mixed_one_marginal8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {7,1,3,3,5,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[]=A0 =3D {1,2,3,3,4,5,6,5};
> +=A0=A0=A0=A0=A0=A0=A0int marginal[] =3D {0,0,0,0,0,1,0,0};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {2,3};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {7};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {1};
> +=A0=A0=A0=A0=A0=A0=A0int group6[] =3D {5};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5, group6};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,2,1,1,1};
> +=A0=A0=A0=A0=A0=A0=A0int group_marginal[] =3D {0,0,0,0,0,0,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_marginal(p8, marginal, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 1), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 7);
> +}
> +
> +
> =A0static void test_group_by_node_name_same8(void **state)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char *node_name[] =3D {"a","a","a","a","a","a","a=
","a"};
> @@ -1002,6 +1192,17 @@ int test_pgpolicies(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_all_marginal, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_half_marginal,
> 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_one_marginal, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_same, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_different, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_mixed, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_3_groups, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_2_groups, 4),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g, 1),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g, 0),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g, _null),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_mixed_all_marginal, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_mixed_half_marginal, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_mixed_one_marginal, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_same, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_increasing, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_3_groups, 8),

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

