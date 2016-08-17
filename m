From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.8 dm-mpath
Date: Tue, 16 Aug 2016 22:43:02 -0400
Message-ID: <20160817024302.GA29089@redhat.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
	<20160816191241.GA16948@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160816191241.GA16948@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 16 2016 at  3:12pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Aug 16 2016 at  1:32pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > Can you have a look at this?
> 
> I'll get linux-dm.git's 'dm-4.8' branch (v4.8-rc2) loaded on one of my
> testbed systems to run the mptest testsuite.  It should provide coverage
> for simple failover and failback.

I successfully ran mptest against that v4.8-rc2 based kernel.  Any
chance you could try mptest to see if it also passes for you?  Or if it
is able to trigger the issue for you.

mptest's runtest script defaults to setting up scsi-mq and dm-mq.
