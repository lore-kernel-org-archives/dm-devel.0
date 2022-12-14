Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE864C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671009610;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7estU0nLqOaKnHJzsooFuMgXMEYK6cEcVPxzu/eCHV8=;
	b=a5Epg8MK5pQ/sapfxgySBgmVPeaXj5GzglLrokWWz2kPu0Cdv2WPgZw5LCPFDihm/taoHC
	d+hrx/zR8JdNS0xQjBxssKYwwWgd4h6ei7d5OmGspu/TPWdSg65L7id1lZN0prOoLBy0XD
	CVBrmTy6WhnwcR8btOl07sYu+KBs6H0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-ibk3N5-jNHelNamBVwOcgQ-1; Wed, 14 Dec 2022 04:20:07 -0500
X-MC-Unique: ibk3N5-jNHelNamBVwOcgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB7438588E8;
	Wed, 14 Dec 2022 09:20:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06F1A14171BE;
	Wed, 14 Dec 2022 09:20:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA37A19465B9;
	Wed, 14 Dec 2022 09:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0AD2E19465B8
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 09:19:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 668162166B2D; Wed, 14 Dec 2022 09:19:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CE7A2166B26
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:19:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B0C63C0252E
 for <dm-devel@redhat.com>; Wed, 14 Dec 2022 09:19:51 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-cWQn78JqNwep0TJl1DPCcQ-1; Wed, 14 Dec 2022 04:19:49 -0500
X-MC-Unique: cWQn78JqNwep0TJl1DPCcQ-1
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com (2603:10a6:102:cf::21)
 by PA4PR04MB9592.eurprd04.prod.outlook.com (2603:10a6:102:271::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Wed, 14 Dec
 2022 09:19:45 +0000
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462]) by PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::9cd7:a417:20a2:4462%4]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 09:19:45 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/3] libmpathutil: simplify set_value
Thread-Index: AQHZD0uyvuXB8tiq9Eyg2gP7ZIJLgq5tG9AA
Date: Wed, 14 Dec 2022 09:19:45 +0000
Message-ID: <2329a2afe95f32ba6520932cdf32c510980b6a88.camel@suse.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
 <1670974567-8005-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1670974567-8005-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB8047:EE_|PA4PR04MB9592:EE_
x-ms-office365-filtering-correlation-id: 39f5e6a2-ec13-4838-ee81-08daddb45754
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bwIMmda7IcMBi3XZ5frArwdtHvbNchfUn7ANL4Ap8Oy3p85sj04SV18jNGt1CNL1QSwZwKiNAfNK7wtErQ9zoFAqGCOCcwqZjp/SjExvuPe5VSYFoJA7Rc8n2pT3NKckjCmhMeqOQT/9VdnRYOQCbMuWw3+Ek55GA2p/z+LawBm9kaiBVgbW1FOKUCOkgeksICVDdSQFAWxjuwj5lzThESxuvzaO4qSSGClrtsfWJoWyk5Puo0YDRjBXK9hysnSwc6JI/h4JpJQu7YKxHS+j7hAMK/NXti31dxN7wIDIufWAV4+Y/WOgzAsw4NkuI+3g3ZrfBSv+9dlCmXjfgW67K3rHfd1nXvGj12Ua9mbvWtu/VGuMs7FhhxVsWYRe7ULF4eZIv2cEghntB0neu4EgYZZi+Ok6+QWIwjSR5oeZcU4eMSAs08DuJCJUQw2bBvSzcz3ID3USqBCnWEio3wkHHkApd3Y5X02Taz+jdzO7t+bJoEnEdkRy/MqGKE78XuZltBuegbE2Gmq2jiV7UDOBQb5oyeiWF5w1eP8PFiY/fBz93C8O29CHACVcRvznF6Dtnsu7UYFs/DYGdfym37ZOZPXF/8xVoRkcZLNMe6MebBBcObFmVqKLqPPT+ICPWqCDbU4zdruRt4Ejnsa1oM8u8F9X0Y5kigHduF/9aASD6lqv6icN5aGvLU9kz9eCFEQ2RDIp/lu8N+Oky4mGXMaVCw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB8047.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199015)(4326008)(44832011)(76116006)(8676002)(8936002)(66446008)(5660300002)(66946007)(64756008)(91956017)(66476007)(66556008)(4001150100001)(110136005)(316002)(41300700001)(2906002)(478600001)(6486002)(71200400001)(6506007)(26005)(36756003)(6512007)(186003)(86362001)(2616005)(38070700005)(83380400001)(38100700002)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?nra0l9WSC77DEqfZmbW6fOcT+tvcwC2Ed8bLNz7tG5YoxkSbP26mA4t1w?=
 =?iso-8859-15?Q?TtmaeMMVOE/pZWzHZfsmAZZH/FrkU5hq+/ANsmfau4yOr9dbZv11Wfw7I?=
 =?iso-8859-15?Q?oRd+fLqJnFslSYD+gi1pxCvGPA91Ioe/NGErd85/T8YOgqRPfD4KU0spl?=
 =?iso-8859-15?Q?GFG75bZ1DV8MX+AwQaiGN9aV4eD5uVvn9ReFfX1Y/20Y+3VJoRyTpz6yf?=
 =?iso-8859-15?Q?qHjkUjV+ha860MTXm0foEED8YmVncTEd4rUJQwBRFqTBFIRAXNMLnPjWN?=
 =?iso-8859-15?Q?jAsZQxHtFstXnoHxMOmI8PNpM+LOpRPDj2fmdoRHlEyS0GoK9EbOYjzal?=
 =?iso-8859-15?Q?PYNFjR74iKqN8y8p58JyrBvbDDcgmeuIc/v+saZdoqtoGIOPvzt7nYY5O?=
 =?iso-8859-15?Q?X8tdXvNvd/8DSE3xSEy/6jbKIlJswKbVk54hlvlHM0GAbCpYwVKqMcqRF?=
 =?iso-8859-15?Q?j/Z+VtXjOiJqMzjuRjrwaJgx4AzSoi/54qNOkFbiNoIiyQIWqDtuYoW/2?=
 =?iso-8859-15?Q?UM2RjIe+Gg1uvIACAfZW9+RIvwsgT5HuPNbvhaqdNtinyoky25PJZiwPa?=
 =?iso-8859-15?Q?eiSxxdoYM4ehKA6m8pOwRx0/H/FXQXYWPqQBX+slKz/Iual8GNsSzpCGv?=
 =?iso-8859-15?Q?Yf0ijPpZOX9Hl1VoakqIBjMB8txD8igj6Aj4PCc7IUJpONRRMoIRUfrBE?=
 =?iso-8859-15?Q?HTpZ+rpDiAi/jvAGidg8OjZXMXqLzTraom+zqZCe0zcZaXX/i0/c622Ny?=
 =?iso-8859-15?Q?lTboqeA8Ok5Jrttpk6JGh4etIRqwxe/QaO4198qfAbfEM+I84G4gc7zK1?=
 =?iso-8859-15?Q?fQaR+7R532P7h0hb+B8UC3I7IoDW+u66xusN2vbM0mGV4QkomhdPehYei?=
 =?iso-8859-15?Q?5DA+gHRvZek/3fAV/jCp/2C0oUU8YldQpcHF1FVydg8aDaNH/8/RYxpqK?=
 =?iso-8859-15?Q?c7K9lQKGhITy6V8uITMayOKHhKcKPSHwvbB67wgd3x4Mj4x8FQ9Il6kG9?=
 =?iso-8859-15?Q?AcLMPUHkdCL8en8HBNa39lMQzAatra/VvGQCvaI9RxMnrlQrUDGCpMqU/?=
 =?iso-8859-15?Q?UB5b/GpLM8tAHT/UkRUaVLw44ShIx0bN+Ok/2KLCNhivkB2Ty7qultvlm?=
 =?iso-8859-15?Q?6Bm1Q6ZETOqo9UY1xMmssdlv7AKVSg2L7O6Ypj4PHPG+gpseMoaowDNBQ?=
 =?iso-8859-15?Q?zKNRMvg7THufxcCTvYIbIGLPjhCMel8h89HrBTGAkuGLw5hvwf8IEAnl5?=
 =?iso-8859-15?Q?dvh/4dJhYFvx1Q5Zr+bZpC/h76nQVrmTAeAzqRNrMbfSNN5baJKlDtG5w?=
 =?iso-8859-15?Q?C7eO4TjYvnP+loXkpv+ZAjGup8yxhxNSHw+KYm+zEx0xzJkdmRGWZpTTG?=
 =?iso-8859-15?Q?dW91MuaO1YvWNadmjflMr7LMoBuLdzUgTmuCjPjZOwYWAPiTnRrOc8yRR?=
 =?iso-8859-15?Q?mO4A1uWo0BXiaOx/Gkg7RQjW87WzLLXOjWRWyIhPMjbvz7kgG7IS3N8Ng?=
 =?iso-8859-15?Q?UfMCFIRi2HnrlkHpR9IOPDP6JZEiej6SwQcNzRq4Gh4CgpUFAFH5EkZ/y?=
 =?iso-8859-15?Q?5TAgl1G4VRckZrkIDPSs7ZZggWY8/6l/o6vqVGWbjs0bjoCWaz4JGTD3e?=
 =?iso-8859-15?Q?sJM9nlPXI+jtbBUrkAgO5To19sUP3hpCN8Ed8yqAK99oCU/6WXsH+zg5R?=
 =?iso-8859-15?Q?5X7M92WspZhwZOj35n0ODmvk3w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB8047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f5e6a2-ec13-4838-ee81-08daddb45754
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 09:19:45.5225 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kudbw3a+bzqDiU275lQ/A2s99jmbo5/WQoMB3XoV9McwWfQ2Q/iN+EpmMSpClCXToWy5LFroSWGt3LhlX2hCDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9592
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 1/3] libmpathutil: simplify set_value
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1B27FB2C2C399A419FB9B2673C1B20AC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-12-13 at 17:36 -0600, Benjamin Marzinski wrote:
> alloc_strvec() will never create a strvec with multiple tokens
> between
> the quote tokens.=A0 Verify this in validate_config_strvec(), and
> simplify
> set_value() by only reading one value after a quote token.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

One suggestion below


> @@ -496,6 +470,10 @@ validate_config_strvec(vector strvec, const char
> *file)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (VECTOR_SIZE(strvec) > i + 1)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ignoring extra data
> starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, (i
> + 1)), line_nr, file);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (i > 3) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
There should only ever be one token
> between quotes */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "parsing error starting with '%s'
> on line %d of %s", str, line_nr, file);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn -1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "missing closing quotes on line %d of =
%s",

This could be further simplified. We know that strvec[1] is a quote. So
the only valid possibilities are

 - strvec[2] is a quote (-> empty string)
 - strvec[2] is not a quote and strvec[3] is a quote

The code would be better understandable if we just spell out these
possibilities rather than using a loop that start at 2 and is left at 3
already.

Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

