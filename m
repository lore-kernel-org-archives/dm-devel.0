From: Joe Thornber <thornber@redhat.com>
Subject: Re: change tracking with block-level granularity using md
Date: Fri, 20 Dec 2013 16:35:06 +0000
Message-ID: <20131220163505.GA15982@debian>
References: <CABhLV00aksW6BzyNswVeytfUQ+q_7PWag1njYs-E=acqqbXoVA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABhLV00aksW6BzyNswVeytfUQ+q_7PWag1njYs-E=acqqbXoVA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 18, 2013 at 09:04:17AM +0100, Thomas Knauth wrote:
> Hello list,
> 
> I am the author of the following paper
> 
> https://www.usenix.org/conference/lisa13/technical-sessions/papers/knauth

I've been working on a similar problem.  There's a new target called
dm-era taking shape here:

https://github.com/jthornber/linux-2.6/blob/era/drivers/md/dm-era-target.c

It uses bloom filters to track changed blocks.  Userland tools will
access snapshots of the metadata via a metadata snapshot.  I expect to
post the finished code to dm-devel some time in Jan.

More information about what I'm trying to do can be found here:

http://device-mapper.org/blog/2013/11/12/retaining-cache-coherency-with-external-snapshots/


BTW: If you're using dm-thin your backup scenario is trivial.  Just
take a snapshot of the volumes you want to back up.  Take a metadata
snap.  Examine the metadata to see which blocks have changed since you
last backed up.  Copy data.  All you need is already written.

- Joe
