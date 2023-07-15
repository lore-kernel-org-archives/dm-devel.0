Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9D9EB64DC
	for <dm-devel@archiver.kernel.org>; Sat, 15 Jul 2023 03:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689391638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AoK3nDduc/4qJbiLnzRydo1Cf8nUrIppfF0UUKFzYpM=;
	b=McLMpO4Pbfr5h2wtFpPnNFGZTvjFRb6aUwmeWRW+EDa5NtCcu/MnCly6HJjq07Mh9+4zX+
	cAVOuiIvA1PQ77AVplsHklr3h8x3bIp8c/g4GuOkWlMI3Uf+0ofbIOXzwXpaCZAksdgnut
	HbH5YVCGzUprTCrfqVSoZmjKnnEkaKo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-hYT7DdQYNLuEGuGu_rQfSw-1; Fri, 14 Jul 2023 23:27:14 -0400
X-MC-Unique: hYT7DdQYNLuEGuGu_rQfSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 246011C04B5F;
	Sat, 15 Jul 2023 03:27:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA87F1454142;
	Sat, 15 Jul 2023 03:27:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B36C01946594;
	Sat, 15 Jul 2023 03:27:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B59C194658F
 for <dm-devel@listman.corp.redhat.com>; Sat, 15 Jul 2023 03:26:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E495C2C856; Sat, 15 Jul 2023 03:26:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76C98C2C7D3
 for <dm-devel@redhat.com>; Sat, 15 Jul 2023 03:26:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56B9D3806629
 for <dm-devel@redhat.com>; Sat, 15 Jul 2023 03:26:48 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-211-6UXvGYyMMZ6K--oK1dFTUw-1; Fri,
 14 Jul 2023 23:26:46 -0400
X-MC-Unique: 6UXvGYyMMZ6K--oK1dFTUw-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id B822021C4693; Fri, 14 Jul 2023 20:26:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B822021C4693
Date: Fri, 14 Jul 2023 20:26:44 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230715032644.GF15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
 <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH RFC v10 7/17] ipe: add userspace interface
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
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:04AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > As is typical with LSMs, IPE uses securityfs as its interface with
> > userspace. for a complete list of the interfaces and the respective
> > inputs/outputs, please see the documentation under
> > admin-guide/LSM/ipe.rst
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile    |   2 +
> >  security/ipe/fs.c        | 101 ++++++++
> >  security/ipe/fs.h        |  16 ++
> >  security/ipe/ipe.c       |   3 +
> >  security/ipe/ipe.h       |   2 +
> >  security/ipe/policy.c    | 111 +++++++++
> >  security/ipe/policy.h    |   9 +
> >  security/ipe/policy_fs.c | 481 +++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 725 insertions(+)
> >  create mode 100644 security/ipe/fs.c
> >  create mode 100644 security/ipe/fs.h
> >  create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > index 4069ff075093..3e8e4a06a044 100644
> > --- a/security/ipe/policy.c
> > +++ b/security/ipe/policy.c
> > @@ -7,9 +7,36 @@
> >  #include <linux/verification.h>
> >  
> >  #include "ipe.h"
> > +#include "eval.h"
> > +#include "fs.h"
> >  #include "policy.h"
> >  #include "policy_parser.h"
> >  
> > +/* lock for synchronizing writers across ipe policy */
> > +DEFINE_MUTEX(ipe_policy_lock);
> > +
> > +/**
> > + * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
> > + * @p: Policy to extract the version from.
> > + *
> > + * Bits (LSB is index 0):
> > + *	[48,32] -> Major
> > + *	[32,16] -> Minor
> > + *	[16, 0] -> Revision
> > + *
> > + * Return: u64 version of the embedded version structure.
> > + */
> > +static inline u64 ver_to_u64(const struct ipe_policy *const p)
> > +{
> > +	u64 r;
> > +
> > +	r = (((u64)p->parsed->version.major) << 32)
> > +	  | (((u64)p->parsed->version.minor) << 16)
> > +	  | ((u64)(p->parsed->version.rev));
> > +
> > +	return r;
> > +}
> > +
> >  /**
> >   * ipe_free_policy - Deallocate a given IPE policy.
> >   * @p: Supplies the policy to free.
> > @@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
> >  	if (IS_ERR_OR_NULL(p))
> >  		return;
> >  
> > +	ipe_del_policyfs_node(p);
> >  	free_parsed_policy(p->parsed);
> >  	if (!p->pkcs7)
> >  		kfree(p->text);
> > @@ -39,6 +67,65 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> >  	return 0;
> >  }
> >  
> > +/**
> > + * ipe_update_policy - parse a new policy and replace @old with it.
> 
> What does "@old" refer to?  I'm guessing you want to drop the "@".
> 
Yes it shouldn't be here, sorry confusion.

> > + * @root: Supplies a pointer to the securityfs inode saved the policy.
> > + * @text: Supplies a pointer to the plain text policy.
> > + * @textlen: Supplies the length of @text.
> > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> > + * @pkcs7len: Supplies the length of @pkcs7len.
> > + *
> > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > + * ipe_new_policy.
> > + *
> > + * Return:
> > + * * !IS_ERR	- The old policy
> 
> "The old policy" is what?
> 
Let me try to pharse it in another way, how about the existing policy
saved in the inode before update?

> > + * * -ENOENT	- Policy doesn't exist
> > + * * -EINVAL	- New policy is invalid
> > + */
> > +struct ipe_policy *ipe_update_policy(struct inode *root,
> > +				     const char *text, size_t textlen,
> > +				     const char *pkcs7, size_t pkcs7len)
> > +{
> > +	int rc = 0;
> > +	struct ipe_policy *old, *ap, *new = NULL;
> > +
> > +	lockdep_assert_held(&ipe_policy_lock);
> > +
> > +	old = (struct ipe_policy *)root->i_private;
> > +	if (!old)
> > +		return ERR_PTR(-ENOENT);
> > +
> > +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > +	if (IS_ERR(new))
> > +		return new;
> > +
> > +	if (strcmp(new->parsed->name, old->parsed->name)) {
> > +		rc = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	if (ver_to_u64(old) > ver_to_u64(new)) {
> > +		rc = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	root->i_private = new;
> > +
> > +	ap = rcu_dereference_protected(ipe_active_policy,
> > +				       lockdep_is_held(&ipe_policy_lock));
> > +	if (old == ap)
> > +		rcu_assign_pointer(ipe_active_policy, new);
> > +
> > +	swap(new->policyfs, old->policyfs);
> 
> We don't have to worry about @new, but is there a guarantee that this
> function is the only one attempting to modify @old?
> 
> *EDIT*: I found that @root is locked by the caller, that's good.  I
> would suggest adding this assumption/requirement to the function's
> description.  In general whenever a function requires something from
> a caller it should be documented in the function's description.
> 
Sorry I missed that, I will add the locking assumption in the description.
Also, just found the err part below might better be replaced by return.

> > +out:
> > +	return (rc < 0) ? ERR_PTR(rc) : old;
> > +err:
> > +	ipe_free_policy(new);
> > +	goto out;
> > +}
> > +
> 
> ...
> 
> > diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
> > new file mode 100644
> > index 000000000000..52a120118cda
> > --- /dev/null
> > +++ b/security/ipe/policy_fs.c
> > @@ -0,0 +1,481 @@
> 
> ...
> 
> > +/**
> > + * getactive - Read handler for "ipe/policies/$name/active".
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Suppleis a buffer passed to the write syscall.
> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * @data will be populated with the 1 or 0 depending on if the
> > + * corresponding policy is active.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t getactive(struct file *f, char __user *data,
> > +			 size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	const char *str;
> > +	struct inode *root = NULL;
> > +	const struct ipe_policy *p = NULL;
> > +
> > +	root = d_inode(f->f_path.dentry->d_parent);
> > +
> > +	inode_lock_shared(root);
> > +	p = (struct ipe_policy *)root->i_private;
> > +	if (!p) {
> > +		inode_unlock_shared(root);
> > +		return -ENOENT;
> > +	}
> > +	inode_unlock_shared(root);
> > +
> > +	str = (p == rcu_access_pointer(ipe_active_policy)) ? "1" : "0";
> 
> The line above should be wrapped with a RCU lock.
> 
This call only checks the value inside the pointer but doesn't dereference it.
Also from https://lwn.net/Articles/652156/ I found it says "The call to
rcu_access_pointer() need not be protected. In contrast, rcu_dereference() must
either be within an RCU read-side critical section", so I didn't add the lock
here, is this article outdated?

Thanks,
-Fan
> > +	rc = simple_read_from_buffer(data, len, offset, str, 1);
> > +
> > +	return rc;
> > +}
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

