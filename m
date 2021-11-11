Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF8FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:57:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66BF96124C
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 66BF96124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-tA_LkrkiM26gE3c3ZZShKw-1; Thu, 11 Nov 2021 06:57:03 -0500
X-MC-Unique: tA_LkrkiM26gE3c3ZZShKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E00141023F4D;
	Thu, 11 Nov 2021 11:56:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFC9019C59;
	Thu, 11 Nov 2021 11:56:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 99DB71819AC1;
	Thu, 11 Nov 2021 11:56:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBuwBW011457 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:56:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9E2402026D5D; Thu, 11 Nov 2021 11:56:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A9B2026D48
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:56:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADFCC85A5A8
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:56:55 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-479-9zLr11xJNFWNNe-n_ZXmWg-1;
	Thu, 11 Nov 2021 06:56:54 -0500
X-MC-Unique: 9zLr11xJNFWNNe-n_ZXmWg-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-25-Fx3LhXZrMhajeTAMQ76H3g-1; Thu, 11 Nov 2021 12:56:51 +0100
X-MC-Unique: Fx3LhXZrMhajeTAMQ76H3g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5578.eurprd04.prod.outlook.com (2603:10a6:10:87::26) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Thu, 11 Nov 2021 11:56:50 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:56:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 7/8] libmultipath: split set_int to enable reuse
Thread-Index: AQHXuu1mU4ueBiHTrUieST8shQsUFqv+cI+A
Date: Thu, 11 Nov 2021 11:56:49 +0000
Message-ID: <f0e8841ff5f36a9f5c5b1d140d69bca11edda36b.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18e94a4a-864e-417b-3eed-08d9a50a5858
x-ms-traffictypediagnostic: DB7PR04MB5578:
x-microsoft-antispam-prvs: <DB7PR04MB5578920547B03E3CAF24C108FC949@DB7PR04MB5578.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: UAEAuDOoAPRq2joDpAQnvBgsYkq+fIX6eaOks5pREW+gaZ6Xg9w3ErvIzBwDAu1MPnoDJ+jnuGNWPI64Q2ksMX05tdOM7tHibIPaV1Udattk/Tf+6a2UyixwpAsGk7ql/E37N4B+C7MTJVxRcEKMxaOJSveMoG+5t6ZaAO2N0MQyMhLtunJRjQsV5kyYufxRU1VuEiQcx1/CkJnrH0sLbPBunbtzRViP7Zs0XbvtX1evvmToaY82ZMcZXh6/WMdhV8+FsY6TmJkeJM6yaEK9SFNGj4E3yhqe4lBmEfvbHHfdzeH4fkKcku5sJC+7+jrC+WBaNKxyaYxwzwfDVejPNsx5IyXWyPrP+Zx/nifyEnZThVIwXQUfEpAUiZzA8BtEw7zWcpbwBq/743zLqYG3nINBJRwz6b/ivEiSgecjuxWuJANRUckdfj7quSd0/k6lK+vCpiQxAft7JNXwh781udHoaUJ1XtKhi6WQhbpsXS15d+istk0kOxzve7sA/pLsjAEC57j+AFbISBMlBB80UpYi4AvS9TlMXXQuy0YJsaziy9zvxFNrcNyBP/rvx8zB8a6uSRfO3XxzWw83lULce60aa37mBaRlyNMQAPKmuGyHmoatafDWmQURxxOEpjsfQ8Gwtm9p/Oh7et4hzYW3qkU4nbqCqLH/j9Em4lK3vCZCqWQtPk0/CeEjx5u7nCdnTXf5NAJfKfoif774gJcmwQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(36756003)(91956017)(26005)(66556008)(6506007)(5660300002)(86362001)(6512007)(8936002)(508600001)(4744005)(2906002)(38100700002)(122000001)(38070700005)(8676002)(66476007)(71200400001)(44832011)(316002)(66446008)(110136005)(4326008)(186003)(64756008)(76116006)(2616005)(6486002)(66946007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?2OMdHRZaFCnn3ggnuzY2fNITI6hvKL7Ro0sWAM8+2vScqUtXrgR1HS/uW?=
	=?iso-8859-15?Q?/25UqLkxgBYsWW0G7QCOHVl+oHtdsY4XLt1qgm095VhImpLQC45PG8EWS?=
	=?iso-8859-15?Q?zjja4M97hF/IdIyYEvvabAG586yX1mK/rXjhWnjIsdSsp2nY3T32RIltu?=
	=?iso-8859-15?Q?CfkpBH9WgERXxBmt9DkaObm5F6csqaYPoYp3pwtiVTvJhusmeg/HFP+da?=
	=?iso-8859-15?Q?70kHwNCQE8AKUoH8fWo+CJdrgRQfaw0sFOwvxKuNQXxwfUgTByTVWtQec?=
	=?iso-8859-15?Q?vs20jnHst1jCRrgJtsQDnAM6BKrP2mcowI3rQsuPiXeAjSGzmYPTTNX3r?=
	=?iso-8859-15?Q?4lwmIHpSqb1sd8NnjDDowu4t3ZyZcO73/XdD1edTXCDiX9QJrS9s8JLnL?=
	=?iso-8859-15?Q?7jEkF8q23fHk4YPjnc+buY+68ur++h4lqeGqDY15qE8DcLmlbn0qGSQs/?=
	=?iso-8859-15?Q?iPvh+KM6lviPe4JtX/ukPQpz5frFJoa95vi/VmIdQIdNtqOKVNxg9U4Zk?=
	=?iso-8859-15?Q?Vau2qL0DNGD/KggYvKqNKM5JTMRYaM2o7mQpC/AzS3NOnVZDrFx2vrm4V?=
	=?iso-8859-15?Q?2wjQr3UFCq2Qjw+O/KMXfhbRoZ4w6zhMg2MTm/RC5i82QqsfpUSaQwYnN?=
	=?iso-8859-15?Q?WPUX7X5uzTf8+vSgcYDs4aJQUwHisRC8U2mamR0NaY3yLEE22KucmRe7Y?=
	=?iso-8859-15?Q?uFTTdlhd0VZhVCWlLq9RN7GkDOnLU75ZDdsHD51ymOPnIEXMbpLOw1i1E?=
	=?iso-8859-15?Q?JlobBKFztN/vkF8S0jZvGuXAuZutWRP3rES4OR5BQrMqJWKJKp0nqOpNL?=
	=?iso-8859-15?Q?yIqkNvQNzSZOlLV/gUBAI3IfgHqeAtspy9WUAM2ShRcDItIX3KZrXqZSN?=
	=?iso-8859-15?Q?qyvnPVEYVT3R/G9DH6VetRupV6Y1r0Tphb+7I88OIUbDaJTQRK0vEVubZ?=
	=?iso-8859-15?Q?t9OonuF1q7lFGQOPddJgGwojsgBIWUTSL590Pqv7igy8QW6qtbHPGfMs6?=
	=?iso-8859-15?Q?mNJ3+je3+Imm6iGp6vGC4B0vyz9W8D885jVZpgW+Th7Ms0z0ppireOmQN?=
	=?iso-8859-15?Q?mZZ232ooGLn1TY1JefDzCg+TmyWdnxV9cS2UOy1IpApv79zeMEzl3YVT2?=
	=?iso-8859-15?Q?GisOg5sfik7sTmLSpihGVwvxHgmrtGCFbD0WCeeT0r8fiqkGNil76cG0W?=
	=?iso-8859-15?Q?jo4BrraSrdMxNx4N7X2NyyrxLLo3iJdEICGaeTw//GpT3WjPf1OFeZbMZ?=
	=?iso-8859-15?Q?zVSGprG3ihuozKKkvQTz5mOXflJETAqxKUikIygfs/BseiF3CH+JMlvQq?=
	=?iso-8859-15?Q?IhlU+Z1MY46tL1pEuFDsxeXZVVHU5YG+fHI4diEF/0hlqE5f0O1kdWMiM?=
	=?iso-8859-15?Q?iyzq9hGaat/CBRTYpwOOFL3GydAUUg5MjGVByQ5oZgTnW8YArO3Wlso1O?=
	=?iso-8859-15?Q?f5k++BPSEfC1RgFkFfZ5ZQtzOEse410zIRjXfBEM3muv1C7ae5y/7N/pq?=
	=?iso-8859-15?Q?FFibGHgfdEDmSsiSu/aCkdZp26YCZHDwYKyiQRPfoKZIdpS3flA8wOrEp?=
	=?iso-8859-15?Q?yIoPl6ghJMmJX3ekAl/wX+t0fo9mnWLMSAElEzHa1dp3Kcm/M+oMPepPO?=
	=?iso-8859-15?Q?njQ+awesc7H44vHM91T9nr+I8YW4CvOGP4xPR8ItYtJN7XHnbjofRuqJ/?=
	=?iso-8859-15?Q?rjhJLTrXjPmFVsLuFpxlDWTn2NNh6YHpWJ7+hKh6xNuR19w=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e94a4a-864e-417b-3eed-08d9a50a5858
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:56:49.9320 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kN/Iyb1tSoQDLvtSspYwkZ5x4igH8xZ7WwiuhWDylJxEX6EmFYug5kJmKMUPMi9v+I4i2aOPeMbvmC0cOpdZZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5578
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBuwBW011457
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/8] libmultipath: split set_int to enable
	reuse
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8FDD79167B7F584995612F3CCC9547E1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> Split the code that does the actual value parsing out of set_int(),
> into
> a helper function, do_set_int(), so that it can be used by other
> handlers. These functions no longer set the config value at all, when
> they have invalid input.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

After discussion on v2 of this patch:

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

