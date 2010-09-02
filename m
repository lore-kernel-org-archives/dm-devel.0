From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Discard support for dm-snap
Date: Thu, 2 Sep 2010 10:14:09 -0400
Message-ID: <20100902141408.GA5987@redhat.com>
References: <4C7F5AE2.9020908@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C7F5AE2.9020908@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, mpatocka@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 02 2010 at  4:05am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> now that we've got discard support in the block layer, are there plans
> to update dm-snap to actually implement discard?
> Looks like a valid addendum here; we could be freeing up unused blocks
> thus freeing up space.
> Especially helpful when using dm-snap to create a sparse device;
> cf
> http://www.mjmwired.net/kernel/Documentation/device-mapper/zero.txt
> 
> Thoughts?

From https://www.redhat.com/archives/dm-devel/2010-July/msg00149.html

"The snapshot and crypt targets will not have discard support.

Snapshots must preserve any data that is deleted so the value of
discard is negligible.  Discard support for the origin target may be
considered in the future (could be especially useful if origin and COW
are different devices and origin is a thinly provisioned LUN)."

The snapshot target must always preserve changes (in the form of
exceptions in the COW store).  Even though you'd be removing files
through the snapshot device as far as the snapshot is concerned it must
track that change (relative to the origin).  Simply put: the current
snapshot store format doesn't easily allow for what you're asking for.

The new shared snapshot target that is in development may provide an
opportunity for adding more intelligence to account for this use-case.

Mikulas and/or Joe may have more insight here.

Mike
