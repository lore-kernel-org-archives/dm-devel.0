Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2902FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 07:03:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-ze6gQ2FZNPCnbdUGASKqyg-1; Fri, 14 Jan 2022 02:02:57 -0500
X-MC-Unique: ze6gQ2FZNPCnbdUGASKqyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647A01018722;
	Fri, 14 Jan 2022 07:02:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C3425DBAF;
	Fri, 14 Jan 2022 07:02:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A59E4CA93;
	Fri, 14 Jan 2022 07:02:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DMYZtG025713 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 17:34:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37AE0141DEE3; Thu, 13 Jan 2022 22:34:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31149141DC2D
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 22:34:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1356D101A52D
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 22:34:35 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-340-ZOZTTAq6Ma2a_aWEhKCKYQ-1; Thu, 13 Jan 2022 17:34:33 -0500
X-MC-Unique: ZOZTTAq6Ma2a_aWEhKCKYQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="224816208"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; d="scan'208";a="224816208"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	13 Jan 2022 14:34:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; d="scan'208";a="529882005"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
	by orsmga008.jf.intel.com with ESMTP; 13 Jan 2022 14:34:31 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
	fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 13 Jan 2022 14:34:30 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
	fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 13 Jan 2022 14:34:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
	fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 14:34:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
	by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.1.2308.20; Thu, 13 Jan 2022 14:34:30 -0800
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
	by DM6PR11MB3963.namprd11.prod.outlook.com (2603:10b6:5:19b::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10;
	Thu, 13 Jan 2022 22:34:27 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::f063:8fd0:839f:76a6]) by
	PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::f063:8fd0:839f:76a6%4]) with mapi id 15.20.4888.011;
	Thu, 13 Jan 2022 22:34:26 +0000
From: "Bae, Chang Seok" <chang.seok.bae@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
Thread-Topic: [PATCH v5 00/12] x86: Support Key Locker
Thread-Index: AQHYB/pCFarBJFjgXkafl7Hx49PA1KxhhmMAgAAFFYA=
Date: Thu, 13 Jan 2022 22:34:26 +0000
Message-ID: <51D8F2DE-404E-4BED-8CE5-4DB1D2243556@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
	<215bc107-aa47-62bd-65ad-f76e65ee75d5@intel.com>
In-Reply-To: <215bc107-aa47-62bd-65ad-f76e65ee75d5@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b012e708-b925-456d-db07-08d9d6e4db49
x-ms-traffictypediagnostic: DM6PR11MB3963:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM6PR11MB39637820680BC1AD1180ED9FD8539@DM6PR11MB3963.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: dtslBQIKiO+8zlJeEnPXnP0THb+LU4783fJVoexmrqZpV/fKLawWKqnnfqSZk9uW+XjgXRQbD+1neLSq9oja/QW1WqA/lNMPLgpVi2xDbu+I1/nT9tEv1xK1Mt64+PUvDqJ1FeHGNx3QEYfFwPMXS0sbpQ1IwWvUMXJCFKXTmq+mCKFRnSd1MCHn6YTQ2/rGSzEylQdBisUA/d0fTRplKKnUXnXpjIPfmWnxapPjujB+DJluw6PMeKmddC9nLoojX5xm5JEZSwAx4EZygZ4/axS11X3G8FBkA+7Dgto5HgG7GWhcuuNhJ4Am4A8c8H/ozSHc+hQafIMyG9URSre7O8wXrCJ6pose1X6JvtOTesApZaGtui0+tDC8jhw7LHTWZRhA+baPkGXB2u9l/wm+idY5K0eBzpFKfA7iNKL3QZIX+suZftKsT0vWARXFlX9tA2kPfWCYSKbgJY85Up319aupvzT00QCxuFuvHx9Mmd64fRe2JqcSAkh3Dqd6HIFavgmKYkC88zXXaLeG+rPrXb+NnSZC7Fj1wTKSdQftDGEHf5bdA6F+j42Zpba98dKR7dx4zqnK2qv/g8L9fx0PMxoy1Mi58+SMapic9enDdxAWdTMI6sHR0d3yL9/Kr163i5zf3+5TZkqT9trq5yBSpj0GGWDkdJcXBYoYIlmY0N2AlgMEpFhjUEPJRGsKzt+koiEkoQKOduPIV1VooSI1utCSB/rUX5gdvsSFy1BOVEQEWgjNat4QcxO9XzAfNHCm
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2906002)(26005)(33656002)(6862004)(508600001)(54906003)(4326008)(36756003)(53546011)(6636002)(6506007)(316002)(37006003)(38070700005)(64756008)(66556008)(2616005)(6486002)(86362001)(122000001)(5660300002)(71200400001)(66476007)(66946007)(6512007)(76116006)(186003)(7416002)(8936002)(82960400001)(38100700002)(8676002)(83380400001)(66446008)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9k0LxA6w67rkJREQ3peII+DFkdCQWLvaJi636oBbtPLThtO+CsZGqS5Pjnwa?=
	=?us-ascii?Q?PJAjJ9KHmVktBS+uiLQPOnPLYlMmRe9yo65iCcc/fsxfVKrFejNMCb36ATkS?=
	=?us-ascii?Q?jRT+r+qUmcQnlzr1su8IYYPs0eBQX7LFffs9XwinuVTPsCIQquBRFlW8CODm?=
	=?us-ascii?Q?G8q5cAj/muCeb+P41263gsUBfeA2z7OzGgUJ9fdDmyuP0OI0I6kqQd621qMS?=
	=?us-ascii?Q?RL1DJxUYCQHf4OmBqAhbLOe/mxrLyYILOq6YD4UR7H5s7InR1fTfkZxtCOfH?=
	=?us-ascii?Q?t/6Hm5Db0SphNaZ1eW8gUJ8JxelQ/cNa2C00Leg612lWxuUae5JD8cYGXY1Q?=
	=?us-ascii?Q?LUDNyizaaN9ymgU+5mbeCSO+eWjdx7ZXQ2EA0/1u075sIkkdJXp2BeLZF6HF?=
	=?us-ascii?Q?cpKmWVcKPV+PKneMxvF16GMazdnuckamxVb/DTXrKNNE1RReEp24QdInLYbT?=
	=?us-ascii?Q?xuTwDCOi36xl/7T51rg6UNpu6Sonh+2pyTj3Z+cmcSYfA1KDR4j4iWWt42hl?=
	=?us-ascii?Q?LuPV1JUHMtA26g7GIJ7iYgU4u9L0Jw9cCtRIYVrQqkSemFyFhhXuVuxuWWpx?=
	=?us-ascii?Q?p1655EObVWQ4JtT5jZ8oP7iUr5hsoSvM0/rv/85O6GQ41bP7RUB18ATAzTuJ?=
	=?us-ascii?Q?kTduk56GlSNaQGWY39OFP0W1Q4M5eaKs1wQ1nKp1Bu50vtLTKmSCmhbj7SvJ?=
	=?us-ascii?Q?CMG+TV9aE8l/bDIjmvTi8YTMRNZMbFC5DY+RtVMz9/2JtaJ3p+eLqGYgtaAF?=
	=?us-ascii?Q?X/E+JhqY83R0UxZ6eKwtckX2hsxJ1uXEjwyrsiXFaiFb/Fl1KQGhyhDMAhR/?=
	=?us-ascii?Q?4ChzKRnJ3Jj0XuYrsGSOU1o/GY3U0P9CyHGmsTLOnjWJPw4tJ4Kyc/18AJn4?=
	=?us-ascii?Q?NRmr4D/8aUUfSjvCeYdJPhWudrqXdRKrh2LoAKEDFEeW74g1wHxNdvpkuTlj?=
	=?us-ascii?Q?8ep27MX/op+D6Z09zFhoVyjqYaA1rjGbrPPBDJYbQ4IUKadhLNOeMH5cd+Hf?=
	=?us-ascii?Q?fPVnPYU6ahzWt43/q5kxtwEfZxeauoVq31vw4+9R4mtEhWQkNLDfeAHXHqjS?=
	=?us-ascii?Q?qtRR3H9q2okgCmIOZF3dVwmx9K9QvbqzlKMDbGqZT6e6+nzpdagUO/qY09Ha?=
	=?us-ascii?Q?0d+1ztKzlRlurmwKmF8TgOHbgrIiZWtyrbkgqpSWhrzKuWxWVz1I9DbzE6/D?=
	=?us-ascii?Q?UdJJFxtyAOjaJr+q7ngp0FmznkwZ/krzGI8LZV+ziawEB7zXC0RWSu+WMMdn?=
	=?us-ascii?Q?r6lZky0TTh4zN8P5KwzYGqJBQuxyuzMpHSdXCKVKoBJKGLrheDzh/KrA5PH9?=
	=?us-ascii?Q?LvGeooYsC8pjvOpAUYPWC0u3sEjgx85dhdj4vC7LkIJ4Q3sw+ZbEDaZ9NslB?=
	=?us-ascii?Q?A2VBH6B8IZVAmTC/fl7h+8tyEFscj/HOo8FIIsNXub/sAuR1zZldz0EkWpmd?=
	=?us-ascii?Q?eYzWA8D1kcqRykMDTZojQKZCyn8PEdpnnc8IpfyNvzCQxiUb6sgbdoTFPNFr?=
	=?us-ascii?Q?mwISMgkGwmb+Y+lqps/U4H8QiVg9jSFsS6K0VD01gEMIpH6YG+x/8kEVuJ02?=
	=?us-ascii?Q?h+vkJSDmb9OFHcJ/0aG7TYmimKLpsao0t8Iz1Q17t79bkQwSBPbGSkB9YDLi?=
	=?us-ascii?Q?S2yxc7IDjDIDb5e2r4oDIfHA7+hNSGVBCviuJmuCduIz6mRdlIN1wm8XqtDE?=
	=?us-ascii?Q?M3TwECkIf3bZzhptVxuSuuBHRtI=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b012e708-b925-456d-db07-08d9d6e4db49
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 22:34:26.8155 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2pMybOAZQVFRJDTnRUfrxx/O1C/4UYxxNetwcYX4oi5Ww1FJc328OuUDsquZKNKMb2lE+Rr3NQtIqaxMxg1SLfnLD8Vri0AVmGaGa9lUqlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3963
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20DMYZtG025713
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 14 Jan 2022 01:58:10 -0500
Cc: "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	the arch/x86 maintainers <x86@kernel.org>, "Williams,
	Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Lutomirski, Andy" <luto@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>, Ard
	Biesheuvel <ardb@kernel.org>, "Gairuboyina,
	Charishma1" <charishma1.gairuboyina@intel.com>, "Dwarakanath, 
	Kumar N" <kumar.n.dwarakanath@intel.com>
Subject: Re: [dm-devel] [PATCH v5 00/12] x86: Support Key Locker
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
Content-ID: <1D0ECD449A0C3D47899F823B5A473FEF@namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jan 13, 2022, at 14:16, Hansen, Dave <dave.hansen@intel.com> wrote:
> On 1/12/22 1:12 PM, Chang S. Bae wrote:
>> A couple of other things outside of these patches are still in progress:
>> * Support DM-crypt/cryptsetup for Key Locker usage (Andy Lutomirski)
>>  [2].
>> * Understand decryption under-performance (Eric Biggers and Milan Broz)
>>  [3][4].
> 
> I really like when contributors are clear about why they are posting
> their series and what their expectations are.  This posting leaves me a
> bit confused as to what you expect the maintainers to do.
> 
> Should the maintainers ignore this series until those in-progress things
> are done?  Or, do you expect that this could be merged as-is before
> those are resolved?

Ah, right. Yeah, this is not super clear about that.

I think it makes sense to clarify those two points -- performance implication
and user interaction in the usage case, before considering this feature
support in the mainline.

But I wanted to address feedback on the patches with this posting. 

Hopefully, this clarifies the status of this series.

Thanks,
Chang


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

