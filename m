From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: device multipath configuration file problem
Date: Tue, 28 Nov 2006 14:10:12 -0600
Message-ID: <20061128201011.GA14134@ether.msp.redhat.com>
References: <39fdf1c70611240339m36909175hf248829c8554257@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <39fdf1c70611240339m36909175hf248829c8554257@mail.gmail.com>
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

On Fri, Nov 24, 2006 at 12:39:16PM +0100, Claudio Tassini wrote:
>    Hi all
> 
>    I'm trying to understand how dm works on a RHEL 4u4, ( and RHCS and GFS
>    too). I have two QLC HBAs connected to a Sun Storage 3510 via a couple of
>    SANBOX2 switches. Initially I uncommented all the entries in the
>    configuration file to make some test and I manage to discover the three
>    luns which where recognized correctly whit their path:
> 
>    [root@store1 ~]# multipath -ll
>    3600c0ff00000000009897a30ae0b0401
>    [size=369 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:1 sde 8:64  [active][ready]
>     \_ 2:0:1:1 sdh 8:112 [active][ready]
> 
>    3600c0ff00000000009897a30ae0b0400
>    [size=40 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:0 sdd 8:48  [active][ready]
>     \_ 2:0:1:0 sdg 8:96  [active][ready]
> 
>    3600c0ff00000000009897a5a29e3f800
>    [size=1091 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:0:0 sdc 8:32  [active][ready]
>     \_ 2:0:0:0 sdf 8:80  [active][ready]
> 
>    Now, the problem is:
>    1) the default configuration should provide a failover policy, but it
>    seems that it is actually using an active-active one

Your problem is that the compiled in default configuration for the SUN
StorEdge 3510 is 'multibus' (active-active). To see what compiled in defaults
are, look in:
/usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults

You will see

...
devices {
...
	device {
               vendor                  "SUN"
               product                 "StorEdge 3510"
               path_grouping_policy    multibus
               getuid_callout          "/sbin/scsi_id -g -u -s"
       }
...
}

>    2) Any change I make to /etc/multipath.conf , the output of multipath -ll
>    remains the same. Also tried to flush and reload, restart the daemon etc..
>    Always the same.

To change this, you need to override the compiled in defaults for your SUN
controllers. Put the following lines in your /etc/multipath.conf

devices {
	device {
		vendor                  "SUN"
		product                 "StorEdge 3510"
		path_grouping_policy    failover
		getuid_callout          "/sbin/scsi_id -g -u -s"
	}
}

>    3) If even I REMOVE the configuration file and reboot the server, it keeps
>    discovering the same paths! :
> 
>    [root@store1 ~]# ls /etc/multipath.conf
>    ls: /etc/multipath.conf: No such file or directory
>    [root@store1 ~]# multipath -ll
>    3600c0ff00000000009897a30ae0b0401
>    [size=369 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:1 sde 8:64  [active][ready]
>     \_ 2:0:1:1 sdh 8:112 [active][ready]
> 
>    3600c0ff00000000009897a30ae0b0400
>    [size=40 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:0 sdd 8:48  [active][ready]
>     \_ 2:0:1:0 sdg 8:96  [active][ready]
> 
>    3600c0ff00000000009897a5a29e3f800
>    [size=1091 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:0:0 sdc 8:32  [active][ready]
>     \_ 2:0:0:0 sdf 8:80  [active][ready]
>    [root@store1 ~]# multipath -v2 -F
>    [root@store1 ~]#
>    [root@store1 ~]# multipath -ll
>    [root@store1 ~]#
>    [root@store1 ~]# /etc/init.d/multipathd restart
>    Stopping multipathd daemon:                                [  OK  ]
>    Starting multipathd daemon:                                [  OK  ]
>    [root@store1 ~]#
>    [root@store1 ~]# multipath -v2 -ll
>    [root@store1 ~]# multipath -v2 -d
>    create: SSEAGATE_ST973401LSUN72G0210CB0H____________3LB0CB0H
>    [size=68 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=1]
>     \_ 0:0:0:0 sda 8:0   [ready]
> 
>    create: SSEAGATE_ST973401LSUN72G0210BTPF____________3LB0BTPF
>    [size=68 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=1]
>     \_ 0:0:1:0 sdb 8:16  [ready]
> 
>    create: 3600c0ff00000000009897a5a29e3f800
>    [size=1091 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:0:0 sdc 8:32  [ready]
>     \_ 2:0:0:0 sdf 8:80  [ready]
> 
>    create: 3600c0ff00000000009897a30ae0b0400
>    [size=40 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:1:0 sdd 8:48  [ready]
>     \_ 2:0:1:0 sdg 8:96  [ready]
> 
>    create: 3600c0ff00000000009897a30ae0b0401
>    [size=369 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:1:1 sde 8:64  [ready]
>     \_ 2:0:1:1 sdh 8:112 [ready]
>    [root@store1 ~]# multipath -v2 -ll
>    [root@store1 ~]# multipath -v2
>    create: 3600c0ff00000000009897a5a29e3f800
>    [size=1091 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:0:0 sdc 8:32  [ready]
>     \_ 2:0:0:0 sdf 8:80  [ready]
> 
>    create: 3600c0ff00000000009897a30ae0b0400
>    [size=40 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:1:0 sdd 8:48  [ready]
>     \_ 2:0:1:0 sdg 8:96  [ready]
> 
>    create: 3600c0ff00000000009897a30ae0b0401
>    [size=369 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2]
>     \_ 1:0:1:1 sde 8:64  [ready]
>     \_ 2:0:1:1 sdh 8:112 [ready]
> 
>    [root@store1 ~]# multipath -v2 -ll
>    3600c0ff00000000009897a30ae0b0401
>    [size=369 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:1 sde 8:64  [active][ready]
>     \_ 2:0:1:1 sdh 8:112 [active][ready]
> 
>    3600c0ff00000000009897a30ae0b0400
>    [size=40 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:1:0 sdd 8:48  [active][ready]
>     \_ 2:0:1:0 sdg 8:96  [active][ready]
> 
>    3600c0ff00000000009897a5a29e3f800
>    [size=1091 GB][features="0"][hwhandler="0"]
>    \_ round-robin 0 [prio=2][active]
>     \_ 1:0:0:0 sdc 8:32  [active][ready]
>     \_ 2:0:0:0 sdf 8:80  [active][ready]
> 
>    [root@store1 ~]#
> 
>    How is it possible??
> 
>    Thanks in advance
> 
>    --
>    Claudio Tassini

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
