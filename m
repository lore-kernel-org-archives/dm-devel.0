From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: relax hard limit on the maximum size of a
 metadata device
Date: Mon, 5 Mar 2012 09:04:21 -0500
Message-ID: <20120305140421.GA25562@redhat.com>
References: <1330723953-16872-1-git-send-email-snitzer@redhat.com>
	<20120305102133.GB6431@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120305102133.GB6431@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 05 2012 at  5:21am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> Hi Mike,
> 
> My concerns are:
> 
> i) The current behaviour is upstream; by changing this aren't you
>    making the tools writers life more complicated rather than less by
>    making them support both interfaces?

It is an incremental improvement.  Allows the kernel to be forgiving.
How does this impact some tool that took the special care to limit the
size of the device to METADATA_DEV_MAX_SECTORS (which is < 16G)?

I'm not imposing new or conflicting restrictions that would trip up any
existing/hypothetical tools.

> ii) 16G is a ludicrous amount of space to allocate for metadata (16M
>     would be much better).  Why are the tools trying to allocate this
>     much?  LVM2's unit of _allocation_ may be the extent, but this is
>     separate from activation.  If your extent size is 16G you can
>     probably squeeze 1000 metadata areas into there.
> 
>     As a side issue it's not clear to me why anyone would want to use
>     16G extents?  (eg, 16M extents lets them address 2^56 bytes of
>     data in the VG).  Maybe the sys admins mistakenly think they're
>     getting performance benefits through having more contiguous data?
>     [LVM2's allocation policies try and allocate contiguous extents
>     anyway].

Whatever the tools may be doing is not my concern.  Ideally the users
and tool authors understand that 16G is insane for thinp metadata.  But
in the event that they use 16G would you rather we reject them?
I do think so, especially given that we've already documented that 16G
is the max.
 
> If you can reassure me about (i) and that your patch isn't encouraging
> poor tool code (ii), then I'll ack this patch.

OK... let me know if I passed ;)

Mike
