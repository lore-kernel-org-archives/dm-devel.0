From: Adam Chasen <adam@chasen.name>
Subject: [Multipath] Round-robin performance limit
Date: Thu, 28 Apr 2011 11:55:55 -0400
Message-ID: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I am very pleased with the features and even some of the documentation
(once I found the RedHat docs) surrounding the latest .49 multipath
tools.

I would imagine that the multipath driver would attempt to max out the
links available to it, but I am not seeing that behavior. I am unable
to achieve bandwidth greater than the value of one of the four links.
Is this the expected behavior?

It is balancing the traffic between the links and when a path fails
the bandwidth increases proportionately between the remaining links. I
originally thought this may be a problem outside of multipath, but
accessing the devices directly allows me to max out all of my links.

If there is a more appropriate venue for this question, I would
appreciate a redirection.

The current setup is as follows:
* iSCSI with 4 portals with two LUNs defined
* server connected to each portal over 4 Gigabit ports (1 to 1 mapping
of ports) yielding 4 devices for each LUN, 8 devices total

There is one device per LUN per portal connection. Multipathing is
enabled with multibus so the round robin will leverage all (4) devices
available per LUN.

I have experienced the following scenarios. I used dd (reading from
device) and bmon (network interface monitor) for all of these tests.
Note that the bandwidth never exceeds 113MB/s.
* direct (no multipath)
** all links fully saturated
** bandwidth close to theoretical max of the gigabit connection (113MB/s).
* all dvices active (multipath)
** all links equally balanced
** links show 1/4 saturation (~30MB/s)
** bandwidth ~113MB/s
* 3 of 4 devices active (multipath)
** remaining links equally balanced
** remaining links show 1/3 saturation (~40MB/s)
** bandwidth ~113MB/s
* 2 of 4 devices active (multipath)
** active links equally balanced
** active links show 1/2 saturation (~60MB/s)
** bandwidth ~113MB/s
* 1 of 4 devices active (multipath)
** active links equally balanced
** active link shows full saturation (~113MB/s)
** bandwidth ~113MB/s

To ensure that it is not the transport or backing storage, I dd from
the direct device, during the tests where the links were not fully
saturated and I was able to fully saturate the link.

[root@zed ~]# multipath -ll
3600c0ff000111346d473554d01000000 dm-3 DotHill,DH3000
size=1.1T features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 88:0:0:0 sdd 8:48  active ready  running
  |- 86:0:0:0 sdc 8:32  active ready  running
  |- 89:0:0:0 sdg 8:96  active ready  running
  `- 87:0:0:0 sdf 8:80  active ready  running
3600c0ff00011148af973554d01000000 dm-2 DotHill,DH3000
size=1.1T features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 89:0:0:1 sdk 8:160 active ready  running
  |- 88:0:0:1 sdi 8:128 active ready  running
  |- 86:0:0:1 sdh 8:112 active ready  running
  `- 87:0:0:1 sdl 8:176 active ready  running

/etc/multipath.conf
defaults {
        path_grouping_policy    multibus
        rr_min_io 100
}

multipath-tools v0.4.9 (05/33, 2016)
2.6.35.11-2-fl.smp.gcc4.4.x86_64

Thanks,
Adam
