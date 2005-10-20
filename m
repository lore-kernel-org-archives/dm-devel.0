From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [ANNOUNCE] block layer (request based) multipath v1
Date: Thu, 20 Oct 2005 15:05:10 -0500
Message-ID: <4357F876.80102@cs.wisc.edu>
References: <4355E5BC.60701@cs.wisc.edu> <20051020135303.GD10778@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051020135303.GD10778@free.fr>
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

Christophe Varoqui wrote:
> On Wed, Oct 19, 2005 at 01:20:44AM -0500, Mike Christie wrote:
> 
>>Version 1 and maybe the only version :)
>>
> 
> ...
> 
>>I think the only items I have left to convert are some of the dm ioctls, 
>>but that is trivial and the defaults are ok for usage. For example I 
>>have not implemted a sysfs attr to read/write queue_if_no_path and a 
>>timeout attr so we do not have to wait forever on it.
>>
>>Comments???? Should I work with Christophe to convert the userspace tools?
>>
> 
> Nice,
> 
> can libdevmapper event listening mecanisms be replaced by the uevents listener ?
> IOW, will all necessary attribute changes be reported as uevents ?

It looks like I am going to redo the patches and make it so dm call 
request_fns. So we are basicall going to fix up dm-multipath instead of 
making yet another multipath driver :)

> 
> Events needed are :
> - multipath topology changes :
>   - path add/remove (well, this one is guarantied through /block I guess)
>   - attributes changes
>   - path state changes / path reinstates
>   - path group switches
> - multipath add/remove (Deduce from /block uevents ?)
> 

I was just wondering where is all this netlink stuff? I have not seen a 
dm-netlink interface patch. Are you just keying of events from the 
kobject stuff?
