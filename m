From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: curious why waitevent sets event_nr field of
	event_thread struct from kernel every time.
Date: Wed, 30 Mar 2005 00:31:11 +0200
Message-ID: <1112135471.10635.41.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A883@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A883@SRMANNING.eng.emc.com>
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

On mar, 2005-03-29 at 17:15 -0500, goggin, edward wrote:
> The multipathd from 0.4.4-pre4 has died a 3 more times.
> I am still not sure what's up here.
> 
Certainly in the logger code, which is very fresh and hard to debug.
Help appreciated here, as my brain kind of melted during the
code-give-birth :/

> Also, curious why waitevent() always sets the event_nr
> field of the event_thread structure in multipathd to
> the event number value pulled from the kernel for the
> mapped device instead of using the event number
> currently saved in the event_thread structure?
> 
> While I can see getting the number from the kernel the
> first time through the code for each mapped device, I
> think the way it is coded it is possible to lose events.
> 
> I think events can get lost if they occur between the
> time multipath pulls out the kernel path state for the
> affected mapped device for the previously detected event
> and the time that the new waitevent pthread calls waitevent
> for the same mapped device.  Granted, the pthread will
> likely make it first -- but there is nothing in place which
> makes this so.
> 
Have you tried your suggested design ?
Is there a regression at first glance ?

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
