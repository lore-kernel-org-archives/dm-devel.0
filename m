Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE86FEB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 23:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689379155;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WtmXuz5vBXCELUl0kVHHY4IVxyGZhNXs7VLAtSnPkeM=;
	b=REUDFDSVlfDsWV1wL8io/yHmKqfuq0rd1deRZ6otJ9INa7qhOxHcX531oE+TaFHcURHiIc
	fYzceZow+OPOy6Qjk+HUnM7ZW/lRFKfrijYK6pwwgO2baLlOSIFS69dFJ3bcGmiE+n1uzD
	dGgBybTlDmePBZuAFvaQDededj8xP2A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658--tyK9HkbP2WkRlzJsbH0Lg-1; Fri, 14 Jul 2023 19:59:12 -0400
X-MC-Unique: -tyK9HkbP2WkRlzJsbH0Lg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22AFD8D1684;
	Fri, 14 Jul 2023 23:59:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F0B140C2063;
	Fri, 14 Jul 2023 23:59:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB3BC194658F;
	Fri, 14 Jul 2023 23:59:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3FFAB1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 23:59:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0F592166B26; Fri, 14 Jul 2023 23:59:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C987D2166B25
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 23:59:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A3B9101134D
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 23:59:07 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-356-ql09o5atP-2IAxUnc99b0Q-1; Fri,
 14 Jul 2023 19:59:03 -0400
X-MC-Unique: ql09o5atP-2IAxUnc99b0Q-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 8332121C4688; Fri, 14 Jul 2023 16:59:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8332121C4688
Date: Fri, 14 Jul 2023 16:59:01 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230714235901.GE15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
 <80ae988288d2ac277a4429e85524a9bb.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <80ae988288d2ac277a4429e85524a9bb.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH RFC v10 6/17] security: add new securityfs
 delete function
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
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 audit@vger.kernel.org, linux-security-module@vger.kernel.org,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:03AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > When deleting a directory in the security file system, the existing
> > securityfs_remove requires the directory to be empty, otherwise
> > it will do nothing. This leads to a potential risk that the security
> > file system might be in an unclean state when the intentded deletion
> > did not happen.
> > 
> > This commit introduces a new function securityfs_recursive_remove
> > to recursively delete a directory without leaving an unclean state.
> > 
> > Co-developed-by: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  include/linux/security.h |  1 +
> >  security/inode.c         | 25 +++++++++++++++++++++++++
> >  2 files changed, 26 insertions(+)
> > 
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index e2734e9e44d5..a88076ebc7b1 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -1971,6 +1971,7 @@ struct dentry *securityfs_create_symlink(const char *name,
> >  					 const char *target,
> >  					 const struct inode_operations *iops);
> >  extern void securityfs_remove(struct dentry *dentry);
> > +extern void securityfs_recursive_remove(struct dentry *dentry);
> >  
> >  #else /* CONFIG_SECURITYFS */
> >  
> > diff --git a/security/inode.c b/security/inode.c
> > index 6c326939750d..13358e8547e8 100644
> > --- a/security/inode.c
> > +++ b/security/inode.c
> > @@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
> >  }
> >  EXPORT_SYMBOL_GPL(securityfs_remove);
> >  
> > +static void remove_one(struct dentry *victim)
> > +{
> > +	simple_release_fs(&mount, &mount_count);
> > +}
> > +
> > +/**
> > + * securityfs_recursive_remove - recursively removes a file or directory from the securityfs filesystem
> 
> I really want to see lines less than or equal to 80 characters; I
> would suggest this:
> 
> "securityfs_recursive_remove - recursively removes a file or directory"
> 
Thanks for the suggestion, I will make the change accordingly.

-Fan
> > + * @dentry: a pointer to a the dentry of the file or directory to be removed.
> > + *
> > + * This function recursively removes a file or directory in securityfs that was
> > + * previously created with a call to another securityfs function (like
> > + * securityfs_create_file() or variants thereof.)
> > + */
> > +void securityfs_recursive_remove(struct dentry *dentry)
> > +{
> > +	if (IS_ERR_OR_NULL(dentry))
> > +		return;
> > +
> > +	simple_pin_fs(&fs_type, &mount, &mount_count);
> > +	simple_recursive_removal(dentry, remove_one);
> > +	simple_release_fs(&mount, &mount_count);
> > +}
> > +EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
> > +
> >  #ifdef CONFIG_SECURITY
> >  static struct dentry *lsm_dentry;
> >  static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
> > -- 
> > 2.25.1
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

