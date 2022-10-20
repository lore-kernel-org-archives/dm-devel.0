Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D4D2C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666258963;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hkOh9NOVjpq1k6b1ZpcBqntAXvhiNivwjDmk4a4/6II=;
	b=GXtLwhFDn/PHUm19ge8hpwaOkzfqY4cDv3KtNVSplEy7zdKHPZlGQQLYIPPhq8KdA2TASN
	T501RkG1ioEeVGjpVv12uJEr4ONrJEr4O74QDiOlfGKPNJEGO+68QIscZhzxdedOQjB0b0
	h4+3hHK9TmUdtFPuBelc4Y6Bag6y+H4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-2vCPsITvOlCXpGolrLSHuA-1; Thu, 20 Oct 2022 05:42:39 -0400
X-MC-Unique: 2vCPsITvOlCXpGolrLSHuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87D02296A629;
	Thu, 20 Oct 2022 09:42:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A43601415113;
	Thu, 20 Oct 2022 09:42:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E3671946595;
	Thu, 20 Oct 2022 09:42:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A9771946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 09:42:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CED382027063; Thu, 20 Oct 2022 09:42:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C69582024CBB
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 09:42:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A217C3C0CD53
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 09:42:33 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-WlobIauuOqWkzzgzDL7lnA-2; Thu, 20 Oct 2022 05:42:30 -0400
X-MC-Unique: WlobIauuOqWkzzgzDL7lnA-2
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8141.eurprd04.prod.outlook.com (2603:10a6:102:1bf::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 09:42:27 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 09:42:27 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] kpartx: hold device open until partitions have been
 created
Thread-Index: AQHY4+RMyfnYHfgP80ukIxflOmYPeK4XCL0A
Date: Thu, 20 Oct 2022 09:42:27 +0000
Message-ID: <b26ac8580081478d7b8f2bc59abe80948f858db8.camel@suse.com>
References: <1666202230-10397-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1666202230-10397-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8141:EE_
x-ms-office365-filtering-correlation-id: 9ef2b83e-697e-4852-e35f-08dab27f6632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ey1uol9D50g3Qkw8dtn9gWUqFKbL2b9EYK7LxBc/AWJUys5Ao80aGiyV+zPZreR7dZsEM4iKQZFyTL9A7snOaEW4GpucYx0H/bGIwSMTJfEd5Bbmsr8yDFFzeYmWDdzLt1E/aOaAbhWaiIhdQc83lO/+Nvpf4OMtWdYTPo6D0gPBPc00Iy+Tu4tbT3Ssn2M58oCQjmv7UoSpkcfU5nSb2RWaZazXH2Zp7A2BDBLiZ/P3Pxve2gn2hWo1YTqOmO+QLgHnISL4hJ/i0NS6bZhw0ai/dAa8MdWC6bfmHa4zd/JFPvG+MX+NnQES2hMabFo03RlGSR0S4yQXIVPgspIDQi6E+GsqhqnNxUS/xJ0r9CsWOEAy/m/jQbfforkGdULsDc3+m/uUo1Md9sguEX2USyHxMcfK9Fk8skNd42/AtEGxv20stOUS0Q0dlH6NwZlk/g1Zx7DaTzCkvA58Y2J84Iy7rCpTmAqdaDGHXfrbtRs3ILMcPjK6sTttX1KkdFPlOvegYcS0qqX2ooFIOHzC4CBQXGgxf8JsQg7iwU+JSXhqG6tKETSMjqd5ajLnFWXFbVrfbM2nANaxNskMmlKPoT79gvJYgMNzxZSgm7koD56bhnGKIAxs8uqoVac+LkvrsXbfnbDRqxO7jPVtlpwzdKny6Rwogs/q1hgq31zamBEnFNumUAH+EUu73ItDZMe+fhzHhB1nUzYgpYC9KvWAv5uM3UQaN3r5olbVRebIxnJgD7W3O9XIPUbfCzO3HX922gj00v7Rd4/34nImjsoXtQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199015)(6512007)(478600001)(71200400001)(86362001)(6486002)(76116006)(36756003)(66556008)(66476007)(6506007)(66446008)(8676002)(316002)(41300700001)(26005)(4326008)(110136005)(8936002)(44832011)(4744005)(5660300002)(2616005)(66946007)(4001150100001)(2906002)(186003)(64756008)(38070700005)(122000001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?FKgFhtpOCWdR0GzimI3Q9Pz/DpG6GU35P4sDVjejOZea2VGorPGeT5FYW?=
 =?iso-8859-15?Q?aplp7uJSrJiZzJNCylhIZFWloQecLzPWzLTu3IGUzH4ijRV7oWnbAXK+n?=
 =?iso-8859-15?Q?7+EdIg4W7kRfPxavmVPss44vSBb97VgurM1wE0PjY9ad43So8zyxUD7B1?=
 =?iso-8859-15?Q?jdDE/Vmg3s+d2VxSEzI/fWpHHxZH/I9AnAZF0geMhl20Cu0Xb8G21lity?=
 =?iso-8859-15?Q?S8cxYJm8Jmd3BavMv4HbIxyrpyu/j0DWiT9e9TXB9EeygqB5GHL+cxpKS?=
 =?iso-8859-15?Q?2dAAKlnO+B38mmWEJ9+C5ApDdQw8VaWVzseIjj/ISfZvr4L/Yki+X7si5?=
 =?iso-8859-15?Q?fLuSuNYlUkEiiO/0NcCksJS8Q4BK5i+TlfumX7A9cy3qgkd9RuAdmg6eb?=
 =?iso-8859-15?Q?Gkpdud++Ql2ti0jkhsqEgk262r9P0skc0Urbk8nBoKieTMox9SOqY/D2A?=
 =?iso-8859-15?Q?VLQL1G9DpHBTLQ7J1Zn8BYaJkZQz2ila4gMPCRXCdxtpIbGLXu+0XgW8A?=
 =?iso-8859-15?Q?C5276UVsxn/Sm/SnQedry1S7gwqy9CxbUpNHC6s4QGx5bu0kjc3XBEzXi?=
 =?iso-8859-15?Q?HuKwddN221Oobt0NXtnSyO3Frnur+FuCTr+L7MwM3rKAl+azBuV0QaNKK?=
 =?iso-8859-15?Q?B1RE3d5oLKQHajGxkajpwZ0VFgN6+bY5R2Oto3FjMrENFkUH3OpybG+z1?=
 =?iso-8859-15?Q?H0roKpEW6elWgyxhvNtRI/OkPnlsv19I2EaEhKENYu7U30Iz1uyUZHee9?=
 =?iso-8859-15?Q?fAFZIRBZrasomh4ljPM+57Qj7uiJ8NvqBVYzxrglYL0YNnk72NKkF4IOE?=
 =?iso-8859-15?Q?DSXLJJea9MmeAFCxXCmHXqY095LIFI3UTjj6SlKDE1VUTwgFOqa2f0Kgc?=
 =?iso-8859-15?Q?5TnFd25NgjtqzjHR4S1EhOMv/tuNrWNaH8nInRVJSYOJF+6Dv6R3ebUm+?=
 =?iso-8859-15?Q?lQfdV+hckRHYTXk54GWI3dTAvdCyuo4SnsILv59yxT16Ue4SXCgHEAUk+?=
 =?iso-8859-15?Q?p+hy+iSIZeNcxNgM3/xEs87V9ti4JCSNtiH4A85wBDhjvqK/d/c4vlG/Y?=
 =?iso-8859-15?Q?BX1i7HgpL3gtB52tAGi0gNMaRrCBiO+UWRwmJDpmCEVYhB6Yp6czxdvTP?=
 =?iso-8859-15?Q?oPn2gMzdP+FlrKEoyKK3qV4h5nezv+NfTmtWiiYePUtIFxj2udKYnhIcg?=
 =?iso-8859-15?Q?XW4bWME9JdJzPVbll1vPi1yZR1BqoVQvm7VaV+4uoDcKV54iIZIUeMeMl?=
 =?iso-8859-15?Q?Oj7QXanyKFgsXCf5mMr8YZnt6uCx2RPNro2p1aCBqeL2rsVoj/LgCVbjF?=
 =?iso-8859-15?Q?3ZxIiFstCYNIN0PHpM49id+jFfYSQOaMScRbohzAPsNKSuO1I8jiEg6TD?=
 =?iso-8859-15?Q?M2rGyXogpETFFDk5E1zxa9fyzutV51OceMcUpXAg1tK51pfR4Y6uw1RA+?=
 =?iso-8859-15?Q?NOVEUQfnVP+o4iuPc1NvMAaWSCPUyiprjSkJ5N35ddQz6HIO0kcXwqt/T?=
 =?iso-8859-15?Q?Nac9HQyV7H4Mqk7MESP54Xno2lkjfvfyNtIJHCCC7NAPoxHVJp8FLXj/B?=
 =?iso-8859-15?Q?cKnXHXczGL5IQTIA6BLvPDg5l5mmPeQJ4Zym2/lgc+bvrX0nuhqXhUDDj?=
 =?iso-8859-15?Q?SzQxx8ZhuiDIQ9oVKrVX80G4MX5BxaisjdXIz0gX9z/2i/7Gxkffwiijy?=
 =?iso-8859-15?Q?RKIQ7dL0yoJF/UViREgt3oAwVQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef2b83e-697e-4852-e35f-08dab27f6632
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 09:42:27.1079 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxz73FAtjuwdf4h7kf6bU0SJLeCorGVv1DNWiqXAIa0HjpI2qnm9O4pMWvCqmlx1WdT3ezuQh+4hOngSUu7wgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8141
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] kpartx: hold device open until partitions
 have been created
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
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4514F99D292CBE44A80414F1C5F77289@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-10-19 at 12:57 -0500, Benjamin Marzinski wrote:
> kpartx was closing the whole device after it read the partition
> information off it.=A0 This allowed a race, where the device could be
> removed and another one created with the same major:minor, after
> kpartx
> read the partition information but before it created the partition
> devices.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

