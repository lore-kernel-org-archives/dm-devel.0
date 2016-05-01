From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 06/57] Use ALUA for HP 3PAR
Date: Sun, 1 May 2016 23:46:49 +0200
Message-ID: <20160501234649.00006611@localhost>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-7-git-send-email-hare@suse.de>
	<20160429002524.00006f73@localhost> <5722F7EC.2030601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5722F7EC.2030601@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> On 04/29/2016 12:25 AM, Sebastian Herbszt wrote:
> > Hannes Reinecke wrote:
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  libmultipath/hwtable.c | 12 ++++++------
> >>  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > You missed to also change multipath.conf.defaults.
> >  
> >> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> >> index 28ee595..4549268 100644
> >> --- a/libmultipath/hwtable.c
> >> +++ b/libmultipath/hwtable.c
> >> @@ -65,13 +65,13 @@ static struct hwentry default_hw[] = {
> >>  		.vendor        = "3PARdata",
> >>  		.product       = "VV",
> >>  		.features      = DEFAULT_FEATURES,
> >> -		.hwhandler     = DEFAULT_HWHANDLER,
> >> -		.pgpolicy      = MULTIBUS,
> >> -		.pgfailback    = FAILBACK_UNDEF,
> >> +		.hwhandler     = "1 alua",
> >> +		.pgpolicy      = GROUP_BY_PRIO,
> >> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> >>  		.rr_weight     = RR_WEIGHT_NONE,
> >> -		.no_path_retry = NO_PATH_RETRY_UNDEF,
> >> -		.checker_name  = DEFAULT_CHECKER,
> >> -		.prio_name     = DEFAULT_PRIO,
> >> +		.no_path_retry = 18,
> >> +		.checker_name  = TUR,
> >> +		.prio_name     = PRIO_ALUA,
> >>  		.prio_args     = NULL,
> >>  	},
> >>  	{
> > 
> > Can you please elaborate on this?
> > I think the correct setting depends on the configured
> > "host persona". Currently the expected value would be
> > "Generic / 1". The patch changes it to "Generic-ALUA / 2".
> > Does the above change still work if the "host persona" is
> > not modified and still set to "Generic / 1"?
> > 
> I have never ever _seen_ an 3Par array, so I wasn't aware that you
> could switch host 'persona'. So I have to rely on our partners (ie
> HPE) for correct configuration here.

HPE published at least two guides:

"HPE 3PAR SUSE Linux Enterprise Implementation Guide" [1] pp. 36-38
"HPE 3PAR Red Hat Enterprise Linux and Oracle Linux Implementation Guide" [2]
pp. 104-110

[1] http://h20565.www2.hpe.com/hpsc/doc/public/display?sp4ts.oid=5383451&docId=emr_na-c02663748&docLocale=en_US
[2] http://h20628.www2.hp.com/km-ext/kmcsdirect/emr_na-c04448818-9.pdf

Sebastian
