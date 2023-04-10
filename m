Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7BAC76196
	for <dm-devel@archiver.kernel.org>; Mon, 10 Apr 2023 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681161762;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FK/+KOiKUzJjb1tg5b0Nk3LMZ56gu4Ouyh0bpjWJNEE=;
	b=ZkawJOlO70NTBJGIfxSOqavMCg9m4bMNkXTWzJWTJf+Deb9M8bfqasPwp0Ocrr2EBkkGHJ
	1iiDaIQ2rTLQk7d8l3sEOSLmCrOlOgX6a5vtZ90qlEnjhgapWQs9FI1PsL8vc4m1693aJx
	BJ1PGpFoVazfLV2YR/8brRzx/eBVzFU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-UL0UpOUDPa2vHzJXUOlH2A-1; Mon, 10 Apr 2023 17:22:40 -0400
X-MC-Unique: UL0UpOUDPa2vHzJXUOlH2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4757829AB435;
	Mon, 10 Apr 2023 21:22:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10847492B00;
	Mon, 10 Apr 2023 21:22:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F03F61946588;
	Mon, 10 Apr 2023 21:22:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 40F8D1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Apr 2023 21:22:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3068A2166B31; Mon, 10 Apr 2023 21:22:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 298982166B30
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 21:22:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 063BB1C041A1
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 21:22:34 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-573-_YhwIxpRNRWUBsIIdj7soA-1; Mon,
 10 Apr 2023 17:22:29 -0400
X-MC-Unique: _YhwIxpRNRWUBsIIdj7soA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 029D62121ED9; Mon, 10 Apr 2023 14:22:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 029D62121ED9
Date: Mon, 10 Apr 2023 14:22:27 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230410212227.GC18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-7-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRX4-=SSAkb0f2722dJ9JGudTyT-B=t8uoRqA8efwcoSg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRX4-=SSAkb0f2722dJ9JGudTyT-B=t8uoRqA8efwcoSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH v9 06/16] ipe: add LSM hooks on execution
 and kernel read
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 02, 2023 at 02:05:20PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:59???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> >
> > IPE's initial goal is to control both execution and the loading of
> > kernel modules based on the system's definition of trust. It
> > accomplishes this by plugging into the security hooks for
> > bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> > and kernel_read_data.
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ...
> 
> > ---
> >  security/ipe/hooks.c | 169 +++++++++++++++++++++++++++++++++++++++++++
> >  security/ipe/hooks.h |  13 ++++
> >  security/ipe/ipe.c   |   6 ++
> >  3 files changed, 188 insertions(+)
> >
> > diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> > index 335b773c7ae1..fd5109e29c76 100644
> > --- a/security/ipe/hooks.c
> > +++ b/security/ipe/hooks.c
> > @@ -23,3 +23,172 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
> >  {
> >         ipe_invalidate_pinned_sb(mnt_sb);
> >  }
> > +
> > +/**
> > + * ipe_bprm_check_security - ipe security hook function for bprm check.
> > + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> > + *       being evaluated.
> > + *
> > + * This LSM hook is called when a binary is loaded through the exec
> > + * family of system calls.
> > + * Return:
> > + * *0  - OK
> > + * *!0 - Error
> > + */
> > +int ipe_bprm_check_security(struct linux_binprm *bprm)
> > +{
> > +       struct ipe_eval_ctx ctx = { 0 };
> > +
> > +       build_eval_ctx(&ctx, bprm->file, ipe_op_exec);
> > +       return ipe_evaluate_event(&ctx);
> > +}
> > +
> > +/**
> > + * ipe_mmap_file - ipe security hook function for mmap check.
> > + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *       system configuration.
> > + * @flags: Unused.
> > + *
> > + * This hook is called when a file is loaded through the mmap
> > + * family of system calls.
> > + *
> > + * Return:
> > + * * 0 - OK
> > + * * !0        - Error
> > + */
> > +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> > +                 unsigned long flags)
> > +{
> > +       struct ipe_eval_ctx ctx = { 0 };
> > +
> > +       if (prot & PROT_EXEC || reqprot & PROT_EXEC) {
> 
> Is there a reason why you care about @reqprot?  It seems like IPE
> would only be interested in the protection flags that the kernel is
> actually using.
> 
> I notice that in the `ipe_file_mprotect()` hook you ignore @reqprot,
> which I believe is the right thing to do.
> 

Yes I double checked and found that's not necessary, I will remove that.

-Fan

> > +               build_eval_ctx(&ctx, f, ipe_op_exec);
> > +               return ipe_evaluate_event(&ctx);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ipe_file_mprotect - ipe security hook function for mprotect check.
> > + * @vma: Existing virtual memory area created by mmap or similar.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *       system configuration.
> > + *
> > + * This LSM hook is called when a mmap'd region of memory is changing
> > + * its protections via mprotect.
> > + *
> > + * Return:
> > + * * 0 - OK
> > + * * !0        - Error
> > + */
> > +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> > +                     unsigned long prot)
> > +{
> > +       struct ipe_eval_ctx ctx = { 0 };
> > +
> > +       /* Already Executable */
> > +       if (vma->vm_flags & VM_EXEC)
> > +               return 0;
> > +
> > +       if (prot & PROT_EXEC) {
> > +               build_eval_ctx(&ctx, vma->vm_file, ipe_op_exec);
> > +               return ipe_evaluate_event(&ctx);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ipe_kernel_read_file - ipe security hook function for kernel read.
> > + * @file: Supplies a pointer to the file structure being read in from disk.
> > + * @id: Supplies the enumeration identifying the purpose of the read.
> > + * @contents: Unused.
> > + *
> > + * This LSM hook is called when a file is being read in from disk from
> > + * the kernel.
> > + *
> > + * Return:
> > + * 0 - OK
> > + * !0 - Error
> > + */
> > +int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
> > +                        bool contents)
> > +{
> > +       enum ipe_op_type op;
> > +       struct ipe_eval_ctx ctx;
> > +
> > +       switch (id) {
> > +       case READING_FIRMWARE:
> > +               op = ipe_op_firmware;
> > +               break;
> > +       case READING_MODULE:
> > +               op = ipe_op_kernel_module;
> > +               break;
> > +       case READING_KEXEC_INITRAMFS:
> > +               op = ipe_op_kexec_initramfs;
> > +               break;
> > +       case READING_KEXEC_IMAGE:
> > +               op = ipe_op_kexec_image;
> > +               break;
> > +       case READING_POLICY:
> > +               op = ipe_op_ima_policy;
> > +               break;
> > +       case READING_X509_CERTIFICATE:
> > +               op = ipe_op_ima_x509;
> > +               break;
> > +       default:
> > +               op = ipe_op_max;
> > +               WARN(op == ipe_op_max, "no rule setup for enum %d", id);
> > +       }
> > +
> > +       build_eval_ctx(&ctx, file, op);
> > +       return ipe_evaluate_event(&ctx);
> > +}
> > +
> > +/**
> > + * ipe_kernel_load_data - ipe security hook function for kernel load data.
> > + * @id: Supplies the enumeration identifying the purpose of the read.
> > + * @contents: Unused.
> > + *
> > + * This LSM hook is called when a buffer is being read in from disk.
> > + *
> > + * Return:
> > + * * 0 - OK
> > + * * !0        - Error
> > + */
> > +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
> > +{
> > +       enum ipe_op_type op;
> > +       struct ipe_eval_ctx ctx = { 0 };
> > +
> > +       switch (id) {
> > +       case LOADING_FIRMWARE:
> > +               op = ipe_op_firmware;
> > +               break;
> > +       case LOADING_MODULE:
> > +               op = ipe_op_kernel_module;
> > +               break;
> > +       case LOADING_KEXEC_INITRAMFS:
> > +               op = ipe_op_kexec_initramfs;
> > +               break;
> > +       case LOADING_KEXEC_IMAGE:
> > +               op = ipe_op_kexec_image;
> > +               break;
> > +       case LOADING_POLICY:
> > +               op = ipe_op_ima_policy;
> > +               break;
> > +       case LOADING_X509_CERTIFICATE:
> > +               op = ipe_op_ima_x509;
> > +               break;
> > +       default:
> > +               op = ipe_op_max;
> > +               WARN(op == ipe_op_max, "no rule setup for enum %d", id);
> > +       }
> > +
> > +       build_eval_ctx(&ctx, NULL, op);
> > +       return ipe_evaluate_event(&ctx);
> > +}
> > diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> > index 30fe455389bf..857cae69678c 100644
> > --- a/security/ipe/hooks.h
> > +++ b/security/ipe/hooks.h
> > @@ -11,4 +11,17 @@
> >
> >  void ipe_sb_free_security(struct super_block *mnt_sb);
> >
> > +int ipe_bprm_check_security(struct linux_binprm *bprm);
> > +
> > +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> > +                 unsigned long flags);
> > +
> > +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> > +                     unsigned long prot);
> > +
> > +int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
> > +                        bool contents);
> > +
> > +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
> > +
> >  #endif /* IPE_HOOKS_H */
> > diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> > index bef923026b50..7af2f942decd 100644
> > --- a/security/ipe/ipe.c
> > +++ b/security/ipe/ipe.c
> > @@ -4,6 +4,7 @@
> >   */
> >
> >  #include "ipe.h"
> > +#include "hooks.h"
> >
> >  bool ipe_enabled;
> >
> > @@ -12,6 +13,11 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
> >
> >  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
> >         LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
> > +       LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
> > +       LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
> > +       LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
> > +       LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
> > +       LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
> >  };
> >
> >  /**
> > --
> > 2.39.0
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

