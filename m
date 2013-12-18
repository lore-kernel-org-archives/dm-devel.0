From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Wed, 18 Dec 2013 09:08:58 -0500
Message-ID: <20131218140858.GC17730@redhat.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1387353155-7271-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Sean Stewart <sean.stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 18 2013 at  2:52am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> The multipath kernel module is rejecting any map with an invalid
> device. However, as the multipathd is processing the events serially
> it will try to push a map with invalid devices if more than one
> device failed at the same time.
> So we can as well accept those maps and make sure to mark the
> paths as down.

Why is it so desirable to do this?  Reduced latency to restore at least
one valid path when a bunch of paths go down?

Why can't we just rely on userspace eventually figuring out which paths
are failed and pushing a valid map down?

Are there favorable reports that this new behavior actually helps?
Please quantify how.

(As an aside, really not a fan of parse_path doing what you've
suggested.. will look closer once I have more justification to do so)
