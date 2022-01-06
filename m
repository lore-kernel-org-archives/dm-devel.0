Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0839C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jan 2022 06:10:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-UBoIJ2HSNqy7z6LdQFoduw-1; Fri, 07 Jan 2022 01:09:57 -0500
X-MC-Unique: UBoIJ2HSNqy7z6LdQFoduw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DFD58015CD;
	Fri,  7 Jan 2022 06:09:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE48312E21;
	Fri,  7 Jan 2022 06:09:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D0A14BB7C;
	Fri,  7 Jan 2022 06:09:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2066DAoA024452 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 01:13:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 895E12026990; Thu,  6 Jan 2022 06:13:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83AA72026D64
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 06:13:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9243E3C0D1B6
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 06:13:07 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-79-pWrISbPOMO2VIfTs0upLVA-1; Thu, 06 Jan 2022 01:13:05 -0500
X-MC-Unique: pWrISbPOMO2VIfTs0upLVA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242805154"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; d="scan'208";a="242805154"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	05 Jan 2022 22:13:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; d="scan'208";a="618229038"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
	by fmsmga002.fm.intel.com with ESMTP; 05 Jan 2022 22:13:03 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
	ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Wed, 5 Jan 2022 22:13:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
	orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 22:13:03 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
	edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.1.2308.20; Wed, 5 Jan 2022 22:13:02 -0800
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
	by PH0PR11MB5781.namprd11.prod.outlook.com (2603:10b6:510:14a::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7;
	Thu, 6 Jan 2022 06:13:01 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::38cc:22c0:928a:95b7]) by
	PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::38cc:22c0:928a:95b7%9]) with mapi id 15.20.4844.017;
	Thu, 6 Jan 2022 06:13:00 +0000
From: "Bae, Chang Seok" <chang.seok.bae@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
Thread-Topic: [PATCH v4 00/13] x86: Support Key Locker
Thread-Index: AQHX8IXgPtLMRzOkzUOX4xWFKhqGg6w0Uf6AgCDKzgCAAHjSAIAAEj0A
Date: Thu, 6 Jan 2022 06:13:00 +0000
Message-ID: <B67A9D30-2FC8-4AF7-957F-5A90D889142F@intel.com>
References: <20211214005212.20588-1-chang.seok.bae@intel.com>
	<YbqRseO+TtuGQk5x@sol.localdomain>
	<4101B942-6327-49A9-BE8B-9E51F0427F50@intel.com>
	<YdZ5HrOKEffBrQIm@sol.localdomain>
In-Reply-To: <YdZ5HrOKEffBrQIm@sol.localdomain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4d9282a-5a89-491a-f4c3-08d9d0db977d
x-ms-traffictypediagnostic: PH0PR11MB5781:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <PH0PR11MB57817C75E166E231327DA2BCD84C9@PH0PR11MB5781.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nP7qoHWjlcal9yYPNZfMfVbNg2d1W8f4qGITcK3ActdZi5+pQxRv7zcPYziLR2rDllDSHPjnnDzrfsAyeYTf6GfNQO0ypxUjYnRRX8ZItvxmoDpzqWWrHM+9XtTf8hMVS9H0LAN61cvBemqkcq/iaOZIGsrnA1i5kTKTP39d3NJw7j3bGQO6ml6C+5yBq9gmqEpcQZS4NXw8r0jivsaI27U50NLoNPx3SZIKDynjQGiLCZdvhNCnRhcvIhrpeF1Egw1UXENkbm1fheV6zpkZ8O4FF6IULAh4rHwlfBovpq0tqXgfjhOdGhcHrgOMZWJJQOGsfrgqMx3AyrHjhkd4U2u/Qll5ALFYm/Zv8bQ4VhWIDnoq/AzXCPedaSpe7f74t2WLaHrJdSDjfv4Ff4LAQWHBp5yvhu99jQW/PeU3/7OcVcdkvNAZgc8bqEeHpifwVDFOa0GFPdDGeRl0VBLq4eBnJZnm8kJSnxf30IS2PAgy1o/xAMFdkaQx2kgiHuO1tOubnrn8czp7R7fXimIyZ9kFaVydgEkQR7eIF9TwEvwEuXUF1cOiDSeLFBlSlVQEiwHo1zFVVJxKCSzc3eQeHL4iycvENZa6WySRvwhqXaQ4VqQIQg+CTsLdaEn1fqYpCvaVzlOdS0t1ius867J+Sf/ajuDPA94qdSWmtj5iRToN4/sPamMtdt2U0+oFiUPiyQKrBP7h7BwHsrMxULm0PSMBe1I0Bn46Ettn0xAr+OpRaYNXX9LqBP4+egy8BvP+
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(38070700005)(33656002)(8676002)(86362001)(71200400001)(36756003)(6916009)(508600001)(66446008)(5660300002)(2906002)(76116006)(54906003)(66476007)(38100700002)(83380400001)(4744005)(66946007)(26005)(186003)(66556008)(53546011)(6506007)(82960400001)(64756008)(2616005)(6486002)(7416002)(6512007)(316002)(122000001)(4326008)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZZ+OvV5mUFkbZ+CvJZ6AyM4L43DO5sLkQs+vArEfrRa5CIBTwFoYO38dHBwi?=
	=?us-ascii?Q?Vg90scRIx4YT4guTZ/dn2JVUGZgHT+2EYO2KrLdMFh5GiJCka4TzQ34EjH7e?=
	=?us-ascii?Q?4U/kR2Dhm5DwuvJ0C0BbAU/piPLqpWnYsmB2+c/CMlSBTSD3seYuqdD+FAqx?=
	=?us-ascii?Q?WlfKCIPqQvx522RWFBzCBCA8mYzBlGA+0V4CfMHtDdis8Jx7DxJL3GR/aMKE?=
	=?us-ascii?Q?qJiX9Xsitljf9wj5DNmgzRU1WprttSsHtt3kfuugCuqe/OXffHxTbG74Y9wB?=
	=?us-ascii?Q?KcqpETQva6fKrfU++BcyIGgigXUdnFVV5L8uEqrXOTYvQ5rxt9hm1NpFNxMB?=
	=?us-ascii?Q?uVETs6bk9Yq0nz+7FjcSuuvCuD6hJpxXCMWnEeoCrDzUqsWYgxL0EOuuyqVd?=
	=?us-ascii?Q?UWCiPCnC+ThQMw1TdN7oRnjgA8f2mQPLUzx/uC/oFTk0Nc2BnDx8RrHxT4V1?=
	=?us-ascii?Q?j2zRBfX9SJq6E/ob9G1FAhqx0ZiiMZSljKpRoPNNW5ZjLKBvIFocbZ9z0x3L?=
	=?us-ascii?Q?rNRzzUudTCrZckJ26KBQeruBPF/USURBGp6zVW9++thyc3dosU6FpUtQpZ8a?=
	=?us-ascii?Q?2CERuqKodCPNqOabXSxS9FP1DR5Pj32XVGekengl1i9lqY1T2i4z9zFuKmO8?=
	=?us-ascii?Q?oxo4KGYQvpw9wV3FSn1jV7xWaNZaKUvnnltlgYI1CtvsAYEiwkKs2r6kXlIM?=
	=?us-ascii?Q?dBTypP10B2YF/wfD4YwbcUsbqjQSRlXQM8z7hFntOtjEqoeczr9qpXVIm0EU?=
	=?us-ascii?Q?aZZFBym71GOUxkXB8fvwozIJiqeHseQdwQGPKmJAoKwJrSNH8mYQ820itAQF?=
	=?us-ascii?Q?3oSahMQWmWILf+GwrXX2NPLNCqPyZElXQfDlTdut/vARk0rMkpnnwEzuupeK?=
	=?us-ascii?Q?287pfgyFaYYrq0HkcHBUo0oQAe936BwEFZMm7LX6njb3Ri7qTuW8T08OVlIC?=
	=?us-ascii?Q?06bx1l08xurtjOBpXmu/XpDLLi8v0ZG1WlL2UvOM9EaAZpo9pCeKOaeQ9ek3?=
	=?us-ascii?Q?RnOsd5cQUVK22mR05cpUMs6IQ/O03SBl9YEJPM0GKgHB0DF+ZpFmQYni+gC8?=
	=?us-ascii?Q?EVU+5J2idQc2OY8meRlI4uqXwhysmLMtmNLg5C9WXS+zZ7M4a+j2v2hH+5LC?=
	=?us-ascii?Q?y2uWx4/FkorvIzEzneT4fgCqpqNTVDG/3odmJeIcK25mAoaZioV4kwpe02vZ?=
	=?us-ascii?Q?XqJ5S1XQCEgXRdqfu7DiZbcxXqyHcQAI3E5F46U9xypx+3eBkIfkWrvzz/aH?=
	=?us-ascii?Q?yWPM5Gn0ZWEWkBAZomgQLwB1Rt/S9J9I3XMvR9nwnSZ9MMp4rfOR82eBD+d4?=
	=?us-ascii?Q?fl1uFPJfGovvJ5Sf6g0gwQURaeYle6xfM7nxrq8yjtfTrwGXtdnbzGrPvNIq?=
	=?us-ascii?Q?eKIWseWI6+iq7qi5VXI+u3nMykuers//4/SG3k4TXVC4/fKnRsPZgV2y8dCu?=
	=?us-ascii?Q?UVA1FJRMwogRadtg/oGfTazeMLkgoY3aNRS9UDRtWPp97EUuT0/7XyYPTkDi?=
	=?us-ascii?Q?af3pWsaC8C1f03AILgnknyhAV4WSmdBfsPIZCnwBA7WJOTw04WddIPsrrFf9?=
	=?us-ascii?Q?T/huSffsvvpVUk2o2STEMmnBSEZ37/tOgpeVtU0v9zMKmp6vXzHUzDUomhw0?=
	=?us-ascii?Q?NhdgFcyzXFBiYp1HANlm+6Jp9829pCzFbCG3DdmBqiPJrtEVu1WR9vMBHOi/?=
	=?us-ascii?Q?xKz7V2S4IRDlveTBbNeATCrhHqU=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d9282a-5a89-491a-f4c3-08d9d0db977d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 06:13:00.6108 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sD1v3mVU+yDiT9v7LQoLQfNKGrsTxX2OQt9x/BBiccz/durOGqfaKqRIK1uY5pjxAIa4wz1U4sfd+e1etThSfvcnAgLxQl+vCRB6CNsNrpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5781
X-OriginatorOrg: intel.com
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2066DAoA024452
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 07 Jan 2022 01:07:52 -0500
Cc: "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>, Herbert
	Xu <herbert@gondor.apana.org.au>,
	Dave Hansen <dave.hansen@linux.intel.com>, "Williams,
	Dan J" <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Krishnakumar,
	Lalithambika" <lalithambika.krishnakumar@intel.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Lutomirski, 
	Andy" <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
	"Gairuboyina, Charishma1" <charishma1.gairuboyina@intel.com>,
	"Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>
Subject: Re: [dm-devel] [PATCH v4 00/13] x86: Support Key Locker
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
Content-Language: en-US
Content-ID: <650678EFAA8AEA4EBF93642644F856B7@namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jan 5, 2022, at 21:07, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Jan 05, 2022 at 09:55:17PM +0000, Bae, Chang Seok wrote:
>> 
>> As long as it is factual that the mode was once popular, it can help somebody
>> who wants to use Key Locker for an old disk image I think.
> 
> AES-CBC is/was usually used with ESSIV, in which case the key cannot be fully
> protected by Key Locker.
> 
> I'm not sure you should bother to support legacy use cases, especially since it
> might mislead users into choosing a worse algorithm.

Alright, this is not that critical as it will be possible to add this mode
later when needed.

Thanks,
Chang


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

