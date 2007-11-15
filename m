From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Creation of the mpath# devices
Date: Thu, 15 Nov 2007 15:02:45 -0600
Message-ID: <342d47870711151302o68e3172fn92c8c1e323812905@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I guess my problems are never completely eliminated... :)

Setup device-mapper multipathing in RHEL 4
http://kbase.redhat.com/faq/FAQ_51_7170.shtm

Per the above KB, after the multipath daemon is configured and
started, "The multipath -v2 command prints out multipathed paths that
show which devices are multipathed. If the command does not print
anything out, ensure that all SAN connections are set up properly and
the system is multipathed."

# multipath -v2

I get nothing on my server.  Although here's what I do get.

# multipath -l
30690a018f015191a6472441d1500f057
[size=4 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:0 sdc 8:32 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:0 sdb 8:16 [active][ready]

# multipath -v3
--- snipped ---
#
# all paths in cache :
#
30690a018f015191a6472441d1500f057  1:0:1:0 sdb 8:16  [active][ready] EQLOGIC /
30690a018f015191a6472441d1500f057  3:0:0:0 sdc 8:32  [active][ready] EQLOGIC /
hda blacklisted
sda blacklisted
--- snipped ---

What am I missing?  As far as I can tell, I'm following the RHEL KB
perfectly and it's still not working as expected (although now I'm
much farther than before!).

Thanks!
Scott
