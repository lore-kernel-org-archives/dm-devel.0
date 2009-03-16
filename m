From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] set pthread stack size to at
	least	PTHREAD_STACK_MIN
Date: Mon, 16 Mar 2009 17:12:57 +0100
Message-ID: <49BE7A89.1040808@suse.de>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>	<49BA3ACF.1010101@suse.de>
	<20090313205514.GL32340@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090313205514.GL32340@ether.msp.redhat.com>
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

Benjamin Marzinski wrote:
[ .. ]
>=20
> This approach doesn't doesn't actually fix the bug that I see. The
> problem I was seeing is that setting the stacksize too small just cause=
s
> pthread_attr_setstacksize() to fail, leaving you with the default stack
> size. On some architectures, the default stacksize is large, like 10Mb.
> Since you start one waiter thread per multipath device, every 100
> devices eats up 1Gb of memory. Your approach always uses the default
> stack size, unless it's too small.  I've never seen problems with the
> stack being too small. Only too large. Maybe your experience has been
> different.
>=20
Me neither. Makes me wonder if we _really_ need to set the stacksize.
After all, I'm not aware that we're having any excessive stack usage
somewhere. Maybe we can simplify it by removing the stack attribute
setting altogether?

I'll see if I can get the different stacksizes and just compare them
to the 'updated' setting. Maybe there's no big difference after all...

> The other problem is that when I actually read the pthread_attr_init ma=
n
> page (it can fail. who knew?), I saw that it can fail with ENOMEM. Also=
,
> that it had a function to free it, and that the result of reinitializin=
g
> an attr that hadn't been freed was undefined.  Clearly, this function
> wasn't intended to be called over and over without ever freeing the
> attr, which is how we've been using it in multipathd. So, in the spirit
> of writing code to the interface, instead of to how it appears to be
> currently implemented, how about this.
Hmm. You're not freeing the attribute for all non-logging threads neither=
.
Oversight?=20

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
