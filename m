From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: rdac on IBM 1746 (SAS connection to
	DS3512)
Date: Wed, 09 Feb 2011 10:49:36 +0100
Message-ID: <1297244976.29348.9.camel@zezette>
References: <1297244251.10348.14.camel@tablet>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1297244251.10348.14.camel@tablet>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Volkov <peter.volkov@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


> root@btv1:~# multipath -l
> vod (360080e50001baa46000025834d501798) dm-0 IBM     ,1746      FASt
> [size=13T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][active]
>  \_ 0:0:2:1 sdc 8:32  [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 0:0:3:1 sdd 8:48  [active][undef]
> 
> 
> Is this normal? On Gentoo system connected to the same DS I see:
> 
There you can say the multipath tools version is outdated on your ubuntu
version (still old output tree format).

> mon1 ~ # multipath -l
> vod (360080e50001baa46000025834d501798) dm-0 IBM,1746      FAStT
> size=13T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1
> rdac' wp=rw
> |-+- policy='round-robin 0' prio=-1 status=active
> | `- 0:0:2:1 sdc 8:32 active undef running
> `-+- policy='round-robin 0' prio=-1 status=enabled
>   `- 0:0:3:1 sdd 8:48 active undef running
> 
> Could you tell me what's hwhandler and why it's 0 in one case and 1 in
> another.
> 
Here the multipath tools version is more recent. More storage device
definitions get added every month. The hardware handler is one of the
properties of such a storage device definition. This property is used to
format the multipath device mapper string.

On your ubuntu setup, multipath tools picked the default hardware
handler (none, ie 0) whereas on your gentoo setup the hardware handler
is explicitely set for use with your storage device.

Now 2 choices :
1/ upgrade multipath-tools
or
2/ set up your device definition in multipath.conf to override internal
defaults

Regards,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
