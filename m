From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: trimmable dm-snapshot?
Date: Wed, 21 Oct 2009 21:05:49 -0600
Message-ID: <4ADFCC0D.6000903@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: david.woodhouse@intel.com
List-Id: dm-devel.ids

Has anyone looked into the idea of dm-snapshots responding appropriately 
to trims from filesystems?

I.e. the efficiency problem of a dm-snapshotted ext filesystem having 
files created and then deleted?  I.e. in such a scenario, resources in 
the cow device end up taken that could be freed if the dm layer could 
efficiently respond to trim notifications by discarding any useless 
exceptions?

I've been poking around pondering whether an offline quick hack might be 
possible with libext2fs and enough knowledge of the on-disk persistent 
snapshot format.  I.e. just walk the exception chunks in the cow device, 
use libext2fs (sufficient? easiest way?) to determine whether all the 
fsblocks/sectors the chunk contains are all currently unneeded, and if 
so reclaiming that space (possibly by relocating the last exception. 
I'm still a distance from truly grokking the on-disk format along with 
the rest of the dm-snapshot and exception-store code).

Does any of this make sense?  Been looked at?  Seem like a reasonable 
avenue to pursue?

-dmc
