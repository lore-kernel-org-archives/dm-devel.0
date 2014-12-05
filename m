From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 13:02:39 +0000
Message-ID: <20141205130239.GC16315@localhost.localdomain>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
	<CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>
List-Id: dm-devel.ids

On Fri, Dec 05, 2014 at 04:38:56PM +0400, Vasiliy Tolstov wrote:
> 2014-12-05 15:25 GMT+03:00 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> > Hello. Does the somebody create scheduler for raid1 to add ability to
> > read data from all devices, for example i need to read from all
> > devices when have sequential read.
> 
> 
> I found patches in 2012 from Robert Collins, [dm-devel] Load balancing
> reads on dmraid1 (and 01) arrays
> why it not merged , does dm devel devs have plans to round-robin raid1
> reading operations ?

iirc the patches showed no measurable performance gain.

Regards,
Bryn.
 
