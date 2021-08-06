Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A09C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DDD36105A
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2DDD36105A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-U1K27cROPIeDt3ocvo8XfA-1; Mon, 09 Aug 2021 02:53:45 -0400
X-MC-Unique: U1K27cROPIeDt3ocvo8XfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 944D91009623;
	Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E0AC81F77;
	Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 56F1F4A707;
	Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 176BCtWs018141 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Aug 2021 07:12:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9439021D4F30; Fri,  6 Aug 2021 11:12:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FB2021D0DDF
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 11:12:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD6E48CA942
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 11:12:52 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-211-Xi5Z96o4Owa8ylngmLhYCQ-1; Fri, 06 Aug 2021 07:12:51 -0400
X-MC-Unique: Xi5Z96o4Owa8ylngmLhYCQ-1
Received: from gallifrey.ext.pengutronix.de
	([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1mBxU5-0002nV-4I; Fri, 06 Aug 2021 12:53:49 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>
References: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
Message-ID: <7bc58825-c6d8-5e6d-4e1c-c4375e19c10e@pengutronix.de>
Date: Fri, 6 Aug 2021 12:53:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
	SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, kernel@pengutronix.de,
	linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH v1 0/4] keys: introduce
	key_extract_material helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello everyone,

On 22.07.21 11:17, Ahmad Fatoum wrote:
> While keys of differing type have a common struct key definition, there is
> no common scheme to the payload and key material extraction differs.
> 
> For kernel functionality that supports different key types,
> this means duplicated code for key material extraction and because key type
> is discriminated by a pointer to a global, users need to replicate
> reachability checks as well, so builtin code doesn't depend on a key
> type symbol offered by a module.
> 
> Make this easier by adding a common helper with initial support for
> user, logon, encrypted and trusted keys.
> 
> This series contains two example of its use: dm-crypt uses it to reduce
> boilerplate and ubifs authentication uses it to gain support for trusted
> and encrypted keys alongside the already supported logon keys.
> 
> Looking forward to your feedback,

@Mike, Aliasdair: Do you think of key_extract_material as an improvement?

Does someone share the opinion that the helper is useful or should I drop
it and just send out the ubifs auth patch seperately?

Cheers,
Ahmad

> Ahmad
> 
> ---
> To: David Howells <dhowells@redhat.com>
> To: Jarkko Sakkinen <jarkko@kernel.org>
> To: James Morris <jmorris@namei.org>
> To: "Serge E. Hallyn" <serge@hallyn.com>
> To: Alasdair Kergon <agk@redhat.com>
> To: Mike Snitzer <snitzer@redhat.com>
> To: dm-devel@redhat.com
> To: Song Liu <song@kernel.org>
> To: Richard Weinberger <richard@nod.at>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Cc: keyrings@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-security-module@vger.kernel.org
> 
> Ahmad Fatoum (4):
>   keys: introduce key_extract_material helper
>   dm: crypt: use new key_extract_material helper
>   ubifs: auth: remove never hit key type error check
>   ubifs: auth: consult encrypted and trusted keys if no logon key was found
> 
>  Documentation/filesystems/ubifs.rst |  2 +-
>  drivers/md/dm-crypt.c               | 65 ++++--------------------------
>  fs/ubifs/auth.c                     | 25 +++++-------
>  include/linux/key.h                 | 45 +++++++++++++++++++++-
>  security/keys/key.c                 | 40 ++++++++++++++++++-
>  5 files changed, 107 insertions(+), 70 deletions(-)
> 
> base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

