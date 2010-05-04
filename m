From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] blk: In elv_abort_queue skip requests with
 REQ_DONTPREP set
Date: Tue, 4 May 2010 10:58:55 -0700
Message-ID: <20100504175855.GB16156@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
 <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
 <20100504104709.GO27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100504104709.GO27497@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 03 2010, Mike Anderson wrote:
> > Having REQ_DONTPREP set on a request can indicated that resources have been
> > allocated for this request. In elv_abort_queue skip requests with
> > REQ_DONTPREP set to avoid leaking resources.
> 
> This also seems weird, are you coding the API backwards from what SCSI
> currently has implemented?
> 

Yes I was coding to current SCSI implementation.

> Would seem a lot cleaner to separate dont-prep from already-prepped.
> 

I assumed to do this we would need another request flag indicating
??REQ_PREPPED?? that would need to be set in the prep function. Then
this flag would be checked vs REQ_DONTPREP to call the unprep_fn or did you
mean something else?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
