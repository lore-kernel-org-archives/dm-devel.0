From: Tore Anderson <tore@linpro.no>
Subject: Re: order of preference / multipath.conf
Date: Wed, 21 Nov 2007 17:14:53 +0100
Message-ID: <4744597D.1050402@linpro.no>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C9D@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C9D@exch-2003.incipient.waltham>
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

* Paul Cote

> Is the following order of preference accurate? 
> 
>  
> 1) Multipaths section (in /etc/multipath.conf)
> 2) Device section   (in /etc/multipath.conf)
> 3) Defaults section (in /etc/multipath.conf)
> 4) Internal default (hwtable.c)

I think maybe that number 3 and 4 is swapped, but don't take my word for
it.  It should be easy to do some tests and figure it out for yourself
by using the "show config" command inside the "multipathd -k" shell with
a few different configuration files.

Regards
-- 
Tore Anderson
