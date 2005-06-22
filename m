From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: blacklist issues and more
Date: Wed, 22 Jun 2005 21:23:22 +0200
Message-ID: <1119468202.1515.154.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AAEB@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAEB@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On mar, 2005-06-21 at 15:50 -0400, goggin, edward wrote:

> 
> (2) This isn't even sufficient since the multipathd holds an open on each
> multipath mapped
> device.  One result of this is that the target devices used by the mapped
> device are not
> available for use by any application which must "claim" them exclusively,
> for example,
> mount(8) or for use via raw io.  I must kill multipathd before I can use any
> of the target
> devices by these "claiming" applications.  Seems like multipath should get
> multipathd
> to close its open on the newly blacklisted block device.
> 
I guess it may be related to the wait DM event ioctl.

The daemon can't reap the waiting threads it starts (may be I'm just too
ignorant there), as they are blocked in the ioctl. It's a known and
serious problem. Moreover the daemon leaks here and pins the dm-* kobj.

The dmeventd should help fix these problems, but I was waiting more
input from Alasdair before deciding to merge that in the 0.4.5 dev
cycle.

Can you confirm this analysis applies to your reported problem.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
