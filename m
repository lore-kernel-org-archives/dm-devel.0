From: malahal@us.ibm.com
Subject: Re: multipath - AAArgh! How do I turn "features=1
	queue_if_no_path" off?
Date: Wed, 30 Sep 2009 08:42:12 -0700
Message-ID: <20090930154212.GA8507@us.ibm.com>
References: <4AC333E2.9090005@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AC333E2.9090005@Calva.COM>
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

John Hughes [john@Calva.COM] wrote:
> I want to turn queue_if_no_path off and use
>
>                polling_interval        5
>                no_path_retry           5
>
> because I've had problems with things hanging when a lun "vanishes" (I 
> deleted it from my external raid box).
>
> But whatever I put in /etc/multipath.conf when I do a "multipath -l" or 
> "multipath-ll" it shows:

Did you reload the mapper table?

> 360024e80005b3add000001b64ab05c87dm-28 DELL    ,MD3000        
> [size=68G][features=1 queue_if_no_path][hwhandler=1 rdac]
> \_ round-robin 0 [prio=3][active]
> \_ 3:0:1:13 sdad 65:208 [active][ready]
> \_ round-robin 0 [prio=0][enabled]
> \_ 4:0:0:13 sdas 66:192 [active][ghost]
>
>
> How on earth do I turn this damn thing off?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
