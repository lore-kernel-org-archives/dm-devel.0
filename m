From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 12:46:13 +0200
Message-ID: <4836A075.9090008@linpro.no>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>	<4836798F.4060100@linpro.no>
	<000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>
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

* Domenico Viggiani

> Red Hat 4.6 defaults for EMC are:
>        device {
>                vendor                  "DGC"
>                product                 "*"
>                bl_product              "LUNZ"
>                path_grouping_policy    group_by_prio
>                getuid_callout          "/sbin/scsi_id -g -u -s"
>                prio_callout            "/sbin/mpath_prio_emc /dev/%n"
>                hardware_handler        "1 emc"
>                features                "1 queue_if_no_path"
>                path_checker            emc_clariion
>                failback                immediate
>        }
> (from  /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults)
> Why do you use different settings? Are they not "optimal"?

These settings are suitable for PNR mode (failover mode 1, where the
passive paths are unable to process I/O - this will show as large
amounts of I/O errors during boot).  When all paths to the currently
active  fail, dm-multipath will instruct the CX to move the volume from
the active controller to the passive one.  This is bad in cluster
environment, where two cluster nodes might have a differing opinion of
which controller should own the volume and you'll end up having a volume
that constantly moves back and forth between controllers.

My settings are better suited for ALUA mode (failover mode 4, all paths
are able to process I/O), especially if the ALUA-specific support in
dm-multipath isn't available due to old kernels or similar.  I sent an
email to the list one hour ago detailing the advantages I see with this
setup.

Unfortunately I have found no way to detect if an array is operating in
ALUA or PNR mode and have dm-multipath automatically apply different
device{} sections based on that.  I have some nodes that are connected
to both my CX3 and an old CX200 (which doesn't support ALUA), and due to
this I need to use PNR mode on the CX3 too, wich kinda sucks.  Time to
get rid of the CX200 I guess.

Regards,
-- 
Tore Anderson
