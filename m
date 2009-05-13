From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: no_path_retry configurable per device basis?
Date: Wed, 13 May 2009 17:51:27 +0200
Message-ID: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,
I post here because I don't find any dm-users mailing list...
please suggest any other more correct if present.
I have multipath configured for a 1750500 storage system.
from multipath.conf.defaults I get
#       device {
#               vendor                  "IBM"
#               product                 "1750500"
#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
#               prio_callout            "/sbin/mpath_prio_alua %d"
#               features                "1 queue_if_no_path"
#               hardware_handler        "0"
#               path_grouping_policy    group_by_prio
#               failback                immediate
#               rr_weight               uniform
#               rr_min_io               1000
#               path_checker            tur
#       }

Mixing with what suggested by IBM I set this in my mutipath.conf
defaults {
        user_friendly_names yes
        polling_interval 30
        rr_min_io 100
}

Now, among the disks managed by device-mapper-multipath there is a
quorum disk for a red hat cluster of which this host is part.
In documentation (http://kbase.redhat.com/faq/docs/DOC-2882) I have
this regarding no_path_retry parameter:

Using 'queue' is not recommended for a multipathed qdisk.

But my storage configuration
features                "1 queue_if_no_path"
is equivalent to no_path_retry queue" .......
correct?
In this case, reading multipath.conf.annotated it seems I can set
no_path_retry per device and so I put this in my multipath.conf
(mpath6 is the quorum disk):

        multipath {
                wwid                    3600507630efe0b0c0000000000000610
                alias                   mpath6
                no_path_retry           3
        }

but, also with a reboot, I get
multipath -l

[snip]
mpath6 (3600507630efe0b0c0000000000000610) dm-12 IBM,1750500
[size=1.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:1:12 sday 67:32  [active][undef]
 \_ 0:0:1:12 sdaz 67:48  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:12 sdy  65:128 [active][undef]
 \_ 0:0:0:12 sdz  65:144 [active][undef]
mpath12 (3600507630efe0b0c0000000000000705) dm-11 IBM,1750500
[size=10G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:11 sdv  65:80  [active][undef]
 \_ 0:0:0:11 sdx  65:112 [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:11 sdaw 67:0   [active][undef]
 \_ 0:0:1:11 sdax 67:16  [active][undef]
[snip]

Is it a bug in my understanding the docs or the docs themselves or the sw part?
Or do I have to unset the parameter from the storage part and set it
for every device (queue for all disk except the quorum one)?
Version is device-mapper-multipath-0.4.7-23.el5_3.4
Thanks in advance,
Gianluca
