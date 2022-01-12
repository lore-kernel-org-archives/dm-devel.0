Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1660BC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jan 2022 17:11:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-6X5MgD_rO1S1ZT7zqPGzBw-1; Wed, 12 Jan 2022 12:11:14 -0500
X-MC-Unique: 6X5MgD_rO1S1ZT7zqPGzBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E15639385;
	Wed, 12 Jan 2022 17:11:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93A967FB9E;
	Wed, 12 Jan 2022 17:11:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 431FC4BB7C;
	Wed, 12 Jan 2022 17:11:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CH8dbY031363 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 12:08:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 93AF4492D48; Wed, 12 Jan 2022 17:08:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FEB9492D47
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 17:08:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A75438035D3
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 17:08:39 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-599-rOY_6pqoNWuvMabWYbOC-A-1; Wed, 12 Jan 2022 12:08:35 -0500
X-MC-Unique: rOY_6pqoNWuvMabWYbOC-A-1
Received: from [2601:1c0:6280:3f0::aa0b]
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n7gVi-000pWI-Rq; Wed, 12 Jan 2022 16:30:07 +0000
Message-ID: <a2fa0ba9-8b93-eb00-9b7f-a5280f304c64@infradead.org>
Date: Wed, 12 Jan 2022 08:30:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: Thore Sommer <public@thson.de>, dm-devel@redhat.com, agk@redhat.com,
	snitzer@redhat.com
References: <20220112144230.1978290-1-public@thson.de>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220112144230.1978290-1-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, linux-doc@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2] dm ima: updates to grammar and some
 details in documentation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi--

On 1/12/22 06:42, Thore Sommer wrote:
> The grammar for the events dm_device_remove, device_resume and
> dm_table_clear did not include the no_data entry when device data
> and hash are missing.
> 
> For the device uuid or name "=" is also escaped with a "\".
> 
> Add a note that dm_table_load might split its target measurements over
> multiple IMA events.
> 
> Signed-off-by: Thore Sommer <public@thson.de>
> ---
> v2:
> - include also device name and uuid in grammar for no_data
> - fixed spelling mistakes
> 
>  .../admin-guide/device-mapper/dm-ima.rst      | 32 +++++++++++++++----
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
> index a4aa50a828e0..ef386a71e015 100644
> --- a/Documentation/admin-guide/device-mapper/dm-ima.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-ima.rst

> @@ -118,9 +121,9 @@ The IMA measurement log has the following format for 'dm_table_load':
>   device_minor := "minor=" <N>
>   minor_count := "minor_count=" <N>
>   num_device_targets := "num_targets=" <N>

These 2 changes still need a space before the '=',

> - dm-device-name := Name of the device. If it contains special characters like '\', ',', ';',
> + dm-device-name := Name of the device. If it contains special characters like '\', ',', ';','=',
>                     they are prefixed with '\'.
> - dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';',
> + dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';','=',
>                     they are prefixed with '\'.
>  
>   table_load_data := <target_data>


-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

