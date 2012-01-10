From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin metadata: clarify __open_device
 functionality and fix callers
Date: Tue, 10 Jan 2012 09:22:45 -0500
Message-ID: <20120110142237.GA8959@redhat.com>
References: <1326141188-2172-1-git-send-email-snitzer@redhat.com>
	<20120110103104.GA5981@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120110103104.GA5981@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 10 2012 at  5:31am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Mon, Jan 09, 2012 at 03:33:08PM -0500, Mike Snitzer wrote:
> > The __open_device() error path of __create_thin() and __create_snap()
> > will call __close_device() even if td was not initialized by
> > __open_device().
> >
> > Clearly define what callers should expect from __open_device()'s
> > return.
> >
> > Also, remove redundant 'td->changed = 1' in __create_thin() --
> > __open_device() with create=1 will have set td->changed on successful
> > return.
> 
> Hi Mike,
> 
> This looks like a code review patch, and as such I ACK it.

Yes, this was something that Alasdair came across when he inspected the
error path of __create_thin().  He was looking at this because Kabi was
having issues with opencount on a DM device (device held open when he
wasn't aware of any openers).
 
> I don't think it changes any behaviour though.  Both create_thin and
> create_snapshot hold a mutex when they run, and the first thing they
> do is check for the existence of the device.
> 
>         r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
>                             &key, &details_le);
>         if (!r)
>                 return -EEXIST;
> 
> I don't think there's a race on creation?

Right, doesn't change any behavior -- other than fix the error path to
not decrement some random memory (uninitialized @td) in
__close_device().

(and no I wasn't suggesting there was some race on creation).
