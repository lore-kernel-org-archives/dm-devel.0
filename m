From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [ANNOUNCE] block layer (request based) multipath v
 1
Date: Thu, 20 Oct 2005 15:07:31 -0500
Message-ID: <4357F903.1070504@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321AD4E@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AD4E@SRMANNING.eng.emc.com>
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

goggin, edward wrote:
> On Thu, 20 Oct 2005 15:53:03 +0200
> Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> 
> 
>>Nice,
>>
>>can libdevmapper event listening mecanisms be replaced by the 
>>uevents listener ?
>>IOW, will all necessary attribute changes be reported as uevents ?
>>
>>Events needed are :
>>- multipath topology changes :
>>  - path add/remove (well, this one is guarantied through 
>>/block I guess)
>>  - attributes changes
>>  - path state changes / path reinstates
>>  - path group switches
>>- multipath add/remove (Deduce from /block uevents ?)
>>
>>Regards,
>>cvaroqui
> 
> 
> Good idea -- but Netlink sockets are inherently unreliable
> (think UDP not TCP) since they use datagrams.  Also, we will
> need lots of kobjects scattered around the current multipath
> kernel components in order to generate the necessary uevents
> whenever attribute values change.  This is no trivial task --

We could actaully do our own netlink socket like the open iscsi guys 
did. Add our own mempools (although Dimitry and Alex found some places 
where there are OOM problems there) and have complete control over the 
events, serialization, etc.

> making the kobject_hotplug call at the right point in the kernel
> code is non intuitive.  Already, the existing code is generating
> calling kobject_hotplug too early in lots of places before
> things needed by the user level code are necessarily in place.
> This causes problems intermittent failures which can be very
> difficult to diagnose.
