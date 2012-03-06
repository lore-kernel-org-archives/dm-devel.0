From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm thin: relax hard limit on the maximum size of a
 metadata device
Date: Tue, 6 Mar 2012 10:09:53 +0000
Message-ID: <20120306100952.GA5323@ubuntu>
References: <1330723953-16872-1-git-send-email-snitzer@redhat.com>
	<20120305102133.GB6431@ubuntu> <20120305140421.GA25562@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120305140421.GA25562@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 05, 2012 at 09:04:21AM -0500, Mike Snitzer wrote:
> On Mon, Mar 05 2012 at  5:21am -0500,
> Joe Thornber <thornber@redhat.com> wrote:
> 
> > Hi Mike,
> > 
> > My concerns are:
> > 
> > i) The current behaviour is upstream; by changing this aren't you
> >    making the tools writers life more complicated rather than less by
> >    making them support both interfaces?
> 
> It is an incremental improvement.  Allows the kernel to be forgiving.
> How does this impact some tool that took the special care to limit the
> size of the device to METADATA_DEV_MAX_SECTORS (which is < 16G)?

You're making this change to make life easier for tool writers, yet
tool writers still have to support the existing 3.2 kernel and deal
with the 16G limit.

> Whatever the tools may be doing is not my concern.  Ideally the users
> and tool authors understand that 16G is insane for thinp metadata.  But
> in the event that they use 16G would you rather we reject them?

Yes, I would rather reject, than let people think they had 32G of
metadata.  It also forces the tool writers to do something sane.

I don't feel strongly enough about this to keep arguing.  So consider
this an ACK and see if you can get it past Alasdair.

- Joe
