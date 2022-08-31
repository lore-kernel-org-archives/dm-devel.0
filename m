Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29382ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 31 Aug 2022 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661972167;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tCzyMg5NnBMbM+iG/jHgC3WvlQzXHngmN4k67jfXNIM=;
	b=Ed/7eO9j11AXi3BvQB3J4cD9vX3RaY+LaQs6wNm/STK4BMChgD2MBSuNsYy+bWEF16Q1wa
	k1NGmFRR3qcy40XIv4Bq+koLDUPqnlb1Lsdry/1IYZIqUhcNJz5qrg6286PqbnfzcjpFye
	5q5msi2TYhwUMcv2d0ZhWIWJ1JeXznw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-nG5c1x_FPlm-QqM2khVXGw-1; Wed, 31 Aug 2022 14:56:03 -0400
X-MC-Unique: nG5c1x_FPlm-QqM2khVXGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C33F1818CBD;
	Wed, 31 Aug 2022 18:56:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD3C3C15BB3;
	Wed, 31 Aug 2022 18:56:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 939041946A45;
	Wed, 31 Aug 2022 18:56:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F08C1946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 Aug 2022 17:39:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F8C52026D64; Wed, 31 Aug 2022 17:39:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 494372026D4C;
 Wed, 31 Aug 2022 17:39:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27VHdkHW021733;
 Wed, 31 Aug 2022 12:39:46 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27VHdjoe021732;
 Wed, 31 Aug 2022 12:39:45 -0500
Date: Wed, 31 Aug 2022 12:39:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220831173945.GJ31105@octiron.msp.redhat.com>
References: <20220830192713.19778-1-mwilck@suse.com>
 <20220830192713.19778-11-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220830192713.19778-11-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v4 10/12] multipathd: exec multipathc in
 interactive mode
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 30, 2022 at 09:27:11PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> A previous patch disabled interactive mode in multipathd, because
> uxclnt() would return immediately without an input command.
> 
> With this patch, we reinstate interactive mode for "multipath -k",
> by just exec()ing the multipathc client.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/Makefile     |  3 ++-
>  multipathd/main.c       | 15 +++++++++++++--
>  multipathd/multipathc.c | 25 +++++++++++++++++++++----
>  3 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 19ab2e9..8a56304 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -17,7 +17,8 @@ endif
>  
>  CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
>  	$(shell $(PKGCONFIG) --modversion liburcu 2>/dev/null | \
> -		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
> +		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }') \
> +	-DBINDIR='"$(bindir)"'
>  CFLAGS += $(BIN_CFLAGS)
>  LDFLAGS += $(BIN_LDFLAGS)
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 5a40894..66177cd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3616,7 +3616,7 @@ main (int argc, char *argv[])
>  	extern char *optarg;
>  	extern int optind;
>  	int arg;
> -	int err;
> +	int err = 0;
>  	int foreground = 0;
>  	struct config *conf;
>  	char *opt_k_arg = NULL;
> @@ -3710,7 +3710,18 @@ main (int argc, char *argv[])
>  			}
>  			c += snprintf(c, s + CMDSIZE - c, "\n");
>  		}
> -		err = uxclnt(s, uxsock_timeout + 100);
> +		if (!s) {
> +			char tmo_buf[16];
> +
> +			snprintf(tmo_buf, sizeof(tmo_buf), "%d",
> +				 uxsock_timeout + 100);
> +			if (execl(BINDIR "/multipathc", "multipathc",
> +				  tmo_buf, NULL) == -1) {
> +				condlog(0, "ERROR: failed to execute multipathc: %m");
> +				err = 1;
> +			}
> +		} else
> +			err = uxclnt(s, uxsock_timeout + 100);
>  		free_config(conf);
>  		return err;
>  	}
> diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
> index a4f9023..9d49655 100644
> --- a/multipathd/multipathc.c
> +++ b/multipathd/multipathc.c
> @@ -246,14 +246,31 @@ static void process(int fd, unsigned int timeout)
>  	}
>  }
>  
> -int main (void)
> +int main (int argc, const char * const argv[])
>  {
> -	int fd = mpath_connect();
> +	int fd;
> +	int tmo = DEFAULT_REPLY_TIMEOUT + 100;
> +	char *ep;
>  
> -	if (fd == -1)
> +	if (argc > 2) {
> +		fprintf(stderr, "Usage: %s [timeout]\n", argv[0]);
>  		return 1;
> +	}
> +	if (argc == 2) {
> +		tmo = strtol(argv[1], &ep, 10);
> +		if (*argv[1] == '\0' || *ep != '\0' || tmo < 0) {
> +			fprintf(stderr, "ERROR: invalid timeout value\n");
> +			return 1;
> +		}
> +	}
>  
> -	process(fd, DEFAULT_REPLY_TIMEOUT + 100);
> +	fd = mpath_connect();
> +	if (fd == -1) {
> +		fprintf(stderr, "ERROR: failed to connect to multipathd\n");
> +		return 1;
> +	}
> +
> +	process(fd, tmo);
>  	mpath_disconnect(fd);
>  	return 0;
>  }
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

