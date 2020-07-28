From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH v5 05/11] fs: add security blob and hooks for
 block_device
Date: Tue, 28 Jul 2020 23:40:03 +0100
Message-ID: <20200728224003.GC951209@ZenIV.linux.org.uk>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200728213614.586312-6-deven.desai@linux.microsoft.com>
 <ef0fff6f-410a-6444-f1e3-03499a2f52b7@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ef0fff6f-410a-6444-f1e3-03499a2f52b7@schaufler-ca.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Deven Bowers <deven.desai@linux.microsoft.com>, agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com, tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatashin@soleen.com
List-Id: dm-devel.ids

On Tue, Jul 28, 2020 at 03:22:59PM -0700, Casey Schaufler wrote:

> > +	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
> > +		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
> > +
> > +		if (rc == -ENOSYS)
> > +			rc = 0;
> > +
> > +		if (rc != 0)
> 
> Perhaps:
> 		else if (rc != 0)
> 
> > +			break;
> > +	}
> > +
> > +	return rc;

	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
		if (rc && rc != -ENOSYS)
			return rc;
	}
	return 0;

Easier to reason about that way...
