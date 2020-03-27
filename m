From: Brian McCullough <bdmc@bdmcc-us.com>
Subject: Re: storage-logger: Recording changes to the udev
 database
Date: Thu, 26 Mar 2020 20:32:24 -0400
Message-ID: <20200327003224.GB3078@bdmcc-us.com>
References: <20200326233144.GM17504@agk-dp.fab.redhat.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <20200326233144.GM17504@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
Content-Disposition: inline
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 26, 2020 at 11:31:45PM +0000, Alasdair G Kergon wrote:
> I'm experimenting with ways of recording changes to the udev database so
> you can look back at the history of the storage stack on a particular
> machine.  This is still a work-in-progress, but it's reached a point
> where I'd like more people to try it out.
> 
> I've written a shell script that records data related to storage uevents
> in the system journal and a perl script that helps you to interrogate
> this data later to create a representation of the storage components.
> 
> If you're interested, please try this out and let me know if you think
> pursing this approach further would lead to something that you would
> use and distributions should ship.


Alasdair,

I have downloaded and installed in a Debian 9 environment.

There are a couple of differences that I have seen so far.

First, most importantly, the udev rules are in /etc/udev/rules.d.

Secondly, it appears that the journalctl command does not like the
output fields option.

I will install this on another machine that has a bit more device
activity, and comment later.


Brian


 
  
> Alasdair
> -- 
> agk@redhat.com
> 
> _______________________________________________
> linux-lvm mailing list
> linux-lvm@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-lvm
> read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
> 


_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
