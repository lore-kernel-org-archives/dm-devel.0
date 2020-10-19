Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D982C433DF
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 21:52:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C983322400
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 21:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Es4Gv2qa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C983322400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603144328;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lQF9DFTKn7ajHA/mm1lPIOR92MnfiRBXlEK3mEZSbV0=;
	b=Es4Gv2qayuqw57Xx9yS9V57hg7j3/MBJMhlNxG2/JplMOnG5vTxcXobVYE9EB3wpJTuM7q
	jPH4tLV+vSGMoXlR0OlY68VP14VIMkrpym9IV7Lqu4/Zk2uk99vEWfWzkhfRADNnni06/e
	9w5QmKFHkyUTEZ0LXOS1pMWlBapaRE0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-c5tcBS8GOrSucLzaXf3BSQ-1; Mon, 19 Oct 2020 17:52:04 -0400
X-MC-Unique: c5tcBS8GOrSucLzaXf3BSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1F041891E81;
	Mon, 19 Oct 2020 21:51:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A461B6EF44;
	Mon, 19 Oct 2020 21:51:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C21EF44A74;
	Mon, 19 Oct 2020 21:51:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JLpuVe007140 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 17:51:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 24CED10002A4; Mon, 19 Oct 2020 21:51:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2803C1002388;
	Mon, 19 Oct 2020 21:51:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JLppqu014503; 
	Mon, 19 Oct 2020 16:51:51 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JLppUg014502;
	Mon, 19 Oct 2020 16:51:51 -0500
Date: Mon, 19 Oct 2020 16:51:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019215151.GI3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-28-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-28-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 27/29] multipathd: common code for "-k"
 and command args
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:44:59PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> 'multipathd -k"cmd"' and 'multipath cmd' are the same thing.
> Treat it with common code.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 725a10b..0cf8a26 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3303,6 +3303,8 @@ main (int argc, char *argv[])
>  	int err;
>  	int foreground = 0;
>  	struct config *conf;
> +	char *opt_k_arg = NULL;
> +	bool opt_k = false;
>  
>  	ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf, sizeof(multipath_conf),
>  				   "Manipulated through RCU");
> @@ -3350,16 +3352,9 @@ main (int argc, char *argv[])
>  			logsink = LOGSINK_STDERR_WITHOUT_TIME;
>  			break;
>  		case 'k':
> -			logsink = 0;
> -			conf = load_config(DEFAULT_CONFIGFILE);
> -			if (!conf)
> -				exit(1);
> -			if (verbosity)
> -				libmp_verbosity = verbosity;
> -			uxsock_timeout = conf->uxsock_timeout;
> -			err = uxclnt(optarg, uxsock_timeout + 100);
> -			free_config(conf);
> -			return err;
> +			opt_k = true;
> +			opt_k_arg = optarg;
> +			break;
>  		case 'B':
>  			bindings_read_only = 1;
>  			break;
> @@ -3375,7 +3370,7 @@ main (int argc, char *argv[])
>  			exit(1);
>  		}
>  	}
> -	if (optind < argc) {
> +	if (opt_k || optind < argc) {
>  		char cmd[CMDSIZE];
>  		char * s = cmd;
>  		char * c = s;
> @@ -3390,14 +3385,20 @@ main (int argc, char *argv[])
>  			libmp_verbosity = verbosity;
>  		uxsock_timeout = conf->uxsock_timeout;
>  		memset(cmd, 0x0, CMDSIZE);
> -		while (optind < argc) {
> -			if (strchr(argv[optind], ' '))
> -				c += snprintf(c, s + CMDSIZE - c, "\"%s\" ", argv[optind]);
> -			else
> -				c += snprintf(c, s + CMDSIZE - c, "%s ", argv[optind]);
> -			optind++;
> +		if (opt_k)
> +			s = opt_k_arg;
> +		else {
> +			while (optind < argc) {
> +				if (strchr(argv[optind], ' '))
> +					c += snprintf(c, s + CMDSIZE - c,
> +						      "\"%s\" ", argv[optind]);
> +				else
> +					c += snprintf(c, s + CMDSIZE - c,
> +						      "%s ", argv[optind]);
> +				optind++;
> +			}
> +			c += snprintf(c, s + CMDSIZE - c, "\n");

combining these two methods makes is obvious that adding the newline to
the cmd buffer is unnecessary. But since your patch didn't add it, and
it doesn't hurt anything
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

>  		}
> -		c += snprintf(c, s + CMDSIZE - c, "\n");
>  		err = uxclnt(s, uxsock_timeout + 100);
>  		free_config(conf);
>  		return err;
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

