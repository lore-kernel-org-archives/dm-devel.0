Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9ABC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:43:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 465A160F56
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 465A160F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-uaWlJX61NZmRzCxs6X1Yjg-1; Wed, 03 Nov 2021 12:43:36 -0400
X-MC-Unique: uaWlJX61NZmRzCxs6X1Yjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B20F100CD17;
	Wed,  3 Nov 2021 16:43:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A3710016F5;
	Wed,  3 Nov 2021 16:43:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 19AED4EA29;
	Wed,  3 Nov 2021 16:43:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3GhOnh012564 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 12:43:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D78812026D5D; Wed,  3 Nov 2021 16:43:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D33152026D46
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 16:43:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D220818A01A0
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 16:43:21 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-0Q_GdIx5PxmBToZFx6MOCQ-1; Wed, 03 Nov 2021 12:43:17 -0400
X-MC-Unique: 0Q_GdIx5PxmBToZFx6MOCQ-1
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Hkssc70vfz67mL5;
	Thu,  4 Nov 2021 00:38:44 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Wed, 3 Nov 2021 17:43:15 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.015; Wed, 3 Nov 2021 17:43:15 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: "deven.desai@linux.microsoft.com" <deven.desai@linux.microsoft.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"paul@paul-moore.com" <paul@paul-moore.com>, "eparis@redhat.com"
	<eparis@redhat.com>, "jmorris@namei.org" <jmorris@namei.org>,
	"serge@hallyn.com" <serge@hallyn.com>
Thread-Topic: [RFC PATCH v7 14/16] scripts: add boot policy generation program
Thread-Index: AQHXwGWMtob3cI5FPU6KyidED8CNc6vyIPKA
Date: Wed, 3 Nov 2021 16:43:14 +0000
Message-ID: <12aec559d6df4191a39ecaec7a0a378e@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-15-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1634151995-16266-15-git-send-email-deven.desai@linux.microsoft.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A3GhOnh012564
X-loop: dm-devel@redhat.com
Cc: "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jannh@google.com" <jannh@google.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH v7 14/16] scripts: add boot policy
	generation program
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: deven.desai@linux.microsoft.com
> [mailto:deven.desai@linux.microsoft.com]
> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Enables an IPE policy to be enforced from kernel start, enabling access
> control based on trust from kernel startup. This is accomplished by
> transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
> c-string literal that is parsed at kernel startup as an unsigned policy.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> ---
> 
> Relevant changes since v6:
>   * Move patch 01/12 to [14/16] of the series
> 
> ---
>  MAINTAINERS                   |   1 +
>  scripts/Makefile              |   1 +
>  scripts/ipe/Makefile          |   2 +
>  scripts/ipe/polgen/.gitignore |   1 +
>  scripts/ipe/polgen/Makefile   |   6 ++
>  scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
>  security/ipe/.gitignore       |   1 +
>  security/ipe/Kconfig          |  10 +++
>  security/ipe/Makefile         |  13 +++
>  security/ipe/ctx.c            |  18 +++++
>  10 files changed, 198 insertions(+)
>  create mode 100644 scripts/ipe/Makefile
>  create mode 100644 scripts/ipe/polgen/.gitignore
>  create mode 100644 scripts/ipe/polgen/Makefile
>  create mode 100644 scripts/ipe/polgen/polgen.c
>  create mode 100644 security/ipe/.gitignore
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f1e76f791d47..a84ca781199b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9283,6 +9283,7 @@ INTEGRITY POLICY ENFORCEMENT (IPE)
>  M:	Deven Bowers <deven.desai@linux.microsoft.com>
>  M:	Fan Wu <wufan@linux.microsoft.com>
>  S:	Supported
> +F:	scripts/ipe/
>  F:	security/ipe/
> 
>  INTEL 810/815 FRAMEBUFFER DRIVER
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 9adb6d247818..a31da6d57a36 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -41,6 +41,7 @@ targets += module.lds
>  subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
>  subdir-$(CONFIG_MODVERSIONS) += genksyms
>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
> +subdir-$(CONFIG_SECURITY_IPE) += ipe
> 
>  # Let clean descend into subdirs
>  subdir-	+= basic dtc gdb kconfig mod
> diff --git a/scripts/ipe/Makefile b/scripts/ipe/Makefile
> new file mode 100644
> index 000000000000..e87553fbb8d6
> --- /dev/null
> +++ b/scripts/ipe/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +subdir-y := polgen
> diff --git a/scripts/ipe/polgen/.gitignore b/scripts/ipe/polgen/.gitignore
> new file mode 100644
> index 000000000000..80f32f25d200
> --- /dev/null
> +++ b/scripts/ipe/polgen/.gitignore
> @@ -0,0 +1 @@
> +polgen
> diff --git a/scripts/ipe/polgen/Makefile b/scripts/ipe/polgen/Makefile
> new file mode 100644
> index 000000000000..066060c22b4a
> --- /dev/null
> +++ b/scripts/ipe/polgen/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +hostprogs-always-y	:= polgen
> +HOST_EXTRACFLAGS += \
> +	-I$(srctree)/include \
> +	-I$(srctree)/include/uapi \
> +
> diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
> new file mode 100644
> index 000000000000..73cf13e743f7
> --- /dev/null
> +++ b/scripts/ipe/polgen/polgen.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <stdlib.h>
> +#include <stddef.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <errno.h>
> +
> +static void usage(const char *const name)
> +{
> +	printf("Usage: %s OutputFile (PolicyFile)\n", name);
> +	exit(EINVAL);
> +}
> +
> +static int policy_to_buffer(const char *pathname, char **buffer, size_t *size)
> +{
> +	int rc = 0;
> +	FILE *fd;
> +	char *lbuf;
> +	size_t fsize;
> +	size_t read;
> +
> +	fd = fopen(pathname, "r");
> +	if (!fd) {
> +		rc = errno;
> +		goto out;
> +	}
> +
> +	fseek(fd, 0, SEEK_END);
> +	fsize = ftell(fd);
> +	rewind(fd);
> +
> +	lbuf = malloc(fsize);
> +	if (!lbuf) {
> +		rc = ENOMEM;
> +		goto out_close;
> +	}
> +
> +	read = fread((void *)lbuf, sizeof(*lbuf), fsize, fd);
> +	if (read != fsize) {
> +		rc = -1;
> +		goto out_free;
> +	}
> +
> +	*buffer = lbuf;
> +	*size = fsize;
> +	fclose(fd);
> +
> +	return rc;
> +
> +out_free:
> +	free(lbuf);
> +out_close:
> +	fclose(fd);
> +out:
> +	return rc;
> +}
> +
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
> +	fprintf(fd, "#include <stddef.h>\n");
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
> +
> +int main(int argc, const char *const argv[])
> +{
> +	int rc = 0;
> +	size_t len = 0;
> +	char *policy = NULL;
> +
> +	if (argc < 2)
> +		usage(argv[0]);
> +
> +	if (argc > 2) {
> +		rc = policy_to_buffer(argv[2], &policy, &len);
> +		if (rc != 0)
> +			goto cleanup;
> +	}
> +
> +	rc = write_boot_policy(argv[1], policy, len);
> +cleanup:
> +	if (policy)
> +		free(policy);
> +	if (rc != 0)
> +		perror("An error occurred during policy conversion: ");
> +	return rc;
> +}
> diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
> new file mode 100644
> index 000000000000..eca22ad5ed22
> --- /dev/null
> +++ b/security/ipe/.gitignore
> @@ -0,0 +1 @@
> +boot-policy.c
> \ No newline at end of file
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index fcf82a8152ec..39df680b67a2 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -20,6 +20,16 @@ menuconfig SECURITY_IPE
> 
>  if SECURITY_IPE
> 
> +config IPE_BOOT_POLICY
> +	string "Integrity policy to apply on system startup"
> +	help
> +	  This option specifies a filepath to a IPE policy that is compiled
> +	  into the kernel. This policy will be enforced until a policy update
> +	  is deployed via the $securityfs/ipe/policies/$policy_name/active
> +	  interface.
> +
> +	  If unsure, leave blank.
> +
>  choice
>  	prompt "Hash algorithm used in auditing policies"
>  	default IPE_AUDIT_HASH_SHA1
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> index 1e7b2d7fcd9e..89fec670f954 100644
> --- a/security/ipe/Makefile
> +++ b/security/ipe/Makefile
> @@ -7,7 +7,18 @@
> 
>  ccflags-y := -I$(srctree)/security/ipe/modules
> 
> +quiet_cmd_polgen = IPE_POL $(2)
> +      cmd_polgen = scripts/ipe/polgen/polgen security/ipe/boot-policy.c $(2)
> +
> +$(eval $(call config_filename,IPE_BOOT_POLICY))
> +
> +targets += boot-policy.c
> +
> +$(obj)/boot-policy.c: scripts/ipe/polgen/polgen
> $(IPE_BOOT_POLICY_FILENAME) FORCE
> +	$(call if_changed,polgen,$(IPE_BOOT_POLICY_FILENAME))
> +
>  obj-$(CONFIG_SECURITY_IPE) += \
> +	boot-policy.o \
>  	ctx.o \
>  	eval.o \
>  	fs.o \
> @@ -21,3 +32,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
>  	policyfs.o \
> 
>  obj-$(CONFIG_AUDIT) += audit.o
> +
> +clean-files := boot-policy.c \
> diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
> index fc9b8e467bc9..879acf4ceac5 100644
> --- a/security/ipe/ctx.c
> +++ b/security/ipe/ctx.c
> @@ -15,6 +15,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/moduleparam.h>
> 
> +extern const char *const ipe_boot_policy;
>  static bool success_audit;
>  static bool enforce = true;
> 
> @@ -329,6 +330,7 @@ void ipe_put_ctx(struct ipe_context *ctx)
>  int __init ipe_init_ctx(void)
>  {
>  	int rc = 0;
> +	struct ipe_policy *p = NULL;
>  	struct ipe_context *lns = NULL;
> 
>  	lns = create_ctx();
> @@ -342,10 +344,26 @@ int __init ipe_init_ctx(void)
>  	WRITE_ONCE(lns->enforce, enforce);
>  	spin_unlock(&lns->lock);
> 
> +	if (ipe_boot_policy) {
> +		p = ipe_new_policy(ipe_boot_policy, strlen(ipe_boot_policy),
> +				   NULL, 0);
> +		if (IS_ERR(p)) {
> +			rc = PTR_ERR(lns);

This should be:

	rc = PTR_ERR(p);

> +			goto err;
> +		}
> +
> +		ipe_add_policy(lns, p);
> +		rc = ipe_set_active_pol(p);
> +		if (!rc)

Here you need to set a non-zero value, so that ipe_init()
does not enable the LSM.

I would set to 1 a new global variable, like ipe_lsm_enabled,
in ipe_init() just before security_add_hooks().

Then, I would add a check of this variable in ipe_init_securityfs()
to avoid the kernel panic.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> +			goto err;
> +	}
> +
>  	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
> +	ipe_put_policy(p);
> 
>  	return 0;
>  err:
> +	ipe_put_policy(p);
>  	ipe_put_ctx(lns);
>  	return rc;
>  }
> --
> 2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

