From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: curious why waitevent sets event_nr field of
	event_thread struct from kernel every time.
Date: Tue, 29 Mar 2005 23:33:22 -0800
Message-ID: <1112168002.8549.7.camel@mylaptop>
References: <C2EEB4E538D3DC48BF57F391F422779321A883@SRMANNING.eng.emc.com>
	<1112135471.10635.41.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112135471.10635.41.camel@zezette>
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

On Wed, 2005-03-30 at 00:31 +0200, christophe varoqui wrote:
> On mar, 2005-03-29 at 17:15 -0500, goggin, edward wrote:
> > The multipathd from 0.4.4-pre4 has died a 3 more times.
> > I am still not sure what's up here.
> > 
> Certainly in the logger code, which is very fresh and hard to debug.
> Help appreciated here, as my brain kind of melted during the
> code-give-birth :/

btw, thanks for the logger. I think it could be useful outside of dm-
devel as well.

I'll try to find some time to adopt your logger for open-iscsi project.
probably next week.

Thanks!
Dmitry
