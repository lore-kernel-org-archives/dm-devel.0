From: Josef Bacik <jbacik@fb.com>
Subject: Re: Question about dm target size
Date: Wed, 12 Nov 2014 02:30:52 +0000
Message-ID: <fw2umnrmmu1mdtg0ab4f8stc.1415759451452@email.android.com>
References: <5462ABD8.1050609@fb.com>,<20141112020641.GA15589@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141112020641.GA15589@redhat.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sorry for top posting, my phone client doesn't do inline.

I'm splitting the disk in half, writing to alternating sides of the disk and keeping track of where which block is so when the power fail event occurs the subsequent reads come from the corresponding mirror in the disk. The disk needs to appear to be size/2 for the mkfs to know the correct size, but my target needs to be able to write up to size.  I looked at thinp but it reflects the full size right? It's just like a sparse find correct? My ->map function does the right thing, doing the ->len trick makes it all work out right, but this is really isolated testing. Thanks,

Josef

Mike Snitzer <snitzer@redhat.com> wrote:


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
