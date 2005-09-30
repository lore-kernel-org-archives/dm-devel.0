From: Brad Dameron <brad@seatab.com>
Subject: Re: multipath tools 0.4.5 bug?
Date: Thu, 29 Sep 2005 17:14:02 -0700
Message-ID: <1128039243.18402.5.camel@dhcpc226.office.pivotlink.com>
References: <1128035309.16902.11.camel@dhcpc226.office.pivotlink.com>
	<1128036198.6536.51.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128036198.6536.51.camel@zezette>
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

On Fri, 2005-09-30 at 01:23 +0200, Christophe Varoqui wrote:
> On jeu, 2005-09-29 at 16:08 -0700, Brad Dameron wrote:
> 
> > defaults {
> >         multipath_tool  "/sbin/multipath -v0"
> >         udev_dir        /dev
> >         polling_interval 10
> > #       default_selector        "round-robin 1"
> >         default_path_grouping_policy    multibus
> >         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
> >         default_prio_callout    "/bin/true"
> >         default_features        "0"
> >         rr_min_io               100
> >         rr_weight               priorities
> > }
> > 
> 
> > Am I doing something wrong for round-robin to work? This is a Qlogic
> > Dual Port 2300 card with both ports connected to a Sun A5200. Any help
> > appreciated.
> > 
> "round-robin 0" is the *only* choice for now.
> Where did you get this bogus template configlet ?
> 
> Regards,
> cvaroqui
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

So how can I do load balancing over both path's? Please tell me this is
possible.

And this config template is the top part of the multipath.conf.synthetic
or whatever it is called.

Brad Dameron
SeaTab Software
www.seatab.com
