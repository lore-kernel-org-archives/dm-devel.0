From: Joe Thornber <thornber@redhat.com>
Subject: Re: [Question] dm-cache table
Date: Wed, 27 Nov 2013 12:29:17 +0000
Message-ID: <20131127122916.GB18478@debian>
References: <52932C6F.5000306@gmail.com> <20131125120512.GC10831@debian>
	<529550BC.2040009@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <529550BC.2040009@gmail.com>
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

On Wed, Nov 27, 2013 at 10:54:04AM +0900, Akira Hayakawa wrote:
> Joe,
> 
> > On Mon, Nov 25, 2013 at 07:54:39PM +0900, Akira Hayakawa wrote:
> >> If it accepted migrate_threshold in .ctr and the parameter
> >> changed later. The actual value and what is seen in table
> >> become inconsistent right? Is this intentionally designed?
> > 
> > No, this is a bug.
> 
> So, the table design should be fully consistent with the actual values?

I guess the status should show what's running, and the table line
should show what was originally loaded.  The problem we have here is
that original table can go out of date and mislead any volume managers
that are relying on it; I really would like to keep the following
sequence a logical noop for all targets:

  - load table
  - run for a bit
  - read table via STATUS ioctl call
  - load table just read
  - switch to newly loaded table

Putting those tunables on the target line and then having messages to
change them obviously breaks this (though not in a data loss way).

The other option would be to store the tunables in the metadata, and
have them only changed via messages (not on the target line).  The
draw back with this approach is it puts extra work on the userland
volume management software; either they end up duplicating these
settings in their own metadata, or have to be able to query them from
the metadata (remember the volume may not be active).  I suggest you
go with this approach for now.

- Joe
