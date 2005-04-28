From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: what is the current utility in testing active pat
	hs from multipathd?
Date: Fri, 29 Apr 2005 01:48:47 +0200
Message-ID: <1114732128.10504.20.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A95C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A95C@SRMANNING.eng.emc.com>
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

Feature added in 0.4.5-pre2 : now multipathd checkers proactively
fail_path upon up -> down transitions.

It won't appear on ftp before tomorrow, as I suddenly lost my dev shell
at osdl because of a server move (planned, /me stupid)

This enhancement request wasn't ignored, just pushed after the "great
stabilization" (which is now I guess)

Regards,
cvaroqui

On jeu, 2005-04-28 at 15:45 -0400, goggin, edward wrote:
> On Wed, 27 Apr 2005 12:27:32 -0400, "goggin, edward" wrote:
> 
> > Although I know it sounds a bit radical and counter intuitive,
> > but I'm not sure of the utility gained in the current multipathing
> > implementation by multipathd periodically testing paths which
> > are known to be in an active state in the multipath target driver.
> > Possibly someone can convince me otherwise.
> 
> ... (added to save space)
> 
> > Furthermore, while the checkloop function reacts immediately
> > to a multipathd state transition of failed to active, the code
> > appears little interested (other than updating the multipathd
> > path state to failed) in the case where the multipathd path
> > state changes from active to failed.
> 
> >From the content and volume of the negative feedback to my proposal,
> it is clear to me that I did a horrible job presenting my point.  It
> seems that no one paid any attention to the second paragraph above
> nor to the fact that multipathd has NEVER (as far back as 01-04-2005
> anyway) failed path state in the kernel when one of its path tests
> failed.  I've pushed for this in the past several times on dm-devel,
> as far back as February.  I stopped pushing when the idea was
> rejected/ignored!
> 
> My email yesterday was simply questioning why even test active paths
> if we do nothing with the result of the test.
> 
> I was not saying that we shouldn't test active paths.  Clearly, this
> is a good thing to do and the current code is only a first pass
> implementation of what could be done.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
