Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019CEC00A5A
	for <dm-devel@archiver.kernel.org>; Thu, 19 Jan 2023 07:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674114166;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ctt1rqZSJdidgW/qGD9VWLkfP206vNleKniy3mxdwcU=;
	b=fq7FJvSrWMdOU54UkhE4ffhlCHzP58LMrO6v/XQ4j/UOsXyLlRZ6ZZ9OMDoEJE5thj/DPE
	dR/daQ4Ia+aaoPCcxaCqHnHmNnKP8c9VvM51FvRx3miuB7MtbHZPqIWtOGS5LRsoY69w6V
	qWb65n5HuuMtWN/HFWrh0GbXqK2uG/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-PlIJKnfZMHmkrorZX58Gmw-1; Thu, 19 Jan 2023 02:42:43 -0500
X-MC-Unique: PlIJKnfZMHmkrorZX58Gmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FBFB858F09;
	Thu, 19 Jan 2023 07:42:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 330022026D68;
	Thu, 19 Jan 2023 07:42:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 01AC31946A6E;
	Thu, 19 Jan 2023 07:42:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2381D1946A6D
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 Jan 2023 02:22:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9662492C1B; Thu, 19 Jan 2023 02:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B09BD492C18
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 02:22:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C478280BCA3
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 02:22:14 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-wWbBwISaO1yR-xh1CS9EXQ-1; Wed, 18 Jan 2023 21:22:11 -0500
X-MC-Unique: wWbBwISaO1yR-xh1CS9EXQ-1
X-IronPort-AV: E=Sophos;i="5.97,226,1669046400"; d="scan'208";a="219514541"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO
 NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
 by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2023 10:21:05 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN7PR04MB4305.namprd04.prod.outlook.com (2603:10b6:406:f9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Thu, 19 Jan 2023 02:20:59 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%7]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 02:20:59 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Thread-Topic: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status, an
 expansion plan for the storage stack test framework
Thread-Index: AQHZK5fyQKUFtoPftkeiJLNotrztl66lAiIA
Date: Thu, 19 Jan 2023 02:20:58 +0000
Message-ID: <20230119022056.plpe5wejji6gl3fp@shindev>
References: <e24383ca-8ba8-3eb3-776c-047aba58173d@nvidia.com>
In-Reply-To: <e24383ca-8ba8-3eb3-776c-047aba58173d@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN7PR04MB4305:EE_
x-ms-office365-filtering-correlation-id: 63fee9c3-1b1f-4509-4a59-08daf9c3cd8b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 91cLSjZxDlyJbNr/xcnas/y/VKyOnpM7eRt4HmXmzYtUTVRHLkzUJg72rwLNuib5nFuegY+L8mW85EP3pTuPOjZ8g5G1r15eKEJLF+lm8dUIx/OrBDMruYh+lXrleinRIh9QzqK231ykzTvpUJWp0NSbN/XY3ru8rjDWoYnyxPej5WTcDhDS9Dm8MB1BKQvvpMACj42LwA4WSxuQMVPvx2SOhtW6Q49gRQ/HpAtQrEyk2Fw+VBDcFu5Gc1zY7gRLFh/FgoYIhIKDiNN5L5H57K5rfIIq7KHr/r3YDN8qPIQJzl+TkXKGlqm1tqaR/G7lVHyxJEXnbD9Y899Gk8gvwZcSOnMSV3KaVQH+2mAj2Fzp5VxT3x384+GDksou2cmTrSC6lWe3yX1R2aAFRtluk3sWCKEkoQUux8g36ZUj1V89Dh60QBd25uuF8AuSBXdJ9mjQVkS+IIHVBpNrecfDbZx+lSyvN5XCHL9JDjJFfdM7hdDw+hf9r2rPTelYAOmcjdnwumFxbPL/fFeuiIA9eDbJu2Wh5RSMkDa2oarvPdlNhfmCGenWUrLDDabYIKULmlgoCvowWM7Lskhq+utbq1+w61qJFr7oePcdJyM1PNUvdH4KVv28utp42CQGyoLIrDT/f4TFmeF7kY/LGYD3CMQQSdik9PxnVl0++szO/wdVXl6qRF5muYSKODNiKGUzyh+jo4eklY7ay6P5bEHXJZ4919mAEAgB/0rSHwvURAy+A2hxmLixfs6piTSj2Y81iJViyn5MnJvjj1NYj/KN4A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(83380400001)(41300700001)(8936002)(54906003)(1076003)(316002)(91956017)(4326008)(66446008)(76116006)(8676002)(66556008)(6916009)(64756008)(66946007)(66476007)(82960400001)(38070700005)(38100700002)(33716001)(86362001)(44832011)(7416002)(2906002)(5660300002)(122000001)(71200400001)(6506007)(6512007)(9686003)(26005)(186003)(966005)(478600001)(6486002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?m5pHjb4qS4yWHCB48dWySdcGpIUPbKBPfGcKNYR1QxDdwldxzwTnktwr0I?=
 =?iso-8859-1?Q?XKSqwS2FhWazUfo3l1UDJZTzXXk+BCJp8v8iPfR53knl6KIrCzftDHXKDE?=
 =?iso-8859-1?Q?ui87oxcmCw3VNA7MTdqFIzPM+UwladUY4AHUQB4b5q3y4uj/PaDzcjiS5d?=
 =?iso-8859-1?Q?IuW7lZWFj5vssDzti5ZzBgFhxudCrEEBZwOOyOV0w2GLdjVOa45FVAd60d?=
 =?iso-8859-1?Q?BO+Cgqn/i9oRX8JwAHMqTMgio/zGVsP3BPUjrBTgL8WGyqvhzFutAyv4kN?=
 =?iso-8859-1?Q?DpHRHsxHCJWe2DnkxHfIYraQ4EmM6TvF6ZwW6EYp1I/r/Xmno9BxlPdIHw?=
 =?iso-8859-1?Q?EH1Fp7dDYXepjY9Vdz8QqNb17Jkegbbz3TReDUOqzln7xEslLuACdd67N0?=
 =?iso-8859-1?Q?UPv0e16g7NZ3KpM802UWZUMBVqWyrcAJIiQh3wJ27lvX1F94lluLXhtTtA?=
 =?iso-8859-1?Q?mKqO8dsqXwdSruyx8OVVqBtPfeVHf9XJQ8YJtwD0dlEelS+wDwFC00/90A?=
 =?iso-8859-1?Q?dsA5S7lDOBPmca4v4ekd4OZTy8WXOzFCOVcwGp1csNAhAcEmGxuNoZ9dsC?=
 =?iso-8859-1?Q?EMajcAFaFhDrznNT2XafdlZ2F+lkL8ryBYIQCEb+pl5j98mdsNlcOHre/G?=
 =?iso-8859-1?Q?GRW6ApEh3ziJph3iWJyVJF1wetKgtyMl+W786p3btXoWWCFEm2t1kGqopl?=
 =?iso-8859-1?Q?HHoy/9kZujQh6cKt4vQBk1EEk0jebOMCxejkUhLR7xPtv+Yiw+Z2NJoeDn?=
 =?iso-8859-1?Q?eWMG8AAL0hTRYmkVPA9A2YSbOTScYHlCFYWxQ9UJCPVyE/kLLeXpDfBu/A?=
 =?iso-8859-1?Q?e5YZ/fyhoWAlNraCDFhEw3ClbZGUGAewLRQC//UiqaNhr+exK8VlfKpusk?=
 =?iso-8859-1?Q?kQXt6he0/5V5riTlV2IcYsyQP4HqJ8c5bDIM1oocyUV2707hDWDLHFQ5Z6?=
 =?iso-8859-1?Q?+k31E7B54U3qGmG7RCdhbJALQ2yr4pcV8AXo6QU8spO2hF6tGBFuQTbBEv?=
 =?iso-8859-1?Q?gH+cqb8AoruGjQOTI9ijT+Wtvt48WPBkGlluzDBY+gl6fb3+Z0vx2l1j8j?=
 =?iso-8859-1?Q?HQrtJBts6EuCAdXn+t5F8IOPvmo2Zn9T7hfUCsky8sUiSl2sEGPR8x2qsU?=
 =?iso-8859-1?Q?bQP8L8yEWbBKDMeSqyfo7VyYev+7Xzeku3CRye6SCx4gnUhnHrKCnkqzvB?=
 =?iso-8859-1?Q?Re6pSoncb8TDT5Uq394gAae27zgIPrmVuAIfaK8Y4/0LRfHuA7t8LAH3KM?=
 =?iso-8859-1?Q?5H4pbh4ESjXZOkWLW1sGb/WPlChPkuXocos+A/h4DBHJ0ohYaiJoEqQAXz?=
 =?iso-8859-1?Q?2eZYFDb1E7xyHOSFoZNCrN4saZSSA3H9kdm5jpQXUiDIQYjx4UPRvQxO5a?=
 =?iso-8859-1?Q?sUUc3qGAB1s3gl12WIDTKMsBnS0/o6A2h7de7vgN9TKiSu6Rm4CDImxPfg?=
 =?iso-8859-1?Q?/z13HQfRxQsd26fD0VTFnPNHtKr/EDq7uMEr128EaFHZDCq8YF5jaRJlXA?=
 =?iso-8859-1?Q?rtUEEfjIZAVSABdrE9ne+3cC7eMHLjeRocum/AcudmndvOM9HjBmDXj515?=
 =?iso-8859-1?Q?LkNmCV9wdUy6sO0/Pcz97s8v8IKpMoOAr69IZLE3YOCBcIwC/xt7lXTk84?=
 =?iso-8859-1?Q?IX9Z0Uq9f+mcLlzomd56t9HIwoqGY3rkWEoK5dgNnuaZBy1Mdk7BedvZ/g?=
 =?iso-8859-1?Q?eRaS3zs8fHvfwodmTUs=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?ubKLDmGVwjOOmZsMHFLxuYJOps3Dupxv/LmXVOdTYIRQj6IuAlYJo7c6dc?=
 =?iso-8859-1?Q?xTxKDfFZsanS5CStpuvZOXiIvmh4sw85E9XA0JnsulF2GPFuXMTW7ABCBx?=
 =?iso-8859-1?Q?n6hGtWXn6CGRCeP1LstQ6GNT3MK7yoikH7yKFoSQUe6bnrUwvKjJUFyytf?=
 =?iso-8859-1?Q?hm3pm+BKKunwtZeopp9hxkMzb9h9KEOc4asryBoqhG4HjM1sRCpt9g6A+q?=
 =?iso-8859-1?Q?11eFhNJxviZQf86H8smqlP9gyaneEHcqT6XkNcKRlCSvQuILeMWhark4kd?=
 =?iso-8859-1?Q?NrXNeRUbqWlnLgTLUq6bF9BYjIcb3/Luw86gba0JgoVGNvpYvcA98HozAn?=
 =?iso-8859-1?Q?9ldzVFTYj/jfuc6lave4akzVRC6VQBnmMNfUA1orZIBGEOcRagEApGTW2D?=
 =?iso-8859-1?Q?SYLsoQcLygrPomkbJWLtYq0+I9WJbSqX4+HKL6mNGLrXQwfiiqERC7fx1d?=
 =?iso-8859-1?Q?UL3I927koiYpefPvmIR7Mg7+dindry42RXGyOHw2Rf2fXfQK6sZhjI6s4l?=
 =?iso-8859-1?Q?AwGa8P9JaPI2buBflLK2tVoUIqjGGVRvzFWiO19AoUMovd7Yng/ogU/0YS?=
 =?iso-8859-1?Q?RglEUxZIQsCoEp50G6LlnSfznIsZR462K55V0Pl8exS1vN1gnQyPjC8JfO?=
 =?iso-8859-1?Q?D5U/SbAb6JUMwbvlTAh8C46lTWvjUTD2qfTCwWYnhaSFBSVp/FlP1UBb4Y?=
 =?iso-8859-1?Q?cGPz9AJr7YfwywZsZawUHgElAWxtZ8bCVKkjoq0gkDxNHL3qmYjpVmz9fA?=
 =?iso-8859-1?Q?H2JKn6oDa/pkPZ3EhmGuxO34wY8nTS+Fufh4gx9k1S9oRKaFeUqlNvqITi?=
 =?iso-8859-1?Q?XI2PZQIZFUIt0cFXKFquzhaTlEHEHkMudUj6HbkDKvc3+HsUMtDi9rKdMG?=
 =?iso-8859-1?Q?quTF58NGRZd+kWKw3KWsOVa5qBkdFYY2ZWxXl60wruhzoCaZP5NqLCgZdL?=
 =?iso-8859-1?Q?01VVd6mDGJaNhaltHtNEpnADbud+IluX58HAXgWYBpMMNHlM0h8Yh3rjLM?=
 =?iso-8859-1?Q?G22uq72lf1T+bBOMKlu1XDhMsAmrW8dywmh1TzL3omSDHk/6TJn+ivlexZ?=
 =?iso-8859-1?Q?yWZ70m2iNDjFmzzsHeiyhWwQGbO7Pj5GJokwpPA9GkJGrgMlkMePmAhnuE?=
 =?iso-8859-1?Q?U01ckpM29zhbhDDyaIE2HB1aMvZ0MygfmR5zFmyneK1V2v4mkYr5y9efYH?=
 =?iso-8859-1?Q?N6mc7VGHkpw54fVivfFsFEcZU4tJheX8s/owVOTXPbHIUtxZHSmMiAO584?=
 =?iso-8859-1?Q?07W8w0PifsqWP7p1F4q9H870m55eZcwitAR4NpghUm1qHAjABKKs3sWLV/?=
 =?iso-8859-1?Q?WLbrD2aKbznd14pV3irMD2jl6g=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fee9c3-1b1f-4509-4a59-08daf9c3cd8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 02:20:58.8430 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HTfLdZ2esIRncGWFlVOlUO+neLEjMlFEpB6x+BFHChwnKdXiupwOlcKxYCIQ6DuDoPGrkOKfyQXgacu2IysOZLozvcvufGx/tO2dp5VnBFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4305
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 19 Jan 2023 07:42:35 +0000
Subject: Re: [dm-devel] [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests:
 status, an expansion plan for the storage stack test framework
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
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Keith Busch <kbusch@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
 Theodore Ts'o <tytso@mit.edu>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jack@suse.com" <jack@suse.com>,
 "linux-fsdevel@vger.kernel.org>> linux-fsdevel"
 <linux-fsdevel@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <21C4C46D6B5FCF49AAC0C94BACC80191@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

CC+: Mike, dm-devel,

Hi Chaitanya, thanks for bringing this up! I definitely want to join and learn
from the discussions. Here I note my comments about them.

On Jan 18, 2023 / 23:52, Chaitanya Kulkarni wrote:
[...]
> For storage track, I would like to propose a session dedicated to
> blktests. It is a great opportunity for the storage developers to gather
> and have a discussion about:-
> 
> 1. Current status of the blktests framework.

In the session, I can talk shortly about recent blktests improvements and
failure cases.

> 2. Any new/missing features that we want to add in the blktests.

A feature I wish is to mark dangerous test cases which cause system crash, in
similar way as fstests does. I think they should be skipped by default not to
confuse new blktests users.

I remember that dmesg logging was discussed at the last LSFMMBPF, but it is not
yet implemented. It may worth revisit.

> 3. Any new kernel features that could be used to make testing easier?
> 4. DM/MD Testcases.

I took a liberty to add Mike and dm-devel to CC. Recently, a patch was posted to
add 'dm' test category [1]. I hope it will help DM/MD developers to add more
tests in the category. I would like to discuss if it is a good start, or if
anything is missing in blktests to support DM/MD testing.

[1] https://lore.kernel.org/linux-block/20221230065424.19998-1-yukuai1@huaweicloud.com/#t

> 
> E.g. Implementing new features in the null_blk.c in order to have device
> independent complete test coverage. (e.g. adding discard command for
> null_blk or any other specific REQ_OP). Discussion about having any new
> tracepoint events in the block layer.
> 
> 4. Any new test cases/categories which are lacking in the blktests
> framework.

One thing in my mind is character device. From recent discussions [2][3], it
looks worth adding some basic test cases for NVME character devices and SG
devices.

[2] https://lore.kernel.org/linux-block/20221221103441.3216600-1-mcgrof@kernel.org/
[3] https://lore.kernel.org/linux-scsi/Y77J%2Fw0gf2nIDMd%2F@x1-carbon/

-- 
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

