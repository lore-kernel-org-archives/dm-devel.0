From: Chr <chunkeey@web.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Mon, 17 Mar 2008 19:36:21 +0100
Message-ID: <200803171936.22260.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de> <20080317173609.GD29322@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755185AbYCQSge@vger.kernel.org>
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Christian Kujau <lists@nerdbynature.de>, Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de, Herbert Xu <herbert@gondor.apana.org.au>, Ritesh Raj Sarraf <rrs@researchut.com>
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
Tested-by: Christian Lamparter <chunkeey@web.de>

Well, the dm-crypt regressions seems to be gone. :)
Thanks for your work & time!

Regards, 
	Christian
