Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F97C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:29:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 14B4B6124F
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14B4B6124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-1IG1zDeQNqi1knXM54zC2Q-1; Thu, 04 Nov 2021 17:29:10 -0400
X-MC-Unique: 1IG1zDeQNqi1knXM54zC2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6775AEC1A3;
	Thu,  4 Nov 2021 21:29:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 495976784A;
	Thu,  4 Nov 2021 21:29:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDE3D4EA2F;
	Thu,  4 Nov 2021 21:29:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4LSHCQ026871 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 17:28:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E487140C1252; Thu,  4 Nov 2021 21:28:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF9C4400F3C6
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:28:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C644F18812C5
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:28:16 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-215-j-iBoLGqOyWRct_89cEGGg-1;
	Thu, 04 Nov 2021 17:28:15 -0400
X-MC-Unique: j-iBoLGqOyWRct_89cEGGg-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2052.outbound.protection.outlook.com [104.47.0.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-28-VPvy0sV9Mc2iuM4S-u_yVg-1; Thu, 04 Nov 2021 22:28:13 +0100
X-MC-Unique: VPvy0sV9Mc2iuM4S-u_yVg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 21:28:11 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 21:28:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/7] libmultipath: always set INIT_REMOVED in
	set_path_removed
Thread-Index: AQHXxebcgJ0UQGe06kq13dwqoMXQyqvz+e6A
Date: Thu, 4 Nov 2021 21:28:11 +0000
Message-ID: <83f320d0d4135bf7cf691f4227b65c81c003ad82.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4cad13a-e37b-41c2-0a6d-08d99fda00d1
x-ms-traffictypediagnostic: DB8PR04MB7114:
x-microsoft-antispam-prvs: <DB8PR04MB7114132EFD3C971D39E301AFFC8D9@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OgsHXgO7lSHJ550L0FRlkurUsinclRD0cRVZkPFzibZHuPDzFT/z8XpbdVRtEFg8DhY5NgyCM172wKier5u4c3n5nLb5g60D1Er4t8TFGsSeFNv0UiLpjoF2OR6H2KUaN6j59xpFD1DArF5W5s+R809qms1mdsJJT8jKsOSyEfSYqBT8K9A5+tCnGwAXvQyqL6zXYGAirXW3907Ok26tkpcg7G+gz/Jwt0ELvm58aFMqxfLUcDFtgc9s23JebXUdShsABILGyFISS/aPKp1E5anzhg12Ag65rQGUjzfgcUzdLEqM/aozXrCfKkyWZshcGZHZq0YLJl0fCKeIrCgiMiEmE/I+COO04qHiphutQi1/lMIkQNEqlJfsWB5QTq3gzb5br+9tvzpl2nKT9o9jgYRhraOiMDbrin49IveThssADzmvu//Y7dphKEZMoF+F85nh7FGXlpXIp+2Fyjvev7CXA0OVgw6jciRXGffawudXM7jC6YCPVo3PejOS5eWLt9Hdp7BVrjsNxN07UE5QALOhq6L3Lw8gi6Xz34OEqxxfDJVaQQ85+PEwsboRgV+Xo/PGpGUb+q7wYgGFq0QHFBNUoO2CgQYUsmuMuSQYBF6gsB2hvx3AYQmo49XVFyomfzOQUgMxMDkbysRHRxcqdODI/SmqmOUrq58vnemJt/K2STK76lTiMSTsoxY0CwwvoryEzJL0n0xAxuHn5uuDzQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(91956017)(64756008)(66556008)(4326008)(66946007)(66446008)(26005)(122000001)(44832011)(6486002)(4001150100001)(558084003)(38100700002)(186003)(2616005)(66476007)(76116006)(6512007)(86362001)(36756003)(38070700005)(6506007)(8676002)(5660300002)(8936002)(508600001)(2906002)(316002)(71200400001)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?SRd7S1uqaGdaVAzQKGZUnpKLHEE3fI8wfOVm8kPIKNrtyetUpdUPq8d6V?=
	=?iso-8859-15?Q?aPadCtOkV96OU3/e+hCKbW8aDvCROO6HbbpNnQ7OF6Dt2CqnmFniLoC3v?=
	=?iso-8859-15?Q?L3itP5Q6JVJUmXlUHPgvNjGYwdCtR/AnHkl/wit1JG7kLWskKoSGmZtKE?=
	=?iso-8859-15?Q?NPUhOVB69FUaLYHyfWhMS1GY0pHsR67hd3JFRzweDooq6zgRmtWyRS4fN?=
	=?iso-8859-15?Q?yiEkHNjkxcp2JdTErspAeFGSksM4tsYvmNl8LTxNK14tAw6wrW0VJao9w?=
	=?iso-8859-15?Q?gARXUQQ+Vh1gJI3WAK/Vsz9qS4I6sAI7/24cPnMmKCFERMjkjnM94suud?=
	=?iso-8859-15?Q?Z5YijI4bqXMzeSvAIBE5FXFeruGBlVs04AQahXVpABPgBtvpxznhsfL01?=
	=?iso-8859-15?Q?z+HOnzaPqPbvcG+gOJfXl6jnMUWecLVUHx+pOUPX+JxnNGX3KL2tFwC79?=
	=?iso-8859-15?Q?yD0sVmJcbADSe4W6K48rBYXj0zirxImGhJNrs4VEWfFWD259SIDVfbC8k?=
	=?iso-8859-15?Q?HPqbRVDpBUkjWGWaqo0qo5iD4XXsTswmRgAhi6ump+NJEGKXmu5gIuew+?=
	=?iso-8859-15?Q?3255OPKlovMPUhxnD3TcR/gJvIs8BVAk6qhpmYP0EpqMZpJLnYSrAjptW?=
	=?iso-8859-15?Q?SU/MmGVUvuRno99Pik3idNCuNOCVbh9db4/n6PKne5ZpbsS4es8VFsVNW?=
	=?iso-8859-15?Q?sQ9zZC2e8m/32DYQZKlG8zT25msGvZQwD6yMLrkyMSUHqEoivzop0a+Dl?=
	=?iso-8859-15?Q?HLrLCR9lvtci9EZQx9VmRC0RfMScgcVkcEyRie+PTkTvr8kZBjd3s3B31?=
	=?iso-8859-15?Q?Uh5K9tsniKPF71CtdRYT6sZxAV54FpOugZLaGHhSYQA9Qet4Vqb5+4Xd4?=
	=?iso-8859-15?Q?zx/IQfEMb5445c3E7gxnZ5TUCCz2BOxCKLBL74GDGxgV+US5I0r5gmIk4?=
	=?iso-8859-15?Q?L6L7rrrRtuJDvS+PKF4vGWKULo6g8Xxf5TTXuBmvKam9AFJJJfIssvmgA?=
	=?iso-8859-15?Q?cy3/ilZHnOfFZ8uKl1bSANthcproSMVdnHOdU0P60hqoA52UkTeRviB4i?=
	=?iso-8859-15?Q?t53bZYvfxD0KGKeaHHzmlR82NjyrPaH7Zf9BPLX8FLhyXK/TWF2tgn3mF?=
	=?iso-8859-15?Q?5ngLk0lqhCoLh5N4mi7AKWc6pJXKC+br/oadsw1g2UClNFMy0AhANVVr1?=
	=?iso-8859-15?Q?qRcm+OfKv//wKQhSDzEi38/PmsAe+ybXQmpn8n1pwTzFb9yFSa7pfZ89H?=
	=?iso-8859-15?Q?eRhCEzQ6KYXvk4924uKrHtfiPvJnxjB4Bsze21eZeiLSyLUrBRKHmOrqK?=
	=?iso-8859-15?Q?itLbC906pYbpKX89XqNp4miW+xtGmv4MaczoES7dP8jHsGWbZgv9EcFJZ?=
	=?iso-8859-15?Q?d4SD5cIneVo1nfuYzwSJVWgZdD2IohndndamEW4ivhDsr4Ad5VVuztW4e?=
	=?iso-8859-15?Q?3OW++BmTcI1KuYnmgdkvlNp5S/NakC84Wy06U+V5D1+BZ40i+4dqAD+uc?=
	=?iso-8859-15?Q?DmhPXussQg/2Zyk1MfrtqJrDcKa/Dq7d9kJZIUpfsk1wgVv1mzGZO5qtx?=
	=?iso-8859-15?Q?XI8VP7rt9eSbRtglEcGjfhrswU/0V9IFv+OZRQrFrqfRjSXbwhV+VLg++?=
	=?iso-8859-15?Q?bsvX6eZAyomXrukytDvErXedTnqOM54vI0IVutsdZaRUllTvCqWwqLEPl?=
	=?iso-8859-15?Q?P+WJA6Liho8NdF2EmqkvsSX0nmjC7CvS5GdjASNJqadGnkE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cad13a-e37b-41c2-0a6d-08d99fda00d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 21:28:11.4292 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RE2kC/zW7xSVo5JkB32gML7D7ctgwQLUC9gjO3JYV65nqIQMvk0M1wSGYpBLDR8I1lP6/bRTKXenQj7iFcx5NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4LSHCQ026871
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/7] libmultipath: always set INIT_REMOVED in
 set_path_removed
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
Content-ID: <CE7D92DFCFE5A444A3A7555E3905C223@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> Avoiding this corner case simplifies a future patch
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

