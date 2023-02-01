Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5D4C63797
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675284402;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FZsfhEZyX6avMFaWYXjikZftGo5sHKlbaa4Nqwq7JzI=;
	b=H8IZYyPPJGQxHK8D2NCbelNkSyewrhhGI4dp3T6Y7b8+xGhJWeBIBZChJuaDdSUOfEoxnp
	wKz+bABSNx8YJ/XfmXnSJG6sV+FAoEj8vIF+0UESlVXx7oeRcZ/4B3BEduYkKyG4NUl+vj
	DjdYr7FTmvMI78B1V8Ho+vyVwyy3NVQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-DoRptVywPMq3DVHRcpXXKw-1; Wed, 01 Feb 2023 15:46:38 -0500
X-MC-Unique: DoRptVywPMq3DVHRcpXXKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DB4585CBE9;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D2D42166B35;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C59F919465BC;
	Wed,  1 Feb 2023 20:46:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B17C194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 19:46:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79AE5140EBF6; Wed,  1 Feb 2023 19:46:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71FBF140EBF4
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 19:46:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51DC3100DEA1
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 19:46:50 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-553-Z18uxoJQPJWlBJnSN-BBDQ-1; Wed,
 01 Feb 2023 14:46:48 -0500
X-MC-Unique: Z18uxoJQPJWlBJnSN-BBDQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 5F2CE20B7102; Wed,  1 Feb 2023 11:46:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F2CE20B7102
Date: Wed, 1 Feb 2023 11:46:47 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230201194647.GA11892@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <255c119de8f8665b88c411d981762fddc0fe7eaa.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <255c119de8f8665b88c411d981762fddc0fe7eaa.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 01 Feb 2023 20:46:35 +0000
Subject: Re: [dm-devel] [RFC PATCH v9 05/16] ipe: add userspace interface
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
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 11:49:44AM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > +
> > +/**
> > + * new_policy - Write handler for the securityfs node, "ipe/new_policy".
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Suppleis a buffer passed to the write syscall.
> 
> Typo: Suppleis.
> 
Thanks for spotting the typos!

> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t new_policy(struct file *f, const char __user *data,
> > +			  size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	char *copy = NULL;
> > +	struct ipe_policy *p = NULL;
> > +
> > +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> > +		return -EPERM;
> > +
> > +	copy = memdup_user_nul(data, len);
> > +	if (IS_ERR(copy)) {
> > +		rc = PTR_ERR(copy);
> > +		goto err;
> > +	}
> > +
> > +	p = ipe_new_policy(NULL, 0, copy, len);
> > +	if (IS_ERR(p)) {
> > +		rc = PTR_ERR(p);
> > +		goto err;
> > +	}
> > +
> > +	rc = ipe_new_policyfs_node(p);
> > +	if (rc)
> > +		goto err;
> 
> Uhm, don't you need to do cleanup of allocated memory or revert the
> actions of ipe_new_policy()?
> 
Yes that should be cleaned up but should be done in ipe_new_policy instead,
will add a ipe_free_policy call at the end. Thanks for pointing that out.

> 
> I would like more to see all the functions managing the policy
> together. If the patch is too long, you could further split by adding
> the helpers (that don't directly deal with the policy) in a separate
> patch.
> 
> Here you would simply instantiate dirs/files in securityfs and call the
> existing functions previously introduced.
> 
> Roberto
> 

I will try to split them in the next version. Thanks for the suggestion.
-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

