From: Martin Wilck <mwilck@suse.com>
Subject: Re: 'multipath add path' returns ok but the path is
 missing in the topology
Date: Wed, 22 Apr 2020 12:05:12 +0200
Message-ID: <086d3e2baae71658539ac7caf634336ea0927c04.camel@suse.com>
References: <CAJX1YtZiGXdZTrGtw8ksP3khRf26jQ7dhBWoEJcGfQQZMGb-gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJX1YtZiGXdZTrGtw8ksP3khRf26jQ7dhBWoEJcGfQQZMGb-gg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@cloud.ionos.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Jinpu Wang <jinpu.wang@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: dm-devel.ids

Hello Gioh,

On Wed, 2020-04-22 at 10:40 +0200, Gioh Kim wrote:
> Hi,
> 
> I would like to report a bug.
> I am using network storage via SRP/SRPT over Infiniband.
> When a new sd device is created by SRP, I execute 'multipathd add
> path
> sdX' command and then a new map device is created automatically.
> 
> I used to use the kernel 4.14 version and had no problem.
> But after upgrading to kernel 4.19, I have a problem that 'multipath
> add path sdX' returns ok but sdX is not included in the topology.
> 
> For example, I ran 'multipath add path sdaj' and 'multipath add path
> sdak' and they returned ok.
> Then I check the topology with 'multipathd show topology' and sdak is
> missing.
> 
> Following is the log message from multipathd daemon.
> I found that
> 1. adding sdaj was done correctly and map
> 3600144f033337cfc3ca5222200196002 and dm-11 was created
> 2. daemon started adding sdak (according to "sdak: add path
> (operator)" message)
> 3. suddenly map dm-11 was removed and created
> 4. adding sdak returned ok but there was no "sdak: path added to
> devmap .." message.  I waited some minutes but it did not show up.
> I guess there would be some corner case for error handling.
> The multipathd might have an error but not return an error.
> 
> 
> <log message>
> multipathd[1920]: sdaj: add path (operator)
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: load table [0
> 2105344 multipath 1 retain_attached_hw_handler 0 1 1 service-time 0 1
> 1 66:48 1]
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: event checker
> started
> multipathd[1920]: sdaj [66:48]: path added to devmap
> 3600144f033337cfc3ca5222200196002
> multipathd[1920]: sdak: add path (operator)
> multipathd[1920]: dm-11: remove map (uevent)
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: stop event
> checker thread (139976177456896)
> multipathd[1920]: dm-11: remove map (uevent)
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: adding map
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: event checker
> started
> multipathd[1920]: 3600144f033337cfc3ca5222200196002: devmap dm-11
> registered
> 
> <multipathd show topology>
> 3600144f033337cfc3ca5222200196002 dm-11 SCST_BIO,e21f6f605c1dfff7
> size=1.0G features='1 retain_attached_hw_handler' hwhandler='0' wp=ro
> `-+- policy='service-time 0' prio=1 status=enabled
> `- 7:0:0:489 sdaj 66:48  active ready running
> 

These logs indicate that multipathd actually successfully added sdak to
the map, so the success return status was correct. The logs provide no
clue why the map was removed and re-added. multipathd seems to have had
just a passive role here. We would need the kernel and udev logs
(udev.log-priority=debug) to see what's actually going on. Also, please
provide your multipath configuration and the version of multipath-tools 
you're using, and logs extending over a long period of time (at least
covering the addition of the new paths).

I'd expect new paths to be added to maps automatically, but that
doesn't seem to happen in your configuration. Are you using
"find_multipaths=strict"? In that case, you should rather use
"multipathd add map "$wwid", or, even better "multipath -a $WWID".

Regards
Martin
