From: Philipp Niemann <niemann@dimdi.de>
Subject: Re: Multipathing hints request
Date: Fri, 22 Jul 2005 10:37:22 +0200
Message-ID: <20050722083722.GJ4240@pan.dimdi.de>
References: <20050721143110.GD4240@pan.dimdi.de>
	<1121970687.19015.78.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1121970687.19015.78.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello again!

On Thu, 21.07.2005-20:31:27 +0200, christophe varoqui wrote:
> On jeu, 2005-07-21 at 16:31 +0200, Philipp Niemann wrote:
[...]
> > 360060160200161a06215f38ffbb2d6e9
> > [size=20 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [enabled][first]
> >   \_ 6:0:1:0 sdd  8:48    [faulty][active]
> >   \_ 7:0:0:0 sdf  8:80    [ready ][active]
> > 
> > 
> > I think this doesn't look too bad. Ready/Faulty match the default owner for the
> > LUN on the Clariion. I am able to create a filesystem say on
> > 360060160200161a037f90d75dfca84f7, which might appear as dm-4 in /proc/partitions
> > 
> It does *not* look good. You ought to have 2 paths group per multipath.
> One for active paths, the other for inactive paths. As you'll see this
> is why the failover does not work for you.

Thanks!
Now it looks different. Think I got what you meant. Or didn't I?
Mostly I changed the config file to contain a multipath section. See
below.

416L3 (360060160200161a037f90d75dfca84f7)
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
  \_ 6:0:1:1 sde  8:64    [faulty][active]
\_ round-robin 0 [enabled][first]
  \_ 7:0:0:1 sdg  8:96    [ready ][active]

> >     BTW: Anyone to know what "hwhandler" tells me? Can I change it? Same for
> >         "features".
> 
> The "hardware handler" is an optional additional kernel module used to
> trigger a specific operation when a new Path Group get activated. This
> is how the host will ask your Clariion controler to activate the
> inactive paths, for example.
> 
> So yes, you need hwhandler="1 emc". "0" meaning no hwhandler at all.

As you see above, I didn't manage that yet. Snip of the config that
produces the above:

multipaths {
        multipath {
                wwid                    360060160200161a037f90d75dfca84f7
                alias                   416L3
                path_grouping_policy    failover
                path_selector           "round-robin 0"
                features                "0"
                hardware_handler        "1 emc"
        }
}

Is that syntax correct? I don't get the activation of the second path.
Is it the release? Should I upgrade from 0.4.2.3? I'd pefer to keep the
debian package for simplicity and I didn't find anything sounding
important in ChangeLog.

Regards,
Philipp
-- 
Philipp Niemann                                       DIMDI
Abteilung D / AG D4
Peripherie / UNIX-Systembetreuer     Waisenhausgasse 36-38a
Tel. : 0221/4724-281                            50676 Koeln
