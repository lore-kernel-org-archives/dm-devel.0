From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Wed, 16 Nov 2011 11:56:32 +0100
Message-ID: <CAG2kNCyCF=OcmqQudtzXH32oP+4RX_wwszECU0R8S1HMWWVJzg@mail.gmail.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
	<1321389505.23295.4.camel@lapoo.opensvc.com>
	<CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

In the mean time, while waiting for further answers, I successfully
tested the failover group policy config
My way of proceedings was this, hope correct.
I didn't find any mention of IBM 1814 in multipath.conf.annotated...
I did find inside it
#defaults {
...
#       # name    : path_grouping_policy
#       # scope   : multipath
#       # desc    : the default path grouping policy to apply to unspecified
#       #           multipaths
#       # values  : failover           = 1 path per priority group
#       #           multibus           = all valid paths in 1 priority group
#       #           group_by_serial    = 1 priority group per detected serial
#       #                                number
#       #           group_by_prio      = 1 priority group per path priority
#       #                                value
#       #           group_by_node_name = 1 priority group per target node name
#       # default : failover
#       #
#       path_grouping_policy    multibus

this seemed a bit misleading because it is not clear to me if the
default then would be multibus or failover...

Setting failover as the group policy inside the defaults {} section of
multipath.conf didn't work.
defaults {
        user_friendly_names yes
        path_grouping_policy failover
}

.. probably overwritten by device itself config default?

Anyway I tried another "path"

# multipahd -k
multipathd> show config
...
found now IBM 1814 inside the output with these specs (donna if would
have found a similar result in a more general section in
multipath.conf.annotated ...)

#devices {
#        device {
#                vendor "IBM"
#                product "1814"
#                path_grouping_policy group_by_prio
#                getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
#                path_selector "round-robin 0"
#                path_checker rdac
#                features "0"
#                hardware_handler "1 rdac"
#                prio_callout "/sbin/mpath_prio_rdac /dev/%n"
#                failback immediate
#                rr_weight uniform
#                no_path_retry queue
#                rr_min_io 1000
#        }
#

So I wanted only to change the path_grouping_policy parameter and I
set this in my multipath.conf


devices {
        device {
                vendor "IBM"
                product "1814"
                path_grouping_policy failover
        }

}

Then
# multipath -v2 -d
and then committed (after deactivating fs and VG, donna if necessary...) with
# multipath -v2

Now I have indeed:
# multipath -l
mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
[size=3.4T][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:0:1 sdb 8:16  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 4:0:0:1 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:1:1 sdd 8:48  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 4:0:1:1 sde 8:64  [active][undef]

Tried this command
# time dd if=/dev/zero of=testfile2 bs=1024k count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 651.872 seconds, 165 MB/s

real	10m51.934s
user	0m0.048s
sys	3m41.549s

And iostat confirmed only sdb was used during I/O operation
I got about 5% performance gain, as yesterday
# time dd if=/dev/zero of=testfile bs=1024k count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 686.96 seconds, 156 MB/s

real	11m27.010s
user	0m0.070s
sys	3m33.813s

But it could also be related to different I/O going through the DS4700 today.

BTW: I would expect "multipathd -k" --> show config to be updated
after changing the policy, but it continues to give
path_grouping_policy group_by_prio
for the IBM 1814
Probably it is a static display... any way to show the current one
with this command?

Sorry for the many answers... probably more targeted at dm-user ml...

Gianluca
