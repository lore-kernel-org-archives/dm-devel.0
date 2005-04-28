From: "goggin, edward" <egoggin@emc.com>
Subject: Re: what is the current utility in testing active pat
	hs from multipathd?
Date: Thu, 28 Apr 2005 15:45:09 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A95C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 27 Apr 2005 12:27:32 -0400, "goggin, edward" wrote:

> Although I know it sounds a bit radical and counter intuitive,
> but I'm not sure of the utility gained in the current multipathing
> implementation by multipathd periodically testing paths which
> are known to be in an active state in the multipath target driver.
> Possibly someone can convince me otherwise.

... (added to save space)

> Furthermore, while the checkloop function reacts immediately
> to a multipathd state transition of failed to active, the code
> appears little interested (other than updating the multipathd
> path state to failed) in the case where the multipathd path
> state changes from active to failed.

From the content and volume of the negative feedback to my proposal,
it is clear to me that I did a horrible job presenting my point.  It
seems that no one paid any attention to the second paragraph above
nor to the fact that multipathd has NEVER (as far back as 01-04-2005
anyway) failed path state in the kernel when one of its path tests
failed.  I've pushed for this in the past several times on dm-devel,
as far back as February.  I stopped pushing when the idea was
rejected/ignored!

My email yesterday was simply questioning why even test active paths
if we do nothing with the result of the test.

I was not saying that we shouldn't test active paths.  Clearly, this
is a good thing to do and the current code is only a first pass
implementation of what could be done.
