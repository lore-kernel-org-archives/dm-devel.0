From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Wed, 30 Nov 2011 09:49:52 -0500
Message-ID: <20111130144951.GA13775@redhat.com>
References: <1322663118-53387-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1322663118-53387-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 30 2011 at  9:25am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> When requeing a request we should be clearing the map_context
> pointer, otherwise we might access an invalid memory location.
> 
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Should Cc: stable too.

(I was thinking Alasdair would pick this up for 3.2 seeing as it is a
change to dm-mpath.c.  Alasdair, James.. I'll let you guys decide)
