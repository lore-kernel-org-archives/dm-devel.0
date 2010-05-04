From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/9] scsi: Add a scsi_unprep_fn
Date: Tue, 4 May 2010 12:48:04 +0200
Message-ID: <20100504104803.GP27497@kernel.dk>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-6-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1272944228-30511-6-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 03 2010, Mike Anderson wrote:
> Add scsi_unprep_fn and set this function as the unprep_rq_fn for the scsi
> queue. This will allow SCSI resources to be released if the block layer
> unpreps a request.

Looks fine, I would fold this in with patches 3+4, there's no point in
separating them this much.


-- 
Jens Axboe

