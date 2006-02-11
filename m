From: "Thomas S. Iversen" <zensonic@zensonic.dk>
Subject: dm-bde
Date: Sat, 11 Feb 2006 16:18:07 +0100
Message-ID: <200602111618.07949.zensonic@zensonic.dk>
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

Hi There

As a part of my education I have ported FreeBSDs Geom Based Device Encryption 
system to Linux. It is implemented as a Devicemapper module. It works but has 
some bugs. My question now is, what kind of state should the code be in in 
order for somebody to pick it up? I can read and write GBDE devices, but

1. If the device is over 4GB and constructed on the opposite system (FreeBSD 
vs. LInux), it will not work. Devices over 4GB constructed on the same OS 
works fine.
2. It is not threadsafe and I cant figure out why.
3. It has the same readspeed as FreeBSD, but (somewhat) slower write speed in 
comparison.

Regards 
Thomas, Denmark
-- 
In the 60's people took acid to make the world weird. Now the world is weird, 
people take prozac to make it normal.
