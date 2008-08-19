From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: Reducing amount of logmessages openiscsi/multipath [with md3000i]
Date: Tue, 19 Aug 2008 12:20:05 -0500
Message-ID: <48AB00C5.8050604@cs.wisc.edu>
References: <005b01c901fd$37683660$a638a320$@net>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <005b01c901fd$37683660$a638a320$@net>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids


Kees Hoekzema wrote:
> Hello List,

I am adding the dm-devel list.

I think you want different settings in your multipath conf. For example 
it looks like you are using directio to test paths and you want TUR or 
the md3000i specific one which does not cause IO errors to passive paths.

You also want to make sure that you are using the md3000i hw handler or 
scsh_dh_module if you are not already. The dm-devel guys can help you out.

You may want to post your multipath.conf on the thread.

> 
> Recently we bought a md3000i for our storage needs. This box comes with two
> redundant controllers and both controller has two networkports. We connected
> all four ports to our testing network, and I let some servers mount the
> md3000i. The goal is to have all four connections on the server available
> with a redundant network, so that we can failover if one switch dies or if a
> controller dies.
> 
> However, the controller does not have support an active-active state, which
> means that if you open four connections to the four ports, you will get two
> faulty connections. With multipath this isn't a big problem as it can see
> fairly quick if a controller is offline and it switches to the other
> controller:
> 
> $ multipath -ll
> webdata (36001ec9000d163110000067f484e260c) dm-0 DELL    ,MD3000i
> [size=2.0T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 4:0:0:0 sda 8:0   [active][ready]
> \_ round-robin 0 [prio=1000][active]
>  \_ 5:0:0:0 sdb 8:16  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 6:0:0:0 sdc 8:32  [active][faulty]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 7:0:0:0 sdd 8:48  [active][faulty]
> 
> (yes, I know the prio's are a bit strange, but that is to test something
> else).
> 
> This all works quite well, but the problem we have is a massive amount of
> spam in dmesg / kern.log / syslog. In syslog we get this every 3 seconds:
> Aug 19 14:54:12 abaris kernel: [691035.298493] end_request: I/O error, dev
> sdc, sector 0
> Aug 19 14:54:12 abaris kernel: [691035.366443] end_request: I/O error, dev
> sdd, sector 0
> Aug 19 14:54:13 abaris multipathd: sdc: directio checker reports path is
> down
> Aug 19 14:54:13 abaris multipathd: sdd: directio checker reports path is
> down
> 
> This is of course useful information, but to get this 28.800 times per day
> in your log is a waste of space, beside making it impossible to read other
> messages without grepping. Now this can still be reduced by adding some
> syslog filters, but the other problem is dmesg:
> 
> $ dmesg
> [691098.658507] end_request: I/O error, dev sdc, sector 0
> [691098.704036] end_request: I/O error, dev sdd, sector 0
> [691101.678930] end_request: I/O error, dev sdc, sector 0
> [691101.738252] end_request: I/O error, dev sdd, sector 0
> 
> And this goes on for every 3 seconds as long as the connection is logged in.
> 
> So my questions:
> - Is there a way to suppress those messages, either in the iscsi programs or
> in multipath?
> - If that fails, is it possible to tweak multipath in such a way that it
> doesn't check the two failed paths, unless there is no other path available?
> These two paths should become available only if the main controller dies.
> 
> Thanks in advance,
> Kees Hoekzema
> 
> 
> > 
