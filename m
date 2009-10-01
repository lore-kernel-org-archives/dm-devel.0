From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 17:13:54 -0700
Message-ID: <20091001001354.GA15420@us.ibm.com>
References: <20090923030331.GA26449@us.ibm.com>
	<F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, jbrassow@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
> Looking through the code before applying your patch, it seems that someone 
> has already thought about this issue - even if it hasn't been implemented.  
> For example, already in the top most function used to create mirrors, 
> 'lv_add_mirrors', we see a 'log_count' parameter.  That parameter can be 
> traced down through 'add_mirror_images/log', '_set_up_mirror_log', and even 
> the allocation functions.  In fact, the first comment in 'add_mirror_log' 
> is /* Unimplemented features */, followed by a check to see if 'log_count > 
> 1'.  Your patch seems to ignore 'log_count' and create new parameters (like 
> mirroredlog), which seem unnecessary to me...

Yes, I saw the log_count but not sure if I can use that for my purpose.
You can have multiple logs (reserved/standby mode implementations)
without the logs themselves mirrored.

> I don't understand why any 
> of the new parameters to the functions are necessary, can you explain?  [I 
> can see new parameters for '_create_mirror_log' though, as it doesn't seem 
> to maintain the 'log_count' parameter - but you didn't do work in that 
> function.]

_set_up_mirror_log() needs those extra parameters while calling
lv_extend() in the patch.

> You also seem to have violated the allocation policies by ignoring the line 
> of work that has been done up to '_set_up_mirror_log' by simply calling 
> 'add_mirror_images'.  This works, but it is oversimplified, I think.  You 
> can see this is incorrect by simply testing:
> prompt> lvcreate -m1 -L 500M -n lv vg /dev/sd[xy]1  # will fail because 
> there are only two devices
> prompt> lvcreate ... --mirroredlog /dev/sd[xy]1 # should fail, but succeeds 
> due to ignoring previous allocation work
> You may wish to push your enhancements into '_[create | init]_mirror_log'?

Thank you for spotting it. I will look into your suggestion.

> Additionally, the 'log_count' parameter is more general than 'mirroredlog' 
> and can support more log types.  Consider the following:
> --mirrorlog core => (log_count = 0)
> --mirrorlog disk => (log_count = 1)
> --mirrorlog redundant => (log_count = 2)
> --mirrorlog fully_redundant => (log_count = # of mirror legs)
> You are looking to add "redundant" (you can call it "mirrored" if you 
> like), but if we use 'log_count' in a general way, we get "fully_redundant" 
> (almost) for free.

The current patch actually creates fully_redundant log based what you
described.

If we are not going to use log_count for anything else other than
creating "mirrored" logs, I can use it. I remember Heinz implementing a
log device per mirror leg but the logs not not mirrored at all.

Alasdair, any comments?

Thanks, Malahal.
