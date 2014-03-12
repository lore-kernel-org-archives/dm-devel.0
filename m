From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Disable partitions scan for multipathed
	devices
Date: Wed, 12 Mar 2014 12:23:10 +0000
Message-ID: <20140312122310.GB14017@agk-dp.fab.redhat.com>
References: <1394624936-118530-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1394624936-118530-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Peter Rajnoha <prajnoha@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 12, 2014 at 12:48:56PM +0100, Hannes Reinecke wrote:
> For this I've implemented a new feature 'no_partitions' which
> just serves as a notifier to kpartx to _not_ create partitions
> on these devices.
 
This should be covered by the existing cookie flags (which udev rules
already use, if you're using udev).  It's not a multipath-specific
problem but can apply to other targets too.

Alasdair
