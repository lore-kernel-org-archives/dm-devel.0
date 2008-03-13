From: David Elliott <david.elliott@shazamteam.com>
Subject: path_checker problems
Date: Thu, 13 Mar 2008 15:36:10 +0000
Message-ID: <47D949EA.9060307@shazamteam.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hello

We're setting up a redhat 5.1 (x86_64) cluster using a winchester 
(infortrend based) storage array (also testing a dothill 2730T with same 
results), brocade switch, and lsilogic dual-port  fibre cards

device-mapper-multipath-0.4.7-12.el5_1.3
2.6.18-53.1.14.el5xen


This is a fairly new setup for us and I wondered if anyone had any ideas 
what might be causing the below problems


1. with readsector0

the path failure (port disabled on switch) is not detected until the 
mptfc_dev_loss_tmo value is reached - which by default is 60 seconds

changing the module options (mptfc_dev_loss_tmo=2) makes it work quickly 
- but I'm not sure this is the correct thing to do, as it seems 
multipath should detect this without requiring the device driver to tell 
it about the path loss

in this setup no io occurs until this timeout is reached

2. with directio

the path change appears to be picked up within seconds without requiring 
the mptfc_dev_loss_tmo change
no change is required to mptfc_dev_loss_tmo to have the failed path 
picked up, but we see this messages constantly in /var/log/messages 
until the path is re-instated

Mar 13 10:01:06 offsan2 multipathd: sdf: directio checker reports path 
is down
Mar 13 10:01:06 offsan2 kernel: sd 0:0:0:3: SCSI error: return code = 
0x00010000
Mar 13 10:01:06 offsan2 kernel: end_request: I/O error, dev sdf, sector 0

# multipath -ll also seems to report the path failure without delay, but 
the command itself doesn't terminate until the default 60 second 
mptfc_dev_loss_tmo timeout is reached

looking at io transfers , although an rsync is constantly running to the 
multipath destination, no data is being transferred, and then we see 
copy problems

[root@offsan1 home]# for f in 1 2 3 4 5 6 7 8;do cp test.tar 
/virtual0/test${f}.tar;done
cp: writing `/virtual0/test4.tar': Input/output error
cp: cannot create regular file `/virtual0/test5.tar': Read-only file system
cp: cannot create regular file `/virtual0/test6.tar': Read-only file system
cp: cannot create regular file `/virtual0/test7.tar': Read-only file system
cp: cannot create regular file `/virtual0/test8.tar': Read-only file system


running multipath commands
- working
[root@offsan1 ~]# multipath -ll
w_qdisk (3600d023000698afb0949f1324710c500) dm-2 WINSYS,FC3458
[size=100M][features=0][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:2:0 sdc 8:32  [active][ready]
 \_ 0:0:2:0 sdi 8:128 [active][ready]
w_virtual0 (3600d023000698afb0949f117e7c0fc00) dm-4 WINSYS,FC3458
[size=136G][features=0][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:2:2 sde 8:64  [active][ready]
 \_ 0:0:2:2 sdk 8:160 [active][ready]

- failed
[root@offsan1 home]# multipath -ll
sdg: checker msg is "directio checker reports path is down"
sdh: checker msg is "directio checker reports path is down"
sdi: checker msg is "directio checker reports path is down"
sdj: checker msg is "directio checker reports path is down"
sdk: checker msg is "directio checker reports path is down"
sdl: checker msg is "directio checker reports path is down"
w_qdisk (3600d023000698afb0949f1324710c500) dm-2 WINSYS,FC3458
[size=100M][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:2:0 sdc 8:32  [active][ready]
 \_ 0:0:2:0 sdi 8:128 [failed][faulty]
w_virtual0 (3600d023000698afb0949f117e7c0fc00) dm-4 WINSYS,FC3458
[size=136G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:2:2 sde 8:64  [active][ready]
 \_ 0:0:2:2 sdk 8:160 [failed][faulty]




3. multipath.conf

using the defaults of
#defaults {
#       udev_dir                /dev
#       polling_interval        10
#       selector                "round-robin 0"
#       path_grouping_policy    multibus
#       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
#       prio_callout            /bin/true
#       path_checker            readsector0
#       rr_min_io               100
#       rr_weight               priorities
#       failback                immediate
#       no_path_retry           fail
#       user_friendly_name      yes
#}

then

devices {
       #device {
       #                vendor  "DotHill"
#               product "R/Evo 2730-2R.*"
                #path_grouping_policy    failover
       #                path_grouping_policy    multibus
        #               no_path_retry           fail
                failback                immediate
       #}
       device {
                vendor  "WINSYS"
                product "FC3458"
                #path_grouping_policy    failover
                path_grouping_policy    multibus
                #polling_interval        10
                no_path_retry           fail
                #path_checker           tur
                #path_checker           readsector0
                path_checker            directio
                failback                immediate
       }
}

This is all fairly new to us here, and any assistance is appreciated

Cheers,
Dave
