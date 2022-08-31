Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A5FECAAD4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Aug 2022 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661962170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=77+OS7hp+6smbNh+Eefh9AgEI9+zRDKJY7XgkeDmTDI=;
	b=aWLhwNulTA4sfL0wgojpXQEUCGZkxArneq6nxqw+21Wpza6KaXolJz95D28qSbDyzTUnRJ
	PrpCeBmdDW/SQTE3oLx6Td+sISHZzvbAcH0AU0CMbHXalIfVFG3Km3SKNeTxjEw/vo4dWb
	yEMmIV4GafWQvLmKTB9TmL5el5DSJZw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-AE34kJpfONG6j4l-QWNH3g-1; Wed, 31 Aug 2022 12:09:25 -0400
X-MC-Unique: AE34kJpfONG6j4l-QWNH3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28AC3858F0C;
	Wed, 31 Aug 2022 16:09:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1858B492C3B;
	Wed, 31 Aug 2022 16:09:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D21C31946A69;
	Wed, 31 Aug 2022 16:09:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 430671946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 Aug 2022 15:21:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCA8B945D0; Wed, 31 Aug 2022 15:21:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 966734C819;
 Wed, 31 Aug 2022 15:21:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27VFL7rx017908;
 Wed, 31 Aug 2022 10:21:12 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27VFL6LY017903;
 Wed, 31 Aug 2022 10:21:06 -0500
Date: Wed, 31 Aug 2022 10:21:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220831152101.GH31105@octiron.msp.redhat.com>
References: <20220830192713.19778-1-mwilck@suse.com>
 <20220830192713.19778-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220830192713.19778-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 01/12] multipathd: replace libreadline
 with getline()
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 30, 2022 at 09:27:02PM +0200, mwilck@suse.com wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> libreadline changed the license to be incompatible with multipath-tools
> usage, so replace it with a simple getline().
> 
> mwilck: Make this the default option via Makefile.inc; it is used if
> READLINE is unset. Compiling with READLINE=libreadline or READLINE=libedit
> remains possible.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc        |  4 ++--
>  multipathd/cli.c    |  2 ++
>  multipathd/cli.h    |  4 +++-
>  multipathd/uxclnt.c | 49 +++++++++++++++++++++++++++++++++------------
>  4 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index ad7afd0..4b32fa7 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -9,10 +9,10 @@
>  # Uncomment to disable dmevents polling support
>  # ENABLE_DMEVENTS_POLL = 0
>  #
> -# Readline library to use, libedit or libreadline
> +# Readline library to use, libedit, libreadline, or empty
>  # Caution: Using libreadline may make the multipathd binary undistributable,
>  # see https://github.com/opensvc/multipath-tools/issues/36
> -READLINE = libedit
> +READLINE :=
>  
>  # List of scsi device handler modules to load on boot, e.g.
>  # SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index fa482a6..cc56950 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -459,6 +459,7 @@ void cli_exit(void)
>  	keys = NULL;
>  }
>  
> +#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
>  static int
>  key_match_fingerprint (struct key * kw, uint64_t fp)
>  {
> @@ -564,3 +565,4 @@ key_generator (const char * str, int state)
>  	 */
>  	return ((char *)NULL);
>  }
> +#endif
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index a6082ac..2a0c102 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -151,6 +151,8 @@ void free_keys (vector vec);
>  void free_handlers (void);
>  int cli_init (void);
>  void cli_exit(void);
> -char * key_generator (const char * str, int state);
> +#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
> +char *key_generator (const char * str, int state);
> +#endif
>  
>  #endif /* _CLI_H_ */
> diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
> index 251e7d7..deff565 100644
> --- a/multipathd/uxclnt.c
> +++ b/multipathd/uxclnt.c
> @@ -30,6 +30,7 @@
>  #include "defaults.h"
>  
>  #include "vector.h"
> +#include "util.h"
>  #include "cli.h"
>  #include "uxclnt.h"
>  
> @@ -77,35 +78,57 @@ static int need_quit(char *str, size_t len)
>   */
>  static void process(int fd, unsigned int timeout)
>  {
> -	char *line;
> -	char *reply;
> -	int ret;
>  
> -	cli_init();
> +#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
>  	rl_readline_name = "multipathd";
>  	rl_completion_entry_function = key_generator;
> -	while ((line = readline("multipathd> "))) {
> -		size_t llen = strlen(line);
> +#endif
>  
> -		if (!llen) {
> -			free(line);
> +	cli_init();
> +	for(;;)
> +	{
> +		char *line __attribute__((cleanup(cleanup_charp))) = NULL;
> +		char *reply __attribute__((cleanup(cleanup_charp))) = NULL;
> +		ssize_t llen;
> +		int ret;
> +
> +#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
> +		line = readline("multipathd> ");
> +		if (!line)
> +			break;
> +		llen = strlen(line);
> +		if (!llen)
>  			continue;
> +#else
> +		size_t lsize = 0;
> +
> +		fputs("multipathd> ", stdout);
> +		errno = 0;
> +		llen = getline(&line, &lsize, stdin);
> +		if (llen == -1) {
> +			if (errno != 0)
> +				fprintf(stderr, "Error in getline: %m");
> +			break;
>  		}
> +		if (!llen || !strcmp(line, "\n"))
> +			continue;
> +#endif
>  
>  		if (need_quit(line, llen))
>  			break;
>  
> -		if (send_packet(fd, line) != 0) break;
> +		if (send_packet(fd, line) != 0)
> +			break;
>  		ret = recv_packet(fd, &reply, timeout);
> -		if (ret != 0) break;
> +		if (ret != 0)
> +			break;
>  
>  		print_reply(reply);
>  
> +#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
>  		if (line && *line)
>  			add_history(line);
> -
> -		free(line);
> -		free(reply);
> +#endif
>  	}
>  }
>  
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

