From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Re: dm: add topology support
Date: Fri, 05 Jun 2009 15:34:20 -0400
Message-ID: <yq1ab4mjwzn.fsf@sermon.lab.mkp.net>
References: <1244059149-14279-1-git-send-email-snitzer@redhat.com>
	<yq17hzrl2pu.fsf@sermon.lab.mkp.net>
	<20090605142111.GA21775@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090605142111.GA21775@redhat.com> (Mike Snitzer's message of
	"Fri, 5 Jun 2009 10:21:12 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> I followed your lead :)
Mike>  http://mkp.net/code/topology/dm-topology.patch

I believe I pointed out that the patch was a proof of concept :)


Mike> I need to continue looking at this problem; particularly as it
Mike> relates to the LVM2 userspace's role in seeding the DM layer
Mike> appropriately.

*nod*


Mike> So I'm not yet seeing why alignment_offset _should_ matter as you
Mike> stack within DM (because of LVM2's role in accounting for it)
Mike> but...

If LVM2 userland takes care of alignment then the offset doesn't matter.
Without it, though, there's not much I can do in the stacking function.

-- 
Martin K. Petersen      http://mkp.net/
