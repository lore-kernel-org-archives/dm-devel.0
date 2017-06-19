From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm integrity tests crash kernel (4.12-rc5)
Date: Mon, 19 Jun 2017 11:47:35 -0400
Message-ID: <20170619154735.GA16472@redhat.com>
References: <2b97933e-3f94-8510-cefd-13fae445400e@redhat.com>
 <d32598d1-2ae3-6b0a-690f-7d7dfa43899e@redhat.com>
 <20170619142026.GA92582@redhat.com>
 <ad400234-fde1-5ff7-246e-91ded98764e2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ad400234-fde1-5ff7-246e-91ded98764e2@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 19 2017 at 11:16am -0400,
Ondrej Kozina <okozina@redhat.com> wrote:

> On 06/19/2017 04:20 PM, Mike Snitzer wrote:
> >
> >Looks like submit_flush_bio() is disabling/enabling interrupts from
> >interrupt context.  Ondrej, does this patch fix the issue?
> 
> I let it spin for 30 minutes on patched dm-integrity and everything
> seems ok now. The moment I loaded back the old one it fell on face
> almost immediately again.

OK, I'll get it staged as a fix for 4.12.

Thanks,
Mike
