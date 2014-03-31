From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Mon, 31 Mar 2014 08:39:40 -0400
Message-ID: <20140331123940.GB25683@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
	<53368043.5000808@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53368043.5000808@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Mar 29 2014 at  4:11am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 03/28/2014 09:11 PM, Mike Snitzer wrote:
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Write requests are sorted in a red-black tree structure and are submitted
> > in the sorted order.
> > 
> > In theory the sorting should be performed by the underlying disk scheduler,
> > however, in practice the disk scheduler accepts and sorts only 128 requests.
> > In order to sort more requests, we need to implement our own sorting.
> 
> Hi,
> 
> I think it would be nice to mention why simply increasing queue nr_request
> doesn't help. It is definitely not limited to 128, it is only default value.
> 
> (I just wonder how this helps for SSDs where I think it depends what's fw
> doing with io requests anyway).

Obviously is less of a concern on SSD but I think we'll find it still is
beneficial.

> It would be nice to have sysfs switch to disable sorting in dmcrypt but that
> can be added later.

Not sure sysfs is the right place to put this.  Would prefer to use a DM
message to toggle it.  And possibly default to off if the backing
storage is non-rotational.

> Anyway, thanks for rebasing these patches!
> 
> ...
> > +#define io_node rb_entry(parent, struct dm_crypt_io, rb_node)
> > +		if (sector < io_node->sector)
> > +			p = &io_node->rb_node.rb_left;
> > +		else
> > +			p = &io_node->rb_node.rb_right;
> > +#undef io_node
> 
> Btw, could this be switched to inline function instead of define,
> or it is only me who thinks #define here is ugly? :)

I wasn't a big fan of the #define .. #undef but I didn't see the need to
change it if Mikulas felt more comfortable with it this way.

I recently wrote some rbtree code for dm-thinp, it also uses a #define
but outside of the function body (above the function), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a43260f01a3b6f5ef33d0abc86e9b0a92096cd84

We could change this code in a similar way.
