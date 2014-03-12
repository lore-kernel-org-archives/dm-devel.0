From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] multipath devices are not getting created
	for readonly	devices
Date: Wed, 12 Mar 2014 12:18:39 +0000
Message-ID: <20140312121838.GA14017@agk-dp.fab.redhat.com>
References: <1394624094-118695-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1394624094-118695-1-git-send-email-hare@suse.de>
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
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 12, 2014 at 12:34:54PM +0100, Hannes Reinecke wrote:
> Currently we cannot create device-mapper tables for multipath devices
> whenever the underlying devices are read-only.

Userspace can specify a read-only table when creating it.

> This patch modifies the device-mapper to set the 'READ-ONLY' flag
> automatically whenever a read-only device is added to the table.
 
I don't know if it's working properly at the moment, but some targets
(like dm-delay) are meant to work with a combination of read-only and
read-write devices. 

I don't think the table mode should get changed quite like this: I
think this problem needs wider review, perhaps overlapping with the
problem of checking on the I/O path not just at device open time.

Alasdair
