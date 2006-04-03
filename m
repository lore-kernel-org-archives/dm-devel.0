From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: creating partition mappings with different delimiters
Date: Mon, 03 Apr 2006 16:51:46 -0400
Message-ID: <1144097506.3111.81.camel@gator.sc.steeleye.com>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1144081162.3111.32.camel@gator.sc.steeleye.com>
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


I see it is kpartx that is defaulting to the 'p' as the delimiter (in
the set_delimiter function) when the uuid ends with a digit and no
delimiter when the uuid ends with a character.

Wouldn't it be better to always use the same delimiter by default?  As
it stands now one will not be able to determine that a node is a
partition versus a full device by just looking at the name. 

Eddie
On Mon, 2006-04-03 at 12:19 -0400, Eddie Williams wrote:
> Where/how does kpartx determine the default delimiter when creating the
> partition mappings and nodes?
> 
> With Red Hat EL 4 Update 3 during bootup the partition mappings are
> getting created in rc.sysinit.  However I find that some of the mappings
> have no delimiter while some have 'p' as the delimiter.  I prefer 'p' as
> the delimiter.
> 
> I have been unsuccessful at finding where kpartx (or is it dmsetup) is
> determining what delimiter to use.
> 
> Eddie
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
