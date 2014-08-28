From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Fix access beyond the end of allocated
	space
Date: Thu, 28 Aug 2014 14:40:55 -0400
Message-ID: <20140828184055.GB976@redhat.com>
References: <alpine.LRH.2.02.1408281108120.31317@file01.intranet.prod.int.rdu2.redhat.com>
	<53FF6E1D.10308@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53FF6E1D.10308@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, kkolasa@winsoft.pl, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 28 2014 at  1:59pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:
 
> Thanks for fixing this!
> 
> I tried all reproducers I have and no problems here with your patch.
> (Except another unrelated oops in scsi_debug :-)
> 
> Tested-by: Milan Broz <gmazyland@gmail.com>

I tweaked the header and code-style a bit and staged this fix here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed

Will likely send to Linus tomorrow since I'll be away all next week.
