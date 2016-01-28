From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [LSF/MM ATTEND] multipath redesign and dm blk-mq issues
Date: Thu, 28 Jan 2016 15:23:15 -0600
Message-ID: <20160128212315.GX24960@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I'd like to attend LSF/MM 2016 to participate in any discussions about 
redesigning how device-mapper multipath operates. I spend a significant
chunk of time dealing with issues around multipath and I'd like to
be part of any discussion about redesigning it.

In addition, I'd be interesting in disucssions that deal with how
device-mapper targets are dealing with blk-mq in general.  For instance,
it looks like the current dm-multipath blk-mq implementation is running
into performance bottlenecks, and changing how path selection works into
something that allows for more parallelism is a worthy discussion.  But
it would also be worth looking into changes about how the dm blk-mq
impementation deals with the mapping between it's swqueues and
hwqueue(s). Right now all the dm mapping is done in .queue_rq, instead
of in .map_queue, but I'm not convinced it belongs there. There's also
the issue that the bio targets may scale better on blk-mq devices than
the blk-mq targets.

If there happen to be any GFS2 related discussions, I'd be interested in
those as well.

Thanks
-Ben
