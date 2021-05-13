Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308CBC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 20:03:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A004C61206
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 20:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A004C61206
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-lYyd7leNN8q2ptVHrXctKw-1; Thu, 13 May 2021 16:03:53 -0400
X-MC-Unique: lYyd7leNN8q2ptVHrXctKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3D57801817;
	Thu, 13 May 2021 20:03:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5A761145;
	Thu, 13 May 2021 20:03:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 589A855343;
	Thu, 13 May 2021 20:03:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DK3jCK020460 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 16:03:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D23FE2157FD5; Thu, 13 May 2021 20:03:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCF0E2157FD4
	for <dm-devel@redhat.com>; Thu, 13 May 2021 20:03:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F9DF83395C
	for <dm-devel@redhat.com>; Thu, 13 May 2021 20:03:42 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-506-JIbxvh-AN8W6crB3ggyVdw-1;
	Thu, 13 May 2021 16:03:40 -0400
X-MC-Unique: JIbxvh-AN8W6crB3ggyVdw-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2058.outbound.protection.outlook.com [104.47.10.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-10-OT7sy2zSPdOHAF1Luc7QVQ-1; Thu, 13 May 2021 22:03:37 +0200
X-MC-Unique: OT7sy2zSPdOHAF1Luc7QVQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7899.eurprd04.prod.outlook.com (2603:10a6:10:1e1::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Thu, 13 May 2021 20:03:36 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Thu, 13 May 2021 20:03:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/6] multipathd: make ev_remove_path return success on
	path removal
Thread-Index: AQHXSDMPbbr1GNYFTEKzDRn2DdT4CQ==
Date: Thu, 13 May 2021 20:03:36 +0000
Message-ID: <2e30d13bd011c1c02e9c794293349b91c2ba6c36.camel@suse.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
	<1620926595-12029-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 164aa8c6-8a35-44d4-409b-08d9164a31be
x-ms-traffictypediagnostic: DBBPR04MB7899:
x-microsoft-antispam-prvs: <DBBPR04MB789983394B418B663DD906FDFC519@DBBPR04MB7899.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IXRgE7SIMVOM4WOnBh6jND0vWKQIe6mzr+JHokbizbppKofXAkAMc4qkv5Nh/bC7u13DmNDbAZqAct+7oMWf8vZEl+zYK99vU5FfGd8Xc+wKhhG31DqLm4oC6stiElYpxe50BblWUN+iURGYSu11jaLGlhgVumZjmmFjCLTSJoz1nE/s0INbScbI1QOORFIcoF2naQB3c+EDdbpBlujk2h56xQegJYC5QRgJXGalkBs0JDKQBw5WFipFI90/a8TLzu1PtoJ5WHGqAbPeWTIoGBcmtK7pcPbLf923rYYdRZ0IMG6iXgvlqjDURKxqBjT6CRU2RJ8Ov3wJrlJB3jZwhkVDdqt5ZFzybYxYuHkSkyrxJBBH+CAP1VyySsBaYwVDE4DhAnqdVc+pBKnqV6z7tsmqfSv1X4XCkYMmhbH3t82SQ2QEe5I7+f6XqZfi9pRD7FfJYkjjHQ6jGSuQaOohI0gYcA8vKHHkDFvfigYfwyMho3dcduTQrJLm+qGQYb2byGu/kLAGOX2axkaKNVnCfy9D8IhxBjfrm1HafzOIGMb31Zz9dyJPb3FKeyTKKGZpizWtnBIEsvFAr1dc8Tw5rPopQW2BGxhoYcXOKRY+63I=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(136003)(39850400004)(366004)(396003)(346002)(64756008)(66946007)(66476007)(8936002)(122000001)(38100700002)(66446008)(66556008)(110136005)(86362001)(6506007)(91956017)(71200400001)(186003)(36756003)(26005)(5660300002)(76116006)(2616005)(478600001)(83380400001)(6512007)(2906002)(44832011)(316002)(6486002)(8676002)(4326008)(4744005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?a4o6Ul2ihBXPwA/6eNIXsokJI8sDaK8qQfo1J3OmNtGVukvueNtqAGdYV?=
	=?iso-8859-15?Q?8uYQ0UgxI4QcAtJvNTx43ufuky8S26JObTVIEZXoELz4cwKLqqk+O20hX?=
	=?iso-8859-15?Q?TAPO04kUbwFoi4n9d7k4TeuKizv2thrXNCJkZNVaLtx4bPHqxVzzs1Ulw?=
	=?iso-8859-15?Q?lfiRAJotm1vR+SC16D/PNijiPmAxFwuqMwOVxNBn4apnJSTilAHfe9hwq?=
	=?iso-8859-15?Q?4Jq3G/72VybEUjFInRYEqOyw7xHdr+Kb/QxWAOcuWTc2l6N43SJpINctZ?=
	=?iso-8859-15?Q?RYvOkgRJnqBqjOBTJ+5ZqRDnbampiJt0nBQc7XiFADwWUuySZudcUfWDD?=
	=?iso-8859-15?Q?8SO/KFyrISfJxYKot1CjRERhWnCtCC1BmxZfW2EyKqmKtsf5gJMnkpJzT?=
	=?iso-8859-15?Q?Y/UovdGV3AiD0avE/dxoLcfH8WRjVh5wfZLfHCIVBG6GDl0vpT0+ogx9k?=
	=?iso-8859-15?Q?uRTBRpHeITrNhcRqsZu1tzrQovM9mzpTj2dXaIo8/P0j/6SF1rqr8rm4k?=
	=?iso-8859-15?Q?MrNEtNrwYtkSEiqXfgMpFScXHK9JoL9tIp4+Tpi1pI7eWqCbTJO4rAcAx?=
	=?iso-8859-15?Q?E/BH2yCiQEI0PPMDZWg/6k/qu71aEVqzIGRoMMswrp+Z2fl0mCXiPEINy?=
	=?iso-8859-15?Q?OUTTNDFfbV/l6f8hq/HzRdUs9z26G+Jfmy3+fqoIXI8naHirSlu8rw0HZ?=
	=?iso-8859-15?Q?o9cC9cI2swVyx85hBiqROdvSxi1S0C+FRLO81Ebt7lSQDArwsILlSHv48?=
	=?iso-8859-15?Q?2hFRw21LE3MT2qUiY4cZPjCV/wn83EpbJa9eu1wtkr15pV8+VhDCJB2tD?=
	=?iso-8859-15?Q?OmRmt6DClretD/nGRhk1e7SF/bSbX014YX6KbtDswcHWPF++wUs9MZPtx?=
	=?iso-8859-15?Q?d0Hq5z10JqYYQQRzFlJW1Vzgaga6Q66X+C8f3B2r0yawx9DXUXegiA2A+?=
	=?iso-8859-15?Q?si/ubB8J4wrfUE6NY0levYJpoWHm7pKssJgygIbkO7Bs6NKVxOnerwsYZ?=
	=?iso-8859-15?Q?jgURK//x7+yuXRRflEa8L+NuqRiGVqikR0Wp5bPHxdfpqkdnFfKSIpUiK?=
	=?iso-8859-15?Q?hn3Xroovy+jgsxXAvE0mORUNHkilQ8w2JSoZQeMck0DQUzmim7d9tPaAz?=
	=?iso-8859-15?Q?Z0RZ/eVGWAJWUXg80xzBzpWvBxGv6XKT9RZg7ZzpQ8n2shyeUziwpBXLX?=
	=?iso-8859-15?Q?xBBexkq1mB/MVqvKW8vBsBBZnG+EqFQAscwI4JtfdEKX9lGkJ5A+B/Kz/?=
	=?iso-8859-15?Q?52dksZQP0mYBHRXoTxD6P5kgCMjUIKOCGmKgorVsiDzS1gOjEi44cICmn?=
	=?iso-8859-15?Q?bmm6R0nTwQepBkZ6Yajya3g7NpBcEkZZypW6pyFTCL9fcCZe5WRAI/fl4?=
	=?iso-8859-15?Q?f8BM7zXu1lHpCX5g1ckS5Nc2iYvRK+5sk?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164aa8c6-8a35-44d4-409b-08d9164a31be
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 20:03:36.6379 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsXW0WH3IhO030Ctk/jYROOGq2ej88oKBXFDel1apEsswQ9emdtkQqH2dL4uNLqAct2bRD6Taky5fTZOFdtpkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7899
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DK3jCK020460
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 3/6] multipathd: make ev_remove_path
 return success on path removal
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <360DD25685EDA749A8F06B95A1D88332@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-13 at 12:23 -0500, Benjamin Marzinski wrote:
> When ev_remove_path() returns success, callers assume that the path
> (and
> possibly the map) has been removed.=A0 When ev_remove_path() returns
> failure, callers assume that the path has not been removed. However,
> the
> path could be removed on both success or failure. This could cause
> callers to dereference the path after it was removed. Change
> ev_remove_path() to return success whenever the path is removed, even
> if
> the map was removed due to a failure when trying to reload it. Found
> by
> coverity.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I'd have preferred to to join this with patch no. 6. Anyway:

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

