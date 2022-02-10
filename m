Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF8EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 17:00:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-W3Jc8u1HPwezl11U_Ggi7w-1; Thu, 10 Feb 2022 12:00:39 -0500
X-MC-Unique: W3Jc8u1HPwezl11U_Ggi7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BC2451099;
	Thu, 10 Feb 2022 17:00:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA5DD85889;
	Thu, 10 Feb 2022 17:00:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DF611806D1D;
	Thu, 10 Feb 2022 17:00:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AH0H2X018265 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 12:00:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 48A8C40885B5; Thu, 10 Feb 2022 17:00:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43164400F3EF
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 17:00:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 259281044561
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 17:00:17 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-457-e6nsUIShPLmBhgQYBy7gzw-1; Thu, 10 Feb 2022 12:00:14 -0500
X-MC-Unique: e6nsUIShPLmBhgQYBy7gzw-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2053.outbound.protection.outlook.com [104.47.6.53]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-12-5R15BNU1P2uTbZVTB_79fA-1; Thu, 10 Feb 2022 18:00:11 +0100
X-MC-Unique: 5R15BNU1P2uTbZVTB_79fA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by VI1PR0402MB3472.eurprd04.prod.outlook.com (2603:10a6:803:a::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18;
	Thu, 10 Feb 2022 17:00:10 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 17:00:10 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxKyNAoKA
Date: Thu, 10 Feb 2022 17:00:09 +0000
Message-ID: <bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d20952a-115d-4e56-00df-08d9ecb6cc03
x-ms-traffictypediagnostic: VI1PR0402MB3472:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB34726C645D9798214C9F8D70FC2F9@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4F/mT6psTFqNOPN3967JMTd4FukRsuBZF6eHGkbLAUIAJOcPCLxwu9FTV9FpT0xQL9DL9Lpop2CoP5x/3tyVfzMWRQew0JqYx8pKu3Y2P9aYc7mEMnl+N36zOYmnxS2+GVaerLdhhy53SatYf4Uu/pEpL4yRSz1cfD4mf/pzbX9AFIGtLA7oQ/tCg1lNWikh/0sW67LsPvjIhFGLoFaSk7Ooxx7k1bezlIErrZrpfe0/ZLmGrP+WZfOPC0TDwlC7ji+2l6eisJhv1bHXjaEmNpy381dkaUuakuz9QlrBUtZQpY98HT3ZDiSoWKCA6tg4QrcsZZE1GvFIwPNVHA1P+5G14r5D3uumhwdTisGmhYeoWxEOzUUnFtDmSMdTLnvz5t+/hhsggd3Uz1eJgIA/M5TjevnXd3O0CRIdk2lSmwm4LqiVJnYWwDOSYlccjjyH/KYa9dxf+fqGKhVGQA3k3ggmEEjK3Rg48XbX5TWQNa38aa839RiTVcI/D1OqbRFvkg1cIbamnYMlQJS/bDRDR4PYXQEp8f/yD+iehmHeU2QKXCoHDN5SYVAvXJiTth+6zmUo2gJL+G3+nj1YBJfZ98rco25N4GNdsIZrFgQOVh4h/CHf9MSwY1Es12B228+nL8Jt0dvpKMbSqcf35Sib9tSl40F3nqOPCO73jCV6DdSp+/cLoihbJOQhwPWRjIVLDvINnGFxkOe23458dhKNuw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(2616005)(71200400001)(66476007)(8936002)(91956017)(110136005)(64756008)(66446008)(8676002)(2906002)(66556008)(99936003)(558084003)(26005)(36756003)(6486002)(4326008)(122000001)(38100700002)(86362001)(38070700005)(54906003)(508600001)(186003)(76116006)(316002)(66946007)(6506007)(44832011)(6512007)(5660300002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?30sEt/aoBm7vv/ud7enn0PEPyrhw40+WhQLgpEm/nwTL+TFyljXJJCW5t?=
	=?iso-8859-15?Q?cDsxYHCa49w9nMlxgzXcQFy6/Emz9pXGwX/6rvIbpMZpi7UcIuYt1D9ME?=
	=?iso-8859-15?Q?RW49YF+p4RIzFiYWpkbsBHM4NUBCHJeDKVp1zPApjTtFFd61m/s4kkPsT?=
	=?iso-8859-15?Q?SmYGx8IoPdlThJ6qJt+nCgbxJq9dthd4XCmL70CsamEwJWgrFwY0qMwX4?=
	=?iso-8859-15?Q?V81haTbAVuv/uzdhOwBKv9LTTNKupdaPMQWcZ2ONBH/TsplqjZpu2bCrE?=
	=?iso-8859-15?Q?tTFbXI/yNDbgg6IxkvsPfunbRtE/JPpnQvBf5lKwnI5s8B/hfI0zocE48?=
	=?iso-8859-15?Q?FTWy5BrLq3CNKCRtBccKJUgZaepZ02aVIYlfmTuyom5DQXon36lbprikl?=
	=?iso-8859-15?Q?QEAaI4Ni4C8qMIYKa9Jpmdru3kfTvt6OIacbLHdEkGwNYKZ5l5XzlPK3r?=
	=?iso-8859-15?Q?2L7RxnzLBAqgPK/XVP9uOPSNnrp5oATsTudG8uH8WRBtgc+3MSArDIDqr?=
	=?iso-8859-15?Q?C2eqJlwdPXG13SgQJhAys1Fmn5dmTwCawfnhyQbXMvQfPYRXa9Kc2MisK?=
	=?iso-8859-15?Q?H0otIvQbZkFIhMHcnwwL34pVGHm7BX1HFKJdKr7qOlUiKpsTOlTxqYrrh?=
	=?iso-8859-15?Q?l7ERzxMX1dcU6RGE7/igxCDDCSDm4rm6Ja2w1QRLRnMJwafyL/EAekxHS?=
	=?iso-8859-15?Q?ri+xaJ+UaO7pBl39zNZmgZINzF30G7jLGmXFwpKT7vE4jrYcjf7UIWtI+?=
	=?iso-8859-15?Q?9Ngh12FpItNfXk/i0woswGouGqQZV2vbJF45WgHSWkTDLdU0Bkla5xryP?=
	=?iso-8859-15?Q?JtBx/3QPnSOdVxqddIWWmN/LmPgQChW7tmYb754kPdbNr1a2QRWL7I9VP?=
	=?iso-8859-15?Q?pZzrWSa8L8QOUrIUyZNZolPXoQ8IFhDUO6/qF1YQ/tyBVvtsyWpkh7PVh?=
	=?iso-8859-15?Q?YpiSliOVY5dG1xr+Cpj2FjAfHPUxvt6Stj1Ciog/V3hC4KpK0YKk5qHMA?=
	=?iso-8859-15?Q?EOgnVIrqFxnM3G4sXGs2U2OE8yBXMCZSPPxLooBbEZLiVzpGO4QDhADn9?=
	=?iso-8859-15?Q?zj1mllP0QTOahdVV+YS/IeSGdfeBlgyiWpHS8MzgUp3xKIPnI72lrZJwd?=
	=?iso-8859-15?Q?zgj8Lh1Tcy8He2z8OnxGVkUhg9+poaikIk2pl0C6xo+cJ4Tz5bGzgCd5H?=
	=?iso-8859-15?Q?bpwh7FiLI7y4SxwOh96Ngmtu/AKPkJH1qNHyA79vl918rzAQFkW/vB6y9?=
	=?iso-8859-15?Q?flnlTrC29IV0h1SIj606q0+eo7nuLu9FyvxFxOH/T+tCZg2THnSamcJGE?=
	=?iso-8859-15?Q?oed4fE4th+fqSyTewK0eGO55pkYvXlEbRSTwHqx1nDI2fdDdtAEqbEJlC?=
	=?iso-8859-15?Q?g9b1Kat+zCXju2bMs3R0ivydtRySY3MZe1dDmtQ2Gh4vdkr/mDy2AkItd?=
	=?iso-8859-15?Q?y8mcSfC+R8SchdpcMvJhn4IuQ++CEbJ9Wos/inQi2ikyi/MCOzZqxYAuc?=
	=?iso-8859-15?Q?n/C+ExdAUPcmUjfRViMnEXPoBFVb8LBcv4ohdV3lF3NdcabllfnEypOr6?=
	=?iso-8859-15?Q?06hgfwxNtMxuQLUV3UJkvczvUcO/nVB4uC69GAd2lAooc42Wk2NqanOR1?=
	=?iso-8859-15?Q?Eh4IgDRI67TmjYCysVGJNrrUjng99/4D2hhoFRXZknF5VSkBrhYB1i5JO?=
	=?iso-8859-15?Q?8AwnU9Qa+ES9ZP0jOWROt1xvs3nd0i96krPdKHaTI1SFyqM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d20952a-115d-4e56-00df-08d9ecb6cc03
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 17:00:09.9806 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0WCAEL7+sPWozRM5bXoSRGsgHKTfKVlnh3TNzU5txxlDX+pzNafAUqj5xjBHtk+nBaeEl/53Dw9TIva9dhvYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_bb2333d75ac49ee865a7c17c8a2c68a3421099f0camelsusecom_"

--_002_bb2333d75ac49ee865a7c17c8a2c68a3421099f0camelsusecom_
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <A3D5B96B2AF4E8469E96173E0BF65FAE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

Hi Muneendra,=20

coverity found some defects in your patch. Please help me review them,
see attachment. It's well possible that they're false positives, but
please double-check.

Thanks
Martin


--_002_bb2333d75ac49ee865a7c17c8a2c68a3421099f0camelsusecom_
Content-Type: message/rfc822
Content-Disposition: attachment; creation-date="Thu, 10 Feb 2022 17:00:09 GMT";
	modification-date="Thu, 10 Feb 2022 17:00:09 GMT"
Content-ID: <194BC0B9795C7D4589A4B1A15BF395D3@eurprd04.prod.outlook.com>

Return-Path: <martin.wilck@suse.com>
Delivered-To: mwilck
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS id MAuAOlBCBWJuPQAAMHmgww
	(envelope-from <martin.wilck@suse.com>)
	for <mwilck>; Thu, 10 Feb 2022 16:50:24 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) by dovecot-director2.suse.de with LMTPS
	id kNpMOVBCBWJTHAAApTUePA (envelope-from <martin.wilck@suse.com>)
	for <mwilck@imap.suse.de>; Thu, 10 Feb 2022 16:50:24 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id DF5A0A3B85
	for <mwilck@imap.suse.de>; Thu, 10 Feb 2022 16:50:24 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: 0.141
X-Spam-Level: 
X-Spam-Status: No, score=0.141 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=0.248, RCVD_IN_DNSWL_LOW=-0.7,
	RCVD_IN_MSPIKE_H5=0.001, RCVD_IN_MSPIKE_WL=0.001,
	SENDGRID_REDIR=0.001, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5fgSk0Q1T4F4 for <mwilck@imap.suse.de>;
	Thu, 10 Feb 2022 16:50:19 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 3E592A3B83
	for <mwilck@imap.suse.de>; Thu, 10 Feb 2022 16:50:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (using TLSv1.2
	with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits)) (No client
	certificate
	requested) by mx2.suse.de (Postfix) with ESMTPS id 19FA2AC51 for
	<mwilck@suse.de>; Thu, 10 Feb 2022 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
	s=mimecast20200619; t=1644511818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:resent-from;
	bh=gC+bJB8vU3m5g1YFmTgRkYhpO22FDMK8DkhadbeVMWk=;
	b=Z+KX2+eQePum7bd2GJW89fJhSuraxwOILgCzUiQYa+3gMUcbg8pNutf06JqYafxWGFB6g+
	Bf2FN1Bjse5NJFJjUfzqnQ1Fno8sk8+Q9HA4B+0Vu/OOJGqDU3pz6tBMna+MdROl6SBENg
	kMA3Y3Zgcoz40C1VZ++XMI2XH2RHgUQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-14-V35nAjgAMParJ78aFGaTAg-2; Thu, 10 Feb 2022 17:50:17 +0100
X-MC-Unique: V35nAjgAMParJ78aFGaTAg-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=J7VvoYaznmrs7ta9YrROrguqK3t6vA1mBJjG4jhAeAKjgJqvGSp0RkDQGbgOoXSqr0TvleFE1cf6L8SElnCRs7SXnyZqnSh8+WohUrczLUDCsSfUZfNMZnibxVBhs6wglo0Cds77CLmBZXy++eogezQvYFQ2N02b17zkw4oEUhx7f7DF+ERN9URTTrgY02gksj/8dtktmrfiYgos9H4/gXhvwvr7PPCdwKwvKrTvh8O6vsEkhHSgl5klXrEggZn/MN6upHAm+sDwEuzLrfEe1JHkn/Eq4MudjhrABHg+KvVnAiJ4h99ThhXwRzvI/U3fzbW3T66xy9HgyyJaeZKdtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=microsoft.com; s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=gC+bJB8vU3m5g1YFmTgRkYhpO22FDMK8DkhadbeVMWk=;
	b=CWcyRh3LseHg3/MfynlyFnWLdpRosr8u7bjJdADjd1R3eOLb4Vvud1GXOeZ0/PpJRvMiy2fbGmrqqTTx6AunaQjNxnB4xKv9b3gCDQGCELZkyw4+j+QW3+SxuAHKrl6x4cnkcrmEB47drFngAIuk609ckcY8O+/3hBrtfyai/XSdAIRFLvZviv1UBi8e1ovYXAf47ubLsZ5NLx4psM1Cep8wXQkRDEmQzyDtRgZIPZhNkxETZYeCBQMr/xcLXtjHIZhP7tOq0Bk07JoWWGqTLAEbaK0vn2VC4wj2XPAnbOP6HHpP+R2FoamteJOPv86BKrDeLrDXSAGJ1nR1I4oxBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
	62.140.7.241) smtp.rcpttodomain=suse.com smtp.mailfrom=sg.coverity.com; 
	dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
	header.from=coverity.com; dkim=pass (signature was verified)
	header.d=coverity.com; arc=none (0)
Resent-From: <martin.wilck@suse.com>
Received: from DB6PR07CA0094.eurprd07.prod.outlook.com (2603:10a6:6:2b::32)
	by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19;
	Thu, 10 Feb 2022 16:50:16 +0000
Received: from DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
	(2603:10a6:6:2b:cafe::ea) by DB6PR07CA0094.outlook.office365.com
	(2603:10a6:6:2b::32) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via
	Frontend Transport; Thu, 10 Feb 2022 16:50:16 +0000
Authentication-Results: spf=fail (sender IP is 62.140.7.241)
	smtp.mailfrom=sg.coverity.com; dkim=pass (signature was verified)
	header.d=coverity.com;dmarc=pass action=none header.from=coverity.com
Received-SPF: Fail (protection.outlook.com: domain of sg.coverity.com does
	not designate 62.140.7.241 as permitted sender)
	receiver=protection.outlook.com; client-ip=62.140.7.241;
	helo=de-smtp-1.mimecast.com
Received: from de-smtp-1.mimecast.com (62.140.7.241) by
	DB5EUR03FT055.mail.protection.outlook.com (10.152.21.30) with Microsoft
	SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 16:50:15 +0000
Received: from xvfrhxqq.outbound-mail.sendgrid.net
	(xvfrhxqq.outbound-mail.sendgrid.net [168.245.10.68]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-10-4OBZW2-FNSyItAKWcStLbQ-1; Thu, 10 Feb 2022 17:50:14 +0100
X-MC-Unique: 4OBZW2-FNSyItAKWcStLbQ-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=coverity.com;
	h=from:subject:mime-version:to:content-type:content-transfer-encoding; 
	s=sc; bh=gC+bJB8vU3m5g1YFmTgRkYhpO22FDMK8DkhadbeVMWk=;
	b=Q9eHMXNtDyxvnX4vwE8x8jhwygZpoP6z80pUeO/p1tSchi7iP8YS9lR0aFKcHqiKfI4m
	exjSdFFNlVubm3I54UPYPn2PYrCkBzTeEwlyInicnWgSKoHtS5YppjJFUKSon7cly6CNW9
	HQ3svfzibXzNzmYHdRpzwY6QOgcifymRSQq69ydywcR4z2SImg4uVFfoYjO6W0D2BTugHI
	Zk+4FXLMIVOF2IfFD60hzUy9IJT6vnirpP5jCbn77GnAG3vVWo2I5bbBs5vTbuDmZGzOiB
	Qfzmry4Y880k/KAbTgQppbnUL75+tjgQarbbsvp5nZ3jBNnOm902wC7Wh4XvW40Q==
Received: by filterdrecv-656998cfdd-clj8n with SMTP id
	filterdrecv-656998cfdd-clj8n-1-62054244-75 2022-02-10
	16:50:12.633741298 +0000 UTC m=+12244972.932539559
Received: from coverity.com (unknown) by ismtpd0155p1mdw1.sendgrid.net (SG)
	with ESMTP id -rSNbzflSYisVKLO72IYug
	Thu, 10 Feb 2022 16:50:12.525 +0000 (UTC)
Date: Thu, 10 Feb 2022 16:50:12 +0000 (UTC)
From: scan-admin@coverity.com
Message-ID: <6205424432ba8_8eb4a2ae2171bf9a866a3@prd-scan-dashboard-0.mail>
Subject: New Defects reported by Coverity Scan for mwilck/multipath-tools
X-SG-EID: =?us-ascii?Q?HBOmY=2FE5MTYb8Mhr7ulQJIaFxcZEWpCD=2F7YwgOg+H8uyNNhTDTn9vQ4=2FQUUWbO?=
	=?us-ascii?Q?96aNb0J4MXQQ1XFhXdrWNYN6Ufb8G7QDFbkCUeU?=
	=?us-ascii?Q?+NoEjN2ap8ewnpcyK5br3TqTzxh8rl8sA71iRte?=
	=?us-ascii?Q?tCFGd41X3fY2InAGnVxCmMuT0nlMeNPGAKLk+oE?=
	=?us-ascii?Q?urgeQ3mwrJLVGKe5O1NCSzfHnCKI0ZE4g+Q=3D=3D?=
To: mwilck@suse.com
X-Entity-ID: S2cgcZKcMUFZg9Mweglhkg==
X-EOPAttributedMessage: 0
X-EOPTenantAttributedMessage: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba:0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5344ef40-95ab-4e4c-a056-08d9ecb5699b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VE1PR04MB747189C50BA6649D1D60AFD3E82F9@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rExOoejf8LAxhHzCZkC4JmulCiiw12DZm4G6s66NSOFOK+1OfW5F5RJIlxW2ml6ROuZX0eWIw0Jn9GlWfHPKZT/NyvAg/kIu/TbXSnyIpAgZnQvZYVLih+MBHcKaWsN7FWlu8kN5Lr7Mt/0un1bSuiJrSgCxhcXeK12nvKgJq/3A8OTPD4xw3e1husG6TBRDUfJiwNChGUspOCLzTd8CdqiFWS3T6yWWDGo64Yulwaj4ncNw5Es5uAyrJtgRtUAajbU3Uk3gcK3jU+kQH2iYTtRw9NncX8ol2iMdikbTwSoZP2BsI9z1uUU+G2F0PlxGfDh3B5D/rcOD3TpR58lJ1kZzaKzD4uWNYex4wPtVH9Kf1ge1BnlBXdXn+pkF1X8tnL7Iu6mSy1XCFjydUJlHViBKVnEwslU14LfLIEgR8DlOrhIpIi2yD5RfNVan9GRfkmdATquJw3nGLqyonGX8zVMNsJMHsyzywax52yK4vbf6TBn52rDtBo0coKsWRbx6WQeR/ee/sDD4SW6mYmdtaluVivzHHKueF/gVGPnTQbNNswLb2Qv11CChgInxZzKv5PfTSYRZsLm3Lwf7lvdJKNYsTBRlAFMsv6tZGctuIyBAWcaYSBAsSoV/zKabRJOa1yfY257//nXq2WXK8/4sfHy1cm68iGFT9GrRKzT9ufemfMPd8uCkgiFAd9T2ZbVu5HbFaLeyLp9HIYEW1rQv66tJuW5NMfOMTSfZHNxbBLo68XFLOgW5Ck/jkBYOMGFhUQFOMyQYBoG3MA4374lsMqBgYZ4ZY4pfopelNvHwUH8=
X-Forefront-Antispam-Report: CIP:62.140.7.241; CTRY:DE; LANG:en; SCL:1; SRV:;
	IPV:CAL; SFV:NSPM; H:de-smtp-1.mimecast.com;
	PTR:de-smtp-delivery-11.mimecast.com; CAT:NONE;
	SFS:(13230001)(40470700004)(7636003)(316002)(82310400004)(356005)(34206002)(70586007)(8676002)(5660300002)(40460700003)(83170400001)(36756003)(2906002)(68406010)(508600001)(9686003)(26005)(336012)(966005)(83380400001);
	DIR:OUT; SFP:1101
X-MS-Exchange-ForwardingLoop: martin.wilck@suse.com;
	f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 16:50:15.3897 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5344ef40-95ab-4e4c-a056-08d9ecb5699b
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Resent-Message-Id: <20220210165024.DF5A0A3B85@relay2.suse.de>
Resent-Date: Thu, 10 Feb 2022 16:50:24 +0000 (UTC)
X-Evolution-Source: 1467640780.19384.16@nohostname
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

Please find the latest report on new defect(s) introduced to mwilck/multipath-tools found with Coverity Scan.

3 new defect(s) introduced to mwilck/multipath-tools found with Coverity Scan.


New defect(s) Reported-by: Coverity Scan
Showing 3 of 3 defect(s)


** CID 375096:  Memory - corruptions  (OVERRUN)
/multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()


________________________________________________________________________________________________________
*** CID 375096:  Memory - corruptions  (OVERRUN)
/multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()
155     	pthread_testcancel();
156     	els_mrg = calloc(1, sizeof(struct els_marginal_list));
157     	if (els_mrg != NULL) {
158     		els_mrg->host_num = fc_event->host_no;
159     		els_mrg->event_code = fc_event->event_code;
160     		els_mrg->length = fc_event->event_datalen;
>>>     CID 375096:  Memory - corruptions  (OVERRUN)
>>>     Overrunning buffer pointed to by "&fc_event->event_data" of 4 bytes by passing it to a function which accesses it at byte offset 2047 using argument "fc_event->event_datalen" (which evaluates to 2048). [Note: The source code implementation of the function has been overridden by a builtin model.]
161     		memcpy(els_mrg->payload, &(fc_event->event_data), fc_event->event_datalen);
162     		list_add_tail(&els_mrg->node, &els_marginal_list_head);
163     		pthread_cond_signal(&fpin_li_cond);
164     	} else
165     		ret = -ENOMEM;
166     	pthread_cleanup_pop(1);

** CID 375095:  Program hangs  (LOCK)
/multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()


________________________________________________________________________________________________________
*** CID 375095:  Program hangs  (LOCK)
/multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()
423     	rcu_register_thread();
424     	pthread_cleanup_push(fpin_clean_marginal_dev_list, NULL);
425     	INIT_LIST_HEAD(&marginal_list_head);
426     	pthread_cleanup_push(fpin_clean_els_marginal_list,
427     				(void *)&marginal_list_head);
428     	for ( ; ; ) {
>>>     CID 375095:  Program hangs  (LOCK)
>>>     "pthread_mutex_lock" locks "fpin_li_mutex" while it is locked.
429     		pthread_mutex_lock(&fpin_li_mutex);
430     		pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex);
431     		pthread_testcancel();
432     		while (list_empty(&els_marginal_list_head))
433     			pthread_cond_wait(&fpin_li_cond, &fpin_li_mutex);
434     

** CID 375094:  Memory - corruptions  (OVERRUN)
/multipathd/fpin_handlers.c: 339 in fpin_handle_els_frame()


________________________________________________________________________________________________________
*** CID 375094:  Memory - corruptions  (OVERRUN)
/multipathd/fpin_handlers.c: 339 in fpin_handle_els_frame()
333     	struct fc_els_fpin *fpin = (struct fc_els_fpin *)&fc_event->event_data;
334     	struct fc_tlv_desc *tlv;
335     	uint32_t dtag;
336     
337     	els_cmd = (uint32_t)fc_event->event_data;
338     	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
>>>     CID 375094:  Memory - corruptions  (OVERRUN)
>>>     "tlv" evaluates to an address that is at byte offset 0 of an array of -4 bytes.
339     	dtag = be32_to_cpu(tlv->desc_tag);
340     	condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dtag 0x%x\n",
341     			els_cmd, fpin->fpin_cmd, dtag);
342     
343     	if ((fc_event->event_code == FCH_EVT_LINK_FPIN) ||
344     			(fc_event->event_code == FCH_EVT_LINKUP) ||


________________________________________________________________________________________________________
To view the defects in Coverity Scan visit, https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yrlXjF1MXVk7PoaBOP4azsLepCe1Mn8gwfBXDBrelSIoRMU8O0U7o5n1FSIQj14Dq4St65JUh9ZnyC-2Fg157qes-2Ft9bX_PKeZaaewXacQHsuZ3T6aIqwwc4cZvX5RuFKlZH-2B-2F-2FW3e6H-2BXHVqahp7aWZNvTEgZriF6MZKau2Bf0lzbvkaTbX4e4aRrLiV588LPwISv-2Baiuvm-2BG4Up9iV7VtAl7qS-2B0T3-2Fqqv361QJbg5iOmqOQvmACpZbC7bxySCtES2vULs1HDMmm0iEnBDbGCNYF1xpA27h3e8fIXqCGYvqwYb-2B3OQ-3D-3D

  To manage Coverity Scan email notifications for "mwilck@suse.com", click https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yped04pjJnmXOsUBtKYNIXxFPY5t1N6AzTJMa-2BnAWi0npABKE4tMGq7bchotHs-2B2MqcQoJY2TJBjK3IaZ-2BUkHe2wCTAqHQyQFhpCFLiEJ5yDOXcRNksjcYeVNM9nq6-2Fe1c-3DJZ6i_PKeZaaewXacQHsuZ3T6aIqwwc4cZvX5RuFKlZH-2B-2F-2FW3e6H-2BXHVqahp7aWZNvTEgZ8ESLNy-2BD7eSZoQJj9Azw80YJzcErYNLrKcxKMYgGbPxYRwvkDgeGxz4WRfn-2B-2BuPaXZTSYImuaAoKoYTe4RaUajUfXcURMKMcXzDOS6kanowCj0jE9AfLqwwWVbaP-2BgeCbRXyI-2FvgEy6HVXWmfdW8qg-3D-3D


--_002_bb2333d75ac49ee865a7c17c8a2c68a3421099f0camelsusecom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--_002_bb2333d75ac49ee865a7c17c8a2c68a3421099f0camelsusecom_--

