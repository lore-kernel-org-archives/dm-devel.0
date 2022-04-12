Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C0AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:40:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-Q6fCFC6hNDKNHwe8vHAy_w-1; Tue, 12 Apr 2022 06:40:20 -0400
X-MC-Unique: Q6fCFC6hNDKNHwe8vHAy_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19DCA811E81;
	Tue, 12 Apr 2022 10:40:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04D88C28104;
	Tue, 12 Apr 2022 10:40:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6FDE1949762;
	Tue, 12 Apr 2022 10:40:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 720AE1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 10:40:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42AF9407E1C6; Tue, 12 Apr 2022 10:40:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D8A7407F78B
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:40:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25AC9101AA44
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:40:17 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-c5Mt5qHjMa6lyLiXOCGK_g-1; Tue, 12 Apr 2022 06:40:15 -0400
X-MC-Unique: c5Mt5qHjMa6lyLiXOCGK_g-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-kwI9EkA3Pn6ypVqr1kkrLw-1; Tue, 12 Apr 2022 12:40:10 +0200
X-MC-Unique: kwI9EkA3Pn6ypVqr1kkrLw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR0402MB3509.eurprd04.prod.outlook.com (2603:10a6:209:4::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 10:40:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 10:40:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/9] libmultipath: make protocol_name global
Thread-Index: AQHYThEKFF556mlptESupKRTda+v/6zsFzkA
Date: Tue, 12 Apr 2022 10:40:09 +0000
Message-ID: <5284a820d41cbf1e4c5d61d9f35f0068b597b884.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <1649728799-11790-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a67d437c-c3d0-45b7-8e9e-08da1c70d0f7
x-ms-traffictypediagnostic: AM6PR0402MB3509:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3509AEFE8028D2444237C978FCED9@AM6PR0402MB3509.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SzJblOcgoFuwIEx5JnZJpscXyRIbzCLD4ij/mlkU8wHyBH7A+N421ByqifFa8e7UK475jgqLRrvAhy4iPI1Y4dgDol5lpFMjQOHQEiJnKTycKPDWCwd1FgaxlqyAY/lPoetFk7eHzn6srGU7aveWm/gzoiQh2A1eR077+envuBr7OhLabbwUANU3fY74az37LTXdh5jM4aKRjb900g7a0WeJQ7P+Yn8FnPHcgmrr5fRKt8vn6VvylRMrFt6R+A7Cxgu7t8jmVZWQU+NcZdqtpfNvtshjrw0DN4w5Jn3XpZ9F8Qct0Yi12IF27XSFzvoy/Z6Mags3aUcl4ojbZGHaBKy27ouRwBdLXLeoZOb6m4lYdW05uo30FiqHcTnmDuJ5ZHsApoxcgG2rBOfrzaihOTbXGuyebbIY82SWt4PyjejHGXwLVUkkukyCs7R8qXmKyCysZJtp90In6qXHCxX2NReZHz0VMwrgXLFaEwd7t6PKbgp0sZkq10mfdz1Q9YeQZJKOHo1+q+UVXCkgHoUUaUR5qK6X73O+3JUI22OB+rR2pyEf/8dH1ZFARDTPejkZZOsxG7JojSip/g0FlgsMxrVRYW2eNv9ZwQOPTceasWj8Aao6VDDOR5cXN6gqNvXfHe4DPxQ8tALldW/67kwsyc0f8fFUyu0Tm/4IZOdid2+KPHzRHmeW4bm4RbyihGV7ReWa37j+CpreWnxUfUKoSw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(5660300002)(86362001)(2616005)(6506007)(558084003)(44832011)(8936002)(508600001)(76116006)(36756003)(66556008)(66946007)(186003)(26005)(6512007)(66446008)(66476007)(64756008)(4326008)(8676002)(91956017)(38070700005)(71200400001)(122000001)(38100700002)(110136005)(6486002)(316002)(2906002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?d03X8GqBgsk6xY6zlhd/cRDKnI9FNNhYiYQsmkHgqnsnhccS1duLQDW9F?=
 =?iso-8859-15?Q?BOYOmzvWeGCCQvVlIdftDmmMVEnJYsqjQNV2CCHrQCOxqt5OZENicWjMe?=
 =?iso-8859-15?Q?qbr8e6CXtAH8YYll1O5XFzI6Tkk3Np0pFv/n/pbeTtRpyuy1I2AjGtUZR?=
 =?iso-8859-15?Q?yoa8lU3XYBRNJcDtnX4TCWXBJZI3KxXlYDE7BxgO/DzJ/8RsDH6W2vSZR?=
 =?iso-8859-15?Q?V5hPqoOv+jfesv12Wv/SPUvAQkz1sZTawtiibtsJEmNgWYAEQRXva1hb5?=
 =?iso-8859-15?Q?+zsW4zFMI7r4lnyRFxPhinW0Jg0kPp8n67Qge3VuNbYTNG6Npcp9NMa4l?=
 =?iso-8859-15?Q?FJ7jWm+sdAjAMWvzWIFstYJjnGZqQ2sA2NyYlCA5Nbc6hNlGZ8OtYxi0b?=
 =?iso-8859-15?Q?L+G7JlSdPFpuvrYIMkh3GXsL088h1UBZaJFbzu2oUkiDe+IvvoL+qbtrd?=
 =?iso-8859-15?Q?8Ytncb5jnglAq9WGjlTHKP8B7BoFtIKMo04KkAKl/awPjR+GwgE8OBoRt?=
 =?iso-8859-15?Q?iI0cCAKqOOn+9qgEkg+Csqgy/YulOyc0AErm2FNLL89jZWRT+pSs0o2jE?=
 =?iso-8859-15?Q?fboLNSsPi5Fhp4B8Y7knGWSg7W/tHloUds7fevh0PJM7w50wtA8iOLRIP?=
 =?iso-8859-15?Q?H/kXFQRnA6pGSfNn3PbBM9iaeohINvBXmzIq5HqbW/koBcEXwKdOVjPEi?=
 =?iso-8859-15?Q?4Sw2mW42U5SV1MGHYJ47uAeYGvE4t8aEURPMlrY3tsrbaxsYYNUUlZer7?=
 =?iso-8859-15?Q?fo71ODtO5lAzqy5jnu/5cKeF6BIpz9z0aYkLnMAbXe/S0e0pmsJEb89ag?=
 =?iso-8859-15?Q?ip8YIFV2h/4/3av+WQzcTnJRCAdq+uDx5YnJGy8BwhDPzR6v60ncuN8xD?=
 =?iso-8859-15?Q?Hb5IIe2j5y/i7NYkzTEKQZVhAIpz0HtVKZgzZFW/g+nTonxNCItp/uoAg?=
 =?iso-8859-15?Q?AQcAP93RkRfTJRp5vb1PVgsqrVIznhfTG6cFw+1WvOkRDFpVyGFlU/FOJ?=
 =?iso-8859-15?Q?noo4z8cpmE8aKgCTEK3Ecw4u7BziAwfT6UmxNVfXmQJaNdoWycmajA7sH?=
 =?iso-8859-15?Q?bt4kl5xsbW8r46sxPW9X1v+xQUYouiRKs7x60+vCIE3ctE8o5SuM8erZ2?=
 =?iso-8859-15?Q?YCzRxXlt1TG2fdoAOauG0Q0lmYFrPDKSLtTohA6dr7ZHkSOwSWEIlnfbn?=
 =?iso-8859-15?Q?LaIwGbPcZxL6dcADLOF98F+56k9OtTR1UBApW0f9JBiIpdAy57g+m5Ekx?=
 =?iso-8859-15?Q?e/h8QLX71+Fy96qfceWdKVOpNPq+SegMUvpCqk8FhDBOZhfI0g+eW0DKa?=
 =?iso-8859-15?Q?dITKgBXjIxW3CpOvdqoKipM+ruGm5hgHm6XZdf5MEpg8+wkWeJ2nfvLaS?=
 =?iso-8859-15?Q?TCegN63wJ5ebKMXcKHiP2fym8C321iVtisJ/M7sDRe+ZB33xfg/LN0tvR?=
 =?iso-8859-15?Q?Uqnv+S89ELwM7n8CriMrMKl4dJtfL+53QLf3XTzc+u9IaIMA0sgIApXXK?=
 =?iso-8859-15?Q?44KbMBPS3dA3xQSNrjBsZENc8odcXA9BrNsQScZg6reZSfN9VYU6o3TQr?=
 =?iso-8859-15?Q?cF/n3GoFyVOs8MezubU4t9DVUPXVrqodBsyd9v3WV6FJRYO1db/ZrLZwA?=
 =?iso-8859-15?Q?mjQr90ci2YyjvontS9Lrg/8C1jC5ZIhLLRZnvvhmoim1IkVPQnXpqaGc5?=
 =?iso-8859-15?Q?FTDACB37YPU227ekwgXCssLYtUs36B2MyGqioYIXuUGE5a8jUoYhapRXl?=
 =?iso-8859-15?Q?alF7Tl8wJEQe3cPwEyoO5XCWre2hPo0sMvDlcoPZU66g/G8X7dOi0kELc?=
 =?iso-8859-15?Q?ARLtr2AOO0ay1m+YfMJxVNZ4+Bxb3k2xrStZ9E7qNZDjLgSC0l0hjTF67?=
 =?iso-8859-15?Q?vTXk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67d437c-c3d0-45b7-8e9e-08da1c70d0f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 10:40:09.3364 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmE8zpbOUzVt4YJQwl7guNvYgl7sMmC6QvWee3Po9/rTnsvGrSqnSma/98xaxNZ6NeRgATr6RG9kh1XMjhlM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3509
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 2/9] libmultipath: make protocol_name global
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <86E8B160DADBDD4F819BFD5F3A376715@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2022-04-11 at 20:59 -0500, Benjamin Marzinski wrote:
> Future patches will make use of this, so move it out of
> snprint_path_protocol()
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

