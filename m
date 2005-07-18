From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: pthread_cancel and clone weirdness
Date: Mon, 18 Jul 2005 21:07:31 +0200
Message-ID: <1121713651.19015.40.camel@zezette>
References: <20050716143122.GA11187@phlogiston.msp.redhat.com>
	<1121533676.19015.11.camel@zezette>
	<20050718151913.GA24376@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050718151913.GA24376@phlogiston.msp.redhat.com>
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

On lun, 2005-07-18 at 10:19 -0500, Benjamin Marzinski wrote:
> On Sat, Jul 16, 2005 at 07:07:56PM +0200, christophe varoqui wrote:
> > cvaroqui@zezette:tmp$ ./pthread_test
> > cancelling thread
> > pthread cancel returned : Success
> > joining thread
> > pthread_join returned : Success
> > child was canceled
> > 
> > both with and without "#define WORK_CORRECTLY 1" on ubuntu breezy HEAD,
> > amd64.
> > 
> > Will try on Debian Sid/amd64 too, tomorrow.
> 
Debian SID/amd64 fails without "#define WORK_CORRECTLY 1" set :

xa-s05:/tmp# ./pthread_test
cancelling thread
pthread cancel returned : No such process
joining thread
[hang till sigterm]

Works fine with the define.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
