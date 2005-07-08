From: "goggin, edward" <egoggin@emc.com>
Subject: Re: multipath state between user and kernel space
Date: Fri, 8 Jul 2005 12:39:14 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB54@SRMANNING.eng.emc.com>
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

On Fri, 8 Jul 2005 09:15:11 +0200
Christophe Varoqui <christophe.varoqui@free.fr> wrote

> > What about the idea of having device specific display options (and
> > device specific plug-ins to manage these) which while they are
> > multipathing relevant, they are not managed by multipath(8)?
> > Are you trying to stay away from this?
> > 
> > I'm sure our CLARiiON customers would rather see that the multipath
> > display command using terminology which they are familiar with
> > already.
> > 
> I'd rather favor consistency for users changing multipathing 
> hardware, than for users changing OS but keeping the same 
> multipathing hardware.
> 
> I guess in the second case, the users already expects changes.
> 
> Also I suspect multi-vendor SAN users will appreciate the consistency.
> 
> Do you have strong feelings about this plugin idea ?

No.  You bring up a very good point about maintaining consistency for the
management of either a multi-vendor SAN or across different SAN hardware.
