From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: curious why waitevent sets event_nr field of
	event_thread struct from kernel every time.
Date: Wed, 30 Mar 2005 10:13:54 +0200
Message-ID: <20050330081354.GA15879@averon.dyndns.org>
References: <C2EEB4E538D3DC48BF57F391F422779321A883@SRMANNING.eng.emc.com>
	<1112135471.10635.41.camel@zezette>
	<1112168002.8549.7.camel@mylaptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1112168002.8549.7.camel@mylaptop>
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

On Tue, Mar 29, 2005 at 11:33:22PM -0800, Dmitry Yusupov wrote:
> On Wed, 2005-03-30 at 00:31 +0200, christophe varoqui wrote:
> > On mar, 2005-03-29 at 17:15 -0500, goggin, edward wrote:
> > > The multipathd from 0.4.4-pre4 has died a 3 more times.
> > > I am still not sure what's up here.
> > > 
> > Certainly in the logger code, which is very fresh and hard to debug.
> > Help appreciated here, as my brain kind of melted during the
> > code-give-birth :/
> 
> btw, thanks for the logger. I think it could be useful outside of dm-
> devel as well.
> 
> I'll try to find some time to adopt your logger for open-iscsi project.
> probably next week.
> 
my pleasure :)

keep in my mind you can forget klibc building with either the pthread wrapper or an ipc wrapper.
maybe fcntl on a tmpfs for locking needs plus socket for signaling might work as a klibc compliant wrapper.

regards,
cvaroqui
