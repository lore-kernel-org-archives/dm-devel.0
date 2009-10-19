From: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>
Subject: Re: memory consumption of multipathd after Upgrade SLES
	=?iso-8859-1?q?10=09SP2?= -> SLES 11
Date: Mon, 19 Oct 2009 09:04:11 +0200
Message-ID: <200910190904.11668.sebastia@l00-bugdead-prods.de>
References: <200910161720.42414.sebastia@l00-bugdead-prods.de>
	<4ADC0453.9010406@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ADC0453.9010406@suse.de>
Content-Disposition: inline
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

Hi,

On Monday 19 October 2009 08:16:51 am Hannes Reinecke wrote:
> Sebastian Reitenbach wrote:
> > Hi,
> >
> > I use multipath tools to manage the multiple ways through the SAN
> > connected via FC. The server sees two paths per LUN. There are 15 LUNs
> > presented to the server.
> >
> > I upgraded two server to SLES 11, installed latest patches, running
> > kernel: Linux server1 2.6.27.29-0.1-xen #1 SMP 2009-08-15 17:53:59 +0200
> > x86_64 x86_64 x86_64 GNU/Linux
> >
> > multipath-tools-0.4.8-40.4.1
> >
> > There I recognized a fairly large amount of memory used by multipathd:
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  5367 root      RT   0  238m 140m 2804 S    0 28.1   0:34.70 multipathd
> >
> > I see the huge memory consumption on both of the servers.
> >
> >
> > On a different server, not yet upgraded, running SLES 10 SP2, with
> > different SAN storages applied, there I run kernel:
> > Linux server2 2.6.16.60-0.34-xen #1 SMP Fri Jan 16 14:59:01 UTC 2009
> > x86_64 x86_64 x86_64 GNU/Linux
> > with multipath tools:
> > multipath-tools-0.4.7-34.40
> > There I have 20 LUNs presented, and the server sees 4 paths per LUN, I in
> > top a much fewer memory consumption:
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  4796 root      RT   0 11928 4808 2220 S    0  1.6   0:01.37 multipathd
> >
> >
> > However, both of the servers running SLES 11 work fine so far, no
> > "errors" recognized. I still wonder whether the large memory consumption
> > is correct, as I expected sth. similar as on the SLES10 SP2 hosts.
> > Below the configuration file I use on the SLES 11 servers.
>
> This is a known regression with SLES11. Please update to the latest
> maintenance release.
I thought I have all available updates installed, need to check, refresh my 
update sources, and see again whether updates are available.

thanks for pointing out
Sebastian
>
> Cheers,
>
> Hannes
