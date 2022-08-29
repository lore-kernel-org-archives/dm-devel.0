Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4749ECAAD2
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661792224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DQH3jrHUnfYFs/7j/QNENbpNiWMf0BmhfsGL6Ae4kfE=;
	b=V+1N9dqDTLrcU/3syIvA9a1hm0kF5ihBdM6HfvAg3mgTZETO3bdM67b+86YxBDUkzak9KM
	7ZDQ3fIAZmUn6LY9BAcaWHqHMANpNK5EfGTP2vJvUbF4PPyBRZdzow8zmu7Wtzf52q/E1M
	7kJCpRK1yP4JwF03+90mDFfq0YKYWCM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-Aj4bFgE-MEWw3GGBw6aKEA-1; Mon, 29 Aug 2022 12:57:03 -0400
X-MC-Unique: Aj4bFgE-MEWw3GGBw6aKEA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6E785A58A;
	Mon, 29 Aug 2022 16:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0C80492C3B;
	Mon, 29 Aug 2022 16:57:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBCFF1946A45;
	Mon, 29 Aug 2022 16:57:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DCF6F1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 Aug 2022 16:56:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBCD54010FA0; Mon, 29 Aug 2022 16:56:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABD1B4010D42;
 Mon, 29 Aug 2022 16:56:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27TGuwn0023994;
 Mon, 29 Aug 2022 11:56:58 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27TGuvWv023993;
 Mon, 29 Aug 2022 11:56:57 -0500
Date: Mon, 29 Aug 2022 11:56:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220829165657.GE16874@octiron.msp.redhat.com>
References: <20220822204119.20719-1-mwilck@suse.com>
 <20220822204119.20719-11-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220822204119.20719-11-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 10/11] multipathd: exec multipathc in
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 22, 2022 at 10:41:18PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> A previous patch disabled interactive mode in multipathd, because
> uxclnt() would return immediately without an input command
> 
> With this patch, we reinstate interactive mode for "multipath -k",
> by just exec()ing the multipathc client.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
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
> index 5a40894..63df643 100644
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
> +				condlog(0, "ERROR: failed to execute multipathc");

We should probably print the error code here.

> +				err = 1;
> +			}
> +		} else
> +			err = uxclnt(s, uxsock_timeout + 100);
>  		free_config(conf);
>  		return err;
>  	}
> diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
> index 571a182..323bd78 100644
> --- a/multipathd/multipathc.c
> +++ b/multipathd/multipathc.c
> @@ -241,14 +241,31 @@ static void process(int fd, unsigned int timeout)
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

strtol() can return a negative number, but process() takes an unsigned
int.  We should probably either use strtoul() or check for negative tmo,
and error. 

-Ben

> +		if (*argv[1] == '\0' || *ep != '\0') {
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

