From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Fri, 13 Jun 2008 11:46:44 +0100
Message-ID: <20080613104644.GL20826@agk.fab.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adam Hamsik <haaaad@gmail.com>
Cc: dm-devel@redhat.com, tech-kern@netbsd.org
List-Id: dm-devel.ids

On Wed, Jun 11, 2008 at 03:57:49PM +0200, Adam Hamsik wrote:
> *** Please keep me on CC when you replying from dm-devel list I'm not  
> currently subscribed there. ***
 
> I have created patch against latest release of libdevmapper, it would  
> be great if we will be able to manage
> commiting of this patch to libdevmapper main repo. My patch is  
> currently not ready to commit, it needs major cleanup, but I thought  
> that it would be good to let dm developers know about my effort and  
> show my work to them.
 
We'd be happy to include such patches in the userspace tools and
libraries.

Just ensure that all the differences are abstracted suitably so
that 'configure' can deal with them without breaking linux:-)

Note that we're part way through the process of merging the
device-mapper and lvm2 source trees: when this is complete
releases will consist of a single tarball with a single
'configure.in' (and an option just to build the former
device-mapper components).

Rather than sending one patch at the end, it's probably better to send
smaller patches as you go along, as and when logically-coherent sets of
changes are ready.  Also, try to avoid copying and pasting code into new
files where very little is changing - create internal library functions
or include files and share them instead, refactoring existing code
as required.

Alasdair
-- 
agk@redhat.com
