From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND] md:Remove no longer needed fix me
	comment in dm-region-hash.c for removing the structure pointer, *rh
	from the definiton of dm_region
Date: Tue, 20 Jan 2015 11:19:51 +0000
Message-ID: <20150120111951.GB17599@agk-dp.fab.redhat.com>
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 19, 2015 at 10:16:21PM -0500, Nicholas Krause wrote:
> Removes the no longer needed fix me comment questioning if we need to remove
> the structure pointer,rh as defined as a structure of type dsm_region_hash
> from the definition of the structure, dm_region. Furthermore this  pointer is
> needed in order for various functions to run and build successfully in the file,
> dm-region-hash.c.
 
You've misunderstood the comment!
Is there a better alternative to having every dm_region struct store its own copy of
this pointer?

Alasdair
