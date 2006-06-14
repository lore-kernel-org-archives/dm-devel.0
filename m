From: Tom Wirschell <dm-devel@wirschell.nl>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Wed, 14 Jun 2006 09:42:36 +0200
Message-ID: <20060614094236.492bab33@localhost>
References: <20060613235316.7f982af7@localhost>
	<20060614035801.GA24236@tik.ee.ethz.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060614035801.GA24236@tik.ee.ethz.ch>
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

On 14 Jun 2006, Arno Wagner wrote:
> 
> WD drives are misdesigned in some way that they need sometimes
> very long to respond to commands. I think it is a quality issue.
> WD itself has "RAID ready" drives that don't do this. 
> 
> I have run TB sized arrays of Seagate and Maxtor drives with
> Linux software RAID for years now and never, ever had this issue.
> My advice is to dump the WD drives and get others.

I was _really_ hoping it wouldn't have to come to that.

But I honestly don't get it. If the drives behave when accessed
individually, what is it that software raid does so differently that
makes them act like this?

Kind regards,

Tom Wirschell
