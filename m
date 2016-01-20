From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache + storage client experiment
Date: Wed, 20 Jan 2016 12:57:13 -0500
Message-ID: <20160120175713.GB15897@redhat.com>
References: <CALU38fe9yDR7=P2eNez0fvgsrBmcY=Q=BvTnC5cPzu-o=MgbzA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALU38fe9yDR7=P2eNez0fvgsrBmcY=Q=BvTnC5cPzu-o=MgbzA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mlody3k ." <mlody3k@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 19 2016 at 11:01am -0500,
mlody3k . <mlody3k@gmail.com> wrote:

> Hi dm developers!
> 
> I'm during the experiment with dm-cache and storage client and I would be
> very grateful if some of You will help me with some of my questions :).
> 
> Simply, I would like to implement the write-through caching in the client
> where:
>  - dm-cache is only responsible to check whether requested data is in the
> cache device (return requested data if hit, ENODATA if miss - do not read
> from origin) - in case of miss, my client will read data from the origin.
>  - dm-cache will write only to the cache device - client will write data to
> the origin.
> 
> Easily, I need to start dm-cache in writethrough mode without determining
> the origin device. More specifically, I need to make two changes in dm code:
>  - Bypass the origin device while writing data
>  - Do not remap the result to the origin device in case of read miss.
> 
> So here's my questions:
>  - Do the similar solution exists?
>  - Do I have to change the policy code or maybe all of this things are
> contained in the target code?
>  - Could someone reproduce the IO path in dm-cache code?

I vaguely recall fielding this type of question before...

DM cache doesn't provide this.  And I'm not aware of any modifications
others have done to approximate what you're asking for.

I'm missing why the origin device driver's access isn't the equivalent
of your "client".  If you need some shim for what is allowed through
this client you'd be better off developing a DM target that provides
this client-based access to the data.  And _not_ modifying dm-cache.
