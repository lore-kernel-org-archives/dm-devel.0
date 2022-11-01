Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 973A8C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 05:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667280593;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xa9SvpFGDBz0F/KBf6X6z85v18MzjY2J3aG9yGVz3b4=;
	b=aRCxXdSlGIW7CiptgHB5r9bzRMEppA+ZTKOhgMbKXqoJwvw9HYknRBK3Xkk+qb/zqJw/p8
	0U4SY1QimjzFpCR62j3nnQKW0IZuB7+qnZk3PagqKOScIFJuqH2gbdEbrncAu/U7wjN8Zw
	VuQsgj9+5zNUCu3RzT1A+MW8rohEH0A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-dZykYcupP-ukVkbQ8jAqqA-1; Tue, 01 Nov 2022 01:29:50 -0400
X-MC-Unique: dZykYcupP-ukVkbQ8jAqqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 110D0101245E;
	Tue,  1 Nov 2022 05:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF97140C2140;
	Tue,  1 Nov 2022 05:29:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B2A8C19465B3;
	Tue,  1 Nov 2022 05:29:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F1E71946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 05:29:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F23E049BB61; Tue,  1 Nov 2022 05:29:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA13949BB60
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:29:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6CBC186E38F
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:29:47 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-s39FoRvdOpSMpOws72rg9w-1; Tue, 01 Nov 2022 01:29:46 -0400
X-MC-Unique: s39FoRvdOpSMpOws72rg9w-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7019.namprd12.prod.outlook.com (2603:10b6:510:1b9::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 05:29:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:29:43 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v3 07/19] nvme: Don't hardcode the data len for pr
 commands
Thread-Index: AQHY6ZHK2YdR6BOC202vDNvo7lAVyq4pkr8A
Date: Tue, 1 Nov 2022 05:29:42 +0000
Message-ID: <fb73946b-acba-3647-69fd-8ed90892710b@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-8-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-8-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7019:EE_
x-ms-office365-filtering-correlation-id: f4898006-7d6a-4086-19c0-08dabbca149f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: NE+jXhEUppWJ0Yw3aKWjjH/vaCedy3vOZ/bu3JakxCPbqyoYfoJ1tx5o+9wmb8GW1LTQlNa0z8WMPe8DDugmK6o6fzDj2E/RNLs3js5WkkAV0eN8GrflwyPo6RpUF7YXm8q1L8LFTSsfH0nJw09Jb5h8LhwNQcJXh2prkygYFzJmkCcLTcPKq4IWTurE0tCX3BeJeBkSnGyYnlmu4UtseqneR0izp4sePuWlOeAXxdztdFYi5pNr64x6LFCBuGLEzgfo4vg0zdf5+11wvvEPD4wKxA4qlMlpqKcCNEhovxZ9PbiUk8jBVRtSfxTH0q8H1gGfaD8haDndlqbCjk/bn3Q+4Cc54zGQk+xV9bNLJWl/AtUYBljiakIL23626O021BuE84dF2wVKnulv3ywSSX6NsyQR8lJeVfUF8EFUHEix2RcQN99Qhf+NM9I7wdp3OWh5LbCZLdXNWt/wEhp/rcq3ybO3F+WcIHgSeUt9TGjYf+KWFK/6yHQMc2uD5BOnZeZyxpzeg9JCURM6EOO8Xq2C5+mWaQXy3sUygvELMuWADRkVTO+D1x/C2pCueseu71v5BrHADY1Qw9mnzwAGDNyg25lf76R8iOqkjPRLnpOaIL4NppmoCHYdgpZbN5s6JotHM9PuKWmnFY6J7rx7IkxS/ivz5iNXDs5A+Uk/frVo+MPF1FuQQfKvfyZUD2c0caXx2lTJz+l5D7lDmn9zxMYXg1wVc7VEfQbOT6PqjcjsAzcFHo88pIAEXHgw9ojaa0TJMyoraFgZKCJHRsHBbySlKrGriZCCK3r5xR9MV9VZFXWbIl1IBkqLp1gK+J0fRVtCVeyEv9tBUSEms4lt+Nc2qdDyLRpf1155w928lo4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199015)(8936002)(31686004)(36756003)(7416002)(122000001)(2906002)(5660300002)(38100700002)(86362001)(31696002)(66946007)(558084003)(921005)(38070700005)(478600001)(186003)(53546011)(71200400001)(6486002)(110136005)(316002)(76116006)(91956017)(66446008)(6512007)(8676002)(2616005)(41300700001)(64756008)(6506007)(66556008)(66476007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG1uYlJCSU13bmkxNDJhUkR5QkMwdmVvSmwzU2p1eGczRlRHTjM0M2J5Y1Ey?=
 =?utf-8?B?YUpMa2tVeVBTbW9PZzNCYjdxQWQ5RVh1NUV3SDBselVBQTBqL0RDaHVTeDhL?=
 =?utf-8?B?dEQxZWdTeDA1bHdqQW5kYUhwanpaMlhkd20wcnRRaCtWQ1hQellZcllYaFo2?=
 =?utf-8?B?Ui96SHc3K2hNanA0eUZvNjRPZDVXSVB4Y1ZhL2grSGhadkJmTDJ3MmFYY0NK?=
 =?utf-8?B?dW1BQXJaSXBUZnVLdGRyMm1Ec0xvZlVhV3Y3elJmNlh4ZFJPU25qS2ZxSUR5?=
 =?utf-8?B?RTgzVjVFSDNyWXcyN25OeUNpcUtKcnVIYmtKOEV0VlBSTWp3elZLdU1BdGtk?=
 =?utf-8?B?eFE5cnNMT29EUkxCUTdKNVE2NkV6OUFVUGU2VXFHUUtxdlN1U1FTalBrM2ts?=
 =?utf-8?B?QWhXR2FpbnBjV2lNdFRpTytTWm1SZ1V2Yk5heUc0b0JuMmNySTdUQmhpK2pT?=
 =?utf-8?B?YVJkUytTSHo3VEx0NUdOOHBBdlRKajBQNkJrOU5wL2kvbW9ZMkJKYkZ6bkNC?=
 =?utf-8?B?NGJwSUxrWnFESmU1MGRTdE9zblN2ZXlMN045OG4zUjBJZjdsM3pIa0ZQdkZ1?=
 =?utf-8?B?OU5SZlJsZjJqTnlFKzAvbkNubzNuNnQ2bkxtazZsNzlLN3M4YWk1Y2k2aXdH?=
 =?utf-8?B?MldUUTBkeTVaRGZ0bk1OVjNTbzBGNWdvNW9xaDh4czdDWkRnWlJmL2NacTZa?=
 =?utf-8?B?TlJranY5bFhQR2hGenRzdGw1ekY5ZG5ha3NhWWVHQmhrZHp0M0JvaEZESDhh?=
 =?utf-8?B?eFpmOElvUkN1clRhbXFSNWw4R0Q3Mitva3pCVzlCdHVlc250SjAvbjA1Zzdy?=
 =?utf-8?B?cXNqY0F1RzdnNDh0OWxWRnh6U2FOOTVGYU90cWF1eGRWTW0wYlpJZGc1MDdw?=
 =?utf-8?B?Z1FoajhGSlEyQXN2S3pqNlN5OXVpdGNSMjZFcUcybytwdHUvWGgrK2w5V2Ri?=
 =?utf-8?B?akhldkhyWUpuR21HSHB2SnFsRExyVE9ROTRxOUR5ODgyWHlkY0R3bUs3WENk?=
 =?utf-8?B?VEp6NHZkbDBpR2dXc3NIb3R4U2hqc1BjdERkVldPR2p1UURZeFdVYTREY1Er?=
 =?utf-8?B?dnNZUHAycytjUE1zNGJXbjViV2xSWkhMOE1BNlZNeGhlT3NJZis0QWxKWHVN?=
 =?utf-8?B?Zko3L25aR3FLT25mOHM0aWNmUFpCYmtic084Q3Bib3dUYnlreVpiRDV5VWx6?=
 =?utf-8?B?MmdBVGs1ZUlqbS80Y3hkNFA4YjNBQ1FFVm5kTDEvU25TS3A4NUdzQ1RiVE9L?=
 =?utf-8?B?ZXQyTlQ0QXNRN3A4QlZCbkJ2bXh4MW05QUNSWUoxVWRVRGJoUjFKYW9ES0x5?=
 =?utf-8?B?SXpMWlNsV1k2dXZTZ3hiZHJHZDFwNUhzeWJFSE1WKzF6N0VZMmFRcmVURE8r?=
 =?utf-8?B?NVd3cnJpMkpaMGdsVEFpTTJsUHZHYks5bjl2a09IeG9VdDRqbmh1U2p0ejBr?=
 =?utf-8?B?N3VlaUFialZuY1dDY2tlN3lKRTVGVDBqUHNXNncveTJWajhQQnAxNWN1S2tk?=
 =?utf-8?B?VjBqeHdKcUovdkpuU0FtaDJZMEp6b29iZmFjV09XNkNFK3V5Sk53MEJQeFQ3?=
 =?utf-8?B?SGFUUnBqQ0ZTSlg4Z1dOZnZYOStiOW9EQ29zQlVmOFFIaGlRNXZtbExaVko1?=
 =?utf-8?B?TFJOM0JYaVZQYm5seXBGQ0ZWUzJReVZuSWRDa2pHN0NMQXN5bTlBMW1wSmhW?=
 =?utf-8?B?REVFNkJ5aXlaNHBZcXNDNWNBRzBwVFE1MVBwbHFlVDhhdzUzdjVBYXpPVStK?=
 =?utf-8?B?Z2ZsdFZyU01Idm1jOGtTc2NRYUx3RzNYZmE5MHNOWnJ6VnltdHltajlYQ2VP?=
 =?utf-8?B?YjFNaDB4MjUrOXpzQjdQTXVZODdWMWZuNVFIQVkyN0h6NGVwZGhFKzJkSWZP?=
 =?utf-8?B?RW54ZWxrVU5JL3JBOENsblRDT3dkdkhKQzBXZys1VnRtcnA2RVU3YlgrV0Qz?=
 =?utf-8?B?Mkt3Um0wNXcvdHJESHJMNGFQN1hLOGc4WnI0YlZwQ1dQNzA3a1laYXp2SXEw?=
 =?utf-8?B?TXlCMms1c09sZzQ4U0FKLzYyOEdCMzMzSjQ4NmFDWmlWYmdCMmUwb09IcUg3?=
 =?utf-8?B?bnRtM0V4dEhVU2l2bXZrdkkydzB6QjlyZlpOTVZ0NFVIa0xOL3F6Qyt6eXdo?=
 =?utf-8?B?b1RNRVZpandOSzNLYTFsRW4wRmgyV29iREhVRU9CemdGN1IxT2JSd1VaQlhz?=
 =?utf-8?B?cHc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4898006-7d6a-4086-19c0-08dabbca149f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:29:42.9636 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevQOWen2cZgYHkmLaUungchRXbTfUgfv4DdiBYhHtAFvPQGjcnR1N4/NYt4ly+6d3X5zX60W9xAzJ9zYScr1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7019
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 07/19] nvme: Don't hardcode the data len
 for pr commands
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FCA781A508452740847D057B54921DFB@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/26/22 16:19, Mike Christie wrote:
> Reservation Report support needs to pass in a variable sized buffer, so
> this patch has the pr command helpers take a data length argument.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

