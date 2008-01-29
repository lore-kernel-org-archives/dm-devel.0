From: malahal@us.ibm.com
Subject: Re: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 11:58:18 -0800
Message-ID: <20080129195818.GA9772@us.ibm.com>
References: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

LittleJ@AE.com [LittleJ@AE.com] wrote:
>    I am attempting to implement dm-multipath on a RHEL4U6 server and I have
>    been successful in enabling it on the second of 2 LUNs on the server but
>    for whatever reason it will not create the device special files in
>    /dev/mapper for the fist LUN.  `multipath -d` shows that it identifies the
>    first LUN and wants to create the mpath0 files:
> 
> 
> 
>    [root@svwdcvispay01 etc]# multipath -d
> 
>    create: mpath0 (36005076801810085c800000000000194)
> 
>    [size=12 GB][features="1 queue_if_no_path"][hwhandler="0"]
> 
>    \_ round-robin 0 [prio=50]
> 
>     \_ 1:0:0:0 sda 8:0  [ready]
> 
>    \_ round-robin 0 [prio=10]
> 
>     \_ 1:0:1:0 sdc 8:32 [ready]

One of the fields (DM path state) is missing from the above output.
Looks like it failed to create mpath0 properly. Make sure you enable
'syslog' and send out the syslog out when you run "multipath -v3" 

Also, can you do read/write I/O to sda and sdc devices? Try reading
data from both of those devices using dd or something similar. The
following should do:

dd if=/dev/sda of=/dev/null count=10
dd if=/dev/sdc of=/dev/null count=10

Thanks, Malahal.
