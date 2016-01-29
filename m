From: Joe Thornber <thornber@redhat.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Fri, 29 Jan 2016 16:05:16 +0000
Message-ID: <20160129160515.GB23215@rh-vpn>
References: <569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
	<20160126161919.GA19606@rh-vpn>
	<CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
	<20160128104405.GA21697@rh-vpn>
	<CAAR726KUTU0Q-hYqXy7BZUke-qb7f_cbUJNrnrwdsiZLxXxLxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAR726KUTU0Q-hYqXy7BZUke-qb7f_cbUJNrnrwdsiZLxXxLxA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 29, 2016 at 07:01:44PM +0800, Dennis Yang wrote:
> I had tried to define MAX_DECS as 1, 16, and 8192, and here is the
> throughput I got.
> When #define MAX_DECS 1, throughput drops from 3.2GB/s to around 800 ~ 950
> MB/s.
> When #define MAX_DECS 16, throughput drops from 3.2GB/s to around 150 ~ 400
> MB/s
> When #define MAX_DECS 8192, the I/O blocks until deletion is done.
> 
> These throughput is gathered by writing to a newly created thin device
> which means lots of provisioning take place. So it seems that the more fine
> grained lock we use here results in the higher throughput. Is there any
> concern if I set MAX_DECS to 1 for production?

Does the time taken to remove the thin device change as you drop it to one?

- Joe
