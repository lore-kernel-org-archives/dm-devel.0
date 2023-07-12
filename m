Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73ABDEB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jul 2023 03:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689133411;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jDqv9oGSbABF89DT8tCpI5Pmrnob2xHlv66GpZHqOQ8=;
	b=iqRK7+SfyMLYRDBMfmwNuvFldILTfZoJTYJLn1Yc82jq0gF2CC/UsUV9q0aDBGGeg7AZxy
	GraMyELBfKHkspneSlgFK/XIFXimn/Z0/H1Bwrst9315BB96ebg0nCbB0rF+b7fCi4u61z
	vpRZjYk6OV10aZ2Nd993O92teIq/Jvo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-wJxMpK9vNmWxQVQqVvAdZg-1; Tue, 11 Jul 2023 23:43:29 -0400
X-MC-Unique: wJxMpK9vNmWxQVQqVvAdZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17842856F66;
	Wed, 12 Jul 2023 03:43:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA9E94067A00;
	Wed, 12 Jul 2023 02:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EACA419465B6;
	Wed, 12 Jul 2023 03:43:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7587194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Jul 2023 03:43:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C9BFE4067A02; Wed, 12 Jul 2023 02:17:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C22C04067A00
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 02:17:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60B161C05143
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 03:43:23 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-54-YkOnIBpQMUCqa8eM6eT8AA-1; Tue,
 11 Jul 2023 23:43:21 -0400
X-MC-Unique: YkOnIBpQMUCqa8eM6eT8AA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id D850A21C4255; Tue, 11 Jul 2023 20:43:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D850A21C4255
Date: Tue, 11 Jul 2023 20:43:19 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZKgm+ffQbdDTxrg9@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [RFC PATCH v10 11/17] dm-verity: consume root hash
 digest and signature data via LSM hook
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
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 roberto.sassu@huawei.com, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 07, 2023 at 10:53:45AM -0400, Mike Snitzer wrote:
Thanks for the review!

> On Wed, Jun 28 2023 at  5:09P -0400,
> Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > dm-verity provides a strong guarantee of a block device's integrity. As
> > a generic way to check the integrity of a block device, it provides
> > those integrity guarantees to its higher layers, including the filesystem
> > level.
> > 
> > An LSM that control access to a resource on the system based on the
> > available integrity claims can use this transitive property of
> > dm-verity, by querying the underlying block_device of a particular
> > file.
> > 
> > The digest and signature information need to be stored in the block
> > device to fulfill the next requirement of authorization via LSM policy.
> > This will enable the LSM to perform revocation of devices that are still
> > mounted, prohibiting execution of files that are no longer authorized
> > by the LSM in question.
> > 
> > This patch added two security hook calls in dm-verity to save the
> > dm-verity roothash and the roothash signature to LSM blobs.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
...
> > diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> > index 4836508ea50c..33165dd7470f 100644
> > --- a/drivers/md/dm-verity-verify-sig.c
> > +++ b/drivers/md/dm-verity-verify-sig.c
> > @@ -9,6 +9,9 @@
> >  #include <linux/verification.h>
> >  #include <keys/user-type.h>
> >  #include <linux/module.h>
> > +#include <linux/security.h>
> > +#include <linux/dm-verity.h>
> > +#include "dm-core.h"
> 
> Why are you including dm-core.h here?
This is used to get the complete definition of struct mapped_device to extract
the struct block_device from it.

> 
> >  #include "dm-verity.h"
> >  #include "dm-verity-verify-sig.h"
> >  
> > @@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
> >   * verify_verify_roothash - Verify the root hash of the verity hash device
> >   *			     using builtin trusted keys.
> >   *
> > + * @bdev: block_device representing the device-mapper created block device.
> > + *	  Used by the security hook, to set information about the block_device.
> >   * @root_hash: For verity, the roothash/data to be verified.
> >   * @root_hash_len: Size of the roothash/data to be verified.
> >   * @sig_data: The trusted signature that verifies the roothash/data.
> >   * @sig_len: Size of the signature.
> >   *
> >   */
> > -int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> > -			    const void *sig_data, size_t sig_len)
> > +int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
> > +			    size_t root_hash_len, const void *sig_data,
> > +			    size_t sig_len)
> >  {
> >  	int ret;
> >  
> > @@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> >  				NULL,
> >  #endif
> >  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> > +	if (ret)
> > +		return ret;
> >  
> > -	return ret;
> > +	return security_bdev_setsecurity(bdev,
> > +					 DM_VERITY_SIGNATURE_SEC_NAME,
> > +					 sig_data, sig_len);
> >  }
> >  
> >  void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
> 
> Both of your calls to security_bdev_setsecurity() to set your blobs in
> the bdev are suspect because you're doing so from the verity_ctr().
> The mapped_device has 2 dm_table slots (active and inactive).  The
> verity_ctr() becomes part of the inactive slot, there is an extra step
> to bind the inactive table to the active table.
> 
> This leads to you changing the blobs in the global bdev _before_ the
> table is actually active.  It is possible that the inactive table will
> simply be removed and the DM verity device put back in service;
> leaving your blob(s) in the bdev inconsistent.
> 
> This issue has parallels to how we need to defer changing the global
> queue_limits associated with a request_queue until _after_ all table
> loading is settled and then the update is done just before resuming
> the DM device (mapped_device) -- see dm_table_set_restrictions().
> 
> Unfortunately, this feels like it may require a new hook in the
> target_type struct (e.g. ->finalize())
> 
> Mike
Thanks for pointing out this issue. We were calling security_bdev_setsecurity()
because the roothash signature data is only available in verity_ctr()
and it is discarded after verity_ctr() finishes.
After digging deeper into the table_load, I realized that we were indeed
wrong here.

Based on my understanding of your suggestion, it seems that the correct
approach would be to save the roothash signature into the struct dm_target
and then invoke security_bdev_setsecurity() before activating
the inactive table in the __bind function (where dm_table_set_restrictions is called).

To facilitate this process, it seems appropriate to introduce a new hook
called finalize() within the struct target_type. This hook would enable
targets to define tasks that need to be completed before activating
a new table.

In our specific case, we would add a finalize hook to the dm-verity module,
allowing us to call security_bdev_setsecurity() and associate the roothash
information in the struct dm_target with the struct block_device of
the struct mapped_device. Is this correct?

Thanks,
- Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

