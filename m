Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A85C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 08:08:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-I3u6rDOyNH-6Ggms79Hl2w-1; Tue, 14 Dec 2021 03:08:50 -0500
X-MC-Unique: I3u6rDOyNH-6Ggms79Hl2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C248519251A3;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA26719EF9;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 859491809CB9;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BE39cur016789 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 22:09:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8233EC23DB3; Tue, 14 Dec 2021 03:09:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CD4BC23DB1
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 03:09:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 619DF3800E81
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 03:09:38 +0000 (UTC)
Received: from na01-obe.outbound.protection.outlook.com
	(mail-eus2azlp17010000.outbound.protection.outlook.com [40.93.12.0]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-q0AYwvf1MAiaZ1rCYYPNFA-1; Mon, 13 Dec 2021 22:09:36 -0500
X-MC-Unique: q0AYwvf1MAiaZ1rCYYPNFA-1
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
	by BY3PR21MB3033.namprd21.prod.outlook.com (2603:10b6:a03:3b3::5)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.6;
	Tue, 14 Dec 2021 03:09:32 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
	([fe80::9904:180b:e610:fd83]) by
	BYAPR21MB1270.namprd21.prod.outlook.com
	([fe80::9904:180b:e610:fd83%4]) with mapi id 15.20.4755.004;
	Tue, 14 Dec 2021 03:09:32 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Ming Lei <ming.lei@redhat.com>
Thread-Topic: Random high CPU utilization in blk-mq with the none scheduler
Thread-Index: AdftWjJCThl7/4e5TledNcioslhEuwA0I/TAAAIttYAAAhJ/YABlPzcAAAFj94AAB4PEgAAi6P2wAAE/dgAABJYKEA==
Date: Tue, 14 Dec 2021 03:09:32 +0000
Message-ID: <BYAPR21MB1270D09A8CF5F21CAA33108FBF759@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com>
	<BYAPR21MB1270DCE17A0FE017AF3272F1BF729@BYAPR21MB1270.namprd21.prod.outlook.com>
	<b80bfe9a-bece-1f32-3d2a-fb4d94b1fa8c@kernel.dk>
	<BYAPR21MB1270B5DAD526C42C070ECB9EBF729@BYAPR21MB1270.namprd21.prod.outlook.com>
	<Yba8nL4x9R6rmTYL@T590>
	<BYAPR21MB127006555030F7BFA47FDAABBF749@BYAPR21MB1270.namprd21.prod.outlook.com>
	<Ybb4X00rfsjRgHj7@T590>
	<BYAPR21MB12706DCD5ED9FC7AB3EE2EEABF759@BYAPR21MB1270.namprd21.prod.outlook.com>
	<YbfrBpcV4hasdqQB@T590>
In-Reply-To: <YbfrBpcV4hasdqQB@T590>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9607a5bc-aab3-45dc-b941-912b06617ad0;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-14T03:04:44Z;
	MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccb1ef23-4d5c-43f6-f536-08d9beaf2699
x-ms-traffictypediagnostic: BY3PR21MB3033:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BY3PR21MB30334C56F8E8DCB3F6D385B6BF759@BY3PR21MB3033.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ye5K0JNRcx2ORTotGeql6lenzZ6UZw3BUipzGN34zohkwh4gQFXbfZu9Bv7GIynYhV1nD9zVp7YWRcp/9fo7ykJqrLKprxe3OkbCJnj9nfy8CyiTfiKtlluLa9pkzeRi6ItvsRJuj4iX3DzWMYwKF8C6i9vEkXxUj1Dp8BTYtnthO1l8ACaBvvfk4Ot0x7UaWFa2FjfK2lYmqSUJd2yTJlW4SqmyF3vUhMM9GbZJzoyhfKZpqQbX6+09vzdye7CykLPSyx/G0HzDggPfwSfYOUY5tH6vZmJU047XXJuoWOoYvFjSVJBhZfS/2rwTdmZwm3ar9q1fsxDmlmvd1fKOKVxsHg5glwfdCzMWylGdq1FclXBto9k2sYCqgLDTWqzmng1iVHxGyL2EZGiSyP9Z+wSjexvDca+at73/8rfr5IKDX5GvjT2P+G0orrap2qVOuh3mjud5mXoFjQDEOI/fPmaZ9HrY/TOEOB2jfF/yzZqII4wrpHJd4KwYbXO5XiFUQiD0xjGhoYfTZR8d+RTDrF0fllFvdjqXm0hVNVEYdptIWcDnjdXF/Qbpwgo+xXcnCQHhbm+YCp414427iv24dYbxlyWt5erSBUOc0cmNS9Zt6U09XtuedxM69vs5UXnM7pvkS46O0F+xR6GwAC+vtagKYiLfvfd0MNQ+GfkPTLyfTw7etwry1bS8ZYWPc0oqdXYkONgQ+j2s1RFCaqkDU6sstfMRg01qKbiY5ussH1mNqq6lVIiUkC6X5+lRqDAf
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR21MB1270.namprd21.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(7696005)(508600001)(10290500003)(71200400001)(4326008)(54906003)(66556008)(66476007)(66446008)(316002)(6506007)(64756008)(9686003)(6916009)(86362001)(8676002)(8936002)(76116006)(66946007)(38100700002)(122000001)(82950400001)(82960400001)(186003)(83380400001)(38070700005)(26005)(5660300002)(2906002)(8990500004)(52536014)(4744005)(33656002)(55016003)(20210929001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lSMi3N5XejgS/G3dwcwJfSdRZQB2myICUe25f2Xk49Q4ZKjUnRde7vbj5nkV?=
	=?us-ascii?Q?sUe5Dp0mI08q4BBxFldpo45/GJqwyc5W0LYMwhrI9bIMy71MGvu6JDtxc75T?=
	=?us-ascii?Q?lGSJaFDfZQMtqhqVNc/Fy7xQ1FRsRbICFMviTwyUpvyet7WM65gTsriINGit?=
	=?us-ascii?Q?Vc5/QOl3eag3UjXeivL28MCaPg/JQz8E5RYAwraRpstb6XhzV00mP7B54s30?=
	=?us-ascii?Q?/p/h6LZgd9hqt1HJtkfAAttsVwkAliEjLGVgu7+N43ZvpVE0/gwhj0Pgx/F/?=
	=?us-ascii?Q?a7SylccX4AZ5wzwTR2zjHiXn1GQ8+CmKLExLr8Pe29B2n6Vimq5mDbJJOGHV?=
	=?us-ascii?Q?WIrMarn4xTzyCASiuUxJmyfv0zSsUvZ0kXoLq6pGR40o/pVUzYRHr0Xe5w+O?=
	=?us-ascii?Q?H8ttRY7aTRTfomCwW0KSRT104bJvFcmpjIGbaqoIBoSmSgT/XstsFsQIqUwv?=
	=?us-ascii?Q?lEoakd3+ImFhBz6fAj724OlsTRV2P2+UqSjQAyyvHcPZR3q0K8MXPMpWsKKo?=
	=?us-ascii?Q?q2e0+Hji5ecYGhwYEL2/olm9wkkk1dCwOIy77SJYLP/o/Wi615gIpXAz3iC8?=
	=?us-ascii?Q?8DKPEOhFlk2I76nuaveCL3/YJSoU6R5vDDZUHSzbgPXVWd71M9OGKMoZ4b6Q?=
	=?us-ascii?Q?3W0Fz0wvNnWLVf+/KwnBi9DHe7u8owiHq67g1FSPKjqj4sAQqa97LmOCPmCj?=
	=?us-ascii?Q?j1u307M5jzUB1l1YSbVkgi8Eh+fFvW44zk0Mo5i0K+IeWEqFd5axQRWMKSub?=
	=?us-ascii?Q?seONHKRt5YJcGGvuliNSuc1tFqE/w0t0tknVlmDuswOmaojG6vFUOTeihxcc?=
	=?us-ascii?Q?gZEm+8T9jp9+6huBXMekbj8JijGRN0CvLpEYNHvvzAkJTuC4sETgfDUzEJAX?=
	=?us-ascii?Q?2kp2QaF1IP2G2QexpXC9oh1hMAKIT+3I3wHgQmfOacEGip4tnrSxee9WIEKs?=
	=?us-ascii?Q?Ilj+kwOWa49VQfwayAu0kTrKDMJ0apQXjsNk7WV1uhtAVOUbGcE2BpdVZlEd?=
	=?us-ascii?Q?F9YoDx1NuwSoX027vuAPc1perRA21m7wAMzxQBPx5//PBtm9mv4JKU9WzfHg?=
	=?us-ascii?Q?5aWANO8N17ga9Ox8WD1IYO1hG5g42qkI/RVRfx9SUHOo03i6fmaFc1KMMbkV?=
	=?us-ascii?Q?4WbPM2LEb7hBLbkJUnPRZzOZoTPddXyoWxX66ZQXA+Goe3qZnHyXLx+B172K?=
	=?us-ascii?Q?+lEdOvh98pZG2hq0JPBKw/9MqCZp8A8NUZtgT8ebZfz7xoObPeAOOkt0tjN0?=
	=?us-ascii?Q?azK5BawA9QnOKU/QjQlctm9n8Ypz0CzUJmszxAaY3w2uHMO5WXmXF7h09GhO?=
	=?us-ascii?Q?Fmc99KZfc8jUeNKQU18ZC7Ai9k/s1KzmPFkTVscpPHWRLcpvQsLlE16IC3bP?=
	=?us-ascii?Q?p3gZCbqbNVl2RuYfUOEYWtex14E748g/Js047OO3kCce4N5pMGjbqQjFSbEH?=
	=?us-ascii?Q?1XKYlsur5/ahi614mHxaW8j7uSZBS9i4j6N9TrtZFpfmMKIUOUsR9NuK/cGi?=
	=?us-ascii?Q?S6mdMu+7RYTB+Wpq6uzxyVkCR7YH2YzpProTr0vQHZ2vaIaX9QaN7ZtcEUcz?=
	=?us-ascii?Q?UVWWFCniOmqch6hQY1N14uLubNUgGG0U7iFUvOu8BbyCIC/lYmtjBlt/ae68?=
	=?us-ascii?Q?Ov6EOm9thIu6Xjv6WZL6Dow=3D?=
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb1ef23-4d5c-43f6-f536-08d9beaf2699
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 03:09:32.4764 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ZY+2M1CG1GEGX37lbZF7pk0opnGsAvGjbBSeL00ORaK1TQy4pdzOSffboqreuhGYeopu0d5orwJ2JbKRepd9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR21MB3033
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BE39cur016789
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 14 Dec 2021 03:08:25 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Long Li <longli@microsoft.com>,
	"'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
	"Michael Kelley \(LINUX\)" <mikelley@microsoft.com>,
	"'linux-block@vger.kernel.org'" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	'Christoph Hellwig' <hch@lst.de>
Subject: Re: [dm-devel] Random high CPU utilization in blk-mq with the none
	scheduler
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

> From: Ming Lei <ming.lei@redhat.com>
> Sent: Monday, December 13, 2021 4:53 PM
>  ...
> The single hw queue may be the root cause of your issue, and there
> is only single run_work, which can be touched by all CPUs(~200) almost, so
> cache
> ping-pong could be very serious.
> 
> Jens patch may improve it more or less, please test it.
> 
> Thanks,
> Ming

I replied to Jens's email with the test result before your email. :-)

Jen's patch does help in the absence of dc5fc361d891 
("block: attempt direct issue of plug list").

BTW, the throughput in the case of dm_mod.dm_mq_queue_depth=256
is slightly better than the case of dm_mod.dm_mq_queue_depth=2048 with
Jen's patch or dc5fc361d891.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

