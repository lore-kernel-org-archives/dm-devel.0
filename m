From: malahal@us.ibm.com
Subject: Re: queue_if_no_path question
Date: Mon, 18 Jun 2007 12:29:40 -0700
Message-ID: <20070618192940.GA3160@us.ibm.com>
References: <1835490703.20070616220741@netvision.net.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20070618193056.GB3160@us.ibm.com>
Resent-To: dm-devel@redhat.com
Content-Disposition: inline
In-Reply-To: <1835490703.20070616220741@netvision.net.il>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maxim Kozover <maximkoz@netvision.net.il>
List-Id: dm-devel.ids

That is probably not unexpected! Use crash and see what other threads
are doing. They were probably waiting on pages that were supposed to be
completed by the DM devices (the pages won't be completed because you
put them in a queue)

Thanks, Malahal.

Maxim Kozover [maximkoz@netvision.net.il] wrote:
> Hi!
> I have a question regarding queue_if_no_path behavior.
> I tried either Red Hat 5.0 2.6.18-8.el5 kernel and more or less recent multipath-tools.
> Set no_path_retry queue in multipath.conf and tried losing all paths
> to a SAN device, while I'm dd-ing from /dev/zero to /dev/mapper/...
> 
> What's strange is that not only ios to that device got blocked, but
> also ios to /tmp and /var/log/messages etc that reside on local drive.
> When I return some paths to the SAN device, all ios resume, both ios
> to that device and those unexpectedly blocked.
> HBA used is QLE2462, I'm not sure if this happened with 2Gb QLogic
> also.
> 
> Please tell me if this is an expected behavior and if not, how could
> we find a source of the problem and fix it?
> 
> # ps aux | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root      2872  0.0  0.0  10064   748 ?        Ds   21:58   0:00 syslogd -m 0
> root      3800 24.9  0.0  63300  1592 ttyS0    D    22:01   0:22 dd if
> /dev/zero of /dev/mapper/...
> root      3990  0.0  0.0  58020   476 ttyS0    D    22:02   0:00 tail -f /var/log/messages
> 
> Thanks much,
> 
> Maxim.
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
