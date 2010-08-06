From: tormen <tormen@gmx.net>
Subject: How does dm-raid isw compare to other linux software
 raid solutions (e.g. mdadm)?
Date: Fri, 06 Aug 2010 11:13:03 -0400
Message-ID: <4C5C267F.8040700@gmx.net>
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

 Hi everybody,

It seems that the only way to have Windows and Linux
use the same software RAID would be through dm-raid isw
(for my intel fake hardware raid).
Is this correct or did I miss something?

Are there any (other) advantages using dm-raid isw over
any other linux based software raid solution (e.g. mdadm)?
    E.g. is it faster (speed / throughput)?
    Or more stable?
    Or more powerful?

I tried to google  comparisons of dmraid isw vs. e.g. mdadm
software RAID 0 (stripe), but was not very successful :(

I also wonder why no where on the intel pages they refer to dm-raid isw...
they just mention that there is no linux support.
Only reason I can think of: They don't because dmraid isw is not
developed by them, or ?
I mean they have Linux resources for so many topics. Or did I miss
something?

Thanks a lot for any hint!

tormen
