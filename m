From: Tore Anderson <tore@linpro.no>
Subject: Re: Release Notes of Red Hat 4.6
Date: Fri, 16 Nov 2007 09:39:51 +0100
Message-ID: <473D5757.20801@linpro.no>
References: <000101c8282a$4b8df0b0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000101c8282a$4b8df0b0$cf42e3c1@pitagora.it>
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

* Domenico Viggiani

> I was reading release Notes of Red Hat 4.6 (just released):
> 
> * implicit active-active failover (ALUA) using dm-multipath on EMC
> Clariion storage is now supported
> 
> Can some good soul explain me the consequences of this?

I wrote a bit about ALUA and how it works on the CLARiiON yesterday:

http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4366/focus=4435

I'm not completely sure how it behaves when using the ALUA hardware
handler compared to using no hardware handler, though.  Maybe Hannes
Reinecke can elaborate a bit on that.

Regards
-- 
Tore Anderson
