From: Tore Anderson <tore@linpro.no>
Subject: Re: Experiences with multipath-tools and EMC CLARiiON
Date: Thu, 10 Feb 2005 10:46:01 +0100
Message-ID: <200502101046.01541.tore@linpro.no>
References: <200502091314.56085.tore@linpro.no> <420B255F.8000100@free.fr>
Reply-To: dm-devel@redhat.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
In-Reply-To: <420B255F.8000100@free.fr>
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

* Christophe Varoqui

 > Yes, "sg_start -s /dev/sdb 1" is not an adequate mean to force a
 > host-driven failover for the clariion hardware. You need the
 > trespass tool included in recent sg3_utils package.

  Ohh, I wasn't aware this utility already existed.  I'll try it out as
 soon as I can.  My test box has crashed though and for some reason
 doesn't reach GRUB so I cannot use the serial console to fix it.  :-(
 So I need to take a trip to our colo in order to test more;  I'll try
 to find time to do it today.

  However, before it crashed I found out another way of doing it, which
 seemed to work more predictably.  I was meaning to wait until I could
 do a second test before I sent the report here, but oh well, here goes:

  If I set "failover mode" in Navisphere to be "2", the CLARiiON's
 behaviour changes to automatically migrate/trespass the LU, if one of
 the controllers receives I/O.  With this setup I believe I can use the
 tur path checker and no hardware_handler.

  Now, I also found out that my testing method of removing the
 controllers as members from the test box' zone is a tad suboptimal,
 because even though I remove only one path, both paths are affected in
 a very short period of time.  I discovered this by running sg_turs on
 both paths in a 20ms loop while removing one path - it started hanging
 (probably waiting for some timeout) on the path I actually removed,
 while one sg_turs invocation on the still present path failed with "bus
 has been reset" or some such.  As I do pretty heavy I/O to the LU while
 failing paths, this is probably more than enough for multipathd to
 conclude that both paths are down, and is probably also the reason why
 I need queue_if_no_path to avoid file system corruption.  Had I been
 able to yank fibres instead I can easily imagine that it had worked.

  However, I think there's a genuine bug in multipathd here - after
 having failed both paths it never recovers them.  They get stuck as
 failed seemingly forever, even though it logs that it's checking paths,
 and in spite of the fact that one of the paths only were failed in a
 split second.  sg_turs towards this path runs OK also.  However, if I
 restart multipathd manually, it rediscovers the path immediately and
 start sending I/O to it.  So it seeems to me that something's not quite
 right with multipathd here - I'll be happy to provide any more info you
 need if you agree.  If this issue is solved I'd say it's quite usable
 for production, if it also passes a few lenghty stability tests of
 course.

  There's a few snags to running the CLARiiON like this, though.  If I
 trespass the LU in the Navisphere interface, it is immediately moved
 back to the controller it was on, because multipathd is sending I/O
 there (trespassing doesn't fail the path).  Also, initiating a trespass
 from the host (can be done by simply attempting to read the partition
 table or something on the inactive path) yields the same result.  I
 don't know if the CLARiiON sends some hint down the fibre that the LU
 has been migrated, but if it does, it's ignored.  I'm guessing, but
 using the trespass utility you spoke of will probably also just be a
 no-op if I am to continue using this automatic trespass mode.

  This is no big deal for me though, however I would really like to find
 out how to make multipathd's affection for the first controller (or the
 sd* with the lowest minor, possibly) go away so that I can distribute
 LUs between the controllers manually.  That's not very important if I
 only have a few connected systems with multipath-tools (as PowerPath
 heeds what controller I set as the default LU owner in Navisphere), but
 if I am to replace PowerPath with multipath-tools on all connected
 systems (something I would very very very much like to do :-), this is
 a blocker, I'm afraid.

Thanks,
-- 
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
