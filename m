Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE47C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645554482;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9XtT9pIdodlhqVQz59fHe//qBtFi1aEnPt8E1iwOHkM=;
	b=B7hsSzpwyKiB5PmzrvwM94QMmqZJL8ZWAvMHhy66m5ydD1Xbwiseu9rAEYzVw8RLogfaHY
	x9VLwJd0OnWdj0cwhjPUm8J9COy4nRVe6QGpaMBzhU+WJZ5TZVnbqlfsDPDNkLLQOvho02
	LZzZ7nDziGHAe/JJ00bktwAp2m2QoTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-SH1UU3KeN0iNRHe1K-U69g-1; Tue, 22 Feb 2022 13:27:59 -0500
X-MC-Unique: SH1UU3KeN0iNRHe1K-U69g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798AC189C440;
	Tue, 22 Feb 2022 18:27:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4401077CB9;
	Tue, 22 Feb 2022 18:27:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07D4F4EE45;
	Tue, 22 Feb 2022 18:27:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MIRqg0024846 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 13:27:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D98278000A; Tue, 22 Feb 2022 18:27:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A54780018;
	Tue, 22 Feb 2022 18:27:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21MIRWud007040; 
	Tue, 22 Feb 2022 12:27:32 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21MIRWhW007039;
	Tue, 22 Feb 2022 12:27:32 -0600
Date: Tue, 22 Feb 2022 12:27:32 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ritika Srivastava <ritika.srivastava@oracle.com>
Message-ID: <20220222182732.GV24684@octiron.msp.redhat.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 11, 2022 at 12:41:48PM -0800, Ritika Srivastava wrote:
> Add -P, partition scanning option to kpartx which would set
> LO_FLAGS_PARTSCAN flag during loop device creation.
> This option is same as losetup -P option.

I'm confused here. What's the benefit of doing this? Doesn't this create
partition devices, just like kpartx would?

-Ben

> 
> Signed-off-by: Ritika Srivastava <ritika.srivastava@oracle.com>
> ---
>  kpartx/kpartx.c | 17 +++++++++++++----
>  kpartx/lopart.c |  5 ++++-
>  kpartx/lopart.h |  2 +-
>  3 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 3c49999..a26d0a2 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -87,7 +87,7 @@ initpts(void)
>  	addpts("ps3", read_ps3_pt);
>  }
>  
> -static char short_opts[] = "rladfgvp:t:snu";
> +static char short_opts[] = "rladfPgvp:t:snu";
>  
>  /* Used in gpt.c */
>  int force_gpt=0;
> @@ -98,7 +98,7 @@ static int
>  usage(void) {
>  	printf(VERSION_STRING);
>  	printf("Usage:\n");
> -	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] wholedisk\n");
> +	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] [-P] wholedisk\n");
>  	printf("\t-a add partition devmappings\n");
>  	printf("\t-r devmappings will be readonly\n");
>  	printf("\t-d del partition devmappings\n");
> @@ -110,6 +110,7 @@ usage(void) {
>  	printf("\t-v verbose\n");
>  	printf("\t-n nosync mode. Return before the partitions are created\n");
>  	printf("\t-s sync mode (Default). Don't return until the partitions are created\n");
> +	printf("\t-P create partitioned loop device\n");
>  	return 1;
>  }
>  
> @@ -228,7 +229,7 @@ xmalloc (size_t size) {
>  
>  int
>  main(int argc, char **argv){
> -	int i, j, m, n, op, off, arg, c, d, ro=0;
> +	int i, j, m, n, op, off, arg, c, d, ro=0, partscan = 0;
>  	int fd = -1;
>  	struct slice all;
>  	struct pt *ptp;
> @@ -311,6 +312,9 @@ main(int argc, char **argv){
>  		case 'u':
>  			what = UPDATE;
>  			break;
> +		case 'P':
> +			partscan = 1;
> +			break;
>  		default:
>  			usage();
>  			exit(1);
> @@ -328,6 +332,11 @@ main(int argc, char **argv){
>  		exit(1);
>  	}
>  
> +	if (what != ADD && partscan == 1)       {
> +		printf("-P option is allowed only during loop device setup\n");
> +		exit(1);
> +	}
> +
>  	if (hotplug) {
>  		/* already got [disk]device */
>  	} else if (optind == argc-2) {
> @@ -359,7 +368,7 @@ main(int argc, char **argv){
>  			exit (0);
>  
>  		if (!loopdev) {
> -			if (set_loop(&loopdev, rpath, 0, &ro)) {
> +			if (set_loop(&loopdev, rpath, 0, &ro, partscan)) {
>  				fprintf(stderr, "can't set up loop\n");
>  				exit (1);
>  			}
> diff --git a/kpartx/lopart.c b/kpartx/lopart.c
> index 512a59f..9a1ce48 100644
> --- a/kpartx/lopart.c
> +++ b/kpartx/lopart.c
> @@ -233,7 +233,8 @@ no_loop_fd:
>  	return NULL;
>  }
>  
> -int set_loop(char **device, const char *file, int offset, int *loopro)
> +int set_loop(char **device, const char *file, int offset, int *loopro,
> +	     int partscan)
>  {
>  	struct loop_info loopinfo;
>  	int fd = -1, ret = 1, ffd, mode;
> @@ -264,6 +265,8 @@ int set_loop(char **device, const char *file, int offset, int *loopro)
>  	loopinfo.lo_offset = offset;
>  	loopinfo.lo_encrypt_type = LO_CRYPT_NONE;
>  	loopinfo.lo_encrypt_key_size = 0;
> +	if (partscan == 1)
> +		loopinfo.lo_flags |= LO_FLAGS_PARTSCAN;
>  
>  	if (ioctl(fd, LOOP_SET_FD, (void*)(uintptr_t)(ffd)) < 0) {
>  		perror ("ioctl: LOOP_SET_FD");
> diff --git a/kpartx/lopart.h b/kpartx/lopart.h
> index c73ab23..81534e2 100644
> --- a/kpartx/lopart.h
> +++ b/kpartx/lopart.h
> @@ -1,4 +1,4 @@
>  extern int verbose;
> -extern int set_loop (char **, const char *, int, int *);
> +extern int set_loop (char **, const char *, int, int *, int);
>  extern int del_loop (const char *);
>  extern char * find_loop_by_file (const char *);
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

