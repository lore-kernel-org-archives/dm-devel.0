Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802FA5396
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZtNkRKSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119566;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rmddIeGleB+CvcksXIlwUEw0FkwTQo8xqUcvDqbnLkY=;
	b=ZtNkRKSYWU/m5fyjcnwoz9DqRVzeqwAabTuJRKGuXI8Bly8F/DTVqHU9xOYpVFl5TCo2XT
	TKd8EnQ3h3FQLOAzh1W+n7fBXiJMa9MQi6x3MySO1UyIMNBxvsc4ndEhERtetj+K+nrn2q
	i7rrT5f7RWx9RMMtznZNYqnJiaeqI9o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-9MTY7KpNOM6LbpIgRZ2tDg-1; Mon,
 23 Oct 2023 23:52:45 -0400
X-MC-Unique: 9MTY7KpNOM6LbpIgRZ2tDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0053238143A8
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC7988C0B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D36A01946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB3E71946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABF071121320; Tue, 24 Oct 2023 03:52:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A41E11121318
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8350980187C
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:39 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-lsl4RHqiN-ahAGvzZm7W-g-1; Mon, 23 Oct 2023 23:52:37 -0400
X-MC-Unique: lsl4RHqiN-ahAGvzZm7W-g-1
Received: by mail-qk1-f171.google.com with SMTP id
 af79cd13be357-778ac9c898dso193823685a.0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119556; x=1698724356;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rmddIeGleB+CvcksXIlwUEw0FkwTQo8xqUcvDqbnLkY=;
 b=fbxLtq0tjy/5Dl1rxbXYc6GLj8hgGQEPx0rs4Rewc4C0PNMZ+ixVYyDc7MoEB8vfEz
 hJQxxuWtGMQjMLZdY6/oBHIknFsTZbptkg8vveSdqvPgubX6EPkfIlhVlSO76n68J4zG
 XY8ohRuCFMxqKCKHSGHuaTcUkwai4oGrk4M7k89pNbEjqpen7+S2VO96+tdYWNeCkExU
 /1JDkZKJNnXIkD5RBzadeQ9xQTgR+iIuJUz9rsZ8DvgDGpOdl75yUYIiD+tXSGkBbk8r
 4Do1K2yNU1Kk5fuWFRuuUSV7dq7hB6ckfnj6fgMEA2awm98MrUnmdmmvdTbjbuhFi264
 lrCg==
X-Gm-Message-State: AOJu0YxJQLIXq53oufZzUa/8WEXlhYLPvAEXIUHhAT1MvAIxuYl4v0/T
 POxZ+jr0I2NISVH0fxJGWc1o
X-Google-Smtp-Source: AGHT+IFa4kcq1x8534opliGWAomlb7YsXdOWGv2jKnIrbHP0ah0tMcnkxxPdDx5NrEcrjlcEEcKHZw==
X-Received: by 2002:a05:620a:172a:b0:775:9c22:e901 with SMTP id
 az42-20020a05620a172a00b007759c22e901mr12880926qkb.15.1698119556628; 
 Mon, 23 Oct 2023 20:52:36 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 t14-20020a05620a0b0e00b007757fefea79sm3144655qkg.130.2023.10.23.20.52.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:36 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:35 -0400
Message-ID: <0c3ac562e5b8ea82d962478459bc7047.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 17/19] scripts: add boot policy generation program
References: <1696457386-3010-18-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-18-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Enables an IPE policy to be enforced from kernel start, enabling access
> control based on trust from kernel startup. This is accomplished by
> transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
> c-string literal that is parsed at kernel startup as an unsigned policy.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + No Changes
> 
> v4:
>   + No Changes
> 
> v5:
>   + No Changes
> 
> v6:
>   + No Changes
> 
> v7:
>   + Move from 01/11 to 14/16
>   + Don't return errno directly.
>   + Make output of script more user-friendly
>   + Add escaping for tab and '?'
>   + Mark argv pointer const
>   + Invert return code check in the boot policy parsing code path.
> 
> v8:
>   + No significant changes.
> 
> v9:
>   + No changes
> 
> v10:
>   + Update the init part code for rcu changes in the eval loop patch
> 
> v11:
>   + Fix code style issues
> ---
>  MAINTAINERS                   |   1 +
>  scripts/Makefile              |   1 +
>  scripts/ipe/Makefile          |   2 +
>  scripts/ipe/polgen/.gitignore |   1 +
>  scripts/ipe/polgen/Makefile   |   6 ++
>  scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
>  security/ipe/.gitignore       |   1 +
>  security/ipe/Kconfig          |  10 +++
>  security/ipe/Makefile         |  11 +++
>  security/ipe/fs.c             |   8 ++
>  security/ipe/ipe.c            |  12 +++
>  11 files changed, 198 insertions(+)
>  create mode 100644 scripts/ipe/Makefile
>  create mode 100644 scripts/ipe/polgen/.gitignore
>  create mode 100644 scripts/ipe/polgen/Makefile
>  create mode 100644 scripts/ipe/polgen/polgen.c
>  create mode 100644 security/ipe/.gitignore

...

> diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
> new file mode 100644
> index 000000000000..40b6fe07f47b
> --- /dev/null
> +++ b/scripts/ipe/polgen/polgen.c
> @@ -0,0 +1,145 @@

...

> +static int write_boot_policy(const char *pathname, const char *buf, size_t size)
> +{
> +	int rc = 0;
> +	FILE *fd;
> +	size_t i;
> +
> +	fd = fopen(pathname, "w");
> +	if (!fd) {
> +		rc = errno;
> +		goto err;
> +	}
> +
> +	fprintf(fd, "/* This file is automatically generated.");
> +	fprintf(fd, " Do not edit. */\n");
> +	fprintf(fd, "#include <linux/stddef.h>\n");
> +	fprintf(fd, "\nextern const char *const ipe_boot_policy;\n\n");
> +	fprintf(fd, "const char *const ipe_boot_policy =\n");
> +
> +	if (!buf || size == 0) {
> +		fprintf(fd, "\tNULL;\n");
> +		fclose(fd);
> +		return 0;
> +	}
> +
> +	fprintf(fd, "\t\"");
> +
> +	for (i = 0; i < size; ++i) {
> +		switch (buf[i]) {
> +		case '"':
> +			fprintf(fd, "\\\"");
> +			break;
> +		case '\'':
> +			fprintf(fd, "'");
> +			break;

The revision of IPE proposed in this patchset doesn't support parsing
single or double quotes, yes?

> +		case '\n':
> +			fprintf(fd, "\\n\"\n\t\"");
> +			break;
> +		case '\\':
> +			fprintf(fd, "\\\\");
> +			break;
> +		case '\t':
> +			fprintf(fd, "\\t");
> +			break;
> +		case '\?':
> +			fprintf(fd, "\\?");
> +			break;

Similar, are question marks supported by the parser?

> +		default:
> +			fprintf(fd, "%c", buf[i]);
> +		}
> +	}
> +	fprintf(fd, "\";\n");
> +	fclose(fd);
> +
> +	return 0;
> +
> +err:
> +	if (fd)
> +		fclose(fd);
> +	return rc;
> +}

...

> diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
> new file mode 100644
> index 000000000000..eca22ad5ed22
> --- /dev/null
> +++ b/security/ipe/.gitignore
> @@ -0,0 +1 @@
> +boot-policy.c
> \ No newline at end of file

Add a newline please.

--
paul-moore.com

