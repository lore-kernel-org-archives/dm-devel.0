From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: RH 4 and HSG80
Date: Wed, 01 Aug 2007 11:50:24 -0700
Message-ID: <1185994224.17399.102.camel@linuxchandra>
References: <46B09E83.9010503@interactivebrokers.com>
	<OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>
	<20070801175946.GA28302@us.ibm.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070801175946.GA28302@us.ibm.com>
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

On Wed, 2007-08-01 at 10:59 -0700, malahal@us.ibm.com wrote:
> Stefan Bader [Stefan.Bader@de.ibm.com] wrote:
> > I have no access to HSGs but maybe this generic statements (plus some 
> > wisdom from hwtable.c) helps:
> > 
> > First, you are actually forcing multipath-tools to use all paths by 
> > stating "multibus" in you multipath section.
> > Everything you put there will replace the defaults and the device 
> > sections. Just be minimalistic there. In the
> 
> One would expect that whatever is specified in the 'device' section would
> be taken for that device no matter what is in the 'defaults' section. If
> device section is missing, then it should use from the 'defaults'
> section. Why is it implemented to have the 'defaults' section override the
> 'device' section? Looks odd to me.

You are right, Malahal. Defaults section does not override the device
section. It just overrides internal default (hwtable.c).

To my understanding the order of attribute override is as under:

internal default (hwtable.c)
defaults section (in /etc/multipath.conf)
device section   (in /etc/multipath.conf)
multipaths section (in /etc/multipath.conf)

There were two things in Eric's multipath.conf which caused his problems
 - setting multibus as the path grouping policy (in multipaths section) 
   for a device that is active/passive (it should be ideally
    group_by_prio, but group_by_serial also works).
 - using /bin/true as prio_callout. As Stefan pointed prio_callout
   should be an appropriate one for the device.

> Thanks, Malahal.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
