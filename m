Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3B6C7EE23
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685957962;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GL09OZfOy6PjzcTh3bl38F65BkuWVb++kWXITKvA/pI=;
	b=PYkbR0mQJmyXuyyt/7t5oe7r7AZwaPj+c7lhlnftwvIlhmQ7hkzhj98D2hePsekvzbQS3f
	TtXdALSPJI3brftxgsLdhtaaRFEaPoSFoN9CqnxVJmNwZkLs+6/4ElL9ABi762lBlDGaW0
	ywe3XmLQdgi5xTzfJOZCQN4VniDyfl0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-OxNqiCNLP-eQvjbn2xK1eA-1; Mon, 05 Jun 2023 05:39:19 -0400
X-MC-Unique: OxNqiCNLP-eQvjbn2xK1eA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71A0B185A78E;
	Mon,  5 Jun 2023 09:39:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC4C1121314;
	Mon,  5 Jun 2023 09:39:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26D4D19465A0;
	Mon,  5 Jun 2023 09:39:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D191C1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 09:39:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A404C140E955; Mon,  5 Jun 2023 09:39:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C780140E954
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 09:39:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80D0485A5A8
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 09:39:15 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-dzpHEFD6PKaKXTKG5lQ9LA-1; Mon,
 05 Jun 2023 05:39:13 -0400
X-MC-Unique: dzpHEFD6PKaKXTKG5lQ9LA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A6D851F8AB;
 Mon,  5 Jun 2023 09:39:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 60BAA139C7;
 Mon,  5 Jun 2023 09:39:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CWC1FUCtfWQrLgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 05 Jun 2023 09:39:12 +0000
Message-ID: <d4bc81d4631a7b487e88314f18f6877541dc5121.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 05 Jun 2023 11:39:11 +0200
In-Reply-To: <8a1a8cb2-565c-6647-0424-548eaca34a78@gmail.com>
References: <20230531135713.13914-1-xose.vazquez@gmail.com>
 <38c4b77c419ca811a839f8eb24e6425d74eef1ab.camel@suse.com>
 <8a1a8cb2-565c-6647-0424-548eaca34a78@gmail.com>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools: adapt HITACHI/OPEN- config
 to work with alua and multibus
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2023-06-03 at 13:12 +0200, Xose Vazquez Perez wrote:
> On 5/31/23 17:49, Martin Wilck wrote:
>=20
> > On Wed, 2023-05-31 at 15:57 +0200, Xose Vazquez Perez wrote:
> > > ALUA is needed by Hitachi Global-Active Device (GAD):
> > > https://knowledge.hitachivantara.com/Documents/Management_Software/SV=
OS/8.1/Global-Active_Device/Overview_of_global-active_device
>=20
> > Thanks, but where exactly did you find this information in the
> > linked
> > document? I don't see ALUA mentioned. Unfortunately Hitachi chose
> > to
> > use non-standard terminology...=20
>=20
> No public info, personal e-mail from Matthias:
>=20
> "We have also a config for ALUA. It is used for hardware copy between
> two
> arrays and the server should only use the local paths:
>=20
> SLES 12 SP2 ALUA:
>=20
> device {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vendor=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 "HITACHI"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 product=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 "OPEN-.*"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 features=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "0"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy group_by_prio
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prio=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 alua
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_selector=A0=A0=A0=A0=A0=A0=A0 "rou=
nd-robin 0"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rr_weight=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 uniform
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no_path_retry=A0=A0=A0=A0=A0=A0=A0 1
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rr_min_io=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 100
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=A0=A0=A0 di=
rectio
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 immediate
> =A0=A0=A0=A0=A0 }
> "
>=20
> =A0> Is ALUA always active / supported in these arrays?
>=20
> Disable by default. And it is only needed with GAD setup:
>=20
> Array settings:
> "ALUA Mode" Enabled
> "Path Mode" ALUA
> "ALUA Permitted" YES
> "ALUA Settable" YES
> "Target Port Asymmetric Access State" Active/Optimized
>=20
> Same case as HUAWEI
> https://github.com/opensvc/multipath-tools/commit/9283fa6663ad908fd0419ed=
cef4795fbbbe9f09d
>=20
> "no_path_retry 10" comes from:=20
> https://knowledge.hitachivantara.com/Documents/Management_Software/SVOS/9=
.8.6/Volume_Management_-_VSP_5000_Series/Host_Attachment/05_Red_Hat_Linux_c=
onfiguration_and_attachment#Device_Mapper_(DM)_Multipath_configuration.0D.0=
A____for_Red_Hat_Linux

Thanks a lot. I'll apply your patch, adding part of this information to
the commit message.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

