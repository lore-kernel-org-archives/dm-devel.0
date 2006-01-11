From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Was: [patch 1/1] md/dm: Reduce stack usage with
	stacked block devices
Date: Wed, 11 Jan 2006 13:53:01 +0000
Message-ID: <20060111135301.GY4346@agk.surrey.redhat.com>
References: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: akpm@osdl.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 11, 2006 at 01:45:41PM +0100, Molle Bestefich wrote:
> * Do you think that there is only 1 data corruption bug in dm snapshot
> and that the code is otherwise good (data consistency wise)?
 
There are several races.  The code makes some ordering assumptions
about the I/O but does nothing to enforce those assumptions.  
So if you're unlucky and I/O happens to complete in the wrong order
or too soon you can see transient corruption in the snapshot or 
reference memory that has been freed and perhaps reallocated to
something else.

Some references:
  https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=175830
  https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=164959
  https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=173209

> * Is dm-snapshot being actively developed?
> * Which organization/person is the main developer on dm-snapshot?

Not actively developed, no.  Long-term we want to replace it with
something better.  But at the moment I'm reviewing the existing code
and fixing as many problems as I can find.
 
> What's the codebase that this patch applies to?

The -mm tree is here:
  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/

The patches I'm working on will appear here very soon now (and I'll
send an email dm-devel):
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/

Alasdair
-- 
agk@redhat.com
