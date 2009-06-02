From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Updated cluster log patch (take 4)
Date: Wed, 3 Jun 2009 00:59:58 +0400
Message-ID: <20090602205958.GA29702@2ka.mipt.ru>
References: <1243972499.25515.17.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1243972499.25515.17.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jonathan.

On Tue, Jun 02, 2009 at 02:54:59PM -0500, Jonathan Brassow (jbrassow@redhat.com) wrote:
> Evgeniy, I was wondering if I could get your thoughts on some of the
> security questions I am currently investigating below...
> 
> This patch contains very minor changes from the last posting.
> - Variable/Macro name changes
> - minor changes to comments
> 
> I am currently exploring the security of using connector/netlink.  I am
> being sure to clear any buffers before populating them to prevent
> leaking any kernel memory contents to userspace.  I am also double
> checking in-coming data length fields which are filled in from user
> space.  I have these questions remaining:
> 
> 1) Can a non-root user communicate with the kernel via connector?  I saw
> this (http://lwn.net/Articles/329266/) regarding a privilege escalation
> (udev + netlink).  The article tells how netlink used to allow userspace
> to both send and receive data, but now only allows data to be received.
> I think this behavior is protocol specific, though...  So, what does
> connector allow?
>
> 2) If connector does allow non-root users to communicate, do I need to
> worry about a simple user being able to perform a DOS on my daemon
> because it somehow manages to monopolize/disrupt communication to the
> connector address I am using?

Connector allows to send packets from non-root user, but only root can
receive the responses. I believe connector should have a default mode to
allow only root to send data to the kernel.

-- 
	Evgeniy Polyakov
