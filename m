From: "goggin, edward" <egoggin@emc.com>
Subject: RE: dm-devel Digest, Vol 11, Issue 18
Date: Fri, 28 Jan 2005 11:53:53 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A72B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> If you look at the emc_clariion checker in multipath-tools, you'll find
> it does that.

> I've this handy paper called "Developing Multipath Software for EMC
> CLARiiON Arrays" in front of me and believe that we implement it
> already, as far as possible. ;-)

> (There's one missing piece, it's handling the specific sense codes, but
> you'll find that they are already coded in dm-emc.c in the kernel, just
> disabled until we finally get the patch to get at the SCSI SENSE data in
> the bio struct. I need to pester axboe about it again.)

> Maybe you could add the Symmetrix specific handling to the emc_clariion
> path checker and the dm-emc.c kernel module? I'd be glad to make it more
> powerful than "just" the CX/AX arrays, alas, I "only" have a CX-500 for
> playing with ;-)


Noticed already.  I am advocating that detecting path-to-LU inconsistency
be adopted generically by the multipath configuration software using one
of the two methods described in previous email and not be implemented
piecemeal or just for CLARiion, Symmetrix, or EMC storage.

This could mean that the storage system getuid callouts become functions
like the checker callouts and that by default, a storage system's getuid
callout be used also as that storage system's path checker.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
