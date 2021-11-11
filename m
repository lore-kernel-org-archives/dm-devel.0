Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87290C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:32:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1827F6103A
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1827F6103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-kydQp0tpNk6aI5C5RbH0DQ-1; Thu, 11 Nov 2021 06:32:10 -0500
X-MC-Unique: kydQp0tpNk6aI5C5RbH0DQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23577871803;
	Thu, 11 Nov 2021 11:32:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FD8A10495AD;
	Thu, 11 Nov 2021 11:32:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B5F01800FDD;
	Thu, 11 Nov 2021 11:32:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBW0rG009345 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:32:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6AE602166B26; Thu, 11 Nov 2021 11:32:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63B992166B2D
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:31:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C677185A7B4
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:31:57 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-205-fIhRE1fHOaqOiOKwZMNUqg-1;
	Thu, 11 Nov 2021 06:31:55 -0500
X-MC-Unique: fIhRE1fHOaqOiOKwZMNUqg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-35-owWV6MRoMuOuPdJ0xyE6Og-1; Thu, 11 Nov 2021 12:31:53 +0100
X-MC-Unique: owWV6MRoMuOuPdJ0xyE6Og-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16;
	Thu, 11 Nov 2021 11:31:52 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:31:52 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 4/9] libmultipath: pass file and line number to
	keyword handlers
Thread-Index: AQHX1phka3dtprsY90G9zP7SIqfjI6v+MkCA
Date: Thu, 11 Nov 2021 11:31:52 +0000
Message-ID: <15022a717be86edddc662e4c65b2947d89a3cf9c.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03bbf2d0-c5de-4d27-87a2-08d9a506dbb0
x-ms-traffictypediagnostic: DB8PR04MB7163:
x-microsoft-antispam-prvs: <DB8PR04MB716317620F8F6453A39C4AB0FC949@DB8PR04MB7163.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: A3Fgvj7WMTUGh1BPoVa8k/XtBBArhHfmtYLvAWH/ZAv8w93st4YLoqPH01clLor1y+8nNvn6KdTcDGxdHNF4DuoA30fl9TbKh1A4jv0MYVHksWiHtQbWGa8z0R7zpxgrPgeSq9x+AP+ufXv7vkc+crd/IOTK4u4XkA/ysR+bzlWWKSsFQoOWE9TinPq4hQaKMCOdEPMOtjHDqBqGj0z3H9fzHDsccY+EYaQIF62z20+JZ10LEWQ/hFcP+bQ/4nhbvSy9k8XdAnPkGzefscEHTVf1GcZvFfLCYSRrWdL3eUGBbDXrIhmQFGcp7xqzj06/lXn8eHlq4HFfvXpUT25sN8YdeToCuPMighTjdMRp2OSQ1rKOO0zHiOPu0NXBmVVFaJYB2d/xh4f3lKw0g50xfsQg2y9qA2qGrCA6w9eCVJqcL83qcSmwUzw32f55oKTluBpV/MyYONXa+xXhxfGFr0B8gZTYY3uPEg4AbJC+k1Yc6eCehVXXVGRM7Cd8Iilkb0R2b0noh6jFcvWapbqODNd2VTzcmN3onV0ZIU8rctOw0nV6ZlSeh5wDPipGQqXLUwIiRflO+hK+gr49qb2FuKKonhOvYkBOopOB9L8jN+YfCDZpeR9hAEilq6jx24/M9m/lLgPWWPWkZ3MXb6YrJg1kDlBmX1PTid8OIU3SsFUzgADsAYtMRCp/Gc4oq/f5Pr4HX1SisN1IpAKOZ/1WUw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(76116006)(2616005)(83380400001)(36756003)(86362001)(186003)(66446008)(66946007)(38100700002)(64756008)(122000001)(66556008)(91956017)(66476007)(8936002)(6506007)(508600001)(4001150100001)(8676002)(26005)(44832011)(6512007)(4326008)(5660300002)(71200400001)(2906002)(558084003)(6486002)(110136005)(316002)(38070700005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?lSFouh81/bZ9FTT201ZNcsOG1iqSL9wPWunOP0iev1CKdMUpNvGRShrjC?=
	=?iso-8859-15?Q?TVgMrRRm44BbALtiQXWFGUs930RuJQbMbChpgLaqEFPjIiXGnS3x/pw2X?=
	=?iso-8859-15?Q?IKz07QMnac9mV6kCdZTf4HU5udaQEcAAB3G2hA0Pb1EghbR4+srtgoPAU?=
	=?iso-8859-15?Q?QC7Ks8WQMPoY5j3DTlIjrq65FAYmIaLG3xEqervV15rwWugwlQgHuIKkx?=
	=?iso-8859-15?Q?RFW+2jTsTPqYHUdyuI6jBtP270X2KzNMaI1bP4KgmjajpTsE4OphSYAzl?=
	=?iso-8859-15?Q?rtNwuGAhSukwQ3NJv9zoSZamTqTJ1Q+aRY0FzI1lLM18PZC/+jtxprby2?=
	=?iso-8859-15?Q?HUbUza4z3tjGsbbqXWhwSvU0YoKtgnVI1nuCOuEwr+jTquZU2JfPBfcxl?=
	=?iso-8859-15?Q?UWPjjoiVHcpkHs8TEYC6+qEt72ThgWucotaY5Qx6w6MPgY7zZXGoZgVej?=
	=?iso-8859-15?Q?EdvA2h3wYE2Ex/4EQTGzd8/PHbx0lbWO8jEt9Eqj+Z9XxbjMpprxlu3kH?=
	=?iso-8859-15?Q?DTp7G+o99yR0N40zMpW+TABwsDBUEAnr/BFQYDBrcK24g+zDbWDVzLJ0l?=
	=?iso-8859-15?Q?onq6HHfNlUQPG2D45P7aGBPhdmnxFkjV4pXm7yaqIEVsbrs37OtfhB/YC?=
	=?iso-8859-15?Q?uAnESc0yuidS6oiAQB8mDrUvHidGIdmQDxeQ0sXAXA+w+439TITGbDvjE?=
	=?iso-8859-15?Q?tPH7tqDn9cFVr5lY6gdVKg5TegErE7KhwzzOqdRa0T8e3Cip1Elvs1CtI?=
	=?iso-8859-15?Q?f3jb//H5QNBC3gpd7WBiPtGHQGho0SKW37dC6ujssWzrW/xC+Cqp6O2yG?=
	=?iso-8859-15?Q?vcjNg9PCt2Mxbl0tJMy47ygo25jp916/Y46eRGy1MtNkRgy27ohrOy69w?=
	=?iso-8859-15?Q?W04K4/TalwAjyqbromtKVtcOY0Ue5+MF/jJ7zpAQUBctNSW49IFTSAiMZ?=
	=?iso-8859-15?Q?fDL950o0nEGalqQQnXaWYnvta+ezHcDOiZg0WDFHrBLvPbaUuKOfZc5ED?=
	=?iso-8859-15?Q?K6Q9+LHSEKWfxhBd9oyumlRwkanqDcF9KEIakHfJ+ZT0Xm+r+OVeuFt7b?=
	=?iso-8859-15?Q?gxQZoWlWSDj82LNGz5kmZqlcyplNnSe6fI1JlK/8CTPjTvvoeeoAefnah?=
	=?iso-8859-15?Q?9tGy9GBAnotT2BVqnULPVYAqmWSxh+TgEnRcpzX9JujGDVMRbtIm1AsYq?=
	=?iso-8859-15?Q?23dW7DAxBqAzLechHUXaBhIftBQZd0HDOqIvUBwlPEz2mWiR6uO39+JKy?=
	=?iso-8859-15?Q?Nra7J+kJWGdPIgEUCNzUp2Oz4zJc/SFqgNHyYcqZg+sXaAOQF90S928Lm?=
	=?iso-8859-15?Q?fWKCOVCOJcsDY7R7ZgwmdNzv0zKHwZVNX4fnXN1KxAuo0h2vm2Yt0KLMg?=
	=?iso-8859-15?Q?3yjOHU1ngBWoPXpVSLtavzZUhVt855dIej0Bn9QGoTytiW+u74nYgIJ8D?=
	=?iso-8859-15?Q?vN2Ob+oZFV87xDHhh2vvRfi3Iw7jyMBzIo1Bg4GEcwBWTbXdwpzH2ni6L?=
	=?iso-8859-15?Q?uHIFJjwNWYvE1Tp+PeWqS7PRjAzZvc4qaqkU5rLjRojsmUHEP5bsjtqpU?=
	=?iso-8859-15?Q?NZvr5CpbOB3pPQ3oN/lLeCUpNi2rkcthK2l7ZdcCR2PKZsJM8CKPC1VbY?=
	=?iso-8859-15?Q?HPxW3QxlpnJU1HB3/rkMeUSXKhhrkGN17n9YIwCwG+Ah1Dn2nf5MMDv+/?=
	=?iso-8859-15?Q?pbovVCrDf0LrEWL0e3bRXrZOXDEEy7kTNSAlINe3rV9nLbc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bbf2d0-c5de-4d27-87a2-08d9a506dbb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:31:52.2722 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FSwR7RITUMV1xF94KVCAkVXAQ4EvgtD/dcs7UR6SMoQLw2oJVp/XEl6NQdnxiNoDhLsx0t5/hJTres++jjwPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBW0rG009345
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 4/9] libmultipath: pass file and line
 number to keyword handlers
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FE88199640E58642B41869EE259F8CD5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> This will make it possible for the keyword handlers to print more
> useful
> warning messages. It will be used by future patches.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

