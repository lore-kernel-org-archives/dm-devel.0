Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691E2C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC4A2610E8
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC4A2610E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-h4XMjS12My6ZRBPcZqX40Q-1; Thu, 14 Oct 2021 03:53:38 -0400
X-MC-Unique: h4XMjS12My6ZRBPcZqX40Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C4E218D6A40;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 106D760CC9;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D29091806D02;
	Thu, 14 Oct 2021 07:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DK4d8c023092 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 16:04:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 33F086D69D; Wed, 13 Oct 2021 20:04:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CE8363F88
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 20:04:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28567185A794
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 20:04:36 +0000 (UTC)
Received: from sonic306-27.consmr.mail.ne1.yahoo.com
	(sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-206-Syb4iQc1Md2hYUBxCmndnA-1;
	Wed, 13 Oct 2021 16:04:34 -0400
X-MC-Unique: Syb4iQc1Md2hYUBxCmndnA-1
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1634155473; bh=GEEBjmJGEQxfcyFnIEv3fggIaOqXHNf1pk/YosIFj4c=;
	h=X-Sonic-MF:Subject:To:From:Date:From:Subject;
	b=e3itMHeCDpMr45c9F7mBUhqMA+IMj+anA5dtZGkTgDkdRUbr2ejfi4HSUKaq3qmpvoJLzHcYl1wM3TLZwl8v9aXk9mSwcl20I4AcOJh0M3nPZYGpO+VXCgA4wu0KWVJAjeoGm5ddvo7yMCEIjjGjUXHF+lBwPFiu6gRzTcaDCNo3o9qq9MDcssMNnpWv+J2rxLOxiEe9JkMTwCOO2CsMfHj6VFiMPP4GZO0z4OhU4G2KOw8hEFmHMsdVSu3cQHXo/FemW+5pmkz+G8fv5xZwLLlHE7N9UKdpWqW7w1R087PgdLNeBCoarpraL6R3OIED9/MfrqKOi5OmN21+WwhQ7g==
X-YMail-OSG: kn2xUMIVM1ljcldJdbo_xnkqUuNbDqiYOz6Jvm2Kl9F.VON6OW4LCcMFdCT9Fwn
	uzldctGGMlW52a8qUqSj6WP1HGnUZTE_AyKWwRoUd1xa9VzKtdGcOih4yhOrjtlmsNomokEP0wmI
	c699IFR2LHW4Ik0FKOH33riSUAYAJkFGg4_DhgYLr9p7sY2P4Mya_cgFHyq7_zd0bno7qlvgJbAp
	kKy9Cgl12uTbUpEdtR1Lk8NXapLp5W1xoTEowVep4Mj8Io72Nt08D99Bv1MO13aJS3AM3_0L8NMy
	.SHIp9yoIDhFawdlNNVp5Off36cm2mxcxvJjFp7fQf9fwss2zEPcKAjoo3r30xWOZa3M7CMqVjmi
	oXVAN6NgWBHetc44JmLzRBAcCvcmDWWducM0_cnrDsQs.h6cSY94ZItvorsVi8Rjw3w2h3Efxw1o
	PpyxdYqGsepYyiKN8TqSr8cdLx71s9bmJYaXeMzYVIljyuyX3ZQKA2c1.xLZV493SNxObTe9uyZo
	pUKZwxdNcFmqjKkPP_2H7q81rPGcIF4.1jwLtxqsYJH1LYErC178Cft84EOgZveJU0l2_5tXviaj
	CpKx35eaFuk8Hauhs6eEq7GhmUN2_OmswvjS0IE8yRiz2DA3OY2dOzIpeaPy9dcy27HfLKeKnXwN
	.RPoJaIGD.eJgRn6a5VhX8nQa1uzeh4CILgyXLqN2aPdqDwVE1NTNZrQc49o9m_Rdyosd.MllIWa
	roSQGBJSXqzGF8SDg3PxeOlEgKxF3wKRoQFjq7gn2WBctNLqdk1Fv4wjFFP.Uulqd767ZLce0nGM
	JtFt7Mfy0QZxeYt31NIPBdUA1zvtQ6ymvfZDNPJPu.T9dsAzi.QNXYBRcAHFxoTbLOLRBItKJxrt
	dyHpYUkU2SkMv_K4i6kR8nwof9Fe1ddP53ZOHey0W2yzsJR2MupHl2dMe0moFZ2YSraQV4rPU7Zl
	oYFQqip9TSUREY6YLltTOwEDEEd0DpHV5DVUo7tGgmS.imdVaB9_yaTWkbrVEALa_PwEuA8hxzAQ
	v.XveYILv.ky80TD7ePE0lFGk5WV_dzeyJjtn227FihLSYxTB1lWg02W5HZYdlIWpLFtYwNP4pzA
	vR_EEr0QZF6vSc_eyXXYFJXU43hsiLkGs_Z.QIHtl7NjP7C2pSeGpHjqMZ2wkXoIh5vdZyQMEu4s
	.Obb31LicwYVWpfRU8FSoWOhcWzW46kj4L4U9KKYO.AU7oNqQAl_Ru9h8Slbb.wOXk0_NYXVpmiW
	_j7DUOFmuDk2K2i_rfCSLCfJPUZRUuqDi3H9rptm4pW_eMpqzTqc6vM8pL8y_SSfTsvbHLMW8ILn
	GGUbyHO8rnfabappvy_21dSwfrL8P2jfTQuI6FSC_NqHWBk_efbBROzZ6d9GZBd4d3b4GxwIhDUg
	pi3yejHHY_T89ImnSYgkbuiT4fVJb2WNxVluWVFIHOSRo5kyk6bEfffUW4ClPvmbX9xEiMDKOiVQ
	lFVxCpgDB6ost0uaWpZU.EXKWX1DxG7S3eOkFh1DvRySIVRiBtlXEYLgBMbK36ORyWCbZYCu4ut8
	JdwJe77Y8_hEJ7eO38.55.ngwSsKl5sgg3P1YHIgsRfjCX9L_bnsSFvX3NbPrH5qUGChgVMoV.8d
	V3nd4CIZOrS.dmq1T0zOzmbUZwvMUsq0xMkDVWNgJwfSPfPVzy.vVbgCL8Es8JT1fSrmtiHjAVgg
	Bt0WEhP_lB9ZBNBOvXb8OIVR0ZWwyfXUkTYIGo0.JcGv_RldoEjG.0Ua1nRVg_yFUF7SUpM4rinf
	_rD3KMuTuGlRwXLtDDB2NxhLOCLKmiR1w7aoQwYgC8tOacfe9Xi1thBkECVFaXsLnTJIulFF29YL
	u85rP3TpCIx0sxdZ5tn1T7Rs2iwlust2EcNDketERPaHEUTXJVqjLyAVcOwHkRw.C08.aQMHx7kd
	f2fiJOLFggYVc2mIJfP3yK_R1tEGN0po6rV9dMZiM.IR_s_hpzegOtqZVzOZpjM7cqRBWI1T9iuS
	prh9dYMzf5snUBPsxjIfDsFx93VDfsx_eb99FM9Vkq066.zto1VYpYEOGPh5O6cDFBu7yr8N6rV5
	05LP1.aEJ4NnfDLBiqsRgQiScbjVgwymfmWTjxX_Pj5sBuz3n6XT.uVnZrXA2FeytSBk6CTs0UGN
	XX732ySAljKmh4DUZI1z86zuqraFfBQzfVdlMTwg3j3WBqQC.iydYEBMMjzSx5iW4Hm6tSSd5Eh1
	uueHK5yAGypMnqKiA23RFrmDIxeKz8Xg6rQX6SEg6wND4HcEmrlIkCZI-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by
	sonic306.consmr.mail.ne1.yahoo.com with HTTP;
	Wed, 13 Oct 2021 20:04:33 +0000
Received: by kubenode504.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP
	Server) with ESMTPA ID d8008b9a833b5ea326972ffc61c3990e; 
	Wed, 13 Oct 2021 20:04:32 +0000 (UTC)
To: deven.desai@linux.microsoft.com, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-6-git-send-email-deven.desai@linux.microsoft.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <a358e0b0-2fc0-8b03-4bee-141675fdc73e@schaufler-ca.com>
Date: Wed, 13 Oct 2021 13:04:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634151995-16266-6-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DK4d8c023092
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: linux-fscrypt@vger.kernel.org, dm-devel@redhat.com, jannh@google.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-audit@redhat.com,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [dm-devel] [RFC PATCH v7 05/16] ipe: add LSM hooks on execution
 and kernel read
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

On 10/13/2021 12:06 PM, deven.desai@linux.microsoft.com wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> IPE's initial goal is to control both execution and the loading of
> kernel modules based on the system's definition of trust. It
> accomplishes this by plugging into the security hooks for execve,
> mprotect, mmap, kernel_load_data and kernel_read_data.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> ---
>
> Relevant changes since v6:
>   * Split up patch 02/12 into four parts:
>       1. context creation [01/16]
>       2. audit [07/16]
>       3. evaluation loop [03/16]
>       4. access control hooks [05/16] (this patch)
>
> ---
>  security/ipe/hooks.c  | 149 ++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h  |  23 ++++++-
>  security/ipe/ipe.c    |   5 ++
>  security/ipe/policy.c |  23 +++++++
>  security/ipe/policy.h |  12 +++-
>  5 files changed, 209 insertions(+), 3 deletions(-)
>
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index ed0c886eaa5a..216242408a80 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -6,11 +6,15 @@
>  #include "ipe.h"
>  #include "ctx.h"
>  #include "hooks.h"
> +#include "eval.h"
>  
> +#include <linux/fs.h>
>  #include <linux/sched.h>
>  #include <linux/types.h>
>  #include <linux/refcount.h>
>  #include <linux/rcupdate.h>
> +#include <linux/binfmts.h>
> +#include <linux/mman.h>
>  
>  /**
>   * ipe_task_alloc: Assign a new context for an associated task structure.
> @@ -56,3 +60,148 @@ void ipe_task_free(struct task_struct *task)
>  	ipe_put_ctx(ctx);
>  	rcu_read_unlock();
>  }
> +
> +/**
> + * ipe_on_exec: LSM hook called when a process is loaded through the exec
> + *		family of system calls.
> + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> + *	  being evaluated.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_on_exec(struct linux_binprm *bprm)
> +{
> +	return ipe_process_event(bprm->file, ipe_operation_exec, ipe_hook_exec);
> +}
> +
> +/**
> + * ipe_on_mmap: LSM hook called when a file is loaded through the mmap
> + *		family of system calls.
> + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + * @flags: Unused.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
> +		unsigned long flags)
> +{
> +	if (prot & PROT_EXEC || reqprot & PROT_EXEC)
> +		return ipe_process_event(f, ipe_operation_exec, ipe_hook_mmap);
> +
> +	return 0;
> +}
> +
> +/**
> + * ipe_on_mprotect: LSM hook called when a mmap'd region of memory is changing
> + *		    its protections via mprotect.
> + * @vma: Existing virtual memory area created by mmap or similar
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> +		    unsigned long prot)
> +{
> +	/* Already Executable */
> +	if (vma->vm_flags & VM_EXEC)
> +		return 0;
> +
> +	if (((prot & PROT_EXEC) || reqprot & PROT_EXEC))
> +		return ipe_process_event(vma->vm_file, ipe_operation_exec,
> +					 ipe_hook_mprotect);
> +
> +	return 0;
> +}
> +
> +/**
> + * ipe_on_kernel_read: LSM hook called when a file is being read in from
> + *		       disk.
> + * @file: Supplies a pointer to the file structure being read in from disk
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
> +		       bool contents)
> +{
> +	enum ipe_operation op;
> +
> +	switch (id) {
> +	case READING_FIRMWARE:
> +		op = ipe_operation_firmware;
> +		break;
> +	case READING_MODULE:
> +		op = ipe_operation_kernel_module;
> +		break;
> +	case READING_KEXEC_INITRAMFS:
> +		op = ipe_operation_kexec_initramfs;
> +		break;
> +	case READING_KEXEC_IMAGE:
> +		op = ipe_operation_kexec_image;
> +		break;
> +	case READING_POLICY:
> +		op = ipe_operation_ima_policy;
> +		break;
> +	case READING_X509_CERTIFICATE:
> +		op = ipe_operation_ima_x509;
> +		break;
> +	default:
> +		op = ipe_operation_max;
> +	}
> +
> +	return ipe_process_event(file, op, ipe_hook_kernel_read);
> +}
> +
> +/**
> + * ipe_on_kernel_load_data: LSM hook called when a buffer is being read in from
> + *			    disk.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents)
> +{
> +	enum ipe_operation op;
> +
> +	switch (id) {
> +	case LOADING_FIRMWARE:
> +		op = ipe_operation_firmware;
> +		break;
> +	case LOADING_MODULE:
> +		op = ipe_operation_kernel_module;
> +		break;
> +	case LOADING_KEXEC_INITRAMFS:
> +		op = ipe_operation_kexec_initramfs;
> +		break;
> +	case LOADING_KEXEC_IMAGE:
> +		op = ipe_operation_kexec_image;
> +		break;
> +	case LOADING_POLICY:
> +		op = ipe_operation_ima_policy;
> +		break;
> +	case LOADING_X509_CERTIFICATE:
> +		op = ipe_operation_ima_x509;
> +		break;
> +	default:
> +		op = ipe_operation_max;
> +	}
> +
> +	return ipe_process_event(NULL, op, ipe_hook_kernel_load);
> +}
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> index 58ed4a612e26..c99a0b7f45f7 100644
> --- a/security/ipe/hooks.h
> +++ b/security/ipe/hooks.h
> @@ -5,11 +5,19 @@
>  #ifndef IPE_HOOKS_H
>  #define IPE_HOOKS_H
>  
> +#include <linux/fs.h>
>  #include <linux/types.h>
>  #include <linux/sched.h>
> +#include <linux/binfmts.h>
> +#include <linux/security.h>
>  
>  enum ipe_hook {
> -	ipe_hook_max = 0
> +	ipe_hook_exec = 0,
> +	ipe_hook_mmap,
> +	ipe_hook_mprotect,
> +	ipe_hook_kernel_read,
> +	ipe_hook_kernel_load,
> +	ipe_hook_max
>  };
>  
>  int ipe_task_alloc(struct task_struct *task,
> @@ -17,4 +25,17 @@ int ipe_task_alloc(struct task_struct *task,
>  
>  void ipe_task_free(struct task_struct *task);
>  
> +int ipe_on_exec(struct linux_binprm *bprm);
> +
> +int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
> +		unsigned long flags);
> +
> +int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> +		    unsigned long prot);
> +
> +int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
> +		       bool contents);
> +
> +int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
> +
>  #endif /* IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index b58b372327a1..3f9d43783293 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -25,6 +25,11 @@ struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
>  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
>  	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
>  	LSM_HOOK_INIT(task_free, ipe_task_free),
> +	LSM_HOOK_INIT(bprm_check_security, ipe_on_exec),
> +	LSM_HOOK_INIT(mmap_file, ipe_on_mmap),
> +	LSM_HOOK_INIT(file_mprotect, ipe_on_mprotect),
> +	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
> +	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),

Please stick with the lsmname_hook_name convention, as you did
with ipe_task_alloc and ipe_task_free. Anyone who is looking at
more than one LSM is going to have a much harder time working
with your code the way you have it. Think

	% find security | xargs grep '_bprm_check_security('

>  };
>  
>  /**
> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index b766824cc08f..048500229365 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -483,6 +483,14 @@ int ipe_parse_op(const struct ipe_policy_token *tok,
>  {
>  	substring_t match[MAX_OPT_ARGS] = { 0 };
>  	const match_table_t ops = {
> +		{ ipe_operation_exec,		 "EXECUTE" },
> +		{ ipe_operation_firmware,	 "FIRMWARE" },
> +		{ ipe_operation_kernel_module,	 "KMODULE" },
> +		{ ipe_operation_kexec_image,	 "KEXEC_IMAGE" },
> +		{ ipe_operation_kexec_initramfs, "KEXEC_INITRAMFS"},
> +		{ ipe_operation_ima_policy,	 "IMA_POLICY" },
> +		{ ipe_operation_ima_x509,	 "IMA_X509_CERT" },
> +		{ ipe_op_alias_kernel_read,	 "KERNEL_READ" },
>  		{ ipe_op_alias_max, NULL },
>  	};
>  
> @@ -838,6 +846,15 @@ static int parse_policy(struct ipe_policy *p)
>  	return rc;
>  }
>  
> +static const enum ipe_operation alias_kread[] = {
> +	ipe_operation_firmware,
> +	ipe_operation_kernel_module,
> +	ipe_operation_ima_policy,
> +	ipe_operation_ima_x509,
> +	ipe_operation_kexec_image,
> +	ipe_operation_kexec_initramfs,
> +};
> +
>  /**
>   * ipe_is_op_alias: Determine if @op is an alias for one or more operations
>   * @op: Supplies the operation to check. Should be either ipe_operation or
> @@ -852,9 +869,15 @@ static int parse_policy(struct ipe_policy *p)
>  bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size)
>  {
>  	switch (op) {
> +	case ipe_op_alias_kernel_read:
> +		*map = alias_kread;
> +		*size = ARRAY_SIZE(alias_kread);
> +		break;
>  	default:
>  		return false;
>  	}
> +
> +	return true;
>  }
>  
>  /**
> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> index 6818f6405dd0..ca37af46e5af 100644
> --- a/security/ipe/policy.h
> +++ b/security/ipe/policy.h
> @@ -26,7 +26,14 @@ struct ipe_policy_line {
>  struct ipe_module;
>  
>  enum ipe_operation {
> -	ipe_operation_max = 0,
> +	ipe_operation_exec = 0,
> +	ipe_operation_firmware,
> +	ipe_operation_kernel_module,
> +	ipe_operation_kexec_image,
> +	ipe_operation_kexec_initramfs,
> +	ipe_operation_ima_policy,
> +	ipe_operation_ima_x509,
> +	ipe_operation_max
>  };
>  
>  /*
> @@ -34,7 +41,8 @@ enum ipe_operation {
>   * that are just one or more operations under the hood
>   */
>  enum ipe_op_alias {
> -	ipe_op_alias_max = ipe_operation_max,
> +	ipe_op_alias_kernel_read = ipe_operation_max,
> +	ipe_op_alias_max,
>  };
>  
>  enum ipe_action {


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

