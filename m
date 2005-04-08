From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: curious why waitevent sets event_nr field of
	event_thread struct from kernel every time.
Date: Fri, 8 Apr 2005 09:18:38 +0200
Message-ID: <20050408071838.GA9350@averon.dyndns.org>
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
By the way, I don't know if it's a problem in open-iscsi or IET (or not even a problem), but an admin is currently allowed to --login multiple time on the same record. The kernel allocates disks, but really doesn't like it when one begins using them.

Regards,
cvaroqui
