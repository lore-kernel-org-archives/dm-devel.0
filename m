From: "goggin, edward" <egoggin@emc.com>
Subject: Re: [ANNOUNCE] block layer (request based) multipath v
	1
Date: Thu, 20 Oct 2005 15:51:03 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AD4E@SRMANNING.eng.emc.com>
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

On Thu, 20 Oct 2005 15:53:03 +0200
Christophe Varoqui <christophe.varoqui@free.fr> wrote:

> Nice,
> 
> can libdevmapper event listening mecanisms be replaced by the 
> uevents listener ?
> IOW, will all necessary attribute changes be reported as uevents ?
> 
> Events needed are :
> - multipath topology changes :
>   - path add/remove (well, this one is guarantied through 
> /block I guess)
>   - attributes changes
>   - path state changes / path reinstates
>   - path group switches
> - multipath add/remove (Deduce from /block uevents ?)
> 
> Regards,
> cvaroqui

Good idea -- but Netlink sockets are inherently unreliable
(think UDP not TCP) since they use datagrams.  Also, we will
need lots of kobjects scattered around the current multipath
kernel components in order to generate the necessary uevents
whenever attribute values change.  This is no trivial task --
making the kobject_hotplug call at the right point in the kernel
code is non intuitive.  Already, the existing code is generating
calling kobject_hotplug too early in lots of places before
things needed by the user level code are necessarily in place.
This causes problems intermittent failures which can be very
difficult to diagnose.
