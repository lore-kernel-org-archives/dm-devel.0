From: Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH] dm-mpath: always return reservation conflict
Date: Thu, 16 Jul 2015 09:54:50 +0200
Message-ID: <20150716075450.GA23334@lst.de>
References: <1436959404-14035-1-git-send-email-hare@suse.de> <1436960108.31121.41.camel@HansenPartnership.com> <CABr-GncMR4y+Sv=cXnhbXyX+ko2d13hgsPg2xbWSp9Z-v8=nqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABr-GncMR4y+Sv=cXnhbXyX+ko2d13hgsPg2xbWSp9Z-v8=nqQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jul 16, 2015 at 05:07:03AM +0000, Christophe Varoqui wrote:
> For reference the opensvc crm does use type 5 pr, and aims for all paths
> registered. It still does not make use of the multipathd pr janitoring
> features, and uses sg_persist directly for pr status and actions.

The type doesn't matter here.  It's important to set the ALL_TG_PT bit
when registering the key.  As dm-mpath opens the underlying devices
exclusively, and doesn't give you a choice which path to send to you're
in a world of pain without that.
