From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: pthread_cancel and clone weirdness
Date: Mon, 18 Jul 2005 10:19:13 -0500
Message-ID: <20050718151913.GA24376@phlogiston.msp.redhat.com>
References: <20050716143122.GA11187@phlogiston.msp.redhat.com>
	<1121533676.19015.11.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1121533676.19015.11.camel@zezette>
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

On Sat, Jul 16, 2005 at 07:07:56PM +0200, christophe varoqui wrote:
> cvaroqui@zezette:tmp$ ./pthread_test
> cancelling thread
> pthread cancel returned : Success
> joining thread
> pthread_join returned : Success
> child was canceled
> 
> both with and without "#define WORK_CORRECTLY 1" on ubuntu breezy HEAD,
> amd64.
> 
> Will try on Debian Sid/amd64 too, tomorrow.

Thanks.
 
> That said, we may now be able to kill all the clone/prepare_namespace()
> things.
> 
> They were introduced to protect from /sbin/multipath exec failures under
> memory pressure. Now, the daemon doesn't exec multipath anymore, so if
> nobody cares, I'll kill them soon, and go back to pure fork()-based
> daemonization.

I am obviously in favor of removing them.
-Ben

> Regards,
> cvaroqui
> 
> On sam, 2005-07-16 at 09:31 -0500, Benjamin Marzinski wrote:
> > O.k. I finally figured out why pthread_cancel just wasn't working for me,
> > and it has something to do with the clone() call in multipathd. If you
> > fork child(), everything works correctly. If you clone it, pthread_cancel
> > dosn't work on PTHREAD_CANCEL_ASYNCHRONOUS type threads. This makes
> > no sense to me.  Is this supposed to happen??
> > 
> > Could people please try running the attached test program? When I use
> > clone() (WORKS_CORRECTLY set to 0) it hangs. When I use fork()
> > (WORKS_CORRECTLY set to 1) it does exactly what I expect.  This is happening
> > for me on RHEL4. I would be interested in knowing if it happens on other
> > distros.
> > 
> > Thanks
> > -Ben
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> -- 
> christophe varoqui <christophe.varoqui@free.fr>
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
