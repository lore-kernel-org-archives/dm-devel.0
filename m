From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 15 Mar 2005 15:51:04 -0800
Message-ID: <1110930664.3584.32.camel@mylaptop>
References: <1110657791.16560.11.camel@mylaptop>
	<1110926912.10694.41.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <1110926912.10694.41.camel@zezette>
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
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
List-Id: dm-devel.ids

On Tue, 2005-03-15 at 23:48 +0100, christophe varoqui wrote:
> On sam, 2005-03-12 at 12:03 -0800, Dmitry Yusupov wrote:
> > Hi Guys!
> > 
> > had anyone tried to setup open-iscsi with dm-multipath yet?
> > I think it should work out of the box, but would be cool if someone will
> > double check on that.
> > 
> > PS: www.open-iscsi.org is a new cool project which features some
> > noticeable performance improvements for soft-based iSCSI Initiator plus
> > other number of exciting abilities such as independent transport and
> > better user-space vs. kernel split. Read more on project's web page.
> > 
> I tried on Monday, but I'm stuck before dm-multipath kicks into play.
> Build runs ok, modules load into the kernel, daemon starts up, but the
> admin tool remain desparetely silent to all commands I stuffed at it.
> 
> What is even more weird is that the daemon (in debug mode) remains
> silent too.

it easily could be a bug in open-iscsi. We just released new bits, some
of the issues got fixed since than. Would be cool, if you could give it
one more try. Kernel requirement changed since than as well. Now you
will need kernel >= 2.6.11 because of a bug in netlink interface.

Thanks!
Dima

> The target side works well : IET verified with Cisco initiator.
> 
> Regards,
