From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: how to refresh LV to apply fstrim online
Date: Thu, 20 Oct 2016 13:40:37 +0200
Message-ID: <da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
References: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Gianluca Cecchi <gianluca.cecchi@gmail.com>
List-Id: dm-devel.ids

Dne 20.10.2016 v 10:52 Gianluca Cecchi napsal(a):
> Hello,
> I have a cluster in RH EL 6.5 (I also have a case open fwiw...) where I'm
> using HA-LVM.
> I made an upgrade of the storage array Netappp -> Netapp.
> I was able to do it online without service disruption using pvmove.
> As a side effect the destination storage array reports the target LUN as 100%
> used due to the pvmove operation itself and how it works.
> The LUN is now thin provisioned but it was not when pvmove was executed, and
> running fstrim on the fs gives error
>
> [root@dbatest1 ~]# fstrim /ALM/rdoffline
> fstrim: /ALM/rdoffline: FITRIM ioctl failed: Operation not supported
> [root@dbatest1 ~]#
>
> The fs is on an LV with its PV on a multipath device
>
> [root@dbatest1 ~]# df -h /ALM/rdoffline
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/VG_ALMTEST_RDOF-LV_ALMTEST_RDOF
>                        50G  1.9G   45G   4% /ALM/rdoffline
>
> [root@dbatest1 ~]# pvs|grep VG_ALMTEST_RDOF
>   /dev/mapper/3600a098038303769752b495147377858 VG_ALMTEST_RDOF lvm2 a--
>  50.00g    0
> [root@dbatest1 ~]#
>
> [root@dbatest1 ~]# multipath -l /dev/mapper/3600a098038303769752b495147377858
> 3600a098038303769752b495147377858 dm-40 NETAPP,LUN C-Mode
> size=50G features='4 queue_if_no_path pg_init_retries 50
> retain_attached_hw_handle' hwhandler='1 alua' wp=rw
> `-+- policy='round-robin 0' prio=0 status=active
>   |- 7:0:5:14 sddt 71:176  active undef running
>   `- 8:0:5:14 sdef 128:112 active undef running
> [root@dbatest1 ~]#
>
> At storage array level the LUN appears as 100% used even if it is almost empty
> I found a way to do the fstrim and reclaim space at storage array level, but
> only giving downtime, with this sequence of steps:
>
> 1) rescan single paths of the multipath device
> [root@dbatest1 ~]# for dev in sddt sdef; do echo "1" >
> /sys/block/${dev}/device/rescan; done
>
> 2) restart multipathd daemon
> [root@dbatest1 ~]# service multipathd restart
> ok
> Stopping multipathd daemon:                                [  OK  ]
> Starting multipathd daemon:                                [  OK  ]
> [root@dbatest1 ~]#
>
> 3) disable/enable the cluster service that contains the fs resource where I
> operated 1) and 2)
> [root@dbatest1 ~]# clusvcadm -d ALMTEST
> Local machine disabling service:ALMTEST...Success
>
> [root@dbatest1 ~]# clusvcadm -e ALMTEST
> Local machine trying to enable service:ALMTEST...Success
> service:ALMTEST is now running on icldbatest1
> [root@dbatest1 ~]#
>
> 4) now fstrim works ok
>  [root@dbatest1 ~]# fstrim /ALM/rdoffline
> [root@dbatest1 ~]#
> (it takes about 10-20 seconds, depending on the work it has to do..)
>
> It seems each of the 3 steps is necessary. If I don't execute one of them, I
> keep getting the error.
>
> Is there a way to refresh the LVM part, without disabling the service, that
> corresponds to without deactivating/activating the LV?
>
> I tried the --refresh option but it didn't work.
>

Hi

Please provide listing of all your 'multipath'  leg devices - are
they support TRIM ?
Then 'check' dm device.

See  (and attach)

  grep "" /sys/block/*/queue/discard_granularity


Also make sure you are NOT using 'ext2' filesystem which does not support 
discard on RHEL6 and you are on latest available RHEL6 kernel.


Regards

Zdenek
