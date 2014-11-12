From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Question about dm target size
Date: Tue, 11 Nov 2014 21:06:41 -0500
Message-ID: <20141112020641.GA15589@redhat.com>
References: <5462ABD8.1050609@fb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5462ABD8.1050609@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Josef Bacik <jbacik@fb.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 11 2014 at  7:37pm -0500,
Josef Bacik <jbacik@fb.com> wrote:

> Hello,
> 
> I'm creating a dm target to better test power fail situations and
> I'm having trouble figuring out how to make the dm device appear as
> a different size.  So for example you do the normal dm table
> 
> offset size power-fail /dev/whatever args

So "size" should be constrained to:
size=$(sudo blockdev --getsz /dev/whatever); $((size/2))

> I want to use the entire size of /dev/whatever, but I want my dm
> device to show up as size/2.  So right now I'm doing this in my
> ->ctr function
> 
> ti->len /= 2;

You don't want to mess with ti->len.  If you have "size" be size/2
then ti->len will automatically reflect that.

But anyway, I'm mot really following how you'd map the entire
/dev/whatever but only expose half its size to the user.  What would the
target's ->map function be doing?
 
> Is that acceptable, or will this have some side-effect that's going
> to bite me in the ass?  I can't see any other target that does
> something similar and there appears to be no helper function.  This
> seems to work as far as blockdev --getsz is concerned, but I'm
> worried I need to do more.  Thanks,

dm-thinp is all about establishing thin volumes of fictional size...
wondering what kind of helper you were hoping to find.

The target's ->ctr would open /dev/whatever and internalize
/dev/whatever's size and ->map would deal with remapping of bios sent to
the target over to /dev/whatever.
