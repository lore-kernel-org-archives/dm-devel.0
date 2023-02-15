Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E64C64ED6
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MsJziyFsDCxVn8dNI2dKJ4U0PCB/V86B2PubdTKVbSc=;
	b=XfZjYhE/4PB1BM5tLieGLopcBnov0nSKMenCLI7E4BHdSRLIJUPlVArUcUryrvWKELfWZ6
	9b20SUDLapJoXqP/CdDd+IhmMs/SvfUoasUKaVzIoj78O5OpRo3s3aICkbudStJjCcnu8W
	bvb9dbu6QMZLC75dKuchR/M/t6Uqa3k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-edumY50sNMeh0tV-Dvu0ZQ-1; Wed, 15 Feb 2023 04:33:45 -0500
X-MC-Unique: edumY50sNMeh0tV-Dvu0ZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C4F11C06920;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71A371121318;
	Wed, 15 Feb 2023 09:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BFDE21946A66;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 711341946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 08:00:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 850C52026D4B; Wed, 15 Feb 2023 08:00:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CB4E2026D68
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 08:00:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AC413C0ED46
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 08:00:59 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10olkn2024.outbound.protection.outlook.com [40.92.40.24]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-e9X35Kq-MCKzCnJwb74BRg-1; Wed, 15 Feb 2023 03:00:57 -0500
X-MC-Unique: e9X35Kq-MCKzCnJwb74BRg-1
Received: from IA1PR20MB5743.namprd20.prod.outlook.com (2603:10b6:208:421::7)
 by PH8PR20MB5511.namprd20.prod.outlook.com (2603:10b6:510:221::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 08:00:56 +0000
Received: from IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083]) by IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083%9]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:00:55 +0000
From: Ganapathi Kamath <hgkamath@hotmail.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: On allowing remounting the partition containing dm-mapped boot
 disk as read-write
Thread-Index: AQHZQRMcmvwWQavdGUObJEKHZgg+qA==
Date: Wed, 15 Feb 2023 08:00:55 +0000
Message-ID: <IA1PR20MB57438FB73EBF5B526DF7D159DAA39@IA1PR20MB5743.namprd20.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-tmn: [fRAXQnK3SqVooS8KGfbFB9nx2+QHaWoB]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR20MB5743:EE_|PH8PR20MB5511:EE_
x-ms-office365-filtering-correlation-id: f462afc5-2b31-4bc7-c3c7-08db0f2ac449
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tgKLKetQ0MZ2Kn4M8lOljhRRl1Wc4Zyh1N/CJb5Co2XDY1/pFAajxQ/E2/C+zqc80s2O54BH6At2+5bHrSYmjktN9h1m+8k/q+FSlhFqWLo5CufxEUxVIRSb1U36l6edJIRMrk7uz91JbFdRcKJzWuvUa/tOD4V1sv8lVQYEQnEXPulkBHt0t+AEGJaG7/tpEwherf7+QGk8hwCiKdgwF0MKGVwpBaBGvK4rXqSbmMUmfoWKNXUSm3Odp3MdCWSIqAibGQkYu87ixr0aZ3dBsPHf1Q1zDslRjYyiwmmu3cEtUEwvxEWnyxAAik6qo6v0yqa+aAwM95/fCaK+ImM2AxmDpHiP2n6nZqAET0R/iDEO400c7RbCzf7qWoXh5ryKqf0uphAOZi94+q8uBQwDVkGU7J+TKcy7UpyfMdrwgbP730AqPmfdK0k3DQRPGZn6YWI3i3J+ma8OXWB9URyORvSs8DeZR4E0OCePjOITiRq7hyo3wtEp7vekBM73zhBatjisC4LKOKHS3ZLDoxq+5WhnH5qS4voARsY4hWa/oRvJf8yXHnqSgO6QrHswZ8RBVs6sEp+pEtm1SJ7f5crLYw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UaMa43bNQJW8yo+T5pzNskjPA/OlJBvmwOCZ30CdKTIocHFJvjnqXeMuVL?=
 =?iso-8859-1?Q?P48pMoQNtwRBQde9I98k/GlssQrMg/RRH5DbUIzGwYdP1GPhibKdXGnuxP?=
 =?iso-8859-1?Q?3vBerBCIcH35dmALa5711ZZa0zfzGyPAago4OhZaESncStgf92clqNDzYa?=
 =?iso-8859-1?Q?EN2d4/gGR3CiCYxP+gN2tMUBvI/3+GNngrZyl+FywXAPVFdUYRXSQdBOCm?=
 =?iso-8859-1?Q?dDcRK1t3ODrMqEIAXHwIxi8RVm+sAU8CjVMOmtEgsgJfLl0xIJTIIDuWx5?=
 =?iso-8859-1?Q?CwF/IE9zw6MywDjrKXZRenWFPb6zCFq7xWGIyhR0J+hdIoFGMKh3PZB4Gg?=
 =?iso-8859-1?Q?bw5jh4cZYwVPJtAkYQ5c8ENPbj1WBo7wZjZskizN8CZjLfuN5QOqCR5MC6?=
 =?iso-8859-1?Q?UUmjixq0GTZVyI8nZQUIJ9M2JuMZZU6nmuJuEc9YelUZ2NZhP9eFtrdRJH?=
 =?iso-8859-1?Q?w6hzSGjkzd8Cu0+vYvGZjC0cHzbi/muSzjmo4tG3Sw2hJcEeyLMocnRW+0?=
 =?iso-8859-1?Q?3YvnjEzV5BXmsvIB+oTVC73Y33mzNObdlLObSgvc2uo8DmhV7nDtCZNeZb?=
 =?iso-8859-1?Q?Q7Lm2USUdiAuvEfqjQ9RcCJvq1ALMzW3dM1o9b1Jb8ZN9xa7FwzWH1odRw?=
 =?iso-8859-1?Q?1K+8MkEA3klr92102BK7Y3tBNpAXhA3UXktPtnX9lbx1iTdilKrYvGFaDr?=
 =?iso-8859-1?Q?jwlzR7xSdr5npPAKygp6iULn3yBnD0kQAhuThT/ulTTISiKjahWGUDsFXA?=
 =?iso-8859-1?Q?jnp9YQ1yzP4ILI99P6t3g1PyaSKBUW4NfeJAopRId/Gceq9+sq8OjtWopV?=
 =?iso-8859-1?Q?TYiuf/imJ2kYhO/nxJ1Qxyvf6SpNlhww4aY7kWaCPjZxzBVzGFJxlXXL27?=
 =?iso-8859-1?Q?6tsdw770Q0D8xrxEH4+VFNNiNwKDAjfNRwNlsWbX+eaKNDJxu70HrMM3l0?=
 =?iso-8859-1?Q?/U7gh0XqRzQeT/mz2RvmyIW/uwaVDBIJr+wrWaiDPmfW/DFiPP7+j34uWd?=
 =?iso-8859-1?Q?1qZMviDHJOm09yPsHq7LcUlysMJGmldvu63/czPvJEHWLKZoegGOBoRfGp?=
 =?iso-8859-1?Q?nN5yL2aZWjp166V2mfLCCoFd/7hTY22aT8nccwUA6frBKcGr6ZbmWOWins?=
 =?iso-8859-1?Q?PQXbUu7RuTQDwMTQPQx8KGekOs9pHdHtDAXO07LDRmLdZ+n9DHuEzVb0CG?=
 =?iso-8859-1?Q?QlP+6NfyZtxYl61YyCw1Rt7E4P7wEA8arILfudijOcZ2aUIKUo2K/VS2nV?=
 =?iso-8859-1?Q?oX9+fwyYDwfN4RG1P6kGB7nSGvxZ+jytg8oDkn0O67ibFMHjHK/bokZnAj?=
 =?iso-8859-1?Q?sXBw?=
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9803a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR20MB5743.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f462afc5-2b31-4bc7-c3c7-08db0f2ac449
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 08:00:55.8800 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR20MB5511
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


I am just an ordinary user of Linux and Ventoy. 
Q)
https://github.com/ventoy/Ventoy/issues/2234
Is what I have suggested here, meaningful?
Is there contra-indications to not do it or an alternative suggestions?
thoughts?

Ventoy a GPL2, grub2 environment to native boot iso-s and vdisks.
Ventoy uses a small kernel patch to achieve a small remountability feature.
It seemed to me, that patching the kernel per distribution is sub-optimal.
I couldn't find a previous relevant discussion on this on dm-devel, but it seems like a requirement would've been well known and this would have already been discussed. What does the actually patch do?

Thx
-Gana

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

