From: Chr <chunkeey@web.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Wed, 26 Mar 2008 17:57:53 +0100
Message-ID: <200803261757.54069.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de> <20080317173609.GD29322@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757371AbYCZQ6R@vger.kernel.org>
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Christian Kujau <lists@nerdbynature.de>, Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, Ritesh Raj Sarraf <rrs@researchut.com>, dm-devel@redhat.com, dm-crypt@saout.de, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Monday 17 March 2008 18:36:09 Alasdair G Kergon wrote:
> Latest version for everyone to try:
>
> From: Milan Broz <mbroz@redhat.com>
>
> Fix regression in dm-crypt introduced in commit
> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> (dm crypt: use async crypto).
>
> If write requests need to be split into pieces, the code must not
> process them in parallel because the crypto context cannot be shared.
> So there can be parallel crypto operations on one part of the write,
> but only one write bio can be processed at a time.
>
> This is not optimal and the workqueue code need to be optimized for
> parallel processing, but for now it solves problem without affecting
> the performance of synchronous crypto operation (most of current
> dm-crypt users).
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
>
> [...]

Is there already a new, optimized version? Or is it postponed and someone will 
_hopefully_ merge  this patch into -rc7-gitX before we have a buggy mainline 
2.6.25?

Thanks,
	Chr  
