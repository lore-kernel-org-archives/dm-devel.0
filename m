Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D337C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 16:21:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 09B6165103
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 16:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09B6165103
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-Ua4C6adQPYOXG7MLP_46oA-1; Tue, 16 Mar 2021 12:21:01 -0400
X-MC-Unique: Ua4C6adQPYOXG7MLP_46oA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A74CA93920;
	Tue, 16 Mar 2021 16:20:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A82A6E6F5;
	Tue, 16 Mar 2021 16:20:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EC7D57DC1;
	Tue, 16 Mar 2021 16:20:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12GGKrS1002259 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 12:20:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 25E192166B44; Tue, 16 Mar 2021 16:20:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C93E2166BA2
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 16:20:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 521FD80A0B0
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 16:20:49 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-418-FMMayC70MK61oKjA7LsQ7Q-1;
	Tue, 16 Mar 2021 12:20:44 -0400
X-MC-Unique: FMMayC70MK61oKjA7LsQ7Q-1
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 6E3B1423B1;
	Tue, 16 Mar 2021 12:20:40 -0400 (EDT)
Received: from BYAPR14MB2758.namprd14.prod.outlook.com (2603:10b6:a03:dd::14)
	by SJ0PR14MB4774.namprd14.prod.outlook.com (2603:10b6:a03:377::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31;
	Tue, 16 Mar 2021 16:20:33 +0000
Received: from BYAPR14MB2758.namprd14.prod.outlook.com
	([fe80::3cc4:bd31:5b40:f77e]) by
	BYAPR14MB2758.namprd14.prod.outlook.com
	([fe80::3cc4:bd31:5b40:f77e%7]) with mapi id 15.20.3933.032;
	Tue, 16 Mar 2021 16:20:32 +0000
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v7 3/3] dm: add DM_INTERPOSED_FLAG
Thread-Index: AQHXF1a3wWnmou/FMES2DaVQsQhHUKqDOrUAgAIGKICAAYEFAIAAAH8AgAAPajA=
Date: Tue, 16 Mar 2021 16:20:32 +0000
Message-ID: <BYAPR14MB275852075C4C032E029D0233F56B9@BYAPR14MB2758.namprd14.prod.outlook.com>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-4-git-send-email-sergei.shtepa@veeam.com>
	<20210314093038.GC3773360@infradead.org>
	<20210315132509.GD30489@veeam.com>
	<20210316152314.GA55391@infradead.org>
	<20210316152500.GA55711@infradead.org>
In-Reply-To: <20210316152500.GA55711@infradead.org>
Accept-Language: ru-RU, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [86.49.140.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cee9e820-45d1-47cd-d844-08d8e8976c71
x-ms-traffictypediagnostic: SJ0PR14MB4774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR14MB47741CDA44D8FC7487B51FB8F56B9@SJ0PR14MB4774.namprd14.prod.outlook.com>
x-veeam-mmex: True
x-ms-oob-tlc-oobclassifiers: OLM:5236
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: e0oEpLFgiQyxG9uR5O9kKg8//sB3pWgsUgCqiD3KfNetP3Z4fZiu08p3rm3Sq+Ndn2H2si0eL8Mnpgd7biBK18QpW3sNjzlVWQddQR6r2HWpYxfUUIxLsvpV3sQ65VIdpYVEnYOayjlUCYre5fPMwPS2co3P9C+JMNl66yq4ADRsQmAuzPuu2y0y/T876jYqn5NtJsZfh6pMqAE2EVH4w+xiaMuBQuDDBpEXMQCSxGWwUjd7hdXQ9+li1VHTIDBR5ipYWEE8EEIKs4ZuES9s9S6aL2q9aohrh1US1L+FePQRAf9RgCaDCrowh0aiL7CJC83NjqNARnEkUu/nCGrFDs2JIOuvRyS0V7dY44Ibii7QmxLg/AF3FYWiEmwYVZaBuYdwYobzDFEpNE4GP2E9vpeX9rVcIuMczgAa+hq8yA1DB0NV4v1IHNUMoAw08qTGcu9GGUiXJ7CmL5QT6fuzNiZnCPRRE8Gi/hK3i6c+C8DKDHeXhNolgKEgcHmYfdNDqvs+Nx8I4nNOXEnfg0i6MRdukSTZM9KVa4eEFBDfNwD6ykBRAemeMg1ItHga3pzR
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR14MB2758.namprd14.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(316002)(186003)(107886003)(66556008)(44832011)(26005)(86362001)(76116006)(6916009)(71200400001)(66946007)(54906003)(7696005)(66476007)(4326008)(8936002)(5660300002)(6506007)(33656002)(2906002)(66446008)(8676002)(64756008)(9686003)(478600001)(55016002)(558084003)(52536014);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?URFQp59IXBqvlSEXsoQ3dAy3cRC5pbZ66yo09ui8GWUfJXhiFAE5ZlfaOwyH?=
	=?us-ascii?Q?FMdJJ/jY27Fw10X35G1bH+Vsgl9uJyOOloPxAVaVszg6DTwzE2CmXpMVWSth?=
	=?us-ascii?Q?7/gHy/TaYvSMFocmcR7/w6Bs43NvDEPszvs6nXlF3w4cYUug6t+ym4q6Vq4v?=
	=?us-ascii?Q?wVILrHDvmMx6E9jw84esYKbcIlqRnr2rxOA2j6wQZPvL/+pg0Z1k2vXmJ1an?=
	=?us-ascii?Q?baFw5D4esFpNwsFS1CmnlYLljbV97xV4JOoQtwlpHa9nhgF8BXfCF/H6lD3A?=
	=?us-ascii?Q?n+LXyLKOgSU/M3B4OXxhf0CXcqI9lyABokT/8eKAn5pOx8GwHYO0x8dDgBKD?=
	=?us-ascii?Q?tEiljS1JiRbJJdBEk6/hCrQnaaKDnvl/B6UhlYHmLhUJha1phuM4RApb+LEt?=
	=?us-ascii?Q?CSmCSaqcXXvOI7JPgI94lvdQZ/XJB3J1JbE6sVaiLvkXEiLbEe5BimICPMuu?=
	=?us-ascii?Q?qSqcx7M1ho7qXN8+/vjc7o9lTPrS39MjBXlo+i+otfkIhfeEJgdD/W0UlmQc?=
	=?us-ascii?Q?wQZM7ODzVQt4PF26UlOvQiBpe3QFlt3L4P61V8k7dEHqFsFdhEyAu/fFA/RY?=
	=?us-ascii?Q?RhSux18j96FEHFSltXQTE4/zZ7AEX6uYwemutw+psH2SEdnkFLrC+/HdE7jl?=
	=?us-ascii?Q?iUck0EwLiakRO6xfeBEBFk3iFWni02tsrvUtwDMt2uHwyoEbK7nEmYFONW/h?=
	=?us-ascii?Q?Xm0IdjZEKJ0Jou+4Wcn4J2qOlSf0KV/z4AY2sjh+/v5T/0p9SZr1GCQ9Twjc?=
	=?us-ascii?Q?+qy0yHYuKQhQVkOGVy/fpRgDJFiYR/rfIQriBwT9Z6rcWCS5qDNn5tGs4nM8?=
	=?us-ascii?Q?OGiGQhsZvF2+9URst6nESKuEnh0zFcIiW57Xs5Dt0thrci4YmvS9Xs2vAOEJ?=
	=?us-ascii?Q?+vHv7gBxDZXioLuETDXs3PahRXC1KWwp+nJoDkq0AcJRWrAs5Cy0YIfIRZdw?=
	=?us-ascii?Q?Xlej+4vUOTDgirFr7LvoNIllWq0h+xc/ZsuLCfLI0/FQ2VVNqHWFoaO/Jul2?=
	=?us-ascii?Q?XfZ/kqMFqAGcvSazggng8iCFEdmjvmQavuzTUSnkDhTdTwwR+L9yUMbUlLjW?=
	=?us-ascii?Q?nxexLly0vh4npUuihSHAhIkw105JVA71GVQ7OIKlQDt9iDOpT5MlzSZCqvwn?=
	=?us-ascii?Q?O+QVmtIp4GXvvfpIGG19nS9Q37m/WYGq6OaLt5pkQRrL89coLPw9FZoLKJiu?=
	=?us-ascii?Q?cI4l+mT59DuhaLqelNdCk3yaHhOOa5Bq9Dhc9TTUQROvozRB/aXefHLu6MCh?=
	=?us-ascii?Q?ZkDm6BGi/dS6dQM3o3xQL87AODD+I/tblljbwrYmLOuBexi3Ihr1iSR1Qkmv?=
	=?us-ascii?Q?V30=3D?=
MIME-Version: 1.0
X-OriginatorOrg: veeam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2758.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cee9e820-45d1-47cd-d844-08d8e8976c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:20:32.7682 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba07baab-431b-49ed-add7-cbc3542f5140
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xq2l7pw+8FYUAYB5xd26YqHZKwlhGSajmijIdJ36ehJiYPj+fQwXwlnnxJmkVqc0PUIEsMg0R8KAxqLVEJ+HkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR14MB4774
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12GGKrS1002259
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 3/3] dm: add DM_INTERPOSED_FLAG
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks!
I've already started doing something like that.
I'm glad we're thinking in the same direction.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

