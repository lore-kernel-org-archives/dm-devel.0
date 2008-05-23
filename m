From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 12:36:12 +0200
Message-ID: <000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>
	<4836798F.4060100@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4836798F.4060100@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

* Tore Anderson
> 4) with my configuration:
> 
>         device {
>                 vendor                  DGC
>                 product                 *
>                 product_blacklist       LUNZ
>                 path_grouping_policy    group_by_prio
>                 path_checker            tur
>                 no_path_retry           queue
>                 prio_callout            "/sbin/mpath_prio_emc /dev/%n"
>                 failback                immediate
>         }

Red Hat 4.6 defaults for EMC are:
       device {
               vendor                  "DGC"
               product                 "*"
               bl_product              "LUNZ"
               path_grouping_policy    group_by_prio
               getuid_callout          "/sbin/scsi_id -g -u -s"
               prio_callout            "/sbin/mpath_prio_emc /dev/%n"
               hardware_handler        "1 emc"
               features                "1 queue_if_no_path"
               path_checker            emc_clariion
               failback                immediate
       }
(from  /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults)
Why do you use different settings? Are they not "optimal"?

--
DV
