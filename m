Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC19FC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:38:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-ar068ho9OqaJnIv37m0vmg-1; Sun, 24 Apr 2022 17:38:23 -0400
X-MC-Unique: ar068ho9OqaJnIv37m0vmg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F94480159B;
	Sun, 24 Apr 2022 21:38:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4954354ACAD;
	Sun, 24 Apr 2022 21:38:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D29D1947BBE;
	Sun, 24 Apr 2022 21:38:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 604011947BBD
 for <dm-devel@listman.corp.redhat.com>; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2728FC27EB3; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 23521C27E94
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08FEC800882
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: from relay3.hostedemail.com (relay3.hostedemail.com
 [64.99.140.33]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-sFFrRw2NOjavhHgUF5x9jg-1; Sun, 24 Apr 2022 17:38:18 -0400
X-MC-Unique: sFFrRw2NOjavhHgUF5x9jg-1
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
 by unirelay11.hostedemail.com (Postfix) with ESMTP id 9E5FA81956;
 Sun, 24 Apr 2022 21:30:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by
 omf19.hostedemail.com (Postfix) with ESMTPA id B2A9420025; 
 Sun, 24 Apr 2022 21:30:16 +0000 (UTC)
Message-ID: <637e370ff1d462cd97bb0dbd85d2aad7abc31d61.camel@perches.com>
From: Joe Perches <joe@perches.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>
Date: Sun, 24 Apr 2022 14:30:15 -0700
In-Reply-To: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Evolution 3.40.4-1ubuntu2
MIME-Version: 1.0
X-Stat-Signature: sfgbdzexosni5hcokt6p4sgeue8moiqj
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: B2A9420025
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+nW6m+7YCu4kZxXkdz00uGq0TxpqzRVnQ=
X-HE-Tag: 1650835816-751548
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Mike Snitzer <msnitzer@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 dm-devel@redhat.com, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, 2022-04-24 at 16:54 -0400, Mikulas Patocka wrote:
> This patch changes the function hex_to_bin so that it contains no branche=
s
> and no memory accesses.
[]
> +++ linux-2.6/lib/hexdump.c=092022-04-24 18:51:20.000000000 +0200
[]
> + * the next line is similar to the previous one, but we need to decode b=
oth
> + *=09uppercase and lowercase letters, so we use (ch & 0xdf), which conve=
rts
> + *=09lowercase to uppercase
> =A0 */
> =A0int hex_to_bin(char ch)
> =A0{
> -=09if ((ch >=3D '0') && (ch <=3D '9'))
> -=09=09return ch - '0';
> -=09ch =3D tolower(ch);
> -=09if ((ch >=3D 'a') && (ch <=3D 'f'))
> -=09=09return ch - 'a' + 10;
> -=09return -1;
> +=09return -1 +
> +=09=09((ch - '0' + 1) & (((ch - '9' - 1) & ('0' - 1 - ch)) >> 8)) +
> +=09=09(((ch & 0xdf) - 'A' + 11) & ((((ch & 0xdf) - 'F' - 1) & ('A' - 1 -=
 (ch & 0xdf))) >> 8));

probably easier to read using a temporary for ch & 0xdf

=09int CH =3D ch & 0xdf;

=09return -1 +
=09       ((ch - '0' +  1) & (((ch - '9' - 1) & ('0' - 1 - ch)) >> 8)) +
=09       ((CH - 'A' + 11) & (((CH - 'F' - 1) & ('A' - 1 - CH)) >> 8));


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

