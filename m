From: Mindaugas Riauba <ml@kilimas.com>
Subject: Problem with multipath
Date: Thu, 9 Jan 2014 08:39:42 +0200
Message-ID: <CADpTdPQmGB9-PvLciGHdLeBa6D4CACMT=UxmyLWQLa4xMXe6OA@mail.gmail.com>
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

  Hello,

  I have a strange problem with multipath on several OEL 6.x servers.
One multipath map is not being setup. What is strange - after reboot
problematic map changes. Previously problem went away after reboot or
two but now I did like 10+ reboots and nothing changed.
  Symptoms are the following:

# echo "show paths" | multipathd -k | fgrep orphan
1:0:5:142 sdbh 67:176 10  undef  ready  running orphan
1:0:2:142 sdad 65:208 130 undef  ready  running orphan
1:0:1:142 sdr  65:16  10  undef  ready  running orphan
2:0:0:142 sdbt 68:112 130 undef  ready  running orphan
2:0:2:142 sdco 69:192 130 undef  ready  running orphan
2:0:5:142 sdds 71:160 10  undef  ready  running orphan

# multipath -v2
Jan 09 08:01:38 | mpatht: ignoring map
Jan 09 08:01:38 | mpatht: ignoring map
Jan 09 08:01:38 | mpatht: ignoring map
Jan 09 08:01:38 | mpatht: ignoring map
Jan 09 08:01:38 | mpatht: ignoring map
Jan 09 08:01:38 | mpatht: ignoring map

  Each LUN has 6 paths so those are 6 paths for one LUN.

  "multipath -v3" output: http://pastebin.com/10WRGvNj
  /etc/multipath.conf: http://pastebin.com/DcremRUh

  Currently kernel is 2.6.39-400.212.1.el6uek.x86_64 but problem
exists also with non-UEK kernels (2.6.32-431.3.1.el6.x86_64). dmesg or
messages do not show any core dumps or similar stuff. Also I tried
with "user_friendly_names no" with the same problem.

  Server has 18 LUNs in total from two storages - 2x EMC Clariion
CX4-480. Problematic LUN may happen from either of them. All LUNs do
not have partitions.

  Regards,
  Mindaugas
