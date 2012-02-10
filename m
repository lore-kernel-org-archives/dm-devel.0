From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: DMLoop
Date: Fri, 10 Feb 2012 08:10:27 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1202100800510.8762@hs20-bc2-1.build.redhat.com>
References: <4F3100D2.3040309@redhat.com> <4F310783.3060907@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F310783.3060907@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: hch@infradead.org, dm-devel@redhat.com, agk@redhat.com, Red Hat Technical Discussion List <tech-list@redhat.com>, axboe@suse.de
List-Id: dm-devel.ids



On Tue, 7 Feb 2012, Bryn M. Reeves wrote:

> On 02/07/2012 10:45 AM, Aleksandar Kostadinov wrote:
> > Hello,
> > 
> > anybody knows the status of dm-loop[1]? Does it have any future?
> > Any alternatives for mapping file ranges to the underlying block
> > device?
> > 
> > [1] http://sources.redhat.com/lvm2/wiki/DMLoop
> > 
> 
> Yes and no. The original patch was really just proof-of-concept (it
> implements the loop device quite differently from traditional
> /dev/loop). This gives better I/O performance and memory footprint
> (running heavy I/O to a few loopback devices doesn't bring a small
> system to its knees for e.g.).
> 
> Apparently Jens Axboe liked the idea as he posted patches to implement
> similar changes in /dev/loop a little while later. These were not
> merged at the time because of some feedback from Christoph suggesting
> additional VFS interfaces would be needed to make the idea really
> workable. Those interfaces still aren't present but the general idea
> still seems to have legs.

Hi

Could you please describe which specific VFS interfaces do you mean?

Some people say that remapping blocks directly isn't safe in the loopback 
driver because the filesystem can move file blocks --- but this is not 
really a problem at all. dm-loop sets S_SWAPFILE in inode->i_flags and 
this flag prevents the filesystem from moving blocks for this file.

If you had something other on your mind, please describe it (or provide 
link to mailing list archives).

Mikulas

> I restarted work on dm-loop again for a little while last year and
> have a git tree here with a version that cannibalises the inner
> workings of loop.c and makes them usable from both device-mapper and
> the traditional /dev/loop interface.
> 
> This is working quite well and I plan to use it as a base for having
> another attempt at the block mapped approach. Right now it's stalled
> for lack of time but only really needs a bit of tidying up to be in a
> reviewable state.
> 
> Regards,
> Bryn.
> 
