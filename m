Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D6F11CB9
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 13:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3O5WSza"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698153862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
	b=R3O5WSzalVcCw6RYYUwJcPuJLRe3SKaNPc/Xv0yCwNjW2PpgJRh1P8KjZA49ABFddFGCfG
	+rUOrMvti3MjNrXyE9NgDCPinRp1hKtIJ3YU5u1au5I9Mri5+wstKuhV1AhjDmuxVfO7ZE
	w2t22qUS/uKm1Q5q1CFQjqmmJlp9lw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-x9AeY59mNqWHnCjWKcO89A-1; Tue, 24 Oct 2023 09:24:21 -0400
X-MC-Unique: x9AeY59mNqWHnCjWKcO89A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7164881C81
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 13:24:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCD8E2026D4C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 13:24:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E89C194658C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 13:24:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0BDA1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 13:24:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D2301121320; Tue, 24 Oct 2023 13:24:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 641131121318
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 13:24:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D9D33822E87
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 13:24:19 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-5gUE6mdKMTim8E8bkfEcWw-1; Tue, 24 Oct 2023 09:24:17 -0400
X-MC-Unique: 5gUE6mdKMTim8E8bkfEcWw-1
X-CSE-ConnectionGUID: Zcf3qwnxTd2s1Wi1FtM54g==
X-CSE-MsgGUID: k9fQxVpdRc280yX9PIcR1w==
X-IronPort-AV: E=Sophos;i="6.03,247,1694707200"; 
   d="scan'208";a="489245"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO
 NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
 by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2023 21:23:12 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7678.namprd04.prod.outlook.com (2603:10b6:a03:319::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 13:23:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5b7e:bd22:eb0a:2aa6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5b7e:bd22:eb0a:2aa6%5]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 13:23:08 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
Thread-Topic: [PATCH] dm: error: Add support for zoned block devices
Thread-Index: AQHaBgKccazHx9ji0E6krLQqQuty3rBY7mgA
Date: Tue, 24 Oct 2023 13:23:08 +0000
Message-ID: <107a08f3-5e64-462e-be82-8530b8ffde32@wdc.com>
References: <20231023224513.344380-1-dlemoal@kernel.org>
In-Reply-To: <20231023224513.344380-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7678:EE_
x-ms-office365-filtering-correlation-id: 699ef4f3-61ca-4106-7740-08dbd4945d1c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WRwWf23bCULVnSRsmLWmtzykInMwkOnbBckby2TW2Lz1MbC103up0DHO1QnIhjSm8ynSjdCnW+wBBm9ISsdp/9OFaxc27517e2JPVTgIfuJZwm23d/5VyjjZoe2j0DQwD0uXK2lTh+6S331reb3aZ04zCplXGFu0YU64SvjH2hQb/0U7fJC8iP6j98Q60bMkqGTHUIw2ybbfLV3B9GoOHC1CXB5B4o6+UK5ZblUOkGVcNMBKuGfx3rBfSGLzBSeq3TeAaGwLeB0+FtRyJCRo3xY9M7axu5Fc4Bjad2hMtEbwsmyhxSdZ1tu4kkrJibuArFumjUc1XoVDPR/qlJMqAAQ53IhhHYYHu0NZPMBf/skx3vDuEhGXz7UaagMOAlMyMtcWtFjZ7PWU4S5tNjDIpX3Y+syXtnh31+EaEuoY/+2fC44eFyVGiUt2A/vu6LDlpcTE2rE3rb+nvXq1KMZ+s1eq+QjOcjouw8dAjexUYw/oQxYs+ja7wWRVixHGLJN5kz5yD8kmb9Sq36VrWqEDAT7QZNFhtM3thcZomhSoaJbwNBbbQ6mwxZbA6/nDNytmePr6NUanr58T6cV8xf0SGS9SeDjXk0yE6LVQzWko33UHdkbdAl07j3zR+zZkL1gpLpsLwzBpPDlincJnOH2evhB6KFBQcMZ+RB01vQUdY1Xd2UM8F7xz+Nq/v/sWAg8J
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(396003)(136003)(39860400002)(366004)(346002)(376002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(31686004)(38070700009)(2906002)(71200400001)(8936002)(36756003)(4326008)(558084003)(8676002)(38100700002)(4270600006)(82960400001)(2616005)(122000001)(26005)(5660300002)(6506007)(31696002)(316002)(91956017)(6486002)(66446008)(478600001)(6512007)(54906003)(86362001)(64756008)(66556008)(110136005)(76116006)(66946007)(41300700001)(66476007)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlZSM0xqMGVCQ0NqVEI5UW9WWldwTXg3T2s3THB1UjF4djkvaCs5WlJqTWtj?=
 =?utf-8?B?UkcrdDFPY014bnBjY05BNjlheHY3MlJhd2lxcmZpNzlpQW9WK2FuWC9kTlhw?=
 =?utf-8?B?MW94WkJNbmtUQ1VUQTlwWnZGenlnL3MyV1c5SVd3VHJ1T0NRbjFjbjdEeTVK?=
 =?utf-8?B?MDdQVDJtM2VVK2docDAyVjRrNHVyK2R5Q1VNZ2RPOFVmL2hJbU15cGF1d05u?=
 =?utf-8?B?cTNzdm5GVlRhay9vM21xTFNlNE03WnBvVzQzbk5SV2t1WkcxMTh1cWpwR0J6?=
 =?utf-8?B?amd0MVJDTzlpQ2VycFNwYytTNmcvOXQvaHNKNmx1VVFqczc5QjJYaExKZngv?=
 =?utf-8?B?ODR4azgzOVlzSTM0cW9uaVJTY2FRSm93TEo0REV4Q1MraUZpZXNQcHZmZ0tP?=
 =?utf-8?B?Q1pHS2JUZ2U2QkgrYWNlS3d5bXppYVU0cnBjYUh2bnBncGdvcmQ2NjNWQkVD?=
 =?utf-8?B?ZS8xRzlYdE5Yb0Y3ZmVieXhzVDhXaHdiMjFESjVqUEVRV0FId3llUmp4UUox?=
 =?utf-8?B?R1RIWWd3bExYekswQVNBbUF6Zzh5THFoMVhmOTJQRVRYZzk0Y1Q4RHR3SWhr?=
 =?utf-8?B?eEY0U3pVT0VocjRPdEhSa0QvZzgxUWVKRXo5VzFzWjRIMjBnSFZ2SzZ2U0Fq?=
 =?utf-8?B?aVdCY0lGczgzTjJpVFdHYlNpanVDWlFqYVh0aG1pOW8yek9TZXUwVzAyVGZP?=
 =?utf-8?B?blpacTc2MTdBL1Y5RjVrNVN6dXNTOXFlZUdBSTFxNEl2VGFHRVJPd3JuUndL?=
 =?utf-8?B?eUNNNVh1cmI5am8yamNlVGFJa3Nsd0hWOWZsNm01WVRKaTZvays3ZVZVeGRz?=
 =?utf-8?B?SHRYd3IxREFWWlUvc0Q5K00vK1VTemIwTUVqd0RoK0FVNEVtbEZrOWVlcUpV?=
 =?utf-8?B?SWloRW9mTWN0YjZIaDEybWQwaC9wS2pETURtNitBOEJxRjN1WjJvdTcvbmIv?=
 =?utf-8?B?bFhtQm40YWVnaktiU2dEazlOVnBFVTc4am5RbkpVRXpkL0JzWDluNUQvMm5J?=
 =?utf-8?B?cU00Sk1nc1VlanR2QjNNV1MreHpsSFpMUU1uK1ZFempxTERZeU1Kd3dkS2VM?=
 =?utf-8?B?UFNpSUQyM2hnZnU4Y0t1OEZxTzlLYzZtVWhMZDFJMGFBdDFSbDBLNUdFd0U4?=
 =?utf-8?B?R0hSYVZKbW1BT01ubS9USHV4N1dUbThWVzluK2FKODRIVGgwNmM5U2VKOWlU?=
 =?utf-8?B?OUtoS3BOblJkb0s3cTdtb1VJaEdUSUljVGUxY3pqaThOc3Z0TGpFbHNrM2lN?=
 =?utf-8?B?WXprSGpCMEFUbVZuRUh5YitsVVFyNkdPWkFWUVlEamc0UEloTXhVeUdaZzdr?=
 =?utf-8?B?d3M3cDJXQzBpSkc5OE80TnFLQmg5WUVnS3Q5d0N0OHYwZ1V3bjNZeWFSYVVU?=
 =?utf-8?B?VjV2ajhUbmcwS1loWjJpbmRpQlpJMjU2aForN0ZwdEJ3bDdxaWxsTzhFVXJJ?=
 =?utf-8?B?M1Axa3g4MDcxSzVNdFNPU3FvQU9Lc1oxcXlYV0tXbm85K0gyOXVzK0IrL0h3?=
 =?utf-8?B?UWw4WkhicnNFRzlXQndsTzlRTjZGMUcvUXVha2xrNXA4MXNMK0JKWWM5ZGFn?=
 =?utf-8?B?cnB0RDVHNXEzVzhWSlFUV3ZKdmNNcEh5VURPT20zQXE0WUllbzB3c0FsT0Ew?=
 =?utf-8?B?bG42TTBVakNOWHVOSCtUdUxjN3V0VFRrOExSTGFpeml3ZXhFVTcrVzlQU0Rn?=
 =?utf-8?B?VzdxWUErTThZVjZSVUppeXBiWUtteWlnV3lkcFRmVmVIekZHdlQyaUhYN2U0?=
 =?utf-8?B?b25nTjd3aUxZNFBCamp4WWtBTTErZEQrQ25rdWllUWY5eEZrNnFRV1Q0UElJ?=
 =?utf-8?B?bWkxbXJGb1MxRjBGeWNEd2pBZDI1ZlowVEl1Qi9sd0NwaGE5TE5QMDlzeFgv?=
 =?utf-8?B?VFZHaFk2SnhldTZwQUVpMDRSbEs4d3ZYRVMwM0swMkUyak9tNnk4b1Fya3Z2?=
 =?utf-8?B?S3NUYmRFd2RoWC9XR3NMaUg0enA5SldyV245bDd3ZjY5ZXNOTFZ4TDZkOC9j?=
 =?utf-8?B?RlNKN0cwYU1DMnpleVFVR0hBYjA4K2Q0Q3RiZ3loa2NpSkFXRjdmVGdsT0R2?=
 =?utf-8?B?Mm1pams2RWRaeFJkSEJPNEI4dmNZREtyY0huekJ3dUVscTBDRFRLc2N6RVox?=
 =?utf-8?B?aFhsQmFkR0lrN05ZSDZrbG5rOTErYXY1UjBHTEtxU01kY1lpTzJEMnA3cGRz?=
 =?utf-8?B?dFE9PQ==?=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fiEJJiDJG1aJy5eHbktlfnNoTJvcTSbGg+8sYUpQcCFHD+tqHtqrGc/OKjx/bTe3ANk94D0CvQE+25m03lXV59VelARqUK9I7KFsArIx7SzNETk3XZg5bd/5AIyM7eDRjV99B4wqcSPYaEwBU9qFOUtVnpfCvYuHJyM067wwmjZBGCc7/Zng9ZvTUU0SqV4i8VtwfEZI/rwlhs0sBwlMrU+CtGq1Qds+leAtBFnflTrHxfGccuQYrjkvsXK41/605rGlgkFnVqwjBL0fL+VG6Q4wntLN4K+zwWKnXRLT04Bq1tOUH5M13BOk21Jfyzd0mv5c3VMjvQEDAfubBsaIX/QpH/rS1SZO/kUrQ5MrvmcVWfrfdCA63jmgiinGi/9GIewoVQTwjGOHmEcuoXmiHnOZjCyhkEBpIRa7s//sBKBHBjZ/cV971+vyBoloG9LTTEeQB68lTJE8c1eKcwV7plZDxaQtfHhfwZ7Nv2UILW4h04T7GS39FDRXxP/7Pn8WYWD7EzGyz2DjBFNHHuj0qL/xj2m2hobzKgugMMdxd+22O9uBmbw7DfzhpdgmWt+8hCDhVl9RWLh2+Qh1k7sjApF/Hwij4wTUQNgpYb4XTF3kqYEjGRDVwY9Fo0jufOo6PQ5E8dT1k7UVqeRyltrAGv0gq4X1eBxV78Mx7bv6xcnGWw5s+om2/dKd39kx+K9mnW1UlRjJh62Py4UVi9ZZOpanmIAbot4nmrGVSfUSk8c9/e0I6pVAI1SW8qrAfdf9lsHruvenWwooerq0vrz59Zgwjr/Kyb9D90Fp++wzEYk5Z4p5VQnX6rGGYldCikXa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699ef4f3-61ca-4106-7740-08dbd4945d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 13:23:08.5195 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yVY4i3z/f8UY4OqMUnGyvMFoTBBuNzgJA96dUBl2kSlpEBan+IQql6xSvIKFkvkz/EI6+bkT07ySbWyxixm2HPxf9oLpa/jZTmEy77Qfq/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7678
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
Cc: Naohiro Aota <Naohiro.Aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <42E2BBA1953CD04FBD18DE9896F83241@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

TG9va3MgZ29vZCB0byBtZSwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFu
bmVzLnRodW1zaGlybkB3ZGMuY29tPg0K

