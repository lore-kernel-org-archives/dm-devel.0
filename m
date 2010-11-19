From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-kcopyd: Delayed unplug of the queues
Date: Fri, 19 Nov 2010 17:18:31 -0500
Message-ID: <20101119221830.GB25730@redhat.com>
References: <Pine.LNX.4.64.1010242102240.6231@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010242102240.6231@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 24 2010 at  9:03pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-kcopyd: Delayed unplug of the queues
> 
> This patch improves performance aby about 20% when writing to the snapshot
> origin. We keep track of two block devices to unplug (one for read and the
> other for write) and unplug them when exiting "do_work" thread. If there are
> more devices used (in theory it could happen, in practice it is rare), we
> unplug immediatelly.

Again, more specifics on how you realized this 20% performance would be
appreciated.  I'd imagine this patch is really where the increased
latency comes back (due to removing immediate unplug)?

But does the fact that >2 devices will unplug immediately mitigate the
worst of the higher latency (e.g. for DM mirrors with >2 legs)?

Mike
