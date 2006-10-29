From: Yonathan Cohen <yonic@voltaire.com>
Subject: FailOver works but FailBack does not.
Date: Sun, 29 Oct 2006 18:14:40 +0200
Message-ID: <4544D370.9010706@Voltaire.COM>
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

Hello.
I am using multipath-tools for sles9 sp3 ( multipath-tools-0.4.5-0.11 )
I am using the following configuration file
defaults {
        polling_interval 5
        udev_dir /dev
        default_path_grouping_policy failover
        rr_weight priorities
        failback                        10
}

devices {
        device {
                vendor                          "DotHill"
                product                         "SANnet II FC"
                getuid_callout           "/sbin/scsi_id -g -u -s /block/%n"
                path_checker            readsector0
                path_selector           "round-robin 0"
                features                        "1 queue_if_no_path"
                hardware_handler        "0"
                failback                        10
        }
}

i got 2 paths lined up to the same lun
pepper:~ # multipath -l
dm names   N
dm table 3600c0ff00000000007c1d167985b4b07  N
dm table 3600c0ff00000000007c1d167985b4b07  N
dm status 3600c0ff00000000007c1d167985b4b07  N
dm info 3600c0ff00000000007c1d167985b4b07  O
3600c0ff00000000007c1d167985b4b07
[size=28 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 4:0:0:0 sda 8:0  [active][ready]
\_ round-robin 0 [enabled]
 \_ 4:1:0:0 sdb 8:16 [active][ready]

failover works great when i fail path 8:0
but when i reactivate it for some reason the deamon does not reinstate it.
only after i invoke
multipath -v 2
do i see the message
reinstate 8:0
which is odd since "multipath -v 2" is suppose to only print topology
can any one please help.
thanks.
