Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6A1C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 21:37:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-NK85z8aKNICxyLhpUAwWCw-1; Wed, 02 Feb 2022 16:37:05 -0500
X-MC-Unique: NK85z8aKNICxyLhpUAwWCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D49A384DA45;
	Wed,  2 Feb 2022 21:37:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 425BE6AB92;
	Wed,  2 Feb 2022 21:37:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 960734BB7C;
	Wed,  2 Feb 2022 21:36:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212LavAS020003 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 16:36:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C18DC080AA; Wed,  2 Feb 2022 21:36:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7712EC07F5D
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:36:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D704811E78
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:36:57 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-vzJYzsNOPnG4i5itdirAgA-1; Wed, 02 Feb 2022 16:36:55 -0500
X-MC-Unique: vzJYzsNOPnG4i5itdirAgA-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2111.outbound.protection.outlook.com [104.47.17.111])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-10-uyYbpxwoNbqyikspf1rntA-1; Wed, 02 Feb 2022 22:36:53 +0100
X-MC-Unique: uyYbpxwoNbqyikspf1rntA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by VI1PR04MB4509.eurprd04.prod.outlook.com (2603:10a6:803:6e::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22;
	Wed, 2 Feb 2022 21:36:51 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.012;
	Wed, 2 Feb 2022 21:36:51 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v2] multipathd: handle fpin events
Thread-Index: AQHYEOg3mopANcC4Q0mGZwXkYi8O26yApa9GgAAyeoA=
Date: Wed, 2 Feb 2022 21:36:51 +0000
Message-ID: <98f10b868fd669737b33e18409eba6ca197cebba.camel@suse.com>
References: <20220123231325.21126-1-muneendra.kumar@broadcom.com>
	<09831bccc70c0b093b9d7128f3d198bc73cec66a.camel@suse.com>
	<20220202183549.GO24684@octiron.msp.redhat.com>
In-Reply-To: <20220202183549.GO24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22f6d610-ec71-4595-7070-08d9e6942011
x-ms-traffictypediagnostic: VI1PR04MB4509:EE_
x-microsoft-antispam-prvs: <VI1PR04MB45093CD56D1E4C7C49C6DC1CFC279@VI1PR04MB4509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zMnTepLo92azvssMlPbYUeiwnh9bFRT/u5XmV+KR9ZZZMVzYnhhst1P/YDs/u7zqKfYPZ+35PXaSBb2zWkOMS0Kq66Nm6Prh77KBA3hcH3jxfDsienTPwpLGcRK8rmJ3ubaAgzFPYOkKosLiOYHxLL+khgKdPEV7pwtWmPtp+kO3iadRrgV6BB0su208Sf+QBsukUecXn3JClNmuPLG/ZnzMaHTcxSlRlmZZHSSyEZiXPh4EDmcWBYTrQX6OZonPYWecMvlQejgHMAigU4+WDSv0YJmipTyMtT+a6/Gl/HXxN+vsbEkfJaZBAdanrv1wX7pUtk6AcCeqONZIfuH1yRHsX/9QvZXBTfozcsfrQq/+Fb9e2E7ijdNmMgjy+YWXHem/D3I1yoQtA/tzx4YGAhOxjiqERr/HSLkSZRPO6n0nryPtw2o8OssoSCNIXKcFJXY4yStnO/o1OWLkVMl5+wMlUc5gCNSO73Zspo+veQK9aiP8wqg6jObm2iXnLwdET2zj2Bu7DX5PjCNQdqPYRMHC2BZ4KjyrHs7wpD+AOgghXeGk7AWbxrQihQP3f0nr2JVw8yP/TSeRxhPj8lbnfsPGwvuPtB+NfRXkttKN2DSnrH5q58Sdid8NXvaLU/ALkzp8SIk07PR/mLSo+swb8gZ6X6ygU32I7CV837U+y/77ZgM5E87ouAZ4jIRpaFkb7MZORol+FCP30QlNS8SRAg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(38100700002)(122000001)(91956017)(6916009)(508600001)(4326008)(8676002)(71200400001)(76116006)(38070700005)(8936002)(36756003)(66446008)(66946007)(66476007)(66556008)(6486002)(316002)(54906003)(64756008)(86362001)(26005)(5660300002)(6512007)(4744005)(2906002)(6506007)(2616005)(186003)(44832011);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?EyQAADVQs+NHS2BHX28h0q7Y/PTO3fsV18XVfayP4on+29Ht4XCB/8k7M?=
	=?iso-8859-15?Q?kPbKmYix3mko4es+MqbVoyfctuf8+i+fCWkTXOab/3PnM6cibDoFcHW+S?=
	=?iso-8859-15?Q?x7+aa9zvl0Y0emoxu6vFL/O0Y/CGjFxfclJcKv9vJOstRM5svZBMGJs5U?=
	=?iso-8859-15?Q?9vs3TmFUzemQHg1QPcVUD5BMVLOwIY8+TMvyUbLZkQeNDidYV+vV/6MuX?=
	=?iso-8859-15?Q?niWANN7UxRznGVj4gjGu74M2TnWQI6JHWeCRE0G1EdLt/KM4XBsb6NNTL?=
	=?iso-8859-15?Q?uRKeKULGzqWzerfkbxwTvpI7lG9+nho5AWV5Qjs7id5QD5SyEwcYW6hPV?=
	=?iso-8859-15?Q?wdGyOcL804JOBTTNC+SL5OmywffSXr8gujzQViM8jIuquSXVaz4WdWgiN?=
	=?iso-8859-15?Q?hxxbH1fvVcyOo/jkQ5B+WW++RxaIDejZj4IPaeZcd6mkcpVf8tjyUQdBv?=
	=?iso-8859-15?Q?LZuW2mP/Kmn8/KiLb6+8qCfYNCWScOgi6yvNM8c82uIoOp230uUhK876/?=
	=?iso-8859-15?Q?H9Sf5egxNMXMwp+mHMtL41EnNtnsNPmxXvjuvfkYGPfqmP/z/mVqDWFgq?=
	=?iso-8859-15?Q?aWK+umB4BwrMTKob1vTGkhLZ8oBkXmy9feJLIXPohHR1lqnO5fdXd0Ev1?=
	=?iso-8859-15?Q?9NuRNzlh6FLgMuL81MFQLgjQ7rjt/ypLUCrN27o6RuPOb6fLAsEscCvHZ?=
	=?iso-8859-15?Q?rPI6dJ3TrQjMXlfescBjd+6nqqlbhbRDG2QvEmDOv72WBdoG1PbrGOqB0?=
	=?iso-8859-15?Q?Xt/E+BfP49tlUmNAvR9xMho9TF62Ub+UoM43Unpapczm85KR8zzL/0B9Q?=
	=?iso-8859-15?Q?IPjLAElUt2WbBAUhPCyVU0Tgp2bGbPv+B93o1p75co1TRpMqiPMGW/0v6?=
	=?iso-8859-15?Q?4o1M34FDigSP2h9Ku/BgJISSyUOh9Rhyv71JCzCrNOmgBjnTVJSgZjDtr?=
	=?iso-8859-15?Q?Z3LatbPCYuAuCQT/RVw+K6W4gILxBLgoTQ2eqwoGoML7Ff2tCNEYYxOkk?=
	=?iso-8859-15?Q?9nBpTON6afNt97CQe/oOPmKngvcO0tEEY//5MQOrBoFS3xRebAq1FIs6g?=
	=?iso-8859-15?Q?ffmjMon9rRU4r9wYhP4waOe1ZQNeptgsU2YWaA1RfgzZtu/lj72gM6ibm?=
	=?iso-8859-15?Q?g40/2l4Z4j3bOAEG+EQr6YEUpuY/SBCBjZmHp/oaB7GuCe4IBE1C1F/UE?=
	=?iso-8859-15?Q?Em1ziEkg7U7QEEipQQoYlYsoYz8N2ZBVNp/aX95S2HQJ8oPhRPyoBu4bi?=
	=?iso-8859-15?Q?yydyrIbiO515qdiuL92FkPasvHJBzK4S18wYVQWtIl7ydOYNyLQuGfqWZ?=
	=?iso-8859-15?Q?VHWvycK3kBcmlZNoFBd2qn2zfCsX57k6nXRTfp+qktvKXyXwE1C4ZtGzu?=
	=?iso-8859-15?Q?61jp1gnYqsh/9TmZoegfM8wxJkZ0fs5Jq38kIa/W4kIQkj+V51drShGeZ?=
	=?iso-8859-15?Q?QCKpOP8XCXP0IA0SU5zk89c2hhlNPoP9plX/TKkqD8qksDJiWpa8V6n69?=
	=?iso-8859-15?Q?65fX0GgOgZlDPzmBxmOv/8jxOWENTgfBReeURCJ0GSPgdQFgCeGozIpbR?=
	=?iso-8859-15?Q?N/uX7oe+awz2VyWeYlEf1z3yfBnn1r+SJEgUIB3WCM76E9TbOsvSNs4kA?=
	=?iso-8859-15?Q?ioBdLbagV2BQreM9lQA3KD/a/b60vOIq+RoPnB9V0HW9j9ZDKBSbwbwXQ?=
	=?iso-8859-15?Q?Yu9WXUnWC/gjiyrFkN2V5v3Wv/eEzLGgk45MlCnHq6Ixb2Y=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f6d610-ec71-4595-7070-08d9e6942011
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 21:36:51.6729 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0hwbrYN7W0Z5A9akdv2xBMm4qj80HBl5JBXm3l/pNcghY0/Mvw9/gVkyzVRybGzWTuS1s4Jn0HM6VMpgu73Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4509
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212LavAS020003
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <03FC3CDC53670E4A96587DFC7BB07E66@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-02-02 at 12:35 -0600, Benjamin Marzinski wrote:
> > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(vecs->mpvec, mpp,=
 i) {
> >=20
> > Any special reason why you walk the vector backwards?
>=20
> reload_and_sync_map() can remove a item from vecs->mpvec.=A0 Walking
> backwards means we don't need to care.=A0 The other option would be to
> walk forwards but add "i--" whenver reload_and_sync_map() removes the
> map.

Right, I forgot about that. @Muneendra, perhaps add a short comment for
forgetful reviewers :-/

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

