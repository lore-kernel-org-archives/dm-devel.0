Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A2FC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:10:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C53161BD3
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C53161BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-KtXuE1C5MBeksLpLQQ101Q-1; Mon, 15 Nov 2021 11:10:42 -0500
X-MC-Unique: KtXuE1C5MBeksLpLQQ101Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D4C110247AA;
	Mon, 15 Nov 2021 16:10:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C46095BB12;
	Mon, 15 Nov 2021 16:10:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9AB071819AC1;
	Mon, 15 Nov 2021 16:10:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFGAFY3027335 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 11:10:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DAC3540CFD12; Mon, 15 Nov 2021 16:10:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A0740CFD10
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:10:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC09F106655F
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:10:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-562-H3G6RpihO0WA0jooYEZ-nA-1;
	Mon, 15 Nov 2021 11:10:11 -0500
X-MC-Unique: H3G6RpihO0WA0jooYEZ-nA-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19--MdJooqKNwGKYaDlVW_Olg-1; Mon, 15 Nov 2021 17:10:09 +0100
X-MC-Unique: -MdJooqKNwGKYaDlVW_Olg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7580.eurprd04.prod.outlook.com (2603:10a6:10:1f7::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26;
	Mon, 15 Nov 2021 16:10:08 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Mon, 15 Nov 2021 16:10:08 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/4] multipathd: move delayed_reconfig out of struct
	config
Thread-Index: AQHXrnY/3GOXmKaFekKzP/E2pyMR7awFGZaA
Date: Mon, 15 Nov 2021 16:10:08 +0000
Message-ID: <6ff4fe373d52e282af83aa0ca7c116b71fe9480e.camel@suse.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1632180076-9294-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e40bf0cb-7914-43ff-3de2-08d9a85264f1
x-ms-traffictypediagnostic: DBBPR04MB7580:
x-microsoft-antispam-prvs: <DBBPR04MB7580A1879171640B8DD7DFE8FC989@DBBPR04MB7580.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nDrW4C8BEQV7cD995eL6hOUwyymRRRcU8Lq5c857M6T/GStEiaq9Q05hFqqfTPjQ17W76HJBP3g8yOKG0Ke2fyc7JMAC4xSA7LoQSjAXeaI4EL6YX3gHrxUXFpab2njSuz01ZBYWvrn+0EqGGB4WqHjyqGahofNZ2G/QcjoJFiq1JY6l4HTNtA1br/cgGvLOlyxL9nUv3UHOdbuLx4EEzLQ3egVozgFXcawBFd8JCGDXbWlE7OjZ0zEeTKOr2xm+XwZBRqQ9LKWnNyXEJqAVLFEdhkvdo1LSBot/eQAUCqVXQxlQeE1HNQzxxhToo9sLBtl6vG0u/DvJls345j37ZBhgULP9RCzvJ+jUq3au61wUZwgRA/ezYw1Lec2LvWJHjKkw+ci/nLkv+xAkkrR3SL6pZ4hgLq2RAJE5/CU8XN2MzWKBwvdVaAIZNsP8zcNT7GCXtA29FSfbxamSuJNo/pZ2qyviCv0xMvRgS2wICDrondiLx0SoQHvuNmD/qsAvF0qalbefgaVwzZcSEphL61L9snnstU1oEvS8WCJmZ46huwbU9i/XEoD+Ds2oEF5tlbx/rcF03MyW9vtcF+g4JLyUTZPpZFGJiVGUstbZ8o4jJ4rFiaZU40xhMInp0npO+ygloIvlADYcfzlH3+Qat4zG7dlpVXyinGR2XQliWLkliaedoAo7JFNMHOkK0lBvK289KGgFN5NdlD3kcfQd/w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2616005)(110136005)(71200400001)(6506007)(316002)(86362001)(44832011)(6486002)(2906002)(83380400001)(91956017)(38100700002)(4326008)(66476007)(66946007)(6512007)(64756008)(122000001)(66556008)(36756003)(66446008)(76116006)(8676002)(38070700005)(508600001)(26005)(4744005)(8936002)(186003)(5660300002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?uBYfUj5FjLLxlogmgANzoy2fRPBJ9Ebm8gji5zha8uGb5uUOBGS+FdsgP?=
	=?iso-8859-15?Q?Q/a8J74zT6vZViXLntXZBAwMha5P5F0E8zyhvqjainYiru+2zbDWETO9E?=
	=?iso-8859-15?Q?ZOUw51INiBQL0F2JIdaBpj69ydRiqNBggIgxiIq8bQdNcrQoRTNUQ44TU?=
	=?iso-8859-15?Q?n+dZM0hpTnIKMqxmwZiaRtt9Nrqf7bVsT5J44zF10mvmrukoMUUkIibJO?=
	=?iso-8859-15?Q?wlbmZQeOGzQHJ5P+e3Bjw01V0cwl9ZvjN3ZD/HE3TTueZ2mu1WLj7KEV9?=
	=?iso-8859-15?Q?QsUWjqhDtPOMMnACc3hAgN8b2bb5uG672rbSaKeDlnpzJqbfU/+nn0q4N?=
	=?iso-8859-15?Q?cJ99ie5tKMgVBVpkiOKWe50mo+u2kq2X1MXTm9gFDkPnlItdw69umI4C7?=
	=?iso-8859-15?Q?KAHBbkeaJ9bzBSvmDb5njt+UrFpIyRcXvug7oR2f9J9ROc3KIKXLOlsJL?=
	=?iso-8859-15?Q?NFxJZW9t4oZvClG5evq5CKXR/2ia6OFvZ8XQvVPar0Su8E6rdDZKa+jiS?=
	=?iso-8859-15?Q?u/XnfRbIX8R3uuJ7MTcfQRW3dqY7KlEE98QOJSGllyEB2NApSmo260nNY?=
	=?iso-8859-15?Q?dkOydP8EvHistK8mEDRUCkKY8mvrTKEY6DycFvaoqSU2kYmxp0o45kBtM?=
	=?iso-8859-15?Q?ra8jfcm+iPdnCTh/bUzxnGo6bM3DwRdYbY6ZP7rKVXKFxEbO+gmGNfosX?=
	=?iso-8859-15?Q?+4lF0C5zz87RIKicx1SKc4t4PQzfq+w8MTetb8CymS7HLl4bemYY3DRGD?=
	=?iso-8859-15?Q?kf1geb7Oa5wGqGUslZdNw4/9qTqq21iD2Kw5pdVUQt0YCFkPb35CKLsB+?=
	=?iso-8859-15?Q?oFz124ZxqDRuZB7NWOEXmBhFV0yTMWjphN49Y8uojyXeNF73X33+fnQYu?=
	=?iso-8859-15?Q?g9RbmeUQvlI8MLSEIwlPBA+UwqiXGCcMAzVZtfbnSqa7h2MvH4zX8usXH?=
	=?iso-8859-15?Q?rLpgzT3jZo7q5RY0OX2Dtqi6qTj19mT6+XJh7+6UFfXzJ8fp+j7QKzm8b?=
	=?iso-8859-15?Q?pQZYyjQE3Jq+2Lc1y6zYBNKvQ6lRpxasJT+PrauJB+6hFUWkd0gs46T6Y?=
	=?iso-8859-15?Q?6AjSHuCaitsv+zoR9p8/OtbgBah+m6mWrN8mcUeF7QY6zXYdxxnftI4Qk?=
	=?iso-8859-15?Q?YbYm4Ri2ILMyDSxkyn6m5Y7494rtgwklgJraNIzR1dJbyMFGB4/6cXIVb?=
	=?iso-8859-15?Q?/zBZSwM6HR+4Dc0hTi+qIRd2olu7p1yR11O174xsCdavshh8dlj6dnUlu?=
	=?iso-8859-15?Q?cLPCN40l7WMErVaaMcxkFRQANMAwSpZlfYDH/XGP5n1jmHO0TE2rYDIXd?=
	=?iso-8859-15?Q?sVnVEg3HkLSCi3P+2U1ZYPmJOnQbU6rlBInJb8fTwLqTiRIYfHRXV7nZu?=
	=?iso-8859-15?Q?IaaUJUZmdNXFRgLJzUsRlUqgitfY9PZguIkqKyF5d68CI8KavMCciMK2y?=
	=?iso-8859-15?Q?nrBThgZR3/DY17OZqGfeTXAVqhEvp6JfLKi4OYsuPxGfutCOIZCtmTM61?=
	=?iso-8859-15?Q?FGD/mq5F5MyOqmGtegVX04TwH4Wb6rzYgvA1RGN2WzA6w1KcNGNlby2eo?=
	=?iso-8859-15?Q?dVGMQu+647ZAEXieKOF0brUTKpvBiymm824F2GgxdznjOaRAYBhTZ+tPg?=
	=?iso-8859-15?Q?VC4Gh9O6n0JhpZ1VAj6YJHOxeq/508+SvhMPQOusI1HMWBn+zv28Sy0er?=
	=?iso-8859-15?Q?FqO3uSrnQntIXKM59tbtJiaakNHQy53k5zZENFGXBE+VNHE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40bf0cb-7914-43ff-3de2-08d9a85264f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 16:10:08.3362 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yysXK88IX5xH06E/ktR3wReVtJARZ7WPAwtBetsqVxA+SZFVxfEFnFSFLoEwtEiY6bphAiNigjX+IFneuXwTjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7580
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AFGAFY3027335
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] multipathd: move delayed_reconfig out of
 struct config
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
Content-ID: <96CB23D36D04394A96FA0D81CDFF349B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> delayed_reconfig was inside the config struct, but it wasn't updated
> during an RCU write section, so there's no synchronization on it.
> Instead, pull it out of the config structure, and use the config_lock
> to synchronize it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

