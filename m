From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Question about Multibus+Failover
Date: Tue, 06 Dec 2005 22:41:47 +0100
Message-ID: <1133905307.5650.23.camel@zezette>
References: <4395F683.1000900@redhat.com> <1133903711.5650.17.camel@zezette>
	<4395FE5A.7020300@redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4395FE5A.7020300@redhat.com>
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
> >
> Hmm, then perhaps I've been seeing errant behavior, b/c everytime 
> somebody uses multibus and they fail a path they get a bunch of IO 
> errors and the FS is remounted, but if they use failover and pull the 
> active connection, there are no errors and the failover is seamless.  I 
> shall investigate further on what they are seeing.  Thank you,
> 
May be because they use hardware that needs a hardware handler ?
The hwh trigger needs different path group, thus not compatible with
multibus.

Regards,
cvaroqui
