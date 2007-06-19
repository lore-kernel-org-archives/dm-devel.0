From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Device mapper devices not created before fsck at boot
Date: Tue, 19 Jun 2007 17:45:37 -0400
Message-ID: <46784E81.5040503@cfl.rr.com>
References: <20070619181216.6671.qmail@sourceware.org>
	<500DD6DE2DFA8E40A33E5898D9471B9702268C21@ASHEVS006.mcilink.com>
Reply-To: Phillip Susi <psusi@cfl.rr.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <500DD6DE2DFA8E40A33E5898D9471B9702268C21@ASHEVS006.mcilink.com>
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

Wilson, Christopher J wrote:
> I have a system(s) which is failing to fsck /dev/mapper/<wwn> devices
> during boot time.  The dev-mapper devices are not created from the time
> dmsetup is run in rc.sysinit until the device fsck is run (next block).
> The only device in /dev/mapper is /dev/mapper/control, none of the <wwn>
> devices exist before fsck attempts to run.  I have put in a "sleep 10"
> in between the two code blocks and this has worked on one system and not
> others.  
<snip>

If you intend to make a new post, please make a new post; do not reply 
to an existing message, change the subject line, and delete all quotes. 
  Doing this causes the message to show up as part of the thread you 
replied to, which may case people to never see it if they are ignoring 
that thread, and confuses people when they see your completely unrelated 
message when they are reading the original thread and are expecting the 
discussion to remain on the same topic.
