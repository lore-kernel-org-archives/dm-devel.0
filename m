From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH v2] dm mpath: fix race condition between
 multipath_dtr and pg_init_done
Date: Thu, 31 Oct 2013 15:26:48 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD32827@SACEXCMBX02-PRD.hq.netapp.com>
References: <FB8A412F33166C4A930D37BD63236C902AD3247A@SACEXCMBX02-PRD.hq.netapp.com>
	<11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
	<20131031144811.GA15712@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131031144811.GA15712@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids


> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Thursday, October 31, 2013 9:48 AM
> To: Junichi Nomura; Merla, ShivaKrishna
> Cc: device-mapper development; agk@redhat.com
> Subject: [PATCH v2] dm mpath: fix race condition between multipath_dtr
> and pg_init_done
> 
> On Thu, Oct 31 2013 at  5:03am -0400,
> Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> 
> >
> > Hi,
> >
> > how about moving this to flush_multipath_work(), which is supposed
> > to silence background activities?
> > I.e.
> >   flush_multipath_work() {
> >      <disable pg_init retry>
> >      ...
> >      <enable pg_init retry>
> >   }
> >
> > Then it not only fixes the crash you hit, it also fixes the hidden bug
> > that pg_init continues retrying while the device is suspended.
> 
> I ran with your suggestion.  Please see below.
> 
> To be clear, pg_init isn't disabled while mpath device is suspended
> (meaning m->pg_init_disabled isn't set until the device is resumed).
> But flush_multipath_work() will no longer start pg_init during suspend
> -- which could otherwise occur while the mpath device is suspended.  So
> in practice it accomplishes the stated goal.
> 
> Thanks for the suggestion Junichi.  Are you OK with this?  If so please
> provide your Ack.
> 
> Shiva, can you please verify that this patch resolves the race, should
> accomplish the same: just pushes the disabling of pg_init inside
> flush_multipath_work().

Yes Mike, This looks good. Thanks Junichi for the suggestion.
