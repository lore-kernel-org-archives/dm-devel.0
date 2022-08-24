Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5C6C00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 08:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661329427;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CUDL8ggxzUnc/A4zvVI2SrEcUjDil9WAAPk6VohMVzc=;
	b=DJheS2T6nj3C3S2IbauF5KZq+rfnQqgj3nugH4wO7IFSwumF6u6xsqy+2MUClUIuJEmzAO
	rE4g1j1OTt9iFaUl7icW/FwJl1bN+hgvSV3UINTuLQH5XlQFZw80hzojErD+qLh83SBY6I
	C4veAsL2WGOjeoMA3oeQmUDuIlORj58=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-IHl2FRkJNNmGuky8qlN-Dg-1; Wed, 24 Aug 2022 04:23:44 -0400
X-MC-Unique: IHl2FRkJNNmGuky8qlN-Dg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BDD618A01BE;
	Wed, 24 Aug 2022 08:23:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 264EF18EA8;
	Wed, 24 Aug 2022 08:23:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14F531946A42;
	Wed, 24 Aug 2022 08:23:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA4F21946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 08:23:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6E7EC15BC5; Wed, 24 Aug 2022 08:23:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A5FC15BC3
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:23:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC254811130
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:23:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-464-AeC0_41sNSK2o0V5_Z4ZGA-1; Wed,
 24 Aug 2022 04:23:35 -0400
X-MC-Unique: AeC0_41sNSK2o0V5_Z4ZGA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 93EA41F8FF;
 Wed, 24 Aug 2022 08:23:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5771D13780;
 Wed, 24 Aug 2022 08:23:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id PCh1EwbgBWOiZAAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 08:23:34 +0000
Message-ID: <29e34267dcf29ec1936a0cec095f483cdec65386.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 24 Aug 2022 10:23:33 +0200
In-Reply-To: <20220823233352.70881-1-xose.vazquez@gmail.com>
References: <20220823233352.70881-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.44.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipath-tools: add more info for NetApp
 RDAC arrays
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-08-24 at 01:33 +0200, Xose Vazquez Perez wrote:
> From:
> https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-49E94674-947F-4=
921-A1D1-CE9B42DCBA39.html
> https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-CA17AE34-F5B2-4=
FF4-8FD4-4A7AA4238976.html
> https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-3DA657A9-FF4A-4=
237-90EC-BA8863B7431E.html
>=20
> To use ALUA mode, "Automatic Load Balancing" should be enabled and
> "Select operating system:" should be changed to "Linux DM-MP (Kernel
> 3.10 or later)".
>=20
> To use RDAC mode, "Automatic Load Balancing" should be disabled and
> "Select operating system:" should be changed to "Linux DM-MP (Kernel
> 3.9 or earlier)".
>=20
>=20
> Add it to prio and hardware_handler, and to alua info.
>=20
>=20
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =A0README.md=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 5 +++--
> =A0multipath/multipath.conf.5 | 8 +++++---
> =A02 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/README.md b/README.md
> index b05b1332..4e34c591 100644
> --- a/README.md
> +++ b/README.md
> @@ -165,8 +165,9 @@ To enable ALUA, the following options should be
> changed:
> =A0=A0=A0 "LUN Affinity" and "ALUA" should be changed to "Enable",
> "Redundancy Type"
> =A0=A0=A0 must be "Active-Active".
> =A0
> -- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series
> and OEM arrays:
> -=A0=A0 "Select operating system:" should be changed to "Linux DM-MP
> (Kernel 3.10 or later)".
> +- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series
> and rebranded arrays:
> +=A0 "Automatic Load Balancing" should be enabled and "Select operating
> system:"
> +=A0 should be changed to "Linux DM-MP (Kernel 3.10 or later)".
> =A0
> =A0- NetApp ONTAP:
> =A0=A0=A0 To check ALUA state: "igroup show -v <igroup_name>", and to
> enable ALUA:
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index acdd1ae6..58080990 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -6,7 +6,7 @@
> =A0.\" Update the date below if you make any significant change.
> =A0.\" ----------------------------------------------------------------
> ------------
> =A0.
> -.TH MULTIPATH.CONF 5 2021-09-08 Linux
> +.TH MULTIPATH.CONF 5 2022-08-14 Linux
> =A0.
> =A0.
> =A0.\" ----------------------------------------------------------------
> ------------
> @@ -320,7 +320,8 @@ Generate the path priority for NetApp ONTAP
> class, and rebranded arrays.
> =A0.I rdac
> =A0(Hardware-dependent)
> =A0Generate the path priority for LSI/Engenio/NetApp RDAC class as
> NetApp SANtricity
> -E/EF Series, and rebranded arrays.
> +E/EF Series and rebranded arrays, with Automatic Load Balancing
> disabled and
> +Select operating system: Linux DM-MP (Kernel 3.9 or earlier).
> =A0.TP
> =A0.I hp_sw
> =A0(Hardware-dependent)
> @@ -1568,7 +1569,8 @@ with Failover Mode 1 (Passive Not Ready(PNR)).
> =A0.I 1 rdac
> =A0(Hardware-dependent)
> =A0Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp
> SANtricity E/EF
> -Series, and rebranded arrays.
> +Series and rebranded arrays, with Automatic Load Balancing disabled
> and
> +Select operating system: Linux DM-MP (Kernel 3.9 or earlier).

Don't we handle RDAC just right with detect_prio and detect_checker set
to 1? I'd like to avoid adding wording here that suggest to the user
that she needs to tune settings, where it's actually not necessary.

Thanks,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

