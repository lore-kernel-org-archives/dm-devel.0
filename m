From: Alex Zeffertt <alex.zeffertt@eu.citrix.com>
Subject: Re: [Fwd: [PATCH] Latest git -master is not compilable]
Date: Mon, 8 Feb 2010 10:01:08 +0000
Message-ID: <4B6FE0E4.7050609@eu.citrix.com>
References: <1265446918.4273.3.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1265446918.4273.3.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "rumcic@gmail.com" <rumcic@gmail.com>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

The lock() macro is defined in libmultipath/lock.h and just invokes 
pthread_mutex_lock() so there'll be no problem replacing the call to lock() with 
a call to pthread_mutex_lock().

In the version I was patching (0.4.7) the macros were used everywhere, but in 
the latest git master it looks like pthread library calls are invoked directly. 
  Please change it if it makes the style more consistent.

Regards,

Alex


Christophe Varoqui wrote:
> Can you confirm the fix from Rumko does not break your ulibc setup ?
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Subject:
> [PATCH] Latest git -master is not compilable
> From:
> Rumko <rumcic@gmail.com>
> Date:
> Fri, 5 Feb 2010 20:02:23 +0000
> To:
> "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
> 
> To:
> "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
> 
> 
> Hi!
> 
> In latest git -master on line 1443 of multipathd/main.c lock() is called on 
> exit_mutex, but since exit_mutex is a pthread_mutex_t, pthread_mutex_lock() 
> is needed.
> 
> Attached is the one-liner patch, tested it on a gentoo machine and seems to be 
> working.
> 
