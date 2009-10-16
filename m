From: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>
Subject: memory consumption of multipathd after Upgrade SLES 10
	SP2 -> SLES 11
Date: Fri, 16 Oct 2009 17:20:42 +0200
Message-ID: <200910161720.42414.sebastia@l00-bugdead-prods.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I use multipath tools to manage the multiple ways through the SAN connected 
via FC. The server sees two paths per LUN. There are 15 LUNs presented to the 
server.

I upgraded two server to SLES 11, installed latest patches, running kernel:
Linux server1 2.6.27.29-0.1-xen #1 SMP 2009-08-15 17:53:59 +0200 x86_64 x86_64 
x86_64 GNU/Linux

multipath-tools-0.4.8-40.4.1

There I recognized a fairly large amount of memory used by multipathd:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5367 root      RT   0  238m 140m 2804 S    0 28.1   0:34.70 multipathd

I see the huge memory consumption on both of the servers. 


On a different server, not yet upgraded, running SLES 10 SP2, with different 
SAN storages applied, there I run kernel:
Linux server2 2.6.16.60-0.34-xen #1 SMP Fri Jan 16 14:59:01 UTC 2009 x86_64 
x86_64 x86_64 GNU/Linux
with multipath tools:
multipath-tools-0.4.7-34.40
There I have 20 LUNs presented, and the server sees 4 paths per LUN, I in top 
a much fewer memory consumption:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4796 root      RT   0 11928 4808 2220 S    0  1.6   0:01.37 multipathd


However, both of the servers running SLES 11 work fine so far, no "errors" 
recognized. I still wonder whether the large memory consumption is correct, as 
I expected sth. similar as on the SLES10 SP2 hosts. 
Below the configuration file I use on the SLES 11 servers.

If I need to provide more information, please let me know.

cheers
Sebastian

/etc/init.d/multipath.conf file on the SLES 11 servers.
defaults {
        udev_dir        /dev
        verbosity       2
        polling_interval 10
        selector        "round-robin 0"
        path_grouping_policy    group_by_serial
        getuid_callout  "/lib/udev/scsi_id -g -u -d /dev/%n"
        path_checker    tur
        rr_min_io       100
        max_fds         8192
        rr_weight       priorities
        failback        immediate
        no_path_retry  fail
        user_friendly_names yes
}

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*|sda"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
blacklist_exceptions {
        devnode "^sda[a-z]+"
}
multipaths {
        multipath {
                wwid                    3600508b4001074ab0000c000014e0000
                alias                   ONE
        }
        multipath {
                wwid                    3600508b4001074ab0000c000014b0000
                alias                   TWO
        }
        multipath {
                wwid                    3600508b4001074ab0000c00001960000
                alias                   THREE
        }
        multipath {
                wwid                    3600508b4001074ab0000c00001be0000
                alias                   FOUR
        }
        multipath {
                wwid                    3600a0b800048b31000000fdc4a0809ff
                alias                   FIVE
        }
        multipath {
                wwid                    3600a0b800048b31000000fb949f9627c
                alias                   SIX
        }
        multipath {
                wwid                    3600a0b800048b31000000fc249f96349
                alias                   SEVEN
        }
        multipath {
                wwid                    3600a0b800048b31000000fbc49f962b0
                alias                   EIGHT
        }
        multipath {
                wwid                    3600a0b800048b31000000fc049f96308
                alias                   NINE
        }
        multipath {
                wwid                    3600508b4001074ab0000c00000a70000
                alias                   TEN
        }
        multipath {
                wwid                    3600a0b800048b310000017c64a48ee34
                alias                   ELEVEN
        }
        multipath {
                wwid                    3600a0b800048b310000017c44a48ec5a
                alias                   TWELVE
        }
        multipath {
                wwid                    3600a0b800048b310000017a04a4058d0
                alias                   THIRTEEN
        }
        multipath {
                wwid                    3600a0b800048b3100000179d4a40589e
                alias                   FOURTEEN
        }
        multipath {
                wwid                    3600a0b800048b310000017c94a48ee57
                alias                   FIVETEEN
        }
}
