From: "goggin, edward" <egoggin@emc.com>
Subject: Re: multipath state between user and kernel space
Date: Thu, 7 Jul 2005 19:08:13 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB47@SRMANNING.eng.emc.com>
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

On Sat, 02 Jul 2005 00:07:40 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> Would printing the "PG-summed path priorities" value for each PG meet
> your needs/taste ?

Yes.  I assume that this would be the sum as recorded by multipathd and
the kernel's active path group would only reflect this under certain
conditions, (e.g., immediate failback is enabled).

What about the idea of having device specific display options (and
device specific plug-ins to manage these) which while they are
multipathing relevant, they are not managed by multipath(8)?
Are you trying to stay away from this?

I'm sure our CLARiiON customers would rather see that the multipath
display command using terminology which they are familiar with
already.
