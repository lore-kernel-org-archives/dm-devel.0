From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Tue, 15 Nov 2011 21:38:25 +0100
Message-ID: <1321389505.23295.4.camel@lapoo.opensvc.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
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


> I'm on a IBM HS21 blade connected to a DS4700 storage array.
> Without doing nothing in multipath.conf but blacklisting the internal
> disk, I get this kind of configuration:
> # multipath -l
> mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
> [size=3.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 3:0:0:1 sdb 8:16  [active][undef]
>  \_ 4:0:0:1 sdc 8:32  [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 3:0:1:1 sdd 8:48  [active][undef]
>  \_ 4:0:1:1 sde 8:64  [active][undef]
> 
> Is there any config option I can force to use only one path at a time
> in the active controller, instead of two (sdb and sdc in my case) in
> round robin as I see in iostat?
> 
What ever the reason you'd want to do that, setting the path group
policy to failover would create 4 1-path groups. I'd have 1 active paths
and 3 spares.

Regards,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
