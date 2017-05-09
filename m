From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] poll()able DM events
Date: Tue, 9 May 2017 17:14:36 -0400
Message-ID: <20170509211436.GA1439@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170509191028.6898-1-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy Grover <agrover@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Tue, May 09 2017 at  3:10pm -0400,
Andy Grover <agrover@redhat.com> wrote:

> Hi Mike,
> 
> We've been working off-list to develop a method of getting DM events
> that is reliable, and also can monitor events from multiple DM devices
> from a single thread.
> 
> In short, these enable an open file descriptor to /dev/mapper/control
> to be polled. If the fd indicates POLLIN, some DM device has
> experienced an event. Figuring out which is made easier by adding
> event_nr in a backwards-compatible way to DM_LIST_DEVICES, so
> userspace can compare against previously seen per-device
> event_nrs. A new ioctl is also added, to rearm the fd so it may be
> re-poll()ed. See individual patch commitlogs for more details.
> 
> Thanks to Mikulas for redeveloping earlier versions into this patchset,
> as well as the other RH LVM devs who provided early internal feedback!

I've picked this patchset up for 4.13 but this branch will likely see
quite a few more rebases until 4.12-rcX stabilizes:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-4.13/dm

I tweaked headers slightly and move the declaration of the variable used
in the last commit to be outside the loop.

Thought about splitting the additional 'struct file *filp' arg being
sprinkled all over in the 2nd commit, into a separate earlier commit,
but just left it as is in the end.

Mike
