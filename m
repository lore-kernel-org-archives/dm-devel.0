Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EB8C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 18:18:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-CeCGSToVMsG5Z0YgGTQZKg-1; Mon, 16 May 2022 14:17:57 -0400
X-MC-Unique: CeCGSToVMsG5Z0YgGTQZKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B33D6857AA9;
	Mon, 16 May 2022 18:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F6461121315;
	Mon, 16 May 2022 18:17:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 366551947055;
	Mon, 16 May 2022 18:17:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BC071947054
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 18:17:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5BF371121320; Mon, 16 May 2022 18:17:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 542EE112131E
 for <dm-devel@redhat.com>; Mon, 16 May 2022 18:17:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D2FB805B25
 for <dm-devel@redhat.com>; Mon, 16 May 2022 18:17:49 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-OLESY_9cMp257qCjEs6jLQ-1; Mon, 16 May 2022 14:17:47 -0400
X-MC-Unique: OLESY_9cMp257qCjEs6jLQ-1
Received: by mail-pl1-f173.google.com with SMTP id c9so15242629plh.2
 for <dm-devel@redhat.com>; Mon, 16 May 2022 11:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uT/H9lZy9IyzIRo1BQPyvaimIM9+75W3QLmIxSLbuUU=;
 b=csWIhZHyrhVSwG3lrAd0BfI71SK53lrCAqhcHdayGhVlkJz7X0fOCVXnDtF1RzhqF2
 7UDCPpXP3oIs8JS7MY80FGNtr5DjnmmVKuJSjfcLd3pudYj6h0ZhincHu9r2PdEBwORx
 iH6bh2DxId3S9ZauobKNseNLMUmcu0tD2ErhO2ztDuNrKp9SRv0LkCKrtwfAEuLVdJcR
 dm12NjL9jwi2voyTWKKipt7GlKWYIKGBr3XDQYWGHtWFH1NKKfRZy/jSGhVQ3g+xs/0Y
 QDyPSISmH7aqMqo8f7+rhIfLeB1rMy93eAjCSvMF3VDGxGbBygH3zsd6ed++Ld32JsF8
 yFMQ==
X-Gm-Message-State: AOAM53371DVUptrZAQqUfvxHusgKzdAGxj3Sl0lIkDeUZ2EKX09gMLfu
 cN3wknBytEX3Sr6ciWQ9gHWs1Q==
X-Google-Smtp-Source: ABdhPJwB7aNz9FzyraE3HZ214E4qpUBNZvJ5G0yqjEDlZDbTxbrjUI8/xzb3tlOkPTBXN2yurcWawg==
X-Received: by 2002:a17:902:b906:b0:158:3120:3b69 with SMTP id
 bf6-20020a170902b90600b0015831203b69mr18435617plb.33.1652725066427; 
 Mon, 16 May 2022 11:17:46 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:4ee0:ca4c:63fd:81d2])
 by smtp.gmail.com with UTF8SMTPSA id
 p11-20020a170902e74b00b0015e8d4eb1d8sm7431343plf.34.2022.05.16.11.17.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 May 2022 11:17:46 -0700 (PDT)
Date: Mon, 16 May 2022 11:17:44 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YoKVSEJyHvFg/V9+@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <B7FB2BE6-DF1C-414A-B4C2-0C15FD1CBF75@chromium.org>
MIME-Version: 1.0
In-Reply-To: <B7FB2BE6-DF1C-414A-B4C2-0C15FD1CBF75@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v3 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kees,

thanks for the review!

On Fri, May 13, 2022 at 03:36:26PM -0700, Kees Cook wrote:
> 
> 
> On May 4, 2022 12:54:18 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
> >Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> >devices.
> >
> >This change adds the concept of trusted verity devices to LoadPin. LoadPin
> >maintains a list of root digests of verity devices it considers trusted.
> >Userspace can populate this list through an ioctl on the new LoadPin
> >securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> >a file with verity digests as parameter. Verity reads the digests from
> >this file after confirming that the file is located on the pinned root.
> >The list of trusted digests can only be set up once, which is typically
> >done at boot time.
> >
> >When a kernel file is read LoadPin first checks (as usual) whether the file
> >is located on the pinned root, if so the file can be loaded. Otherwise, if
> >the verity extension is enabled, LoadPin determines whether the file is
> >located on a verity backed device and whether the root digest of that
> 
> I think this should be "... on an already trusted device ..."

It's not entirely clear which part you want me to substitute. 'an already
trusted device' makes me wonder whether you are thinking about reading the
list of digests, and not the general case of reading a kernel file, which
this paragraph intends to describe.

> >device is in the list of trusted digests. The file can be loaded if the
> >verity device has a trusted root digest.
> >
> >Background:
> >
> >As of now LoadPin restricts loading of kernel files to a single pinned
> >filesystem, typically the rootfs. This works for many systems, however it
> >can result in a bloated rootfs (and OTA updates) on platforms where
> >multiple boards with different hardware configurations use the same rootfs
> >image. Especially when 'optional' files are large it may be preferable to
> >download/install them only when they are actually needed by a given board.
> >Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
> >at runtime. As an example a DLC package could contain firmware for a
> >peripheral that is not present on all boards. DLCs use dm-verity to verify
> >the integrity of the DLC content.
> >
> >[1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> >[2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> >
> >Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >---
> >
> >Changes in v3:
> >- added securityfs for LoadPin (currently only populated when
> >  CONFIG_SECURITY_LOADPIN_VERITY=y)
> >- added uapi include for LoadPin
> >- changed the interface for setting up the list of trusted
> >  digests from sysctl to ioctl on securityfs entry
> >- added stub for loadpin_is_fs_trusted() to be used
> >  CONFIG_SECURITY_LOADPIN_VERITY is not select
> >- depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
> >- updated Kconfig help
> >- minor changes in read_trusted_verity_root_digests()
> >- updated commit message
> >
> >Changes in v2:
> >- userspace now passes the path of the file with the verity digests
> >  via systcl, instead of the digests themselves
> >- renamed sysctl file to 'trusted_verity_root_digests_path'
> >- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
> >- updated Kconfig doc
> >- updated commit message
> >
> > include/uapi/linux/loadpin.h |  19 ++++
> > security/loadpin/Kconfig     |  16 +++
> > security/loadpin/loadpin.c   | 184 ++++++++++++++++++++++++++++++++++-
> > 3 files changed, 218 insertions(+), 1 deletion(-)
> > create mode 100644 include/uapi/linux/loadpin.h
> >
> >diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
> >index b12f7d986b1e..c29ce562a366 100644
> >--- a/security/loadpin/loadpin.c
> >+++ b/security/loadpin/loadpin.c
>
> ...
>
> >+static int read_trusted_verity_root_digests(unsigned int fd)
> >+{
> >+	struct fd f;
> >+	void *data;
> 
> Probably easier if this is u8 *?

Maybe slightly, it would then require a cast when passing it to
kernel_read_file()

> >+	int rc;
> >+	char *p, *d;
> >+
> >+	/* The list of trusted root digests can only be set up once */
> >+	if (!list_empty(&trusted_verity_root_digests))
> >+		return -EPERM;
> >+
> >+	f = fdget(fd);
> >+	if (!f.file)
> >+		return -EINVAL;
> >+
> >+	data = kzalloc(SZ_4K, GFP_KERNEL);
> >+	if (!data) {
> >+		rc = -ENOMEM;
> >+		goto err;
> >+	}
> >+
> >+	rc = kernel_read_file(f.file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
> >+	if (rc < 0)
> >+		goto err;
> >+
> >+	((char *)data)[rc] = '\0';
> >+
> >+	p = strim(data);
> >+	while ((d = strsep(&p, ",")) != NULL) {
> 
> Maybe be flexible and add newline as a separator too?

Sure, I can add that. I'd also be fine with just allowing a newline as
separator, which seems a reasonable format for a sysfs file.

> >+		int len = strlen(d);
> >+		struct trusted_root_digest *trd;
> >+
> >+		if (len % 2) {
> >+			rc = -EPROTO;
> >+			goto err;
> >+		}
> >+
> >+		len /= 2;
> >+
> >+		trd = kzalloc(sizeof(*trd), GFP_KERNEL);
> 
> With the struct change, this could be:
> 
> kzalloc(struct_size(trd, data, len), ...)

Will change

> >+		if (!trd) {
> >+			rc = -ENOMEM;
> >+			goto err;
> >+		}
> >+
> >+		trd->data = kzalloc(len, GFP_KERNEL);
> >+		if (!trd->data) {
> >+			kfree(trd);
> >+			rc = -ENOMEM;
> >+			goto err;
> >+		}
> >+
> >+		if (hex2bin(trd->data, d, len)) {
> >+			kfree(trd);
> >+			kfree(trd->data);
> >+			rc = -EPROTO;
> >+			goto err;
> >+		}
> >+
> >+		trd->len = len;
> >+
> >+		list_add_tail(&trd->node, &trusted_verity_root_digests);
> >+	}
> >+
> >+	kfree(data);
> >+	fdput(f);
> >+
> >+	if (!list_empty(&trusted_verity_root_digests))
> >+		dm_verity_loadpin_set_trusted_root_digests(&trusted_verity_root_digests);
> >+
> >+	return 0;
> >+
> >+err:
> >+	kfree(data);
> >+
> 
> Maybe add a comment that any load failure will invalidate the entire list?

ok

> Otherwise looks good! The only other thing I can think of is pondering more
> about more carefully failing closed. E.g. instead of just throwing away all
> the other hashes on a file load failure, maybe lock out future attempts to
> set it too? I'm not sure this is actually useful, though. :P it shouldn't be
> possible to corrupt the file, etc. But in the universe where things like
> DirtyCOW happens, I've gotten even more paranoid. ;)

Sure, we can do that

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

