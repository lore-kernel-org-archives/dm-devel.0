From: christophe.varoqui@free.fr
Subject: Re: Memory leak in multipathd.
Date: Mon, 11 May 2009 23:43:48 +0200 (CEST)
Message-ID: <968759065.6756991242078228723.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <1055152916.6756351242077998524.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1055152916.6756351242077998524.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Harikrishnan Padidakul <hpadidakul@inmage.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> I was testing multipath with more than 3000paths, I found multipathd using around 2.3GB of memory. 
> After closely digging the code, I found In function dm_get_name() we are calling dm_get_maps() which will allocate memory for mmp. 
> But we are not freeing the same after search is done. 
> I have made a fix by calling free_multipath() ,w ith this fix multipathd is using less than 200MB of memory. 

Hi Hari,

are you reporting on the upstream multipath-tools code ? I already see multipath vector freeing there ...
