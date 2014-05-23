From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: slab_common: fix the check for duplicate slab names
Date: Fri, 23 May 2014 16:16:33 -0400
Message-ID: <20140523201632.GA16013@redhat.com>
References: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com>
 <20140325170324.GC580@redhat.com>
 <alpine.DEB.2.10.1403251306260.26471@nuc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1403251306260.26471@nuc>
Sender: owner-linux-mm@kvack.org
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 25 2014 at  2:07pm -0400,
Christoph Lameter <cl@linux.com> wrote:

> On Tue, 25 Mar 2014, Mike Snitzer wrote:
> 
> > This patch still isn't upstream.  Who should be shepherding it to Linus?
> 
> Pekka usually does that.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

This still hasn't gotten upstream.

Pekka, any chance you can pick it up?  Here it is in dm-devel's
kernel.org patchwork: https://patchwork.kernel.org/patch/3768901/

(Though it looks like it needs to be rebased due to the recent commit
794b1248, should Mikulas rebase and re-send?)

Mike

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
