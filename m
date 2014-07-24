From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 5/5] libmultipath: Accept "*" as a valid
 regular expression
Date: Thu, 24 Jul 2014 17:34:07 +0100
Message-ID: <20140724163407.GD16321@localhost.localdomain>
References: <53C91871.9070402@acm.org> <53C9191C.4070705@acm.org>
	<20140724165559.000076e3@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140724165559.000076e3@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Thu, Jul 24, 2014 at 04:55:59PM +0200, Sebastian Herbszt wrote:
> Bart Van Assche wrote:
> > Inside libmultipath regcomp() is used to compile regular expressions
> > specified in /etc/multipath.conf. Many multipath.conf examples contain
> > 'product_type "*"'. However, "*" is not a valid POSIX regular expression.
> > Hence this patch that changes the regular expression "*" into ".*".
> > 
> Is this change really required? With patch 4 we now get a proper error:
> multipath.conf +14 parsing failed:            vendor "*"
> multipath.conf +15 parsing failed:            product "*"
> error parsing config file
> 
> I think it should be enough to modify the man page to mention vendor/product
> are both regular expressions. This change might also confuse users since this
> automagic "*" to ".*" only applies to the blacklist exceptions.

Agreed; the examples are broken here so let's fix them rather than add magic
parsing that will only come back to confuse people in the future.

Regards,
Bryn.
