Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868E7EB64DC
	for <dm-devel@archiver.kernel.org>; Sat, 15 Jul 2023 04:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689393678;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0Y82WXdLupjB990shUC9RZW/fkYpK6Gn5KpPj/hoIfM=;
	b=PiNZRf4IERSRm/GRGjKi7GW1xfrsEx7Nqx7NES4r7rmz/aFLtqlkz6PIPWD9x+8IOxO0Ua
	1RjRLe1ZEu2cMxpcNZ1O5UsP8JJQgd0jLYycZRc/k5KVW+7d8e40D50MNKtsO1WpolVAPZ
	fSrISFLLjFiOsNOVGAOnZxBuawwS0ZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-_kNS6TENNkqD4NKTRO1ogw-1; Sat, 15 Jul 2023 00:01:15 -0400
X-MC-Unique: _kNS6TENNkqD4NKTRO1ogw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FF3985A58A;
	Sat, 15 Jul 2023 04:01:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C50E2166B25;
	Sat, 15 Jul 2023 04:01:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 251501946594;
	Sat, 15 Jul 2023 04:01:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20B4E194658F
 for <dm-devel@listman.corp.redhat.com>; Sat, 15 Jul 2023 04:01:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E35640D2839; Sat, 15 Jul 2023 04:01:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E784067A3A
 for <dm-devel@redhat.com>; Sat, 15 Jul 2023 04:00:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0A778D1682
 for <dm-devel@redhat.com>; Sat, 15 Jul 2023 04:00:48 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-411-i0HEnFkmP4W55a8TpFPczQ-1; Sat,
 15 Jul 2023 00:00:30 -0400
X-MC-Unique: i0HEnFkmP4W55a8TpFPczQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 1139721C4693; Fri, 14 Jul 2023 21:00:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1139721C4693
Date: Fri, 14 Jul 2023 21:00:29 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230715040029.GH15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
 <85af33c02638ebb501b40fd0f3785b12.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <85af33c02638ebb501b40fd0f3785b12.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH RFC v10 9/17] ipe: add permissive toggle
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:06AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE, like SELinux, supports a permissive mode. This mode allows policy
> > authors to test and evaluate IPE policy without it effecting their
> > programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> > be reported.
> > 
> > This patch adds the following audit records:
> > 
> >     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
> >       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> >     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
> >       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> > 
> > The audit record only emit when the value from the user input is
> > different from the current enforce value.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/audit.c | 22 ++++++++++++++
> >  security/ipe/audit.h |  1 +
> >  security/ipe/eval.c  |  9 ++++++
> >  security/ipe/eval.h  |  1 +
> >  security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 102 insertions(+)
> 
> ...
> 
> > diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> > index 6bd2aa84831b..1761d39e4d04 100644
> > --- a/security/ipe/fs.c
> > +++ b/security/ipe/fs.c
> > @@ -16,6 +16,7 @@ static struct dentry *np __ro_after_init;
> >  static struct dentry *root __ro_after_init;
> >  struct dentry *policy_root __ro_after_init;
> >  static struct dentry *audit_node __ro_after_init;
> > +static struct dentry *enforce_node __ro_after_init;
> >  
> >  /**
> >   * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> > @@ -68,6 +69,61 @@ static ssize_t getaudit(struct file *f, char __user *data,
> >  	return simple_read_from_buffer(data, len, offset, result, 1);
> >  }
> >  
> > +/**
> > + * setenforce - Write handler for the securityfs node, "ipe/enforce"
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Supplies a buffer passed to the write syscall.
> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t setenforce(struct file *f, const char __user *data,
> > +			  size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	bool new_value, old_value;
> > +
> > +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> > +		return -EPERM;
> > +
> > +	old_value = READ_ONCE(enforce);
> > +	new_value = old_value;
> 
> Why set @new_value equal to @old_value here?
> 
Sorry this mistake is the same as the one for audit switch. 
kstrtobool_from_user will return error if new_value is not set,
I will remove the above line.

-Fan
> > +	rc = kstrtobool_from_user(data, len, &new_value);
> > +	if (rc)
> > +		return rc;
> > +
> > +	if (new_value != old_value) {
> > +		ipe_audit_enforce(new_value, old_value);
> > +		WRITE_ONCE(enforce, new_value);
> > +	}
> > +
> > +	return len;
> > +}
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

