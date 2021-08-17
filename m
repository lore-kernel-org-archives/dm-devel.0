Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D6DC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 01:51:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5E5C60F46
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 01:51:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C5E5C60F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-dJB2MljePP-iWZ-HuH0eEw-1; Mon, 16 Aug 2021 21:51:13 -0400
X-MC-Unique: dJB2MljePP-iWZ-HuH0eEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 217181853026;
	Tue, 17 Aug 2021 01:51:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B05D0669F3;
	Tue, 17 Aug 2021 01:51:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C5F44A7C8;
	Tue, 17 Aug 2021 01:51:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17H1kh89027186 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 21:46:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C8BA621449D5; Tue, 17 Aug 2021 01:46:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C222221449D7
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 01:46:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1672E8D138C
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 01:46:41 +0000 (UTC)
Received: from esa17.fujitsucc.c3s2.iphmx.com
	(esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-80-wXgXas9pP2a0MYB7Z-d8bg-1;
	Mon, 16 Aug 2021 21:46:39 -0400
X-MC-Unique: wXgXas9pP2a0MYB7Z-d8bg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="36657678"
X-IronPort-AV: E=Sophos;i="5.84,327,1620658800"; d="scan'208";a="36657678"
Received: from mail-ty1jpn01lp2058.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.58])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 10:45:32 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB3000.jpnprd01.prod.outlook.com (2603:1096:604:1c::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14;
	Tue, 17 Aug 2021 01:45:28 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.023;
	Tue, 17 Aug 2021 01:45:28 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
Thread-Index: AQHXhSoJ2MKEQAyDOkuQStUpIsX3SqtlsyYAgBFVaHA=
Date: Tue, 17 Aug 2021 01:45:28 +0000
Message-ID: <OSBPR01MB292042C10A7AA95CB6862F08F4FE9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
	<e844fc54-113f-239d-da23-fa140aeea9d7@oracle.com>
In-Reply-To: <e844fc54-113f-239d-da23-fa140aeea9d7@oracle.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ccf31b3-b7eb-4bfe-8767-08d96120b0c6
x-ms-traffictypediagnostic: OSBPR01MB3000:
x-microsoft-antispam-prvs: <OSBPR01MB30009BBC35070111A6F5EFAFF4FE9@OSBPR01MB3000.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bVI+29haPUqxDBc7Ukq/XeEfo4Gf40TbeArXck6AnboSZR6ehfDA8Hct3dU9TQeJT+sELzLFNyaEirRplqNzgN5FyVOofVZCzm4uq6xk/gbvC5fcL9ggK+9WLw5US9/Z9KV/OXMVN5uUdH9LCtwxqlzVZCe5nI96jgqbGsJdZzKquMmZY5wONN8h6lrpYH0sDhEZACLj2F4vOeqEsv2j2fgWBZ1uRgjEdSf5ur9nhaVuJdaUX+DfUx9OZalw2h1Hbn0WN3PtTPeljzX1eZnO35l3I5ySzHn7FbSXu6xU4s6bIOVqzE3CfTwNiGZJXkZGjp5qF80Td2rAiUFm7iOlI50ofwSCXN5HxFk5XNNf1sI02FC1qKWjhx9vHOPe2VW2436s8vBqro9aWKSTHtWY/qJxy3eZ8SB8qBWrChsZlvCd8aDezQI8uoHjf8PrIHIbVQ6amO2UWm1hC2iY4C3Itbbgs5KmiDDVbEScCGc9bA0VOZVeESySDh6Dw2sK9dC6O4WyauKz34hC0WmntUuv5z+TpoZvfpZNMxn6GZ2/s0J5ja1z+/2azqRmwtH5ffmkh5wegLI/xTO6NRJXnyyKOnj49DltkycC4YTsFEXuZ45tswVNmS+/yEWtUHlxVWEhg8vFq/hW/ZypJ/HkvtNMfWg0AWXpxQ0jY4/1fC8xMkMeuxJnCShIPz/AISFLEEgZ4K1s0vw2t84VsKOHMcFZSw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(8936002)(122000001)(5660300002)(7416002)(85182001)(478600001)(38100700002)(316002)(54906003)(2906002)(33656002)(66946007)(86362001)(110136005)(83380400001)(8676002)(66476007)(55016002)(64756008)(26005)(66556008)(66446008)(9686003)(6506007)(53546011)(4326008)(7696005)(186003)(52536014)(76116006)(71200400001)(38070700005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MU9ETnZkR0VWcGk1cU1YV1p4ZUJjSy9wUDE2bE1sWFlpdHhtSHpKbitDNi9j?=
	=?utf-8?B?Uzlxc09xcjZqOHhSOEdSZmxEM09oa29DaHJoOVBUN2VjNGVNeUFLMHBRNEsr?=
	=?utf-8?B?aldabzUzSjR5YnhpZW5zWnhBNVptSVovNGxFQzFaTnlTeWlQRW9zWHVXU1Vh?=
	=?utf-8?B?ZlA3Mnk3MjZrSEhNWUVFMExXRW45dS94VXdXbis4ZE01UGpTT2MvRjUxVFFx?=
	=?utf-8?B?RnByTTYxTWVZc1lUVUpEVHlYWmxWVVBZeHdVQ3hKaVdIVWZmLzhDRzN1VGg1?=
	=?utf-8?B?RmhsbGUxNWV2THUwNkVjRi9NSWFIdDZQbC82Y0I0Y1hTYUNzcjBFc3dkYnJM?=
	=?utf-8?B?c0dvUHhPdTZSM1Rxa01RTlBwbEhxeExaNFFvZWhOU2JyRjR2SUtVZkQyR0Vv?=
	=?utf-8?B?djVlRnhJcHg1R0hBNUw5N0VjNEtDR1lzODdKbVQ3cDhrRUk4WGxVSlhsVW1B?=
	=?utf-8?B?Mlk2SENiWjNIWVRDM0RWNjhjQkxQaHJ2SWdqcmdWQTJDa1l4dDR5SGtsblhu?=
	=?utf-8?B?dEpNU09tSDN2bFdseTFuQ1FibktHbWdRN3hqb2pIamxNam0rcWw1c1lVZndW?=
	=?utf-8?B?aWNmQW51cEVsc1JpY3h6T2JuQjRNTlc3eFp2SWxhMkRQRVJVcUhJSEJ2cFl6?=
	=?utf-8?B?Sy9kSnJ0MFcyZnBncVREY0E4RjN5WE1mQ3hRQXo0TEJqMldMZXRVU3FVRlpM?=
	=?utf-8?B?WEhob1N3ek1WUlpFNXpxbUZMMC9lVHEvUTl3eFhPZ1EydCtDWlA0enFKbjZE?=
	=?utf-8?B?cWswNmM3Wkx6Z0QxQVV6VzdYMVpDV0JLTXJ5RXVYMm5UUjdTc0twc1g1MGJ6?=
	=?utf-8?B?a05OdHBkL0d6bER0YUx4QjBvWUJoMFEvUjRFZXJQdmt1eW1wUkt6aXE1WDU2?=
	=?utf-8?B?K2xTbDQ4a0NDY1NaZ0F2U1ZYN1FPa3ZDYzRac3FQTkFTNXRlVXhlZlk3YVM1?=
	=?utf-8?B?bWF6aVlueDQvR0djTHZ1VnBaTlVkTHpDUFJmVlZjdjZHUkhoNXVOd3dUeGVv?=
	=?utf-8?B?TjJkdFc5UGQyQ0ZZcGd5ZmZpZnRNOFUxNS8rN3gwZWU4ZmdVbDZMdXlKSHFa?=
	=?utf-8?B?MTMvdmJwdTZSaTIxUGRWQm1qWUtrRTVHaXBDRks1Y3pzZUR1S21md2R4S0kw?=
	=?utf-8?B?eExpdVY5ZmVGNmtqelZGdmdXejRWajN3eDB0VDJrRSs4eS9lMjk0MGhGR3NW?=
	=?utf-8?B?dGtlN3ZFckJ2eUpvWDdPQ1Jva1lnUUlvemJCR2VxcVlhRHZEMlZDVTM0Qk93?=
	=?utf-8?B?bkxobmN3dmJzazlpS2JXK3ovNmlQNXNTYnFlUFNCYkdQUkYvdWIrZzZrSVY1?=
	=?utf-8?B?TGx6TEczamQ0aDVQcE1naVBQMkc0aVg5R0VBYXhQS3NMWUpNT3luK1hkcHpZ?=
	=?utf-8?B?K3lQUWNOcThHeHZZRkZQcUJxZ0FoazVtOTlocXlDOUN0bG1DTkwzUjNBN0lx?=
	=?utf-8?B?MUR4TG1vK1JTRWx6Smk2MHNocTgxeUEzVDlZbEtHTU1aWGE4aEVTYzNyM0hH?=
	=?utf-8?B?NjltY1gydFRyVUhXUG1QR0lQdTIveG0rQkZqQWtyZ2ZaS080REs0dkdDb1NJ?=
	=?utf-8?B?bzFjUlIwZ3VqS3RoWWVtUE1aQ2RqWlJZMWRDeXhWK1VjSzVZNk1NeUdCS1Jq?=
	=?utf-8?B?cW1yZVBrQ1NsRHZzZCtvdlYyTWNVMzJxcUZNaG9DUXF4akZEUjFOOWFYQ2g2?=
	=?utf-8?B?V01tbFpkUDBlNEZjODBrSnE2SE8zRER6SklpRitlMzdua0lzYWxpait0VStH?=
	=?utf-8?Q?qCDu2qcdK6IzUWSh65RoOslfauwNdJPOydn6roO?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccf31b3-b7eb-4bfe-8767-08d96120b0c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 01:45:28.1734 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQJF1TotPN+oWvieAzz06YKTmRNHnZq3iylTD4fT8ah7/a3jhH6OT7Dbft7Zpe1rD793XlZl2aBulMkaMIR/YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3000
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17H1kh89027186
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 2/9] dax: Introduce holder for
	dax_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> -----Original Message-----
> From: Jane Chu <jane.chu@oracle.com>
> Subject: Re: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
> 
> 
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -214,6 +214,8 @@ enum dax_device_flags {
> >    * @cdev: optional character interface for "device dax"
> >    * @host: optional name for lookups where the device path is not available
> >    * @private: dax driver private data
> > + * @holder_rwsem: prevent unregistration while holder_ops is in progress
> > + * @holder_data: holder of a dax_device: could be filesystem or mapped
> device
> >    * @flags: state and boolean properties
> 
> Perhaps add two documentary lines for @ops and @holder_ops?

OK. I'll add them in next version.

--
Thanks,
Ruan.

> >    */
> >   struct dax_device {
> > @@ -222,8 +224,11 @@ struct dax_device {
> >   	struct cdev cdev;
> >   	const char *host;
> >   	void *private;
> > +	struct rw_semaphore holder_rwsem;
> > +	void *holder_data;
> >   	unsigned long flags;
> >   	const struct dax_operations *ops;
> > +	const struct dax_holder_operations *holder_ops;
> >   };
> 
> thanks,
> -jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

