From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [ANNOUNCE] block layer (request based) multipath v1
Date: Thu, 20 Oct 2005 15:53:03 +0200
Message-ID: <20051020135303.GD10778@free.fr>
References: <4355E5BC.60701@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4355E5BC.60701@cs.wisc.edu>
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

On Wed, Oct 19, 2005 at 01:20:44AM -0500, Mike Christie wrote:
> Version 1 and maybe the only version :)
>
...
> 
> I think the only items I have left to convert are some of the dm ioctls, 
> but that is trivial and the defaults are ok for usage. For example I 
> have not implemted a sysfs attr to read/write queue_if_no_path and a 
> timeout attr so we do not have to wait forever on it.
> 
> Comments???? Should I work with Christophe to convert the userspace tools?
> 
Nice,

can libdevmapper event listening mecanisms be replaced by the uevents listener ?
IOW, will all necessary attribute changes be reported as uevents ?

Events needed are :
- multipath topology changes :
  - path add/remove (well, this one is guarantied through /block I guess)
  - attributes changes
  - path state changes / path reinstates
  - path group switches
- multipath add/remove (Deduce from /block uevents ?)

Regards,
cvaroqui
