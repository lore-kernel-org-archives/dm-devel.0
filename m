Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0233C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:38:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23E1423A52
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E1423A52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-qFGvk7x5NX6imH8Yi9cDiA-1; Tue, 08 Dec 2020 07:38:15 -0500
X-MC-Unique: qFGvk7x5NX6imH8Yi9cDiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DD6F800D55;
	Tue,  8 Dec 2020 12:38:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E1051001901;
	Tue,  8 Dec 2020 12:38:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C540180954D;
	Tue,  8 Dec 2020 12:38:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8Cc3K7011554 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 07:38:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA3752166B27; Tue,  8 Dec 2020 12:38:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A335B2166B2A
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:38:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25A368001B8
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:38:01 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-520-sRMV_DY5OWmubwg2yEWU9g-1; Tue, 08 Dec 2020 07:37:56 -0500
X-MC-Unique: sRMV_DY5OWmubwg2yEWU9g-1
IronPort-SDR: abtrLtjU8r7qbebe22o6Ui/fBA1/jmjQ0bCFqV/R//d6Gqk952wtTcJQ+4Or5KrWdSZVzgbI1m
	3IHfuQvkX+0Wvnk5+kNPoEfUmrljix8usNCBJL9jpz9awgTPWraxS7uN5CjxUPzqMahhWzgJM7
	iqnZsJjfMQ103kruTfcDAf/Zunf7xPrBXHjDwq5rlFAe9+E5ERT+GsKilfXpmarxpyBg1ThCyR
	r1mXyetvJEsMXzHm8tCjdB8157q68MBtgx+KjndtljSKoF6Lc1NjYtLk9V/lj5x3iDXGRZKCeQ
	Fls=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; d="scan'208";a="159142705"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
	by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 20:37:53 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4688.namprd04.prod.outlook.com
	(2603:10b6:805:ab::10) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Tue, 8 Dec 2020 12:37:52 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038;
	Tue, 8 Dec 2020 12:37:52 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date: Tue, 8 Dec 2020 12:37:52 +0000
Message-ID: <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208122248.utv7pqthmmn6uwv6@mpHalley>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 50276e26-5770-4e9d-ebe9-08d89b76146e
x-ms-traffictypediagnostic: SN6PR04MB4688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4688CEFDCDD615DB1A9649EC9BCD0@SN6PR04MB4688.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 83MaK3bxef/YyUz965MJhh0VWCUK1FzEM8xQPMAlBV/PCnpTj4QsfTwxmr/opNxxz7sezpcT0FuFEXE6+fthlJEolJkPnsWmn1IZey+Xm4odGv/RII+Hm6NgpXJbhNM3ZQwkMJcUFz7KV0gkjUMPhwbvjXla521O0krLnuEcJLcOfv6TleG79Rr/Br99TPv0a9i2JlseJNjwFjYhiRNG3ymLLXUHO/gJjSY/cC40C1bDaqNAJdTgFxUvGvbqmJmU7UeBv/OLzF/gKOA63vWYICchEOYXexj0cjxNyH0j88OD+2I4o9N80tC8l4SMd1Ge
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(186003)(6506007)(53546011)(5660300002)(66556008)(7416002)(54906003)(4326008)(26005)(86362001)(8936002)(66446008)(91956017)(66946007)(66476007)(64756008)(71200400001)(76116006)(7696005)(2906002)(83380400001)(498600001)(52536014)(6916009)(8676002)(9686003)(55016002)(33656002)(4744005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?hXoZZYOsSI1tef74rXtmZ/sr9UvCdM+iSb12WHZ/HirFhds/JrG+gVQp8K?=
	=?iso-8859-1?Q?1glI/qRMoGZ3b2bmWC0GK5xDOGeXnuzNPPfOYwSV5SlwvR0et7XbFSz1h0?=
	=?iso-8859-1?Q?DBqFl6xfVEVu7b8UB4iwNJY3XFJSbYJphjSTZwP41zAs2TGGEwtCmz+1BY?=
	=?iso-8859-1?Q?qrXEWlzC4hPpo3DvOO2IsqJpxSmdMoQxXDVekS4Vp72pAn+cNkyY3wB5sl?=
	=?iso-8859-1?Q?X0AWusHi4rqC0oicsH/ulnsQ92609BZf+wd5lW9VB++Ntlq5TuPgK6Xn7r?=
	=?iso-8859-1?Q?Jt+PZnKUY8baR33lSv54L5L2ETEZWIq53JWD/VyjasGSo3n6kfD+431QvZ?=
	=?iso-8859-1?Q?yjQ/sAHL5NBZ8e5Pt/5vLMK9L572MlsRsGFfIntoGgeWiLtEO02wRNPm59?=
	=?iso-8859-1?Q?IfkaR9sk7EbCd8Hk1YRWutH/yvbopm84LRqJjC8ksQfnAQdVlgDiFTA/H/?=
	=?iso-8859-1?Q?DRSRogmZRhIF1ETPpGi+D+SFuFbgWPJGU4nM2qUovkgJv7heqCC/22QI4V?=
	=?iso-8859-1?Q?l/C09l2QFILoQWpMQ4tH7dutI0DbrUN/6yXmTRpsbpgTThOksvIgfmsaz/?=
	=?iso-8859-1?Q?FTnZ8E3UU3rPFmBCT3kkXYTLFsU4iTHgOgRst8gR9mz5jj7HmmwoVNlWyc?=
	=?iso-8859-1?Q?yvflC6qgTZdINNHn/xZOf9h2vPYLSzq6ZHXBu1uvBWGc3QYdDHps+l0kVI?=
	=?iso-8859-1?Q?jczJE+zROarQdSMlmp42fwpO+DcIRMKfCXJlDNzhA1CXSMIMgM84Z/odho?=
	=?iso-8859-1?Q?iWzlpS4y48WUg1A7YwJSl8pY/KDzEKdHMt+pS9lSh+uGOIBKWf7VKbvqr8?=
	=?iso-8859-1?Q?M2Nm32qO2kqBNIxLDTJo9ANFRImB/vvb1lksDHUsu2IcdjSlRZv8vKeedc?=
	=?iso-8859-1?Q?yUomWavPHWpqUtmEAlPevPwTT+23dL/pDv0xV9UHAjyDIsOPzPXbb6IyYE?=
	=?iso-8859-1?Q?yxL1p8AGGjvMs7wIVFPU8ohUXW60YFbN/VE1Wjxd1W7vhkB0/AZj6TPOcY?=
	=?iso-8859-1?Q?ZPqL7ixekTYyfYd5SjZFoDaFet/MdV4i/Ddn3m?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50276e26-5770-4e9d-ebe9-08d89b76146e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:37:52.3295 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoDEvVRI6Bu2bCZj2jMSUK1+BhUKw5uR/UrbKbu355p4YOyYZMw11ucxaAxEf80O9Li5EmBhltmcZrcpKJXmMaJJnsWdP+pAGj6XuP3FiAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4688
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B8Cc3K7011554
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	S <selvakuma.s1@samsung.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>, SelvaKumar,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Patocka <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Mikulas,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 08/12/2020 13:22, Javier Gonz=E1lez wrote:
> Good idea. Are you thinking of a sysfs entry to select the backend?

Not sure on this one, initially I thought of a sysfs file, but then
how would you do it. One "global" sysfs entry is probably a bad idea.
Having one per block device to select native vs emulation maybe? And
a good way to benchmark.

The other idea would be a benchmark loop on boot like the raid library
does.

Then on the other hand, there might be workloads that run faster with=20
the emulation and some that run faster with the hardware acceleration.

I think these points are the reason the last attempts got stuck.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

