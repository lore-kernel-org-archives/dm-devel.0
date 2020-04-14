From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v2 11/12] documentation: Add IPE Documentation
Date: Tue, 14 Apr 2020 09:38:09 -0600
Message-ID: <20200414093809.2c6ef93b@lwn.net>
References: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
        <20200406221439.1469862-12-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200406221439.1469862-12-deven.desai@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: deven.desai@linux.microsoft.com
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon,  6 Apr 2020 15:14:38 -0700
deven.desai@linux.microsoft.com wrote:

> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Add IPE's documentation to the kernel tree.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

Thanks for including this nice documentation from the outset!  I have a
couple of tiny nits to pick, but nothing really substantive to complain
about, so:

  Acked-by: Jonathan Corbet <corbet@lwn.net>

[...]

> +IPE is a Linux Security Module, which allows for a configurable policy

I'd drop the comma (I told you these were nits!)

[...]

> +IPE Policy
> +~~~~~~~~~~
> +
> +IPE policy is designed to be both forward compatible and backwards
> +compatible. There is one required line, at the top of the policy,
> +indicating the policy name, and the policy version, for instance:
> +
> +::
> +
> +   policy_name="Ex Policy" policy_version=0.0.0

This pattern can be compressed a bit by just putting the "::" at the end of
the last line of text:

	indicating the policy name, and the policy version, for instance::

	   policy_name="Ex Policy" policy_version=0.0.0

The result is a bit more readable in the plain-text format, IMO, and
renders exactly the same in Sphinx.

Thanks,

jon
