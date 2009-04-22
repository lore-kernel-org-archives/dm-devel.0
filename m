From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: [PATCH 2/4] multipath-tools: install
	libmultipath.so in $syslibdir
Date: Wed, 22 Apr 2009 22:44:28 +0200
Message-ID: <1240433068.32381.3.camel@plop>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
	<1240006080-27892-3-git-send-email-snitzer@redhat.com>
	<1240179025.25083.2.camel@plop>  <20090419223620.GA9385@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090419223620.GA9385@redhat.com>
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


> > 
> > Mike,
> > am I missing something ... I don't the lib/lib64 switching code.
> 
> The standard install would still just place libmultipath.so in /lib but
> this patch exposes the ability to override the default e.g.:
> make install syslibdir=/lib64 libdir=/lib64/multipath
> 
> The path checker and prioritizer modules would get installed in
> /lib64/multipath and libmultipath.so in /lib64
> 
Oh ok, I was expecting some kind of detection code to set /lib64.
I understand that this approach is sufficient for your packagers needs.

Thanks for explaining.
