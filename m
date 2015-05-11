From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Mon, 11 May 2015 08:55:23 +0200
Message-ID: <20150511065523.GG30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430743343-47174-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 04, 2015 at 02:42:14PM +0200, Hannes Reinecke wrote:
> We should be issuing STPG synchronously as we need to
> evaluate the return code on failure.

How does this fit into the calling convention?  It seems like generally
dm-mpath expects async execution of ->activate.  If we don't actually need
asynchronous activation we should remove it from all the drivers to have
a consistent calling convention.
