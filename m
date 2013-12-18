From: Thomas Knauth <thomas.knauth@gmx.de>
Subject: change tracking with block-level granularity using md
Date: Wed, 18 Dec 2013 09:04:17 +0100
Message-ID: <CABhLV00aksW6BzyNswVeytfUQ+q_7PWag1njYs-E=acqqbXoVA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello list,

I am the author of the following paper

https://www.usenix.org/conference/lisa13/technical-sessions/papers/knauth

just presented at LISA 2013. Folks at the conference expressed
interested in seeing this merged into the official Linux kernel. I
would like to gauge your opinion of whether this has a chance to
actually be accepted.

The basic idea is to provide a mechanism to track changes at the block
device layer. I've based my prototype on dm-linear.c. The following
things were added:

(1) a bit vector (one bit per 4 KiB block) is used to track the changes.
(2) a pseudo-file in /proc, one per tracked device, exports the
changed block numbers

There are also two small user-space tools for convenient extraction
and merging of the modified blocks.

I'd be happy to hear your thoughts/concerns and answer questions. If I
get positive feedback, I'd prepare a patch (as outlined in
the kernel docs) and send it to the list for further dissection.

There also exists a bitbucket repository (
https://bitbucket.org/tknauth/devicemapper/ ) with all the data
related to the above paper. It also includes the code [1], albeit in
all its unpolished research hack glory.

Kind regards,
Thomas.

[1] patch file against old 3.2 kernel:
https://bitbucket.org/tknauth/devicemapper/src/ffe167007fb4c57f7b00d60ce32aa59ff4b66d61/code/dsync.diff?at=master
